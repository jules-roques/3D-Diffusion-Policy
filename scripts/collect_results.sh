#!/bin/bash
# Summarize DP3 medium-MetaWorld results from slurm training logs.
# For each task: best eval success rate and mean of the 5 best evals (paper-style metric).
ARRAY_ID=${1:-70313}
LOGDIR=/lustre/fswork/projects/rech/rgx/unw24jl/3D-Diffusion-Policy/slurm_logs
TASKS=(basketball bin-picking box-close coffee-pull coffee-push hammer peg-insert-side push-wall soccer sweep sweep-into)

printf "%-18s %10s %10s %8s\n" task best top5_mean n_evals
for i in "${!TASKS[@]}"; do
    f=$LOGDIR/train_${ARRAY_ID}_${i}.out
    [ -f "$f" ] || { printf "%-18s %10s\n" "${TASKS[$i]}" "no log"; continue; }
    grep -oE "test_mean_score: [0-9.]+" "$f" | awk -v t="${TASKS[$i]}" '
        {v=$2; n++; vals[n]=v}
        END {
            if (n==0) { printf "%-18s %10s\n", t, "no evals"; exit }
            asort(vals); best=vals[n]
            k=(n<5)?n:5; s=0
            for (j=n-k+1; j<=n; j++) s+=vals[j]
            printf "%-18s %10.3f %10.3f %8d\n", t, best, s/k, n
        }'
done
