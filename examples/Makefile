loopback_server: scripts/loopback.tcl ../ip_repo/*
	rm -rf loopback_server
	vivado -mode tcl -source scripts/loopback.tcl -nolog -nojournal

benchmark: scripts/benchmark.tcl ../ip_repo/*
	rm -rf benchmark
	vivado -mode tcl -source scripts/benchmark.tcl -nolog -nojournal

clean:
	rm -rf loopback_server benchmark
