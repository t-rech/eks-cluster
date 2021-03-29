if kubectl get ns istio-system; then
  echo "Istio already installed. Skipping initialization."
else
  kubectl create ns istio-system
  istioctl operator init
fi

kubectl apply -f istio-operator.yaml