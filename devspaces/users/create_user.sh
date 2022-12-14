htpasswd -c -B -b users.htpasswd user2 openshift

for i in {2..11}
do
    htpasswd -Bb users.htpasswd user$i openshift
done

