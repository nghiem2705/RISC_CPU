module PC #(
    parameter ADDRESS_WIDTH = 5
) 
(
    input clk,
    input n_rst,
    input ld_pc,
    input inc_pc,
    input [ADDRESS_WIDTH - 1 : 0] add_in,
    output reg [ADDRESS_WIDTH - 1 : 0] pc
);

always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        pc <= 8'h00 ;
    end
    else if (inc_pc) begin 
        pc <= pc + 8'h01 ;
    end
    else if (ld_pc) begin
        pc <= add_in ;
    end
    else begin
        pc <= pc ; 
    end
end
    
endmodule