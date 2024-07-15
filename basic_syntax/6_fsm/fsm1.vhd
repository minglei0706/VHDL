--FPGA_Kap3_page_3_86


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity fsm1 is
    generic( DATA_WIDTH: positive :=8);
    port(
        rst,clk:    in std_logic;
        rd,wr:      out std_logic;
        ack:        in std_logic;
        rdata:      in std_logic_vector(DATA_WIDTH-1 downto 0);
        wdata:      out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end entity fsm1;

--architecture
architecture behavioral of fsm1 is
    type fsm_t is (IDLE, GET_OP,PUT_RES);
    signal state, next_state: fsm_t;
    signal data_r,data_next: std_logic_vector(wdata'range);
begin
    seq:process(clk,rst)
    begin
        if rst = '1' then
            state <= IDLE;
            data_r <= (others=>'0');
        elsif ringsing_edge(clk) then
            state <= next_state;
            data_r <= data_next;
        end if;
    end process seq;

    fsm_comb:process(state,ack,rdata,data_r)
    begin
        state_next  <= state;
        data_next   <= data_r;
        rd          <= '0';
        wr          <= '0';
        wdata       <= (others=>'-');
        case state is
            when IDLE => 
                state_next <= GET_OP;
            when GET_OP => 
                rd  <= '1';
                data <= rdata;
                if ack = '1' then
                    state_next <= PUT_RES;
                end if;
            when PUT_RES =>
                wr <= '1';
                wdata <= data_r;
                state_next <= IDLE;
            when others => null;
        end case;
    end process fsm_comb;
end architecture behavioral;