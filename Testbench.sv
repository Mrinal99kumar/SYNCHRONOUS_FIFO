class stimulas;
  rand bit [7:0]data_in;
  rand bit write, read;
  
  
endclass



module tb_syncfifo();
  stimulas st;
logic clk,rst_n,write,read;
logic [7:0]data_in;
logic [7:0]data_out;
logic empty;
logic full;
logic [3:0]count;
  
  sync_fifo fw(clk,rst_n,write,read,data_in,data_out,empty,full,count);
  
covergroup cgroup@(posedge clk);
    option.per_instance = 1;
  coverpoint data_in {bins b1 =  {[0:63]};
                      bins b2  =  {[64:127]};
                      bins b3 =  {[128:191]};
                      bins b4 = {[192:255]};}
endgroup
 
cgroup cg ;
    

always begin
#5 clk = ~clk;
end

initial begin
  st = new();
rst_n = 1;
clk = 0;
read = 0;
write = 0;
#3 rst_n = 0;
 
  
$monitor($time," The stored data is = %0d || data_in = %0d count=%0d ",data_out,data_in,count);
  
end  
 
  
initial begin
  cg = new();
  write = 1;
  repeat(34)begin
    #5 st.randomize();
      data_in = st.data_in;
    read = 1;
  end
 #0 $display("the coverage = %0d",cg.get_coverage);
#100 $finish;
end
  
initial begin 
    $dumpfile("dump.vcd"); 
    $dumpvars;
end

endmodule
