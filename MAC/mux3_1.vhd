library ieee;
use ieee.std_logic_1164.all;

entity mux3_1 is
    port(
        in0   : in    std_logic_vector(15 downto 0);
        in1   : in    std_logic_vector(15 downto 0);
        in2   : in    std_logic_vector(15 downto 0);
        S     : in    std_logic_vector(1 downto 0);
        output   : out   std_logic_vector(15 downto 0)
    );
end entity mux3_1;

architecture Behavmux3_1 of mux3_1 is

begin
	output <= in0 when(S="00")else
 		  in1 when(S="01")else
		  in2 when(S="10");
end architecture Behavmux3_1;
