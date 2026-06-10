#!/bin/bash
#SBATCH --job-name=dp3-smoke
#SBATCH --account=rgx@v100
#SBATCH --constraint=v100-32g
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=10
#SBATCH --hint=nomultithread
#SBATCH --qos=qos_gpu-dev
#SBATCH --time=00:20:00
#SBATCH --output=/lustre/fswork/projects/rech/rgx/unw24jl/3D-Diffusion-Policy/slurm_logs/smoke_%j.out
#SBATCH --error=/lustre/fswork/projects/rech/rgx/unw24jl/3D-Diffusion-Policy/slurm_logs/smoke_%j.out

module purge
source /lustre/fswork/projects/rech/rgx/unw24jl/3D-Diffusion-Policy/env.sh
cd $DP3_REPO/3D-Diffusion-Policy

python - <<'EOF'
import torch
print("torch:", torch.__version__, "| cuda available:", torch.cuda.is_available(),
      "| device:", torch.cuda.get_device_name(0))

# pytorch3d CUDA kernel (farthest point sampling, used by DP3)
import pytorch3d.ops as ops
pts = torch.rand(2, 4096, 3, device="cuda")
sampled, idx = ops.sample_farthest_points(pts, K=512)
print("pytorch3d FPS on GPU OK:", sampled.shape)

# metaworld env with EGL rendering + point cloud generation
from diffusion_policy_3d.env import MetaWorldEnv
env = MetaWorldEnv("basketball", device="cuda:0", use_point_crop=True)
obs = env.reset()
print("env reset OK; obs keys:", list(obs.keys()))
print("point_cloud shape:", obs["point_cloud"].shape, "| agent_pos:", obs["agent_pos"].shape)
obs, rew, done, info = env.step(env.action_space.sample())
print("env step OK")
img = env.render(mode="rgb_array")
print("render OK:", getattr(img, "shape", None))
print("SMOKE TEST PASSED")
EOF
