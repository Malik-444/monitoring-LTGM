FROM python:3.11-slim

WORKDIR /app

# Update Debian packages to receive the latest security fixes
RUN apt-get update \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/*

# Copy Python dependencies
COPY requirements.txt .

# Install application dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application
COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]
