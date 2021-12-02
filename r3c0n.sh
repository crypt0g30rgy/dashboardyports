#!/bin/bash
read -p "enter domain name: " domain  #accept user input as a domain-name i.e google.com
	if [ ! -d "$domain"  ]; then  #check if directory exists

        	mkdir -p $domain      #make a directory with the name of the domain i.e /home/user/recon/<goole.com>/
	fi
		assetfinder --subs-only $domain > $domain/output_subs.txt
		
		amass enum -silent -passive -norecursive -noalts -d $domain >>$domain/output_subs.txt
		
		python3 /home/g30rgy/Bin/Sublist3r/sublist3r.py -d $domain -o$domain/output_subs.txt
		
		findomain-linux -q -t $domain >> $domain/output_subs.txt
		
		subfinder -silent -d $domain -o $domain/output_subs.txt
		
		python3 /home/g30rgy/Bin/subbrute/subbrute.py $domain >> $domain/output_subs.txt
		
		cat $domain/output_subs.txt  | sort -u | wc  -l
