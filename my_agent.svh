class my_agent extends uvm_agent;
  `uvm_component_utils(my_agent)
  my_sequencer my_sq_h;
  my_driver my_dr_h;
  //my_monitor my_mon_h;
  my_dut_config my_config_h;
  uvm_tlm_fifo #(my_transaction) tlm_fifo;

  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    my_sq_h = my_sequencer::type_id::create("my_sq_h",this);
    my_dr_h = my_driver::type_id::create("my_dr_h",this);
    //my_mon_h = my_monitor::type_id::create("my_mon_h",this);
    my_config_h = new();
    if (!uvm_config_db #(virtual arb_inf)::get(this, "", "dut_vi", my_config_h.dut_vi))  
      `uvm_fatal("FATAL MSG", "Virtual Interface Not Set Properly");
    uvm_config_db #(my_dut_config)::set(this, "*", "config", my_config_h);
    tlm_fifo = new ("uvm_tlm_fifo", this, 1);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    my_sq_h.put_port.connect(tlm_fifo.put_export);
    my_dr_h.get_port.connect(tlm_fifo.get_export);
  endfunction
  
  task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	#1000;
	phase.drop_objection(this);
  endtask
    
endclass