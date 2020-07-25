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
mkdir -p .ssh
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
echo "STEP4:配置Sysctl Success."
wget -O linux-image-5.7.10-xanmod1_5.7.10-xanmod1.ed358d3_amd64.deb https://sourceforge.net/projects/xanmod/files/releases/stable/5.7.10-xanmod1/linux-image-5.7.10-xanmod1_5.7.10-xanmod1-0%7Egit20200722.ed358d3_amd64.deb/download
wget -O linux-headers-5.7.10-xanmod1_5.7.10-xanmod1.ed358d3_amd64.deb https://sourceforge.net/projects/xanmod/files/releases/stable/5.7.10-xanmod1/linux-headers-5.7.10-xanmod1_5.7.10-xanmod1-0%7Egit20200722.ed358d3_amd64.deb/download
sudo dpkg -i linux-image-*xanmod*.deb linux-headers-*xanmod*.deb
echo "STEP5:安装Xanmod内核 Success."
sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
echo "net.core.default_qdisc=cake" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p
echo "STEP6:开启BBR和CAKE队列算法 Success."
wget https://raw.githubusercontent.com/CokeMine/ServerStatus-Hotaru/master/status.sh
wget https://github.com/ginuerzh/gost/releases/download/v2.11.1/gost-linux-amd64-2.11.1.gz
gunzip gost-linux-amd64-2.11.1.gz
wget https://github.com/txthinking/brook/releases/download/v20200701/brook_linux_amd64
chmod +x status.sh
chmod +x gost-linux-amd64-2.11.1
chmod +x brook_linux_amd64
mv gost-linux-amd64-2.11.1 gost
mv brook_linux_amd64 brook
echo "STEP7:下载中间件 Success."
echo "确认无误后,请重启."
echo "重启后使用密钥连接SSH,并使用 cat /proc/sys/net/core/default_qdisc 查看队列算法是否正确,使用 uname -a 查看内核是否正确."
