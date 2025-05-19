FROM amazonlinux:2

# Update OS and install dependencies
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
    curl \
    which && \
    yum clean all

# Install pip2 manually using get-pip.py
RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py && \
    python2.7 get-pip.py && \
    rm -f get-pip.py

# Set python2 and pip2 as default python and pip (optional, if needed)
RUN alternatives --install /usr/bin/python python /usr/bin/python2.7 1 && \
    alternatives --install /usr/bin/pip pip /usr/local/bin/pip2 1

# Create application directory
RUN mkdir -p /usr/src/app

# Set working directory
WORKDIR /usr/src/app

# Copy requirements and install Python dependencies
COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy application source code
COPY . /usr/src/app

# Set environment variable
ENV PORT 8080

# Expose port
EXPOSE $PORT

# Set up persistent volume
VOLUME ["/app-data"]

# Run the application
CMD gunicorn -b :$PORT -c gunicorn.conf.py main:app
