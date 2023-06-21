set root_dir [file dirname [file dirname [file dirname [file normalize [info script]]]]]
set ip_name "benchmark"
set module_name "payload_validator"
cd $ip_name
open_project $module_name
set_top $module_name
add_files $root_dir/../../src/$ip_name/$module_name.cpp
open_solution "solution1" -flow_target vivado
set_part {xczu19eg-ffvc1760-2-i}
create_clock -period 3.103 -name default
config_rtl -reset all
csynth_design
export_design
