module ACC #(
    parameter DATA_WIDTH = 8
) (
    input clk ,
    input n_rst,
    input ld_ac,
    input [DATA_WIDTH - 1 : 0] data_in, 
    output reg [DATA_WIDTH - 1 : 0] data_out
);

always @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        data_out <= {DATA_WIDTH{1'b0}};
    end
    else if (ld_ac) begin
        data_out <= data_in;
    end
    else begin
        data_out <= data_out;
    end
end
    
endmodule