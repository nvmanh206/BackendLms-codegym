-- BAI THUC HANH: HAM TONG HOP VA GROUP BY TRONG MYSQL
-- Yeu cau: CSDL QuanLySinhVien da co cac bang Student va Mark.
-- Script chi truy van, KHONG tao lai bang hay thay doi du lieu.

USE QuanLySinhVien;

-- CAU 1: So luong sinh vien tai tung dia chi.
SELECT
    S.Address,
    COUNT(S.StudentID) AS `So luong hoc vien`
FROM Student AS S
GROUP BY S.Address
ORDER BY S.Address;

-- CAU 2: Diem trung binh cac mon hoc cua moi hoc vien co diem.
SELECT
    S.StudentID,
    S.StudentName,
    AVG(M.Mark) AS AverageMark
FROM Student AS S
INNER JOIN Mark AS M
    ON S.StudentID = M.StudentID
GROUP BY S.StudentID, S.StudentName
ORDER BY S.StudentID;

-- CAU 3: Hoc vien co diem trung binh lon hon 15.
-- Neu du lieu mau chi co 8, 10, 12 thi khong co ban ghi phu hop.
SELECT
    S.StudentID,
    S.StudentName,
    AVG(M.Mark) AS AverageMark
FROM Student AS S
INNER JOIN Mark AS M
    ON S.StudentID = M.StudentID
GROUP BY S.StudentID, S.StudentName
HAVING AVG(M.Mark) > 15
ORDER BY AverageMark DESC, S.StudentName;

-- CAU 4: Hoc vien co diem trung binh cao nhat (giu tat ca dong hang).
SELECT
    S.StudentID,
    S.StudentName,
    AVG(M.Mark) AS AverageMark
FROM Student AS S
INNER JOIN Mark AS M
    ON S.StudentID = M.StudentID
GROUP BY S.StudentID, S.StudentName
HAVING AVG(M.Mark) >= ALL (
    SELECT AVG(M2.Mark)
    FROM Mark AS M2
    GROUP BY M2.StudentID
)
ORDER BY S.StudentID;
