library ieee;
use ieee.std_logic_1164.all;

entity loop_comparator is
    port(
        next_inst, last_inst    :   in  std_logic_vector(13 downto 0);
	clk         		:   in  std_logic;
        isLast      		:   out std_logic
    );
end loop_comparator;

architecture Behav_loop_comparator of loop_comparator is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if next_inst = last_inst then
                isLast <= '1';
            else
                isLast <= '0';
            end if;
        end if;
    end process;
end architecture Behav_loop_comparator;
