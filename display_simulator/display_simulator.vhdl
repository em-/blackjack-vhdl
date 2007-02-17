library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_simulator is
    port(E14, G13, N15, P15, R16, F13, N16: in std_logic; -- display
         P16:                               in std_logic; -- DP
         E13, F14, G14, D14:                in std_logic; -- AN(3 downto 0)
        
         DIGITS_0, DIGITS_1, DIGITS_2, DIGITS_3: out character := ' ';
         DOTS_0,   DOTS_1,   DOTS_2,   DOTS_3:   out boolean);
end display_simulator;


architecture structural of display_simulator is
    signal DIGIT: std_logic_vector (6 downto 0);
    signal DOT:   std_logic;
    signal AN:    std_logic_vector (3 downto 0);
begin

DIGIT <= E14 & G13 & N15 & P15 & R16 & F13 & N16;
DOT <= P16;
AN <= E13 & F14 & G14 & D14;

process(DIGIT, DOT, AN)
    variable char: character;
    variable point: boolean;
begin
    if    DIGIT(6 downto 0) = "0000001" then
        char := '0';
    elsif DIGIT(6 downto 0) = "1001111" then
        char := '1';
    elsif DIGIT(6 downto 0) = "0010010" then
        char := '2';
    elsif DIGIT(6 downto 0) = "0000110" then
        char := '3';
    elsif DIGIT(6 downto 0) = "1001100" then
        char := '4';
    elsif DIGIT(6 downto 0) = "0100100" then
        char := '5';
    elsif DIGIT(6 downto 0) = "0100000" then
        char := '6';
    elsif DIGIT(6 downto 0) = "0001111" then
        char := '7';
    elsif DIGIT(6 downto 0) = "0000000" then
        char := '8';
    elsif DIGIT(6 downto 0) = "0000100" then
        char := '9';
    elsif DIGIT(6 downto 0) = "1111111" then
        char := ' ';
    else
        char := '*';
    end if;

    if DOT = '0' then
        point := True;
    else
        point := False;
    end if;

    if AN(3) = '0' then
        DIGITS_0 <= char;
        DOTS_0 <= point;
    end if;

    if AN(2) = '0' then
        DIGITS_1 <= char;
        DOTS_1 <= point;
    end if;

    if AN(1) = '0' then
        DIGITS_2 <= char;
        DOTS_2 <= point;
    end if;

    if AN(0) = '0' then
        DIGITS_3 <= char;
        DOTS_3 <= point;
    end if;
end process;
end structural;
