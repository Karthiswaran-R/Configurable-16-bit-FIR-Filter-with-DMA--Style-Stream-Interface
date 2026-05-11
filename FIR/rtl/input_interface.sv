module input_interface #(
    parameter int DATA_W = 16
)(
    input  logic clk,
    input  logic rst_n,
    input  logic in_valid,
    output logic in_ready,
    input  logic signed [DATA_W-1:0] in_data,
    output logic signed [DATA_W-1:0] data_out,
    output logic valid_out
);
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        in_ready  <= 1'b1;
        valid_out <= 1'b0;
        data_out  <= '0;
    end else begin
        if (in_valid && in_ready) begin
            data_out  <= in_data;
            valid_out <= 1'b1;
        end else begin
            valid_out <= 1'b0;
        end
    end
end
endmodule