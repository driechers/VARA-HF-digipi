#!/bin/bash -x

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT
trap ctrl_c TERM
function ctrl_c() {
   echo "CTRL-C pressed, killing xterm"
   vncserver -kill :1
   sudo kill `ps aux | grep launch | grep -v grep | awk '{print $2}'`  # novnc socket
   sudo sh -c  "echo powersave  > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"

   exit 0
}

sudo sh -c  "echo performance  > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"

source ~/localize.env

# stop stuff
vncserver -kill :1
sudo kill `ps aux | grep launch | grep -v grep | awk '{print $2}'`  # novnc socket

# start stuff
nice -n 5 vncserver -depth 16                                 # runs in background
nice -n 5 /usr/share/novnc/utils/novnc_proxy --vnc localhost:5901 &                # this doesn't exit

export DISPLAY=:1   

export LC_ALL=C; unset LANGUAGE

echo ============ Starting Varanny ======================
cd git/varanny
./varanny &

sudo renice -n 0 `ps aux | grep varanny | grep -v grep | awk '{print $2}'`
sudo renice -n 5 `ps aux | grep Xtightvnc | grep -v grep | awk '{print $2}'`

echo "URL is http://digipi.local:6080/vnc.html?port=6080&password=test11&autoconnect=true "

sleep infinity
