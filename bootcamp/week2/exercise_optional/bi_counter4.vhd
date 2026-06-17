library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bi_counter4 is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           dir : in STD_LOGIC;
           en : in STD_LOGIC;
           count : out STD_LOGIC_VECTOR (3 downto 0));
end bi_counter4;

architecture rtl of bi_counter4 is
    signal count_int : unsigned(3 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                count_int <= (others => '0');
            elsif en = '1' then
                if dir = '1' then
                    count_int <= count_int + 1;
                else
                    count_int <= count_int - 1;
                end if;
            end if;
        end if;
    end process;

    count <= std_logic_vector(count_int);

end rtl;