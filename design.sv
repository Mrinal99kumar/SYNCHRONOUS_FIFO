interface fifo;

logic clk,rst_n,write,read,full,empty;
  logic [7:0] data_in,data_out;
  logic [3:0] count;

modport dsgn(input clk,rst_n,write,read,data_in,output  data_out,count,full,empty);
  
modport  test(input data_out,count,full,empty,output clk,rst_n,write,read,data_in);
  
endinterface


module sync_fifo (fifo.dsgn inf);

reg [3:0] w_ptr, r_ptr;
reg [7:0] fifo[16];


// Set Default values on reset.
always@(posedge inf.clk) begin
  if(!inf.rst_n) begin
    w_ptr <= 0; r_ptr <= 0;
    inf.data_out <= 0;
    inf.count <= 0;
  end
end

// To write data to FIFO
always@(posedge inf.clk) begin
    if(inf.write & !inf.full)begin
       fifo[w_ptr] <= inf.data_in;
       w_ptr <= w_ptr + 1;
       inf.count <= inf.count+1;
    end
end

// To read data from FIFO
always@(posedge inf.clk) begin
    if(inf.read & !inf.empty) begin
       inf.data_out <= fifo[r_ptr];
       r_ptr <= r_ptr + 1;
       inf.count <= inf.count-1;
    end
end

assign inf.full = ((w_ptr+1'b1) == r_ptr);
assign inf.empty = (w_ptr == r_ptr);
endmodule
