date=$(date +'%Y-%m-%d %X')
battery=$(cat /sys/class/power_supply/BAT0/capacity)

echo $date $battery%
