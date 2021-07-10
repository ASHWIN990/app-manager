#!/usr/bin/env bash

#Tool = app-manager
#Version = 0.1
#Author = ASHWINI SAHU
#Date = 10/07/2021
#Written in Bash

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

# Ascii art banner main.
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
function print_banner_main() {

    TERM_COLUMN=$(stty size | cut -d" " -f2)

    if [[ "$TERM_COLUMN" -ge "70" ]]; then
        banner
    else
        echo -e "\n\e[1;93mWarning : \e[0mTerminal size too small.\n"
    fi
}

# Ascii art banner list application.
function list_app_banner() {

    cat <<"EOF"
[01;94m _ _     _                                
[01;94m| (_)   | |                               
[01;94m| |_ ___| |_  [01;91m ______ [01;92m   __ _ _ __  _ __  
[01;94m| | / __| __| [01;91m|______|[01;92m  / _` | '_ \| '_ \ 
[01;94m| | \__ \ |_           [01;92m| (_| | |_) | |_) |
[01;94m|_|_|___/\__|          [01;92m \__,_| .__/| .__/ 
                             [01;92m| |   | |    
                             [01;92m|_|   |_|    
[0m
EOF
    echo -e "\t\e[93mMade with \e[91m❤️\e[93m by \e[1;92mASHWINI SAHU\e[0m\n"

}

# Print the banner and check the terminal size.
function print_banner_list_app() {

    TERM_COLUMN=$(stty size | cut -d" " -f2)

    if [[ "$TERM_COLUMN" -ge "43" ]]; then
        list_app_banner
    else
        echo -e "\n\e[1;93mWarning : \e[0mTerminal size too small.\n"
    fi
}

################  Main logic starts  ################

# Checking if ADB command exist or not.
if ! [ "$(command -v adb)" ]; then
    echo -e "\n\e[1;91mError : \e[0mCommand \e[93madb\e[0m is not installed on system.\e[0m"
    exit 1
else
    ADB=$(which adb)
fi

# Checking if less command exist or not.
if ! [ "$(command -v less)" ]; then
    echo -e "\n\e[1;91mError : \e[0mCommand \e[93mless\e[0m is not installed on system.\e[0m"
    exit 1
else
    LESS=$(which less)
fi

# Check device valid or not.
function device_valid_or_not() {
    if ! $ADB -s "$SERIAL_NO" get-state 1>/dev/null 2>&1; then
        echo -e "\n\e[1;91mError : \e[0mSerial : \e[93m'$SERIAL_NO'\e[0m not connected.\e[0m\n"
        echo -e "\e[32mUse\e[0m : -s <serial no> specify the serial no.\e[0m"
        exit 1
    fi
}

# Check if serial no. is passed or not.
for ((i = 1; i <= $#; i++)); do

    j=$((i + 1))

    if [[ "${!i}" == "-s" ]] || [[ "${!i}" == "--serial" ]]; then
        if [[ "${!j}" == "" ]]; then
            echo -e "\n\e[1;91mError : \e[0mNo Serial no. passed.\e[0m\n"
            echo -e "\e[32mUse\e[0m : -s <serial no> or --help\e[0m"
            exit 1
        else
            SERIAL_NO="${!j}"
            device_valid_or_not "$SERIAL_NO"
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

    echo -e "\n\e[93mThe Details for device \e[1;92m'$MODEL' \e[21;93mare :- \n"
    echo -e "\e[21;95mModel \e[1;94m= \e[1;93m$MODEL"
    echo -e "\e[21;95mDevice \e[1;94m= \e[1;93m$DEVICE_NAME"
    echo -e "\e[21;95mManufacturer \e[1;94m= \e[1;93m$DEVICE_MANUFATURER"
    echo -e "\e[21;95mBuild Date \e[1;94m= \e[1;93m$BUILD_DATE"
    echo -e "\e[21;95mAndroid \e[1;94m= \e[1;93m$ANDROID"
    echo -e "\e[21;95mSDK Version \e[1;94m= \e[1;93m$SDK_VERSION"
    echo -e "\e[21;95mSim Card \e[1;94m= \e[1;93m$GSM_SIM"
    echo -e "\e[21;95mSecurity Patch  \e[1;94m= \e[1;93m$SECURITY_PATCH"
    echo -e "\e[21;95mEncryption State \e[1;94m= \e[1;93m$ENCRYPTION_STATE"
    echo -e "\e[21;95mWiFi Interface \e[1;94m= \e[1;93m$WIFI_INTERFACE\e[0m\n"

    # Exiting the Script
    exit 0

}

###### OPTION 2 "UNINSTALL A APPLICATION" ######

function option_2() {

    read -rp $'\e[1;93m\nEnter the package name to uninstall : \e[21;92m' uninstall_pkg

    if [ "$uninstall_pkg" == "" ]; then
        echo -e "\n\e[1;91mError : \e[0mNo package name was provided\e[0m"
        exit 1
    else
        if $ADB -s "$SERIAL_NO" uninstall "$uninstall_pkg" &>/dev/null; then
            echo -e "\n\e[1;92mSuccess : \e[0mUninstalled the \e[33m'$uninstall_pkg' \e[0mfrom \e[33m'$MODEL'\e[0m"
            exit 0
        else
            echo -e "\n\e[1;91mError : \e[0mFailed uninstalling \e[33m'$uninstall_pkg' \e[0mfrom \e[33m'$MODEL'\e[0m"
            exit 1
        fi
    fi

}

###### OPTION 3 "INSTALL A APPLICATION" ######

function option_3() {

    function apk_install() {

        echo -e "\n\e[1;93m*Note* : \e[0mCheck the device."
        if $ADB -s "$SERIAL_NO" install -r "$apk_file_paths" &>/dev/null; then
            echo -e "\n\e[1;92mSuccess : \e[0mInstalled the \e[33m'$apk_file_paths' \e[0mto \e[33m'$MODEL'\e[0m"
            exit 0
        else
            echo -e "\n\e[1;91mError : \e[0mFailed installing \e[33m'$apk_file_paths' \e[0mto \e[33m'$MODEL'\e[0m"
            exit 1
        fi

    }

    read -rp $'\e[1;93m\nEnter the path of the apk file : \e[21;92m' apk_file_paths

    if [ "$apk_file_paths" = "" ]; then
        echo -e "\n\e[1;91mError : \e[0mNo apk was provided\e[0m"
        exit 1
    else
        if [ -f "$apk_file_paths" ]; then
            apk_install
        else
            echo -e "\n\e[1;91mError : \e[0mThe provided apk file does not exist\e[0m"
            exit 1
        fi
    fi

}

###### OPTION 4 "DISABLE APPLICATION" ######

function option_4() {

    read -rp $'\e[1;93m\nEnter the package name to disable : \e[21;92m' disable_pkg
    if [ "$disable_pkg" == "" ]; then
        echo -e "\n\e[1;91mError : \e[0mNo package was provided\e[0m"
        exit 1
    else
        if $ADB -s "$SERIAL_NO" shell pm disable-user --user 0 "$disable_pkg" &>/dev/null; then
            echo -e "\n\e[1;92mSuccess : \e[0mDisabled \e[33m'$disable_pkg' \e[0mfrom \e[33m'$MODEL'\e[0m"
            exit 0
        else
            echo -e "\n\e[1;91mError : \e[0mFailed disabling \e[33m'$disable_pkg' \e[0mfrom \e[33m'$MODEL'\e[0m"
            exit 1
        fi
    fi

}

###### OPTION 5 "ENABLE APPLICATION" ######

function option_5() {

    read -rp $'\e[1;93m\nEnter the package name to enable : \e[21;92m' enable_pkg
    if [ "$enable_pkg" == "" ]; then
        echo -e "\n\e[1;91mError : \e[0mNo package was provided\e[0m"
        exit 1
    else
        if $ADB -s "$SERIAL_NO" shell pm enable "$enable_pkg" &>/dev/null; then
            echo -e "\n\e[1;92mSuccess : \e[0mEnabled \e[33m'$enable_pkg' \e[0mfrom \e[33m'$MODEL'\e[0m"
            exit 0
        else
            echo -e "\n\e[1;91mError : \e[0mFailed enabling \e[33m'$enable_pkg' \e[0mfrom \e[33m'$MODEL'\e[0m"
            exit 1
        fi
    fi

}

###### OPTION 6 "LIST APPLICATION" ######

function list_application() {

    ###### OPTION 1 "LIST ALL APPLICATION" ######

    function option_list_1() {

        echo -e "\n\e[1;92mListing all packages in : \e[33m'$MODEL'\e[0m\n"
        echo -e "\n\e[1;93m*Note* : \e[0mPress \e[1;93mq\e[0m to stop in viewing."

        sleep 1s # Giving time to read the note

        temp_file1=$(mktemp) # creating a temp file to store output
        temp_file2=$(mktemp) # creating a temp file to filter

        if ! $ADB -s "$SERIAL_NO" shell cmd package list packages >"$temp_file1"; then
            echo -e "\n\e[1;91mError : \e[0mSome error occured.\e[0m"
            exit 1
        fi

        counter="1"
        while read -r line; do
            set "$line"
            echo "[94m$counter [93m: [92m${1#*:}[0m" counter=$((counter + 1)) >>"$temp_file2"
        done <"$temp_file1"

        $LESS -R "${temp_file2}" # Displaying all the apps

        rm "${temp_file1}" # Deleting the temp file
        rm "${temp_file2}" # Deleting the temp file

    }

    ###### OPTION 2 "LIST ENABLED APPLICATION" ######

    function option_list_2() {

        echo -e "\n\e[1;92mListing all enabled packages in : \e[33m'$MODEL'\e[0m\n"
        echo -e "\n\e[1;93m*Note* : \e[0mPress \e[1;93mq\e[0m to stop in viewing."

        sleep 1s # Giving time to read the note

        temp_file1=$(mktemp) # creating a temp file to store output
        temp_file2=$(mktemp) # creating a temp file to filter

        if ! $ADB -s "$SERIAL_NO" shell cmd package list packages -e >"$temp_file1"; then
            echo -e "\n\e[1;91mError : \e[0mSome error occured.\e[0m"
            exit 1
        fi

        counter="1"
        while read -r line; do
            set "$line"
            echo "[94m$counter [93m: [92m${1#*:}[0m" >>"$temp_file2"
            counter=$((counter + 1))
        done <"$temp_file1"

        $LESS -R "${temp_file2}" # Displaying all the apps

        rm "${temp_file1}" # Deleting the temp file
        rm "${temp_file2}" # Deleting the temp file

    }

    ###### OPTION 3 "LIST DISABLED APPLICATION" ######

    function option_list_3() {

        echo -e "\n\e[1;92mListing all disabled packages in : \e[33m'$MODEL'\e[0m\n"
        echo -e "\n\e[1;93m*Note* : \e[0mPress \e[1;93mq\e[0m to stop in viewing."

        sleep 1s # Giving time to read the note

        temp_file1=$(mktemp) # creating a temp file to store output
        temp_file2=$(mktemp) # creating a temp file to filter

        if ! $ADB -s "$SERIAL_NO" shell cmd package list packages -d >"$temp_file1"; then
            echo -e "\n\e[1;91mError : \e[0mSome error occured.\e[0m"
            exit 1
        fi

        counter="1"
        while read -r line; do
            set "$line"
            echo "[94m$counter [93m: [92m${1#*:}[0m" >>"$temp_file2"
            counter=$((counter + 1))
        done <"$temp_file1"

        $LESS -R "${temp_file2}" # Displaying all the apps

        rm "${temp_file1}" # Deleting the temp file
        rm "${temp_file2}" # Deleting the temp file

    }

    ###### OPTION 4 "LIST SYSTEM APPLICATION" ######

    function option_list_4() {

        echo -e "\n\e[1;92mListing all system packages in : \e[33m'$MODEL'\e[0m\n"
        echo -e "\n\e[1;93m*Note* : \e[0mPress \e[1;93mq\e[0m to stop in viewing."

        sleep 1s # Giving time to read the note

        temp_file1=$(mktemp) # creating a temp file to store output
        temp_file2=$(mktemp) # creating a temp file to filter

        if ! $ADB -s "$SERIAL_NO" shell cmd package list packages -s >"$temp_file1"; then
            echo -e "\n\e[1;91mError : \e[0mSome error occured.\e[0m"
            exit 1
        fi

        counter="1"
        while read -r line; do
            set "$line"
            echo "[94m$counter [93m: [92m${1#*:}[0m" >>"$temp_file2"
            counter=$((counter + 1))
        done <"$temp_file1"

        $LESS -R "${temp_file2}" # Displaying all the apps

        rm "${temp_file1}" # Deleting the temp file
        rm "${temp_file2}" # Deleting the temp file

    }

    ###### OPTION 5 "LIST THIRD PARTY APPLICATION" ######

    function option_list_5() {

        echo -e "\n\e[1;92mListing all third party packages in : \e[33m'$MODEL'\e[0m\n"
        echo -e "\n\e[1;93m*Note* : \e[0mPress \e[1;93mq\e[0m to stop in viewing."

        sleep 1s # Giving time to read the note

        temp_file1=$(mktemp) # creating a temp file to store output
        temp_file2=$(mktemp) # creating a temp file to filter

        if ! $ADB -s "$SERIAL_NO" shell cmd package list packages -3 >"$temp_file1"; then
            echo -e "\n\e[1;91mError : \e[0mSome error occured.\e[0m"
            exit 1
        fi

        counter="1"
        while read -r line; do
            set "$line"
            echo "[94m$counter [93m: [92m${1#*:}[0m" >>"$temp_file2"
            counter=$((counter + 1))
        done <"$temp_file1"

        $LESS -R "${temp_file2}" # Displaying all the apps

        rm "${temp_file1}" # Deleting the temp file
        rm "${temp_file2}" # Deleting the temp file

    }

    echo -e "\033[2J\033[1;1H" # Might replace with 'clear' later
    list_app_banner
    echo -e "\e[1;93m 1.  \e[1;92mList All Application\n"
    echo -e "\e[1;93m 2.  \e[1;92mList Enabled Application"
    echo -e "\e[1;93m 3.  \e[1;92mList Disabled Application"
    echo -e "\e[1;93m 4.  \e[1;92mList System Application"
    echo -e "\e[1;93m 5.  \e[1;92mList Third Party Application\n"
    echo -e "\e[1;93m E.  \e[1;92mExit"
    echo -e "$revised"
    read -rp $'  \e[1;4;91mEnter\e[1;24;91m \e[1;4;91m$\e[1;24;91m\e[24;1;97m : \e[0m' options_list_application

    while true; do

        case $options_list_application in

        "1")
            option_list_1
            break
            ;;
        "2")
            option_list_2
            break
            ;;
        "3")
            option_list_3
            break
            ;;
        "4")
            option_list_4
            break
            ;;
        "5")
            option_list_5
            break
            ;;
        [Ee]*)
            echo -e "\n\e[1;93mWarning : \e[0mExiting.....\n"
            break
            exit 0
            ;;
        *)
            revised="\n\e[1;91m Enter the right option :-)\e[0m\n"
            list_application
            break
            ;;

        esac

    done

}

# Option list
function option_picker() {

    print_banner_main
    echo -e "\e[1;93m 1.  \e[1;92mGet Device detail\n"
    echo -e "\e[1;93m 2.  \e[1;92mUninstall Application"
    echo -e "\e[1;93m 3.  \e[1;92mInstall Application 'apk'"
    echo -e "\e[1;93m 4.  \e[1;92mDisable Application"
    echo -e "\e[1;93m 5.  \e[1;92mEnable Application\n"
    echo -e "\e[1;93m 6.  \e[1;92mList Applications (Multiple)\n"
    echo -e "\e[1;93m E.  \e[1;92mExit"
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
            option_3
            break
            ;;
        "4")
            option_4
            break
            ;;
        "5")
            option_5
            break
            ;;
        "6")
            list_application
            break
            ;;
        [Ee]*)
            echo -e "\n\e[1;93mWarning : \e[0mExiting.....\n"
            break
            exit 0
            ;;
        *)
            echo -e "\033[2J\033[1;1H" # Might replace with 'clear' later
            revised="\n\e[1;91m Enter the right option :-)\e[0m\n"
            option_picker
            break
            ;;

        esac

    done

}

##################### MAIN FUNCTION #####################

function main() {

    get_device_info # Getting device info and checking ia any valid device connected or not
    option_picker   # Option picker dialog

}

#### Calling the main function ####

main
