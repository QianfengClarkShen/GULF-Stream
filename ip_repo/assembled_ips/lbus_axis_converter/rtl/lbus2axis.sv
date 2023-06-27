`timescale 1ps/1ps

module lbus2axis # (
	parameter int ENABLE_ILKN_PORTS = 0
) (
	input logic clk,
	input logic rst,
//AXI4-Stream interface
	output logic [511:0] m_axis_tdata,
	output logic [63:0] m_axis_tkeep,
	output logic m_axis_tlast,
	output logic m_axis_tvalid,
//LBUS interface
	//optional for interlaken
	input logic [10:0] rx_lbus_seg0_chan_in,
	input logic [10:0] rx_lbus_seg1_chan_in,
	input logic [10:0] rx_lbus_seg2_chan_in,
	input logic [10:0] rx_lbus_seg3_chan_in,
	output logic [10:0] rx_lbus_seg0_chan_out,
	output logic [10:0] rx_lbus_seg1_chan_out,
	output logic [10:0] rx_lbus_seg2_chan_out,
	output logic [10:0] rx_lbus_seg3_chan_out,
	//common
	input logic [127:0] rx_lbus_seg0_data,
	input logic rx_lbus_seg0_ena,
	input logic rx_lbus_seg0_sop,
	input logic rx_lbus_seg0_eop,
	input logic [3:0] rx_lbus_seg0_mty,
	input logic rx_lbus_seg0_err,
	input logic [127:0] rx_lbus_seg1_data,
	input logic rx_lbus_seg1_ena,
	input logic rx_lbus_seg1_sop,
	input logic rx_lbus_seg1_eop,
	input logic [3:0] rx_lbus_seg1_mty,
	input logic rx_lbus_seg1_err,
	input logic [127:0] rx_lbus_seg2_data,
	input logic rx_lbus_seg2_ena,
	input logic rx_lbus_seg2_sop,
	input logic rx_lbus_seg2_eop,
	input logic [3:0] rx_lbus_seg2_mty,
	input logic rx_lbus_seg2_err,
	input logic [127:0] rx_lbus_seg3_data,
	input logic rx_lbus_seg3_ena,
	input logic rx_lbus_seg3_sop,
	input logic rx_lbus_seg3_eop,
	input logic [3:0] rx_lbus_seg3_mty,
	input logic rx_lbus_seg3_err,
	output logic rx_lbus_seg0_err_out,
	output logic rx_lbus_seg1_err_out,
	output logic rx_lbus_seg2_err_out,
	output logic rx_lbus_seg3_err_out
);
	localparam int ILKN_PORT_WIDTH = 11*ENABLE_ILKN_PORTS;
	genvar i;

/*----------------------------------------------
**      internal logics
  --------------------------------------------*/
	logic [135+ILKN_PORT_WIDTH:0] rx_lbus_logic[3:0];
	logic [1:0] sop_position_logic;
	logic output_switch;

/*----------------------------------------------
**      fifo input logics
  --------------------------------------------*/
	logic [7*(136+ILKN_PORT_WIDTH)-1:0] rx_lbus_fifo_tdata_in;
	logic [135+ILKN_PORT_WIDTH:0] rx_lbus_fifo_logic[2:0];

/*----------------------------------------------
**      fifo output logics
  --------------------------------------------*/
	logic [7*(136+ILKN_PORT_WIDTH)-1:0] rx_lbus_fifo_tdata_out;
	logic rx_lbus_fifo_tvalid_out;
	logic [127:0] rx_lbus_seg_data_fifo_out[7:0];
	logic rx_lbus_seg_ena_fifo_out[7:0];
	logic rx_lbus_seg_sop_fifo_out[7:0];
	logic rx_lbus_seg_eop_fifo_out[7:0];
	logic [3:0] rx_lbus_seg_mty_fifo_out[7:0];
	logic rx_lbus_seg_err_fifo_out[7:0];
	logic [10:0] rx_lbus_seg_chan_fifo_out[7:0];

/*----------------------------------------------
**      internal logicisters
  --------------------------------------------*/ 
	logic [136+ILKN_PORT_WIDTH-1:0] rx_lbus_reg[3:0];
	logic rx_lbus_fifo_valid_reg;
	logic [136+ILKN_PORT_WIDTH-1:0] rx_lbus_fifo_end_reg[2:0];
	logic [1:0] sop_position_reg;
	logic rx_lbus_fifo_paused;
	logic eop_reg;

/*----------------------------------------------
**      internal lbus fifo
  --------------------------------------------*/
	easy_fifo # (
		.DWIDTH(7*(136+ILKN_PORT_WIDTH)),
		.DEPTH(16)
	) rx_lbus_fifo_inst (
		.clk(clk),
		.rst(rst),
		.s_axis_tdata(rx_lbus_fifo_tdata_in),
		.s_axis_tvalid(rx_lbus_fifo_valid_reg && (sop_position_reg == 2'b0 || rx_lbus_seg0_ena || eop_reg)),
		.m_axis_tready(~(rx_lbus_fifo_tvalid_out & rx_lbus_seg_ena_fifo_out[4]) | rx_lbus_fifo_paused),
		.m_axis_tdata(rx_lbus_fifo_tdata_out),
		.m_axis_tvalid(rx_lbus_fifo_tvalid_out)
	);

	always_ff @(posedge clk) begin
		if (rst)
			rx_lbus_fifo_paused <= 1'b0;
		else if (rx_lbus_fifo_paused)
			rx_lbus_fifo_paused <= 1'b0;
		else if (rx_lbus_fifo_tvalid_out & rx_lbus_seg_ena_fifo_out[4])
			rx_lbus_fifo_paused <= 1'b1;
	end

	always_ff @(posedge clk) begin
		if (rst) begin
			eop_reg <= 1'b0;
			rx_lbus_reg[0] <= {{136+ILKN_PORT_WIDTH}{1'b0}};
			rx_lbus_reg[1] <= {{136+ILKN_PORT_WIDTH}{1'b0}};
			rx_lbus_reg[2] <= {{136+ILKN_PORT_WIDTH}{1'b0}};
			rx_lbus_reg[3] <= {{136+ILKN_PORT_WIDTH}{1'b0}};
		end
		else if (rx_lbus_seg0_ena || eop_reg || sop_position_reg == 2'b0) begin
			if (sop_position_logic == 2'd0) begin
				rx_lbus_reg[0] <= rx_lbus_logic[0];
				rx_lbus_reg[1] <= rx_lbus_seg0_eop ? {{136+ILKN_PORT_WIDTH}{1'b0}} : rx_lbus_logic[1];
				rx_lbus_reg[2] <= rx_lbus_seg1_eop ? {{136+ILKN_PORT_WIDTH}{1'b0}} : rx_lbus_logic[2];
				rx_lbus_reg[3] <= rx_lbus_seg2_eop ? {{136+ILKN_PORT_WIDTH}{1'b0}} : rx_lbus_logic[3];
				eop_reg <= rx_lbus_seg0_ena & (rx_lbus_seg0_eop | rx_lbus_seg1_eop | rx_lbus_seg2_eop | rx_lbus_seg3_eop);
				rx_lbus_fifo_valid_reg <= rx_lbus_seg0_ena;
			end
			else if (sop_position_logic == 2'd1) begin
				rx_lbus_reg[0] <= rx_lbus_logic[1];
				rx_lbus_reg[1] <= rx_lbus_seg1_eop ? {{136+ILKN_PORT_WIDTH}{1'b0}} : rx_lbus_logic[2];
				rx_lbus_reg[2] <= rx_lbus_seg2_eop ? {{136+ILKN_PORT_WIDTH}{1'b0}} : rx_lbus_logic[3];
				eop_reg <= rx_lbus_seg1_ena & (rx_lbus_seg1_eop | rx_lbus_seg2_eop | rx_lbus_seg3_eop);
				rx_lbus_fifo_valid_reg <= rx_lbus_seg1_ena;
			end
			else if (sop_position_logic == 2'd2) begin
				rx_lbus_reg[0] <= rx_lbus_logic[2];
				rx_lbus_reg[1] <= rx_lbus_seg2_eop ? {{136+ILKN_PORT_WIDTH}{1'b0}} : rx_lbus_logic[3];
				eop_reg <= rx_lbus_seg2_ena & (rx_lbus_seg2_eop | rx_lbus_seg3_eop);
				rx_lbus_fifo_valid_reg <= rx_lbus_seg2_ena;
			end
			else if (sop_position_logic == 2'd3) begin
				rx_lbus_reg[0] <= rx_lbus_logic[3];
				eop_reg <= rx_lbus_seg3_ena & rx_lbus_seg3_eop;
				rx_lbus_fifo_valid_reg <= rx_lbus_seg3_ena;
			end

			if (sop_position_reg == 2'd0 && rx_lbus_seg3_ena && (rx_lbus_seg1_sop | rx_lbus_seg2_sop | rx_lbus_seg3_sop)) begin
				rx_lbus_fifo_end_reg[0] <= rx_lbus_logic[0];
				rx_lbus_fifo_end_reg[1] <= rx_lbus_seg1_sop ? {{136+ILKN_PORT_WIDTH}{1'b0}} : rx_lbus_logic[1];
				rx_lbus_fifo_end_reg[2] <= (rx_lbus_seg1_sop | rx_lbus_seg2_sop) ? {{136+ILKN_PORT_WIDTH}{1'b0}} : rx_lbus_logic[2];
			end
			else if (sop_position_reg == 2'd1 && rx_lbus_seg3_ena && (rx_lbus_seg2_sop | rx_lbus_seg3_sop)) begin
				rx_lbus_fifo_end_reg[0] <= rx_lbus_logic[1];
				rx_lbus_fifo_end_reg[1] <= rx_lbus_seg2_sop ? {{136+ILKN_PORT_WIDTH}{1'b0}} : rx_lbus_logic[2];
			end
			else if (sop_position_reg == 2'd2 && rx_lbus_seg3_ena && rx_lbus_seg3_sop) begin
				rx_lbus_fifo_end_reg[0] <= rx_lbus_logic[2];
			end
			else begin
				rx_lbus_fifo_end_reg[0] <= {{136+ILKN_PORT_WIDTH}{1'b0}};
				rx_lbus_fifo_end_reg[1] <= {{136+ILKN_PORT_WIDTH}{1'b0}};
				rx_lbus_fifo_end_reg[2] <= {{136+ILKN_PORT_WIDTH}{1'b0}};
			end
		end
	end
	always_ff @(posedge clk) begin
		if (rst)
			sop_position_reg <= 2'd0;
		else begin
			sop_position_reg <= sop_position_logic;
		end
	end
	always_comb begin
		if (rx_lbus_seg0_ena & rx_lbus_seg0_sop)
			sop_position_logic = 2'd0;
		else if (rx_lbus_seg1_ena & rx_lbus_seg1_sop)
			sop_position_logic = 2'd1;
		else if (rx_lbus_seg2_ena & rx_lbus_seg2_sop)
			sop_position_logic = 2'd2;
		else if (rx_lbus_seg3_ena & rx_lbus_seg3_sop)
			sop_position_logic = 2'd3;
		else
			sop_position_logic = sop_position_reg;
	end

	always_comb begin
		case (sop_position_reg)
			2'd0: rx_lbus_fifo_tdata_in = {rx_lbus_reg[0],rx_lbus_reg[1],rx_lbus_reg[2],rx_lbus_reg[3],rx_lbus_fifo_end_reg[0],rx_lbus_fifo_end_reg[1],rx_lbus_fifo_end_reg[2]};
			2'd1: rx_lbus_fifo_tdata_in = {rx_lbus_reg[0],rx_lbus_reg[1],rx_lbus_reg[2],rx_lbus_fifo_logic[0],rx_lbus_fifo_end_reg[0],rx_lbus_fifo_end_reg[1],rx_lbus_fifo_end_reg[2]};
			2'd2: rx_lbus_fifo_tdata_in = {rx_lbus_reg[0],rx_lbus_reg[1],rx_lbus_fifo_logic[0],rx_lbus_fifo_logic[1],rx_lbus_fifo_end_reg[0],rx_lbus_fifo_end_reg[1],rx_lbus_fifo_end_reg[2]};
			2'd3: rx_lbus_fifo_tdata_in = {rx_lbus_reg[0],rx_lbus_fifo_logic[0],rx_lbus_fifo_logic[1],rx_lbus_fifo_logic[2],rx_lbus_fifo_end_reg[0],rx_lbus_fifo_end_reg[1],rx_lbus_fifo_end_reg[2]};
		endcase
	end

	if (ENABLE_ILKN_PORTS) begin
		assign rx_lbus_logic[0] = {rx_lbus_seg0_chan_in,rx_lbus_seg0_data,rx_lbus_seg0_ena ,rx_lbus_seg0_sop,rx_lbus_seg0_eop,rx_lbus_seg0_mty,rx_lbus_seg0_err&rx_lbus_seg0_ena};
		assign rx_lbus_logic[1] = {rx_lbus_seg1_chan_in,rx_lbus_seg1_data,rx_lbus_seg1_ena,rx_lbus_seg1_sop,rx_lbus_seg1_eop,rx_lbus_seg1_mty,rx_lbus_seg1_err&rx_lbus_seg1_ena};
		assign rx_lbus_logic[2] = {rx_lbus_seg2_chan_in,rx_lbus_seg2_data,rx_lbus_seg2_ena,rx_lbus_seg2_sop,rx_lbus_seg2_eop,rx_lbus_seg2_mty,rx_lbus_seg2_err&rx_lbus_seg2_ena};
		assign rx_lbus_logic[3] = {rx_lbus_seg3_chan_in,rx_lbus_seg3_data,rx_lbus_seg3_ena,rx_lbus_seg3_sop,rx_lbus_seg3_eop,rx_lbus_seg3_mty,rx_lbus_seg3_err&rx_lbus_seg3_ena};
		assign rx_lbus_fifo_logic[0] = {rx_lbus_seg0_chan_in,rx_lbus_seg0_data,rx_lbus_seg0_ena&~eop_reg,rx_lbus_seg0_sop,rx_lbus_seg0_eop,rx_lbus_seg0_mty,rx_lbus_seg0_err&rx_lbus_seg0_ena&~eop_reg};
		assign rx_lbus_fifo_logic[1] = {rx_lbus_seg1_chan_in,rx_lbus_seg1_data,rx_lbus_seg1_ena&~eop_reg&~rx_lbus_seg0_eop,rx_lbus_seg1_sop,rx_lbus_seg1_eop,rx_lbus_seg1_mty,rx_lbus_seg1_err&rx_lbus_seg1_ena&~eop_reg};
		assign rx_lbus_fifo_logic[2] = {rx_lbus_seg2_chan_in,rx_lbus_seg2_data,rx_lbus_seg2_ena&~eop_reg&~rx_lbus_seg0_eop&~rx_lbus_seg1_eop,rx_lbus_seg2_sop,rx_lbus_seg2_eop,rx_lbus_seg2_mty,rx_lbus_seg2_err&rx_lbus_seg2_ena&~eop_reg};
	end
	else begin
		assign rx_lbus_logic[0] = {rx_lbus_seg0_data,rx_lbus_seg0_ena,rx_lbus_seg0_sop,rx_lbus_seg0_eop,rx_lbus_seg0_mty,rx_lbus_seg0_err&rx_lbus_seg0_ena};
		assign rx_lbus_logic[1] = {rx_lbus_seg1_data,rx_lbus_seg1_ena,rx_lbus_seg1_sop,rx_lbus_seg1_eop,rx_lbus_seg1_mty,rx_lbus_seg1_err&rx_lbus_seg1_ena};
		assign rx_lbus_logic[2] = {rx_lbus_seg2_data,rx_lbus_seg2_ena,rx_lbus_seg2_sop,rx_lbus_seg2_eop,rx_lbus_seg2_mty,rx_lbus_seg2_err&rx_lbus_seg2_ena};
		assign rx_lbus_logic[3] = {rx_lbus_seg3_data,rx_lbus_seg3_ena,rx_lbus_seg3_sop,rx_lbus_seg3_eop,rx_lbus_seg3_mty,rx_lbus_seg3_err&rx_lbus_seg3_ena};
		assign rx_lbus_fifo_logic[0] = {rx_lbus_seg0_data,rx_lbus_seg0_ena&~eop_reg,rx_lbus_seg0_sop,rx_lbus_seg0_eop,rx_lbus_seg0_mty,rx_lbus_seg0_err&rx_lbus_seg0_ena&~eop_reg};
		assign rx_lbus_fifo_logic[1] = {rx_lbus_seg1_data,rx_lbus_seg1_ena&~eop_reg&~rx_lbus_seg0_eop,rx_lbus_seg1_sop,rx_lbus_seg1_eop,rx_lbus_seg1_mty,rx_lbus_seg1_err&rx_lbus_seg0_ena&~eop_reg};
		assign rx_lbus_fifo_logic[2] = {rx_lbus_seg2_data,rx_lbus_seg2_ena&~eop_reg&~rx_lbus_seg0_eop&~rx_lbus_seg1_eop,rx_lbus_seg2_sop,rx_lbus_seg2_eop,rx_lbus_seg2_mty,rx_lbus_seg2_err&rx_lbus_seg0_ena&~eop_reg};
	end

	for (i = 0; i < 7; i = i + 1) begin
		assign rx_lbus_seg_data_fifo_out[i] = rx_lbus_fifo_tdata_out[135+(6-i)*(136+ILKN_PORT_WIDTH):8+(6-i)*(136+ILKN_PORT_WIDTH)];
		assign rx_lbus_seg_ena_fifo_out[i] = rx_lbus_fifo_tdata_out[7+(6-i)*(136+ILKN_PORT_WIDTH)];
		assign rx_lbus_seg_sop_fifo_out[i] = rx_lbus_fifo_tdata_out[6+(6-i)*(136+ILKN_PORT_WIDTH)];
		assign rx_lbus_seg_eop_fifo_out[i] = rx_lbus_fifo_tdata_out[5+(6-i)*(136+ILKN_PORT_WIDTH)];
		assign rx_lbus_seg_mty_fifo_out[i] = rx_lbus_fifo_tdata_out[4+(6-i)*(136+ILKN_PORT_WIDTH):1+(6-i)*(136+ILKN_PORT_WIDTH)];
		assign rx_lbus_seg_err_fifo_out[i] = rx_lbus_fifo_tdata_out[(6-i)*(136+ILKN_PORT_WIDTH)];
		if (ENABLE_ILKN_PORTS) begin
			assign rx_lbus_seg_chan_fifo_out[i] = rx_lbus_fifo_tdata_out[(7-i)*(136+ILKN_PORT_WIDTH)-1:(7-i)*(136+ILKN_PORT_WIDTH)-ILKN_PORT_WIDTH];
		end
	end

	assign rx_lbus_seg_data_fifo_out[7] = 128'b0;
	assign rx_lbus_seg_ena_fifo_out[7] = 1'b0;
	assign rx_lbus_seg_sop_fifo_out[7] = 1'b0;
	assign rx_lbus_seg_eop_fifo_out[7] = 1'b0;
	assign rx_lbus_seg_mty_fifo_out[7] = 4'b0;
	assign rx_lbus_seg_err_fifo_out[7] = 1'b0;
	if (ENABLE_ILKN_PORTS) begin
		assign rx_lbus_seg_chan_fifo_out[7] = 11'b0;
	end

	assign output_switch = rx_lbus_seg_ena_fifo_out[4] & ~rx_lbus_fifo_paused;
/*----------------------------------------------
**      output logics
  --------------------------------------------*/
	genvar j;
	assign m_axis_tdata = output_switch ? {rx_lbus_seg_data_fifo_out[4],rx_lbus_seg_data_fifo_out[5],rx_lbus_seg_data_fifo_out[6],rx_lbus_seg_data_fifo_out[7]} : {rx_lbus_seg_data_fifo_out[0],rx_lbus_seg_data_fifo_out[1],rx_lbus_seg_data_fifo_out[2],rx_lbus_seg_data_fifo_out[3]};
	for (i = 0; i < 4; i = i + 1) begin
		for (j = 0; j < 16; j = j + 1) begin
			assign m_axis_tkeep[(3-i)*16+j] = output_switch ? (rx_lbus_seg_ena_fifo_out[i+4] && rx_lbus_seg_mty_fifo_out[i+4] < (j+1)) : (rx_lbus_seg_ena_fifo_out[i] && rx_lbus_seg_mty_fifo_out[i] < (j+1));
		end
	end
	assign m_axis_tlast = output_switch ? (rx_lbus_seg_eop_fifo_out[4] | rx_lbus_seg_eop_fifo_out[5] | rx_lbus_seg_eop_fifo_out[6]) : (rx_lbus_seg_eop_fifo_out[0] | rx_lbus_seg_eop_fifo_out[1] | rx_lbus_seg_eop_fifo_out[2] | rx_lbus_seg_eop_fifo_out[3]);
	assign m_axis_tvalid = rx_lbus_fifo_tvalid_out;

	assign rx_lbus_seg0_err_out = output_switch ? rx_lbus_seg_err_fifo_out[4] : rx_lbus_seg_err_fifo_out[0];
	assign rx_lbus_seg1_err_out = output_switch ? rx_lbus_seg_err_fifo_out[5] : rx_lbus_seg_err_fifo_out[1];
	assign rx_lbus_seg2_err_out = output_switch ? rx_lbus_seg_err_fifo_out[6] : rx_lbus_seg_err_fifo_out[2];
	assign rx_lbus_seg3_err_out = output_switch ? rx_lbus_seg_err_fifo_out[7] : rx_lbus_seg_err_fifo_out[3];

	if (ENABLE_ILKN_PORTS) begin
		assign rx_lbus_seg0_chan_out = output_switch ? rx_lbus_seg_chan_fifo_out[4] : rx_lbus_seg_chan_fifo_out[0];
		assign rx_lbus_seg1_chan_out = output_switch ? rx_lbus_seg_chan_fifo_out[5] : rx_lbus_seg_chan_fifo_out[1];
		assign rx_lbus_seg2_chan_out = output_switch ? rx_lbus_seg_chan_fifo_out[6] : rx_lbus_seg_chan_fifo_out[2];
		assign rx_lbus_seg3_chan_out = output_switch ? rx_lbus_seg_chan_fifo_out[7] : rx_lbus_seg_chan_fifo_out[3];
	end
	else begin
		assign rx_lbus_seg0_chan_out = 11'b0;
		assign rx_lbus_seg1_chan_out = 11'b0;
		assign rx_lbus_seg2_chan_out = 11'b0;
		assign rx_lbus_seg3_chan_out = 11'b0;
	end
endmodule
