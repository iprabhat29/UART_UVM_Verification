class my_driver extends uvm_driver #(my_transaction);
  `uvm_component_utils(my_driver)
  uvm_blocking_get_port #(my_transaction) get_port;
  virtual arb_inf dut_vi;
  my_dut_config my_config_h;
  function new(string name ,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    get_port = new("get_port",this);
    if(!uvm_config_db #(my_dut_config)::get(this, "", "config", my_config_h))
       `uvm_fatal("FATAL MSG", "Configuration Object Not Received Properly");
  endfunction
  
  function void connect_phase (uvm_phase phase);
   super.connect_phase(phase);
   dut_vi = my_config_h.dut_vi;
  endfunction: connect_phase
  
  task run_phase(uvm_phase phase);
    repeat(10) begin
      my_transaction t = new();
      get_port.get(t);
      //`uvm_info("my_driver","Got the data",UVM_LOW)
      dut_vi.reset = 1;
      dut_vi.enable = 1;
      dut_vi.send = 0;
      dut_vi.datain = t.datain;
      @(dut_vi.busy <= 0);
      #30;
      t = new();
      get_port.get(t);
      //`uvm_info("my_driver","Got the data",UVM_LOW)
      dut_vi.reset = 0;
      dut_vi.enable = 1;
      dut_vi.send = 1;
      dut_vi.datain = t.datain;
      @(dut_vi.busy <= 1);
      @(dut_vi.busy <= 0);
    end
  endtask
endclass
  
  
    