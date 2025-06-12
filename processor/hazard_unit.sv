module hazard_unit (output logic [2-1:0] ForwardAE,
                    output logic [2-1:0] ForwardBE,
                    output logic StallF,
                    output logic StallD,
                    output logic FlushD,
                    output logic FlushE,
                    input logic [5-1:0] Rs1D,
                    input logic [5-1:0] Rs2D,
                    input logic [5-1:0] Rs1E,
                    input logic [5-1:0] Rs2E,
                    input logic [5-1:0] RdE,
                    input logic [5-1:0] RdM,
                    input logic [5-1:0] RdW,
                    input logic RegWriteM,
                    input logic RegWriteW,
                    input logic PCSrcE,
                    input logic ResultSrcE0);

    logic lwStall;
  
    always_comb begin
        // Forward logic
        if (((Rs1E == RdM) & RegWriteM) & (Rs1E != 1'b0))
            ForwardAE = 2'b10;
        else if (((Rs1E == RdW) & RegWriteW) & (Rs1E != 1'b0))
            ForwardAE = 2'b01;
        else 
            ForwardAE = 2'b00;

        if (((Rs2E == RdM) & RegWriteM) & (Rs2E != 1'b0))
            ForwardBE = 2'b10;
        else if (((Rs2E == RdW) & RegWriteW) & (Rs2E != 1'b0))
            ForwardBE = 2'b01;
        else
            ForwardBE = 2'b00;

    end

    // Stall logic
    assign lwStall = ResultSrcE0 & ((Rs1D == RdE) || (Rs2D == RdE)); // if ResultSrcE[0] == 1, load word is in the execute stage
    assign StallD = lwStall;
    assign StallF = lwStall;

    // Flush logic
    assign FlushD = PCSrcE;
    assign FlushE = lwStall | PCSrcE;

endmodule
