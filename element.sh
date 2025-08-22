#!/bin/bash

# Script to get information about elements from the periodic table database

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# check if user entered an argument
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # check for element in 'elements' table
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    FIND_ELEMENT_RESULT=$($PSQL "
      select name from elements
      where atomic_number=$1
    ")
    if [[ -z $FIND_ELEMENT_RESULT ]]
    then
      echo "I could not find that element's number in the database."
    else
      echo "Element number found!"
    fi
  else
    FIND_ELEMENT_RESULT=$($PSQL "
      select name from elements
      where symbol='$1' or name='$1'
    ")
    if [[ -z $FIND_ELEMENT_RESULT ]]
    then
      echo "I could not find that element's name or symbol in the database."
    else
      echo "Element name or symbol found!"
    fi
  fi
fi