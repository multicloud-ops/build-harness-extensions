
github/branch-protect:
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

github/update-tag:
	git checkout master -f
	git tag -a unreleased-master -m 'unreleased-master' -f
	git push --tag -f

github/webhook-setup:
	curl -sSL -H "Authorization: token ${GITHUB_TOKEN}" \
	-d '{"name": "web","events": [ "issues" ],"config": {"url": "${RELEASE_CUTTER_URL}","content_type": "json","insecure_ssl": "0","secret": "${RELEASE_CUTTER_SECRET}"}}' \
	https://github.ibm.com/api/v3/repos/${GITHUB_REPO_OWNER}/${GITHUB_REPO}/hooks

github/travis-setup:
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