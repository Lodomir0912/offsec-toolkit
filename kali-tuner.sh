#!/bin/bash
# Script made for automatic tuning for Kali Linux

# Prepare directories in /opt
for dir in tools privesc pivot; do
	if [ ! -d "/opt/$dir" ]; then
		mkdir -p /opt/$dir
	fi
done

# Pull tools repository
git clone https://github.com/Lodomir0912/offsec-toolkit /opt/tools/.

# Download scripts for privesc
wget https://github.com/peass-ng/PEASS-ng/releases/download/20260924-77959926/linpeas.sh -O /opt/privesc/linpeas.sh
wget https://github.com/peass-ng/PEASS-ng/releases/download/20260924-77959926/winPEASany.exe -O /opt/privesc/winPEASany.exe
wget https://raw.githubusercontent.com/rebootuser/LinEnum/refs/heads/master/LinEnum.sh -O /opt/privesc/LinEnum.sh
wget https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/refs/heads/master/Privesc/PowerUp.ps1 -O /opt/privesc/PowerUp.ps1

# Add nmap-full to path
cp /opt/tools/nmap-full.sh /usr/bin
mv /usr/bin/nmap-full.sh /usr/bin/nmap-full
chmod u+x /usr/bin/nmap-full

# Download and extract chisel for pivoting
wget https://github.com/jpillora/chisel/releases/download/v1.12.0/chisel_1.12.0_linux_amd64.gz -O /opt/pivot/chisel_1.12.0_linux_amd64.gz
gunzip /opt/pivot/chisel_1.12.0_linux_amd64.gz

