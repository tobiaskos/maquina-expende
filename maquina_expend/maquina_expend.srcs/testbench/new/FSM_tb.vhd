----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.02.2024 12:25:35
-- Design Name: 
-- Module Name: FSM_tb - Behavioral
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

entity FSM_tb is
-- No ports
end FSM_tb;

architecture TB_ARCH of FSM_tb is
    signal clk_tb: std_logic := '0';
    signal reset_tb: std_logic := '1';
    signal digsel_all_tb: std_logic_vector(31 downto 0) := (others => '0');
    signal segment_all_tb: std_logic_vector(27 downto 0) := (others => '0');
    signal dp_all_tb: std_logic_vector(2 downto 0) := "000";
    signal led_all_tb: std_logic_vector(15 downto 0) := (others => '0');
    signal ok_count_tb: std_logic := '0';
    signal ok_opt_tb: std_logic := '0';
    signal sw_in_tb: std_logic_vector(3 downto 0) := "0000";

    signal digsel_tb_tb: std_logic_vector(7 downto 0);
    signal segments_tb_tb: std_logic_vector(6 downto 0);
    signal dp_tb_tb: std_logic;
    signal led_tb_tb: std_logic_vector(15 downto 0);
    signal ok_count_tb_tb: std_logic;
    signal ok_opt_tb_tb: std_logic;
    signal sw_in_tb_tb: std_logic_vector(3 downto 0);

    component FSM is
        port(
            clk: in std_logic;
            digsel_all:in std_logic_vector(31 downto 0);
            segment_all:in std_logic_vector(27 downto 0);
            dp_all:in std_logic_vector(2 downto 0);
            led_all:in std_logic_vector(15 downto 0);
            reset:in std_logic;
            ok_count:in std_logic;
            ok_opt:in std_logic;
            SW_in: IN std_logic_vector(3 DOWNTO 0);
            DP: out std_logic;
            digsel: out std_logic_vector (7 downto 0);
            led: out std_logic_vector (15 downto 0);
            segments:out std_logic_vector(6 downto 0)
        );
    end component;

begin
    UUT: FSM port map (
        clk => clk_tb,
        digsel_all => digsel_all_tb,
        segment_all => segment_all_tb,
        dp_all => dp_all_tb,
        led_all => led_all_tb,
        reset => reset_tb,
        ok_count => ok_count_tb,
        ok_opt => ok_opt_tb,
        SW_in => sw_in_tb,
        DP => dp_tb_tb,
        digsel => digsel_tb_tb,
        led => led_tb_tb,
        segments => segments_tb_tb
    );

    CLK_PROCESS: process
    begin
        while now < 500 ns loop  -- Duración de la simulación
            clk_tb <= not clk_tb after 5 ns;  -- Cambia la señal de reloj cada 5 ns
            wait for 2.5 ns;
        end loop;
        wait;
    end process;

    STIMULUS_PROCESS: process
    begin
        reset_tb <= '0'; 
        --digsel_all_tb <= (others => '0');  -- Configura todas las señales de selección a 0
        --segment_all_tb <= (others => '0');  -- Configura todas las señales de segmento a 0
       -- dp_all_tb <= "000";  -- Configura todas las señales de punto decimal a 0
        --led_all_tb <= (others => '0');  -- Configura todas las LEDs a 0
        ok_count_tb <= '0';  -- Configura la señal de contador a 0
        ok_opt_tb <= '0';  -- Configura la señal de opción a 0
        
        sw_in_tb <= "0000";  -- Configura la entrada del interruptor a 0

      
        wait;
    end process;
end TB_ARCH;
