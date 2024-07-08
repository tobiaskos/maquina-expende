----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2023 17:22:58
-- Design Name: 
-- Module Name: DISPLAY_OPTION - Behavioral
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

entity DISPLAY_OPTION is
Port (  clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        count: in STD_LOGIC_VECTOR (6 downto 0);
        ok_start_disp_option: in std_logic;
        sw: in STD_LOGIC_VECTOR (2 downto 0);
        digsel : out STD_LOGIC_VECTOR ( 7 downto 0);
        segment : out STD_LOGIC_VECTOR (6 downto 0);
        DP : out std_logic;
        error : out std_logic;
        ok_op: out std_logic);
end DISPLAY_OPTION;

architecture Behavioral of DISPLAY_OPTION is
-- DECLARACION
 component COMPARE is
   Port ( clk : in STD_LOGIC;
          -- price : in STD_LOGIC_VECTOR (6 downto 0);
           count : in STD_LOGIC_VECTOR (6 downto 0);
           reset : in STD_LOGIC;
           ok_compare: in std_logic;
           option: in STD_LOGIC_VECTOR (2 downto 0);
           importe_ok : out STD_LOGIC;
           error_comp : out std_logic);
 end component;              
 
 component decoder is
   Port ( 
               code : IN std_logic_vector(3 DOWNTO 0);
               segment : OUT std_logic_vector(6 DOWNTO 0)
         );
  end component; 
   
  signal clk_aux: std_logic;   
  signal reset_aux: std_logic;
  signal price_aux : std_logic_vector(6 downto 0);
  signal count_aux : std_logic_vector(6 downto 0);
  signal option_aux : std_logic_vector(2 downto 0);
  signal error_aux : std_logic;
  signal importe_ok_aux : std_logic;
  signal counter_1ms: natural range 0 to 99999 := 0;
  signal digit_ctrl: natural range 0 to 5 := 0;
  signal final_ctrl: natural range 0 to 1 := 0;
  signal sw_state: std_logic_vector(2 downto 0) := "000";
  signal digsel_value: std_logic_vector(3 downto 0);
  signal ok_start_aux: std_logic;
        
begin
 inst_COMPARE: COMPARE  port map(
    reset=> reset_aux,
    clk =>clk_aux,
    ok_compare=>ok_start_aux ,
   -- price=>price_aux,
    count=>count_aux,
    option=>option_aux,
    error_comp =>error_aux,
    importe_ok=>importe_ok_aux
    );
reloj_1ms: process(clk)
 begin
     if (rising_edge(clk)) then
        counter_1ms <= counter_1ms + 1;
       
        if (counter_1ms >= 99999) then
             counter_1ms <= 0;
             digit_ctrl <= digit_ctrl + 1;
             if (digit_ctrl > 5)then
                 digit_ctrl <= 0;
             end if;
        end if;
     end if;
 end process;
 
digit_control: process(digit_ctrl,sw,ok_start_disp_option)
begin  
    if(ok_start_disp_option = '1') then
        case (digit_ctrl) is
              when 0 =>
                digsel <= "10111111";
                DP <= '1';
                  case (sw) is 
                     when "100" => segment <= "1001111"; -- Imprime un 1
                     when "010" => segment <= "1001111"; -- Imprime un 1
                     when "001" => segment <= "0000001"; -- Imprime un 0
                     when others => segment <= "1111111";
                      --DP <= '1';
                  end case;                 
              when 1 =>
                digsel <= "11011111";
                DP <= '0';
                  case(sw) is 
                     when "100" => segment <= "0000001"; -- Imprime un 0 
                     when "010" => segment <= "0000000"; -- Imprime un 8
                     when "001" => segment <= "0001111"; -- Imprime un 7
                     when others => segment <= "1111111";
                  end case;    
              when 2 =>
                digsel <= "11110111";
                DP <= '0';
                 case(sw) is 
                     when "100" => segment <= "0001000"; -- Imprime una A 
                     when "010" => segment <= "1001110"; -- Imprime una C
                     when "001" => segment <= "1001110"; -- Imprime una C
                     when others => segment <= "1111111";
                    end case;    
              when 3 =>
                digsel <= "11111011";
                DP <= '0';
                 case(sw) is 
                     when "100" => segment <= "0100000"; -- Imprime una G
                     when "010" => segment <= "0000001"; -- Imprime una O
                     when "001" => segment <= "0001000"; -- Imprime una A 
                     when others => segment <= "1111111";
                   end case;       
              when 4 =>
                digsel <= "11111101";
                DP <= '0';
                 case(sw) is 
                     when "100" => segment <= "1000001"; -- Imprime una U
                     when "010" => segment <= "1001110"; -- Imprime una C
                     when "001" => segment <= "0111000"; -- Imprime una F 
                     when others => segment <= "1111111";        
                 end case;
              when 5 =>
                digsel <= "11111110";         
                DP <= '0';
                case(sw) is 
                     when "100" => segment <= "0001000"; -- Imprime una A
                     when "010" => segment <= "0001000"; -- Imprime una A
                     when "001" => segment <= "0110000"; -- Imprime una E 
                     when others => segment <= "1111111";         
                 end case;
         end case; 
     else
        DP <= '0';
        segment <= "1111110";
        digsel <= "11111111";
       
     end if;     

end process;
    clk_aux<=clk;
    reset_aux<=reset;
    count_aux<=count;
    option_aux <= sw;
    ok_start_aux<= ok_start_disp_option; 
    
    
    ok_op<=importe_ok_aux;  
    error<=error_aux; 
   
   
    
   
end Behavioral;
