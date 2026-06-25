# 📊 Credit Risk Analytics Dashboard (Power BI)

Thư mục này quản lý hệ thống báo cáo quản trị rủi ro trực quan (Interactive Dashboard) được xây dựng trên nền tảng **Power BI**. Hệ thống được thiết kế theo tư duy cấu trúc từ bức tranh tổng thể danh mục (Macro) đi sâu vào phân đoạn rủi ro cục bộ (Micro) để phục vụ khâu ra quyết định chính sách tại Nova Bank.

---

## 💾 Tệp Nguồn & Hướng Dẫn Truy Cập

*   **Tệp nguồn chính:** `Dashboard.pbix`
    *   *Cách sử dụng:* Tải tệp tin này về máy tính và mở bằng phần mềm *Power BI Desktop* để trải nghiệm toàn bộ các tính năng tương tác động (Dynamic Filtering, Drill-down, Tooltips, Slice & Dice).
*   **Phương án xem nhanh (Fallback Previews):** Phòng trường hợp nhà tuyển dụng không cài đặt sẵn môi trường Power BI, hệ thống 4 tệp ảnh tĩnh `.png` dưới đây ghi lại trọn vẹn giao diện và các phát hiện dữ liệu quan trọng của từng phân hệ báo cáo.

---

## 🖼️ Đặc Tả Hệ Thống Giao Diện & Câu Chuyện Dữ Liệu

Hệ thống dashboard được chia làm 4 phân hệ tương ứng với 4 tab điều hướng chuyên nghiệp tại Sidebar bên trái:

### 1️⃣ Overview.png — Tổng Quan Sức Khỏe Danh Mục (Executive Overview)
*   **Mục tiêu chiến lược:** Cung cấp cái nhìn toàn cảnh cho Giám đốc Khối Rủi ro (CRO) về mức độ nghiêm trọng của danh mục cũ.
*   **Chỉ số KPI cốt lõi:** Làm nổi bật tổng quy mô giải ngân (306.02M USD), tổng số đơn (31,679) và tỷ lệ nợ xấu báo động (21.54%).
*   **Điểm nhấn phân tích:** Biểu đồ phân rã mục đích vay và hồ sơ thu nhập chỉ ra lỗ hổng của bộ lọc cũ khi phân phối vốn quá lớn vào các phân khúc có biên độ rủi ro cao.

### 2️⃣ Default by Country.png — Phân Đoạn Địa Lý & Nhân Khẩu Học (Macro Risk)
*   **Mục tiêu chiến lược:** Nhận diện và cô lập các ổ rủi ro theo vị trí địa lý và đặc tính khách hàng.
*   **Điểm nhấn phân tích:** Ứng dụng biểu đồ cấu trúc cây (Tree-map) cho biến thành phố và phân rã các nhóm tuổi, hình thức việc làm. Chứng minh rằng nợ xấu không phân bổ đồng đều theo quốc gia mà tập trung cục bộ ở một số đô thị lớn (như Vancouver, Manchester) và nhóm khách hàng trẻ tuổi.

### 3️⃣ Default By Customers.png — Thẩm Định Phân Tầng Tín Dụng (Micro Credit Risk)
*   **Mục tiêu chiến lược:** Đánh giá năng lực phân tách rủi ro của hệ thống xếp hạng tín dụng và thiết lập ranh giới phê duyệt.
*   **Điểm nhấn phân tích:** Ma trận `Loan Grade` kết hợp dải màu Gradient trực quan hóa dòng nợ xấu vọt lên tới 98.44% ở nhóm hạng G. Phân hệ này là cơ sở nghiệp vụ để đề xuất chiến lược đóng băng nhóm F, G (Hard Reject) và áp dụng định giá theo rủi ro (Risk-Based Pricing) cho nhóm Vùng Vàng (Hạng D, E) dựa trên biến DTI và LTI.

### 4️⃣ Correlation.png — Phân Tích Tương Quan Phi Tuyến (Statistical Insights)
*   **Mục tiêu chiến lược:** Chứng minh tính khoa học và logic nghiệp vụ của các biến số độc lập trước khi đưa vào mô hình hóa.
*   **Điểm nhấn phân tích:** Sử dụng hệ thống biểu đồ phân tán (Scatter Plots) thể hiện hình thái biến thiên phi tuyến (như phân phối hình chữ S của biến DTI và LTI đối với tỷ lệ vỡ nợ). Đây là bằng chứng trực quan giải thích lý do tại sao phương pháp chia khoảng (Binning) và mã hóa WOE lại tối ưu hơn việc đưa dữ liệu thô vào mô hình tuyến tính.

---

## 🎨 Tiêu Chuẩn Thiết Kế Hệ Thống (UI/UX Standards)

*   **Tư duy phần mềm (Product-minded Layout):** Thiết kế Sidebar động bên trái tạo trải nghiệm nhất quán giống như một hệ thống phần mềm quản trị nội bộ thực tế tại ngân hàng.
*   **Bảng màu tài chính (Color Palette):** Sử dụng tông màu xanh dương chủ đạo (Trust Blue) đại diện cho sự tin cậy, kết hợp màu sắc cảnh báo rủi ro có độ tương phản cao ở các phân đoạn nợ xấu đậm để hướng sự tập trung của người dùng vào các vùng nguy hiểm.
