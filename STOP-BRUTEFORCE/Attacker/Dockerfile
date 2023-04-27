FROM kalilinux/kali-rolling

RUN apt-get update && apt-get install -y hydra
RUN apt-get update && apt-get install -y hydra netcat


# Copie et exécute generer_password_list.sh
COPY generer_password_list.sh /root/generer_password_list.sh
RUN chmod +x /root/generer_password_list.sh
RUN /root/generer_password_list.sh

# Copie et rend exécutable attack.sh
COPY attack.sh /root/attack.sh
RUN chmod +x /root/attack.sh

CMD ["/root/attack.sh"]
