library std;
library ieee; 
use std.textio.all;
use ieee.std_logic_1164.all; 
use ieee.std_logic_textio.all; -- synopsys only
use ieee.std_logic_arith.all;  -- synopsys only

entity blackjack is
    port (CLK:                        in  std_logic;
          Reset, NewGame, Stop, En:   in  std_logic;
          DATA_IN:                    in  integer;
          PLAYER_SCORE, DEALER_SCORE: out integer);
end blackjack;

architecture structural of blackjack is
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

    type STATE is (IDLE, CLEAN, 
                   WAIT_PC, WAIT_DC,
                   SETUP_PC, SETUP_DC,
                   READ_PC, READ_DC,
                   CHECK_PC, CHECK_DC,
                   PLAYER_BUSTED, DEALER_BUSTED, DEALER_WIN);
    signal current_state, next_state: STATE;
    signal PLAYER_INT, DEALER_INT: integer;
    signal Bust, Win: std_logic;
    signal ShowPlayer, ShowDealer, 
           PlayerWin,  DealerWin,
           PlayerRead, DealerRead,
           PlayerTurn, DealerTurn, Clear: std_logic;
    signal NRESET, NPLAYER_EN, NDEALER_EN: std_logic;
    signal DATA_IN_EXTENDED,
           PLAYER,           DEALER,
           PLAYER_NEXTSCORE, DEALER_NEXTSCORE: std_logic_vector (7 downto 0);
begin
    DATA_IN_EXTENDED <= conv_std_logic_vector(DATA_IN, 8);
    NPLAYER_EN <= not PlayerRead;
    NDEALER_EN <= not DealerRead;
    NRESET     <= not Clear;

    p_score: reg
        generic map(8)
        port map (CLK, NRESET, NPLAYER_EN, PLAYER_NEXTSCORE, PLAYER);
    player_adder: rca
        generic map(8)
        port map (PLAYER, DATA_IN_EXTENDED, '0', PLAYER_NEXTSCORE);

    d_score: reg
        generic map(8)
        port map (CLK, NRESET, NDEALER_EN, DEALER_NEXTSCORE, DEALER);

    dealer_adder: rca
        generic map(8)
        port map (DEALER, DATA_IN_EXTENDED, '0', DEALER_NEXTSCORE);

    process (CLK, Reset)
    begin
        if Reset='1' then
            current_state <= IDLE;
        elsif rising_edge(CLK) then
            current_state <= next_state;
        end if;
    end process;

    process (current_state, NewGame, Stop, En, Bust, Win)
    begin
        case current_state is
            when IDLE =>
                if NewGame = '1' then
                    next_state <= CLEAN;
                end if;
            when CLEAN =>
                next_state <= WAIT_PC;
            when WAIT_PC =>
                if    Stop = '1' then
                    next_state <= WAIT_DC;
                elsif En = '1' then
                    next_state <= SETUP_PC;
                end if;
            when SETUP_PC =>
                next_state <= READ_PC;
            when READ_PC =>
                next_state <= CHECK_PC;
            when CHECK_PC =>
                if Bust = '1' then
                    next_state <= PLAYER_BUSTED;
                else
                    next_state <= WAIT_PC;
                end if;
            when WAIT_DC =>
                if En = '1' then
                    next_state <= SETUP_DC;
                end if;
            when SETUP_DC =>
                next_state <= READ_DC;
            when READ_DC =>
                next_state <= CHECK_DC;
            when CHECK_DC =>
                if    Bust = '1' then
                    next_state <= DEALER_BUSTED;
                elsif Win = '1' then
                    next_state <= DEALER_WIN;
                else
                    next_state <= WAIT_DC;
                end if;
            when PLAYER_BUSTED =>
                if NewGame = '1' then
                    next_state <= CLEAN;
                end if;
            when DEALER_BUSTED =>
                if NewGame = '1' then
                    next_state <= CLEAN;
                end if;
            when DEALER_WIN =>
                if NewGame = '1' then
                    next_state <= CLEAN;
                end if;
        end case;
    end process;

    process (CLK)
        variable t: integer;
        variable l: line;
    begin
        if rising_edge(CLK) then
        case current_state is
            when IDLE =>
                PLAYER_INT <= 0;
                DEALER_INT <= 0;
                ShowPlayer <= '0';
                ShowDealer <= '0';
                PlayerWin  <= '0';
                DealerWin  <= '0';
                PlayerRead <= '0';
                DealerRead <= '0';
                PlayerTurn <= '0';
                DealerTurn <= '0';
            when CLEAN =>
                PLAYER_INT <= 0;
                DEALER_INT <= 0;
                Clear      <= '1';
                ShowPlayer <= '0';
                ShowDealer <= '0';
                PlayerWin  <= '0';
                DealerWin  <= '0';
                PlayerRead <= '0';
                DealerRead <= '0';
                PlayerTurn <= '0';
                DealerTurn <= '0';
                Bust <= '0';
                Win  <= '0';
            when WAIT_PC =>
                Clear      <= '0';
                ShowPlayer <= '1';
                PlayerTurn <= '1';
            when SETUP_PC =>
                PlayerRead <= '1';
            when READ_PC =>
                PlayerRead <= '0';
                t := PLAYER_INT + DATA_IN;
                PLAYER_INT <= t;
                if t > 21 then
                    Bust <= '1';
                end if;
            when CHECK_PC =>
            when WAIT_DC =>
                ShowDealer <= '1';
                PlayerTurn <= '0';
                DealerTurn <= '1';
            when SETUP_DC =>
                DealerRead <= '1';
            when READ_DC =>
                DealerRead <= '0';
                t := DEALER_INT + DATA_IN;
                DEALER_INT <= t;
                if t >= PLAYER_INT then
                    Win <= '1';
                elsif t > 21 then
                    Bust <= '1';
                end if;
            when CHECK_DC =>
            when PLAYER_BUSTED =>
                PlayerTurn <= '0';
                DealerWin  <= '1';
            when DEALER_BUSTED =>
                DealerTurn <= '0';
                PlayerWin  <= '1';
            when DEALER_WIN =>
                DealerTurn <= '0';
                DealerWin  <= '1';
        end case;
        end if;
    end process;

PLAYER_SCORE <= PLAYER_INT;
DEALER_SCORE <= DEALER_INT;

debug: process(CLK)
    variable l: line;
    variable enable_debug: boolean := true;
begin
    if enable_debug and rising_edge(CLK) then
        write(l, string'("now = "));
        write(l, now);
        writeline(output, l);
        write(l, string'("En = "));
        write(l, En);
        writeline(output, l);
        write(l, string'("Stop = "));
        write(l, Stop);
        writeline(output, l);
        write(l, string'("NPLAYER_EN = "));
        write(l, NPLAYER_EN);
        writeline(output, l);
        write(l, string'("PlayerRead = "));
        write(l, PlayerRead);
        writeline(output, l);
        write(l, string'("DealerRead = "));
        write(l, DealerRead);
        writeline(output, l);
        write(l, string'("PlayerTurn = "));
        write(l, PlayerTurn);
        writeline(output, l);
        write(l, string'("Win = "));
        write(l, Win);
        writeline(output, l);
        write(l, string'("DATA_IN = "));
        write(l, DATA_IN);
        writeline(output, l);
        write(l, string'("DATA_IN_EXTENDED = "));
        write(l, DATA_IN_EXTENDED);
        writeline(output, l);
        write(l, string'("PLAYER_INT = "));
        write(l, PLAYER_INT);
        writeline(output, l);
        write(l, string'("PLAYER = "));
        write(l, PLAYER);
        writeline(output, l);
        write(l, string'("DEALER = "));
        write(l, DEALER);
        writeline(output, l);
        write(l, string'("current_state = "));
        case current_state is
            when IDLE =>
                write(l, string'("id"));
            when CLEAN =>
                write(l, string'("cl"));
            when WAIT_PC =>
                write(l, string'("wpc"));
            when SETUP_PC =>
                write(l, string'("spc"));
            when READ_PC =>
                write(l, string'("rpc"));
            when CHECK_PC =>
                write(l, string'("cpc"));
            when WAIT_DC =>
                write(l, string'("wdc"));
            when SETUP_DC =>
                write(l, string'("sdc"));
            when READ_DC =>
                write(l, string'("rdc"));
            when CHECK_DC =>
                write(l, string'("cdc"));
            when PLAYER_BUSTED =>
                write(l, string'("pb"));
            when DEALER_BUSTED =>
                write(l, string'("db"));
            when DEALER_WIN =>
                write(l, string'("dw"));
        end case;
        writeline(output, l);
        if not is_X(PLAYER) then
            assert PLAYER_INT = conv_integer(unsigned(PLAYER));
            assert DEALER_INT = conv_integer(unsigned(DEALER));
        end if;
    end if;
end process;
end structural;
