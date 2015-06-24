require 'dbi'
require 'pg'
require 'securerandom'

puts "Connecting to MySQL....."
dbh = DBI.connect("DBI:Mysql:database=migration;host=localhost;port=3306",
                  "root", "root")

puts "Connecting to PostgreSQL....."
conn = PGconn.connect("localhost", 5433, '', '',
                      "intermediate", "nemo", "nemo123")

# For Course
puts "Preparing MySQL query ..."
sth = dbh.prepare("SELECT * FROM CMEMODULE")

puts "Excuting query ..."
sth.execute()

count = 1
sth.fetch do |row|
  activityId = "http://#{row[10]}"
  id = SecureRandom.uuid

  sql = "INSERT INTO \"COURSES\" (\"id\", \"activityId\", \"cmsId\", \"numberOfAttempts\", \"credit\")
            VALUES ('#{id}', '#{activityId}', #{row[10]}, null, #{row[4]})"

  puts "Inserting... #{sql}"
  conn.exec(sql)
  puts "Record has been created #{count}"
  count += 1
end

sth.finish
dbh.disconnect