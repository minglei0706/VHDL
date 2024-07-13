--library and package
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--entity

entity vote13 is
port(
    vote : in std_logic_vector(12 downto 0);
    result : out std_logic

);
end entity vote13;

--architecture
architecture behavior of vote13 is
begin
    process(vote)
    variable sum : integer range 0 to 13;
    begin
        sum := 0;
        for i in 0 to 12 loop
            if(vote(i)=1) then 
                sum := sum + 1;
                if(sum>=7) then result <= 1;
                else result <= 0;
                end if;
            else sum := sum;
            end if;
        end loop;
    end process;
end architecture behavior;