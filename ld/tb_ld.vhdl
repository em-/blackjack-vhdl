library std;
library ieee;

use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all; -- synopsys only

entity tb_ld is
end tb_ld;

architecture test of tb_ld is
    signal CLK, RST: std_logic := '0';
    signal EN, D: std_logic;
    signal Q: std_logic;
    signal counter: integer := -1;
	
	component ld port (
        CLK, RST: in  std_logic;
        EN:       in  std_logic;
        D:        in  std_logic;
        Q:        out std_logic);
	end component;

begin 
	U: ld port map (CLK, RST, EN, D, Q);

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
    variable testRST, testEN, testD, testQ: std_logic;
    file test_file: text is in "ld/tb_ld.test";

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
        read(l, testEN);
        read(l, testD);

        read(l, space);

        read(l, testQ);

        while counter /= t loop
            wait on counter;
        end loop;

        RST <= testRST;
        EN <= testEN;
        D <= testD;

        assert Q = testQ report "Mismatch on output Q";
    end loop;

    assert false report "Finished" severity note;
    wait;
end process;

end test;
