library ieee; 
use ieee.std_logic_1164.all; 

entity latch is
    generic (N: integer := 8);
    
    port (CLK, RST:  in  std_logic;
          EN:        in  std_logic;
          A:         in  std_logic_vector (N-1 downto 0);
          O:         out std_logic_vector (N-1 downto 0));
end latch;

architecture behavioral of latch is
begin
process (RST, CLK)
begin
    if RST = '0' then
        O <= (O'range => '0');
    elsif CLK = '0' then
        if EN = '0' then
            O <= A;
        end if;
    end if;
end process;
end behavioral;

architecture structural of latch is
    component ld is
        port (CLK, RST: in  std_logic;
              EN:       in  std_logic;
              D:        in  std_logic;
              Q:        out std_logic);
    end component;
begin
    ld_vect: for i in N-1 downto 0 generate
        ld_i: ld port map (CLK, RST, EN, A(i), O(i));
    end generate;
end structural;
