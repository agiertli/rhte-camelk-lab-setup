# login to openshift as cluster admin

# oc login --token=sha256~NtBsSlxUyqW60J4uAb2gCTaK5opMLEjqIpgkKrW2dys --server=https://api.cluster-rz9hh.rz9hh.sandbox1086.opentlc.com:6443

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

