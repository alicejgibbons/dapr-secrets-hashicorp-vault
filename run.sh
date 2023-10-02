# Pre-reqs: K8s cluster with Dapr installed
# Follow the instructions here up until the completion of a "Set a secret in Vault" section: https://developer.hashicorp.com/vault/tutorials/kubernetes/kubernetes-minikube-raft

# Build and push the sample app to a docker registry of your choice. Instructions here for m1 Mac.
DOCKER_REGISTRY=<YOUR_DOCKER_REGISTRY>
cd src/order-processor
docker buildx build --platform linux/amd64 -t $DOCKER_REGISTRY/orders-secrets:latest .
docker push $DOCKER_REGISTRY/orders-secrets:latest

# Update the K8s manifest with your docker image
kubectl apply -f deploy/deploy.yaml

# Copy and paste your token from cluster-keys.json into <VAULT_TOKEN> in components/vault.yaml
cd ../..
jq -r ".root_token" cluster-keys.json
kubectl apply -f components/vault.yaml

kubectl logs -l app=orders-secrets

## Sample output:
# Defaulted container "orders-secrets" out of: orders-secrets, daprd

# > order-processor@1.0.0 start
# > node index.js

# Fetching secret: config from: vault with no metadata
# 2023-10-02T22:29:08.138Z INFO [HTTPClient, HTTPClient] Awaiting Sidecar to be Started
# 2023-10-02T22:29:18.709Z INFO [HTTPClient, HTTPClient] Sidecar Started
# Fetched Secret: {"password":"static-password","username":"static-user"}