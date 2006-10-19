library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vectors.all;

entity display is
    port(DIGIT:  in std_logic_vector (6 downto 0);
         DOT:    in std_logic;
         AN:     in std_logic_vector (3 downto 0);

         DIGITS: out natural_vector (0 to 3);
         DOTS:   out boolean_vector (0 to 3) );
end display;


architecture structural of display is
    component seven_segment_dot is
        port(I:   in  std_logic_vector(7 downto 0);
             O:   out natural;
             DOT: out boolean);
    end component;

    type connection is array(natural range <>) of std_logic_vector(7 downto 0);

    signal input: connection(0 to 3);
begin

s: for i in 3 downto 0 generate
    s_i: seven_segment_dot port map (input(i), DIGITS(i), DOTS(i));
end generate;

process(DIGIT, DOT, AN)
begin
    if AN(0) = '0' then
        input(0) <= DOT & DIGIT;
    end if;

    if AN(1) = '0' then
        input(1) <= DOT & DIGIT;
    end if;

    if AN(2) = '0' then
        input(2) <= DOT & DIGIT;
    end if;

    if AN(3) = '0' then
        input(3) <= DOT & DIGIT;
    end if;
end process;
end structural;
