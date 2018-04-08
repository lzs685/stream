`timescale 1 ns / 1 ps

	module myip2_v1_0_lzs_m
	(
	    input wire din,
		input wire  M_AXIS_ACLK,
		input wire  M_AXIS_ARESETN,
		input wire  M_AXIS_TREADY,
		
		output wire  M_AXIS_TVALID,
		
		output wire [31: 0] M_AXIS_TDATA
		
		
	);
	reg clk_en;
	reg valid;           assign  M_AXIS_TVALID=valid;
	reg [31:0]axi_data;  assign  M_AXIS_TDATA=axi_data;
	 assign ready=M_AXIS_TREADY;
	 
	reg [9:0]div_cnt;
	
	reg [3:0]num_cnt;
	reg [7:0]data;
	reg[31:0]data_out;
	reg [2:0] i;
	reg rx_en;
	//////////////**************************///////
	parameter IDLE= 2'b00;
    parameter JISHU=2'b01;
    parameter THREE=2'b10;
	parameter FOUR=2'b11;
	reg [1:0]state;
	/////////////////********************///////////
    reg din0,din1,din2,din3;  ///////////*******四级触发器用来同步   一般两级或者三级就行
    always @ (posedge M_AXIS_ACLK or negedge M_AXIS_ARESETN) begin
      if(!M_AXIS_ARESETN) begin
              din0 <= 1'b0;
              din1 <= 1'b0;
              din2 <= 1'b0;
              din3 <= 1'b0;
          end
      else begin
              din0 <= din;
              din1 <= din0;
              din2 <= din1;
              din3 <= din2;
          end
    end
   wire neg_din;
   assign neg_din = din3 & din2 & ~din1 & ~din0;
   /////////////////////////****************///////////////中间进行采样，产生clk_en
    always @(posedge M_AXIS_ACLK or negedge M_AXIS_ARESETN)begin
                 if(!M_AXIS_ARESETN)begin
                 clk_en<=0;
              
                 end
                 else if(div_cnt==10'd434)begin
                   clk_en<=1;
                
                 end
       
                 else begin
                 
                  clk_en<=0;
                 end
             end
	/////////////////////////************************///////////////	波特率计数	 
	   always @(posedge M_AXIS_ACLK or negedge M_AXIS_ARESETN)begin
            if(!M_AXIS_ARESETN)begin
          
                div_cnt<=0;
            end
            else if(rx_en)begin
                  if(div_cnt==10'd868)
                     div_cnt<=0;
                  else 
                     div_cnt<=div_cnt+1;
                end
                else div_cnt<=0;
          
            
        end
	/////////////////////////***********************//////////////////////////输出位计数
            always  @(posedge M_AXIS_ACLK or negedge M_AXIS_ARESETN)begin
           if(!M_AXIS_ARESETN)begin
               num_cnt<=0; 
                 end
             else      
                 if(clk_en)begin
                    if(num_cnt==4'd9)begin
                      num_cnt<=0; end
                      else begin num_cnt<=num_cnt+1;  end
                
               end
                
       end	
	   ///////////////////////////////**********************//////////////////
	   always @(posedge M_AXIS_ACLK or negedge M_AXIS_ARESETN)begin
          if(!M_AXIS_ARESETN)begin 
            data<=0;
            end
            else if(clk_en)begin
            case(num_cnt)
             4'd1:data[0]<=din;
             4'd2:data[1]<=din;
             4'd3:data[2]<=din;
             4'd4:data[3]<=din;
             4'd5:data[4]<=din;
             4'd6:data[5]<=din;
             4'd7:data[6]<=din;
             4'd8:data[7]<=din;
            default: ;
            endcase
            end
            end
//////////////////*******************/////////////////////		
  always@(posedge M_AXIS_ACLK or negedge M_AXIS_ARESETN)begin
         if(!M_AXIS_ARESETN) rx_en<=0;
         else if(neg_din)begin
         rx_en<=1'b1;
         end
         else if(clk_en&&num_cnt==4'd9)begin
         rx_en<=0;
         end
         end	 
    always @ (posedge M_AXIS_ACLK or negedge M_AXIS_ARESETN) begin
      if(!M_AXIS_ARESETN) begin
      state<=IDLE; i<=0; valid=0;axi_data=0;data_out=0;end
	  else case(state)
	  IDLE: begin
	       valid<=0;
	       if(rx_en)                 ///////////第一个下降沿：起始位的到来////
		   state<=JISHU;
           if(i==3'd4) begin
		   state<=FOUR;  axi_data<=data_out; i<=0;
		   end
		   
		   end
		   
     JISHU: begin 
	           if(clk_en&&num_cnt==4'd9)begin
			     i<=i+1;
				 state<=THREE;
			end
		 end
	THREE: begin
            case(i)
		    3'd1:data_out[7:0]<=data;
            3'd2:data_out[15:8]<=data;
            3'd3:data_out[23:16]<=data;
            3'd4:data_out[31:24]<=data;
			endcase
			state<=IDLE; 
			
			end
     FOUR: begin
	        valid<=1;
			if(ready==1)begin
			state<=IDLE;
			end
			end
		endcase
   end
    endmodule   
	 
   
   
   
   