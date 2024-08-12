#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU() {
  echo -e "\n1) push\n2) pull\n3) legs"
  read SERVICE_ID_SELECTED

  if [[ $SERVICE_ID_SELECTED != 1 && $SERVICE_ID_SELECTED != 2 && $SERVICE_ID_SELECTED != 3 ]]
  then
    MAIN_MENU "Enter a valid option."
  else
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE

    PHONE_RESULT=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE';")
    if [[ -z $PHONE_RESULT ]]
    then
      echo -e "\nWhat's your name?"
      read CUSTOMER_NAME
      INSERT_CUSTOMER=$($PSQL "insert into customers(phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
    fi
    echo -e "\nWhat time would you like to schedule an appointment for?"
    read SERVICE_TIME
    CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE';")
    MAKE_APPOINTMENT=$($PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
    
    SERVICE_NAME=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED;")
    echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
  
}

MAIN_MENU