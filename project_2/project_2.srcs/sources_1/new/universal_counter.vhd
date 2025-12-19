library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



entity universal_counter is
    Port ( clk : in STD_LOGIC; -- clock
           arst_n : in STD_LOGIC; -- reset
           enable : in STD_LOGIC; -- enable for counting
           load : in STD_LOGIC; -- load data
           dir : in STD_LOGIC;  -- direction for up and down counting
           data : in std_logic_vector(3 downto 0); -- data storage for 4 bit 
           count : out std_logic_vector(3 downto 0); -- 4 bit counter
           over : out STD_LOGIC); -- overflow/underflow 
end universal_counter;

architecture Behavioral of universal_counter is
    -- signal count_t: integer := 0; -- declare count_t for counting
    signal cnt_reg : unsigned(3 downto 0) := (others => '0');
    signal over_reg: std_logic := '0';
begin

 -- Single process (async reset, synchronous behavior otherwise)
    proc : process(clk, arst_n)
    begin
        if arst_n = '0' then
            cnt_reg  <= (others => '0');
            over_reg <= '0';
        elsif rising_edge(clk) then
            if enable = '0' then
                -- paused: hold current count and clear over
                over_reg <= '0';
                -- cnt_reg unchanged
            else
                -- enable = '1'
                if load = '1' then
                    -- load current data onto count (priority to load)
                    cnt_reg  <= unsigned(data);
                    over_reg <= '0';
                else
                    -- normal counting
                    if dir = '0' then  -- count up
                        if cnt_reg = to_unsigned(15, 4) then
                            cnt_reg  <= to_unsigned(0, 4);  -- wrap to 0
                            over_reg <= '1';                -- overflow pulse (one clock)
                        else
                            cnt_reg  <= cnt_reg + 1;
                            over_reg <= '0';
                        end if;
                    else               -- dir = '1' count down
                        if cnt_reg = to_unsigned(0, 4) then
                            cnt_reg  <= to_unsigned(15, 4); -- wrap to 15
                            over_reg <= '1';                -- underflow pulse
                        else
                            cnt_reg  <= cnt_reg - 1;
                            over_reg <= '0';
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;

    count <= std_logic_vector(cnt_reg);
    over  <= over_reg;

end Behavioral;






   
