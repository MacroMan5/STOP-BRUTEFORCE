#!/bin/bash
USER="CTFuser"
TIMEOUT_SECONDS=$((10 * 60))
FAIL_MESSAGE="L'attaquant s'est connecté, vous avez échoué."

sleep $TIMEOUT_SECONDS

# Vérifie si le user est connecté via SSH
if pgrep -u $USER sshd > /dev/null; then
  # Ferme la connexion SSH
  pkill -u $USER sshd
  
  # Affiche le message d'échec
  echo "$FAIL_MESSAGE"
fi
