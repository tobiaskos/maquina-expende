----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.12.2023 14:04:28
-- Design Name: 
-- Module Name: CHANGE_tb - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CHANGE_tb is
end CHANGE_tb;

architecture tb_architecture of CHANGE_tb is
    signal reset_tb          : std_logic := '0';
    signal clk_tb            : std_logic := '0';
    signal option_tb         : std_logic_vector(2 downto 0) := "000";
    signal reassemble_tb     : std_logic := '0';
    signal count_tb          : std_logic_vector(6 downto 0) := "0000000";
    signal change_tb         : std_logic_vector(6 downto 0);

begin
    uut: entity work.CHANGE
        port map (
            reset => reset_tb,
            clk => clk_tb,
            option => option_tb,
            reassemble => reassemble_tb,
            count => count_tb,
            change => change_tb
        );

    clk_process: process
    begin
        while now < 5000 ns loop
            clk_tb <= not clk_tb;
            wait for 5 ns;
        end loop;
        wait;
    end process;

    stimuli_process: process
    begin
        count_tb<="1111111";
        reset_tb <= '0';
        wait for 10 ns;
        reset_tb <= '1';

        wait for 100 ns;

        -- Puedes cambiar las entradas según tus necesidades
        option_tb <= "100"; -- AGUA
       -- reassemble_tb <= '0';     
        wait for 200 ns;
        option_tb <= "010";      
        wait for 200 ns;
        reset_tb <= '0';
        wait for 100 ns;
        reset_tb <= '1';
         option_tb <= "001";         
        wait for 200 ns;
        --reassemble_tb <= '1';
       
        option_tb <= "100"; -- AGUA
        reassemble_tb <= '1';     
        wait for 10 ns;
        reassemble_tb <= '0';  
        wait for 200 ns;
        option_tb <= "010";      
        wait for 200 ns;
        

        -- Puedes seguir agregando más estímulos según sea necesario

        wait;
    end process;

end tb_architecture;
