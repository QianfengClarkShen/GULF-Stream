#include <ap_int.h>
#include "arp_server.h"
void arp_receive(
	const ap_uint<32>	myIP,
	HEADER			arp_in,
	ARP_RESP		arp_internal_resp,
	ARP_RESP		&call_for_responce,
	ARP_RESP		&arptable_dataout,
	ap_uint<8>		&arptable_addrout
) 
{
	#pragma HLS INTERFACE ap_ctrl_none port=return
	#pragma HLS INTERFACE ap_none port=myIP
	#pragma HLS INTERFACE ap_none port=arp_in
	#pragma HLS INTERFACE ap_none port=arp_internal_resp
	#pragma HLS INTERFACE ap_none port=call_for_responce
	#pragma HLS INTERFACE ap_none port=arptable_dataout
	#pragma HLS INTERFACE ap_none port=arptable_addrout

//input registers
	static ap_uint<32>      myIPReg;
	static ap_uint<48>	eth_src_mac;
	static ARP_HEADER	arp_in_reg;
	static ap_uint<80>	arp_internal_resp_reg;
	static ap_uint<1>	arp_internal_resp_valid_reg;
///////////////

//output registers
	static ARP_RESP		call_for_responce_reg;
	static ARP_RESP		arptable_dataout_reg;
	static ap_uint<8>	arptable_addrout_reg;
//////////////////////


//output
	call_for_responce = call_for_responce_reg;
	arptable_dataout = arptable_dataout_reg;
	arptable_addrout = arptable_addrout_reg;
/////////////////////

//arp receive channel
	call_for_responce_reg.valid = arp_in_reg.valid && arp_in_reg.fixed_head == ARP_FIXED_HEAD && arp_in_reg.dst_ip == myIPReg && arp_in_reg.opcode == 1;
	arptable_dataout_reg.valid = (arp_in_reg.valid && arp_in_reg.fixed_head == ARP_FIXED_HEAD && ((arp_in_reg.dst_ip == myIPReg) || (arp_in_reg.dst_mac == BCAST_MAC && arp_in_reg.src_ip == arp_in_reg.dst_ip && arp_in_reg.opcode == 1))) | arp_internal_resp_valid_reg;
	if (arp_in_reg.valid) {
		if (arp_in_reg.fixed_head == ARP_FIXED_HEAD && arp_in_reg.dst_ip == myIPReg && arp_in_reg.opcode == 1) {
		//got a ARP request, call for ARP responce
			call_for_responce_reg.Mac_IP = (eth_src_mac, arp_in_reg.src_ip);
			arptable_dataout_reg.Mac_IP = (arp_in_reg.src_mac, arp_in_reg.src_ip);
			arptable_addrout_reg = arp_in_reg.src_ip(7,0);
		} else if (arp_in_reg.fixed_head == ARP_FIXED_HEAD && ((arp_in_reg.dst_ip == myIPReg && arp_in_reg.opcode == 2) || (arp_in_reg.dst_mac == BCAST_MAC && arp_in_reg.src_ip == arp_in_reg.dst_ip && arp_in_reg.opcode == 1))) {
		//got a ARP reply or gratuitous ARP, write ARP table
			arptable_dataout_reg.Mac_IP = (arp_in_reg.src_mac, arp_in_reg.src_ip);
			arptable_addrout_reg = arp_in_reg.src_ip(7,0);
		}
	} else if (arp_internal_resp_valid_reg) {
		arptable_dataout_reg.Mac_IP = arp_internal_resp_reg;
		arptable_addrout_reg = arp_internal_resp_reg(7,0);
	}
/////////////////////////////////////////////

//input registers
	if (arp_internal_resp.valid) {
		arp_internal_resp_valid_reg = 1;
	} else if (!arp_in_reg.valid) {
		arp_internal_resp_valid_reg = 0;
	}
	myIPReg = myIP;
	eth_src_mac = arp_in.data(287,240);
	arp_in_reg.fixed_head = arp_in.data(223,176);
	arp_in_reg.opcode = arp_in.data(175,160);
	arp_in_reg.src_mac = arp_in.data(159,112);
	arp_in_reg.src_ip = arp_in.data(111,80);
	arp_in_reg.dst_mac = arp_in.data(79,32);
	arp_in_reg.dst_ip = arp_in.data(31,0);
	arp_in_reg.valid = arp_in.valid;
	arp_internal_resp_reg = arp_internal_resp.Mac_IP;
/////////////////////////////////////////////
}
