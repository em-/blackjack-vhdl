library std;
library ieee;

use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all; -- synopsys only

entity tb_counter is
end tb_counter;

architecture test of tb_counter is
    signal CLK, RST: std_logic := '0';
    signal EN: std_logic;
    signal S: std_logic_vector(2 downto 0);
    signal OWFL: std_logic;
    signal clock_counter: integer := -1;
    
    component counter 
        generic (N: integer := 3);
        port (CLK, RST: in    std_logic;
              EN:       in    std_logic;
              S:        inout std_logic_vector (N-1 downto 0);
              OWFL:     out   std_logic
        );
    end component;

    signal finished: boolean := false;
begin 
    U: counter port map (CLK, RST, EN, S, OWFL);

clock: process
begin
    CLK <= not CLK;
    if finished then wait; end if;
    wait for 0.5 ns;
end process;

count: process(CLK)
begin
    if rising_edge(CLK) then
        clock_counter <= clock_counter + 1;
    end if;
end process;

test: process
    variable testRST, testEN: std_logic;
    variable testS: std_logic_vector(2 downto 0);
    variable testOWFL: std_logic;
    file test_file: text is in "counter/tb_counter.test";

    variable l: line;
    variable t: integer;
    variable good: boolean;
    variable space: character;
begin
    wait on clock_counter;

    while not endfile(test_file) loop
        readline(test_file, l);

        -- read the time from the beginning of the line
        -- skip the line if it doesn't start with an integer
        read(l, t, good => good);
        next when not good;

        read(l, space);

        read(l, testRST);
        read(l, testEN);

        read(l, space);

        read(l, testS);

        read(l, space);

        read(l, testOWFL);

        while clock_counter /= t loop
            wait on clock_counter;
        end loop;

        RST <= testRST;
        EN <= testEN;

        assert S = testS report "Mismatch on output S";
        assert OWFL = testOWFL report "Mismatch on output OWFL";
    end loop;

    finished <= true;
    wait;
end process;

end test;
