# Utiliser l'image de base Kali Linux Rolling
FROM kalilinux/kali-rolling

# Mettre à jour les paquets et installer les outils nécessaires
RUN apt-get update && apt-get install -y \
    hydra \
    netcat-openbsd \
    wordlists \
    && apt-get clean
    
# Créer le dossier pour le fichier de mots de passe
RUN mkdir /root/passwords

# Copie et rend exécutable attack.sh
COPY attack.sh /root/attack.sh
RUN chmod +x /root/attack.sh

# Commande à exécuter lors du lancement du conteneur
# Exécute le script attack.sh au démarrage du conteneur
CMD ["/bin/bash", "-c", "/root/attack.sh"]



