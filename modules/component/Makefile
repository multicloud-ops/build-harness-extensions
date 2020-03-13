DEPLOYMENT_UPDATE_SCRIPT ?= ./build/e2e-test.sh
COMPONENT_NAMESPACE ?= 
DEPLOYMENT_NAME ?=
DEPLOYMENT_CONTAINER ?=

## Ensure that the deployment will have access to necessary pull secret
component/remote/pullsecret:
	oc -n $(COMPONENT_NAMESPACE) create secret docker-registry deployregistrykey --docker-server=$(TARGET_DOCKER_REGISTRY) --docker-username=$(DOCKER_USERNAME) --docker-password=$(DOCKER_PASSWORD) --docker-email=not@real.id
	oc -n $(COMPONENT_NAMESPACE) get serviceaccounts default -o json | jq  'del(.metadata.resourceVersion)'|  jq ' .imagePullSecrets += [{"name":"deployregistrykey"}]' | oc -n $(COMPONENT_NAMESPACE) replace serviceaccount default -f -
			 
## Rollout $(DOCKER_IMAGE_NAME) to the deployment $(DEPLOYMENT_NAME)
component/deployment/rollout:
	## Assume that the image has been just built
	$(shell $(DEPLOYMENT_UPDATE_SCRIPT) "$(DEPLOYMENT_NAME)" "$(DEPLOYMENT_CONTAINER)" "$(DOCKER_IMAGE_NAME)" "$(COMPONENT_NAMESPACE)")

component/deployment/status:
	oc -n $(COMPONENT_NAMESPACE) rollout status $(DEPLOYMENT_NAME)

component/deployment/rollout/undo:
	 oc -n $(COMPONENT_NAMESPACE) rollout undo $(DEPLOYMENT_NAME)
