struct AXISBUS
{
	ap_uint<512>	data;
	ap_uint<64>	keep;
	ap_uint<1>	last;
	ap_uint<1>	valid;
};
ap_uint<64> payload_length2keep(ap_uint<16> length);
const struct AXISBUS AXIS_DUMMY = {0,0,0,0};
