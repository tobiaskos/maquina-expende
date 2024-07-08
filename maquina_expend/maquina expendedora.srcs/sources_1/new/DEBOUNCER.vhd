----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.12.2022 12:01:04
-- Design Name: 
-- Module Name: DEBOUNCER - Behavioral
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
--use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DEBOUNCER is
    generic(
        -- Ancho del vector de conteo
        WIDTH : positive:= 9
    );
    port (
        clk	: in std_logic;  -- clock
        btn_in	: in std_logic_vector(3 downto 0); -- Synhronous input from SYNCHRNZR
        btn_out	: out std_logic_vector(3 downto 0) -- Stable value output
    );
end entity DEBOUNCER;

architecture Behavioral of DEBOUNCER is

-- DECLARACION E INICIALIZACION DE SE ALES
    -- btn_prev sirve para comporbar que la se al sea estable
    signal btn_prev: std_logic_vector(3 downto 0);
    -- counter almacena los ciclos en los que la se al no ha cambiado de valor
    type matrix_counter is array (3 downto 0) of unsigned(WIDTH downto 0);
    signal counter    : matrix_counter := ( (others => '0') ,
                                            (others => '0') ,
                                            (others => '0') ,
                                            (others => '0') );

begin
    process(clk)
    begin
        if (clk'event and clk='1') then
            for i in 0 to 3 loop
                if (btn_prev(i) xor btn_in(i)) = '1' then
                    counter(i) <= (others => '0');
                    btn_prev(i) <= btn_in(i);
                elsif (counter(i)(WIDTH) = '0') then
                    counter(i) <= counter(i) + 1;
                else
                    btn_out(i) <= btn_prev(i);
                end if;
            end loop;
        end if;
    end process;
end architecture Behavioral;
