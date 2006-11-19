library ieee; 
use ieee.std_logic_1164.all; 

entity mux41_1bit is
    port (A, B, C, D: in  std_logic;
          SEL:  in  std_logic_vector(1 downto 0);
          O:    out std_logic);
end mux41_1bit;

architecture behavioral of mux41_1bit is
begin
process (A, B, C, D, SEL)
begin
    if    SEL = "00" then
        O <= A;
    elsif SEL = "01" then
        O <= B;
    elsif SEL = "10" then
        O <= C;
    elsif SEL = "11" then
        O <= D;
    end if;
end process;
end behavioral;
