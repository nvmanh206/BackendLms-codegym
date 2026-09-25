
USE QuanLySinhVien;

-- 1. Hiển thị tất cả học viên
SELECT * FROM Student;

-- 2. Hiển thị học viên đang theo học
SELECT * FROM Student
WHERE Status = TRUE;

-- 3. Hiển thị môn học có Credit < 10
SELECT * FROM Subject
WHERE Credit < 10;

-- 4. Hiển thị học viên lớp A1
SELECT S.StudentID, S.StudentName, C.ClassName
FROM Student S
JOIN Class C ON S.ClassID = C.ClassID
WHERE C.ClassName = 'A1';

-- 5. Hiển thị điểm môn CF
SELECT S.StudentID, S.StudentName, Sub.SubName, M.Mark
FROM Student S
JOIN Mark M ON S.StudentID = M.StudentID
JOIN Subject Sub ON M.SubID = Sub.SubID
WHERE Sub.SubName = 'CF';