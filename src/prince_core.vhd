library ieee;
use ieee.std_logic_1164.all;

entity prince_core is
    port(data_in:  in std_logic_vector(63 downto 0);
         key:      in std_logic_vector(63 downto 0);
         data_out: out std_logic_vector(63 downto 0)
    );
end prince_core;

architecture structural of prince_core is
    type round_constants is array(0 to 11) of std_logic_vector(63 downto 0);
    type intermediate_signals is array(0 to 11) of std_logic_vector(63 downto 0);

    constant rcs: round_constants := (x"0000000000000000",
                                      x"13198A2E03707344",
                                      x"A4093822299F31D0",
                                      x"082EFA98EC4E6C89",
                                      x"452821E638D01377",
                                      x"BE5466CF34E90C6C",
                                      x"7EF84F78FD955CB1",
                                      x"85840851F1AC43AA",
                                      x"C882D32F25323C54",
                                      x"64A51195E0E3610D",
                                      x"D3B5A399CA0C2399",
                                      x"C0AC29B7C97C50DD");

    signal ims: intermediate_signals;
    signal middle1, middle2: std_logic_vector(63 downto 0);

    component sbox
        port(data_in:  in std_logic_vector(3 downto 0);
             data_out: out std_logic_vector(3 downto 0)
        );
    end component;

    component sbox_inv
        port(data_in:  in std_logic_vector(3 downto 0);
             data_out: out std_logic_vector(3 downto 0)
        );
    end component;

    component linear_m
        port(data_in:  in std_logic_vector(63 downto 0);
             data_out: out std_logic_vector(63 downto 0)
        );
    end component;

    component linear_m_inv
        port(data_in:  in std_logic_vector(63 downto 0);
             data_out: out std_logic_vector(63 downto 0)
        );
    end component;

    component linear_mprime
        port(data_in:  in std_logic_vector(63 downto 0);
             data_out:  out std_logic_vector(63 downto 0)
        );
    end component;

    begin
        -- Round 0
        ims(0) <= data_in xor key xor rcs(0);

        -- Round 1 to 5
        FIRST_HALF: for i in 1 to 5 generate
            signal sb_out, m_out: std_logic_vector(63 downto 0);
        
        begin
            SB_FH: for j in 0 to 15 generate
                SX_FH: sbox port map(
                    data_in => ims(i - 1)(63 - 4*j downto 63 - 4*j - 3),
                    data_out => sb_out(63 - 4*j downto 63 - 4*j - 3)
                );
            end generate;

            LIN_M: linear_m port map(
                data_in => sb_out,
                data_out => m_out
            );

            ims(i) <= m_out xor rcs(i) xor key;
        end generate;

        -- Middle layer
        SB_MID: for i in 0 to 15 generate
            SX_M1: sbox port map(
                data_in => ims(5)(63 - 4*i downto 63 - 4*i - 3),
                data_out => middle1(63 - 4*i downto 63 - 4*i - 3)
            );
        end generate;

        MP_MID: linear_mprime port map(
            data_in => middle1,
            data_out => middle2
        );

        SB_MID_INV: for i in 0 to 15 generate
            SX_M2: sbox_inv port map(
                data_in => middle2(63 - 4*i downto 63 - 4*i - 3),
                data_out => ims(6)(63 - 4*i downto 63 - 4*i - 3)
            );
        end generate;

        -- Round 6 to 10
        SECOND_HALF: for i in 6 to 10 generate
            signal m_in, sb_in: std_logic_vector(63 downto 0);

        begin
            m_in <= ims(i) xor key xor rcs(i);

            LIN_M_INV: linear_m_inv port map(
                data_in => m_in,
                data_out => sb_in
            );

            SB_SH: for j in 0 to 15 generate
                SX_SH: sbox_inv port map(
                    data_in => sb_in(63 - 4*j downto 63 - 4*j - 3),
                    data_out => ims(i + 1)(63 - 4*j downto 63 - 4*j - 3)
                );
            end generate;
        end generate;

        -- Round 11
        data_out <= ims(11) xor rcs(11) xor key;
    end architecture;
