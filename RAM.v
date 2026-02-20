module RAM #(
    parameter DATA_WIDTH = 8 ,
    parameter ADDRESS_WIDTH = 5 
)(
    input clk ,
    input n_rst,
    input rd,
    input wr,
    input data_e,
    input [ADDRESS_WIDTH - 1 : 0] mux_add_in ,
    inout [DATA_WIDTH - 1 : 0] data
);

reg [DATA_WIDTH - 1 : 0] mem [0 : (2**ADDRESS_WIDTH) - 1] ;
reg [DATA_WIDTH - 1 : 0] data_tmp ;

initial begin
    $readmemh("program.hex", mem);
end

assign data = (rd && !wr) ? data_tmp : {DATA_WIDTH{1'bz}} ;

always @(posedge clk) begin
    
    data_tmp <= {DATA_WIDTH{1'b0}};

    if (wr && data_e) begin
        mem[mux_add_in] <= data;
    end
    else if (rd) begin
        data_tmp <= mem[mux_add_in] ;
    end
end

endmodule 