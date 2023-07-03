library ieee;
use ieee.std_logic_1164.all;

entity processing_unit is

	port (
		clk : in std_logic;
		rs, En : in std_logic;
		PMA : inout std_logic_vector(13 downto 0); -- the PMA bus
		DMA : inout std_logic_vector(13 downto 0); -- the DMA bus
		PMD : in std_logic_vector(23 downto 0); -- the PMD bus
		DMD : inout std_logic_vector(15 downto 0); -- the DMD bus
		R : inout std_logic_vector(15 downto 0);

		s_program_seq : in std_logic_vector(1 downto 0); -- selection signal for program_control muxes
		s_alu : in std_logic_vector(7 downto 0); -- selection signal for alu muxes
		s_mac : in std_logic_vector(10 downto 0); -- selection signal for mac muxes			
		s_shifter : in std_logic_vector(3 downto 0); -- selection signal for shifter muxes

		load_program_seq : in std_logic_vector(2 downto 0); -- load signal for program control registers
		load_alu : in std_logic_vector(5 downto 0); -- load signal for alu registers
		load_mac : in std_logic_vector(7 downto 0); -- load signal for mac registers
		load_shifter : in std_logic_vector(2 downto 0); -- load signal for shifter registers
		bc_program_seq : in std_logic_vector(2 downto 0); -- program_control tristate buffers control signal
		bc_alu : in std_logic_vector(3 downto 0); -- alu tristate buffers control signal
		bc_mac : in std_logic_vector(5 downto 0); -- mac tristate buffers control signal
		bc_shifter : in std_logic_vector(3 downto 0); -- shifter tristate buffers control signal
		control : in std_logic_vector(4 downto 0); -- control code signal for alu and mac
		carry : in std_logic; -- carry signal for alu

		pass : in std_logic; -- control bit for OR/PASS for shifter
		x_in : in std_logic; -- extension bit to be filled in the left part of shifter array
		HI_LO : in std_logic; -- control bit to indicate high/low position in shifter array
		offset : in std_logic_vector(7 downto 0); -- bits to indicate the offset for the shifter
		alu_out : inout std_logic_vector(15 downto 0);
		mac_out : inout std_logic_vector(15 downto 0);
		SR_out : inout std_logic_vector(31 downto 0)
	);
end processing_unit;

architecture struct of processing_unit is

	component ALU is
		port(
        		Load    					:   in      std_logic_vector(5 downto 0);
        		Sel     					:   in      std_logic_vector(5 downto 0);  
        		CLK     					:   in      std_logic;
        		DMD     					:   inout   std_logic_vector(15 downto 0);
        		R       					:   inout   std_logic_vector(15 downto 0);
        		PMD     					:   in      std_logic_vector(23 downto 0);
        		AMF     					:   in      std_logic_vector(4 downto 0);
        		CI     					:   in      std_logic;
        		En    						:   in      std_logic_vector(3 downto 0);
			AZ, AN, AC, AV, AS		:   out     std_logic;
        		ALU_out 					:   inout   std_logic_vector(15 downto 0)
    		);
	end component;

	component MAC is
		port(
        		clk    		:   in      std_logic;
        		load    	:   in      std_logic_vector(7 downto 0);
        		s     		:   in      std_logic_vector(9 downto 0);  -- 9 downto 0
    			En   		:   in	    std_logic_vector(5 downto 0); 
        		DMD     	:   inout   std_logic_vector(15 downto 0);
        		PMD     	:   in      std_logic_vector(23 downto 0);
        		AMF     	:   in      std_logic_vector(4 downto 0); 
        		R       	:   inout   std_logic_vector(15 downto 0);
        		MV      	:   out     std_logic;
        		mac_out 	:   out   std_logic_vector(15 downto 0)
      		);
	end component;

	component barrel_shifter is
		port( DMD: inout std_logic_vector(15 downto 0);
		R: inout std_logic_vector(15 downto 0);
		C: in std_logic_vector(7 downto 0);
		HI_LO, X, SROR, clk: in std_logic;
		Load: in std_logic_vector(2 downto 0);
		SEL, ctr: in std_logic_vector(3 downto 0);
		SR_out : inout std_logic_vector(31 downto 0));
	end component;

	component ProgramSequencer is
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
        		jumpAddress	:   std_logic_vector(13 downto 0);
			interruptAdd  	:   std_logic_vector(13 downto 0));
        		--stk_overflow :  out     std_logic;
        		--stk_underflow : out     std_logic
    		--);
	end component;

	signal SS, MV, AQ, AS, AC, AV, AN, AZ : std_logic;
	--signal 	R: std_logic_vector(15 downto 0);
	--signal Inst : std_logic_vector(23 downto 0);
	signal astat : std_logic_vector(7 downto 0);
	signal AddJump : std_logic_vector(13 downto 0);
	--signal AddTC : std_logic_vector(17 downto 0);
	signal IRAddress : std_logic_vector(13 downto 0);
	signal CC : std_logic_vector(3 downto 0);
begin
	astat(0) <= AZ;
	astat(1) <= AN;
	astat(2) <= AV;
	astat(3) <= AC;
	astat(4) <= AS;
	astat(5) <= AQ;
	astat(6) <= MV;
	astat(7) <= SS;

	P1 : ProgramSequencer port map(
		PMD, astat(6 downto 0), s_program_seq(0), clk, load_program_seq(0), rs, En,
		PMA, CC, AddJump, IRAddress);
	A1 : ALU port map(load_alu, s_alu(5 downto 0), clk, DMD, R, PMD, control, carry, bc_alu, AZ, AN, AV, AC, AS, alu_out);
	M1 : MAC port map(clk, load_mac, s_mac(9 downto 0), bc_mac, DMD, PMD, control, R, MV, mac_out);
	S1 : barrel_shifter port map(DMD, R, offset, HI_LO, x_in, pass, clk, load_shifter, s_shifter, bc_shifter, SR_out);

end struct;
	   
	   