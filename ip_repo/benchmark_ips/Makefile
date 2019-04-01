GULFStream_benchmark: payload_generator payload_validator PSInterface scripts/benchmark.tcl
	rm -rf GULFStream_benchmark
	vivado -mode tcl -source scripts/benchmark.tcl -nolog -nojournal

payload_generator: scripts/payload_generator.tcl ../../src/benchmark/benchmark.h ../../src/benchmark/util.cpp ../../src/benchmark/payload_generator.cpp
	rm -rf payload_generator
	vivado_hls scripts/payload_generator.tcl
	rm -f vivado_hls.log

payload_validator: scripts/payload_validator.tcl ../../src/benchmark/benchmark.h ../../src/benchmark/payload_validator.cpp
	rm -rf payload_validator
	vivado_hls scripts/payload_validator.tcl
	rm -f vivado_hls.log

PSInterface: scripts/PSInterface.tcl ../../src/benchmark/PSInterface.cpp
	rm -rf PSInterface
	vivado_hls scripts/PSInterface.tcl
	rm -f vivado_hls.log

clean:
	rm -rf payload_generator payload_validator PSInterface GULFStream_benchmark
