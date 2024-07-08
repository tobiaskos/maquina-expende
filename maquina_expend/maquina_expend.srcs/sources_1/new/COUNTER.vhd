----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2023 16:58:16
-- Design Name: 
-- Module Name: COUNTER - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity COUNTER is
    Port ( reset : in STD_LOGIC;
           CLK : in STD_LOGIC;
           COIN : in STD_LOGIC_VECTOR (3 downto 0);
           OK : in STD_LOGIC;
           count: out STD_LOGIC_VECTOR (6 downto 0);
           ok_cuenta: out std_logic
           );
           
end COUNTER;

architecture Behavioral of COUNTER is
    type ESTADO is (S0, S1);
    signal estado_actual: ESTADO := S0;
    signal estado_siguiente: ESTADO:=S1; 
    signal  actual_count : natural range 0 to 99:=0;
    signal ok_cuenta_aux: std_logic:='0';
    signal coin_anterior: std_logic:='0';
    signal coin_actual: std_logic:='0';
    begin
    process(clk, reset)
    begin
        if (reset = '1') then
            estado_actual <= S0;
        elsif (rising_edge(clk)) then
            estado_actual <= estado_siguiente;
            
        end if;
    end process;
--Estado S0, cuenta = 0
--Estado S1, suma las monedas
    process (coin)
    begin
        coin_anterior<=coin_actual;
        if coin="0001" or coin="0010" or coin="0100" or coin="1000" then
            coin_actual<='1';
        else
            coin_actual<='0';
        end if;
    end process;
    
    process (ok)
    begin
        if(ok = '1') then      
            --estado_siguiente <= S0;
            ok_cuenta_aux<='1';
        else
           estado_siguiente <= S1; --¡¡¡lo he descomentado!!
        end if;
    end process;  
   
  
    
   process (estado_actual, coin_actual)
    begin
        case estado_actual is
                when S0 =>
                    actual_count <= 0;
                    
                when S1 =>
                    if coin_anterior='0' and coin_actual= '1' then
                        if coin = "0001" then  -- 10 cent
                        actual_count <= actual_count + 1;
                       -- coin_anterior<='1';
                        elsif coin = "0010" then  -- 20 cent
                        actual_count <= actual_count + 2;
                      --  coin_anterior<='1';
                        elsif coin = "0100" then  -- 50 cent
                        actual_count <= actual_count + 5;
                      --  coin_anterior<='1';
                        elsif coin = "1000" then  -- 1 euro
                        actual_count <= actual_count + 10;
                      --  coin_anterior<='1';
                        end if;
                    end if;
                    
            end case;
end process;


    ok_cuenta<=ok_cuenta_aux;
    count <= std_logic_vector(to_unsigned(actual_count,  7));
    
end Behavioral;
