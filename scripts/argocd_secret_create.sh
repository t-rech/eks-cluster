CLIENT_ID=$(printf ${AUTH0_ARGOCD_CLIENT_ID} | base64)
CLIENT_SECRET=$(printf ${AUTH0_ARGOCD_CLIENT_SECRET} | base64)

kubectl -n argocd patch secret argocd-secret \
  -p '{"stringData": {
    "oidc.auth0.clientID": "'${AUTH0_ARGOCD_CLIENT_ID}'",
    "oidc.auth0.clientSecret": "'${AUTH0_ARGOCD_CLIENT_SECRET}'"
  }}'

  kubectl rollout restart deployment argo-cd-argocd-server -n argocd