module IR #(
    parameter ADDRESS_WIDTH = 5,
    parameter INSTRUCTION_WIDTH = 8 ,
    parameter OP_CODE_WIDTH = INSTRUCTION_WIDTH - ADDRESS_WIDTH
)
(
    input clk,
    input n_rst,
    input ld_ir,
    input [INSTRUCTION_WIDTH - 1 : 0] instruction,
    output reg [OP_CODE_WIDTH - 1 : 0] op_code,
    output reg [ADDRESS_WIDTH - 1 : 0] address
);

always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        op_code <= 3'b0;
        address <= 5'b0 ;
    end
    else if (ld_ir) begin
        op_code <= instruction[INSTRUCTION_WIDTH - 1 : ADDRESS_WIDTH] ;
        address <= instruction[ADDRESS_WIDTH - 1 : 0] ;
    end
    else begin
        op_code <= op_code ;
        address <= address ;
    end
end

endmodule