#!/bin/bash

IP=$1

if [ "$#" -lt 1 ]; then
	read -p "Enter IP to scan: " IP
fi

DIR="scan-$IP"

if [ ! -d $DIR ]; then
	mkdir $DIR
else
	read -p "[!] Directory already exists, overwrite? [Y/n]: " CHOICE
	if [ ${CHOICE,,} == "y" ]; then
		rm -rf $DIR
		mkdir $DIR
	elif [ ${CHOICE,,} == "n" ]; then
		echo "[!] Stopped the program - directory already exists."
		exit 1
	else
		echo "[!] Invalid option!"
		exit 1
	fi
fi

echo "[*] Starting nmap-full scan!"

sudo nmap -T4 -Pn -sS -v $IP -p- --min-rate 1000 -max-rtt-timeout 1000ms --max-retries 5 > $DIR/basicscan.txt
echo "[*] Port scan finished!"

ports=$(cat $DIR/basicscan.txt | grep -E '^[0-9]+' | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//)

sudo nmap -sV -sC -T4 -Pn -v $IP -p $ports > $DIR/versionscan.txt
echo "[*] Version scan finished!"

sudo nmap -sV --script=vuln -v $IP > $DIR/vulnscan.txt
echo "[*] Vuln scan finished!"

echo "[+] All finished! Output files are in $DIR"
