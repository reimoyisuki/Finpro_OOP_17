library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity InputHandler is
    Port (
        clk          : in std_logic;
        reset        : in std_logic;
        input_text   : in std_logic_vector(7 downto 0); -- Input text character
        input_valid  : in std_logic;                   -- Input validity signal
        output_text  : out std_logic_vector(7 downto 0); -- Output character
        next_request : in std_logic                    -- Request for next character
    );
end InputHandler;

architecture Behavioral of InputHandler is
    -- Define states
    type state_type is (Idle, Receive, WaitTranslate, Output);
    signal state: state_type := Idle;

    -- Internal memory to store the input text
    type text_memory_type is array (0 to 15) of std_logic_vector(7 downto 0);
    signal text_memory: text_memory_type := (others => (others => '0'));

    -- Current character index
    signal char_index: integer range 0 to 15 := 0;
    signal char_count: integer range 0 to 15 := 0; -- Keeps track of total characters read

begin
    process (clk, reset)
    begin
        if reset = '1' then
            -- Reset all signals
            state <= Idle;
            char_index <= 0;
            char_count <= 0;
            output_text <= (others => '0');
            text_memory <= (others => (others => '0'));
        elsif rising_edge(clk) then
            case state is
                when Idle =>
                    if input_valid = '1' then
                        state <= Receive;
                        char_index <= 0;
                        char_count <= 0; -- Reset character count for new input
                    end if;

                when Receive =>
                    -- Store the input character into text memory
                    text_memory(char_count) <= input_text;
                    char_count <= char_count + 1;

                    -- Transition to WaitTranslate if `input_valid` is deasserted
                    if input_valid = '0' or char_count = 15 then
                        state <= WaitTranslate;
                        char_index <= 0; -- Prepare for output
                    end if;

                when WaitTranslate =>
                    -- Wait for the translator to request the next character
                    if next_request = '1' then
                        state <= Output;
                    end if;

                when Output =>
                    -- Send the current character to the output
                    output_text <= text_memory(char_index);

                    if char_index = char_count - 1 then
                        char_index <= 0; -- Reset index for the next round
                    else
                        char_index <= char_index + 1;
                    end if;

                    state <= WaitTranslate;
            end case;
        end if;
    end process;
end Behavioral;
