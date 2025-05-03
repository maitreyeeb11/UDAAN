Server [localhost]:
Database [postgres]:
Port [5432]:
Username [postgres]:
Password for user postgres:

psql (16.3)
WARNING: Console code page (437) differs from Windows code page (1252)
         8-bit characters might not work correctly. See psql reference
         page "Notes for Windows users" for details.
Type "help" for help.

postgres=# \l
                                                              List of databases
   Name    |  Owner   | Encoding | Locale Provider |      Collate       |       Ctype        | ICU Locale | ICU Rules |   Access privileges
-----------+----------+----------+-----------------+--------------------+--------------------+------------+-----------+-----------------------
 php       | postgres | UTF8     | libc            | English_India.1252 | English_India.1252 |            |           |  postgres  | postgres | UTF8     | libc            | English_India.1252 | English_India.1252 |            |           |  template0 | postgres | UTF8     | libc            | English_India.1252 | English_India.1252 |            |           | =c/postgres          +
           |          |          |                 |                    |                    |            |           | postgres=CTc/postgres
 template1 | postgres | UTF8     | libc            | English_India.1252 | English_India.1252 |            |           | =c/postgres          +
           |          |          |                 |                    |                    |            |           | postgres=CTc/postgres
 udaan     | postgres | UTF8     | libc            | English_India.1252 | English_India.1252 |            |           | (5 rows)


postgres=# \c udaan
You are now connected to database "udaan" as user "postgres".
udaan=# \d
                   List of relations
 Schema |            Name            | Type  |  Owner
--------+----------------------------+-------+----------
 public | child                      | table | postgres
 public | child_mentorsession        | table | postgres
 public | child_sponsorship          | table | postgres
 public | child_volunteersession     | table | postgres
 public | guardian                   | table | postgres
 public | mentor                     | table | postgres
 public | mentor_mentorsession       | table | postgres
 public | mentorsession              | table | postgres
 public | sponsor                    | table | postgres
 public | sponsorship                | table | postgres
 public | volunteer                  | table | postgres
 public | volunteer_volunteersession | table | postgres
 public | volunteersession           | table | postgres
(13 rows)


udaan=# drop table volunteersession
udaan-# ;
ERROR:  cannot drop table volunteersession because other objects depend on it
DETAIL:  constraint fk_volunteer_session on table volunteer_volunteersession depends on table volunteersession
constraint fk_volunteer_session on table child_volunteersession depends on table volunteersession
HINT:  Use DROP ... CASCADE to drop the dependent objects too.
udaan=# drop table child;
ERROR:  cannot drop table child because other objects depend on it
DETAIL:  constraint fk_child on table child_sponsorship depends on table child
constraint fk_child on table child_mentorsession depends on table child
constraint fk_child on table child_volunteersession depends on table child
HINT:  Use DROP ... CASCADE to drop the dependent objects too.
udaan=# DROP TABLE volunteersession CASCADE ;
NOTICE:  drop cascades to 2 other objects
DETAIL:  drop cascades to constraint fk_volunteer_session on table volunteer_volunteersession
drop cascades to constraint fk_volunteer_session on table child_volunteersession
DROP TABLE
udaan=# DROP TABLE volunteer CASCADE ;
NOTICE:  drop cascades to constraint fk_volunteer on table volunteer_volunteersession
DROP TABLE
udaan=# DROP TABLE volunteer_volunteersession CASCADE ;
DROP TABLE
udaan=# DROP TABLE child CASCADE ;
NOTICE:  drop cascades to 3 other objects
DETAIL:  drop cascades to constraint fk_child on table child_sponsorship
drop cascades to constraint fk_child on table child_mentorsession
drop cascades to constraint fk_child on table child_volunteersession
DROP TABLE
udaan=# DROP TABLE child_mentorsession CASCADE ;
DROP TABLE
udaan=# DROP TABLE child_sponsorship CASCADE ;
DROP TABLE
udaan=# DROP TABLE child_volunteersession CASCADE ;
DROP TABLE
udaan=# DROP TABLE guardian CASCADE ;
DROP TABLE
udaan=# DROP TABLE mentor CASCADE ;
NOTICE:  drop cascades to constraint fk_mentor on table mentor_mentorsession
DROP TABLE
udaan=# DROP TABLE mentor_mentorsession CASCADE ;
DROP TABLE
udaan=# DROP TABLE mentorsession CASCADE ;
DROP TABLE
udaan=# DROP TABLE sponsor CASCADE ;
NOTICE:  drop cascades to constraint fk_sponsor on table sponsorship
DROP TABLE
udaan=# DROP TABLE sponsorship CASCADE ;
DROP TABLE
udaan=# \d
Did not find any relations.
udaan=# CREATE TABLE guardian (
udaan(#     guardian_id SERIAL PRIMARY KEY,
udaan(#     name VARCHAR(30),
udaan(#     contact VARCHAR(15),
udaan(#     rel_with_child VARCHAR(20),
udaan(#     address VARCHAR(100),
udaan(#     CONSTRAINT chk_contact CHECK (contact ~ '^\d{10}$')
udaan(#
udaan(# );
CREATE TABLE
udaan=# INSERT INTO guardian (name, contact, rel_with_child, address)
udaan-# VALUES
udaan-# ('Anjali Trust', '9012345678', 'NGO', 'Pune, India'),
udaan-# ('Ashray Foundation', '9876098765', 'NGO', 'Pune, India'),
udaan-# ('Maitra Foundation', '9901234567', 'NGO', 'Pune, India'),
udaan-# ('Saheli Foundation', '9091238765', 'NGO', 'Pune, India'),
udaan-# ('Jeevan NGO', '9212345678', 'NGO', 'Pune, India'),
udaan-# ('Prerna NGO', '9019876543', 'NGO', 'Pune, India'),
udaan-# ('Sarita Devi', '9098765432', 'Mother', 'Pune, India'),
udaan-# ('Manju Devi', '9054321890', 'Mother', 'Pune, India'),
udaan-# ('Priya Kamble', '9321456789', 'Mother', 'Pune, India'),
udaan-# ('Radha Kumari', '9123456780', 'Mother', 'Pune, India');
INSERT 0 10
udaan=# CREATE TABLE child(
udaan(#     enrol_id SERIAL PRIMARY KEY,
udaan(#     child_name VARCHAR(30),
udaan(#     gender VARCHAR(15),
udaan(#     dob DATE,
udaan(#     edu_level VARCHAR(20),
udaan(#     emo_status VARCHAR(20),
udaan(#     career_asp VARCHAR(20),
udaan(#     guardian_id INT,
udaan(#     CONSTRAINT fk_guardian FOREIGN KEY (guardian_id) REFERENCES guardian(guardian_id)
udaan(#     ON DELETE CASCADE ON UPDATE CASCADE
udaan(# );
CREATE TABLE
udaan=# ALTER TABLE child ADD COLUMN skills_interest VARCHAR(50);
ALTER TABLE
udaan=# INSERT INTO child (child_name, gender, dob, edu_level, emo_status, career_asp, guardian_id)
udaan-# VALUES
udaan-# ('Aarav', 'Male', '2011-05-15', 'Secondary', 'Stable', 'Engineer', 1),
udaan-# ('Riya', 'Female', '2012-03-20', 'Secondary', 'Anxious', 'Doctor', 2),
udaan-# ('Kabir', 'Male', '2011-07-10', 'Secondary', 'Improving', 'Scientist', 1),
udaan-# ('Ishita', 'Female', '2009-08-25', 'High School', 'Stable', 'Teacher', 2),
udaan-# ('Aditya', 'Male', '2010-11-02', 'High School', 'Stable', 'Pilot', 3),
udaan-# ('Nisha', 'Female', '2011-12-15', 'Secondary', 'Anxious', 'Artist', 5),
udaan-# ('Ayaan', 'Male', '2005-09-18', 'College/University', 'Stable', 'Entrepreneur', 7),
udaan-# ('Pooja', 'Female', '2008-01-10', 'High School', 'Stable', 'Psychologist', 8),
udaan-# ('Kartik', 'Male', '2007-05-22', 'High School', 'Improving', 'Engineer', 9),
udaan-# ('Simran', 'Female', '2012-06-30', 'Secondary', 'Stable', 'Dancer', 4),
udaan-# ('Romil', 'Male', '2011-12-12', 'Secondary', 'Stable', 'Scientist', 5),
udaan-# ('Anika', 'Female', '2004-03-05', 'College/University', 'Improving', 'Dancer', 3),
udaan-# ('Aryan', 'Male', '2011-07-09', 'Secondary', 'Stable', 'Pilot', 2),
udaan-# ('Meera', 'Female', '2009-11-21', 'High School', 'Improving', 'Engineer', 4),
udaan-# ('Raju', 'Male', '2005-06-03', 'College/University', 'Stable', 'Engineer', 5),
udaan-# ('Shrikant', 'Male', '2007-09-06', 'High School', 'Improving', 'Engineer', 10);
INSERT 0 16
udaan=# CREATE TABLE mentor (
udaan(#     mentor_id SERIAL PRIMARY KEY,
udaan(#     mentor_name VARCHAR(30),
udaan(#     expertise VARCHAR(50),
udaan(#     mentor_avail VARCHAR(10),
udaan(#     mentor_email VARCHAR(30),
udaan(#     contact_no VARCHAR(15),
udaan(#     CONSTRAINT chk_mentor_contact CHECK (contact_no ~ '^\d{10}$'),
udaan(#     CONSTRAINT chk_email CHECK (mentor_email ~ '^[^@]+@[^@]+$')
udaan(# );
CREATE TABLE
udaan=# INSERT INTO mentor (mentor_name, expertise, mentor_avail, mentor_email, contact_no)
udaan-# VALUES
udaan-# ('Dr. Meera Sharma', 'Psychiatry', 'Offline', 'meera.sharma@example.com', '9876501234'),
udaan-# ('Arjun Patel', 'Career Counselling', 'Offline', 'arjun.patel@example.com', '9123456789'),
udaan-# ('Neha Singh', 'Behavioral Therapy', 'Hybrid', 'neha.singh@example.com', '9812345678'),
udaan-# ('Pooja Sharma', 'Career Guidance', 'Hybrid', 'pooja.sharma@example.com', '9832145678'),
udaan-# ('Sanjay Verma', 'Education Counselling', 'Offline', 'sanjay.verma@example.com', '9743126589'),
udaan-# ('Anjali Mehta', 'Soft Skills Training', 'Offline', 'anjali.mehta@example.com', '9598765432'),
udaan-# ('Dr. Ramesh Gupta', 'Psychiatry', 'Hybrid', 'ramesh.gupta@example.com', '9101234567'),
udaan-# ('Sneha Roy', 'Child Development', 'Offline', 'sneha.roy@example.com', '9823145670'),
udaan-# ('Manish Kapoor', 'Motivational Coaching', 'Offline', 'manish.kapoor@example.com', '9123987654');
INSERT 0 9
udaan=# CREATE TABLE volunteer (
udaan(#     volunteer_id SERIAL PRIMARY KEY,
udaan(#     full_name VARCHAR(50) NOT NULL,
udaan(#     age INT NOT NULL CHECK (age >= 18 AND age <= 100),
udaan(#     gender VARCHAR(20) NOT NULL CHECK (gender IN ('Male', 'Female', 'Other', 'Prefer Not to Answer')),
udaan(#     volunteer_email VARCHAR(50) NOT NULL UNIQUE CHECK (volunteer_email ~ '^[^@]+@[^@]+\.[^@]+$'),
udaan(#     volunteer_contact VARCHAR(10) NOT NULL CHECK (volunteer_contact ~ '^\d{10}$'),
udaan(#     skills VARCHAR(100) NOT NULL,
udaan(#     interest VARCHAR(100) NOT NULL,
udaan(#     volunteer_avail VARCHAR(20) NOT NULL,
udaan(#     experience TEXT,
udaan(#     reason TEXT
udaan(# );
CREATE TABLE
udaan=# INSERT INTO volunteer (full_name, age, gender, volunteer_email, volunteer_contact, skills, interest, volunteer_avail)
udaan-# VALUES
udaan-# ('Kavya Desai', 25, 'Female', 'kavya.desai@example.com', '9001234567', 'Soft Skills', 'Teaching, Communication', 'Weekends'),
udaan-# ('Rohan Gupta', 30, 'Male', 'rohan.gupta@example.com', '8987654321', 'Group Activities', 'Event Management, Team Building', 'Flexible'),
udaan-# ('Aditi Rao', 27, 'Female', 'aditi.rao@example.com', '9012345678', 'Art Therapy', 'Creative Workshops, Therapy Support', 'Weekdays'),
udaan-# ('Akshay Jain', 28, 'Male', 'akshay.jain@example.com', '9098765432', 'Public Speaking', 'Debate, Presentation Coaching', 'Flexible'),
udaan-# ('Naina Singh', 24, 'Female', 'naina.singh@example.com', '9087654321', 'Sports Training', 'Fitness, Coaching', 'Weekends'),
udaan-# ('Ravi Shankar', 35, 'Male', 'ravi.shankar@example.com', '9009876543', 'Dance and Yoga Therapy', 'Mindfulness, Physical Fitness', 'Weekdays'),
udaan-# ('Priya Nair', 29, 'Female', 'priya.nair@example.com', '9123456789', 'Storytelling', 'Creative Writing, Theatre', 'Flexible'),
udaan-# ('Rajesh Sharma', 32, 'Male', 'rajesh.sharma@example.com', '9034567890', 'Music Lessons', 'Instrumental, Vocal Training', 'Weekends'),
udaan-# ('Ankit Mehta', 26, 'Male', 'ankit.mehta@example.com', '9091234567', 'Leadership Skills', 'Public Speaking, Management', 'Flexible'),
udaan-# ('Shreya Kulkarni', 31, 'Female', 'shreya.kulkarni@example.com', '9076543210', 'Cooking Classes', 'Nutrition, Healthy Eating', 'Weekdays');
INSERT 0 10
udaan=# CREATE TABLE mentorsession (
udaan(#     mentor_session_id SERIAL PRIMARY KEY,
udaan(#     mentor_session_date DATE,
udaan(#     focus_area VARCHAR(30),
udaan(#     outcome VARCHAR(30),
udaan(#     msession_type VARCHAR(30) CHECK (msession_type IN ('Hybrid', 'Offline')),
udaan(#     msession_status VARCHAR(30) CHECK (msession_status IN ('Scheduled', 'Completed', 'Cancelled'))
udaan(# );
CREATE TABLE
udaan=# INSERT INTO mentorsession (mentor_session_date, focus_area, outcome, msession_type, msession_status)
udaan-# VALUES
udaan-#     ('2025-02-01', 'Career Counselling', 'In Progress', 'Offline', 'Scheduled'),
udaan-#     ('2025-02-03', 'Behavioral Therapy', 'Positive Outcome', 'Offline', 'Completed'),
udaan-#     ('2025-02-07', 'Education Counselling', 'Needs Follow-up', 'Offline', 'Scheduled'),
udaan-#     ('2025-02-10', 'Child Development', 'Successful', 'Offline', 'Completed'),
udaan-#     ('2025-02-12', 'Motivational Coaching', 'Continued Support', 'Hybrid', 'Completed'),
udaan-#     ('2025-02-14', 'Career Guidance', 'Positive Feedback', 'Hybrid', 'Completed'),
udaan-#     ('2025-02-15', 'Soft Skills Training', 'In Progress', 'Hybrid', 'Scheduled'),
udaan-#     ('2025-02-17', 'Life Coaching', 'Ongoing Support', 'Offline', 'Scheduled'),
udaan-#     ('2025-02-18', 'Leadership Development', 'Excellent Progress', 'Hybrid', 'Completed'),
udaan-#     ('2025-02-20', 'Stress Management', 'Improved Well-being', 'Offline', 'Completed');
INSERT 0 10
udaan=# CREATE TABLE volunteersession (
udaan(#     volunteer_session_id SERIAL PRIMARY KEY,
udaan(#     volunteer_session_date DATE,
udaan(#     purpose VARCHAR(30),
udaan(#     outcome VARCHAR(30),
udaan(#     vsession_type VARCHAR(30),
udaan(#     vsession_status VARCHAR(30),
udaan(#     CONSTRAINT status_chk CHECK (vsession_status IN ('Scheduled', 'Completed', 'Cancelled')),
udaan(#     CONSTRAINT type_chk CHECK (vsession_type IN ('Hybrid', 'Offline'))
udaan(# );
CREATE TABLE
udaan=# INSERT INTO volunteersession (volunteer_session_date, purpose, outcome, vsession_type, vsession_status)
udaan-# VALUES
udaan-#     ('2025-02-01', 'Soft Skills Training', 'Successful', 'Offline', 'Completed'),
udaan-#     ('2025-02-05', 'Group Activities', 'Positive Response', 'Offline', 'Completed'),
udaan-#     ('2025-02-07', 'Art Therapy Workshop', 'In Progress', 'Offline', 'Scheduled'),
udaan-#     ('2025-02-10', 'Public Speaking Session', 'Successful', 'Offline', 'Completed'),
udaan-#     ('2025-02-12', 'Sports Training Camp', 'Ongoing', 'Offline', 'Scheduled'),
udaan-#     ('2025-02-14', 'Dance Therapy Class', 'Cancelled', 'Offline', 'Cancelled'),
udaan-#     ('2025-02-16', 'Storytelling Workshop', 'Great Feedback', 'Offline', 'Completed'),
udaan-#     ('2025-02-18', 'Music Lessons', 'In Progress', 'Offline', 'Scheduled'),
udaan-#     ('2025-02-20', 'Leadership Skills Training', 'Excellent Progress', 'Offline', 'Completed'),
udaan-#     ('2025-02-22', 'Cooking Class', 'Positive Outcome', 'Offline', 'Completed');
INSERT 0 10
udaan=# CREATE TABLE sponsor (
udaan(#     sponsor_id SERIAL PRIMARY KEY,
udaan(#     sponsor_name VARCHAR(30) NOT NULL,
udaan(#     sponsor_contact VARCHAR(15) NOT NULL,
udaan(#     sponsor_email VARCHAR(30) NOT NULL,
udaan(#     pan_number VARCHAR(15) NOT NULL,
udaan(#     amt NUMERIC(10, 2) NOT NULL,
udaan(#     address TEXT NOT NULL, -- Flat No. and Street combined
udaan(#     pincode VARCHAR(6) NOT NULL,
udaan(#     city VARCHAR(50) NOT NULL,
udaan(#     state VARCHAR(50) NOT NULL,
udaan(#     CONSTRAINT chk_pan CHECK (pan_number ~ '^[A-Z]{5}\d{4}[A-Z]{1}$'),  -- PAN number format
udaan(#     CONSTRAINT chk_contact CHECK (sponsor_contact ~ '^\d{10}$'),
udaan(#     CONSTRAINT chk_email CHECK (sponsor_email ~ '^[^@]+@[^@]+$'),
udaan(#     CONSTRAINT chk_pincode CHECK (pincode ~ '^\d{6}$') -- Ensuring valid 6-digit pincode
udaan(# );
CREATE TABLE
udaan=# INSERT INTO sponsor (sponsor_name, sponsor_contact, sponsor_email, pan_number, amt, address, pincode, city, state)
udaan-# VALUES
udaan-#     ('Reliance Foundation', '9812345678', 'reliance@example.com', 'ABCDE1234F', 50000.00, 'Flat 101, Gokul Heights, Baner', '411045', 'Pune', 'Maharashtra'),
udaan-#     ('Mr. Ravi Kumar', '9823456789', 'ravi.kumar@example.com', 'FGHIJ5678K', 20000.00, 'Building 4B, MG Road, Camp', '411001', 'Pune', 'Maharashtra'),
udaan-#     ('Infosys Foundation', '9876543210', 'infosys@example.com', 'PQRST5678L', 70000.00, 'Tower 2, Hinjawadi Phase 3', '411057', 'Pune', 'Maharashtra'),
udaan-#     ('Tata Trust', '9019876543', 'tata@example.com', 'LMNOP1234A', 60000.00, 'Flat 402, Koregaon Park', '411001', 'Pune', 'Maharashtra'),
udaan-#     ('Mrs. Anjali Sharma', '9123987654', 'anjali.sharma@example.com', 'WXYZC4567B', 15000.00, 'Wing A, Magarpatta City', '411028', 'Pune', 'Maharashtra'),
udaan-#     ('HDFC CSR', '9002345678', 'hdfc@example.com', 'EFGHI7890C', 45000.00, 'Flat 12, Law College Road', '411004', 'Pune', 'Maharashtra'),
udaan-#     ('Dr. Ramesh Kumar', '9123456780', 'ramesh.kumar@example.com', 'HIJKL2345D', 25000.00, 'Building 5, Viman Nagar', '411014', 'Pune', 'Maharashtra'),
udaan-#     ('Ashok Leyland', '9109876543', 'ashok@example.com', 'ABCDE9876F', 30000.00, 'Wing B, Powai', '400076', 'Mumbai', 'Maharashtra');
INSERT 0 8
udaan=# CREATE TABLE sponsorship (
udaan(#     sponsorship_id SERIAL PRIMARY KEY,
udaan(#     sponsorship_type VARCHAR(20),
udaan(#     sponsorship_amt NUMERIC(10,2),
udaan(#     sponsor_id INT,
udaan(#     CONSTRAINT fk_sponsor FOREIGN KEY (sponsor_id)
udaan(#         REFERENCES sponsor(sponsor_id)
udaan(#         ON DELETE CASCADE
udaan(#         ON UPDATE CASCADE
udaan(# );
CREATE TABLE
udaan=# INSERT INTO sponsorship (sponsorship_type, sponsorship_amt, sponsor_id)
udaan-# VALUES
udaan-#     ('Event', 20000.00, 1),///
udaan-#     ('Scholarship', 15000.00, 2),
udaan-#     ('Healthcare', 30000.00, 3),
udaan-#     ('Education', 40000.00, 4),
udaan-#     ('Infrastructure', 25000.00, 5),
udaan-#     ('Scholarship', 15000.00, 6),
udaan-#     ('Event', 20000.00, 7),
udaan-#     ('Education', 35000.00, 8),
udaan-#     ('Healthcare', 30000.00, 9),
udaan-#     ('Event', 25000.00, 10);
ERROR:  syntax error at or near "///"
LINE 3:     ('Event', 20000.00, 1),///
                                   ^
udaan=# INSERT INTO sponsorship (sponsorship_type, sponsorship_amt, sponsor_id)
udaan-# VALUES
udaan-#     ('Event', 20000.00, 1),
udaan-#     ('Scholarship', 15000.00, 2),
udaan-#     ('Healthcare', 30000.00, 3),
udaan-#     ('Education', 40000.00, 4),
udaan-#     ('Infrastructure', 25000.00, 5),
udaan-#     ('Scholarship', 15000.00, 6),
udaan-#     ('Event', 20000.00, 7),
udaan-#     ('Education', 35000.00, 8),
udaan-#     ('Healthcare', 30000.00, 9),
udaan-#     ('Event', 25000.00, 10);
ERROR:  insert or update on table "sponsorship" violates foreign key constraint "fk_sponsor"
DETAIL:  Key (sponsor_id)=(9) is not present in table "sponsor".
udaan=# SELECT * FROM sponsor;
 sponsor_id |    sponsor_name     | sponsor_contact |       sponsor_email       | pan_number |   amt    |            address             | pincode |  city  |    state
------------+---------------------+-----------------+---------------------------+------------+----------+--------------------------------+---------+--------+-------------
          1 | Reliance Foundation | 9812345678      | reliance@example.com      | ABCDE1234F | 50000.00 | Flat 101, Gokul Heights, Baner | 411045  | Pune   | Maharashtra
          2 | Mr. Ravi Kumar      | 9823456789      | ravi.kumar@example.com    | FGHIJ5678K | 20000.00 | Building 4B, MG Road, Camp     | 411001  | Pune   | Maharashtra
          3 | Infosys Foundation  | 9876543210      | infosys@example.com       | PQRST5678L | 70000.00 | Tower 2, Hinjawadi Phase 3     | 411057  | Pune   | Maharashtra
          4 | Tata Trust          | 9019876543      | tata@example.com          | LMNOP1234A | 60000.00 | Flat 402, Koregaon Park        | 411001  | Pune   | Maharashtra
          5 | Mrs. Anjali Sharma  | 9123987654      | anjali.sharma@example.com | WXYZC4567B | 15000.00 | Wing A, Magarpatta City        | 411028  | Pune   | Maharashtra
          6 | HDFC CSR            | 9002345678      | hdfc@example.com          | EFGHI7890C | 45000.00 | Flat 12, Law College Road      | 411004  | Pune   | Maharashtra
          7 | Dr. Ramesh Kumar    | 9123456780      | ramesh.kumar@example.com  | HIJKL2345D | 25000.00 | Building 5, Viman Nagar        | 411014  | Pune   | Maharashtra
          8 | Ashok Leyland       | 9109876543      | ashok@example.com         | ABCDE9876F | 30000.00 | Wing B, Powai                  | 400076  | Mumbai | Maharashtra
(8 rows)


udaan=# INSERT INTO sponsorship (sponsorship_type, sponsorship_amt, sponsor_id)
udaan-# VALUES
udaan-#     ('Event', 20000.00, 1),
udaan-#     ('Scholarship', 15000.00, 2),
udaan-#     ('Healthcare', 30000.00, 3),
udaan-#     ('Education', 40000.00, 4),
udaan-#     ('Infrastructure', 25000.00, 5),
udaan-#     ('Scholarship', 15000.00, 6),
udaan-#     ('Event', 20000.00, 7),
udaan-#     ('Education', 35000.00, 8);
INSERT 0 8
udaan=# SELECT * FROM sponsorship;
 sponsorship_id | sponsorship_type | sponsorship_amt | sponsor_id
----------------+------------------+-----------------+------------
             11 | Event            |        20000.00 |          1
             12 | Scholarship      |        15000.00 |          2
             13 | Healthcare       |        30000.00 |          3
             14 | Education        |        40000.00 |          4
             15 | Infrastructure   |        25000.00 |          5
             16 | Scholarship      |        15000.00 |          6
             17 | Event            |        20000.00 |          7
             18 | Education        |        35000.00 |          8
(8 rows)


udaan=# SELECT * FROM sponsor;
 sponsor_id |    sponsor_name     | sponsor_contact |       sponsor_email       | pan_number |   amt    |            address             | pincode |  city  |    state
------------+---------------------+-----------------+---------------------------+------------+----------+--------------------------------+---------+--------+-------------
          1 | Reliance Foundation | 9812345678      | reliance@example.com      | ABCDE1234F | 50000.00 | Flat 101, Gokul Heights, Baner | 411045  | Pune   | Maharashtra
          2 | Mr. Ravi Kumar      | 9823456789      | ravi.kumar@example.com    | FGHIJ5678K | 20000.00 | Building 4B, MG Road, Camp     | 411001  | Pune   | Maharashtra
          3 | Infosys Foundation  | 9876543210      | infosys@example.com       | PQRST5678L | 70000.00 | Tower 2, Hinjawadi Phase 3     | 411057  | Pune   | Maharashtra
          4 | Tata Trust          | 9019876543      | tata@example.com          | LMNOP1234A | 60000.00 | Flat 402, Koregaon Park        | 411001  | Pune   | Maharashtra
          5 | Mrs. Anjali Sharma  | 9123987654      | anjali.sharma@example.com | WXYZC4567B | 15000.00 | Wing A, Magarpatta City        | 411028  | Pune   | Maharashtra
          6 | HDFC CSR            | 9002345678      | hdfc@example.com          | EFGHI7890C | 45000.00 | Flat 12, Law College Road      | 411004  | Pune   | Maharashtra
          7 | Dr. Ramesh Kumar    | 9123456780      | ramesh.kumar@example.com  | HIJKL2345D | 25000.00 | Building 5, Viman Nagar        | 411014  | Pune   | Maharashtra
          8 | Ashok Leyland       | 9109876543      | ashok@example.com         | ABCDE9876F | 30000.00 | Wing B, Powai                  | 400076  | Mumbai | Maharashtra
(8 rows)


udaan=# CREATE TABLE child_sponsorship (
udaan(#     child_sponsorship_id SERIAL PRIMARY KEY,
udaan(#     enrol_id INT NOT NULL,
udaan(#     sponsorship_id INT NOT NULL,
udaan(#     sponsorship_date DATE NOT NULL,
udaan(#     sponsorship_status VARCHAR(20) CHECK (sponsorship_status IN ('Active', 'Expired', 'Pending')),
udaan(#     CONSTRAINT fk_child FOREIGN KEY (enrol_id) REFERENCES child(enrol_id) ON DELETE CASCADE ON UPDATE CASCADE,
udaan(#     CONSTRAINT fk_sponsorship FOREIGN KEY (sponsorship_id) REFERENCES sponsorship(sponsorship_id) ON DELETE CASCADE ON UPDATE CASCADE
udaan(# );
CREATE TABLE
udaan=# DROP TABLE sponsorship CASCADE ;
NOTICE:  drop cascades to constraint fk_sponsorship on table child_sponsorship
DROP TABLE
udaan=# DROP TABLE child_sponsorship CASCADE ;
DROP TABLE
udaan=# CREATE TABLE sponsorship (
udaan(#     sponsorship_id SERIAL PRIMARY KEY,
udaan(#     sponsorship_type VARCHAR(20),
udaan(#     sponsorship_amt NUMERIC(10,2),
udaan(#     sponsor_id INT,
udaan(#     CONSTRAINT fk_sponsor FOREIGN KEY (sponsor_id)
udaan(#         REFERENCES sponsor(sponsor_id)
udaan(#         ON DELETE CASCADE
udaan(#         ON UPDATE CASCADE
udaan(# );
CREATE TABLE
udaan=# INSERT INTO sponsorship (sponsorship_type, sponsorship_amt, sponsor_id)
udaan-# VALUES
udaan-#     ('Event', 20000.00, 1),
udaan-#     ('Scholarship', 15000.00, 2),
udaan-#     ('Healthcare', 30000.00, 3),
udaan-#     ('Education', 40000.00, 4),
udaan-#     ('Infrastructure', 25000.00, 5),
udaan-#     ('Scholarship', 15000.00, 6),
udaan-#     ('Event', 20000.00, 7),
udaan-#     ('Education', 35000.00, 8);
INSERT 0 8
udaan=# SELECT * FROM sponsorship;
 sponsorship_id | sponsorship_type | sponsorship_amt | sponsor_id
----------------+------------------+-----------------+------------
              1 | Event            |        20000.00 |          1
              2 | Scholarship      |        15000.00 |          2
              3 | Healthcare       |        30000.00 |          3
              4 | Education        |        40000.00 |          4
              5 | Infrastructure   |        25000.00 |          5
              6 | Scholarship      |        15000.00 |          6
              7 | Event            |        20000.00 |          7
              8 | Education        |        35000.00 |          8
(8 rows)


udaan=# SELECT * FROM sponsorship;
 sponsorship_id | sponsorship_type | sponsorship_amt | sponsor_id
----------------+------------------+-----------------+------------
              1 | Event            |        20000.00 |          1
              2 | Scholarship      |        15000.00 |          2
              3 | Healthcare       |        30000.00 |          3
              4 | Education        |        40000.00 |          4
              5 | Infrastructure   |        25000.00 |          5
              6 | Scholarship      |        15000.00 |          6
              7 | Event            |        20000.00 |          7
              8 | Education        |        35000.00 |          8
(8 rows)


udaan=# SELECT * guardian;
ERROR:  syntax error at or near "guardian"
LINE 1: SELECT * guardian;
                 ^
udaan=# SELECT * FROM guardian;
 guardian_id |       name        |  contact   | rel_with_child |   address
-------------+-------------------+------------+----------------+-------------
           1 | Anjali Trust      | 9012345678 | NGO            | Pune, India
           2 | Ashray Foundation | 9876098765 | NGO            | Pune, India
           3 | Maitra Foundation | 9901234567 | NGO            | Pune, India
           4 | Saheli Foundation | 9091238765 | NGO            | Pune, India
           5 | Jeevan NGO        | 9212345678 | NGO            | Pune, India
           6 | Prerna NGO        | 9019876543 | NGO            | Pune, India
           7 | Sarita Devi       | 9098765432 | Mother         | Pune, India
           8 | Manju Devi        | 9054321890 | Mother         | Pune, India
           9 | Priya Kamble      | 9321456789 | Mother         | Pune, India
          10 | Radha Kumari      | 9123456780 | Mother         | Pune, India
(10 rows)


udaan=# SELECT * FROM child;
 enrol_id | child_name | gender |    dob     |     edu_level      | emo_status |  career_asp  | guardian_id | skills_interest
----------+------------+--------+------------+--------------------+------------+--------------+-------------+-----------------
        1 | Aarav      | Male   | 2011-05-15 | Secondary          | Stable     | Engineer     |           1 |
        2 | Riya       | Female | 2012-03-20 | Secondary          | Anxious    | Doctor       |           2 |
        3 | Kabir      | Male   | 2011-07-10 | Secondary          | Improving  | Scientist    |           1 |
        4 | Ishita     | Female | 2009-08-25 | High School        | Stable     | Teacher      |           2 |
        5 | Aditya     | Male   | 2010-11-02 | High School        | Stable     | Pilot        |           3 |
        6 | Nisha      | Female | 2011-12-15 | Secondary          | Anxious    | Artist       |           5 |
        7 | Ayaan      | Male   | 2005-09-18 | College/University | Stable     | Entrepreneur |           7 |
        8 | Pooja      | Female | 2008-01-10 | High School        | Stable     | Psychologist |           8 |
        9 | Kartik     | Male   | 2007-05-22 | High School        | Improving  | Engineer     |           9 |
       10 | Simran     | Female | 2012-06-30 | Secondary          | Stable     | Dancer       |           4 |
       11 | Romil      | Male   | 2011-12-12 | Secondary          | Stable     | Scientist    |           5 |
       12 | Anika      | Female | 2004-03-05 | College/University | Improving  | Dancer       |           3 |
       13 | Aryan      | Male   | 2011-07-09 | Secondary          | Stable     | Pilot        |           2 |
       14 | Meera      | Female | 2009-11-21 | High School        | Improving  | Engineer     |           4 |
       15 | Raju       | Male   | 2005-06-03 | College/University | Stable     | Engineer     |           5 |
       16 | Shrikant   | Male   | 2007-09-06 | High School        | Improving  | Engineer     |          10 |
(16 rows)


udaan=# SELECT * FROM mentor;
 mentor_id |   mentor_name    |       expertise       | mentor_avail |       mentor_email        | contact_no
-----------+------------------+-----------------------+--------------+---------------------------+------------
         1 | Dr. Meera Sharma | Psychiatry            | Offline      | meera.sharma@example.com  | 9876501234
         2 | Arjun Patel      | Career Counselling    | Offline      | arjun.patel@example.com   | 9123456789
         3 | Neha Singh       | Behavioral Therapy    | Hybrid       | neha.singh@example.com    | 9812345678
         4 | Pooja Sharma     | Career Guidance       | Hybrid       | pooja.sharma@example.com  | 9832145678
         5 | Sanjay Verma     | Education Counselling | Offline      | sanjay.verma@example.com  | 9743126589
         6 | Anjali Mehta     | Soft Skills Training  | Offline      | anjali.mehta@example.com  | 9598765432
         7 | Dr. Ramesh Gupta | Psychiatry            | Hybrid       | ramesh.gupta@example.com  | 9101234567
         8 | Sneha Roy        | Child Development     | Offline      | sneha.roy@example.com     | 9823145670
         9 | Manish Kapoor    | Motivational Coaching | Offline      | manish.kapoor@example.com | 9123987654
(9 rows)


udaan=# SELECT * FROM volunteer;
 volunteer_id |    full_name    | age | gender |       volunteer_email       | volunteer_contact |         skills         |              interest               | volunteer_avail | experience | reason
--------------+-----------------+-----+--------+-----------------------------+-------------------+------------------------+-------------------------------------+-----------------+------------+--------
            1 | Kavya Desai     |  25 | Female | kavya.desai@example.com     | 9001234567        | Soft Skills            | Teaching, Communication             | Weekends        |            |
            2 | Rohan Gupta     |  30 | Male   | rohan.gupta@example.com     | 8987654321        | Group Activities       | Event Management, Team Building     | Flexible        |            |
            3 | Aditi Rao       |  27 | Female | aditi.rao@example.com       | 9012345678        | Art Therapy            | Creative Workshops, Therapy Support | Weekdays        |            |
            4 | Akshay Jain     |  28 | Male   | akshay.jain@example.com     | 9098765432        | Public Speaking        | Debate, Presentation Coaching       | Flexible        |            |
            5 | Naina Singh     |  24 | Female | naina.singh@example.com     | 9087654321        | Sports Training        | Fitness, Coaching                   | Weekends        |            |
            6 | Ravi Shankar    |  35 | Male   | ravi.shankar@example.com    | 9009876543        | Dance and Yoga Therapy | Mindfulness, Physical Fitness       | Weekdays        |            |
            7 | Priya Nair      |  29 | Female | priya.nair@example.com      | 9123456789        | Storytelling           | Creative Writing, Theatre           | Flexible        |            |
            8 | Rajesh Sharma   |  32 | Male   | rajesh.sharma@example.com   | 9034567890        | Music Lessons          | Instrumental, Vocal Training        | Weekends        |            |
            9 | Ankit Mehta     |  26 | Male   | ankit.mehta@example.com     | 9091234567        | Leadership Skills      | Public Speaking, Management         | Flexible        |            |
           10 | Shreya Kulkarni |  31 | Female | shreya.kulkarni@example.com | 9076543210        | Cooking Classes        | Nutrition, Healthy Eating           | Weekdays        |            |
(10 rows)


udaan=# SELECT * FROM mentorsession;
 mentor_session_id | mentor_session_date |       focus_area       |       outcome       | msession_type | msession_status
-------------------+---------------------+------------------------+---------------------+---------------+-----------------
                 1 | 2025-02-01          | Career Counselling     | In Progress         | Offline       | Scheduled
                 2 | 2025-02-03          | Behavioral Therapy     | Positive Outcome    | Offline       | Completed
                 3 | 2025-02-07          | Education Counselling  | Needs Follow-up     | Offline       | Scheduled
                 4 | 2025-02-10          | Child Development      | Successful          | Offline       | Completed
                 5 | 2025-02-12          | Motivational Coaching  | Continued Support   | Hybrid        | Completed
                 6 | 2025-02-14          | Career Guidance        | Positive Feedback   | Hybrid        | Completed
                 7 | 2025-02-15          | Soft Skills Training   | In Progress         | Hybrid        | Scheduled
                 8 | 2025-02-17          | Life Coaching          | Ongoing Support     | Offline       | Scheduled
                 9 | 2025-02-18          | Leadership Development | Excellent Progress  | Hybrid        | Completed
                10 | 2025-02-20          | Stress Management      | Improved Well-being | Offline       | Completed
(10 rows)


udaan=# SELECT * FROM volunteersession;
 volunteer_session_id | volunteer_session_date |          purpose           |      outcome       | vsession_type | vsession_status
----------------------+------------------------+----------------------------+--------------------+---------------+-----------------
                    1 | 2025-02-01             | Soft Skills Training       | Successful         | Offline       | Completed
                    2 | 2025-02-05             | Group Activities           | Positive Response  | Offline       | Completed
                    3 | 2025-02-07             | Art Therapy Workshop       | In Progress        | Offline       | Scheduled
                    4 | 2025-02-10             | Public Speaking Session    | Successful         | Offline       | Completed
                    5 | 2025-02-12             | Sports Training Camp       | Ongoing            | Offline       | Scheduled
                    6 | 2025-02-14             | Dance Therapy Class        | Cancelled          | Offline       | Cancelled
                    7 | 2025-02-16             | Storytelling Workshop      | Great Feedback     | Offline       | Completed
                    8 | 2025-02-18             | Music Lessons              | In Progress        | Offline       | Scheduled
                    9 | 2025-02-20             | Leadership Skills Training | Excellent Progress | Offline       | Completed
                   10 | 2025-02-22             | Cooking Class              | Positive Outcome   | Offline       | Completed
(10 rows)


udaan=# SELECT * FROM sponsor;
 sponsor_id |    sponsor_name     | sponsor_contact |       sponsor_email       | pan_number |   amt    |            address             | pincode |  city  |    state
------------+---------------------+-----------------+---------------------------+------------+----------+--------------------------------+---------+--------+-------------
          1 | Reliance Foundation | 9812345678      | reliance@example.com      | ABCDE1234F | 50000.00 | Flat 101, Gokul Heights, Baner | 411045  | Pune   | Maharashtra
          2 | Mr. Ravi Kumar      | 9823456789      | ravi.kumar@example.com    | FGHIJ5678K | 20000.00 | Building 4B, MG Road, Camp     | 411001  | Pune   | Maharashtra
          3 | Infosys Foundation  | 9876543210      | infosys@example.com       | PQRST5678L | 70000.00 | Tower 2, Hinjawadi Phase 3     | 411057  | Pune   | Maharashtra
          4 | Tata Trust          | 9019876543      | tata@example.com          | LMNOP1234A | 60000.00 | Flat 402, Koregaon Park        | 411001  | Pune   | Maharashtra
          5 | Mrs. Anjali Sharma  | 9123987654      | anjali.sharma@example.com | WXYZC4567B | 15000.00 | Wing A, Magarpatta City        | 411028  | Pune   | Maharashtra
          6 | HDFC CSR            | 9002345678      | hdfc@example.com          | EFGHI7890C | 45000.00 | Flat 12, Law College Road      | 411004  | Pune   | Maharashtra
          7 | Dr. Ramesh Kumar    | 9123456780      | ramesh.kumar@example.com  | HIJKL2345D | 25000.00 | Building 5, Viman Nagar        | 411014  | Pune   | Maharashtra
          8 | Ashok Leyland       | 9109876543      | ashok@example.com         | ABCDE9876F | 30000.00 | Wing B, Powai                  | 400076  | Mumbai | Maharashtra
(8 rows)


udaan=# SELECT * FROM sponsorship;
 sponsorship_id | sponsorship_type | sponsorship_amt | sponsor_id
----------------+------------------+-----------------+------------
              1 | Event            |        20000.00 |          1
              2 | Scholarship      |        15000.00 |          2
              3 | Healthcare       |        30000.00 |          3
              4 | Education        |        40000.00 |          4
              5 | Infrastructure   |        25000.00 |          5
              6 | Scholarship      |        15000.00 |          6
              7 | Event            |        20000.00 |          7
              8 | Education        |        35000.00 |          8
(8 rows)


udaan=# CREATE TABLE child_sponsorship (
udaan(#     child_sponsorship_id SERIAL PRIMARY KEY,
udaan(#     enrol_id INT NOT NULL,
udaan(#     sponsorship_id INT NOT NULL,
udaan(#     sponsorship_date DATE NOT NULL,
udaan(#     sponsorship_status VARCHAR(20) CHECK (sponsorship_status IN ('Active', 'Expired', 'Pending')),
udaan(#     CONSTRAINT fk_child FOREIGN KEY (enrol_id) REFERENCES child(enrol_id) ON DELETE CASCADE ON UPDATE CASCADE,
udaan(#     CONSTRAINT fk_sponsorship FOREIGN KEY (sponsorship_id) REFERENCES sponsorship(sponsorship_id) ON DELETE CASCADE ON UPDATE CASCADE
udaan(# );
CREATE TABLE
udaan=# INSERT INTO child_sponsorship (enrol_id, sponsorship_id, sponsorship_date, sponsorship_status)
udaan-# VALUES
udaan-#     (1, 1, '2025-01-01', 'Active'),
udaan-#     (2, 2, '2025-01-05', 'Pending'),
udaan-#     (3, 3, '2025-01-10', 'Expired'),
udaan-#     (4, 4, '2025-01-15', 'Active'),
udaan-#     (5, 5, '2025-01-20', 'Pending'),
udaan-#     (6, 6, '2025-01-25', 'Active'),
udaan-#     (7, 7, '2025-01-30', 'Expired'),
udaan-#     (8, 8, '2025-02-01', 'Pending'),
udaan-#     (9, 9, '2025-02-05', 'Active'),
udaan-#     (10, 10, '2025-02-10', 'Active'),
udaan-#     (11, 1, '2025-02-12', 'Active'),
udaan-#     (12, 2, '2025-02-14', 'Expired'),
udaan-#     (13, 3, '2025-02-16', 'Pending'),
udaan-#     (14, 4, '2025-02-18', 'Active'),
udaan-#     (15, 5, '2025-02-20', 'Active'),
udaan-#     (16, 6, '2025-02-22', 'Pending');
ERROR:  insert or update on table "child_sponsorship" violates foreign key constraint "fk_sponsorship"
DETAIL:  Key (sponsorship_id)=(9) is not present in table "sponsorship".
udaan=# INSERT INTO child_sponsorship (enrol_id, sponsorship_id, sponsorship_date, sponsorship_status)
udaan-# VALUES
udaan-#     (1, 1, '2025-01-01', 'Active'),
udaan-#     (2, 2, '2025-01-05', 'Pending'),
udaan-#     (3, 3, '2025-01-10', 'Expired'),
udaan-#     (4, 4, '2025-01-15', 'Active'),
udaan-#     (5, 5, '2025-01-20', 'Pending'),
udaan-#     (6, 6, '2025-01-25', 'Active'),
udaan-#     (7, 7, '2025-01-30', 'Expired'),
udaan-#     (8, 8, '2025-02-01', 'Pending'),
udaan-#     (9, 8, '2025-02-05', 'Active'),
udaan-#     (10, 7, '2025-02-10', 'Active'),
udaan-#     (11, 1, '2025-02-12', 'Active'),
udaan-#     (12, 2, '2025-02-14', 'Expired'),
udaan-#     (13, 3, '2025-02-16', 'Pending'),
udaan-#     (14, 4, '2025-02-18', 'Active'),
udaan-#     (15, 5, '2025-02-20', 'Active'),
udaan-#     (16, 6, '2025-02-22', 'Pending');
INSERT 0 16
udaan=# SELECT * FROM child_sponsorship;
 child_sponsorship_id | enrol_id | sponsorship_id | sponsorship_date | sponsorship_status
----------------------+----------+----------------+------------------+--------------------
                   17 |        1 |              1 | 2025-01-01       | Active
                   18 |        2 |              2 | 2025-01-05       | Pending
                   19 |        3 |              3 | 2025-01-10       | Expired
                   20 |        4 |              4 | 2025-01-15       | Active
                   21 |        5 |              5 | 2025-01-20       | Pending
                   22 |        6 |              6 | 2025-01-25       | Active
                   23 |        7 |              7 | 2025-01-30       | Expired
                   24 |        8 |              8 | 2025-02-01       | Pending
                   25 |        9 |              8 | 2025-02-05       | Active
                   26 |       10 |              7 | 2025-02-10       | Active
                   27 |       11 |              1 | 2025-02-12       | Active
                   28 |       12 |              2 | 2025-02-14       | Expired
                   29 |       13 |              3 | 2025-02-16       | Pending
                   30 |       14 |              4 | 2025-02-18       | Active
                   31 |       15 |              5 | 2025-02-20       | Active
                   32 |       16 |              6 | 2025-02-22       | Pending
(16 rows)


udaan=# DROP TABLE child_sponsorship CASCADE;
DROP TABLE
udaan=# CREATE TABLE child_sponsorship (
udaan(#     child_sponsorship_id SERIAL PRIMARY KEY,
udaan(#     enrol_id INT NOT NULL,
udaan(#     sponsorship_id INT NOT NULL,
udaan(#     sponsorship_date DATE NOT NULL,
udaan(#     sponsorship_status VARCHAR(20) CHECK (sponsorship_status IN ('Active', 'Expired', 'Pending')),
udaan(#     CONSTRAINT fk_child FOREIGN KEY (enrol_id) REFERENCES child(enrol_id) ON DELETE CASCADE ON UPDATE CASCADE,
udaan(#     CONSTRAINT fk_sponsorship FOREIGN KEY (sponsorship_id) REFERENCES sponsorship(sponsorship_id) ON DELETE CASCADE ON UPDATE CASCADE
udaan(# );
CREATE TABLE
udaan=# INSERT INTO child_sponsorship (enrol_id, sponsorship_id, sponsorship_date, sponsorship_status)
udaan-# VALUES
udaan-#     (1, 1, '2025-01-01', 'Active'),
udaan-#     (2, 2, '2025-01-05', 'Pending'),
udaan-#     (3, 3, '2025-01-10', 'Expired'),
udaan-#     (4, 4, '2025-01-15', 'Active'),
udaan-#     (5, 5, '2025-01-20', 'Pending'),
udaan-#     (6, 6, '2025-01-25', 'Active'),
udaan-#     (7, 7, '2025-01-30', 'Expired'),
udaan-#     (8, 8, '2025-02-01', 'Pending'),
udaan-#     (9, 8, '2025-02-05', 'Active'),
udaan-#     (10, 7, '2025-02-10', 'Active'),
udaan-#     (11, 1, '2025-02-12', 'Active'),
udaan-#     (12, 2, '2025-02-14', 'Expired'),
udaan-#     (13, 3, '2025-02-16', 'Pending'),
udaan-#     (14, 4, '2025-02-18', 'Active'),
udaan-#     (15, 5, '2025-02-20', 'Active'),
udaan-#     (16, 6, '2025-02-22', 'Pending');
INSERT 0 16
udaan=# SELECT * FROM child_sponsorship;
 child_sponsorship_id | enrol_id | sponsorship_id | sponsorship_date | sponsorship_status
----------------------+----------+----------------+------------------+--------------------
                    1 |        1 |              1 | 2025-01-01       | Active
                    2 |        2 |              2 | 2025-01-05       | Pending
                    3 |        3 |              3 | 2025-01-10       | Expired
                    4 |        4 |              4 | 2025-01-15       | Active
                    5 |        5 |              5 | 2025-01-20       | Pending
                    6 |        6 |              6 | 2025-01-25       | Active
                    7 |        7 |              7 | 2025-01-30       | Expired
                    8 |        8 |              8 | 2025-02-01       | Pending
                    9 |        9 |              8 | 2025-02-05       | Active
                   10 |       10 |              7 | 2025-02-10       | Active
                   11 |       11 |              1 | 2025-02-12       | Active
                   12 |       12 |              2 | 2025-02-14       | Expired
                   13 |       13 |              3 | 2025-02-16       | Pending
                   14 |       14 |              4 | 2025-02-18       | Active
                   15 |       15 |              5 | 2025-02-20       | Active
                   16 |       16 |              6 | 2025-02-22       | Pending
(16 rows)


udaan=# CREATE TABLE child_mentorSession (
udaan(#     child_mentor_session_id SERIAL PRIMARY KEY,
udaan(#     enrol_id INT NOT NULL,
udaan(#     mentor_session_id INT NOT NULL,
udaan(#     participation_status VARCHAR(20) CHECK (participation_status IN ('Attended', 'Missed')),
udaan(#     feedback VARCHAR(20) CHECK (feedback IN ('Satisfactory', 'Unsatisfactory', 'Needs Improvement')),
udaan(#     CONSTRAINT fk_child FOREIGN KEY (enrol_id) REFERENCES child(enrol_id) ON DELETE CASCADE ON UPDATE CASCADE,
udaan(#     CONSTRAINT fk_mentor_session FOREIGN KEY (mentor_session_id) REFERENCES mentorSession(mentor_session_id) ON DELETE CASCADE ON UPDATE CASCADE
udaan(# );
CREATE TABLE
udaan=# INSERT INTO child_mentorSession (enrol_id, mentor_session_id, participation_status, feedback)
udaan-# VALUES
udaan-#     (1, 1, 'Attended', 'Satisfactory'),
udaan-#     (2, 2, 'Missed', 'Needs Improvement'),
udaan-#     (3, 3, 'Attended', 'Satisfactory'),
udaan-#     (4, 4, 'Attended', 'Satisfactory'),
udaan-#     (5, 5, 'Missed', 'Unsatisfactory'),
udaan-#     (6, 6, 'Attended', 'Needs Improvement'),
udaan-#     (7, 7, 'Attended', 'Satisfactory'),
udaan-#     (8, 8, 'Missed', 'Needs Improvement'),
udaan-#     (9, 9, 'Attended', 'Satisfactory'),
udaan-#     (10, 10, 'Attended', 'Satisfactory');
INSERT 0 10
udaan=# SELECT * FROM child_mentorsession;
 child_mentor_session_id | enrol_id | mentor_session_id | participation_status |     feedback
-------------------------+----------+-------------------+----------------------+-------------------
                       1 |        1 |                 1 | Attended             | Satisfactory
                       2 |        2 |                 2 | Missed               | Needs Improvement
                       3 |        3 |                 3 | Attended             | Satisfactory
                       4 |        4 |                 4 | Attended             | Satisfactory
                       5 |        5 |                 5 | Missed               | Unsatisfactory
                       6 |        6 |                 6 | Attended             | Needs Improvement
                       7 |        7 |                 7 | Attended             | Satisfactory
                       8 |        8 |                 8 | Missed               | Needs Improvement
                       9 |        9 |                 9 | Attended             | Satisfactory
                      10 |       10 |                10 | Attended             | Satisfactory
(10 rows)


udaan=# CREATE TABLE child_volunteerSession (
udaan(#     child_volunteer_session_id SERIAL PRIMARY KEY,
udaan(#     enrol_id INT NOT NULL,
udaan(#     volunteer_session_id INT NOT NULL,
udaan(#     participation_status VARCHAR(20) CHECK (participation_status IN ('Attended', 'Missed')),
udaan(#     feedback VARCHAR(20) CHECK (feedback IN ('Satisfactory', 'Unsatisfactory', 'Needs Improvement')),
udaan(#     CONSTRAINT fk_child FOREIGN KEY (enrol_id) REFERENCES child(enrol_id) ON DELETE CASCADE ON UPDATE CASCADE,
udaan(#     CONSTRAINT fk_volunteer_session FOREIGN KEY (volunteer_session_id) REFERENCES volunteerSession(volunteer_session_id) ON DELETE CASCADE ON UPDATE CASCADE
udaan(# );
CREATE TABLE
udaan=# INSERT INTO child_volunteerSession (enrol_id, volunteer_session_id, participation_status, feedback)
udaan-# VALUES
udaan-#     (1, 1, 'Attended', 'Satisfactory'),
udaan-#     (2, 2, 'Missed', 'Unsatisfactory'),
udaan-#     (3, 3, 'Attended', 'Needs Improvement'),
udaan-#     (4, 4, 'Attended', 'Satisfactory'),
udaan-#     (5, 5, 'Missed', 'Unsatisfactory'),
udaan-#     (6, 6, 'Attended', 'Satisfactory'),
udaan-#     (7, 7, 'Attended', 'Satisfactory'),
udaan-#     (8, 8, 'Missed', 'Needs Improvement'),
udaan-#     (9, 9, 'Attended', 'Satisfactory'),
udaan-#     (10, 10, 'Missed', 'Unsatisfactory');
INSERT 0 10
udaan=#
udaan=# CREATE TABLE volunteer_volunteerSession (
udaan(#     volunteer_volunteer_session_id SERIAL PRIMARY KEY,
udaan(#     volunteer_id INT NOT NULL,
udaan(#     volunteer_session_id INT NOT NULL,
udaan(#     role VARCHAR(50),
udaan(#     CONSTRAINT fk_volunteer FOREIGN KEY (volunteer_id) REFERENCES volunteer(volunteer_id) ON DELETE CASCADE ON UPDATE CASCADE,
udaan(#     CONSTRAINT fk_volunteer_session FOREIGN KEY (volunteer_session_id) REFERENCES volunteerSession(volunteer_session_id) ON DELETE CASCADE ON UPDATE CASCADE
udaan(# );
CREATE TABLE
udaan=# INSERT INTO volunteer_volunteerSession (volunteer_id, volunteer_session_id, role)
udaan-# VALUES
udaan-#     (1, 1, 'Trainer'),
udaan-#     (2, 2, 'Coordinator'),
udaan-#     (3, 3, 'Facilitator'),
udaan-#     (4, 4, 'Speaker'),
udaan-#     (5, 5, 'Trainer'),
udaan-#     (6, 6, 'Instructor'),
udaan-#     (7, 7, 'Storyteller'),
udaan-#     (8, 8, 'Instructor'),
udaan-#     (9, 9, 'Trainer'),
udaan-#     (10, 10, 'Chef');
INSERT 0 10
udaan=# SELECT * FROM child_volunteersession;
 child_volunteer_session_id | enrol_id | volunteer_session_id | participation_status |     feedback
----------------------------+----------+----------------------+----------------------+-------------------
                          1 |        1 |                    1 | Attended             | Satisfactory
                          2 |        2 |                    2 | Missed               | Unsatisfactory
                          3 |        3 |                    3 | Attended             | Needs Improvement
                          4 |        4 |                    4 | Attended             | Satisfactory
                          5 |        5 |                    5 | Missed               | Unsatisfactory
                          6 |        6 |                    6 | Attended             | Satisfactory
                          7 |        7 |                    7 | Attended             | Satisfactory
                          8 |        8 |                    8 | Missed               | Needs Improvement
                          9 |        9 |                    9 | Attended             | Satisfactory
                         10 |       10 |                   10 | Missed               | Unsatisfactory
(10 rows)


udaan=# SELECT * FROM volunteer_volunteersession;
 volunteer_volunteer_session_id | volunteer_id | volunteer_session_id |    role
--------------------------------+--------------+----------------------+-------------
                              1 |            1 |                    1 | Trainer
                              2 |            2 |                    2 | Coordinator
                              3 |            3 |                    3 | Facilitator
                              4 |            4 |                    4 | Speaker
                              5 |            5 |                    5 | Trainer
                              6 |            6 |                    6 | Instructor
                              7 |            7 |                    7 | Storyteller
                              8 |            8 |                    8 | Instructor
                              9 |            9 |                    9 | Trainer
                             10 |           10 |                   10 | Chef
(10 rows)


udaan=# CREATE TABLE mentor_mentorsession (
udaan(#     mentor_mentor_session_id SERIAL PRIMARY KEY,
udaan(#     mentor_id INT NOT NULL,
udaan(#     mentor_session_id INT NOT NULL,
udaan(#     role VARCHAR(50),
udaan(#     CONSTRAINT fk_mentor FOREIGN KEY (mentor_id) REFERENCES mentor(mentor_id) ON UPDATE CASCADE ON DELETE CASCADE,
udaan(#     CONSTRAINT fk_mentor_session FOREIGN KEY (mentor_session_id) REFERENCES mentorsession(mentor_session_id) ON UPDATE CASCADE ON DELETE CASCADE
udaan(# );
CREATE TABLE
udaan=# INSERT INTO mentor_mentorsession (mentor_mentor_session_id, mentor_id, mentor_session_id, role) VALUES
udaan-# (1, 2, 1, 'Lead Mentor'),
udaan-# (2, 3, 2, 'Co-Mentor'),
udaan-# (3, 5, 3, 'Primary Mentor'),
udaan-# (4, 8, 4, 'Child Specialist'),
udaan-# (5, 9, 5, 'Motivational Expert'),
udaan-# (6, 4, 6, 'Career Advisor'),
udaan-# (7, 6, 7, 'Skills Trainer'),
udaan-# (8, 7, 10, 'Psychiatrist'),
udaan-# (9, 1, 2, 'Session Coordinator'),
udaan-# (10, 2, 9, 'Leadership Guide');
INSERT 0 10
udaan=# SELECT * FROM mentor_mentorsession;
 mentor_mentor_session_id | mentor_id | mentor_session_id |        role
--------------------------+-----------+-------------------+---------------------
                        1 |         2 |                 1 | Lead Mentor
                        2 |         3 |                 2 | Co-Mentor
                        3 |         5 |                 3 | Primary Mentor
                        4 |         8 |                 4 | Child Specialist
                        5 |         9 |                 5 | Motivational Expert
                        6 |         4 |                 6 | Career Advisor
                        7 |         6 |                 7 | Skills Trainer
                        8 |         7 |                10 | Psychiatrist
                        9 |         1 |                 2 | Session Coordinator
                       10 |         2 |                 9 | Leadership Guide
(10 rows)


udaan=# \d
                                      List of relations
 Schema |                             Name                              |   Type   |  Owner
--------+---------------------------------------------------------------+----------+----------
 public | child                                                         | table    | postgres
 public | child_enrol_id_seq                                            | sequence | postgres
 public | child_mentorsession                                           | table    | postgres
 public | child_mentorsession_child_mentor_session_id_seq               | sequence | postgres
 public | child_sponsorship                                             | table    | postgres
 public | child_sponsorship_child_sponsorship_id_seq                    | sequence | postgres
 public | child_volunteersession                                        | table    | postgres
 public | child_volunteersession_child_volunteer_session_id_seq         | sequence | postgres
 public | guardian                                                      | table    | postgres
 public | guardian_guardian_id_seq                                      | sequence | postgres
 public | mentor                                                        | table    | postgres
 public | mentor_mentor_id_seq                                          | sequence | postgres
 public | mentor_mentorsession                                          | table    | postgres
 public | mentor_mentorsession_mentor_mentor_session_id_seq             | sequence | postgres
 public | mentorsession                                                 | table    | postgres
 public | mentorsession_mentor_session_id_seq                           | sequence | postgres
 public | sponsor                                                       | table    | postgres
 public | sponsor_sponsor_id_seq                                        | sequence | postgres
 public | sponsorship                                                   | table    | postgres
 public | sponsorship_sponsorship_id_seq                                | sequence | postgres
 public | volunteer                                                     | table    | postgres
 public | volunteer_volunteer_id_seq                                    | sequence | postgres
 public | volunteer_volunteersession                                    | table    | postgres
 public | volunteer_volunteersession_volunteer_volunteer_session_id_seq | sequence | postgres
 public | volunteersession                                              | table    | postgres
 public | volunteersession_volunteer_session_id_seq                     | sequence | postgres
(26 rows)


udaan=#

udaan=# ALTER TABLE child ADD COLUMN behavioral_challenges text;
ALTER TABLE
udaan=# \d child;
                                              Table "public.child"   
        Column         |         Type          | Collation | Nullable |                 Default
-----------------------+-----------------------+-----------+----------+-----------------------------------------
 enrol_id              | integer               |           | not null | nextval('child_enrol_id_seq'::regclass)
 child_name            | character varying(30) |           |          
|
 gender                | character varying(15) |           |          
|
 dob                   | date                  |           |          
|
 edu_level             | character varying(20) |           |          
|
 emo_status            | character varying(20) |           |          
|
 career_asp            | character varying(20) |           |          
|
 guardian_id           | integer               |           |          
|
 skills_interest       | character varying(50) |           |          
|
 behavioral_challenges | text                  |           |          
|
Indexes:
    "child_pkey" PRIMARY KEY, btree (enrol_id)
Foreign-key constraints:
    "fk_guardian" FOREIGN KEY (guardian_id) REFERENCES guardian(guardian_id) ON UPDATE CASCADE ON DELETE CASCADE
Referenced by:
    TABLE "child_sponsorship" CONSTRAINT "fk_child" FOREIGN KEY (enrol_id) REFERENCES child(enrol_id) ON UPDATE CASCADE ON DELETE CASCADE  
    TABLE "child_mentorsession" CONSTRAINT "fk_child" FOREIGN KEY (enrol_id) REFERENCES child(enrol_id) ON UPDATE CASCADE ON DELETE CASCADE
    TABLE "child_volunteersession" CONSTRAINT "fk_child" FOREIGN KEY (enrol_id) REFERENCES child(enrol_id) ON UPDATE CASCADE ON DELETE CASCADE

