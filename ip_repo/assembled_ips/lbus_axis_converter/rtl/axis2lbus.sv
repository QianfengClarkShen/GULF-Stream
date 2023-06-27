`timescale 1ps/1ps

module axis2lbus # (
	parameter ENABLE_ILKN_PORTS = 0
) (
	input logic clk,
	input logic rst,
//AXI4-Stream interface
	input logic [511:0] s_axis_tdata,
	input logic [63:0] s_axis_tkeep,
	input logic s_axis_tlast,
	input logic s_axis_tvalid,
	output logic s_axis_tready,
//LBUS interface
	//optional for interlaken
	input logic [10:0] tx_lbus_seg0_chan_in,
	input logic [10:0] tx_lbus_seg1_chan_in,
	input logic [10:0] tx_lbus_seg2_chan_in,
	input logic [10:0] tx_lbus_seg3_chan_in,
	input logic tx_lbus_seg0_bctlin_in,
	input logic tx_lbus_seg1_bctlin_in,
	input logic tx_lbus_seg2_bctlin_in,
	input logic tx_lbus_seg3_bctlin_in,
	output logic [10:0] tx_lbus_seg0_chan_out,
	output logic [10:0] tx_lbus_seg1_chan_out,
	output logic [10:0] tx_lbus_seg2_chan_out,
	output logic [10:0] tx_lbus_seg3_chan_out,
	output logic tx_lbus_seg0_bctlin_out,
	output logic tx_lbus_seg1_bctlin_out,
	output logic tx_lbus_seg2_bctlin_out,
	output logic tx_lbus_seg3_bctlin_out,
	output logic tx_lbus_ready_out,
	//common
	input logic tx_lbus_ready,
	output logic [127:0] tx_lbus_seg0_data,
	output logic tx_lbus_seg0_ena,
	output logic tx_lbus_seg0_sop,
	output logic tx_lbus_seg0_eop,
	output logic [3:0] tx_lbus_seg0_mty,
	output logic tx_lbus_seg0_err,
	output logic [127:0] tx_lbus_seg1_data,
	output logic tx_lbus_seg1_ena,
	output logic tx_lbus_seg1_sop,
	output logic tx_lbus_seg1_eop,
	output logic [3:0] tx_lbus_seg1_mty,
	output logic tx_lbus_seg1_err,
	output logic [127:0] tx_lbus_seg2_data,
	output logic tx_lbus_seg2_ena,
	output logic tx_lbus_seg2_sop,
	output logic tx_lbus_seg2_eop,
	output logic [3:0] tx_lbus_seg2_mty,
	output logic tx_lbus_seg2_err,
	output logic [127:0] tx_lbus_seg3_data,
	output logic tx_lbus_seg3_ena,
	output logic tx_lbus_seg3_sop,
	output logic tx_lbus_seg3_eop,
	output logic [3:0] tx_lbus_seg3_mty,
	output logic tx_lbus_seg3_err
);

/* --------------------------------------
**  internal logics
   ------------------------------------*/
	logic [15:0] tkeep_seg0;
	logic [15:0] tkeep_seg1;
	logic [15:0] tkeep_seg2;
	logic [15:0] tkeep_seg3;
	logic [3:0] tx_lbus_seg0_mty_int;
	logic [3:0] tx_lbus_seg1_mty_int;
	logic [3:0] tx_lbus_seg2_mty_int;
	logic [3:0] tx_lbus_seg3_mty_int;

/* --------------------------------------
**  internal logic
   ------------------------------------*/
	reg in_packet;
	always @(posedge clk) begin
		if (rst)
			in_packet <= 1'b0;
		else if(tx_lbus_ready) begin
			if (s_axis_tvalid & s_axis_tlast)
				in_packet <= 1'b0;
			else if (s_axis_tvalid)
				in_packet <= 1'b1;
		end
	end

	keep2mty keep2mty_seg0_inst (
		.tkeep(tkeep_seg0),
		.mty(tx_lbus_seg0_mty_int)
	);
	keep2mty keep2mty_seg1_inst (
		.tkeep(tkeep_seg1),
		.mty(tx_lbus_seg1_mty_int)
	);
	keep2mty keep2mty_seg2_inst (
		.tkeep(tkeep_seg2),
		.mty(tx_lbus_seg2_mty_int)
	);
	keep2mty keep2mty_seg3_inst (
		.tkeep(tkeep_seg3),
		.mty(tx_lbus_seg3_mty_int)
	);

	assign tkeep_seg0 = s_axis_tkeep[63:48];
	assign tkeep_seg1 = s_axis_tkeep[47:32];
	assign tkeep_seg2 = s_axis_tkeep[31:16];
	assign tkeep_seg3 = s_axis_tkeep[15:0];

/* --------------------------------------
**  output logic (optional)
   ------------------------------------*/
	if (ENABLE_ILKN_PORTS) begin
		assign tx_lbus_seg0_chan_out = tx_lbus_seg0_chan_in;
		assign tx_lbus_seg1_chan_out = tx_lbus_seg1_chan_in;
		assign tx_lbus_seg2_chan_out = tx_lbus_seg2_chan_in;
		assign tx_lbus_seg3_chan_out = tx_lbus_seg3_chan_in;
		assign tx_lbus_seg0_bctlin_out = tx_lbus_seg0_bctlin_in;
		assign tx_lbus_seg1_bctlin_out = tx_lbus_seg1_bctlin_in;
		assign tx_lbus_seg2_bctlin_out = tx_lbus_seg2_bctlin_in;
		assign tx_lbus_seg3_bctlin_out = tx_lbus_seg3_bctlin_in;
	end
	else begin
		assign tx_lbus_seg0_chan_out = 11'b0;
		assign tx_lbus_seg1_chan_out = 11'b0;
		assign tx_lbus_seg2_chan_out = 11'b0;
		assign tx_lbus_seg3_chan_out = 11'b0;
		assign tx_lbus_seg0_bctlin_out = 1'b0;
		assign tx_lbus_seg1_bctlin_out = 1'b0;
		assign tx_lbus_seg2_bctlin_out = 1'b0;
		assign tx_lbus_seg3_bctlin_out = 1'b0;
	end

/* --------------------------------------
**  output logic (common)
   ------------------------------------*/
	assign tx_lbus_seg0_data = s_axis_tdata[511:384];
	assign tx_lbus_seg1_data = s_axis_tdata[383:256];
	assign tx_lbus_seg2_data = s_axis_tdata[255:128];
	assign tx_lbus_seg3_data = s_axis_tdata[127:0];
	assign tx_lbus_seg0_ena = tx_lbus_ready ? s_axis_tvalid & tkeep_seg0[15] : 1'b0;
	assign tx_lbus_seg1_ena = tx_lbus_ready ? s_axis_tvalid & tkeep_seg1[15] : 1'b0;
	assign tx_lbus_seg2_ena = tx_lbus_ready ? s_axis_tvalid & tkeep_seg2[15] : 1'b0;
	assign tx_lbus_seg3_ena = tx_lbus_ready ? s_axis_tvalid & tkeep_seg3[15] : 1'b0;
	assign tx_lbus_seg0_sop = s_axis_tvalid & ~in_packet;
	assign tx_lbus_seg1_sop = 1'b0;
	assign tx_lbus_seg2_sop = 1'b0;
	assign tx_lbus_seg3_sop = 1'b0;
	assign tx_lbus_seg0_eop = s_axis_tlast & tkeep_seg0[15] & ~tkeep_seg1[15];
	assign tx_lbus_seg1_eop = s_axis_tlast & tkeep_seg1[15] & ~tkeep_seg2[15];
	assign tx_lbus_seg2_eop = s_axis_tlast & tkeep_seg2[15] & ~tkeep_seg3[15];
	assign tx_lbus_seg3_eop = s_axis_tlast & tkeep_seg3[15];
	assign tx_lbus_seg0_mty = tx_lbus_seg0_mty_int;
	assign tx_lbus_seg1_mty = tx_lbus_seg1_mty_int;
	assign tx_lbus_seg2_mty = tx_lbus_seg2_mty_int;
	assign tx_lbus_seg3_mty = tx_lbus_seg3_mty_int;
	assign tx_lbus_seg0_err = (&(~tkeep_seg0 & (tkeep_seg0<<1))) | (~tkeep_seg0[0] & tkeep_seg1[15]);
	assign tx_lbus_seg1_err = (&(~tkeep_seg1 & (tkeep_seg1<<1))) | (~tkeep_seg1[0] & tkeep_seg2[15]);
	assign tx_lbus_seg2_err = (&(~tkeep_seg2 & (tkeep_seg2<<1))) | (~tkeep_seg2[0] & tkeep_seg3[15]);
	assign tx_lbus_seg3_err = &(~tkeep_seg3 & (tkeep_seg3<<1));

	assign s_axis_tready = tx_lbus_ready;
	assign tx_lbus_ready_out = tx_lbus_ready;

endmodule
