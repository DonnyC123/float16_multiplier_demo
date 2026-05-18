# ####################################################################

#  Created by Genus(TM) Synthesis Solution 18.14-s037_1 on Mon May 18 11:05:00 CDT 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1.0fF
set_units -time 1000.0ps

# Set the current design
current_design float16_multiplier

set_load -pin_load -min 0.0 [get_ports {float_product_o[15]}]
set_load -pin_load -max 0.1 [get_ports {float_product_o[15]}]
set_load -pin_load -min 0.0 [get_ports {float_product_o[14]}]
set_load -pin_load -max 0.1 [get_ports {float_product_o[14]}]
set_load -pin_load -min 0.0 [get_ports {float_product_o[13]}]
set_load -pin_load -max 0.1 [get_ports {float_product_o[13]}]
set_load -pin_load -min 0.0 [get_ports {float_product_o[12]}]
set_load -pin_load -max 0.1 [get_ports {float_product_o[12]}]
set_load -pin_load -min 0.0 [get_ports {float_product_o[11]}]
set_load -pin_load -max 0.1 [get_ports {float_product_o[11]}]
set_load -pin_load -min 0.0 [get_ports {float_product_o[10]}]
set_load -pin_load -max 0.1 [get_ports {float_product_o[10]}]
set_load -pin_load -min 0.0 [get_ports {float_product_o[9]}]
set_load -pin_load -max 0.1 [get_ports {float_product_o[9]}]
set_load -pin_load -min 0.0 [get_ports {float_product_o[8]}]
set_load -pin_load -max 0.1 [get_ports {float_product_o[8]}]
set_load -pin_load -min 0.0 [get_ports {float_product_o[7]}]
set_load -pin_load -max 0.1 [get_ports {float_product_o[7]}]
set_load -pin_load -min 0.0 [get_ports {float_product_o[6]}]
set_load -pin_load -max 0.1 [get_ports {float_product_o[6]}]
set_load -pin_load -min 0.0 [get_ports {float_product_o[5]}]
set_load -pin_load -max 0.1 [get_ports {float_product_o[5]}]
set_load -pin_load -min 0.0 [get_ports {float_product_o[4]}]
set_load -pin_load -max 0.1 [get_ports {float_product_o[4]}]
set_load -pin_load -min 0.0 [get_ports {float_product_o[3]}]
set_load -pin_load -max 0.1 [get_ports {float_product_o[3]}]
set_load -pin_load -min 0.0 [get_ports {float_product_o[2]}]
set_load -pin_load -max 0.1 [get_ports {float_product_o[2]}]
set_load -pin_load -min 0.0 [get_ports {float_product_o[1]}]
set_load -pin_load -max 0.1 [get_ports {float_product_o[1]}]
set_load -pin_load -min 0.0 [get_ports {float_product_o[0]}]
set_load -pin_load -max 0.1 [get_ports {float_product_o[0]}]
set_max_delay 2 -from [list \
  [get_ports {float_a_i[15]}]  \
  [get_ports {float_a_i[14]}]  \
  [get_ports {float_a_i[13]}]  \
  [get_ports {float_a_i[12]}]  \
  [get_ports {float_a_i[11]}]  \
  [get_ports {float_a_i[10]}]  \
  [get_ports {float_a_i[9]}]  \
  [get_ports {float_a_i[8]}]  \
  [get_ports {float_a_i[7]}]  \
  [get_ports {float_a_i[6]}]  \
  [get_ports {float_a_i[5]}]  \
  [get_ports {float_a_i[4]}]  \
  [get_ports {float_a_i[3]}]  \
  [get_ports {float_a_i[2]}]  \
  [get_ports {float_a_i[1]}]  \
  [get_ports {float_a_i[0]}]  \
  [get_ports {float_b_i[15]}]  \
  [get_ports {float_b_i[14]}]  \
  [get_ports {float_b_i[13]}]  \
  [get_ports {float_b_i[12]}]  \
  [get_ports {float_b_i[11]}]  \
  [get_ports {float_b_i[10]}]  \
  [get_ports {float_b_i[9]}]  \
  [get_ports {float_b_i[8]}]  \
  [get_ports {float_b_i[7]}]  \
  [get_ports {float_b_i[6]}]  \
  [get_ports {float_b_i[5]}]  \
  [get_ports {float_b_i[4]}]  \
  [get_ports {float_b_i[3]}]  \
  [get_ports {float_b_i[2]}]  \
  [get_ports {float_b_i[1]}]  \
  [get_ports {float_b_i[0]}] ] -to [list \
  [get_ports {float_product_o[15]}]  \
  [get_ports {float_product_o[14]}]  \
  [get_ports {float_product_o[13]}]  \
  [get_ports {float_product_o[12]}]  \
  [get_ports {float_product_o[11]}]  \
  [get_ports {float_product_o[10]}]  \
  [get_ports {float_product_o[9]}]  \
  [get_ports {float_product_o[8]}]  \
  [get_ports {float_product_o[7]}]  \
  [get_ports {float_product_o[6]}]  \
  [get_ports {float_product_o[5]}]  \
  [get_ports {float_product_o[4]}]  \
  [get_ports {float_product_o[3]}]  \
  [get_ports {float_product_o[2]}]  \
  [get_ports {float_product_o[1]}]  \
  [get_ports {float_product_o[0]}] ]
set_clock_gating_check -setup 0.0 
set_max_capacitance 0.0 [get_ports {float_a_i[15]}]
set_max_capacitance 0.0 [get_ports {float_a_i[14]}]
set_max_capacitance 0.0 [get_ports {float_a_i[13]}]
set_max_capacitance 0.0 [get_ports {float_a_i[12]}]
set_max_capacitance 0.0 [get_ports {float_a_i[11]}]
set_max_capacitance 0.0 [get_ports {float_a_i[10]}]
set_max_capacitance 0.0 [get_ports {float_a_i[9]}]
set_max_capacitance 0.0 [get_ports {float_a_i[8]}]
set_max_capacitance 0.0 [get_ports {float_a_i[7]}]
set_max_capacitance 0.0 [get_ports {float_a_i[6]}]
set_max_capacitance 0.0 [get_ports {float_a_i[5]}]
set_max_capacitance 0.0 [get_ports {float_a_i[4]}]
set_max_capacitance 0.0 [get_ports {float_a_i[3]}]
set_max_capacitance 0.0 [get_ports {float_a_i[2]}]
set_max_capacitance 0.0 [get_ports {float_a_i[1]}]
set_max_capacitance 0.0 [get_ports {float_a_i[0]}]
set_max_capacitance 0.0 [get_ports {float_b_i[15]}]
set_max_capacitance 0.0 [get_ports {float_b_i[14]}]
set_max_capacitance 0.0 [get_ports {float_b_i[13]}]
set_max_capacitance 0.0 [get_ports {float_b_i[12]}]
set_max_capacitance 0.0 [get_ports {float_b_i[11]}]
set_max_capacitance 0.0 [get_ports {float_b_i[10]}]
set_max_capacitance 0.0 [get_ports {float_b_i[9]}]
set_max_capacitance 0.0 [get_ports {float_b_i[8]}]
set_max_capacitance 0.0 [get_ports {float_b_i[7]}]
set_max_capacitance 0.0 [get_ports {float_b_i[6]}]
set_max_capacitance 0.0 [get_ports {float_b_i[5]}]
set_max_capacitance 0.0 [get_ports {float_b_i[4]}]
set_max_capacitance 0.0 [get_ports {float_b_i[3]}]
set_max_capacitance 0.0 [get_ports {float_b_i[2]}]
set_max_capacitance 0.0 [get_ports {float_b_i[1]}]
set_max_capacitance 0.0 [get_ports {float_b_i[0]}]
set_input_transition 0.1 [get_ports {float_a_i[15]}]
set_input_transition 0.1 [get_ports {float_a_i[14]}]
set_input_transition 0.1 [get_ports {float_a_i[13]}]
set_input_transition 0.1 [get_ports {float_a_i[12]}]
set_input_transition 0.1 [get_ports {float_a_i[11]}]
set_input_transition 0.1 [get_ports {float_a_i[10]}]
set_input_transition 0.1 [get_ports {float_a_i[9]}]
set_input_transition 0.1 [get_ports {float_a_i[8]}]
set_input_transition 0.1 [get_ports {float_a_i[7]}]
set_input_transition 0.1 [get_ports {float_a_i[6]}]
set_input_transition 0.1 [get_ports {float_a_i[5]}]
set_input_transition 0.1 [get_ports {float_a_i[4]}]
set_input_transition 0.1 [get_ports {float_a_i[3]}]
set_input_transition 0.1 [get_ports {float_a_i[2]}]
set_input_transition 0.1 [get_ports {float_a_i[1]}]
set_input_transition 0.1 [get_ports {float_a_i[0]}]
set_input_transition 0.1 [get_ports {float_b_i[15]}]
set_input_transition 0.1 [get_ports {float_b_i[14]}]
set_input_transition 0.1 [get_ports {float_b_i[13]}]
set_input_transition 0.1 [get_ports {float_b_i[12]}]
set_input_transition 0.1 [get_ports {float_b_i[11]}]
set_input_transition 0.1 [get_ports {float_b_i[10]}]
set_input_transition 0.1 [get_ports {float_b_i[9]}]
set_input_transition 0.1 [get_ports {float_b_i[8]}]
set_input_transition 0.1 [get_ports {float_b_i[7]}]
set_input_transition 0.1 [get_ports {float_b_i[6]}]
set_input_transition 0.1 [get_ports {float_b_i[5]}]
set_input_transition 0.1 [get_ports {float_b_i[4]}]
set_input_transition 0.1 [get_ports {float_b_i[3]}]
set_input_transition 0.1 [get_ports {float_b_i[2]}]
set_input_transition 0.1 [get_ports {float_b_i[1]}]
set_input_transition 0.1 [get_ports {float_b_i[0]}]
set_dont_use [get_lib_cells NangateOpenCellLibrary/ANTENNA_X1]
set_dont_use [get_lib_cells NangateOpenCellLibrary/FILLCELL_X1]
set_dont_use [get_lib_cells NangateOpenCellLibrary/FILLCELL_X2]
set_dont_use [get_lib_cells NangateOpenCellLibrary/FILLCELL_X4]
set_dont_use [get_lib_cells NangateOpenCellLibrary/FILLCELL_X8]
set_dont_use [get_lib_cells NangateOpenCellLibrary/FILLCELL_X16]
set_dont_use [get_lib_cells NangateOpenCellLibrary/FILLCELL_X32]
set_dont_use [get_lib_cells NangateOpenCellLibrary/LOGIC0_X1]
set_dont_use [get_lib_cells NangateOpenCellLibrary/LOGIC1_X1]
