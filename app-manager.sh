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

    cat <<"EOF"
[01;94m  __ _ _ __  _ __           [01;92m _ __ ___   __ _ _ __   __ _  __ _  ___ _ __ 
[01;94m / _` | '_ \| '_ \  [01;91m _____  [01;92m| '_ ` _ \ / _` | '_ \ / _` |/ _` |/ _ \ '__|
[01;94m| (_| | |_) | |_) | [01;91m|_____| [01;92m| | | | | | (_| | | | | (_| | (_| |  __/ |   
[01;94m \__,_| ___/| .__/  [01;91m        [01;92m|_| |_| |_|\__,_|_| |_|\__,_|\__, |\___|_|   
[01;94m      |_|   |_|             [01;92m                             |___/           
[0m
EOF
    echo -e "\t\t\t\e[93mMade with \e[91m❤️\e[93m by \e[1;92mASHWINI SAHU\e[0m\n"

}

# Print the banner and check the terminal size.
function print_banner() {

    TERM_COLUMN=$(stty size | cut -d" " -f2)

    if [[ "$TERM_COLUMN" -ge "70" ]]; then
        banner
    else
        echo -e "\n\e[1;93mWarning : \e[0mTerminal size too small.\n"
    fi
}

################  Main logic starts  ################

# Checking if ADB command exist or not.
if ! [ "$(command -v adb)" ]; then
    echo "command \"adb\" is not installed on system"
    exit 1
else
    ADB=$(which adb)
fi

# Check device valid or not.
function device_valid_or_not() {
    if ! $ADB -s "$SERIAL_NO" get-state 1>/dev/null 2>&1; then
        echo -e "\n\e[1;91mError : \e[0mSerial : \e[93m$SERIAL_NO\e[0m not connected.\e[0m\n"
        echo -e "\e[32mUse\e[0m : -s <serial no> specify the serial no."
        exit 1
    fi
}

# Check if serial no. is passed or not.
for ((i = 1; i <= $#; i++)); do

    j=$((i + 1))

    if [[ "${!i}" == "-s" ]] || [[ "${!i}" == "--serial" ]]; then
        if [[ "${!j}" == "" ]]; then
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
        echo -e "\n\e[1;91mError : \e[21;93mMultiple or No Device Connected\e[0m\n"
        echo -e "\e[32mUse\e[0m : -s <serial no> or --help\e[0m"
        exit 1
    else
        SERIAL_NO=$($ADB -s "$SERIAL_NO" get-serialno)
        MODEL=$($ADB -s "$SERIAL_NO" shell getprop ro.product.model)
        DEVICE_NAME=$($ADB -s "$SERIAL_NO" shell getprop ro.product.name)
        DEVICE_MANUFATURER=$($ADB -s "$SERIAL_NO" shell getprop ro.product.manufacturer)

    fi

}

###### OPTION 1 "GET SYSTEM DETAIL" ######

function option_1() {

    ### Fetching all the data ###

    MODEL=$($ADB -s "$SERIAL_NO" shell getprop ro.product.model)
    DEVICE_NAME=$($ADB -s "$SERIAL_NO" shell getprop ro.product.name)
    DEVICE_MANUFATURER=$($ADB -s "$SERIAL_NO" shell getprop ro.product.manufacturer)
    ANDROID=$($ADB -s "$SERIAL_NO" shell getprop ro.build.version.release)
    SECURITY_PATCH=$($ADB -s "$SERIAL_NO" shell getprop ro.build.version.security_patch)
    GSM_SIM=$($ADB -s "$SERIAL_NO" shell getprop gsm.sim.operator.alpha)
    ENCRYPTION_STATE=$($ADB -s "$SERIAL_NO" shell getprop ro.crypto.state)
    BUILD_DATE=$($ADB -s "$SERIAL_NO" shell getprop ro.build.date)
    SDK_VERSION=$($ADB -s "$SERIAL_NO" shell getprop ro.build.version.sdk)
    WIFI_INTERFACE=$($ADB -s "$SERIAL_NO" shell getprop wifi.interface)

    ### Printing all the data ###

    echo -e "\n\e[1;93mThe Details of the device \e[1;92m$MODEL \e[93mare :- "
    echo -e "\n\e[21;92mModel \e[1;94m= \e[1;93m$MODEL"
    echo -e "\e[21;92mDevice \e[1;94m= \e[1;93m$DEVICE_NAME"
    echo -e "\e[21;92mManufacturer \e[1;94m= \e[1;93m$DEVICE_MANUFATURER"
    echo -e "\e[21;92mBuild Date \e[1;94m= \e[1;93m$BUILD_DATE"
    echo -e "\e[21;92mAndroid \e[1;94m= \e[1;93m$ANDROID"
    echo -e "\e[21;92mSDK Version \e[1;94m= \e[1;93m$SDK_VERSION"
    echo -e "\e[21;92mSim Card \e[1;94m= \e[1;93m$GSM_SIM"
    echo -e "\e[21;92mSecurity Patch  \e[1;94m= \e[1;93m$SECURITY_PATCH"
    echo -e "\e[21;92mEncryption State \e[1;94m= \e[1;93m$ENCRYPTION_STATE"
    echo -e "\e[21;92mWiFi Interface \e[1;94m= \e[1;93m$WIFI_INTERFACE\e[0m\n"

    # Exiting the Script
    exit 0

}

###### OPTION 2 "UNINSTALL A APPLICATION" ######

function option_2() {

    read -rp $'\e[1;93m\nEnter the package name you want to uninstall : \e[21;92m' uninstall_pkg
    if [ "$uninstall_pkg" == "" ]; then
        echo -e "\n\e[1;91mError : \e[21;93mNo package name was provided\e[0m\n"
    else
        if $ADB -s "$SERIAL_NO" uninstall "$uninstall_pkg" &>/dev/null; then
            echo -e "\n\e[1;92mSuccessfully uninstalled the 'apk' into device $MODEL\n"
        else
            echo -e "\n\e[1;91mFailed uninstalling the 'apk' into device $MODEL\n"
        fi
    fi

}

# Option list
function option_list() {

    print_banner
    echo -e "\e[1;93m 1.  \e[1;92mGet Device detail\n"

    echo -e "\e[1;93m 2.  \e[1;92mUninstall Application"
    echo -e "\e[1;93m 3.  \e[1;92mInstall Application 'apk'"
    echo -e "\e[1;93m 4.  \e[1;92mDisable Application"
    echo -e "\e[1;93m 5.  \e[1;92mEnable Application\n"

    echo -e "\e[1;93m 6.  \e[1;92mList All Application"
    echo -e "\e[1;93m 7.  \e[1;92mList Disabled Application"

    echo -e "$revised"
    read -rp $'  \e[1;4;91mEnter\e[1;24;91m \e[1;4;91m$\e[1;24;91m\e[24;1;97m : \e[0m' options
    while true; do

        case $options in

        "1")
            option_1
            break
            ;;
        "2")
            option_2
            break
            ;;
        "3")
            echo -e "ss"
            break
            ;;
        "4")
            echo -e "w"
            break
            ;;
        *)
            clear
            revised="\n\e[1;91mEnter the right option :-)\e[0m\n"
            option_list
            break
            ;;

        esac

    done

}

function main() {
    get_device_info
    option_list

}

main
