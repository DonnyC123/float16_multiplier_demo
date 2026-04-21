#!/usr/bin/env bash
# ./sim.sh        # batch
# ./sim.sh gui    # gui

set -euo pipefail

TOP=float16_multiplier_tb

RTL=(
    float16_decoder.v
    leading_zero_counter.v
    product_normalizer.v
    product_rounder.v
    float16_multiplier.v
)

TB=(
    float16_multiplier_tb.v
)

FLAGS=(-64bit -sv -timescale 1ns/1ps -access +rwc)

MODE="${1:-batch}"
if [[ "$MODE" == "gui" || "$MODE" == "-gui" ]]; then
    CMD=(xrun "${FLAGS[@]}" "${RTL[@]}" "${TB[@]}" -top "$TOP" -gui)
else
    CMD=(xrun "${FLAGS[@]}" "${RTL[@]}" "${TB[@]}" -top "$TOP" -input sim.tcl -l xrun.log)
fi

printf '%s ' "${CMD[@]}"; echo
"${CMD[@]}"

