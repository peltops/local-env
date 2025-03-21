## Build
Open terminal and run
`docker build -t local-env:v0.2 -f Dockerfile .`
## Run
Open terminal, change to your work directory, and run 
```
docker run -it -v .:/work -v ${HOME}/.ssh:/root/.ssh -v ${HOME}/.kube:/root/.kube -v ./.bash_history:/root/.bash_history -v /var/run/docker.sock:/var/run/docker.sock -w /work --cap-add=NET_ADMIN local-env:v0.2 bash
```