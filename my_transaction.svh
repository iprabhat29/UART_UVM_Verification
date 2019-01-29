class my_transaction extends uvm_sequence_item;
  bit reset;
  bit enable;
  bit send;
  rand logic [9:0] datain;
  
  task setup();
    this.reset = 1;
    this.enable = 1;
    this.send = 0;
  endtask
  
  task start();
    this.reset = 0;
    this.enable = 1;
    this.send = 1;
  endtask 
  
  task display();
    $display("Reset %b Send %b Enable %b",this.reset,this.send,this.enable);
  endtask
endclass
  
  