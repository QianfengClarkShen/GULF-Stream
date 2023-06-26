set project_dir [file dirname [file dirname [file normalize [info script]]]]
set project_name "arp_server_100g"
source ${project_dir}/scripts/util.tcl

create_project $project_name $project_dir/$project_name -part xczu19eg-ffvc1760-2-i
#set_property board_part fidus.com:sidewinder100:part0:1.0 [current_project]
create_bd_design $project_name

set_property ip_repo_paths "${project_dir}/../hls_ips" [current_project]
update_ip_catalog -rebuild

addip arp_receive arp_receive_0
addip arp_send arp_send_0

addip blk_mem_gen blk_mem_gen_0
set_property -dict [list CONFIG.Memory_Type {Simple_Dual_Port_RAM} CONFIG.Enable_32bit_Address {false} CONFIG.Use_Byte_Write_Enable {false} CONFIG.Byte_Size {9} CONFIG.Assume_Synchronous_Clk {true} CONFIG.Write_Width_A {80} CONFIG.Write_Depth_A {256} CONFIG.Read_Width_A {80} CONFIG.Operating_Mode_A {NO_CHANGE} CONFIG.Enable_A {Always_Enabled} CONFIG.Write_Width_B {80} CONFIG.Read_Width_B {80} CONFIG.Operating_Mode_B {READ_FIRST} CONFIG.Enable_B {Always_Enabled} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.Register_PortB_Output_of_Memory_Primitives {true} CONFIG.Use_RSTA_Pin {false} CONFIG.Port_B_Clock {100} CONFIG.Port_B_Enable_Rate {100} CONFIG.use_bram_block {Stand_Alone} CONFIG.EN_SAFETY_CKT {false}] [get_bd_cells blk_mem_gen_0]

make_bd_pins_external [get_bd_pins arp_receive_0/ap_clk]
make_bd_pins_external [get_bd_pins arp_receive_0/ap_rst]
make_bd_pins_external [get_bd_pins arp_send_0/myMac]
make_bd_pins_external [get_bd_pins arp_send_0/myIP]
make_bd_pins_external [get_bd_pins arp_send_0/gateway]
make_bd_pins_external [get_bd_pins arp_send_0/netmask]
make_bd_pins_external [get_bd_pins arp_receive_0/arp_in_data]
make_bd_pins_external [get_bd_pins arp_receive_0/arp_in_valid]
make_bd_pins_external [get_bd_pins arp_send_0/arp_out_data]
make_bd_pins_external [get_bd_pins arp_send_0/arp_out_keep]
make_bd_pins_external [get_bd_pins arp_send_0/arp_out_last]
make_bd_pins_external [get_bd_pins arp_send_0/arp_out_valid]
make_bd_pins_external [get_bd_pins arp_send_0/arp_out_ready]
make_bd_pins_external [get_bd_pins arp_send_0/lookup_result]
make_bd_pins_external [get_bd_pins arp_send_0/lookup_req]
make_bd_pins_external [get_bd_pins arp_send_0/arp_status]
make_bd_pins_external [get_bd_pins arp_receive_0/arp_internal_resp_Mac_IP]
make_bd_pins_external [get_bd_pins arp_receive_0/arp_internal_resp_valid]

set_property name clk [get_bd_ports ap_clk_0]
set_property name rst [get_bd_ports ap_rst_0]
foreach port [get_bd_ports *_0] {
	set_property name [regsub "_0" [regsub "/" $port ""] ""] $port
}

connect_bd_net [get_bd_ports myIP] [get_bd_pins arp_receive_0/myIP]
connect_bd_net [get_bd_pins arp_send_0/arptable_addr] [get_bd_pins blk_mem_gen_0/addrb]
connect_bd_net [get_bd_pins arp_send_0/arptable_data] [get_bd_pins blk_mem_gen_0/doutb]
connect_bd_net [get_bd_ports clk] [get_bd_pins blk_mem_gen_0/clkb]
connect_bd_net [get_bd_ports clk] [get_bd_pins blk_mem_gen_0/clka]
connect_bd_net [get_bd_pins blk_mem_gen_0/dina] [get_bd_pins arp_receive_0/arptable_dataout_Mac_IP]
connect_bd_net [get_bd_pins arp_receive_0/arptable_dataout_valid] [get_bd_pins blk_mem_gen_0/wea]
connect_bd_net [get_bd_pins arp_receive_0/arptable_addrout] [get_bd_pins blk_mem_gen_0/addra]
connect_bd_net [get_bd_pins arp_receive_0/call_for_responce_Mac_IP] [get_bd_pins arp_send_0/call_for_responce_Mac_IP]
connect_bd_net [get_bd_pins arp_receive_0/call_for_responce_valid] [get_bd_pins arp_send_0/call_for_responce_valid]
connect_bd_net [get_bd_ports clk] [get_bd_pins arp_send_0/ap_clk]
connect_bd_net [get_bd_ports rst] [get_bd_pins arp_send_0/ap_rst]
save_bd_design

make_wrapper -files [get_files $project_dir/$project_name/${project_name}.srcs/sources_1/bd/${project_name}/${project_name}.bd] -top
add_files -norecurse $project_dir/$project_name/${project_name}.srcs/sources_1/bd/${project_name}/hdl/${project_name}_wrapper.v

ipx::package_project -import_files -root_dir $project_dir/$project_name/${project_name}.srcs/sources_1/bd/${project_name} -vendor clarkshen.com -library user -taxonomy /UserIP
set_property vendor_display_name {clarkshen.com} [ipx::current_core]
set_property name $project_name [ipx::current_core]
set_property display_name $project_name [ipx::current_core]
set_property description $project_name [ipx::current_core]

ipx::add_bus_interface arp_in [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:interface:axis_rtl:1.0 [ipx::get_bus_interfaces arp_in -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:interface:axis:1.0 [ipx::get_bus_interfaces arp_in -of_objects [ipx::current_core]]
set_property display_name arp_in [ipx::get_bus_interfaces arp_in -of_objects [ipx::current_core]]
ipx::add_port_map TDATA [ipx::get_bus_interfaces arp_in -of_objects [ipx::current_core]]
set_property physical_name arp_in_data [ipx::get_port_maps TDATA -of_objects [ipx::get_bus_interfaces arp_in -of_objects [ipx::current_core]]]
ipx::add_port_map TVALID [ipx::get_bus_interfaces arp_in -of_objects [ipx::current_core]]
set_property physical_name arp_in_valid [ipx::get_port_maps TVALID -of_objects [ipx::get_bus_interfaces arp_in -of_objects [ipx::current_core]]]
ipx::associate_bus_interfaces -busif arp_in -clock clk [ipx::current_core]

ipx::add_bus_interface arp_out [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:interface:axis_rtl:1.0 [ipx::get_bus_interfaces arp_out -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:interface:axis:1.0 [ipx::get_bus_interfaces arp_out -of_objects [ipx::current_core]]
set_property interface_mode master [ipx::get_bus_interfaces arp_out -of_objects [ipx::current_core]]
set_property display_name arp_out [ipx::get_bus_interfaces arp_out -of_objects [ipx::current_core]]
ipx::add_port_map TDATA [ipx::get_bus_interfaces arp_out -of_objects [ipx::current_core]]
set_property physical_name arp_out_data [ipx::get_port_maps TDATA -of_objects [ipx::get_bus_interfaces arp_out -of_objects [ipx::current_core]]]
ipx::add_port_map TLAST [ipx::get_bus_interfaces arp_out -of_objects [ipx::current_core]]
set_property physical_name arp_out_last [ipx::get_port_maps TLAST -of_objects [ipx::get_bus_interfaces arp_out -of_objects [ipx::current_core]]]
ipx::add_port_map TVALID [ipx::get_bus_interfaces arp_out -of_objects [ipx::current_core]]
set_property physical_name arp_out_valid [ipx::get_port_maps TVALID -of_objects [ipx::get_bus_interfaces arp_out -of_objects [ipx::current_core]]]
ipx::add_port_map TKEEP [ipx::get_bus_interfaces arp_out -of_objects [ipx::current_core]]
set_property physical_name arp_out_keep [ipx::get_port_maps TKEEP -of_objects [ipx::get_bus_interfaces arp_out -of_objects [ipx::current_core]]]
ipx::add_port_map TREADY [ipx::get_bus_interfaces arp_out -of_objects [ipx::current_core]]
set_property physical_name arp_out_ready [ipx::get_port_maps TREADY -of_objects [ipx::get_bus_interfaces arp_out -of_objects [ipx::current_core]]]
ipx::associate_bus_interfaces -busif arp_out -clock clk [ipx::current_core]

ipx::add_bus_interface arp_internal_resp [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:interface:axis_rtl:1.0 [ipx::get_bus_interfaces arp_internal_resp -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:interface:axis:1.0 [ipx::get_bus_interfaces arp_internal_resp -of_objects [ipx::current_core]]
set_property display_name arp_internal_resp [ipx::get_bus_interfaces arp_internal_resp -of_objects [ipx::current_core]]
ipx::add_port_map TDATA [ipx::get_bus_interfaces arp_internal_resp -of_objects [ipx::current_core]]
set_property physical_name arp_internal_resp_Mac_IP [ipx::get_port_maps TDATA -of_objects [ipx::get_bus_interfaces arp_internal_resp -of_objects [ipx::current_core]]]
ipx::add_port_map TVALID [ipx::get_bus_interfaces arp_internal_resp -of_objects [ipx::current_core]]
set_property physical_name arp_internal_resp_valid [ipx::get_port_maps TVALID -of_objects [ipx::get_bus_interfaces arp_internal_resp -of_objects [ipx::current_core]]]
ipx::associate_bus_interfaces -busif arp_internal_resp -clock clk [ipx::current_core]
set_property supported_families {virtexu Beta virtexuplus Beta virtexuplusHBM Beta zynquplus Beta kintexu Beta kintexuplus Beta} [ipx::current_core]

set_property core_revision 0 [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
set_property ip_repo_paths [list "$project_dir/$project_name/${project_name}.srcs/sources_1/bd/${project_name}" "${project_dir}/../hls_ips"] [current_project]
update_ip_catalog
ipx::check_integrity -quiet [ipx::current_core]
ipx::archive_core $project_dir/$project_name/${project_name}.srcs/sources_1/bd/${project_name}/${project_name}_1.0.zip [ipx::current_core]
close_project
exit
