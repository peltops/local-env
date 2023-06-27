FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update; \
    apt-get install -y curl wget python3-pip openssh-client iputils-ping netcat vim
RUN pip3 install ansible docker pyyaml
RUN ansible --version
RUN mkdir /etc/ansible
RUN echo "[ssh_connection]" > /etc/ansible/ansible.cfg
RUN echo "control_path_dir=/dev/shm/ansible_control_path" >> /etc/ansible/ansible.cfg
