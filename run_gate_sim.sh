#!/usr/bin/env bash
# ./run_gate_sim.sh              # batch, low-effort netlist
# ./run_gate_sim.sh high         # batch, high-effort netlist
# ./run_gate_sim.sh low gui      # gui, low-effort netlist
# ./run_gate_sim.sh high gui     # gui, high-effort netlist

set -euo pipefail

TOP=float16_multiplier_tb

EFFORT="${1:-low}"
MODE="${2:-batch}"

case "$EFFORT" in
    low|high) NETLIST_DIR="synth_opt_${EFFORT}" ;;
    *) echo "error: first arg must be 'low' or 'high' (got '$EFFORT')" >&2; exit 1 ;;
esac

NETLIST="${NETLIST_DIR}/float16_multiplier.v"
CELL_LIB=/vol/ece303/genus_tutorial/NangateOpenCellLibrary.v

if [[ ! -f "$NETLIST" ]]; then
    echo "error: netlist not found at $NETLIST — run synthesis first" >&2
    exit 1
fi

SRC=(
    "$CELL_LIB"
    "$NETLIST"
    float16_multiplier_tb.v
)

FLAGS=(-64bit -sv -timescale 1ns/1ps -access +rwc
       -xmelab_args "-warnmax 0 -delay_mode zero -maxdelays")

if [[ "$MODE" == "gui" || "$MODE" == "-gui" ]]; then
    CMD=(xrun "${FLAGS[@]}" "${SRC[@]}" -top "$TOP" -gui)
else
    CMD=(xrun "${FLAGS[@]}" "${SRC[@]}" -top "$TOP" -input sim.tcl -l "xrun_gate_${EFFORT}.log")
fi

printf '%s ' "${CMD[@]}"; echo
"${CMD[@]}"
