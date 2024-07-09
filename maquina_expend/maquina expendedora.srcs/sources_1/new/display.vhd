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

entity FSM_DISPLAY is
    Port(
        --INPUTS
        clk: in std_logic; -- clock
        reset: in std_logic; --Asynchronous reset
        reassemble: in std_logic; -- Manual restart
        count: in unsigned(4 downto 0); -- Money count
        price: in natural range 0 to 20; -- Drink price
        change: in natural range 0 to 10; -- Money chang
        option: in std_logic; -- 1 if any product is selected  
        confirmed_sale: in std_logic; -- 1 if an item is sold
        --OUTPUTS
        segments: out std_logic_vector(7 downto 0); -- Active digit segments
                                                    -- Ver constraints
        digsel: out std_logic_vector(7 downto 0) -- Active digit selection        
                                                 -- Ver constraints
    );              
end entity FSM_DISPLAY;

architecture Behavioral of FSM_DISPLAY is

-- DECLARACION DE SE ALES
    -- definimos un estado por cada pantalla a mostrar
    type DISPLAY_STATE is (S0, S1, S2);-- S0 elegir producto
                                       -- S1 introducir monedas
                                       -- S2 rearme manual
    signal present_state: DISPLAY_STATE := S0;
    signal next_state: DISPLAY_STATE;
                                                   
    -- counter_1ms nos permiten modificar la frecuencia del reloj
    -- tendremos 100[MHz]/(99999+1) = 1[kHz] que sera a la que cambien los digitos
    -- cada digito tardara 1[ms] en cambiar y se volvera a encender dentro de 8[ms]
    -- 8[ms] esta dentro del margen de 1-16[ms] proporcionado en el datasheet
    -- se asegura de esta manera que no hay parpadeo
    signal counter_1ms: natural range 0 to 99999 := 0;
    -- counter_2s permite cambiar la pantalla final cada 2 segundos
    -- tendremos 100[MHz]/(199999999+1) = 0.5[Hz]
    signal counter_2s: natural range 0 to 199999999 := 0;
    -- digit_ctrl nos permite alternar el digito que queremos activo
    signal digit_ctrl: natural range 0 to 7 := 0;
    -- final_ctrl nos permite alterar la pantalla final
    signal final_ctrl: natural range 0 to 1 := 0;
    

begin

    -- Generamos una se al que cambia cada milisegundo (digit_ctrl)
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
    
    -- Generamos una se al que cambia cada milisegundo (digit_ctrl)
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
    
    -- Asociamos los anodos de los diodos a la se al de un 1[ms]
    digit_control: process(digit_ctrl)
    begin
        case (digit_ctrl) is
            when 0 =>
                -- Significa que queremos el primer digito activo (activo a nivel bajo)
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

    -- Control de estado para la maquina de estados
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
    
    -- Establecemos los patrones de los segmentos en funcion del estado
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
                    -- Mostraremos un mensaje CHOSE.SW
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
                        
                    -- No podemos hacer una W pero podemos concatenar 2 U
                    elsif (digit_ctrl = 6) then
                        segments <= "11000001"; -- U
                    elsif (digit_ctrl = 7) then                
                        segments <= "11000001"; -- U
                    end if;
                    
                when S1 =>
                    -- Mostramos el precio a la izquierda y a la derecha las monedas introducidas
                    -- 1.X0E X.X0E                            
                    --  4 DIGITOS DE LA IZQUIERDA
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
                                segments <= "11111111"; -- No se puede dar el caso, pero estaria apagado
                        end case;
                    elsif (digit_ctrl = 2) then
                        segments <= "10000001"; -- 0
                    elsif (digit_ctrl = 3) then
                        segments <= "10110000";-- E
                    
                    --  4 DIGITOS DE LA DERECHA
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
                                segments <= "10001111"; -- 7
                            when 8 =>
                                segments <= "10000000"; -- 8
                            when 9 =>
                                segments <= "10000100"; -- 9
                            when others =>
                                segments <= "11111111"; -- No deberia de darse
                        end case;
                    elsif (digit_ctrl = 6) then
                        segments <= "10000001"; -- 0
                    elsif (digit_ctrl = 7) then
                        segments <= "10110000";-- E
                    end if;
                    
                when S2 =>
                    -- Mostramos el cambio y cambiamos la pantalla cada 2 segundo para indicar el rearme manual
                    if (final_ctrl = 0) then
                        --Mostraremos CHG=0.X0E             
                        if (digit_ctrl = 0) then
                            segments <= "10110001"; -- C
                        elsif (digit_ctrl = 1) then
                            segments <= "11001000"; -- H
                        elsif (digit_ctrl = 2) then
                            segments <= "10100000"; -- 6/G
                        elsif (digit_ctrl = 3) then
                            segments <= "10110111"; -- =
                        elsif (digit_ctrl = 4) then
                            segments <= "00000001"; -- 0.
                        elsif (digit_ctrl = 5) then
                            case (change) is
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
                                    segments <= "10001111"; -- 7
                                when 8 =>
                                    segments <= "10000000"; -- 8
                                when 9 =>
                                    segments <= "10000100"; -- 9
                                when others =>
                                    segments <= "11111111"; -- No puede darse el caso pero estaria apagado
                            end case;             
                        elsif (digit_ctrl = 6) then
                            segments <= "10000001"; -- 0
                        elsif (digit_ctrl = 7) then                
                            segments <= "10110000";-- E
                        end if;
                    elsif (final_ctrl = 1) then
                        -- Mostraremos -ok porque hemos asociado el reseteo a ese interruptor
                        if (digit_ctrl = 0) then
                            segments <= "11111110"; -- -
                        elsif (digit_ctrl = 1) then
                            segments <= "11111111"; -- S/5
                        elsif (digit_ctrl = 2) then
                            segments <= "11111111"; -- U
                        elsif (digit_ctrl = 3) then
                            segments <= "11111111"; -- U.
                        elsif (digit_ctrl = 4) then
                            segments <= "11111111"; -- U
                        elsif (digit_ctrl = 5) then
                            segments <= "11111111"; -- 1                                            
                        elsif (digit_ctrl = 6) then
                            segments <= "11111111"; -- 1
                        elsif (digit_ctrl = 7) then                
                            segments <= "11111111"; -- -
                        end if;
                    end if;                                             
            end case;
        end if;        
    end process;        
        
end Behavioral;
