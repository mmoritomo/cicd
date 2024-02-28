TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`

export EXTERNAL_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4
)

curl -sSL https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml > argocd-install.yaml
kubectl create ns argocd
kubectl apply -f argocd-install.yaml -n argocd
kubectl patch service -n argocd argocd-server -p '{"spec":{"type": "NodePort"}}'

export ARGO_NODE_PORT=$(kubectl get svc -n argocd argocd-server -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')

echo http://${EXTERNAL_IP}:${ARGO_NODE_PORT}