`timescale 1ps/1ps
module easy_fifo #
(
	parameter int DWIDTH = 32,
	parameter int DEPTH	= 16
)
(
	input logic clk,
	input logic rst,
	input logic [DWIDTH-1:0] s_axis_tdata,
	input logic s_axis_tvalid,
    output logic s_axis_tready,
	output logic [DWIDTH-1:0] m_axis_tdata,
	output logic m_axis_tvalid,
    input logic m_axis_tready
);
	logic [DWIDTH-1:0] fifo_lutram[DEPTH-1:0] = '{DEPTH{{DWIDTH{1'b0}}}};
	logic [$clog2(DEPTH)-1:0] lutram_rd_addr;
	logic [$clog2(DEPTH)-1:0] lutram_wr_addr;
	logic [$clog2(DEPTH):0] lutram_rd_ptr = {($clog2(DEPTH)+1){1'b0}};
	logic [$clog2(DEPTH):0] lutram_wr_ptr = {($clog2(DEPTH)+1){1'b0}};

	logic lutram_empty = 1'b1;
	logic lutram_full = 1'b0;
    logic core_rdy;

	always_ff @(posedge clk) begin
		if (rst) begin
			lutram_rd_ptr <= {($clog2(DEPTH)+1){1'b0}};
			lutram_wr_ptr <= {($clog2(DEPTH)+1){1'b0}};
            lutram_empty <= 1'b1;
            lutram_full <= 1'b0;
		end
		else begin
			if (s_axis_tvalid & ~lutram_full) begin
				fifo_lutram[lutram_wr_addr] <= s_axis_tdata;
				lutram_wr_ptr <= lutram_wr_ptr + 1'b1;
			end
			if (core_rdy && lutram_rd_ptr != lutram_wr_ptr)
				lutram_rd_ptr <= lutram_rd_ptr + 1'b1;

            if (core_rdy)
                lutram_full <= 1'b0;
            else if (s_axis_tvalid && (lutram_rd_ptr - 1'b1 == {~lutram_wr_ptr[$clog2(DEPTH)],lutram_wr_addr}))
                lutram_full <= 1'b1;
            if (s_axis_tvalid)
                lutram_empty <= 1'b0;
            else if (core_rdy && (lutram_rd_ptr + 1'b1 == lutram_wr_ptr))
                lutram_empty <= 1'b1;
		end
	end

//output reg
    always_ff @(posedge clk) begin
        if (rst) begin
            m_axis_tdata <= {DWIDTH{1'b0}};
            m_axis_tvalid <= 1'b0;
        end
        else if (core_rdy) begin
            m_axis_tdata <= fifo_lutram[lutram_rd_addr];
            m_axis_tvalid <= ~lutram_empty;
        end
    end
    assign core_rdy = m_axis_tready || ~m_axis_tvalid;
	assign s_axis_tready = ~lutram_full;

	assign lutram_wr_addr = lutram_wr_ptr[$clog2(DEPTH)-1:0];
	assign lutram_rd_addr = lutram_rd_ptr[$clog2(DEPTH)-1:0];
endmodule