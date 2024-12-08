library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MatrixController is
    Port (
        clk            : in std_logic;
        reset          : in std_logic;
        column_in      : in std_logic_vector(7 downto 0); -- Serialized column data
        led_out        : out std_logic_vector(63 downto 0); -- 8x8 LED matrix output
        ready_for_input : out std_logic;                    -- Indicates readiness for new input
        column_ready    : in std_logic                      -- Indicates column data is ready
    );
end MatrixController;

architecture Behavioral of MatrixController is
    -- Define states
    type state_type is (Idle, Shift, Delay);
    signal state: state_type := Idle;

    -- Signals for operations
    signal shift_register: std_logic_vector(63 downto 0) := (others => '0'); -- Matrix storage
    signal delay_counter: unsigned(19 downto 0) := (others => '0');          -- Adjustable delay counter
    constant delay_limit: unsigned(19 downto 0) := to_unsigned(1000, 20);    -- Adjust delay limit for clock frequency

begin
    process (clk, reset)
    begin
        if reset = '1' then
            -- Reset all signals
            shift_register <= (others => '0');
            delay_counter <= (others => '0');
            ready_for_input <= '0';
            state <= Idle;

        elsif rising_edge(clk) then
            case state is
                when Idle =>
                    -- Ready to accept new input
                    ready_for_input <= '1';
                    if column_ready = '1' then
                        ready_for_input <= '0';
                        state <= Shift;
                    end if;

                when Shift =>
                    -- Shift register left and append new column
                    shift_register <= shift_register(55 downto 0) & column_in;
                    state <= Delay;

                when Delay =>
                    -- Implement delay
                    if delay_counter = delay_limit then
                        delay_counter <= (others => '0');
                        state <= Idle;
                    else
                        delay_counter <= delay_counter + 1;
                    end if;
            end case;
        end if;
    end process;

    -- Output the current state of the shift register to the LED matrix
    led_out <= shift_register;

end Behavioral;
