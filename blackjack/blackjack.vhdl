library std;
library ieee; 
use std.textio.all;
use ieee.std_logic_1164.all; 
use ieee.std_logic_textio.all; -- synopsys only

entity blackjack is
    port (CLK:                        in  std_logic;
          Reset, NewGame, Stop, En:   in  std_logic;
          DATA_IN:                    in  integer;
          PLAYER_SCORE, DEALER_SCORE: out integer);
end blackjack;

architecture structural of blackjack is
    type STATE is (IDLE, CLEAN, 
                   WAIT_PC, WAIT_DC,
                   READ_PC, READ_DC,
                   CHECK_PC, CHECK_DC,
                   PLAYER_BUSTED, DEALER_BUSTED, DEALER_WIN);
    signal current_state, next_state: STATE;
    signal PLAYER, DEALER: integer;
    signal Bust, Win: std_logic;
    signal ShowPlayer, ShowDealer, 
           PlayerWin,  DealerWin,
           PlayerTurn, DealerTurn: std_logic;
begin
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
                    next_state <= READ_PC;
                end if;
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
                    next_state <= READ_DC;
                end if;
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
                PLAYER <= 0;
                DEALER <= 0;
                ShowPlayer <= '0';
                ShowDealer <= '0';
                PlayerWin  <= '0';
                DealerWin  <= '0';
                PlayerTurn <= '0';
                DealerTurn <= '0';
            when CLEAN =>
                PLAYER <= 0;
                DEALER <= 0;
                ShowPlayer <= '0';
                ShowDealer <= '0';
                PlayerWin  <= '0';
                DealerWin  <= '0';
                PlayerTurn <= '0';
                DealerTurn <= '0';
                Bust <= '0';
                Win  <= '0';
            when WAIT_PC =>
                ShowPlayer <= '1';
                PlayerTurn <= '1';
            when READ_PC =>
                t := PLAYER + DATA_IN;
                PLAYER <= t;
                if t > 21 then
                    Bust <= '1';
                end if;
            when CHECK_PC =>
            when WAIT_DC =>
                ShowDealer <= '1';
                PlayerTurn <= '0';
                DealerTurn <= '1';
            when READ_DC =>
                t := DEALER + DATA_IN;
                DEALER <= t;
                if t >= PLAYER then
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
        write(l, string'("current_state = "));
        case current_state is
            when IDLE =>
                write(l, string'("id"));
            when CLEAN =>
                write(l, string'("cl"));
            when WAIT_PC =>
                write(l, string'("wpc"));
            when READ_PC =>
                write(l, string'("rpc"));
            when CHECK_PC =>
                write(l, string'("cpc"));
            when WAIT_DC =>
                write(l, string'("wdc"));
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
    end if;
end process;
end structural;
