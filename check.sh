OUTPUT="$(ssh cluster1 -l admin "metrocluster show"|grep "Local:")"
echo "$OUTPUT"
case $OUTPUT in
        *switchover*)
                echo "COMPLETED";;
        *normal*)
                echo "READY";;
        *)
                echo "ERROR";;
esac


