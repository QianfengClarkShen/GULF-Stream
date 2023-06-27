# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ENABLE_ILKN_PORTS" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "ENDIANNESS" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "RX_INPUT_REG" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TX_OUTPUT_REG" -parent ${Page_0}


}

proc update_PARAM_VALUE.ENABLE_ILKN_PORTS { PARAM_VALUE.ENABLE_ILKN_PORTS } {
	# Procedure called to update ENABLE_ILKN_PORTS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENABLE_ILKN_PORTS { PARAM_VALUE.ENABLE_ILKN_PORTS } {
	# Procedure called to validate ENABLE_ILKN_PORTS
	return true
}

proc update_PARAM_VALUE.ENDIANNESS { PARAM_VALUE.ENDIANNESS } {
	# Procedure called to update ENDIANNESS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ENDIANNESS { PARAM_VALUE.ENDIANNESS } {
	# Procedure called to validate ENDIANNESS
	return true
}

proc update_PARAM_VALUE.RX_INPUT_REG { PARAM_VALUE.RX_INPUT_REG } {
	# Procedure called to update RX_INPUT_REG when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RX_INPUT_REG { PARAM_VALUE.RX_INPUT_REG } {
	# Procedure called to validate RX_INPUT_REG
	return true
}

proc update_PARAM_VALUE.TX_OUTPUT_REG { PARAM_VALUE.TX_OUTPUT_REG } {
	# Procedure called to update TX_OUTPUT_REG when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TX_OUTPUT_REG { PARAM_VALUE.TX_OUTPUT_REG } {
	# Procedure called to validate TX_OUTPUT_REG
	return true
}


proc update_MODELPARAM_VALUE.ENDIANNESS { MODELPARAM_VALUE.ENDIANNESS PARAM_VALUE.ENDIANNESS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENDIANNESS}] ${MODELPARAM_VALUE.ENDIANNESS}
}

proc update_MODELPARAM_VALUE.ENABLE_ILKN_PORTS { MODELPARAM_VALUE.ENABLE_ILKN_PORTS PARAM_VALUE.ENABLE_ILKN_PORTS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ENABLE_ILKN_PORTS}] ${MODELPARAM_VALUE.ENABLE_ILKN_PORTS}
}

proc update_MODELPARAM_VALUE.TX_OUTPUT_REG { MODELPARAM_VALUE.TX_OUTPUT_REG PARAM_VALUE.TX_OUTPUT_REG } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TX_OUTPUT_REG}] ${MODELPARAM_VALUE.TX_OUTPUT_REG}
}

proc update_MODELPARAM_VALUE.RX_INPUT_REG { MODELPARAM_VALUE.RX_INPUT_REG PARAM_VALUE.RX_INPUT_REG } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RX_INPUT_REG}] ${MODELPARAM_VALUE.RX_INPUT_REG}
}

