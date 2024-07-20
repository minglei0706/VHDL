`timescale 1ns/1ps

module tb;

int fsdbDumpfile;
integer seed;

logic clk;
logic rst_n;

logic [31:0]    wr_array[$] ;
logic [31:0]    rd_array[$] ;

logic wr ;
logic rd ;
logic [31:0]    wr_data;
wire [31:0]    rd_data;
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

int file1;
int file2;

//$timeformat(-9, 3, “ ns”, 0)：设置时间格式。
//-9表示时间单位是纳秒，3表示小数点后三位，" ns"是时间单位的后缀，0是填充位数。
initial $timeformat(-9, 3, "ns", 0);


initial
begin

//	•	$value$plusargs(“seed=%d”, seed)：检查命令行参数中是否有seed，
//      如果有，则将其赋值给seed变量。如果没有指定seed，则默认值为100。
//	•	$srandom(seed)：用指定的seed初始化随机数生成器。
//	•	$display(“seed = %d\n”, seed)：打印seed的值。
    if(!$value$plusarge("seed=%d",seed))
        seed = 100;
    $srandom(seed);
    $display("seed = %d\n", seed);


//	•	$value$plusargs(“fsdbDump=%d”, fsdbDump)：检查命令行参数中是否有fsdbDump，
//      如果有，则将其赋值给fsdbDump变量。如果没有指定fsdbDump，则默认值为1。
    if(!$value$plusargs("fsdbDump=%d",fsdbDump))
        fsdbDump = 1;

//	•	if (fsdbDump)：如果fsdbDump为真，则生成FSDB文件。
//	•	$fsdbDumpfile(“tb.fsdb”)：指定生成的FSDB文件名为tb.fsdb。
//	•	$fsdbDumpvars(0)：转储所有变量的波形。
//	•	$fsdbDumpMDA(“tb.u_tst.my_memory”)：转储多维数组my_memory的波形。
    if(fsdbDump)
    begin
        $fsdbDumpfile("tb.fsdb")
        $fsdbDumpvars(0);
        $fsdbDumpMDA('tb.u_tst.my_memory');
    end
end

initial
begin
    clk 1'b0;
    forever
    begin
//	#(1e9/(2.0*40e6)) clk = ~clk：每隔12.5纳秒（对应40 MHz频率的一半周期），
//  时钟信号翻转一次。计算公式为1e9/(2*40e6)，即1秒除以2倍的40 MHz，结果是12.5纳秒。
        #(1e9/(2.0*40e6)) clk = ~clk;
    end
end

initial
begin
    rst_n = 0;
    #30 rstn  =1;
end

initial
begin
    wr = 1'b0;
    rd = 1'b0;
    wr_data = 32'h00000000;
    wr_cnt = 0;
    rd_cnt = 0;
    sample_full = 1'b0;
    sample_empty = 1'b0;

    @(posedge rstn);

    repeat(1e4)
    begin
        @(posedge clk);
        sample_full = full;
        sample_empty = empty;

        if(rd_data_vld)
        begin
            rd_array[rd_cnt] = rd_data;
            rd_cnt = rd_cnt+1;
        end

        #1;
        wr = 0;

        if(rd)
            rd = 0;
        
        wr = {$random(seed)}%2;
        rd = {$random(seed)}%2;

        if((~sample_full)&wr)
        begin
            wr_array[wr_cnt] = {$random(seed)}%32;
            wr_data = wr_array[wr_cnt];
            wr_cnt = wr_cnt + 1;
        end
        else
            wr = 0;

        if(~((~sample_empty)&rd))
            rd = 0;
    end

    file1 = $fopen("wr_fifo.txt","w");
    file2 = $fopen("rd_fifo.txt","w");
    for(cnt=0;cnt<rd_cnt;cnt++)
    begin
        if(rd_array[cnt] != wr_array[cnt])
            $display("err in address: %d", cnt);
        
        $fdisplay(file1, "%x",wr_array[cnt]);
        $fdisplay(file2, "%x",rd_array[cnt]);
    end
    $fclose(file1);
    $fclose(file2);

    $finish;
end



//-----------------------------------------------------
synfifo
#(
    .data_width(32),
    .data_depth(32),
    .depth_width(5)
)
u_sync_fifo
(
    .clk(clk),
    .rstn(rstn),

    .rd(rd),
    .wr(wr),
    .wr_data(wr_data),
    .rd_data(rd_data),
    .rd_data_vld(rd_data_vld),
    
    .cfg_almos_full(0x1B),
    .cfg_almost_empty(0x04),
    .almost_empty(almost_empty),
    .almost_full(almost_full),
    .full(full),
    .empty(empty),
    .fifo_num(fifo_num)
);
endmodule