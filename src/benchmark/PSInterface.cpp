#include <ap_int.h>
void PSInterface (
//AXI Lite interface, to PS
	ap_uint<32>	axil_start,
	ap_uint<32>	axil_rst,
	ap_uint<32>	axil_pkt_num,
	ap_uint<32>	axil_pkt_len,
	ap_uint<32>	axil_ip,
	ap_uint<32>     axil_gateway,
	ap_uint<32>     axil_netmask,
	ap_uint<32>     axil_mac_high16,
	ap_uint<32>	axil_mac_low32,
	ap_uint<32>	&axil_tx_timeElapse_high,
	ap_uint<32>     &axil_tx_timeElapse_low,
	ap_uint<32>	&axil_tx_done,
	ap_uint<32>	&axil_latency_sum_high,
	ap_uint<32>     &axil_latency_sum_low,
 	ap_uint<32>	&axil_rx_timeElaspe_high,
	ap_uint<32>     &axil_rx_timeElaspe_low,
	ap_uint<32>	&axil_rx_done,
	ap_uint<32>	&axil_rx_error,
	ap_uint<32>	&axil_rx_curr_cnt,
/////////////
//PL interfaces
	ap_uint<1>	&start,
	ap_uint<1>	&rst,
	ap_uint<32>	&pkt_num,
	ap_uint<16>	&pkt_len,
	ap_uint<32>	&ip,
	ap_uint<32>	&gateway,
	ap_uint<32>	&netmask,
	ap_uint<48>	&mac,
	ap_uint<64>	tx_timeElapse,
	ap_uint<1>	tx_done,
	ap_uint<64>	latency_sum,
	ap_uint<64>	rx_timeElapse,
	ap_uint<32>	rx_cnt,
	ap_uint<1>	rx_done,
	ap_uint<1>	rx_error
//////////////
) {
	#pragma HLS INTERFACE ap_ctrl_none port=return
	#pragma HLS INTERFACE s_axilite port=axil_start
	#pragma HLS INTERFACE s_axilite port=axil_rst
	#pragma HLS INTERFACE s_axilite port=axil_pkt_num
	#pragma HLS INTERFACE s_axilite port=axil_pkt_len
	#pragma HLS INTERFACE s_axilite port=axil_ip
	#pragma HLS INTERFACE s_axilite port=axil_gateway
	#pragma HLS INTERFACE s_axilite port=axil_netmask
	#pragma HLS INTERFACE s_axilite port=axil_mac_high16
	#pragma HLS INTERFACE s_axilite port=axil_mac_low32
	#pragma HLS INTERFACE s_axilite port=axil_tx_timeElapse_high
	#pragma HLS INTERFACE s_axilite port=axil_tx_timeElapse_low
	#pragma HLS INTERFACE s_axilite port=axil_tx_done
	#pragma HLS INTERFACE s_axilite port=axil_latency_sum_high
	#pragma HLS INTERFACE s_axilite port=axil_latency_sum_low
	#pragma HLS INTERFACE s_axilite port=axil_rx_timeElaspe_high
	#pragma HLS INTERFACE s_axilite port=axil_rx_timeElaspe_low
	#pragma HLS INTERFACE s_axilite port=axil_rx_done
	#pragma HLS INTERFACE s_axilite port=axil_rx_error
	#pragma HLS INTERFACE s_axilite port=axil_rx_curr_cnt
	#pragma HLS INTERFACE ap_none port=start
	#pragma HLS INTERFACE ap_none port=rst
	#pragma HLS INTERFACE ap_none port=pkt_num
	#pragma HLS INTERFACE ap_none port=pkt_len
	#pragma HLS INTERFACE ap_none port=ip
	#pragma HLS INTERFACE ap_none port=gateway
	#pragma HLS INTERFACE ap_none port=netmask
	#pragma HLS INTERFACE ap_none port=mac
	#pragma HLS INTERFACE ap_none port=tx_timeElapse
	#pragma HLS INTERFACE ap_none port=tx_done
	#pragma HLS INTERFACE ap_none port=latency_sum
	#pragma HLS INTERFACE ap_none port=rx_timeElapse
	#pragma HLS INTERFACE ap_none port=rx_cnt
	#pragma HLS INTERFACE ap_none port=rx_done
	#pragma HLS INTERFACE ap_none port=rx_error

	start 	=	axil_start[0];
	pkt_num	=	axil_pkt_num;
	pkt_len	=	axil_pkt_len;
	ip	=	axil_ip;
	gateway	=	axil_gateway;
	netmask	=	axil_netmask;
	mac	=	(axil_mac_high16(15,0),axil_mac_low32);

	axil_rx_curr_cnt	=	rx_cnt;
	axil_tx_timeElapse_high	=	tx_timeElapse(63,32);
	axil_tx_timeElapse_low	=	tx_timeElapse(31,0);
	axil_tx_done		=	tx_done;
	axil_latency_sum_high	=	latency_sum(63,32);
	axil_latency_sum_low	=	latency_sum(31,0);
	axil_rx_timeElaspe_high	=	rx_timeElapse(63,32);
	axil_rx_timeElaspe_low	=	rx_timeElapse(31,0);
	axil_rx_done		=	rx_done;
	axil_rx_error		=	rx_error;

	rst = axil_rst[0];
}
