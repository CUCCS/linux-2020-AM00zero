##########################################################################
# File Name: test.sh
# Author: am
# Created Time: Sun May  3 11:13:46 2020
#########################################################################
#!/usr/bin/env/bash

awk -F "\t" 'BEGIN{d20=0;bt2030=0;up30=0}NR>1{print $6}' chap0x04/worldcupplayerinfo.tsv
