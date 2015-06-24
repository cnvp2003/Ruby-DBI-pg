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
# For local DB
sth = dbh.prepare("SELECT DISTINCT(userId) FROM CREDIT")
#For remote DB
#sth = dbh.prepare("SELECT DISTINCT(userId) FROM CREDIT order by userId limit 25000")
#sth = dbh.prepare("SELECT DISTINCT(userId) FROM CREDIT order by userId LIMIT 25000 OFFSET 25000")
#sth = dbh.prepare("SELECT DISTINCT(userId) FROM CREDIT order by userId LIMIT 25000 OFFSET 50000")
#sth = dbh.prepare("SELECT DISTINCT(userId) FROM CREDIT order by userId LIMIT 25000 OFFSET 75000")

puts "Excuting query ..."
sth.execute()

count = 1
sth.fetch do |row|
  #puts row[10]
  tincanId = "account:[\"ods\",\"#{row[0]}\"]"
  id = SecureRandom.uuid
  puts "#{row[0][0]}Id: '#{tincanId}'"

  sql = "INSERT INTO \"USERS\" (\"id\", \"tincanId\", \"odsId\", \"email\", \"name\", \"isSpringerEmployee\", \"timestamp\")
            VALUES ('#{id}', '#{tincanId}', #{row[0]}, null, null, null, null)"

  puts "Inserting... #{sql}"
  conn.exec(sql)

  puts "Record has been created #{count}"
  count += 1
end

sth.finish
dbh.disconnect