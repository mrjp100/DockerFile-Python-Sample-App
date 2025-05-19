FROM amazonlinux:2

# Install required tools and Python 2.7
RUN yum -y update && \
    yum -y install \
    python27 \
    python27-pip \
    gcc \
    python27-devel \
    libffi-devel \
    openssl-devel \
    wget \
    unzip \
    tar \
    which && \
    yum clean all

# Upgrade pip to latest version for Python 2
RUN pip2 install --upgrade pip

# Create application source directory
RUN mkdir -p /usr/src/app

# Set working directory
WORKDIR /usr/src/app

# Install Python dependencies
COPY requirements.txt /usr/src/app/
RUN pip2 install --no-cache-dir -r requirements.txt

# Copy application source code
COPY . /usr/src/app

# Environment variables
ENV PORT 8080

# Expose application port
EXPOSE $PORT

# Persistent volume
VOLUME ["/app-data"]

# Start the application
CMD gunicorn -b :$PORT -c gunicorn.conf.py main:app
