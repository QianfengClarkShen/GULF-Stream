set project_dir [file dirname [file dirname [file normalize [info script]]]]
set project_name "benchmark"
set script_dir [file dirname [file normalize [info script]]]
source $script_dir/util.tcl

create_project $project_name $project_dir/$project_name -part xczu19eg-ffvc1760-2-i
set_property board_part fidus.com:sidewinder100:part0:1.0 [current_project]
create_bd_design $project_name
set_property ip_repo_paths "${project_dir}/../ip_repo" [current_project]
update_ip_catalog -rebuild
#make 100g ethernet core hireachy
create_bd_cell -type hier eth_100g
addip cmac_usplus eth_100g/cmac_usplus_0
set_property -dict [list CONFIG.CMAC_CAUI4_MODE {1} CONFIG.NUM_LANES {4} CONFIG.GT_REF_CLK_FREQ {322.265625} CONFIG.GT_DRP_CLK {200.0} CONFIG.RX_CHECK_PREAMBLE {1} CONFIG.RX_CHECK_SFD {1} CONFIG.TX_FLOW_CONTROL {0} CONFIG.RX_FLOW_CONTROL {0} CONFIG.ENABLE_AXI_INTERFACE {0} CONFIG.CMAC_CORE_SELECT {CMACE4_X0Y1} CONFIG.GT_GROUP_SELECT {X0Y12~X0Y15} CONFIG.LANE1_GT_LOC {X0Y12} CONFIG.LANE2_GT_LOC {X0Y13} CONFIG.LANE3_GT_LOC {X0Y14} CONFIG.LANE4_GT_LOC {X0Y15} CONFIG.LANE5_GT_LOC {NA} CONFIG.LANE6_GT_LOC {NA} CONFIG.LANE7_GT_LOC {NA} CONFIG.LANE8_GT_LOC {NA} CONFIG.LANE9_GT_LOC {NA} CONFIG.LANE10_GT_LOC {NA}] [get_bd_cells eth_100g/cmac_usplus_0]
addip util_ds_buf eth_100g/util_ds_buf_0

addip xlconstant eth_100g/zero
addip xlconstant eth_100g/one
addip xlconstant eth_100g/zeroX10
addip xlconstant eth_100g/zeroX12
addip xlconstant eth_100g/zeroX16
addip xlconstant eth_100g/zeroX56
set_property -dict [list CONFIG.CONST_VAL {0}] [get_bd_cells eth_100g/zero]
set_property -dict [list CONFIG.CONST_WIDTH {16} CONFIG.CONST_VAL {0}] [get_bd_cells eth_100g/zeroX16]
set_property -dict [list CONFIG.CONST_WIDTH {56} CONFIG.CONST_VAL {0}] [get_bd_cells eth_100g/zeroX56]
set_property -dict [list CONFIG.CONST_WIDTH {12} CONFIG.CONST_VAL {0}] [get_bd_cells eth_100g/zeroX12]
set_property -dict [list CONFIG.CONST_WIDTH {10} CONFIG.CONST_VAL {0}] [get_bd_cells eth_100g/zeroX10]

addip lbus_axis_converter eth_100g/lbus_axis_converter_0

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
#
addip GULF_Stream GULF_Stream_0
set_property -dict [list CONFIG.HAS_AXIL {true}] [get_bd_cells GULF_Stream_0]
connect_bd_intf_net [get_bd_intf_pins GULF_Stream_0/m_axis] [get_bd_intf_pins eth_100g/lbus_axis_converter_0/s_axis]
connect_bd_intf_net [get_bd_intf_pins GULF_Stream_0/s_axis] [get_bd_intf_pins eth_100g/lbus_axis_converter_0/m_axis]
connect_bd_net [get_bd_pins GULF_Stream_0/clk] [get_bd_pins eth_100g/cmac_usplus_0/gt_txusrclk2]

addip zynq_ultra_ps_e zynq_ultra_ps_e_0
source $script_dir/ps_preset.tcl
set_property -dict [apply_preset zynq_ultra_ps_e_0] [get_bd_cells zynq_ultra_ps_e_0]
set_property -dict [list CONFIG.PSU__USE__S_AXI_GP2 {0}] [get_bd_cells zynq_ultra_ps_e_0]

addip proc_sys_reset proc_sys_reset_0
addip axi_interconnect axi_interconnect_0
addip GULF_Stream_benchmark GULF_Stream_benchmark_0
connect_bd_net [get_bd_pins eth_100g/gt_txusrclk2] [get_bd_pins axi_interconnect_0/ACLK] -boundary_type upper
connect_bd_net [get_bd_pins eth_100g/gt_txusrclk2] [get_bd_pins axi_interconnect_0/S00_ACLK] -boundary_type upper
connect_bd_net [get_bd_pins eth_100g/gt_txusrclk2] [get_bd_pins axi_interconnect_0/M00_ACLK] -boundary_type upper
connect_bd_net [get_bd_pins eth_100g/gt_txusrclk2] [get_bd_pins axi_interconnect_0/M01_ACLK] -boundary_type upper
connect_bd_net [get_bd_pins eth_100g/gt_txusrclk2] [get_bd_pins GULF_Stream_benchmark_0/clk]
connect_bd_net [get_bd_pins eth_100g/gt_txusrclk2] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
connect_bd_net [get_bd_pins eth_100g/gt_txusrclk2] [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk]

connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] [get_bd_pins proc_sys_reset_0/ext_reset_in]
connect_bd_net [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins axi_interconnect_0/ARESETN]
connect_bd_net [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins axi_interconnect_0/S00_ARESETN]
connect_bd_net [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins axi_interconnect_0/M00_ARESETN]
connect_bd_net [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins axi_interconnect_0/M01_ARESETN]
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_reset] [get_bd_pins GULF_Stream_0/rst]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins GULF_Stream_0/s_axictl]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/M01_AXI] [get_bd_intf_pins GULF_Stream_benchmark_0/AXILITE_Config]
connect_bd_intf_net [get_bd_intf_pins GULF_Stream_benchmark_0/payload_m_axis] [get_bd_intf_pins GULF_Stream_0/payload_from_user]
connect_bd_intf_net [get_bd_intf_pins GULF_Stream_0/payload_to_user] [get_bd_intf_pins GULF_Stream_benchmark_0/payload_s_axis]

addip xlconstant port_num
set_property -dict [list CONFIG.CONST_WIDTH {16}] [get_bd_cells port_num]
connect_bd_net [get_bd_pins port_num/dout] [get_bd_pins GULF_Stream_0/remote_port_tx]
connect_bd_net [get_bd_pins port_num/dout] [get_bd_pins GULF_Stream_0/local_port_tx]
addip xlconstant remote_ip
set_property -dict [list CONFIG.CONST_WIDTH {32} CONFIG.CONST_VAL {0x0a0a0ef0}] [get_bd_cells remote_ip]
connect_bd_net [get_bd_pins remote_ip/dout] [get_bd_pins GULF_Stream_0/remote_ip_tx]


set_property name init [get_bd_intf_ports CLK_IN_D_0]
set_property name gt_ref [get_bd_intf_ports gt_ref_clk_0]
set_property CONFIG.FREQ_HZ 200000000 [get_bd_intf_ports /init]
add_files -fileset constrs_1 -norecurse $project_dir/constraints/sidewinder100.xdc
assign_bd_address
validate_bd_design
make_wrapper -files [get_files $project_dir/$project_name/${project_name}.srcs/sources_1/bd/${project_name}/${project_name}.bd] -top
add_files -norecurse $project_dir/$project_name/${project_name}.srcs/sources_1/bd/${project_name}/hdl/${project_name}_wrapper.v
save_bd_design
return
close_project
exit
