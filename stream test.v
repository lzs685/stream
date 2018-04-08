`timescale 1 ns / 100 ps
   module stream_tb();
 reg  clk,  rst_n, valid;
 reg [31:0] tdata;
 wire tready;
/* wire ready;
 wire clk_en;
 wire [9:0]div_cnt;
 wire [7:0] reg_data;
 wire [3:0] num_cnt;
wire mst_exec_state; 
wire [2:0] write_pointer;
wire writes_done;*/
wire txd;


  myip_001_v1_0_S00_AXIS dut(
	  .S_AXIS_ACLK(clk),
	  . S_AXIS_ARESETN(rst_n),
	  . S_AXIS_TREADY(tready),
	  .S_AXIS_TDATA(tdata),
	 // .S_AXIS_TLAST(last),
	  . S_AXIS_TVALID(valid),
	//  .clk_en(clk_en),
	//  .ready(ready),
	//  .div_cnt(div_cnt),
	//  .reg_data(reg_data),
	//  .num_cnt(num_cnt),
	//  .mst_exec_state(mst_exec_state),
	//  .write_pointer(write_pointer),
	//  .writes_done(writes_done),
	  .txd(txd)
  );
  initial begin
	  clk=0;
	  rst_n=1'b0;
	  valid=0;
	 // last=0;
	  tdata=0;
  end
  always begin 
	  #10 clk=~clk;
  end
  initial begin
	  #14 rst_n=1;
	  #10 valid=1;
	  #10 tdata=32'haabbccdd;
  end

endmodule



