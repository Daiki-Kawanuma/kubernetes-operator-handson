# Kubernetes Operator Handson

## 稼働確認環境
- OpenShift 4.3.5
  - Kubernete 1.16.2
  - cri-o 1.16.3

&nbsp;

## Operatorイメージのビルド
```
cd operator
docker build -t someapp-operator:1.0 .
```

&nbsp;

## Custom Resourceの定義
- image: 起動するイメージのURI
- replicas: Podのレプリカ数

&nbsp;

## 起動方法
```
# Operator Podの作成
kubectl apply -f sa-operator.yaml
kubectl apply -f crb-operator.yaml
kubectl apply -f deployment-operator.yaml

# Custom Resourceの適用
kubectl apply -f cr-someapp.yaml
```