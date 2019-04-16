Shout out to the 996.icu project, programmer lives matter!<br>
[![996.icu](https://img.shields.io/badge/link-996.icu-red.svg)](https://996.icu/#/en_US)

# GULF-Stream
100G UDP Link For AXI Stream

GULF-Stream is a hardware IP written in HLS. It provides 100G UDP link for FPGA devices, currently it only supports Xilinx Ultrascale and Ultrascale+ devices.

The major components of GULF-Stream are a lbus to axi-stream converter and a 100G UDP IP core.

To make the GULF-Stream IP core you would run:

make GULF_Stream_IPCore

You would find all the GULF-Stream Vivado IP cores in ip_repo.
Among the IP cores, "GULF Stream" and "lbus axis converter" are the 2 IP cores that users would need to be put into their 100G UDP projects. The "GULF Stream" provides 100G UDP link for AXI stream interface, the "lbus axis converter" acts as a bridge between AXI Stream and LBUS interface.

Please refer to the loopback example project for how to use these 2 cores in your design.

To make a loop back example project you would run:

make loopback_example

You would find the loopback example project at examples/loopback_server/loopback_server.xpr

There is also a benchmark provided, To make a benchmark project you would run:

make benchmark_example

You would find the benchmark example project at examples/benchmark/benchmark.xpr
