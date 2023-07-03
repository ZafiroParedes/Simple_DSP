library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALUKernel is 
	port(X, Y	:in std_logic_vector(15 downto 0);
	     CI 	:in std_logic;
	     AMF	:in std_logic_vector(4 downto 0);
	     CLK	:in std_logic;
	     R		:out std_logic_vector(15 downto 0);
	     AZ, AN, AC, AV, AS: out std_logic);
end entity ALUKernel;

architecture BehavALUKernel of ALUKernel is

    signal result  :   std_logic_vector(15 downto 0);

begin
 
--	if (result = X"0000") then
--		AZ <= '1';
--   else
--		AZ <= '0';
--   end if;
	
	AN <= result(15);
	AS <= X(15);
   R <= result;
	AZ <= '1' when (result = X"0000") else '0';


Kernel: process(X, Y, CI, AMF, result)	
    begin											

        case(AMF) is
            when "10000" =>
					AC <= '0';
					AV <= '0';
					result <= Y;
            
				when "10001" =>
					result <= std_logic_vector(signed(Y) + 1); --reseult first, then check flags
					AC <= (NOT result(15)) AND Y(15); --check carry with add
					AV <= result(15) AND (NOT Y(15)); --check overflow for add
            
				when "10010" =>
					if (CI = '0') then -- no carry in
						result <= std_logic_vector(signed(X) + signed(Y));
               else	--carry in, add 1
						result <= std_logic_vector(signed(X) + signed(Y) + 1);
               end if;
					
					AC <= (X(15) OR Y(15)) AND NOT result(15); --combine carry of x and y and result
					AV <= (NOT X(15)) AND (NOT Y(15)) AND result(15);               
            
				when "10011" =>
               result <= std_logic_vector(signed(X) + signed(Y));
					
               AC <= (X(15) OR Y(15)) AND NOT result(15);
					AV <= (NOT X(15)) AND (NOT Y(15)) AND result(15);
					 
            when "10100" =>
                AC <= '0';
                AV <= '0';
                result <= NOT Y;
					 
            when "10101" =>
				    AC <= '0';
                AV <= '0';
                result <= std_logic_vector(0 - signed(Y)); --only way work
					 
            when "10110" =>
                if (CI = '0') then
                    result <= std_logic_vector(signed(X) - signed(Y) - 1);
                else
                    result <= std_logic_vector(signed(X) - signed(Y));
                end if;

                -- unsigned can only underflow (carry)
                if(unsigned(Y) < unsigned(X)) then
                    AC <= '0';
                else
                    AC <= '1';
                end if;

					 -- signed can have overflow
                if ((signed(X) < 0) AND (signed(Y) >=0)) then  -- oveflow if A < 0
                    AV <= X(15) AND NOT Y(15) AND NOT result(15);
					 elsif ((signed(X) >= 0) AND (signed(Y) < 0)) then  -- overflow if B < 0
                    AV <= NOT X(15) AND Y(15) AND result(15);
                else  -- overflow not possible
                    AV <= '0';
                end if;
					 
            when "10111" =>
                result <= std_logic_vector(signed(X) - signed(Y));
					 
                -- unsigned can only underflow (carry)
                if(unsigned(Y) < unsigned(X)) then
                    AC <= '0';
                else
                    AC <= '1';
                end if;

					 -- signed can have overflow
                if ((signed(X) < 0) AND (signed(Y) >=0)) then  -- oveflow if A < 0
                    AV <= X(15) AND NOT Y(15) AND NOT result(15);
					 elsif ((signed(X) >= 0) AND (signed(Y) < 0)) then  -- overflow if B < 0
                    AV <= NOT X(15) AND Y(15) AND result(15);
                else  -- overflow not possible
                    AV <= '0';
                end if;

            when "11000" =>
                result <= std_logic_vector(signed(Y) - 1);

                if (Y = X"0000") then
                    AC <= '1';
                else
                    AC <= '0';
                end if;

                if (Y = "1000000000000000") then --since signed and msb 1 then overflowed
                    AV <= '1';
                else
                    AV <= '0';
                end if;

            when "11001" =>
                result <= std_logic_vector(signed(Y) - signed(X));
                
                -- unsigned can only underflow (carry)
                if(unsigned(Y) < unsigned(X)) then
                    AC <= '0';
                else
                    AC <= '1';
                end if;

					 -- signed can have overflow
                if ((signed(X) < 0) AND (signed(Y) >=0)) then  -- oveflow if A < 0
                    AV <= X(15) AND NOT Y(15) AND NOT result(15);
					 elsif ((signed(X) >= 0) AND (signed(Y) < 0)) then  -- overflow if B < 0
                    AV <= NOT X(15) AND Y(15) AND result(15);
                else  -- overflow not possible
                    AV <= '0';
                end if;

            when "11010" =>
                if (CI = '0') then
                    result <= std_logic_vector(signed(Y) - signed(X) - 1);
                else
                    result <= std_logic_vector(signed(Y) - signed(X));
                end if;
                
                -- unsigned can only underflow (carry)
                if(unsigned(Y) < unsigned(X)) then
                    AC <= '0';
                else
                    AC <= '1';
                end if;

					 -- signed can have overflow
                if ((signed(X) < 0) AND (signed(Y) >=0)) then  -- oveflow if A < 0
                    AV <= X(15) AND NOT Y(15) AND NOT result(15);
					 elsif ((signed(X) >= 0) AND (signed(Y) < 0)) then  -- overflow if B < 0
                    AV <= NOT X(15) AND Y(15) AND result(15);
                else  -- overflow not possible
                    AV <= '0';
                end if;
					 
            when "11011" =>
					AC <= '0';
               AV <= '0';
               result <= NOT X;
					
            when "11100" =>
					AC <= '0';
               AV <= '0';
               result <= X AND Y;
                
            when "11101" =>
					AC <= '0';
               AV <= '0';
               result <= X OR Y;
                
            when "11110" =>
					AC <= '0';
               AV <= '0';
               result <= X XOR Y;
                
            when "11111" =>
					AC <= '0';
               AV <= '0';
               result <= std_logic_vector(abs(signed(X)));
                
            when others =>
                result <= "0101010101010101";  --pattern will show error in amf
					 
				AC <= '0';
				AV <= '0';
				
        end case;
    end process;

end architecture BehavALUKernel;
