library ieee;
use ieee.std_logic_1164.all;

entity ft is
    port (CLK, RST: in  std_logic;
          T:        in  std_logic;
          Q:        out std_logic);
end ft;

architecture behavioral of ft is
begin

process (CLK, RST)
    variable d: std_logic;
begin
    if RST = '0' then
        d := '0';
    elsif CLK'event and CLK = '1' then
        if T = '1' then
            d := not d;
        else
            d := d;
        end if;
    end if;
    Q <= d;
end process;
end behavioral;
