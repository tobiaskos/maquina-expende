library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DISPLAY_CH_tb is
end DISPLAY_CH_tb;

architecture TB of DISPLAY_CH_tb is
    signal clk_tb     : std_logic := '0';
    signal reset_tb   : std_logic := '0';
    signal option_tb  : std_logic_vector(2 downto 0) := "000";
    signal reassemble_tb : std_logic := '0';
    signal count_tb   : std_logic_vector(6 downto 0) := "0000000";
    signal ok_start_disp_change_tb: std_logic:='0';
    signal digsel_tb  : std_logic_vector(7 downto 0);
    signal segment_tb : std_logic_vector(6 downto 0);
    signal num_ud_tb  : std_logic_vector(3 downto 0);
    signal num_dec_tb : std_logic_vector(3 downto 0);
    signal DP_tb      : std_logic;

    constant clk_period : time := 10 ns; -- Puedes ajustar esto según la velocidad deseada.

    -- Estimulación de la entidad DISPLAY_CH
    component DISPLAY_CH
        Port (
            clk        : in STD_LOGIC;
            reset      : in STD_LOGIC;
            option     : in STD_LOGIC_VECTOR(2 downto 0);
            reassemble : in STD_LOGIC;
            count      : in STD_LOGIC_VECTOR(6 downto 0);
            ok_start_disp_change: in std_logic;
            digsel     : out STD_LOGIC_VECTOR(7 downto 0);
            segment    : out STD_LOGIC_VECTOR(6 downto 0);
            num_ud     : out std_logic_vector(3 downto 0);
            num_dec    : out std_logic_vector(3 downto 0);
            DP         : out std_logic
        );
    end component;

    -- Estímulo
    signal stimulus_done : boolean := false;

begin
    -- Instanciación de la entidad DISPLAY_CH
    UUT : DISPLAY_CH
        port map (
            clk        => clk_tb,
            reset      => reset_tb,
            option     => option_tb,
            reassemble => reassemble_tb,
            count      => count_tb,
            ok_start_disp_change=>ok_start_disp_change_tb,
            digsel     => digsel_tb,
            segment    => segment_tb,
            num_ud     => num_ud_tb,
            num_dec    => num_dec_tb,
            DP         => DP_tb
        );

    -- Proceso de generación de reloj
    clk_process: process
    begin
        while not stimulus_done loop
            clk_tb <= '0';
            wait for clk_period / 2;
            clk_tb <= '1';
            wait for clk_period / 2;
        end loop;
  
        wait;
    end process;
process
begin
      count_tb<="0101101"; 
     -- count_tb<="0010100";
      option_tb<="100";
      ok_start_disp_change_tb<='0';
      wait for 300 ns;
      ok_start_disp_change_tb<='1';
      --option_tb<="010";
     -- wait for 300ns;
     -- option_tb<="001";
     -- wait for 300 ns;
      wait;      
end process;
      
    -- Proceso de estímulo
    stimulus_process: process
    begin
        -- Puedes ajustar aquí tus señales de estímulo según sea necesario
        --reset_tb <= '1';
        wait for 50 ns;
       reset_tb <= '0';
       wait for 50ns;
      -- reset_tb <= '1';
       wait for 500 ns;
       reset_tb <= '0';
       wait for 50ns;
      -- reset_tb <= '1';
        wait for 1000 ns;
        stimulus_done <= true;
        wait;
    end process;

end TB;