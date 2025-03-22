# local-env
Development sandbox with various tools
- Python
- Ansible
- Docker
- Kubectl
- Terraform
- Helm

# Build
Open terminal and run
`docker build -t local-env:v0.2  --platform linux/amd64,linux/arm64 -f Dockerfile . `
# Run
Open terminal, change to your work directory, and run 

## On Linux/Mac:
```
docker run -it -v .:/work -v ${HOME}/.ssh:/root/.ssh -v ${HOME}/.kube:/root/.kube -v ./.bash_history:/root/.bash_history -v /var/run/docker.sock:/var/run/docker.sock -w /work --cap-add=NET_ADMIN local-env:v0.2 bash
```

## On Windows
```
docker run -it -v ${PWD}:/work -v ${HOME}\.ssh:/root/.ssh -v ${HOME}\.kube:/root/.kube -v ${PWD}/.bash_history:/root/.bash_history -v //var/run/docker.sock:/var/run/docker.sock -w /work --cap-add=NET_ADMIN local-env:v0.2 bash
```