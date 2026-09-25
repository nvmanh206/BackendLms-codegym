-- ================================================================
-- PAYFLOW: EXPLAIN, COMPOSITE INDEX VA TRUY VAN SARGABLE
-- Bai thuc hanh MySQL - chay tren database THU NGHIEM.
-- Chay tu tren xuong duoi LAN DAU de so sanh EXPLAIN truoc/sau.
-- Bang trong de bai GIA LAP 5 trieu giao dich; file khong tao 5 trieu dong.
-- ================================================================

-- PHAN 1: MA NGUON GOC TU DE BAI - TAO DATABASE VA BANG
CREATE DATABASE IF NOT EXISTS payflow_db;
USE payflow_db;

CREATE TABLE IF NOT EXISTS Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    amount DECIMAL(15,2),
    transaction_type VARCHAR(20), -- 'DEPOSIT', 'WITHDRAW', 'TRANSFER'
    created_at DATETIME
);

-- PHAN 2: TRUY VAN LEGACY (CHAY EXPLAIN TRUOC KHI TAO INDEX)
-- Ham YEAR/MONTH boc quanh created_at lam truy van khong the
-- su dung B-Tree index thong thuong tren created_at de tim theo RANGE.
EXPLAIN FORMAT=TRADITIONAL
SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT'
  AND YEAR(created_at) = 2026
  AND MONTH(created_at) = 6;

-- PHAN 3: TAO COMPOSITE INDEX THEO YEU CAU DE BAI
-- Chi chay CREATE INDEX mot lan. Neu idx_type_date da ton tai,
-- bo qua lenh CREATE INDEX khi chay lai file.
-- Voi bang lon, can xem xet thoi gian / tai nguyen tao index.
CREATE INDEX idx_type_date
ON Transactions (transaction_type, created_at);

-- PHAN 4: EXPLAIN TRUY VAN DA TOI UU
-- Dieu kien bang (=) tren cot dau, khoang [dau thang, dau thang sau)
-- tren cot thu hai. Khong boc ham quanh created_at.
EXPLAIN FORMAT=TRADITIONAL
SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT'
  AND created_at >= '2026-06-01 00:00:00'
  AND created_at <  '2026-07-01 00:00:00';

-- PHAN 5: TRUY VAN BAO CAO CHINH THUC (CHO DU LIEU THUC TE)
SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT'
  AND created_at >= '2026-06-01 00:00:00'
  AND created_at <  '2026-07-01 00:00:00';

-- PHAN 6: KIEM TRA INDEX, SO DONG VA PHIEN BAN MYSQL
SHOW INDEX FROM Transactions;
SELECT VERSION() AS mysql_version;
-- SELECT COUNT(*) AS total_transactions FROM Transactions;

-- ================================================================
-- TUY CHON A: DU LIEU MAU CHO MAY CA NHAN (KHONG PHAI 5 TRIEU DONG)
-- Neu bang dang trong va ban muon thu NGHIEP VU, mo comment khoi duoi,
-- chay INSERT mot lan, sau do chay lai SELECT.
-- Tong DEPOSIT thang 06/2026 cua mau: 1580.50.
-- Mau qua nho: optimizer CO THE van chon type=ALL vi re hon range;
-- khong dung du lieu mau nay de khang dinh cai thien tren 5 trieu dong.
-- ================================================================
/*
INSERT INTO Transactions (user_id, amount, transaction_type, created_at) VALUES
(1, 100.00,  'DEPOSIT',  '2026-06-01 00:00:00'),
(2, 250.50,  'DEPOSIT',  '2026-06-12 10:30:00'),
(1, 30.00,   'DEPOSIT',  '2026-06-30 23:59:59'),
(3, 75.00,   'WITHDRAW', '2026-06-14 09:00:00'),
(4, 999.00,  'DEPOSIT',  '2026-07-01 00:00:00'),
(5, 80.00,   'DEPOSIT',  '2026-05-31 23:59:59'),
(6, 1200.00, 'DEPOSIT',  '2026-06-16 15:00:00');
*/

-- TUY CHON B: DO THOI GIAN THUC TE (MySQL >= 8.0.18).
-- EXPLAIN ANALYZE THUC SU CHAY truy van; chi chay tren moi truong test
-- hoac khi da danh gia chi phi tren he thong that.
/*
EXPLAIN ANALYZE
SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT'
  AND created_at >= '2026-06-01 00:00:00'
  AND created_at <  '2026-07-01 00:00:00';
*/
