library ieee;
use ieee.std_logic_1164.all;

-- This entity applies the matrix from linear_mprime. In addition, a nibble-wise
-- transposition is performed in the end.
entity linear_m is
    port(data_in:  in std_logic_vector(63 downto 0);
         data_out: out std_logic_vector(63 downto 0)
    );
end linear_m;

architecture structural of linear_m is
    signal mprime_out: std_logic_vector(63 downto 0);

    component linear_mprime
        port(data_in:  in std_logic_vector(63 downto 0);
             data_out: out std_logic_vector(63 downto 0)
        );
    end component;

    begin
        MP: linear_mprime port map(
            data_in => data_in,
            data_out => mprime_out
        );

        data_out(63 downto 60) <= mprime_out(63 downto 60);
        data_out(59 downto 56) <= mprime_out(43 downto 40);
        data_out(55 downto 52) <= mprime_out(23 downto 20);
        data_out(51 downto 48) <= mprime_out(3 downto 0);
        data_out(47 downto 44) <= mprime_out(47 downto 44);
        data_out(43 downto 40) <= mprime_out(27 downto 24);
        data_out(39 downto 36) <= mprime_out(7 downto 4);
        data_out(35 downto 32) <= mprime_out(51 downto 48);
        data_out(31 downto 28) <= mprime_out(31 downto 28);
        data_out(27 downto 24) <= mprime_out(11 downto 8);
        data_out(23 downto 20) <= mprime_out(55 downto 52);
        data_out(19 downto 16) <= mprime_out(35 downto 32);
        data_out(15 downto 12) <= mprime_out(15 downto 12);
        data_out(11 downto 8)  <= mprime_out(59 downto 56);
        data_out(7 downto 4)   <= mprime_out(39 downto 36);
        data_out(3 downto 0)   <= mprime_out(19 downto 16);
    end architecture;
