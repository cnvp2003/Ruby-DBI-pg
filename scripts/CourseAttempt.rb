require 'dbi'
require 'pg'
require 'securerandom'

puts "Connecting to MySQL....."
dbh = DBI.connect("DBI:Mysql:database=migration;host=localhost;port=3306",
                  "root", "root")

puts "Connecting to PostgreSQL....."
conn = PGconn.connect("localhost", 5433, '', '',
                      "intermediate", "nemo", "nemo123")

# For Course Attempt
puts "Preparing MySQL query ..."
sth = dbh.prepare("SELECT userid, moduleid, laststarttime, lastpasstime, status, percent FROM CREDIT")

puts "Excuting query ..."
sth.execute()

count = 1
sth.fetch do |row|
  userSql = "SELECT id FROM \"USERS\" WHERE \"odsId\" = '#{row[0].abs}'"
  courseSql = "SELECT id FROM \"COURSES\" WHERE \"cmsId\" = #{row[1].abs}"

  puts "Getting User Id: #{userSql}"
  resUser = conn.exec(userSql)
  puts "Getting Course Id: #{courseSql}"
  resCourse = conn.exec(courseSql)

  id = SecureRandom.uuid
  timeStamp = Time.now.getutc
  attemptStatementId = SecureRandom.uuid
  completedStatementId = SecureRandom.uuid

  success = if (row[4] == "done")
              1
            else
              0
            end
  completedDate = row[3]
  if completedDate.nil?
    completedDate = "2001-02-01T00:00:00+00:00"
  end

  sql = "INSERT INTO \"COURSE_ATTEMPTS\"(\"id\", \"userId\", \"courseId\", timeStamp, \"attemptDate\", \"attemptStatementId\",
          \"completedDate\", \"completedStatementID\", \"success\", \"scaledScore\")
          VALUES ('#{id}','#{resUser[0]['id']}','#{resCourse[0]['id']}','#{timeStamp}','#{row[2]}','#{attemptStatementId}','#{completedDate}',
          '#{completedStatementId}','#{success}','#{row[5]}')"

  puts "Inserting... #{sql}"
  conn.exec(sql)

  puts "Record has been created #{count}"
  count += 1
end

sth.finish
dbh.disconnect