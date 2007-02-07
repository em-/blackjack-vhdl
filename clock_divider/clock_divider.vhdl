library ieee; 
use ieee.std_logic_1164.all; 

entity clock_divider is 
    generic (N: integer := 8);
    
    port (CLK, RST:  in  std_logic;
          O:         out std_logic);
end clock_divider;

architecture behavioral of clock_divider is  
    signal output: std_logic;
begin

O <= output;

process (RST, CLK)
	variable count : integer range 0 to N;
begin
    if RST = '0' then
		count := 0;
		output <= '0';
	elsif (CLK'event) then
		if (count = (N-1)) then 
			count := 0;
			output <= not output;
		else
			count := count + 1;
		end if;
	end if;
end process;
end behavioral;
