set -x

# reinforce++

ray job submit --address="http://127.0.0.1:8000" \
   --runtime-env-json='{"working_dir": "/openrlhf"}' \
   -- python3 -m openrlhf.cli.train_ppo_ray \
   --ref_num_nodes 1 \
   --ref_num_gpus_per_node 1 \
   --reward_num_nodes 1 \
   --reward_num_gpus_per_node 1 \
   --actor_num_nodes 1 \
   --actor_num_gpus_per_node 1 \
   --vllm_num_engines 1 \
   --vllm_tensor_parallel_size 1 \
   --pretrain meta-llama/Llama-3.2-1B-Instruct \
   --reward_pretrain countdown \
   --save_path /scr/akchak/rl_behaviors/checkpoints/llama-3-2-1b-rlhf \
   --micro_train_batch_size 16 \
   --train_batch_size 128 \
   --micro_rollout_batch_size 32 \
   --rollout_batch_size 1024 \
   --n_samples_per_prompt 1 \
   --max_epochs 1 \
   --prompt_max_len 1024 \
   --max_samples 100000 \
   --generate_max_len 1024 \
   --advantage_estimator reinforce \
   --zero_stage 3 \
   --bf16 \
   --actor_learning_rate 5e-7 \
   --init_kl_coef 0.01 \
   --prompt_data ../data/countdown/train.jsonl \
   --input_key query \
   --adam_offload \
   --gradient_checkpointing \
   --packing_samples \
   --save_steps -1 \
   --ckpt_path /scr/akchak/rl_behaviors/checkpoints/llama-3-2-1b-rlhf

# also supports --advantage_estimator rloo