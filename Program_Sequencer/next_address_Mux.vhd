library ieee;
use ieee.std_logic_1164.all;

entity next_address_Mux is
    port(
        Inp1   : in    std_logic_vector(13 downto 0);
        Inp2   : in    std_logic_vector(13 downto 0);
        Inp3   : in    std_logic_vector(13 downto 0);
	Inp4   : in    std_logic_vector(13 downto 0);
        Sel    : in    std_logic_vector(1 downto 0);
        Outp   : out   std_logic_vector(13 downto 0)
    );
end entity next_address_Mux;

architecture Behavnext_address_Mux of next_address_Mux is

begin
	Outp <= Inp1 when(Sel="00")else
 		  Inp2 when(Sel="01")else
		  Inp3 when(Sel="10")else
	          Inp4 when(Sel="11");
end architecture Behavnext_address_Mux;
