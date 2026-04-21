# float16_multiplier_demo

float16 multiplier with a sim flow (xrun) and two Genus synth scripts.

## Setup

Source the cadence env first so xrun and genus are on your PATH:

```
source /vol/ece303/genus_tutorial/cadence.env
```

## run_sim.sh

Runs the testbench (float16_multiplier_tb) through xrun.

```
./run_sim.sh        # batch, logs to xrun.log, waves in waves.shm
./run_sim.sh gui    # opens simvision
```

Batch mode uses sim.tcl to dump waves and exit. GUI mode just brings up the tool.

## synth_opt_low.tcl / synth_opt_high.tcl

Genus scripts for float16_multiplier against the Nangate library. Same flow,
different effort levels.

```
genus -f synth_opt_low.tcl
genus -f synth_opt_high.tcl
```

Make the output dir before running (synth_opt_low/ or synth_opt_high/) since
the reports get redirected there.

Both do: read_hdl, elaborate, set_max_delay 2.0, syn_generic, syn_map, syn_opt,
then report timing/area/gates/power and write the netlist + sdc.

- low: all efforts set to low, one syn_opt pass
- high: all efforts set to high, plus two extra syn_opt -incremental passes
