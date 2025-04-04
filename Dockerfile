FROM runpod/serverless:3.0.0

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /app

RUN apt-get update && apt-get install -y \
	git python3 python3-pip curl && \
	ln -s /usr/bin/python3 /usr/bin/python && \
	pip install --upgrade pip

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY handler.py .

CMD bash -c "\
	python3 -m vllm.entrypoints.openai.api_server \
	--model meta-llama/Meta-Llama-3-70B-Instruct \
	--token $HF_TOKEN \
	--port 8000 --max-model-len 8192 & \
	sleep 10 && \
	python3 handler.py"
