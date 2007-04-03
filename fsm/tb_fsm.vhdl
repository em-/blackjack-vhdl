library std;
library ieee;

use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all; -- synopsys only

entity tb_fsm is
end tb_fsm;

architecture test of tb_fsm is
    signal CLK, RST: std_logic := '0';
    signal NewGame, En, Stop, Bust, Win: std_logic;
    signal ShowPlayer, ShowDealer, PlayerWin, DealerWin: std_logic;
    signal PlayerRead, DealerRead: std_logic;
    signal Clear: std_logic;
    signal counter: integer := -1;
    signal finished: boolean := false;

    component fsm
        port (CLK, RST:  in  std_logic;
              NewGame, En, Stop, Bust, Win: in std_logic;
              ShowPlayer, ShowDealer, PlayerWin, DealerWin: out std_logic;
              PlayerRead, DealerRead: out std_logic;
              Clear: out std_logic);
    end component;
begin 
    U: fsm port map (CLK, RST, NewGame, En, Stop, Bust, Win, 
                     ShowPlayer, ShowDealer, PlayerWin, DealerWin,
                     PlayerRead, DealerRead, Clear);

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
    variable testRST: std_logic;
    variable testA, testO: std_logic_vector(2 downto 0);
    variable testNewGame, testEn, testStop, testBust, testWin: std_logic;
    variable testShowPlayer, testShowDealer: std_logic;
    variable testPlayerWin, testDealerWin: std_logic;
    variable testPlayerRead, testDealerRead: std_logic;
    variable testClear: std_logic;
    file test_file: text is in "fsm/tb_fsm.test";

    variable l: line;
    variable l_out: line;
    variable t: integer;
    variable good: boolean;
    variable space: character;
begin
    wait on counter;

    while not endfile(test_file) loop
        readline(test_file, l);

        -- read the time from the beginning of the line
        -- skip the line if it doesn't start with an integer
        read(l, t, good => good);
        next when not good;

        read(l, space);

        read(l, testRST);
        read(l, space);

        read(l, testNewGame);
        read(l, testEn);
        read(l, testStop);
        read(l, testBust);
        read(l, testWin);
        read(l, space);

        read(l, testShowPlayer);
        read(l, testShowDealer);
        read(l, testPlayerWin);
        read(l, testDealerWin);
        read(l, testPlayerRead);
        read(l, testDealerRead);

        read(l, space);
        read(l, testClear);

        RST <= testRST;
        NewGame <= testNewGame;
        En   <= testEn;
        Stop <= testStop;
        Bust <= testBust;
        Win  <= testWin;

        while counter /= t loop
            wait on counter;
        end loop;

        assert ShowPlayer = testShowPlayer report "Mismatch on output ShowPlayer";
        assert ShowDealer = testShowDealer report "Mismatch on output ShowDealer";
        assert PlayerWin  = testPlayerWin  report "Mismatch on output PlayerWin";
        assert DealerWin  = testDealerWin  report "Mismatch on output DealerWin";
        assert PlayerRead = testPlayerRead report "Mismatch on output PlayerRead";
        assert DealerRead = testDealerRead report "Mismatch on output DealerRead";
        assert Clear      = testClear      report "Mismatch on output Clear";
    end loop;

    finished <= true;
    wait;
end process;

end test;
