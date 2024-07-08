----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.02.2024 14:13:38
-- Design Name: 
-- Module Name: compare_tb - Behavioral
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


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY COMPARE_TB IS
END COMPARE_TB;

ARCHITECTURE behavior OF COMPARE_TB IS 
  SIGNAL clk_tb           : STD_LOGIC := '0';
  SIGNAL reset_tb         : STD_LOGIC := '0';
  SIGNAL price_tb         : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
  SIGNAL count_tb         : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";
  SIGNAL ok_compare_tb    : STD_LOGIC := '0';
  SIGNAL option_tb       : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
  SIGNAL importe_ok_tb   : STD_LOGIC;
  SIGNAL error_tb        : STD_LOGIC;
BEGIN

  UUT: ENTITY work.COMPARE PORT MAP(
    clk         => clk_tb,
    reset       => reset_tb,
   -- price       => price_tb,
    count       => count_tb,
    ok_compare  => ok_compare_tb,
    option      => option_tb,
    importe_ok  => importe_ok_tb,
    error_comp      => error_tb
  );

  -- Clock process
  clk_process : PROCESS
  BEGIN
    WAIT FOR 5 ns;
    clk_tb <= NOT clk_tb;
  END PROCESS;

  -- Stimulus process
  stim_proc: PROCESS
  BEGIN
    -- Initialize inputs
    --reset_tb <= '1';
   -- wait for 10 ns;
    reset_tb <= '0';
    ok_compare_tb <= '1';
    
    count_tb <= "0000001"; 
    option_tb <= "100"; --agua que vale 1€
    wait for 50ns;
    count_tb <= "0010100"; 
    wait for 50ns;
    reset_tb <= '1';
    wait for 10ns;
    reset_tb <= '0';
    wait for 50ns;
    option_tb <= "100"; 
    count_tb <= "0010100";
    ok_compare_tb <= '1';
    wait for 50ns;
    ok_compare_tb <= '0';
    wait for 50ns;
    wait;
  END PROCESS;

END;
