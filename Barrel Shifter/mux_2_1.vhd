library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mux_2_1 is
  port( SEL: in std_logic;
    A, B : in std_logic_vector(15 downto 0);
    X : out std_logic_vector(15 downto 0));
  end mux_2_1;

architecture behav of mux_2_1 is
  begin
    process(SEL, A, B)
    begin
      case SEL is
         when '0' => X <= A;
         when '1' => X <= B;
         when others => X <= "ZZZZZZZZZZZZZZZZ";
      end case;
    end process;
   end behav;

