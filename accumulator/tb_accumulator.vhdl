library std;
library ieee;

use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all; -- synopsys only

entity tb_accumulator is
end tb_accumulator;

architecture test of tb_accumulator is
    signal CLK, RST: std_logic := '0';
    signal EN: std_logic;
    signal A, B:       std_logic_vector (2 downto 0);
    signal ACCUMULATE: std_logic;
    signal O:          std_logic_vector (2 downto 0);

    component accumulator
        generic (N: integer := 3);
        port (CLK, RST:   in    std_logic;
              EN:         in    std_logic;
              A, B:       in    std_logic_vector (N-1 downto 0);
              ACCUMULATE: in    std_logic;
              O:          inout std_logic_vector (N-1 downto 0));
    end component;

    signal clock_counter: integer := -1;
    signal finished: boolean := false;
begin 
    U: accumulator port map (CLK, RST, EN, A, B, ACCUMULATE, O);

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
    variable testRST, testEN, testACCUMULATE: std_logic;
    variable testA, testB, testO: std_logic_vector(2 downto 0);
    file test_file: text is in "accumulator/tb_accumulator.test";

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
        read(l, testACCUMULATE);

        read(l, space);

        read(l, testA);

        read(l, space);

        read(l, testB);

        read(l, space);

        read(l, testO);

        while clock_counter /= t loop
            wait on clock_counter;
        end loop;

        RST <= testRST;
        EN <= testEN;
        ACCUMULATE <= testACCUMULATE;
        A <= testA;
        B <= testB;

        assert O = testO report "Mismatch on output O";
    end loop;

    finished <= true;
    wait;
end process;

end test;
