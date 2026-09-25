# AI Prompt Log – PayFlow

> Đây là bộ câu hỏi và phần giải thích AI cung cấp khi chuẩn bị bài này. Hãy đối chiếu, thử nghiệm trên MySQL và chỉnh sửa nhật ký để phản ánh các câu hỏi bạn thực sự đã trao đổi. Không ghi số liệu EXPLAIN giả lập thành kết quả đo thực tế.

## 1. EXPLAIN và ý nghĩa các loại truy cập

**Prompt:** Trong MySQL, `EXPLAIN` có các giá trị `type = ALL`, `index`, `range`, `ref`, `const` như thế nào? `possible_keys`, `key`, `rows`, `Extra` thể hiện điều gì?

**Kiến thức thu được:** `ALL` là quét toàn bảng; `index` là quét toàn bộ index; `range` quét một khoảng khóa; `ref` tìm theo khóa không duy nhất/phần đầu chỉ mục; `const` tìm tối đa một hàng bằng khóa duy nhất với điều kiện bằng. `possible_keys` là các index có thể dùng; `key` là index optimizer chọn; `rows` là ước tính số hàng cần đọc; `Extra` nêu thao tác bổ sung. `ALL` không luôn sai nếu bảng rất nhỏ hoặc truy vấn cần phần lớn dữ liệu.

## 2. SARGable và hàm YEAR/MONTH

**Prompt:** Vì sao `YEAR(created_at) = 2026` có thể không tận dụng B-Tree index thông thường trên `created_at`? SARGable nghĩa là gì?

**Kiến thức thu được:** SARGable là điều kiện mà bộ tối ưu có thể dùng để giới hạn tìm kiếm qua index. Bọc hàm trên cột ngày thường khiến điều kiện không thể dùng index thường để tìm trực tiếp khoảng khóa. Khoảng nửa mở `created_at >= '2026-06-01' AND created_at < '2026-07-01'` giữ được độ chính xác ở cuối tháng và cho phép truy cập range. Index theo biểu thức là một trường hợp khác, nhưng không phải yêu cầu của bài.

## 3. Thứ tự cột trong composite index

**Prompt:** Vì sao index `(transaction_type, created_at)` đặt cột loại giao dịch trước cột thời gian? Đổi thứ tự có ảnh hưởng gì?

**Kiến thức thu được:** Với truy vấn lọc bằng trên `transaction_type` rồi lọc khoảng trên `created_at`, thứ tự này cho phép MySQL tìm nhóm khóa của một loại giao dịch và quét tiếp theo khoảng ngày. B-Tree composite dùng nguyên tắc tiền tố trái; thứ tự phù hợp phụ thuộc các dạng truy vấn khác của hệ thống, không chỉ độ chọn lọc riêng lẻ.

## 4. Index Seek và Index Scan

**Prompt:** Index Seek khác Index Scan thế nào, và B-Tree hỗ trợ hai thao tác này ra sao?

**Kiến thức thu được:** Seek là tìm tới một khóa hoặc điểm đầu của khoảng; Scan là duyệt một chuỗi phần tử của index. Truy vấn `range` thường tìm tới đầu khoảng rồi quét các mục kế tiếp. Trong EXPLAIN MySQL, tên `range`, `ref`, `index` và `ALL` nên được dùng thay vì suy diễn trực tiếp thuật ngữ từ hệ CSDL khác.

## 5. Đo thời gian và phân tích Extra

**Prompt:** Làm thế nào xem thời gian thực thi thật, và `Using index condition` khác `Using index` như thế nào?

**Kiến thức thu được:** MySQL 8.0.18+ có `EXPLAIN ANALYZE`: thực sự chạy truy vấn và hiển thị thời gian, số hàng thực tế và số vòng lặp. `Using index condition` biểu thị Index Condition Pushdown: engine lọc điều kiện bằng index trước khi lấy toàn bộ hàng nếu cần. `Using index` thường thể hiện covering index, khi dữ liệu truy vấn cần có thể lấy từ index. Với index chỉ gồm `transaction_type, created_at`, phép `SUM(amount)` thường vẫn cần đọc `amount` ngoài index.

## 6. Chi phí index và Full Table Scan

**Prompt:** Trong hệ thống INSERT/UPDATE/DELETE liên tục, tạo quá nhiều index có rủi ro gì? Khi nào Full Table Scan có thể hợp lý?

**Kiến thức thu được:** Index chiếm dung lượng lưu trữ, tăng chi phí ghi và bảo trì B-Tree, có thể gây thêm cạnh tranh tài nguyên. Quét toàn bảng có thể rẻ hơn khi bảng nhỏ hoặc truy vấn đọc phần lớn các hàng. Mục tiêu là đo bằng `EXPLAIN`/`EXPLAIN ANALYZE` trên bộ dữ liệu đại diện, không ép mọi truy vấn phải dùng index.

## 7. Thứ tự xử lý logic của SELECT

**Prompt:** Vì sao WHERE được xét trước SELECT và thứ tự xử lý logic của câu SQL là gì?

**Kiến thức thu được:** Có thể hình dung theo logic `FROM/JOIN → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT`. Tuy nhiên, đó là mô hình logic để hiểu SQL, không phải một lịch thực thi vật lý cố định; MySQL optimizer có thể đổi thứ tự và cách xử lý để giảm chi phí.

## Tài liệu đối chiếu

- https://dev.mysql.com/doc/refman/8.4/en/explain.html
- https://dev.mysql.com/doc/refman/8.4/en/column-indexes.html
- https://dev.mysql.com/doc/refman/8.4/en/multiple-column-indexes.html
