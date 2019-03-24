#include <ap_int.h>

struct AXISBUS
{
	ap_uint<512>		data;
	ap_uint<64>		keep;
	ap_uint<1>		last;
	ap_uint<1>		valid;
};

struct LBUS
{
	ap_uint<128>		data;
	ap_uint<1>		ena;
	ap_uint<1>		sop;
	ap_uint<1>		eop;
	ap_uint<1>		err;
	ap_uint<4>		mty;
};

void keep2mty(
	ap_uint<16>	keep,
	ap_uint<4>	&mty
);
