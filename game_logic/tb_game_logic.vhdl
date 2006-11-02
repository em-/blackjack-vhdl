library std;
library ieee;

use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all; -- synopsys only

entity tb_game_logic is
end tb_game_logic;

architecture test of tb_game_logic is
    signal PLAYER, DEALER: std_logic_vector (7 downto 0) := "00000000";
    signal WIN, BUST:      std_logic;

    component game_logic
        port (PLAYER, DEALER: in  std_logic_vector (7 downto 0);
              WIN, BUST:      out std_logic);
    end component;
begin 
	U: game_logic port map (PLAYER, DEALER, WIN, BUST);

test: process
    variable testPLAYER, testDEALER: std_logic_vector (7 downto 0);
    variable testWIN, testBUST:      std_logic;
    file test_file: text is in "game_logic/tb_game_logic.test";

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

        read(l, testPLAYER);
        read(l, space);
        read(l, testDEALER);
        read(l, space);

        read(l, testWIN);
        read(l, space);
        read(l, testBUST);

        PLAYER <= testPLAYER;
        DEALER <= testDEALER;

        t := i * 1 ns;  -- convert an integer to time
        if (now < t) then
            wait for t - now;
        end if;

        assert WIN  = testWIN  report "Mismatch on output WIN";
        assert BUST = testBUST report "Mismatch on output BUST";
    end loop;

    assert false report "Finished" severity note;
    wait;
end process;

end test;
