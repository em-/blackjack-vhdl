library ieee; 
use ieee.std_logic_1164.all; 

entity reg is
    generic (N: integer := 8);
    
    port (CLK, RST:  in  std_logic;
          EN:        in  std_logic;
          A:         in  std_logic_vector (N-1 downto 0);
          O:         out std_logic_vector (N-1 downto 0));
end reg;

architecture behavioral of reg is
begin
process (RST, CLK)
begin
    if RST = '0' then
        O <= (O'range => '0');
    elsif CLK'event and CLK = '1' then
        if EN = '0' then
            O <= A;
        end if;
    end if;
end process;
end behavioral;

architecture structural of reg is
    component fd is
        port (CLK, RST: in  std_logic;
              EN:       in  std_logic;
              D:        in  std_logic;
              Q:        out std_logic);
    end component;
begin
    fd_vect: for i in N-1 downto 0 generate
        fd_i: fd port map (CLK, RST, EN, A(i), O(i));
    end generate;
end structural;
