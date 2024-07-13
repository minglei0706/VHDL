library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity mem_rw_rw is
    generic(
        AWIDTH : positive :=9;
        DWIDTH : positive :=64
    );
    port(
        clk_a, clk_b: in std_logic;
        we_a, we_b: in std_logic;
        addr_a,addr_b: in std_logic_vector(AWIDTH-1 downto 0);
        wdata_a, wdata_b: in std_logic_vector(DWIDTH-1 downto 0);
        rdata_a, rdata_b: out std_logic_vector(DWIDTH-1 downto 0)
    );
end entity mem_rw_rw;

architecture behaviour of mem_rw_rw is
    type ram_t is array(0 to 2**AWIDTH-1) of std_logic_vector(DWIDTH-1 downto 0);
    signal ram:ram_t;
begin
    process(clk_a)
    begin
        if rising_edge(clk_a) then
            rdata_a <= ram(to_integer(unsigned(addr_a)));
            if we_a = '1' then
                ram(to_integer(unsigned(addr_a))) <= wdata_a;
            end if;
        end if;
    end process;

    process(clk_b)
    begin
        if rising_edge(clk_b) then
            rdata_b <= ram(to_integer(unsigned(addr_b)));
            if we_b = '1' then
                ram(to_integer(unsigned(addr_b))) <= wdata_b;
            end if;
        end if;
    end process;
    
end architecture behaviour;