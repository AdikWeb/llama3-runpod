FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /app

RUN apt-get update && apt-get install -y \
	python3 python3-pip git curl && \
	ln -s /usr/bin/python3 /usr/bin/python && \
	pip install --upgrade pip

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY handler.py .

CMD bash -c "\
	python3 -m vllm.entrypoints.openai.api_server \
	--model meta-llama/Meta-Llama-3-70B-Instruct \
	--token $HF_TOKEN \
	--port 8000 --max-model-len 8192 & \
	sleep 10 && \
	python3 handler.py"
