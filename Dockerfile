FROM docker.io/library/fedora:30

ARG tfvers='0.11.14'
ARG user=demo
ARG uid=1000
ARG gid=1000

# Create working user
RUN \
    groupadd -f -g ${gid} ${user}; \
    useradd -d /home/${user} -s /bin/bash -u ${uid} -g ${gid} ${user}

# Install dependencies
RUN dnf update -y;
RUN dnf install -y \
        ansible \
        awscli \
        bash \
        bind-utils \
        docker \
        gcc \
        git \
        hostname \
        iputils \
        lastpass-cli \
        less \
        letsencrypt \
        libcurl-devel \
        libxml2 \
        libxml2-devel \
        make \
        net-tools \
        openssh \
        openssh-clients \
        openssl-devel \
        podman \
        python2-boto \
        python2-pycurl \
        python2-virtualenv \
        python3-boto \
        python3-dns \
        python3-dns-lexicon \
        python3-pycurl \
        python3-virtualenv \
        python3-virtualenvwrapper \
        tmux \
        unzip \
        vim \
        wget \
        zip; \
    pip install ovirt-engine-sdk-python; \
    pip3 install ovirt-engine-sdk-python;

# Install Terraform
RUN \
    mkdir /tmp/tf; \
    cd /tmp/tf; \
    wget https://releases.hashicorp.com/terraform/${tfvers}/terraform_${tfvers}_linux_amd64.zip; \
    unzip -qq terraform_${tfvers}_linux_amd64.zip; \
    mv terraform /usr/local/bin; \
    cd; \
    rm -rf /tmp/tf

# Setup docker sock
RUN \
    touch /var/run/docker.sock; \
    chown root:${gid} /var/run/docker.sock

# Setup startup environment
USER ${user}
WORKDIR /home/${user}
CMD /bin/bash
