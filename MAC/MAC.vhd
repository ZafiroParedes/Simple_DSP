library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MAC is 
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
end MAC;

architecture Behav_MAC of MAC is

    component inreg8 is
 	port(
 	input : in std_logic_vector(7 downto 0);
 	load : in std_logic;
 	clk : in std_logic;
 	output : out std_logic_vector(7 downto 0) );
    end component inreg8;

    component inreg16 is
 	port(
 	input : in std_logic_vector(15 downto 0);
 	load : in std_logic;
 	clk : in std_logic;
 	output : out std_logic_vector(15 downto 0) );
    end component inreg16;


    component multiplier is
    	port(
        X   :   in  std_logic_vector(15 downto 0);
        Y   :   in  std_logic_vector(15 downto 0);
        P   :   out std_logic_vector(31 downto 0)
    	);
    end component multiplier;

    component mux2_1 is
    	port(
        in0   : in    std_logic_vector(15 downto 0);
        in1   : in    std_logic_vector(15 downto 0);
        S     : in    std_logic;
        output   : out   std_logic_vector(15 downto 0)
    );
    end component mux2_1;

    component mux2_1_8bit is
    	port(
        in0   : in    std_logic_vector(7 downto 0);
        in1   : in    std_logic_vector(7 downto 0);
        S     : in    std_logic;
        output   : out   std_logic_vector(7 downto 0)
    	);
    end component mux2_1_8bit;

    component mux3_1 is
    	port(
        in0   : in    std_logic_vector(15 downto 0);
        in1   : in    std_logic_vector(15 downto 0);
        in2   : in    std_logic_vector(15 downto 0);
        S     : in    std_logic_vector(1 downto 0);
        output   : out   std_logic_vector(15 downto 0)
    	);
    end component mux3_1;

    component mux3_1_8bit is
    	port(
        in0   : in    std_logic_vector(15 downto 0);
        in1   : in    std_logic_vector(15 downto 0);
        in2   : in    std_logic_vector(7 downto 0);
        S     : in    std_logic_vector(1 downto 0);
        output   : out   std_logic_vector(15 downto 0)
    	);
    end component mux3_1_8bit;

    component tristate_buffer16 is
    	port(
        input    : in    std_logic_vector(15 downto 0);
        enable     : in    std_logic;
        output   : out   std_logic_vector(15 downto 0)
    	);
    end component tristate_buffer16;

    component tristate_buffer8 is
    	port(
        input    : in    std_logic_vector(7 downto 0);
        enable      : in    std_logic;
        output   : out   std_logic_vector(15 downto 0)
    	);
    end component tristate_buffer8;

    component addsub is 
    	port(
        AMF :   in  std_logic_vector(4 downto 0);
        P   :   in  std_logic_vector(31 downto 0);
        MR  :   in  std_logic_vector(39 downto 0);
        MV  :   out std_logic;
        R0  :   out std_logic_vector(15 downto 0);
        R1  :   out std_logic_vector(15 downto 0);
        R2  :   out std_logic_vector(7 downto 0)
    	);
    end component addsub;

    component Display is
	port(
	Input: in std_logic_vector(3 downto 0); --input from calc
	segmentSeven : out std_logic_vector(6 downto 0)); --7 bit output end Display_Ckt;
    end component Display;

    signal MULTI_AS   : std_logic_vector(31 downto 0);
    signal MX1_MUX1, MX0_MUX1, MUX0_MY0_MY1 : std_logic_vector(15 downto 0);
    signal MY0_MUX2, MY1_MUX2, MUX1_MULTI, MUX2_MULTI	: std_logic_vector(15 downto 0);
    signal MF_MUX2, AS_MUX4_MF, AS_MUX5, MUX4_MR1, MUX5_MR0, MUX6_T2: std_logic_vector(15 downto 0);
    signal MR1_MUX6_T6, MR0_MUX6_T7 : std_logic_vector(15 downto 0) := (others => '0');
    signal AS_MUX3, MUX3_MR2 :std_logic_vector(7 downto 0);
    signal MR2_MUX6_T5 : std_logic_vector(7 downto 0) := (others => '0');

    --signal load : std_logic_vector(7 downto 0);
    --signal En   : std_logic_vector(5 downto 0);
    signal MR_complete : std_logic_vector(39 downto 0);

    signal t_X0 : std_logic_vector(15 downto 0) := "0000000000000011";
    signal t_X1 : std_logic_vector(15 downto 0) := "0000000000000100";
    signal t_Y0 : std_logic_vector(15 downto 0) := "0000000000000101";
    signal t_Y1 : std_logic_vector(15 downto 0) := "0000000000000110";

begin
    --load <= "11111111";  
    --En <= "100100";
    MR_complete <= MR2_MUX6_T5 & MR1_MUX6_T6 & MR0_MUX6_T7;

    MX0 : inreg16 port map(DMD, load(0), clk, MX0_MUX1);     -- DMD
    MX1 : inreg16 port map(DMD, load(1), clk, MX1_MUX1);     -- DMD
    MY0 : inreg16 port map(MUX0_MY0_MY1, load(2), clk, MY0_MUX2);     -- MUX0_MY0_MY1
    MY1 : inreg16 port map(MUX0_MY0_MY1, load(3), clk, MY1_MUX2);     -- MUX0_MY0_MY1
    	

    MR2 : inreg8 port map(MUX3_MR2, load(4), clk, MR2_MUX6_T5);
    MR1 : inreg16 port map(MUX4_MR1, load(5), clk, MR1_MUX6_T6);
    MR0 : inreg16 port map(MUX5_MR0, load(6), clk, MR0_MUX6_T7);

    MF  : inreg16 port map(AS_MUX4_MF, load(7), clk, MF_MUX2);

    MUX0 : mux2_1 port map(DMD,PMD(23 downto 8), s(0), MUX0_MY0_MY1);  -- sel(0)
    MUX1 : mux3_1 port map(R, MX0_MUX1, MX1_MUX1, s(2 downto 1), MUX1_MULTI);  -- sel(2 downto 1)
    MUX2 : mux3_1 port map(MY0_MUX2, MY1_MUX2, MF_MUX2, s(4 downto 3), MUX2_MULTI);  -- sel(4 downto 3)
    MUX3 : mux2_1_8bit port map(AS_MUX3,DMD(7 downto 0), s(5), MUX3_MR2);  -- sel(5)
    MUX4 : mux2_1 port map(AS_MUX4_MF,DMD, s(6), MUX4_MR1);  -- sel(6)
    MUX5 : mux2_1 port map(AS_MUX5,DMD, s(7), MUX5_MR0);  -- sel(7)
   
    MUX6 : mux3_1_8bit port map(MR0_MUX6_T7, MR1_MUX6_T6, MR2_MUX6_T5, s(9 downto 8), MUX6_T2); -- sel(9 downto 8)
    -- 
    MUL : multiplier port map(MUX1_MULTI, MUX2_MULTI, MULTI_AS);
                    
    AS : addsub port map(AMF, MULTI_AS, MR_complete, MV, AS_MUX5, AS_MUX4_MF, AS_MUX3);

    T0 : tristate_buffer16 port map(MX0_MUX1, En(0), DMD);
    T1 : tristate_buffer16 port map(MY1_MUX2, En(1), DMD);
    T2 : tristate_buffer16 port map(MUX6_T2, En(2), DMD);
    T3 : tristate_buffer8 port map(MR2_MUX6_T5, En(3), R);
    T4 : tristate_buffer16 port map(MR1_MUX6_T6, En(4), R);
    T5 : tristate_buffer16 port map(MR0_MUX6_T7, En(5), R);

    mac_out <= MR0_MUX6_T7;

    --LSB is HexN[6] for each display
    --SevSeg3  :   Display     port map(MR0_MUX6_T7(15 downto 12), mac_out(27 downto 21));   --display
    --SevSeg2  :   Display     port map(MR0_MUX6_T7(11 downto 8), mac_out(20 downto 14));
    --SevSeg1  :   Display     port map(MR0_MUX6_T7(7 downto 4), mac_out(13 downto 7));
    --SevSeg0  :   Display     port map(MR0_MUX6_T7(3 downto 0), mac_out(6 downto 0));

end;
