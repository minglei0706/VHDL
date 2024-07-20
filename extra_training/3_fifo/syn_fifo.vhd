--  In Synchronous FIFO, data read and write operations use the same clock frequency. 
--  Usually, they are used with high clock frequency to support high-speed systems.
--  用同一时钟频率进行读写操作的同步FIFO，通常用于支持高速系统。

--  In a synchronous FIFO, both read and write operations use the same clock signal. 
--  This means that data read and write operations occur within the same clock domain.

--  同步FIFO的应用
--  
--  	1.	高速数据缓冲：
--  	•	场景：在一个高性能处理器与其缓存之间的数据传输。
--  	•	原因：处理器和缓存通常工作在相同的时钟频率下。使用同步FIFO可以确保数据传输的高效和低延迟。
--  	2.	视频帧缓冲：
--  	•	场景：在一个视频处理流水线中，处理多个时钟周期内生成的像素数据。
--  	•	原因：视频处理流水线的各个阶段通常使用相同的时钟信号，因此同步FIFO可以有效地缓冲和传输帧数据。
--  	3.	音频数据处理：
--  	•	场景：在数字音频处理器内部，从ADC（模数转换器）到DSP（数字信号处理器）的数据传输。
--  	•	原因：ADC和DSP通常在相同的时钟域中操作，使用同步FIFO可以确保音频数据的无缝传输和处理。

library ieee;












module sync_fifo

#(
    parameter DATA_WIDTH = 5,
    parameter DATA_DEPTH = 8,
    parameter DEPTH_WIDTH = 3
)
(
    input                              clk                  ,
    input                              rst                  ,

    input                               wr                  ,
    input                               rd                  ,  
    input           [DATA_WIDTH-1:0]    wr_data             ,
    output  reg     [DATA_WIDTH-1:0]    rd_data             ,
    output  reg                         rd_data_valid       ,  

    input           [DEPTH_WIDTH-1:0]   cfg_almost_full     ,
    input           [DEPTH_WIDTH-1:0]   cfg_almost_empty    ,
    output                              almost_full         ,
    output                              almost_empty        ,
    output                              full                ,
    output                              empty               ,
    output          [DEEPTH_WIDTH:0]    fifo_num
);



//******************************************************************

wire    [DEPTH_WIDTH-1:0]   ram_wr_ptr                  ;
wire    [DEPTH_WIDTH-1:0]   ram_rd_ptr                  ;
reg     [DEPTH_WIDTH:0]     ram_wr_ptr_exp              ;
reg     [DEPTH_WIDTH:0]     ram_rd_ptr_exp              ;

reg     [DATA_WIDTH-1:0]    my_memory[DATA_DEPTH-1:0]   ;


assign ram_wr_ptr = ram_wr_ptr_exp[DEPTH_WIDTH-1:0];
assign ram_rd_ptr = ram_rd_ptr_exp[DEPTH_WIDTH-1:0];

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        ram_wr_ptr_exp <= {(DEPTH_WIDTH+1){1'b0}};
    else if(wr)
    begin
        if(ram_wr_ptr_exp < DATA_DEPTH + DATA_DEPTH - 1)
            ram_wr_ptr_exp <= ram_wr_ptr_exp +1;
        else
            ram_wr_ptr_exp <= {(DEPTH_WIDTH+1){1'b0}};
    end
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        ram_rd_ptr_exp <= {(DEPTH_WIDTH+1){1'b0}};
    else if(wr)
    begin
        if(ram_rd_ptr_exp < DATA_DEPTH + DATA_DEPTH - 1)
            ram_rd_ptr_exp <= ram_rd_ptr_exp +1;
        else
            ram_rd_ptr_exp <= {(DEPTH_WIDTH+1){1'b0}};
    end
end

assign fifo_num = ram_wr_ptr_exp - ram_rd_ptr_exp;

assign full = (fifo_num == DATA_DEPTH) | ((fifo_num == DATA_DEPTH - 1)&wr&(~rd));
assign empty = (fifo_num == 0) | ((fifo_num == 1)&rd&(~wr));
assign almost_full = (fifo_num >=cfg_almost_full) | ((fifo_num == cfg_almost_full)&wr&(~rd));
assign almost_empty = (fifo_num <=cfg_almost_empty)|((fifo_num == cfg_almost_empty)&rd&(~wr));

integer i;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        for(i=0;i<DATA_DEPTH;i=i+1)
            my_memory[i] <= {(DATA_WIDTH){1'b0}};
    else
    begin
        for(i=0;i<DATA_DEPTH;i=i+1)
        begin
            if(wr && (ram_wr_ptr == i))
                my_memory[i] = wr_data;
        end
    end
end


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        rd_data <= {(DATA_WIDTH){1'b0}};
    else
    begin
        if(rd)
        begin
            for(i=0;i<DATA_DEPTH;i=i+1)
            begin
                if(ram_wr_ptr == i)
                    rd_data <=my_memory[i];
            end
        end
    end
end


always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        rd_data_valid <= 1'b0;
    else
        rd_data_valid <= rd;
end

endmodule
