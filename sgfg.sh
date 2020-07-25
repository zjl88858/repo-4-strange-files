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
sed -i '/net.ipv4.tcp_retries2/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_slow_start_after_idle/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_fastopen/d' /etc/sysctl.conf
sed -i '/fs.file-max/d' /etc/sysctl.conf
sed -i '/fs.inotify.max_user_instances/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_syncookies/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_fin_timeout/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_tw_reuse/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_max_syn_backlog/d' /etc/sysctl.conf
sed -i '/net.ipv4.ip_local_port_range/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_max_tw_buckets/d' /etc/sysctl.conf
sed -i '/net.ipv4.route.gc_timeout/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_synack_retries/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_syn_retries/d' /etc/sysctl.conf
sed -i '/net.core.somaxconn/d' /etc/sysctl.conf
sed -i '/net.core.netdev_max_backlog/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_timestamps/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_max_orphans/d' /etc/sysctl.conf
sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf
cat>>/etc/sysctl.conf<<EOF
net.ipv4.tcp_retries2 = 8
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_fastopen = 3
fs.file-max = 1000000
fs.inotify.max_user_instances = 8192
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.core.somaxconn = 32768
net.core.netdev_max_backlog = 32768
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_max_orphans = 32768
# forward ipv4
net.ipv4.ip_forward = 1
EOF
sysctl -p
cat>/etc/security/limits.conf<<EOF
*               soft    nofile           1000000
*               hard    nofile           1000000
EOF
echo "ulimit -SHn 1000000">>/etc/profile
