awk 'BEGIN { for (i=0;i<=186;i++) print "exiftool -p \047$Duration $Filename\047 NEW_PIZZ/PIZZ" i ".wav" }' | sh > pizz.txt
