library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity barrel_shifter is
	port( DMD: inout std_logic_vector(15 downto 0);
	R: inout std_logic_vector(15 downto 0);
	C: in std_logic_vector(7 downto 0);
	HI_LO, X, SROR, clk: in std_logic;
	Load: in std_logic_vector(2 downto 0);
	SEL, ctr: in std_logic_vector(3 downto 0);
	SR_out : inout std_logic_vector(31 downto 0));
	--xed1, xed2, xed3, xed4, xed5, xed6: out std_logic_vector(6 downto 0);
	--led1, led2, led3, led4, led5, led6, led7, led8: out std_logic);
end barrel_shifter;

architecture behav of barrel_shifter is

component register_16 
    Port(Iput : in std_logic_vector(15 downto 0);
         Load, Clk : in std_logic;
         Oput : out std_logic_vector(15 downto 0));
end component;

 component mux_2_1
	port(SEL: in std_logic;
	A,B: in std_logic_vector(15 downto 0);
	X: out std_logic_vector(15 downto 0));
 end component;

 component tri_state
	port(input: in std_logic_vector(15 downto 0);
	enable: in std_logic;
	output: out std_logic_vector(15 downto 0));
 end component;

component shift_array 
	port(input: in std_logic_vector(15 downto 0);
	X, HI_LO: in std_logic;
	C: in std_logic_vector(7 downto 0);
	output: out std_logic_vector(31 downto 0));
end component;

component orpass 
	port(SAOut: in std_logic_vector(31 downto 0);
	Reg1Out: in std_logic_vector(15 downto 0);
	Reg0Out: in std_logic_vector(15 downto 0);
	SROR: in std_logic;
	MuxsIn: out std_logic_vector(31 downto 0));
	--Mux2In: out std_logic_vector(15 downto 0));
end component;

component Display 
	port(Input: in std_logic_vector(3 downto 0); --input from calc
	segmentSeven : out std_logic_vector(6 downto 0)); --7 bit output end Display_Ckt;
end component;

 signal regSI, muxSI: std_logic_vector(15 downto 0) := (others => '0');
 signal SAoutput: std_logic_vector(31 downto 0) := (others => '0');
 signal orpassOut: std_logic_vector(31 downto 0) := (others => '0');
 --signal orpassOR: std_logic_vector(31 downto 0);
 signal muxS0, muxS1: std_logic_vector(15 downto 0) := (others => '0');
 signal regSR0, regSR1: std_logic_vector(15 downto 0) := (others => '0'); 
 signal muxOut: std_logic_vector(15 downto 0) := (others => '0');
 
 signal loadd: std_logic_vector(2 downto 0) := "111";
 signal ctrr: std_logic_vector(3 downto 0) := "0101";
 signal SELL: std_logic_vector(3 downto 0) := "1000";
 signal SRORR: std_logic := '0';
 signal RR: std_logic_vector(15 downto 0) := "0000000000000000";
 signal DMDD: std_logic_vector(15 downto 0) := "1011011010100011";

 begin
	
	SIregister: register_16 port map(DMD, load(0),clk,regSI);
	TOPtristate: tri_state port map(regSI,ctr(0), DMD);
	SImux: mux_2_1 port map(SEL(0),regSI, R, muxSI);

	SA: shift_array port map(muxSI, X, HI_LO, C, SAoutput);
	ORPass1: orpass port map(SAoutput, regSR1, regSR0, SROR, orpassOut);

 	S1mux: mux_2_1 port map(SEL(1), orpassOut(31 downto 16), DMD, muxS1);
  	S0mux: mux_2_1 port map(SEL(2), orpassOut(15 downto 0), DMD, muxS0);

	SR1register: register_16 port map(muxS1,load(1),clk,regSR1);
	SR0register: register_16 port map(muxS0,load(2),clk,regSR0);

	S1tristate: tri_state port map(regSR1,ctr(1),R);
	S0tristate: tri_state port map(regSR0,ctr(2),R);

	muxFeedback: mux_2_1 port map(SEL(3),regSR1,regSR0,muxOut);
	BOTTOMtristate: tri_state port map(muxOut, ctr(3), DMD);

	SR_out <= regSR1 & regSR0;
	
	--sevenSeg1: Display port map(regSR0(3 downto 0), xed1);
	--sevenSeg2: Display port map(regSR0(7 downto 4), xed2);
	--sevenSeg3: Display port map(regSR0(11 downto 8), xed3);
	--sevenSeg4: Display port map(regSR0(15 downto 12), xed4);
	--sevenSeg5: Display port map(regSR1(3 downto 0), xed5);
	--sevenSeg6: Display port map(regSR1(7 downto 4), xed6);

	--led1 <= regSR1(8);
	--led2 <= regSR1(9);
	--led3 <= regSR1(10);
	--led4 <= regSR1(11);
	--led5 <= regSR1(12);
	--led6 <= regSR1(13);
	--led7 <= regSR1(14);
	--led8 <= regSR1(15);
	
end behav;
