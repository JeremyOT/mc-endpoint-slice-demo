#!/bin/bash

if [ -z "${KUBE_ROOT}" ]; then
  echo "Set KUBE_ROOT to the path to a K8s installation."
  echo "Download from https://github.com/kubernetes/kubernetes/releases/download/v1.17.4/kubernetes.tar.gz"
  exit -1
fi

export MULTIZONE=true
export KUBERNETES_PROVIDER=gce

export CLUSTER_IP_RANGE='10.64.0.0/14'
export SERVICE_CLUSTER_IP_RANGE='10.1.0.0/16'
export KUBE_DNS_SERVER_IP='10.1.0.10'
export MASTER_IP_RANGE='10.246.0.0/24'
export KUBE_GCE_INSTANCE_PREFIX='cluster-1'
export OVERRIDE_CONTEXT=${KUBE_GCE_INSTANCE_PREFIX}

KUBE_USE_EXISTING_MASTER=true KUBE_GCE_ZONE=us-central1-b "${KUBE_ROOT}/cluster/kube-down.sh"
KUBE_GCE_ZONE=us-central1-a "${KUBE_ROOT}/cluster/kube-down.sh"

export CLUSTER_IP_RANGE='10.68.0.0/14'
export SERVICE_CLUSTER_IP_RANGE='10.2.0.0/16'
export KUBE_DNS_SERVER_IP='10.2.0.10'
export MASTER_IP_RANGE='10.247.0.0/24'
export KUBE_GCE_INSTANCE_PREFIX='cluster-2'
export OVERRIDE_CONTEXT=${KUBE_GCE_INSTANCE_PREFIX}

KUBE_USE_EXISTING_MASTER=true KUBE_GCE_ZONE=us-central1-b "${KUBE_ROOT}/cluster/kube-down.sh"
KUBE_GCE_ZONE=us-central1-a "${KUBE_ROOT}/cluster/kube-down.sh"

