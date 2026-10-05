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

# Install bloodhound-cli
git clone https://github.com/SpecterOps/bloodhound-cli.git /opt

if [ ! -x $(which go) ]; then
	apt install -y go
fi

if [ ! -x $(which docker) ]; then
	apt install -y docker.io
fi

if [ ! -x $(which docker-compose) ]; then
	apt install -y docker-compose
fi

go build -ldflags="-s -w -X 'github.com/SpecterOps/BloodHound_CLI/cmd/config.Version=`git describe --tags --abbrev=0`' -X 'github.com/SpecterOps/BloodHound_CLI/cmd/config.BuildDate=`date -u '+%d %b %Y'`'" -o /opt/bloodhound-cli /opt/bloodhound-cli/main.go

cp /opt/bloodhound-cli/bloodhound-cli /usr/bin/.

# Install targeted kerberoast
git clone https://github.com/ShutdownRepo/targetedKerberoast /opt

cp /opt/targetedKerberoast/targetedKerberoast.py /usr/bin/.
