ls *mp3 | awk -F "." '{print $1}' > list.txt
ls *mp3 | awk -F "." '{print $1 "_SOUND " $1}' > def.txt
