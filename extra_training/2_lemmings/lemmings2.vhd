--module top_module(
--    input clk,
--    input areset,    // Freshly brainwashed Lemmings walk left.
--    input bump_left,
--    input bump_right,
--    input ground,
--    output walk_left,
--    output walk_right,
--    output aaah ); 
--    
--    parameter LEFT = 2'b00,RIGHT = 2'b01,FALL_LEFT = 2'b10,FALL_RIGHT = 2'b11;
--    reg [1:0] state,next_state;
--    
--    always@(posedge clk or posedge areset)
--        begin
--            if(areset)
--                state <= LEFT;
--            else
--                state <= next_state;
--        end
--    
--    always@(*)
--        begin
--            case(state)
--                LEFT: next_state = ground? (bump_left?RIGHT:LEFT):FALL_LEFT;
--                RIGHT:next_state = ground? (bump_right?LEFT:RIGHT):FALL_RIGHT;
--                FALL_LEFT:next_state = ground?LEFT:FALL_LEFT;
--                FALL_RIGHT:next_state = ground?RIGHT:FALL_RIGHT;
--                default: next_state = LEFT;
--            endcase
--        end
--    assign walk_left = (state==LEFT)?1'b1:1'b0;
--    assign walk_right = (state == RIGHT)?1'b1:1'b0;
--    assign aaah = (state == FALL_LEFT || state == FALL_RIGHT)?1'b1:1'b0;
--
--endmodule
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity lemmings2 is
    port(
        clk: in std_logic;
        areset: in std_logic;
        bump_left: in std_logic;
        bump_right: in std_logic;
        ground: in std_logic;
        walk_left: out std_logic;
        walk_right: out std_logic;
        aaah: out std_logic
    );
end entity lemmings2;

architecture behavioral of lemmings2 is
    type state_type is (LEFT, RIGHT, FALL_LEFT, FALL_RIGHT);
    signal state: state_type;
    signal next_state: state_type;

    attribute enum_encoding : string;
    attribute enum_encoding of state_type : type is "00 01 10 11";
begin
    process(clk, areset)
    begin
        if(areset = '1') then
            state <= LEFT;
        elsif(rising_edge(clk)) then
            state <= next_state;
        end if;
    end process;

    process(state, bump_left, bump_right, ground)
    begin
        case(state) is
            when LEFT =>
                if ground = '1' then
                    if bump_left = '1' then
                        next_state <= RIGHT;
                    else
                        next_state <= LEFT;
                    end if;
                else
                    next_state <= FALL_LEFT;        
                end if; 
            when RIGHT =>
                next_state <= (ground = '1')?
                                (bump_right = '1')?LEFT:RIGHT
                                :FALL_RIGHT;
            when FALL_LEFT =>
                next_state <= (ground = '1')?LEFT:FALL_LEFT;
            when FALL_RIGHT =>
                next_state <= (ground = '1')?RIGHT:FALL_RIGHT;
            when others =>
                next_state <= LEFT;
        end case;
    end process;

    walk_left <= '1' when state = LEFT else '0';
    walk_right <= '1' when state = RIGHT else '0';
    aaah <= '1' when (state = FALL_LEFT or state = FALL_RIGHT) else '0';
end architecture behavioral;
