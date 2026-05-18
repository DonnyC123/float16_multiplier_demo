#!/usr/bin/env bash
# ./run_sim_pipe.sh        # batch
# ./run_sim_pipe.sh gui    # gui

set -euo pipefail

TOP=float16_multiplier_pipe_tb

RTL=(
    rtl_pipe/float16_decoder.v
    rtl_pipe/leading_zero_counter.v
    rtl_pipe/product_normalizer.v
    rtl_pipe/product_rounder.v
    rtl_pipe/float16_multiplier.v
)

TB=(
    float16_multiplier_pipe_tb.v
)

FLAGS=(-64bit -sv -timescale 1ns/1ps -access +rwc)

MODE="${1:-batch}"
if [[ "$MODE" == "gui" || "$MODE" == "-gui" ]]; then
    CMD=(xrun "${FLAGS[@]}" "${RTL[@]}" "${TB[@]}" -top "$TOP" -gui)
else
    CMD=(xrun "${FLAGS[@]}" "${RTL[@]}" "${TB[@]}" -top "$TOP" -input sim.tcl -l xrun_pipe.log)
fi

printf '%s ' "${CMD[@]}"; echo
"${CMD[@]}"
