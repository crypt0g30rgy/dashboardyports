#!/bin/bash	
 url=$1
 if [ ! -d "$url" ];then
	 mkdir $url
	 fi
	 if [ ! -d "$url/recon" ];then
		 mkdir $url/recon
		   fi
		 if [ ! -d "$url/recon/scans" ];then
			 mkdir $url/recon/scans
			 fi
			 if [ ! -d "$url/recon/httprobe" ];then
				 mkdir $url/recon/httprobe
				 fi
				 if [ ! -d "$url/recon/potential_takeovers" ];then
					 mkdir $url/recon/potential_takeovers
								 fi
								 if [ ! -f "$url/recon/httprobe/alive.txt" ];then
									 touch $url/recon/httprobe/alive.txt
									 fi
									 if [ ! -f "$url/recon/final.txt" ];then
										 touch $url/recon/final.txt
										 fi
										 
										 echo "[+] Harvesting subdomains with assetfinder..."
										 assetfinder $url >> $url/recon/assets.txt
										 cat $url/recon/assets.txt | grep $1 >> $url/recon/final.txt
										 rm $url/recon/assets.txt
										 
										 echo "[+] Double checking for subdomains with amass..."
										 amass enum -d $url >> $url/recon/f.txt
										 sort -u $url/recon/f.txt >> $url/recon/final.txt
										 rm $url/recon/f.txt
										 
										 echo "[+] Probing for alive domains..."
										 cat $url/recon/final.txt | sort -u | httprobe -s -p https:443 | sed 's/https\?:\/\///' | tr -d ':443' >> $url/recon/httprobe/a.txt
										 sort -u $url/recon/httprobe/a.txt > $url/recon/httprobe/alive.txt
										 rm $url/recon/httprobe/a.txt
										 
										 echo "[+] Checking for possible subdomain takeover..."
										 
										 if [ ! -f "$url/recon/potential_takeovers/potential_takeovers.txt" ];then
											 touch $url/recon/potential_takeovers/potential_takeovers.txt
											 fi
											 
											 subjack -w $url/recon/final.txt -t 100 -timeout 30 -ssl -c fingerprints.json -v 3 -o $url/recon/potential_takeovers/potential_takeovers.txt

											 echo "[+] Scanning for open ports..."
										
