library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_tb is
end counter_tb;

architecture Behavioral of counter_tb is

    -- Component declaration for the DUT
    component universal_counter
        port(
            clk    : in  std_logic;
            arst_n : in  std_logic;
            enable : in  std_logic;
            load   : in  std_logic;
            dir    : in  std_logic;
            data   : in  std_logic_vector(3 downto 0);
            count  : out std_logic_vector(3 downto 0);
            over   : out std_logic
        );
    end component;

    -- Signals to connect to the DUT
    signal clk    : std_logic := '0';
    signal arst_n : std_logic := '1';
    signal enable : std_logic := '0';
    signal load   : std_logic := '0';
    signal dir    : std_logic := '0';
    signal data   : std_logic_vector(3 downto 0) := (others => '0');
    signal count  : std_logic_vector(3 downto 0);
    signal over   : std_logic;

    -- Clock period constant
    constant PERIOD : time := 10 ns;  -- 100 MHz simulation clock

begin

    -- Instantiate the DUT
    DUT: universal_counter
        port map (
            clk    => clk,
            arst_n => arst_n,
            enable => enable,
            load   => load,
            dir    => dir,
            data   => data,
            count  => count,
            over   => over
        );

    -- Clock generation
    clk_work: process
    begin
        while now < 5 ms loop
            clk <= '0'; wait for PERIOD / 2;
            clk <= '1'; wait for PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Test stimulus
    stim_proc: process
    begin
        -- 1) Assert async reset
        arst_n <= '0'; wait for 30 ns;
        arst_n <= '1'; wait for 30 ns;

        -- 2) Test load while paused (enable = 0) - load ignored because enable=0
        data <= "0101"; load <= '1'; enable <= '0';
        wait for 20 ns;
        load <= '0';
        wait for 40 ns;

        -- 3) Enable and load (should load)
        enable <= '1'; load <= '1';
        wait for 20 ns;
        load <= '0';
        wait for 40 ns;

        -- 4) Count up from 5 to overflow
        dir <= '0';
        wait for 10 * PERIOD;

        -- Load 1110 (14) to test overflow
        load <= '1'; data <= "1110"; wait for 2 * PERIOD;
        load <= '0';
        wait for 6 * PERIOD;

        -- 5) Test underflow (count down)
        dir <= '1';
        wait for 4 * PERIOD;
        load <= '1'; data <= "0000"; wait for 2 * PERIOD; load <= '0';
        wait for 2 * PERIOD; -- underflow occurs

        -- 6) Pause enable and check hold
        enable <= '0';
        wait for 6 * PERIOD;

        -- 7) Test load while enabled (should load)
        enable <= '1'; load <= '1'; data <= "0011"; wait for 2 * PERIOD; load <= '0';
        wait for 4 * PERIOD;

        -- 8) Final reset
        arst_n <= '0'; wait for 30 ns;
        arst_n <= '1'; wait for 30 ns;

        wait; -- end simulation
    end process;

end Behavioral;
