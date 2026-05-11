module shift_register #(
    parameter int N      = 8,
    parameter int DATA_W = 16
)(
    input  logic clk,
    input  logic rst_n,
    input  logic shift_en,
    input  logic signed [DATA_W-1:0] data_in,

    output logic signed [DATA_W-1:0] x_bus [0:N-1]
);
integer i;
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i=0;i<N;i++)
            x_bus[i] <= '0;
    end
    else if (shift_en) begin
        for (i=N-1;i>0;i--)
            x_bus[i] <= x_bus[i-1];
        x_bus[0] <= data_in;
    end
end
endmodule