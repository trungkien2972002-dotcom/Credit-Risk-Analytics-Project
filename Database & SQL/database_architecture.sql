create schema Risk_Bank
CREATE TABLE Risk_Bank.Dim_Loan_Intent (
    loan_intent_id SERIAL PRIMARY KEY,        -- Khóa số duy nhất, tự động tăng (1, 2, 3...)
    loan_intent_name VARCHAR(50) NOT NULL UNIQUE -- Lưu các giá trị như: PERSONAL, EDUCATION, MEDICAL...
);
INSERT INTO Risk_Bank.Dim_Loan_Intent (loan_intent_name)
SELECT DISTINCT loan_intent 
FROM public."Risk_Dataset" rd 
WHERE loan_intent IS NOT NULL;

select *
from Risk_Bank.Dim_Loan_Intent
limit 5;

CREATE TABLE Risk_Bank.Dim_Home_Ownership (
    home_ownership_id SERIAL PRIMARY KEY,        -- Khóa số duy nhất, tự động tăng
    home_ownership_status VARCHAR(30) NOT NULL UNIQUE -- Lưu các giá trị như: RENT, OWN, MORTGAGE...
);

INSERT INTO Risk_Bank.Dim_Home_Ownership (home_ownership_status)
SELECT DISTINCT person_home_ownership 
FROM public."Risk_Dataset" rd 
WHERE person_home_ownership IS NOT NULL;

select *
from Risk_Bank.Dim_Home_Ownership
limit 5;

CREATE TABLE Risk_Bank.Dim_Geography (
    geo_id SERIAL PRIMARY KEY,                -- Khóa số duy nhất tự tăng
    country VARCHAR(100),
    state VARCHAR(100),
    city VARCHAR(100),
    city_latitude NUMERIC(9,6),
    city_longitude NUMERIC(9,6),
    CONSTRAINT unique_location UNIQUE (country, state, city) -- Đảm bảo không trùng lặp tổ hợp địa lý
);
INSERT INTO Risk_Bank.Dim_Geography (country, state, city, city_latitude, city_longitude)
SELECT 
    country, 
    state, 
    city, 
    MAX(city_latitude) as city_latitude, 
    MAX(city_longitude) as city_longitude
FROM public."Risk_Dataset" rd 
WHERE city IS NOT NULL
GROUP BY country, state, city;

select *
from Risk_Bank.Dim_Geography
limit 5;

CREATE TABLE Risk_Bank.Dim_Customers (
    customer_key SERIAL PRIMARY KEY,          -- Khóa số duy nhất (Surrogate Key) tự tăng
    client_ID VARCHAR(50) NOT NULL UNIQUE,    -- Mã ID gốc từ hệ thống của bạn
    gender VARCHAR(20),
    marital_status VARCHAR(30),
    education_level VARCHAR(50)
);

-- Xóa bảng cũ nếu có để làm sạch cấu trúc
DROP TABLE IF EXISTS Risk_Bank.Dim_Customers;

CREATE TABLE Risk_Bank.Dim_Customers (
    customer_key SERIAL PRIMARY KEY,          -- Khóa số duy nhất tự tăng
    client_id VARCHAR(50) NOT NULL UNIQUE,    -- Đã chuyển thành chữ thường hoàn toàn
    gender VARCHAR(20),
    marital_status VARCHAR(30),
    education_level VARCHAR(50)
);

INSERT INTO Risk_Bank.Dim_Customers (client_id, gender, marital_status, education_level)
SELECT 
    "client_ID" AS client_id,               -- Đọc từ cột gốc chữ hoa và alias về chữ thường
    MAX(gender) as gender,                 
    MAX(marital_status) as marital_status,
    MAX(education_level) as education_level
FROM public."Risk_Dataset" rd 
WHERE "client_ID" IS NOT NULL
GROUP BY "client_ID";

select *
from Risk_Bank.Dim_Customers
limit 5;

CREATE TABLE Risk_Bank.Dim_Customer_Financial_Profile (
    profile_id SERIAL PRIMARY KEY,            -- Khóa số duy nhất tự tăng cho mỗi hồ sơ tài chính
    customer_key INT REFERENCES Risk_Bank.Dim_Customers(customer_key), -- Khóa ngoại nối sang bảng Customer số
    person_age INT,
    person_income NUMERIC(15,2),
    employment_type VARCHAR(50),
    person_emp_length VARCHAR(30),
    emp_length_num NUMERIC(4,1),
    age_bucket VARCHAR(30),                    -- Cột tính toán mới
    income_bucket VARCHAR(50)                  -- Cột tính toán mới
);

INSERT INTO Risk_Bank.Dim_Customer_Financial_Profile (
    customer_key, 
    person_age, 
    person_income, 
    employment_type, 
    person_emp_length, 
    emp_length_num, 
    age_bucket, 
    income_bucket
)
SELECT 
    c.customer_key,                            -- Lấy khóa số từ bảng Dim_Customers đã map xong
    rd.person_age,
    rd.person_income,
    rd.employment_type,
    rd.person_emp_length,
    rd.emp_length_num,
    -- Logic phân nhóm tuổi (Age Bucket)
    CASE 
        WHEN rd.person_age < 25 THEN 'Under 25'
        WHEN rd.person_age BETWEEN 25 AND 34 THEN '25-34'
        WHEN rd.person_age BETWEEN 35 AND 44 THEN '35-44'
        WHEN rd.person_age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55 and Over'
    END AS age_bucket,
    -- Logic phân nhóm thu nhập (Income Bucket)
    CASE 
        WHEN rd.person_income < 30000 THEN 'Low Income (<30k)'
        WHEN rd.person_income BETWEEN 30000 AND 70000 THEN 'Medium Income (30k-70k)'
        WHEN rd.person_income BETWEEN 70001 AND 120000 THEN 'High Income (70k-120k)'
        ELSE 'Very High Income (>120k)'
    END AS income_bucket
FROM public."Risk_Dataset" rd
JOIN Risk_Bank.Dim_Customers c ON rd."client_ID" = c.client_id; -- Join để lấy đúng khóa số duy nhất

SELECT person_age, age_bucket, person_income, income_bucket 
FROM Risk_Bank.Dim_Customer_Financial_Profile 
LIMIT 10;

-- Làm sạch dữ liệu cũ trước khi nạp mới
TRUNCATE TABLE Risk_Bank.Dim_Customer_Financial_Profile;

INSERT INTO Risk_Bank.Dim_Customer_Financial_Profile (
    customer_key, 
    person_age, 
    person_income, 
    employment_type, 
    person_emp_length, 
    emp_length_num, 
    age_bucket, 
    income_bucket
)
SELECT 
    c.customer_key,
    rd.person_age,
    rd.person_income,
    rd.employment_type,
    rd.person_emp_length,
    rd.emp_length_num,
    -- CẬP NHẬT: Logic phân nhóm tuổi chuẩn theo Python Pandas của bạn
    CASE 
        WHEN rd.person_age <= 25 THEN '18-25'
        WHEN rd.person_age > 25 AND rd.person_age <= 35 THEN '26-35'
        WHEN rd.person_age > 35 AND rd.person_age <= 45 THEN '36-45'
        WHEN rd.person_age > 45 AND rd.person_age <= 55 THEN '46-55'
        WHEN rd.person_age > 55 AND rd.person_age <= 65 THEN '56-65'
        WHEN rd.person_age > 65 THEN '66+'
        ELSE 'Unknown'
    END AS age_bucket,
    -- Logic phân nhóm thu nhập (đã đồng bộ ở bước trước)
    CASE 
        WHEN rd.person_income <= 30000 THEN '<30k'
        WHEN rd.person_income > 30000 AND rd.person_income <= 60000 THEN '30-60k'
        WHEN rd.person_income > 60000 AND rd.person_income <= 100000 THEN '60-100k'
        WHEN rd.person_income > 100000 AND rd.person_income <= 200000 THEN '100-200k'
        WHEN rd.person_income > 200000 THEN '200k+'
        ELSE 'Unknown'
    END AS income_bucket
FROM public."Risk_Dataset" rd
JOIN Risk_Bank.Dim_Customers c ON rd."client_ID" = c.client_id;

select *
from Risk_Bank.Dim_Customer_Financial_Profile
limit 5



CREATE TABLE Risk_Bank.Fact_Loan_Applications (
    application_id SERIAL PRIMARY KEY,
    
    -- Các khóa ngoại nối sang các bảng Dim (Kiểu số để tối ưu hiệu năng)
    customer_key INT REFERENCES Risk_Bank.Dim_Customers(customer_key),
    profile_id INT REFERENCES Risk_Bank.Dim_Customer_Financial_Profile(profile_id),
    geo_id INT REFERENCES Risk_Bank.Dim_Geography(geo_id),
    loan_intent_id INT REFERENCES Risk_Bank.Dim_Loan_Intent(loan_intent_id),
    home_ownership_id INT REFERENCES Risk_Bank.Dim_Home_Ownership(home_ownership_id),
    
    -- Các trường dữ liệu gốc (đã chuyển về chữ thường)
    loan_grade CHAR(1),
    loan_amnt NUMERIC(15,2),
    loan_int_rate NUMERIC(5,2),
    loan_status SMALLINT,              -- Biến mục tiêu (Target)
    loan_percent_income NUMERIC(5,2),
    loan_term_months INT,
    loan_to_income_ratio NUMERIC(5,2),
    cb_person_default_on_file VARCHAR(5),
    cb_person_cred_hist_length INT,
    other_debt NUMERIC(15,2),
    debt_to_income_ratio NUMERIC(5,2),
    open_accounts INT,
    credit_utilization_ratio NUMERIC(5,2),
    past_delinquencies INT,
    
    -- Các cột TÍNH TOÁN MỚI được tạo sẵn bằng SQL
    installment_amount NUMERIC(15,2),
    installment_to_income_ratio NUMERIC(5,2),
    total_debt_after_loan NUMERIC(15,2),
    has_delinquency_flag SMALLINT,
    credit_age_bucket VARCHAR(50),
    credit_utilization_bucket VARCHAR(50),
    interest_rate_bucket VARCHAR(50),
    loan_amount_bucket VARCHAR(50)
);
INSERT INTO Risk_Bank.Fact_Loan_Applications (
    customer_key, profile_id, geo_id, loan_intent_id, home_ownership_id,
    loan_grade, loan_amnt, loan_int_rate, loan_status, loan_percent_income,
    loan_term_months, loan_to_income_ratio, cb_person_default_on_file,
    cb_person_cred_hist_length, other_debt, debt_to_income_ratio,
    open_accounts, credit_utilization_ratio, past_delinquencies,
    installment_amount, installment_to_income_ratio, total_debt_after_loan,
    has_delinquency_flag, credit_age_bucket, credit_utilization_bucket,
    interest_rate_bucket, loan_amount_bucket
)
SELECT 
    c.customer_key,
    p.profile_id,
    g.geo_id,
    i.loan_intent_id,
    h.home_ownership_id,
    src.loan_grade,
    src.loan_amnt,
    src.loan_int_rate,
    src.loan_status,
    src.loan_percent_income,
    src.loan_term_months,
    src.loan_to_income_ratio,
    src.cb_person_default_on_file,
    src.cb_person_cred_hist_length,
    src.other_debt,
    src.debt_to_income_ratio,
    src.open_accounts,
    src.credit_utilization_ratio,
    src.past_delinquencies,
    
    -- 1. Tính số tiền trả định kỳ (installment_amount)
    -- Công thức: (Gốc / Kỳ hạn) + Lãi tháng của toàn bộ khoản vay
    (src.loan_amnt / src.loan_term_months) + (src.loan_amnt * (src.loan_int_rate / 100) / 12) AS installment_amount,
    
    -- 2. Tỷ lệ trả nợ trên thu nhập tháng (installment_to_income_ratio)
    ((src.loan_amnt / src.loan_term_months) + (src.loan_amnt * (src.loan_int_rate / 100) / 12)) / NULLIF((src.person_income / 12), 0) AS installment_to_income_ratio,
    
    -- 3. Tổng nợ sau khi vay (total_debt_after_loan)
    src.other_debt + src.loan_amnt AS total_debt_after_loan,
    
    -- 4. Cờ đánh dấu đã từng trễ hạn (has_delinquency_flag)
    CASE WHEN src.past_delinquencies > 0 OR src.cb_person_default_on_file = 'Y' THEN 1 ELSE 0 END AS has_delinquency_flag,
    
    -- 5. Nhóm thâm niên tín dụng (credit_age_bucket)
    CASE 
        WHEN src.cb_person_cred_hist_length <= 2 THEN 'New Credit (<2 years)'
        WHEN src.cb_person_cred_hist_length BETWEEN 3 AND 5 THEN 'Established (3-5 years)'
        ELSE 'Long History (>5 years)'
    END AS credit_age_bucket,
    
    -- 6. Nhóm sử dụng hạn mức tín dụng (credit_utilization_bucket)
    CASE 
        WHEN src.credit_utilization_ratio <= 0.3 THEN 'Good (<30%)'
        WHEN src.credit_utilization_ratio > 0.3 AND src.credit_utilization_ratio <= 0.7 THEN 'Moderate (30%-70%)'
        ELSE 'High Risk (>70%)'
    END AS credit_utilization_bucket,
    
    -- 7. Nhóm lãi suất (interest_rate_bucket)
    CASE 
        WHEN src.loan_int_rate <= 8.0 THEN 'Low (<8%)'
        WHEN src.loan_int_rate > 8.0 AND src.loan_int_rate <= 12.0 THEN 'Medium (8%-12%)'
        ELSE 'High (>12%)'
    END AS interest_rate_bucket,
    
    -- 8. Nhóm số tiền vay (loan_amount_bucket)
    CASE 
        WHEN src.loan_amnt <= 5000 THEN 'Small (<5k)'
        WHEN src.loan_amnt > 5000 AND src.loan_amnt <= 15000 THEN 'Medium (5k-15k)'
        ELSE 'Large (>15k)'
    END AS loan_amount_bucket

FROM public."Risk_Dataset" src -- Đọc chính xác từ schema gốc của bạn
JOIN Risk_Bank.Dim_Customers c ON src."client_ID" = c.client_id
JOIN Risk_Bank.Dim_Customer_Financial_Profile p ON c.customer_key = p.customer_key AND src.person_age = p.person_age AND src.person_income = p.person_income
JOIN Risk_Bank.Dim_Geography g ON src.country = g.country AND src.state = g.state AND src.city = g.city
JOIN Risk_Bank.Dim_Loan_Intent i ON src.loan_intent = i.loan_intent_name
JOIN Risk_Bank.Dim_Home_Ownership h ON src.person_home_ownership = h.home_ownership_status;

select *
from Risk_Bank.Fact_Loan_Applications
limit 5

-- Bước 1 (Tùy chọn): Xóa sạch dữ liệu cũ trong bảng Fact nếu bạn đã lỡ nạp trước đó
TRUNCATE TABLE Risk_Bank.Fact_Loan_Applications;

-- Bước 2: Chạy lệnh INSERT hoàn chỉnh đã đồng bộ cả 4 cột theo mô hình Python
INSERT INTO Risk_Bank.Fact_Loan_Applications (
    customer_key, profile_id, geo_id, loan_intent_id, home_ownership_id,
    loan_grade, loan_amnt, loan_int_rate, loan_status, loan_percent_income,
    loan_term_months, loan_to_income_ratio, cb_person_default_on_file,
    cb_person_cred_hist_length, other_debt, debt_to_income_ratio,
    open_accounts, credit_utilization_ratio, past_delinquencies,
    installment_amount, installment_to_income_ratio, total_debt_after_loan,
    has_delinquency_flag, credit_age_bucket, credit_utilization_bucket,
    interest_rate_bucket, loan_amount_bucket
)
SELECT 
    c.customer_key,
    p.profile_id,
    g.geo_id,
    i.loan_intent_id,
    h.home_ownership_id,
    src.loan_grade,
    src.loan_amnt,
    src.loan_int_rate,
    src.loan_status,
    src.loan_percent_income,
    src.loan_term_months,
    src.loan_to_income_ratio,
    src.cb_person_default_on_file,
    src.cb_person_cred_hist_length,
    src.other_debt,
    src.debt_to_income_ratio,
    src.open_accounts,
    src.credit_utilization_ratio,
    src.past_delinquencies,
    
    -- Các trường tính toán số học gốc giữ nguyên
    (src.loan_amnt / src.loan_term_months) + (src.loan_amnt * (src.loan_int_rate / 100) / 12) AS installment_amount,
    ((src.loan_amnt / src.loan_term_months) + (src.loan_amnt * (src.loan_int_rate / 100) / 12)) / NULLIF((src.person_income / 12), 0) AS installment_to_income_ratio,
    src.other_debt + src.loan_amnt AS total_debt_after_loan,
    CASE WHEN src.past_delinquencies > 0 OR src.cb_person_default_on_file = 'Y' THEN 1 ELSE 0 END AS has_delinquency_flag,
    
    -- 1. ĐÃ ĐỒNG BỘ: Khớp theo hàm credit_age_bucket(x) mới nhất
    CASE 
        WHEN src.cb_person_cred_hist_length < 1 THEN 'very_short'
        WHEN src.cb_person_cred_hist_length >= 1 AND src.cb_person_cred_hist_length < 3 THEN 'short'
        WHEN src.cb_person_cred_hist_length >= 3 AND src.cb_person_cred_hist_length < 5 THEN 'medium'
        ELSE 'long'
    END AS credit_age_bucket,
    
    -- 2. ĐÃ ĐỒNG BỘ: Khớp theo hàm utilization_bucket(x) ở bước trước
    CASE 
        WHEN src.credit_utilization_ratio < 0.3 THEN 'low'
        WHEN src.credit_utilization_ratio >= 0.3 AND src.credit_utilization_ratio < 0.6 THEN 'medium'
        WHEN src.credit_utilization_ratio >= 0.6 AND src.credit_utilization_ratio < 0.9 THEN 'high'
        ELSE 'critical'
    END AS credit_utilization_bucket,
    
    -- 3. ĐÃ ĐỒNG BỘ: Khớp theo interest_rate_bucket từ pd.cut
    CASE 
        WHEN src.loan_int_rate <= 5.0 THEN '<5%'
        WHEN src.loan_int_rate > 5.0 AND src.loan_int_rate <= 10.0 THEN '5-10%'
        WHEN src.loan_int_rate > 10.0 AND src.loan_int_rate <= 15.0 THEN '10-15%'
        WHEN src.loan_int_rate > 15.0 AND src.loan_int_rate <= 20.0 THEN '15-20%'
        WHEN src.loan_int_rate > 20.0 THEN '20%'
        ELSE 'Unknown'
    END AS interest_rate_bucket,
    
    -- 4. ĐÃ ĐỒNG BỘ: Khớp theo loan_amount_bucket từ pd.cut
    CASE 
        WHEN src.loan_amnt <= 2000 THEN '<2k'
        WHEN src.loan_amnt > 2000 AND src.loan_amnt <= 5000 THEN '2-5k'
        WHEN src.loan_amnt > 5000 AND src.loan_amnt <= 10000 THEN '5-10k'
        WHEN src.loan_amnt > 10000 AND src.loan_amnt <= 20000 THEN '10-20k'
        WHEN src.loan_amnt > 20000 THEN '20k+'
        ELSE 'Unknown'
    END AS loan_amount_bucket

FROM public."Risk_Dataset" src
JOIN Risk_Bank.Dim_Customers c ON src."client_ID" = c.client_id
JOIN Risk_Bank.Dim_Customer_Financial_Profile p ON c.customer_key = p.customer_key AND src.person_age = p.person_age AND src.person_income = p.person_income
JOIN Risk_Bank.Dim_Geography g ON src.country = g.country AND src.state = g.state AND src.city = g.city
JOIN Risk_Bank.Dim_Loan_Intent i ON src.loan_intent = i.loan_intent_name
JOIN Risk_Bank.Dim_Home_Ownership h ON src.person_home_ownership = h.home_ownership_status;

select *
from Risk_Bank.Fact_Loan_Applications
limit 5