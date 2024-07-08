----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.12.2023 12:47:53
-- Design Name: 
-- Module Name: display_counter_tb - Behavioral
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
-- arithmeticlibrary IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TB_DISPLAY_COUNTERS is
end TB_DISPLAY_COUNTERS;

architecture TESTBENCH of TB_DISPLAY_COUNTERS is

  signal clk_tb: STD_LOGIC := '0';
  signal reset_tb: STD_LOGIC := '0';
  signal coin_in_tb: STD_LOGIC_VECTOR(3 downto 0) := "0000";
  signal ok_in_tb: STD_LOGIC := '0';

  signal digsel_tb: STD_LOGIC_VECTOR(7 downto 0):="00000000";
  signal segment_out_tb: STD_LOGIC_VECTOR(6 downto 0) := (others => '0');
  signal count_tb: STD_LOGIC_VECTOR(6 downto 0):= (others => '0');
  signal ok_out_tb: STD_LOGIC:='0';
  signal DP_tb: STD_LOGIC:= '0';

  constant CLK_PERIOD : time := 10 ns;  -- Define your clock period here
  COMPONENT DISPLAY_COUNTER
    Port ( 
      clk : in STD_LOGIC;
      coin_in : in STD_LOGIC_VECTOR(3 downto 0);
      reset : in STD_LOGIC;
      ok_in : in STD_LOGIC;
      digsel : out STD_LOGIC_VECTOR(7 downto 0);
      segment_out : out STD_LOGIC_VECTOR(6 downto 0);
      count : out STD_LOGIC_VECTOR(6 downto 0);
      ok_out : out STD_LOGIC;
      DP : out STD_LOGIC
    );
  end COMPONENT;
  -- Clock process
  begin
    UUT: DISPLAY_COUNTER
    port map (
     clk=>clk_tb,
     coin_in=>coin_in_tb,
     reset=>reset_tb, 
     ok_in=>ok_in_tb, 
     digsel=>digsel_tb,
     segment_out=>segment_out_tb, 
     count=>count_tb, 
     ok_out=>ok_out_tb, 
     DP=>DP_tb);
  -- Stimulus process
    process
    begin
      while now < 50 ms loop  -- simulate for 5000 ns 
            clk_tb <= not clk_tb;
           wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;
    process
    begin
        wait for 2ms;
        coin_in_tb <= "0000";
        wait for 1ms;
        coin_in_tb <= "0001"; -- Set some example input values
        reset_tb <= '0';
        wait for 1ms;
        coin_in_tb <= "0000";
        wait for 1ms;
        coin_in_tb <= "0010";
        wait for 1ms;
        coin_in_tb <= "0000";
        wait for 1ms;
        coin_in_tb <= "1000";
        wait for 1ms;        
        coin_in_tb <= "0000";
        wait for 1ms;
        reset_tb <= '1';
        wait for 1ms;
        reset_tb <= '0';
        wait for 1ms;
        coin_in_tb <= "1000";
        wait for 1ms;        
        coin_in_tb <= "0000";
        wait;
                -- Add more test cases as needed
    end process;
end TESTBENCH;
