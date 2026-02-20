module MUX #(
    parameter ADDRESS_WIDTH = 5 
) (
    input clk ,
    input n_rst ,
    input sel ,
    input [ADDRESS_WIDTH - 1 : 0] inst_add,
    input [ADDRESS_WIDTH - 1 : 0] op_add,
    output reg [ADDRESS_WIDTH - 1 : 0 ] mux_add
);

always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        mux_add <= 5'b0 ; 
    end
    else if (sel) begin
        mux_add <= inst_add ;
    end 
    else if (!sel) begin
        mux_add <= op_add ;
    end
    else begin
        mux_add <= mux_add ;
    end
end
    
endmodule