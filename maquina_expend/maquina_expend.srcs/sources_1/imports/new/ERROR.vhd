----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2023 16:08:41
-- Design Name: 
-- Module Name: ERROR - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ERROR is
PORT (
    error : IN std_logic;
    reset : IN STD_LOGIC;
    CLK : IN STD_LOGIC;
    led: OUT std_logic_vector(15 downto 0);
    digsel: OUT std_logic_vector(7 downto 0);
    segment_error : OUT std_logic_vector(6 DOWNTO 0) 
    
);
end ERROR;

architecture Behavioral of ERROR is
--Para cambiar pantalla de tal modo que no sea perceptible para...
-- ... el ojo y parezca un texto mostrado de manera continua:
signal counter_1ms: natural range 0 to 99999 := 0;

--Para cambiar de digsel:
signal digsel_change: natural range 0 to 7 := 0;
signal enciende_led:  boolean :=false;  
begin

    reloj_1ms: process(CLK)
    begin
        if (rising_edge(CLK)) then
            counter_1ms <= counter_1ms + 1; 
            if (counter_1ms >= 9) then
                counter_1ms <= 0;
                if (digsel_change=0 or digsel_change=1 ) then
                    digsel_change <= digsel_change + 1;
                else
                    digsel_change <= 0;
                end if;
                --digsel_change <= digsel_change + 1;   
                --if (digsel_change > 3)then
               --     digsel_change <= 0;
              --  end if;
            end if;
        end if;
    end process;



--Process para mostrar 'Err' indicativo de error
error_display: process(error, reset,digsel_change)
    begin
        if (reset='0' or error='0') then
             enciende_led<= false;  
             case (digsel_change) is
                    when others =>
                        digsel <= "11111111";
                        segment_error <= "1111111"; 
                end case;
        else
            if (error = '1') then
                enciende_led<= true;  
                case (digsel_change) is
                    when 0 =>
                        digsel <= "11111011";
                        segment_error <= "0110000"; -- E (activo a nivel bajo)
                    when 1 =>
                        digsel <= "11111101";
                        segment_error <= "1111010"; -- r
                    when 2=>
                        digsel <= "11111110";
                        segment_error <= "1111010"; -- r
                    when others=>
                        digsel <= "11111111";
                        segment_error <= "1111111";
                end case;
            else 
                enciende_led<= false;  
            end if;
        end if;            
        
end process;


process (enciende_led)
begin
    if (enciende_led=true) then
        led<=(others=>'1');
     else
        led<=(others=>'0');
    end if;
end process;

end Behavioral;
