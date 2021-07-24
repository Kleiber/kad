# Example

```bash
$ cat ~/.bashrc
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

export NAMESPACE=kleiber
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
export DOCKER_REGISTRY=localhost:5000
export DOCKER_TAG=kleiber
```

```bash
$ kad install helm
Installing helm version v3.6.2 for linux OS...
Helm version v3.6.2 was installed successfully.
```

```bash
$ kad install kubectl
Installing kubectl version v1.21.2 for linux OS...
Kubectl version v1.21.2 was installed successfully.
```

```bash
$ kad install golang
Installing golang version 1.16.5 for linux OS...
Golang version 1.16.5 was installed successfully.
```

```bash
$ kad install k3s
Installing k3s version v1.21.2+k3s1 for linux OS...
[INFO]  Using v1.21.2+k3s1 as release
[INFO]  Downloading hash https://github.com/k3s-io/k3s/releases/download/v1.21.2+k3s1/sha256sum-amd64.txt
[INFO]  Downloading binary https://github.com/k3s-io/k3s/releases/download/v1.21.2+k3s1/k3s
[INFO]  Verifying binary download
[INFO]  Installing k3s to /usr/local/bin/k3s
[INFO]  Skipping /usr/local/bin/kubectl symlink to k3s, already exists
[INFO]  Creating /usr/local/bin/crictl symlink to k3s
[INFO]  Skipping /usr/local/bin/ctr symlink to k3s, command exists in PATH at /usr/bin/ctr
[INFO]  Creating killall script /usr/local/bin/k3s-killall.sh
[INFO]  Creating uninstall script /usr/local/bin/k3s-uninstall.sh
[INFO]  env: Creating environment file /etc/systemd/system/k3s.service.env
[INFO]  systemd: Creating service file /etc/systemd/system/k3s.service
[INFO]  systemd: Enabling k3s unit
Created symlink /etc/systemd/system/multi-user.target.wants/k3s.service → /etc/systemd/system/k3s.service.
[INFO]  systemd: Starting k3s
namespace/kleiber created
Context "default" modified.
K3s version v1.21.2+k3s1 was installed successfully.
```

```bash
$ kad registry init
Starting registry localhost:5000...
Unable to find image 'registry:2' locally
2: Pulling from library/registry
ddad3d7c1e96: Already exists 
6eda6749503f: Pull complete 
363ab70c2143: Pull complete 
5b94580856e6: Pull complete 
12008541203a: Pull complete 
Digest: sha256:aba2bfe9f0cff1ac0618ec4a54bfefb2e685bbac67c8ebaf3b6405929b3e616f
Status: Downloaded newer image for registry:2
8b246ec5e0c95aa5c9a11aa48294f9999d8a16a52e9c9329ef3733c07e44384e
Starting registry completed successfully.
```

```bash
$ cd example
```

## Images

```bash
$ kad docker build --dockerfile app --image kad
Building dockerfile at app...
Sending build context to Docker daemon  4.608kB
Step 1/10 : FROM golang
latest: Pulling from library/golang
627b765e08d1: Pull complete 
c040670e5e55: Pull complete 
073a180f4992: Pull complete 
bf76209566d0: Pull complete 
6182a456504b: Pull complete 
cc29a4876382: Pull complete 
ff36ba465698: Pull complete 
Digest: sha256:4544ae57fc735d7e415603d194d9fb09589b8ad7acd4d66e928eabfb1ed85ff1
Status: Downloaded newer image for golang:latest
 ---> 028d102f774a
Step 2/10 : WORKDIR $GOPATH/src
 ---> Running in e7f2d303b824
Removing intermediate container e7f2d303b824
 ---> fae42e661d74
Step 3/10 : RUN mkdir app
 ---> Running in a45a127e9229
Removing intermediate container a45a127e9229
 ---> 8e48599f09b8
Step 4/10 : COPY go.mod app/go.mod
 ---> a3bfe0498399
Step 5/10 : COPY main.go app/main.go
 ---> 53d38e8c22d1
Step 6/10 : WORKDIR $GOPATH/src/app
 ---> Running in ca84cc724340
Removing intermediate container ca84cc724340
 ---> 9976b3af8292
Step 7/10 : RUN go mod tidy
 ---> Running in e4bd602a3cef
go: downloading github.com/gorilla/mux v1.8.0
Removing intermediate container e4bd602a3cef
 ---> 693689d19ae1
Step 8/10 : RUN go install main.go
 ---> Running in 38d1f54ef877
Removing intermediate container 38d1f54ef877
 ---> 94d2bb320e5e
Step 9/10 : EXPOSE 8080
 ---> Running in c32acfb9f234
Removing intermediate container c32acfb9f234
 ---> 5911174459f9
Step 10/10 : CMD ["main"]
 ---> Running in 81d7cd026600
Removing intermediate container 81d7cd026600
 ---> 94bb5b3748e3
Successfully built 94bb5b3748e3
Successfully tagged kad:latest
Build dockerfile completed successfully.
```

```bash
$ kad docker push --image kad
Pushing kad image to localhost:5000 registry...
Using default tag: latest
The push refers to repository [localhost:5000/kad]
0b946d759312: Pushed 
09d797223b42: Pushed 
1cb1cc85739c: Pushed 
c1fb70eead53: Pushed 
c69af10b32dd: Pushed 
9672a02ff8cf: Pushed 
e46b2fd4e4ea: Pushed 
d1c59e37fbfc: Pushed 
ad83f0aa5c0a: Pushed 
5a9a65095453: Pushed 
4b0edb23340c: Pushed 
afa3e488a0ee: Pushed 
latest: digest: sha256:443f1a806c220fc9314acbe5f32e25ba4aecf1bf2c1efceb0fb6566794dfddef size: 2837
Push image completed successfully.
```

```bash
$ kad registry ls
REGISTRY/IMAGE      TAG
localhost:5000/kad  latest
```

## Chart

```
my-chart
|-- Chart.yaml
|-- charts
|-- crds
|-- templates
|   |-- configmap.yaml
|   |-- ingress.yaml
|   |-- service.yaml
|   `-- statefulset.yaml
`-- values.yaml
```

```bash
$ kad deploy install --name kad --chart my-chart
Deploying kad from my-chart chart...
NAME: kad
LAST DEPLOYED: Sat Jul 24 22:04:49 2021
NAMESPACE: kleiber
STATUS: deployed
REVISION: 1
TEST SUITE: None
Deploy kad completed successfully.
```

```bash
$ kad deploy ls
NAME       	NAMESPACE  	REVISION	UPDATED                                 	STATUS  	CHART             	APP VERSION
kad        	kleiber    	1       	2021-07-24 22:04:49.879751074 +0200 CEST	deployed	my-chart-v1       	           
traefik    	kube-system	1       	2021-07-24 19:43:22.376582588 +0000 UTC 	deployed	traefik-9.18.2    	2.4.8
traefik-crd	kube-system	1       	2021-07-24 19:43:20.943949275 +0000 UTC 	deployed	traefik-crd-9.18.2	
```

## App

```bash
$ kubectl get pods
NAME                READY   STATUS    RESTARTS   AGE
statefulset-kad-0   1/1     Running   0          5s
statefulset-kad-1   1/1     Running   0          4s
statefulset-kad-2   1/1     Running   0          3s
```

```bash
i865255@PHLL41000201D:~/kad/example (master)$ kubectl get statefulset
NAME              READY   AGE
statefulset-kad   3/3     17s
```

```bash
i865255@PHLL41000201D:~/kad/example (master)$ kubectl get configmap
NAME               DATA   AGE
configmap-kad      2      23s
kube-root-ca.crt   1      23s
```

```bash
i865255@PHLL41000201D:~/kad/example (master)$ kubectl get service
NAME          TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service-kad   ClusterIP   10.43.144.212   <none>        8080/TCP   30s
```

```bash
$ kubectl logs statefulset-kad-0
Initializing the router...
Starting server "localhost" on port "8080"...
$ kubectl logs statefulset-kad-1
Initializing the router...
Starting server "localhost" on port "8080"...
$ kubectl logs statefulset-kad-2
Initializing the router...
Starting server "localhost" on port "8080"...
```

```bash
$ kubectl port-forward svc/service-kad 8080
Forwarding from 127.0.0.1:8080 -> 8080
Forwarding from [::1]:8080 -> 8080
```

```bash
$ curl http://127.0.0.1:8080/hello
Hello "kad" application version "latest"!!!!
```

```bash
$ kad deploy uninstall --name kad
Undeploying kad deploy...
release "kad" uninstalled
No resources found
No resources found
secret "default-token-x8djx" deleted
configmap "kube-root-ca.crt" deleted
namespace "kleiber" deleted
Undeploy kad completed successfully.
```

```bash
$ kad deploy ls
NAME       	NAMESPACE  	REVISION	UPDATED                                	STATUS  	CHART             	APP VERSION
traefik    	kube-system	1       	2021-07-24 19:43:22.376582588 +0000 UTC	deployed	traefik-9.18.2    	2.4.8
traefik-crd	kube-system	1       	2021-07-24 19:43:20.943949275 +0000 UTC	deployed	traefik-crd-9.18.2
```
