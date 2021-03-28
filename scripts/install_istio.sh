istioctl operator init

kubectl create ns istio-system

kubectl apply -f istio/istio-operator.yaml

kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.9/samples/addons/kiali.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.9/samples/addons/kiali.yaml