library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity TriStateBuffer is
    port(
        T_in    : in    std_logic_vector(15 downto 0);
        En   	: in    std_logic;
        T_out   : out   std_logic_vector(15 downto 0)
    );
end entity TriStateBuffer;

architecture BehavTri of TriStateBuffer is

begin
    process(T_in, En)
    begin
    if(En = '1')then T_out <= T_in;
    else
    
    T_out <= "ZZZZZZZZZZZZZZZZ";
    
    end if;
    end process;
   
    end BehavTri;
