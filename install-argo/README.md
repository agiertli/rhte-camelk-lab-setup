## ArgoCD Setup

This dir includes scripts and resources necessary for setting up the ArgoCD 

## Pre-requisite

You are logged into the OpenShift cluster as cluster admin
`oc` and `argocd` command line utilities are available on the `$PATH`

## Usage

./install.sh -p <ARGOCD_MASTER_PASSWORD>

## Output

`argocd` namespace will be created with Red Hat GitOps operator installed and instance of `ArgoCD CR` with name `argocd-master` will be applied.