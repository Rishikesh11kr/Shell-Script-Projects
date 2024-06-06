#!/bin/bash



CPU_THRESHOLD=80      

MEMORY_THRESHOLD=80       
DISK_THRESHOLD=80         
CHECK_INTERVAL=60        

LOG_FILE="/var/log/system_monitor.log"
ALERT_EMAIL="1911rishikesh@gmail.com"

while true; 
do

    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    echo "$(date): CPU Usage: $CPU_USAGE%" | tee -a $LOG_FILE
    if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
        echo "$(date): ALERT: High CPU usage detected!!" | tee -a $LOG_FILE
        echo "High CPU usage: $CPU_USAGE%" | mail -s "High CPU Usage Alert" $ALERT_EMAIL
    fi

    
    MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    echo "$(date): Memory Usage: $MEMORY_USAGE%" | tee -a $LOG_FILE
    if (( $(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" | bc -l) )); then
        echo "$(date): ALERT: High memory usage detected" | tee -a $LOG_FILE
        echo "High memory usage: $MEMORY_USAGE%" | mail -s "High Memory Usage Alert" $ALERT_EMAIL
    fi

    DISK_USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//g')
    echo "$(date): Disk Usage: $DISK_USAGE%" | tee -a $LOG_FILE
    if (( DISK_USAGE > DISK_THRESHOLD )); then
        echo "$(date): ALERT: high disk usage detected!" | tee -a $LOG_FILE
        echo "High disk usage: $DISK_USAGE%" | mail -s "High Disk Usage Alert" $ALERT_EMAIL
    fi

    NETWORK_ACTIVITY=$(ifstat -i eth0 1 1 | awk 'NR==4 {print $1, $2}')
    echo "$(date): Network Activity: $NETWORK_ACTIVITY KB/s" | tee -a $LOG_FILE

    sleep $CHECK_INTERVAL
done
