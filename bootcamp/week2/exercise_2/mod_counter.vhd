library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mod_counter is
    port (
        clk : in std_logic;
        reset : in std_logic;
        enable : in std_logic;
        count : out std_logic_vector(3 downto 0);
        tick : out std_logic
    );
end mod_counter;

architecture rtl of mod_counter is 
    
    signal count_int : std_logic_vector(3 downto 0) := (others => '0');
    signal tick_int : std_logic := '0';

begin
    process(clk, reset)
    begin
        if reset = '1' then
            count_int <= (others => '0');
            tick_int <= '0';
        elsif rising_edge(clk) then
            if enable = '1' and count_int /= x"9" then
                count_int <= std_logic_vector(unsigned(count_int) + 1);
				tick_int <= '0';
            else
                count_int <= (others => '0');
                tick_int <= '1';
            end if;
        
        end if;
    
    end process;

    count <= count_int;
    tick <= tick_int;

end rtl;
