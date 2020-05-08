#!/usr/bin/env bash
##########################################################################
# File Name: wcup.sh
# Author: am
# Created Time: Thu Apr 30 19:12:56 2020
#########################################################################

FILE_NAME="./chap0x04/tsvdata/worldcupplayerinfo.tsv"

function ageRangeCount(){
	awk -F  "\t" '
	# before running
	BEGIN{
		d20=0
		bt2030=0
		up30=0
	}
	# during running per line
	NR>1{
		if($6<20){
			d20++
		}
		else if($6<=30){
			bt2030++
		}
		else{
			up30++
		}
	}
	# after running
	END{
		tot=d20+bt2030+up30;
		printf("------------------------------\n")
		printf("range\tnumber\tpercentage\n")
		printf("------------------------------\n")
		printf("[<20]\t%d\t%05.2f%\n",d20,d20/tot*100)
		printf("[20-30]\t%d\t%05.2f%\n",bt2030,bt2030/tot*100)
		printf("[>30]\t%d\t%05.2f%\n",up30,up30/tot*100)
		printf("------------------------------\n")
	}' "${FILE_NAME}"

}

function playerPositionCount(){
	awk -F "\t" '
	BEGIN{
		tot=0		
	}
	NR>1{
		ppc[$5]=ppc[$5]+1
		tot++
	}
	END{
		printf("----------------------------------\n")
		printf("position\tnumber\tpercentage\n")
		printf("----------------------------------\n")
		for(i in ppc){
			printf("%-8s\t%d\t%05.2f%\n",i,ppc[i],ppc[i]/tot*100)
		}
		printf("----------------------------------\n")
	}
	' "${FILE_NAME}"

}

# vegetable algorithm: traversing the file twice to output names that all have the maximum length
function nameLongest(){
	awk -F "\t" '
	BEGIN{
		maxNL=0
		num=0
		printf("------------------------------\n")
		printf("number\tname\n")
	}
	# because we traversing the file twice, so added a comparison between NR and FNR
	# then, we have two {}s
	NR>1&&NR==FNR{
		if(length($9)>=maxNL){
			maxNL=length($9)
		}
	}
	FNR>1&&NR!=FNR{
		if(length($9)==maxNL){
			num++;
			printf("%d\t%s\n",num,$9)
		}
	}
	END{
		printf("------------------------------\n")
		printf("the maximal length is:%d\n",maxNL)
		printf("------------------------------\n")
	}
	' "${FILE_NAME}" "${FILE_NAME}"
	# obviously, we also need to place the same file name twice
}

# the principle of the following functions are consistent with the above
function nameShortest(){
	awk -F "\t" '
	BEGIN{
		minNL=999
		num=0
		printf("------------------------------\n")
		printf("number\tname\n")
	}
	NR>1&&NR==FNR{
		if(length($9)<=minNL){
			minNL=length($9)
		}
	}
	FNR>1&&NR!=FNR{
		if(length($9)==minNL){
			num++;
			printf("%d\t%s\n",num,$9)
		}
	}
	END{
		printf("------------------------------\n")
		printf("the minimal length is:%d\n",minNL)
		printf("------------------------------\n")
	}
	' "${FILE_NAME}" "${FILE_NAME}"
}

function oldest(){
	awk -F "\t" '
	BEGIN{
		maxAGE=0
		num=0
		printf("------------------------------\n")
		printf("number\tage\tname\n")
	}
	NR>1&&NR==FNR{
		if($6>=maxAGE){
			maxAGE=$6
		}
	}
	FNR>1&&NR!=FNR{
		if($6==maxAGE){
			num++;
			printf("%d\t%d\t%s\n",num,$6,$9)
		}
	}
	END{
		printf("------------------------------\n")
		printf("the maxnmal age is:%d\n",maxAGE)
		printf("------------------------------\n")
	}
	' "${FILE_NAME}" "${FILE_NAME}"
}

function youngest(){
	awk -F "\t" '
	BEGIN{
		minAGE=99
		num=0
		printf("------------------------------\n")
		printf("number\tage\tname\n")
	}
	NR>1&&NR==FNR{
		if($6<=minAGE){
			minAGE=$6
		}
	}
	FNR>1&&NR!=FNR{
		if($6==minAGE){
			num++;
			printf("%d\t%d\t%s\n",num,$6,$9)
		}
	}
	END{
		printf("------------------------------\n")
		printf("the minimal age is:%d\n",minAGE)
		printf("------------------------------\n")
	}
	' "${FILE_NAME}" "${FILE_NAME}"
}


SCRIPT_NAME="$0"

function usage(){
cat <<EOF
Usage: bash "${SCRIPT_NAME}" [OPTION] 
[OPTION]
	[-a] [-p] [-l] [-s] [-o] [-y] [--help]
[DECRIPTION] 
	This script can show the information about the "${FILE_NAME}".

	-a                      ageRangeCount
	-p                      playerPositionCount
	-l                      nameLongest
	-s                      nameShortest
	-o                      oldest
	-y                      youngest
	--help                  show help information

EOF
}

function PRINT_ERROR(){
	>&2 echo -e "\033[31m[ERROR]: $1 \033[0m\n" # >&2 same as 1>&2, 
	exit 255
}

ARGS=$(getopt -o aplsoy -l help  -n "${SCRIPT_NAME}" -- "$@")

[ $? != 0 ]&&PRINT_ERROR "unknown argument!"

eval set -- "${ARGS}"

while [ -n "$1" ]; do
	case "$1" in 
		-a) ageRangeCount ;shift ;;
        -p) playerPositionCount ; shift ;;
		-l) nameLongest ; shift ;;
		-s) nameShortest ; shift ;;
		-o) oldest ; shift ;;
		-y) youngest ; shift ;;
     	--help) usage ; exit 0 ;;
        --)shift; break ;;
 		*) PRINT_ERROR "Internal error!"
	esac
done




