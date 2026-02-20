module RAM_WRAPPER #(
    parameter DATA_WIDTH = 8 ,
    parameter ADDRESS_WIDTH = 5 
) (
    input clk,
    input n_rst,
    input rd,
    input wr,
    input data_e,
    input [ADDRESS_WIDTH - 1 : 0] mux_add,
    input [DATA_WIDTH - 1 : 0] data_w,
    output [DATA_WIDTH - 1 : 0] data_r
);

wire [DATA_WIDTH - 1 : 0] data ; 
assign data = (wr && data_e) ? data_w : {DATA_WIDTH{1'bz}} ;
assign data_r = data ;
// RAM module 

RAM #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDRESS_WIDTH(ADDRESS_WIDTH)
) ram_instance (
    .clk(clk),
    .n_rst(n_rst),
    .rd(rd),
    .wr(wr),
    .data_e(data_e),
    .mux_add_in(mux_add),
    .data(data)
);
    
endmodule