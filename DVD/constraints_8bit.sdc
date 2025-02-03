current_design counter // replace "counter" module with actual module name

create_clock -name "clk" -add -period 16.0 -waveform {0.0 8.0} [get_ports clk] //clk is argument in counter module
set_input_delay -clock [get_clocks clk] -add_delay 0.4 [get_ports rst] //rst is argument in counter module
set_output_delay -clock [get_clocks clk] -add_delay 0.4 [get_ports count] // count is a argument in counter module
