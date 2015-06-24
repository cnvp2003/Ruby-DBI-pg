CREATE TABLE "COURSES"
(
  id uuid PRIMARY KEY NOT NULL,
  "activityId" VARCHAR(254) NOT NULL,
  "cmsId" INT,
  "numberOfAttempts" INT,
  credit INT,
  title VARCHAR(254) DEFAULT NULL
);
CREATE UNIQUE INDEX course_index_cmsid ON "COURSES" ("cmsId");
CREATE UNIQUE INDEX course_index_tincanid ON "COURSES" ("activityId");

CREATE TABLE "USERS"
(
  id uuid PRIMARY KEY NOT NULL,
  "tincanId" VARCHAR(254) NOT NULL,
  "odsId" VARCHAR(255) DEFAULT NULL,
  email VARCHAR(255) DEFAULT NULL,
  name VARCHAR(255) DEFAULT NULL,
  "isSpringerEmployee" BOOL,
  timestamp TIMESTAMP
);
CREATE UNIQUE INDEX user_index_tincanid ON "USERS" ("tincanId");

CREATE TABLE "COURSE_QUESTIONS"
(
  id uuid PRIMARY KEY NOT NULL,
  "courseId" uuid NOT NULL,
  "activityId" VARCHAR(254) NOT NULL,
  question VARCHAR,
  "correctChoice" VARCHAR,
  ordering INT DEFAULT 0,
  FOREIGN KEY ("courseId") REFERENCES "COURSES" (id)
);
CREATE UNIQUE INDEX course_question_unique_activity_idx ON "COURSE_QUESTIONS" ("activityId");
CREATE INDEX course_question_ordering_idx ON "COURSE_QUESTIONS" (ordering);

CREATE TABLE "COURSE_ATTEMPTS"
(
  id uuid PRIMARY KEY NOT NULL,
  "userId" uuid NOT NULL,
  "courseId" uuid NOT NULL,
  timestamp TIMESTAMP NOT NULL,
  "attemptDate" TIMESTAMP NOT NULL,
  "attemptStatementId" uuid NOT NULL,
  "completedDate" TIMESTAMP,
  "completedStatementID" uuid,
  success BOOL,
  "scaledScore" DOUBLE PRECISION,
  ignore BOOL DEFAULT false NOT NULL,
  "ignoreCause" VARCHAR(254) DEFAULT NULL,
  "attemptNum" INT DEFAULT 0 NOT NULL,
  FOREIGN KEY ("courseId") REFERENCES "COURSES" (id),
  FOREIGN KEY ("userId") REFERENCES "USERS" (id)
);
CREATE INDEX course_attempts_course_idx ON "COURSE_ATTEMPTS" ("courseId");
CREATE INDEX course_attempts_timestamp_idx ON "COURSE_ATTEMPTS" (timestamp);
CREATE INDEX course_attempts_user_idx ON "COURSE_ATTEMPTS" ("userId");

CREATE TABLE "ANSWERS"
(
  id uuid PRIMARY KEY NOT NULL,
  "questionId" uuid NOT NULL,
  "attemptId" uuid NOT NULL,
  "statementId" uuid NOT NULL,
  correct BOOL,
  FOREIGN KEY ("attemptId") REFERENCES "COURSE_ATTEMPTS" (id),
  FOREIGN KEY ("questionId") REFERENCES "COURSE_QUESTIONS" (id)
);