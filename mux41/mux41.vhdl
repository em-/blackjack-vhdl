library ieee; 
use ieee.std_logic_1164.all; 

entity mux41 is
    generic (N: integer := 8);
    
    port (A, B, C, D: in  std_logic_vector (N-1 downto 0);
          SEL:  in  std_logic_vector(1 downto 0);
          O:    out std_logic_vector (N-1 downto 0) );
end mux41;

architecture behavioral of mux41 is
begin
process (A, B, C, D, SEL)
begin
    case SEL is
        when "00" => O <= A;
        when "01" => O <= B;
        when "10" => O <= C;
        when "11" => O <= D;
    end case;
end process;
end behavioral;
