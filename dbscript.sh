#!/bin/bash
script_name=`basename $0`
show_error () {
    echo "USAGE: ${script_name} DATABASE USER [PASSWORD]"
    exit 1
}

if [[ -z "$1" ]]; then show_error; fi # Check if enough args
if [[ -z "$2" ]]; then show_error; fi
if [[ -n "$4" ]]; then show_error; fi # Check if not too much args

db=$1
user=$2
pass="password" # Password is optional arg, but at least we can have a default
if [[ -n "$3" ]]; then pass=$3; fi

sql="CREATE DATABASE IF NOT EXISTS ${db};"
sql+="GRANT USAGE ON *.* TO ${user}@localhost IDENTIFIED BY '${pass}';"
sql+="GRANT ALL PRIVILEGES ON ${db}.* TO ${user}@localhost;"

out=$(mysql -hlocalhost -uroot -e "${sql}")

# Normally should be no output, warn if is
if [[ -n "$out" ]]; then
    echo "WARNING, output returned from call to mysql: "$out
else
    echo "Now try login with: "
    echo "mysql -hlocalhost -u${user} -p${pass} ${db}"
fi