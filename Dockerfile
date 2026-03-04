FROM python:3.11-slim

WORKDIR /app

# Copy dependency files
COPY requirements.txt ./

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code and knowledge base
COPY src/ ./src/
COPY KNOWLEDGE_BASE.md ./

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app

# Run the agent
CMD ["python", "src/main.py"]
