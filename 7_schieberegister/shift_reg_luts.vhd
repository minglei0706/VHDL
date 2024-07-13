library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std,all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity shift_reg_luts is
    generic (MAX_DEPTH : integer := 64);
    port(
        taps:   in std_logic_vector(BITS(MAX_DEPTH-1)-1 downto 0)
        clk :   in std_logic;
        shift:  in std_logic;
        d_in:   in std_logic;
        d_out:  out std_logic
    );
end entity shift_reg_luts;

architecture behaviour of shift_reg_luts is
    signal shift_ff: std_logic_vector (0 to MAX_DEPTH-1);
begin
    LUT:process(clk)
        if rising_edge(clk) then
            if shift = '1' then
                --concatenation of d_in and shift_ff
                shift_ff <= d_in & schift_ff(0 to MAX_DEPTH-2);
            end if;
        end if;
    end process LUT;
    --output selection
    d_out <= shift_ff(to_ingeger(unsigned(taps)));
end architecture behaviour;

function BITS(n: natural) return natural is
    begin
        if n = 1 then return 1;
        else return (1+BITS(n/2));
        end if;
    end function bits;