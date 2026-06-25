library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_alu4_extended is
end tb_alu4_extended;

architecture sim of tb_alu4_extended is

    -- DUT signals
    signal a, b    : std_logic_vector(3 downto 0) := (others => '0');
    signal op      : std_logic_vector(2 downto 0) := (others => '0');
    signal result  : std_logic_vector(3 downto 0);
    signal zero    : std_logic;
    signal carry   : std_logic;
    signal negative: std_logic;

    -- Helper procedure so each test case is one readable line
    procedure apply (
        signal sa  : out std_logic_vector(3 downto 0);
        signal sb  : out std_logic_vector(3 downto 0);
        signal sop : out std_logic_vector(2 downto 0);
        constant va : std_logic_vector(3 downto 0);
        constant vb : std_logic_vector(3 downto 0);
        constant vop: std_logic_vector(2 downto 0)
    ) is
    begin
        sa  <= va;
        sb  <= vb;
        sop <= vop;
        wait for 20 ns;
    end procedure;

begin

    -- ── Instantiate DUT ────────────────────────────────────────────
    uut: entity work.alu4_extended
        port map (
            a        => a,
            b        => b,
            op       => op,
            result   => result,
            zero     => zero,
            carry    => carry,
            negative => negative
        );

    -- ── Stimulus process ───────────────────────────────────────────
    stim: process
    begin

        -- ── op="000"  ADD ─────────────────────────────────────────
        -- 7 + 1 = 8  →  result="1000"  zero=0  carry=0  negative=1
        apply(a, b, op, "0111", "0001", "000");

        -- 15 + 1 = 16 → lower 4 bits ="0000"  zero=1  carry=1  negative=0
        -- This is the required carry='1' test case.
        apply(a, b, op, "1111", "0001", "000");

        -- 9 + 9 = 18 → "0010" carry=1  negative=0  zero=0
        apply(a, b, op, "1001", "1001", "000");

        -- ── op="001"  SUB ─────────────────────────────────────────
        -- 8 − 3 = 5  →  result="0101"  zero=0  carry=0  negative=0
        apply(a, b, op, "1000", "0011", "001");

        -- 3 − 3 = 0  →  zero=1
        -- This is a required zero='1' test case (via SUB).
        apply(a, b, op, "0011", "0011", "001");

        -- ── op="010"  AND ─────────────────────────────────────────
        -- 1010 & 1100 = 1000  →  negative=1
        apply(a, b, op, "1010", "1100", "010");

        -- 1010 & 0101 = 0000  →  zero=1
        apply(a, b, op, "1010", "0101", "010");

        -- ── op="011"  OR ──────────────────────────────────────────
        -- 1010 | 0101 = 1111  →  negative=1
        apply(a, b, op, "1010", "0101", "011");

        -- 0000 | 0000 = 0000  →  zero=1
        apply(a, b, op, "0000", "0000", "011");

        -- ── op="100"  XOR ─────────────────────────────────────────
        -- 1010 XOR 1010 = 0000  →  zero=1  (a XOR a = 0 property)
        apply(a, b, op, "1010", "1010", "100");

        -- 1010 XOR 0101 = 1111  →  negative=1
        apply(a, b, op, "1010", "0101", "100");

        -- From hand-calc table: 1010 XOR 1010 = 0000
        apply(a, b, op, "1010", "1010", "100");

        -- ── op="101"  NOT ─────────────────────────────────────────
        -- NOT 1000 = 0111  →  negative=0  (from hand-calc table)
        apply(a, b, op, "1000", "0000", "101");

        -- NOT 0000 = 1111  →  negative=1
        apply(a, b, op, "0000", "0000", "101");

        -- NOT 1111 = 0000  →  zero=1
        apply(a, b, op, "1111", "0000", "101");

        -- ── op="110"  NEGATE ──────────────────────────────────────
        -- NEGATE 0011 (3) = 1101 (−3)  →  negative=1  (from hand-calc)
        apply(a, b, op, "0011", "0000", "110");

        -- NEGATE 0000 = 0000  →  zero=1
        apply(a, b, op, "0000", "0000", "110");

        -- ── op="111"  NOP ─────────────────────────────────────────
        -- result="0000"  all flags='0'
        apply(a, b, op, "1111", "1111", "111");

        wait;   -- simulation ends
    end process;

end sim;
