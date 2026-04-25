module shift_register #(
    parameter N = 8,              
    parameter WIDTH = 16          
)(
    input  wire clk,
    input  wire rst_n,
    input  wire shift_en,     
    input  wire signed [WIDTH-1:0] data_in,
    output reg signed [N*WIDTH-1:0] x_bus
);
integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        x_bus <= 0;
    end 
    else if (shift_en) begin
        for (i = N-1; i > 0; i = i - 1) begin
            x_bus[i*WIDTH +: WIDTH] <= x_bus[(i-1)*WIDTH +: WIDTH];
        end
        x_bus[0 +: WIDTH] <= data_in;
    end
end
endmodule
