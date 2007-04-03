library std;
library ieee;

use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all; -- synopsys only

entity tb_display_controller is
end tb_display_controller;

architecture test of tb_display_controller is
    signal CLK, RST: std_logic := '0';
    signal DIGIT_3, DIGIT_2, DIGIT_1, DIGIT_0: std_logic_vector(7 downto 0);
    signal OUTPUT: std_logic_vector (7 downto 0);
    signal AN:     std_logic_vector (3 downto 0);
    signal counter: integer := -1;
    signal finished: boolean := false;

    component display_controller 
        port(CLK, RST: std_logic;
             DIGIT_3, DIGIT_2, DIGIT_1, DIGIT_0: in std_logic_vector(7 downto 0);

             OUTPUT: out std_logic_vector (7 downto 0);
             AN:     out std_logic_vector (3 downto 0));
    end component;

begin 
    U: display_controller port map (CLK, RST,
                                    DIGIT_3, DIGIT_2, DIGIT_1, DIGIT_0,
                                    OUTPUT, AN);

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
    variable testRST: std_logic;
    variable testDIGIT_3, testDIGIT_2, 
             testDIGIT_1, testDIGIT_0: std_logic_vector(7 downto 0);
    variable testOUTPUT: std_logic_vector (7 downto 0);
    variable testAN:     std_logic_vector (3 downto 0);
    file test_file: text is in "display_controller/tb_display_controller.test";

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
        read(l, space);

        read(l, testDIGIT_3);
        read(l, space);
        read(l, testDIGIT_2);
        read(l, space);
        read(l, testDIGIT_1);
        read(l, space);
        read(l, testDIGIT_0);
        read(l, space);

        read(l, testOUTPUT);
        read(l, space);
        read(l, testAN);

        RST <= testRST;
        DIGIT_3 <= testDIGIT_3;
        DIGIT_2 <= testDIGIT_2;
        DIGIT_1 <= testDIGIT_1;
        DIGIT_0 <= testDIGIT_0;

        while counter /= t loop
            wait on counter;
        end loop;

        assert OUTPUT = testOUTPUT report "Mismatch on output OUTPUT";
        assert AN     = testAN report "Mismatch on output AN";
    end loop;

    finished <= true;
    wait;
end process;

end test;
