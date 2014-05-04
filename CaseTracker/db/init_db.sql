CREATE DATABASE IF NOT EXISTS case_tracker DEFAULT CHARACTER SET 'UTF8';
CREATE DATABASE IF NOT EXISTS test_case_tracker DEFAULT CHARACTER SET 'UTF8';
GRANT ALL ON case_tracker.* TO 'hotel_tonight'@'localhost' IDENTIFIED BY '9NvZWOKwbksxb3KQzo18';
GRANT ALL ON test_case_tracker.* TO 'hotel_tonight'@'localhost' IDENTIFIED BY '9NvZWOKwbksxb3KQzo18';