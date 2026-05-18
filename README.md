# float16_multiplier_demo

IEEE-754 float16 multiplier with two RTL versions (combinational and pipelined),
RTL + gate-level sim flows, and Genus synthesis scripts.

## Setup

Source the cadence env first so `xrun` and `genus` are on your PATH:

```
source /vol/ece303/genus_tutorial/cadence.env
```

## Repository layout

| Path | Contents |
|---|---|
| `rtl_comb/` | Combinational version of the multiplier (no clock). |
| `rtl_pipe/` | Pipelined version (3 register stages, `clk` + active-low `rst_n`). |
| `float16_multiplier_tb.v` | Testbench for the combinational design. |
| `float16_multiplier_pipe_tb.v` | Testbench for the pipelined design (clock, latency-aware checking). |
| `synth_opt_{low,high}.tcl` | Genus scripts for the combinational design. |
| `synth_pipe_{low,high}.tcl` | Genus scripts for the pipelined design. |
| `run_sim.sh` / `run_sim_pipe.sh` | RTL simulation. |
| `run_gate_sim.sh` / `run_gate_sim_pipe.sh` | Zero-delay gate-level simulation of the synthesized netlist. |
| `sim.tcl` | xrun runtime tcl — opens a waves database and runs to `$finish`. |

## RTL simulation

### Combinational

```
./run_sim.sh        # batch; log -> xrun.log, waves -> waves.shm
./run_sim.sh gui    # opens SimVision
```

### Pipelined

```
./run_sim_pipe.sh        # batch; log -> xrun_pipe.log
./run_sim_pipe.sh gui    # GUI
```

The pipelined TB drives inputs on every clock edge, carries each expected result
through a length-3 shift register so it lands at the output at the same cycle as
the DUT's `float_product_o`, and prints a `driven / passed / failed` summary at
the end.

## Synthesis

All flows write reports + netlist + SDF into a directory named after the script.

### Combinational

```
genus -f synth_opt_low.tcl     # outputs in synth_opt_low/
genus -f synth_opt_high.tcl    # outputs in synth_opt_high/
```

Constraint: `set_max_delay 2.0` from all inputs to all outputs (no clock —
purely combinational).

### Pipelined

```
genus -f synth_pipe_low.tcl    # outputs in synth_pipe_low/
genus -f synth_pipe_high.tcl   # outputs in synth_pipe_high/
```

Constraints:

- `create_clock -period 1.0` on `clk` (1 GHz target).
- `set_input_delay 0.2`, `set_output_delay 0.2`, `set_input_transition 0.1` on
  the data ports.

### Effort levels

- `low`: low generic/map/opt effort, single `syn_opt` pass — fast, baseline QoR.
- `high`: high generic/map/opt effort plus `syn_opt -incremental` — slower, best QoR.

## Gate-level simulation (zero-delay)

Both gate-sim scripts run with `-delay_mode zero` — no SDF, no timing checks.
They verify the synthesized netlist is logically equivalent to the RTL.

```
./run_gate_sim.sh              # comb, synth_opt_low netlist, batch
./run_gate_sim.sh high         # comb, synth_opt_high netlist, batch
./run_gate_sim.sh high gui     # GUI mode

./run_gate_sim_pipe.sh         # pipe, synth_pipe_low netlist, batch
./run_gate_sim_pipe.sh high    # pipe, synth_pipe_high netlist, batch
./run_gate_sim_pipe.sh high gui
```

The scripts require the corresponding synth flow to have been run first (they
check for the netlist file and abort with a clear error if it's missing).

## Typical end-to-end flow

1. RTL sim: `./run_sim.sh` or `./run_sim_pipe.sh`.
2. Synthesize: `genus -f synth_{opt,pipe}_high.tcl`.
3. Check `synth_*/timing.rpt` for positive slack.
4. Gate-level functional sim: `./run_gate_sim.sh high` or `./run_gate_sim_pipe.sh high`.
