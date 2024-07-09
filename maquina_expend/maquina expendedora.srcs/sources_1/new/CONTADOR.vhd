----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.12.2022 14:45:14
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
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity COUNTER is
   Port(   
        --INPUTS
        clk: in std_logic; -- clock
        reset: in std_logic; --Asynchronous reset
        coin: in std_logic_vector(3 downto 0); -- Coins input
        option: in std_logic; -- 1 if any product is selected
        price: in natural range 0 to 20; -- Drink price
        reassemble: in std_logic; -- Manual restart
        --OUTPUTS
        count: out unsigned(4 downto 0); -- Money count
        change: out natural range 0 to 10 -- Money change 
    );
end COUNTER;

architecture Behavioral of COUNTER is

-- DECLARACION DE SE ALES
    -- usamos count_s para poder leer el valor acumulado
    signal count_s: unsigned(4 downto 0) := "00000";

begin
        
    coin_sum: process(clk, reset)
    variable cuenta: unsigned(4 downto 0) := "00000";
    begin
        if (reset = '0') then
            cuenta := "00000";
        elsif (option = '0') then
            cuenta := "00000";
        elsif rising_edge(clk) then
            if(coin(0) = '1') then
                cuenta := cuenta + "00001";
            elsif(coin(1) = '1') then
                cuenta := cuenta + "00010";
            elsif(coin(2) = '1') then
                cuenta := cuenta + "00101";
            elsif(coin(3) = '1') then
                cuenta := cuenta + "01010";
            end if;
        end if;
        count_s <= cuenta;
    end process;

    money_change: process(reset , clk, reassemble)
    variable count_s_N: natural range 0 to 30;
    variable cambio: natural range 0 to 10 := 0;
    begin
        count_s_N := to_integer(count_s);
        if (reset = '0') then
            cambio := 0;    
        elsif(count_s_N > price) then
            cambio := count_s_N - price;
        elsif(reassemble = '0' and cambio /= 0) then
            cambio := cambio;
        else
            cambio := 0;
        end if;
        change <= cambio;
    end process;

-- ASIGNACION DE PUERTOS
    count <= count_s;

end Behavioral;
