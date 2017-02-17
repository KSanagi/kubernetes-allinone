#!/bin/bash
# confirmed this work with CentOS7.3

yum -y install kubernetes etcd
mkdir -p /etc/pki/kube-apiserver
openssl genrsa -out /etc/pki/kube-apiserver/serviceaccount.key 2048
sed -i -e 's%^KUBE_API_ARGS=.*$%KUBE_API_ARGS="--service_account_key_file=/etc/pki/kube-apiserver/serviceaccount.key"%' /etc/kubernetes/apiserver
sed -i -e 's%^KUBE_CONTROLLER_MANAGER_ARGS=.*$%KUBE_CONTROLLER_MANAGER_ARGS="--service_account_private_key_file=/etc/pki/kube-apiserver/serviceaccount.key"%' /etc/kubernetes/controller-manager
for SERVICE in etcd kube-apiserver kube-controller-manager kube-scheduler kube-proxy kubelet docker; do
  systemctl restart $SERVICE
  systemctl enable $SERVICE
  systemctl status $SERVICE
done
 
