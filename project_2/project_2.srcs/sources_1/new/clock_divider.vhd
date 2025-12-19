library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Clock_Divider is
    generic (
            div : natural := 10000000  -- default divide factor
        );
        port (
            clk  : in  std_logic;
            arst_n  : in  std_logic;
            clk_out : out std_logic
        );
end Clock_Divider;

architecture bhv of Clock_Divider is
    signal cnt : unsigned(31 downto 0) := (others => '0');
    signal out_reg : std_logic := '0';
begin

    process(clk, arst_n)
        begin
            if arst_n = '0' then
                cnt <= (others => '0');
                out_reg <= '0';
            elsif rising_edge(clk) then
                if cnt = to_unsigned(div/2 - 1, cnt'length) then
                    out_reg <= not out_reg;
                    cnt <= (others => '0');
                else
                    cnt <= cnt + 1;
                end if;
            end if;
            
        end process;
    
    clk_out <= out_reg;
        
end bhv;

