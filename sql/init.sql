CREATE TYPE GENDER AS ENUM ('male', 'female')
;

CREATE TYPE DAY AS ENUM ('monday','tuesday','wednesday','thursday','friday','saturday','sunday')
;

CREATE TYPE WEEK AS ENUM ('first','second','both')
;

CREATE TYPE ROOM_TYPE AS ENUM ('lecture', 'lab', 'practice')
;

CREATE TABLE passport_info
(
	id          SERIAL PRIMARY KEY,
	first_name  VARCHAR(50) NOT NULL,
	middle_name VARCHAR(50) NOT NULL,
	last_name   VARCHAR(50) NOT NULL,
	series      CHAR(2)     NOT NULL,
	code        CHAR(6)     NOT NULL,
	birthday    DATE        NOT NULL,
	gender      GENDER      NOT NULL,
	UNIQUE (series, code)
)
;

CREATE TABLE subjects
(
	id   SERIAL PRIMARY KEY,
	name VARCHAR(255) NOT NULL UNIQUE
)
;

CREATE TABLE departments
(
	id           SERIAL PRIMARY KEY,
	full_name    VARCHAR(255) NOT NULL UNIQUE,
	abbreviation CHAR(10)     NOT NULL UNIQUE
)
;

CREATE TABLE specialities
(
	id   SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL UNIQUE,
	code SMALLINT     NOT NULL UNIQUE
)
;

CREATE TABLE groups
(
	id            SERIAL PRIMARY KEY,
	name          CHAR(10) NOT NULL UNIQUE,
	id_speciality INT      NOT NULL,
	id_department INT      NOT NULL,
	FOREIGN KEY (id_speciality) REFERENCES specialities(id),
	FOREIGN KEY (id_department) REFERENCES departments(id)
)
;

CREATE TABLE students
(
	id                 SERIAL PRIMARY KEY,
	id_passport        INT NOT NULL UNIQUE,
	record_book_series CHAR(2)  NOT NULL,
	record_book_code   CHAR(6)  NOT NULL,
	id_group           INT      NOT NULL,
	FOREIGN KEY (id_group) REFERENCES groups(id),
	FOREIGN KEY (id_passport) REFERENCES passport_info(id),
	UNIQUE (record_book_code, record_book_series)
)
;

CREATE TABLE tutors
(
	id              SERIAL PRIMARY KEY,
	id_passport        INT NOT NULL UNIQUE,
	academic_degree VARCHAR(100),
	id_department   INT      NOT NULL,
	FOREIGN KEY (id_department) REFERENCES departments(id),
	FOREIGN KEY (id_passport) REFERENCES passport_info(id)
)
;

CREATE TABLE study_plans
(
	id         SERIAL PRIMARY KEY,
	id_subject INT      NOT NULL,
	id_group   INT      NOT NULL,
	credits    SMALLINT NOT NULL,
	FOREIGN KEY (id_subject) REFERENCES subjects(id),
	FOREIGN KEY (id_group) REFERENCES groups(id)
)
;

CREATE TABLE marks
(
	id         SERIAL PRIMARY KEY,
	id_subject INT          NOT NULL,
	id_tutor   INT          NOT NULL,
	id_student INT          NOT NULL,
	comment    VARCHAR(255) NULL     DEFAULT NULL,
	created_at DATE         NOT NULL DEFAULT CURRENT_DATE,
	FOREIGN KEY (id_subject) REFERENCES subjects(id),
	FOREIGN KEY (id_tutor) REFERENCES tutors(id),
	FOREIGN KEY (id_student) REFERENCES students(id)
)
;

CREATE TABLE rooms
(
	id   SERIAL PRIMARY KEY,
	code CHAR(10) NOT NULL UNIQUE,
	type ROOM_TYPE NOT NULL,
	capacity SMALLINT NOT NULL
)
;

CREATE TABLE schedule
(
	id           SERIAL PRIMARY KEY ,
	id_subject   INT      NOT NULL,
	id_group     INT      NOT NULL,
	id_tutor     INT      NOT NULL,
	id_room      INT      NOT NULL,
	week         WEEK     NOT NULL,
	day          DAY      NOT NULL,
	order_number SMALLINT NOT NULL,
	FOREIGN KEY (id_subject) REFERENCES subjects(id),
	FOREIGN KEY (id_group) REFERENCES groups(id),
	FOREIGN KEY (id_tutor) REFERENCES tutors(id),
	FOREIGN KEY (id_room) REFERENCES rooms(id)
)
;

CREATE TABLE session_results
(
	id         SERIAL PRIMARY KEY,
	id_subject INT      NOT NULL,
	id_tutor   INT      NOT NULL,
	id_student INT      NOT NULL,
	mark       SMALLINT NOT NULL CHECK ( mark >= 0 AND mark <= 100),
	created_at DATE     NOT NULL DEFAULT CURRENT_DATE,
	FOREIGN KEY (id_subject) REFERENCES subjects(id),
	FOREIGN KEY (id_tutor) REFERENCES tutors(id),
	FOREIGN KEY (id_student) REFERENCES students(id)
)
;
