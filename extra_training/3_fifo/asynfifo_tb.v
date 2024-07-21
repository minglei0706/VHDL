`timescale 1ns/1ps

module tb;

//int fsdbDump;
integer seed;

logic clk;

logic wr_clk;
logic wr_rstn;

logic rd_clk;
logic rd_rstn;

logic                   wr_clk_r        ;
logic                   rd_clk_r        ;
wire                    wr_clk_rise     ;
wire                    rd_clk_rise     ;




logic [7:0]    wr_array[$] ;
logic [7:0]    rd_array[$] ;

logic wr ;
logic rd ;
logic [7:0]    wr_data;
wire [7:0]    rd_data;
wire rd_data_vld;

wire almost_full ;
wire almost_empty;
wire full;
wire empty;
logic sample_full;
logic sample_empty;

integer wr_cnt;
integer rd_cnt;
integer cnt;

//int file1;
//int file2;

//$timeformat(-9, 3, “ ns”, 0)：设置时间格式。
//-9表示时间单位是纳秒，3表示小数点后三位，" ns"是时间单位的后缀，0是填充位数。
//initial $timeformat(-9, 3, "ns", 0);


initial
begin

//	•	$value$plusargs(“seed=%d”, seed)：检查命令行参数中是否有seed，
//      如果有，则将其赋值给seed变量。如果没有指定seed，则默认值为100。
//	•	$srandom(seed)：用指定的seed初始化随机数生成器。
//	•	$display(“seed = %d\n”, seed)：打印seed的值。
////    if(!$value$plusarge("seed=%d",seed))
        seed = $time;
//    $srandom(seed);
//    $display("seed = %d\n", seed);


//	•	$value$plusargs(“fsdbDump=%d”, fsdbDump)：检查命令行参数中是否有fsdbDump，
//      如果有，则将其赋值给fsdbDump变量。如果没有指定fsdbDump，则默认值为1。
//    if(!$value$plusargs("fsdbDump=%d",fsdbDump))
//        fsdbDump = 1;

//	•	if (fsdbDump)：如果fsdbDump为真，则生成FSDB文件。
//	•	$fsdbDumpfile(“tb.fsdb”)：指定生成的FSDB文件名为tb.fsdb。
//	•	$fsdbDumpvars(0)：转储所有变量的波形。
//	•	$fsdbDumpMDA(“tb.u_tst.my_memory”)：转储多维数组my_memory的波形。
//    if(fsdbDump)
//    begin
//        $fsdbDumpfile("tb.fsdb")
//        $fsdbDumpvars(0);
//        $fsdbDumpMDA('tb.u_tst.my_memory');
//    end
end
//--------------------------------------------------------------
initial
begin
    clk=1'b0;
    #3;
    forever
    begin
//	#(1e9/(2.0*40e6)) clk = ~clk：每隔12.5纳秒（对应40 MHz频率的一半周期），
//  时钟信号翻转一次。计算公式为1e9/(2*40e6)，即1秒除以2倍的40 MHz，结果是12.5纳秒。
        #(1e9/(2.0*1e9)) clk = ~clk;
    end
end


initial
begin
    wr_clk = 1'b0;
    #1;
    forever
    begin
        #(1e9/(2.0*40e6)) wr_clk = ~wr_clk;
    end
end
initial
begin
    wr_rstn = 0;
    #30 wr_rstn=1'b1;
end



initial
begin
    rd_rstn = 0;
    #40 rd_rstn=1'b1;
end
initial
begin
    rd_clk = 1'b0;
    #2;
    forever
    begin
        #(1e9/(2.0*20e6)) rd_clk = ~rd_clk;
    end
end
//----------------------------------------------------------------------
initial
begin
	wr_clk_r = 0;   

	forever
	begin
		@(posedge clk);
		if (wr_clk)
			#0.1 wr_clk_r = 1;
		else
			#0.1 wr_clk_r = 0;
	end
end


initial
begin
	rd_clk_r = 0;   

	forever
	begin
		@(posedge clk);
		if (rd_clk)
			#0.1 rd_clk_r = 1;
		else
			#0.1 rd_clk_r = 0;
	end
end


assign wr_clk_rise = wr_clk & ~wr_clk_r;
assign rd_clk_rise = rd_clk & ~rd_clk_r;
//---------------------------------------------------------------------

initial
begin
    wr = 0;
    rd = 0;
    wr_data = 0;
    wr_cnt = 0;
    rd_cnt = 0;
    sample_full = 0;
    sample_empty = 0;

    @(posedge rd_rstn);

    forever
    begin
        @(posedge clk);
        if(rd_cnt >= 1e4)
            break;
            
        fork
            begin
                if(wr_clk_rise)
                begin
                    sample_full = full;
                    #1
                    wr = {$random(seed)}%2;

                    if((~sample_full)&wr)
                    begin
                        wr_array[wr_cnt] = {$random(seed)}%256;
                        wr_data = wr_array[wr_cnt];
                        wr_cnt = wr_cnt + 1;
                    end
                    else
                        wr=0;

                end
            end

            begin
                if(rd_clk_rise)
                begin
                    sample_empty = empty;

                    if(rd_data_vld)
                    begin
                        rd_array[rd_cnt] = rd_data;
                        rd_cnt = rd_cnt +1;
                    end

                    #1;
                    rd = {$random(seed)}%2;
                    if(~((~sample_empty)&rd))
                        rd = 0;
                end
            end
        join
    end

//    file1 = $fopen("wr_fifo.txt","w");
//    file2 = $fopen("rd_fifo.txt","w");
//    for(cnt=0;cnt<rd_cnt;cnt++)
//    begin
//        if(rd_array[cnt] != wr_array[cnt])
//            $display("err in address: %d", cnt);
        
//        $fdisplay(file1, "%x",wr_array[cnt]);
//        $fdisplay(file2, "%x",rd_array[cnt]);
//    end
//    $fclose(file1);
//    $fclose(file2);

    $finish;
end



//-----------------------------------------------------
asynfifo
#(
    .data_width(8),
    .data_depth(32),
    .depth_width(5)
)
u_async_fifo
(
    .wr_clk(wr_clk),
    .wr_rstn(wr_rstn),
    .wr(wr),
    .wr_data(wr_data),

    .rd_clk(rd_clk),
    .rd_rstn(rd_rstn),
    .rd(rd),
    .rd_data(rd_data),
    .rd_data_vld(rd_data_vld),
    
    .cfg_almost_full(29),
    .cfg_almost_empty(3),
    .almost_empty(almost_empty),
    .almost_full(almost_full),
    .full(full),
    .empty(empty),
    .wr_num(wr_num),
    .rd_num(rd_num)
);
endmodule