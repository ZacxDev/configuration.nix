''
[ether-price]
command=$SCRIPT_DIR/ether-price
interval=30

[toggle-k3d]
command=$SCRIPT_DIR/toggle-k3d
interval=1

[bandwidth]
command=$SCRIPT_DIR/bandwidth
interval=persist
markup=pango
LABEL=<span>↓↑</span>

[ssid]
command=$SCRIPT_DIR/ssid
interval=60
INTERFACE=dev

[wifi]
command=$SCRIPT_DIR/wifi
label=wifi:
INTERFACE=wlp170s0
interval=60

[network-speed]
command=$SCRIPT_DIR/network-speed
INTERFACE=wlp170s0
interval=30

[iface]
command=$SCRIPT_DIR/iface
#LABEL=wlan0:
#IFACE=wlan0
#ADDRESS_FAMILY=inet6?
color=#00FF00
interval=10
# set this to 1 to display the name of the connected WIFI interface instead of the IP address.
display_wifi_name=0

[cpu_usage]
command=$SCRIPT_DIR/cpu_usage/cpu_usage
markup=pango
interval=persist
min_width=CPU 100.00%
REFRESH_TIME=1
LABEL=CPU
WARN_PERCENT=50
CRIT_PERCENT=80
DECIMALS=2

[temperature]
command=$SCRIPT_DIR/temperature
label=TEMP 
interval=10

[battery]
command=$SCRIPT_DIR/battery
LABEL=BAT
interval=5

[calendar]
command=$SCRIPT_DIR/calendar
interval=1
''

