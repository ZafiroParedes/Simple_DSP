library ieee;
use ieee.std_logic_1164.all;

entity ALURegister is
    port(
        D_in    : in std_logic_vector(15 downto 0);
        load     : in std_logic;
        clk      : in std_logic;
        D_out   : out std_logic_vector(15 downto 0)
    );
end entity ALURegister;

architecture BehaveALURegister of ALURegister is

    signal storage : std_logic_vector(15 downto 0);

begin

    process(D_in, load, clk)
    begin
        if(clk'event and clk='1' and load='1')then
    		storage <= D_in;
	elsif(clk'event and clk ='0')then
		D_out <= storage;
	end if;
    end process;
end;
