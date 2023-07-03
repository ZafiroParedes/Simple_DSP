library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier is
    port(
        X   :   in  std_logic_vector(15 downto 0);
        Y   :   in  std_logic_vector(15 downto 0);
        P   :   out std_logic_vector(31 downto 0)
    );
end entity multiplier;

architecture Behavmultiplier of multiplier is
begin
    P <= std_logic_vector(signed(X) * signed(Y));
end Behavmultiplier;
