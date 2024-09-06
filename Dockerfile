FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update; \
    apt-get install -y curl wget python3-pip openssh-client iputils-ping netcat vim unzip 
RUN apt-get install -y gnupg software-properties-common groff
RUN pip3 install ansible docker pyyaml
RUN ansible --version
RUN mkdir /etc/ansible
RUN echo "[ssh_connection]" > /etc/ansible/ansible.cfg
RUN echo "control_path_dir=/dev/shm/ansible_control_path" >> /etc/ansible/ansible.cfg

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
RUN gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list
RUN apt update
RUN apt-get install -y terraform

RUN wget -qO- https://get.pnpm.io/install.sh | ENV="$HOME/.bashrc" SHELL="$(which bash)" bash -
RUN export PNPM_HOME="/root/.local/share/pnpm"; \
    export PATH="$PNPM_HOME:$PATH"; \
    pnpm env use --global lts
