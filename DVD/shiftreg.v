module shiftreg(R, L, E, W, clock, q);
  parameter n = 8;
  input [n-1:0] R;
  input L, E, W, clock;
  output [n-1:0] q;
  reg [n-1:0] q;
  integer k;

  always @(posedge clock) begin
    if (L)
      q <= R;
    else if (E) begin
      for (k = n-1; k > 0; k = k - 1)
        q[k-1] <= q[k];
      q[n-1] <= W;
    end
  end
endmodule
