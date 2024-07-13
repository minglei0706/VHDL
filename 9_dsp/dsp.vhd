library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity dsp is
    port (
        clk :           in std_logic;
        a,b :           in std_logic_vector(7 downto 0);
        rstn :          in std_logic;
        accum_out :     out std_logic_vector(15 downto 0)
    );
end entity dsp;

architecture rtl of mult_dsp is
    signal a_reg, b_reg : signed(7 downto 0);
    signal adder_out : signed(15 downto 0);
begin
    process(clk, rstn)
    begin
        if(rstn = '1') then
            a_reg <= (others => '0');
            b_reg <= (others => '0');
            adder_out <= (others => '0');
        elsif rising_edge(clk) then
            a_reg <= signed(a);
            b_reg <= signed(b);
            adder_out <= a_reg + b_reg;
        end if;
    end process;
    accum_out <= std_logic_vector(adder_out);
end architecture rtl;