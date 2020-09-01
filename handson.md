# ハンズオン

1. Git Cloneします
```
$ git clone https://github.com/Daiki-Kawanuma/kubernetes-operator-handson.git
```

&nbsp;

2. Operatorをビルドします
```
$ cd /path/to/kubernetes-operator-handson/operator
$ docker build -t someapp-operator:1.0 .
```

`Q1. Docker Build内でどんなことをしていたでしょう？`

&nbsp;

3. Operator Podを作成します
```
$ cd /path/to/kubernetes-operator-handson

$ kubectl apply -f sa-operator.yaml
$ kubectl apply -f crb-operator.yaml
$ kubectl apply -f deployment-operator.yaml
```

`Q2. なぜ ServiceAccountとClusterRoleBindingが必要なのでしょう？`

&nbsp;

4. Operator PodのログおよびCRDを取得します
```
$ kubectl logs someapp-operator-xxx
$ kubectl get crd/someapp.project-respite.com
```

`Q3. Operatorは起動時、何を行なっているでしょう？`

&nbsp;

5. CustomResourceを適用します
```
$ kubectl get deployment
$ kubectl get pod

$ kubectl apply -f cr-someapp.yaml
$ kubectl get someapp
$ kubectl get deployment
$ kubectl get pod
```

`Q4. CustomResource適用後はどんな状態でしょう？`

&nbsp;

6. Operatorの実装を確認します
```
$ cat /path/to/kubernetes-operator-handson/operator/operator.sh
```

`Q5. Operatorは何をしているでしょう？`