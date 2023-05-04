
# Créer une image à partir de l'image ubuntu:latest

FROM ubuntu:latest

# Mettre à jour les paquets et installer les paquets nécessaires
RUN apt-get update && apt-get install -y rsyslog openssh-server iptables ufw fail2ban tcpdump nmap tshark htop net-tools sudo

# Configuration de rsyslog pour enregistrer les logs SSH dans /var/log/auth.log
RUN echo 'auth,authpriv.*                 /var/log/auth.log' >> /etc/rsyslog.d/50-default.conf

# Désactiver imklog dans rsyslog.conf
RUN sed -i 's/^module(load="imklog")/#module(load="imklog")/' /etc/rsyslog.conf


# Ajouter les utilisateurs admin et CTFuser
RUN useradd -rm -d /home/admin -s /bin/bash -g root -G sudo -u 1000 admin && echo 'admin:admin1234' | chpasswd
RUN useradd -rm -d /home/CTFuser -s /bin/bash -g root -u 1001 CTFuser && echo 'CTFuser:user' | chpasswd

# Ajouter CTFuser au groupe adm pour accéder aux fichiers de logs
RUN usermod -a -G adm CTFuser

# Configuration de SSH
RUN mkdir /var/run/sshd
RUN echo 'root:toor' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Activer l'authentification par mot de passe
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
# Modifier MaxAuthTries pour permettre un nombre illimité de tentatives d'authentification
RUN sed -i 's/#MaxAuthTries .*/MaxAuthTries 1000/' /etc/ssh/sshd_config
# Modifier le niveau de log SSH par défaut
RUN sed -i 's/#LogLevel INFO/LogLevel VERBOSE/' /etc/ssh/sshd_config


# Ajouter les règles sudo pour CTFuser
RUN echo 'CTFuser ALL=(ALL) NOPASSWD: /usr/sbin/iptables' >> /etc/sudoers
RUN echo 'CTFuser ALL=(ALL) NOPASSWD: /usr/sbin/ufw' >> /etc/sudoers
RUN echo 'CTFuser ALL=(ALL) NOPASSWD: /usr/sbin/fail2ban-client' >> /etc/sudoers
RUN echo 'CTFuser ALL=(ALL) NOPASSWD: /usr/sbin/tcpdump' >> /etc/sudoers
RUN echo 'CTFuser ALL=(ALL) NOPASSWD: /usr/bin/nmap' >> /etc/sudoers
RUN echo 'CTFuser ALL=(ALL) NOPASSWD: /usr/bin/tshark' >> /etc/sudoers
# Autorise le CTFuser à modifier le fichier sshd_config avec sudo
RUN echo "CTFuser ALL=(ALL) NOPASSWD: /usr/bin/editor /etc/ssh/sshd_config" >> /etc/sudoers

# Créer un répertoire pour les fichiers cachés
RUN mkdir /opt/hidden_files && chmod 700 /opt/hidden_files

# Ajouter les scripts disconnect_user.sh dans le répertoire /opt/hidden_files et les rendre exécutables
COPY disconnect_user.sh /opt/hidden_files/disconnect_user.sh 
RUN chmod +x /opt/hidden_files/disconnect_user.sh 
COPY check_blocked_ip.sh /opt/hidden_files/check_blocked_ip.sh 
RUN chmod +x /opt/hidden_files/check_blocked_ip.sh 

# Changer l'appartenance et les permissions des fichiers pour les rendre accessibles uniquement par l'utilisateur root
RUN chown root:root /opt/hidden_files/disconnect_user.sh
RUN chmod 700 /opt/hidden_files/disconnect_user.sh 
RUN chown root:root /opt/hidden_files/check_blocked_ip.sh
RUN chmod 700 /opt/hidden_files/check_blocked_ip.sh



#Démarrage de rsyslog pour les logs, Exécuter les scripts et démarrer le serveur SSH au démarrage du conteneur
CMD ["/bin/bash", "-c", "/usr/sbin/rsyslogd && /opt/hidden_files/check_blocked_ip.sh & /opt/hidden_files/disconnect_user.sh & /usr/sbin/sshd -D"]

EXPOSE 22
