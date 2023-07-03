library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use IEEE.numeric_std.all;
use ieee.NUMERIC_STD.all;

entity shift_array is 
	port(input: in std_logic_vector(15 downto 0);
	X, HI_LO: in std_logic;
	C: in std_logic_vector(7 downto 0);
	output: out std_logic_vector(31 downto 0));
end shift_array;

architecture behav of shift_array is 
signal temp: std_logic_vector(31 downto 0) := (others => '0');
signal num: std_logic := '0';
signal shiftby: integer := 0;

begin
	process(input, HI_LO, X, num, C)
	begin
		shiftby <= to_integer(signed(C));

		num <= input(7);

		if HI_LO = '1' then --set in the high
			temp <=  input & "0000000000000000";
		elsif HI_LO = '0' then --set in the low
			if X = '0' then --logical shift therefore always zero 
				temp <= "0000000000000000" & input;
			elsif X = '1' then --A shift therefore first num matter
				temp <= num&num&num&num&num&num&num&num&num&num&num&num&num&num&num&num & input;
			end if;
		end if;

	end process;


	process(X, C, shiftby, temp) 
	begin
		if X = '0' then --Logical shift
			if C(7) = '0' then --left shift/positive
				output <= std_logic_vector(shift_left(unsigned(temp), shiftby));
			elsif C(7) = '1' then --right shift/negative
				output <= std_logic_vector(shift_right(unsigned(temp), -1*shiftby));
			end if;
		elsif X = '1' then --Arthmetic shift
			if C(7) = '0' then --left shift/positive
				output <= std_logic_vector(shift_left(signed(temp), shiftby));
			elsif C(7) = '1' then --right shift/negative
				output <= std_logic_vector(shift_right(signed(temp), -1*shiftby));
			end if;
		end if;
		
	end process;
		
end behav;
