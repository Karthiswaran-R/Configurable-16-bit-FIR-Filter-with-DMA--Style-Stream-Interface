
module shift_register_tb;

parameter N = 8;
parameter WIDTH = 16;

// DUT signals
reg clk;
reg rst_n;
reg shift_en;
reg signed [WIDTH-1:0] data_in;

wire signed [N*WIDTH-1:0] x_bus;

// Instantiate DUT
shift_register #(N, WIDTH) dut (
    .clk(clk),
    .rst_n(rst_n),
    .shift_en(shift_en),
    .data_in(data_in),
    .x_bus(x_bus)
);

//////////////////////////////////////////////////
// CLOCK
//////////////////////////////////////////////////
initial clk = 0;
always #5 clk = ~clk;   // 100 MHz

//////////////////////////////////////////////////
// RESET
//////////////////////////////////////////////////
task reset_dut;
begin
    rst_n = 0;
    shift_en = 0;
    data_in = 0;
    repeat(5) @(posedge clk);
    rst_n = 1;
end
endtask

//////////////////////////////////////////////////
// INPUT DRIVER
//////////////////////////////////////////////////
task send_sample(input signed [15:0] sample);
begin
    @(posedge clk);
    shift_en = 1;
    data_in  = sample;

    @(posedge clk);
    shift_en = 0;
end
endtask

//////////////////////////////////////////////////
// MONITOR
//////////////////////////////////////////////////
integer i;

always @(posedge clk) begin
    $write("T=%0t | x = ", $time);
    for (i=0;i<N;i=i+1) begin
        $write("%0d ", x_bus[i*WIDTH +: WIDTH]);
    end
    $write("\n");
end

//////////////////////////////////////////////////
// TEST SEQUENCE
//////////////////////////////////////////////////
initial begin
    $dumpfile("shift_register.vcd");
    $dumpvars(0, shift_register_tb);

    reset_dut();

    // Apply samples
    send_sample(10);
    send_sample(20);
    send_sample(30);
    send_sample(40);
    send_sample(50);

    // Wait to observe shifts
    repeat(10) @(posedge clk);

    $finish;
end

endmodule
