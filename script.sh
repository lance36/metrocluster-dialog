#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
HEIGHT=15
WIDTH=70
CHOICE_HEIGHT=4
BACKTITLE="NetApp Metrocluster Switchover Control - Lottomatica SpA"
TITLE="Switchover Control"
MENU="Selezionare l'operazione che si desidera effettuare:"
WARNINGTITLE="\Zb\Z1  User Notice\Zn"
MSGCONFIRM="\nConfermare Operazione?"
MCCSTATE="$(netapp-metrocluster-tiebreaker-software-cli monitor  show -status | grep 'Monitor State:')"
if [[ $MCCSTATE == "    Monitor State: Normal" ]]
then MCCSTATE="\Zb\Z2 $MCCSTATE \Zn"
else MCCSTATE="\Zb\Z1 $MCCSTATE \Zn"
fi

dialog --no-lines --colors --title "\Zn\Z1PROCEDURA DI SWITCHOVER\Zn" --yesno "$(</opt/netapp/metrocluster-dialog/warning_message.txt)" 9 100
if [[ $? != 0 ]]; then clear; echo "Operazione Annullata";exit $rc; fi

         #PIANIFICATO
                TITLE="Switchover PIANIFICATO"
                OPTIONS=(1 "Spegnimento sito Campo Boario 56"
                        2 "Spegnimento sito Scalo Prenestino 15"
                                                q "Quit ")
                CHOICE2=$(dialog --no-cancel --colors --no-lines\
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MCCSTATE \n $MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                                --and-widget  --colors --keep-window --ascii-lines --title "$WARNINGTITLE" --yesno "$MSGCONFIRM" 10 50\
                2>&1 >/dev/tty)
                                if [[ $? != 0 ]]; then clear; echo "Operazione Annullata";exit $rc; fi
                case $CHOICE2 in
             1)
                                clear
                                /opt/netapp/metrocluster-dialog/spegni_cb_pianificato.sh
                                exit 0
             ;;
             2)
                                clear
                                /opt/netapp/metrocluster-dialog/spegni_sp_pianificato.sh
                                exit 0
             ;;
                         q)
                                clear
                                exit 0
                        ;;
                esac
clear
elif [ "$1" = "spegniCB" ]
then
  echo "Spegnimento Sito Campo Boario, 56"
elif [ "$1" = "spegniSP" ]
then
  echo "Spegnimento Sito Scalo Prenestino, 15"
else
  echo "Invalid Agrument supplied '$@'"
fi

