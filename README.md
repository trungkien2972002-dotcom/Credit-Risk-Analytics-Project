# 🏛️ End-to-End Credit Risk Analytics & Scorecard Development

> **Dự án:** Xây dựng Mô hình Xếp hạng Tín dụng Nội bộ và Hệ thống Giám sát Rủi ro Danh mục (Credit Scorecard & Risk Dashboard) cho Nova Bank.
> **Phương pháp luận:** Chuẩn hóa Basel II/III (Logistic Regression & WOE Binning).
> **Ngôn ngữ đặc tả kỹ thuật:** Tài liệu Model Development Document (MDD) - 30 trang (Tiếng Việt).

---

## 📊 1. Tổng Quan Bài Toán & Nỗi Đau Doanh Nghiệp (Business Context)

Qua khảo sát hiện trạng danh mục cho vay cũ của Nova Bank, hệ thống phê duyệt cũ đang bộc lộ những lỗ hổng quản trị rủi ro nghiêm trọng, đe dọa trực tiếp đến tính thanh khoản và vốn tự có của ngân hàng:
*   **Tổng quy mô danh mục giải ngân:** 306.02 triệu USD với tổng cộng 31,679 đơn đề nghị vay vốn.
*   **Tỷ lệ nợ xấu (Default Rate) toàn danh mục:** Chạm ngưỡng báo động **21.54%** (Tương đương 6,825 ứng viên vỡ nợ).
*   **Lãi suất cho vay trung bình:** Chỉ đạt **11.04%**. 

**Nghịch lý phản biện:** Về mặt toán học tài chính, một định chế có lãi suất thu về trung bình 11.04% nhưng phải gánh tỷ lệ nợ xấu >21% đồng nghĩa với việc doanh nghiệp đang âm dòng tiền và "tự sát tài chính" do chạy theo KPI doanh số một cách bất chấp. 

Dự án này được tối ưu nhằm mục đích tái cấu trúc lại toàn bộ bộ lọc rủi ro, sửa lỗi hệ thống cũ và thiết lập phanh an toàn cho ngân hàng.

---

## 🛠️ 2. Kiến Trúc Dự Án (Project Architecture)

Repository này được tổ chức khoa học theo chuẩn công nghiệp, tách biệt rõ ràng giữa tài liệu giải pháp và tiến trình thực nghiệm mã nguồn:

```text
Credit-Risk-Analytics-Project/
│
├── 📜 README.md               <-- Bản tóm tắt chiến lược dự án (File này)
│
├── 📂 Documents/              <-- Khối Tài liệu Thẩm định & Giải pháp
│   ├── Model Development Document.pdf  <-- Chiến lược & Thuật toán chi tiết (30 trang Tiếng Việt)
│   └── Presentation Final.pdf             <-- Slide báo cáo Hội đồng Quản trị / Hội đồng Rủi ro
│   └── Portfolio Overview.pdf             <-- Tổng quan danh mục dự án
│   └── Mega Case Study.pdf                <-- Lập luận kinh doanh và thiết kế chính sách rủi ro
├── 📂 Dashboard/              <-- Khối Trực quan hóa & Giám sát Danh mục
│   
└── 📂 Notebook/     <-- Khối Thực nghiệm Mã nguồn (Pipeline từ Sơ khai -> Hoàn thiện)
    ├── 01.Explorarion.ipynb đến 04.Visualize.ipynb <-- Tiền xử lý, EDA & Kỹ nghệ biến số
    └── (1)05.Modeling.ipynb đến (6)05.5 Modeling_03_WOE_Fix(2).ipynb <-- Tiến trình sửa lỗi logic & Scaling
