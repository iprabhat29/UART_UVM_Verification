// Code your design here
interface arb_inf(input clock);
  logic reset;
  logic enable;
  logic send;
  logic [9:0] datain;
  logic Dout;
  logic busy;
  
  //modport DUT(input clock, reset,enable,send,datain,output Dout,output busy);
endinterface
    
module clock_divider #(parameter DIVIDE = 300)
  (input sys_clock,reset,enable,output out_clock);
  bit [8:0] temp = 8'd0;
  bit clk_temp;
  always @(posedge sys_clock or posedge reset) begin
    if (reset) begin
      temp <= 0;
    end
    else if(!reset && enable) begin
      if(temp == DIVIDE) begin
        clk_temp <= ~ clk_temp;
        temp = 0;
      end
      temp ++;
    end
    else clk_temp <= 0;
  end
  assign out_clock = clk_temp;
endmodule

module mod10_counter #(parameter DW = 10) (
  input clock,
  input reset,
  input enable,
  output bit sig_count,
  output bit count);
  bit [3:0] temp = 0;
  bit sig_clk;
  always @(posedge clock or posedge reset) begin
    if(reset) begin
      sig_clk <= 0;
      temp <= 0;
      sig_count <= 0;
    end
    else if(!reset && enable) begin
      if (temp == DW+1) begin
        sig_clk <= 0;
        temp <= 0;
        sig_count <= 1;
      end
      else begin
        sig_count <= 0;
        sig_clk <= 1;
        temp ++;
      end
    end
    else begin
      sig_clk <= 0;
      sig_count <= 0;
    end
  end
  
  assign count = (sig_clk) ? clock : 0;
endmodule


module shift_reg(
  input shift,
  input reset,
  input enable,
  input load,
  input [9:0] datain,
  output logic dataout);
  
  logic [9:0] temp;
  always @(posedge shift or posedge reset) begin
    if (reset && enable && !load) dataout <= 'X;
    else if(reset && enable && load) begin
      temp <= datain;            
    end
    else if(!reset && enable && !load) begin
      dataout <= temp[0];
      temp <= temp >> 1;
    end
    else dataout <= 'X;
  end
endmodule

module trans_fsm(
  input clock,
  input reset,
  input enable,
  input send,
  input [9:0] datain,
  output logic Dout,
  output logic busy);
  
  logic newclk;
  logic count;
  
  bit div_reset;
  bit count_reset;
  bit shift_reset;
  bit div_enable;  
  bit count_enable;
  bit shift_enable;
  bit load;
  bit [2:0] next_state;
  logic sig_count;
  
  clock_divider #(10) inst_0(clock,div_reset,div_enable,newclk);
  
  mod10_counter inst_1(newclk,count_reset,count_enable,sig_count,count);
  
  shift_reg inst_2(count,shift_reset,shift_enable,load,datain,dataout); 
  
  always @(posedge clock or posedge reset) begin
    if(enable && reset) begin
      div_reset <= 1;
      count_reset <= 1;
      shift_reset <= 1;
      div_enable <= 1;
      count_enable <= 1;
      shift_enable <= 1;
      busy <= 0;
      load <= 0;
      //dataout <= 'bx;
    end
    else if(enable && !reset) begin
      case(next_state)
        3'b000: begin
          if(send) begin
            next_state <= 3'b001;
            div_enable <= 1;
      		count_enable <= 1;
      		shift_enable <= 1;
          end
          else begin
            next_state <= 3'b000;
            div_enable <= 0;
      		count_enable <= 0;
      		shift_enable <= 0;
          end
        end
        3'b001: begin
          load <= 1;
          busy <= 1;
          div_reset <= 0;
          count_reset <= 0;
          shift_reset <= 1;
          next_state <= 3'b011;
        end
        3'b011: begin
          @(posedge count);
          load <= 0;
          shift_reset <= 0;
          next_state <= 3'b100;
          end	
        3'b100: begin
          if(sig_count) begin
            next_state <= 3'b101;
          end
          else next_state <= 3'b100;
        end
        3'b101: begin
          busy <= 0;
          next_state <= 3'b000;
        end
      endcase
    end
  end
  assign Dout = dataout;
endmodule      