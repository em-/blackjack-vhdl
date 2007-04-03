library std;
library ieee;

use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all; -- synopsys only

entity tb_fa is
end tb_fa;

architecture test of tb_fa is
    signal A: std_logic := '0';
    signal B: std_logic := '0';
    signal Ci: std_logic;
    signal S: std_logic;
    signal Co: std_logic;
    
    component fa port (
        A, B, Ci: in std_logic;
        S, Co: out std_logic);
    end component;

begin 
    U: fa port map (A, B, Ci, S, Co);

test: process
    variable testA, testB, testCi, testS, testCo: std_logic;
    file test_file: text is in "fa/tb_fa.test";

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

        read(l, testA);
        read(l, testB);
        read(l, testCi);
        read(l, testS);
        read(l, testCo);

        A <= testA;
        B <= testB;
        Ci <= testCi;
        S <= testS;
        Co <= testCo;

        t := i * 1 ns;  -- convert an integer to time
        if (now < t) then
            wait for t - now;
        end if;
        
        assert S = testS report "Mismatch on output S";
        assert Co = testCo report "Mismatch on output Co";
    end loop;

    wait;
end process;

end test;
