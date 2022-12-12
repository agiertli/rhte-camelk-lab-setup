# login to openshift as cluster admin


# Install image puller in the tooling namespace

oc process -f serviceaccount.yaml --namespace=tooling | oc apply -n tooling -f -
oc process -f configmap.yaml --namespace=tooling | oc apply -n tooling -f -
oc process -f app.yaml --namespace=tooling | oc apply -n tooling -f -
sleep 5

# install the devspaces operator

dsc server:deploy -n tooling -p openshift --che-operator-cr-yaml=che-operator-cr.yaml
sleep 5

# Patch Operator group because it doenst default to AllNamespaces

oc patch -n tooling operatorGroups kubernetes-imagepuller-operator --patch '[{"op":"remove","path":"/spec/targetNamespaces"}]' --type=json

# oc packagemanifest
# oc get substription devspaces -o yaml | oc neat