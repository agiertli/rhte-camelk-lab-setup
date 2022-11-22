ARGOCD_NAMESPACE=argocd
ARGOCD_CR_NAME=argocd-master


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

echo "Creating namespace : argocd"
oc apply -f namespace.yaml
oc project argocd
echo "Creating OperatorGroup: argocd-operator"
oc apply -f operator-group.yaml
echo "Creating Subscription: argocd"
oc apply -f argocd-subs.yaml
echo "Creating ArgoCD CR : ${ARGOCD_CR_NAME}"
while [[ argoCdOutput=$(oc apply -f argocd-cr.yaml 2>&1 > /dev/null) == *"error"* ]]
do
 echo "Waiting until ArgoCD operator is ready..."
 sleep 5
done

while [[ argoSecret=$(oc get secret ${ARGOCD_CR_NAME}-cluster 2>&1 > /dev/null) == *"Error"* ]]
do
echo "Waiting until ArgoCD CR is ready..."
sleep 5
done
oc -n $ARGOCD_NAMESPACE patch secret $ARGOCD_CR_NAME-cluster --patch "{\"stringData\": {\"admin.password\": \"$ARGOCD_ADMIN_PASSWORD\"}}"

echo "Logging into the ArgoCD instance.."
argocd login \
  --grpc-web \
  --username admin \
  --password $ARGOCD_ADMIN_PASSWORD \
  $(oc get route ${ARGOCD_CR_NAME}-server -n ${ARGOCD_NAMESPACE} --template='{{ .spec.host }}')

echo "Installation complete!" 
