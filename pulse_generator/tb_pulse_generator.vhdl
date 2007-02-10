library std;
library ieee;

use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all; -- synopsys only

entity tb_pulse_generator is
end tb_pulse_generator;

architecture test of tb_pulse_generator is
    signal CLK, RST: std_logic := '0';
    signal I, O: std_logic;
    signal counter: integer := -1;
	
	component pulse_generator port (
        CLK, RST: in  std_logic;
        I:        in  std_logic;
        O:        out std_logic);
	end component;

begin 
	U: pulse_generator port map (CLK, RST, I, O);

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
    variable testRST, testI, testO: std_logic;
    file test_file: text is in "pulse_generator/tb_pulse_generator.test";

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
        read(l, testI);

        read(l, space);

        read(l, testO);

        while counter /= t loop
            wait on counter;
        end loop;

        RST <= testRST;
        I <= testI;

        assert O = testO report "Mismatch on output O";
    end loop;

    assert false report "Finished" severity note;
    wait;
end process;

end test;
