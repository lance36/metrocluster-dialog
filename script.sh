#!/bin/bash
HEIGHT=15
WIDTH=70
CHOICE_HEIGHT=4
BACKTITLE="NetApp Metrocluster Switchover Control"
TITLE="Switchover Control"
MENU="Choose one of the following options:"
OPTIONS=(1 "Switchover PIANIFICATO (Manutenzione)"
         2 "Switchover FORZATO (Disastro)")
CHOICE=$(dialog --no-lines\
                --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
case $CHOICE in
        1) #PIANIFICATO
                TITLE="Switchover PIANIFICATO"
                OPTIONS=(1 "Spegnimento sito di Campo Boario 56"
                        2 "Spegnimento Sito Scalo Prenestino 15")
                CHOICE2=$(dialog --no-lines\
                --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
                case $CHOICE2 in
                        1)
				dialog --no-lines --title "[ ! ] ATTENZIONE[ ! ]" --yesno "\nSicuro?" 10 50
				if [[ $? == 1 ]]; then clear; echo "Operazione Annullata";exit $rc; fi
				clear
				./spegni_cb_pianificato.sh
				exit 0
                        ;;
                        2)
				clear
				./spegni_sp_pianificato.sh
				exit 0
                        ;;
		esac
        ;;
        2)
            #FORZATO
		dialog --no-lines --title "[ ! ] ATTENZIONE[ ! ]" --yesno "$(<warning_message.txt)" 13 125
		if [[ $? == 1 ]]; then clear; echo "Operazione Annullata";exit $rc; fi
                TITLE="[ ! ] Switchover FORZATO [ ! ]"
                OPTIONS=(1 "Spegnimento sito di Campo Boario 56"
                        2 "Spegnimento Sito Scalo Prenestino 15")
                CHOICE2=$(dialog --no-lines\
                --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
                case $CHOICE2 in
                        1)
				clear
				./spegni_cb_forzato.sh
				exit 0
                        ;;
                        2)
				clear
				./spegni_sp_forzato.sh
				exit 0
                        ;;
		esac
            ;;
esac
