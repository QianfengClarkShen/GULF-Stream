#include <ap_int.h>
#include "udp_ip_rx.h"
void action_excecutor(
	ACTION_BOX	action,
	ap_uint<1>	action_valid,
	ap_uint<1>	action_empty,
	ap_uint<1>	&action_re,
	PAYLOAD_FULL	payload_in,
	ap_uint<1>	&payload_ready,
	PAYLOAD_FULL	&payload_out,
	ap_uint<32>	&src_ip,
	ap_uint<16>	&src_port,
	ap_uint<16>	&dst_port
) {
	#pragma HLS INTERFACE ap_ctrl_none port=return
	#pragma HLS INTERFACE ap_none port=action
	#pragma HLS INTERFACE ap_none port=action_valid
	#pragma HLS INTERFACE ap_none port=action_empty
	#pragma HLS INTERFACE ap_none port=action_re
	#pragma HLS INTERFACE ap_none port=payload_in
	#pragma HLS INTERFACE ap_none port=payload_ready
	#pragma HLS INTERFACE ap_none port=payload_out
	#pragma HLS INTERFACE ap_none port=src_ip
	#pragma HLS INTERFACE ap_none port=src_port
	#pragma HLS INTERFACE ap_none port=dst_port
	#pragma HLS DATA_PACK variable=action

	static ap_uint<32>	src_ip_reg;
	static ap_uint<16>	src_port_reg,dst_port_reg;
	static PAYLOAD_FULL	payload_out_reg;

	payload_out = payload_out_reg;
	src_ip = src_ip_reg;
	src_port = src_port_reg;
	dst_port = dst_port_reg;

	if (payload_in.valid & action_valid & action.action) { //PASS
		payload_out_reg = payload_in;
	} else {
		payload_out_reg = PAYLOAD_FULL_DUMMY;
	}
	if (action_valid & action.action) {
		src_ip_reg = action.src_ip;
		src_port_reg = action.src_port;
		dst_port_reg = action.dst_port;
	} else {
		src_ip_reg = 0;
		src_port_reg = 0;
		dst_port_reg = 0;
	}

	action_re = !action_empty & (payload_in.valid & payload_in.last);
	payload_ready = action_valid;
}
