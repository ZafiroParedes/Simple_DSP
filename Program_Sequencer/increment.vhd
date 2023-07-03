library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity increment is
    port(
        inp     :   in  std_logic_vector(13 downto 0);
        outp    :   out std_logic_vector(13 downto 0)
    );
end increment;

architecture Behav_increment of increment is
begin
    outp <= std_logic_vector(unsigned(inp) + 1);
end Behav_increment;
