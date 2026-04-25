module shift_register #(
    parameter N = 8,              // Number of taps
    parameter WIDTH = 16          // Data width
)(
    input  wire clk,
    input  wire rst_n,

    // control
    input  wire shift_en,         // valid data indicator

    // input
    input  wire signed [WIDTH-1:0] data_in,

    // output (packed bus for multiplier)
    output reg signed [N*WIDTH-1:0] x_bus
);

integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        x_bus <= 0;
    end 
    else if (shift_en) begin
        // Shift operation
        for (i = N-1; i > 0; i = i - 1) begin
            x_bus[i*WIDTH +: WIDTH] <= x_bus[(i-1)*WIDTH +: WIDTH];
        end

        // Insert new sample
        x_bus[0 +: WIDTH] <= data_in;
    end
end

endmodule
