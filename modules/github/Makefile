
github/branch-protect:
	for row in $(curl -sSL -H "Authorization: token ${GITHUB_TOKEN}" https://github.ibm.com/api/v3/repos/${GITHUB_REPO_OWNER}/${GITHUB_REPO}/branches | jq -rc '.[]'); do
	release=$(echo ${row} | jq -r '.name' | grep "release")
	if [[ ${release} != "" ]]; then
		echo ${release}
		curl -X PUT -L -H "Authorization: token ${GITHUB_TOKEN}" -d '{	"required_status_checks": {	"strict": true, "contexts": [ "continuous-integration/travis-ci" ]}, "enforce_admins": true, "required_pull_request_reviews": { "dismiss_stale_reviews": true, "require_code_owner_reviews": false }, "restrictions": null' https://github.ibm.com/api/v3/repos/${GITHUB_REPO_OWNER}/${GITHUB_REPO}/branches/${release}/protection
	fi
	done
	curl -X PUT -L -H "Authorization: token ${GITHUB_TOKEN}" -d '{	"required_status_checks": {	"strict": true, "contexts": [ "continuous-integration/travis-ci" ]}, "enforce_admins": true, "required_pull_request_reviews": { "dismiss_stale_reviews": true, "require_code_owner_reviews": false }, "restrictions": null' https://github.ibm.com/api/v3/repos/${GITHUB_REPO_OWNER}/${GITHUB_REPO}/branches/master/protection

github/update-tag:
	git checkout master -f
	git tag -a unreleased-master -m 'unreleased-master' -f
	git push --tag -f

github/webhook-setup:
	curl -X PUT -sSL -H "Authorization: token ${GITHUB_TOKEN}" \
	-d '{"name": "web","events": [ "issues" ],"config": {"url": "${RELEASE_CUTTER_URL}","content_type": "json","insecure_ssl": "1","secret": "${RELEASE_CUTTER_SECRET}"}}' \
	https://github.ibm.com/api/v3/repos/${GITHUB_REPO_OWNER}/${GITHUB_REPO}/hooks

