library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CONTADOR is
    Port(
        clk: in std_logic;
        reset: in std_logic;
        coin: in std_logic_vector(3 downto 0);
        option: in std_logic;
        price: in natural range 0 to 20;
        reassemble: in std_logic;
        count: out unsigned(4 downto 0); -- Money count
        change: out natural range 0 to 10 -- Money change
    );
end CONTADOR;

architecture Behavioral of CONTADOR is
    -- SIGNAL DECLARATION
    -- Using count_s to read the accumulated value
    signal count_s: unsigned(4 downto 0) := "00000";
begin

    -- Process to sum the coins
    coin_accumulation: process(clk, reset)
        variable total: unsigned(4 downto 0) := "00000";
    begin
        if (reset = '0') then
            total := "00000";
        elsif (option = '0') then
            total := "00000";
        elsif rising_edge(clk) then
            if coin(0) = '1' then
                total := total + "00001"; -- Coin of value 1
            elsif coin(1) = '1' then
                total := total + "00010"; -- Coin of value 2
            elsif coin(2) = '1' then
                total := total + "00101"; -- Coin of value 5
            elsif coin(3) = '1' then
                total := total + "01010"; -- Coin of value 10
            end if;
        end if;
        count_s <= total;
    end process;

    -- Process to calculate the change
    calculate_change: process(reset, clk, reassemble)
        variable count_s_N: natural range 0 to 30;
        variable change_amt: natural range 0 to 10 := 0;
    begin
        count_s_N := to_integer(count_s);
        if reset = '0' then
            change_amt := 0;
        elsif count_s_N > price then
            change_amt := count_s_N - price; -- Calculate change if price is exceeded
        elsif reassemble = '0' and change_amt /= 0 then
            change_amt := change_amt; -- Maintain change if reassemble is active
        else
            change_amt := 0; -- Reset change to 0
        end if;
        change <= change_amt;
    end process;

    -- PORT ASSIGNMENT
    count <= count_s;

end Behavioral;