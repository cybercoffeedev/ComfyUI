ARG IMAGE=cpu
ARG PY_VER=3.13

FROM ubuntu:24.04 AS cpu
FROM nvidia/cuda:13.0.2-base-ubuntu24.04 AS cuda

FROM ${IMAGE} AS comfy

ARG PY_VER
RUN apt update && apt install -y --no-install-recommends \
    software-properties-common && add-apt-repository ppa:deadsnakes/ppa && \
    apt update && apt install -y --no-install-recommends \
    python${PY_VER} \
    python3-pip \
    git && \
    ln -sf /usr/bin/python${PY_VER} /usr/bin/python && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

ARG IMAGE
RUN if [ "$IMAGE" = "cuda" ]; then \
        export INDEX="https://download.pytorch.org/whl/cu130" EXTRA_FLAGS=""; \
    else \
        export INDEX="https://download.pytorch.org/whl/cpu" EXTRA_FLAGS="--cpu"; \
    fi && \
    python -m pip install --no-cache-dir torch torchvision torchaudio --index-url $INDEX --break-system-packages && \
    python -m pip install --no-cache-dir -r requirements.txt --break-system-packages && \
    echo $EXTRA_FLAGS > /app/extra_flags

ENTRYPOINT [ "sh", "-c", "python main.py --listen $(cat /app/extra_flags)" ]