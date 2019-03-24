struct AXIS_RAW
{
	ap_uint<512>	data;
	ap_uint<64>	keep;
	ap_uint<1>	last;
	ap_uint<1>	valid;
};

struct HEADER
{
	ap_uint<336>	data;
	ap_uint<1>	valid;
};

struct PAYLOAD
{
	ap_uint<512>	data;
	ap_uint<1>	valid;
	ap_uint<1>	last;
};

struct PAYLOADLEN {
	ap_uint<16>	data;
	ap_uint<1>	valid;
};

const ap_uint<48> BCAST_MAC = ap_uint<48>("0xffffffffffff",16);
const ap_uint<16> IP_HEX = ap_uint<16>("0x0800",16);
const ap_uint<16> ARP_HEX = ap_uint<16>("0x0806",16);
