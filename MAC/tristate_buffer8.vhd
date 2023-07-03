library ieee;
use ieee.std_logic_1164.all;

entity tristate_buffer8 is
    port(
        input    : in    std_logic_vector(7 downto 0);
        enable      : in    std_logic;
        output   : out   std_logic_vector(15 downto 0)
    );
end entity tristate_buffer8;

architecture Behavtristate_buffer8 of tristate_buffer8 is

    signal s_input : std_logic_vector(7 downto 0);

begin
process(input, enable)
 
begin

    --s_input <= X"00" when (input(7) = '0') else
               --X"11";

	if(input(7) = '0')then s_input <= X"00";
 
	else
		s_input <= X"11";
	end if;
 
	if(enable = '1')then output <= s_input & input;
 
	else
 
 	output <= "ZZZZZZZZZZZZZZZZ";
 
end if;
 
end process;

end Behavtristate_buffer8;
