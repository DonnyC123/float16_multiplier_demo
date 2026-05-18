
set_db init_hdl_search_path { . rtl_pipe }
read_hdl [list \
    float16_decoder.v \
    leading_zero_counter.v \
    product_normalizer.v \
    product_rounder.v \
    float16_multiplier.v \
]

set_db library /vol/ece303/genus_tutorial/NangateOpenCellLibrary_typical.lib
set_db lef_library /vol/ece303/genus_tutorial/NangateOpenCellLibrary.lef

elaborate float16_multiplier
check_design float16_multiplier

# Set timing requirements
create_clock -name clk -period 1.0 [get_ports clk]
set_input_delay      0.2 -clock clk [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay     0.2 -clock clk [all_outputs]
set_input_transition 0.1            [remove_from_collection [all_inputs] [get_ports clk]]

# Assume 50fF load capacitances as outputs
set_load 0.050 [all_outputs]

# Set 10fF maximum capacitance on all inputs
set_max_capacitance 0.010 [all_inputs]


set_db auto_ungroup both

# Set syn effort low
set_db syn_opt_effort     low
set_db syn_generic_effort low
set_db syn_map_effort     low

# Run synthesis
syn_generic
syn_map
syn_opt

# Save outputs
report_timing > synth_pipe_low/timing.rpt
report_area   > synth_pipe_low/area.rpt
report_gates  > synth_pipe_low/gates.rpt
report_power  > synth_pipe_low/power.rpt

write_hdl > synth_pipe_low/float16_multiplier.v
write_sdc > synth_pipe_low/float16_multiplier.sdc
write_sdf > synth_pipe_low/float16_multiplier.sdf
