----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.12.2022 15:05:51
-- Design Name: 
-- Module Name: FSM_SELECTION - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- This module implements a finite state machine (FSM) for a drink selection system.
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

entity seleccion is
    Port(
        -- INPUTS
        clk: in std_logic; -- Clock signal
        reset: in std_logic; -- Asynchronous reset signal
        sw: in std_logic_vector(3 downto 0); -- Switch input: 0=J15, 1=L16, 2=M13, 3=T18
        confirmed_sale: in std_logic; -- 1 if an item is sold ("external reset")
        -- OUTPUTS
        LED: out std_logic_vector(3 downto 0); -- Shows the selection
        option: out std_logic; -- 1 if any product is selected 
        price: out natural range 0 to 20 -- Drink price 
    );
end entity seleccion;

architecture Behavioral of seleccion is

-- SIGNAL DECLARATION
    -- Define available drinks
    type BEBIDA is (S0, agua, fanta, nestea, redbull); -- S0: idle state
    -- Create signals for the state machine
    signal present_state: BEBIDA := S0;
    signal next_state: BEBIDA;

begin

    -- State register process
    state_register: process (clk, reset)
    begin
        if (reset = '0') then
            present_state <= S0;
        elsif (rising_edge(clk)) then
            present_state <= next_state;
        end if;
    end process;

    -- Next state decoder process
    next_state_decoder: process(present_state, sw, confirmed_sale)
    begin
        next_state <= present_state;
        -- After the sale of a drink, PRECIO sends the information
        -- Manual reset is needed to deactivate confirmed_sale
        if (confirmed_sale = '1') then            
            -- S0=1 -> option=0 (SELECCION) -> count="00000" (CONTADOR)
            -- This clears the variables
            next_state <= S0;
        else
            case present_state is
                when S0 => 
                    if (sw(0) = '1') then
                        next_state <= agua;
                    elsif (sw(1) = '1') then
                        next_state <= fanta;
                    elsif (sw(2) = '1') then
                        next_state <= nestea;
                    elsif (sw(3) = '1') then
                        next_state <= redbull;
                    end if;
                when agua | fanta | nestea | redbull =>
                    if (sw = "0000") then
                        next_state <= S0;
                    end if;
                when others =>
                    next_state <= S0;                
            end case;
        end if;                
    end process;
    
    -- Output decoder process
    output_decoder: process(present_state)
    begin        
        case present_state is
            when S0 =>
                option <= '0';
                price <= 0;
                LED <= "0000";
            when agua =>
                option <= '1';
                price <= 10;
                LED(0) <= '1';
                LED(1) <= '0';
                LED(2) <= '0';
                LED(3) <= '0';
            when fanta =>
                option <= '1';
                price <= 12;
                LED(0) <= '0';
                LED(1) <= '1';
                LED(2) <= '0';
                LED(3) <= '0';
            when nestea =>
                option <= '1';
                price <= 15;
                LED(0) <= '0';
                LED(1) <= '0';
                LED(2) <= '1';
                LED(3) <= '0';
            when redbull =>
                option <= '1';
                price <= 18;
                LED(0) <= '0';
                LED(1) <= '0';
                LED(2) <= '0';
                LED(3) <= '1';
            when others =>
                option <= '0';
                price <= 0;
                LED <= "0000";
        end case;
    end process;

end Behavioral;