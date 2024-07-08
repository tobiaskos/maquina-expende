----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.01.2024 19:22:52
-- Design Name: 
-- Module Name: FSM - Behavioral
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

entity FSM is
port(
    clk: in std_logic;
    digsel_all:in std_logic_vector(31 downto 0):=(others=>'0');
    segment_all:in std_logic_vector(27 downto 0):=(others=>'0');
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
end FSM;

architecture Behavioral of FSM is
    type STATE is (COUNTER_STATE, OPTIONS_STATE, CHANGE_STATE, ERROR_STATE);
    signal estado_actual: STATE := COUNTER_STATE;
    signal estado_siguiente: STATE ;
    signal ok_counter: std_logic:='0';
    signal ok_option: std_logic:='0'; --es el negado de 'error' de display_option
    --signal reset_aux: std_logic;
   -- signal clk_aux: std_logic;
    signal count_aux: std_logic_vector(6 downto 0);
    signal digsel_aux1,digsel_aux2,digsel_aux3,digsel_aux4: std_logic_vector (7 downto 0):="00000000";
    signal segment_aux1: std_logic_vector (6 downto 0):="0000000";
    signal segment_aux2: std_logic_vector (6 downto 0):="0000000";
    signal segment_aux3: std_logic_vector (6 downto 0):="0000000";
    signal segment_aux4: std_logic_vector (6 downto 0):="0000000";
    signal DP_aux1: std_logic;
    signal DP_aux2: std_logic;
    signal DP_aux3: std_logic;
    --signal error_aux:std_logic;
    signal led_aux:std_logic_vector(15 downto 0);
  --  signal sw_aux: std_logic_vector(2 downto 0);
begin

process(clk, reset)
    begin
        if (reset = '1') then
            estado_actual <= COUNTER_STATE;
        elsif (rising_edge(clk)) then
            estado_actual <= estado_siguiente;
        end if;
    end process;

process (estado_siguiente)
    begin
        case estado_actual is
        when COUNTER_STATE=>
            if (ok_counter='1') then
            estado_siguiente<=OPTIONS_STATE;
            ok_counter<='0';
            end if;
            segments<=segment_all(27 downto 21);
            DP<=DP_all(2); 
            digsel<=digsel_all(31 downto 24);
            
        when OPTIONS_STATE=>
            if (ok_option='1') then
            estado_siguiente<=CHANGE_STATE;
            end if;
            segments<=segment_all(20 downto 14);
            DP<=DP_all(1); 
            digsel<=digsel_all(23 downto 16);
        when CHANGE_STATE=>
            if (falling_edge(ok_option)) then
            estado_siguiente<=ERROR_STATE;
            end if;  
            segments<=segment_all(13 downto 7); 
            DP<=DP_all(0);
            digsel<=digsel_all(15 downto 8);
                
        when ERROR_STATE=>
            ok_option<='1';
            estado_siguiente<=COUNTER_STATE;
            segments<=segment_all(6 downto 0);
            digsel<=digsel_all(7 downto 0);
            led<=led_all;
        end case;   
    end process;
  ok_counter<=ok_count;
  ok_option<=ok_opt;  
   -- error_aux<=not ok_option;
  --  sw_aux<=sw_in(3 downto 1);
   -- clk_aux<=clk;
    --reset_aux<=not reset;

end Behavioral;
