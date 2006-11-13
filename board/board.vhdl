library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity board is
    port (CLK:                      in  std_logic;
          Reset, NewGame, Stop, En: in  std_logic;
          DATA_IN:                  in  std_logic_vector (7 downto 0);
          OUTPUT:                   out std_logic_vector (7 downto 0);
          AN:                       out std_logic_vector (3 downto 0));
end board;

architecture structural of board is
    component blackjack
        port (CLK:                      in  std_logic;
              Reset, NewGame, Stop, En: in  std_logic;
              DATA_IN:                  in  std_logic_vector (7 downto 0);
              PLAYER_L, PLAYER_H:       out std_logic_vector (3 downto 0);
              DEALER_L, DEALER_H:       out std_logic_vector (3 downto 0);
              PLAYER_SHOW, DEALER_SHOW: out std_logic;
              PLAYER_WIN,  DEALER_WIN:  out std_logic);
    end component;
    component display
        port (CLK, RST:                 in  std_logic;
              PLAYER_L, PLAYER_H:       in  std_logic_vector (3 downto 0);
              DEALER_L, DEALER_H:       in  std_logic_vector (3 downto 0);
              PLAYER_SHOW, DEALER_SHOW: in  std_logic;
              PLAYER_WIN,  DEALER_WIN:  in  std_logic;
              OUTPUT:                   out std_logic_vector (7 downto 0);
              AN:                       out std_logic_vector (3 downto 0));
    end component;

    signal PLAYER_L, PLAYER_H:       std_logic_vector (3 downto 0);
    signal DEALER_L, DEALER_H:       std_logic_vector (3 downto 0);
    signal PLAYER_SHOW, DEALER_SHOW: std_logic;
    signal PLAYER_WIN,  DEALER_WIN:  std_logic;
    signal NRESET:                   std_logic;
begin
    NRESET <= not Reset;

    bj: blackjack
        port map (CLK, Reset, NewGame, Stop, En, DATA_IN,
                  PLAYER_L, PLAYER_H, DEALER_L, DEALER_H,
                  PLAYER_SHOW, DEALER_SHOW,
                  PLAYER_WIN,  DEALER_WIN);

    disp: display
        port map (CLK, NRESET,
                  PLAYER_L, PLAYER_H, DEALER_L, DEALER_H,
                  PLAYER_SHOW,  DEALER_SHOW,
                  PLAYER_WIN,   DEALER_WIN,
                  OUTPUT, AN);
end structural;
