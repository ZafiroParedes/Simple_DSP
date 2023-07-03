library ieee;
use ieee.std_logic_1164.all;

entity register_16 is
    Port(Iput : in std_logic_vector(15 downto 0);
         Load, Clk : in std_logic;
         Oput : out std_logic_vector(15 downto 0));
  end register_16;

architecture behav of register_16 is
  Signal storage : std_logic_vector(15 downto 0);
    begin
        process(Iput, Load, Clk)
        begin
            if(Clk'event and Clk='1' and Load='1') then
                storage <= Iput;
            elsif(Clk'event and Clk='0') then
               Oput <= storage;
            end if;
        end process;
   end;

