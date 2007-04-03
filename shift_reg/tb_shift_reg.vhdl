library std;
library ieee;

use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all; -- synopsys only

entity tb_shift_reg is
end tb_shift_reg;

architecture test of tb_shift_reg is
    signal CLK, RST: std_logic := '0';
    signal EN: std_logic;
    signal A:        std_logic;
    signal D:        std_logic_vector (2 downto 0);
    signal counter: integer := -1;
    signal finished: boolean := false;

    component shift_reg 
        generic (N: integer := 3);
        port (CLK, RST:  in    std_logic;
              EN:        in    std_logic;
              A:         in    std_logic;
              D:         inout std_logic_vector (N-1 downto 0));
    end component;

begin 
    U: shift_reg port map (CLK, RST, EN, A, D);

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
    variable testA: std_logic;
    variable testD: std_logic_vector (2 downto 0);
    file test_file: text is in "shift_reg/tb_shift_reg.test";

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

        read(l, space);

        read(l, testA);

        read(l, space);

        read(l, testD);

        while counter /= t loop
            wait on counter;
        end loop;

        RST <= testRST;
        EN <= testEN;
        A <= testA;

        assert D = testD report "Mismatch on output D";
    end loop;

    finished <= true;
    wait;
end process;

end test;
