import runpod
import requests

def handler(job):
    prompt = job["input"].get("prompt", "")
    max_tokens = job["input"].get("max_tokens", 256)
    temperature = job["input"].get("temperature", 0.7)

    payload = {
        "model": "mistralai/Mistral-7B-Instruct-v0.2",
        "prompt": prompt,
        "max_tokens": max_tokens,
        "temperature": temperature,
    }

    try:
        response = requests.post("http://localhost:8000/v1/completions", json=payload, timeout=60)
        response.raise_for_status()
        return response.json()
    except Exception as e:
        return {"error": str(e)}

runpod.serverless.start({"handler": handler})
