FROM amazonlinux:2

# Install required tools and Python 2.7
RUN yum -y update && \
    yum -y install \
    python27 \
    python27-devel \
    gcc \
    libffi-devel \
    openssl-devel \
    wget \
    tar \
    unzip \
    which && \
    yum clean all

# Install pip2 manually
RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py && \
    python2.7 get-pip.py && \
    rm -f get-pip.py

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
