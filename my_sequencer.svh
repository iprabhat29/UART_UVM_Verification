class my_sequencer extends uvm_sequencer #(my_transaction);
  `uvm_component_utils(my_sequencer)
  uvm_blocking_put_port #(my_transaction) put_port;
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    put_port = new("put_port",this);
  endfunction
  
  task run_phase(uvm_phase phase);
    repeat(10) begin
      my_transaction my_trans_h = new();
      if(my_trans_h.randomize()) begin
        //$display("data-->%d",my_trans_h.datain);
        my_trans_h.setup();
        //my_trans_h.display();
        put_port.put(my_trans_h);
        //`uvm_info("my_sequencer","Randomized and sending to fifo",UVM_LOW)
        my_trans_h.start();
        //my_trans_h.display();
        put_port.put(my_trans_h);
        //`uvm_info("my_sequencer","Randomized and sending to fifo",UVM_LOW)
      end
      else 
        `uvm_fatal("my_sequencer","Can't randomize!!!")
        end
  endtask      
endclass
    