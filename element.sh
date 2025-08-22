#!/bin/bash

# Script to get information about elements from the periodic table database

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

GET_ELEMENT_INFO () {
  echo "info about $1"
}

# check if user entered an argument
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # check for element in 'elements' table by possible number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT_NAME=$($PSQL "
      select name from elements
      where atomic_number=$1
    ")
    # if not found
    if [[ -z $ELEMENT_NAME ]]
    then
      echo "I could not find that element's number in the database."
    # otherwise run 'get info' function
    else
      GET_ELEMENT_INFO $ELEMENT_NAME
    fi
  # check for element in 'elements' table by possible name or symbol
  else
    ELEMENT_NAME=$($PSQL "
      select name from elements
      where symbol='$1' or name='$1'
    ")
    # if not found
    if [[ -z $ELEMENT_NAME ]]
    then
      echo "I could not find that element's name or symbol in the database."
    # otherwise run 'get info' function
    else
      GET_ELEMENT_INFO $ELEMENT_NAME
    fi
  fi
fi
