library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity mem_r_w is
    generic(
        AWIDTH : positive := 9;
        DWIDTH : positive := 64
    );
    port(
        clk,we :        in std_logic;
        waddr, raddr :  in std_logic_vector(AWIDTH-1 downto 0);
        wdata :         in std_logic_vector(DWIDTH-1 downto 0);
        rdata :         out std_logic_vector(DWIDTH-1 downto 0)
    );
end entity mem_r_w;

architecture forward of mem_r_w is
    signal raddr_reg: std_logic_vector(raddr'range);
    type ram_t is array (0 to 2**AWIDTH-1) of std_logic_vector(wdata'range);
    signal ram: ram_t;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            raddr_reg <= raddr;
            if we = '1'then
                ram(to_integer(unsigned(waddr))) <= wdata;
            end if;
        end if;
    end process;
    rdata <= ram(to_integer(unsigned(raddr_reg)));
end architecture forward;
