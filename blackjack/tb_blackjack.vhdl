library std;
library ieee;

use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all; -- synopsys only
use ieee.numeric_std.all;

entity tb_blackjack is
end tb_blackjack;

architecture test of tb_blackjack is
    signal CLK: std_logic := '0';
    signal Reset, NewGame, Stop, En: std_logic;
    signal DATA_IN: std_logic_vector (7 downto 0);
    signal PLAYER_L, PLAYER_H: std_logic_vector (3 downto 0);
    signal DEALER_L, DEALER_H: std_logic_vector (3 downto 0);
    signal PLAYER_SHOW, DEALER_SHOW: std_logic;
    signal PLAYER_WIN,  DEALER_WIN:  std_logic;
    signal counter: integer := -1;
    signal finished: boolean := false;

    component blackjack
        port (CLK:                      in  std_logic;
              Reset, NewGame, Stop, En: in  std_logic;
              DATA_IN:                    in  std_logic_vector (7 downto 0);
              PLAYER_L, PLAYER_H:         out std_logic_vector (3 downto 0);
              DEALER_L, DEALER_H:         out std_logic_vector (3 downto 0);
              PLAYER_SHOW,  DEALER_SHOW:  out std_logic;
              PLAYER_WIN,   DEALER_WIN:   out std_logic);
    end component;
begin 
    U: blackjack port map (CLK, Reset, NewGame, Stop, En, DATA_IN,
                           PLAYER_L, PLAYER_H,
                           DEALER_L, DEALER_H,
                           PLAYER_SHOW, DEALER_SHOW,
                           PLAYER_WIN,  DEALER_WIN);

clock: process
begin
    CLK <= not CLK;
    if finished then wait; end if;
    wait for 0.5 ns;
end process;

count: process(CLK)
begin
    if rising_edge(CLK) then
        counter <= counter + 1;
    end if;
end process;

test: process
    variable testReset, testNewGame, testStop, testEn: std_logic;
    variable testDATA_IN: integer;
    variable testPLAYER, testDEALER: integer;
    variable testPLAYER_SHOW, testDEALER_SHOW: std_logic;
    variable testPLAYER_WIN,  testDEALER_WIN:  std_logic;
    file test_file: text is in "blackjack/tb_blackjack.test";

    variable l: line;
    variable l_out: line;
    variable t: integer;
    variable good: boolean;
    variable space: character;

    variable enable_debug: boolean := false;
begin
    wait on counter;

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

        read(l, testPLAYER);
        read(l, space);
        read(l, testDEALER);
        read(l, space);

        read(l, testPLAYER_SHOW);
        read(l, testDEALER_SHOW);
        read(l, space);

        read(l, testPLAYER_WIN);
        read(l, testDEALER_WIN);


        Reset   <= testReset;
        NewGame <= testNewGame;
        Stop    <= testStop;
        En      <= testEn;
        DATA_IN <= std_logic_vector(to_unsigned(testDATA_IN, DATA_IN'length));

        while counter /= t loop
            wait on counter;
        end loop;

        if enable_debug then
            write(l_out, string'("PLAYER_SHOW = "));
            write(l_out, PLAYER_SHOW);
            writeline(output, l_out);
            write(l_out, string'("DEALER_L = "));
            write(l_out, DEALER_L);
            writeline(output, l_out);
            write(l_out, string'("testDEALER = "));
            write(l_out, testDEALER);
            writeline(output, l_out);
        end if;

        assert to_integer(to_01(unsigned(PLAYER_L))) = testPLAYER mod 10 report "Mismatch on output PLAYER_L";
        assert to_integer(to_01(unsigned(PLAYER_H))) = testPLAYER / 10   report "Mismatch on output PLAYER_H";
        assert to_integer(to_01(unsigned(DEALER_L))) = testDEALER mod 10 report "Mismatch on output DEALER_L";
        assert to_integer(to_01(unsigned(DEALER_H))) = testDEALER / 10   report "Mismatch on output DEALER_H";
        assert PLAYER_SHOW = testPLAYER_SHOW report "Mismatch on output PLAYER_SHOW";
        assert DEALER_SHOW = testDEALER_SHOW report "Mismatch on output DEALER_SHOW";
        assert PLAYER_WIN  = testPLAYER_WIN  report "Mismatch on output PLAYER_WIN";
        assert DEALER_WIN  = testDEALER_WIN  report "Mismatch on output DEALER_WIN";
    end loop;

    finished <= true;
    wait;
end process;

end test;
