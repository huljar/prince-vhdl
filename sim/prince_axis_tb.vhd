--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:   14:37:59 02/28/2017
-- Design Name:
-- Module Name:   /home/julian/Projekt/Xilinx Projects/present-vhdl/src/present_tb.vhd
-- Project Name:  present-vhdl
-- Target Device:
-- Tool versions:
-- Description:
--
-- VHDL Test Bench Created by ISE for module: present_top
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes:
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE std.textio.ALL;
USE ieee.std_logic_textio.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY prince_axis_tb IS
END prince_axis_tb;

ARCHITECTURE behavior OF prince_axis_tb IS

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT axi_stream_wrapper
    PORT(
         ACLK : IN std_logic;
         ARESETN : IN std_logic;
         S_AXIS_TREADY : OUT std_logic;
         S_AXIS_TDATA : IN std_logic_vector(31 downto 0);
         S_AXIS_TLAST : IN std_logic;
         S_AXIS_TVALID : IN std_logic;
         M_AXIS_TVALID : OUT std_logic;
         M_AXIS_TDATA : OUT std_logic_vector(31 downto 0);
         M_AXIS_TLAST : OUT std_logic;
         M_AXIS_TREADY : IN std_logic
        );
    END COMPONENT;


   --Inputs
   signal ACLK : std_logic := '0';
   signal ARESETN : std_logic := '0';
   signal S_AXIS_TDATA : std_logic_vector(31 downto 0) := (others => '0');
   signal S_AXIS_TLAST : std_logic := '0';
   signal S_AXIS_TVALID : std_logic := '0';
   signal M_AXIS_TREADY : std_logic := '0';

 	--Outputs
   signal S_AXIS_TREADY : std_logic;
   signal M_AXIS_TVALID : std_logic;
   signal M_AXIS_TDATA : std_logic_vector(31 downto 0);
   signal M_AXIS_TLAST : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   
   -- Other signals
   signal ciphertext : std_logic_vector(63 downto 0);

BEGIN

	-- Instantiate the Unit Under Test (UUT)
   uut: axi_stream_wrapper PORT MAP (
          ACLK => ACLK,
          ARESETN => ARESETN,
          S_AXIS_TREADY => S_AXIS_TREADY,
          S_AXIS_TDATA => S_AXIS_TDATA,
          S_AXIS_TLAST => S_AXIS_TLAST,
          S_AXIS_TVALID => S_AXIS_TVALID,
          M_AXIS_TVALID => M_AXIS_TVALID,
          M_AXIS_TDATA => M_AXIS_TDATA,
          M_AXIS_TLAST => M_AXIS_TLAST,
          M_AXIS_TREADY => M_AXIS_TREADY
        );

   -- Clock process definitions
   clk_process: process
   begin
		ACLK <= '0';
		wait for clk_period/2;
		ACLK <= '1';
		wait for clk_period/2;
   end process;


   -- Stimulus process
   stim_proc: process
      variable ct: line;
   begin
      -- hold reset state for 100 ns.
      wait for 100 ns;

      -- write plaintext
      ARESETN <= '1';
      S_AXIS_TVALID <= '1';
      S_AXIS_TDATA <= x"01234567";
      wait for clk_period;
      assert (S_AXIS_TREADY = '1') report "ERROR: axi slave is not ready!" severity error;
      wait for clk_period;
      S_AXIS_TDATA <= x"89ABCDEF";
      wait for clk_period;
      
      -- write key
      S_AXIS_TDATA <= (others => '0');
      wait for clk_period*2;
      S_AXIS_TDATA <= x"FEDCBA98";
      wait for clk_period;
      S_AXIS_TDATA <= x"76543210";
      wait for clk_period;
      S_AXIS_TDATA <= (others => '0');
      S_AXIS_TVALID <= '0';
      wait for clk_period;
      assert (S_AXIS_TREADY = '0') report "ERROR: axi slave is still ready after reading data!" severity error;
      
      -- read ciphertext
      assert (M_AXIS_TVALID = '1') report "ERROR: axi master is not ready in time!" severity error;
      M_AXIS_TREADY <= '1';
      wait for clk_period;
      ciphertext(63 downto 32) <= M_AXIS_TDATA;
      wait for clk_period;
      ciphertext(31 downto 0) <= M_AXIS_TDATA;
      wait for clk_period;
      assert (M_AXIS_TVALID = '0') report "ERROR: axi master is still valid after writing all output!" severity error;
      M_AXIS_TREADY <= '0';
      
      -- print ciphertext
      hwrite(ct, ciphertext);
      report "Ciphertext is " & ct.all & " (expected value: ae25ad3ca8fa9ccf)";
      deallocate(ct);

      wait;
   end process;

END;
