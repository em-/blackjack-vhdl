library std;
library ieee;

use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all; -- synopsys only

entity tb_display_simulator is
end tb_display_simulator;

architecture test of tb_display_simulator is
    signal E14, G13, N15, P15, R16, F13, N16: std_logic;
    signal P16:                               std_logic;
    signal E13, F14, G14, D14:                std_logic;

    type character_vector is array(natural range <>) of character;
    type boolean_vector is array(natural range <>) of boolean;

    signal DIGITS: character_vector (0 to 3);
    signal DOTS:   boolean_vector (0 to 3);

	component display_simulator
        port(E14, G13, N15, P15, R16, F13, N16: in std_logic;
             P16:                               in std_logic;
             E13, F14, G14, D14:                in std_logic;

             DIGITS_0, DIGITS_1, DIGITS_2, DIGITS_3: out character;
             DOTS_0,   DOTS_1,   DOTS_2,   DOTS_3:   out boolean);
	end component;

begin 
	U: display_simulator port map (E14, G13, N15, P15, R16, F13, N16, 
                         P16, E13, F14, G14, D14,
                         DIGITS(0), DIGITS(1), DIGITS(2), DIGITS(3),
                         DOTS(0),   DOTS(1),   DOTS(2),   DOTS(3));

test: process
    variable testDIGIT:  std_logic_vector (6 downto 0);
    variable testDOT:    std_logic;
    variable testAN:     std_logic_vector (3 downto 0);

    variable testDIGITS: character_vector (3 downto 0);
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
        read(l, space);
            
        read(l, testDIGITS(0));
        read(l, testDIGITS(1));
        read(l, testDIGITS(2));
        read(l, testDIGITS(3));
        read(l, space);

        read(l, testDOTS(0));
        read(l, testDOTS(1));
        read(l, testDOTS(2));
        read(l, testDOTS(3));

        E14 <= testDIGIT(6);
        G13 <= testDIGIT(5);
        N15 <= testDIGIT(4);
        P15 <= testDIGIT(3);
        R16 <= testDIGIT(2);
        F13 <= testDIGIT(1);
        N16 <= testDIGIT(0);

        P16 <= testDOT;
        E13 <= testAN(3);
        F14 <= testAN(2);
        G14 <= testAN(1);
        D14 <= testAN(0);

        t := i * 1 ns;  -- convert an integer to time
        if (now < t) then
            wait for t - now;
        end if;

        assert DIGITS = testDIGITS report "Mismatch on output DIGITS";
        assert DOTS   = testDOTS report "Mismatch on output DOTS";
    end loop;

    wait;
end process;

end test;
