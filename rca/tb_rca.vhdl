library std;
library ieee;

use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all; -- synopsys only

entity tb_rca is
end tb_rca;

architecture test of tb_rca is
    signal A, B, S: std_logic_vector(2 downto 0);
    signal Ci, Co: std_logic;
    
    component rca
        generic (N: integer);
        port (A, B: in  std_logic_vector (N-1 downto 0);
              Ci:   in  std_logic;
              S:    out std_logic_vector (N-1 downto 0);
              Co:   out std_logic);
    end component;
begin 
    U: rca generic map (3) port map (A, B, Ci, S, Co);

test: process
    variable testA, testB, testS: std_logic_vector (2 downto 0);
    variable testCi, testCo: std_logic;
    file test_file: text is in "rca/tb_rca.test";

    variable l: line;
    variable t: time;
    variable i: integer;
    variable good: boolean;
    variable space: character;
begin
    while not endfile(test_file) loop
        readline(test_file, l);

        read(l, i, good => good);
        next when not good;

        read(l, space);

        read(l, testA);
        read(l, space);

        read(l, testB);
        read(l, space);

        read(l, testCi);
        read(l, space);

        read(l, testS);
        read(l, space);

        read(l, testCo);

        A <= testA;
        B <= testB;
        Ci <= testCi;

        t := i * 1 ns;
        if (now < t) then
            wait for t - now;
        end if;
        
        assert S = testS report "Mismatch on output S";
        assert Co = testCo report "Mismatch on output Co";
    end loop;

    wait;
end process;
end test;
