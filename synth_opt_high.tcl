
set_db hdl_search_path { . }
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
set_max_delay 2.0 -from [all_inputs] -to [all_outputs]

# Assume 50fF load capacitances everywhere:
set_load 0.050 [all_outputs]

# Set 10fF maximum capacitance on all inputs
set_max_capacitance 0.010 [all_inputs]


set_db auto_ungroup both

# Set syn effort high
set_db syn_opt_effort     high
set_db syn_generic_effort high
set_db syn_map_effort     high

syn_generic
syn_map
syn_opt
syn_opt -incremental

report_timing > synth_opt_high/timing.rpt
report_area   > synth_opt_high/area.rpt
report_gates  > synth_opt_high/gates.rpt
report_power  > synth_opt_high/power.rpt

write_hdl > synth_opt_high/float16_multiplier.v
write_sdc > synth_opt_high/float16_multiplier.sdc
