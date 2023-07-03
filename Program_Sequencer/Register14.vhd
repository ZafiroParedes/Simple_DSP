library IEEE;
use IEEE.std_logic_1164.all;

entity Register14 is
    port(
        Inp    		    : in std_logic_vector(13 downto 0);
        Load, Clk, reset    : in std_logic;
        Outp   		    : out std_logic_vector(13 downto 0)
    );
end entity Register14;

architecture Behav_Register14 of Register14 is

begin

    Reg_Proc: process(Clk)
    begin
        if (reset = '1') then
            Outp <= "00000000000000";
        elsif rising_edge(Clk) then
            if (Load = '1') then
                Outp <= Inp;
            end if;
        end if;
    end process;

end architecture Behav_Register14;
