module coeff_mem #(
    parameter int N        = 8,
    parameter int COEFF_W  = 16
)(
    input  logic clk,
    input  logic cfg_we,
    input  logic [$clog2(N)-1:0] cfg_addr,
    input  logic signed [COEFF_W-1:0] cfg_data,

    output logic signed [COEFF_W-1:0] coeff [0:N-1]
);
integer i;
always_ff @(posedge clk) begin
    if (cfg_we)
        coeff[cfg_addr] <= cfg_data;
end
initial begin
    for (i=0;i<N;i++)
        coeff[i] = '0;
end
endmodule