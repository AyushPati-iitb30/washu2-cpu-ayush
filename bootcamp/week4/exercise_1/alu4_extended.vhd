library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu4_extended is
    port (
        a        : in  std_logic_vector(3 downto 0);
        b        : in  std_logic_vector(3 downto 0);
        op       : in  std_logic_vector(2 downto 0);
        result   : out std_logic_vector(3 downto 0);
        zero     : out std_logic;   -- '1' when result = "0000"
        carry    : out std_logic;   -- '1' when ADD produces a carry out
        negative : out std_logic    -- '1' when result(3) = '1' (MSB set)
    );
end alu4_extended;

architecture rtl of alu4_extended is

    -- Internal signals so we can read the result back for flag logic
    signal result_int : std_logic_vector(3 downto 0);
    signal carry_int  : std_logic;

    -- 5-bit widened operands for carry-detecting addition
    signal a5, b5, sum5 : unsigned(4 downto 0);

begin

    -- ── 5-bit adder (always running; only hooked up for op = ADD) ──
    a5   <= '0' & unsigned(a);
    b5   <= '0' & unsigned(b);
    sum5 <= a5 + b5;

    -- ── Main combinational ALU process ─────────────────────────────
    process(a, b, op, sum5)
    begin
        -- Defaults prevent latches
        result_int <= "0000";
        carry_int  <= '0';

        case op is

            when "000" =>           -- ADD  (unsigned; carry from bit 4)
                result_int <= std_logic_vector(sum5(3 downto 0));
                carry_int  <= sum5(4);

            when "001" =>           -- SUB  (A − B, 4-bit; carry always '0')
                result_int <= std_logic_vector(unsigned(a) - unsigned(b));

            when "010" =>           -- AND  (bitwise)
                result_int <= a and b;

            when "011" =>           -- OR   (bitwise)
                result_int <= a or b;

            when "100" =>           -- XOR  (bitwise)
                result_int <= a xor b;

            when "101" =>           -- NOT  (unary; B ignored; carry '0')
                result_int <= not a;

            when "110" =>           -- NEGATE  (two's complement of A; B ignored)
                result_int <= std_logic_vector(-signed(a));

            when others =>          -- "111" NOP / undefined → all zeros
                result_int <= "0000";

        end case;
    end process;

    -- ── Output assignments ─────────────────────────────────────────
    result   <= result_int;
    carry    <= carry_int;
    zero     <= '1' when result_int = "0000" else '0';
    negative <= result_int(3);      -- MSB is the sign bit

end rtl;
