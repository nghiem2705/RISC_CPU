module CONTROLLER #(
    parameter OP_CODE_WIDTH = 3  
)
(
    input clk ,
    input n_rst,
    input is_zero,
    input [OP_CODE_WIDTH - 1 : 0] op_code,
    output reg sel,
    output reg rd,
    output reg ld_ir,
    output reg halt,
    output reg inc_pc,
    output reg ld_ac,
    output reg ld_pc,
    output reg wr,
    output reg data_e
);

localparam HLT = 3'b000; // 0
localparam SKZ = 3'b001; // 1
localparam ADD = 3'b010; // 2
localparam AND = 3'b011; // 3
localparam XOR = 3'b100; // 4
localparam LDA = 3'b101; // 5
localparam STO = 3'b110; // 6
localparam JMP = 3'b111; // 7

localparam INST_ADDR  = 4'd0;
localparam INST_FETCH = 4'd1;
localparam INST_LOAD  = 4'd2;
localparam IDLE       = 4'd3;
localparam OP_ADDR    = 4'd4;
localparam OP_FETCH   = 4'd5;
localparam ALU_OP     = 4'd6;
localparam STORE      = 4'd7;

reg [3 : 0] state ;

always @(posedge clk or negedge n_rst) begin

    if (!n_rst) begin
        {sel , rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} <= 9'b0;
        state <= INST_ADDR ;
    end

    else begin

        {sel , rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} <= 9'b0;

        case (state)

            INST_ADDR : begin
                sel <= 1'b1 ;
                state <= INST_FETCH;
            end

            INST_FETCH : begin
                sel <= 1'b1 ;
                rd <= 1'b1;
                state <= INST_LOAD ;
            end

            INST_LOAD : begin
                sel <= 1'b1;
                rd <= 1'b1;
                ld_ir <= 1'b1;
                state <= IDLE;
            end

            IDLE : begin
                sel <= 1'b1;
                rd <= 1'b1;
                ld_ir <= 1'b1;
                state <= OP_ADDR;
            end

            OP_ADDR : begin
                if (op_code == HLT) begin
                    halt <= 1'b1;
                    inc_pc <= 1'b1;
                    state <= OP_ADDR;
                end
                else begin
                    halt <= 1'b0 ;
                    inc_pc <= 1'b1;
                    state <= OP_FETCH;
                end
            end

            OP_FETCH : begin
                if (op_code == ADD | op_code == AND | op_code == XOR | op_code == LDA) begin
                    rd <= 1'b1;
                end 
                
                else begin
                    rd <= 1'b0;
                end

                state <= ALU_OP;
            end

            ALU_OP : begin
                if (op_code == ADD | op_code == AND | op_code == XOR | op_code == LDA) begin
                    rd <= 1'b1;
                end 

                else if (op_code == SKZ && is_zero) begin
                    inc_pc <= 1'b1 ;
                end

                else if (op_code == JMP) begin
                    ld_pc <= 1'b1;
                end

                else if (op_code == STO) begin
                    data_e <= 1'b1 ;
                end

                else begin
                  rd <= 1'b0;
                  inc_pc <= 1'b0;
                  ld_pc <= 1'b0;
                  data_e <= 1'b0 ;
                end

                state <= STORE;
            end

            STORE : begin
                if (op_code == ADD | op_code == AND | op_code == XOR | op_code == LDA) begin
                    rd <= 1'b1;
                    ld_ac <= 1'b1;
                end 

                else if (op_code == JMP) begin
                    ld_pc <= 1'b1;
                end

                else if (op_code == STO) begin
                    wr <= 1'b1;
                    data_e <= 1'b1 ;
                end

                else begin
                  rd <= 1'b0;
                  ld_ac <= 1'b0;
                  ld_pc <= 1'b0;
                  wr <= 1'b0;
                  data_e <= 1'b0 ;
                end

                state <= INST_ADDR;
            end

            default: begin
                {sel , rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} <= 9'b0;
                state <= INST_ADDR;
            end
        endcase
    end
end

endmodule 