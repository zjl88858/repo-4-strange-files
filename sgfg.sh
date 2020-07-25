# !/bin/bash
# SGFG_Server_Installer Author:Turmi License:WTFPLv2
if cat /etc/issue | grep -q -E -i "debian"; then
  echo "ERROR:你是傻逼吗?傻逼才装Debian."
  exit
elif cat /etc/issue | grep -q -E -i "ubuntu"; then
  echo "STEP1:系统检查 Success."
else
  echo "ERROR:你连傻逼都不如,傻逼都知道装Debian.想给大脑升级吗?那就赶紧装Ubuntu."
  exit
fi
cd .ssh
cat>authorized_keys<<EOF
---- BEGIN SSH2 PUBLIC KEY ----
Comment: "root"
AAAAC3NzaC1lZDI1NTE5AAAAIBtv1Z4gytAih/QwiayKapnUl5irWsiY2MX38lYh
XGvd
---- END SSH2 PUBLIC KEY ----
EOF
chmod 600 authorized_keys
cd /root
chmod 700 ~/.ssh
if cat .ssh/authorized_keys | grep -q -E -i "AAAAC3Nza"; then
  echo "STEP2:安装SSH公钥 Success."
else
  echo "ERROR:我觉得这个错误不可能出现,但如果你遇到了请扔掉这个辣鸡机器."
  exit
fi
