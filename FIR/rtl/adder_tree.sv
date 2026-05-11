module adder_tree #(
    parameter int N       = 8,
    parameter int MULT_W  = 32,
    parameter int ACC_W   = 32
)(
    input  logic clk,
    input  logic rst_n,
    input  logic shift_en,
    input  logic signed [MULT_W-1:0] mult_bus [0:N-1],
    output logic signed [ACC_W-1:0] sum
);
integer i;
logic signed [ACC_W-1:0] acc;
logic [$clog2(N+1)-1:0] valid_cnt;
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum       <= '0;
        valid_cnt <= '0;
    end
    else begin
        if (shift_en && valid_cnt < N)
            valid_cnt <= valid_cnt + 1'b1;
        acc = '0;
        for (i=0;i<N;i++) begin
            if (i < valid_cnt)
                acc = acc + mult_bus[i];
        end
        sum <= acc;
    end
end
endmodule
