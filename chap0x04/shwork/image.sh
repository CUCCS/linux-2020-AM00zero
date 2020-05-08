#!/usr/bin/env/bash
##########################################################################
# File Name: image.sh
# Author: am
# Created Time: Tue Apr 28 12:12:55 2020
#########################################################################

# env parameters
TYPE_ARR=("jpg" "png" "svg" "jpeg")
TOOL_NAME="convert"
SCRIPT_NAME="$0"

# use cat+EOF to instead of "echo" and "printf" line by line 
function usage(){
cat <<EOF
Usage: bash "${SCRIPT_NAME}" [OPTION]... [FILE]... 
[OPTION]
	[-q quality] [-r resolution] [-w watermark]
	[-p prefix] [-s suffix] [-j] [-- help] [-d --directory]
[DECRIPTION] 
	This script can do a variety of batch jobs on images.

	-d, --directory     	the directoey path of images
	-q, --quality           image quality compression in jpeg format
	-r, --resolution        compress the resolution of jpeg/png/svg images while maintaining the original aspect ratio
	-w, --watermark         add custom text watermarks to images in batches
	-p, --prefix            add prefix to new images' names
	-s, --suffix            add suffix to new images' names
	-j                      convert png/svg images to jpg images
	--help                  show help information

EOF
}

# regular parameters-----
QUALITY_FLAG=false
RESOLUTION_FLAG=false
WATERMARK_FLAG=false
JPG_FLAG=false

quality_compress=100
resolution_compress=""
directory_PATH=""
watermark=""
prefix=""
suffix=""

#------------------------

# red letter and black backgroud-->\033[31m ... \033[0m
# >&2:When bash image.sh > txt is executed, the contents of the echo are not saved in txt, but are displayed in the screen back
function PRINT_ERROR(){
	>&2 echo -e "\033[31m[ERROR]: $1 \033[0m\n" # >&2 same as 1>&2, 
	exit 255
}

# CHECK FUNCTIONS--------
function ENV_CHECK(){
	if ! [ -x "$(command -v convert)" ];
	then
		PRINT_ERROR "convert is not found!"
	fi
}
ENV_CHECK

function PATH_CHECK(){
	if ! [[ -d $1 ]];
	then
		PRINT_ERROR "$1 is not a valid path!"
	fi
} 

function POSITIVE_INTEGER_CHECK(){
	if [[ ! ( "$1" =~ ^[0-9]+$) ]];
	then
		PRINT_ERROR "$1 is not a positive integer!"
	fi
}

function TYPE_CHECK(){
	if [[ "${TYPE_ARR[*]}" == *"$1"*  ]]; # wildcard-->'==';RE-->'=~'
	then
		TYPEOK=true
	else
		TYPEOK=false
	fi
}
#-----------------------

# entry parameters analysis
ARGS=$(getopt -o :q:r:w:p:s:d:j -l help,quality:,resolution:,watermark:,prefix:,suffix:,directory:,jpg -- "$@")

[ $? != 0 ]&&PRINT_ERROR "unknown argument!"

# 'eval'--> prevent the shell command in the parameter and be extended by error
#  '--' --> ensure that the string behind the string is not directly resolved
eval set -- "${ARGS}"

while [ -n "$1" ] # must be "$1" but not $1 because of the '-n'	
do
	case "$1" in
	--help)
		usage
		exit 0
		;;
	-q|--quality)
		QUALITY_FLAG=true
		quality_compress=$2	
		POSITIVE_INTEGER_CHECK ${quality_compress}
		shift 2
		;;
	-r|--resolution)
		RESOLUTION_FLAG=true
		resolution_compress="$2"
		shift 2
		;;
	-w|--watermark)
		WATERMARK_FLAG=true
		watermark=$2
		shift 2
		;;
	-p|--prefix)
		prefix="$2"
		shift 2
		;;
	-s|--suffix)
		suffix="$2"
		shift 2
		;;
	-d|--directory)
		directory_PATH="$2"
		PATH_CHECK "${directory_PATH}"
		shift 2
		;;
	-j)
		JPG_FLAG=true
		shift
		;;
	--)
		shift
		break
		;;
	*)
		PRINT_ERROR "unknown argument!"
	esac
done
#--------------------
# main function to excute
function main(){

output_DPATH="${directory_PATH}/output"
mkdir -p "${output_DPATH}"
images_List=$(ls "${directory_PATH}")

for NOW_IMAGE_File in $images_List;
do
	#-file---------
	filename="${NOW_IMAGE_File##*/}" #imagename.type
	NAME="${filename%.*}" #imagename
	TYPE="${filename#*.}" #type
	TYPE_CHECK "${TYPE}"
	if ! ${TYPEOK} ;then continue ;fi	
	
	#-command-------
	COMMAND="${TOOL_NAME}"
	
	if  ${QUALITY_FLAG} && [[ "${TYPE}" == "jpeg" ]] ;
	then
		COMMAND="${COMMAND} -quality ${quality_compress}" 
	fi 
	
	if  ${RESOLUTION_FLAG} && [[ ${TYPE} != "jpg" ]] ;
	then
		COMMAND="${COMMAND} -resize ${resolution_compress}"
	fi
	
	COLOR="white"
	POINTSIZE=40
	POSITION='10,50'
	if ${WATERMARK_FLAG} ;then COMMAND="${COMMAND} -fill ${COLOR} -pointsize ${POINTSIZE} -draw 'text ${POSITION} \"${watermark}\" ' " ;fi
	if ${JPG_FLAG} ;
	then
		if [[ ${TYPE} == "png" || ${TYPE} == "svg" ]];
		then
			TYPE="jpg" 
		fi
	fi
	# genareate a command
	saveFile="${prefix}${NAME}${suffix}.${TYPE}"
	CMD="${COMMAND} ${directory_PATH}/${NOW_IMAGE_File} ${output_DPATH}/${saveFile}"
	
	#echo "${CMD}" # print to test
	eval "${CMD}"

done

}

main
