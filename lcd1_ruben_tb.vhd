--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:17:21 04/03/2025
-- Design Name:   
-- Module Name:   C:/Users/ATC/Desktop/Trabajo/lcd_rubenfriasmunoz/lcd1_ruben_tb.vhd
-- Project Name:  lcd_rubenfriasmunoz
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: lcd1_ruben
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY lcd1_ruben_tb IS
END lcd1_ruben_tb;
 

ARCHITECTURE behavior OF lcd1_ruben_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT lcd1_ruben
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         ini : IN  std_logic;
         e : OUT  std_logic;
         rs : OUT  std_logic;
         rw : OUT  std_logic;
         db : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '1';
   signal ini : std_logic := '0';

 	--Outputs
   signal e : std_logic;
   signal rs : std_logic;
   signal rw : std_logic;
   signal db : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: lcd1_ruben PORT MAP (
          clk => clk,
          reset => reset,
          ini => ini,
          e => e,
          rs => rs,
          rw => rw,
          db => db
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for 1000 ns;
        ini <= '1';
        wait for 50 ns;
        ini <= '0';
        wait;
   end process;

END;

