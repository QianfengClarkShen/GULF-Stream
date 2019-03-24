//ARP status
#define VALID   0
#define WORKING 1
#define TIMEOUT 2
/////
struct AXIS_RAW
{
	ap_uint<512>	data;
	ap_uint<64>	keep;
	ap_uint<1>	valid;
	ap_uint<1>	last;
};
struct PAYLOAD_FULL
{
	ap_uint<512>	data;
	ap_uint<64>	keep;
	ap_uint<1>	valid;
	ap_uint<1>	last;
};

struct ACTION_BOX {
	ap_uint<32>	dst_ip;
	ap_uint<48>	dst_mac;
	ap_uint<16>	src_port;
	ap_uint<16>	dst_port;
	ap_uint<17>	udp_cksum;
	ap_uint<16>	ip_cksum;
	ap_uint<16>	payload_length;
};

const PAYLOAD_FULL PAYLOAD_FULL_DUMMY = {0,0,0,0};
const ACTION_BOX ACTION_DUMMY = {0,0,0,0,0,0,0};
const AXIS_RAW AXIS_RAW_DUMMY = {0,0,0,0};
const ap_uint<16> IP_FIXED_CKSUM = 0xc52d; // 0x4500 (IP_FIXED_HEAD) + 28 (ip header length) + 0x4000 (fragment) + 0x4011 (ttl + udp protocol);
const ap_uint<6> UDP_FIXED_CKSUM = 33; //17 (UDP_HEX) + 16 (udp header length * 2)
