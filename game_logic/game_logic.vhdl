library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity game_logic is
    port (PLAYER, DEALER:         in  std_logic_vector (7 downto 0);
          WIN, BUST: out std_logic);
end game_logic;


architecture behavioral of game_logic is
begin

winner: process (PLAYER, DEALER)
    variable P, D: unsigned(7 downto 0);
begin
    P := to_01(unsigned(PLAYER));
    D := to_01(unsigned(DEALER));

    if (P = 21) or (P <= D) then
        WIN <= '1';
    else
        WIN <= '0';
    end if;
end process;

busted: process (PLAYER, DEALER)
    variable P, D: unsigned(7 downto 0);
begin
    P := to_01(unsigned(PLAYER));
    D := to_01(unsigned(DEALER));

    if (P > 21) or (D > 21) then
        BUST <= '1';
    else
        BUST <= '0';
    end if;
end process;

end behavioral;
