# Kết quả dự kiến với dữ liệu mẫu của bài INSERT trước

Đây là **kết quả minh họa theo dữ liệu mẫu**, không phải ảnh chụp hoặc kết quả đã chạy trên MySQL của bạn. Nếu bạn đã thêm hoặc sửa dữ liệu, kết quả thực tế có thể khác.

## Câu 1 — Số học viên theo địa chỉ

| Address | Số lượng học viên |
|---|---:|
| Ha Noi | 1 |
| Hai phong | 1 |
| HCM | 1 |

## Câu 2 — Điểm trung bình theo học viên

| StudentID | StudentName | AverageMark |
|---:|---|---:|
| 1 | Hung | 10 |
| 2 | Hoa | 10 |

Manh không có điểm trong dữ liệu mẫu nên không xuất hiện do dùng `INNER JOIN`.

## Câu 3 — Điểm trung bình lớn hơn 15

Không có bản ghi phù hợp trong dữ liệu mẫu (Hung = 10, Hoa = 10). Đây không phải lỗi SQL.

## Câu 4 — Điểm trung bình cao nhất

| StudentID | StudentName | AverageMark |
|---:|---|---:|
| 1 | Hung | 10 |
| 2 | Hoa | 10 |

Cả hai học viên có cùng điểm trung bình cao nhất; phép so sánh `>= ALL` giữ cả hai.

## Ghi chú

Các giá trị điểm mẫu: Hung học hai môn với điểm 8 và 12, Hoa có một điểm 10. Nếu cột `Mark` trong CSDL được ràng buộc tối đa 10, điểm 12 trong đề INSERT có thể không được nhập thành công; khi đó hãy kiểm tra lại bảng `Mark` thực tế trước khi đối chiếu kết quả.
