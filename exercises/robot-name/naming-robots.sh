#!/bin/bash

# naming robots: a simple scripts to randomly name a maximum of 1000 robots

###########################################################################

# Manage robot factory settings.

# When robots come off the factory floor, they have no name.

# The first time you boot them up, a random name is generated in the format of
# two uppercase letters followed by three digits, such as RX837 or BC811.

# Every once in a while we need to reset a robot to its factory settings, which
# means that their name gets wiped. The next time you ask, it will respond with
# a new random name.

# The names must be random: they should not follow a predictable
# sequence. Random names means a risk of collisions. Your solution must ensure
# that every existing robot has a unique name.

# some variables

orange='\033[33m' 
cyan='\033[36m'
green='\033[32m'
NC='\033[0m'

maximum=1000


# Function to get number of robot from user

robotAmount() {
echo -e "${orange}Hi, how many randomly named robots do you want created?.${NC}"

read  amount

if  [ "$amount" -ge 1 ] && [ "$amount" -le "$maximum" ] 2>/dev/null; then
    echo -e "${orange}Thanks.${NC}"
    createRobots
    exit
else
    echo -e "Sorry, run the script again and provide a proper value or a smaller number."
    exit
fi     

}

# We give the robots names & store them in an array

createRobots() {
    progressBar
    robots=()
    for ((rob=1; rob<="$amount"; rob++))
 do
     LETTERS=$(cat /dev/urandom | tr -dc 'A-Z'| fold -w 2 | head -n 1)
     NUMS=$(cat /dev/urandom | tr -dc '0-9'|fold -w 3 | head -n 1)

     robots["$rob"]=$LETTERS$NUMS
     echo "Robot$rob = $LETTERS$NUMS"
     sleep 1

 done
resetRobot
}


# We create a new array to give a particular robot a brand new name

resetaRobot() {

    newRobot=()
echo -e "${orange}What robot number would you like to reset?.${NC}"

read  number

if  [ "$number" -ge 1 ] && [ "$number" -le "$amount" ] 2>/dev/null; then
    echo "Ok ..."
    NEW_LETTERS=$(cat /dev/urandom | tr -dc 'A-Z'| fold -w 2 | head -n 1)
    NEW_NUMS=$(cat /dev/urandom | tr -dc '0-9'|fold -w 3 | head -n 1)
    newRobot[0]=$NEW_LETTERS$NEW_NUMS
    collisionChecker

else 
    echo "Sorry, you didn't type in a valid number; try again"
    resetaRobot
fi


}


# We check that all names are unique

collisionChecker() {

    for r in "${robots[@]}"
    do
	if [ "$r" -eq ${newRobot[0]} ] 2> /dev/null; then
	    echo "Sorry, name already taken. I need some more processing ..."
	    resetaRobot
	else
	    echo "The new unique number for Robot #$number is: " ${newRobot[0]}
       	    sleep 2

	    robots["$number"]=${newRobot[0]}
	    echo ${robots["$number"]}
	    echo "All your robots names are: "
	    echo ${robots[*]}
	    echo "Bye!"

	    exit
	fi
    done
    
    
 }

# We get info from user in case they want to reset a robot or start afresh

resetRobot() {

    echo -e "${orange}Please, choose your option:

1. I want to reset all my robots
2. I want to reset a particular robot
3. I don't want to reset any robot
0. Quit
${NC}"
    read -p "Enter selection [0-3] >"

    case $REPLY in
	0)  echo -e "${orange}Bye!${NC}"
	    exit
	    ;;

	1)  createRobots
	    ;;

	2)  resetaRobot
   	    exit
	    ;;

	3)  echo -e "${orange}Bye!${NC}"
	    exit
	    ;;

	*)  echo -e "${orange}Invalid option${NC}" >&2
            exit  1
	    ;;
    esac

}


# progress bar

progressBar() {

echo -e "${orange}Generating robot names...${NC}"

for i in {001..005}
 do
    sleep 1
    echo -n .

done

echo -e
    
}


robotAmount
