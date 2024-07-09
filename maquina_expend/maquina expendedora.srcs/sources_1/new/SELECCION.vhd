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

entity FSM_SELECTION is
    Port(
        -- INPUTS
        clk: in std_logic; -- clk
        reset: in std_logic; -- Asynchronous reset
        sw: in std_logic_vector(3 downto 0); -- switch input: 0=J15 , 1=L16 , 2=M13  , 3=T18
        confirmed_sale: in std_logic; -- 1 if an item is sold ("external reset")
        -- OUTPUTS
        LED: out std_logic_vector(3 downto 0); -- Shows the selection
        option: out std_logic; -- 1 if any product is selected 
        price: out natural range 0 to 20 -- Drink price 
    );
end entity FSM_SELECTION;

architecture Behavioral of FSM_SELECTION is

--DECLARACION DE SE ALES
    -- definimos las bebidas que disponemos
    type BEBIDA is (S0, agua, fanta, nestea, redbull); -- S0 estado de reposo
    -- creamos las se ales para la maquina de estados
    signal present_state: BEBIDA := S0;
    signal next_state: BEBIDA;

begin

    state_register: process (clk, reset)
    begin
        if (reset = '0') then
            present_state <= S0;
        elsif (rising_edge(clk)) then
            present_state <= next_state;
        end if;
    end process;

    next_state_decoder: process(present_state, sw, confirmed_sale)
    begin
        next_state <= present_state;
        -- Tras la venta de una bebida FSM_PRICE envia la informacion
        -- Se necesita un rearme manual para desactivar confirmed_sale
        if (confirmed_sale = '1') then            
            -- S0=1 -> option=0 (FSM_SELECTION.vdh)-> count="00000" (COUNTER.vhd)
            -- De esta forma se realiza una limpieza de las variables
            next_state <= S0;
        else
            case present_state is
                when S0 => 
                    if (sw(0) = '1') then
                        next_state <= agua;
                    elsif (sw(1) ='1') then
                        next_state <= fanta;
                    elsif (sw(2) ='1') then
                        next_state <= nestea;
                    elsif (sw(3) ='1') then
                        next_state <= redbull;
                    end if;
                when agua | fanta | nestea | redbull=>
                    if (sw = "0000") then
                        next_state <= S0;
                    end if;
                when others =>
                    next_state <= S0;                
            end case;
        end if;
                
    end process;
    
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
            when fanta =>
                option <= '1';
                price <= 12;
                LED(1) <= '1';
            when nestea =>
                option <= '1';
                price <= 15;
                LED(2) <= '1';
            when redbull =>
                option <= '1';
                price <= 18;
                LED(3) <= '1';
            when others =>
                option <= '0';
                price <= 0;
                LED <= "0000";
        end case;
    end process;

end Behavioral;
