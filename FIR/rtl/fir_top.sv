module fir_top #(
    parameter int N         = 8,
    parameter int DATA_W    = 16,
    parameter int COEFF_W   = 16,
    parameter int MULT_W    = 32,
    parameter int ACC_W     = 32
)(
    input  logic clk,
    input  logic rst_n,
    // Input Stream
    input  logic in_valid,
    output logic in_ready,
    input  logic signed [DATA_W-1:0] in_data,
    // Output Stream
    output logic out_valid,
    input  logic out_ready,
    output logic signed [DATA_W-1:0] out_data,
    // Coefficient Configuration
    input  logic cfg_we,
    input  logic [$clog2(N)-1:0] cfg_addr,
    input  logic signed [COEFF_W-1:0] cfg_data
);

logic shift_en;
logic signed [DATA_W-1:0] sample;
logic signed [DATA_W-1:0] x_bus [0:N-1];
logic signed [COEFF_W-1:0] h_bus [0:N-1];
logic signed [MULT_W-1:0] mult_bus [0:N-1];
logic signed [ACC_W-1:0] sum_out;

// Input Interface
input_interface #(
    .DATA_W(DATA_W)
) u_input_if (
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(in_valid),
    .in_ready(in_ready),
    .in_data(in_data),
    .data_out(sample),
    .valid_out(shift_en)
);

// Shift Register
shift_register #(
    .N(N),
    .DATA_W(DATA_W)
) u_shift_reg (
    .clk(clk),
    .rst_n(rst_n),
    .shift_en(shift_en),
    .data_in(sample),
    .x_bus(x_bus)
);

// Coefficient Memory
coeff_mem #(
    .N(N),
    .COEFF_W(COEFF_W)
) u_coeff_mem (
    .clk(clk),
    .cfg_we(cfg_we),
    .cfg_addr(cfg_addr),
    .cfg_data(cfg_data),
    .coeff(h_bus)
);

// Multiplier Array
multiplier #(
    .N(N),
    .DATA_W(DATA_W),
    .COEFF_W(COEFF_W),
    .MULT_W(MULT_W)
) u_multiplier (
    .x_bus(x_bus),
    .h_bus(h_bus),
    .mult_bus(mult_bus)
);

// Adder Tree
adder_tree #(
    .N(N),
    .MULT_W(MULT_W),
    .ACC_W(ACC_W)
) u_adder (
    .clk(clk),
    .rst_n(rst_n),
    .shift_en(shift_en),
    .mult_bus(mult_bus),
    .sum(sum_out)
);

// Output Interface
output_interface #(
    .DATA_W(DATA_W),
    .ACC_W(ACC_W)
) u_output_if (
    .clk(clk),
    .rst_n(rst_n),
    .sum_in(sum_out),
    .out_valid(out_valid),
    .out_ready(out_ready),
    .out_data(out_data)
);
endmodule