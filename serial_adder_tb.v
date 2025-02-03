module serial_adder_tb;
  reg [7:0] A, B;
  reg reset, clock;
  wire [7:0] sum;

  serial_adder s1(A, B, reset, clock, sum);

  always begin
    #5 clock = ~clock;
  end

  initial begin
    clock = 0;
    A = 8'h03;
    B = 8'h05;
    reset = 1;
    #10 reset = 0;
    #100 $finish;
  end
endmodule
