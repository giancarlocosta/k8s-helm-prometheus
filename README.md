# Prometheus Helm Chart

> Cloned and slightly modified version of
[Stable Kubernetes Prometheus Helm Chart](https://github.com/kubernetes/charts/tree/master/stable/prometheus).
Refer there for more documentation.

## Overview

This Chart allows you to deploy a Prometheus server, Prometheus Alert Manager,
Kube State Metrics server, and Node Exporter Daemonset. Edit all values, alerts,
etc. via the properties/values files.


## Getting Started

1. If you are going to use persistence, _and you are using some custom storage layer such as NFS_,
deploy the Kubernetes PersistentVolumes and PersistentVolumeClaims you define in
`properties/<your-target-cluster>/pre-install/persistent-volumes` for your target
cluster if you haven't already. _If not using a custom storage layer don't worry about this._

2. Specify/update values in `properties/<your-target-cluster>/properties.yaml` for
your target cluster that will be used to overwrite default values of the Chart.

3. Deploy (Helm install/update) using the `properties/` values file for your target cluster.

    Example deployment to Prod ELK env
    ```
    helm --kube-context=prod-elk --namespace ops --name prometheus-prod-elk install . --debug --values properties/prod-elk/properties.yaml
    helm --kube-context=prod-elk --namespace ops upgrade prometheus-prod-elk . --debug --values properties/prod-elk/properties.yaml
    ```

4. Deploy Prometheus data sources.<br/>
Prometheus collects logs from any Kubernetes Services, Deployments, etc. that
have a `"prometheus.io/scrape": "true"` annotation.
```
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: test-service
spec:
  template:
    metadata:
      labels:
        app: test-service
      annotations:
        "prometheus.io/scrape": "true";
...
```
This annotation will tell
Prometheus to scrape the `/metrics` endpoint of the pods for Prometheus formatted
metrics. Make sure if you add this annotation to your service's Deployment, your
service does indeed export Prometheus formatted metrics via a `/metrics` endpoint!
There are good libraries that make it easy to add Prometheus metrics to your services,
for example `express-prom-bundle` for NodeJS/Express services.
In some cases where you can't define the metrics endpoint on your non-custom services,
such as rabbitmq, elasticsearch, redis, etc. you may need to run an "exporter" pod
alongside those pods that collects metric information from those pods and exposes
a /metrics endpoint for Prometheus.
