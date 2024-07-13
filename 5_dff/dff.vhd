--libraray and package
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--entity
entity dff is
port(
    d: in std_logic;
    reset: in std_logic;
    clk: in std_logic;
    q: out std_logic
);
end entity dff;

--architecture
architecture behaviour of dff is
begin
    process(clk, reset)
    begin
        if(reset = '1') then
            q <= '0';
        elsif(rising_edge(clk)) then
            q <= d;
        end if;
    end process;
end architecture behaviour;