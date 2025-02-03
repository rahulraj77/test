`timescale 1ns/1ps

module counter_test();
reg clk, rst;
wire [7:0] count;


initial begin
clk = 0;
rst  = 0; #10
rst = 1;
end

always begin
#5 clk = ~clk;
end
endmodule
