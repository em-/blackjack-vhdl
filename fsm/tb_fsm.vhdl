library std;
library ieee;

use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all; -- synopsys only

entity tb_fsm is
end tb_fsm;

architecture test of tb_fsm is
    signal CLK, RST: std_logic := '0';
    signal NewGame, Stop, Bust, Win: std_logic;
    signal ShowPlayer, ShowDealer, PlayerWin, DealerWin: std_logic;
    signal PlayerTurn, DealerTurn: std_logic;
    signal counter: integer := -1;
	
    component fsm
        port (CLK, RST:  in  std_logic;
              NewGame, Stop, Bust, Win: in std_logic;
              ShowPlayer, ShowDealer, PlayerWin, DealerWin: out std_logic;
              PlayerTurn, DealerTurn: out std_logic);
	end component;
begin 
	U: fsm port map (CLK, RST, NewGame, Stop, Bust, Win, 
                     ShowPlayer, ShowDealer, PlayerWin, DealerWin,
                     PlayerTurn, DealerTurn);

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
    variable testRST: std_logic;
    variable testA, testO: std_logic_vector(2 downto 0);
    variable testNewGame, testStop, testBust, testWin: std_logic;
    variable testShowPlayer, testShowDealer: std_logic;
    variable testPlayerWin, testDealerWin: std_logic;
    variable testPlayerTurn, testDealerTurn: std_logic;
    file test_file: text is in "fsm/tb_fsm.test";

    variable l: line;
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
        read(l, testStop);
        read(l, testBust);
        read(l, testWin);
        read(l, space);

        read(l, testShowPlayer);
        read(l, testShowDealer);
        read(l, testPlayerWin);
        read(l, testDealerWin);
        read(l, testPlayerTurn);
        read(l, testDealerTurn);

        RST <= testRST;
        NewGame <= testNewGame;
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
        assert PlayerTurn = testPlayerTurn report "Mismatch on output PlayerTurn";
        assert DealerTurn = testDealerTurn report "Mismatch on output DealerTurn";
    end loop;

    assert false report "Finished" severity note;
    wait;
end process;

end test;
