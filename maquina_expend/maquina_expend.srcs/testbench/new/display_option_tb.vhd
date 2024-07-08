----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.02.2024 14:58:47
-- Design Name: 
-- Module Name: display_option_tb - Behavioral
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

ENTITY DISPLAY_OPTION_TB IS
END DISPLAY_OPTION_TB;

ARCHITECTURE behavior OF DISPLAY_OPTION_TB IS 

  SIGNAL clk_tb         : STD_LOGIC := '0';
  SIGNAL reset_tb       : STD_LOGIC := '0';
  SIGNAL count_tb       : STD_LOGIC_VECTOR (6 DOWNTO 0) := (OTHERS => '0');
  SIGNAL ok_start_disp_option_tb : STD_LOGIC := '0';
  SIGNAL sw_tb          : STD_LOGIC_VECTOR (2 DOWNTO 0) := "000";
  SIGNAL digsel_tb      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL segment_tb     : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL DP_tb          : STD_LOGIC;
  SIGNAL error_tb       : STD_LOGIC;
  SIGNAL ok_op_tb       : STD_LOGIC;

  COMPONENT DISPLAY_OPTION
    PORT(
      clk                  : IN STD_LOGIC;
      reset                : IN STD_LOGIC;
      count                : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
      ok_start_disp_option : IN STD_LOGIC;
      sw                   : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      digsel               : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      segment              : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      DP                   : OUT STD_LOGIC;
      error                : OUT STD_LOGIC;
      ok_op                : OUT STD_LOGIC
    );
  END COMPONENT;

BEGIN

  UUT: DISPLAY_OPTION PORT MAP(
    clk                  => clk_tb,
    reset                => reset_tb,
    count                => count_tb,
    ok_start_disp_option => ok_start_disp_option_tb,
    sw                   => sw_tb,
    digsel               => digsel_tb,
    segment              => segment_tb,
    DP                   => DP_tb,
    error                => error_tb,
    ok_op                => ok_op_tb
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
    --ok_start_disp_option_tb <= '0';
    reset_tb <= '1';
   -- count_tb<="0010100"; --cuenta de 2€
   -- sw_tb<="100"; --elijo agua que vale 1€: error tiene que ser 0 y ok_op 1
  
   -- wait for 300 ns;
    ok_start_disp_option_tb <= '1';
    --wait for 100 ns;
    count_tb<="0010100"; --cuenta de 2€
    sw_tb<="100"; --elijo agua que vale 1€: error tiene que ser 0 y ok_op 1
    --reset_tb <= '1';
    wait for 100 ns;
    
    reset_tb <= '0';
    ok_start_disp_option_tb <= '1';
    wait for 100 ns;
    -- Add more stimulus as needed

    wait;
  END PROCESS;

END;

