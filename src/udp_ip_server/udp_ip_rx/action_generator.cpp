#include <ap_int.h>
#include "udp_ip_rx.h"
void action_generator(
	HEADER_META		meta_in,
	PAYLOAD_CHECKSUM	payload_cksum,
	ACTION_BOX		&action_out,
	ap_uint<1>		&action_out_valid
)
{
	#pragma HLS INTERFACE ap_ctrl_none port=return
	#pragma HLS INTERFACE ap_none port=meta_in
	#pragma HLS INTERFACE ap_none port=payload_cksum
	#pragma HLS INTERFACE ap_none port=action_out
	#pragma HLS INTERFACE ap_none port=action_out_valid
	#pragma HLS DATA_PACK variable=action_out
	static HEADER_META	meta_in_reg0,meta_in_reg;
	static ACTION_BOX	action_out_reg,action_out_reg1;
	static ap_uint<1>	action_out_valid_reg,action_out_valid_reg1;
	static ap_uint<1>	ignore_flag,ignore_flag1;

	static ap_uint<32>	combined_cksum;
	static ap_uint<16>	combined_cksum_final;

	action_out.src_ip = action_out_reg1.src_ip;
	action_out.src_port = action_out_reg1.src_port;
	action_out.dst_port = action_out_reg1.dst_port;
	action_out.action = (ignore_flag1 || combined_cksum_final == CHECKSUM_GOOD) ? PASS : DROP; //DROP = 0; PASS = 1;
	action_out_valid = action_out_valid_reg1;
	
//cycle 1
	combined_cksum_final = combined_cksum(31,16) + combined_cksum(15,0);
	action_out_reg1 = action_out_reg;
	action_out_valid_reg1 = action_out_valid_reg;
	ignore_flag1 = ignore_flag;
//cycle 0
	combined_cksum = meta_in_reg.checksum + payload_cksum.data;
	action_out_valid_reg = payload_cksum.valid;
	action_out_reg.src_ip = meta_in_reg.src_ip;
	action_out_reg.src_port = meta_in_reg.protocol_header(63,48);
	action_out_reg.dst_port = meta_in_reg.protocol_header(47,32);
	action_out_reg.action = meta_in_reg.action;
	ignore_flag = meta_in_reg.action == IGNORE;
//cycle -1
//align meta with payload checksum, difference = 2 cycles
	meta_in_reg = meta_in_reg0;
	meta_in_reg0 = meta_in;
}
