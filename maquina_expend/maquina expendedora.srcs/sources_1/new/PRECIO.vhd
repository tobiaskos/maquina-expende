----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.12.2022 18:36:31
-- Design Name: 
-- Module Name: FSM_PRICE - Behavioral
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

entity Precio is
    Port(
        -- INPUTS
        clk: in std_logic; -- clock
        reset: in std_logic; -- Asynchronous reset
        coin: in std_logic_vector(3 downto 0); -- Coins input
        option: in std_logic; -- 1 if any product is selected
        price: in natural range 0 to 20; -- Drink price
        count: in unsigned(4 downto 0); -- Money count
        reassemble: in std_logic; -- Manual restart
        -- OUTPUTS
        confirmed_sale: out std_logic -- 1 if an item is sold
    );
end entity Precio;

architecture Behavioral of Precio is
    -- DECLARATION OF SIGNALS
    -- Define a state for each combination of coins
    type COUNT_STATE is (S0, S1, S2, S3, S4, S5, 
                         S6, S7, S8, S9, S10, S11, 
                         S12, S13, S14, S15, S16, 
                         S17, S18, S19); -- S0: rest state
                                         -- Each state represents a combination of money
                                         -- S19 represents the assured sale state 
                                         -- (reached by either exceeding the price or paying the exact amount) 
    signal present_state: COUNT_STATE := S0;
    signal next_state: COUNT_STATE;             
    -- Use confirmed_sale_s to assign within the process (next_state_decoder)
    signal confirmed_sale_s: std_logic;
                                        
begin
    
    state_register: process(clk, reset)
    begin
        if reset = '0' then
            present_state <= S0;
        elsif rising_edge(clk) then
            present_state <= next_state;
        end if;
    end process;

    -- Define the conditions for each state's transition
    -- Not complex but extensive
    -- The states where the sale is made are: S10, S12, S15, S18, and S19 
    -- (and all intermediates if the counter exceeds the price)
    -- A maximum of 2.7 can be entered, but from 1.9 we consider everything the same
    -- For these cases, the rest is calculated by the COUNTER entity and stored in change
    next_state_decoder: process(clk, present_state, coin)
    variable count_N: natural range 0 to 30;
    begin
        count_N := to_integer(count);   
        -- Coins will only be accepted if a product is selected
        -- After detecting a sale, coin insertion is disabled as option=0 (FSM_SELECTION.vhd)  
        if option = '1' then
            next_state <= present_state;
            case present_state is
                when S0 =>
                    if coin(0) = '1' then
                        next_state <= S1;
                    elsif coin(1) = '1' then
                        next_state <= S2;
                    elsif coin(2) = '1' then
                        next_state <= S5;
                    elsif coin(3) = '1' then
                        next_state <= S10;
                    end if;
                  
                when S1 =>
                    if coin(0) = '1' then
                        next_state <= S2;
                    elsif coin(1) = '1' then
                        next_state <= S3;
                    elsif coin(2) = '1' then
                        next_state <= S6;
                    elsif coin(3) = '1' then
                        next_state <= S11;
                    end if;
                                  
                when S2 =>
                    if coin(0) = '1' then
                        next_state <= S3;
                    elsif coin(1) = '1' then
                        next_state <= S5;
                    elsif coin(2) = '1' then
                        next_state <= S7;
                    elsif coin(3) = '1' then
                        next_state <= S12;
                    end if;
                                  
                when S3 =>
                    if coin(0) = '1' then
                        next_state <= S4;
                    elsif coin(1) = '1' then
                        next_state <= S6;
                    elsif coin(2) = '1' then
                        next_state <= S8;
                    elsif coin(3) = '1' then
                        next_state <= S13;
                    end if;
                                  
                when S4 =>
                    if coin(0) = '1' then
                        next_state <= S5;
                    elsif coin(1) = '1' then
                        next_state <= S6;
                    elsif coin(2) = '1' then
                        next_state <= S9;
                    elsif coin(3) = '1' then
                        next_state <= S14;
                    end if;
                                  
                when S5 =>
                    if coin(0) = '1' then
                        next_state <= S6;
                    elsif coin(1) = '1' then
                        next_state <= S7;
                    elsif coin(2) = '1' then
                        next_state <= S10;
                    elsif coin(3) = '1' then
                        next_state <= S15;
                    end if;
                                  
                when S6 =>
                    if coin(0) = '1' then
                        next_state <= S7;
                    elsif coin(1) = '1' then
                        next_state <= S8;
                    elsif coin(2) = '1' then
                        next_state <= S11;
                    elsif coin(3) = '1' then
                        next_state <= S16;
                    end if;
                                  
                when S7 =>
                    if coin(0) = '1' then
                        next_state <= S8;
                    elsif coin(1) = '1' then
                        next_state <= S9;
                    elsif coin(2) = '1' then
                        next_state <= S12;
                    elsif coin(3) = '1' then
                        next_state <= S17;
                    end if;
                                  
                when S8 =>
                    if coin(0) = '1' then
                        next_state <= S9;
                    elsif coin(1) = '1' then
                        next_state <= S10;
                    elsif coin(2) = '1' then
                        next_state <= S13;
                    elsif coin(3) = '1' then
                        next_state <= S18;
                    end if;
                                  
                when S9 =>
                    if coin(0) = '1' then
                        next_state <= S10;
                    elsif coin(1) = '1' then
                        next_state <= S11;
                    elsif coin(2) = '1' then
                        next_state <= S16;
                    elsif coin(3) = '1' then
                        next_state <= S19;
                    end if;
                                  
                when S10 =>
                    if price = count_N then
                        next_state <= S19;
                    else
                        if coin(0) = '1' then
                            next_state <= S11;
                        elsif coin(1) = '1' then
                            next_state <= S12;
                        elsif coin(2) = '1' then
                            next_state <= S15;
                        elsif coin(3) = '1' then
                            next_state <= S19;
                        end if;
                    end if;
                    
                when S11 =>
                    if price < count_N then
                        next_state <= S19;            
                    else
                        if coin(0) = '1' then
                            next_state <= S12;
                        elsif coin(1) = '1' then
                            next_state <= S13;
                        elsif coin(2) = '1' then
                            next_state <= S16;
                        elsif coin(3) = '1' then
                            next_state <= S19;
                        end if;
                    end if;      
                                  
                when S12 =>
                    if price <= count_N then
                        next_state <= S19;  
                    else
                        if coin(0) = '1' then
                            next_state <= S13;
                        elsif coin(1) = '1' then
                            next_state <= S14;
                        elsif coin(2) = '1' then
                            next_state <= S17;
                        elsif coin(3) = '1' then
                            next_state <= S19;
                        end if;
                    end if;
                                  
                when S13 =>
                    if price < count_N then
                        next_state <= S19;
                    else
                        if coin(0) = '1' then
                            next_state <= S14;
                        elsif coin(1) = '1' then
                            next_state <= S15;
                        elsif coin(2) = '1' then
                            next_state <= S18;
                        elsif coin(3) = '1' then
                            next_state <= S19;
                        end if;
                    end if;
                                  
                when S14 =>
                    if price < count_N then
                        next_state <= S19;          
                    else
                        if coin(0) = '1' then
                            next_state <= S15;
                        elsif coin(1) = '1' then
                            next_state <= S16;
                        elsif coin(2) = '1' then
                            next_state <= S19;
                        elsif coin(3) = '1' then
                            next_state <= S19;
                        end if;
                    end if;
                                  
                when S15 =>
                    if price <= count_N then
                        next_state <= S19; 
                    else
                        if coin(0) = '1' then
                            next_state <= S16;
                        elsif coin(1) = '1' then
                            next_state <= S17;
                        elsif coin(2) = '1' then
                            next_state <= S19;
                        elsif coin(3) = '1' then
                            next_state <= S19;
                        end if;
                    end if;
                                  
                when S16 =>
                    if price < count_N then
                        next_state <= S19;                   
                    else
                        if coin(0) = '1' then
                            next_state <= S17;
                        elsif coin(1) = '1' then
                            next_state <= S18;
                        elsif coin(2) = '1' then
                            next_state <= S19;
                        elsif coin(3) = '1' then
                            next_state <= S19;
                        end if;
                    end if;
                                  
                when S17 =>
                    if price < count_N then
                        next_state <= S19;
                    else
                        if coin(0) = '1' then
                            next_state <= S18;
                        elsif coin(1) = '1' then
                            next_state <= S19;
                        elsif coin(2) = '1' then
                            next_state <= S19;
                        elsif coin(3) = '1' then
                            next_state <= S19;
                        end if;
                    end if;
                                  
                when S18 =>
                    next_state <= S19;  
                                  
                when S19 =>
                    next_state <= S0;                                
                
                when others =>
                    next_state <= S0;
            end case;            
        end if;
    end process;
    
    output_decoder: process(present_state, reassemble)
    variable venta: std_logic := '0';
    begin
        if reset = '0' then
            confirmed_sale_s <= '0'; 
            venta := '0';                
        elsif present_state = S19 then
            confirmed_sale_s <= '1';
            venta := '1';
        elsif venta = '1' and reassemble = '0' then
            confirmed_sale_s <= '1';       
        else
            confirmed_sale_s <= '0';
            venta := '0';
        end if;
    end process;

    -- PORT ASSIGNMENT
    confirmed_sale <= confirmed_sale_s;

end architecture Behavioral;