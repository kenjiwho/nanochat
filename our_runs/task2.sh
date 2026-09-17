export OMP_NUM_THREADS=1

# setup environment
command -v uv &> /dev/null || curl -LsSf https://astral.sh/uv/install.sh | sh
[ -d ".venv" ] || uv venv
uv sync --extra gpu --group dev
source .venv/bin/activate

# -----------------------------------------------------------------------------
# # wandb setup
# # If you wish to use wandb for logging (it's nice!, recommended).
# # 1) Make sure to first log in to wandb, e.g. run:
# #    `wandb login`
# # 2) Set the WANDB_RUN environment variable when running this script, e.g.:
# #    `WANDB_RUN=d26 bash speedrun.sh`
WANDB_RUN=gpu_run2
if [ -z "$WANDB_RUN" ]; then
    # by default use "dummy" : it's handled as a special case, skips logging to wandb
    WANDB_RUN=dummy
fi

export PYTORCH_ALLOC_CONF=expandable_segments:True


# download 500MB of data
python -m nanochat.dataset -n 5

# pre-train transformer
# torchrun --standalone --nproc_per_node=8 -m scripts.base_train -- --depth=2 --save-every=100 --eval-every=100 --target-param-data-ratio=8 --device-batch-size=16 --run=$WANDB_RUN --total-batch-size=122880
torchrun --standalone --nproc_per_node=2 -m scripts.base_train -- --depth=2 --save-every=100 --eval-every=10 --target-param-data-ratio=8 --device-batch-size=1 --run=$WANDB_RUN --window-pattern=L


# evaluate the model: CORE metric, BPB on train/val, and draw samples
torchrun --standalone --nproc_per_node=2 -m scripts.base_eval -- --device-batch-size=2

