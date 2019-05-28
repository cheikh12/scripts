#!/bin/bash
echo Debut

git log -1  --name-only > path.txt
cut -f1 -d/ -s  path.txt | uniq > paquets.txt

while read p; do
    if [ $p != Jenkinsfile ]; then
        echo "Modification sur le package $p :  $p"
        echo "############### Clean Rebuild du package $p ######################"
        R CMD INSTALL --preclean $p > res_build.txt
        grep -i " ERROR " res_build.txt
        if [ $? == 0 ];
        then
            rm paquets.txt
            rm res_build.txt
            echo BUILD FAILED
            exit 1
        else
            echo "BUILD SUCCESS"
            rm res_build.txt
        fi
        echo "############### Checking packages....pour $p ######################"
        R CMD Check > res_check.txt
        grep -i " ERROR " res_check.txt
        if [ $? == 0 ];
        then
            rm paquets.txt
            rm res_checj.txt
            echo R CMD Check Failed
            exit 1
        else
            echo "R CMD Check succeded"
            rm res_check.txt
        fi
    fi
done < paquets.txt
rm paquets.txt


