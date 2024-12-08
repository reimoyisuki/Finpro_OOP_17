library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MainFile is
    Port (
        clk          : in std_logic;                      -- Clock signal
        reset        : in std_logic;                      -- Reset signal
        input_text   : in std_logic_vector(7 downto 0);   -- Text input (ASCII)
        input_valid  : in std_logic;                      -- Input validity signal
        matrix_out   : out std_logic_vector(63 downto 0)  -- Output to LED matrix
    );
end MainFile;

architecture Structural of MainFile is
    component InputHandler is
        Port (
            clk          : in std_logic;
            reset        : in std_logic;
            input_text   : in std_logic_vector(7 downto 0); -- Input text character
            input_valid  : in std_logic;                   -- Input validity signal
            output_text  : out std_logic_vector(7 downto 0); -- Output character
            next_request : in std_logic                    -- Request for next character
        );
    end component;

    component CharTranslator is
        port (
            clk          : in std_logic;
            char_in      : in std_logic_vector(7 downto 0);
            next_char    : out std_logic;
            column_out   : out std_logic_vector(7 downto 0);
            matrix_ready : in std_logic;
            output_ready : out std_logic
        );
    end component;


    component MatrixController is
        Port (
            clk            : in std_logic;
            reset          : in std_logic;
            column_in      : in std_logic_vector(7 downto 0); -- Serialized column data
            led_out        : out std_logic_vector(63 downto 0); -- 8x8 LED matrix output
            ready_for_input : out std_logic;                    -- Indicates readiness for new input
            column_ready    : in std_logic                      -- Indicates column data is ready
        );
    end component;

    -- Internal signals
    signal char_signal       : std_logic_vector(7 downto 0); -- Character from InputHandler
    signal column_signal     : std_logic_vector(7 downto 0); -- Column data for LED matrix
    signal next_char_signal  : std_logic;                   -- Request for next character
    signal matrix_ready_signal : std_logic;                 -- Ready signal from MatrixController
    signal column_ready_signal : std_logic;
begin
    -- Instantiate InputHandler
    input_inst: InputHandler
        port map (
            clk          => clk,
            reset        => reset,
            input_text   => input_text,
            input_valid  => input_valid,
            output_text  => char_signal,
            next_request => next_char_signal
        );

    -- Instantiate CharTranslator
    translator_inst: CharTranslator
        port map (
            clk          => clk,
            char_in      => char_signal,
            next_char    => next_char_signal,
            column_out   => column_signal,
            matrix_ready => matrix_ready_signal,
            output_ready => column_ready_signal
        );

    -- Instantiate MatrixController
    matrix_inst: MatrixController
        port map (
            clk            => clk,
            reset          => reset,
            column_in      => column_signal,
            led_out        => matrix_out,
            ready_for_input => matrix_ready_signal,
            column_ready => column_ready_signal
        );
end Structural;
