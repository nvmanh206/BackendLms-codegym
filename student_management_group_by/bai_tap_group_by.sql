
USE QuanLySinhVien;

SELECT *
FROM subject
WHERE credit = (SELECT MAX(credit) FROM subject);

SELECT s.*, m.mark
FROM subject s
JOIN mark m ON s.id = m.subject_id
WHERE m.mark = (SELECT MAX(mark) FROM mark);

SELECT st.id,
       st.name,
       AVG(m.mark) AS diem_trung_binh
FROM student st
JOIN mark m ON st.id = m.student_id
GROUP BY st.id, st.name
ORDER BY diem_trung_binh DESC;
