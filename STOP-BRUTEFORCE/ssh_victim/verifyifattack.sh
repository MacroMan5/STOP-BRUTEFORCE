#!/bin/bash
#verifyifattack.sh
FLAG="01253(U stopped it)" # Remplacez par le flag réel
TARGET_IP="127.0.0.1" # Remplacez par l'adresse IP du conteneur de l'attaquant
SSH_PORT=22
CHECK_INTERVAL=30 # Vérifie toutes les 30 secondes

previous_failed_attempts=-1
current_failed_attempts=0

while true; do
  sleep $CHECK_INTERVAL
  current_failed_attempts=$(grep "Failed password for" /var/log/auth.log | grep "from $TARGET_IP" | wc -l)

  if [[ $current_failed_attempts -eq $previous_failed_attempts ]]; then
    FLAG_MESSAGE="L'attaque a été stoppée! Voici le flag: $FLAG"
    echo "$FLAG_MESSAGE"
    wall "$FLAG_MESSAGE"
    break
  fi

  previous_failed_attempts=$current_failed_attempts
done