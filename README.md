#DB MiGRATION

## Description:

This contains all the necessary tools to migrate the existing mySQL DataBase into postgresql DB.

## Source:

[here](https://github.com/cnvp2003/Ruby-DBI-pg.git)

## System dependencies:

* Ruby
* Postgre DB

## How to setup ruby

Run this set of commands to have a good working ruby environment:
Warning: If this is really what is needed needs to be checked!!!

sudo apt-get install curl
sudo apt-get install ruby2.1
sudo gem update --system
sudo apt-get install rake
apt-get install ruby-dev
sudo gem install amatch
sudo apt-get install libmysqlclient-dev
sudo gem install -r dbi
sudo gem install -r mysql dbd-mysql
sudo gem install dbd
sudo gem install dbd-mysql

## How to setup the postgreSQL DB

run .sql file on DB console it will create Database schema for you.

Dataflow
legacy Mysql Data -> Postgres DB


In general the "postgres.sql" contains everything needed to setup DB and tables.

## How to run ruby script files

In console window write:

ruby User.rb

## How to run the migration

To run the migration first make sure you have set up the postgres DB configured.

Execute the files in this order:

User.rb
Course.rb
Question.rb
CourseAttempts.rb
Answers.rb

## Develop and testing

Make sure you are targeting your local dev database when doing development.
Change the following line in the script to use your local DB:

e.g

puts "Connecting to PostgreSQL....."
conn = PGconn.connect("localhost", 5432, '', '',"postgres", "postgres", "postgres")