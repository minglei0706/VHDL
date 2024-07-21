module asynfifo
#(
    parameter data_width = 8,
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
    output reg [data_width-1:0] rd_data,
    output reg rd_data_vld,

    input [depth_width-1:0] cfg_almost_empty,
    input [depth_width-1:0] cfg_almost_full,
    output almost_empty,
    output almost_full,
    output full,
    output empty,
    output [depth_width:0] wr_num,
    output [depth_width:0] rd_num
);

reg [depth_width:0] wr_ptr_exp,rd_ptr_exp;
wire [depth_width-1:0] wr_ptr,rd_ptr;

reg [depth_width:0] wr_ptr_exp_r;
reg [depth_width:0] rd_ptr_exp_r;
reg [depth_width:0] wr_ptr_exp_cross;
reg [depth_width:0] rd_ptr_exp_cross;
reg [depth_width:0] wr_ptr_exp_cross_r;
reg [depth_width:0] rd_ptr_exp_cross_r;
wire [depth_width:0] wr_ptr_exp_cross_trans;
wire [depth_width:0] rd_ptr_exp_cross_trans;

reg [data_width-1:0] my_memory[data_depth-1:0];
integer i;
//--------------------------------------------------------
assign wr_ptr = wr_ptr_exp[depth_width-1:0];
assign rd_ptr = rd_ptr_exp[depth_width-1:0];

assign wr_num = wr_ptr_exp - rd_ptr_exp_cross_trans;
assign rd_num = wr_ptr_exp_cross_trans - rd_ptr_exp;

assign full = (wr_num == data_depth) | ((wr_num == data_depth-1)&wr);
assign empty = (rd_num == 0)|((rd_num == 1)&rd);

assign almost_full = (wr_num >= cfg_almost_full)| ((wr_num == cfg_almost_full-1)&wr);
assign almost_empty = (rd_num <= cfg_almost_empty)|((rd_num == cfg_almost_empty+1)&rd);

//------------------------------------------------------
always@(posedge wr_clk or negedge wr_rstn)
begin
    if(!wr_rstn)
        wr_ptr_exp <= {(depth_width+1){1'b0}};
    else if(wr)
        wr_ptr_exp <= wr_ptr_exp + {{(depth_width){1'b0}},1'b1};
end

always@(posedge rd_clk or negedge rd_rstn)
begin
    if(!rd_rstn)
        rd_ptr_exp <= {(depth_width+1){1'b0}};
    else if (rd)
        rd_ptr_exp <= rd_ptr_exp + {{(depth_width){1'b0}},1'b1};
end

//--------------------------------------------------------------
always@(posedge wr_clk or negedge wr_rstn)
begin
    if(!wr_rstn)
    begin
        wr_ptr_exp_r <={(depth_width+1){1'b0}};
        rd_ptr_exp_cross<={(depth_width+1){1'b0}};
        rd_ptr_exp_cross_r<={(depth_width+1){1'b0}};
    end
    else
    begin
        wr_ptr_exp_r <= graycode(wr_ptr_exp);
        rd_ptr_exp_cross <= rd_ptr_exp_r;
        rd_ptr_exp_cross_r <=rd_ptr_exp_cross;
    end
end

always@(posedge rd_clk or negedge rd_rstn)
begin
    if(!rd_rstn)
    begin
        rd_ptr_exp_r<={(depth_width+1){1'b0}};
        wr_ptr_exp_cross<={(depth_width+1){1'b0}};
        wr_ptr_exp_cross_r<={(depth_width+1){1'b0}};
    end
    else
    begin
        rd_ptr_exp_r<=graycode(rd_ptr_exp);
        wr_ptr_exp_cross<=wr_ptr_exp_r;
        wr_ptr_exp_cross_r<=wr_ptr_exp_cross;
    end
end

assign rd_ptr_exp_cross_trans = degraycode(rd_ptr_exp_cross_r);
assign wr_ptr_exp_cross_trans = degraycode(wr_ptr_exp_cross_r);

//----------------------------------------------------------------------
always@(posedge wr_clk or negedge wr_rstn)
begin
    if(!wr_rstn)
        for(i=0;i<data_depth;i=i+1)
            my_memory[i]<={(data_width){1'b0}};
    else if (wr)
        for(i=0;i<data_depth;i=i+1)
            if(wr_ptr == i)
                my_memory[i] = wr_data;
end

always@(posedge rd_clk or negedge rd_rstn)
begin
    if(!rd_rstn)
        rd_data <= {data_width{1'b0}};
    else if (rd)
        for(i=0;i<data_depth;i=i+1)
            if(rd_ptr == i)
                rd_data <= my_memory[i];
end

always@(posedge rd_clk or negedge rd_rstn)
begin
    if(!rd_rstn)
        rd_data_vld <=1'b0;
    else
        rd_data_vld <=rd;
end
//----------------------------------------------------------------------------
function    [depth_width:0] graycode;
input [depth_width:0] bin;
begin
    graycode = bin ^ (bin>>1);
end
endfunction

function [depth_width:0] degraycode;
input [depth_width:0] gray;
integer i;
begin
    degraycode[depth_width] = gray[depth_width];
    for(i=(depth_width-1);i>=0;i=i-1)
        degraycode[i]=degraycode[i+1]^gray[i];
end
endfunction

endmodule