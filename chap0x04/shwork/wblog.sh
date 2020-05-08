##########################################################################
# File Name: wblog.sh
# Author: am
# Created Time: Mon May  4 21:55:48 2020
#########################################################################
#!/usr/bin/env/bash

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
	for t4xx in ${t4xxs[@]}; do
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

hostTop100
hostIPTop100
freURLTop100
resCntPCT
cnt4xxURL
Top100hostForYourURL $1
