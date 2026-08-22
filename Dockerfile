FROM python:3.11-slim

WORKDIR /app

# Update Debian packages with the latest security fixes
RUN apt-get update \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/*

# Update Python packaging tools
RUN pip install --no-cache-dir --upgrade pip setuptools wheel

# Copy application dependencies
COPY requirements.txt .

# Install application dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy Flask application
COPY app.py .

EXPOSE 5000

# Start the Flask application
CMD ["python", "app.py"]
