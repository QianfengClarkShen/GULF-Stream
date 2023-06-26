proc addip {ipName displayName} {
#find the latest version of an IP
    set vlnv_version_independent [lindex [get_ipdefs -all -filter "NAME == ${ipName} && UPGRADE_VERSIONS == \"\""] end]
    return [create_bd_cell -type ip -vlnv $vlnv_version_independent $displayName]
}

set script_folder [file dirname [file normalize [info script]]]

# CHANGE DESIGN NAME HERE
variable design_name
set design_name loopback_server

create_bd_design $design_name

current_bd_design $design_name


##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: eth_100g
proc create_hier_cell_eth_100g { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 gt_ref_clk

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 CLK_IN_D_0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 gt_serial_port


  # Create pins
  create_bd_pin -dir O -type clk gt_txusrclk2

  # Create instance: cmac_usplus_0, and set properties
  set cmac_usplus_0 [ addip cmac_usplus cmac_usplus_0 ]
  set_property -dict [list \
    CONFIG.CMAC_CAUI4_MODE {1} \
    CONFIG.CMAC_CORE_SELECT {CMACE4_X0Y1} \
    CONFIG.ENABLE_AXI_INTERFACE {0} \
    CONFIG.GT_DRP_CLK {200.0} \
    CONFIG.GT_GROUP_SELECT {X0Y12~X0Y15} \
    CONFIG.GT_REF_CLK_FREQ {322.265625} \
    CONFIG.NUM_LANES {4x25} \
    CONFIG.RX_CHECK_PREAMBLE {1} \
    CONFIG.RX_CHECK_SFD {1} \
    CONFIG.RX_FLOW_CONTROL {0} \
    CONFIG.TX_FLOW_CONTROL {0} \
  ] $cmac_usplus_0


  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ addip util_ds_buf util_ds_buf_0 ]

  # Create instance: zero, and set properties
  set zero [ addip xlconstant zero ]
  set_property CONFIG.CONST_VAL {0} $zero


  # Create instance: one, and set properties
  set one [ addip xlconstant one ]

  # Create instance: zeroX10, and set properties
  set zeroX10 [ addip xlconstant zeroX10 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {10} \
  ] $zeroX10


  # Create instance: zeroX12, and set properties
  set zeroX12 [ addip xlconstant zeroX12 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {12} \
  ] $zeroX12


  # Create instance: zeroX16, and set properties
  set zeroX16 [ addip xlconstant zeroX16 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {16} \
  ] $zeroX16


  # Create instance: zeroX56, and set properties
  set zeroX56 [ addip xlconstant zeroX56 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0} \
    CONFIG.CONST_WIDTH {56} \
  ] $zeroX56


  # Create instance: lbus_axis_converter_0, and set properties
  set lbus_axis_converter_0 [ addip lbus_axis_converter lbus_axis_converter_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins cmac_usplus_0/gt_ref_clk] [get_bd_intf_pins gt_ref_clk]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins util_ds_buf_0/CLK_IN_D] [get_bd_intf_pins CLK_IN_D_0]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins lbus_axis_converter_0/s_axis] [get_bd_intf_pins s_axis]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins lbus_axis_converter_0/m_axis] [get_bd_intf_pins m_axis]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins cmac_usplus_0/gt_serial_port] [get_bd_intf_pins gt_serial_port]
  connect_bd_intf_net -intf_net cmac_usplus_0_lbus_rx [get_bd_intf_pins lbus_axis_converter_0/cmac_lbus_rx] [get_bd_intf_pins cmac_usplus_0/lbus_rx]
  connect_bd_intf_net -intf_net lbus_axis_converter_0_cmac_lbus_tx [get_bd_intf_pins lbus_axis_converter_0/cmac_lbus_tx] [get_bd_intf_pins cmac_usplus_0/lbus_tx]

  # Create port connections
  connect_bd_net -net cmac_usplus_0_gt_txusrclk2 [get_bd_pins cmac_usplus_0/gt_txusrclk2] [get_bd_pins cmac_usplus_0/rx_clk] [get_bd_pins gt_txusrclk2] [get_bd_pins lbus_axis_converter_0/rx_clk] [get_bd_pins lbus_axis_converter_0/tx_clk]
  connect_bd_net -net one_dout [get_bd_pins one/dout] [get_bd_pins cmac_usplus_0/ctl_tx_enable] [get_bd_pins cmac_usplus_0/ctl_rx_enable]
  connect_bd_net -net util_ds_buf_0_IBUF_OUT [get_bd_pins util_ds_buf_0/IBUF_OUT] [get_bd_pins cmac_usplus_0/init_clk]
  connect_bd_net -net zeroX10_dout [get_bd_pins zeroX10/dout] [get_bd_pins cmac_usplus_0/drp_addr]
  connect_bd_net -net zeroX12_dout [get_bd_pins zeroX12/dout] [get_bd_pins cmac_usplus_0/gt_loopback_in]
  connect_bd_net -net zeroX16_dout [get_bd_pins zeroX16/dout] [get_bd_pins cmac_usplus_0/drp_di]
  connect_bd_net -net zeroX56_dout [get_bd_pins zeroX56/dout] [get_bd_pins cmac_usplus_0/tx_preamblein]
  connect_bd_net -net zero_dout [get_bd_pins zero/dout] [get_bd_pins cmac_usplus_0/sys_reset] [get_bd_pins cmac_usplus_0/drp_clk] [get_bd_pins cmac_usplus_0/core_drp_reset] [get_bd_pins cmac_usplus_0/core_tx_reset] [get_bd_pins cmac_usplus_0/core_rx_reset] [get_bd_pins cmac_usplus_0/ctl_tx_test_pattern] [get_bd_pins cmac_usplus_0/ctl_tx_send_idle] [get_bd_pins cmac_usplus_0/ctl_tx_send_rfi] [get_bd_pins cmac_usplus_0/ctl_tx_send_lfi] [get_bd_pins cmac_usplus_0/ctl_rx_force_resync] [get_bd_pins cmac_usplus_0/ctl_rx_test_pattern] [get_bd_pins cmac_usplus_0/drp_we] [get_bd_pins cmac_usplus_0/drp_en] [get_bd_pins cmac_usplus_0/gtwiz_reset_tx_datapath] [get_bd_pins cmac_usplus_0/gtwiz_reset_rx_datapath] [get_bd_pins lbus_axis_converter_0/rx_rst] [get_bd_pins lbus_axis_converter_0/tx_rst]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set gt_ref [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 gt_ref ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {322265625} \
   ] $gt_ref

  set init [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 init ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200000000} \
   ] $init

  set gt_serial_port [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 gt_serial_port ]


  # Create ports

  # Create instance: eth_100g
  create_hier_cell_eth_100g [current_bd_instance .] eth_100g

  # Create instance: GULF_Stream_0, and set properties
  set GULF_Stream_0 [ addip GULF_Stream GULF_Stream_0 ]
  set_property CONFIG.HAS_AXIL {false} $GULF_Stream_0


  # Create instance: rst, and set properties
  set rst [ addip xlconstant rst ]
  set_property CONFIG.CONST_VAL {0} $rst


  # Create interface connections
  connect_bd_intf_net -intf_net CLK_IN_D_0_1 [get_bd_intf_ports init] [get_bd_intf_pins eth_100g/CLK_IN_D_0]
  connect_bd_intf_net -intf_net GULF_Stream_0_m_axis [get_bd_intf_pins GULF_Stream_0/m_axis] [get_bd_intf_pins eth_100g/s_axis]
  connect_bd_intf_net -intf_net GULF_Stream_0_meta_rx [get_bd_intf_pins GULF_Stream_0/meta_rx] [get_bd_intf_pins GULF_Stream_0/meta_tx]
  connect_bd_intf_net -intf_net GULF_Stream_0_payload_to_user [get_bd_intf_pins GULF_Stream_0/payload_to_user] [get_bd_intf_pins GULF_Stream_0/payload_from_user]
  connect_bd_intf_net -intf_net eth_100g_gt_serial_port_0 [get_bd_intf_ports gt_serial_port] [get_bd_intf_pins eth_100g/gt_serial_port]
  connect_bd_intf_net -intf_net eth_100g_m_axis [get_bd_intf_pins GULF_Stream_0/s_axis] [get_bd_intf_pins eth_100g/m_axis]
  connect_bd_intf_net -intf_net gt_ref_clk_0_1 [get_bd_intf_ports gt_ref] [get_bd_intf_pins eth_100g/gt_ref_clk]

  # Create port connections
  connect_bd_net -net eth_100g_gt_txusrclk2 [get_bd_pins eth_100g/gt_txusrclk2] [get_bd_pins GULF_Stream_0/clk]
  connect_bd_net -net rst_dout [get_bd_pins rst/dout] [get_bd_pins GULF_Stream_0/rst]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


