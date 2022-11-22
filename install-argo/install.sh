ARGOCD_NAMESPACE=openshift-gitops
ARGOCD_TOOLING_NAMESPACE=tooling
ARGOCD_CR_NAME=openshift-gitops
ARGOCD_GIT_URL=https://github.com/agiertli/rhte-camelk.git
ARGOCD_GIT_NAME="rhte-camelk-tooling"
ARGOCD_PROJECT_NAME="rhte-camelk-tooling"
ARGOCD_APP_NAME="${ARGOCD_PROJECT_NAME}-app-of-apps"

while getopts "p:" opt; do
  case $opt in
    p) ARGOCD_ADMIN_PASSWORD="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    exit 1
    ;;
  esac

  case $OPTARG in
    -*) echo "Option $opt needs a valid argument"
    exit 1
    ;;
  esac
done

# echo "Creating namespace : argocd"
# oc apply -f namespace.yaml
# oc project ${ARGOCD_NAMESPACE}
# echo "Creating OperatorGroup: argocd-operator"
# oc apply -f operator-group.yaml
echo "Creating Subscription: argocd"
oc apply -f argocd-subs.yaml
# echo "Creating ArgoCD CR : ${ARGOCD_CR_NAME}"
# while [[ argoCdOutput=$(oc apply -f argocd-cr.yaml 2>&1 > /dev/null) == *"error"* ]]
# do
#  echo "Waiting until ArgoCD operator is ready..."
#  sleep 5
# done

while [[ argoSecret=$(oc -n ${ARGOCD_NAMESPACE} get secret ${ARGOCD_CR_NAME}-cluster 2>&1 > /dev/null) == *"Error"* ]]
do
echo "Waiting until ArgoCD CR is ready..."
sleep 5
done
oc -n $ARGOCD_NAMESPACE patch secret $ARGOCD_CR_NAME-cluster --patch "{\"stringData\": {\"admin.password\": \"$ARGOCD_ADMIN_PASSWORD\"}}"

echo "Logging into the ArgoCD instance..waiting for 30s to allow ArgoCD redeploy after patching"
sleep 30
argocd login \
  --grpc-web \
  --username admin \
  --password $ARGOCD_ADMIN_PASSWORD \
  $(oc get route ${ARGOCD_CR_NAME}-server -n ${ARGOCD_NAMESPACE} --template='{{ .spec.host }}')

echo "Adding Github Repository ${ARGOCD_GIT_URL}"
argocd repo add ${ARGOCD_GIT_URL} --name ${ARGOCD_GIT_NAME}


# echo "Setting ArgoCD permissions"
oc new-project tooling
oc policy add-role-to-user \
   edit \
   system:serviceaccount:openshift-gitops:openshift-gitops-argocd-application-controller \
   --rolebinding-name=argocd-edit \
   -n ${ARGOCD_TOOLING_NAMESPACE}

echo "Creating ArgoCD Project ${ARGOCD_PROJECT_NAME}"

argocd proj create ${ARGOCD_PROJECT_NAME} \
   --dest https://kubernetes.default.svc,* \
   --src ${ARGOCD_GIT_URL} \
   --description "ArgoCD Project for Tooling"

echo "Creating ArgoCD App of Apps ${ARGOCD_APP_NAME}"

argocd app create ${ARGOCD_APP_NAME} \
  --project ${ARGOCD_PROJECT_NAME} \
  --repo ${ARGOCD_GIT_URL} \
  --path tooling \
  --revision HEAD \
  --dest-namespace ${ARGOCD_NAMESPACE} \
  --dest-server https://kubernetes.default.svc


argocd app set ${ARGOCD_APP_NAME} --sync-policy automated --self-heal
#argocd app set ${ARGOCD_APP_NAME} --sync-option CreateNamespace=true

echo "Installation complete!" 
