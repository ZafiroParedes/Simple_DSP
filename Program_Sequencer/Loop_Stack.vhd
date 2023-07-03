library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity Loop_Stack is
	port( 
		push,pop,reset: IN std_logic;
		data_in: IN std_logic_vector(17 downto 0); 
		clk : In std_logic;
		data_out: OUT std_logic_vector(17 downto 0);
		overflow,underflow: OUT std_logic
	);
end Loop_Stack;


architecture behavLoop_Stack of Loop_Stack is
    
type arr is array (0 to 4) of std_logic_vector(17 downto 0);   -- Array of M rows and N columns

begin
	
	
process(clk)
	
	
variable data_stack : arr;  
	
variable pointer: integer range 0 to 4 := 0;
	
	
begin
	
if (clk = '0') then
	
		
data_stack(0) := (others => '0');
		
if (reset = '1') then
			
pointer := 0;		
		
elsif (push = '1') then
			
if (pointer < 4) then
				
pointer := pointer + 1;
				
data_stack(pointer) := data_in;
				
overflow <= '0';
			
else
				
overflow <= '1';
			
end if;
underflow <= '0';
			
		-- handle the pop operation	
		
elsif (pop = '1') then
			
if (pointer > 0) then
				
pointer := pointer -1;
				
underflow <= '0';
			
else
				
underflow <= '1';
			
end if;

overflow <= '0';
		
end if;
		
		-- output data
		
data_out <= data_stack(pointer);
		
	
end if; -- end of sync


end process;
   

end behavLoop_Stack;
    

