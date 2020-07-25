# !/bin/bash
# SGFG_Server_Installer
# Author:Turmi
# License:WTFPLv2
if cat /etc/issue | grep -q -E -i "debian"; then
  echo "ERROR:你是傻逼吗?傻逼才装Debian."
  exit
elif cat /etc/issue | grep -q -E -i "ubuntu"; then
  if whoami | grep -q -E -i "root"; then
  echo "STEP1:系统检查 Success."
  else
  echo "ERROR:用root,如果你不知道怎么切, sudo su - 即可."
  fi
else
  echo "ERROR:你连傻逼都不如,傻逼都知道装Debian.想给大脑升级吗?那就赶紧装Ubuntu."
  exit
fi
cd .ssh
cat>authorized_keys<<EOF
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBtv1Z4gytAih/QwiayKapnUl5irWsiY2MX38lYhXGvd sgfg_root
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
cat>>/etc/ssh/sshd_config<<EOF
PasswordAuthentication no
EOF
if cat /etc/ssh/sshd_config | grep -q -E -i "PasswordAuthentication no"; then
  systemctl restart sshd
  echo "STEP3:配置OpenSSH Success."
else
  echo "ERROR:我觉得这个错误不可能出现,除非你没有systemd(魔改版Ubuntu?)."
  exit
fi
