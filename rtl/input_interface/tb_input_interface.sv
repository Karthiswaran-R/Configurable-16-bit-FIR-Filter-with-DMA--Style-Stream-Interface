module tb_input_interface;
parameter DATA_WIDTH = 16;
reg clk;
reg rst_n;
reg in_valid;
wire in_ready;
reg signed [DATA_WIDTH-1:0] in_data;
wire out_valid;
reg out_ready;
wire signed [DATA_WIDTH-1:0] out_data;
input_interface #(
    .DATA_WIDTH(DATA_WIDTH)
) dut (
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(in_valid),
    .in_ready(in_ready),
    .in_data(in_data),
    .out_valid(out_valid),
    .out_ready(out_ready),
    .out_data(out_data)
);
always #5 clk = ~clk;
integer i;
initial begin
    clk = 0;
    rst_n = 0;
    in_valid = 0;
    in_data  = 0;
    out_ready = 0;
    #20;
    rst_n = 1;
    for (i = 0; i < 20; i = i + 1) begin
        @(posedge clk);
        in_valid <= 1;
        in_data  <= i;
        out_ready <= $random % 2;
        while (!in_ready) begin
            @(posedge clk);
            out_ready <= $random % 2;
        end
    end
    @(posedge clk);
    in_valid <= 0;
    repeat(10) @(posedge clk);
    $finish;
end
initial begin
    $monitor("T=%0t | in_valid=%b in_ready=%b in_data=%0d | out_valid=%b out_ready=%b out_data=%0d",
              $time, in_valid, in_ready, in_data, out_valid, out_ready, out_data);
	$dumpfile("tb_input_interface.fsdb");
	$dumpvars(0,tb_input_interface);
end
endmodule
