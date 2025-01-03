`include "processor.sv"

module processor_tb;
    logic clk, reset;

    processor pc1(.clk(clk), .reset(reset)); 


    integer i;
    
    initial begin
        reset = 1;
        clk = 1'b0;
        #5 reset = 0;

        for (i = 0; i < 50; i = i + 1) begin
            #5 clk = ~clk;
        end
    end
    
endmodule