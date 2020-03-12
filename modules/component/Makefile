DEPLOYMENT_UPDATE_SCRIPT ?= ./build/e2e-test.sh
DEPLOYMENT_NAMESPACE ?= 
DEPLOYMENT_NAME ?=
DEPLOYMENT_CONTAINER ?=

## Ensure that the deployment will have access to necessary pull secret
project/remote/pullsecret:
	oc -n $(DEPLOYMENT_NAMESPACE) create secret docker-registry deployregistrykey --docker-server=$(TARGET_DOCKER_REGISTRY) --docker-username=$(DOCKER_USERNAME) --docker-password=$(DOCKER_PASSWORD) --docker-email=not@real.id
	oc -n $(DEPLOYMENT_NAMESPACE) get serviceaccounts default -o json | jq  'del(.metadata.resourceVersion)'|  jq ' .imagePullSecrets += [{"name":"deployregistrykey"}]' | oc -n $(DEPLOYMENT_NAMESPACE) replace serviceaccount default -f -
			 
## Rollout $(DOCKER_IMAGE_NAME) to the deployment $(DEPLOYMENT_NAME)
project/deployment/rollout:
	## Assume that the image has been just built
	$(shell $(DEPLOYMENT_UPDATE_SCRIPT) "$(DEPLOYMENT_NAME)" "$(DEPLOYMENT_CONTAINER)" "$(DOCKER_IMAGE_NAME)" "$(DEPLOYMENT_NAMESPACE)")

project/deployment/status:
	oc -n $(DEPLOYMENT_NAMESPACE) rollout status $(DEPLOYMENT_NAME)

project/deployment/rollout/undo:
	 oc -n $(DEPLOYMENT_NAMESPACE) rollout undo $(DEPLOYMENT_NAME)
