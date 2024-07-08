----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.12.2022 22:09:02
-- Design Name: 
-- Module Name: FSM_DISPLAY - Behavioral
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
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity display is
    Port(
        --INPUTS
        clk: in std_logic; -- clock
        reset: in std_logic; -- Asynchronous reset
        reassemble: in std_logic; -- Manual restart
        count: in unsigned(4 downto 0); -- Money count
        price: in natural range 0 to 20; -- Drink price
        change: in natural range 0 to 10; -- Money change
        option: in std_logic; -- 1 if any product is selected  
        confirmed_sale: in std_logic; -- 1 if an item is sold
        --OUTPUTS
        segments: out std_logic_vector(7 downto 0); -- Active digit segments
        digsel: out std_logic_vector(7 downto 0) -- Active digit selection        
    );              
end entity display;

architecture Behavioral of display is

-- Signal declaration
    -- Define a state for each screen to display
    type DISPLAY_STATE is (S0, S1, S2);-- S0: choose product
                                       -- S1: insert coins
                                       -- S2: manual reset
    signal present_state: DISPLAY_STATE := S0;
    signal next_state: DISPLAY_STATE;
                                                   
    -- counter_1ms allows us to modify the clock frequency
    -- we will have 100[MHz]/(99999+1) = 1[kHz] which will be the digit change rate
    -- each digit will take 1[ms] to change and will light up again within 8[ms]
    -- 8[ms] is within the 1-16[ms] margin provided in the datasheet
    -- this ensures no flickering
    signal counter_1ms: natural range 0 to 99999 := 0;
    -- counter_2s allows us to change the final screen every 2 seconds
    -- we will have 100[MHz]/(199999999+1) = 0.5[Hz]
    signal counter_2s: natural range 0 to 199999999 := 0;
    -- digit_ctrl allows us to alternate the active digit
    signal digit_ctrl: natural range 0 to 7 := 0;
    -- final_ctrl allows us to change the final screen
    signal final_ctrl: natural range 0 to 1 := 0;
    
begin

    -- Generate a signal that changes every millisecond (digit_ctrl)
    reloj_1ms: process(clk)
    begin
        if (rising_edge(clk)) then
            counter_1ms <= counter_1ms + 1;
            if (counter_1ms >= 99999) then
                counter_1ms <= 0;
                digit_ctrl <= digit_ctrl + 1;
                if (digit_ctrl > 7)then
                    digit_ctrl <= 0;
                end if;
            end if;
        end if;
    end process;
    
    -- Generate a signal that changes every 2 seconds (final_ctrl)
    reloj_2s: process(clk)
    begin
        if (rising_edge(clk)) then
            counter_2s <= counter_2s + 1;
            if (counter_2s >= 199999999) then
                counter_2s <= 0;
                final_ctrl <= final_ctrl + 1;
                if (final_ctrl > 1)then
                    final_ctrl <= 0;
                end if;
            end if;
        end if;
    end process;
    
    -- Associate the anodes of the diodes with the 1[ms] signal
    digit_control: process(digit_ctrl)
    begin
        case (digit_ctrl) is
            when 0 =>
                -- Means we want the first digit active (active low)
                digsel <= "01111111";
            when 1 =>
                digsel <= "10111111";
            when 2 =>
                digsel <= "11011111";
            when 3 =>
                digsel <= "11101111";
            when 4 =>
                digsel <= "11110111";
            when 5 =>
                digsel <= "11111011";
            when 6 =>
                digsel <= "11111101";
            when 7 =>
                digsel <= "11111110";
        end case;
    end process;

    -- State control for the finite state machine
    state_register: process(clk, reset)    
    begin
        if (reset = '0') then            
            present_state <= S0;            
        elsif (rising_edge(clk)) then
            present_state <= next_state;
        end if;
    end process;
    
    next_state_decoder: process(present_state, reassemble)    
    begin
        next_state <= present_state;
        case (present_state) is
            when S0 =>
                if (option = '1') then
                    next_state <= S1;
                end if;
            when S1 =>
                if (option = '0') then
                    next_state <= S0;
                elsif (confirmed_sale = '1') then
                    next_state <= S2;
                end if;
            when S2 =>
                if (reassemble = '1') then
                    next_state <= S0;
                end if;
            when others =>
                next_state <= S0;
        end case;
    end process;
    
    -- Set the segment patterns based on the state
    output_decoder: process(present_state, reset, digit_ctrl, final_ctrl)
    variable count_N: natural range 0 to 30;
    begin
        count_N := to_integer(count);
        segments <= "11111111";
        if (reset = '0') then
            segments <= "11111111";            
        else
            case (present_state) is
                when S0 =>
                    -- Display message CHOSE.SW
                    if (digit_ctrl = 0) then
                        segments <= "10110001"; -- C
                    elsif (digit_ctrl = 1) then
                        segments <= "11001000"; -- H
                    elsif (digit_ctrl = 2) then
                        segments <= "10000001"; -- O/0
                    elsif (digit_ctrl = 3) then
                        segments <= "10100100"; -- S/5
                    elsif (digit_ctrl = 4) then
                        segments <= "00110000";-- E.
                    elsif (digit_ctrl = 5) then
                        segments <= "10100100"; -- S/5
                        
                    -- Cannot display W, so concatenate 2 U's
                    elsif (digit_ctrl = 6) then
                        segments <= "11000001"; -- U
                    elsif (digit_ctrl = 7) then                
                        segments <= "11000001"; -- U
                    end if;
                    
                when S1 =>
                    -- Display price on the left and inserted coins on the right
                    -- 1.X0E X.X0E                            
                    --  4 LEFT DIGITS
                    if (digit_ctrl = 0) then
                        segments <= "01001111"; -- 1.
                    elsif (digit_ctrl = 1) then
                        case (price) is
                            when 10 =>
                                segments <= "10000001"; -- 0
                            when 12 =>
                                segments <= "10010010"; -- 2
                            when 15 =>
                                segments <= "10100100"; -- 5
                            when 18 =>
                                segments <= "10000000"; -- 8
                            when others =>
                                segments <= "11111111"; -- Should not occur, but will be off
                        end case;
                    elsif (digit_ctrl = 2) then
                        segments <= "10000001"; -- 0
                    elsif (digit_ctrl = 3) then
                        segments <= "10110000";-- E
                    
                    --  4 RIGHT DIGITS
                    elsif (digit_ctrl = 4) then
                        if (count_N < 10) then
                            segments <= "00000001"; -- 0.
                        elsif (count < 20) then
                            segments <= "01001111"; -- 1.
                        else
                            segments <= "00010010"; -- 2.
                        end if;
                    elsif (digit_ctrl = 5) then
                        case (count_N mod 10) is
                            when 0 =>
                                segments <= "10000001"; -- 0
                            when 1 =>
                                segments <= "11001111"; -- 1
                            when 2 =>
                                segments <= "10010010"; -- 2                            
                            when 3 =>
                                segments <= "10000110"; -- 3                           
                            when 4 =>
                                segments <= "11001100"; -- 4                            
                            when 5 =>
                                segments <= "10100100"; -- 5                            
                            when 6 =>
                                segments <= "10100000"; -- 6                            
                            when 7 =>
                                segments <= "11001111"; -- 7                            
                            when 8 =>
                                segments <= "10000000"; -- 8                            
                            when 9 =>
                                segments <= "10000100"; -- 9
                            when others =>
                                segments <= "11111111"; -- Should not occur, but will be off                            
                        end case;
                    elsif (digit_ctrl = 6) then
                        segments <= "10000001"; -- 0
                    elsif (digit_ctrl = 7) then
                        segments <= "10110000"; -- E
                    end if;
                
                when S2 =>
                    if (final_ctrl = 0) then
                        -- Display message: H.LO.SA.
                        if (digit_ctrl = 0) then
                            segments <= "11001000"; -- H
                        elsif (digit_ctrl = 1) then
                            segments <= "11111111"; -- <off>
                        elsif (digit_ctrl = 2) then
                            segments <= "11001100"; -- L
                        elsif (digit_ctrl = 3) then
                            segments <= "10100000"; -- O
                        elsif (digit_ctrl = 4) then
                            segments <= "10110000";-- S
                        elsif (digit_ctrl = 5) then
                            segments <= "11001111";-- A
                        elsif (digit_ctrl = 6) then
                            segments <= "10110000";-- .
                        elsif (digit_ctrl = 7) then
                            segments <= "11111111";-- <off>
                        end if;
                    else
                        -- Display change
                        -- Message: 0.<change>0E
                        if (digit_ctrl = 0) then
                            segments <= "00000001"; -- 0.
                        elsif (digit_ctrl = 1) then
                            case change is
                                when 0 =>
                                    segments <= "10000001"; -- 0
                                when 1 =>
                                    segments <= "11001111"; -- 1
                                when 2 =>
                                    segments <= "10010010"; -- 2
                                when 3 =>
                                    segments <= "10000110"; -- 3
                                when 4 =>
                                    segments <= "11001100"; -- 4
                                when 5 =>
                                    segments <= "10100100"; -- 5
                                when 6 =>
                                    segments <= "10100000"; -- 6
                                when 7 =>
                                    segments <= "11001111"; -- 7
                                when 8 =>
                                    segments <= "10000000"; -- 8
                                when 9 =>
                                    segments <= "10000100"; -- 9
                                when others =>
                                    segments <= "11111111"; -- Should not occur, but will be off
                            end case;
                        elsif (digit_ctrl = 2) then
                            segments <= "10000001"; -- 0
                        elsif (digit_ctrl = 3) then
                            segments <= "10110000"; -- E
                        elsif (digit_ctrl = 4) then
                            segments <= "11111111"; -- <off>
                        elsif (digit_ctrl = 5) then
                            segments <= "11111111"; -- <off>
                        elsif (digit_ctrl = 6) then
                            segments <= "11111111"; -- <off>
                        elsif (digit_ctrl = 7) then
                            segments <= "11111111"; -- <off>
                        end if;
                    end if;
                when others =>
                    segments <= "11111111";
            end case;
        end if;
    end process;
    
end Behavioral;