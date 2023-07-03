library ieee;
use ieee.std_logic_1164.all;

entity mux2_1_8bit is
    port(
        in0   : in    std_logic_vector(7 downto 0);
        in1   : in    std_logic_vector(7 downto 0);
        S     : in    std_logic;
        output   : out   std_logic_vector(7 downto 0)
    );
end entity mux2_1_8bit;

architecture Behavmux2_1_8bit of mux2_1_8bit is

begin
 output <= in0 when(S='1')else in1; 
end Behavmux2_1_8bit;
