loopback_example: IPCore
	$(MAKE) -C examples loopback_server

IPCore:
	$(MAKE) -C ip_repo/hls_ips
	$(MAKE) -C ip_repo/assembled_ips

clean_all:
	$(MAKE) -C examples clean
	$(MAKE) -C ip_repo/assembled_ips clean
	$(MAKE) -C ip_repo/hls_ips clean
