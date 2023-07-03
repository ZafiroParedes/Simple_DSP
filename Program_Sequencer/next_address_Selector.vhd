library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity next_address_Selector is 
	port (Inst		: IN std_logic_vector(23 downto 0);	-- 24 bits instruction
	      cond		: IN std_logic ;	                -- condition code in the instruction
	      LastInst	        : IN std_logic;				-- loop_end condition from the loop comparator
	      rs		: IN std_logic;
	      add_sel	        : OUT std_logic_vector(1 downto 0);
	      Clk 		: IN std_logic
);
end next_address_Selector ;


architecture behav of next_address_Selector is 
begin
	process (Clk, rs, LastInst, cond)			
	begin
		if (rs = '1') then 
			add_sel <= "00";
		elsif (Clk'event and Clk = '1') then
			elsif (Inst(23 downto 19) = "00011" and cond = '1') then --Conditional Jump
				add_sel <= "10" ;
			elsif (LastInst = '1' and cond = '0') then
				add_sel <= "01" ; -- select from the pc stack
			elsif (LastInst = '0' and cond = '0') then
				add_sel <= "00" ; -- select from the pc incrementer
			end if;			
		--end if;

	end process;
end behav;



