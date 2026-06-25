library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram8x8 is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;                     -- synchronous reset
        we       : in  std_logic;                     -- write enable
        addr     : in  std_logic_vector(2 downto 0);  -- 3-bit address (0..7)
        data_in  : in  std_logic_vector(7 downto 0);  -- write data
        data_out : out std_logic_vector(7 downto 0);  -- read data (registered)
        valid    : out std_logic                       -- '1' same cycle data_out is valid
    );
end ram8x8;

architecture rtl of ram8x8 is

    type ram_t is array(0 to 7) of std_logic_vector(7 downto 0);
    signal mem : ram_t;     -- contents NOT cleared on reset

begin

    process(clk)
    begin
        if rising_edge(clk) then

            if rst = '1' then
                -- Clear output registers only; mem is untouched
                data_out <= (others => '0');
                valid    <= '0';

            elsif we = '1' then
                -- WRITE: store data, clear valid immediately
                mem(to_integer(unsigned(addr))) <= data_in;
                valid <= '0';

            else
                -- READ: register the memory word and assert valid
                -- Both appear on data_out/valid one cycle after this edge
                data_out <= mem(to_integer(unsigned(addr)));
                valid    <= '1';

            end if;
        end if;
    end process;

end rtl;
