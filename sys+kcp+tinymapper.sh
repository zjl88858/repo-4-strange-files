#!/bin/bash
if cat /etc/issue | grep -q -E -i "debian"; then
apt install whiptail -y
elif cat /etc/issue | grep -q -E -i "ubuntu"; then
apt install whiptail -y
else
yum install whiptail -y
OPTION=$(whiptail --title "兔子最可爱" --menu "Choose your option" 15 60 4 \
"1" "Grilled Spicy Sausage" \
"2" "Grilled Halloumi Cheese" \
"3" "Charcoaled Chicken Wings" \
"4" "Fried Aubergine"  3>&1 1>&2 2>&3)
 
exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Your chosen option:" $OPTION
else
    echo "You chose Cancel."
fi
