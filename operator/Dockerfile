FROM centos:7

# kubectl のインストール
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

# Operator用ディレクトリ作成
RUN mkdir -m 755 /opt/operator

# YAML, Shellのコピー
COPY --chown=1001:0 crd-someapp.yaml deployment.yaml operator.sh /opt/operator/

# 実行
CMD /opt/operator/operator.sh