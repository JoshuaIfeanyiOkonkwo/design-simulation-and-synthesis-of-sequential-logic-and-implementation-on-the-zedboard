# Clock signal
#set_property PACKAGE_PIN Y9 [get_ports {clk}]
#set_property IOSTANDARD LVCMOS33 [get_ports {clk}]
set_property PACKAGE_PIN Y9 [get_ports {CLK_100MHz}]
set_property IOSTANDARD LVCMOS33 [get_ports {CLK_100MHz}]

# Reset signal
set_property PACKAGE_PIN F22 [get_ports {SW_ARST_N}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW_ARST_N}]

# Enable signal
set_property PACKAGE_PIN G22 [get_ports {SW_ENABLE}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW_ENABLE}]

# Direction signal
set_property PACKAGE_PIN H22 [get_ports {SW_DIR}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW_DIR}]

# Load signal
set_property PACKAGE_PIN F21 [get_ports {SW_LOAD}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW_LOAD}]

# Data input (4-bit)
set_property PACKAGE_PIN H19 [get_ports {SW_DATA[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW_DATA[3]}]

set_property PACKAGE_PIN H18 [get_ports {SW_DATA[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW_DATA[2]}]

set_property PACKAGE_PIN H17 [get_ports {SW_DATA[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW_DATA[1]}]

set_property PACKAGE_PIN H15 [get_ports {SW_DATA[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW_DATA[0]}]

# Count output (4-bit)
set_property PACKAGE_PIN T22 [get_ports {LED_COUNT[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_COUNT[3]}]

set_property PACKAGE_PIN T21 [get_ports {LED_COUNT[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_COUNT[2]}]

set_property PACKAGE_PIN U22 [get_ports {LED_COUNT[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_COUNT[1]}]

set_property PACKAGE_PIN U21 [get_ports {LED_COUNT[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_COUNT[0]}]

# Overflow signal
set_property PACKAGE_PIN W22 [get_ports {LED_OVER}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_OVER}]
