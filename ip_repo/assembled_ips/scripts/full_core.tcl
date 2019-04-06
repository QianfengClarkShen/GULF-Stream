set project_dir [file dirname [file dirname [file normalize [info script]]]]
set project_name "GULF_Stream"
source ${project_dir}/scripts/util.tcl

create_project $project_name $project_dir/$project_name -part xczu19eg-ffvc1760-2-i
set_property board_part fidus.com:sidewinder100:part0:1.0 [current_project]
create_bd_design $project_name

set_property ip_repo_paths [list "${project_dir}/../hls_ips" "$project_dir"] [current_project]
update_ip_catalog -rebuild

addip util_vector_logic util_vector_logic_0
set_property -dict [list CONFIG.C_SIZE {1} CONFIG.C_OPERATION {not} CONFIG.LOGO_FILE {data/sym_notgate.png}] [get_bd_cells util_vector_logic_0]

create_bd_cell -type ip -vlnv Qianfeng_Clark_Shen:user:udp_ip_server_100g:1.0 udp_ip_server_100g_0
create_bd_cell -type ip -vlnv Qianfeng_Clark_Shen:user:arp_server_100g:1.0 arp_server_100g_0
addip ether_protocol_spliter ether_protocol_spliter_0
addip ether_protocol_assembler ether_protocol_assembler_0

addip fifo_generator axis_data_fifo_0
set_property -dict [list CONFIG.INTERFACE_TYPE {AXI_STREAM} CONFIG.Reset_Type {Asynchronous_Reset} CONFIG.TDATA_NUM_BYTES {64} CONFIG.TUSER_WIDTH {0} CONFIG.Enable_TLAST {true} CONFIG.TSTRB_WIDTH {64} CONFIG.HAS_TKEEP {true} CONFIG.TKEEP_WIDTH {64} CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} CONFIG.Full_Threshold_Assert_Value_wach {15} CONFIG.Empty_Threshold_Assert_Value_wach {14} CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} CONFIG.Full_Threshold_Assert_Value_wrch {15} CONFIG.Empty_Threshold_Assert_Value_wrch {14} CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} CONFIG.Full_Threshold_Assert_Value_rach {15} CONFIG.Empty_Threshold_Assert_Value_rach {14} CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} CONFIG.FIFO_Implementation_axis {Common_Clock_Distributed_RAM} CONFIG.FIFO_Application_Type_axis {Low_Latency_Data_FIFO} CONFIG.Input_Depth_axis {16} CONFIG.Full_Threshold_Assert_Value_axis {15} CONFIG.Empty_Threshold_Assert_Value_axis {14}] [get_bd_cells axis_data_fifo_0]

addip fifo_generator axis_data_fifo_1
set_property -dict [list CONFIG.INTERFACE_TYPE {AXI_STREAM} CONFIG.Reset_Type {Asynchronous_Reset} CONFIG.TDATA_NUM_BYTES {64} CONFIG.TUSER_WIDTH {0} CONFIG.Enable_TLAST {true} CONFIG.TSTRB_WIDTH {64} CONFIG.HAS_TKEEP {true} CONFIG.TKEEP_WIDTH {64} CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} CONFIG.Full_Threshold_Assert_Value_wach {15} CONFIG.Empty_Threshold_Assert_Value_wach {14} CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} CONFIG.Full_Threshold_Assert_Value_wrch {15} CONFIG.Empty_Threshold_Assert_Value_wrch {14} CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} CONFIG.Full_Threshold_Assert_Value_rach {15} CONFIG.Empty_Threshold_Assert_Value_rach {14} CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} CONFIG.FIFO_Implementation_axis {Common_Clock_Distributed_RAM} CONFIG.FIFO_Application_Type_axis {Low_Latency_Data_FIFO} CONFIG.Input_Depth_axis {16} CONFIG.Full_Threshold_Assert_Value_axis {15} CONFIG.Empty_Threshold_Assert_Value_axis {14}] [get_bd_cells axis_data_fifo_1]

make_bd_pins_external  [get_bd_pins arp_server_100g_0/clk]
make_bd_pins_external  [get_bd_pins arp_server_100g_0/rst]
make_bd_pins_external  [get_bd_pins ether_protocol_spliter_0/s_axis_data_V]
make_bd_pins_external  [get_bd_pins ether_protocol_spliter_0/s_axis_keep_V]
make_bd_pins_external  [get_bd_pins ether_protocol_spliter_0/s_axis_last_V]
make_bd_pins_external  [get_bd_pins ether_protocol_spliter_0/s_axis_valid_V]
make_bd_pins_external  [get_bd_pins ether_protocol_assembler_0/eth_out_data_V]
make_bd_pins_external  [get_bd_pins ether_protocol_assembler_0/eth_out_keep_V]
make_bd_pins_external  [get_bd_pins ether_protocol_assembler_0/eth_out_valid_V]
make_bd_pins_external  [get_bd_pins ether_protocol_assembler_0/eth_out_last_V]
make_bd_pins_external  [get_bd_pins ether_protocol_assembler_0/eth_out_ready_V]
make_bd_pins_external  [get_bd_pins arp_server_100g_0/gateway]
make_bd_pins_external  [get_bd_pins arp_server_100g_0/myIP]
make_bd_pins_external  [get_bd_pins arp_server_100g_0/myMac]
make_bd_pins_external  [get_bd_pins arp_server_100g_0/netmask]
make_bd_pins_external  [get_bd_pins udp_ip_server_100g_0/local_port_tx]
make_bd_pins_external  [get_bd_pins udp_ip_server_100g_0/remote_ip_tx]
make_bd_pins_external  [get_bd_pins udp_ip_server_100g_0/remote_port_tx]
make_bd_pins_external  [get_bd_pins udp_ip_server_100g_0/local_port_rx]
make_bd_pins_external  [get_bd_pins udp_ip_server_100g_0/remote_ip_rx]
make_bd_pins_external  [get_bd_pins udp_ip_server_100g_0/remote_port_rx]
make_bd_pins_external  [get_bd_pins arp_server_100g_0/arp_status]
make_bd_intf_pins_external  [get_bd_intf_pins udp_ip_server_100g_0/payload_to_user]
make_bd_intf_pins_external  [get_bd_intf_pins udp_ip_server_100g_0/payload_from_user]
foreach port [get_bd_ports *_0] {
        set_property name [regsub "_0" [regsub "/" $port ""] ""] $port
}
foreach port [get_bd_intf_ports *_0] {
        set_property name [regsub "_0" [regsub "/" $port ""] ""] $port
}

set_property CONFIG.POLARITY ACTIVE_HIGH [get_bd_ports rst]

connect_bd_net [get_bd_ports myMac] [get_bd_pins ether_protocol_spliter_0/myMacAddr_V]
connect_bd_net [get_bd_ports myMac] [get_bd_pins udp_ip_server_100g_0/myMac]
connect_bd_net [get_bd_ports myIP] [get_bd_pins udp_ip_server_100g_0/myIP]
connect_bd_net [get_bd_ports clk] [get_bd_pins udp_ip_server_100g_0/clk]
connect_bd_net [get_bd_ports clk] [get_bd_pins ether_protocol_assembler_0/ap_clk]
connect_bd_net [get_bd_ports clk] [get_bd_pins ether_protocol_spliter_0/ap_clk]
connect_bd_net [get_bd_ports clk] [get_bd_pins axis_data_fifo_0/s_aclk]
connect_bd_net [get_bd_ports clk] [get_bd_pins axis_data_fifo_1/s_aclk]
connect_bd_net [get_bd_ports rst] [get_bd_pins util_vector_logic_0/Op1]

connect_bd_net [get_bd_pins util_vector_logic_0/Res] [get_bd_pins axis_data_fifo_0/s_aresetn]
connect_bd_net [get_bd_pins util_vector_logic_0/Res] [get_bd_pins axis_data_fifo_1/s_aresetn]
connect_bd_net [get_bd_ports rst] [get_bd_pins ether_protocol_assembler_0/ap_rst]
connect_bd_net [get_bd_ports rst] [get_bd_pins ether_protocol_spliter_0/ap_rst]
connect_bd_net [get_bd_ports rst] [get_bd_pins udp_ip_server_100g_0/rst]
connect_bd_intf_net [get_bd_intf_pins arp_server_100g_0/arp_out] [get_bd_intf_pins axis_data_fifo_0/S_AXIS]
connect_bd_intf_net [get_bd_intf_pins udp_ip_server_100g_0/packet_m_axis] [get_bd_intf_pins axis_data_fifo_1/S_AXIS]
connect_bd_intf_net [get_bd_intf_pins udp_ip_server_100g_0/arp_internal_resp] [get_bd_intf_pins arp_server_100g_0/arp_internal_resp]
connect_bd_net [get_bd_pins ether_protocol_spliter_0/arp_data_V] [get_bd_pins arp_server_100g_0/arp_in_data]
connect_bd_net [get_bd_pins ether_protocol_spliter_0/arp_valid_V] [get_bd_pins arp_server_100g_0/arp_in_valid]
connect_bd_net [get_bd_pins ether_protocol_spliter_0/ip_data_V] [get_bd_pins udp_ip_server_100g_0/ip_in_data]
connect_bd_net [get_bd_pins ether_protocol_spliter_0/ip_valid_V] [get_bd_pins udp_ip_server_100g_0/ip_in_valid]
connect_bd_net [get_bd_pins ether_protocol_spliter_0/payload_data_V] [get_bd_pins udp_ip_server_100g_0/payload_in_data]
connect_bd_net [get_bd_pins ether_protocol_spliter_0/payload_valid_V] [get_bd_pins udp_ip_server_100g_0/payload_in_valid]
connect_bd_net [get_bd_pins ether_protocol_spliter_0/payload_last_V] [get_bd_pins udp_ip_server_100g_0/payload_in_last]
connect_bd_net [get_bd_pins ether_protocol_spliter_0/payload_len_data_V] [get_bd_pins udp_ip_server_100g_0/payload_length_data]
connect_bd_net [get_bd_pins ether_protocol_spliter_0/payload_len_valid_V] [get_bd_pins udp_ip_server_100g_0/payload_length_valid]
connect_bd_net [get_bd_pins arp_server_100g_0/lookup_result] [get_bd_pins udp_ip_server_100g_0/dst_mac]
connect_bd_net [get_bd_pins arp_server_100g_0/arp_status] [get_bd_pins udp_ip_server_100g_0/arp_status]
connect_bd_net [get_bd_ports remote_ip_tx] [get_bd_pins arp_server_100g_0/lookup_req]
connect_bd_net [get_bd_pins axis_data_fifo_0/m_axis_tvalid] [get_bd_pins ether_protocol_assembler_0/eth_arp_in_valid_V]
connect_bd_net [get_bd_pins axis_data_fifo_0/m_axis_tready] [get_bd_pins ether_protocol_assembler_0/arp_ready_V]
connect_bd_net [get_bd_pins axis_data_fifo_0/m_axis_tdata] [get_bd_pins ether_protocol_assembler_0/eth_arp_in_data_V]
connect_bd_net [get_bd_pins axis_data_fifo_0/m_axis_tkeep] [get_bd_pins ether_protocol_assembler_0/eth_arp_in_keep_V]
connect_bd_net [get_bd_pins axis_data_fifo_0/m_axis_tlast] [get_bd_pins ether_protocol_assembler_0/eth_arp_in_last_V]
connect_bd_net [get_bd_pins axis_data_fifo_1/m_axis_tvalid] [get_bd_pins ether_protocol_assembler_0/eth_ip_in_valid_V]
connect_bd_net [get_bd_pins axis_data_fifo_1/m_axis_tready] [get_bd_pins ether_protocol_assembler_0/ip_ready_V]
connect_bd_net [get_bd_pins axis_data_fifo_1/m_axis_tdata] [get_bd_pins ether_protocol_assembler_0/eth_ip_in_data_V]
connect_bd_net [get_bd_pins axis_data_fifo_1/m_axis_tkeep] [get_bd_pins ether_protocol_assembler_0/eth_ip_in_keep_V]
connect_bd_net [get_bd_pins axis_data_fifo_1/m_axis_tlast] [get_bd_pins ether_protocol_assembler_0/eth_ip_in_last_V]

validate_bd_design
make_wrapper -files [get_files $project_dir/$project_name/${project_name}.srcs/sources_1/bd/${project_name}/${project_name}.bd] -top
add_files -norecurse $project_dir/$project_name/${project_name}.srcs/sources_1/bd/${project_name}/hdl/${project_name}_wrapper.v
save_bd_design

ipx::package_project -root_dir $project_dir/$project_name/${project_name}.srcs/sources_1/bd/${project_name} -vendor Qianfeng_Clark_Shen -library user -taxonomy /UserIP
set_property vendor_display_name {Qianfeng (Clark) Shen} [ipx::current_core]
set_property name $project_name [ipx::current_core]
set_property display_name $project_name [ipx::current_core]
set_property description $project_name [ipx::current_core]

ipx::add_bus_interface m_axis [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:interface:axis_rtl:1.0 [ipx::get_bus_interfaces m_axis -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:interface:axis:1.0 [ipx::get_bus_interfaces m_axis -of_objects [ipx::current_core]]
set_property interface_mode master [ipx::get_bus_interfaces m_axis -of_objects [ipx::current_core]]
set_property display_name m_axis [ipx::get_bus_interfaces m_axis -of_objects [ipx::current_core]]
ipx::add_port_map TDATA [ipx::get_bus_interfaces m_axis -of_objects [ipx::current_core]]
set_property physical_name eth_out_data_V [ipx::get_port_maps TDATA -of_objects [ipx::get_bus_interfaces m_axis -of_objects [ipx::current_core]]]
ipx::add_port_map TLAST [ipx::get_bus_interfaces m_axis -of_objects [ipx::current_core]]
set_property physical_name eth_out_last_V [ipx::get_port_maps TLAST -of_objects [ipx::get_bus_interfaces m_axis -of_objects [ipx::current_core]]]
ipx::add_port_map TVALID [ipx::get_bus_interfaces m_axis -of_objects [ipx::current_core]]
set_property physical_name eth_out_valid_V [ipx::get_port_maps TVALID -of_objects [ipx::get_bus_interfaces m_axis -of_objects [ipx::current_core]]]
ipx::add_port_map TKEEP [ipx::get_bus_interfaces m_axis -of_objects [ipx::current_core]]
set_property physical_name eth_out_keep_V [ipx::get_port_maps TKEEP -of_objects [ipx::get_bus_interfaces m_axis -of_objects [ipx::current_core]]]
ipx::add_port_map TREADY [ipx::get_bus_interfaces m_axis -of_objects [ipx::current_core]]
set_property physical_name eth_out_ready_V [ipx::get_port_maps TREADY -of_objects [ipx::get_bus_interfaces m_axis -of_objects [ipx::current_core]]]

ipx::add_bus_interface s_axis [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:interface:axis_rtl:1.0 [ipx::get_bus_interfaces s_axis -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:interface:axis:1.0 [ipx::get_bus_interfaces s_axis -of_objects [ipx::current_core]]
set_property interface_mode slave [ipx::get_bus_interfaces s_axis -of_objects [ipx::current_core]]
set_property display_name s_axis [ipx::get_bus_interfaces s_axis -of_objects [ipx::current_core]]
ipx::add_port_map TDATA [ipx::get_bus_interfaces s_axis -of_objects [ipx::current_core]]
set_property physical_name s_axis_data_V [ipx::get_port_maps TDATA -of_objects [ipx::get_bus_interfaces s_axis -of_objects [ipx::current_core]]]
ipx::add_port_map TLAST [ipx::get_bus_interfaces s_axis -of_objects [ipx::current_core]]
set_property physical_name s_axis_last_V [ipx::get_port_maps TLAST -of_objects [ipx::get_bus_interfaces s_axis -of_objects [ipx::current_core]]]
ipx::add_port_map TVALID [ipx::get_bus_interfaces s_axis -of_objects [ipx::current_core]]
set_property physical_name s_axis_valid_V [ipx::get_port_maps TVALID -of_objects [ipx::get_bus_interfaces s_axis -of_objects [ipx::current_core]]]
ipx::add_port_map TKEEP [ipx::get_bus_interfaces s_axis -of_objects [ipx::current_core]]
set_property physical_name s_axis_keep_V [ipx::get_port_maps TKEEP -of_objects [ipx::get_bus_interfaces s_axis -of_objects [ipx::current_core]]]

ipx::associate_bus_interfaces -busif payload_from_user -clock clk [ipx::current_core]
ipx::associate_bus_interfaces -busif payload_to_user -clock clk [ipx::current_core]
ipx::associate_bus_interfaces -busif m_axis -clock clk [ipx::current_core]
ipx::associate_bus_interfaces -busif s_axis -clock clk [ipx::current_core]

ipx::remove_bus_interface user_GULF_stream_config [ipx::current_core]

ipx::add_bus_interface meta_rx [ipx::current_core]
set_property abstraction_type_vlnv clarkshen.com:user:GULF_stream_meta_rtl:1.0 [ipx::get_bus_interfaces meta_rx -of_objects [ipx::current_core]]
set_property bus_type_vlnv clarkshen.com:user:GULF_stream_meta:1.0 [ipx::get_bus_interfaces meta_rx -of_objects [ipx::current_core]]
set_property interface_mode master [ipx::get_bus_interfaces meta_rx -of_objects [ipx::current_core]]
set_property display_name meta_rx [ipx::get_bus_interfaces meta_rx -of_objects [ipx::current_core]]
ipx::add_port_map remote_port [ipx::get_bus_interfaces meta_rx -of_objects [ipx::current_core]]
set_property physical_name remote_port_rx [ipx::get_port_maps remote_port -of_objects [ipx::get_bus_interfaces meta_rx -of_objects [ipx::current_core]]]
ipx::add_port_map local_port [ipx::get_bus_interfaces meta_rx -of_objects [ipx::current_core]]
set_property physical_name local_port_rx [ipx::get_port_maps local_port -of_objects [ipx::get_bus_interfaces meta_rx -of_objects [ipx::current_core]]]
ipx::add_port_map remote_ip [ipx::get_bus_interfaces meta_rx -of_objects [ipx::current_core]]
set_property physical_name remote_ip_rx [ipx::get_port_maps remote_ip -of_objects [ipx::get_bus_interfaces meta_rx -of_objects [ipx::current_core]]]

ipx::add_bus_interface meta_tx [ipx::current_core]
set_property abstraction_type_vlnv clarkshen.com:user:GULF_stream_meta_rtl:1.0 [ipx::get_bus_interfaces meta_tx -of_objects [ipx::current_core]]
set_property bus_type_vlnv clarkshen.com:user:GULF_stream_meta:1.0 [ipx::get_bus_interfaces meta_tx -of_objects [ipx::current_core]]
set_property display_name meta_tx [ipx::get_bus_interfaces meta_tx -of_objects [ipx::current_core]]
ipx::add_port_map remote_port [ipx::get_bus_interfaces meta_tx -of_objects [ipx::current_core]]
set_property physical_name remote_port_tx [ipx::get_port_maps remote_port -of_objects [ipx::get_bus_interfaces meta_tx -of_objects [ipx::current_core]]]
ipx::add_port_map local_port [ipx::get_bus_interfaces meta_tx -of_objects [ipx::current_core]]
set_property physical_name local_port_tx [ipx::get_port_maps local_port -of_objects [ipx::get_bus_interfaces meta_tx -of_objects [ipx::current_core]]]
ipx::add_port_map remote_ip [ipx::get_bus_interfaces meta_tx -of_objects [ipx::current_core]]
set_property physical_name remote_ip_tx [ipx::get_port_maps remote_ip -of_objects [ipx::get_bus_interfaces meta_tx -of_objects [ipx::current_core]]]

ipx::add_bus_interface meta_config [ipx::current_core]
set_property abstraction_type_vlnv clarkshen.com:user:GULF_stream_config_rtl:1.0 [ipx::get_bus_interfaces meta_config -of_objects [ipx::current_core]]
set_property bus_type_vlnv clarkshen.com:user:GULF_stream_config:1.0 [ipx::get_bus_interfaces meta_config -of_objects [ipx::current_core]]
set_property interface_mode master [ipx::get_bus_interfaces meta_config -of_objects [ipx::current_core]]
set_property display_name meta_config [ipx::get_bus_interfaces meta_config -of_objects [ipx::current_core]]
set_property interface_mode slave [ipx::get_bus_interfaces meta_config -of_objects [ipx::current_core]]
ipx::add_port_map myIP [ipx::get_bus_interfaces meta_config -of_objects [ipx::current_core]]
set_property physical_name myIP [ipx::get_port_maps myIP -of_objects [ipx::get_bus_interfaces meta_config -of_objects [ipx::current_core]]]
ipx::add_port_map myMac [ipx::get_bus_interfaces meta_config -of_objects [ipx::current_core]]
set_property physical_name myMac [ipx::get_port_maps myMac -of_objects [ipx::get_bus_interfaces meta_config -of_objects [ipx::current_core]]]
ipx::add_port_map netmask [ipx::get_bus_interfaces meta_config -of_objects [ipx::current_core]]
set_property physical_name netmask [ipx::get_port_maps netmask -of_objects [ipx::get_bus_interfaces meta_config -of_objects [ipx::current_core]]]
ipx::add_port_map gateway [ipx::get_bus_interfaces meta_config -of_objects [ipx::current_core]]
set_property physical_name gateway [ipx::get_port_maps gateway -of_objects [ipx::get_bus_interfaces meta_config -of_objects [ipx::current_core]]]

set_property core_revision 2 [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
set_property ip_repo_paths [list "$project_dir" "${project_dir}/../hls_ips"] [current_project]
update_ip_catalog
ipx::check_integrity -quiet [ipx::current_core]
ipx::archive_core $project_dir/$project_name/${project_name}.srcs/sources_1/bd/${project_name}/${project_name}_1.0.zip [ipx::current_core]
close_project
exit
