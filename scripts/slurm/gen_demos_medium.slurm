#!/bin/bash
#SBATCH --job-name=dp3-gendemo
#SBATCH --account=rgx@v100
#SBATCH --constraint=v100-32g
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=10
#SBATCH --hint=nomultithread
#SBATCH --time=10:00:00
#SBATCH --output=/lustre/fswork/projects/rech/rgx/unw24jl/3D-Diffusion-Policy/slurm_logs/gendemo_%j.out
#SBATCH --error=/lustre/fswork/projects/rech/rgx/unw24jl/3D-Diffusion-Policy/slurm_logs/gendemo_%j.out

# Generate expert demonstrations for the 11 "medium" MetaWorld tasks (DP3 paper split).
module purge
source /lustre/fswork/projects/rech/rgx/unw24jl/3D-Diffusion-Policy/env.sh
cd $DP3_REPO/third_party/Metaworld

TASKS="basketball bin-picking box-close coffee-pull coffee-push hammer peg-insert-side push-wall soccer sweep sweep-into"

for task in $TASKS; do
    echo "=== Generating demonstrations: $task ==="
    python gen_demonstration_expert.py --env_name=$task \
        --num_episodes 10 \
        --root_dir "$DP3_REPO/3D-Diffusion-Policy/data/" || echo "FAILED: $task"
done

echo "=== Demo generation finished. Contents of data dir: ==="
ls -d $DP3_REPO/3D-Diffusion-Policy/data/*.zarr
