module DUT_IF(arb_inf a);
  trans_fsm trans_inst(a.clock,a.reset,a.enable,a.send,a.datain,a.Dout,a.busy);
endmodule