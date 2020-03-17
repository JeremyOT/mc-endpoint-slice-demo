#!/bin/bash

. $(dirname ${BASH_SOURCE})/util.sh

function dryrun() {
  maybe_first_prompt
  rate=25
  echo "$green$1$reset" | pv -qL $rate
  read -d '' -t "${timeout}" -n 10000 # clear stdin
  prompt
  if [ -z "$DEMO_AUTO_RUN" ]; then
    read -s
  fi
}

export DEMO_AUTO_RUN="true"

C1="cluster-1"
C2="cluster-2"

run "kubectl --context ${C1} apply -f yaml/demo-service-1.yaml"
run "kubectl --context ${C1} apply -f yaml/pinger.yaml"
run "kubectl --context ${C2} apply -f yaml/demo-service-2.yaml"
run "kubectl --context ${C2} apply -f yaml/pinger.yaml"

PINGER_1_A=$(kubectl --context ${C1} get pods -n demos -l app=pinger-a -o go-template --template="{{(index .items 0).metadata.name}}")
PINGER_1_B=$(kubectl --context ${C1} get pods -n demos -l app=pinger-b -o go-template --template="{{(index .items 0).metadata.name}}")
PINGER_2_A=$(kubectl --context ${C2} get pods -n demos -l app=pinger-a -o go-template --template="{{(index .items 0).metadata.name}}")
PINGER_2_B=$(kubectl --context ${C2} get pods -n demos -l app=pinger-b -o go-template --template="{{(index .items 0).metadata.name}}")

sleep 3

#export DEMO_AUTO_RUN=""

desc "Show requests from ${C1} zone A"
run "kubectl --context ${C1} logs -n demos ${PINGER_1_A} --tail 10"

desc "Show requests from ${C1} zone B"
run "kubectl --context ${C1} logs -n demos ${PINGER_1_B} --tail 10"

desc "Show requests from ${C2} zone A"
run "kubectl --context ${C2} logs -n demos ${PINGER_2_A} --tail 10"

desc "Show requests from ${C2} zone B"
run "kubectl --context ${C2} logs -n demos ${PINGER_2_B} --tail 10"

export DEMO_AUTO_RUN="true"

desc "Copy EnndpointSlices between clusters..."

run "kubectl --context ${C1} get endpointslice -n demos"
run "kubectl --context ${C2} get endpointslice -n demos"

EP_1=$(kubectl --context ${C1} get endpointslice -n demos --template="{{(index .items 0).metadata.name}}")
EP_2=$(kubectl --context ${C2} get endpointslice -n demos --template="{{(index .items 0).metadata.name}}")

run "kubectl --context ${C1} get endpointslice -n demos ${EP_1} -o yaml | ./edit_meta --metadata '{name: ${EP_1}, namespace: demos, labels: {kubernetes.io/service-name: demo}}' > yaml/cluster-1-epslice.yaml"
run "kubectl --context ${C2} get endpointslice -n demos ${EP_2} -o yaml | ./edit_meta --metadata '{name: ${EP_2}, namespace: demos, labels: {kubernetes.io/service-name: demo}}' > yaml/cluster-2-epslice.yaml"
run "kubectl --context ${C1} apply -f yaml/cluster-2-epslice.yaml"
run "kubectl --context ${C2} apply -f yaml/cluster-1-epslice.yaml"
run "kubectl --context ${C1} get endpointslice -n demos"
run "kubectl --context ${C2} get endpointslice -n demos"
sleep 3

#export DEMO_AUTO_RUN=""

desc "Show requests from ${C1} zone A"
run "kubectl --context ${C1} logs -n demos ${PINGER_1_A} --tail 10"

desc "Show requests from ${C1} zone B"
run "kubectl --context ${C1} logs -n demos ${PINGER_1_B} --tail 10"

desc "Show requests from ${C2} zone A"
run "kubectl --context ${C2} logs -n demos ${PINGER_2_A} --tail 10"

desc "Show requests from ${C2} zone B"
run "kubectl --context ${C2} logs -n demos ${PINGER_2_B} --tail 10"

