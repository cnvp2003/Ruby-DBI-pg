require 'dbi'
require 'pg'
require 'securerandom'

puts "Connecting to MySQL....."
dbh = DBI.connect("DBI:Mysql:database=migration;host=localhost;port=3306",
                  "root", "root")

puts "Connecting to PostgreSQL....."
conn = PGconn.connect("localhost", 5433, '', '',
                      "intermediate", "nemo", "nemo123")

# For Answers
puts "Preparing MySQL query ..."
sth = dbh.prepare("SELECT questionId, moduleId, userId, answerValid FROM CREDITANSWER")

puts "Excuting query ..."
sth.execute()

count = 1
sth.fetch do |row|
  courseSql = "SELECT id FROM \"COURSES\" WHERE \"cmsId\" = #{row[1]}"
  puts "Getting Course Id: #{crsql}"
  rescourse = conn.exec(courseSql)

  userSql = "SELECT id FROM \"USERS\" WHERE \"odsId\" = '#{row[2]}'"
  puts "Getting User Id: #{userSql}"
  resUser = conn.exec(userSql)

  questionSql = "SELECT id FROM \"COURSE_QUESTIONS\" WHERE \"courseId\" = '#{rescourse[0]['id']}'"

  attemptSql = "SELECT id, \"attemptStatementId\" FROM \"COURSE_ATTEMPTS\"  WHERE \"courseId\" = '#{rescourse[0]['id']}' and \"userId\" =  '#{resUser[0]['id']}'"

  puts "Getting Question Id: #{questionSql}"
  resQuestion = conn.exec(questionSql)
  puts "Getting attempt: #{attemptSql}"
  resAttempt = conn.exec(attemptSql)

  correct = row[3]
  attemptId = resAttempt[0]['id']
  statementId = resAttempt[0]['attemptStatementId']

  resQuestion.each do |row|
    id = SecureRandom.uuid

    sql = "INSERT INTO \"ANSWERS\"(\"id\", \"questionId\", \"attemptId\", \"statementId\", \"correct\")
          VALUES ('#{id}','#{row['id']}', '#{attemptId}','#{statementId}','#{correct}')"

    puts "Inserting... #{sql}"
    conn.exec(sql)
  end
  puts "Record has been created #{count}"
  count += 1
end

sth.finish
dbh.disconnect