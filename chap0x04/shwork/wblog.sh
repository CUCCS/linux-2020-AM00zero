#!/usr/bin/env/bash
##########################################################################
# File Name: wblog.sh
# Author: am
# Created Time: Mon May  4 21:55:48 2020
#########################################################################

FILE_NAME="./chap0x04/tsvdata/web_log.tsv"

# the hostTop100's method is different from other functions because of the "uniq"
function hostTop100(){
	
	echo   "show the top100 hosts"
	echo   "---------------------------------------------"
	printf "%-33s\t%s\n" "hostname" "count"
	echo   "---------------------------------------------"

	awk -F "\t" '
	NR>1{
		print $1
	}
	' "${FILE_NAME}" | sort | uniq -c | sort -unr | head -n 100 | 
	awk '{printf("%-33s\t%5d\n",$2,$1)}'
	# the "uniq -c"'s "-c" has a counting function 
	echo   "---------------------------------------------"
}

# In addition to uniq, we can count with ARR(actually a DIC)(dog's head)
function hostIPTop100(){
		
	echo   "show the top100 hostIPs"
	echo   "---------------------------------"
	printf "%-18s\t%s\n" "IP" "count"
	echo   "---------------------------------"

	# $1~/「RE」/
	awk -F "\t" '
	NR>1&&$1~/([0-9]{1,3}\.){3}[0-9]{1,3}/{
		hostIPcnt[$1]+=1
	}
	END{
		for(i in hostIPcnt){
			printf("%-18s\t%5d\n",i,hostIPcnt[i])
		}
	}
	' "${FILE_NAME}" | sort -nr -k 2 | head -n 100

	echo "-----------------------------------"
}

function freURLTop100(){
	
	echo   "show the top100 frequent URLs"
	echo   "---------------------------------------------------------------------"
	printf "%-56s\t%s\n" "URL" "count"
	echo   "---------------------------------------------------------------------"

	awk -F "\t" '
	NR>1{
		URLcnt[$5]+=1
	}
	END{
		for(i in URLcnt){
			printf("%-56s\t%5d\n",i,URLcnt[i])
		}
	}
	' "${FILE_NAME}" | sort -nr -k 2 | head -n 100

	echo    "--------------------------------------------------------------------"

}
	
function resCntPCT(){
	
	echo   "show the top100's count and percentage of response"
	echo   "-----------------------------------------"
	printf "%-10s\t%9s\t%8s\n" "response" "count" "PCT"
	echo   "-----------------------------------------"

	awk -F "\t" '
	BEGIN{
		tot=0
	}
	NR>1{
		rescnt[$6]+=1
		tot++
	}
	END{
		for(i in rescnt){
			printf("%-10s\t%9d\t%8.5f%\n",i,rescnt[i],rescnt[i]/tot*100)
		}
	}
	' "${FILE_NAME}" | sort -nr -k 2 | head -n 100

	echo    "-----------------------------------------"
}	

function cnt4xxURL(){
	
	echo   "show the top10 URL that 4xx correspond "
	echo   "*--------------------------------------"
	# the "uniq" does not work when duplicate lines are not adjacent, so we need sort to keep it company
	# but, why not just use "sort -u"?
	t4xxs=$(awk -F "\t" 'NR>1&&$6~/^4/{print $6}' "${FILE_NAME}" | sort -u )
	for t4xx in "${t4xxs[@]}"; do
		echo "${t4xx}'s top10 URL"
		echo   "---------------------------------------------------------------------"
		printf "%-8s\t%-42s\t%s\n" "response" "URL" "count"
		echo   "---------------------------------------------------------------------"
		# we're using a pseudo-two-dimensional array of awk here
		awk -F "\t" '
		NR>1&&$6~/^4/{
			show4xx[$6,$5]+=1 
		}
		END{
			for(url4xx in show4xx){
			split(url4xx,idx,SUBSEP)			
			printf("%-8s\t%-42s\t%5d\n",idx[1],idx[2],show4xx[idx[1],idx[2]])
			}
		}
		' "${FILE_NAME}" | grep ${t4xx} | sort -nr -k 3 | head -n 10
		echo "-------------------------------------------"
	done
	echo   "*---------------------------------------*"
	
}

function Top100hostForYourURL(){
	
	URL=$1
	
	echo   "show the top100 hosts of ${URL}"
	echo   "---------------------------------------------"
	printf "%-33s\t%s\n" "hostname" "count"
	echo   "---------------------------------------------"

	awk -F "\t" '
	NR>1&&$5=="'"${URL}"'"{
		hostcnt[$1]+=1
	}
	END{
		for(i in hostcnt){
			printf("%-33s\t%5d\n",i,hostcnt[i])
		}
	}
	' "${FILE_NAME}" | sort -nr -k 2 | head -n 100

	echo "---------------------------------------------"
}

SCRIPT_NAME="$0"

function usage(){
cat <<EOF
Usage: bash "${SCRIPT_NAME}" [OPTION]... 
[OPTION]
	[-i ip] [-h host] [-u url] [-r res] 
	[--cnt4xxurl] [--hostforurl] [-- help] 
[DECRIPTION] 
	This script can show the information about the "${FILE_NAME}".

	-i, --ip                hostIPTop100
	-h, --host              hostTop100
	-u, --url               freURLTop100
	-r, --res               resCntPCT
	--cnt4xxurl	            cnt4xxURL
	--hostforurl            Top100hostForYourURL
	--help                  show help information

EOF
}

function PRINT_ERROR(){
	>&2 echo -e "\033[31m[ERROR]: $1 \033[0m\n" # >&2 same as 1>&2, 
	exit -1
}

ARGS=$(getopt -o ihur --long help,ip,host,url,res,cnt4xxurl,hostforurl:  -n "${SCRIPT_NAME}" -- "$@")

[ $? != 0 ]&&PRINT_ERROR "unknown argument!"

eval set -- "${ARGS}"

while [ -n "$1" ]; do
	case "$1" in 
		-i|--ip) hostIPTop100 ;shift ;;
        -h|--host) hostTop100 ; shift ;;
		-u|--url) freURLTop100 ; shift ;;
		-r|--res) resCntPCT ; shift ;;
		--cnt4xxurl) cnt4xxURL ; shift ;;
		-hostfoturl) Top100hostForYourURL "$2" ; shift 2 ;;
     	--help) usage ; exit 0 ;;
        --)shift; break ;;
 		*) PRINT_ERROR "Internal error!"
	esac
done

