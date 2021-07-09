#!/usr/bin/env bash

# Usage and Help Documentaion.
function usage() {
    echo "Help"
}

# Checking if help agrument is passed or not.
for i in "$@"; do
    if [[ $i == "-h" ]] || [[ $i == "--help" ]]; then
        usage
        exit 0
    fi
done

# Ascii art banner.
function banner() {
cat << "EOF"
  __ _ _ __  _ __        _ __ ___   __ _ _ __   __ _  __ _  ___ _ __ 
 / _` | '_ \| '_ \ _____| '_ ` _ \ / _` | '_ \ / _` |/ _` |/ _ \ '__|
| (_| | |_) | |_) |_____| | | | | | (_| | | | | (_| | (_| |  __/ |   
 \__,_| ___/| .__/      |_| |_| |_|\__,_|_| |_|\__,_|\__, |\___|_|   
      |_|   |_|                                      |___/           

EOF
}

# Print the banner and check the terminal size.
function print_banner() {

    TERM_COLUMN=$(stty size | cut -d" " -f2)
    echo "$TERM_COLUMN" #temp remove

    if [[ "$TERM_COLUMN" -ge "70" ]]; then
        banner
    else
        echo -e "Terminal size too small."
    fi
}

######## Main logic starts ########

# Checking if ADB command exist or not.
if ! [ "$(command -v adb)" ]; then
    echo "command \"adb\" is not installed on system"
    exit 1
else
    ADB=$(which adb)
fi

# Check device valid or not.
function device_valid_or_not () {
    if ! $ADB -s "$SERIAL_NO" get-state 1>/dev/null 2>&1; then
        echo -e "No Device with : $SERIAL_NO, connected."
        exit 1
    fi
}

# Check if serial no. is passed or not.
for (( i=1; i<=$#; i++)); do
    j=$((i+1))
    if [[ "${!i}" == "-s" ]] || [[ "${!i}" == "--serial" ]]; then
        if [[ "${!j}" == "" ]]
            then
                echo -e "Error : No Serial no. passed."
                exit 1
            else
                SERIAL_NO="${!j}"
                device_valid_or_not $SERIAL_NO
        fi
    fi

done

# Get device Info.
function get_device_info() {

    # Check if device is connected or not.
    if ! $ADB -s "$SERIAL_NO" get-state 1>/dev/null 2>&1; then
        echo $SERIAL_NO SERIAL NO
        echo -e "\nMultiple or No Device Connected\n"
        exit 1
        else
            SERIAL_NO=$($ADB -s "$SERIAL_NO" get-serialno)
            echo "$SERIAL_NO" SERIAL NO

            DEVICE_MODEL=$($ADB -s "$SERIAL_NO" shell getprop ro.product.model)
            DEVICE_NAME=$($ADB -s "$SERIAL_NO" shell getprop ro.product.name)
            DEVICE_MANUFATURER=$($ADB -s "$SERIAL_NO" shell getprop ro.product.manufacturer)
            
            echo "$DEVICE_MODEL $DEVICE_NAME $DEVICE_MANUFATURER"
            echo "Device Connected" # del this line later
    fi

}

get_device_info