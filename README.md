### Install MiniKube:
- brew install minikube 
- brew install kubectl

### Install Helm:
- brew install helm 

### Install Argo CLI:
- curl -sLO https://github.com/argoproj/argo-workflows/releases/download/v3.2.6/argo-darwin-amd64.gz
- gunzip argo-darwin-amd64.gz
- chmod +x argo-darwin-amd64
- sudo mv ./argo-darwin-amd64 /usr/local/bin/argo
- argo version

### Start:
ensure that docker engine is running 
*your minikube start needs to be done at project source*
- minikube start --driver=docker --memory 4096 --cpus=4 --mount --mount-string=$HOME/dev/ps-wex-k8s/:/tag-core
- eval $(minikube docker-env)
- docker build --rm -t hello-world .
- minikube addons enable ingress
- minikube tunnel
- new shell
- start argoCD ( see below )
- minikube ssh && sudo apt-get update && sudo apt-get install docker-compose-plugin
- docker pull tag.us-east-1.artifactory.wexapps.com/omaha-api:RC-release-178-98af4314df4bacb24ddf20b8b8da016844458bde
- docker pull tag.us-east-1.artifactory.wexapps.com/omaha-web:RC-release-178-98af4314df4bacb24ddf20b8b8da016844458bde
- docker pull mongo:4.2.19
>> note to stop: minikube stop ${namespace} || minikube delete --all

### Docker:
- ```docker build --rm -t hello-world .```

### Helm:
- create charts in helm dir = ```helm create <repo>```
- cd into helm dir
- ```helm install go-app --namespace hello-world --create-namespace ./hello-world```
- ```helm install localstack-tf --namespace local-stack-tf --create-namespace ./ --dry-run --debug```
- ```helm install tag --namespace tag --create-namespace ./tag-core```
- ```helm uninstall tag --namespace tag```


### ArgoCD UI
- kubectl create namespace argocd
- kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
- wait until all have arrived at running `kubectl get all -n argocd`
- kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
- kubectl port-forward svc/argocd-server -n argocd 8080:443
- new shell
- kubectl apply -f manifests/argo


### KeyGen link github
- ssh-keygen -t ed25519 -C "argocd"
- add pub key in repo -> deploy keys

### Argo-Rollouts
- kubectl create namespace aro-rollouts
- kubectl apply -n argo-rollouts -f https://github.com/argoproj/aro-rollouts/releases/latest/download/install.yaml
- kubectl argo rollouts dashboard

