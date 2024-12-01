#!/usr/bin/bash
set -e

[ -z $1 ] && echo "No input file provided" && exit 1
[ -z $2 ] && echo "No subproblem provided" && exit 1
[[ $2 -eq 1 || $2 -eq 2 ]] || (echo "Sub problem should either be 1 or 2" && exit 1)

awk -F ' ' '{print $1}' < $1 | sort > col1.txt
awk -F ' ' '{print $2}' < $1 | sort > col2.txt

similarity_score=0
while read -r line
do
	IFS=":" read a b <<< $line

	if [[ $2 -eq 1 ]]
	then

		distance=$((b - a))
		[[ $distance -lt 0 ]] && distance=$(($distance * -1))
		echo $distance
	else
		count=$(grep -c $a col2.txt) && similarity_score=$((similarity_score + a*count))
	fi

done <<< $(paste -d":" col1.txt col2.txt)

[[ $2 -eq 2 ]] && echo $similarity_score

rm col1.txt col2.txt
