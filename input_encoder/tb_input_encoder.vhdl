library std;
library ieee;

use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all; -- synopsys only

entity tb_input_encoder is
end tb_input_encoder;

architecture test of tb_input_encoder is
    signal I: std_logic_vector (2 downto 0);
    signal O: std_logic_vector (3 downto 0);

    component input_encoder
        port (I: in  std_logic_vector(2 downto 0);
              O: out std_logic_vector(3 downto 0));
    end component;

begin 
    U: input_encoder port map (I, O);

test: process
    variable testI: std_logic_vector(2 downto 0);
    variable testO: std_logic_vector(3 downto 0);
    file test_file: text is in "input_encoder/tb_input_encoder.test";

    variable l: line;
    variable t: time;
    variable s: integer;
    variable good: boolean;
    variable space: character;
begin
    while not endfile(test_file) loop
        readline(test_file, l);

        -- read the time from the beginning of the line
        -- skip the line if it doesn't start with an integer
        read(l, s, good => good);
        next when not good;

        read(l, space);

        read(l, testI);
        read(l, testO);

        I <= testI;

        t := s * 1 ns;  -- convert an integer to time
        if (now < t) then
            wait for t - now;
        end if;
        
        assert O = testO report "Mismatch on output O";
    end loop;

    wait;
end process;

end test;
