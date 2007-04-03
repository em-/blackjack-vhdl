library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator is 
    generic(N: integer := 8);
    port(A, B: in  std_logic_vector (N-1 downto 0);
         O:    out std_logic_vector (0 to 1));
end comparator;

architecture behavorial of comparator is
begin
    process(A, B)
    begin
        -- This could be rewritten as:
        --  O (0) <= '1' when (A > B) else
        --           '0';
        -- but ghdl doesn't seems to handle the "when" syntax
        if A > B then
            O(0) <= '1';
        else
            O(0) <= '0';
        end if;

        if B > A then
            O(1) <= '1';
        else
            O(1) <= '0';
        end if;
    end process;
end behavorial;

