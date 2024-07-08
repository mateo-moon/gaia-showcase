## Practise Test

 1. **Dockerize**: the idea is to create self sufficient image with `gaiad` binary and all required configs. And meanwhile allow container to accept just usual arguments for `gaiad` .
	 _________
	 
	 
 -  `make build` (optional) Builds images from current Dockerfile. The image is also available throught docker hub `docker pull oplakida/gaia:v17.2.0` to pull locally
 - `docker run -p 26656 oplakida/gaia:v17.2.0 pruned start` will start node in quick sync mode. After downloading pruned snapshot of db gaiad will start without any additional flags. One may pass any additional flags after `...start`
 - It's possible to feed `docker run -p 26656 oplakida/gaia:v17.2.0` just commands as to `gaiad` binary
 - It's possible to change node name, chain-id and genesis with corresponding flags to `docker run` command: `-e MONIKER=<>, -e CHAIN_ID=<>, -e GENESIS_URL=<>`

2. **K8S**:  using image above deploy statefulSet with persistent volume(keep in mind size of volume is set to 10Gi in this example, but in eral life you will need 600-1500Gi depending on node type). Deployment is done with helm Chart and utilize default config files for node which could be cusotmized by helm values.yaml. Default `cmd` for container is set to `pruned start` wich triggers `init_pruned.sh` script. That script will init a new node and start quicksync process.

----------

- edit `helm/values.yaml` file
- `make deploy` will run `helm install --name gaia -n gaia ./helm`


3. **Observabilities**: One of the part of previous step is to alter `config.tml` file and turn on exposure of prometheus metrics from container. In order to utilize this endpoint there is ` ServiceMonitor` resource in the helm release. There should be installed Prometheus operator in order to scrape them.

4. **Script kiddies**: `init_pruned.sh`
5. **Script grown-ups**: TODO
6. **Terraform lovers unite**: All required resource including ones requiered for terraform initialization are in `terraform` directory. One just need to run `terraform init && terraform apply` in order to deploy everything. Although there are some prerequisites:

- There should be set up AWS creds.
- (Optional) Commmit out S3 remote backend in `terraform/backend` after first apply and apply once again if you want to keep remote state.
