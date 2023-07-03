library ieee;
use ieee.std_logic_1164.all;

entity mux3_1_8bit is
    port(
        in0   : in    std_logic_vector(15 downto 0);
        in1   : in    std_logic_vector(15 downto 0);
        in2   : in    std_logic_vector(7 downto 0);
        S     : in    std_logic_vector(1 downto 0);
        output   : out   std_logic_vector(15 downto 0)
    );
end mux3_1_8bit;

architecture Behavmux3_1_8bit of mux3_1_8bit is

    signal s_in2    :   std_logic_vector(15 downto 0);

begin

	s_in2 <= "00000000" & in2 when(in2(7)='0')else
                 "11111111" & in2 when(in2(7)='1');

	output <= in0 when(S="00")else
 		  in1 when(S="01")else
		  s_in2 when(S="10");

end Behavmux3_1_8bit;
