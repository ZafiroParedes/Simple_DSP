library IEEE;
use IEEE.std_logic_1164.all;

entity Multiplexer is
    port(
        M_in1   : in    std_logic_vector(15 downto 0);
        M_in2   : in    std_logic_vector(15 downto 0);
        Sel       : in    std_logic;
        M_out   : out   std_logic_vector(15 downto 0)
    );
end entity Multiplexer;

architecture BehavMultiplexer of Multiplexer is

begin
    M_out <= M_in1 when(Sel='0')else M_in2;   
end BehavMultiplexer;
