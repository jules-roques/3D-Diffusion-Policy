# Self-contained environment for DP3 on Jean Zay.
# Everything (python env, caches, mujoco, wandb logs) lives inside this repo.
# Usage: source env.sh

export DP3_REPO="/lustre/fswork/projects/rech/rgx/unw24jl/3D-Diffusion-Policy"

# --- keep all caches/configs inside the repo (nothing written to $HOME) ---
export XDG_CACHE_HOME="$DP3_REPO/.cache"
export PIP_CACHE_DIR="$DP3_REPO/.cache/pip"
export CONDA_PKGS_DIRS="$DP3_REPO/.cache/conda_pkgs"
export CONDA_ENVS_PATH="$DP3_REPO/envs"
export CONDA_REGISTER_ENVS=false
export TORCH_EXTENSIONS_DIR="$DP3_REPO/.cache/torch_extensions"
export NUMBA_CACHE_DIR="$DP3_REPO/.cache/numba"
export MPLCONFIGDIR="$DP3_REPO/.cache/matplotlib"

# --- wandb: offline (compute nodes have no internet), logs inside repo ---
export WANDB_MODE=offline
export WANDB_DIR="$DP3_REPO/.wandb"
export WANDB_CACHE_DIR="$DP3_REPO/.cache/wandb"
export WANDB_CONFIG_DIR="$DP3_REPO/.config/wandb"

# --- mujoco 2.1.0, contained in the repo (instead of ~/.mujoco) ---
export MUJOCO_PY_MUJOCO_PATH="$DP3_REPO/third_party/mujoco210"
export LD_LIBRARY_PATH="$MUJOCO_PY_MUJOCO_PATH/bin:$LD_LIBRARY_PATH"
export MUJOCO_GL=egl

# --- conda env (prefix env inside the repo) ---
export DP3_ENV="$DP3_REPO/envs/dp3"
if [ -d "$DP3_ENV" ]; then
    export PATH="$DP3_ENV/bin:$PATH"
    # headers/libs from conda-forge (glew, osmesa) used when (re)compiling mujoco-py
    export CPATH="$DP3_ENV/include:$CPATH"
    export LIBRARY_PATH="$DP3_ENV/lib:$LIBRARY_PATH"
    export LD_LIBRARY_PATH="$DP3_ENV/lib:$LD_LIBRARY_PATH"
fi

mkdir -p "$XDG_CACHE_HOME" "$PIP_CACHE_DIR" "$WANDB_DIR" "$WANDB_CACHE_DIR" "$WANDB_CONFIG_DIR"
