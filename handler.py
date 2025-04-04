import runpod
import requests

VLLM_URL = "http://localhost:8000/v1/completions"

def handler(job):
    prompt = job["input"].get("prompt", "")
    max_tokens = job["input"].get("max_tokens", 1024)
    temperature = job["input"].get("temperature", 0.7)

    payload = {
        "model": "llama3-70b",
        "prompt": prompt,
        "max_tokens": max_tokens,
        "temperature": temperature,
    }

    try:
        resp = requests.post(VLLM_URL, json=payload, timeout=60)
        resp.raise_for_status()
        result = resp.json()
        return result
    except Exception as e:
        return {"error": str(e)}

runpod.serverless.start({"handler": handler})
