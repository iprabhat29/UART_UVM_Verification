class my_dut_config extends uvm_object;
`uvm_object_utils( my_dut_config )
  virtual arb_inf dut_vi;
  function new(string name = "");
    super.new(name);
  endfunction
endclass
  