--              -------------
--              |      a    |
--              |           |
--        f     |           |   b
--              |           |
--              |___________|           
--              |     g     |  
--              |           |  
--         e    |           |  c
--              |           |      
--              |     d     |  
--              |-----------|
--              display = {a,b,c,d,e,f,g}

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--entity

entity sevensigdis is
    port(
        en: in std_logic;
        data: in std_logic_vector(3 downto 0);
        display: out std_logic_vector(6 downto 0)

    );
end entity sevensigdis;

--architector

architecture behavior of sevensigdis is
    begin
        process(en, data)
        begin
            if(en = '0') then 
                display <= "zzzzzzz";
            else
                case data is
                    when "0000" => display <= "1111110"
                    when "0001" => display <= "0110000"
                    when "0010" => display <= "1101101"
                    when "0011" => display <= "1111001"
                    when "0100" => display <= "0110011"
                    when "0101" => display <= "1011011"
                    when "0110" => display <= "1011111"
                    when "0111" => display <= "1110000"
                    when "1000" => display <= "1111111"
                    when "1001" => display <= "1110011"
                    when others => display <= "zzzzzzz"
                end case;
            end if;
        end process;
    end architecture behavior;
