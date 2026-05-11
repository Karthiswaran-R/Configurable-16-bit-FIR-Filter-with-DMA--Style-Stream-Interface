module fir_tb;
parameter N = 8;
logic clk;
logic rst_n;
logic in_valid;
logic in_ready;
logic signed [15:0] in_data;
logic out_valid;
logic out_ready;
logic signed [15:0] out_data;
logic cfg_we;
logic [$clog2(N)-1:0] cfg_addr;
logic signed [15:0] cfg_data;

fir_top #(N) dut (.*);
initial clk = 0;
always #5 clk = ~clk;
initial begin
    rst_n = 0;
    in_valid = 0;
    out_ready = 1;
    cfg_we = 0;
    repeat(5) @(posedge clk);
    rst_n = 1;
    // Load coefficients
    for (int i=0;i<N;i++) begin
        @(posedge clk);
        cfg_we   = 1;
        cfg_addr = i;
        cfg_data = i+1;
    end
    @(posedge clk);
    cfg_we = 0;
    // Send samples
    for (int i=0;i<20;i++) begin
        @(posedge clk);
        in_valid = 1;
        in_data  = i*100;
    end
    @(posedge clk);
    in_valid = 0;
    repeat(50) @(posedge clk);
    $finish;
end
endmodule