
`timescale 1 ns / 1 ps

	module myip1_v1_0_lzs_AXIS #
	(
		// Users to add parameters here
 //  parameter bps_02=10'd868, //100MHz  115200波特率
		// User parameters ends
		// Do not modify the parameters beyond this line

		// AXI4Stream sink: Data Width
		parameter integer C_S_AXIS_TDATA_WIDTH	= 32
	)
	(
		// Users to add ports here
output wire TXD,
		// User ports ends
		// Do not modify the ports beyond this line

		// AXI4Stream sink: Clock
		input wire  S_AXIS_ACLK,
		// AXI4Stream sink: Reset
		input wire  S_AXIS_ARESETN,
		// Ready to accept data in
		output wire  S_AXIS_TREADY,
		// Data in
		input wire [C_S_AXIS_TDATA_WIDTH-1 : 0] S_AXIS_TDATA,
		// Byte qualifier
	//	input wire [(C_S_AXIS_TDATA_WIDTH/8)-1 : 0] S_AXIS_TSTRB,
		// Indicates boundary of last packet
	//	input wire  S_AXIS_TLAST,
		// Data is in valid
		input wire  S_AXIS_TVALID
	);
	// function called clogb2 that returns an integer which has the 
	// value of the ceiling of the log base 2.
	/*function integer clogb2 (input integer bit_depth);
	  begin
	    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
	      bit_depth = bit_depth >> 1;
	  end
	endfunction

	// Total number of input data.
	localparam NUMBER_OF_INPUT_WORDS  = 8;
	// bit_num gives the minimum number of bits needed to address 'NUMBER_OF_INPUT_WORDS' size of FIFO.
	localparam bit_num  = clogb2(NUMBER_OF_INPUT_WORDS-1);
	// Define the states of state machine
	// The control state machine oversees the writing of input streaming data to the FIFO,
	// and outputs the streaming data from the FIFO
	parameter [1:0] IDLE = 1'b0,        // This is the initial/idle state 

	                WRITE_FIFO  = 1'b1; // In this state FIFO is written with the
	                                    // input stream data S_AXIS_TDATA 
	wire  	axis_tready;
	// State variable
	reg mst_exec_state;  
	// FIFO implementation signals
	genvar byte_index;     
	// FIFO write enable
	wire fifo_wren;
	// FIFO full flag
	reg fifo_full_flag;
	// FIFO write pointer
	reg [bit_num-1:0] write_pointer;
	// sink has accepted all the streaming data and stored in FIFO
	  reg writes_done;
	// I/O Connections assignments

	assign S_AXIS_TREADY	= axis_tready;
	// Control state machine implementation
	always @(posedge S_AXIS_ACLK) 
	begin  
	  if (!S_AXIS_ARESETN) 
	  // Synchronous reset (active low)
	    begin
	      mst_exec_state <= IDLE;
	    end  
	  else
	    case (mst_exec_state)
	      IDLE: 
	        // The sink starts accepting tdata when 
	        // there tvalid is asserted to mark the
	        // presence of valid streaming data 
	          if (S_AXIS_TVALID)
	            begin
	              mst_exec_state <= WRITE_FIFO;
	            end
	          else
	            begin
	              mst_exec_state <= IDLE;
	            end
	      WRITE_FIFO: 
	        // When the sink has accepted all the streaming input data,
	        // the interface swiches functionality to a streaming master
	        if (writes_done)
	          begin
	            mst_exec_state <= IDLE;
	          end
	        else
	          begin
	            // The sink accepts and stores tdata 
	            // into FIFO
	            mst_exec_state <= WRITE_FIFO;
	          end

	    endcase
	end
	// AXI Streaming Sink 
	// 
	// The example design sink is always ready to accept the S_AXIS_TDATA  until
	// the FIFO is not filled with NUMBER_OF_INPUT_WORDS number of input words.
	assign axis_tready = ((mst_exec_state == WRITE_FIFO) && (write_pointer <= NUMBER_OF_INPUT_WORDS-1));

	always@(posedge S_AXIS_ACLK)
	begin
	  if(!S_AXIS_ARESETN)
	    begin
	      write_pointer <= 0;
	      writes_done <= 1'b0;
	    end  
	  else
	    if (write_pointer <= NUMBER_OF_INPUT_WORDS-1)
	      begin
	        if (fifo_wren)
	          begin
	            // write pointer is incremented after every write to the FIFO
	            // when FIFO write signal is enabled.
	            write_pointer <= write_pointer + 1;
	            writes_done <= 1'b0;
	          end
	          if ((write_pointer == NUMBER_OF_INPUT_WORDS-1)|| S_AXIS_TLAST)
	            begin
	              // reads_done is asserted when NUMBER_OF_INPUT_WORDS numbers of streaming data 
	              // has been written to the FIFO which is also marked by S_AXIS_TLAST(kept for optional usage).
	              writes_done <= 1'b1;
	            end
	      end  
	end

	// FIFO write enable generation
	assign fifo_wren = S_AXIS_TVALID && axis_tready;

	// FIFO Implementation
	generate 
	  for(byte_index=0; byte_index<= (C_S_AXIS_TDATA_WIDTH/8-1); byte_index=byte_index+1)
	  begin:FIFO_GEN

	    reg  [(C_S_AXIS_TDATA_WIDTH/4)-1:0] stream_data_fifo [0 : NUMBER_OF_INPUT_WORDS-1];

	    // Streaming input data is stored in FIFO

	    always @( posedge S_AXIS_ACLK )
	    begin
	      if (fifo_wren)// && S_AXIS_TSTRB[byte_index])
	        begin
	          stream_data_fifo[write_pointer] <= S_AXIS_TDATA[(byte_index*8+7) -: 8];
	        end  
	    end  
	  end		
	endgenerate

	// Add user logic here

	// User logic ends

	endmodule
*/
reg[1:0] state;
parameter  IDLE = 2'b00, WR=2'b01,WRR=2'b10,UART=2'b11;
reg clk_en;
reg ready;
reg [9:0]div_cnt;
 reg [7:0] data;
reg[2:0] i;
 reg[31:0] stream_data;
reg[3:0] num_cnt;
reg flag;
reg txd;
assign TXD=txd;
//wire [7:0]uart_in;
//assign uart_in=data;
/*
	// function called clogb2 that returns an integer which has the 
	// value of the ceiling of the log base 2.
	function integer clogb2 (input integer bit_depth);
	  begin
	    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
	      bit_depth = bit_depth >> 1;
	  end
	endfunction

	// Total number of input data.
	localparam NUMBER_OF_INPUT_WORDS  = 8;
	// bit_num gives the minimum number of bits needed to address 'NUMBER_OF_INPUT_WORDS' size of FIFO.
	localparam bit_num  = clogb2(NUMBER_OF_INPUT_WORDS-1);
	// Define the states of state machine
	// The control state machine oversees the writing of input streaming data to the FIFO,
	// and outputs the streaming data from the FIFO
	parameter [1:0] IDLE = 1'b0,        // This is the initial/idle state 

	                WRITE_FIFO  = 1'b1; // In this state FIFO is written with the
	                                    // input stream data S_AXIS_TDATA 
	wire  	axis_tready;
	// State variable
	reg mst_exec_state;  
	// FIFO implementation signals
	genvar byte_index;     
	// FIFO write enable
	wire fifo_wren;
	// FIFO full flag
	reg fifo_full_flag;
	// FIFO write pointer
	reg [bit_num-1:0] write_pointer;
	// sink has accepted all the streaming data and stored in FIFO
	  reg writes_done;
	// I/O Connections assignments

	assign S_AXIS_TREADY	= axis_tready;
	// Control state machine implementation
	always @(posedge S_AXIS_ACLK) 
	begin  
	  if (!S_AXIS_ARESETN) 
	  // Synchronous reset (active low)
	    begin
	      mst_exec_state <= IDLE;
	    end  
	  else
	    case (mst_exec_state)
	      IDLE: 
	        // The sink starts accepting tdata when 
	        // there tvalid is asserted to mark the
	        // presence of valid streaming data 
	          if (S_AXIS_TVALID)
	            begin
	              mst_exec_state <= WRITE_FIFO;
	            end
	          else
	            begin
	              mst_exec_state <= IDLE;
	            end
	      WRITE_FIFO: 
	        // When the sink has accepted all the streaming input data,
	        // the interface swiches functionality to a streaming master
	        if (writes_done)
	          begin
	            mst_exec_state <= IDLE;
	          end
	        else
	          begin
	            // The sink accepts and stores tdata 
	            // into FIFO
	            mst_exec_state <= WRITE_FIFO;
	          end

	    endcase
	end

	assign axis_tready = (mst_exec_state == WRITE_FIFO) ;//&& (write_pointer <= NUMBER_OF_INPUT_WORDS-1));

	always@(posedge S_AXIS_ACLK)
	begin
	  if(!S_AXIS_ARESETN)
	    begin
	      write_pointer <= 0;
	      writes_done <= 1'b0;
	    end  
	  else
//	    if (write_pointer <= NUMBER_OF_INPUT_WORDS-1)
	      begin
	        if (fifo_wren)
	          begin
	            // write pointer is incremented after every write to the FIFO
	            // when FIFO write signal is enabled.
	            write_pointer <= write_pointer + 1;
	            writes_done <= 1'b0;
	          end
	          if ((write_pointer == NUMBER_OF_INPUT_WORDS-1)|| S_AXIS_TLAST)
	            begin
	              // reads_done is asserted when NUMBER_OF_INPUT_WORDS numbers of streaming data 
	              // has been written to the FIFO which is also marked by S_AXIS_TLAST(kept for optional usage).
	              writes_done <= 1'b1;
	            end
	      end  
	end

	// FIFO write enable generation
	assign fifo_wren = S_AXIS_TVALID && axis_tready;

	// FIFO Implementation
 reg  [(C_S_AXIS_TDATA_WIDTH/4)-1:0] stream_data_fifo [0 : NUMBER_OF_INPUT_WORDS-1];
	generate 
	  for(byte_index=0; byte_index<= (C_S_AXIS_TDATA_WIDTH/8-1); byte_index=byte_index+1)
	  begin:FIFO_GEN

	   // reg  [(C_S_AXIS_TDATA_WIDTH/4)-1:0] stream_data_fifo [0 : NUMBER_OF_INPUT_WORDS-1];

	    // Streaming input data is stored in FIFO

	    always @( posedge S_AXIS_ACLK )
	    begin
	      if (fifo_wren)// && S_AXIS_TSTRB[byte_index])
	        begin
	          stream_data_fifo[write_pointer] <= S_AXIS_TDATA[(byte_index*8+7) -: 8];
	        end  
	    end  
	  end		
	endgenerate
*/
	assign S_AXIS_TREADY	= ready;	
//
    always @(posedge S_AXIS_ACLK or negedge S_AXIS_ARESETN)begin
            if(!S_AXIS_ARESETN)begin
                   state<=IDLE;stream_data<=0; ready<=0;i<=0;  txd<=1'b1; flag<=0;
	   end
	   else case(state)
		   IDLE:begin
			   if(S_AXIS_TVALID)begin
				   
				   state<=WR;
				   ready<=1;
				   i<=0;
			   end
			   else state<=IDLE;
		   end
	         WR:begin
			 stream_data<=S_AXIS_TDATA;
			 state<=WRR;
			 ready<=0;
		 end
		 WRR:begin 
		        
		        
		           case(i)
		           0:data<=stream_data[7:0];
		           1:data<=stream_data[15:8];
	                   2:data<=stream_data[23:16];
		           3:data<=stream_data[31:24];
	                   endcase
			   state<=UART;
		            
		        end

		  UART:begin
		      flag<=1;
			  if(clk_en)begin
			     case(num_cnt)
          4'd0:txd<=1'b1;
          4'd1:txd<=1'b0;   //起始位
          4'd2:txd<=data[0];
          4'd3:txd<=data[1];
          4'd4:txd<=data[2];
          4'd5:txd<=data[3]; 
          4'd6:txd<=data[4];
          4'd7:txd<=data[5];
          4'd8:txd<=data[6];
          4'd9:txd<=data[7]; 
	  4'd10:txd<=1'b1;
	  default:txd<=1'b1;
                           endcase
			   
			 if(num_cnt==4'd10)begin	   
	   		 i<=i+1;state<=WRR; flag<=0;
			   
		           end
		     end
		     else if(i==3'd4)
		     begin state<=IDLE; flag<=0;
		     ready<=1;end
		          else
			     state<=UART;
	     end
	     





	 endcase
 end






		  










      //分频模块和clk_en
      always @(posedge S_AXIS_ACLK or negedge S_AXIS_ARESETN)begin
	      if(!S_AXIS_ARESETN)begin
		//      clk_en<=0;
		      div_cnt<=0;
	      end
	      else if(div_cnt==10'd868)begin
		//      clk_en<=1;
		      div_cnt<=0;
	      end

	      else begin
		      div_cnt<=div_cnt+1;
		//      clk_en<=0;
	      end
      end
	  ////////clk_en  一定要在计数中央采样   哈哈哈哈
       always @(posedge S_AXIS_ACLK or negedge S_AXIS_ARESETN)begin
               if(!S_AXIS_ARESETN)begin
               clk_en<=0;
              //     div_cnt<=0;
               end
               else if(div_cnt==10'd434)begin
                 clk_en<=1;
              //     div_cnt<=0;
               end
     
               else begin
                //   div_cnt<=div_cnt+1;
                  clk_en<=0;
               end
           end
/*
//预存到寄存器
    always  @(posedge S_AXIS_ACLK or negedge S_AXIS_ARESETN)begin
             if(!S_AXIS_ARESETN)begin
		     data<=0;
	     end
	    else data<=stream_data_fifo[write_pointer];
     end*/


//输出位加
 always  @(posedge S_AXIS_ACLK or negedge S_AXIS_ARESETN)begin
             if(!S_AXIS_ARESETN)begin
		     num_cnt<=0;
	     end
	     else if(flag)begin
	     if(clk_en)begin
		     if(num_cnt==4'd10)begin
			     num_cnt<=0;
		     end
		     else num_cnt<=num_cnt+1;
	     end
	     end
     end
      
	
	



  /*   always  @(posedge S_AXIS_ACLK or negedge S_AXIS_ARESETN)begin
             if(!S_AXIS_ARESETN)begin
		     txd<=1'b1;end
	     else if(clk_en)begin
			     case(num_cnt)
          4'd0:txd<=1'b1;
          4'd1:txd<=1'b0;   //起始位
          4'd2:txd<=data[0];
          4'd3:txd<=data[1];
          4'd4:txd<=data[2];
          4'd5:txd<=data[3]; 
          4'd6:txd<=data[4];
          4'd7:txd<=data[5];
          4'd8:txd<=data[6];
          4'd9:txd<=data[7]; 
	  4'd10:txd<=1'b1;
	  default:txd<=1'b1;
                           endcase
		   end
	   end

	*/			     

	    
     //





	// User logic ends

	endmodule
