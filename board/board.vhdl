library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity board is
    generic (GAME_CLK_DIV: integer := 1000;
             DISP_CLK_DIV: integer := 100000);
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
    component pulse_generator
        port (CLK, RST: in  std_logic;
              I:        in  std_logic;
              O:        out std_logic);
    end component;
	component clock_divider 
        generic (MODULUS: in positive range 2 to integer'high := 4);
        port (CLK, RST: in  std_logic;
              O:        out std_logic);
	end component;

    signal Reset_PULSE, NewGame_PULSE, Stop_PULSE, En_PULSE: std_logic;
    signal PLAYER_L, PLAYER_H:       std_logic_vector (3 downto 0);
    signal DEALER_L, DEALER_H:       std_logic_vector (3 downto 0);
    signal PLAYER_SHOW, DEALER_SHOW: std_logic;
    signal PLAYER_WIN,  DEALER_WIN:  std_logic;
    signal NRESET:                   std_logic;
    signal BJ_CLK, DISP_CLK:         std_logic;
begin
    NRESET <= not Reset;

    r_pgen: pulse_generator port map (DISP_CLK, NRESET, Reset, Reset_PULSE);
    n_pgen: pulse_generator port map (BJ_CLK, NRESET, NewGame, NewGame_PULSE);
    s_pgen: pulse_generator port map (BJ_CLK, NRESET, Stop, Stop_PULSE);
    e_pgen: pulse_generator port map (BJ_CLK, NRESET, En, En_PULSE);

    bj_div: clock_divider
        generic map (GAME_CLK_DIV)
        port map (CLK, NRESET, BJ_CLK);

    disp_div: clock_divider
        generic map (DISP_CLK_DIV)
        port map (CLK, NRESET, DISP_CLK);

    bj: blackjack
        port map (BJ_CLK, Reset_PULSE, NewGame_PULSE, Stop_PULSE, En_PULSE,
                  DATA_IN,
                  PLAYER_L, PLAYER_H, DEALER_L, DEALER_H,
                  PLAYER_SHOW, DEALER_SHOW,
                  PLAYER_WIN,  DEALER_WIN);

    disp: display
        port map (DISP_CLK, NRESET,
                  PLAYER_L, PLAYER_H, DEALER_L, DEALER_H,
                  PLAYER_SHOW,  DEALER_SHOW,
                  PLAYER_WIN,   DEALER_WIN,
                  OUTPUT, AN);
end structural;
