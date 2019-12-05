#!/usr/bin/env bash


curl -O https://en.wikipedia.org/wiki/Harry_Potter

Harry=`grep -o "\<Harry\>" Harry_Potter | wc -l`
Lord=`grep -o "\<Lord\>" Harry_Potter | wc -l`
Hogwarts=`grep -o "\<Hogwarts\>" Harry_Potter | wc -l`

har=`grep -n Harry Harry_Potter | cut -d: -f1 | xargs` 
lo=`grep -n Lord Harry_Potter | cut -d: -f1 | xargs`
hog=`grep -n Hogwarts Harry_Potter | cut -d: -f1 | xargs`


echo 'Harry - ' $Harry '[' $har ']' >> res.txt 
echo 'Lord - ' $Lord '[' $lo ']' >> res.txt
echo 'Hogwarts - ' $Hogwarts '[' $hog  ']' >>res.txt
