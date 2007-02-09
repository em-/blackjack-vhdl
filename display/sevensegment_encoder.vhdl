library ieee;
use ieee.std_logic_1164.all;

entity sevensegment_encoder is
    port (A: in  std_logic_vector(3 downto 0);
          O: out std_logic_vector(6 downto 0));
end sevensegment_encoder;


architecture behavioral of sevensegment_encoder is
begin
process(A)
begin    
    if    A = "0000" then
        O <= "0000001";
    elsif A = "0001" then
        O <= "1001111";
    elsif A = "0010" then
        O <= "0010010";
    elsif A = "0011" then
        O <= "0000110";
    elsif A = "0100" then
        O <= "1001100";
    elsif A = "0101" then
        O <= "0100100";
    elsif A = "0110" then
        O <= "0100000";
    elsif A = "0111" then
        O <= "0001111";
    elsif A = "1000" then
        O <= "0000000";
    elsif A = "1001" then
        O <= "0000100";
    elsif A = "1010" then
        O <= "0001000";
    elsif A = "1011" then
        O <= "1100000";
    elsif A = "1100" then
        O <= "0110001";
    elsif A = "1101" then
        O <= "1000010";
    elsif A = "1110" then
        O <= "0010000";
    elsif A = "1111" then
        O <= "0111000";
    end if;
end process;
end behavioral;
