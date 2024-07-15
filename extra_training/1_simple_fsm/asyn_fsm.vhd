--module top_module(
--    input clk,
--    input areset,    // Asynchronous reset to state B
--    input in,
--    output out);//  
--
--    parameter A=0, B=1; 
--    reg state, next_state;
--
--    always @(*) begin    // This is a combinational always block
--        // State transition logic
--        case(state)
--            A:begin 
--                if(in == 1'b1)
--                    next_state = A;
--                else
--                    next_state = B;
--            end
--            B:begin
--                if(in == 1'b1)
--                    next_state = B;
--                else
--                    next_state = A;
--            end
--            default:next_state = B;    
--        endcase
--    end
--
--    always @(posedge clk, posedge areset) begin    // This is a sequential always block
--        // State flip-flops with asynchronous reset
--        if(areset == 1'b1)
--            state <=B;
--        else
--            state <=next_state;
--    end
--
--    // Output logic
--    // assign out = (state == ...);
--    assign out = (state == A)? 1'b0:1'b1;
--
--endmodule

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity asyn_fsm is
    port(
        clk : in std_logic;
        areset : in std_logic;
        in_ : in std_logic;
        out_ : out std_logic
    );
end entity asyn_fsm;

architecture behavioral of asyn_fsm is
    type state_type is (A,B);
    signal state,next_state : state_type;
begin
    process(clk,areset)
    begin
        if areset = '1' then
            state <= B;
        else
            state <= next_state;
        end if;
    end process;

    process(state,in_)
    begin
        case state is
            when A =>
                if in_ = '1' then
                    next_state <= A;
                else
                    next_state <= B;
                end if;
            when B =>
                if in_ = '1' then
                    next_state <= B;
                else
                    next_state <= A;
                end if;
            when others =>
                next_state <= B;
        end case;
    end process;
    out_ <= '0' when state = A else '1';
    end architecture behavioral;