library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seven_segment_dot is
    port(I:   in  std_logic_vector(7 downto 0);
         O:   out natural;
         DOT: out boolean);
end seven_segment_dot;

architecture behavioral of seven_segment_dot is
begin

process(I)
begin    
    if    I(6 downto 0) = "1111110" then
        O <= 0;
    elsif I(6 downto 0) = "0110000" then
        O <= 1;
    elsif I(6 downto 0) = "1101101" then
        O <= 2;
    elsif I(6 downto 0) = "1111001" then
        O <= 3;
    elsif I(6 downto 0) = "0110011" then
        O <= 4;
    elsif I(6 downto 0) = "1011011" then
        O <= 5;
    elsif I(6 downto 0) = "1011111" then
        O <= 6;
    elsif I(6 downto 0) = "1110000" then
        O <= 7;
    elsif I(6 downto 0) = "1111111" then
        O <= 8;
    elsif I(6 downto 0) = "1111011" then
        O <= 9;
    end if;
end process;

process(I)
begin
    if I(7) = '1' then
        DOT <= true;
    else
        DOT <= false;
    end if;
end process;
end behavioral;
