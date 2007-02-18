library ieee; 
use ieee.std_logic_1164.all; 

entity pulse_generator is
    port (CLK: in  std_logic;
          I:   in  std_logic;
          O:   out std_logic);
end pulse_generator;

architecture behavioral of pulse_generator is
begin
process (CLK)
    variable old: std_logic := '0';
begin
    if rising_edge(CLK) then
        if old = '0' and I = '1' then
            O <= '1';
        else
            O <= '0';
        end if;
        
        old := I;
    end if;
end process;
end behavioral;
