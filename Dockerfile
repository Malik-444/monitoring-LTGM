# Use Python 3.11
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements first
COPY requirements.txt .

# Install application dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Upgrade packages with known security fixes
RUN pip install --no-cache-dir --upgrade \
    setuptools>=78.1.1 \
    msgpack>=1.2.1
    
RUN apt-get update \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/*
# Copy application
COPY app.py .

# Document application port
EXPOSE 5000

# Start Flask application
CMD ["python", "app.py"]
