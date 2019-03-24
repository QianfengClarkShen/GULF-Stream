set project_dir [file dirname [file dirname [file normalize [info script]]]]
set project_name "loopback_server"
create_project $project_name $project_dir/$project_name -part xczu19eg-ffvc1760-2-i
set_property board_part fidus.com:sidewinder100:part0:1.0 [current_project]
create_bd_design $project_name

set_property ip_repo_paths "${project_dir}/../ip_repo" [current_project]
update_ip_catalog -rebuild

#make 100g ethernet core hireachy
create_bd_cell -type hier eth_100g
create_bd_cell -type ip -vlnv xilinx.com:ip:cmac_usplus:2.4 eth_100g/cmac_usplus_0
set_property -dict [list CONFIG.CMAC_CAUI4_MODE {1} CONFIG.NUM_LANES {4} CONFIG.GT_REF_CLK_FREQ {322.265625} CONFIG.GT_DRP_CLK {200.0} CONFIG.RX_CHECK_PREAMBLE {1} CONFIG.RX_CHECK_SFD {1} CONFIG.TX_FLOW_CONTROL {0} CONFIG.RX_FLOW_CONTROL {0} CONFIG.ENABLE_AXI_INTERFACE {0} CONFIG.CMAC_CORE_SELECT {CMACE4_X0Y1} CONFIG.GT_GROUP_SELECT {X0Y12~X0Y15} CONFIG.LANE1_GT_LOC {X0Y12} CONFIG.LANE2_GT_LOC {X0Y13} CONFIG.LANE3_GT_LOC {X0Y14} CONFIG.LANE4_GT_LOC {X0Y15} CONFIG.LANE5_GT_LOC {NA} CONFIG.LANE6_GT_LOC {NA} CONFIG.LANE7_GT_LOC {NA} CONFIG.LANE8_GT_LOC {NA} CONFIG.LANE9_GT_LOC {NA} CONFIG.LANE10_GT_LOC {NA}] [get_bd_cells eth_100g/cmac_usplus_0]
create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 eth_100g/util_ds_buf_0

create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 eth_100g/zero
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 eth_100g/one
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 eth_100g/zeroX10
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 eth_100g/zeroX12
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 eth_100g/zeroX16
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 eth_100g/zeroX56
set_property -dict [list CONFIG.CONST_VAL {0}] [get_bd_cells eth_100g/zero]
set_property -dict [list CONFIG.CONST_WIDTH {16} CONFIG.CONST_VAL {0}] [get_bd_cells eth_100g/zeroX16]
set_property -dict [list CONFIG.CONST_WIDTH {56} CONFIG.CONST_VAL {0}] [get_bd_cells eth_100g/zeroX56]
set_property -dict [list CONFIG.CONST_WIDTH {12} CONFIG.CONST_VAL {0}] [get_bd_cells eth_100g/zeroX12]
set_property -dict [list CONFIG.CONST_WIDTH {10} CONFIG.CONST_VAL {0}] [get_bd_cells eth_100g/zeroX10]

create_bd_cell -type ip -vlnv Qianfeng_Clark_Shen:user:lbus_axis_converter:1.0 eth_100g/lbus_axis_converter_0

make_bd_intf_pins_external  [get_bd_intf_pins eth_100g/cmac_usplus_0/gt_ref_clk]
make_bd_intf_pins_external  [get_bd_intf_pins eth_100g/cmac_usplus_0/gt_serial_port]
make_bd_intf_pins_external  [get_bd_intf_pins eth_100g/util_ds_buf_0/CLK_IN_D]

connect_bd_intf_net [get_bd_intf_pins eth_100g/lbus_axis_converter_0/lbus_tx] [get_bd_intf_pins eth_100g/cmac_usplus_0/lbus_tx]
connect_bd_intf_net [get_bd_intf_pins eth_100g/lbus_axis_converter_0/lbus_rx] [get_bd_intf_pins eth_100g/cmac_usplus_0/lbus_rx]
connect_bd_net [get_bd_pins eth_100g/cmac_usplus_0/gt_txusrclk2] [get_bd_pins eth_100g/cmac_usplus_0/rx_clk]
connect_bd_net [get_bd_pins eth_100g/cmac_usplus_0/gt_txusrclk2] [get_bd_pins eth_100g/lbus_axis_converter_0/clk]
connect_bd_net [get_bd_pins eth_100g/util_ds_buf_0/IBUF_OUT] [get_bd_pins eth_100g/cmac_usplus_0/init_clk]
connect_bd_net [get_bd_pins eth_100g/zero/dout] [get_bd_pins eth_100g/lbus_axis_converter_0/rst]
connect_bd_net [get_bd_pins eth_100g/zero/dout] [get_bd_pins eth_100g/cmac_usplus_0/sys_reset]
connect_bd_net [get_bd_pins eth_100g/zero/dout] [get_bd_pins eth_100g/cmac_usplus_0/drp_clk]
connect_bd_net [get_bd_pins eth_100g/zero/dout] [get_bd_pins eth_100g/cmac_usplus_0/core_drp_reset]
connect_bd_net [get_bd_pins eth_100g/zero/dout] [get_bd_pins eth_100g/cmac_usplus_0/core_tx_reset]
connect_bd_net [get_bd_pins eth_100g/zero/dout] [get_bd_pins eth_100g/cmac_usplus_0/core_rx_reset]
connect_bd_net [get_bd_pins eth_100g/zero/dout] [get_bd_pins eth_100g/cmac_usplus_0/ctl_tx_test_pattern]
connect_bd_net [get_bd_pins eth_100g/zero/dout] [get_bd_pins eth_100g/cmac_usplus_0/ctl_tx_send_idle]
connect_bd_net [get_bd_pins eth_100g/zero/dout] [get_bd_pins eth_100g/cmac_usplus_0/ctl_tx_send_rfi]
connect_bd_net [get_bd_pins eth_100g/zero/dout] [get_bd_pins eth_100g/cmac_usplus_0/ctl_tx_send_lfi]
connect_bd_net [get_bd_pins eth_100g/zero/dout] [get_bd_pins eth_100g/cmac_usplus_0/ctl_rx_force_resync]
connect_bd_net [get_bd_pins eth_100g/zero/dout] [get_bd_pins eth_100g/cmac_usplus_0/ctl_rx_test_pattern]
connect_bd_net [get_bd_pins eth_100g/zero/dout] [get_bd_pins eth_100g/cmac_usplus_0/drp_we]
connect_bd_net [get_bd_pins eth_100g/zero/dout] [get_bd_pins eth_100g/cmac_usplus_0/drp_en]
connect_bd_net [get_bd_pins eth_100g/zero/dout] [get_bd_pins eth_100g/cmac_usplus_0/gtwiz_reset_tx_datapath]
connect_bd_net [get_bd_pins eth_100g/zero/dout] [get_bd_pins eth_100g/cmac_usplus_0/gtwiz_reset_rx_datapath]

connect_bd_net [get_bd_pins eth_100g/one/dout] [get_bd_pins eth_100g/cmac_usplus_0/ctl_tx_enable]
connect_bd_net [get_bd_pins eth_100g/one/dout] [get_bd_pins eth_100g/cmac_usplus_0/ctl_rx_enable]

connect_bd_net [get_bd_pins eth_100g/zeroX10/dout] [get_bd_pins eth_100g/cmac_usplus_0/drp_addr]
connect_bd_net [get_bd_pins eth_100g/zeroX12/dout] [get_bd_pins eth_100g/cmac_usplus_0/gt_loopback_in]
connect_bd_net [get_bd_pins eth_100g/zeroX16/dout] [get_bd_pins eth_100g/cmac_usplus_0/drp_di]
connect_bd_net [get_bd_pins eth_100g/zeroX56/dout] [get_bd_pins eth_100g/cmac_usplus_0/tx_preamblein]
##################

#make loopback GULF stream
create_bd_cell -type ip -vlnv Qianfeng_Clark_Shen:user:GULF_Stream:1.0 GULF_Stream_0
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 rst
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 ip
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 gateway
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 netmask
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 mac
set_property -dict [list CONFIG.CONST_VAL {0}] [get_bd_cells rst]
set_property -dict [list CONFIG.CONST_WIDTH {32} CONFIG.CONST_VAL {0x0a0a0ef0}] [get_bd_cells ip]
set_property -dict [list CONFIG.CONST_WIDTH {32} CONFIG.CONST_VAL {0x0a0a0e0a}] [get_bd_cells gateway]
set_property -dict [list CONFIG.CONST_WIDTH {32} CONFIG.CONST_VAL {0xffffff00}] [get_bd_cells netmask]
set_property -dict [list CONFIG.CONST_WIDTH {48} CONFIG.CONST_VAL {0x203ab490c564}] [get_bd_cells mac]

connect_bd_intf_net [get_bd_intf_pins GULF_Stream_0/m_axis] [get_bd_intf_pins eth_100g/lbus_axis_converter_0/s_axis]
connect_bd_intf_net [get_bd_intf_pins GULF_Stream_0/s_axis] [get_bd_intf_pins eth_100g/lbus_axis_converter_0/m_axis]
connect_bd_net [get_bd_pins GULF_Stream_0/clk] [get_bd_pins eth_100g/cmac_usplus_0/gt_txusrclk2]
connect_bd_intf_net [get_bd_intf_pins GULF_Stream_0/meta_rx] [get_bd_intf_pins GULF_Stream_0/meta_tx]
connect_bd_intf_net [get_bd_intf_pins GULF_Stream_0/payload_to_user] [get_bd_intf_pins GULF_Stream_0/payload_from_user]
connect_bd_net [get_bd_pins ip/dout] [get_bd_pins GULF_Stream_0/myIP]
connect_bd_net [get_bd_pins mac/dout] [get_bd_pins GULF_Stream_0/myMac]
connect_bd_net [get_bd_pins rst/dout] [get_bd_pins GULF_Stream_0/rst]
connect_bd_net [get_bd_pins gateway/dout] [get_bd_pins GULF_Stream_0/gateway]
connect_bd_net [get_bd_pins netmask/dout] [get_bd_pins GULF_Stream_0/netmask]
###########

set_property name init [get_bd_intf_ports CLK_IN_D_0]
set_property name gt_ref [get_bd_intf_ports gt_ref_clk_0]
set_property CONFIG.FREQ_HZ 200000000 [get_bd_intf_ports /init]
add_files -fileset constrs_1 -norecurse /home/owl/src/GULF_Stream/examples/loopback_server.xdc

validate_bd_design
make_wrapper -files [get_files $project_dir/$project_name/${project_name}.srcs/sources_1/bd/${project_name}/${project_name}.bd] -top
add_files -norecurse $project_dir/$project_name/${project_name}.srcs/sources_1/bd/${project_name}/hdl/${project_name}_wrapper.v
save_bd_design
close_project
exit
