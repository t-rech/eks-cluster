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
	kubectl create namespace argocd && kubectl apply -n argocd -f argocd/

access-argocd:
	kubectl port-forward svc/argocd-server -n argocd 8080:443