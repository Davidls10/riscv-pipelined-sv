module alu#(parameter N = 32)
           (output logic [N-1:0] ALUResult,
            output logic zero_flag,
            input logic [N-1:0] SrcA, SrcB,
            input logic [3-1:0] ALUControl);

    logic [N-1:0] sum;
    logic [N-1:0] sub;
    logic [N-1:0] y_and;
    logic [N-1:0] y_or;
    assign zero_flag = ((SrcA - SrcB) !== 0) ? 0 : 1;

    adder add1(.f(sum), .cout(cout), .a(SrcA), .b(SrcB)); // 000
    subtractor sub1(sub, SrcA, SrcB); // 001
    andN and1(y_and, SrcA, SrcB); // 010
    orN or1(y_or, SrcA, SrcB); // 011
    mux32 mux32_1(ALUResult, sum, sub, y_and, y_or, ALUControl);
endmodule

module half_adder(s, c, a, b);
    output logic s, c;
    input logic a, b;

    assign s = a ^ b;
    assign c = a & b;
endmodule

module full_adder(s, cout, a, b, cin);
    output logic s, cout;
    input logic a, b, cin;

    half_adder h1(s1, cout1, a, b), h2(s, cout2, s1, cin);
    or g1(cout, cout1, cout2);
endmodule

module adder#(parameter N = 32)
             (output logic [N-1:0] f, 
              output logic cout,
              input logic [N-1:0] a, b);

    logic [N:0] carry;

    genvar i;

    assign carry[0] = 0;

    generate
        for (i = 0; i < N; i = i + 1) begin
            full_adder s(f[i], carry[i+1], a[i], b[i], carry[i]);
        end
    endgenerate

    assign cout = carry[N];
endmodule

module subtractor #(parameter N = 32)
                   (output logic [N-1:0] y,
                    input logic [N-1:0] a, b);
    
    assign y = a - b;
endmodule

module andN #(parameter N = 32)
            (output logic [N-1:0] f,
             input logic [N-1:0] a, b);

    assign f = a & b;
endmodule

module orN #(parameter N = 32)
            (output logic [N-1:0] f,
             input logic [N-1:0] a, b);

    assign f = a | b;
endmodule

module mux32(output logic [32-1:0] y,
             input logic [32-1:0] d0, d1, d2, d3,
             input logic [3-1:0] s);
        
    assign y = s[2] ? 32'bx : (s[1] ? (s[0] ? d3 : d2) : (s[0] ? d1 : d0));
endmodule