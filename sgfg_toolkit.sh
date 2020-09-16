# !/bin/bash
# SGFG_Server_Installer For Public 
# Author:Turmi
# License:WTFPLv2
if cat /etc/issue | grep -q -E -i "debian"; then
	echo -e "\e[41m 不支持Debian操作系统! \e[0m"
elif cat /etc/issue | grep -q -E -i "ubuntu"; then
	echo -e "\e[41m 不支持Ubuntu操作系统! \e[0m"
else
	su - root -c "yum install -y whiptail >/dev/null 2>&1"
fi
