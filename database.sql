
-- 1. TẠO DATABASE
CREATE DATABASE IF NOT EXISTS hrms_demo
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE hrms_demo;

-- 2. XÓA BẢNG CŨ THEO ĐÚNG THỨ TỰ KHÓA NGOẠI
DROP TABLE IF EXISTS overtime;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

-- =========================================
-- 3. BẢNG PHÒNG BAN
-- =========================================
CREATE TABLE departments (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    code        VARCHAR(10)  NOT NULL UNIQUE,
    name        VARCHAR(100) NOT NULL,
    note        VARCHAR(255)
);

-- DỮ LIỆU PHÒNG BAN
INSERT INTO departments (code, name, note) VALUES
('HCNS', 'Hành chính - Nhân sự', 'Quản lý hồ sơ, lương, BHXH...'),
('IT',   'Công nghệ thông tin',  'Phát triển & vận hành hệ thống'),
('KD',   'Kinh doanh',           'Chăm sóc khách hàng, doanh số'),
('TC',   'Tài chính - Kế toán',  'Quản lý thu chi, báo cáo tài chính');

-- =========================================
-- 4. BẢNG NHÂN VIÊN
-- =========================================
CREATE TABLE employees (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    code          VARCHAR(10)  NOT NULL UNIQUE,      -- Mã NV (NV001,...)
    fullname      VARCHAR(100) NOT NULL,             -- Họ tên
    department_id INT          NOT NULL,             -- FK sang departments
    position      VARCHAR(100),                      -- Chức danh
    dob           DATE,                              -- Ngày sinh
    gender        ENUM('Nam','Nữ') DEFAULT 'Nam',    -- Giới tính
    salary_coeff  DECIMAL(4,2),                      -- Hệ số lương
    base_salary   INT,                               -- Lương cơ bản (VNĐ) - optional
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_emp_dept FOREIGN KEY (department_id)
        REFERENCES departments(id)
);

-- DỮ LIỆU NHÂN VIÊN
INSERT INTO employees (code, fullname, department_id, position, dob, gender, salary_coeff, base_salary) VALUES
('NV001', 'Nguyễn Văn A',  1, 'Chuyên viên nhân sự',      '1995-01-01', 'Nam', 3.20, 8000000),
('NV002', 'Trần Thị B',    2, 'Lập trình viên',           '1996-03-15', 'Nữ',  3.50, 10000000),
('NV003', 'Lê Văn C',      3, 'Nhân viên kinh doanh',     '1993-07-20', 'Nam', 4.10, 12000000),
('NV004', 'Lại Đức D',     1, 'Nhân viên hợp đồng',       '2000-07-25', 'Nam', 2.60, 6000000),
('NV005', 'Phùng Hồng E',  2, 'Tester',                   '1998-08-07', 'Nữ',  2.85, 9000000),
('NV006', 'Cấn Thảo G',    2, 'Thực tập sinh (Dev)',      '2002-10-20', 'Nữ',  0.00, 0);

-- 5. BẢNG CHẤM CÔNG
-- Ký hiệu:
--   X  - Đi làm
--   P  - Nghỉ phép
--   K  - Nghỉ không phép
--   O  - Ốm / Chế độ
--   CN - Chủ nhật
CREATE TABLE attendance (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    work_date   DATE NOT NULL,
    symbol      ENUM('X','P','K','O','CN') NOT NULL,
    note        VARCHAR(255),
    CONSTRAINT fk_att_emp FOREIGN KEY (employee_id)
        REFERENCES employees(id)
);

-- DỮ LIỆU CHẤM CÔNG
INSERT INTO attendance (employee_id, work_date, symbol, note) VALUES
(1, '2025-12-01', 'X',  NULL),
(1, '2025-12-02', 'P',  'Nghỉ phép năm'),
(1, '2025-12-03', 'X',  NULL),

(2, '2025-12-01', 'X',  NULL),
(2, '2025-12-02', 'X',  NULL),
(2, '2025-12-03', 'O',  'Xin nghỉ ốm'),

(3, '2025-12-01', 'K',  'Nghỉ không phép'),
(3, '2025-12-02', 'X',  NULL),

(4, '2025-12-01', 'X',  NULL),
(4, '2025-12-02', 'X',  NULL),

(5, '2025-12-01', 'X',  NULL),
(5, '2025-12-02', 'X',  NULL),

(6, '2025-12-01', 'CN', 'Chủ nhật'),
(6, '2025-12-02', 'X',  NULL);

-- =========================================
-- 6. BẢNG LÀM THÊM GIỜ (OT)
-- =========================================
-- factor:
--   1.5 = Ngày thường 150%
--   2.0 = Cuối tuần 200%
--   3.0 = Ngày lễ 300%
CREATE TABLE overtime (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    ot_date     DATE NOT NULL,
    hours       DECIMAL(5,2) NOT NULL,    -- Số giờ OT
    factor      DECIMAL(3,1) NOT NULL,    -- Hệ số OT
    hourly_rate INT NOT NULL,             -- Lương 1 giờ (VNĐ)
    amount      INT NOT NULL,             -- Tiền OT = hours * factor * hourly_rate
    note        VARCHAR(255),
    CONSTRAINT fk_ot_emp FOREIGN KEY (employee_id)
        REFERENCES employees(id)
);

-- DỮ LIỆU OT
INSERT INTO overtime (employee_id, ot_date, hours, factor, hourly_rate, amount, note) VALUES
-- NV001: lương cơ bản 8.000.000, giả sử 1 ngày công 22 ngày, 1 ngày 8 giờ
-- Lương giờ ≈ 8,000,000 / 22 / 8 ≈ 45,455
(1, '2025-12-02', 2.0, 1.5, 45455, 136364, 'OT ngày thường 150%'),
-- NV002: lương cơ bản 10.000.000 => giờ ≈ 56,818
(2, '2025-12-05', 3.0, 2.0, 56818, 340908, 'OT cuối tuần 200%');
