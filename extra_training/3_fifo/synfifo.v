module synfifo #(
    parameter data_width = 5,
    parameter data_depth = 8,
    parameter depth_width = 3
) (
    input                       clk,
    input                       rstn,

    input                       rd,
    input                       wr,
    input       [data_width-1:0]      wr_data,
    output reg  [data_width-1:0]        rd_data,
    output reg                  rd_data_vld,

    input [depth_width-1:0]       cfg_almost_full,
    input [depth_width-1:0]       cfg_almost_empty,
    output                      almost_empty,
    output                      almost_full,
    output                      full,
    output                      empty,
    output [depth_width:0]      fifo_num

);

wire [depth_width-1:0]  rd_ptr,wr_ptr;
reg [depth_width:0] rd_ptr_exp,wr_ptr_exp;
reg [data_width-1:0] my_memory[data_depth-1:0];
integer i;

assign rd_ptr = rd_ptr_exp[depth_width-1:0];
assign wr_ptr = wr_ptr_exp[depth_width-1:0];

always@(posedge clk or negedge rstn)
begin
    if(!rstn)
        wr_ptr_exp <= {(depth_width+1){1'b0}};
    else if (wr)
        wr_ptr_exp <= wr_ptr_exp + {{(depth_width){1'b0}},1'b1};
end

always@(posedge clk or negedge rstn)
begin
    if(!rstn)
        rd_ptr_exp <= {(depth_width+1){1'b0}};
    else if (rd)
        rd_ptr_exp <= rd_ptr_exp + {{(depth_width){1'b0}},1'b1};
end

assign fifo_num = wr_ptr_exp - rd_ptr_exp;

assign full = (fifo_num == data_depth) | ((fifo_num == data_depth - {{(depth_width){1'b0}},1'b1}) &(wr)&(!rd));
assign empty = (fifo_num == {(depth_width+1){1'b0}}) | ((fifo_num == {{(depth_width){1'b0}},1'b1}) &(~wr)&(rd));
assign almost_empty = (fifo_num <= cfg_almost_empty) | ((fifo_num == cfg_almost_empty+{{(depth_width){1'b0}},1'b1}) &(~wr)&(rd));
assign almost_full = (fifo_num >= cfg_almost_full) | ((fifo_num == cfg_almost_full - {{(depth_width){1'b0}},1'b1}) &(wr)&(!rd));

always@(posedge clk or negedge rstn)
begin
    if(!rstn)
        for(i=0;i<data_depth;i=i+1)
            my_memory[i] <= {(data_width){1'b0}};
    else if (wr)
        for(i=0;i<data_depth;i=i+1)
            if(i == wr_ptr)
                my_memory[i] <= wr_data;
end

always@(posedge clk or negedge rstn)
begin
    if(!rstn)
        for(i=0;i<data_depth;i=i+1)
            rd_data <= {(data_width){1'b0}};
    else if (rd)
        for(i=0;i<data_depth;i=i+1)
            if(i == rd_ptr)
                rd_data <= my_memory[i];
end

always@(posedge clk or negedge rstn)
begin
    if(!rstn)
        rd_data_vld <= 1'b0;
    else
        rd_data_vld <= rd;
end
    
endmodule