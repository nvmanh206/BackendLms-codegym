# Phân tích EXPLAIN – PayFlow

**Môi trường:** MySQL [phiên bản]; Transactions [số dòng].

| Chỉ số | Trước tối ưu | Sau tối ưu |
|---|---|---|
| `type` | [điền] | [điền] |
| `possible_keys` | [điền] | [điền] |
| `key` | [điền] | [điền] |
| `rows` | [điền] | [điền] |
| `Extra` | [điền] | [điền] |

Truy vấn cũ bọc `YEAR()` và `MONTH()` quanh `created_at`, cản trở việc tìm theo khoảng trên B-Tree index thông thường. Giải pháp: tạo index `(transaction_type, created_at)` rồi lọc bằng loại giao dịch và khoảng thời gian nửa mở từ `2026-06-01` đến trước `2026-07-01`.

Ghi kết quả EXPLAIN thực tế vào bảng trên. `type` là phương thức truy cập; `possible_keys` là các index có thể dùng; `key` là index được chọn; `rows` là **ước tính** số hàng cần đọc. Phương án `range` thường có lợi khi khoảng ngày chọn lọc tốt, nhưng MySQL vẫn có thể chọn `ALL` nếu bảng nhỏ hoặc đọc nhiều dòng. Không điền số liệu giả lập thành kết quả đo.

**Bằng chứng:** Đính kèm ảnh EXPLAIN trước và sau tối ưu từ MySQL Workbench.
