library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

entity ProgramMemory is
	port (
		PMA : in std_logic_vector(13 downto 0); -- address bus
		PMD : inout std_logic_vector(23 downto 0); --data bus
		s_read: in std_logic
	);
end ProgramMemory;

architecture ProgramMemory_Behav of ProgramMemory is

	type memory_array is array (0 to 14) of std_logic_vector(23 downto 0);

	
	
begin

	process(s_read, PMA)

	variable memory : memory_array;

	begin

--	memory(1) := "010000000000000000100000";
--	memory(2) := "010000000000000000110101";
--	memory(3) := "010000000000000001000010";
--	memory(4) := "010000000000000000100111";
--	memory(5) := "001001100010100000001111";
--	memory(6) := "001010100110100010100000";
--	memory(7) := "001010000010100010110000";
--	memory(8) := "000101000000000010110001";
--	memory(9) := "001001100011000000001111";
--	memory(10) := "001001100011000000001110";
--	memory(11) := "001001100011000000001101";
--	memory(12) := "001001100011000000001011";
--	memory(13) := "001001100011000000001100";

	memory(1) := "010000000000000000100000";
	memory(2) := "010000000000000000110101";
	memory(3) := "010000000000000001000010";
	memory(4) := "010000000000000000100111";
	memory(5) := "010010110110101000111000";
	memory(6) := "001010100110100010100000";
	memory(7) := "001010000010100010110000";
	memory(8) := "000011110000000011111011";
	memory(9) := "000000101000000000000000";
	memory(10) := "000000101000000000000000";
	memory(11) := "000000101000000000000000";
	memory(12) := "000000101000000000000000";
	memory(13) := "000000101000000000000000";

	if (s_read = '1') then
		PMD <= memory(to_integer(unsigned(PMA)));
	else
		PMD <= PMD;
	end if;

	end process;
end ProgramMemory_Behav;
