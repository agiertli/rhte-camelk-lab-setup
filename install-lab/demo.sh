
for i in {1..10}
do
    oc delete app lab5-user$i-charts-prod -n openshift-gitops
    oc delete app lab5-user$i-charts-dev -n openshift-gitops
    oc delete app lab5-user$i-secrets-prod -n openshift-gitops
    oc delete app lab5-user$i-secrets-dev -n openshift-gitops
done

oc delete app lab5 -n openshift-gitops
oc delete app rhte-camelk-tooling-app-of-apps -n openshift-gitops
oc delete app amq7 -n openshift-gitops
oc delete app devspaces-seed -n openshift-gitops
oc delete app devspaces-install -n openshift-gitops
oc delete app gitea -n openshift-gitops
oc delete app namespaces -n openshift-gitops
oc delete app sealed-secrets -n openshift-gitops
oc delete app tekton -n openshift-gitops
oc delete app camelk-community -n openshift-gitops
oc delete appproject rhte-camelk-tooling -n openshift-gitops
