library ieee;
use ieee.std_logic_1164.all;

entity Condition_Logic is
port (	cond_code	: IN std_logic_vector(3 downto 0);	-- condition code from the instruction
	loop_cond	: IN std_logic_vector(3 downto 0);	-- condition for the DO Util loop
	status		: IN std_logic_vector(6 downto 0);	-- data from register ASTAT
	CE		: IN std_logic;				-- CE condition for the DO Util Loop
	s       	: IN std_logic_vector(17 downto 0);	-- control signal to select which condition code to check
	cond		: OUT std_logic
	);

end Condition_Logic;

architecture behav of Condition_logic is 
begin 
	process (cond_code, loop_cond, status, s)
	--variable c : std_logic;
	begin
		if (s = "000000000000000000") then
			case cond_code is		
				when "0000" => cond <= status(0);		-- EQ
				when "0001" => cond <= not status(0);	-- NE
				when "0010" => cond <= not ((status(1) XOR status(2)) OR status(0));-- GT			
				when "0011" => cond <= (status(1) XOR status(2)) OR status(0);	-- LE			
				when "0100" => cond <= status(1) XOR status(2);			-- LT			
				when "0101" => cond <= not (status(1) XOR status(2));		-- GE			
				when "0110" => cond <= status(2);		-- AV			
				when "0111" => cond <= not (status(2));	-- NOT AV			
				when "1000" => cond <= status(3);		-- AC			
				when "1001" => cond <= not (status(3));	-- NOT AC			
				when "1010" => cond <= status(4);		-- NEG			
				when "1011" => cond <= not (status(4));	-- POS			
				when "1100" => cond <= status(6);		-- MV			
				when "1101" => cond <= not (status(6));	-- NOT MV			
				when "1110" => cond <= not CE;		-- NOT CE			
				when "1111" => cond <= '1';		-- Always true		
				when others => cond <= '0';		
			end case;
		else
			case loop_cond is 		
				when "0000" => cond <= not status(0);	-- NE			
				when "0001" => cond <= status(0);		-- EQ			
				when "0010" => cond <= (status(1) XOR status(2)) OR status(0);	-- LE 			
				when "0011" => cond <= not ((status(1) XOR status(2)) OR status(0));-- GT			
				when "0100" => cond <= not (status(1) XOR status(2));		-- GE			
				when "0101" => cond <= status(1) XOR status(2);			-- LT			
				when "0110" => cond <= not (status(2));	-- NOT AV		
				when "0111" => cond <= status(2);		-- AV
				when "1000" => cond <= not (status(3));	-- NOT AC
				when "1001" => cond <= status(3);		-- AC
				when "1010" => cond <= not (status(4));	-- POS
				when "1011" => cond <= status(4);		-- NEG
				when "1100" => cond <= not (status(6));	-- NOT MV
				when "1101" => cond <= status(6);		-- MV
				when "1110" => cond <= CE;			-- CE
				when "1111" => cond <= '1';		-- Always true
				when others => cond <= '0';	

			end case;
		end if;
		--cond <= c;
	end process;
end behav;



