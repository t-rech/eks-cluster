plan:
	cd terragrunt/nonprod && terragrunt run-all plan

apply:
	cd terragrunt/nonprod && terragrunt run-all apply

destroy:
	cd terragrunt/nonprod && terragrunt run-all destroy

update-kubeconfig:
	aws eks update-kubeconfig --name eks-cluster --alias eks-cluster

setup-argocd:
	bash scripts/install_argocd.sh

access-argocd:
	bash scripts/argocd_connect.sh

install-istio:
	bash scripts/install_istio.sh

argocd-default-password:
	kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2

me-happy: apply update-kubeconfig install-istio setup-argocd
