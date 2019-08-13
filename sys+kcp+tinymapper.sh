#!/bin/bash
if cat /etc/issue | grep -q -E -i "debian"; then
	apt-get install whiptail -y
elif cat /etc/issue | grep -q -E -i "ubuntu"; then
	apt-get install whiptail -y
else
	yum install whiptail -y
fi
OPTION=$(whiptail --title "SysConf+KCP+TM OneKey Dialog BY:TURMI" --menu "How many Tuzi u need? Ctrl+C to exit." 15 60 4 \
"1xTuzi" "Modify sysctl.conf" \
"2xTuzi" "Install KCPTun Client and add to rc.local" \
"3xTuzi" "Install KCPTun Server and add to rc.local" \
"4xTuzi" "Install TinyMapper and add to rc.local" 3>&1 1>&2 2>&3)
if [ $OPTION = 1xTuzi ]; then
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
	echo "fs.file-max = 1000000
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
	net.ipv4.ip_forward = 1">>/etc/sysctl.conf
	sysctl -p
	echo "*               soft    nofile           1000000
	*               hard    nofile          1000000">/etc/security/limits.conf
	echo "ulimit -SHn 1000000">>/etc/profile
	whiptail --title "SysConf+KCP+TM OneKey Dialog BY:TURMI" --msgbox "Modify complete! Maybe need reboot system." 10 60
elif [ $OPTION = 2xTuzi ]; then
	wget https://github.com/xtaci/kcptun/releases/download/v20190809/kcptun-linux-amd64-20190809.tar.gz
    tar xvzf kcptun-linux-amd64-20190809.tar.gz
SERVER=$(whiptail --title "SysConf+KCP+TM OneKey Dialog BY:TURMI" --inputbox "Server IP?" 10 60  3>&1 1>&2 2>&3)
PORT=$(whiptail --title "SysConf+KCP+TM OneKey Dialog BY:TURMI" --inputbox "Server PORT?" 10 60 8888 3>&1 1>&2 2>&3)
PW=$(whiptail --title "SysConf+KCP+TM OneKey Dialog BY:TURMI" --inputbox "KCPTun Password?" 10 60 sgtunnel-nxy^809-CAY^883 3>&1 1>&2 2>&3)
CPORT=$(whiptail --title "SysConf+KCP+TM OneKey Dialog BY:TURMI" --inputbox "Client PORT?" 10 60 8888 3>&1 1>&2 2>&3)
METHOD=$(whiptail --title "SysConf+KCP+TM OneKey Dialog BY:TURMI" --inputbox "KCPTun Method (fast,fast2,fast3)?" 10 60 fast3 3>&1 1>&2 2>&3)
nohup ./client_linux_amd64 -r "$SERVER:$PORT" -l ":$CPORT" -mode $METHOD -sndwnd 1024 -rcvwnd 1024 -autoexpire 900 -sockbuf 16777217 -dscp 46 -key $PW -crypt xor -nocomp -keepalive 15 &
sed -i 'exit 0' /etc/rc.local
echo "nohup ./client_linux_amd64 -r "$SERVER:$PORT" -l ":$CPORT" -mode $METHOD -sndwnd 1024 -rcvwnd 1024 -autoexpire 900 -sockbuf 16777217 -dscp 46 -key $PW -crypt xor -nocomp -keepalive 15 &" >>/etc/rc.local
echo "exit 0" >>/etc/rc.local
fi
