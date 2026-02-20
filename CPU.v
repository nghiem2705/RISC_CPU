module CPU #(
    parameter INSTRUCTION_WIDTH = 8,
    parameter DATA_WIDTH = 8,
    parameter ADDRESS_WIDTH = 5,
    parameter OP_CODE_WIDTH = INSTRUCTION_WIDTH - ADDRESS_WIDTH
)
(
    input clk,
    input n_rst,
    output halt_signel
);


wire halt;
wire ld_pc, inc_pc;
wire ld_ir;
wire ld_ac;
wire sel;
wire data_e ;
wire rd, wr;
wire [ADDRESS_WIDTH - 1 : 0] pc ;
wire [OP_CODE_WIDTH - 1 : 0] op_code;
wire [ADDRESS_WIDTH - 1 : 0] address;
wire [DATA_WIDTH - 1 : 0] data_out;
wire [ADDRESS_WIDTH - 1 : 0] mux_add ;
wire [DATA_WIDTH - 1 : 0] data_r;
wire [DATA_WIDTH - 1 : 0] result ;
wire is_zero;

// CONTROLLER module 
CONTROLLER # (
    .OP_CODE_WIDTH(OP_CODE_WIDTH)
) controller_instance (
    .clk(clk),
    .n_rst(n_rst),
    .is_zero(is_zero),
    .op_code(op_code),
    .sel(sel),
    .rd(rd),
    .ld_ir(ld_ir),
    .halt(halt),
    .inc_pc(inc_pc),
    .ld_ac(ld_ac),
    .ld_pc(ld_pc),
    .wr(wr),
    .data_e(data_e)
);

// PC module 
PC #(
    .ADDRESS_WIDTH(ADDRESS_WIDTH)
) pc_instance (
    .clk (clk),
    .n_rst(n_rst),
    .ld_pc(ld_pc),
    .inc_pc(inc_pc),
    .add_in(mux_add),
    .pc(pc)
);

// IR module 
IR #(
    .ADDRESS_WIDTH(ADDRESS_WIDTH),
    .INSTRUCTION_WIDTH(INSTRUCTION_WIDTH),
    .OP_CODE_WIDTH(OP_CODE_WIDTH)
) ir_instance (
    .clk(clk),
    .n_rst(n_rst),
    .ld_ir(ld_ir),
    .instruction(data_r),
    .op_code(op_code),
    .address(address)
);

// ACC module 
ACC #(
    .DATA_WIDTH(DATA_WIDTH)
) acc_instance (
    .clk(clk),
    .n_rst(n_rst),
    .ld_ac(ld_ac),
    .data_in(result),
    .data_out(data_out)
);

// MUX module 
MUX # (
    .ADDRESS_WIDTH(ADDRESS_WIDTH)
) mux_instance (
    .clk(clk),
    .n_rst(n_rst),
    .sel(sel),
    .inst_add(pc),
    .op_add(address),
    .mux_add(mux_add)
);

// RAM_WRAPPER module
RAM_WRAPPER #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDRESS_WIDTH(ADDRESS_WIDTH)
) ram_wrapper_instance (
    .clk(clk),
    .n_rst(n_rst),
    .rd(rd),
    .wr(wr),
    .data_e(data_e),
    .mux_add(mux_add),
    .data_w(data_out),
    .data_r(data_r)
);

// ALU module 
ALU # (
    .DATA_WIDTH(DATA_WIDTH)
) alu_instance (
    .op_code(op_code),
    .inA(data_out),
    .inB(data_r),
    .result(result),
    .is_zero(is_zero)
);

assign halt_signel = halt ;


endmodule