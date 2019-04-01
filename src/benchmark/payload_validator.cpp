#include <ap_int.h>
#include "benchmark.h"
void payload_validator(
	ap_uint<32>	packet_num,
	ap_uint<32>	counter_in,
	AXISBUS		s_axis,
	ap_uint<64>	&latency_sum,
	ap_uint<64>	&time_elapse,
	ap_uint<32>	&curr_cnt,
	ap_uint<1>	&done,
	ap_uint<1>	&error
) {
	#pragma HLS INTERFACE ap_ctrl_none port=return
	#pragma HLS INTERFACE ap_none port=packet_num
	#pragma HLS INTERFACE ap_none port=counter_in
	#pragma HLS INTERFACE ap_none port=s_axis
	#pragma HLS INTERFACE ap_none port=latency_sum
	#pragma HLS INTERFACE ap_none port=time_elapse
	#pragma HLS INTERFACE ap_none port=curr_cnt
	#pragma HLS INTERFACE ap_none port=done
	#pragma HLS INTERFACE ap_none port=error

	static ap_uint<32>	packet_cnt;
	static ap_uint<1>	IN_PACKET;
	static ap_uint<1>	done_reg;
	static ap_uint<1>	error_reg;
	static ap_uint<64>	latency_sum_reg;
	static ap_uint<32>	latency;
	static ap_uint<1>	init_reg;
	static ap_uint<64>	time_elapse_reg;

	error = error_reg;
	done = done_reg;
	curr_cnt = packet_cnt+1;
	latency_sum = latency_sum_reg;
	time_elapse = time_elapse_reg;

        if (init_reg & !done_reg) {
                time_elapse_reg++;
        }

	latency_sum_reg += latency;
	done_reg = (packet_cnt == packet_num);

	if (!IN_PACKET & s_axis.valid & !error_reg) {
		if (s_axis.data(511,480) == (packet_cnt+1) && s_axis.keep[56]) {
			latency = counter_in - s_axis.data(479,448);
		} else {
			latency = 0;
			error_reg = 1;
		}
	} else {
		latency = 0;
	}

	if (!IN_PACKET & s_axis.valid) {
		init_reg = 1;
	}

	if (s_axis.valid & s_axis.last) {
		IN_PACKET = 0;
		packet_cnt++;
	} else if (!IN_PACKET & s_axis.valid) {
		IN_PACKET = 1;
	}
}
