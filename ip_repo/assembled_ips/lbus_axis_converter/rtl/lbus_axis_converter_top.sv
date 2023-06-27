`timescale 1ps/1ps

module lbus_axis_converter_top # (
	parameter ENDIANNESS = 1,
	parameter ENABLE_ILKN_PORTS = 0,
	parameter TX_OUTPUT_REG = 0,
	parameter RX_INPUT_REG = 0
) (
	input logic tx_clk,
	input logic rx_clk,
	input logic tx_rst,
	input logic rx_rst,
//LBUS to AXI4-Stream
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
	output logic rx_lbus_seg3_err_out,
//AXI4-Stream to LBUS
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
**  internal logics connected to axis2lbus and lbus2axis function blocks
   ------------------------------------*/
	//optional
	logic [10:0] tx_lbus_seg0_chan_out_int;
	logic [10:0] tx_lbus_seg1_chan_out_int;
	logic [10:0] tx_lbus_seg2_chan_out_int;
	logic [10:0] tx_lbus_seg3_chan_out_int;
	logic tx_lbus_seg0_bctlin_out_int;
	logic tx_lbus_seg1_bctlin_out_int;
	logic tx_lbus_seg2_bctlin_out_int;
	logic tx_lbus_seg3_bctlin_out_int;
	//tx common
	logic [127:0] tx_lbus_seg0_data_int;
	logic tx_lbus_seg0_ena_int;
	logic tx_lbus_seg0_sop_int;
	logic tx_lbus_seg0_eop_int;
	logic [3:0] tx_lbus_seg0_mty_int;
	logic tx_lbus_seg0_err_int;
	logic [127:0] tx_lbus_seg1_data_int;
	logic tx_lbus_seg1_ena_int;
	logic tx_lbus_seg1_sop_int;
	logic tx_lbus_seg1_eop_int;
	logic [3:0] tx_lbus_seg1_mty_int;
	logic tx_lbus_seg1_err_int;
	logic [127:0] tx_lbus_seg2_data_int;
	logic tx_lbus_seg2_ena_int;
	logic tx_lbus_seg2_sop_int;
	logic tx_lbus_seg2_eop_int;
	logic [3:0] tx_lbus_seg2_mty_int;
	logic tx_lbus_seg2_err_int;
	logic [127:0] tx_lbus_seg3_data_int;
	logic tx_lbus_seg3_ena_int;
	logic tx_lbus_seg3_sop_int;
	logic tx_lbus_seg3_eop_int;
	logic [3:0] tx_lbus_seg3_mty_int;
	logic tx_lbus_seg3_err_int;

	//rx optional
	logic [10:0] rx_lbus_seg0_chan_in_int;
	logic [10:0] rx_lbus_seg1_chan_in_int;
	logic [10:0] rx_lbus_seg2_chan_in_int;
	logic [10:0] rx_lbus_seg3_chan_in_int;
	logic [127:0] rx_lbus_seg0_data_int;
	//rx common
	logic rx_lbus_seg0_ena_int;
	logic rx_lbus_seg0_sop_int;
	logic rx_lbus_seg0_eop_int;
	logic [3:0] rx_lbus_seg0_mty_int;
	logic rx_lbus_seg0_err_int;
	logic [127:0] rx_lbus_seg1_data_int;
	logic rx_lbus_seg1_ena_int;
	logic rx_lbus_seg1_sop_int;
	logic rx_lbus_seg1_eop_int;
	logic [3:0] rx_lbus_seg1_mty_int;
	logic rx_lbus_seg1_err_int;
	logic [127:0] rx_lbus_seg2_data_int;
	logic rx_lbus_seg2_ena_int;
	logic rx_lbus_seg2_sop_int;
	logic rx_lbus_seg2_eop_int;
	logic [3:0] rx_lbus_seg2_mty_int;
	logic rx_lbus_seg2_err_int;
	logic [127:0] rx_lbus_seg3_data_int;
	logic rx_lbus_seg3_ena_int;
	logic rx_lbus_seg3_sop_int;
	logic rx_lbus_seg3_eop_int;
	logic [3:0] rx_lbus_seg3_mty_int;
	logic rx_lbus_seg3_err_int;

/* --------------------------------------
**  input and output regs (optional)
   ------------------------------------*/
	logic [10:0] tx_lbus_seg0_chan_out_reg;
	logic [10:0] tx_lbus_seg1_chan_out_reg;
	logic [10:0] tx_lbus_seg2_chan_out_reg;
	logic [10:0] tx_lbus_seg3_chan_out_reg;
	logic tx_lbus_seg0_bctlin_out_reg;
	logic tx_lbus_seg1_bctlin_out_reg;
	logic tx_lbus_seg2_bctlin_out_reg;
	logic tx_lbus_seg3_bctlin_out_reg;
	logic [127:0] tx_lbus_seg0_data_reg;
	logic tx_lbus_seg0_ena_reg;
	logic tx_lbus_seg0_sop_reg;
	logic tx_lbus_seg0_eop_reg;
	logic [3:0] tx_lbus_seg0_mty_reg;
	logic tx_lbus_seg0_err_reg;
	logic [127:0] tx_lbus_seg1_data_reg;
	logic tx_lbus_seg1_ena_reg;
	logic tx_lbus_seg1_sop_reg;
	logic tx_lbus_seg1_eop_reg;
	logic [3:0] tx_lbus_seg1_mty_reg;
	logic tx_lbus_seg1_err_reg;
	logic [127:0] tx_lbus_seg2_data_reg;
	logic tx_lbus_seg2_ena_reg;
	logic tx_lbus_seg2_sop_reg;
	logic tx_lbus_seg2_eop_reg;
	logic [3:0] tx_lbus_seg2_mty_reg;
	logic tx_lbus_seg2_err_reg;
	logic [127:0] tx_lbus_seg3_data_reg;
	logic tx_lbus_seg3_ena_reg;
	logic tx_lbus_seg3_sop_reg;
	logic tx_lbus_seg3_eop_reg;
	logic [3:0] tx_lbus_seg3_mty_reg;
	logic tx_lbus_seg3_err_reg;

	logic [10:0] rx_lbus_seg0_chan_in_reg;
	logic [10:0] rx_lbus_seg1_chan_in_reg;
	logic [10:0] rx_lbus_seg2_chan_in_reg;
	logic [10:0] rx_lbus_seg3_chan_in_reg;
	logic [127:0] rx_lbus_seg0_data_reg;
	logic rx_lbus_seg0_ena_reg;
	logic rx_lbus_seg0_sop_reg;
	logic rx_lbus_seg0_eop_reg;
	logic [3:0] rx_lbus_seg0_mty_reg;
	logic rx_lbus_seg0_err_reg;
	logic [127:0] rx_lbus_seg1_data_reg;
	logic rx_lbus_seg1_ena_reg;
	logic rx_lbus_seg1_sop_reg;
	logic rx_lbus_seg1_eop_reg;
	logic [3:0] rx_lbus_seg1_mty_reg;
	logic rx_lbus_seg1_err_reg;
	logic [127:0] rx_lbus_seg2_data_reg;
	logic rx_lbus_seg2_ena_reg;
	logic rx_lbus_seg2_sop_reg;
	logic rx_lbus_seg2_eop_reg;
	logic [3:0] rx_lbus_seg2_mty_reg;
	logic rx_lbus_seg2_err_reg;
	logic [127:0] rx_lbus_seg3_data_reg;
	logic rx_lbus_seg3_ena_reg;
	logic rx_lbus_seg3_sop_reg;
	logic rx_lbus_seg3_eop_reg;
	logic [3:0] rx_lbus_seg3_mty_reg;
	logic rx_lbus_seg3_err_reg;

	if (TX_OUTPUT_REG) begin
		if (ENABLE_ILKN_PORTS) begin
			always_ff @(posedge tx_clk) begin
				tx_lbus_seg0_chan_out_reg <= tx_lbus_seg0_chan_out_int;
				tx_lbus_seg1_chan_out_reg <= tx_lbus_seg1_chan_out_int;
				tx_lbus_seg2_chan_out_reg <= tx_lbus_seg2_chan_out_int;
				tx_lbus_seg3_chan_out_reg <= tx_lbus_seg3_chan_out_int;
				tx_lbus_seg0_bctlin_out_reg <= tx_lbus_seg0_bctlin_out_int;
				tx_lbus_seg1_bctlin_out_reg <= tx_lbus_seg1_bctlin_out_int;
				tx_lbus_seg2_bctlin_out_reg <= tx_lbus_seg2_bctlin_out_int;
				tx_lbus_seg3_bctlin_out_reg <= tx_lbus_seg3_bctlin_out_int;
			end
			assign tx_lbus_seg0_chan_out = tx_lbus_seg0_chan_out_reg;
			assign tx_lbus_seg1_chan_out = tx_lbus_seg1_chan_out_reg;
			assign tx_lbus_seg2_chan_out = tx_lbus_seg2_chan_out_reg;
			assign tx_lbus_seg3_chan_out = tx_lbus_seg3_chan_out_reg;
			assign tx_lbus_seg0_bctlin_out = tx_lbus_seg0_bctlin_out_reg;
			assign tx_lbus_seg1_bctlin_out = tx_lbus_seg1_bctlin_out_reg;
			assign tx_lbus_seg2_bctlin_out = tx_lbus_seg2_bctlin_out_reg;
			assign tx_lbus_seg3_bctlin_out = tx_lbus_seg3_bctlin_out_reg;
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
		always_ff @(posedge tx_clk) begin
			tx_lbus_seg0_data_reg <= tx_lbus_seg0_data_int;
			tx_lbus_seg0_ena_reg <= tx_lbus_seg0_ena_int;
			tx_lbus_seg0_sop_reg <= tx_lbus_seg0_sop_int;
			tx_lbus_seg0_eop_reg <= tx_lbus_seg0_eop_int;
			tx_lbus_seg0_mty_reg <= tx_lbus_seg0_mty_int;
			tx_lbus_seg0_err_reg <= tx_lbus_seg0_err_int;
			tx_lbus_seg1_data_reg <= tx_lbus_seg1_data_int;
			tx_lbus_seg1_ena_reg <= tx_lbus_seg1_ena_int;
			tx_lbus_seg1_sop_reg <= tx_lbus_seg1_sop_int;
			tx_lbus_seg1_eop_reg <= tx_lbus_seg1_eop_int;
			tx_lbus_seg1_mty_reg <= tx_lbus_seg1_mty_int;
			tx_lbus_seg1_err_reg <= tx_lbus_seg1_err_int;
			tx_lbus_seg2_data_reg <= tx_lbus_seg2_data_int;
			tx_lbus_seg2_ena_reg <= tx_lbus_seg2_ena_int;
			tx_lbus_seg2_sop_reg <= tx_lbus_seg2_sop_int;
			tx_lbus_seg2_eop_reg <= tx_lbus_seg2_eop_int;
			tx_lbus_seg2_mty_reg <= tx_lbus_seg2_mty_int;
			tx_lbus_seg2_err_reg <= tx_lbus_seg2_err_int;
			tx_lbus_seg3_data_reg <= tx_lbus_seg3_data_int;
			tx_lbus_seg3_ena_reg <= tx_lbus_seg3_ena_int;
			tx_lbus_seg3_sop_reg <= tx_lbus_seg3_sop_int;
			tx_lbus_seg3_eop_reg <= tx_lbus_seg3_eop_int;
			tx_lbus_seg3_mty_reg <= tx_lbus_seg3_mty_int;
			tx_lbus_seg3_err_reg <= tx_lbus_seg3_err_int;
		end
		assign tx_lbus_seg0_data = tx_lbus_seg0_data_reg; 
		assign tx_lbus_seg0_ena = tx_lbus_seg0_ena_reg; 
		assign tx_lbus_seg0_sop = tx_lbus_seg0_sop_reg; 
		assign tx_lbus_seg0_eop = tx_lbus_seg0_eop_reg; 
		assign tx_lbus_seg0_mty = tx_lbus_seg0_mty_reg; 
		assign tx_lbus_seg0_err = tx_lbus_seg0_err_reg; 
		assign tx_lbus_seg1_data = tx_lbus_seg1_data_reg; 
		assign tx_lbus_seg1_ena = tx_lbus_seg1_ena_reg; 
		assign tx_lbus_seg1_sop = tx_lbus_seg1_sop_reg; 
		assign tx_lbus_seg1_eop = tx_lbus_seg1_eop_reg; 
		assign tx_lbus_seg1_mty = tx_lbus_seg1_mty_reg; 
		assign tx_lbus_seg1_err = tx_lbus_seg1_err_reg; 
		assign tx_lbus_seg2_data = tx_lbus_seg2_data_reg; 
		assign tx_lbus_seg2_ena = tx_lbus_seg2_ena_reg; 
		assign tx_lbus_seg2_sop = tx_lbus_seg2_sop_reg; 
		assign tx_lbus_seg2_eop = tx_lbus_seg2_eop_reg; 
		assign tx_lbus_seg2_mty = tx_lbus_seg2_mty_reg; 
		assign tx_lbus_seg2_err = tx_lbus_seg2_err_reg; 
		assign tx_lbus_seg3_data = tx_lbus_seg3_data_reg; 
		assign tx_lbus_seg3_ena = tx_lbus_seg3_ena_reg; 
		assign tx_lbus_seg3_sop = tx_lbus_seg3_sop_reg; 
		assign tx_lbus_seg3_eop = tx_lbus_seg3_eop_reg; 
		assign tx_lbus_seg3_mty = tx_lbus_seg3_mty_reg; 
		assign tx_lbus_seg3_err = tx_lbus_seg3_err_reg;
	end
	else begin
		if (ENABLE_ILKN_PORTS) begin
			assign tx_lbus_seg0_chan_out = tx_lbus_seg0_chan_out_int;
			assign tx_lbus_seg1_chan_out = tx_lbus_seg1_chan_out_int;
			assign tx_lbus_seg2_chan_out = tx_lbus_seg2_chan_out_int;
			assign tx_lbus_seg3_chan_out = tx_lbus_seg3_chan_out_int;
			assign tx_lbus_seg0_bctlin_out = tx_lbus_seg0_bctlin_out_int;
			assign tx_lbus_seg1_bctlin_out = tx_lbus_seg1_bctlin_out_int;
			assign tx_lbus_seg2_bctlin_out = tx_lbus_seg2_bctlin_out_int;
			assign tx_lbus_seg3_bctlin_out = tx_lbus_seg3_bctlin_out_int;
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
		assign tx_lbus_seg0_data = tx_lbus_seg0_data_int;
		assign tx_lbus_seg0_ena = tx_lbus_seg0_ena_int;
		assign tx_lbus_seg0_sop = tx_lbus_seg0_sop_int;
		assign tx_lbus_seg0_eop = tx_lbus_seg0_eop_int;
		assign tx_lbus_seg0_mty = tx_lbus_seg0_mty_int;
		assign tx_lbus_seg0_err = tx_lbus_seg0_err_int;
		assign tx_lbus_seg1_data = tx_lbus_seg1_data_int;
		assign tx_lbus_seg1_ena = tx_lbus_seg1_ena_int;
		assign tx_lbus_seg1_sop = tx_lbus_seg1_sop_int;
		assign tx_lbus_seg1_eop = tx_lbus_seg1_eop_int;
		assign tx_lbus_seg1_mty = tx_lbus_seg1_mty_int;
		assign tx_lbus_seg1_err = tx_lbus_seg1_err_int;
		assign tx_lbus_seg2_data = tx_lbus_seg2_data_int;
		assign tx_lbus_seg2_ena = tx_lbus_seg2_ena_int;
		assign tx_lbus_seg2_sop = tx_lbus_seg2_sop_int;
		assign tx_lbus_seg2_eop = tx_lbus_seg2_eop_int;
		assign tx_lbus_seg2_mty = tx_lbus_seg2_mty_int;
		assign tx_lbus_seg2_err = tx_lbus_seg2_err_int;
		assign tx_lbus_seg3_data = tx_lbus_seg3_data_int;
		assign tx_lbus_seg3_ena = tx_lbus_seg3_ena_int;
		assign tx_lbus_seg3_sop = tx_lbus_seg3_sop_int;
		assign tx_lbus_seg3_eop = tx_lbus_seg3_eop_int;
		assign tx_lbus_seg3_mty = tx_lbus_seg3_mty_int;
		assign tx_lbus_seg3_err = tx_lbus_seg3_err_int;
	end

	if (RX_INPUT_REG) begin
		if (ENABLE_ILKN_PORTS) begin
			always_ff @(posedge rx_clk) begin
				rx_lbus_seg0_chan_in_reg <= rx_lbus_seg0_chan_in;
				rx_lbus_seg1_chan_in_reg <= rx_lbus_seg1_chan_in;
				rx_lbus_seg2_chan_in_reg <= rx_lbus_seg2_chan_in;
				rx_lbus_seg3_chan_in_reg <= rx_lbus_seg3_chan_in;
			end
			assign rx_lbus_seg0_chan_in_int = rx_lbus_seg0_chan_in_reg;
			assign rx_lbus_seg1_chan_in_int = rx_lbus_seg1_chan_in_reg;
			assign rx_lbus_seg2_chan_in_int = rx_lbus_seg2_chan_in_reg;
			assign rx_lbus_seg3_chan_in_int = rx_lbus_seg3_chan_in_reg;
		end
		else begin
			assign rx_lbus_seg0_chan_in_int = 11'b0;
			assign rx_lbus_seg1_chan_in_int = 11'b0;
			assign rx_lbus_seg2_chan_in_int = 11'b0;
			assign rx_lbus_seg3_chan_in_int = 11'b0;
		end
		always_ff @(posedge rx_clk) begin
			rx_lbus_seg0_data_reg <= rx_lbus_seg0_data;
			rx_lbus_seg0_ena_reg <= rx_lbus_seg0_ena;
			rx_lbus_seg0_sop_reg <= rx_lbus_seg0_sop;
			rx_lbus_seg0_eop_reg <= rx_lbus_seg0_eop;
			rx_lbus_seg0_mty_reg <= rx_lbus_seg0_mty;
			rx_lbus_seg0_err_reg <= rx_lbus_seg0_err;
			rx_lbus_seg1_data_reg <= rx_lbus_seg1_data;
			rx_lbus_seg1_ena_reg <= rx_lbus_seg1_ena;
			rx_lbus_seg1_sop_reg <= rx_lbus_seg1_sop;
			rx_lbus_seg1_eop_reg <= rx_lbus_seg1_eop;
			rx_lbus_seg1_mty_reg <= rx_lbus_seg1_mty;
			rx_lbus_seg1_err_reg <= rx_lbus_seg1_err;
			rx_lbus_seg2_data_reg <= rx_lbus_seg2_data;
			rx_lbus_seg2_ena_reg <= rx_lbus_seg2_ena;
			rx_lbus_seg2_sop_reg <= rx_lbus_seg2_sop;
			rx_lbus_seg2_eop_reg <= rx_lbus_seg2_eop;
			rx_lbus_seg2_mty_reg <= rx_lbus_seg2_mty;
			rx_lbus_seg2_err_reg <= rx_lbus_seg2_err;
			rx_lbus_seg3_data_reg <= rx_lbus_seg3_data;
			rx_lbus_seg3_ena_reg <= rx_lbus_seg3_ena;
			rx_lbus_seg3_sop_reg <= rx_lbus_seg3_sop;
			rx_lbus_seg3_eop_reg <= rx_lbus_seg3_eop;
			rx_lbus_seg3_mty_reg <= rx_lbus_seg3_mty;
			rx_lbus_seg3_err_reg <= rx_lbus_seg3_err;
		end
		assign rx_lbus_seg0_data_int = rx_lbus_seg0_data_reg;
		assign rx_lbus_seg0_ena_int = rx_lbus_seg0_ena_reg;
		assign rx_lbus_seg0_sop_int = rx_lbus_seg0_sop_reg;
		assign rx_lbus_seg0_eop_int = rx_lbus_seg0_eop_reg;
		assign rx_lbus_seg0_mty_int = rx_lbus_seg0_mty_reg;
		assign rx_lbus_seg0_err_int = rx_lbus_seg0_err_reg;
		assign rx_lbus_seg1_data_int = rx_lbus_seg1_data_reg;
		assign rx_lbus_seg1_ena_int = rx_lbus_seg1_ena_reg;
		assign rx_lbus_seg1_sop_int = rx_lbus_seg1_sop_reg;
		assign rx_lbus_seg1_eop_int = rx_lbus_seg1_eop_reg;
		assign rx_lbus_seg1_mty_int = rx_lbus_seg1_mty_reg;
		assign rx_lbus_seg1_err_int = rx_lbus_seg1_err_reg;
		assign rx_lbus_seg2_data_int = rx_lbus_seg2_data_reg;
		assign rx_lbus_seg2_ena_int = rx_lbus_seg2_ena_reg;
		assign rx_lbus_seg2_sop_int = rx_lbus_seg2_sop_reg;
		assign rx_lbus_seg2_eop_int = rx_lbus_seg2_eop_reg;
		assign rx_lbus_seg2_mty_int = rx_lbus_seg2_mty_reg;
		assign rx_lbus_seg2_err_int = rx_lbus_seg2_err_reg;
		assign rx_lbus_seg3_data_int = rx_lbus_seg3_data_reg;
		assign rx_lbus_seg3_ena_int = rx_lbus_seg3_ena_reg;
		assign rx_lbus_seg3_sop_int = rx_lbus_seg3_sop_reg;
		assign rx_lbus_seg3_eop_int = rx_lbus_seg3_eop_reg;
		assign rx_lbus_seg3_mty_int = rx_lbus_seg3_mty_reg;
		assign rx_lbus_seg3_err_int = rx_lbus_seg3_err_reg;
	end
	else begin
		if (ENABLE_ILKN_PORTS) begin
            assign rx_lbus_seg0_chan_in_int = rx_lbus_seg0_chan_in;
            assign rx_lbus_seg1_chan_in_int = rx_lbus_seg1_chan_in;
            assign rx_lbus_seg2_chan_in_int = rx_lbus_seg2_chan_in;
            assign rx_lbus_seg3_chan_in_int = rx_lbus_seg3_chan_in;
		end
		else begin
            assign rx_lbus_seg0_chan_in_int = 11'b0;
            assign rx_lbus_seg1_chan_in_int = 11'b0;
            assign rx_lbus_seg2_chan_in_int = 11'b0;
            assign rx_lbus_seg3_chan_in_int = 11'b0;
		end
		assign rx_lbus_seg0_data_int = rx_lbus_seg0_data;
		assign rx_lbus_seg0_ena_int = rx_lbus_seg0_ena;
		assign rx_lbus_seg0_sop_int = rx_lbus_seg0_sop;
		assign rx_lbus_seg0_eop_int = rx_lbus_seg0_eop;
		assign rx_lbus_seg0_mty_int = rx_lbus_seg0_mty;
		assign rx_lbus_seg0_err_int = rx_lbus_seg0_err;
		assign rx_lbus_seg1_data_int = rx_lbus_seg1_data;
		assign rx_lbus_seg1_ena_int = rx_lbus_seg1_ena;
		assign rx_lbus_seg1_sop_int = rx_lbus_seg1_sop;
		assign rx_lbus_seg1_eop_int = rx_lbus_seg1_eop;
		assign rx_lbus_seg1_mty_int = rx_lbus_seg1_mty;
		assign rx_lbus_seg1_err_int = rx_lbus_seg1_err;
		assign rx_lbus_seg2_data_int = rx_lbus_seg2_data;
		assign rx_lbus_seg2_ena_int = rx_lbus_seg2_ena;
		assign rx_lbus_seg2_sop_int = rx_lbus_seg2_sop;
		assign rx_lbus_seg2_eop_int = rx_lbus_seg2_eop;
		assign rx_lbus_seg2_mty_int = rx_lbus_seg2_mty;
		assign rx_lbus_seg2_err_int = rx_lbus_seg2_err;
		assign rx_lbus_seg3_data_int = rx_lbus_seg3_data;
		assign rx_lbus_seg3_ena_int = rx_lbus_seg3_ena;
		assign rx_lbus_seg3_sop_int = rx_lbus_seg3_sop;
		assign rx_lbus_seg3_eop_int = rx_lbus_seg3_eop;
		assign rx_lbus_seg3_mty_int = rx_lbus_seg3_mty;
		assign rx_lbus_seg3_err_int = rx_lbus_seg3_err;
	end

	genvar i;
	logic [511:0] s_axis_tdata_int;
	logic [511:0] m_axis_tdata_int;
	logic [63:0] s_axis_tkeep_int;
	logic [63:0] m_axis_tkeep_int;

	if (ENDIANNESS) begin
		assign s_axis_tdata_int = s_axis_tdata;
		assign s_axis_tkeep_int = s_axis_tkeep;
		assign m_axis_tdata = m_axis_tdata_int;
		assign m_axis_tkeep = m_axis_tkeep_int;
	end
	else begin
        assign s_axis_tdata_int = {<<8{s_axis_tdata}};
        assign s_axis_tkeep_int = {<<{s_axis_tkeep}};
        assign m_axis_tdata = {<<8{m_axis_tdata_int}};
        assign m_axis_tkeep = {<<{m_axis_tkeep_int}};
	end
 
	axis2lbus # (
		.ENABLE_ILKN_PORTS(ENABLE_ILKN_PORTS)
	) axis2lbus_inst (
		.clk(tx_clk),
		.rst(tx_rst),
		.s_axis_tdata(s_axis_tdata_int),
		.s_axis_tkeep(s_axis_tkeep_int),
		.s_axis_tlast(s_axis_tlast),
		.s_axis_tvalid(s_axis_tvalid),
		.s_axis_tready(s_axis_tready),
		.tx_lbus_seg0_chan_in(tx_lbus_seg0_chan_in),
		.tx_lbus_seg1_chan_in(tx_lbus_seg1_chan_in),
		.tx_lbus_seg2_chan_in(tx_lbus_seg2_chan_in),
		.tx_lbus_seg3_chan_in(tx_lbus_seg3_chan_in),
		.tx_lbus_seg0_bctlin_in(tx_lbus_seg0_bctlin_in),
		.tx_lbus_seg1_bctlin_in(tx_lbus_seg1_bctlin_in),
		.tx_lbus_seg2_bctlin_in(tx_lbus_seg2_bctlin_in),
		.tx_lbus_seg3_bctlin_in(tx_lbus_seg3_bctlin_in),
		.tx_lbus_seg0_chan_out(tx_lbus_seg0_chan_out_int),
		.tx_lbus_seg1_chan_out(tx_lbus_seg1_chan_out_int),
		.tx_lbus_seg2_chan_out(tx_lbus_seg2_chan_out_int),
		.tx_lbus_seg3_chan_out(tx_lbus_seg3_chan_out_int),
		.tx_lbus_seg0_bctlin_out(tx_lbus_seg0_bctlin_out_int),
		.tx_lbus_seg1_bctlin_out(tx_lbus_seg1_bctlin_out_int),
		.tx_lbus_seg2_bctlin_out(tx_lbus_seg2_bctlin_out_int),
		.tx_lbus_seg3_bctlin_out(tx_lbus_seg3_bctlin_out_int),
		.tx_lbus_ready_out(tx_lbus_ready_out),
		.tx_lbus_ready(tx_lbus_ready),
		.tx_lbus_seg0_data(tx_lbus_seg0_data_int),
		.tx_lbus_seg0_ena(tx_lbus_seg0_ena_int),
		.tx_lbus_seg0_sop(tx_lbus_seg0_sop_int),
		.tx_lbus_seg0_eop(tx_lbus_seg0_eop_int),
		.tx_lbus_seg0_mty(tx_lbus_seg0_mty_int),
		.tx_lbus_seg0_err(tx_lbus_seg0_err_int),
		.tx_lbus_seg1_data(tx_lbus_seg1_data_int),
		.tx_lbus_seg1_ena(tx_lbus_seg1_ena_int),
		.tx_lbus_seg1_sop(tx_lbus_seg1_sop_int),
		.tx_lbus_seg1_eop(tx_lbus_seg1_eop_int),
		.tx_lbus_seg1_mty(tx_lbus_seg1_mty_int),
		.tx_lbus_seg1_err(tx_lbus_seg1_err_int),
		.tx_lbus_seg2_data(tx_lbus_seg2_data_int),
		.tx_lbus_seg2_ena(tx_lbus_seg2_ena_int),
		.tx_lbus_seg2_sop(tx_lbus_seg2_sop_int),
		.tx_lbus_seg2_eop(tx_lbus_seg2_eop_int),
		.tx_lbus_seg2_mty(tx_lbus_seg2_mty_int),
		.tx_lbus_seg2_err(tx_lbus_seg2_err_int),
		.tx_lbus_seg3_data(tx_lbus_seg3_data_int),
		.tx_lbus_seg3_ena(tx_lbus_seg3_ena_int),
		.tx_lbus_seg3_sop(tx_lbus_seg3_sop_int),
		.tx_lbus_seg3_eop(tx_lbus_seg3_eop_int),
		.tx_lbus_seg3_mty(tx_lbus_seg3_mty_int),
		.tx_lbus_seg3_err(tx_lbus_seg3_err_int)
	);

	lbus2axis # (
		.ENABLE_ILKN_PORTS(ENABLE_ILKN_PORTS)
	) lbus2axis_inst (
		.clk(rx_clk),
		.rst(rx_rst),
		.m_axis_tdata(m_axis_tdata_int),
		.m_axis_tkeep(m_axis_tkeep_int),
		.m_axis_tlast(m_axis_tlast),
		.m_axis_tvalid(m_axis_tvalid),
		.rx_lbus_seg0_chan_in(rx_lbus_seg0_chan_in_int),
		.rx_lbus_seg1_chan_in(rx_lbus_seg1_chan_in_int),
		.rx_lbus_seg2_chan_in(rx_lbus_seg2_chan_in_int),
		.rx_lbus_seg3_chan_in(rx_lbus_seg3_chan_in_int),
		.rx_lbus_seg0_chan_out(rx_lbus_seg0_chan_out),
		.rx_lbus_seg1_chan_out(rx_lbus_seg1_chan_out),
		.rx_lbus_seg2_chan_out(rx_lbus_seg2_chan_out),
		.rx_lbus_seg3_chan_out(rx_lbus_seg3_chan_out),
		.rx_lbus_seg0_data(rx_lbus_seg0_data_int),
		.rx_lbus_seg0_ena(rx_lbus_seg0_ena_int),
		.rx_lbus_seg0_sop(rx_lbus_seg0_sop_int),
		.rx_lbus_seg0_eop(rx_lbus_seg0_eop_int),
		.rx_lbus_seg0_mty(rx_lbus_seg0_mty_int),
		.rx_lbus_seg0_err(rx_lbus_seg0_err_int),
		.rx_lbus_seg1_data(rx_lbus_seg1_data_int),
		.rx_lbus_seg1_ena(rx_lbus_seg1_ena_int),
		.rx_lbus_seg1_sop(rx_lbus_seg1_sop_int),
		.rx_lbus_seg1_eop(rx_lbus_seg1_eop_int),
		.rx_lbus_seg1_mty(rx_lbus_seg1_mty_int),
		.rx_lbus_seg1_err(rx_lbus_seg1_err_int),
		.rx_lbus_seg2_data(rx_lbus_seg2_data_int),
		.rx_lbus_seg2_ena(rx_lbus_seg2_ena_int),
		.rx_lbus_seg2_sop(rx_lbus_seg2_sop_int),
		.rx_lbus_seg2_eop(rx_lbus_seg2_eop_int),
		.rx_lbus_seg2_mty(rx_lbus_seg2_mty_int),
		.rx_lbus_seg2_err(rx_lbus_seg2_err_int),
		.rx_lbus_seg3_data(rx_lbus_seg3_data_int),
		.rx_lbus_seg3_ena(rx_lbus_seg3_ena_int),
		.rx_lbus_seg3_sop(rx_lbus_seg3_sop_int),
		.rx_lbus_seg3_eop(rx_lbus_seg3_eop_int),
		.rx_lbus_seg3_mty(rx_lbus_seg3_mty_int),
		.rx_lbus_seg3_err(rx_lbus_seg3_err_int),
		.rx_lbus_seg0_err_out(rx_lbus_seg0_err_out_int),
		.rx_lbus_seg1_err_out(rx_lbus_seg1_err_out_int),
		.rx_lbus_seg2_err_out(rx_lbus_seg2_err_out_int),
		.rx_lbus_seg3_err_out(rx_lbus_seg3_err_out_int)
	);

endmodule
