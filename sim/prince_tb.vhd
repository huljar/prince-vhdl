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
         plaintext : IN  std_logic_vector(63 downto 0);
         key : IN  std_logic_vector(127 downto 0);
         ciphertext : OUT  std_logic_vector(63 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal plaintext : std_logic_vector(63 downto 0) := (others => '0');
   signal key : std_logic_vector(127 downto 0) := (others => '0');

 	--Outputs
   signal ciphertext : std_logic_vector(63 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: prince_top PORT MAP (
      plaintext => plaintext,
      key => key,
      ciphertext => ciphertext
    );

   -- Stimulus process
   stim_proc: process
      variable ct: line;
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;

      -- Test vectors from the PRINCE paper
      -- First test vector
      plaintext <= x"0000000000000000";
      key <= x"00000000000000000000000000000000";
      wait for 1 ns;
      hwrite(ct, ciphertext);
      report "Ciphertext is " & ct.all & " (expected value: 818665aa0d02dfda)";
      deallocate(ct);
      
      wait for 10 ns;

      -- Second test vector
      plaintext <= x"FFFFFFFFFFFFFFFF";
      key <= x"00000000000000000000000000000000";
      wait for 1 ns;
      hwrite(ct, ciphertext);
      report "Ciphertext is " & ct.all & " (expected value: 604ae6ca03c20ada)";
      deallocate(ct);
      
      wait for 10 ns;

      -- Third test vector
      plaintext <= x"0000000000000000";
      key <= x"FFFFFFFFFFFFFFFF0000000000000000";
      wait for 1 ns;
      hwrite(ct, ciphertext);
      report "Ciphertext is " & ct.all & " (expected value: 9fb51935fc3df524)";
      deallocate(ct);
      
      wait for 10 ns;

      -- Fourth test vector
      plaintext <= x"0000000000000000";
      key <= x"0000000000000000FFFFFFFFFFFFFFFF";
      wait for 1 ns;
      hwrite(ct, ciphertext);
      report "Ciphertext is " & ct.all & " (expected value: 78a54cbe737bb7ef)";
      deallocate(ct);
      
      wait for 10 ns;

      -- Fifth test vector
      plaintext <= x"0123456789ABCDEF";
      key <= x"0000000000000000FEDCBA9876543210";
      wait for 1 ns;
      hwrite(ct, ciphertext);
      report "Ciphertext is " & ct.all & " (expected value: ae25ad3ca8fa9ccf)";
      deallocate(ct);
      
      wait;
   end process;

END;
