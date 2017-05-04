library ieee;
use ieee.std_logic_1164.all;

entity axi_stream_wrapper is
    port(ACLK: in std_logic; -- positive edge clock
         ARESETN: in std_logic; -- active-low synchronous reset
         S_AXIS_TREADY: out std_logic;
         S_AXIS_TDATA: in std_logic_vector(31 downto 0);
         S_AXIS_TLAST: in std_logic;
         S_AXIS_TVALID: in std_logic;
         M_AXIS_TVALID: out std_logic;
         M_AXIS_TDATA: out std_logic_vector(31 downto 0);
         M_AXIS_TLAST: out std_logic;
         M_AXIS_TREADY: in std_logic
    );
end axi_stream_wrapper;

architecture behavioral of axi_stream_wrapper is
    type state_type is (idle, read_plaintext, read_key, write_ciphertext);
    type axis_buffer is array(integer range <>) of std_logic_vector(31 downto 0);

    constant plaintext_reads: natural := 2;
    constant key_reads: natural := 4;
    constant ciphertext_writes: natural := 2;

    signal state: state_type;
    signal counter: natural range 0 to 3;
    
    signal ip_plaintext: std_logic_vector(63 downto 0);
    signal ip_key: std_logic_vector(127 downto 0);
    signal ip_ciphertext: std_logic_vector(63 downto 0);

    signal ip_plaintext_buf: axis_buffer(0 to 1);
    signal ip_key_buf: axis_buffer(0 to 3);
    signal ip_ciphertext_buf: axis_buffer(0 to 1);

    component prince_top
        port(plaintext:  in std_logic_vector(63 downto 0);
             key:        in std_logic_vector(127 downto 0);
             ciphertext: out std_logic_vector(63 downto 0)
        );
    end component;
begin
    IP: prince_top port map(
        plaintext => ip_plaintext,
        key => ip_key,
        ciphertext => ip_ciphertext
    );
    
    ip_plaintext <= ip_plaintext_buf(0) & ip_plaintext_buf(1);
    ip_key <= ip_key_buf(0) & ip_key_buf(1) & ip_key_buf(2) & ip_key_buf(3);
    ip_ciphertext_buf(0) <= ip_ciphertext(63 downto 32);
    ip_ciphertext_buf(1) <= ip_ciphertext(31 downto 0);
    
    S_AXIS_TREADY <= '1' when (state = read_plaintext or state = read_key) else '0';
    M_AXIS_TVALID <= '1' when state = write_ciphertext else '0';
    M_AXIS_TLAST  <= '1' when (state = write_ciphertext and counter = ciphertext_writes-1) else '0';

    state_machine: process(ACLK)
    begin
        if rising_edge(ACLK) then
            if ARESETN = '0' then
                state <= idle;
                counter <= 0;
            else
                case state is
                when idle =>
                    M_AXIS_TDATA <= (others => '0');
                    
                    if S_AXIS_TVALID = '1' then
                        state <= read_plaintext;
                        counter <= 0;
                    end if;

                when read_plaintext =>
                    if S_AXIS_TVALID = '1' then
                        ip_plaintext_buf(counter) <= S_AXIS_TDATA;
                        
                        if counter = plaintext_reads-1 then
                            state <= read_key;
                            counter <= 0;
                        else
                            counter <= counter+1;
                        end if;
                    end if;

                when read_key =>
                    if S_AXIS_TVALID = '1' then
                        ip_key_buf(counter) <= S_AXIS_TDATA;
                        
                        if counter = key_reads-1 then
                            state <= write_ciphertext;
                            counter <= 0;
                        else
                            counter <= counter+1;
                        end if;
                    end if;

                when write_ciphertext =>
                    M_AXIS_TDATA <= ip_ciphertext_buf(counter);
                    
                    if M_AXIS_TREADY = '1' then
                        if counter = ciphertext_writes-1 then
                            state <= idle;
                            counter <= 0;
                        else
                            counter <= counter+1;
                        end if;
                    end if;
                end case;
            end if;
        end if;
    end process;
end architecture;
