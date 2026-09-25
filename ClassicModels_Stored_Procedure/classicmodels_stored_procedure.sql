-- ==========================================================
-- BAI THUC HANH: STORED PROCEDURE TRONG MYSQL
-- Database: classicmodels (co san tu bai hoc / du lieu mau)
-- Chay trong MySQL Workbench: File > Open SQL Script > Execute All
-- ==========================================================

-- 1. Su dung CSDL classicmodels da co
USE classicmodels;

-- Kiem tra du lieu dau vao (tuy chon)
SELECT COUNT(*) AS total_customers FROM customers;

-- 2. TAO PROCEDURE DAU TIEN: Lay tat ca khach hang
-- DROP IF EXISTS de co the chay lai file nhieu lan
DROP PROCEDURE IF EXISTS findAllCustomers;

DELIMITER $$
CREATE PROCEDURE findAllCustomers()
BEGIN
    SELECT *
    FROM customers;
END$$
DELIMITER ;

-- 3. GOI PROCEDURE: ket qua la tat ca khach hang
CALL findAllCustomers();

-- 4. SUA PROCEDURE: MySQL khong ho tro ALTER BODY truc tiep,
--    vi vay xoa va tao lai de chi lay customerNumber = 175
DROP PROCEDURE IF EXISTS findAllCustomers;

DELIMITER $$
CREATE PROCEDURE findAllCustomers()
BEGIN
    SELECT *
    FROM customers
    WHERE customerNumber = 175;
END$$
DELIMITER ;

-- 5. GOI LAI PROCEDURE: ket qua chi gom khach hang ma so 175
CALL findAllCustomers();

-- 6. XEM DINH NGHIA PROCEDURE HIEN TAI (tuy chon)
SHOW CREATE PROCEDURE findAllCustomers;
