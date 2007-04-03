library std;
library ieee;

use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all; -- synopsys only

entity tb_and2 is
end tb_and2;

architecture test of tb_and2 is
    signal A: std_logic := '0';
    signal B: std_logic := '0';
    signal O: std_logic;
    
    component and2 port (
        A, B: in std_logic;
        O: out std_logic);
    end component;

begin 
    U: and2 port map (A, B, O);

test: process
    variable testA, testB, testO: std_logic;
    file test_file: text is in "and2/tb_and2.test";

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

        read(l, space); -- skip a space

        read(l, testA);  -- read A value
        read(l, testB);  -- read B value
        read(l, testO);  -- read O value

        A <= testA;
        B <= testB;

        t := i * 1 ns;  -- convert an integer to time
        if (now < t) then
            wait for t - now;
        end if;
        
        assert O = testO report "Mismatch on output O";
    end loop;

    wait;
end process;

end test;
