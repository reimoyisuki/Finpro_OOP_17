library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CharTranslator is
    port (
        clk          : in std_logic;
        char_in      : in std_logic_vector(7 downto 0);
        next_char    : out std_logic;
        column_out   : out std_logic_vector(7 downto 0);
        matrix_ready : in std_logic;
        output_ready : out std_logic
    );
end CharTranslator;

architecture Behavioral of CharTranslator is
    type state_type is (Idle, LoadCharacter, OutputColumn);
    signal state: state_type := Idle;

    type matrix_type is array(0 to 255, 0 to 7) of std_logic_vector(7 downto 0);
    signal char: std_logic_vector(7 downto 0);
    signal char_matrix: matrix_type;
    signal column_index: integer range 0 to 7 := 0;

begin
    -- Initialize the character matrix
    process
    begin
        for i in 0 to 255 loop
            for j in 0 to 7 loop
                char_matrix(i, j) <= (others => '0'); -- Initialize to blank
            end loop;
        end loop;

        -- A
        char_matrix(65, 0) <= "00000000";
        char_matrix(65, 1) <= "00111100";
        char_matrix(65, 2) <= "01100110";
        char_matrix(65, 3) <= "01100110";
        char_matrix(65, 4) <= "01111110";
        char_matrix(65, 5) <= "01100110";
        char_matrix(65, 6) <= "01100110";
        char_matrix(65, 7) <= "01100110";

        -- B
        char_matrix(66, 0) <= "01111000";
        char_matrix(66, 1) <= "01001000";
        char_matrix(66, 2) <= "01001000";
        char_matrix(66, 3) <= "01110000";
        char_matrix(66, 4) <= "01001000";
        char_matrix(66, 5) <= "01000100";
        char_matrix(66, 6) <= "01000100";
        char_matrix(66, 7) <= "01111100";

        -- C
        char_matrix(67, 0) <= "00000000";
        char_matrix(67, 1) <= "00011110";
        char_matrix(67, 2) <= "00100000";
        char_matrix(67, 3) <= "01000000";
        char_matrix(67, 4) <= "01000000";
        char_matrix(67, 5) <= "01000000";
        char_matrix(67, 6) <= "00100000";
        char_matrix(67, 7) <= "00011110";

        -- D
        char_matrix(68, 0) <= "00000000";
        char_matrix(68, 1) <= "00111000";
        char_matrix(68, 2) <= "00100100";
        char_matrix(68, 3) <= "00100010";
        char_matrix(68, 4) <= "00100010";
        char_matrix(68, 5) <= "00100100";
        char_matrix(68, 6) <= "00111000";
        char_matrix(68, 7) <= "00000000";

        -- E
        char_matrix(69, 0) <= "00000000";
        char_matrix(69, 1) <= "00111100";
        char_matrix(69, 2) <= "00100000";
        char_matrix(69, 3) <= "00111000";
        char_matrix(69, 4) <= "00100000";
        char_matrix(69, 5) <= "00100000";
        char_matrix(69, 6) <= "00111100";
        char_matrix(69, 7) <= "00000000";

        -- F
        char_matrix(70, 0) <= "00000000";
        char_matrix(70, 1) <= "00111100";
        char_matrix(70, 2) <= "00100000";
        char_matrix(70, 3) <= "00111000";
        char_matrix(70, 4) <= "00100000";
        char_matrix(70, 5) <= "00100000";
        char_matrix(70, 6) <= "00100000";
        char_matrix(70, 7) <= "00000000";

        -- G
        char_matrix(71, 0) <= "00000000";
        char_matrix(71, 1) <= "00111110";
        char_matrix(71, 2) <= "00100000";
        char_matrix(71, 3) <= "00100000";
        char_matrix(71, 4) <= "00101110";
        char_matrix(71, 5) <= "00100010";
        char_matrix(71, 6) <= "00111110";
        char_matrix(71, 7) <= "00000000";

        -- H
        char_matrix(72, 0) <= "00000000";
        char_matrix(72, 1) <= "00100100";
        char_matrix(72, 2) <= "00100100";
        char_matrix(72, 3) <= "00111100";
        char_matrix(72, 4) <= "00100100";
        char_matrix(72, 5) <= "00100100";
        char_matrix(72, 6) <= "00100100";
        char_matrix(72, 7) <= "00000000";

        -- I
        char_matrix(73, 0) <= "00000000";
        char_matrix(73, 1) <= "00111000";
        char_matrix(73, 2) <= "00010000";
        char_matrix(73, 3) <= "00010000";
        char_matrix(73, 4) <= "00010000";
        char_matrix(73, 5) <= "00010000";
        char_matrix(73, 6) <= "00111000";
        char_matrix(73, 7) <= "00000000";

        -- J
        char_matrix(74, 0) <= "00000000";
        char_matrix(74, 1) <= "00011100";
        char_matrix(74, 2) <= "00001000";
        char_matrix(74, 3) <= "00001000";
        char_matrix(74, 4) <= "00001000";
        char_matrix(74, 5) <= "00101000";
        char_matrix(74, 6) <= "00111000";
        char_matrix(74, 7) <= "00000000";

        -- K
        char_matrix(75, 0) <= "00000000";
        char_matrix(75, 1) <= "00100100";
        char_matrix(75, 2) <= "00101000";
        char_matrix(75, 3) <= "00110000";
        char_matrix(75, 4) <= "00101000";
        char_matrix(75, 5) <= "00100100";
        char_matrix(75, 6) <= "00100100";
        char_matrix(75, 7) <= "00000000";

        -- L
        char_matrix(76, 0) <= "00000000";
        char_matrix(76, 1) <= "00100000";
        char_matrix(76, 2) <= "00100000";
        char_matrix(76, 3) <= "00100000";
        char_matrix(76, 4) <= "00100000";
        char_matrix(76, 5) <= "00100000";
        char_matrix(76, 6) <= "00111100";
        char_matrix(76, 7) <= "00000000";

        -- M
        char_matrix(77, 0) <= "00000000";
        char_matrix(77, 1) <= "01000100";
        char_matrix(77, 2) <= "10101010";
        char_matrix(77, 3) <= "10010010";
        char_matrix(77, 4) <= "10000010";
        char_matrix(77, 5) <= "10000010";
        char_matrix(77, 6) <= "10000010";
        char_matrix(77, 7) <= "00000000";

        -- N
        char_matrix(78, 0) <= "00000000";
        char_matrix(78, 1) <= "00100010";
        char_matrix(78, 2) <= "00110010";
        char_matrix(78, 3) <= "00101010";
        char_matrix(78, 4) <= "00100110";
        char_matrix(78, 5) <= "00100010";
        char_matrix(78, 6) <= "00100010";
        char_matrix(78, 7) <= "00000000";

        -- O
        char_matrix(79, 0) <= "00000000";
        char_matrix(79, 1) <= "00111100";
        char_matrix(79, 2) <= "01000010";
        char_matrix(79, 3) <= "01000010";
        char_matrix(79, 4) <= "01000010";
        char_matrix(79, 5) <= "01000010";
        char_matrix(79, 6) <= "00111100";
        char_matrix(79, 7) <= "00000000";

        -- P
        char_matrix(80, 0) <= "00000000";
        char_matrix(80, 1) <= "00111000";
        char_matrix(80, 2) <= "00100100";
        char_matrix(80, 3) <= "00100100";
        char_matrix(80, 4) <= "00111000";
        char_matrix(80, 5) <= "00100000";
        char_matrix(80, 6) <= "00100000";
        char_matrix(80, 7) <= "00000000";

        -- Q
        char_matrix(81, 0) <= "00000000";
        char_matrix(81, 1) <= "00111100";
        char_matrix(81, 2) <= "01000010";
        char_matrix(81, 3) <= "01000010";
        char_matrix(81, 4) <= "01000010";
        char_matrix(81, 5) <= "01000110";
        char_matrix(81, 6) <= "00111110";
        char_matrix(81, 7) <= "00000001";

        -- R
        char_matrix(82, 0) <= "00000000";
        char_matrix(82, 1) <= "00111000";
        char_matrix(82, 2) <= "00100100";
        char_matrix(82, 3) <= "00100100";
        char_matrix(82, 4) <= "00111000";
        char_matrix(82, 5) <= "00100100";
        char_matrix(82, 6) <= "00100100";
        char_matrix(82, 7) <= "00000000";

        -- S
        char_matrix(83, 0) <= "00000000";
        char_matrix(83, 1) <= "00111100";
        char_matrix(83, 2) <= "00100000";
        char_matrix(83, 3) <= "00111100";
        char_matrix(83, 4) <= "00000100";
        char_matrix(83, 5) <= "00000100";
        char_matrix(83, 6) <= "00111100";
        char_matrix(83, 7) <= "00000000";

        -- T
        char_matrix(84, 0) <= "00000000";
        char_matrix(84, 1) <= "01111100";
        char_matrix(84, 2) <= "00010000";
        char_matrix(84, 3) <= "00010000";
        char_matrix(84, 4) <= "00010000";
        char_matrix(84, 5) <= "00010000";
        char_matrix(84, 6) <= "00010000";
        char_matrix(84, 7) <= "00000000";

        -- U
        char_matrix(85, 0) <= "00000000";
        char_matrix(85, 1) <= "01000010";
        char_matrix(85, 2) <= "01000010";
        char_matrix(85, 3) <= "01000010";
        char_matrix(85, 4) <= "01000010";
        char_matrix(85, 5) <= "01000010";
        char_matrix(85, 6) <= "00111100";
        char_matrix(85, 7) <= "00000000";

        -- V
        char_matrix(86, 0) <= "00000000";
        char_matrix(86, 1) <= "00100010";
        char_matrix(86, 2) <= "00100010";
        char_matrix(86, 3) <= "00100010";
        char_matrix(86, 4) <= "00010100";
        char_matrix(86, 5) <= "00010100";
        char_matrix(86, 6) <= "00001000";
        char_matrix(86, 7) <= "00000000";

        -- W
        char_matrix(87, 0) <= "00000000";
        char_matrix(87, 1) <= "10000010";
        char_matrix(87, 2) <= "10010010";
        char_matrix(87, 3) <= "01010100";
        char_matrix(87, 4) <= "01010100";
        char_matrix(87, 5) <= "00101000";
        char_matrix(87, 6) <= "00000000";
        char_matrix(87, 7) <= "00000000";

        -- X
        char_matrix(88, 0) <= "00000000";
        char_matrix(88, 1) <= "01000010";
        char_matrix(88, 2) <= "00100100";
        char_matrix(88, 3) <= "00011000";
        char_matrix(88, 4) <= "00011000";
        char_matrix(88, 5) <= "00100100";
        char_matrix(88, 6) <= "01000010";
        char_matrix(88, 7) <= "00000000";

        -- Y
        char_matrix(89, 0) <= "00000000";
        char_matrix(89, 1) <= "01000100";
        char_matrix(89, 2) <= "00101000";
        char_matrix(89, 3) <= "00010000";
        char_matrix(89, 4) <= "00010000";
        char_matrix(89, 5) <= "00010000";
        char_matrix(89, 6) <= "00010000";
        char_matrix(89, 7) <= "00000000";

        -- Z
        char_matrix(90, 0) <= "00000000";
        char_matrix(90, 1) <= "00111100";
        char_matrix(90, 2) <= "00000100";
        char_matrix(90, 3) <= "00001000";
        char_matrix(90, 4) <= "00010000";
        char_matrix(90, 5) <= "00100000";
        char_matrix(90, 6) <= "00111100";
        char_matrix(90, 7) <= "00000000";

        wait; -- Initialization complete
    end process;

    -- Main process for state-based control
    process (clk)
    begin
        if rising_edge(clk) then
            case state is
                when Idle =>
                    output_ready <= '0';
                    next_char <= '0';
                    if matrix_ready = '1' then
                        next_char <= '1'; -- Request next character from InputHandler
                        state <= LoadCharacter;
                    end if;

                when LoadCharacter =>
                    char <= char_in;
                    next_char <= '0';
                    output_ready <= '1';
                    column_index <= 0;
                    state <= OutputColumn;

                when OutputColumn =>
                    column_out <= char_matrix(to_integer(unsigned(char)), column_index);
                    if column_index = 7 then
                        state <= Idle; -- All columns sent, wait for the next character
                    else
                        column_index <= column_index + 1;
                    end if;
            end case;
        end if;
    end process;
end Behavioral;
