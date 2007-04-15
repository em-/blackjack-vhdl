library std;
library ieee;

use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all; -- synopsys only
use ieee.std_logic_arith.all;  -- synopsys only

entity tb_board is
end tb_board;

architecture test of tb_board is
    signal CLK: std_logic := '0';
    signal Reset, NewGame, Stop, En: std_logic;
    signal DATA_IN: std_logic_vector (2 downto 0);

    type character_vector is array(natural range <>) of character;
    type boolean_vector is array(natural range <>) of boolean;

    signal DIGIT: std_logic_vector (7 downto 0);
    signal AN:    std_logic_vector (3 downto 0);

    signal DIGITS: character_vector (3 downto 0);
    signal DOTS:   boolean_vector (3 downto 0);

    signal clock_counter: integer := -1;
    signal finished: boolean := false;

    component board
        generic (GAME_CLK_DIV: integer := 1000;
                 DISP_CLK_DIV: integer := 1000000);
        port (CLK:                      in  std_logic;
              Reset, NewGame, Stop, En: in  std_logic;
              DATA_IN: in  std_logic_vector (2 downto 0);
              OUTPUT:  out std_logic_vector (7 downto 0);
              AN:      out std_logic_vector (3 downto 0));
    end component;

    component display_simulator
        port(E14, G13, N15, P15, R16, F13, N16: in std_logic;
             P16:                               in std_logic;
             E13, F14, G14, D14:                in std_logic;

             DIGITS_0, DIGITS_1, DIGITS_2, DIGITS_3: out character;
             DOTS_0,   DOTS_1,   DOTS_2,   DOTS_3:   out boolean);
    end component;

begin 
    U: board
        generic map (2, 2)
        port map (CLK, Reset, NewGame, Stop, En, DATA_IN, DIGIT, AN);

    simul: display_simulator 
             port map (DIGIT(7), DIGIT(6), DIGIT(5), DIGIT(4), 
                       DIGIT(3), DIGIT(2), DIGIT(1),
                       DIGIT(0),
                       AN(3), AN(2), AN(1), AN(0),
                       DIGITS(3), DIGITS(2), DIGITS(1), DIGITS(0),
                       DOTS(3),   DOTS(2),   DOTS(1),   DOTS(0));

clock: process
begin
    CLK <= not CLK;
    if finished then wait; end if;
    wait for 0.5 ns;
end process;

count: process(CLK)
begin
    if rising_edge(CLK) then
        clock_counter <= clock_counter + 1;
    end if;
end process;

test: process
    variable testReset, testNewGame, testStop, testEn: std_logic;
    variable testDATA_IN: integer;

    variable testDIGITS: character_vector (3 downto 0);
    variable testDOTS:   boolean_vector (3 downto 0);

    file test_file: text is in "board/tb_board.test";

    variable l: line;
    variable t: integer;
    variable good: boolean;
    variable space: character;

    variable enable_debug: boolean := false;
    variable l_out: line;
begin
    wait on clock_counter;

    while not endfile(test_file) loop
        readline(test_file, l);

        -- read the time from the beginning of the line
        -- skip the line if it doesn't start with an integer
        read(l, t, good => good);
        next when not good;

        read(l, space);

        read(l, testReset);
        read(l, testNewGame);
        read(l, testStop);
        read(l, testEn);
        read(l, space);

        read(l, testDATA_IN);
        read(l, space);

        read(l, testDIGITS(3));
        read(l, testDIGITS(2));
        read(l, testDIGITS(1));
        read(l, testDIGITS(0));
        read(l, space);

        read(l, testDOTS(3));
        read(l, testDOTS(2));
        read(l, testDOTS(1));
        read(l, testDOTS(0));

        Reset   <= testReset;
        NewGame <= testNewGame;
        Stop    <= testStop;
        En      <= testEn;
        DATA_IN <= conv_std_logic_vector(testDATA_IN, DATA_IN'length);

        while clock_counter /= t*1000 loop
            wait on clock_counter;
        end loop;

        if enable_debug then
            write(l_out, string'("(tb_board: "));
            write(l_out, now);
            write(l_out, string'(") "));
            write(l_out, string'("DIGITS = "));
            write(l_out, DIGITS(3));
            write(l_out, string'(" "));
            write(l_out, DIGITS(2));
            write(l_out, string'(" "));
            write(l_out, DIGITS(1));
            write(l_out, string'(" "));
            write(l_out, DIGITS(0));
            write(l_out, string'(", DOTS = "));
            write(l_out, DOTS(3));
            write(l_out, string'(" "));
            write(l_out, DOTS(2));
            write(l_out, string'(" "));
            write(l_out, DOTS(1));
            write(l_out, string'(" "));
            write(l_out, DOTS(0));
            write(l_out, string'(", AN = "));
            write(l_out, AN);
            writeline(output, l_out);
        end if;
        assert DIGITS(3) = testDIGITS(3)
                report "Mismatch on output DIGITS(3)";
        assert DIGITS(2) = testDIGITS(2)
                report "Mismatch on output DIGITS(2)";
        assert DIGITS(1) = testDIGITS(1)
                report "Mismatch on output DIGITS(1)";
        assert DIGITS(0) = testDIGITS(0)
                report "Mismatch on output DIGITS(0)";
        assert DOTS(3)   = testDOTS(3)
                report "Mismatch on output DOTS(3)";
        assert DOTS(2)   = testDOTS(2)
                report "Mismatch on output DOTS(2)";
        assert DOTS(1)   = testDOTS(1)
                report "Mismatch on output DOTS(1)";
        assert DOTS(0)   = testDOTS(0)
                report "Mismatch on output DOTS(0)";
    end loop;

    finished <= true;
    wait;
end process;

end test;
