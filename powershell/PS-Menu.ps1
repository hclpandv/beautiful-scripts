# A menu driven powershell script sample template 

#----------------------------------
# variables
# ----------------------------------


# ----------------------------------
# User defined function
# ----------------------------------
function pause(){
    $EnterKey = Read-Host "Press [Enter] key to continue..." 
}
function one(){
    Write-Host "Running command : az --version" -ForegroundColor Green
    az --version
    pause
}
# do something in two()
function two(){
    Write-Host "Running command : az account show" -ForegroundColor Green
    az account show
    pause
}
# third option
function three(){
    Write-Host "Running command : az account list --output table" -ForegroundColor Green
    az account list --output table
    pause
}
# function to display menus
function Show-Menus() {
    $msg = "
    ~~~~~~~~~~~~~~~~~~~~~	
    Viki Az cli Menu 
    ~~~~~~~~~~~~~~~~~~~~~
    1. Validate if Az-Cli Installed
    2. Get current Az account details
    3. List Az Subscriptions
    4. Connect another Az subscription
    5. Connect another Az subscription
    6. Exit
    "

    Write-Host $msg -ForegroundColor Yellow
}
# read input from the keyboard and take an action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option and so on.
# Exit when user the user select 6 form the menu option.
function Read-Options(){
        $choice = Read-Host "Enter choice [ 1 - 6] "
        
        switch ($choice) {
            "1"  { one }
            "2"  { two }
            "3"  { three }
            "4"  { echo "four" }
            "5"  { }
            "6"  {exit}
        }

	
}
# ----------------------------------------------
# Step #3: Trap CTRL+C, CTRL+Z and quit singles
# ----------------------------------------------
#trap '' SIGINT SIGQUIT SIGTSTP
# -----------------------------------
# Step #4: Main logic - infinite loop
# ------------------------------------

while ($true)
{
   Show-Menus
   Read-Options   
}
