# A menu driven powershell script sample template 

#----------------------------------
# variables
# ----------------------------------

#For User Interface

BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
POWDER_BLUE=$(tput setaf 153)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)


# ----------------------------------
# User defined function
# ----------------------------------
function pause(){
    read -p "Press [Enter] key to continue..." fackEnterKey
}
one(){
    echo "${GREEN} Running command : az --version ${STD}"
    az --version
    pause
}
# do something in two()
two(){
    echo "${GREEN} Running command : az account show ${STD}"
    az account show
    pause
}
# third option
three(){
    echo "${GREEN} Running command : az account list --output table ${STD}"
    az account list --output table
    pause
}
# function to display menus
show_menus() {
    clear
    echo "${LIME_YELLOW}"
    echo "~~~~~~~~~~~~~~~~~~~~~"	
    echo "Viki Az cli Menu "
    echo "~~~~~~~~~~~~~~~~~~~~~"
    echo "1. Validate if Az-Cli Installed"
    echo "2. Get current Az account details"
    echo "3. List Az Subscriptions"
    echo "4. Connect another Az subscription"
    echo "5. Connect another Az subscription"
    echo "6. Exit"
    echo "${STD}"
}
# read input from the keyboard and take a action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option.
# Exit when user the user select 3 form the menu option.
read_options(){
        local choice
	read -p "Enter choice [ 1 - 6] " choice
	case $choice in
         1) one ;;
         2) two ;;
         3) three ;;
         4) four ;;
         5) five ;;
         6) exit 0;;																	3) exit 0;;
         *) echo -e "${RED}Error...${STD}" && sleep 2
       esac
}
# ----------------------------------------------
# Step #3: Trap CTRL+C, CTRL+Z and quit singles
# ----------------------------------------------
trap '' SIGINT SIGQUIT SIGTSTP
# -----------------------------------
# Step #4: Main logic - infinite loop
# ------------------------------------
while true
do
  show_menus
  read_options
done
