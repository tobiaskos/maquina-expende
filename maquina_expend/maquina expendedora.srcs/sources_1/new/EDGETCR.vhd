----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.12.2022 12:57:35
-- Design Name: 
-- Module Name: EDGEDTCtR - Behavioral
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

entity EDGEDTCTR is
    Port(
        clk: in std_logic; -- clock
        reset:in std_logic; -- Asynchronous reset
        sync_in: in std_logic_vector(3 downto 0); -- Input from DEBOUNCER
        edge: out std_logic_vector(3 downto 0)
    );
end EDGEDTCtR;

architecture Behavioral of EDGEDTCTR is

-- DECLARACION DE SE ALES
    type matrix_sreg is array(3 downto 0) of std_logic_vector(2 downto 0);
    signal sreg : matrix_sreg;
    signal edge_s: std_logic_vector(3 downto 0):= "0000";
    
begin
    -- DETECCION DE FLANCO
    process (reset,clk)
    begin
        if (reset = '0') then
            for i in 0 to 3 loop
                sreg(i) <= "000";
            end loop;
        elsif rising_edge(clk) then
            for i in 0 to 3 loop
                sreg(i) <= sreg(i)(1 downto 0) & sync_in(i);
            end loop;
        end if;
    end process;
    
    -- ACTUALIZACION DEL VALOR DE EDGE_S
    process (reset, sreg)
    begin
        if(reset = '0') then
            edge_s<= "0000";
        else
            for i in 0 to 3 loop
                if(sreg(i) = "100") then
                    edge_s(i) <= '1';
                else
                    edge_s(i) <= '0';
                end if;
            end loop; 
        end if;
    end process;
    
-- ASIGNACION DE LA SE AL AL PUERTO
    edge <= edge_s;
end Behavioral;
