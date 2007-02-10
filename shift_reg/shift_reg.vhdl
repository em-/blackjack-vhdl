library ieee; 
use ieee.std_logic_1164.all; 

entity shift_reg is
    generic (N: integer := 8);
    
    port (CLK, RST:  in    std_logic;
          EN:        in    std_logic;
          A:         in    std_logic;
          D:         inout std_logic_vector (N-1 downto 0));
end shift_reg;

architecture structural of shift_reg is
    component fd is
        port (CLK, RST: in  std_logic;
              EN:       in  std_logic;
              D:        in  std_logic;
              Q:        out std_logic);
    end component;

begin
    fd_1: fd port map (CLK, RST, EN, A, D(0));

    fd_vect: for i in N-1 downto 1 generate
        fd_i: fd port map (CLK, RST, EN, D(i-1), D(i));
    end generate;
end structural;
