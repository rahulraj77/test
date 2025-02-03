`timescale 1ns/1ps

module counter8bit(input clk, rst, output reg [7:0] count);

always @(posedge clk or nededge rst) begin
if(~rst) begin
count <= 0;
end else begin 
count <= count + 1;
end 
end
endmodule
