FROM nvidia/cuda:12.2.2-base-ubuntu22.04
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /ComfyUI
COPY . .

RUN apt update && apt install -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt update && apt install -y python3.12 python3.12-venv python3-pip

RUN python3.12 -m venv /ComfyUI/venv && \
    /ComfyUI/venv/bin/pip install --upgrade pip && \
    /ComfyUI/venv/bin/pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118 && \
    /ComfyUI/venv/bin/pip install -r requirements.txt

ENV PATH="/ComfyUI/venv/bin:$PATH"
CMD ["python", "main.py", "--listen"]
