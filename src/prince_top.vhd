library ieee;
use ieee.std_logic_1164.all;

entity prince_top is
    port(plaintext:  in std_logic_vector(63 downto 0);
         key:        in std_logic_vector(127 downto 0);
         ciphertext: out std_logic_vector(63 downto 0)
    );
end prince_top;

architecture behavioral of prince_top is
    signal k0_start,
           k0_end,
           k1: std_logic_vector(63 downto 0);
    signal core_in,
           core_out: std_logic_vector(63 downto 0);

    begin
        -- Key extension/whitening keys
        -- TODO: check if k0_end computation is correct
        k0_start <= key(127 downto 64);
        k0_end <= ("0" & key(127 downto 65)) xor
                  (key(126 downto 64) & key(127));
        k1 <= key(63 downto 0);

        -- PRINCE_core input/output
        core_in <= plaintext xor k0_start;
        ciphertext <= core_out xor k0_end;
    end architecture;
