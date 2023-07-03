library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity addsub is 
    port(
        AMF :   in  std_logic_vector(4 downto 0);
        P   :   in  std_logic_vector(31 downto 0);
        MR  :   in  std_logic_vector(39 downto 0);
        MV  :   out std_logic;
        R0  :   out std_logic_vector(15 downto 0);
        R1  :   out std_logic_vector(15 downto 0);
        R2  :   out std_logic_vector(7 downto 0)
    );
end entity addsub;

architecture Behav_addsub of addsub is

    signal reg_signals, P_signal  :   std_logic_vector(39 downto 0);

begin

    P_signal(31 downto 0) <= P;

    with P(31) select
        P_signal(39 downto 32) <= X"00" when '0',
                             X"11" when others;
    R0 <= reg_signals(15 downto 0);
    R1 <= reg_signals(31 downto 16);
    R2 <= reg_signals(39 downto 32);

    process(AMF, P, MR, reg_signals, P_signal)
    begin

        case(AMF) is
            when "00000" =>
                reg_signals <= X"0000000000";
                MV <= '0';
            when "00001" =>
                reg_signals <= P_signal;
                MV <= '0';
            when "00010" =>
                reg_signals <= std_logic_vector(signed(MR) + signed(P_signal));
                
                MV <= (MR(39) and P_signal(39) and not reg_signals(39)) or (not MR(39) and not P_signal(39) and reg_signals(39));
            when "01100" =>
                reg_signals <= std_logic_vector(signed(MR) - signed(P_signal));
              
                if ((signed(MR) >= 0) AND (signed(P_signal) < 0)) then  -- 2
                    MV <= NOT MR(39) AND P_signal(39) AND reg_signals(39);
                elsif ((signed(MR) < 0) AND (signed(P_signal) >=0)) then  -- 3
                    MV <= MR(39) AND NOT P_signal(39) AND NOT reg_signals(39);
                else  -- 1 and 4
                    MV <= '0';
                end if;
            when others =>
                reg_signals <= X"1010101010";  
                MV <= '0';
        end case;
    end process;
end architecture Behav_addsub;
