----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.12.2022 10:07:12
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
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TOP is
    Port(
        -- INPUTS
        clk: in std_logic; -- Clock (100 MHz)
        reset: in std_logic; -- Asynchronous Reset Signal. TRUE when reset=0 
        coin: in std_logic_vector(3 downto 0); -- Coin input: 0=10cent , 1=20cent , 2=50cent , 3=1 
                                               -- Modelado con botones (ver Constraints)
        sw: in std_logic_vector(3 downto 0); -- switch input: 0=J15 , 1=L16 , 2=M13  , 3=T18
        reassemble: in std_logic; -- Manual restart
        
        -- OUTPUTS
        segments:out std_logic_vector(7 downto 0); -- Active digit segments
        digsel:out std_logic_vector(7 downto 0); -- Active digit selection
        led:out std_logic_vector(3 downto 0) -- Item selection ligth
    );
end entity TOP;

architecture Behavioral of TOP is

-- DECLARACION DE SE ALES
    -- sync_out guarda la pulsacion de los botones y se pasa a las demas entidades
    signal sync_out: std_logic_vector(3 downto 0);
    -- option nos indica si se ha seleccionado una bebida
    signal option: std_logic;
    -- price contiene el valor de la bebida multiplicado por 10
    signal price: natural range 0 to 20;
    -- count cotiene el valor almacenado al introducir monedas
    signal count: unsigned(4 downto 0);
    -- change contiene valor del cambio
    signal change: natural range 0 to 10;
    -- confirmed_sale nos informa si se ha producico la venta (count > price)
    signal confirmed_sale: std_logic;
    
-- DECLARACION DE COMPONENTES
    -- COIN_INPUT gestiona los botones de introducir moneda
    component ENTRADA is
        port(
            clk: in std_logic;
            reset: in std_logic;
            async_in: in std_logic_vector(3 downto 0);
            sync_out: out std_logic_vector(3 downto 0)
        );
    end component ENTRADA;
    
    -- FSM_SELECTION nos indica cuando hemos escogido una bebida y su precio
    component SELECCION is
        port(
            clk: in std_logic;
            reset: in std_logic;
            sw: in std_logic_vector(3 downto 0);
            confirmed_sale: in std_logic;
            LED: out std_logic_vector(3 downto 0);
            option: out std_logic; 
            price: out natural range 0 to 20
        );
    end component SELECCION;
    
    -- FSM_PRICE nos indica cuando se se ha realizado una venta mediante confirmed_signal
    component PRECIO is
        Port(
            clk: in std_logic;
            reset: in std_logic;
            coin: in std_logic_vector(3 downto 0);
            option: in std_logic;
            price: in natural range 0 to 20;
            count: in unsigned(4 downto 0);
            reassemble: in std_logic;
            confirmed_sale: out std_logic
        );
    end component PRECIO;
    
    -- COUNTER realiza la suma de dinero y nos devuelve el cambio en caso de pasarnos
    component CONTADOR is 
        Port(
            clk: in std_logic;
            reset: in std_logic;
            coin: in std_logic_vector(3 downto 0);
            option: in std_logic;
            price: in natural range 0 to 20;
            reassemble: in std_logic;
            count: out unsigned(4 downto 0);
            change: out natural range 0 to 10
        );
    end component CONTADOR;  
    
    -- FSM_DISPLAY
    component DISPLAY is 
        Port(
            clk: in std_logic;
            reset: in std_logic;
            reassemble: in std_logic;
            count: in unsigned(4 downto 0);
            price: in natural range 0 to 20;
            change: in natural range 0 to 10;
            option: in std_logic;  
            confirmed_sale: in std_logic;
            segments: out std_logic_vector(7 downto 0);                                                      
            digsel: out std_logic_vector(7 downto 0)            
        );    
    end component DISPLAY; 

begin

-- INICIALIZACION DE COMPONENTES
    inst_ENTRADA: ENTRADA port map(
            clk => clk ,
            reset => reset ,
            async_in => coin ,
            sync_out => sync_out
    );

    inst_SELECTION: SELECCION port map(
            clk => clk ,
            reset => reset ,
            sw => sw ,
            confirmed_sale => confirmed_sale ,
            LED => led ,
            option => option ,
            price => price 
    );

    inst_PRECIO: PRECIO port map(
            clk => clk ,
            reset => reset ,
            coin => sync_out ,
            option => option ,
            price => price ,
            count => count ,
            reassemble => reassemble ,
            confirmed_sale => confirmed_sale
    );
    
    inst_CONTADOR: CONTADOR port map(
            clk => clk ,
            reset => reset ,
            coin => sync_out ,
            option => option ,
            price => price ,
            reassemble => reassemble ,
            count => count ,
            change => change  
    );
    
    inst_DISPLAY: DISPLAY port map(
            clk => clk ,
            reset => reset ,
            reassemble => reassemble ,
            count => count ,
            price => price ,
            change => change ,
            option => option , 
            confirmed_sale => confirmed_sale ,
            segments => segments ,                                                     
            digsel => digsel        
    );
end architecture Behavioral;