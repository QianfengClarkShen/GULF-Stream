#include <ap_int.h>

#define ARP 0
#define IP 1

struct AXIS_RAW
{
	ap_uint<512>	data;
	ap_uint<64>	keep;
	ap_uint<1>	valid;
	ap_uint<1>	last;
};

const struct AXIS_RAW DUMMY = {0,0,0,0};

void ether_protocol_assembler(
	AXIS_RAW	eth_arp_in,
	ap_uint<1>	&arp_ready,
	AXIS_RAW	eth_ip_in,
	ap_uint<1>	&ip_ready,
	AXIS_RAW	&eth_out,
	ap_uint<1>	eth_out_ready
) {
	#pragma HLS INTERFACE ap_ctrl_none port=return
	#pragma HLS INTERFACE ap_none port=eth_arp_in
	#pragma HLS INTERFACE ap_none port=eth_ip_in
	#pragma HLS INTERFACE ap_none port=eth_out
	#pragma HLS INTERFACE ap_none port=arp_ready
	#pragma HLS INTERFACE ap_none port=ip_ready
	#pragma HLS INTERFACE ap_none port=eth_out_ready

	ap_uint<1> output_sw;
	static ap_uint<1>	output_sw_reg;
	static AXIS_RAW		eth_out_reg;
	static ap_uint<1>	arbiter = 1;

	eth_out = eth_out_ready ? eth_out_reg : DUMMY;

	if ((eth_out_reg.valid & eth_out_reg.last) | arbiter) {
		if (eth_arp_in.valid && output_sw_reg != ARP) {
			output_sw = ARP;
			arbiter = 0;
			output_sw_reg = ARP;
		} else if (eth_ip_in.valid && output_sw_reg != IP) {
			output_sw = IP;
			arbiter = 0;
			output_sw_reg = IP;
		} else if (eth_arp_in.valid | eth_ip_in.valid) {
			output_sw = output_sw_reg;
			arbiter = 0;
		} else {
			output_sw = output_sw_reg;
			arbiter = 1;
		}
	} else {
		output_sw = output_sw_reg;
	}

	if (eth_out_ready) {
		if (output_sw == ARP) {
			eth_out_reg = eth_arp_in;
		} else {
			eth_out_reg = eth_ip_in;
		}
	}
	arp_ready = (output_sw == ARP) & eth_out_ready;
	ip_ready = (output_sw == IP) & eth_out_ready;
}
