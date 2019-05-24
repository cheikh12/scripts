#!/bin/bash
cd Compiler404
git log -5 --author="cheikh12" --name-only > path.txt
cut -f2 -d/ -s  path.txt | uniq > paquets.txt

while read p; do
  echo "le paquet $p"
done < paquets.txt
