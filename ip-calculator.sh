#/bin/bash

# Author : ECote
# Calculate IPs in txt files in the directory where this script resides.
# Help to determine the POSSIBLE IPs available in subnets declared in scope.

# ipcalc is required --> sudo apt install ipcalc
# Example of txt file content:

# 192.168.1.0/24
# 172.16.0.0./16
# 10.0.0.0/8

# Verify if ipcalc is installed
hash ipcalc 2>/dev/null || { echo >&2 "ipcalc is required but is not installed.  Aborting."; exit 1; }

declare -i total
declare -i total2
declare -i hosts
total=0
total2=0
hosts=0
echo "Calculating..."
# Loop for txt files in current directory
for txt in `ls *.txt`; do
  # Loop for IPs in each txt files
  hosts=0
  total=0
  for ip in `cat $txt`; do 
    #ipcalc $ip|grep -i Hosts|cut -d " " -f 2
    if [[ "$ip" == *"/"* ]]; then
        hosts=$(ipcalc -nb $ip|grep -i Hosts|cut -d " " -f 2) && total=total+$hosts
    else
        hosts=$(ipcalc -nb $ip 32|grep -i Hosts|cut -d " " -f 2) && total=total+$hosts
    fi
  done
  echo "Total IPs in $txt: $total"
  total2=$total2+$total
done
echo "All txt files combined: $total2"
