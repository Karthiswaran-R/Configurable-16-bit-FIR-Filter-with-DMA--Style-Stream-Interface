module tb_output_interface;
parameter IN_WIDTH  = 32;
parameter OUT_WIDTH = 16;
parameter MSB_INDEX = IN_WIDTH-1;
reg clk;
reg rst_n;
reg in_valid;
wire in_ready;
reg signed [IN_WIDTH-1:0] sum_in;
wire out_valid;
reg  out_ready;
wire signed [OUT_WIDTH-1:0] out_data;
output_interface #(
    .IN_WIDTH(IN_WIDTH),
    .OUT_WIDTH(OUT_WIDTH),
    .MSB_INDEX(MSB_INDEX)
) dut (
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(in_valid),
    .in_ready(in_ready),
    .sum_in(sum_in),
    .out_valid(out_valid),
    .out_ready(out_ready),
    .out_data(out_data)
);
always #5 clk = ~clk;
reg signed [OUT_WIDTH-1:0] expected;
integer i;
initial begin
    clk = 0;
    rst_n = 0;
    in_valid = 0;
    sum_in = 0;
    out_ready = 0;
    #20;
    rst_n = 1;
    for (i = 0; i < 20; i = i + 1) begin
        @(posedge clk);

        in_valid <= 1;
        sum_in   <= $random;
        expected <= sum_in[MSB_INDEX -: OUT_WIDTH];
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
always @(posedge clk) begin
    if (out_valid && out_ready) begin
        if (out_data !== expected) begin
            $display(" ERROR at time %0t: Expected %0d, Got %0d",$time, expected, out_data);
        end else begin
            $display(" PASS at time %0t: Output %0d",$time, out_data);
        end
    end
end
initial begin
    $monitor("T=%0t | in_valid=%b in_ready=%b sum_in=%0d | out_valid=%b out_ready=%b out_data=%0d",$time, in_valid, in_ready, sum_in, out_valid, out_ready, out_data);
    $dumpfile("tb_ouput_interface.fsdb");
    $dumpvars(0,tb_output_interface);
end
endmodule
