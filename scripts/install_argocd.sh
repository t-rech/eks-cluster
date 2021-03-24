kubectl create namespace argocd && kubectl apply -n argocd -f argocd/install.yaml

kubectl apply -n argocd -f argocd/bootstrap.yaml

kubectl apply -n argocd -f argocd/argocd-cm.yaml

# kubectl label namespace argocd istio-injection=enabled --overwrite

# kubectl -n argocd patch deployment argocd-server -p '{"spec":{"template":{"metadata":{"annotations":{"sidecar.istio.io/inject": "true"}}}}}'