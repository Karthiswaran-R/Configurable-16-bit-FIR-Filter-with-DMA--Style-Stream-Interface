module input_interface #(
    parameter DATA_WIDTH = 16
)(
    input clk,
    input rst_n,
    input  in_valid,
    output in_ready,
    input  signed [DATA_WIDTH-1:0] in_data,
    output reg out_valid,
    input      out_ready,
    output reg signed [DATA_WIDTH-1:0] out_data
);

reg full;
assign in_ready = !full || (out_ready && out_valid);
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out_valid <= 0;
        out_data  <= 0;
        full      <= 0;
    end else begin
        if (in_valid && in_ready) begin
            out_data  <= in_data;
            out_valid <= 1;
            full      <= 1;
        end
        else if (out_valid && out_ready) begin
            out_valid <= 0;
            full      <= 0;
        end
    end
end
endmodule
