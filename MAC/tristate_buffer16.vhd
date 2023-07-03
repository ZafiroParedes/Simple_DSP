library ieee;
use ieee.std_logic_1164.all;

entity tristate_buffer16 is
    port(
        input    : in    std_logic_vector(15 downto 0);
        enable     : in    std_logic;
        output   : out   std_logic_vector(15 downto 0)
    );
end entity tristate_buffer16;

architecture Behavtristate_buffer16 of tristate_buffer16 is

begin
process(input, enable)
 begin
 
if(enable = '1')then output <= input;
 
else
 
 output <= "ZZZZZZZZZZZZZZZZ";
 
 
end if;
 
end process;

end Behavtristate_buffer16;
