##ArtyZ7 Timing

# define clock and period - 20Mhz
create_clock -period 50.000 -name clk_pin -waveform {0.000 4.000} [get_ports clk_pin]

# Create a virtual clock for IO constraints - 40Mhz 
create_clock -period 25.000 -name virtual_clock

#set_input_delay -clock virtual_clock -max 0.000 [get_ports rst_pin]
#set_input_delay -clock virtual_clock -min -0.500 [get_ports rst_pin]

#set_input_delay -clock virtual_clock -max 0.000 [get_ports btn_pin]
#set_input_delay -clock virtual_clock -min -0.500 [get_ports btn_pin]

#output delay
#set_output_delay -clock virtual_clock 0.000 [get_ports {led_pins[*]}]