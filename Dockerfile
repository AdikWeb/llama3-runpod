FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /app

# Установка системных пакетов
RUN apt-get update && apt-get install -y \
	python3 python3-pip curl git && \
	ln -s /usr/bin/python3 /usr/bin/python && \
	pip install --upgrade pip

# Установка Python зависимостей
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копируем обработчик
COPY handler.py .

# Запуск vLLM и handler
CMD bash -c "\
	python3 -m vllm.entrypoints.openai.api_server \
	--model mistralai/Mistral-7B-Instruct-v0.2 \
	--token $HF_TOKEN \
	--port 8000 --max-model-len 8192 & \
	sleep 20 && \
	python3 handler.py"
