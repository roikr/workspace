awk '{ printf "\t\tpublic static const %s : String = \"%s\";\n",$1,$2}' def.txt > const.txt
ls *mp3 | awk -F "." '{ printf "\t\t[Embed(source=\"../sounds/%s.mp3\")] private static var %s:Class;\n",$1,$1}' > library.txt
