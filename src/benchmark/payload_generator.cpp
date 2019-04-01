#include <ap_int.h>
#include "benchmark.h"
void payload_generator(
	ap_uint<1>	start,
	ap_uint<1>	ready,
	ap_uint<32>	packet_num,
	ap_uint<16>	payload_len,
	ap_uint<32>	&counter_out,
	ap_uint<32>	&time_elapse,
	AXISBUS		&m_axis,
	ap_uint<1>	&done
) {
	#pragma HLS INTERFACE ap_ctrl_none port=return
	#pragma HLS INTERFACE ap_none port=start
	#pragma HLS INTERFACE ap_none port=packet_num
	#pragma HLS INTERFACE ap_none port=payload_len
	#pragma HLS INTERFACE ap_none port=counter_out
	#pragma HLS INTERFACE ap_none port=time_elapse
	#pragma HLS INTERFACE ap_none port=m_axis
	#pragma HLS INTERFACE ap_none port=done
	static ap_uint<1>	status;
	static ap_uint<32>	cnt;
	static ap_uint<32>	packet_id;
	static ap_uint<32>	time_elapse_reg;
	static ap_uint<16>	length_remain;
	static AXISBUS		axis_reg;

	static ap_uint<16>	payload_len_adjusted;
	static ap_uint<32>	packet_num_reg;
	static ap_uint<1>	start_reg;
	static ap_uint<1>	done_reg;
	m_axis = (ready & !done_reg) ? axis_reg : AXIS_DUMMY;
	counter_out = cnt;
	done = done_reg;
	time_elapse = time_elapse_reg - 1;
	if (!start_reg & start) {
		status = 1;
		done_reg = 0;
		cnt = 0;
		packet_id = 1;
		length_remain = payload_len_adjusted;
		time_elapse_reg = 0;
	} else {
		if (!done_reg & status) {
			time_elapse_reg++;
		}
		if ((packet_id == (packet_num_reg+1)) && ready) {
			status = 0;
			done_reg = 1;
			axis_reg = AXIS_DUMMY;
		} else if (ready & status) {
			axis_reg.data(511,480) = (length_remain == payload_len_adjusted) ? packet_id : (ap_uint<32>)0;
			axis_reg.data(479,448) = (length_remain == payload_len_adjusted) ? cnt : (ap_uint<32>)0;
			axis_reg.data(447,0) = 0;
			axis_reg.keep = payload_length2keep(length_remain);
			axis_reg.last = (length_remain <= 64) && (length_remain != 0);
			axis_reg.valid = length_remain != 0;
			
			if (length_remain <= 64) {
				length_remain = payload_len_adjusted;
				packet_id++;
			} else {
				length_remain -= 64;
			}
		} else if (!status) {
			axis_reg = AXIS_DUMMY;
		}
		cnt++;
	}

	start_reg = start;
	packet_num_reg = packet_num;
	payload_len_adjusted = (payload_len <= 8) ? (ap_uint<16>)8 : ((payload_len >= 9558) ? (ap_uint<16>)9558 : payload_len); 
}
