library std;
library ieee;

use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all; -- synopsys only

entity tb_mux41_1bit is
end tb_mux41_1bit;

architecture test of tb_mux41_1bit is
    signal A, B, C, D, O: std_logic;
    signal SEL: std_logic_vector(1 downto 0);

	component mux41_1bit
        port (A, B, C, D: in  std_logic;
              SEL:  in  std_logic_vector(1 downto 0);
              O:    out std_logic);
	end component;

begin 
	U: mux41_1bit port map (A, B, C, D, SEL, O);

test: process
    variable testA, testB, testC, testD, testO: std_logic;
    variable testSEL: std_logic_vector(1 downto 0);
    file test_file: text is in "mux41/tb_mux41_1bit.test";

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

        read(l, testA);
        read(l, testB);
        read(l, testC);
        read(l, testD);
        read(l, space);

        read(l, testSEL);
        read(l, space);

        read(l, testO);

        A <= testA;
        B <= testB;
        C <= testC;
        D <= testD;
        SEL <= testSEL;

        t := i * 1 ns;  -- convert an integer to time
        if (now < t) then
            wait for t - now;
        end if;
        
        assert O = testO report "Mismatch on output O";
    end loop;

    assert false report "Finished" severity note;
    wait;
end process;

end test;
