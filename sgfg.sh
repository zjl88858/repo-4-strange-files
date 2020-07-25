# !/bin/bash
# SGFG_Server_Installer Author:Turmi License:WTFPLv2
if cat /etc/issue | grep -q -E -i "debian"; then
  echo "ERROR:你是傻逼吗?傻逼才装Debian."
  exit
elif cat /etc/issue | grep -q -E -i "ubuntu"; then
  echo "STEP1:系统检查 Success."
else
  echo "ERROR:你连傻逼都不如,傻逼都知道装Debian.想给大脑升级吗?那就赶紧装Ubuntu."
fi
