library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ALU is
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
        ALU_out 					:   inout   std_logic_vector(15 downto 0) --(27 downto 0)
    );
end ALU;

Architecture arch of ALU is

    component TriStateBuffer is
        port(	
            T_in    :   in  std_logic_vector(15 downto 0);
            En      :   in  std_logic;
            T_out   :   out std_logic_vector(15 downto 0)
        );
    end component TriStateBuffer;

    component ALURegister is
        port(
            D_in    :   in  std_logic_vector(15 downto 0);
            Load    :   in  std_logic;
            clk     :   in  std_logic;
            D_out   :   out std_logic_vector(15 downto 0)
        ); 
    end component ALURegister;

    component Multiplexer is
        port(
            M_in1   :   in  std_logic_vector(15 downto 0);
            M_in2   :   in  std_logic_vector(15 downto 0);
            Sel     :   in  std_logic;
            M_out   :   out std_logic_vector(15 downto 0)
        );    
    end component Multiplexer;

    component ALUKernel is
        port(X, Y	:in std_logic_vector(15 downto 0);
				CI 	:in std_logic;
				AMF	:in std_logic_vector(4 downto 0);
				CLK	:in std_logic;
				R		:out std_logic_vector(15 downto 0);
				AZ, AN, AC, AV, AS: out std_logic);
    end component ALUKernel;

    component Display is
        port(
				Input: in std_logic_vector(3 downto 0);
				segmentSeven : out std_logic_vector(6 downto 0));
    end component Display;

    --signal dmd_s: std_logic_vector(15 downto 0) := (others => '0');
    --signal pmd_s: std_logic_vector(23 downto 0) := (others => '0');
    signal enable: std_logic_vector(3 downto 0) := "1000"; -- AR tristatebuffer enabled

    signal AX0_MUX1, AX1_MUX1, MUX1_MUX2_TSB0, MUX2_ALU 							: std_logic_vector(15 downto 0);
	 signal MUX0_AY0_AY1, AY0_MUX3, AY1_MUX3, MUX3_MUX4_TSB1						: std_logic_vector(15 downto 0);
	 signal AF_MUX4, MUX4_ALU, ALU_AF, ALU_AF_MUX5, MUX5_AR, AR_TSB3_TSB2	: std_logic_vector(15 downto 0);
  
begin

    AX0 :   ALURegister     port map(DMD, Load(0), CLK, AX0_MUX1); --DMD (11) "0000000000001011"
    AX1 :   ALURegister     port map(DMD, Load(1), CLK, AX1_MUX1); --DMD (5)
    AY0 :   ALURegister     port map(MUX0_AY0_AY1,  Load(2), CLK, AY0_MUX3); -- (7) 0000000000000111
    AY1 :   ALURegister     port map(MUX0_AY0_AY1,  Load(3), CLK, AY1_MUX3); -- (13) 0000000000001101
    AF  :   ALURegister     port map(ALU_AF_MUX5, Load(4), CLK, AF_MUX4);
    AR  :   ALURegister     port map(MUX5_AR, Load(5), CLK, AR_TSB3_TSB2);

    MUX0   :   Multiplexer     port map(DMD, PMD(23 downto 8), Sel(0), MUX0_AY0_AY1);
    MUX1   :   Multiplexer     port map(AX0_MUX1, AX1_MUX1, Sel(1), MUX1_MUX2_TSB0);
    MUX2   :   Multiplexer     port map(R, MUX1_MUX2_TSB0, Sel(2), MUX2_ALU);
    MUX3   :   Multiplexer     port map(AY0_MUX3, AY1_MUX3, Sel(3), MUX3_MUX4_TSB1);
    MUX4   :   Multiplexer     port map(MUX3_MUX4_TSB1, AF_MUX4, Sel(4), MUX4_ALU);
    MUX5   :   Multiplexer     port map(ALU_AF_MUX5, DMD, Sel(5), MUX5_AR);

    ALU   :   ALUKernel       port map(MUX2_ALU, MUX4_ALU, CI, AMF, CLK, ALU_AF_MUX5, AZ, AN, AC, AV, AS); --AMF code hardcoded

	 TSB0  :   TriStateBuffer      port map(MUX1_MUX2_TSB0, En(0), DMD);
    TSB1  :   TriStateBuffer      port map(MUX3_MUX4_TSB1, En(1), DMD);  
    TSB2  :   TriStateBuffer      port map(AR_TSB3_TSB2, En(2), DMD);
    TSB3  :   TriStateBuffer      port map(AR_TSB3_TSB2, En(3), R);


    ALU_out <= AR_TSB3_TSB2;
	 
	 --LSB is HexN[6] for each display
    --SevSeg3 :   Display     port map(AR_TSB3_TSB2(15 downto 12), ALU_out(27 downto 21));
    --SevSeg2  :   Display     port map(AR_TSB3_TSB2(11 downto 8), ALU_out(20 downto 14));
    --SevSeg1  :   Display     port map(AR_TSB3_TSB2(7 downto 4), ALU_out(13 downto 7));
    --SevSeg0  :   Display     port map(AR_TSB3_TSB2(3 downto 0), ALU_out(6 downto 0));

end;
