library ieee; 
use ieee.std_logic_1164.all; 

entity ld is
    port (CLK, RST: in  std_logic;
          EN:       in  std_logic;
          D:        in  std_logic;
          Q:        out std_logic);
end ld;

architecture behavioral of ld is
begin
process (CLK, RST, D)
begin
    if RST = '0' then
        Q <= '0';
    elsif CLK = '0' then
        if EN = '0' then
            Q <= D;
        end if;
    end if;
end process;
end behavioral;
