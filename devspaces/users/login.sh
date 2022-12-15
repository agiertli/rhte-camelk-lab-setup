# while getopts "c:" opt; do
#   case $opt in
#     p) CLUSTER="$OPTARG"
#     ;;
#     \?) echo "Invalid option -$OPTARG" >&2
#     exit 1
#     ;;
#   esac

#   case $OPTARG in
#     -*) echo "Option $opt needs a valid argument"
#     exit 1
#     ;;
#   esac
# done
for i in {2..11}
do
    # oc login --server=${CLUSTER} -u user$i -p openshift
    oc login -u user$i -p openshift
done