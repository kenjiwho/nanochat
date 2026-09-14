# setup environment
command -v uv &> /dev/null || curl -LsSf https://astral.sh/uv/install.sh | sh
[ -d ".venv" ] || uv venv
uv sync --extra gpu
source .venv/bin/activate

# download 500MB of data
python -m nanochat.dataset -n 5
# train and evaluate tokenizer on downloaded data
python -m scripts.tok_train --vocab-size 8192
python -m scripts.tok_eval

python -m scripts.tok_train --vocab-size 32768
python -m scripts.tok_eval

