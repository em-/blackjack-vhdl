library ieee; 
use ieee.std_logic_1164.all; 

entity fsm is
    port (CLK, RST:  in  std_logic;
          NewGame, En, Stop, Bust, Win: in std_logic;
          ShowPlayer, ShowDealer, PlayerWin, DealerWin: out std_logic;
          PlayerRead, DealerRead: out std_logic;
          Clear: out std_logic);
end fsm;

architecture state_machine of fsm is
    type STATE is (IDLE, CLEAN, 
                   WAIT_PC, WAIT_DC,
                   SETUP_PC, SETUP_DC,
                   READ_PC, READ_DC,
                   CHECK_PC, CHECK_DC,
                   PLAYER_BUSTED, DEALER_BUSTED, DEALER_WINNER);
    signal current_state, next_state: STATE;
begin
    process (CLK, RST)
    begin
        if RST='1' then
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
                    next_state <= DEALER_WINNER;
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
            when DEALER_WINNER =>
                if NewGame = '1' then
                    next_state <= CLEAN;
                end if;
        end case;
    end process;

    process (CLK)
    begin
        if rising_edge(CLK) then
        case current_state is
            when IDLE =>
                Clear      <= '0';
                ShowPlayer <= '0';
                ShowDealer <= '0';
                PlayerWin  <= '0';
                DealerWin  <= '0';
                PlayerRead <= '0';
                DealerRead <= '0';
            when CLEAN =>
                Clear      <= '1';
                ShowPlayer <= '0';
                ShowDealer <= '0';
                PlayerWin  <= '0';
                DealerWin  <= '0';
                PlayerRead <= '0';
                DealerRead <= '0';
            when WAIT_PC =>
                Clear      <= '0';
                ShowPlayer <= '1';
            when SETUP_PC =>
                PlayerRead <= '1';
            when READ_PC =>
                PlayerRead <= '0';
            when CHECK_PC =>
            when WAIT_DC =>
                ShowDealer <= '1';
            when SETUP_DC =>
                DealerRead <= '1';
            when READ_DC =>
                DealerRead <= '0';
            when CHECK_DC =>
            when PLAYER_BUSTED =>
                DealerWin  <= '1';
            when DEALER_BUSTED =>
                PlayerWin  <= '1';
            when DEALER_WINNER =>
                DealerWin  <= '1';
        end case;
        end if;
    end process;
end state_machine;
