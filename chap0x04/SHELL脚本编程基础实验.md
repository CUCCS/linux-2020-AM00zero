[![Build Status](https://travis-ci.com/AM00zero/linux-2020-AM00zero.svg?branch=chap0x04)](https://travis-ci.com/AM00zero/linux-2020-AM00zero)

# 实验四：SHELL脚本编程基础

---

## 1.实验准备

- 虚拟机：VIrtualBox 6.1.4 r136177 (Qt5.6.2)
- Linux系统：ubuntu 18.04.4 server 64bit
  
## 2.实验任务

- 本次实验所有脚本执行效果和完整结果，及shellcheck检查所有脚本后的结果详见[travis展示](https://travis-ci.com/github/AM00zero/linux-2020-AM00zero)

#### Mission 1：用bash编写一个图片批处理脚本，实现功能如下：

- 功能完成情况：
  - [x] 支持命令行参数方式使用不同功能
  - [x] 支持对指定目录下所有支持格式的图片文件进行批处理指定目录进行批处理
  - [x] 支持以下常见图片批处理功能的单独使用或组合使用
    - [x] 支持对jpeg格式图片进行图片质量压缩
    - [x] 支持对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率
    - [x] 支持对图片批量添加自定义文本水印
    - [x] 支持批量重命名（统一添加文件名前缀或后缀，不影响原始文件扩展名）
    - [x] 支持将png/svg图片统一转换为jpg格式

- 说明：通过将命令拼接为ImageMagick命令进行图片处理，支持长参数短参数

- 脚本内置帮助信息：
  ```
  Usage: bash "chap0x04/shwork/image.sh" [OPTION]... [FILE]... 
  [OPTION]
    [-q quality] [-r resolution] [-w watermark]
    [-p prefix] [-s suffix] [-j] [-- help] [-d --directory]
  [DECRIPTION] 
    This script can do a variety of batch jobs on images.

    -d, --directory     	  the directoey path of images
    -q, --quality           image quality compression in jpeg format
    -r, --resolution        compress the resolution of jpeg/png/svg images while maintaining the original aspect ratio
    -w, --watermark         add custom text watermarks to images in batches
    -p, --prefix            add prefix to new images' names
    -s, --suffix            add suffix to new images' names
    -j                      convert png/svg images to jpg images
    --help                  show help information
  ```

---

#### Mission 2-1：用bash编写文本批处理脚本，完成相应数据统计任务如下：

- 功能完成情况
  - [x] 统计不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员数量、百分比
  - [x] 统计不同场上位置的球员数量、百分比
  - [x] 名字最长的球员是谁？名字最短的球员是谁？
  - [x] 年龄最大的球员是谁？年龄最小的球员是谁？

- 说明：使用awk及shell脚本编程方式统计球员数据，通过不同传参完成不同功能，并用格式化输出打印，将统计数据结构以良好的视图展现出来
- 脚本内置帮助信息
  ```
  Usage: bash "chap0x04/shwork/wcup.sh" [OPTION] 
  [OPTION]
	  [-a] [-p] [-l] [-s] [-o] [-y] [--help]
  [DECRIPTION] 
	  This script can show the information about the "./chap0x04/tsvdata/worldcupplayerinfo.tsv".
	  -a                      ageRangeCount
	  -p                      playerPositionCount
	  -l                      nameLongest
	  -s                      nameShortest
	  -o                      oldest
	  -y                      youngest
	  --help                  show help information
  ```
- 统计数据结果
  ``` 
  ------------------------------
  range	number	percentage
  ------------------------------
  [<20]	9	01.22%
  [20-30]	600	81.52%
  [>30]	127	17.26%
  ------------------------------
  ----------------------------------
  position	number	percentage
  ----------------------------------
  Défenseur	1	00.14%
  Midfielder	268	36.41%
  Defender	236	32.07%
  Forward 	135	18.34%
  Goalie  	96	13.04%
  ----------------------------------
  ------------------------------
  number	name
  1	Francisco Javier Rodriguez
  2	Lazaros Christodoulopoulos
  3	Liassine Cadamuro-Bentaeba
  ------------------------------
  the maximal length is:26
  ------------------------------
  ------------------------------
  number	name
  1	Jô
  ------------------------------
  the minimal length is:2
  ------------------------------
  ------------------------------
  number	age	name
  1	42	Faryd Mondragon
  ------------------------------
  the maxnmal age is:42
  ------------------------------
  ------------------------------
  number	age	name
  1	18	Fabrice Olinga
  2	18	Luke Shaw
  ------------------------------
  the minimal age is:18
  ------------------------------
  ```

---
#### Mission 2-2：用bash编写文本批处理脚本，完成相应数据统计任务如下：

- 功能完成情况
  - [x] 统计访问来源主机TOP100和分别对应出现的总次数
  - [x] 统计访问来源主机TOP100IP和分别对应出现的总次数
  - [x] 统计最频繁被访问的URLTOP100
  - [x] 统计不同响应状态码的出现次数和对应百分比
  - [x] 分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数
  - [x] 给定URL输出TOP100访问来源主机

- 说明：使用awk及shell脚本编程方式统计日志数据，通过不同传参完成不同功能，并用格式化输出打印，将统计数据结构以良好的视图展现出来
- 脚本内置帮助信息
  ```Usage: bash "chap0x04/shwork/wblog.sh" [OPTION]... 
  [OPTION]
	  [-i ip] [-h host] [-u url] [-r res] 
	  [--cnt4xxurl] [--hostforurl] [-- help] 
  [DECRIPTION] 
	  This script can show the information about the "./chap0x04/tsvdata/web_log.tsv".
	  -i, --ip                hostIPTop100
	  -h, --host              hostTop100
	  -u, --url               freURLTop100
	  -r, --res               resCntPCT
	  --cnt4xxurl	            cnt4xxURL
	  --hostforurl            Top100hostForYourURL
	  --help                  show help information
  ```
- [统计数据结果](https://github.com/CUCCS/linux-2020-AM00zero/tree/chap0x04/chap0x04/stat_results)
  
## 3.课内作业

1. 求2个数的最大公约数，要求：
     - 通过命令行参数读取2个整数，对不符合参数调用规范（使用小数、字符、少于2个参数等）的脚本执行要给出明确的错误提示信息，并退出代码执行
  
  - shell脚本代码如下：
    ```shell
    1 #!/usr/bin/env/bash
    2 #########################################################################
    3 # File Name: class.sh
    4 # Author: am
    5 # Created Time: Thu Apr 23 12:33:01 2020
    6 #########################################################################
    7 
    8 set -eo pipefail
    9 
    10 #ans=0
    11 
    12 function gcd {
    13     if [[ $2 == 0 ]] ;then
    14         #ans=$1
    15         echo $1
    16         return 0
    17     else
    18         gcd $2 $(( "$1" % "$2" )) #由于Shell特性，仅按C语言方式返回递归值并不不符合预期，改用「echo输出」/「全局变量存储」
    19     fi
    20 }
    21 
    22 
    23 if [[ $# != 2 ]];
    24 then
    25     printf "参数数目错误！\n"
    26     exit -1
    27     
    28 elif [[ ! ( "$1" =~ ^-?[0-9]+$ && "$2" =~ ^-?[0-9]+$ ) ]]; #短横负
    29 then
    30     printf "参数不为整数！\n"
    31     exit -1
    32 fi
    33 
    34 gcd $1 $2
    35 #echo ${ans} 
    ```

## 4.参考文献

#### shell编程
- [Linux正则匹配](https://www.cnblogs.com/think-and-do/p/7101986.html)
  - if condition模糊匹配使用正则表达式匹配时用「=~」，使用通配符匹配时用「==」。🤔

- [Shell函数返回值：return关键字](http://c.biancheng.net/view/2863.html)

- [shell中的getopt与getopts](http://www.361way.com/shell-getopt/4981.html)

- [getopt：命令行选项、参数处理](https://linuxeye.com/389.html)
  
- [关于「>&2」的疑惑](https://zhidao.baidu.com/question/538628763.html)
  - 根据此赶忙改进了自己的PRINT_ERROR函数

- [which/type/command](http://blog.sina.com.cn/s/blog_d9809c3d0102xet2.html)

- [shell中的(),(()),{},=,==,[],[[]]几种语法用法](https://blog.csdn.net/Michaelwubo/article/details/81698307)

- [shell if [ -n ]用法](https://www.cnblogs.com/ariclee/p/6137456.html)

- [#*,##*,#*,##*,% *,%% *含义及用法/替换字符](https://blog.csdn.net/zhaoyangjian724/article/details/89383479)

- [shell数组](http://c.biancheng.net/view/810.html)

- [Shell编程排序工具sort和uniq](https://www.cnblogs.com/llife/p/11682072.html)

#### awk编程

- [awk官方手册](http://www.gnu.org/software/gawk/manual/gawk.html#Arrays)
  
- [awk编程基础](hhttps://www.cnblogs.com/meitian/p/5302416.html)

- [awk命令详解及示例](https://blog.csdn.net/jsut_rick/article/details/78287744?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromBaidu-1&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromBaidu-1)

- [awk中二维数组使用](https://blog.csdn.net/beyondlpf/article/details/7024730)

## 5.插曲
- 在删除img中输出的测试图片时没看清处所在目录，直接rm *删掉了原本的脚本，最后又过了几天才写回来TAT。~~最后痛定思痛把rm重命名mv设了一个回收站按时清理以为就可以避免删库跑路了~~
- 直接放web_log是不可能的，超过100MB的文件放入github需要一些别的操作，~~因为懒得看是什么操作~~于是直接放入.7z文件