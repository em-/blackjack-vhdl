library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity bcd_encoder is
    port (I:    in  std_logic_vector(7 downto 0);
          H, L: out std_logic_vector(3 downto 0));
end bcd_encoder;


-- WARNING: This architecture is limited to numbers smaller than 39!
architecture naive_behavioral of bcd_encoder is
begin
process(I)
    variable vI, t: unsigned(7 downto 0);
begin
    vI := unsigned(I);
    if vI >= 30 then
        H <= "0011";
        t := vI - 30;
    elsif vI >= 20 then
        H <= "0010";
        t := vI - 20;
    elsif vI >= 10 then
        H <= "0001";
        t := vI - 10;
    else
        H <= "0000";
        t := vI - 0;
    end if;
    L <= std_logic_vector(t(3 downto 0));
end process;
end naive_behavioral;
