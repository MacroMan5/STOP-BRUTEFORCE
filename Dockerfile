
# Créer une image à partir de l'image ubuntu:latest

FROM ubuntu:latest

# Mettre à jour les paquets et installer les paquets nécessaires
RUN apt-get update && apt-get install -y openssh-server iptables ufw fail2ban tcpdump nmap tshark htop net-tools sudo

# Ajouter les utilisateurs admin et CTFuser
RUN useradd -rm -d /home/admin -s /bin/bash -g root -G sudo -u 1000 admin && echo 'admin:admin' | chpasswd
RUN useradd -rm -d /home/CTFuser -s /bin/bash -g root -u 1001 CTFuser && echo 'CTFuser:user' | chpasswd

# Configuration de SSH
RUN mkdir /var/run/sshd
RUN echo 'root:toor' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config



# Ajouter les règles sudo pour CTFuser
RUN echo 'CTFuser ALL=(ALL) NOPASSWD: /usr/sbin/iptables' >> /etc/sudoers
RUN echo 'CTFuser ALL=(ALL) NOPASSWD: /usr/sbin/ufw' >> /etc/sudoers
RUN echo 'CTFuser ALL=(ALL) NOPASSWD: /usr/sbin/fail2ban-client' >> /etc/sudoers
RUN echo 'CTFuser ALL=(ALL) NOPASSWD: /usr/sbin/tcpdump' >> /etc/sudoers
RUN echo 'CTFuser ALL=(ALL) NOPASSWD: /usr/bin/nmap' >> /etc/sudoers
RUN echo 'CTFuser ALL=(ALL) NOPASSWD: /usr/bin/tshark' >> /etc/sudoers
# Autorise le CTFuser à modifier le fichier sshd_config avec sudo
RUN echo "CTFuser ALL=(ALL) NOPASSWD: /usr/bin/editor /etc/ssh/sshd_config" >> /etc/sudoers


# Ajouter les scripts verifyifattack.sh et disconnect_user.sh dans le conteneur et les rendre exécutables
COPY firewallInit.sh /root/firewallInit.sh 
COPY verifyifattack.sh /home/CTFuser/verifyifattack.sh
COPY disconnect_user.sh /home/CTFuser/disconnect_user.sh
RUN chmod +x /home/CTFuser/verifyifattack.sh
RUN chmod +x /home/CTFuser/disconnect_user.sh
RUN chmod +x /root/firewallInit.sh

# Exécute les script au démarrage du conteneur
CMD ["/bin/bash", "-c", "/root/firewallInit.sh && /usr/sbin/rsyslogd && /opt/hidden_files/check_blocked_ip.sh & /opt/hidden_files/disconnect_user.sh & /usr/sbin/sshd -D"]
EXPOSE 22

