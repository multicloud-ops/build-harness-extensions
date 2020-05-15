#-----------------------------------------------------------------------
# Licensed Materials - Property of IBM
#
# (C) Copyright IBM Corporation 2020.
#
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corporation.
#-----------------------------------------------------------------------

# Lints a set of helm charts.
#
# Variables:
#   HELM_CHART_DIR
#     The directory containing the helm charts.  This is the directory
#     containing the Chart.yaml file.
.PHONY: helm/chart/lint
## Lints a set of helm charts
helm/chart/lint:
	$(call assert-set,HELM_CHART_DIR)
	cd $(HELM_CHART_DIR) && \
	$(HELM) dependency update && \
	rm -f requirement.lock && \
	$(HELM) lint .

# Packages a set of helm charts.
#
# (Can't use helm/chart/build/package because it depends on yq, which
# doesn't run on Power or zLinux.)
#
# Variables:
#   HELM_CHART_DIR
#     The directory containing the helm charts.  This is the directory
#     containing the Chart.yaml file.
#   HELM_CHART_NAME
#     The name for the packaged helm charts.
#   HELM_CHART_VERSION
#     The version for the packaged helm charts.
.PHONY: helm/chart/package
## Packages a set of helm charts
helm/chart/package:
	$(call assert-set,HELM_CHART_DIR)
	$(call assert-set,HELM_CHART_NAME)
	$(call assert-set,HELM_CHART_VERSION)
	cd $(HELM_CHART_DIR) && \
	$(HELM) package --version $(HELM_CHART_VERSION) .