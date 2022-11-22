ARGOCD_NAMESPACE=argocd
ARGOCD_CR_NAME=argocd-master
ARGOCD_GIT_URL=https://github.com/agiertli/rhte-camelk.git
ARGOCD_GIT_NAME="rhte-camelk-tooling"
ARGOCD_PROJECT_NAME="rhte-camelk-tooling-parent"
ARGOCD_ADMIN_PASSWORD="rhte-camelk"

echo "Logging into the ArgoCD instance.."
argocd login \
  --grpc-web \
  --username admin \
  --password $ARGOCD_ADMIN_PASSWORD \
  $(oc get route ${ARGOCD_CR_NAME}-server -n ${ARGOCD_NAMESPACE} --template='{{ .spec.host }}')

