library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std,all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity shift_reg_ff is
    generic (TAPS : integer := 32);
    port(
        clk :   in std_logic;
        shift:  in std_logic;
        d_in:   in std_logic;
        d_out:  out std_logic_vector(TAPS-1 downto 0)
    );
end entity shift_reg_ff;

architecture behaviour of shift_reg_ff is
    signal shift_ff: std_logic_vector (Taps-1 downto 0):=(others=>'0');
begin
    ff:process(clk)
        if rising_edge(clk) then
            if shift = '1' then
                --concatenation of d_in and shift_ff
                shift_ff <= d_in & schift_ff(TAPS-1 downto 1);
            end if;
        end if;
    end process ff;
    d_out <= shift_ff;
end architecture behaviour;