library ieee;
use ieee.std_logic_1164.all;

entity Multiplexer14 is
 port(
 
	Inp1 : in std_logic_vector(13 downto 0);
 	Inp2 : in std_logic_vector(13 downto 0);
 	Sel : in std_logic;
 	Outp : out std_logic_vector(13 downto 0)
	);
end entity Multiplexer14;

architecture BehavMulti of Multiplexer14 is
begin
Outp <= Inp1 when(Sel='0')else Inp2;
 
end architecture BehavMulti;
