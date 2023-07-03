library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity ProgramSequencer is
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
end ProgramSequencer;

architecture ProgramSequencer_Arch of ProgramSequencer is

    component Condition_Logic is
	port (	cond_code	: IN std_logic_vector(3 downto 0);	-- condition code from the instruction
		loop_cond	: IN std_logic_vector(3 downto 0);	-- condition for the DO Util loop
		status		: IN std_logic_vector(6 downto 0);	-- data from register ASTAT
		CE		: IN std_logic;				-- CE condition for the DO Util Loop
		s       	: IN std_logic_vector(17 downto 0);		-- control signal to select which condition code to check
		cond		: OUT std_logic
	);
     end component Condition_Logic;

    component increment is
   	port(
        	inp     :   in  std_logic_vector(13 downto 0);
        	outp    :   out std_logic_vector(13 downto 0)
    	);
    end component increment;

    component loop_comparator is
    	port(
        	next_inst, last_inst    :   in  std_logic_vector(13 downto 0);
		clk    	     		:   in  std_logic;
        	isLast      		:   out std_logic
    	);
    end component loop_comparator;

    component Multiplexer14 is
 	port(
		Inp1 : in std_logic_vector(13 downto 0);
 		Inp2 : in std_logic_vector(13 downto 0);
 		Sel : in std_logic;
 		Outp : out std_logic_vector(13 downto 0)
	);
    end component Multiplexer14;

    component next_address_Mux is
    	port(
        	Inp1   : in    std_logic_vector(13 downto 0);
        	Inp2   : in    std_logic_vector(13 downto 0);
        	Inp3   : in    std_logic_vector(13 downto 0);
		Inp4   : in    std_logic_vector(13 downto 0);
        	Sel    : in    std_logic_vector(1 downto 0);
        	Outp   : out   std_logic_vector(13 downto 0)
    	);
    end component next_address_Mux;

    component next_address_Selector is 
	port (Inst		: IN std_logic_vector(23 downto 0);	-- 24 bits instruction
	      cond		: IN std_logic ;	                -- condition code in the instruction
	      LastInst	        : IN std_logic;				-- loop_end condition from the loop comparator
	      rs		: IN std_logic;
	      add_sel	        : OUT std_logic_vector(1 downto 0);
	      Clk 		: IN std_logic
	);
    end component next_address_Selector ;

    component Register14 is
    	port(
        	Inp    		    : in std_logic_vector(13 downto 0);
        	Load, Clk, reset    : in std_logic;
        	Outp   		    : out std_logic_vector(13 downto 0)
    	);
    end component Register14;

    component StackController is
    	port(
        clk, reset        :   in  std_logic;
        PMD 		  :   in  std_logic_vector(23 downto 0);
	pop_needed  	  :   in  std_logic;
	CE, cond	  :   in  std_logic;
	add_sel		  :   in  std_logic_vector(1 downto 0);
        push, pop 	  :   out std_logic
	);
    end component StackController;

-- Not used
--    component Count_Stack is
--	port( 
--		push,pop,reset: IN std_logic;
--		data_in: IN std_logic_vector(13 downto 0); 
--		clk : In std_logic;
--		data_out: OUT std_logic_vector(13 downto 0);
--		overflow,underflow: OUT std_logic
-- 	);
--    end component Count_Stack;
  
    component PC_Stack is
	port( 
		push,pop,reset		: IN std_logic;
		data_in			: IN std_logic_vector(13 downto 0); 
		clk 			: In std_logic;
		data_out		: OUT std_logic_vector(13 downto 0);
		overflow, underflow	: OUT std_logic
 	);

    end component PC_Stack;

    component Loop_Stack is
	port( 
		push,pop,reset: IN std_logic;
		data_in: IN std_logic_vector(17 downto 0); 
		clk : In std_logic;
		data_out: OUT std_logic_vector(17 downto 0);
		overflow,underflow: OUT std_logic
	);

    end component Loop_Stack;

    component TriStateBuffer14 is
    port(
        Data    : in    std_logic_vector(13 downto 0);
        En       : in    std_logic;
        Outp   : out   std_logic_vector(13 downto 0)
    );
    end component TriStateBuffer14;

    component Tristatebuffer14to16 is
	port(
	input : in std_logic_vector(13 downto 0);
	enable : in std_logic;
	output : out std_logic_vector(15 downto 0)
	);
    end component Tristatebuffer14to16;

    signal incrementOut, PCStackOut, currInst, nextAdd, nextAdd_loop, PCStackInc    :   std_logic_vector(13 downto 0);
    signal add_sel   							:   std_logic_vector(1 downto 0);
    signal CE, isLast, cond, pop_needed, push, pop, PCoverflow 		: std_logic;
    signal PCunderflow, loopoverflow, loopunderflow, stk_overflow, stk_underflow		: std_logic;
    signal loopStackOut  						:   std_logic_vector(17 downto 0);
    signal loop_data_in   						:   std_logic_vector(17 downto 0);
    --signal jumpAddress, interruptAdd			:   std_logic_vector(13 downto 0);
    signal lastAddress  			:   std_logic_vector(13 downto 0);

begin

    pop_needed <= isLast and cond;
    stk_overflow <= PCoverflow or loopoverflow;
    stk_underflow <= PCunderflow or loopunderflow;
    loop_data_in <= Inst(17 downto 0);
    CE <= '0';
    --interruptAdd <= "00000000000000";
    --jumpAddress <= "11111111111111";
    lastAddress <= loopStackOut(17 downto 4);

    PCStack    :   PC_Stack port map (push, pop, Reset, incrementOut, Clk, PCStackOut, PCoverflow, PCunderflow);

    LoopStack   :   Loop_Stack port map(push, pop, Reset, loop_data_in, Clk, loopStackOut, loopoverflow, loopunderflow);
    
    ConditionLogic  :   Condition_Logic port map(IR_CC, loopStackOut(3 downto 0), ASTAT, CE, loopStackOut, cond); --CE = 0, s= LSB of loopStackOut?, 

    PCIncrement : increment port map (currInst, incrementOut);

    LoopCompare  :   loop_comparator port map (nextAdd_loop, lastAddress, Clk, isLast);

    Mux         :   Multiplexer14 port map (nextAdd, PMA, Sel, nextAdd_loop);

    PCStackOutIncre	: increment port map (PCStackOut, PCStackInc);
    --PCStackInc <= PCStackOut;

    NextAddress :   next_address_Mux port map (incrementOut, PCStackInc, jumpAddress, interruptAdd, add_sel, nextAdd); --incrementor, stack, jump, interrupt

    NextAddressSel : next_address_Selector port map(Inst, cond, isLast, Reset, add_sel, clk);

    PC          :   Register14 port map(nextAdd_loop, Load, Clk, Reset, currInst);
    
    StackControl  :   StackController port map (Clk, Reset, Inst, pop_needed, CE, cond, add_sel, push, pop);

    TriStateBuff         :   TriStateBuffer14 port map(nextAdd, En, PMA);
    

end ProgramSequencer_Arch;
