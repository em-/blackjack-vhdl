library std;
library ieee;

use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all; -- synopsys only
use ieee.std_logic_arith.all;  -- synopsys only

entity tb_display is
end tb_display;

architecture test of tb_display is
    signal CLK: std_logic := '0';
    signal RST:                       std_logic;
    signal PLAYER_L, PLAYER_H:        std_logic_vector (3 downto 0);
    signal DEALER_L, DEALER_H:        std_logic_vector (3 downto 0);
    signal PLAYER_SHOW,  DEALER_SHOW: std_logic;
    signal PLAYER_WIN,   DEALER_WIN:  std_logic;
    signal DIGIT:                     std_logic_vector (7 downto 0);
    signal AN:                        std_logic_vector (3 downto 0);

    signal clock_counter: integer := -1;

    component display
        port (CLK, RST:                  in  std_logic;
              PLAYER_L, PLAYER_H:        in  std_logic_vector (3 downto 0);
              DEALER_L, DEALER_H:        in  std_logic_vector (3 downto 0);
              PLAYER_SHOW,  DEALER_SHOW: in  std_logic;
              PLAYER_WIN,   DEALER_WIN:  in  std_logic;
              OUTPUT:                    out std_logic_vector (7 downto 0);
              AN:                        out std_logic_vector (3 downto 0));
    end component;
begin 
    U: display port map(CLK, RST,
                PLAYER_L, PLAYER_H, DEALER_L, DEALER_H,
                PLAYER_SHOW, DEALER_SHOW, PLAYER_WIN, DEALER_WIN,
                DIGIT, AN);

clock: process
begin
    CLK <= not CLK;
    wait for 0.5 ns;
end process;

count: process(CLK)
begin
    if rising_edge(CLK) then
        clock_counter <= clock_counter + 1;
    end if;
end process;

test: process
    variable testRST:                          std_logic;
    variable testPLAYER_L, testPLAYER_H:       natural;
    variable testDEALER_L, testDEALER_H:       natural;
    variable testPLAYER_SHOW, testDEALER_SHOW: std_logic;
    variable testPLAYER_WIN,  testDEALER_WIN:  std_logic;
    variable testDIGIT:                        std_logic_vector (7 downto 0);
    variable testAN:                           std_logic_vector (3 downto 0);

    file test_file: text is in "display/tb_display.test";

    variable l: line;
    variable t: integer;
    variable good: boolean;
    variable space: character;

    variable enable_debug: boolean := false;
    variable l_out: line;
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

        read(l, space);
        read(l, testPLAYER_H);
        read(l, testPLAYER_L);
        read(l, testDEALER_H);
        read(l, testDEALER_L);
        
        read(l, space);
        read(l, testPLAYER_SHOW);
        read(l, testDEALER_SHOW);
        read(l, testPLAYER_WIN);
        read(l, testDEALER_WIN);

        read(l, space);
        read(l, testDIGIT);
        read(l, testAN);

        RST <= testRST;
        PLAYER_H <= conv_std_logic_vector(testPLAYER_H, PLAYER_H'length);
        PLAYER_L <= conv_std_logic_vector(testPLAYER_L, PLAYER_L'length);
        DEALER_H <= conv_std_logic_vector(testDEALER_H, DEALER_H'length);
        DEALER_L <= conv_std_logic_vector(testDEALER_L, DEALER_L'length);
        PLAYER_SHOW <= testPLAYER_SHOW;
        DEALER_SHOW <= testDEALER_SHOW;
        PLAYER_WIN  <= testPLAYER_WIN;
        DEALER_WIN  <= testDEALER_WIN;

        while clock_counter /= t loop
            wait on clock_counter;
        end loop;

        if enable_debug then
            write(l_out, string'("(tb_display) "));
            write(l_out, string'(", PLAYER_SHOW = "));
            write(l_out, PLAYER_SHOW);
            write(l_out, string'(" DIGIT = "));
            write(l_out, DIGIT);
            write(l_out, string'(", AN = "));
            write(l_out, AN);
            writeline(output, l_out);
        end if;

        assert DIGIT = testDIGIT report "Mismatch on output DIGIT";
        assert AN    = testAN    report "Mismatch on output AN";
    end loop;

    assert false report "Finished" severity note;
    wait;
end process;

end test;
