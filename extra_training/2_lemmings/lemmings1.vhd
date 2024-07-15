--module top_module(
--    input clk,
--    input areset,    // Freshly brainwashed Lemmings walk left.
--    input bump_left,
--    input bump_right,
--    output walk_left,
--    output walk_right); //  
--
--    // parameter LEFT=0, RIGHT=1, ...
--    reg state, next_state;
--    parameter LEFT = 1'b0,RIGHT = 1'b1;
--
--    always @(*) begin
--        // State transition logic
--        case(state)
--            LEFT:next_state = (bump_left)?RIGHT:LEFT;
--            RIGHT:next_state = (bump_right)?LEFT:RIGHT;
--            default:next_state = LEFT;
--        endcase
--    end
--
--    always @(posedge clk, posedge areset) begin--
--        // State flip-flops with asynchronous reset
--        if(areset)
--            state <= LEFT;
--        else
--            state <= next_state;
--    end
--
--    //Output logic
--            assign walk_left = (state == LEFT)? 1'b1 : 1'b0;
--            assign walk_right = (state == RIGHT)? 1'b1 : 1'b0;
--
--endmodule

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity lemmings1 is
    port (
        clk : in std_logic;
        areset : in std_logic;
        bump_left : in std_logic;
        bump_right : in std_logic;
        walk_left : out std_logic;
        walk_right : out std_logic
    );
end entity lemmings1;

architecture behavioral of lemmings1 is
    type state_type is (LEFT, RIGHT);
    signal state,next_state : state_type;

begin
    process(clk, areset)
    begin
        if(areset = '1') then
            state <= LEFT;
        elsif(rising_edge(clk)) then
            state <= next_state;
        end if;
    end process;

    process(state, bump_left, bump_right)
    begin
        case(state) is
            when LEFT =>
                if(bump_left = '1') then 
                    next_state <= RIGHT;
                else
                    next_state <= LEFT;
                end if;
            when RIGHT =>
                if(bump_right = '1') then 
                    next_state <= LEFT;
                else
                    next_state <= RIGHT;
                end if;
            when others =>
                next_state <= LEFT;
        end case;
    end process;
    walk_left <= '1' when state = LEFT else '0';
    walk_right <= '1' when state = RIGHT else '0';

end architecture behavioral;

