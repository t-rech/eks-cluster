init:
	cd cluster/ && terraform init

plan:
	cd cluster/ && terraform plan -var-file=environments/nonprod.tfvars

apply:
	cd cluster/ && terraform apply -auto-approve -var-file=environments/nonprod.tfvars

destroy:
	cd cluster/ && terraform destroy -auto-approve -var-file=environments/nonprod.tfvars

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
