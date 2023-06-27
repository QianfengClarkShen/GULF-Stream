proc init { cell_name undefined_params } {}

proc post_config_ip { cell_name args } {
    set ip [get_bd_cells $cell_name]
    set tx_interfaces_str "m_axis"
    set rx_interfaces_str "s_axis"
    set TYPE [get_property CONFIG.ENABLE_ILKN_PORTS $ip]
    if { $TYPE == 0 } {
        set tx_interfaces_str "$tx_interfaces_str:cmac_lbus_tx"
        set rx_interfaces_str "$rx_interfaces_str:cmac_lbus_rx"
    } else {
        set tx_interfaces_str "$tx_interfaces_str:inkl_lbus_tx"
        set rx_interfaces_str "$rx_interfaces_str:lnkl_lbus_rx"
    }
    set_property CONFIG.ASSOCIATED_BUSIF "$tx_interfaces_str" [get_bd_pins $ip/tx_clk]
    set_property CONFIG.ASSOCIATED_BUSIF "$rx_interfaces_str" [get_bd_pins $ip/rx_clk]
    set_property CONFIG.POLARITY {ACTIVE_HIGH} [get_bd_pins $ip/tx_rst]
    set_property CONFIG.POLARITY {ACTIVE_HIGH} [get_bd_pins $ip/rx_rst]
}

proc propagate { cell_name prop_info } {}
