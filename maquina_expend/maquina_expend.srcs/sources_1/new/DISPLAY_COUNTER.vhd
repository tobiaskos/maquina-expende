----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2023 17:22:58
-- Design Name: 
-- Module Name: DISPLAY_COUNTER - Behavioral
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
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DISPLAY_COUNTER is
Port ( clk : in STD_LOGIC;
       coin_in : in std_logic_vector(3 downto 0);
       reset : in STD_LOGIC;
       ok_in : in std_logic;
       digsel : out STD_LOGIC_VECTOR (7 downto 0);
       segment_out : out STD_LOGIC_VECTOR (6 downto 0);
       count : out STD_LOGIC_VECTOR (6 downto 0); 
       ok_out : out std_logic;
       DP : out std_logic);     
end DISPLAY_COUNTER;
architecture Behavioral of DISPLAY_COUNTER is
        component COUNTER is
        Port ( reset : in STD_LOGIC;
               CLK : in STD_LOGIC;
               COIN : in STD_LOGIC_VECTOR (3 downto 0);
               OK : in STD_LOGIC;
               count : out STD_LOGIC_VECTOR (6 downto 0);
               ok_cuenta : out std_logic
         );
    end component;
    component decoder is
        Port ( 
               code : IN std_logic_vector(3 DOWNTO 0);
               segment : OUT std_logic_vector(6 DOWNTO 0)
         );
    end component;
    component SYNCHRNZR is
        Port ( 
                CLK : in STD_LOGIC;
                ASYNC_IN : in STD_LOGIC;
                SYNC_OUT : out STD_LOGIC
         );
    end component;
    component edgedtctr is
        Port ( 
                CLK : in STD_LOGIC;
                SYNC_IN : in STD_LOGIC;
                EDGE : out STD_LOGIC
         );
    end component;
    component Debouncer is
        Port ( 
                CLK : in STD_LOGIC;
                btn_in : in STD_LOGIC_VECTOR(3 downto 0);
                COIN_OUT : out STD_LOGIC_VECTOR(3 downto 0)
         );
    end component;
       signal ok_aux: std_logic := '0';
       signal reset_aux: std_logic;
       signal digit_cycle: std_logic:= '0';
       signal counter_1ms: natural range 0 to 99999 := 0;
       signal number_int: integer:=0;
       signal number_unidades: std_logic_vector(3 downto 0);
       signal number_decenas: std_logic_vector(3 downto 0);
       signal number_vector: std_logic_vector(6 downto 0);
       signal decoder_in: std_logic_vector(3 downto 0);
       signal clk_aux: std_logic;
       signal sync_aux_10_cent: std_logic;
       signal sync_aux_20_cent: std_logic;
       signal sync_aux_50_cent: std_logic;
       signal sync_aux_100_cent: std_logic;
       signal async_aux_10_cent: std_logic;
       signal async_aux_20_cent: std_logic;
       signal async_aux_50_cent: std_logic;
       signal async_aux_100_cent: std_logic; 
       signal coin_out_10_cent : std_logic;
       signal coin_out_20_cent : std_logic;
       signal coin_out_50_cent : std_logic;
       signal coin_out_100_cent : std_logic;
       signal digsel_aux: std_logic_vector(7 downto 0):=(others=>'0');
       signal coin_in_aux: std_logic_vector(3 downto 0);
       signal coin_in_10_cent : std_logic;
       signal coin_in_20_cent : std_logic;
       signal coin_in_50_cent : std_logic;
       signal coin_in_100_cent : std_logic;
begin 
     inst_SYNCHRNZR_10cent: synchrnzr  port map(
        Clk=>clk_aux,
        async_in=>coin_in_10_cent,
        sync_out=>sync_aux_10_cent
    );
        inst_Edgectr_10cent: edgedtctr  port map(
        clk=>clk_aux,
        sync_in=>sync_aux_10_cent,
        edge=>coin_out_10_cent
    );
    inst_SYNCHRNZR_20cent: synchrnzr  port map(
        Clk=>clk_aux,
        async_in=>coin_in_20_cent,
        sync_out=>sync_aux_20_cent
    );
    inst_Edgectr_20cent: edgedtctr  port map(
       clk=>clk_aux,
       sync_in=>sync_aux_20_cent,
        edge=>coin_out_20_cent
    );
    inst_SYNCHRNZR_50cent: synchrnzr  port map(
        Clk=>clk_aux,
        async_in=>coin_in_50_cent,
        sync_out=>sync_aux_50_cent
    );
    inst_Edgectr_50cent: edgedtctr  port map(
        clk=>clk_aux,
        sync_in=>sync_aux_50_cent,
        edge=>coin_out_50_cent
    );
    inst_SYNCHRNZR_100cent: synchrnzr  port map(
        Clk=>clk_aux,
        async_in=>coin_in_100_cent,
        sync_out=>sync_aux_100_cent
    );
    inst_Edgectr_100cent: edgedtctr  port map(
        clk=>clk_aux,
        sync_in=>sync_aux_100_cent,
        edge=>coin_out_100_cent
    );
    inst_COUNTER: COUNTER  port map(
    reset=> reset_aux,
    clk =>clk_aux,
    Coin=>coin_in_aux,
    ok=>ok_in,
    count =>number_vector,
    ok_cuenta=>ok_aux
    );
   
    inst_DECODER: Decoder  port map(
        code=>decoder_in,
        segment=>segment_out
    );
        process(coin_in)
     begin
     case coin_in is
    when "0001" =>
        coin_in_10_cent <= '1';
        coin_in_20_cent <= '0';
        coin_in_50_cent <= '0';
        coin_in_100_cent <= '0';
    when "0010" =>
        coin_in_10_cent <= '0';
        coin_in_20_cent <= '1';
        coin_in_50_cent <= '0';
        coin_in_100_cent <= '0';
    when "0100" =>
        coin_in_10_cent <= '0';
        coin_in_20_cent <= '0';
        coin_in_50_cent <= '1';
        coin_in_100_cent <= '0';
    when "1000" =>
        coin_in_10_cent <= '0';
        coin_in_20_cent <= '0';
        coin_in_50_cent <= '0';
        coin_in_100_cent <= '1';
     when others =>
        coin_in_10_cent <= '0';
        coin_in_20_cent <= '0';
        coin_in_50_cent <= '0';
        coin_in_100_cent <= '0';
   end case;
        end process;
      process(coin_out_10_cent,coin_out_20_cent,coin_out_50_cent,coin_out_100_cent)
      begin
      if(coin_out_10_cent = '1') then
        coin_in_aux<="0001";
     elsif(coin_out_20_cent = '1') then
        coin_in_aux<="0010";
     elsif(coin_out_50_cent = '1') then
        coin_in_aux<="0100";
    elsif(coin_out_100_cent = '1') then
        coin_in_aux<="1000";
     else
        coin_in_aux<="0000";
        end if;
       end process; 
    reloj_1ms: process(clk_aux)
 begin
        if (rising_edge(clk_aux)) then
            counter_1ms <= counter_1ms + 1;

         if (counter_1ms >= 99999) then
             counter_1ms <= 0;
             digit_cycle <= not digit_cycle; -- Cambio aquí
         end if;
         end if;
     end process;
     digit_seleccion: process(digit_cycle,number_decenas,number_unidades)
 begin
        case (digit_cycle) is
            when '0' =>
                digsel_aux <= "10111111";
                decoder_in<= number_decenas;
                DP <= '1';
            when '1' =>
                digsel_aux <= "11011111";
                decoder_in<= number_unidades;
                DP<='0';
             when others=>
       end case;
     end process;

      clk_aux <= clk;
      --coin_in_aux<=coin_in;
      ok_out<=ok_aux;
      reset_aux<=reset;
      count <= number_vector;
      number_int <= to_integer(unsigned(number_vector));
      number_unidades <= std_logic_vector(to_unsigned(number_int mod 10, 4));
      number_decenas <= std_logic_vector(to_unsigned(number_int / 10, 4));
      digsel<=digsel_aux;
end Behavioral;
