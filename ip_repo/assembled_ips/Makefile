all: GULF_Stream

GULF_Stream: scripts/full_core.tcl arp_server_100g udp_ip_server_100g ../hls_ips/ether_protocol_assembler ../hls_ips/ether_protocol_spliter ../../src/full_core/*
	rm -rf GULF_Stream
	vivado -mode tcl -source scripts/full_core.tcl -nolog -nojournal

arp_server_100g: scripts/arp.tcl ../hls_ips/arp_server
	rm -rf arp_server_100g
	vivado -mode tcl -source scripts/arp.tcl -nolog -nojournal

udp_ip_server_100g: scripts/udp_ip.tcl ../hls_ips/udp_ip_server
	rm -rf udp_ip_server_100g
	vivado -mode tcl -source scripts/udp_ip.tcl -nolog -nojournal

clean:
	rm -rf GULF_Stream arp_server_100g udp_ip_server_100g
