library ieee;
use ieee.std_logic_1164.all;

-- The top level module of PRINCE
entity prince_top is
    port(intext:  in  std_logic_vector(63  downto 0); -- 64 bit plaintext block
         key:     in  std_logic_vector(127 downto 0); -- 128 bit key
         encdec:  in  std_logic;                      -- switch enc/dec
         
         outtext: out std_logic_vector(63  downto 0)  -- 64 bit encrypted block
    );
end prince_top;

architecture structural of prince_top is
    -- Intermediate signals for splitting the key into the whitening keys k0
    -- and k0_end, and the key k1 which is used in prince_core
    signal k0_start,
           k0_end,
           k1: std_logic_vector(63 downto 0);
    -- Data I/O for prince_core
    signal core_in,
           core_out: std_logic_vector(63 downto 0);

    component prince_core
        port(data_in:  in std_logic_vector(63 downto 0);
             key:      in std_logic_vector(63 downto 0);
             data_out: out std_logic_vector(63 downto 0)
        );
    end component;

    begin
        -- Key extension/whitening keys
        PK: process (encdec, key) is
        begin 
            if encdec = '0' then  -- encryption
                k0_start <= key(127 downto 64);
                k0_end <= key(64) & key(127 downto 66) & (key(65) xor key(127));
                k1 <= key(63 downto 0);
            else                  -- decryption
                k0_end <= key(127 downto 64);
                k0_start <= key(64) & key(127 downto 66) & (key(65) xor key(127));
                k1 <= key(63 downto 0) xor x"C0AC29B7C97C50DD";
            end if;
        end process PK;

        

        -- PRINCE_core
        core_in <= intext xor k0_start;
        outtext <= core_out xor k0_end;

        PC: prince_core port map(
            data_in => core_in,
            key => k1,
            data_out => core_out
        );
    end architecture;
