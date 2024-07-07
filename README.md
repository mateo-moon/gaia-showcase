## Practise Test

 1. **Dockerize**: the idea is to create self sufficient image with `gaiad` binary and all required configs. And meanwhile allow container to accept just usual arguments for `gaiad` .
	 _________
	 
	 
 - `make build` (optional) Builds images from current Dockerfile. The image is also available throught docker hub `docker pull oplakida/gaia:v17.2.0` to pull locally
 - `docker run -p 26656 oplakida/gaia:v17.2.0 pruned start` will start node in quick sync mode. After downloading pruned snapshot of db gaiad will start without any additional flags. One may pass any additional flags after `...start`
 - It's possible to feed `docker run -p 26656 oplakida/gaia:v17.2.0` just commands as to `gaiad` binary
 - It's possible to change node name, chain-id and genesis with corresponding flags to `docker run` command: `-e MONIKER=<>, -e CHAIN_ID=<>, -e GENESIS_URL=<>`

2. **K8S**: `make deploy`

