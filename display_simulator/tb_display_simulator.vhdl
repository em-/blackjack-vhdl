library std;
library ieee;

use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all; -- synopsys only

entity tb_display_simulator is
end tb_display_simulator;

architecture test of tb_display_simulator is
    signal DIGIT:  std_logic_vector (6 downto 0);
    signal DOT:    std_logic;
    signal AN:     std_logic_vector (3 downto 0);

    type natural_vector is array(natural range <>) of natural;
    type boolean_vector is array(natural range <>) of boolean;

    signal DIGITS: natural_vector (0 to 3);
    signal DOTS:   boolean_vector (0 to 3);

	component display_simulator
        port(DIGIT:  in std_logic_vector (6 downto 0);
             DOT:    in std_logic;
             AN:     in std_logic_vector (3 downto 0);

             DIGITS_0, DIGITS_1, DIGITS_2, DIGITS_3: out natural;
             DOTS_0,   DOTS_1,   DOTS_2,   DOTS_3:   out boolean);
	end component;

begin 
	U: display_simulator port map (DIGIT, DOT, AN,
                         DIGITS(0), DIGITS(1), DIGITS(2), DIGITS(3),
                         DOTS(0),   DOTS(1),   DOTS(2),   DOTS(3));

test: process
    variable testDIGIT:  std_logic_vector (6 downto 0);
    variable testDOT:    std_logic;
    variable testAN:     std_logic_vector (3 downto 0);

    variable testDIGITS: natural_vector (3 downto 0);
    variable testDOTS:   boolean_vector (3 downto 0);

    file test_file: text is in "display_simulator/tb_display_simulator.test";

    variable l: line;
    variable t: time;
    variable i: integer;
    variable good: boolean;
    variable space: character;
begin
    while not endfile(test_file) loop
        readline(test_file, l);

        -- read the time from the beginning of the line
        -- skip the line if it doesn't start with an integer
        read(l, i, good => good);
        next when not good;

        read(l, space);

        read(l, testDIGIT);
        read(l, space);
        read(l, testDOT);
        read(l, testAN);
            
        read(l, testDIGITS(0));
        read(l, testDIGITS(1));
        read(l, testDIGITS(2));
        read(l, testDIGITS(3));

        read(l, testDOTS(0));
        read(l, testDOTS(1));
        read(l, testDOTS(2));
        read(l, testDOTS(3));

        DIGIT <= testDIGIT;
        DOT   <= testDOT;
        AN    <= testAN;

        t := i * 1 ns;  -- convert an integer to time
        if (now < t) then
            wait for t - now;
        end if;
        
        assert DIGITS = testDIGITS report "Mismatch on output DIGITS";
        assert DOTS   = testDOTS report "Mismatch on output DOTS";
    end loop;

    assert false report "Finished" severity note;
    wait;
end process;

end test;
