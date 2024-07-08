----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.12.2022 11:17:21
-- Design Name: 
-- Module Name: SYNCHRNZR - Behavioral
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

entity SYNCHRNZR is
    Port (
        clk: in std_logic; -- clcok
        reset: in std_logic; -- Asynchronous reset
        async_in: in std_logic_vector(3 downto 0); -- Asynchronous input
        sync_out: out std_logic_vector(3 downto 0) -- Synchronous output
    );
end SYNCHRNZR;


architecture Behavioral of SYNCHRNZR is
    -- DECLARACION DE SE ALES
    type matrix_sreg is array(3 downto 0) of std_logic_vector(1 downto 0);
    signal sreg: matrix_sreg;
    
begin
    process (reset,clk)
    begin
        if (reset='0') then
            for i in 0 to 3 loop
                sync_out(i) <= '0';
                sreg(i) <="00";
            end loop;
        elsif rising_edge(clk) then
            for i in 0 to 3 loop
                sync_out(i) <= sreg(i)(1);
                sreg(i) <= sreg(i)(0) & async_in(i);
            end loop;
        end if;
    end process;
end  architecture Behavioral;
