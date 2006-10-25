library ieee; 
use ieee.std_logic_1164.all; 

entity fsm is
    port (CLK, RST:  in  std_logic;
          EN:        in  std_logic;
          NewGame, Stop, Bust, Win: in std_logic;
          ShowPlayer, ShowDealer, PlayerWin, DealerWin: out std_logic);
end fsm;

architecture state_machine of fsm is
    type STATE is (IDLE, PLAYER_CARD, DEALER_CARD,
                         PLAYER_BUSTED, DEALER_BUSTED, DEALER_WIN);
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

    process (current_state, NewGame, Stop, Bust, Win)
    begin
        case current_state is
            when IDLE =>
                if NewGame = '1' then
                    next_state <= PLAYER_CARD;
                end if;
            when PLAYER_CARD =>
                if Bust = '1' then
                    next_state <= PLAYER_BUSTED;
                elsif Stop = '1' then
                    next_state <= DEALER_CARD;
                end if;
            when DEALER_CARD =>
                if Bust = '1' then
                    next_state <= DEALER_BUSTED;
                elsif Win = '1' then
                    next_state <= DEALER_WIN;
                end if;
            when PLAYER_BUSTED =>
            when DEALER_BUSTED =>
            when DEALER_WIN =>
                if NewGame = '1' then
                    next_state <= PLAYER_CARD;
                end if;
        end case;
    end process;

    process (current_state)
    begin
        case current_state is
            when IDLE =>
                ShowPlayer <= '0';
                ShowDealer <= '0';
                PlayerWin  <= '0';
                DealerWin  <= '0';
            when PLAYER_CARD =>
                ShowPlayer <= '1';
                ShowDealer <= '0';
                PlayerWin  <= '0';
                DealerWin  <= '0';
            when DEALER_CARD =>
                ShowDealer <= '1';
            when PLAYER_BUSTED =>
                DealerWin  <= '1';
            when DEALER_BUSTED =>
                PlayerWin  <= '1';
            when DEALER_WIN =>
                DealerWin  <= '1';
        end case;
    end process;
end state_machine;
