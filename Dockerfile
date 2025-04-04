FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /app

# --- Установка Python и зависимостей
RUN apt-get update && apt-get install -y \
	git python3 python3-pip curl && \
	ln -s /usr/bin/python3 /usr/bin/python && \
	pip install --upgrade pip

# --- Установка Python-зависимостей
COPY requirements.txt .
RUN pip install -r requirements.txt

# --- Скачивание модели LLaMA3 70B (ты можешь заменить на свою, если хочешь)
ENV HF_TOKEN=your_huggingface_token
RUN mkdir -p /models
RUN huggingface-cli download meta-llama/Meta-Llama-3-70B-Instruct \
	--local-dir /models/llama3 --token $HF_TOKEN --resume-download --exclude ".git"

# --- Копируем handler
COPY handler.py .

# --- Запуск: сначала vllm, потом handler
CMD bash -c "\
	python3 -m vllm.entrypoints.openai.api_server \
	--model /models/llama3 \
	--port 8000 --max-model-len 8192 & \
	sleep 15 && \
	python3 handler.py"
