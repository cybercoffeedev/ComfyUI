# Base image
FROM ubuntu:24.04 AS base

# Install system dependencies
RUN apt update && apt install -y --no-install-recommends \
    software-properties-common && add-apt-repository ppa:deadsnakes/ppa && \
    apt update && apt install -y --no-install-recommends \
    python3.12 \
    python3-pip \
    git && \
    rm -rf /var/lib/apt/lists/*
    
WORKDIR /app
COPY . .

# Install dependencies with PIP
RUN pip install --no-cache-dir torch torchvision torchaudio \
    --index-url https://download.pytorch.org/whl/cpu --break-system-packages \
    && pip install --no-cache-dir -r requirements.txt --break-system-packages

# Default entrypoint
ENTRYPOINT ["python3.12", "main.py", "--listen", "--cpu"]

# CUDA image
FROM nvidia/cuda:12.9.0-base-ubuntu24.04 AS cuda

# Install system dependencies
RUN apt update && apt install -y --no-install-recommends \
    software-properties-common && add-apt-repository ppa:deadsnakes/ppa && \
    apt update && apt install -y --no-install-recommends \
    python3.12 \
    python3-pip \
    git && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

# Install dependencies with PIP
RUN pip install --no-cache-dir torch torchvision torchaudio \
    --index-url https://download.pytorch.org/whl/cu128 --break-system-packages \
    && pip install --no-cache-dir -r requirements.txt --break-system-packages

# Default entrypoint
ENTRYPOINT ["python3.12", "main.py", "--listen"]
