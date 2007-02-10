library std;
library ieee;

use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all; -- synopsys only

entity tb_clock_divider is
end tb_clock_divider;

architecture test of tb_clock_divider is
    signal CLK, RST: std_logic := '0';
    signal O: std_logic;
    signal counter: integer := -1;
    signal finished: boolean := false;

	component clock_divider 
        generic (MODULUS: in positive range 2 to integer'high := 4);
        port (
            CLK, RST: in  std_logic;
            O:        out std_logic);
	end component;

begin 
	U: clock_divider port map (CLK, RST, O);

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
    variable testRST, testEN: std_logic;
    variable testO: std_logic;
    file test_file: text is in "clock_divider/tb_clock_divider.test";

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
        read(l, testO);

        while counter /= t loop
            wait on counter;
        end loop;

        RST <= testRST;

        assert O = testO report "Mismatch on output O";
    end loop;

    finished <= true;
    wait;
end process;

end test;
