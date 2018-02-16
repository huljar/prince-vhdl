--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:11:13 03/02/2017
-- Design Name:   
-- Module Name:   /home/julian/Projekt/Xilinx Projects/prince-vhdl/sim/prince_tb.vhd
-- Project Name:  prince-vhdl
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: prince_top
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
 
ENTITY prince_tb IS
END prince_tb;
 
ARCHITECTURE behavior OF prince_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT prince_top
    PORT(
         intext : IN  std_logic_vector(63 downto 0);
         key : IN  std_logic_vector(127 downto 0);
         encdec: IN std_logic;
         outtext : OUT  std_logic_vector(63 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal intext : std_logic_vector(63 downto 0) := (others => '0');
   signal key : std_logic_vector(127 downto 0) := (others => '0');
   signal encdec: std_logic := '0';

 	--Outputs
   signal outtext : std_logic_vector(63 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: prince_top PORT MAP (
      intext => intext,
      key => key,
      encdec => encdec,
      outtext => outtext
    );

   -- Stimulus process
   stim_proc: process
      variable ct: line;
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;

      -- Test vectors from the PRINCE paper
      -- ENCRYPTION
      encdec <= '0';
      -- First test vector
      intext <= x"0000000000000000";
      key <= x"00000000000000000000000000000000";
      wait for 1 ns;
      hwrite(ct, outtext);
      report "Ciphertext is " & ct.all & " (expected value: 818665aa0d02dfda)";
      deallocate(ct);
      
      wait for 10 ns;

      -- Second test vector
      intext <= x"FFFFFFFFFFFFFFFF";
      key <= x"00000000000000000000000000000000";
      wait for 1 ns;
      hwrite(ct, outtext);
      report "Ciphertext is " & ct.all & " (expected value: 604ae6ca03c20ada)";
      deallocate(ct);
      
      wait for 10 ns;

      -- Third test vector
      intext <= x"0000000000000000";
      key <= x"FFFFFFFFFFFFFFFF0000000000000000";
      wait for 1 ns;
      hwrite(ct, outtext);
      report "Ciphertext is " & ct.all & " (expected value: 9fb51935fc3df524)";
      deallocate(ct);
      
      wait for 10 ns;

      -- Fourth test vector
      intext <= x"0000000000000000";
      key <= x"0000000000000000FFFFFFFFFFFFFFFF";
      wait for 1 ns;
      hwrite(ct, outtext);
      report "Ciphertext is " & ct.all & " (expected value: 78a54cbe737bb7ef)";
      deallocate(ct);
      
      wait for 10 ns;

      -- Fifth test vector
      intext <= x"0123456789ABCDEF";
      key <= x"0000000000000000FEDCBA9876543210";
      wait for 1 ns;
      hwrite(ct, outtext);
      report "Ciphertext is " & ct.all & " (expected value: ae25ad3ca8fa9ccf)";
      deallocate(ct);
      
      wait for 55 ns;
      -- DECRYPTION
      encdec <= '1';
      -- First test vector
      intext <= x"818665AA0D02DFDA";
      key <= x"00000000000000000000000000000000";
      wait for 1 ns;
      hwrite(ct, outtext);
      report "Plaintext is " & ct.all & " (expected value: 0000000000000000)";
      deallocate(ct);
      
      wait for 10 ns;
      
      -- Second test vector
      intext <= x"604AE6CA03C20ADA";
      key <= x"00000000000000000000000000000000";
      wait for 1 ns;
      hwrite(ct, outtext);
      report "Plaintext is " & ct.all & " (expected value: FFFFFFFFFFFFFFFF)";
      deallocate(ct);
      
      wait for 10 ns;
      
      -- Third test vector
      intext <= x"9FB51935FC3DF524";
      key <= x"FFFFFFFFFFFFFFFF0000000000000000";
      wait for 1 ns;
      hwrite(ct, outtext);
      report "Plaintext is " & ct.all & " (expected value: 0000000000000000)";
      deallocate(ct);
      
      wait for 10 ns;
      
      -- Fourth test vector
      intext <= x"78A54CBE737BB7EF";
      key <= x"0000000000000000FFFFFFFFFFFFFFFF";
      wait for 1 ns;
      hwrite(ct, outtext);
      report "Plaintext is " & ct.all & " (expected value: 0000000000000000)";
      deallocate(ct);
      
      wait for 10 ns;
      
      -- Fifth test vector
      intext <= x"AE25AD3CA8FA9CCF";
      key <= x"0000000000000000FEDCBA9876543210";
      wait for 1 ns;
      hwrite(ct, outtext);
      report "Plaintext is " & ct.all & " (expected value: 0123456789ABCDEF)";
      deallocate(ct);
      
      wait;
   end process;

END;
