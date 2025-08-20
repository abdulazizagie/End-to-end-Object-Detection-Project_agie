FROM python:3.10.6-slim-buster

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Update APT sources
RUN echo "deb http://archive.debian.org/debian buster main" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security buster/updates main" >> /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until && \
    echo 'Acquire::Max-FutureTime 86400;' >> /etc/apt/apt.conf.d/99no-check-valid-until

# Install system dependencies (including build tools for ML packages)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        unzip \
        ca-certificates \
        build-essential \
        gcc \
        g++ \
        make \
        pkg-config \
        libhdf5-dev \
        libopencv-dev \
        python3-dev && \
    curl --connect-timeout 30 --retry 3 --retry-delay 5 \
         "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir --timeout 180 -r requirements.txt

COPY . .

EXPOSE 8080
CMD ["python", "app.py"]
