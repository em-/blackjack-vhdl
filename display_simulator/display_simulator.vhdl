library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_simulator is
    port(E14, G13, N15, P15, R16, F13, N16: in std_logic; -- display
         P16:                               in std_logic; -- DP
         E13, F14, G14, D14:                in std_logic; -- AN(3 downto 0)
        
         DIGITS_0, DIGITS_1, DIGITS_2, DIGITS_3: out natural;
         DOTS_0,   DOTS_1,   DOTS_2,   DOTS_3:   out boolean);
end display_simulator;


architecture structural of display_simulator is
    component seven_segment_dot is
        port(I:   in  std_logic_vector(7 downto 0);
             O:   out natural;
             DOT: out boolean);
    end component;

    type connection is array(natural range <>) of std_logic_vector(7 downto 0);

    signal input: connection(0 to 3);

    signal DIGIT: std_logic_vector (6 downto 0);
    signal DOT:   std_logic;
    signal AN:    std_logic_vector (3 downto 0);
begin

s_0: seven_segment_dot port map (input(0), DIGITS_0, DOTS_0);
s_1: seven_segment_dot port map (input(1), DIGITS_1, DOTS_1);
s_2: seven_segment_dot port map (input(2), DIGITS_2, DOTS_2);
s_3: seven_segment_dot port map (input(3), DIGITS_3, DOTS_3);

DIGIT <= E14 & G13 & N15 & P15 & R16 & F13 & N16;
DOT <= P16;
AN <= E13 & F14 & G14 & D14;

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
