export OMP_NUM_THREADS=1

# setup environment
command -v uv &> /dev/null || curl -LsSf https://astral.sh/uv/install.sh | sh
[ -d ".venv" ] || uv venv
uv sync --extra gpu --group dev
source .venv/bin/activate

# -----------------------------------------------------------------------------
# wandb setup
WANDB_RUN=task3_run2
if [ -z "$WANDB_RUN" ]; then
    # by default use "dummy" : it's handled as a special case, skips logging to wandb
    WANDB_RUN=dummy
fi

export PYTORCH_ALLOC_CONF=expandable_segments:True

# mid-learning Using 2 gpus
torchrun --standalone --nproc_per_node=2 -m scripts.chat_sft_mid -- --run=$WANDB_RUN
torchrun --standalone --nproc_per_node=2 -m scripts.chat_eval -- -i stage1 -a "ARC-Easy|ARC-Challenge|GSM8K"

# sft using gpu Using 1 gpu
torchrun --standalone --nproc_per_node=1 -m scripts.chat_sft -- --run=$WANDB_RUN --load-optimizer=0 --device-batch-size=16 #device batch size was 32
torchrun --standalone --nproc_per_node=1 -m scripts.chat_eval -- -i sft -a "ARC-Easy|ARC-Challenge|GSM8K"
