library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity input_encoder is
    port (I: in  std_logic_vector(2 downto 0);
          O: out std_logic_vector(3 downto 0));
end input_encoder;

architecture behavioral of input_encoder is
begin
process(I)
begin
    if I = "000" then
        O <= "1000";
    else
        O <= '0' & I;
    end if;
end process;
end behavioral;
