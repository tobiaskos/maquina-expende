----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2023 17:37:35
-- Design Name: 
-- Module Name: DISPLAY_CH - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DISPLAY_CH is
Port ( clk : in STD_LOGIC;
       reset : in STD_LOGIC;
       --change: in STD_LOGIC_VECTOR (3 downto 0);
       option: in STD_LOGIC_VECTOR (2 downto 0);
       reassemble: in STD_LOGIC;
       count: in STD_LOGIC_VECTOR (6 downto 0);
       ok_start_disp_change: in std_logic;
       digsel : out STD_LOGIC_VECTOR (7 downto 0);
       segment : out STD_LOGIC_VECTOR (6 downto 0);
       num_ud:out std_logic_vector(3 downto 0);
       num_dec:out std_logic_vector(3 downto 0);
       DP : out std_logic);
end DISPLAY_CH;

architecture Behavioral of DISPLAY_CH is
signal segment_aux: std_logic_vector(6 downto 0);
-- DECLARACION
    component SYNCHRONIZER is
    port (
        CLK : in std_logic;
        ASYNC_IN : in std_logic;
        SYNC_OUT : out std_logic
        );
    end component;
    
    component EDGEDETECTOR is
    port (
        CLK : in std_logic;
        SYNC_IN : in std_logic;
        EDGE : out std_logic
        );
    end component;

    component CHANGE is
    port (
        reset : in STD_LOGIC;
        clk : in STD_LOGIC;
        option: in STD_LOGIC_vECTOR(2 downto 0); --100 agua; 010 coca; 001 cafe
        reassemble: in STD_LOGIC;
        count : in STD_LOGIC_VECTOR (6 downto 0);
        ok_change: in std_logic;        
        change: out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component;
    component decoder is
        Port ( 
               code : IN std_logic_vector(3 DOWNTO 0);
               segment : OUT std_logic_vector(6 DOWNTO 0)
        );
    end component;
    
    --SEÑALES
    signal change_signal: STD_LOGIC_VECTOR (6 downto 0);
    signal digit_cycle: std_logic:='0';
    signal counter_1ms: natural range 0 to 100000 := 0;
    signal integer_change: integer:=0;
    signal number_unidades: std_logic_vector(3 downto 0);
    signal number_decenas: std_logic_vector(3 downto 0);
    signal clk_aux: std_logic;
    signal decoder_in: std_logic_vector(3 downto 0);    
    --cambios:
    signal reset_async: std_logic;
    signal reset_sync: std_logic;
    signal reassemble_async: std_logic;
    signal reassemble_sync: std_logic;
    signal reset_aux: std_logic;
    signal reassemble_aux: std_logic;

begin
--INSTANCIACIÓN

    inst_SYNCHRONIZER_reset: SYNCHRONIZER port map(
        CLK=>clk_aux,
        ASYNC_IN => reset_async,
        SYNC_OUT => reset_sync
        );
    inst_SYNCHRONIZER_reassemble: SYNCHRONIZER port map(
        CLK=>clk_aux,
        ASYNC_IN => reassemble_async,
        SYNC_OUT => reassemble_sync
        );
    
    inst_EDGEDETECTOR_reset: EDGEDETECTOR port map(
        CLK =>clk_aux,
        SYNC_IN => reset_sync,
        EDGE => reset_aux
        );
     inst_EDGEDETECTOR_reassemble: EDGEDETECTOR port map(
        CLK =>clk_aux,
        SYNC_IN => reassemble_sync,
        EDGE => reassemble_aux
        );
        
    inst_CHANGE: CHANGE port map(
    reset=> reset_aux,
    clk =>clk_aux,
    option=>option,
    ok_change=>ok_start_disp_change,
    reassemble=> reassemble_aux,
    count =>count,
    change=>change_signal
    );
    
    inst_DECODER: Decoder  port map(
        code=>decoder_in,
        segment=>segment_aux
    );
    
--IMPRIMIR EL CAMBIO:
--crear un reloj auxiliar de 1ms
reloj_1ms: process(clk_aux)
 begin
        if (rising_edge(clk_aux)) then
            counter_1ms <= counter_1ms + 1;
            if (counter_1ms >= 9) then --al décimo flanco de subida cambia
                counter_1ms <= 0;
                digit_cycle <= not digit_cycle;
            end if;
        end if;
     end process;
     
     
     digit_seleccion: process(digit_cycle,ok_start_disp_change) 
     begin
     if(ok_start_disp_change = '1') then
        case (digit_cycle) is
            when '0' =>
                digsel <= "11111011";
                decoder_in<= number_decenas;
                DP <= '1';
            when '1' =>
                digsel <= "11111101";
                decoder_in<= number_unidades;
                DP <= '1';
            when others=>
                DP <= '0';
        end case;
     else 
          digsel <=(others=>'1'); -- todos los digsel desactivados
          --segment_aux<="1111110"; 
          DP <= '0';
          --change_signal<=(others=>'0');
     end if;
     end process;
     
    
     clk_aux <= clk;
     segment<=segment_aux;
     integer_change <= to_integer(unsigned(change_signal));
     number_unidades <= std_logic_vector(to_unsigned(integer_change mod 10, 4));
     number_decenas <= std_logic_vector(to_unsigned(integer_change / 10, 4));
     num_ud<=number_unidades;
     num_dec<=number_decenas;
     
     --cambios:
     reset_async<=reset;
     reassemble_async<=reassemble;

end Behavioral;



