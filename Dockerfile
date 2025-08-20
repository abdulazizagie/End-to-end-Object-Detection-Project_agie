FROM python:3.10.6-slim-buster

# Set environment variables for better Python behavior
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Update APT sources to use archives for EOL Buster
RUN echo "deb http://archive.debian.org/debian buster main" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security buster/updates main" >> /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until && \
    echo 'Acquire::Max-FutureTime 86400;' >> /etc/apt/apt.conf.d/99no-check-valid-until

# Install AWS CLI v2 with timeout and retry logic
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl unzip ca-certificates && \
    curl --connect-timeout 30 --retry 3 --retry-delay 5 \
         "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements first for better layer caching
COPY requirements.txt .

# Install Python dependencies with timeout and better error handling
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir --timeout 60 -r requirements.txt

# Copy application code (this should be after pip install for better caching)
COPY . .

# Create non-root user for security (optional but recommended)
RUN useradd --create-home --shell /bin/bash appuser && \
    chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose port (adjust based on your app)
EXPOSE 8080

# Add healthcheck (optional)
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import requests; requests.get('http://localhost:8080/health', timeout=5)" || exit 1

# Default command
CMD ["python", "app.py"]
