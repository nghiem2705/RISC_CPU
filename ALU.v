module ALU #(
    parameter DATA_WIDTH = 8
)(
    input wire [2:0] op_code,
    input [DATA_WIDTH - 1 : 0] inA,
    input [DATA_WIDTH - 1 : 0] inB,
    output reg [DATA_WIDTH - 1 : 0] result,
    output reg is_zero
);

always @(*) begin

    is_zero = 1'b0;
    result = 8'b0 ;

    case (op_code)
        3'b000 : result = inA;
        3'b001 : begin
                    result = inA;
                    is_zero = (inA == 0) ? 1'b1 : 1'b0;
                 end 
        3'b010 : result = inA + inB ;
        3'b011 : result = inA & inB ;
        3'b100 : result = inA ^ inB ;
        3'b101 : result = inB;
        3'b110 : result = inA;
        3'b111 : result = inA;
        default: result = 8'b0;
    endcase
end

endmodule