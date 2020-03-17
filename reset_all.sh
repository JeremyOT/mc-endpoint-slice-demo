kubectl config use cluster-1
$(dirname ${BASH_SOURCE})/reset.sh

kubectl config use cluster-2
$(dirname ${BASH_SOURCE})/reset.sh
