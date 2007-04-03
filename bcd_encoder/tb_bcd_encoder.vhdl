library std;
library ieee;

use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; -- synopsys only
use ieee.std_logic_textio.all; -- synopsys only

entity tb_bcd_encoder is
end tb_bcd_encoder;

architecture test of tb_bcd_encoder is
    signal I:    std_logic_vector(7 downto 0) := "00000000";
    signal H, L: std_logic_vector(3 downto 0);

    signal n: integer := -1;
    
    component bcd_encoder
        port (I:    in  std_logic_vector(7 downto 0);
              H, L: out std_logic_vector(3 downto 0));
    end component;

begin 
    U: bcd_encoder port map (I, H, L);

test: process
    variable l_out: line;
    variable ref: integer;
begin
    wait on n;
    while true loop
        ref := n;
        wait on n;
       
        assert H = conv_std_logic_vector(ref / 10, 4)   report "Mismatch on output H";
        assert L = conv_std_logic_vector(ref mod 10, 4) report "Mismatch on output L";
    end loop;
end process;

I <= conv_std_logic_vector(n, I'length);

count: process
begin
    while n <= 39 loop
        n <= n + 1;
        wait for 0.1 ns;
    end loop;
    wait;
end process;
end test;
