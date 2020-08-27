#!/bin/bash

# CRDが既に適用されているか確認
check_crd() {	
  kubectl get crd someapp.project-respite.com > /dev/null 2>&1
}

# CRDを新たに適用する
create_crd() {	
  echo "Create Custom Resource Definition.";
  kubectl apply -f /opt/operator/crd-someapp.yaml
}

# SomeAppリソースにfinalizerを追加する
inject_finalizer(){
  local name=$1
  kubectl patch someapp $name --type merge -p '{"metadata":{"finalizers": ["finalizer.someapp.project-respite.com"]}}'
}

# SomeAppリソースからDeploymentを生成・適用
ensure_service() {
  echo "Ensure Service."

  local name=$1
  local image=$2
  local replicas=$3

  # finalizer設定
  inject_finalizer $1

  # Deployment起動
  sed "s%name: xxx%name: $name%g" /opt/operator/deployment.yaml \
    | sed "s%image: xxx%image: $image%g" \
    | sed "s%replicas: 0%replicas: $replicas%g" \
    | kubectl apply -f - > /dev/null
}

# SomeAppリソースが削除済みの場合、Deploymentも削除する
delete_service() {
  echo "Delete Service."

  local name=$1
  local deletionTimestamp=$2

  echo "name:[${name}]"
  echo "deletionTimestamp:[${deletionTimestamp}]"

  if [[ -n ${deletionTimestamp} ]]; then
    kubectl delete deployment $name
    kubectl patch someapp $name --type merge -p '{"metadata":{"finalizers": [null]}}'
  fi
}

echo "Begin operator.sh"

# CRDが既に適用されているか確認し、未適用ならば適用する
if ! check_crd; then  
  create_crd;
  sleep 1;  
fi

# Reconciliation Loop
while true; do    

  # SomeAppリソースを検索し、追加・変更を適用する
  for i in $(kubectl get someapp -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.end}'); do
    ensure_service $(kubectl get someapp $i \
      -o jsonpath='{.metadata.name}{"\t"}{.spec.image}{"\t"}{.spec.replicas}{"\t"}');
  done

  # SomeAppリソースを検索し、SomeAppリソースが削除されていれば関連するDeploymentを削除する
  for i in $(kubectl get someapp -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.end}'); do
    delete_service $(kubectl get someapp $i \
      -o jsonpath='{.metadata.name}{"\t"}{.metadata.deletionTimestamp}');
  done

  sleep 5;

done