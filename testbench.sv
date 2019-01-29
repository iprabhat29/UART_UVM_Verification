// Code your testbench here
// or browse Examples
`include "my_pkg.svh"
`include "dutinf.sv"
module top;
  import uvm_pkg::*;
  import mypkg::*;
  
  bit clock;
  
  initial forever #2 clock = ~ clock;
  
  arb_inf arb_inf_h(clock);
  
  DUT_IF d(arb_inf_h);
    
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
  
  initial begin
    uvm_config_db #(virtual arb_inf)::set(null,"*", "dut_vi", arb_inf_h);
    run_test("my_agent");
  end
  
endmodule