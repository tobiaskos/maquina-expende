----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.02.2024 12:24:16
-- Design Name: 
-- Module Name: OPTIONandCHANGE - Behavioral
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

entity OPTIONandCHANGE is
end OPTIONandCHANGE;

architecture sim of OPTIONandCHANGE is
  signal clk_tb : std_logic := '0';
  signal reset_tb : std_logic := '0';
  signal count_tb : std_logic_vector(6 downto 0) := (others => '0');
 -- signal sw_tb : std_logic_vector(2 downto 0) := "000";
  signal ok_start_disp_option_tb : std_logic := '0';
  signal ok_start_disp_change_tb : std_logic := '0';
  signal reassemble_tb : std_logic := '0';
  
  signal clk_aux_tb : std_logic := '0';
  
  signal digsel_tb : std_logic_vector(7 downto 0) := (others => '0');
  signal segment_tb : std_logic_vector(6 downto 0) := (others => '0');
  signal DP_tb : std_logic := '0';
  signal error_tb : std_logic := '0';
  signal ok_op_tb : std_logic := '0';
  
  signal option_tb : std_logic_vector(2 downto 0) := "000";
  signal change_tb : std_logic_vector(6 downto 0) := (others => '0');
  signal num_ud_tb : std_logic_vector(3 downto 0) := (others => '0');
  signal num_dec_tb : std_logic_vector(3 downto 0) := (others => '0');

  constant clk_period : time := 10 ns;

  component DISPLAY_OPTION
    Port (  
      clk : in STD_LOGIC;
      reset : in STD_LOGIC;
      count : in STD_LOGIC_VECTOR (6 downto 0);
      ok_start_disp_option : in std_logic;
      sw : in STD_LOGIC_VECTOR (2 downto 0);
      digsel : out STD_LOGIC_VECTOR ( 7 downto 0);
      segment : out STD_LOGIC_VECTOR (6 downto 0);
      DP : out std_logic;
      error : out std_logic;
      ok_op : out std_logic
    );
  end component;

  component DISPLAY_CH
    Port ( 
      clk : in STD_LOGIC;
      reset : in STD_LOGIC;
      option : in STD_LOGIC_VECTOR (2 downto 0);
      reassemble : in STD_LOGIC;
      count : in STD_LOGIC_VECTOR (6 downto 0);
      ok_start_disp_change : in std_logic;
      digsel : out STD_LOGIC_VECTOR (7 downto 0);
      segment : out STD_LOGIC_VECTOR (6 downto 0);
      num_ud : out std_logic_vector(3 downto 0);
      num_dec : out std_logic_vector(3 downto 0);
      DP : out std_logic
    );
  end component;

begin
-- Display Option instantiation
  uut_display_option : DISPLAY_OPTION
    port map(
      clk => clk_tb,
      reset => reset_tb,
      count => count_tb,
      ok_start_disp_option => ok_start_disp_option_tb,
      sw => option_tb,
      digsel => digsel_tb,
      segment => segment_tb,
      DP => DP_tb,
      error => error_tb,
      ok_op => ok_op_tb
    );

  -- Display CH instantiation
  uut_display_ch : DISPLAY_CH
    port map(
      clk => clk_tb,
      reset => reset_tb,
      option => option_tb,
      reassemble => reassemble_tb,
      count => count_tb,
      ok_start_disp_change => ok_start_disp_change_tb,
      digsel => digsel_tb,
      segment => segment_tb,
      num_ud => num_ud_tb,
      num_dec => num_dec_tb,
      DP => DP_tb
    );
 
 
  -- Clock process
  process
  begin
    while now < 1000 ms loop
      clk_tb <= not clk_tb;
      wait for clk_period / 2;
    end loop;
    wait;
  end process;


  -- Stimulus process
  process
  begin
    
    reset_tb <= '0';
    ok_start_disp_option_tb <= '1';
    ok_start_disp_change_tb <= '1';
    count_tb<="0010100";
    option_tb<="100";
    reassemble_tb<='0';
    
    wait;
  end process;

  

end sim;
