all: arp_server ether_protocol_assembler ether_protocol_spliter udp_ip_server

arp_server: scripts/arp_server/* ../../src/arp_server/*
	rm -rf arp_server
	mkdir -p arp_server
	vitis_hls scripts/arp_server/arp_receive.tcl
	vitis_hls scripts/arp_server/arp_send.tcl
	rm -f vitis_hls.log

ether_protocol_assembler: scripts/ether_protocol_assembler/* ../../src/ether_protocol_assembler/*
	rm -rf ether_protocol_assembler
	vitis_hls scripts/ether_protocol_assembler/ether_protocol_assembler.tcl
	rm -f vitis_hls.log

ether_protocol_spliter: scripts/ether_protocol_spliter/* ../../src/ether_protocol_spliter/*
	rm -rf ether_protocol_spliter
	vitis_hls scripts/ether_protocol_spliter/ether_protocol_spliter.tcl
	rm -f vitis_hls.log

udp_ip_server: scripts/udp_ip_server/* ../../src/udp_ip_server/*
	rm -rf udp_ip_server
	mkdir -p udp_ip_server
	vitis_hls scripts/udp_ip_server/action_excecutor.tcl
	vitis_hls scripts/udp_ip_server/action_generator.tcl
	vitis_hls scripts/udp_ip_server/payload_checksum.tcl
	vitis_hls scripts/udp_ip_server/udp_ip_receive.tcl
	vitis_hls scripts/udp_ip_server/udp_ip_tx.tcl
	vitis_hls scripts/udp_ip_server/udp_eth_assemble.tcl
	rm -f vitis_hls.log

clean:
	rm -rf arp_server ether_protocol_assembler ether_protocol_spliter udp_ip_server
