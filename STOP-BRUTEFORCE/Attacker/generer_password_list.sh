#!/bin/bash
#Création des 1000 mots passe qui seront tester par l'attaque 
NUM_PASSWORDS=999
PASSWORD_LENGTH=8

for i in $(seq 1 $NUM_PASSWORDS); do
  head /dev/urandom | tr -dc A-Za-z0-9 | head -c$PASSWORD_LENGTH; echo ''
done > passwords.txt
