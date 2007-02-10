library ieee; 
use ieee.std_logic_1164.all; 

entity pulse_generator is
    port (CLK, RST: in  std_logic;
          I:        in  std_logic;
          O:        out std_logic);
end pulse_generator;

architecture behavioral of pulse_generator is
begin
process (CLK, RST)
    variable old: std_logic;
begin
    if RST = '0' then
        old := '0';
        O <= '0';
    elsif rising_edge(CLK) then
        if old = '0' and I = '1' then
            O <= '1';
        else
            O <= '0';
        end if;
        
        old := I;
    end if;
end process;
end behavioral;
