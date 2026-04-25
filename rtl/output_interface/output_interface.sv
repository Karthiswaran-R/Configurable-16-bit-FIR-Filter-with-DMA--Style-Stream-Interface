module output_interface #(
    parameter IN_WIDTH  = 32,
    parameter OUT_WIDTH = 16,
    parameter MSB_INDEX = IN_WIDTH-1   
)(
    input  wire clk,
    input  wire rst_n,

    input  wire in_valid,
    output wire in_ready,
    input  wire signed [IN_WIDTH-1:0] sum_in,

    output reg  out_valid,
    input  wire out_ready,
    output reg  signed [OUT_WIDTH-1:0] out_data
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
            out_data  <= sum_in[MSB_INDEX -: OUT_WIDTH];           
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
