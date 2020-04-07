
github/echo/test:
	echo ${GITHUB_REPO_OWNER}
	echo ${GITHUB_REPO}

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
	curl -X PUT -sSL -H "Authorization: token ${GITHUB_TOKEN}" -d '{
		"name": "web",
		"events": [ "issues" ],
		"config": {
			"url": "https://us-south.functions.cloud.ibm.com/api/v1/web/cf5bd24b-2e65-403b-9de3-7a53ecf960aa/default/createrelease",
			"content_type": "json",
			"insecure_ssl": "1",
			"secret": ""
		}
	}' https://github.ibm.com/api/v3/repos/${GITHUB_REPO_OWNER}/${GITHUB_REPO}/hooks

