library ieee;
use ieee.std_logic_1164.all;

-- This entity applies the inverse transformation of linear_m. The transposition
-- is done before multiplying the state with the matrix. The matrix itself
-- (linear_mprime) stays the same because it is an involution.
entity linear_m_inv is
    port(data_in:  in std_logic_vector(63 downto 0);
         data_out: out std_logic_vector(63 downto 0)
    );
end linear_m_inv;

architecture structural of linear_m_inv is
    signal mprime_in: std_logic_vector(63 downto 0);

    component linear_mprime
        port(data_in:  in std_logic_vector(63 downto 0);
             data_out: out std_logic_vector(63 downto 0)
        );
    end component;

    begin
        mprime_in(63 downto 60) <= data_in(63 downto 60);
        mprime_in(59 downto 56) <= data_in(11 downto 8);
        mprime_in(55 downto 52) <= data_in(23 downto 20);
        mprime_in(51 downto 48) <= data_in(35 downto 32);
        mprime_in(47 downto 44) <= data_in(47 downto 44);
        mprime_in(43 downto 40) <= data_in(59 downto 56);
        mprime_in(39 downto 36) <= data_in(7 downto 4);
        mprime_in(35 downto 32) <= data_in(19 downto 16);
        mprime_in(31 downto 28) <= data_in(31 downto 28);
        mprime_in(27 downto 24) <= data_in(43 downto 40);
        mprime_in(23 downto 20) <= data_in(55 downto 52);
        mprime_in(19 downto 16) <= data_in(3 downto 0);
        mprime_in(15 downto 12) <= data_in(15 downto 12);
        mprime_in(11 downto 8)  <= data_in(27 downto 24);
        mprime_in(7 downto 4)   <= data_in(39 downto 36);
        mprime_in(3 downto 0)   <= data_in(51 downto 48);

        MP: linear_mprime port map(
            data_in => mprime_in,
            data_out => data_out
        );
    end architecture;
