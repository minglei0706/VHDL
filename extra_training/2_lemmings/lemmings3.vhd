--module top_module(
--    input clk,
--    input areset,    // Freshly brainwashed Lemmings walk left.
--    input bump_left,
--    input bump_right,
--    input ground,
--    input dig,
--    output walk_left,
--    output walk_right,
--    output aaah,
--    output digging ); 
--    
--    parameter LEFT = 3'b000,RIGHT = 3'b001,FALL_LEFT = 3'b010,FALL_RIGHT = 3'b011,DIG_LEFT = 3'b100,DIG_RIGHT = 3'b101;
--    reg [2:0] state,next_state;
--    
--    always@(posedge clk or posedge areset)
--        begin
            if(areset)
                state <= LEFT;
            else
                state <= next_state;
--        end
--   
--   always@(*)
--        begin
--            case(state)
--                LEFT: next_state = ground?(dig?DIG_LEFT:
--                                           (bump_left?RIGHT:
--                                            LEFT)):FALL_LEFT;
--                RIGHT:next_state = ground?(dig?DIG_RIGHT:
--                                           bump_right?LEFT:
--                                           RIGHT):FALL_RIGHT;
--                DIG_LEFT:next_state = ground?DIG_LEFT:FALL_LEFT;
--                DIG_RIGHT:next_state = ground?DIG_RIGHT:FALL_RIGHT;
--                FALL_LEFT:next_state = ground?LEFT:FALL_LEFT;
--                FALL_RIGHT:next_state = ground?RIGHT:FALL_RIGHT;
--                default: next_state = LEFT;
--            endcase
--        end
--    assign walk_left = (state==LEFT)?1'b1:1'b0;
--    assign walk_right = (state == RIGHT)?1'b1:1'b0;
--    assign aaah = (state == FALL_LEFT || state == FALL_RIGHT)?1'b1:1'b0;
--    assign digging = (state == DIG_LEFT || state == DIG_RIGHT)?1'b1:1'b0;
--
--endmodule

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity lemmings3 is
    port(
        clk : in std_logic;
        areset : in std_logic;
        bump_left : in std_logic;
        bump_right : in std_logic;
        ground : in std_logic;
        dig : in std_logic;
        walk_left : out std_logic;
        walk_right : out std_logic;
        aaah : out std_logic;
        digging : out std_logic
    );
end entity;

architecture behavioral of lemmings3 is
    type state_type is (LEFT, RIGHT, FALL_LEFT, FALL_RIGHT, DIG_LEFT, DIG_RIGHT)
    signal state, next_state : state_type;

    attribute enum_encoding : string;
    attribute enum_encoding of state : signal is "one-hot";
begin
    process(clk, areset)
    begin
        if areset = '1' then
            state <= LEFT;
        elsif rising_edge(clk) then
            state <= next_state;
        end if ;
    end process;

    process(state, ground, dig, bump_left, bump_right)
    begin
        case state is
            when LEFT =>
                next_state <= (ground = '1')? (dig = '1')? DIG_LEFT : (bump_left = '1')? RIGHT: LEFT: FALL_LEFT;
            when RIGHT =>
                next_state <= (ground = '1')? (dig = '1')? DIG_RIGHT:(bump_right = '1')? LEFT:RIGHT:FALL_RIGHT;
            when DIG_LEFT =>
                next_state <= (ground = '1')? DIG_LEFT : FALL_LEFT;
            when DIG_RIGHT =>
                next_state <= (ground = '1')? DIG_RIGHT : FALL_RIGHT;
            when FALL_LEFT =>
                next_state <= (ground = '1')? LEFT : FALL_LEFT;
            when FALL_RIGHT =>
                next_state <= (ground = '1')? RIGHT : FALL_RIGHT;
            when others => next_state <= LEFT;
        end case;
    end process;

    walk_left <= '1' when state = LEFT else '0';
    walk_right <= '1' when state = RIGHT else '0';
    aaah <= 1' when (state = FALL_LEFT or state = FALL_RIGHT) else '0';
    digging <= '1' when (state = DIG_LEFT or state = DIG_RIGHT) else '0';

end architecture;