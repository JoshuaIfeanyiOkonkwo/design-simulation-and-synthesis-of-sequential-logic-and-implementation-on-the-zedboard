library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
    Port ( 
        CLK_100MHz : in  std_logic;       -- board clock
        -- control switches (connect to board DIP switches)
        SW_ARST_N  : in  std_logic;       -- async reset (active low)
        SW_ENABLE  : in  std_logic;
        SW_LOAD    : in  std_logic;
        SW_DIR     : in  std_logic;
        SW_DATA    : in  std_logic_vector(3 downto 0);
        -- LEDs
        LED_COUNT  : out std_logic_vector(3 downto 0);
        LED_OVER   : out std_logic
    );
end top_level;

architecture Behavioral of top_level is
    signal slow_clk : std_logic;
    -- internal count wires
    signal count_sig : std_logic_vector(3 downto 0);
    signal over_sig  : std_logic;

    -- declare clock_divider component
    component Clock_Divider
        generic (
            div : natural := 10000000
        );
        Port ( 
            clk      : in std_logic;
            arst_n   : in std_logic;
            clk_out  : out std_logic
        );
    end component;

    -- connect to universal_counter file
    component universal_counter
        Port ( 
            clk    : in std_logic;
            arst_n : in std_logic;
            enable : in std_logic;
            load   : in std_logic;
            dir    : in std_logic;
            data   : in std_logic_vector(3 downto 0);
            count  : out std_logic_vector(3 downto 0);
            over   : out std_logic
        );
    end component;

begin

    -- connect module clock_Divider and map them together
    clk_div_inst : Clock_Divider
        generic map (
            div => 10000000
        )
        port map (
            clk     => CLK_100MHz,
            arst_n  => SW_ARST_N,
            clk_out => slow_clk
        );

    -- connect module universal_counter and map with clock divided
    counter_inst : universal_counter
        port map (
            clk    => slow_clk,
            arst_n => SW_ARST_N,
            enable => SW_ENABLE,
            load   => SW_LOAD,
            dir    => SW_DIR,
            data   => SW_DATA,
            count  => count_sig,
            over   => over_sig
        );      
        
     -- drive LEDs directly
    LED_COUNT <= count_sig;
    LED_OVER  <= over_sig; 
    
end Behavioral;
