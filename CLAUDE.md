# MES Powder — khuôn màn hình (mockup)

Bản sao mã nguồn canvas "MES Powder — khuôn màn hình" trên claude.ai
(https://claude.ai/artifact/UVtFtHptFq4JiVwW7oUBcV). Canvas là nơi chạy và xem; repo này là nơi sửa.

## Cấu trúc
- `project/canvas.json` — danh sách màn (board): vị trí, kích thước, tiêu đề "số · tên màn", thứ tự. Thêm / bỏ màn phải sửa cả `boards` và `order`.
- `project/*.dc.html` — mỗi file là 1 màn. Hai loại:
  - File lớn (BanHang, KhoVH, LenhSX, ChatLuong, KeToan…): chứa giao diện + logic của cả phân hệ.
  - File nhỏ (~1 KB): chỉ `<dc-import name="..." screen="..." start="...">` gọi file lớn với trạng thái hiển thị khác nhau. Sửa giao diện → sửa file lớn.
- `project/ds/mespowder/` — hệ thiết kế: `tokens.css` (màu, cỡ, khoảng cách), `components/bundle.css` (mọi lớp `mp-*` dùng chung), font.
- `mp-scroll.js` (bản đúng, nạp qua `/_blob/1ac7da4f2947094995f1ad52291bf36c`) — thanh cuộn nổi. `project/mp-scroll.js` là bản cũ, bỏ qua.

## Định dạng file .dc.html (bắt buộc, sai là hỏng im lặng)
- Giữ nguyên dòng `<script src="./support.js"></script>` trong `<head>`; sau đó là link `tokens.css`, `bundle.css`, rồi script thanh cuộn.
- Giao diện nằm trong `<x-dc>…</x-dc>`; CSS riêng màn trong `<helmet><style>`.
- `{{ten}}` chỉ là tra cứu (`{{a.b}}`), không viết biểu thức. Tính trong `renderVals()`.
- Lặp / rẽ nhánh: `<sc-for list="{{ds}}" as="x">`, `<sc-if value="{{dk}}">`. Sự kiện: `onClick="{{ham}}"`.
- Logic: `<script type="text/x-dc" data-dc-script data-props='…'>` với `class Component extends DCLogic { renderVals() {…} }` — JS thường, không import/export, không tự dựng giao diện bằng `innerHTML`.
- Đóng mọi thẻ, đặt mọi thuộc tính trong ngoặc kép.

## Quy ước giao diện
- Dùng lớp có sẵn trong `bundle.css` (mp-btn, mp-table, mp-xs, mp-form, mp-field, mp-input, mp-doc, mp-lot…) trước khi viết CSS mới. Sửa kiểu dùng chung → sửa `bundle.css`, ghi chú `/* … (chốt dd/mm) */`.
- Chữ tiếng Việt, cỡ nền 18px, bảng 16px; người dùng lớn tuổi nên nút / ô nhập ≥ 44px.
- Bảng rộng bọc trong `.mp-xs > .mp-xs__body`; cột đầu dính trái, cột thao tác dùng `.mp-rowact`.

## Xem thử
Chạy ở máy: `node serve.mjs` (trong `mockup/`), mở http://localhost:4321/. Trang này có danh sách màn theo `canvas.json` và lọc được; mở từng màn qua `/<Man>.dc.html`.
- `support.js` được phục vụ từ `runtime/artifact-type/dc-runtime.js` (runtime của canvas, untracked). Nếu thiếu, tải lại `artifact-type/dc-runtime.js` từ artifact canvas ở trên vào `runtime/`.
- Lỗi console kiểu `{{x.url}}` 404 là do trình duyệt đọc HTML thô trước khi runtime điền giá trị. Lỗi này vô hại.
- Bản chính vẫn là canvas: kiểm lại trên canvas sau khi đẩy lên.

## Đẩy thay đổi lên canvas
Canvas giới hạn 200 lần lưu / ngày → gom thay đổi, đẩy 1 lần.
1. `git add -A && git commit`
2. `git diff --name-only HEAD~1` → danh sách file đã sửa.
3. Gửi các file đó vào một phiên chat trong Project "Powder", nhờ Claude đẩy lên canvas bằng 1 lần lưu (publish_files, mode patch).

## Tài liệu nghiệp vụ
- docs/mes-powder-quy-trinh.md — quy trình, vai trò × chức năng, màn ↔ bước quy trình
- docs/mes-powder-du-lieu.md + .sql — bảng, cột, ràng buộc (PostgreSQL 16)
- Sửa bảng: sửa docs/mes-powder-mo-hinh-du-lieu.json rồi sinh lại, không sửa tay .sql