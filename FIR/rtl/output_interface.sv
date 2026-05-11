module output_interface #(
    parameter int DATA_W = 16,
    parameter int ACC_W  = 32
)(
    input  logic clk,
    input  logic rst_n,
    input  logic signed [ACC_W-1:0] sum_in,
    output logic out_valid,
    input  logic out_ready,
    output logic signed [DATA_W-1:0] out_data
);
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out_valid <= 1'b0;
        out_data  <= '0;
    end
    else begin
        out_valid <= 1'b1;
        if (out_ready)
            out_data <= sum_in[DATA_W-1:0];
    end
end
endmodule