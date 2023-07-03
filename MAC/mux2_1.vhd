library ieee;
use ieee.std_logic_1164.all;

entity mux2_1 is
    port(
        in0   : in    std_logic_vector(15 downto 0);
        in1   : in    std_logic_vector(15 downto 0);
        S     : in    std_logic;
        output   : out   std_logic_vector(15 downto 0)
    );
end entity mux2_1;

architecture Behavmux2_1 of mux2_1 is

begin
output <= in0 when(S='1')else in1;
    
end architecture Behavmux2_1;
