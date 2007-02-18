library ieee;
use ieee.std_logic_1164.all;

entity display_controller is
    port(CLK, RST: in std_logic;
         DIGIT_3, DIGIT_2, DIGIT_1, DIGIT_0: in std_logic_vector(7 downto 0);

         OUTPUT: out std_logic_vector (7 downto 0);
         AN:     out std_logic_vector (3 downto 0));
end display_controller;


architecture structural of display_controller is
    component shift_reg is
        generic (N: integer := 8);
        port (CLK, RST:  in    std_logic;
              EN:        in    std_logic;
              A:         in    std_logic;
              D:         inout std_logic_vector (N-1 downto 0));
    end component;

    component mux21_1bit is
        port (A, B: in  std_logic;
              SEL:  in  std_logic;
              O:    out std_logic);
    end component;

    component mux41_1bit is
        port (A, B, C, D: in  std_logic;
              SEL:        in  std_logic_vector(1 downto 0);
              O:          out std_logic);
    end component;

    signal STARTED, SHIFT_IN: std_logic;
    signal SHIFT_OUT: std_logic_vector(3 downto 0);
    signal SEL:   std_logic_vector(1 downto 0);
begin

STARTED  <= SHIFT_OUT(0) or SHIFT_OUT(1) or SHIFT_OUT(2) or SHIFT_OUT(3);
SHIFT_IN <= not STARTED or SHIFT_OUT(3);

SEL(0)  <= SHIFT_OUT(1) or SHIFT_OUT(3);
SEL(1)  <= SHIFT_OUT(2) or SHIFT_OUT(3);

reg: shift_reg generic map (4) port map (CLK, RST, '0', SHIFT_IN, SHIFT_OUT);

mux: for i in 0 to 7 generate
    mux_i: mux41_1bit 
        port map (DIGIT_0(i), DIGIT_1(i), DIGIT_2(i), DIGIT_3(i), 
                  SEL, OUTPUT(i));
end generate;

AN <= not SHIFT_OUT;
end structural;
