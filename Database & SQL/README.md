# 🗄️ Database Architecture & Data Warehousing (SQL)

Thư mục này quản lý toàn bộ mã nguồn SQL được thực thi trên môi trường **DBeaver** để xử lý dữ liệu thô (Pre-processing), xây dựng mô hình kho dữ liệu thu nhỏ (Data Mart) phục vụ cho hệ thống Dashboard và Mô hình hóa.

## 📐 Kiến Trúc Mô Hình Dữ Liệu (Star Schema)

Để tối ưu hóa hiệu năng truy vấn cho Power BI và đồng bộ dữ liệu đầu vào cho Python, cấu trúc dữ liệu đã được chuẩn hóa từ dạng bảng phẳng (Flat table) sang mô hình **Kho dữ liệu dạng Sao (Star Schema)** bao gồm:

*   **Bảng Fact (Fact_Loans):** Lưu trữ các thông tin định lượng của khoản vay bao gồm ID khách hàng, Số tiền giải ngân (Loan Amount), Lãi suất (Interest Rate), Điểm số hệ thống, và Trạng thái vỡ nợ (Default Indicator).
*   **Các bảng Chiều (Dim_Customers, Dim_Geography, Dim_Employment):** Lưu trữ các thông tin định tính dùng để phân đoạn rủi ro như Thu nhập (Income), Học vấn (Education), Thành phố/Quốc gia (City/Country), và Trạng thái việc làm (Employment Status).

## ⚡ Các Kỹ Thuật SQL Được Áp Dụng trong `data_warehouse_schema.sql`
1.  **Dùng DDL (Data Definition Language):** Khởi tạo cấu trúc bảng, định nghĩa khóa chính (Primary Key), khóa ngoại (Foreign Key) để đảm bảo tính toàn vẹn dữ liệu (Referential Integrity).
2.  **Xử lý dữ liệu khuyết thiếu & Chuẩn hóa (Data Cleansing):** Sử dụng các hàm điều kiện (`CASE WHEN`, `COALESCE`) để làm sạch các trường dữ liệu bị trống hoặc sai định dạng thô.
3.  **Tối ưu hóa hiệu năng:** Phân tách dữ liệu giúp Power BI giảm tải dung lượng file `.pbix`, tăng tốc độ tải các biểu đồ tương tác động.
