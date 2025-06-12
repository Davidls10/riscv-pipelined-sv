module register_file #(parameter N = 5,  M = 32, L = 32)
                (input logic clk,
                 input logic we,
                 input logic [N-1:0] a1, a2, a3,
                 input logic [M-1:0] wd3,
                 output logic [M-1:0] rd1, rd2);

    logic [M-1:0] rf [L-1:0];

    always_ff @(negedge clk) begin
            if (we) rf[a3] = wd3;
    end

    assign rd1 = (a1 != 0) ? rf[a1] : 0;
    assign rd2 = (a2 != 0) ? rf[a2] : 0;
endmodule
