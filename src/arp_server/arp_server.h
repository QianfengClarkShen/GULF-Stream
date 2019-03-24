//ARP status
#define VALID	0
#define WORKING 1
#define TIMEOUT 2

struct AXIS_RAW
{
	ap_uint<512>	data;
	ap_uint<64>	keep;
	ap_uint<1>	last;
	ap_uint<1>	valid;
	ap_uint<1>	ready;
};
struct HEADER
{
	ap_uint<336>    data;
	ap_uint<1>      valid;
};

struct ARP_HEADER
{
	ap_uint<48>	fixed_head;
	ap_uint<16>	opcode;
	ap_uint<48>	src_mac;
	ap_uint<32>	src_ip;
	ap_uint<48>	dst_mac;
	ap_uint<32>	dst_ip;
	ap_uint<1>	valid;
};

struct ARP_REQ
{
	ap_uint<32>	ip;
	ap_uint<1>	valid;
};

struct ARP_RESP
{
	ap_uint<80>	Mac_IP;
	ap_uint<1>	valid;
};

struct ARP_RESP_FIFO
{
	ap_uint<48>	mac;
	ap_uint<32>	ip;
};

const ap_uint<48> ARP_FIXED_HEAD = ap_uint<48>("0x000108000604",16);
const ap_uint<48> BCAST_MAC = ap_uint<48>("0xffffffffffff",16);
const ap_uint<16> ARP_HEX = ap_uint<16>("0x0806",16);
