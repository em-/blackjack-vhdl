library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all;  -- synopsys only

entity blackjack is
    port (CLK:                        in  std_logic;
          Reset, NewGame, Stop, En:   in  std_logic;
          DATA_IN:                    in  std_logic_vector (7 downto 0);
          PLAYER_L, PLAYER_H:         out std_logic_vector (3 downto 0);
          DEALER_L, DEALER_H:         out std_logic_vector (3 downto 0);
          PLAYER_SHOW,  DEALER_SHOW:  out std_logic;
          PLAYER_WIN,   DEALER_WIN:   out std_logic);
end blackjack;

architecture structural of blackjack is
    component game_logic
        port (PLAYER, DEALER: in  std_logic_vector (7 downto 0);
              WIN, BUST:      out std_logic);
    end component;
    component reg is
        generic (N: integer := 8);
        port (CLK, RST:  in  std_logic;
              EN:        in  std_logic;
              A:         in  std_logic_vector (N-1 downto 0);
              O:         out std_logic_vector (N-1 downto 0));
    end component;
    component rca
        generic (N: integer := 8);
        port (A, B: in  std_logic_vector (N-1 downto 0);
              Ci:   in  std_logic;
              S:    out std_logic_vector (N-1 downto 0);
              Co:   out std_logic);
    end component;
    component fsm
        port (CLK, RST:  in  std_logic;
              NewGame, En, Stop, Bust, Win: in std_logic;
              ShowPlayer, ShowDealer, PlayerWin, DealerWin: out std_logic;
              PlayerRead, DealerRead: out std_logic;
              Clear: out std_logic);
    end component;
    component bcd_encoder
        port (I:    in  std_logic_vector(7 downto 0);
              H, L: out std_logic_vector(3 downto 0));
    end component;

    signal Bust, Win: std_logic;
    signal ShowPlayer, ShowDealer, 
           PlayerWin,  DealerWin,
           PlayerRead, DealerRead,
           Clear: std_logic;
    signal NRESET, NPLAYER_EN, NDEALER_EN: std_logic;
    signal PLAYER,           DEALER,
           PLAYER_NEXTSCORE, DEALER_NEXTSCORE: std_logic_vector (7 downto 0);
begin
    NPLAYER_EN <= not PlayerRead;
    NDEALER_EN <= not DealerRead;
    NRESET     <= not Clear;

    PLAYER_SHOW <= ShowPlayer;
    DEALER_SHOW <= ShowDealer;
    PLAYER_WIN  <= PlayerWin;
    DEALER_WIN  <= DealerWin;

    p_score: reg
        generic map(8)
        port map (CLK, NRESET, NPLAYER_EN, PLAYER_NEXTSCORE, PLAYER);
    player_adder: rca
        generic map(8)
        port map (PLAYER, DATA_IN, '0', PLAYER_NEXTSCORE);

    d_score: reg
        generic map(8)
        port map (CLK, NRESET, NDEALER_EN, DEALER_NEXTSCORE, DEALER);

    dealer_adder: rca
        generic map(8)
        port map (DEALER, DATA_IN, '0', DEALER_NEXTSCORE);

    game: game_logic
        port map (PLAYER, DEALER, Win, Bust);

    state_machine: fsm
        port map (CLK, Reset, NewGame, En, Stop, Bust, Win,
                  ShowPlayer, ShowDealer, PlayerWin, DealerWin,
                  PlayerRead, DealerRead, Clear);

    bcd_player: bcd_encoder
        port map (PLAYER, PLAYER_H, PLAYER_L);

    bcd_dealer: bcd_encoder
        port map (DEALER, DEALER_H, DEALER_L);
end structural;
