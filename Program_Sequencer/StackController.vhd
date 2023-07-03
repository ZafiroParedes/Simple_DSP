library ieee;
use ieee.std_logic_1164.all;
--Additional testing

entity StackController is
    port(
        clk, reset        :   in  std_logic;
        PMD 		  :   in  std_logic_vector(23 downto 0);
	pop_needed  	  :   in  std_logic;
	CE, cond	  :   in  std_logic;
	add_sel		  :   in  std_logic_vector(1 downto 0);
        push, pop 	  :   out std_logic
    );
end StackController;

architecture StackController_arch of StackController is
begin
    process(clk, PMD)
    begin
        if (reset = '1') then
            push <= '0';
            pop <= '0';
        --elsif falling_edge(clk) OR rising_edge(clk) then --does not work, waits an entire clock cycle and then saves the next address
            elsif (PMD(23 downto 18) = "000101") then  -- do until
                push <= '1';
                pop <= '0';
            elsif (pop_needed = '1') then
                push <= '0';
                pop <= '1';
            else
                push <= '0';
                pop <= '0';
            end if;
        --end if;
    end process;
end StackController_arch;
