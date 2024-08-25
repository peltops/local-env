## Build
`docker build -t local-env:v0.2 -f Dockerfile`
## Run
`docker run -it -v ${PWD}:/work -w /work local-env:v0.2 bash`