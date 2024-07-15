library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity mem_rw is
    generic(
        AWIDTH : positive :=9;
        DWIDTH : positive :=32
    );
    port(
        clk :   in std_logic;
        we :    in std_logic;
        addr :  in std_logic_vector(AWIDTH-1 downto 0);
        wdata:  in std_logic_vector(DWIDTH-1 downto 0);
        rdata: out std_logic_vector(DWIDTH-1 downto 0)
    );
end entity mem_rw;

architecture old_data of mem_rw is
    type ram_t is array(0 to 2**AWIDTH-1) of std_logic_vector(DWIDTH-1 downto 0);
    signal ram : ram_t;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            rdata <= ram(to_integer(unsigned(addr)));
            if we = '1' then
                ram(to_integer(unsigned(addr)))<= wdata;
            end if;
        end if;
    end process;
end architecture old_data;