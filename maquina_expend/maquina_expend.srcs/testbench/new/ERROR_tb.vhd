library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ERROR_TB is
end ERROR_TB;

architecture TB_ARCH of ERROR_TB is

-- Instantiate the ERROR module
  component ERROR
    port (
      error           : in std_logic;
      reset           : in std_logic;
      CLK             : in std_logic;
      digsel          : out std_logic_vector(7 downto 0);
      segment_error   : out std_logic_vector(6 downto 0);
      led: OUT std_logic_vector(15 downto 0)
     -- enciende_led    : out boolean
    );
  end component;
  
  signal error_tb          : std_logic := '0';
  signal reset_tb          : std_logic := '0';
  signal CLK_TB            : std_logic := '0';
  signal led_tb: std_logic_vector(15 downto 0):= (others => '0');
  signal digsel_tb         : std_logic_vector(7 downto 0) := (others => '0');
  signal segment_error_tb  : std_logic_vector(6 downto 0) := (others => '0');
  --signal enciende_led_tb   : boolean := false;

  constant CLOCK_PERIOD    : time := 10 ns; -- Adjust the period as needed  
  
  begin
    ERROR_inst : ERROR
    port map (
      error           => error_tb,
      reset           => reset_tb,
      CLK             => CLK_TB,
      digsel          => digsel_tb,
      segment_error   => segment_error_tb,
      led =>led_tb
      
      --enciende_led    => enciende_led_tb
    );


  process
  begin
    while now < 1000 ms loop
      CLK_TB <= not CLK_TB;
      wait for CLOCK_PERIOD / 2;
    end loop;
    wait;
  end process;


  process
  begin
    error_tb <= '1';
    reset_tb <= '1';
    wait for 20 ns; 
    reset_tb <= '0';
    wait for 20 ns; 
    reset_tb <= '1';
    wait for 20 ns; 
    error_tb <= '0';
    wait for 20 ns;
    error_tb <= '1';
    wait;
 end process;

end architecture;

