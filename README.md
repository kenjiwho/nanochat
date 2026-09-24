# executing the code
In the folder our_runs is all the added code, which makes use of the original nano code. To execute each task, type the bash command for each corresponding task, for example for task 1: ```bash our_runs/task1.sh```.

The outputs for task 1 are saved in output.txt and output2.txt

# changed python files
To be able to train our model, some python files were changed and added. In ```scripts/```, the ```chat_sft.py``` script was copied to ```chat_sft_mid.py``` and modified to only perform mid-training. ```chat_sft.py``` was modified to only perform SFT. In ```nanochat/```, the ```checkpoint_manager.py``` script was modified to add a new possible checkpoint directory for the stage 1 model in the cache. In ```our_runs/```, the task bash scripts, outputs, and checkpoints for base, stage 1, and stage 2 are stored. A python script (```tok_insight_eval.py```) was also made to print the texts with token splits to see how the trained tokenizer tokenizes the texts.

```our_runs/base_checkpoints/```: pre-trained model checkpoints\
```our_runs/stage1_checkpoints/```: mid-trained model checkpoints\
```our_runs/chatsft_checkpoints/```: SFT model checkpoints
