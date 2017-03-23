library ieee;
use ieee.std_logic_1164.all;

-- Substitution box of PRINCE
entity sbox is
    port(data_in:  in std_logic_vector(3 downto 0);
         data_out: out std_logic_vector(3 downto 0)
    );
end sbox;

architecture behavioral of sbox is
    begin
        process(data_in)
        begin
            case data_in is
                when x"0" => data_out <= x"B";
                when x"1" => data_out <= x"F";
                when x"2" => data_out <= x"3";
                when x"3" => data_out <= x"2";
                when x"4" => data_out <= x"A";
                when x"5" => data_out <= x"C";
                when x"6" => data_out <= x"9";
                when x"7" => data_out <= x"1";
                when x"8" => data_out <= x"6";
                when x"9" => data_out <= x"7";
                when x"A" => data_out <= x"8";
                when x"B" => data_out <= x"0";
                when x"C" => data_out <= x"E";
                when x"D" => data_out <= x"5";
                when x"E" => data_out <= x"D";
                when x"F" => data_out <= x"4";
                when others => null; -- GHDL complains without this statement
            end case;
        end process;
    end behavioral;
