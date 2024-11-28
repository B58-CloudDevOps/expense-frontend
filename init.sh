# ARGO_URL=$(kubectl get svc -n argocd|grep argocd-server |grep LoadBalancer | awk  '{print $4}')
echo "Authenticaing to EKS DEV"
aws eks update-kubeconfig --name ${1}-eks
kubectl get nodes 

ARGO_URL="argocd.cloudapps.today"
ARGO_PWD=$(kubectl get secret argocd-initial-admin-secret -n argocd-initial-admin-secret -o json -n argocd | jq '.data.password'| xargs | base64 -d)
argocd login $ARGO_URL  --username admin --password $ARGO_PWD

echo "creating ${1} frontend app"
argocd app create frontend --repo https://github.com/B58-CloudDevOps/expense-helm.git --path . --dest-namespace default --dest-server https://kubernetes.default.svc --values ${1}/frontend.yaml --sync-policy auto --grpc-web