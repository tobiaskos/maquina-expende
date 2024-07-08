----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.07.2024 18:08:29
-- Design Name: 
-- Module Name: TOP - Behavioral
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

entity TOP is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           coin : in STD_LOGIC;
           sw : in STD_LOGIC;
           reassemble : in STD_LOGIC;
           led : out STD_LOGIC;
           digsel : out STD_LOGIC;
           segmentss : out STD_LOGIC);
end TOP;

architecture Behavioral of TOP is

begin


end Behavioral;
