module multiplier #(
    parameter int N         = 8,
    parameter int DATA_W    = 16,
    parameter int COEFF_W   = 16,
    parameter int MULT_W    = 32
)(
    input  logic signed [DATA_W-1:0] x_bus [0:N-1],
    input  logic signed [COEFF_W-1:0] h_bus [0:N-1],
    output logic signed [MULT_W-1:0] mult_bus [0:N-1]
);
integer i;
always_comb begin
    for (i=0;i<N;i++) begin
        mult_bus[i] = $signed(x_bus[i]) * $signed(h_bus[i]);
    end
end
endmodule