#!/bin/bash
#SBATCH --job-name=dp3-train
#SBATCH --account=rgx@v100
#SBATCH --constraint=v100-32g
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=10
#SBATCH --hint=nomultithread
#SBATCH --time=10:00:00
#SBATCH --array=0-10
#SBATCH --output=/lustre/fswork/projects/rech/rgx/unw24jl/3D-Diffusion-Policy/slurm_logs/train_%A_%a.out
#SBATCH --error=/lustre/fswork/projects/rech/rgx/unw24jl/3D-Diffusion-Policy/slurm_logs/train_%A_%a.out

# Train DP3 on the 11 "medium" MetaWorld tasks (one array task per env), seed 0.
# Mirrors scripts/train_policy.sh but with wandb offline (no internet on compute nodes).
module purge
source /lustre/fswork/projects/rech/rgx/unw24jl/3D-Diffusion-Policy/env.sh

TASKS=(basketball bin-picking box-close coffee-pull coffee-push hammer peg-insert-side push-wall soccer sweep sweep-into)
task_name=metaworld_${TASKS[$SLURM_ARRAY_TASK_ID]}

alg_name=dp3
addition_info=repro
seed=${DP3_SEED:-0}
exp_name=${task_name}-${alg_name}-${addition_info}
run_dir="data/outputs/${exp_name}_seed${seed}"

cd $DP3_REPO/3D-Diffusion-Policy
export HYDRA_FULL_ERROR=1

echo "=== Training $exp_name (seed $seed) on $(hostname) ==="
python train.py --config-name=${alg_name}.yaml \
    task=${task_name} \
    hydra.run.dir=${run_dir} \
    training.debug=False \
    training.num_epochs=1000 \
    training.seed=${seed} \
    training.device="cuda:0" \
    exp_name=${exp_name} \
    logging.mode=offline \
    checkpoint.save_ckpt=True
