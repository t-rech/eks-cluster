plan:
	cd terragrunt/nonprod && terragrunt run-all plan

apply:
	cd terragrunt/nonprod && terragrunt run-all apply

destroy:
	cd terragrunt/nonprod && terragrunt run-all destroy

init.%:
	cd terragrunt/nonprod/$* && terragrunt init

apply.%:
	cd terragrunt/nonprod/$* && terragrunt apply -auto-approve

plan.%:
	cd terragrunt/nonprod/$* && terragrunt plan

destroy.%:
	cd terragrunt/nonprod/$* && terragrunt destroy -auto-approve

update-kubeconfig:
	aws eks update-kubeconfig --name eks-cluster --alias eks-cluster

access-argocd:
	bash scripts/argocd_connect.sh

install.%: update-kubeconfig
	bash scripts/install_$*.sh

argocd-default-password:
	kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2

me-happy: apply update-kubeconfig install-istio setup-argocd

.PHONY: ingress-pod
ingress-pod:
	@echo $(shell kubectl get pod -l service.istio.io/canonical-name=public-ingressgateway -o jsonpath={.items..metadata.name} -n istio-system)
