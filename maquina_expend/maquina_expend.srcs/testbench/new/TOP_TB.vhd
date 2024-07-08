----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.02.2024 12:21:02
-- Design Name: 
-- Module Name: NewTop2_tb - Behavioral
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

entity TOP_TB is
-- No ports
end TOP_TB;

architecture TB_ARCH of TOP_TB is
    signal clk_tb: std_logic := '0';
    signal reset_tb: std_logic := '1';
    signal coin_tb: std_logic_vector(3 downto 0) := "0000";
    signal reassemble_tb: std_logic := '0';
    signal sw_in_tb: std_logic_vector(3 downto 0) := "0000";

    signal digsel_aux1_tb: std_logic_vector(7 downto 0);
    signal segment_aux1_tb: std_logic_vector(6 downto 0);
    signal DP_aux1_tb: std_logic;
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
    digsels: OUT std_logic_vector(7 DOWNTO 0);
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
        digsels => digsel_aux1_tb,
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
        
        wait for 1 ms;        
        coin_tb <= "1000";  
        wait for 1 ms;        
        coin_tb <= "0000";
        wait for 1 ms;
        sw_in_tb <= "1001";  
        
        wait;
    end process;
end TB_ARCH;