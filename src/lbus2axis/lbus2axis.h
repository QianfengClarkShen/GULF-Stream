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
	ap_uint<1> 		eop;
	ap_uint<1>		err;
	ap_uint<4>		mty;
};

struct LBUS_FIFO_DATA
{
	LBUS	lbus0;
	LBUS    lbus1;
	LBUS    lbus2;
	LBUS    lbus3;
};

struct LBUS_FIFO_END_DATA
{
	LBUS    lbus0;
	LBUS    lbus1;
	LBUS    lbus2;
};

const struct LBUS dummy = {0,0,0,0,0,0};
