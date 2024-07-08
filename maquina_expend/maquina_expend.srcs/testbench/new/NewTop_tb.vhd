----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.02.2024 11:50:48
-- Design Name: 
-- Module Name: NewTop_tb - Behavioral
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



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity New_Top_tb is
-- No ports
end New_Top_tb;

architecture TB_ARCH of New_Top_tb is
    signal clk_tb: std_logic := '0';
    signal reset_tb: std_logic := '1';
    signal coin_tb: std_logic_vector(3 downto 0) := "0000";
    signal reassemble_tb: std_logic := '0';
    signal sw_in_tb: std_logic_vector(3 downto 0) := "0000";

    signal digsel_aux1_tb, digsel_aux2_tb, digsel_aux3_tb, digsel_aux4_tb: std_logic_vector(7 downto 0);
    signal segment_aux1_tb, segment_aux2_tb, segment_aux3_tb, segment_aux4_tb: std_logic_vector(6 downto 0);
    signal DP_aux1_tb, DP_aux2_tb, DP_aux3_tb: std_logic;
    signal led_aux_tb: std_logic_vector(15 downto 0);
    signal error_aux_tb: std_logic;
    signal sw_aux_tb: std_logic_vector(2 downto 0);

    constant CLOCK_PERIOD: time := 10 ns;
    
    component Top is
        PORT (
            CLK: IN std_logic;
            reset: in std_logic;
            COIN: IN std_logic_vector(3 DOWNTO 0);
            reassemble: IN std_logic;
            SW_in: IN std_logic_vector(3 DOWNTO 0);
            digsel: OUT std_logic_vector(7 DOWNTO 0);
            segments: out std_logic_vector(6 downto 0);
            DP: out std_logic;
            led: OUT std_logic_vector(15 downto 0) 
        );
    end component;

begin
    UUT: Top port map (
        CLK => clk_tb,
        reset => reset_tb,
        COIN => coin_tb,
        reassemble => reassemble_tb,
        SW_in => sw_in_tb,
        digsel => digsel_aux1_tb,
        segments => segment_aux1_tb,
        DP => DP_aux1_tb,
        led => led_aux_tb
    );

    CLK_PROCESS: process
    begin
         while now < 50 ms loop  -- simulate for 5000 ns 
            clk_tb <= not clk_tb;
           wait for CLOCK_PERIOD / 2;
        end loop;
        wait;
    end process;

    STIMULUS_PROCESS: process
    begin
        
        reset_tb <= '1';  
        wait for 100 ns;        
        coin_tb <= "1000";  
        wait for 10 ns;
        coin_tb <= "0000";  
         wait for 10 ns;
        coin_tb <= "1000";  
        wait for 10 ns;
        coin_tb <= "0000";  
        wait for 10 ns;
        
        sw_in_tb <= "1001";  -- Simula un valor de interruptor de 6
        
        
        wait;
    end process;
end TB_ARCH;
