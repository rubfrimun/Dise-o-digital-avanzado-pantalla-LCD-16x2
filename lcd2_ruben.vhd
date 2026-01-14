----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:10:17 04/11/2025 
-- Design Name: 
-- Module Name:    lcd2_ruben - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lcd2_ruben is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        m1 : in STD_LOGIC;
        m2 : in STD_LOGIC;
        cl : in STD_LOGIC;
        e : out STD_LOGIC;
        rs : out STD_LOGIC;
        rw : out STD_LOGIC;
        db : out STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
end lcd2_ruben;

architecture Behavioral of lcd2_ruben is
    type est is (Inicio, Inh, FunctionSet, DisplayOn, ClearDisplay, 
                 SetLine2, EscribirMsg, EsperarPulsacion);
    signal estado, proximo_estado : est;
    signal cuenta : integer range 0 to 20000 := 0;
    signal fin_cuenta : boolean := false;
    signal i : integer range 0 to 31 := 0;
    signal mensaje_sel : integer := 0; -- 0: nombre, 1: mensaje libre
    signal escribir : boolean := false;
    signal thresh : std_logic := '0';
    signal contador_thresh : integer range 0 to 99 := 0;

    constant wait_20ms : integer := 19999;
    constant wait_152us : integer := 1520;
    constant wait_39us : integer := 39;
    constant wait_43us : integer := 43;

    type rom_array is array(0 to 31) of std_logic_vector(7 downto 0);
    constant mensaje1 : rom_array := (
    x"49", x"6E", x"67", x"65", x"6E", x"69", x"65", x"72", 
    x"69", x"61", x"20", x"20", x"20", x"20", x"20", x"20", -- "Ingenieria"
    x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20",
    x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20");
   
constant mensaje2 : rom_array := (
    x"45", x"6C", x"65", x"63", x"74", x"72", x"6F", x"6E",
    x"69", x"63", x"61", x"20", x"20", x"20", x"20", x"20", -- "Electronica Industrial"
    x"49", x"6E", x"64", x"75", x"73", x"74", x"72", x"69",
    x"61", x"6C", x"20", x"20", x"20", x"20", x"20", x"20");


begin

    process (clk, reset)
    begin
        if reset = '1' then
            contador_thresh <= 0;
            thresh <= '0';
        elsif rising_edge(clk) then
            if contador_thresh = 99 then
                thresh <= '1';
                contador_thresh <= 0;
            else
                thresh <= '0';
                contador_thresh <= contador_thresh + 1;
            end if;
        end if;
    end process;

    process (clk, reset)
    begin
        if reset = '1' then
            estado <= Inicio;
            cuenta <= 0;
            i <= 0;
            escribir <= false;
            mensaje_sel <= 0;
        elsif rising_edge(clk) then
            if thresh = '1' then
                if cuenta > 0 then
                    cuenta <= cuenta - 1;
                    fin_cuenta <= false;
                else
                    fin_cuenta <= true;
                    estado <= proximo_estado;
                end if;

                case estado is

                    when Inicio =>
                        rs <= '0';
                        rw <= '0';
                        e <= '0';
                        db <= (others => '0');
                        if m1 = '1' then
                            mensaje_sel <= 0;
                            escribir <= true;
                            proximo_estado <= FunctionSet;
                            cuenta <= wait_20ms;
                        elsif m2 = '1' then
                            mensaje_sel <= 1;
                            escribir <= true;
                            proximo_estado <= FunctionSet;
                            cuenta <= wait_20ms;
                        elsif cl = '1' then
                            escribir <= false;
                            proximo_estado <= FunctionSet;
                            cuenta <= wait_20ms;
                        else
                            proximo_estado <= Inicio;
                        end if;

                    when FunctionSet =>
                        rs <= '0';
                        rw <= '0';
                        e <= '1';
                        db <= "00111000"; -- 8 bits, 2 líneas, 5x8
                        if fin_cuenta then
                            e <= '0';
                            cuenta <= wait_39us;
                            proximo_estado <= DisplayOn;
                        end if;

                    when DisplayOn =>
                        rs <= '0';
                        rw <= '0';
                        e <= '1';
                        db <= "00001100"; -- Display ON, Cursor OFF
                        if fin_cuenta then
                            e <= '0';
                            cuenta <= wait_39us;
                            proximo_estado <= ClearDisplay;
                        end if;

                    when ClearDisplay =>
                        rs <= '0';
                        rw <= '0';
                        e <= '1';
                        db <= "00000001";
                        i <= 0;
                        if fin_cuenta then
                            e <= '0';
                            cuenta <= wait_152us;
                            if escribir = true then
                                proximo_estado <= EscribirMsg;
                            else
                                proximo_estado <= EsperarPulsacion;
                            end if;
                        end if;

                    when EscribirMsg =>
                        if i = 16 then
                            rs <= '0';
                            rw <= '0';
                            e <= '1';
                            db <= "11000000"; -- Set DDRAM addr segunda línea
                            if fin_cuenta then
                                e <= '0';
                                cuenta <= wait_39us;
                                i <= 16;
                            end if;
                        elsif i < 32 then
                            rs <= '1';
                            rw <= '0';
                            e <= '1';
                            if mensaje_sel = 0 then
                                db <= mensaje1(i);
                            else
                                db <= mensaje2(i);
                            end if;
                            if fin_cuenta then
                                e <= '0';
                                cuenta <= wait_43us;
                                i <= i + 1;
                            end if;
                        else
                            proximo_estado <= EsperarPulsacion;
                        end if;

                    when EsperarPulsacion =>
                        if m1 = '1' then
                            mensaje_sel <= 0;
                            escribir <= true;
                            proximo_estado <= ClearDisplay;
                            cuenta <= wait_152us;
                            i <= 0;
                        elsif m2 = '1' then
                            mensaje_sel <= 1;
                            escribir <= true;
                            proximo_estado <= ClearDisplay;
                            cuenta <= wait_152us;
                            i <= 0;
                        elsif cl = '1' then
                            escribir <= false;
                            proximo_estado <= ClearDisplay;
                            cuenta <= wait_152us;
                            i <= 0;
                        end if;

                    when others =>
                        estado <= Inicio;

                end case;
            end if;
        end if;
    end process;

end Behavioral;
