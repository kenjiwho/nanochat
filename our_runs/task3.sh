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
WANDB_RUN=task3_run1
if [ -z "$WANDB_RUN" ]; then
    # by default use "dummy" : it's handled as a special case, skips logging to wandb
    WANDB_RUN=dummy
fi

export PYTORCH_ALLOC_CONF=expandable_segments:True

# mid-learning
torchrun --standalone --nproc_per_node=2 -m scripts.chat_sft_mid -- --run=$WANDB_RUN
torchrun --standalone --nproc_per_node=2 -m scripts.chat_eval -- -i sft -a "ARC-Easy|ARC-Challenge|GSM-8K"

# sft
torchrun --standalone --nproc_per_node=2 -m scripts.chat_sft -- --run=$WANDB_RUN
torchrun --standalone --nproc_per_node=2 -m scripts.chat_eval -- -i sft -a "ARC-Easy|ARC-Challenge|GSM-8K"