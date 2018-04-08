`timescale 1 ns / 100 ps
module test_rx();
  reg clk,rst_n;
  reg din;
  reg ready;
  wire data_out;
    
	
	myip2_v1_0_lzs_m inst(
	.M_AXIS_ACLK(clk),
	.M_AXIS_ARESETN(rst_n),
.M_AXIS_TREADY(ready),
	.din(din)
	);
	always #5  clk=~clk;
	initial begin
	   rst_n=0;
	   clk=0;
	  ready=1;
	    
	    din=1;
	   #22 rst_n=1;
	   #8657 din=0;
	   
	   #8657 din=0;
	   #8657 din=1;
	   #8657 din=0;
	   #8657 din=1;
	   #8657 din=0;
	   #8657 din=1;
	   #8657 din=0;
	   #8657 din=1;
	     #8657 din=1;
	  
	    #8657 din=0;
	    
		#8657 din=1;
		#8657 din=1;
		#8657 din=1;
		#8657 din=1;
		 #8657 din=0;
		 #8657 din=0;
		 #8657 din=0;
		 #8657 din=0;
		 
	  #8657 din=1;
		 
	    #8657 din=0;
	    
		#8657 din=1;
		#8657 din=1;
		#8657 din=0;
		#8657 din=0;
		 #8657 din=1;
		 #8657 din=1;
		 #8657 din=0;
		 #8657 din=0;
		 
		 #8657 din=1;
		  
		  
	    #8657 din=0;
		#8657 din=1;
		#8657 din=1;
		#8657 din=0;
		#8657 din=0;
		 #8657 din=0;
		 #8657 din=0;
		 #8657 din=1;
		 #8657 din=1;
		 
		 #8657 din=1;
	
	   end
	   endmodule