----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.12.2022 10:07:52
-- Design Name: 
-- Module Name: COIN_INPUT - Behavioral
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

entity ENTRADA is
    -- se podria generalizar para mas monedas con generic(WIDTH(...))
    port(
        clk: in std_logic; -- clock
        reset: in std_logic; -- Asynchronous reset
        async_in: in std_logic_vector(3 downto 0); -- Asynchronous coin input
        sync_out: out std_logic_vector(3 downto 0) -- Synchronous coin output
    );
end ENTRADA;

architecture Behavioral of ENTRADA is

-- DECLARACION DE SE ALES
    signal sync_output: std_logic_vector(3 downto 0);
    signal btn_out: std_logic_vector(3 downto 0);
    
-- DECLARACION DE COMPONENTES
    --SYNCHRZNR nos devuelve una se al sincrona 
    component SYNCHRNZR is
        Port (
            clk: in std_logic;
            reset: in std_logic;
            async_in: in std_logic_vector(3 downto 0);
            sync_out: out std_logic_vector(3 downto 0)
        );
    end component SYNCHRNZR;

    --DEBOUNCER nos asegura que no haya rebotes
    component DEBOUNCER is
        Port(
            clk	: in std_logic;
            btn_in	: in std_logic_vector(3 downto 0);
            btn_out	: out std_logic_vector(3 downto 0)
        );
    end component DEBOUNCER;

    -- EDGEDTCTR detecta cuando se produe un flanco de subida
    component EDGEDTCtR is
        Port(
            clk: in std_logic;
            reset:in std_logic;
            sync_in: in std_logic_vector(3 downto 0);
            edge: out std_logic_vector(3 downto 0)
        );
    end component EDGEDTCtR;
    
begin

-- INICIALIZACION DE COMPONENTES
    inst_SYNCHRNZR: SYNCHRNZR port map(
            clk => clk ,
            reset => reset ,
            async_in => async_in ,
            sync_out => sync_output
    );
    
    inst_DEBOUNCER: DEBOUNCER port map(
            clk => clk ,
            btn_in => sync_output ,
            btn_out => btn_out
    );
    
    inst_EDGEDTCTR: EDGEDTCtR port map(
            clk => clk ,
            reset => reset ,
            sync_in => btn_out ,
            edge => sync_out
    );

end architecture Behavioral;
