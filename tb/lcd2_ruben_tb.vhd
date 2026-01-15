--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:14:45 04/11/2025
-- Design Name:   
-- Module Name:   C:/Users/ATC/Desktop/TrabajoV2/lcd_V3/lcd2_ruben_tb.vhd
-- Project Name:  lcd_V3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: lcd2_ruben
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lcd2_ruben_tb is
end lcd2_ruben_tb;

architecture Behavioral of lcd2_ruben_tb is

    signal clk     : std_logic := '0';
    signal reset   : std_logic := '1';
    signal m1      : std_logic := '0';
    signal m2      : std_logic := '0';
    signal cl      : std_logic := '0';
    signal e       : std_logic;
    signal rs      : std_logic;
    signal rw      : std_logic;
    signal db      : std_logic_vector(7 downto 0);

    -- Simula un periodo de reloj de 10 ns (100 MHz)
    constant clk_period : time := 10 ns;

begin

    -- Instancia del DUT (Device Under Test)
    uut: entity work.lcd2_ruben
        port map (
            clk => clk,
            reset => reset,
            m1 => m1,
            m2 => m2,
            cl => cl,
            e => e,
            rs => rs,
            rw => rw,
            db => db
        );

    -- Generador de reloj
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Estímulos
    stim_proc: process
    begin
        -- Reset activo
        wait for 50 ns;
        reset <= '0';
        wait for 100 ns;

        -- Pulso m1 (mensaje nombre/apellidos)
        m1 <= '1';
        wait for 50 ns;
        m1 <= '0';

        wait for 2 ms; -- espera mientras escribe

        -- Pulso cl (clear)
        cl <= '1';
        wait for 50 ns;
        cl <= '0';

        wait for 1 ms;

        -- Pulso m2 (mensaje libre)
        m2 <= '1';
        wait for 50 ns;
        m2 <= '0';

        wait for 2 ms;

        -- Fin de simulación
        wait;
    end process;

end Behavioral;
