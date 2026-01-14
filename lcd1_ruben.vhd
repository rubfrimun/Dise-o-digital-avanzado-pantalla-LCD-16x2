----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:22:10 03/25/2025 
-- Design Name: 
-- Module Name:    lcd1_ruben - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;y

entity lcd1_ruben is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           ini : in  STD_LOGIC;
           e : out  STD_LOGIC;
           rs : out  STD_LOGIC;
           rw : out  STD_LOGIC;
           db : out  STD_LOGIC_VECTOR(7 DOWNTO 0));
end lcd1_ruben;

architecture Behavioral of lcd1_ruben is
   type est is(Inh,FunctionSet,DisplayOn,ClearDisplay,
               WriteToRam,WaitSetDDRAMAdress,WriteToRamApellido); -- quito los wait, se hacen de forma interna
   signal estado, proximo_estado, estado_anterior: est;
   signal cuenta : integer range 0 to 19999 := 0; -- la mayor cuenta es de 0 a 20ms
   signal fin_cuenta : boolean := false; --para saber qeu la cuenta ha terminado
   signal i : integer := 0;
   signal fin_proceso : boolean := false;
   signal thresh : std_logic := '0';
   signal contador_thresh : integer range 0 to 99 :=0; 
   
   constant wait_20ms : integer:= 19999;  
   constant wait_152us : integer := 1520; 
   constant wait_39us : integer := 39;
   constant wait_43us : integer := 43;
   
   type matriz is array (0 to 15) of std_logic_vector(7 downto 0);
   constant nombre : matriz := (x"52", x"75", x"62", x"65", x"6E",
            x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20");
   constant apellido : matriz := (x"46", x"72", x"69", x"61", x"73",
            x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20", x"20");
   
begin
   process (clk,reset,estado,ini)
   begin
      if reset = '1' then
         e <= '0';
         rs<= '0';
         rw<= '0';
         db<= (others => '0');
         cuenta <= 0;
         estado <= Inh;
         proximo_estado <= Inh;
         i <= 0;
      elsif rising_edge(clk) then        
        if thresh = '1' then
            --e <= '0';
            if cuenta = 0 then
               fin_cuenta <= true;
               estado <= proximo_estado;
            else
               fin_cuenta <= false;
               cuenta <= cuenta - 1;
            end if;
            
      case estado is 
         when Inh =>
            rs<= '0';
            rw<= '0';
            db<= (others => '0');
            
            if ini = '1' then
               cuenta <= wait_20ms;
               proximo_estado <= FunctionSet;
            end if;
            
         when FunctionSet =>
            e <= '0';
            rs <= '0';
            rw <= '0';
            db <= "00111000";
            if fin_cuenta then
            cuenta <= wait_39us;               
            proximo_estado <= DisplayOn;
            end if; 
            
         when DisplayOn =>
            e <= '0';
            rs <= '0';
            rw <= '0';
            db <= "00001100";
            if fin_cuenta then 
            cuenta <= wait_39us;
            proximo_estado <= ClearDisplay;
            end if;
           
         when ClearDisplay => 
            e <= '0';
            rs <= '0';
            rw <= '0';
            db <= "00000001";
            i <= 0;
            if fin_cuenta then
            estado_anterior <= ClearDisplay;
            proximo_estado <= WriteToRam;
            end if;
            
         when WriteToRam =>
            rs <= '1';
            rw <= '0';
            e <= '0';
               if fin_cuenta then
               e <= '1';
               db <= nombre(i);
               cuenta <= wait_43us;
               fin_cuenta <= false;
                  if nombre(i) = x"20" then
                     if estado_anterior = ClearDisplay then --cambio waitcleardisplay por cleardisplay
                        proximo_estado <= WaitSetDDRAMAdress;
                     elsif estado_anterior = WaitSetDDRAMAdress then
                        fin_proceso <= true;
                     end if;
                  else
                  i <= i + 1;
                  cuenta <= wait_43us;
                  end if;
               cuenta <= wait_43us;
               else 
               cuenta <= cuenta - 1;
               end if;
           
         when WriteToRamApellido =>
            rs <= '1';
            rw <= '0';
            e <= '0';
            if fin_cuenta then
            e <= '1';
            db <= apellido(i);
            fin_cuenta <= false;
                  if apellido(i) = x"20" then
                     proximo_estado <= Inh;
                  else
                  i <= i + 1;
                  cuenta <= wait_43us;
                 end if;
               cuenta <= wait_43us;
            end if; 
                          
         when WaitSetDDRAMAdress =>
            rs <= '1';
            rw <= '0';
            db <= "11000000";
               if fin_cuenta then
                  i <= 0;
                  cuenta <= wait_39us;
                  proximo_estado <= WriteToRamApellido;
               end if;
         end case; 
         end if;
         end if;
   end process;
   
   process (clk, reset)
   begin
      if reset = '1' then
          contador_thresh <= 0;
          thresh <= '0';
      elsif rising_edge(clk) then
          if contador_thresh = 99 then      -- tambien es 99
              thresh <= '1';
              contador_thresh <= 0;
          else
              thresh <= '0' ;
              contador_thresh <= contador_thresh + 1;
          end if;
      end if;
   end process;   
end Behavioral;
