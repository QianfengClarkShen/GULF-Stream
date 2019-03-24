create_clock -period 5.000 [get_ports init_clk_p]
set_property PACKAGE_PIN N13 [get_ports init_clk_p]
set_property PACKAGE_PIN M13 [get_ports init_clk_n]
set_property IOSTANDARD LVDS_25 [get_ports init_clk_p]
set_property IOSTANDARD LVDS_25 [get_ports init_clk_n]

create_clock -period 3.103 [get_ports gt_ref_clk_n]
set_property PACKAGE_PIN R32 [get_ports gt_ref_clk_p]
set_property PACKAGE_PIN R33 [get_ports gt_ref_clk_n]
