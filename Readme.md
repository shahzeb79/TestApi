# Building and Deploying a Distributed Web API Application to Kubernetes

This guide outlines the process of building and deploying a distributed web API application into a Kubernetes cluster. The application consists of a .NET Core Web API backend and an Nginx-powered file server serving a static JSON file.

## Prerequisites

- Docker installed on your local machine
- minikube installed on machine

## Launch Complete Solution Locally with following commands in the root directory of current folder using Command Prompt or Terminal of VS Code:

1. `minikube start`
This will start minikube(local kubernetes cluster) on your machine. Prerequisite is to have minikube installed locally and docker running in background.

2. `kubectl create ns development`
This command will create development namespace on kubernetes cluster to keep resources separate.

3. `kubectl config set-context --current --namespace=development`
This command will switch default namespace to development.

4. `kubectl apply -f deployment.yaml`
This command will create two deployments using deployment file in kubernestes cluster i.e nginx(1 pod) and webapi(3 pods)

5. `kubectl apply -f service.yaml`
This command will create 2 services. One for nginx file server which is having clusterIP and not exposed and 2nd for webapi which has loadbalancer and gets an IP address to access from outside.

6. `minikube tunnel`
This will help to create loadbalancer as in local setup we dont have any loadbalancers configured.

After all these commands, you can access webAPI in browser using link http://127.0.0.1/weatherforecast or http://127.0.0.1/weatherforecast/stats or http://127.0.0.1/weatherforecast/fetch

# Complete Solution CI/CD Process using GitOps

The complete CI/CD process is automated using Azure DevOps and ArgoCD. The final API is deployed to AKS kubernetes cluster provisioned through terraform.
The final solution consists of 3 parts:
- CI of .Net app via [AzureDevops](https://dev.azure.com/shahzeb799/TestApi/_build?definitionId=1)
- CD of .Net app to AKS cluster via [ArgoCD](https://github.com/shahzeb79/Kube_Manifest_TestApi)
- AKS Cluster provision using Terraform via [AzureDevops](https://github.com/shahzeb79/terraform)

This whole prcess is controlled via code in github repor. Any changes to application source code will trigger CI pipeline in Azure Devops which will deploy final container to Docker registry. CI pipeline will also update our deployment manifests in another github repo. The update of manifests in deployment repo will automatically trigger ArgoCD job that will deploy our containers to kubernetes.
The API is exposed via AKS loadbalancer on kubernetes service and can be accessed via http://98.67.234.212/weatherforecast
All above links require authorization, and access can be granted upon request.

## Build Docker Images

### Web API Application:

Unzip the provided TestApi.zip file containing the source code for the .NET Core Web API application.
There is Dockerfile in the TestApi directory of the project.
Build the Docker image using the following command in TestApi directory.

`docker build shahzeb799/testapi:latest .`

### Nginx File Server:

There is Dockerfile in the root directory of the project to create nginx container.
Update the default configuration of nginx using nginx.conf file to serve the static JSON file.
Build the Docker image using the following command in root directory of this project.

`docker build shahzeb799/nginx:latest .`

After that, you can push images to container registry using following commands (You need to be authenticated with docker registry before):

`docker push shahzeb799/testapi:latest`
`docker push shahzeb799/nginx:latest`

### Links to docker images:

https://hub.docker.com/r/shahzeb799/testapi
https://hub.docker.com/r/shahzeb799/nginx




