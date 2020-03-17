# Playing with Multi-Cluster Topology and EndpointSlice

Either use these scripts as a reference (`demo.sh` will be most useful), or
use them to set up example clusters and run through a live demo.

## Setup

Set `KUBE_ROOT` to the path to a K8s 1.17 installation, and `PROJECT` to the name
of your GCP project, then run `./setup/clusters-up.sh` to start 2 clusters in
your current GCP project. Each cluster will have a total of 6 nodes, 3 in
us-central1-a and 3 in us-central1-b.

The clusters will be created with contexts `cluster-1` and `cluster-2`
respectively.

If creating your own clusters on another platform, either use the same names or
update `demo.sh` accordingly.

## Demo

Run `./demo.sh` to create demo services and pinger deployments in each cluster.
Pinger simply makes a request to the demo service and logs the result. Each
cluster will have 2 pingers. One in zone A and one in zone B. The demo service
uses zonal topology.

It will then show that requests in each cluster stay within the cluster and
zone.

EndpointSlices will be copied between clusters.

Finally, the demo will show that requests now cross the cluster boundary, but
still stay within their respective zones.

