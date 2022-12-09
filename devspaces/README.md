# Automating The Installation of Dev Spaces

## Requirements

Tools Installed:
    1. oc
    2. dsc

Installation Guides:
`https://docs.openshift.com/container-platform/4.11/cli_reference/openshift_cli/getting-started-cli.html`
`https://access.redhat.com/documentation/en-us/red_hat_openshift_dev_spaces/3.2/html/administration_guide/installing-devspaces#installing-devspaces-on-openshift-using-the-cli-management-tool`

## Running the script

Make sure you log in to openshift using the `oc login` 

To run the script run `./install.sh` script.
This may fail initially as the subscription takes a while and we hit a time out error. if that happens, try again and it should work. 

## Explanation.

The first step is to install the `Kubernetes Image Puller` operator, this is because it needs to be installed in the `tooling` namespace. If this is not done, it would cause an error.

We then install and deploy the `Dev Spaces` Operator, with the `dsc` tool. we can install the che cluster on the `tooling` namespace, we can also customise the operator yaml using the `dsc` tool and enable the `image puller`option.

We then finally have to update the `kubernetes-imagepuller-operator` Operator Group. With the current version of Dev Spaces the Operator Group has `targetNamespaces:tooling` enabled, this causes an error. This needs to be updated to be include all namespaces. By using `oc patch` tool. 

## Lessons Learnt

One fo the issues I faced is with namespaces. 
Despite multiple attempts to install the Dev Spaces operator and the Kubernetes Image puller operator in the `tooling` namespace.
it simply refused to work. The Dev Spaces operator needed to be installed in `openshift-operators` namespace. 
When trying to use to use the `tooling` namespace. 
I would use install the dev spaces operator as usual, create a new `che cluster` within `tooling` namespace with the image puller option enabled.
I would face `OwnNamespace InstallModeType not supported, cannot configure to watch own namespace` error. 
Despite `https://issues.redhat.com/browse/CRW-3467` and it's fix `https://github.com/eclipse-che/che-operator/pull/1546`.
This could be because I'm using 3.2. It seems to be fixed with dev spaces 3.3, but this has not been released. 