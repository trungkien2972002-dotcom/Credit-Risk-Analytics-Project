
# 📂 Notebooks & Model Development Pipeline

Thư mục này lưu trữ toàn bộ các tệp Jupyter Notebook (`.ipynb`) ghi lại tiến trình thực nghiệm, nghiên cứu và phát triển hệ thống Mô hình Xếp hạng tín dụng nội bộ (Credit Scorecard) từ những bước sơ khai nhất cho đến mô hình tối ưu cuối cùng áp dụng tại Nova Bank.

Mục tiêu cốt lõi của chuỗi thực nghiệm này không chỉ là tối ưu các chỉ số toán học tài chính (Gini, AUC), mà quan trọng hơn là **phát hiện nghịch lý dữ liệu, hiệu chỉnh lỗi logic ngược dấu hệ số (Sign Reversal), và đảm bảo tính giải thích chuẩn ngành (Model Interpretability)** theo định hướng Basel.

---

## 🏗️ Cấu trúc Tiến trình và Bản đồ Tệp tin

Hệ thống tệp tin được phân loại theo hai khối nhiệm vụ chính: **Khối Chuẩn bị Dữ liệu Nền tảng** và **Khối Tiến trình Thực nghiệm & Hiệu chỉnh Mô hình** (Được đánh số thứ tự từ `(1)` đến `(6)` đồng bộ hoàn toàn với cấu trúc nội dung của Tài liệu Mô tả Phát triển Mô hình - MDD).

### 🛠️ Phần 1: Khối Chuẩn bị Dữ liệu Nền tảng (Data Foundations)
Các tệp tin này thực hiện khâu tiền xử lý, khám phá và chuẩn bị tài nguyên dữ liệu sạch trước khi đưa vào huấn luyện mô hình:
*   `01.Explorarion.ipynb`: Khám phá dữ liệu thô (Exploratory Data Analysis - EDA), khảo sát cấu trúc phân phối của danh mục khách hàng, phân tích sơ bộ tỷ lệ nợ xấu (Default Rate) và xác định các thuộc tính dữ liệu.
*   `02.Clean_data.ipynb`: Thực hiện quy trình làm sạch dữ liệu, xử lý các giá trị khuyết thiếu (Missing values), cô lập và xử lý giá trị ngoại lai (Outliers), chuẩn hóa định dạng biến số phục vụ mô hình hóa.
*   `03.1.Feature_new.ipynb`: Kỹ nghệ biến số (Feature Engineering), khởi tạo các biến phái sinh mới từ tập dữ liệu thô nhằm tăng cường năng lực phân tách rủi ro của mô hình.
*   `04.Visualize.ipynb`: Trực quan hóa mối quan hệ tương quan giữa các biến độc lập và biến mục tiêu, tạo tiền đề kiểm tra phân phối phi tuyến trước khi tiến hành chia khoảng (Binning).

### 📈 Phần 2: Khối Thực nghiệm & Tối ưu hóa Scorecard (Model Iterations)
Chuỗi tệp tin từ `(1)` đến `(6)` thể hiện tư duy phản biện cốt lõi và hành trình "Sửa lỗi hệ thống" để hoàn thiện mô hình tiệm cận thực tế kinh doanh:

*   **(1) 05.Modeling.ipynb**: Thử nghiệm xây dựng các mô hình nền tảng đầu tiên (Baseline Models). Khảo sát sơ bộ hiệu năng của các thuật toán khác nhau trên tập dữ liệu để lựa chọn phương pháp tiếp cận tối ưu.
*   **(2) 05.1Modeling_01_Logistic_Regression.ipynb**: Hiện thực hóa mô hình hồi quy tuyến tính Logistic Regression thô. Đánh giá ban đầu về các hệ số Beta của phương trình.
*   **(3) 05.2 Modeling_02_Logistic_Regression.ipynb**: Tinh chỉnh mô hình Logistic Regression vòng 2. Tập trung vào việc lựa chọn và lọc biến số (Feature Selection)
*   **(4) 05.3 Modeling_03_WOE.ipynb**: Áp dụng phương pháp luận chia khoảng (Binning) chuẩn ngành và mã hóa giá trị trọng số chứng cứ (Weight of Evidence - WOE). Lọc biến số dựa trên chỉ số Information Value (IV).
*   **(5) 05.4 Modeling_03_WOE_Fix.ipynb**: Bước can thiệp kỹ thuật vòng một nhằm khắc phục lỗi ngược dấu của biến DTI. Tiến hành gộp các khoảng binning, tối ưu lại xu hướng biến thiên đơn điệu của WOE để đảm bảo rủi ro cao phải đi kèm điểm số thấp theo đúng logic nghiệp vụ ngân hàng.
*   *Phát hiện quan trọng:* Tại bước này, hệ thống phát hiện ra **lỗi logic ngược dấu (Sign Reversal)** nghiêm trọng do phép biến đổi WOE.
*   **(6) 05.5 Modeling_03_WOE_Fix(2).ipynb (Mô hình Hoàn thiện Cuối cùng)**: Phiên bản tối ưu và hoàn chỉnh nhất của hệ thống Credit Scorecard. 
    *   Giải quyết triệt để bài toán đa cộng tuyến (Kiểm soát hệ số phóng đại phương sai VIF < 2.5).
    *   Thực hiện chuyển đổi hệ số hồi quy Beta thành hệ thống thang điểm tín dụng (Credit Score Scaling) dựa trên các tham số nghiệp vụ (Base Score, Base Odds, PDO).
    *   Chạy các chỉ số kiểm định năng lực phân tách rủi ro toàn diện: ROC-AUC, Hệ số Gini, Thống kê Kolmogorov-Smirnov (K-S), tính toán Điểm cắt hòa vốn (Cut-off Score) và kiểm thử độ ổn định danh mục qua PSI.

---

## 🎯 Điểm Nhấn Tư Duy Nghiệp Vụ Trong Source Code

Nếu bạn là nhà tuyển dụng hoặc chuyên gia thẩm định mô hình (Model Validator), vui lòng chú ý vào các phân đoạn mã nguồn xử lý các bài toán sau để thấy được tư duy phản biện của ứng viên:
1.  **Hàm kiểm soát Monotonic Binning (`WOE_Fix`):** Minh chứng cho việc không phó mặc cho thuật toán tự chạy mà có sự can thiệp của tư duy rủi ro để điều chỉnh mối quan hệ giữa các biến sau biến đổi WOE
2.  **Khâu xử lý Đa cộng tuyến (VIF Matrix):** Loại bỏ các biến gây nhiễu toán học giúp mô hình đạt độ ổn định cao khi mang đi kiểm định áp lực (Stress Testing).
3.  **Hàm Scaling Scorecard:** Đoạn code chuyển đổi toán học từ giá trị log-odds sang điểm số thương mại (ví dụ: Thang điểm 300 - 850), biến một mô hình toán học thuần túy thành một công cụ ra quyết định phê duyệt tự động (Straight-Through Processing - STP) thực tế cho các Chi nhánh.
