ARGOCD_NAMEPSACE=argocd 
oc project ${ARGOCD_NAMEPSACE}
oc delete argocd argocd-master
oc delete csv openshift-gitops-operator.v1.6.2
oc delete subs openshift-gitops-operator
oc delete project ${ARGOCD_NAMEPSACE}