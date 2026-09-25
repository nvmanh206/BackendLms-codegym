
USE QuanLySinhVien;

-- CAU 1: Sinh vien co ten bat dau bang h
SELECT *
FROM Student
WHERE LOWER(StudentName) LIKE 'h%';

-- CAU 2: Lop hoc bat dau trong thang 12
SELECT *
FROM Class
WHERE MONTH(StartDate) = 12;

-- CAU 3: Mon hoc co Credit tu 3 den 5
SELECT *
FROM Subject
WHERE Credit BETWEEN 3 AND 5;

-- CAU 4: Chuyen sinh vien Hung sang lop 2
UPDATE Student
SET ClassID = 2
WHERE StudentName = 'Hung';

-- Kiem tra sau khi cap nhat
SELECT StudentID, StudentName, ClassID
FROM Student
WHERE StudentName = 'Hung';

-- CAU 5: Hien thi diem thi theo thu tu yeu cau
SELECT
    S.StudentName,
    Sub.SubName,
    M.Mark
FROM Student S
INNER JOIN Mark M
    ON S.StudentID = M.StudentID
INNER JOIN Subject Sub
    ON M.SubID = Sub.SubID
ORDER BY
    M.Mark DESC,
    S.StudentName ASC;