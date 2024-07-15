--libiary and package
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std__logic_unsigned.all;

--entity
entity basic_logic is
    port(
        a,b,c,d: in std_logic;
        out_and,out_or : out std_logic;
        out_xor,out_nand,out_nor,out_xnor: out std_logic
    );
end entity basic_logic;

--architecture
architecture behavior of test is
begin
    out_and <= a and b and c and d;
    out_or <= a or b or c or d;
    out_xor <= a xor b xor c xor d;
    out_nand <= not (a and b and c and d);
    out_nor <= not (a or b or c or d);
    out_xnor <= not (a xor b xor c xor d);
end architecture behavior;
