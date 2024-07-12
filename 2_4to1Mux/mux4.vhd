--library and package declarations
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--entity
entity mux4 is
    port(
        I0, I1, I2, I3: in std_logic;
        sel: in std_logic_vector(1 downto 0);
        o: out std_logic
    );
end entity mux4;

--architrcture
architecture behavior of mux4 is
begin
    process(I0, I1, I2, I3, sel)
    begin
        case cel is
            when "00" => o <= I0;
            when "01" => o <= I1;
            when "10" => o <= I2;
            when "11" => o <= I3;
            when others => o <= 'X';
        end case;
    end process;
end architecture behavior;