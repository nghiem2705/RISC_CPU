module tb_cpu ;

reg clk;
reg n_rst;
wire halt_signel;

parameter INSTRUCTION_WIDTH = 8;
parameter DATA_WIDTH = 8 ;
parameter ADDRESS_WIDTH = 5 ;
parameter OP_CODE_WIDTH = 3 ;

CPU # (
    .INSTRUCTION_WIDTH(INSTRUCTION_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .ADDRESS_WIDTH(ADDRESS_WIDTH),
    .OP_CODE_WIDTH(OP_CODE_WIDTH)
) cpu_instance (
    .clk(clk),
    .n_rst(n_rst),
    .halt_signel(hal_signel)
);

// T?o xung Clock
initial begin
    clk = 0; // B?T BU?C: Kh?i t?o giá tr? ban ??u cho clk
    forever #5 clk = ~clk; // Chu k? 10ns
end

initial begin
    n_rst = 0 ; #5
    n_rst = 1 ; 

    #10000 $finish ;
end

endmodule 