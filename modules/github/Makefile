
## Protect all release and master branches
github/branch-protect:
	$(call assert-set,GITHUB_TOKEN)
	$(call assert-set,GITHUB_REPO)
	$(call assert-set,GITHUB_REPO_OWNER)
	$(shell curl -sSL -H "Authorization: token ${GITHUB_TOKEN}" https://github.ibm.com/api/v3/repos/${GITHUB_REPO_OWNER}/${GITHUB_REPO}/branches \
	| jq -rc '.[]' \
	| while read branches ; do (printf "$$branches" | jq -r '.name' | grep release) >> branches ;  done)
	while IFS= read -r line ; do curl -X PUT -ssL -H "Authorization: token ${GITHUB_TOKEN}" \
	-d '{"required_status_checks": {"strict": true, "contexts": [ "continuous-integration/travis-ci" ]}, "enforce_admins": true, "required_pull_request_reviews": { "dismiss_stale_reviews": true, "require_code_owner_reviews": false }, "restrictions": null'} \
	https://github.ibm.com/api/v3/repos/${GITHUB_REPO_OWNER}/${GITHUB_REPO}/branches/$$line/protection ; done < ./branches
	curl -X PUT -ssL -H "Authorization: token ${GITHUB_TOKEN}" \
	-d '{"required_status_checks": {"strict": true, "contexts": [ "continuous-integration/travis-ci" ]}, "enforce_admins": true, "required_pull_request_reviews": { "dismiss_stale_reviews": true, "require_code_owner_reviews": false }, "restrictions": null'} \
	https://github.ibm.com/api/v3/repos/${GITHUB_REPO_OWNER}/${GITHUB_REPO}/branches/master/protection
	rm ./branches

## Update unreleased master tag to latest local commit
github/update-tag:
	git checkout master -f
	git tag -a unreleased-master -m 'unreleased-master' -f
	git push --tag -f

## Setup the webhook for the release-cutter bot
github/webhook-setup:
	$(call assert-set,GITHUB_TOKEN)
	$(call assert-set,GITHUB_REPO)
	$(call assert-set,GITHUB_REPO_OWNER)
	$(call assert-set,RELEASE_CUTTER_URL)
	$(call assert-set,RELEASE_CUTTER_SECRET)
	curl -sSL -H "Authorization: token ${GITHUB_TOKEN}" \
	-d '{"name": "web","events": [ "issues" ],"config": {"url": "${RELEASE_CUTTER_URL}","content_type": "json","insecure_ssl": "0","secret": "${RELEASE_CUTTER_SECRET}"}}' \
	https://github.ibm.com/api/v3/repos/${GITHUB_REPO_OWNER}/${GITHUB_REPO}/hooks

## Setup the webhook for the cherry-picker bot
github/webhook-setup:
	$(call assert-set,GITHUB_TOKEN)
	$(call assert-set,GITHUB_REPO)
	$(call assert-set,GITHUB_REPO_OWNER)
	$(call assert-set,CHERRY_PICKER_URL)
	$(call assert-set,CHERRY_PICKER_SECRET)
	curl -sSL -H "Authorization: token ${GITHUB_TOKEN}" \
	-d '{"name": "web","events": [ "issues" ],"config": {"url": "${CHERRY_PICKER_URL}","content_type": "json","insecure_ssl": "0","secret": "${CHERRY_PICKER_SECRET}"}}' \
	https://github.ibm.com/api/v3/repos/${GITHUB_REPO_OWNER}/${GITHUB_REPO}/hooks

## Enable this repo on travis and add Docker username/password environment variables
github/travis-setup:
	$(call assert-set,GITHUB_TOKEN)
	$(call assert-set,TRAVIS_TOKEN)
	$(call assert-set,GITHUB_REPO)
	$(call assert-set,GITHUB_REPO_OWNER)
	$(call assert-set,DOCKER_PASSWORD)
	$(call assert-set,DOCKER_USERNAME)
	$(call assert-set,TARGET_DOCKER_REGISTRY)
	curl -X POST -sSL -H "Authorization: token ${TRAVIS_TOKEN}" \
	-H "Travis-API-Version: 3" \
	https://travis.ibm.com/api/repo/${GITHUB_REPO_OWNER}%2F${GITHUB_REPO}/activate

	curl -X POST -sSL -H "Authorization: token ${TRAVIS_TOKEN}" \
	-H "Travis-API-Version: 3" \
	-H "Content-Type: application/json" \
	-d '{ "env_var.name": "DOCKER_USERNAME", "env_var.value": "${DOCKER_USERNAME}", "env_var.public": false }' \
	https://travis.ibm.com/api/repo/${GITHUB_REPO_OWNER}%2F${GITHUB_REPO}/env_vars

	curl -X POST -sSL -H "Authorization: token ${TRAVIS_TOKEN}" \
	-H "Travis-API-Version: 3" \
	-H "Content-Type: application/json" \
	-d '{ "env_var.name": "DOCKER_PASSWORD", "env_var.value": "${DOCKER_PASSWORD}", "env_var.public": false }' \
	https://travis.ibm.com/api/repo/${GITHUB_REPO_OWNER}%2F${GITHUB_REPO}/env_vars

	curl -X POST -sSL -H "Authorization: token ${TRAVIS_TOKEN}" \
	-H "Travis-API-Version: 3" \
	-H "Content-Type: application/json" \
	-d '{ "env_var.name": "TARGET_DOCKER_REGISTRY", "env_var.value": "${TARGET_DOCKER_REGISTRY}", "env_var.public": false }' \
	https://travis.ibm.com/api/repo/${GITHUB_REPO_OWNER}%2F${GITHUB_REPO}/env_vars