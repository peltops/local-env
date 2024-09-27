FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update; \
    apt-get install -y curl wget python3-pip openssh-client iputils-ping netcat vim unzip 
RUN apt-get install -y gnupg software-properties-common groff
RUN pip3 install ansible docker pyyaml kubernetes
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

RUN apt-get install -y apt-transport-https ca-certificates gnupg
RUN wget -O- https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | \
    gpg --dearmor | \
    tee /usr/share/keyrings/kubernetes-apt-keyring.gpg > /dev/null \
    chmod 644 /usr/share/keyrings/kubernetes-apt-keyring.gpg 
RUN echo 'deb [signed-by=/usr/share/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
RUN chmod 644 /etc/apt/sources.list.d/kubernetes.list 
RUN apt-get update; \ 
    apt-get install -y kubectl bash-completion

RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
RUN chmod 700 get_helm.sh
RUN ./get_helm.sh
RUN echo "source <(kubectl completion bash)" >> ~/.bashrc

RUN apt-get install -y trickle
RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
RUN chmod a+r /etc/apt/keyrings/docker.asc
RUN echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \       
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update
RUN apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin