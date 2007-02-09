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
    if    I(6 downto 0) = "0000001" then
        O <= 0;
    elsif I(6 downto 0) = "1001111" then
        O <= 1;
    elsif I(6 downto 0) = "0010010" then
        O <= 2;
    elsif I(6 downto 0) = "0000110" then
        O <= 3;
    elsif I(6 downto 0) = "1001100" then
        O <= 4;
    elsif I(6 downto 0) = "0100100" then
        O <= 5;
    elsif I(6 downto 0) = "0100000" then
        O <= 6;
    elsif I(6 downto 0) = "0001111" then
        O <= 7;
    elsif I(6 downto 0) = "0000000" then
        O <= 8;
    elsif I(6 downto 0) = "0000100" then
        O <= 9;
    end if;
end process;

process(I)
begin
    if I(7) = '0' then
        DOT <= true;
    else
        DOT <= false;
    end if;
end process;
end behavioral;
