library std;
library ieee;

use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all; -- synopsys only

entity tb_blackjack is
end tb_blackjack;

architecture test of tb_blackjack is
    signal CLK: std_logic := '0';
    signal Reset, NewGame, Stop, En: std_logic;
    signal DATA_IN: integer;
    signal PLAYER, DEALER: integer;
    signal counter: integer := -1;

    component blackjack
        port (CLK:                      in  std_logic;
              Reset, NewGame, Stop, En: in  std_logic;
              DATA_IN:                  in  integer; 
              PLAYER_SCORE, DEALER_SCORE: out integer);
    end component;
begin 
	U: blackjack port map (CLK, Reset, NewGame, Stop, En, DATA_IN,
                           PLAYER, DEALER);

clock: process
begin
    CLK <= not CLK;
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

        Reset   <= testReset;
        NewGame <= testNewGame;
        Stop    <= testStop;
        En      <= testEn;
        DATA_IN <= testDATA_IN;

        while counter /= t loop
            wait on counter;
        end loop;

        if enable_debug then
            write(l_out, string'("PLAYER = "));
            write(l_out, PLAYER);
            writeline(output, l_out);
            write(l_out, string'("DEALER = "));
            write(l_out, DEALER);
            writeline(output, l_out);
        end if;

        assert PLAYER = testPLAYER report "Mismatch on output PLAYER";
        assert DEALER = testDEALER report "Mismatch on output DEALER";
    end loop;

    assert false report "Finished" severity note;
    wait;
end process;

end test;
