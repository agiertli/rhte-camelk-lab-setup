for i in {2..11}
do
    oc login --server=https://api.cluster-gl48f.gl48f.sandbox467.opentlc.com:6443 -u user$i -p openshift
done