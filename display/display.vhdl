library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity display is
    port (CLK, RST:                  in  std_logic;
          PLAYER_L, PLAYER_H:        in  std_logic_vector (3 downto 0);
          DEALER_L, DEALER_H:        in  std_logic_vector (3 downto 0);
          PLAYER_SHOW,  DEALER_SHOW: in  std_logic;
          PLAYER_WIN,   DEALER_WIN:  in  std_logic;
          OUTPUT:                    out std_logic_vector (7 downto 0);
          AN:                        out std_logic_vector (3 downto 0));
end display;

architecture structural of display is
    component sevensegment_encoder
        port (A: in  std_logic_vector(3 downto 0);
              O: out std_logic_vector(6 downto 0));
    end component;
    component mux21
        generic (N: integer);
        port (A, B: in  std_logic_vector (N-1 downto 0);
              SEL:  in  std_logic;
              O:    out std_logic_vector (N-1 downto 0));
    end component;
    component display_controller
        port(CLK, RST: in std_logic;
             DIGIT_3, DIGIT_2, DIGIT_1, DIGIT_0: in std_logic_vector(7 downto 0);
             OUTPUT: out std_logic_vector (7 downto 0);
             AN:     out std_logic_vector (3 downto 0));
    end component;

    signal PL, PH, DL, DH: std_logic_vector (6 downto 0);
    signal ONES: std_logic_vector (6 downto 0) := (others => '1');
    signal DISPLAY_PL, DISPLAY_PH,
           DISPLAY_DL, DISPLAY_DH: std_logic_vector (6 downto 0);
    signal DIGIT_PL,   DIGIT_PH, 
           DIGIT_DL,   DIGIT_DH: std_logic_vector(7 downto 0);
begin
    sse_pl: sevensegment_encoder port map (PLAYER_L, PL);
    sse_ph: sevensegment_encoder port map (PLAYER_H, PH);
    sse_dl: sevensegment_encoder port map (DEALER_L, DL);
    sse_dh: sevensegment_encoder port map (DEALER_H, DH);

    mux_pl: mux21 generic map(7) 
                  port map (ONES, PL, PLAYER_SHOW, DISPLAY_PL);
    mux_ph: mux21 generic map(7) 
                  port map (ONES, PH, PLAYER_SHOW, DISPLAY_PH);
    mux_dl: mux21 generic map(7) 
                  port map (ONES, DL, DEALER_SHOW, DISPLAY_DL);
    mux_dh: mux21 generic map(7) 
                  port map (ONES, DH, DEALER_SHOW, DISPLAY_DH);

    DIGIT_PL <= not PLAYER_WIN & DISPLAY_PL;
    DIGIT_PH <= not PLAYER_WIN & DISPLAY_PH;
    DIGIT_DL <= not DEALER_WIN & DISPLAY_DL;
    DIGIT_DH <= not DEALER_WIN & DISPLAY_DH;

    display: display_controller
            port map (CLK, RST,
                      DIGIT_PH, DIGIT_PL, DIGIT_DH, DIGIT_DL,
                      OUTPUT, AN);
end structural;
