#!/bin/bash

#####################################
#		Maksymilian odziemczyk		#
#####################################

#
# Program wysyłający na e-mail parametry komputera
#

#Dane mailowe (POLA DO EDYCJI):
tytul="Parametry komputera"
adresat="maksymilian.odziemczyk@gmail.com"

#Dane komputera:
adresIP=`hostname -I`
pamiecRAM=`free -m | grep Mem | awk '{print $2}'` #POPRAWIONE
infoProc=`cat /proc/cpuinfo | grep processor | wc -l` #POPRAWIONE

wyslij_mail()
{	
	wiadomosc="/tmp/parametry.txt"
	printf "Adres IP: $adresIP\n\n" > $wiadomosc
	printf "Ilosc RAM [total MB]: $pamiecRAM\n\n" >> $wiadomosc
	printf "Ilosc procesorow: $infoProc\n" >> $wiadomosc
	mail -s "$tytul" "$adresat" < $wiadomosc
}
update()
{
	update="/tmp/parametry_new.txt"
	printf "Adres IP: $adresIP\n\n" > $update
	printf "Ilosc RAM [total MB]: $pamiecRAM\n\n" >> $update
	printf "Ilosc procesorow: $infoProc\n" >> $update
}
main()
{
	if [[ ! -e /tmp/parametry.txt ]] ; then
		printf "Dane o Twoim komputerze wygenerowano pierwszy raz.\n"
		printf "Informacje przeslano na podany adres email.\n"
		wyslij_mail
	else
		update
		cmp -s /tmp/parametry.txt /tmp/parametry_new.txt
		status=$?
		if [[ $status = 0 ]] ; then
			printf "Parametry nie uległy zmianie.\n"
			printf "Nie podjeto dzialania.\n"
			rm /tmp/parametry.txt
			mv /tmp/parametry_new.txt /tmp/parametry.txt
		else
			printf "Dane z poprzedniej weryfikacji ulegly zmianie.\n"
			printf "Na Twojego maila wyslano aktualizacje.\n"
			rm /tmp/parametry_new.txt /tmp/parametry.txt 
			wyslij_mail
		fi
	fi
}
main