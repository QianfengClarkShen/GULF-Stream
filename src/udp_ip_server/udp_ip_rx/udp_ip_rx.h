struct ARP_RESP
{
	ap_uint<80>	Mac_IP;
	ap_uint<1>	valid;
};
struct PAYLOAD
{
	ap_uint<512>	data;
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
struct HEADER
{
	ap_uint<336>	data;
	ap_uint<1>	valid;
};

struct IP_HEADER
{
	ap_uint<16>	fixed_head;
	ap_uint<16>	length;
	ap_uint<16>	id;
	ap_uint<16>	fragment;
	ap_uint<8>	ttl;
	ap_uint<8>	proto;
	ap_uint<16>	checksum;
	ap_uint<32>	src_ip;
	ap_uint<32>	dst_ip;
	ap_uint<64>	proto_header;
	ap_uint<1>	valid;
};

struct PAYLOADLEN {
	ap_uint<16>	data;
	ap_uint<1>	valid;
};

struct PAYLOAD_CHECKSUM {
	ap_uint<32>	data;
	ap_uint<1>	valid;
};

struct HEADER_META {
	ap_uint<32>	src_ip;
	ap_uint<64>	protocol_header;
	ap_uint<32>	checksum;
	ap_uint<2>	action;
};

struct ACTION_BOX {
	ap_uint<32>	src_ip;
	ap_uint<16>	src_port;
	ap_uint<16>	dst_port;
	ap_uint<1>	action;
};

const ap_uint<16> CHECKSUM_GOOD = ap_uint<16>("ffff",16);
const ap_uint<16> IP_FIXED_HEAD = ap_uint<16>("4500",16);
const ap_uint<16> FRAGMENT = ap_uint<16>("4000",16);
const ap_uint<8> ICMP_HEX = 1;
const ap_uint<8> UDP_HEX = 17;
const PAYLOAD DUMMY = {0,0};
const PAYLOAD_FULL PAYLOAD_FULL_DUMMY = {0,0,0,0};

#define DROP	0
#define PASS	1
#define IGNORE	2
