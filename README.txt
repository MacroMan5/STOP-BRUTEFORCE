# Compétition CTF - Arrêtez l'attaque brute force SSH

## Contexte

Une entreprise vous a contacté pour analyser les logs d'un serveur syslog et trouver les traces d'une attaque brute force. Vous avez réussi à trouver le premier flag dans les logs auth.log générés par votre script. 

La compagnie, satisfaite de votre travail, fait de nouveau appel à vous. 
Leur machine est actuellement la cible d'une attaque brute force sur le port 22 (SSH). 
>Ils vous demandent de vous connecter à la machine et de stopper l'attaque.

Vous avez 10 minutes pour stopper l'attaque brute force en cours. Si vous y parvenez, vous obtiendrez le flag tant convoité.

## Instructions


1. Connectez-vous à la machine victime en utilisant les identifiants du user `CTFuser` (mot de passe : `user`) et le port 2222 : `ssh CTFuser@localhost -p 2222`.
2. Trouvez un moyen d'arrêter l'attaque brute force en cours. Vous pouvez chercher des informations et des indices dans les fichiers de logs et dans la configuration du serveur.
3. Si vous parvenez à stopper l'attaque avant la fin des 10 minutes, un message apparaîtra avec le flag. Sinon, la connexion SSH sera fermée et vous aurez échoué.

## Objectif

L'objectif de ce challenge est de stopper l'attaque brute force en cours pour obtenir le flag.

## Conseils

- Examinez les logs pour déterminer l'origine de l'attaque.
- Familiarisez-vous avec les commandes et les outils de gestion des services sur Linux.
- Soyez créatif et pensez aux différentes manières de bloquer une attaque brute force.

Bonne chance !
 
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

Exécutez `docker-compose up` pour lancer les conteneurs Docker de la machine attaquante et de la machine victime.

 Lorsque vous lancez l'environnement avec docker-compose up, voici ce qui se passe :

1. Docker Compose lit le fichier docker-compose.yml et commence à construire les images des services définis dans le fichier (ici, ssh_victim et attacker).
2. Le service ssh_victim est construit à partir du répertoire ./ssh_victim qui contient le Dockerfile et les scripts associés. 
3. Le conteneur est configuré avec OpenSSH, les utilisateurs admin et CTFuser, et les scripts nécessaires pour vérifier et arrêter l'attaque.
4. Le service attacker est construit à partir du répertoire ./attacker qui contient le Dockerfile et les scripts associés.
 Le conteneur est configuré avec les outils nécessaires pour mener l'attaque par force brute, comme Hydra, et un script pour générer la liste des mots de passe à tester.

5.Docker Compose crée un réseau ctf_network avec le subnet 192.168.10.0/24 et attribue les adresses IP statiques définies dans le fichier docker-compose.yml aux conteneurs.
Les conteneurs sont lancés et connectés au réseau ctf_network. Le conteneur ssh_victim est accessible via le port 2222 sur l'hôte Docker, mappé sur le port 22 du conteneur.

6.Le joueur se connecte au conteneur ssh_victim en utilisant les identifiants de l'utilisateur CTFuser et a pour mission d'arrêter l'attaque par force brute en cours.
Pendant ce temps, l'attaquant (le conteneur attacker) commence l'attaque par force brute sur le service SSH du conteneur ssh_victim en utilisant la liste de mots de passe générée par le script.
Le joueur doit arrêter l'attaque par force brute dans les 10 minutes imparties.

7. S'il réussit, le flag s'affiche dans la console de tous les utilisateurs connectés à la machine victime (y compris le joueur) grâce au script verifyifattack.sh. 
8. S'il échoue, le script disconnect_user.sh ferme la connexion SSH du joueur et affiche un message d'échec.


En résumé, en lançant l'environnement avec docker-compose up, vous créez et déployez deux conteneurs Docker interconnectés : 
l'un pour la machine victime et l'autre pour l'attaquant. Le joueur doit se connecter à la machine victime et arrêter l'attaque en cours pour réussir le défi CTF.


COMMANDE PRATIQUE POUR LE JEU 
ssh CTFuser@localhost -p 2222
tail -f /var/log/auth.log 
cd /var/log/ 
cat auth.log 
cat auth.log | grep "Failed password"

Bloquer l'attaque brute force en cours en utilisant la commande suivante :
sudo ufw deny from 192.168.10.169
sudo iptables -A INPUT -s 192.168.10.169 -j DROP

ls -a  
cat VoiciLeFlag 