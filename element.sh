#!/bin/bash

# Script to get information about elements from the periodic table database

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

GET_ELEMENT_INFO () {
  ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where atomic_number=$1")
  EL_NAME=$($PSQL "select name from elements where atomic_number=$1")
  EL_SYMBOL=$($PSQL "select symbol from elements where atomic_number=$1")
  EL_TYPE=$($PSQL "select t.type from types t join properties p on t.type_id=p.type_id where atomic_number=$1")
  ATOMIC_MASS=$($PSQL "select atomic_mass from properties where atomic_number=$1")
  MELTING_POINT=$($PSQL "select melting_point_celsius from properties where atomic_number=$1")
  BOILING_POINT=$($PSQL "select boiling_point_celsius from properties where atomic_number=$1")
  echo "The element with atomic number $ATOMIC_NUMBER is $EL_NAME ($EL_SYMBOL). It's a $EL_TYPE, with a mass of $ATOMIC_MASS amu. $EL_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
}

# check if user entered an argument
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # check for element in 'elements' table by possible number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT_NUMBER=$($PSQL "
      select atomic_number from elements
      where atomic_number=$1
    ")
    # if not found
    if [[ -z $ELEMENT_NUMBER ]]
    then
      echo "I could not find that element's number in the database."
    # otherwise run 'get info' function
    else
      GET_ELEMENT_INFO $ELEMENT_NUMBER
    fi
  # check for element in 'elements' table by possible name or symbol
  else
    ELEMENT_NUMBER=$($PSQL "
      select atomic_number from elements
      where symbol='$1' or name='$1'
    ")
    # if not found
    if [[ -z $ELEMENT_NUMBER ]]
    then
      echo "I could not find that element's name or symbol in the database."
    # otherwise run 'get info' function
    else
      GET_ELEMENT_INFO $ELEMENT_NUMBER
    fi
  fi
fi
