module serial_adder(A, B, reset, clock, sum);
  input [7:0] A, B;
  input reset, clock;
  output reg [7:0] sum;

  reg [3:0] count;
  reg carry_in;
  reg s;
  reg carry_in_next;

  wire [7:0] qa, qb;
  wire run;

  shiftreg A1(A, reset, 1'b1, 1'b0, clock, qa);
  shiftreg B1(B, reset, 1'b1, 1'b0, clock, qb);
  
  always @(posedge clock or posedge reset) begin
    if (reset) begin
      sum <= 8'b0;
      carry_in <= 0;
      count <= 8;
    end else if (run) begin
      sum <= {s, sum[7:1]};
      carry_in <= carry_in_next;
    end
  end

  always @(qa, qb, carry_in) begin
    s = qa[0] ^ qb[0] ^ carry_in;
    carry_in_next = (qa[0] & qb[0]) | (qa[0] & carry_in) | (qb[0] & carry_in);
  end

  always @(posedge clock or posedge reset) begin
    if (reset) 
      count <= 8;
    else if (run) 
      count <= count - 1;
  end
  
  assign run = (count > 0);
  
endmodule
