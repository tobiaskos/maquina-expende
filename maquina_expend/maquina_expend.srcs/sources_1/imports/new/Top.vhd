----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.12.2023 15:54:02
-- Design Name: 
-- Module Name: Top - Behavioral
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

entity Top is
--  Port ( );
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
end Top;

architecture Behavioral of Top is
    type STATE is (COUNTER_STATE, OPTIONS_STATE, CHANGE_STATE, ERROR_STATE);
    signal estado_actual: STATE := COUNTER_STATE;
    signal estado_siguiente: STATE ;
    signal ok_counter: std_logic:='0';
    signal ok_option: std_logic:='0'; --es el negado de 'error' de display_option
    signal reset_aux: std_logic;
    signal clk_aux: std_logic;
    signal count_aux: std_logic_vector(6 downto 0);
    signal digsel_aux1,digsel_aux2,digsel_aux3,digsel_aux4: std_logic_vector (7 downto 0):="00000000";
    signal segment_aux1: std_logic_vector (6 downto 0):="0000000";
    signal segment_aux2: std_logic_vector (6 downto 0):="0000000";
    signal segment_aux3: std_logic_vector (6 downto 0):="0000000";
    signal segment_aux4: std_logic_vector (6 downto 0):="0000000";
    signal DP_aux1: std_logic;
    signal DP_aux2: std_logic;
    signal DP_aux3: std_logic;
    signal error_aux:std_logic;
    signal led_aux:std_logic_vector(15 downto 0);
    signal sw_aux: std_logic_vector(2 downto 0);
    signal digsel_all_aux: std_logic_vector(31 downto 0):=(others=>'0');
    signal segment_all_aux:std_logic_vector(27 downto 0):=(others=>'0');
    signal dp_all_aux:std_logic_vector(2 downto 0):=(others=>'0');
    signal led_all_aux:std_logic_vector(15 downto 0):=(others=>'0'); 
    
    
   component DISPLAY_COUNTER is
    Port ( clk : in STD_LOGIC;
       coin_in : in std_logic_vector(3 downto 0);
       reset : in STD_LOGIC;
       ok_in : in std_logic;
       digsel : out STD_LOGIC_VECTOR (7 downto 0);
       segment_out : out STD_LOGIC_VECTOR (6 downto 0);
       count : out STD_LOGIC_VECTOR (6 downto 0);
       ok_out : out std_logic;
       DP : out std_logic    );
    end component;
    
    component DISPLAY_CH is
    Port ( clk : in STD_LOGIC;
       reset : in STD_LOGIC;
       --change: in STD_LOGIC_VECTOR (3 downto 0);
       option: in STD_LOGIC_VECTOR (2 downto 0);
       reassemble: in STD_LOGIC;
       count: in STD_LOGIC_VECTOR (6 downto 0);
       ok_start_disp_change: in std_logic;
       digsel : out STD_LOGIC_VECTOR (7 downto 0);
       segment : out STD_LOGIC_VECTOR (6 downto 0);
       DP : out std_logic);
    end component;
    
    component DISPLAY_ERR is
Port ( clk : in STD_LOGIC;
       reset : in STD_LOGIC;
       input_error: in  std_logic;
       led: OUT STD_LOGIC_vector(15 downto 0);
       digsel : out STD_LOGIC_VECTOR (7 downto 0);
       segment : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component DISPLAY_OPTION is
Port (  clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        count: in STD_LOGIC_VECTOR (6 downto 0);
        sw: in STD_LOGIC_VECTOR (2 downto 0);
        ok_start_disp_option:in std_logic;
        digsel : out STD_LOGIC_VECTOR (7 downto 0);
        segment : out STD_LOGIC_VECTOR (6 downto 0);
        DP : out std_logic;
        ok_op: out std_logic;
        error : out std_logic);        
end component;

component FSM is
port(
    clk: in std_logic;
    digsel_all:in std_logic_vector(31 downto 0);
    segment_all:in std_logic_vector(27 downto 0);
    dp_all:in std_logic_vector(2 downto 0);
    led_all:in std_logic_vector(15 downto 0); 
    reset:in std_logic;
    SW_in: IN std_logic_vector(3 DOWNTO 0);
    DP: out std_logic;
    digsel: out std_logic_vector (7 downto 0);
    led: out std_logic_vector (15 downto 0);
    ok_count:in std_logic;
    ok_opt:in std_logic;
    segments:out std_logic_vector(6 downto 0)
    );
end component;    

begin

inst_DISPLAY_COUNTER: DISPLAY_COUNTER Port map ( 
       clk =>clk_aux,
       coin_in=> coin,
       reset=>reset_aux,
       ok_in => sw_in(0),
       digsel => digsel_aux1,
       segment_out => segment_aux1,
       count => count_aux,
       ok_out=> ok_counter,
       DP =>DP_aux1); 
       
 inst_DISPLAY_OPTION: DISPLAY_OPTION port map(
       clk =>clk_aux,
        reset=>reset_aux,
        count=>count_aux,
        sw=> sw_aux,
        ok_op=>ok_option,
        ok_start_disp_option=>ok_counter,
        digsel =>digsel_aux2,
        segment=> segment_aux2,
        error=> error_aux,
        DP=>DP_aux2
 );    

inst_DISPLAY_CH: DISPLAY_CH port map(
       clk =>clk_aux,
       reset =>reset_aux,
       option=>sw_aux,
       reassemble=> reassemble,
       ok_start_disp_change=>ok_option,
       count=>count_aux,
       digsel =>digsel_aux3,
       segment=>segment_aux3,
       DP=>DP_aux3
);

inst_DISPLAY_ERR: DISPLAY_ERR port map(
       clk => clk_aux,
       reset =>reset_aux,
       input_error=> error_aux,
       led=>led_aux,
       digsel=> digsel_aux4,
       segment=>segment_aux4
);

inst_FSM: FSM port map(
    clk=> clk_aux,
    digsel_all=>digsel_all_aux,
    segment_all=>segment_all_aux,
    dp_all=>dp_all_aux,
    led_all=>led_all_aux,
    reset=>reset_aux,
    SW_in=> SW_in,
    DP=>DP,
    digsel=>digsels,
    led=>led,
    ok_opt=>ok_option,
    ok_count=>ok_counter,
    segments=>segments
);
    digsel_all_aux<=digsel_aux1 & digsel_aux2 & digsel_aux3 & digsel_aux4;
    segment_all_aux<=segment_aux1 & segment_aux2 & segment_aux3 & segment_aux4;
    dp_all_aux<=DP_aux1 & DP_aux2 & DP_aux3;
    led_all_aux<=led_aux;
    error_aux<=not ok_option; 
    sw_aux<=sw_in(3 downto 1);
    clk_aux<=clk;
    reset_aux<=not reset;
end Behavioral;
