library std;
library ieee;

use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all; -- synopsys only

entity tb_mux41 is
end tb_mux41;

architecture test of tb_mux41 is
    signal A, B, C, D, O: std_logic_vector(1 downto 0);
    signal SEL: std_logic_vector(1 downto 0);

	component mux41
        generic (N: integer := 8);
        
        port (A, B, C, D: in  std_logic_vector (N-1 downto 0);
              SEL:  in  std_logic_vector(1 downto 0);
              O:    out std_logic_vector (N-1 downto 0) );
	end component;

begin 
	U: mux41 generic map(2) port map (A, B, C, D, SEL, O);

test: process
    variable testA, testB, testC, testD, testO: std_logic_vector(1 downto 0);
    variable testSEL: std_logic_vector(1 downto 0);
    file test_file: text is in "mux41/tb_mux41.test";

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
        read(l, space);

        read(l, testB);
        read(l, space);

        read(l, testC);
        read(l, space);

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
