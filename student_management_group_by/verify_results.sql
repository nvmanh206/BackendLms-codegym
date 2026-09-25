-- KIEM TRA CSDL / DU LIEU MAU. Chi chay SELECT, khong sua du lieu.
USE QuanLySinhVien;

-- Xac nhan bang du lieu va xem cac ban ghi dang co.
SHOW TABLES;
SELECT * FROM Student ORDER BY StudentID;
SELECT * FROM Mark ORDER BY StudentID, SubID, ExamTimes;

-- Kiem tra so luong hoc vien tai tung dia chi.
SELECT Address, COUNT(StudentID) AS StudentCount
FROM Student
GROUP BY Address
ORDER BY Address;

-- Kiem tra diem trung binh thuc te theo tung StudentID.
SELECT StudentID, AVG(Mark) AS AverageMark
FROM Mark
GROUP BY StudentID
ORDER BY StudentID;
