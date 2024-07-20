module asynfifo
#(
    parameter data_width = 32,
    parameter data_depth = 32,
    parameter depth_width = 5
)
(
    input wr_clk,
    input wr_rstn,
    input wr,
    input [data_width-1:0] wr_data,

    input rd_clk,
    input rd_rstn,
    input rd,
    output [data_width-1:0] rd_data,
    output rd_data_vld,

    input [depth_width-1:0] cfg_almost_empty,
    input [depth_width-1:0] cfg_almost_full,
    output almost_empty,
    output almost_full,
    output full,
    output empty,
    output [depth_width:0] wr_num,
    output [depth_width:0] rd_num,
);

reg [depth_width:0] wr_ptr_exp,rd_ptr_exp;
reg [depth_width-1:0] wr_ptr,rd_ptr;

reg [depth_width:0] wr_ptr_exp_r;
reg [depth_width:0] rd_ptr_exp_r;
reg [depth_width:0] wr_ptr_exp_cross;
reg [depth_width:0] rd_ptr_exp_cross;
reg [depth_width:0] wr_ptr_exp_cross_r;
reg [depth_width:0] rd_ptr_exp_cross_r;
reg [depth_width:0] wr_ptr_exp_cross_trans;
reg [depth_width:0] rd_ptr_exp_cross_trans;

reg [data_width] my_memory[depth_width-1:0];
integer i;
//--------------------------------------------------------
assign wr_ptr = wr_ptr_exp[depth_width-1:0];
assign rd_ptr = rd_ptr_exp[depth_width-1:0];

assign wr_num = wr_ptr_exp - rd_ptr_exp_cross_trans;
assign rd_num = wr_ptr_exp_cross_trans - rd_ptr_exp;

assign full = (wr_num == depth_width) | ((wr_num == depth_width-{{(depth_width){1'b0}},1'b1})&wr);
assign empty = (rd_num == {(depth_width+1){1'b0}})|((rd_num = {{(depth_width){1'b0}},1'b1})&rd);

assign almost_full = (wr_num >= cfg_almost_full)| ((wr_num == cfg_almost_full-{{(depth_width){1'b0}},1'b1})&wr);
assign almost_empty = (rd_num <= cfg_almost_empty)|((rd_num == cfg_almost_empty+{{(depth_width){1'b0}},1'b1})&rd);

//------------------------------------------------------