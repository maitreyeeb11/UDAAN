postgres=# CREATE DATABASE UDAAN
postgres-# ;
CREATE DATABASE

postgres=# \c udaan;
You are now connected to database "udaan" as user "postgres".
udaan=#

--------------------------------------------------------------------------------------------------
CREATE TABLE guardian (
    guardian_id INT PRIMARY KEY,                    
    name VARCHAR(30),                               
    contact VARCHAR(15),                            
    rel_with_child VARCHAR(20),                     
    address VARCHAR(100),                           
    CONSTRAINT chk_contact CHECK (contact ~ '^\d{10}$')  
    
);


udaan=# \d guardian
                         Table "public.guardian"
     Column     |          Type          | Collation | Nullable | Default
----------------+------------------------+-----------+----------+---------
 guardian_id    | integer                |           | not null |
 name           | character varying(30)  |           |          |
 contact        | character varying(15)  |           |          |
 rel_with_child | character varying(20)  |           |          |
 address        | character varying(100) |           |          |
Indexes:
    "guardian_pkey" PRIMARY KEY, btree (guardian_id)
Check constraints:
    "chk_contact" CHECK (contact::text ~ '^\d{10}$'::text)

---------------------------------------------------------------------------------------------------

CREATE TABLE child(
    enrol_id INT PRIMARY KEY, 
    child_name VARCHAR(30),
    gender VARCHAR(15),
    dob DATE,
    edu_level VARCHAR(20),
    emo_status VARCHAR(20),
    career_asp VARCHAR(20),
    guardian_id INT,
    CONSTRAINT fk_guardian FOREIGN KEY (guardian_id) REFERENCES guardian(guardian_id) ON DELETE CASCADE ON UPDATE CASCADE 
    );


udaan=# \d child
                         Table "public.child"
   Column    |         Type          | Collation | Nullable | Default
-------------+-----------------------+-----------+----------+---------
 enrol_id    | integer               |           | not null |
 child_name  | character varying(30) |           |          |
 gender      | character varying(15) |           |          |
 dob         | date                  |           |          |
 edu_level   | character varying(20) |           |          |
 emo_status  | character varying(20) |           |          |
 career_asp  | character varying(20) |           |          |
 guardian_id | integer               |           |          |
Indexes:
    "child_pkey" PRIMARY KEY, btree (enrol_id)
Foreign-key constraints:
    "fk_guardian" FOREIGN KEY (guardian_id) REFERENCES guardian(guardian_id) ON UPDATE CASCADE ON DELETE CASCADE

---------------------------------------------------------------------------------------------------
CREATE TABLE mentor (
    mentor_id INT PRIMARY KEY,
    mentor_name VARCHAR(30),
    expertise VARCHAR(50),
    mentor_avail VARCHAR(10),
    mentor_email VARCHAR(30),
    contact_no VARCHAR(15),
    CONSTRAINT chk_mentor_contact CHECK (contact_no ~ '^\d{10}$'),  
    CONSTRAINT chk_email CHECK (mentor_email ~ '^[^@]+@[^@]+$')     
);



udaan=# \d mentor
                         Table "public.mentor"
    Column    |         Type          | Collation | Nullable | Default
--------------+-----------------------+-----------+----------+---------
 mentor_id    | integer               |           | not null |
 mentor_name  | character varying(30) |           |          |
 expertise    | character varying(50) |           |          |
 mentor_avail | character varying(10) |           |          |
 mentor_email | character varying(30) |           |          |
 contact_no   | character varying(15) |           |          |
Indexes:
    "mentor_pkey" PRIMARY KEY, btree (mentor_id)
Check constraints:
    "chk_email" CHECK (mentor_email::text ~ '^[^@]+@[^@]+$'::text)
    "chk_mentor_contact" CHECK (contact_no::text ~ '^\d{10}$'::text)
----------------------------------------------------------------------------------------------------

CREATE TABLE volunteer(
    volunteer_id INT PRIMARY KEY,
    volunter_name VARCHAR(30),
    skills VARCHAR(50),
    volunteer_avail VARCHAR(10),
    volunteer_email VARCHAR(30),
    volunteer_contact VARCHAR(15),
    CONSTRAINT chk_volunteer_contact CHECK (volunteer_contact ~ '^\d{10}$'),  
    CONSTRAINT chk_email CHECK (volunteer_email ~ '^[^@]+@[^@]+$')     

);


udaan=# \d volunteer
                          Table "public.volunteer"
      Column       |         Type          | Collation | Nullable | Default
-------------------+-----------------------+-----------+----------+---------
 volunteer_id      | integer               |           | not null |
 volunter_name     | character varying(30) |           |          |
 skills            | character varying(50) |           |          |
 volunteer_avail   | character varying(10) |           |          |
 volunteer_email   | character varying(30) |           |          |
 volunteer_contact | character varying(15) |           |          |
Indexes:
    "volunteer_pkey" PRIMARY KEY, btree (volunteer_id)
Check constraints:
    "chk_email" CHECK (volunteer_email::text ~ '^[^@]+@[^@]+$'::text)
    "chk_volunteer_contact" CHECK (volunteer_contact::text ~ '^\d{10}$'::text)
-----------------------------------------------------------------------------------------------------

CREATE TABLE mentorSession (
    mentor_session_id INT PRIMARY KEY,              
    mentor_session_date DATE,                        
    focus_area VARCHAR(15),                          
    outcome VARCHAR(15),                             
    msession_type VARCHAR(20),                       
    msession_status VARCHAR(15),                     
    CONSTRAINT status_chk CHECK (msession_status IN ('Scheduled', 'Completed', 'Cancelled')),  
    CONSTRAINT type_chk CHECK (msession_type IN ('Hybrid', 'Offline'))  
);


udaan=# \d mentorSession
                         Table "public.mentorsession"
       Column        |         Type          | Collation | Nullable | Default
---------------------+-----------------------+-----------+----------+---------
 mentor_session_id   | integer               |           | not null |
 mentor_session_date | date                  |           |          |
 focus_area          | character varying(15) |           |          |
 outcome             | character varying(15) |           |          |
 msession_type       | character varying(20) |           |          |
 msession_status     | character varying(15) |           |          |
Indexes:
    "mentorsession_pkey" PRIMARY KEY, btree (mentor_session_id)
Check constraints:
    "status_chk" CHECK (msession_status::text = ANY (ARRAY['Scheduled'::character varying, 'Completed'::character varying, 'Cancelled'::character varying]::text[]))
    "type_chk" CHECK (msession_type::text = ANY (ARRAY['Hybrid'::character varying, 'Offline'::character varying]::text[]))
---------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE volunteerSession(
    volunteer_session_id INT PRIMARY KEY,              
    volunteer_session_date DATE,                        
    purpose VARCHAR(25),                          
    outcome VARCHAR(15),                             
    vsession_type VARCHAR(20),                       
    vsession_status VARCHAR(15),                     
    CONSTRAINT status_chk CHECK (vsession_status IN ('Scheduled', 'Completed', 'Cancelled')),  
    CONSTRAINT type_chk CHECK (vsession_type IN ('Hybrid', 'Offline'))
);


udaan=# \d volunteerSession
                         Table "public.volunteersession"
         Column         |         Type          | Collation | Nullable | Default
------------------------+-----------------------+-----------+----------+---------
 volunteer_session_id   | integer               |           | not null |
 volunteer_session_date | date                  |           |          |
 purpose                | character varying(25) |           |          |
 outcome                | character varying(15) |           |          |
 vsession_type          | character varying(20) |           |          |
 vsession_status        | character varying(15) |           |          |
Indexes:
    "volunteersession_pkey" PRIMARY KEY, btree (volunteer_session_id)
Check constraints:
    "status_chk" CHECK (vsession_status::text = ANY (ARRAY['Scheduled'::character varying, 'Completed'::character varying, 'Cancelled'::character varying]::text[]))
    "type_chk" CHECK (vsession_type::text = ANY (ARRAY['Hybrid'::character varying, 'Offline'::character varying]::text[]))
-------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE sponsor(
    sponsor_id INT PRIMARY KEY,
    sponsor_name VARCHAR(30),
    sponsor_contact VARCHAR(15),
    sponsor_email VARCHAR(30),
    pan_number VARCHAR(15),
    amt NUMERIC(10, 2),
    CONSTRAINT chk_pan CHECK (pan_number ~ '^[A-Z]{5}\d{4}[A-Z]{1}$'),  -- PAN number format
    CONSTRAINT chk_contact CHECK (sponsor_contact ~ '^\d{10}$'),
    CONSTRAINT chk_email CHECK (sponsor_email ~ '^[^@]+@[^@]+$')

);

udaan=# \d sponsor
                          Table "public.sponsor"
     Column      |         Type          | Collation | Nullable | Default
-----------------+-----------------------+-----------+----------+---------
 sponsor_id      | integer               |           | not null |
 sponsor_name    | character varying(30) |           |          |
 sponsor_contact | character varying(15) |           |          |
 sponsor_email   | character varying(30) |           |          |
 pan_number      | character varying(15) |           |          |
 amt             | numeric(10,2)         |           |          |
Indexes:
    "sponsor_pkey" PRIMARY KEY, btree (sponsor_id)
Check constraints:
    "chk_contact" CHECK (sponsor_contact::text ~ '^\d{10}$'::text)
    "chk_email" CHECK (sponsor_email::text ~ '^[^@]+@[^@]+$'::text)
    "chk_pan" CHECK (pan_number::text ~ '^[A-Z]{5}\d{4}[A-Z]{1}$'::text)

ALTER TABLE sponsor ADD COLUMN sponsor_addr VARCHAR(40);
udaan=# \d sponsor
                          Table "public.sponsor"
     Column      |         Type          | Collation | Nullable | Default
-----------------+-----------------------+-----------+----------+---------
 sponsor_id      | integer               |           | not null |
 sponsor_name    | character varying(30) |           |          |
 sponsor_contact | character varying(15) |           |          |
 sponsor_email   | character varying(30) |           |          |
 pan_number      | character varying(15) |           |          |
 amt             | numeric(10,2)         |           |          |
 sponsor_addr    | character varying(40) |           |          |
Indexes:
    "sponsor_pkey" PRIMARY KEY, btree (sponsor_id)
Check constraints:
    "chk_contact" CHECK (sponsor_contact::text ~ '^\d{10}$'::text)
    "chk_email" CHECK (sponsor_email::text ~ '^[^@]+@[^@]+$'::text)
    "chk_pan" CHECK (pan_number::text ~ '^[A-Z]{5}\d{4}[A-Z]{1}$'::text)
Referenced by:
    TABLE "sponsorship" CONSTRAINT "fk_sponsor" FOREIGN KEY (sponsor_id) REFERENCES sponsor(sponsor_id) ON UPDATE CASCADE ON DELETE CASCADE
    TABLE "child_sponsor" CONSTRAINT "fk_sponsor" FOREIGN KEY (sponsor_id) REFERENCES sponsor(sponsor_id) ON UPDATE CASCADE ON DELETE CASCADE
udaan=# ALTER TABLE sponsor
udaan-# ALTER COLUMN sponsor_addr TYPE VARCHAR(200);
ALTER TABLE

udaan=# \d sponsor
                          Table "public.sponsor"
     Column      |          Type          | Collation | Nullable | Default
-----------------+------------------------+-----------+----------+---------
 sponsor_id      | integer                |           | not null |
 sponsor_name    | character varying(30)  |           |          |
 sponsor_contact | character varying(15)  |           |          |
 sponsor_email   | character varying(30)  |           |          |
 pan_number      | character varying(15)  |           |          |
 amt             | numeric(10,2)          |           |          |
 sponsor_addr    | character varying(200) |           |          |
Indexes:
    "sponsor_pkey" PRIMARY KEY, btree (sponsor_id)
Check constraints:
    "chk_contact" CHECK (sponsor_contact::text ~ '^\d{10}$'::text)
    "chk_email" CHECK (sponsor_email::text ~ '^[^@]+@[^@]+$'::text)
    "chk_pan" CHECK (pan_number::text ~ '^[A-Z]{5}\d{4}[A-Z]{1}$'::text)
Referenced by:
    TABLE "sponsorship" CONSTRAINT "fk_sponsor" FOREIGN KEY (sponsor_id) REFERENCES sponsor(sponsor_id) ON UPDATE CASCADE ON DELETE CASCADE
    TABLE "child_sponsor" CONSTRAINT "fk_sponsor" FOREIGN KEY (sponsor_id) REFERENCES sponsor(sponsor_id) ON UPDATE CASCADE ON DELETE CASCADE




---------------------------------------------------------------------------------------------------------
CREATE TABLE sponsorship(
    sponsorship_id INT PRIMARY KEY, 
    sponsorship_type VARCHAR(10),
    sponsorship_amt NUMERIC(10,2),
    sponsor_id INT,
    CONSTRAINT fk_sponsor FOREIGN KEY (sponsor_id) REFERENCES sponsor(sponsor_id) ON DELETE CASCADE ON UPDATE CASCADE 
);

udaan=# \d sponsorship
                        Table "public.sponsorship"
      Column      |         Type          | Collation | Nullable | Default
------------------+-----------------------+-----------+----------+---------
 sponsorship_id   | integer               |           | not null |
 sponsorship_type | character varying(10) |           |          |
 sponsorship_amt  | numeric(10,2)         |           |          |
 sponsor_id       | integer               |           |          |
Indexes:
    "sponsorship_pkey" PRIMARY KEY, btree (sponsorship_id)
Foreign-key constraints:
    "fk_sponsor" FOREIGN KEY (sponsor_id) REFERENCES sponsor(sponsor_id) ON UPDATE CASCADE ON DELETE CASCADE

-------------------------------------------------------------------------------------------------------------



==================================================================================================

INSERT INTO guardian (guardian_id, name, contact, rel_with_child, address)
VALUES
(1, 'Anjali Trust', '9012345678', 'NGO', 'Pune, India'),
(2, 'Ashray Foundation', '9876098765', 'NGO', 'Pune, India'),
(3, 'Maitra Foundation', '9901234567', 'NGO', 'Pune, India'),
(4, 'Saheli Foundation', '9091238765', 'NGO', 'Pune, India'),
(5, 'Jeevan NGO', '9212345678', 'NGO', 'Pune, India'),
(6, 'Prerna NGO', '9019876543', 'NGO', 'Pune, India'),
(7, 'Sarita Devi', '9098765432', 'Mother', 'Pune, India'),
(8, 'Manju Devi', '9054321890', 'Mother', 'Pune, India'),
(9, 'Priya Kamble', '9321456789', 'Mother', 'Pune, India'),
(10, 'Radha Kumari', '9123456780', 'Mother', 'Pune, India');

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





INSERT INTO child (enrol_id, child_name, gender, dob, edu_level, emo_status, career_asp, guardian_id)
VALUES
(1, 'Aarav', 'Male', '2011-05-15', 'Secondary', 'Stable', 'Engineer', 1),
(2, 'Riya', 'Female', '2012-03-20', 'Secondary', 'Anxious', 'Doctor', 2),
(3, 'Kabir', 'Male', '2011-07-10', 'Secondary', 'Improving', 'Scientist', 1),
(4, 'Ishita', 'Female', '2009-08-25', 'High School', 'Stable', 'Teacher', 2),
(5, 'Aditya', 'Male', '2010-11-02', 'High School', 'Stable', 'Pilot', 3),
(6, 'Nisha', 'Female', '2011-12-15', 'Secondary', 'Anxious', 'Artist', 5),
(7, 'Ayaan', 'Male', '2005-09-18', 'College/University', 'Stable', 'Entrepreneur', 7),
(8, 'Pooja', 'Female', '2008-01-10', 'High School', 'Stable', 'Psychologist', 8),
(9, 'Kartik', 'Male', '2007-05-22', 'High School', 'Improving', 'Engineer', 9),
(10, 'Simran', 'Female', '2012-06-30', 'Secondary', 'Stable', 'Dancer', 4),
(11, 'Romil', 'Male', '2011-12-12', 'Secondary', 'Stable', 'Scientist', 5),
(12, 'Anika', 'Female', '2004-03-05', 'College/University', 'Improving', 'Dancer', 3),
(13, 'Aryan', 'Male', '2011-07-09', 'Secondary', 'Stable', 'Pilot', 2),
(14, 'Meera', 'Female', '2009-11-21', 'High School', 'Improving', 'Engineer', 4),
(15, 'Raju', 'Male', '2005-06-03', 'College/University', 'Stable', 'Engineer', 5),
(16, 'Shrikant', 'Male', '2007-09-06', 'High School', 'Improving', 'Engineer', 10);


udaan=# SELECT * FROM child;
 enrol_id | child_name | gender |    dob     |     edu_level      | emo_status |  career_asp  | guardian_id
----------+------------+--------+------------+--------------------+------------+--------------+-------------
        1 | Aarav      | Male   | 2011-05-15 | Secondary          | Stable     | Engineer     |           1
        2 | Riya       | Female | 2012-03-20 | Secondary          | Anxious    | Doctor       |           2
        3 | Kabir      | Male   | 2011-07-10 | Secondary          | Improving  | Scientist    |           1
        4 | Ishita     | Female | 2009-08-25 | High School        | Stable     | Teacher      |           2
        5 | Aditya     | Male   | 2010-11-02 | High School        | Stable     | Pilot        |           3
        6 | Nisha      | Female | 2011-12-15 | Secondary          | Anxious    | Artist       |           5
        7 | Ayaan      | Male   | 2005-09-18 | College/University | Stable     | Entrepreneur |           7
        8 | Pooja      | Female | 2008-01-10 | High School        | Stable     | Psychologist |           8
        9 | Kartik     | Male   | 2007-05-22 | High School        | Improving  | Engineer     |           9
       10 | Simran     | Female | 2012-06-30 | Secondary          | Stable     | Dancer       |           4
       11 | Romil      | Male   | 2011-12-12 | Secondary          | Stable     | Scientist    |           5
       12 | Anika      | Female | 2004-03-05 | College/University | Improving  | Dancer       |           3
       13 | Aryan      | Male   | 2011-07-09 | Secondary          | Stable     | Pilot        |           2
       14 | Meera      | Female | 2009-11-21 | High School        | Improving  | Engineer     |           4
       15 | Raju       | Male   | 2005-06-03 | College/University | Stable     | Engineer     |           5
       16 | Shrikant   | Male   | 2007-09-06 | High School        | Improving  | Engineer     |          10
(16 rows)


------
INSERT INTO mentor (mentor_id, mentor_name, expertise, mentor_avail, mentor_email, contact_no)
VALUES
(1, 'Dr. Meera Sharma', 'Psychiatry', 'Offline', 'meera.sharma@example.com', '9876501234'),
(2, 'Arjun Patel', 'Career Counselling', 'Offline', 'arjun.patel@example.com', '9123456789'),
(3, 'Neha Singh', 'Behavioral Therapy', 'Hybrid', 'neha.singh@example.com', '9812345678'),
(4, 'Pooja Sharma', 'Career Guidance', 'Hybrid', 'pooja.sharma@example.com', '9832145678'),
(5, 'Sanjay Verma', 'Education Counselling', 'Offline', 'sanjay.verma@example.com', '9743126589'),
(6, 'Anjali Mehta', 'Soft Skills Training', 'Offline', 'anjali.mehta@example.com', '9598765432'),
(7, 'Dr. Ramesh Gupta', 'Psychiatry', 'Hybrid', 'ramesh.gupta@example.com', '9101234567'),
(8, 'Sneha Roy', 'Child Development', 'Offline', 'sneha.roy@example.com', '9823145670'),
(9, 'Manish Kapoor', 'Motivational Coaching', 'Offline', 'manish.kapoor@example.com', '9123987654');

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


INSERT INTO volunteer (volunteer_id, volunter_name, skills, volunteer_avail, volunteer_email, volunteer_contact)
VALUES
(1, 'Kavya Desai', 'Soft Skills', 'Offline', 'kavya.desai@example.com', '9001234567'),
(2, 'Rohan Gupta', 'Group Activities', 'Offline', 'rohan.gupta@example.com', '8987654321'),
(3, 'Aditi Rao', 'Art Therapy', 'Offline', 'aditi.rao@example.com', '9012345678'),
(4, 'Akshay Jain', 'Public Speaking', 'Offline', 'akshay.jain@example.com', '9098765432'),
(5, 'Naina Singh', 'Sports Training', 'Offline', 'naina.singh@example.com', '9087654321'),
(6, 'Ravi Shankar', 'Dance and Yoga Therapy', 'Offline', 'ravi.shankar@example.com', '9009876543'),
(7, 'Priya Nair', 'Storytelling', 'Offline', 'priya.nair@example.com', '9123456789'),
(8, 'Rajesh Sharma', 'Music Lessons', 'Offline', 'rajesh.sharma@example.com', '9034567890'),
(9, 'Ankit Mehta', 'Leadership Skills', 'Offline', 'ankit.mehta@example.com', '9091234567'),
(10, 'Shreya Kulkarni', 'Cooking Classes', 'Offline', 'shreya.kulkarni@example.com', '9076543210');

udaan=# SELECT * FROM volunteer;
 volunteer_id |  volunter_name  |         skills         | volunteer_avail |       volunteer_email       | volunteer_contact
--------------+-----------------+------------------------+-----------------+-----------------------------+-------------------
            1 | Kavya Desai     | Soft Skills            | Offline         | kavya.desai@example.com     | 9001234567
            2 | Rohan Gupta     | Group Activities       | Offline         | rohan.gupta@example.com     | 8987654321
            3 | Aditi Rao       | Art Therapy            | Offline         | aditi.rao@example.com       | 9012345678
            4 | Akshay Jain     | Public Speaking        | Offline         | akshay.jain@example.com     | 9098765432
            5 | Naina Singh     | Sports Training        | Offline         | naina.singh@example.com     | 9087654321
            6 | Ravi Shankar    | Dance and Yoga Therapy | Offline         | ravi.shankar@example.com    | 9009876543
            7 | Priya Nair      | Storytelling           | Offline         | priya.nair@example.com      | 9123456789
            8 | Rajesh Sharma   | Music Lessons          | Offline         | rajesh.sharma@example.com   | 9034567890
            9 | Ankit Mehta     | Leadership Skills      | Offline         | ankit.mehta@example.com     | 9091234567
           10 | Shreya Kulkarni | Cooking Classes        | Offline         | shreya.kulkarni@example.com | 9076543210
(10 rows)

INSERT INTO sponsor (sponsor_id, sponsor_name, sponsor_contact, sponsor_email, pan_number, amt, sponsor_addr)
VALUES
(1, 'Reliance Foundation', '9812345678', 'reliance@example.com', 'ABCDE1234F', 50000.00, 'Flat 101, Gokul Heights, Baner, Pune, Maharashtra, India'),
(2, 'Mr. Ravi Kumar', '9823456789', 'ravi.kumar@example.com', 'FGHIJ5678K', 20000.00, 'Building 4B, MG Road, Camp, Pune, Maharashtra, India'),
(3, 'Infosys Foundation', '9876543210', 'infosys@example.com', 'PQRST5678L', 70000.00, 'Tower 2, Hinjawadi Phase 3, Pune, Maharashtra, India'),
(4, 'Tata Trust', '9019876543', 'tata@example.com', 'LMNOP1234A', 60000.00, 'Flat 402, Koregaon Park, Pune, Maharashtra, India'),
(5, 'Mrs. Anjali Sharma', '9123987654', 'anjali.sharma@example.com', 'WXYZC4567B', 15000.00, 'Wing A, Magarpatta City, Pune, Maharashtra, India'),
(6, 'HDFC CSR', '9002345678', 'hdfc@example.com', 'EFGHI7890C', 45000.00, 'Flat 12, Law College Road, Pune, Maharashtra, India'),
(7, 'Dr. Ramesh Kumar', '9123456780', 'ramesh.kumar@example.com', 'HIJKL2345D', 25000.00, 'Building 5, Viman Nagar, Pune, Maharashtra, India'),
(8, 'Ashok Leyland', '9109876543', 'ashok@example.com', 'ABCDE9876F', 30000.00, 'Flat 303, Andheri East, Mumbai, Maharashtra, India'),
(9, 'ICICI CSR', '9212345678', 'icici@example.com', 'JKLHI5678G', 40000.00, 'Building 2A, Bandra West, Mumbai, Maharashtra, India'),
(10, 'Tech Mahindra Foundation', '9323456789', 'techm@example.com', 'OPQRK3456H', 60000.00, 'Wing B, Powai, Mumbai, Maharashtra, India');

udaan=# SELECT * FROM sponsor;
 sponsor_id |       sponsor_name       | sponsor_contact |       sponsor_email       | pan_number |   amt    |
             sponsor_addr
------------+--------------------------+-----------------+---------------------------+------------+----------+----------------------------------------------------------
          1 | Reliance Foundation      | 9812345678      | reliance@example.com      | ABCDE1234F | 50000.00 | Flat 101, Gokul Heights, Baner, Pune, Maharashtra, India
          2 | Mr. Ravi Kumar           | 9823456789      | ravi.kumar@example.com    | FGHIJ5678K | 20000.00 | Building 4B, MG Road, Camp, Pune, Maharashtra, India
          3 | Infosys Foundation       | 9876543210      | infosys@example.com       | PQRST5678L | 70000.00 | Tower 2, Hinjawadi Phase 3, Pune, Maharashtra, India
          4 | Tata Trust               | 9019876543      | tata@example.com          | LMNOP1234A | 60000.00 | Flat 402, Koregaon Park, Pune, Maharashtra, India
          5 | Mrs. Anjali Sharma       | 9123987654      | anjali.sharma@example.com | WXYZC4567B | 15000.00 | Wing A, Magarpatta City, Pune, Maharashtra, India
          6 | HDFC CSR                 | 9002345678      | hdfc@example.com          | EFGHI7890C | 45000.00 | Flat 12, Law College Road, Pune, Maharashtra, India
          7 | Dr. Ramesh Kumar         | 9123456780      | ramesh.kumar@example.com  | HIJKL2345D | 25000.00 | Building 5, Viman Nagar, Pune, Maharashtra, India
          8 | Ashok Leyland            | 9109876543      | ashok@example.com         | ABCDE9876F | 30000.00 | Flat 303, Andheri East, Mumbai, Maharashtra, India
          9 | ICICI CSR                | 9212345678      | icici@example.com         | JKLHI5678G | 40000.00 | Building 2A, Bandra West, Mumbai, Maharashtra, India
         10 | Tech Mahindra Foundation | 9323456789      | techm@example.com         | OPQRK3456H | 60000.00 | Wing B, Powai, Mumbai, Maharashtra, India
(10 rows)


CREATE TABLE child_sponsorship (
    child_sponsorship_id INT PRIMARY KEY,
    enrol_id INT NOT NULL,
    sponsorship_id INT NOT NULL,
    sponsorship_date DATE NOT NULL,
    sponsorship_status VARCHAR(20) CHECK (sponsorship_status IN ('Active', 'Expired', 'Pending')),
    CONSTRAINT fk_child FOREIGN KEY (enrol_id) REFERENCES child(enrol_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_sponsorship FOREIGN KEY (sponsorship_id) REFERENCES sponsorship(sponsorship_id) ON DELETE CASCADE ON UPDATE CASCADE
);


udaan=# \d child_sponsorship;
                       Table "public.child_sponsorship"
        Column        |         Type          | Collation | Nullable | Default
----------------------+-----------------------+-----------+----------+---------
 child_sponsorship_id | integer               |           | not null |
 enrol_id             | integer               |           | not null |
 sponsorship_id       | integer               |           | not null |
 sponsorship_date     | date                  |           | not null |
 sponsorship_status   | character varying(20) |           |          |
Indexes:
    "child_sponsorship_pkey" PRIMARY KEY, btree (child_sponsorship_id)
Check constraints:
    "child_sponsorship_sponsorship_status_check" CHECK (sponsorship_status::text = ANY (ARRAY['Active'::character varying, 'Expired'::character varying, 'Pending'::character varying]::text[]))
Foreign-key constraints:
    "fk_child" FOREIGN KEY (enrol_id) REFERENCES child(enrol_id) ON UPDATE CASCADE ON DELETE CASCADE
    "fk_sponsorship" FOREIGN KEY (sponsorship_id) REFERENCES sponsorship(sponsorship_id) ON UPDATE CASCADE ON DELETE CASCADE





CREATE TABLE child_mentorSession (
    enrol_id INT NOT NULL,
    mentor_session_id INT NOT NULL,
    participation_status VARCHAR(20) CHECK (participation_status IN ('Attended', 'Missed')),
    feedback VARCHAR(20) CHECK (feedback IN ('Satisfactory', 'Unsatisfactory', 'Needs Improvement')),
    CONSTRAINT pk_child_mentor_session PRIMARY KEY (enrol_id, mentor_session_id),
    CONSTRAINT fk_child FOREIGN KEY (enrol_id) REFERENCES child(enrol_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_mentor_session FOREIGN KEY (mentor_session_id) REFERENCES mentorSession(mentor_session_id) ON DELETE CASCADE ON UPDATE CASCADE
);

udaan=# \d child_mentorSession
                      Table "public.child_mentorsession"
        Column        |         Type          | Collation | Nullable | Default
----------------------+-----------------------+-----------+----------+---------
 enrol_id             | integer               |           | not null |
 mentor_session_id    | integer               |           | not null |
 participation_status | character varying(20) |           |          |
 feedback             | character varying(20) |           |          |
Indexes:
    "pk_child_mentor_session" PRIMARY KEY, btree (enrol_id, mentor_session_id)
Check constraints:
    "child_mentorsession_feedback_check" CHECK (feedback::text = ANY (ARRAY['Satisfactory'::character varying, 'Unsatisfactory'::character varying, 'Needs Improvement'::character varying]::text[]))
    "child_mentorsession_participation_status_check" CHECK (participation_status::text = ANY (ARRAY['Attended'::character varying, 'Missed'::character varying]::text[]))
Foreign-key constraints:
    "fk_child" FOREIGN KEY (enrol_id) REFERENCES child(enrol_id) ON UPDATE CASCADE ON DELETE CASCADE
    "fk_mentor_session" FOREIGN KEY (mentor_session_id) REFERENCES mentorsession(mentor_session_id) ON UPDATE CASCADE ON DELETE CASCADE


CREATE TABLE child_volunteerSession (
    enrol_id INT NOT NULL,
    volunteer_session_id INT NOT NULL,
    participation_status VARCHAR(20) CHECK (participation_status IN ('Attended', 'Missed')),
    feedback VARCHAR(20) CHECK (feedback IN ('Satisfactory', 'Unsatisfactory', 'Needs Improvement')),
    CONSTRAINT pk_child_volunteer_session PRIMARY KEY (enrol_id, volunteer_session_id),
    CONSTRAINT fk_child FOREIGN KEY (enrol_id) REFERENCES child(enrol_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_volunteer_session FOREIGN KEY (volunteer_session_id) REFERENCES volunteerSession(volunteer_session_id) ON DELETE CASCADE ON UPDATE CASCADE
);

udaan=# \d child_volunteerSession
                     Table "public.child_volunteersession"
        Column        |         Type          | Collation | Nullable | Default
----------------------+-----------------------+-----------+----------+---------
 enrol_id             | integer               |           | not null |
 volunteer_session_id | integer               |           | not null |
 participation_status | character varying(20) |           |          |
 feedback             | character varying(20) |           |          |
Indexes:
    "pk_child_volunteer_session" PRIMARY KEY, btree (enrol_id, volunteer_session_id)
Check constraints:
    "child_volunteersession_feedback_check" CHECK (feedback::text = ANY (ARRAY['Satisfactory'::character varying, 'Unsatisfactory'::character varying, 'Needs Improvement'::character varying]::text[]))
    "child_volunteersession_participation_status_check" CHECK (participation_status::text = ANY (ARRAY['Attended'::character varying, 'Missed'::character varying]::text[]))
Foreign-key constraints:
    "fk_child" FOREIGN KEY (enrol_id) REFERENCES child(enrol_id) ON UPDATE CASCADE ON DELETE CASCADE
    "fk_volunteer_session" FOREIGN KEY (volunteer_session_id) REFERENCES volunteersession(volunteer_session_id) ON UPDATE CASCADE ON DELETE CASCADE



CREATE TABLE volunteer_volunteerSession (
    volunteer_volunteer_session_id INT PRIMARY KEY,
    volunteer_id INT NOT NULL,
    volunteer_session_id INT NOT NULL,
    role VARCHAR(50),
    CONSTRAINT fk_volunteer FOREIGN KEY (volunteer_id) REFERENCES volunteer(volunteer_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_volunteer_session FOREIGN KEY (volunteer_session_id) REFERENCES volunteerSession(volunteer_session_id) ON DELETE CASCADE ON UPDATE CASCADE
);

udaan=# \d volunteer_volunteerSession;
                        Table "public.volunteer_volunteersession"
             Column             |         Type          | Collation | Nullable | Default
--------------------------------+-----------------------+-----------+----------+---------
 volunteer_volunteer_session_id | integer               |           | not null |
 volunteer_id                   | integer               |           | not null |
 volunteer_session_id           | integer               |           | not null |
 role                           | character varying(50) |           |          |
Indexes:
    "volunteer_volunteersession_pkey" PRIMARY KEY, btree (volunteer_volunteer_session_id)
Foreign-key constraints:
    "fk_volunteer" FOREIGN KEY (volunteer_id) REFERENCES volunteer(volunteer_id) ON UPDATE CASCADE ON DELETE CASCADE
    "fk_volunteer_session" FOREIGN KEY (volunteer_session_id) REFERENCES volunteersession(volunteer_session_id) ON UPDATE CASCADE ON DELETE CASCADE


CREATE TABLE mentor_mentorSession (
    mentor_mentor_session_id INT PRIMARY KEY,
    mentor_id INT NOT NULL,
    mentor_session_id INT NOT NULL,
    role VARCHAR(50),
    CONSTRAINT fk_mentor FOREIGN KEY (mentor_id) REFERENCES mentor(mentor_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_mentor_session FOREIGN KEY (mentor_session_id) REFERENCES mentorSession(mentor_session_id) ON DELETE CASCADE ON UPDATE CASCADE
);

udaan=# \d mentor_mentorSession;
                        Table "public.mentor_mentorsession"
          Column          |         Type          | Collation | Nullable | Default
--------------------------+-----------------------+-----------+----------+---------
 mentor_mentor_session_id | integer               |           | not null |
 mentor_id                | integer               |           | not null |
 mentor_session_id        | integer               |           | not null |
 role                     | character varying(50) |           |          |
Indexes:
    "mentor_mentorsession_pkey" PRIMARY KEY, btree (mentor_mentor_session_id)
Foreign-key constraints:
    "fk_mentor" FOREIGN KEY (mentor_id) REFERENCES mentor(mentor_id) ON UPDATE CASCADE ON DELETE CASCADE
    "fk_mentor_session" FOREIGN KEY (mentor_session_id) REFERENCES mentorsession(mentor_session_id) ON UPDATE CASCADE ON DELETE CASCADE


Volunteer Roles:

Facilitator: Leading the session and ensuring smooth execution.
Support Staff: Assisting with logistics or providing materials.
Trainer: Teaching or guiding participants on specific topics.
Event Coordinator: Organizing and managing the session schedule.

Mentor Roles:

Career Advisor: Providing guidance on career aspirations and paths.
Emotional Support Mentor: Helping the child with emotional and psychological well-being.
Subject Expert: Offering expertise in a specific area of focus for the session.
Session Leader: Driving the discussion and activities.



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