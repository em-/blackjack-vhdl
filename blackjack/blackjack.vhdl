library std;
library ieee; 
use std.textio.all;
use ieee.std_logic_1164.all; 
use ieee.std_logic_textio.all; -- synopsys only
use ieee.std_logic_arith.all;  -- synopsys only

entity blackjack is
    port (CLK:                        in  std_logic;
          Reset, NewGame, Stop, En:   in  std_logic;
          DATA_IN:                    in  std_logic_vector (7 downto 0);
          PLAYER_SCORE, DEALER_SCORE: out std_logic_vector (7 downto 0);
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

PLAYER_SCORE <= PLAYER;
DEALER_SCORE <= DEALER;

debug: process(CLK)
    variable l: line;
    variable enable_debug: boolean := false;
begin
    if enable_debug and rising_edge(CLK) then
        write(l, string'("now = "));
        write(l, now);
        writeline(output, l);
        write(l, string'("En = "));
        write(l, En);
        writeline(output, l);
        write(l, string'("Bust = "));
        write(l, Bust);
        writeline(output, l);
        write(l, string'("Win = "));
        write(l, Win);
        writeline(output, l);
        write(l, string'("DATA_IN = "));
        write(l, DATA_IN);
        writeline(output, l);
        write(l, string'("PLAYER = "));
        write(l, PLAYER);
        writeline(output, l);
        write(l, string'("DEALER = "));
        write(l, DEALER);
        writeline(output, l);
    end if;
end process;
end structural;
