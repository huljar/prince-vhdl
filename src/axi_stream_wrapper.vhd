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
    type state_type is (idle, read_parameter, read_intext, read_key, write_outtext);
    type axis_buffer is array(integer range <>) of std_logic_vector(31 downto 0);

    constant intext_reads: natural := 2;
    constant key_reads: natural := 4;
    constant outtext_writes: natural := 2;

    signal state: state_type;
    signal counter: natural range 0 to 3;
    
    signal ip_intext: std_logic_vector(63 downto 0);
    signal ip_key: std_logic_vector(127 downto 0);
    signal ip_outtext: std_logic_vector(63 downto 0);
    signal ip_parameter: std_logic_vector(31 downto 0);
    signal ip_encdec: std_logic;

    signal ip_parameter_buf: axis_buffer(0 to 0);
    signal ip_intext_buf: axis_buffer(0 to 1);
    signal ip_key_buf: axis_buffer(0 to 3);
    signal ip_outtext_buf: axis_buffer(0 to 1);

    component prince_top
        port(intext:  in std_logic_vector(63 downto 0);
             key:     in std_logic_vector(127 downto 0);
             encdec:  in std_logic;
             outtext: out std_logic_vector(63 downto 0)
        );
    end component;
begin
    IP: prince_top port map(
        intext => ip_intext,
        key => ip_key,
        encdec => ip_encdec,
        outtext => ip_outtext
    );
    
    ip_intext <= ip_intext_buf(0) & ip_intext_buf(1);
    ip_key <= ip_key_buf(0) & ip_key_buf(1) & ip_key_buf(2) & ip_key_buf(3);
    ip_outtext_buf(0) <= ip_outtext(63 downto 32);
    ip_outtext_buf(1) <= ip_outtext(31 downto 0);
    ip_parameter <= ip_parameter_buf(0);
    ip_encdec <= ip_parameter(0);
    
    S_AXIS_TREADY <= '1' when (state = read_intext or state = read_key or state = read_parameter) else '0';
    M_AXIS_TVALID <= '1' when state = write_outtext else '0';
    M_AXIS_TLAST  <= '1' when (state = write_outtext and counter = outtext_writes-1) else '0';

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
                        state <= read_parameter;

                    end if;
                when read_parameter =>
                    if S_AXIS_TVALID = '1' then
                        ip_parameter_buf(0) <= S_AXIS_TDATA;
                        state <= read_intext;
                        counter <= 0;
                    end if;
                when read_intext =>
                    if S_AXIS_TVALID = '1' then
                        ip_intext_buf(counter) <= S_AXIS_TDATA;
                        
                        if counter = intext_reads-1 then
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
                            state <= write_outtext;
                            counter <= 0;
                        else
                            counter <= counter+1;
                        end if;
                    end if;

                when write_outtext =>
                    M_AXIS_TDATA <= ip_outtext_buf(counter);
                    
                    if M_AXIS_TREADY = '1' then
                        if counter = outtext_writes-1 then
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
