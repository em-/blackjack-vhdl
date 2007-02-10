-- Adapted from the example in the comp.lang.vhdl FAQ

library ieee; 
use ieee.std_logic_1164.all; 

entity clock_divider is
    generic (MODULUS: in positive range 2 to integer'high := 4);

    port (CLK, RST:  in  std_logic;
          O:         out std_logic);
end clock_divider;

architecture behavioral of clock_divider is
begin
process (CLK, RST)
    variable count: natural range 0 to MODULUS-1;
begin
    if RST = '0' then
        count := 0;
        O <= '0';
    elsif rising_edge(CLK) then
        if count = MODULUS-1 then
            count := 0;
        else
            count := count + 1;
        end if;
        if count >= MODULUS/2 then
            O <= '0';
        else
            O <= '1';
        end if;
    end if;
end process;
end behavioral;
