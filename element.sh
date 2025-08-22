#!/bin/bash

# Script to get information about elements from the periodic table database

PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  echo Argument found!
fi