IPCore:
	$(MAKE) -C ip_repo/hls_ips
	$(MAKE) -C ip_repo/assembled_ips

loopback_example: IPCore
	$(MAKE) -C examples loopback_server

clean_all:
	$(MAKE) -C examples clean
	$(MAKE) -C ip_repo/assembled_ips clean
	$(MAKE) -C ip_repo/hls_ips clean
