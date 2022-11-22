ARGOCD_CR_NAMESPACE=openshift-gitops
ARGOCD_OPERATOR_NAMESPACE=openshift-operators
ARGOCD_TOOLING_NAMESPACE=tooling
oc delete argocd openshift-gitops -n ${ARGOCD_CR_NAMESPACE}
oc delete csv openshift-gitops-operator.v1.6.2 -n ${ARGOCD_OPERATOR_NAMESPACE}
oc delete subs openshift-gitops-operator -n ${ARGOCD_OPERATOR_NAMESPACE}
oc delete project ${ARGOCD_CR_NAMESPACE}
oc delete project ${ARGOCD_TOOLING_NAMESPACE}