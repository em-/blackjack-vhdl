library ieee; 
use ieee.std_logic_1164.all; 

entity clock_divider is 
    generic (N: integer := 8);
    
    port (CLK, RST:  in  std_logic;
          O:         out std_logic);
end clock_divider;

architecture behavioral of clock_divider is  
begin
process (RST, CLK)
	variable count : integer range 0 to N;
begin
    if RST = '0' then
		count := 0;
		O <= '0';
	elsif (rising_edge(CLK)) then
		if (count = (N-1)) then 
			count := 0;
			O <= '1';
		else
			count := count + 1;
			O <= '0';
		end if;
	end if;
end process;
end behavioral;
