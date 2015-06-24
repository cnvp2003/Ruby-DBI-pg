require 'dbi'
require 'pg'
require 'securerandom'
require 'csv'

puts "Connecting to MySQL....."
dbh = DBI.connect("DBI:Mysql:database=migration;host=localhost;port=3306",
                  "root", "root")

puts "Connecting to PostgreSQL....."
conn = PGconn.connect("localhost", 5433, '', '',
                      "intermediate", "nemo", "nemo123")

# For Questions
puts "Preparing MySQL query ..."
sth = dbh.prepare("select q.id, q.moduleid, q.textlang1, q.titlelang1, a.titlelang1, o.questions_order from CMEQUESTION q,
          CMEANSWER a, CMEMO_QUESTIONS o where q.id = a.questionid and a.valid = 'true' and q.id = o.questions_id")

puts "Excuting query ..."
sth.execute()

count = 1
sth.fetch do |row|
  crsql = "SELECT id FROM \"COURSES\" WHERE \"cmsId\" = #{row[1]}"
  puts "Getting Course Id: #{crsql}"
  res = conn.exec(crsql)

  id = SecureRandom.uuid

  questions = "#{row[3]} #{row[2]}"
  question1 = questions.force_encoding('iso-8859-1'||'iso-8859-2'||'iso-8859-3'||'iso-8859-4'||'iso-8859-9'||'iso-8859-10'||'iso-8859-13'||'iso-8859-14'||'iso-8859-15'||'iso-8859-16'||'ASCII-8BIT'||'latin1').encode('utf-8')
  question = question1.tr("'s", "s")

  activityId = "http://#{row[1]}/#{row[0]}/#{id}"

  correctChoices = "#{row[4]}"
  correctChoice1 = correctChoices.force_encoding('iso-8859-1'||'iso-8859-2'||'iso-8859-3'||'iso-8859-4'||'iso-8859-9'||'iso-8859-10'||'iso-8859-13'||'iso-8859-14'||'iso-8859-15'||'iso-8859-16'||'ASCII-8BIT'||'latin1').encode('utf-8')
  correctChoice = correctChoice1.tr("'s", "s")

  sql = "INSERT INTO \"COURSE_QUESTIONS\"(\"id\",\"courseId\", \"activityId\", \"question\", \"correctChoice\", \"ordering\")
          VALUES('#{id}', '#{res[0][0]}', '#{activityId}', '#{question}', '#{correctChoice}', #{row[5]})"

  puts "Inserting... #{sql}"
  conn.exec(sql)

  puts "Record has been created #{count}"
  count += 1
end

sth.finish
dbh.disconnect