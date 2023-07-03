library ieee; 
use ieee.std_logic_1164.all;
entity Tristatebuffer14to16 is
port(
input : in std_logic_vector(13 downto 0);
enable : in std_logic;
output : out std_logic_vector(15 downto 0)
);
end entity Tristatebuffer14to16;
architecture BehavTristatebuffer14to16 of Tristatebuffer14to16 is
signal ss : std_logic_vector(1 downto 0);
begin
 
ss <= "00" when (input(13) = '0') else
 
"11";
 with (enable) select
 
output <= ss & input when '1',
 
"ZZZZZZZZZZZZZZZZ" when others;
end BehavTristatebuffer14to16;
