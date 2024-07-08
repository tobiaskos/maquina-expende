library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL; 
entity Debouncer is
    generic (
        WIDTH : positive := 9
    );
    Port (
        CLK : in STD_LOGIC;
        btn_in : in STD_LOGIC_VECTOR(3 downto 0);
        COIN_OUT : out STD_LOGIC_VECTOR(3 downto 0)
    );
end Debouncer;

architecture Behavioral of Debouncer is
    signal coin_prev : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    type matrix_counter is array(3 downto 0) of unsigned(WIDTH downto 0);
    signal counter : matrix_counter := (
        (others => '0'),
        (others => '0'),
        (others => '0'),
        (others => '0')
    );

begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            for i in 0 to 3 loop
                if (coin_prev(i) xor btn_in(i)) = '1' then
                    counter(i) <= (others => '0');
                    coin_prev(i) <= btn_in(i);
                elsif counter(i)(WIDTH) = '0' then
                    counter(i) <= counter(i) + 1;
                else
                    COIN_OUT(i) <= coin_prev(i);
                end if;
            end loop;
        end if;
    end process;

end Behavioral;