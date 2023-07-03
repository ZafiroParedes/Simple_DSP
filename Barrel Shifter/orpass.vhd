library ieee;
use ieee.std_logic_1164.all;

entity orpass is 
	port(SAOut: in std_logic_vector(31 downto 0);
	Reg1Out: in std_logic_vector(15 downto 0);
	Reg0Out: in std_logic_vector(15 downto 0);
	SROR: in std_logic;
	MuxsIn: out std_logic_vector(31 downto 0));
end orpass;

architecture behav of orpass is 
begin
	process(SAOut, Reg1Out, Reg0Out, SROR)
 	begin
		if(SROR ='0') then --changed for controller?
			MuxsIn <= SAOut or (Reg1Out & Reg0Out);
		else
			MuxsIn <= SAOut;
		end if;

  	end process;

end; 