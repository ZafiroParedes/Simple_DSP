library ieee;
use ieee.std_logic_1164.all;

entity PS_Memory is
    port(
        Clk         :   in      std_logic;
	reset	    :   in 	std_logic
	--s_read	    :   in 	std_logic;
        --PMA         :   inout   std_logic_vector(13 downto 0)
    );
end PS_Memory;

architecture PS_Memory_Behav of PS_Memory is

	component ProgramSequencer
		port(
        		Inst        :   in      std_logic_vector(23 downto 0);
        		ASTAT       :   in      std_logic_vector(6 downto 0);
        		Sel         :   in      std_logic;
        		Clk         :   in      std_logic;
        		Load        :   in      std_logic;
        		Reset       :   in      std_logic;
        		En          :   in      std_logic;
        		PMA         :   inout   std_logic_vector(13 downto 0);
        		IR_CC       :   in      std_logic_vector(3 downto 0);
        		stk_overflow :  out     std_logic;
        		stk_underflow : out     std_logic
    		);
	end component;

	component ProgramMemory
		port (
			PMA : in std_logic_vector(13 downto 0); -- address bus
			PMD : inout std_logic_vector(23 downto 0); --data bus
			s_read: in std_logic
		);
	end component;

	signal PMD 						: std_logic_vector(23 downto 0);
	signal PMA 						: std_logic_vector(13 downto 0);
	signal ASTAT 						: std_logic_vector(6 downto 0);
	signal IR_CC 						: std_logic_vector(3 downto 0);
	signal Sel, Load, En, stk_overflow, stk_underflow, s_read	: std_logic;

begin
	ASTAT <= "0000000";
	IR_CC <= "0000";
	Sel <= '1';
	Load <= '1';
	En <= '1';
	s_read <= '1';

	PS 	: ProgramSequencer 
		port map(PMD, ASTAT, Sel, Clk, Load, Reset, En, PMA, IR_CC, stk_overflow, stk_underflow);

	Memory	: ProgramMemory port map(PMA, PMD, s_read);

end PS_Memory_Behav;