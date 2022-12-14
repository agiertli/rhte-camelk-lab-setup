
for i in {2..11}
do
    # Create Project On Openshift
    oc process -f workspace/namespace.yaml -p USERNAME=user$i | oc create -f - &
    sleep 0.5
    # Gives user access to namespace
    oc adm policy add-role-to-user admin user$i -n user$i-devspaces

    # Grant permissions
    oc process -f workspace/auth.yaml -p USERNAME=user$i -p UUID=$(oc get users.user.openshift.io user$i | awk 'FNR == 2 { print $2 }') | oc create -f - &

    # Config Maps to Be Installeed
    oc process -f configmaps/devworkspace-gitconfig.yaml -p USERNAME=user$i | oc create -f - -n user$i-devspaces
    oc process -f configmaps/workspace-preferences-configmap.yaml -p USERNAME=user$i | oc create -f - -n user$i-devspaces
    oc process -f configmaps/workspace-userdata-gitconfig-configmap.yaml -p USERNAME=user$i | oc create -f - -n user$i-devspaces

    # Add missing secrets
    oc process -f secrets/user-preferences.yaml -p USERNAME=user$i | oc create -f - -n user$i-devspaces
    oc process -f secrets/user-profile.yaml -p USERNAME=user$i | oc create -f - -n user$i-devspaces
    oc process -f secrets/workspace-credentials-secret.yaml -p USERNAME=user$i | oc create -f - -n user$i-devspaces

    # Create the workspace
    oc process -f devspace/devworkspace-template.yaml -p USERNAME=user$i | oc create -f - -n user$i-devspaces
    oc process -f devspace/devworkspace.yaml -p USERNAME=user$i | oc create -f - -n user$i-devspaces &
    
done
