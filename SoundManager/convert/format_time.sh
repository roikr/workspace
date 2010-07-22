ls *.txt | awk -F "." '{ print "awk \047{print \"\t\t\t\"$1*1000 \",\"}\047 " $1 ".txt > " $1 "_array.txt"}' | sh
#awk '{print "\t\t\t" $1*1000 ","}' popo.txt > popo.as