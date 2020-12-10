import subprocess

import uvicorn as uvicorn
from fastapi import FastAPI

app = FastAPI(title="Lighthouse Extractor", version="0.1")

API_PORT = 5058


@app.get("/accessibility")
def accessibility():
    url = "https://www.google.com"
    strategy = "mobile"
    cmd = [
        f"lighthouse",
        url,
        "--enable-error-reporting",
        "--chrome-flags='--headless --no-sandbox --disable-gpu'",
        f"--emulated-form-factor={strategy}",
        "--output=json",
        "--quiet",
    ]

    p = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )

    output = []

    for line in iter(p.stdout.readline, b""):
        output.append(line.decode())
    output = "".join(output)

    return {"status": "ok", "output": output}


@app.get("/_ping")
def ping():
    return {"status": "ok"}


uvicorn.run(app, host="0.0.0.0", port=API_PORT, log_level="info")
