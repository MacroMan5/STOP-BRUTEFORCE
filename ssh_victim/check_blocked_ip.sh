#!/bin/bash

# L'adresse IP de l'attaquant
ATTACKER_IP='192.168.10.169'

# Le chemin vers le fichier de flag caché
FLAG_FILE='/home/CTFuser/.hidden_flag/flag.txt'

# Le contenu du flag
FLAG='01253{YouStoppedTheScriptKiddies}'

# Fonction qui vérifie si l'adresse IP de l'attaquant est bloquée
function is_attacker_blocked {
    # Vérifie si l'adresse IP de l'attaquant est bloquée dans iptables
    if sudo iptables -L -n | grep -q "$ATTACKER_IP"; then
        wall "L'adresse IP de l'attaquant est bloquée dans iptables."
        return 0
    fi

    # Vérifie si l'adresse IP de l'attaquant est bloquée dans UFW
    if sudo ufw status numbered | grep -q "$ATTACKER_IP"; then
        wall "L'adresse IP de l'attaquant est bloquée dans UFW."
        return 0
    fi
    # L'adresse IP de l'attaquant n'est pas bloquée
    return 1
}


# Crée le dossier caché pour le fichier de flag s'il n'existe pas encore
sudo mkdir -p /home/CTFuser/.hidden_flag

# Boucle tant que l'adresse IP de l'attaquant n'est pas bloquée
while ! is_attacker_blocked; do
    sleep 15  # Attendre 15 secondes avant la prochaine vérification
done

# Écrire le flag dans le fichier caché
echo "$FLAG" | sudo tee "$FLAG_FILE" > /dev/null
