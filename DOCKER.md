# Docker Deployment Guide

Complete guide for containerizing and deploying the Acme Dental AI Agent.

## Quick Start

```bash
# Build the image
docker build -t acme-dental-agent .

# Run with environment file
docker run --env-file .env -it acme-dental-agent

# Or run with inline environment variables
docker run -e LLM_PROVIDER=openai -e OPENAI_API_KEY=your-key -it acme-dental-agent
```

## Dockerfile Overview

The project includes an optimized multi-stage Dockerfile:

```dockerfile
FROM python:3.11-slim

# Install uv package manager
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

# Set working directory
WORKDIR /app

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies
RUN uv sync --frozen --no-cache

# Copy application code
COPY . .

# Run the application
CMD ["uv", "run", "python", "src/main.py"]
```

## Build Options

### Standard Build
```bash
docker build -t acme-dental-agent .
```

### Build with Custom Tag
```bash
docker build -t acme-dental-agent:v1.0.0 .
```

### Build with Build Args
```bash
docker build --build-arg PYTHON_VERSION=3.11 -t acme-dental-agent .
```

### Multi-Platform Build
```bash
docker buildx build --platform linux/amd64,linux/arm64 -t acme-dental-agent .
```

## Running Containers

### Interactive Mode (Development)
```bash
docker run -it --env-file .env acme-dental-agent
```

### Detached Mode (Production)
```bash
docker run -d --name dental-agent --env-file .env acme-dental-agent
```

### With Volume Mounts (Development)
```bash
docker run -it \
  --env-file .env \
  -v $(pwd)/src:/app/src \
  acme-dental-agent
```

### With Custom Environment
```bash
docker run -it \
  -e LLM_PROVIDER=openai \
  -e OPENAI_API_KEY=sk-proj-your-key \
  -e CALENDLY_API_TOKEN=your-token \
  acme-dental-agent
```

## Environment Configuration

### Using .env File (Recommended)
```bash
# Create .env file
cp .env.example .env
# Edit .env with your API keys

# Run with env file
docker run --env-file .env -it acme-dental-agent
```

### Using Environment Variables
```bash
docker run \
  -e LLM_PROVIDER=openai \
  -e OPENAI_API_KEY=sk-proj-your-key \
  -e CALENDLY_API_TOKEN=your-token \
  -it acme-dental-agent
```

### Using Docker Secrets (Production)
```bash
# Create secrets
echo "sk-proj-your-key" | docker secret create openai_key -
echo "your-token" | docker secret create calendly_token -

# Use in docker-compose or swarm
```

## Docker Compose

### Basic docker-compose.yml
```yaml
version: '3.8'

services:
  dental-agent:
    build: .
    environment:
      - LLM_PROVIDER=openai
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - CALENDLY_API_TOKEN=${CALENDLY_API_TOKEN}
    stdin_open: true
    tty: true
```

### Production docker-compose.yml
```yaml
version: '3.8'

services:
  dental-agent:
    build: .
    env_file:
      - .env
    restart: unless-stopped
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
    healthcheck:
      test: ["CMD", "python", "-c", "from src.services.llm import get_llm; get_llm()"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
```

### With Redis Cache
```yaml
version: '3.8'

services:
  dental-agent:
    build: .
    env_file:
      - .env
    depends_on:
      - redis
    environment:
      - REDIS_URL=redis://redis:6379

  redis:
    image: redis:7-alpine
    restart: unless-stopped
    volumes:
      - redis_data:/data

volumes:
  redis_data:
```

## Production Deployment

### Health Checks
```dockerfile
# Add to Dockerfile
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD python -c "from src.services.llm import get_llm; get_llm()" || exit 1
```

### Resource Limits
```bash
docker run \
  --memory=512m \
  --cpus=0.5 \
  --env-file .env \
  acme-dental-agent
```

### With Restart Policy
```bash
docker run -d \
  --name dental-agent \
  --restart=unless-stopped \
  --env-file .env \
  acme-dental-agent
```

## Kubernetes Deployment

### Basic Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dental-agent
spec:
  replicas: 1
  selector:
    matchLabels:
      app: dental-agent
  template:
    metadata:
      labels:
        app: dental-agent
    spec:
      containers:
      - name: dental-agent
        image: acme-dental-agent:latest
        env:
        - name: LLM_PROVIDER
          value: "openai"
        - name: OPENAI_API_KEY
          valueFrom:
            secretKeyRef:
              name: api-keys
              key: openai-key
        - name: CALENDLY_API_TOKEN
          valueFrom:
            secretKeyRef:
              name: api-keys
              key: calendly-token
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:
          exec:
            command:
            - python
            - -c
            - "from src.services.llm import get_llm; get_llm()"
          initialDelaySeconds: 30
          periodSeconds: 30
        readinessProbe:
          exec:
            command:
            - python
            - -c
            - "from src.services.llm import get_llm; get_llm()"
          initialDelaySeconds: 10
          periodSeconds: 10
```

### ConfigMap for Environment
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: dental-agent-config
data:
  LLM_PROVIDER: "openai"
  CALENDLY_TIMEOUT: "30"
```

### Secret for API Keys
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: api-keys
type: Opaque
data:
  openai-key: <base64-encoded-key>
  calendly-token: <base64-encoded-token>
```

## Monitoring & Logging

### Container Logs
```bash
# View logs
docker logs dental-agent

# Follow logs
docker logs -f dental-agent

# View last 100 lines
docker logs --tail 100 dental-agent
```

### Log Configuration
```yaml
# docker-compose.yml
services:
  dental-agent:
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

### Monitoring with Prometheus
```yaml
# Add to docker-compose.yml
services:
  dental-agent:
    # ... existing config
    labels:
      - "prometheus.io/scrape=true"
      - "prometheus.io/port=8000"
```

## Security Best Practices

### Non-Root User
```dockerfile
# Add to Dockerfile
RUN adduser --disabled-password --gecos '' appuser
USER appuser
```

### Minimal Base Image
```dockerfile
FROM python:3.11-slim  # Instead of full python image
```

### Multi-Stage Build
```dockerfile
# Build stage
FROM python:3.11-slim as builder
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv
WORKDIR /app
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-cache

# Runtime stage
FROM python:3.11-slim
COPY --from=builder /app/.venv /app/.venv
WORKDIR /app
COPY . .
CMD ["/app/.venv/bin/python", "src/main.py"]
```

### Secrets Management
```bash
# Use Docker secrets instead of environment variables
docker secret create openai_key openai_key.txt
docker service create \
  --secret openai_key \
  --env OPENAI_API_KEY_FILE=/run/secrets/openai_key \
  acme-dental-agent
```

## Troubleshooting

### Common Issues

#### Container Exits Immediately
```bash
# Check logs
docker logs dental-agent

# Run interactively to debug
docker run -it --env-file .env acme-dental-agent /bin/bash
```

#### Permission Denied Errors
```bash
# Check file permissions
ls -la

# Fix permissions
chmod +x src/main.py
```

#### API Connection Issues
```bash
# Test API connectivity from container
docker run -it --env-file .env acme-dental-agent python -c "
from src.services.llm import get_llm
llm = get_llm()
print('LLM connection OK')
"
```

#### Memory Issues
```bash
# Check container resource usage
docker stats dental-agent

# Increase memory limit
docker run --memory=1g --env-file .env acme-dental-agent
```

### Debug Mode
```bash
# Run with debug environment
docker run -it \
  --env-file .env \
  -e DEBUG=1 \
  acme-dental-agent
```

### Shell Access
```bash
# Get shell in running container
docker exec -it dental-agent /bin/bash

# Or run new container with shell
docker run -it --env-file .env acme-dental-agent /bin/bash
```

## Performance Optimization

### Image Size Optimization
```dockerfile
# Use .dockerignore
echo "*.pyc\n__pycache__\n.git\n*.md" > .dockerignore

# Multi-stage build
FROM python:3.11-slim as builder
# ... build dependencies
FROM python:3.11-slim as runtime
COPY --from=builder /app/.venv /app/.venv
```

### Build Cache Optimization
```dockerfile
# Copy requirements first for better caching
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-cache

# Copy code after dependencies
COPY . .
```

### Runtime Optimization
```bash
# Use specific Python optimizations
docker run \
  -e PYTHONUNBUFFERED=1 \
  -e PYTHONDONTWRITEBYTECODE=1 \
  --env-file .env \
  acme-dental-agent
```

## Registry & Distribution

### Push to Docker Hub
```bash
# Tag image
docker tag acme-dental-agent username/acme-dental-agent:latest

# Push to registry
docker push username/acme-dental-agent:latest
```

### Private Registry
```bash
# Tag for private registry
docker tag acme-dental-agent registry.company.com/acme-dental-agent:latest

# Push to private registry
docker push registry.company.com/acme-dental-agent:latest
```

### GitHub Container Registry
```bash
# Tag for GHCR
docker tag acme-dental-agent ghcr.io/username/acme-dental-agent:latest

# Login and push
echo $GITHUB_TOKEN | docker login ghcr.io -u username --password-stdin
docker push ghcr.io/username/acme-dental-agent:latest
```

## CI/CD Integration

### GitHub Actions
```yaml
name: Build and Push Docker Image

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Build Docker image
      run: docker build -t acme-dental-agent .
    
    - name: Test Docker image
      run: |
        docker run --rm \
          -e LLM_PROVIDER=openai \
          -e OPENAI_API_KEY=${{ secrets.OPENAI_API_KEY }} \
          acme-dental-agent python -c "print('Container test passed')"
    
    - name: Push to registry
      run: |
        echo ${{ secrets.DOCKER_PASSWORD }} | docker login -u ${{ secrets.DOCKER_USERNAME }} --password-stdin
        docker push acme-dental-agent
```

This comprehensive Docker guide covers all aspects of containerizing and deploying the Acme Dental AI Agent, from basic usage to production-ready deployments with Kubernetes.