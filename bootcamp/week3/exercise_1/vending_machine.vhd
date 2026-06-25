library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vending_machine is
    port (
        clk      : in  std_logic;
        reset    : in  std_logic;
        coin5    : in  std_logic;   -- '1' for one clock cycle when 5p inserted
        coin10   : in  std_logic;   -- '1' for one clock cycle when 10p inserted
        dispense : out std_logic;   -- '1' for one cycle when item is released
        change   : out std_logic    -- '1' for one cycle when 5p change is given
    );
end vending_machine;

architecture rtl of vending_machine is
    type state_type is (S0, S5, S10, S15, S20);
    signal current_state : state_type;
    signal next_state : state_type;

begin

    state_register : process(clk, reset)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                current_state <= S0;
            else
                current_state <= next_state;
            end if;
        end if;
    end process;

    comb_logic : process(current_state, coin5, coin10)
    begin
        next_state <= current_state;  -- default state
        dispense <= '0';
        change <= '0';

        case current_state is
            when S0 =>
                if coin5 = '1' then
                    next_state <= S5;
                elsif coin10 = '1' then
                    next_state <= S10;
                end if;

            when S5 =>
                if coin5 = '1' then
                    next_state <= S10;
                elsif coin10 = '1' then
                    next_state <= S15;
                end if;

            when S10 =>
                if coin5 = '1' then
                    next_state <= S15;
                elsif coin10 = '1' then
                    next_state <= S20;
                end if;

            when S15 => 
                dispense <= '1';
                change <= '0';
                next_state <= S0;

            when S20 =>
                dispense <= '1';
                change <= '1';
                next_state <= S0;

            when others =>
                next_state <= S0;
        end case;
    end process;
end rtl;

    