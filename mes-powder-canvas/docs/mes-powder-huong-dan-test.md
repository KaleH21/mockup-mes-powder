# MES Powder — hướng dẫn test dữ liệu trên mockup

Cập nhật 04/11/2026. Viết theo mockup đã đồng bộ ngày 04/11. Gồm 139 board và 26 quy trình.

File này dành cho người test nghiệp vụ và QA. Người đọc mở canvas "MES Powder — khuôn màn hình" rồi đi qua từng board. Mỗi board có các trường hợp dữ liệu cần thử. Mỗi trường hợp ghi kết quả đúng phải thấy.

Quy tắc nghiệp vụ gốc nằm ở [mes-powder-quy-trinh.md](mes-powder-quy-trinh.md). Cấu trúc dữ liệu nằm ở [mes-powder-du-lieu.md](mes-powder-du-lieu.md). Khi mockup và hai file đó nói khác nhau, ghi lại thành lỗi, đừng tự chọn bên nào đúng.

## Mục lục

1. Cách test trên canvas
2. Menu bên trái theo vai trò
3. So cùng một mã giữa các phân hệ
4. Trường hợp test theo từng phân hệ
   - 4.1. Chung — đăng nhập, việc cần làm, tổng quan Giám đốc, hồ sơ và biểu mẫu in
   - 4.2. Bán hàng — đơn hàng, khách hàng, giao hàng, hóa đơn
   - 4.3. Mua hàng & Kế toán
   - 4.4. Kho
   - 4.5. Sản xuất — lệnh sản xuất, tiến độ, công thức
   - 4.6. Chất lượng — yêu cầu kiểm, phiếu kiểm, phiếu chứng nhận, mẫu lưu
   - 4.7. Truy xuất & thu hồi
   - 4.8. Danh mục — nguyên vật liệu, sản phẩm, hồ sơ pháp lý chung, đơn vị
   - 4.9. Nhà máy, khu vực & quản trị hệ thống
5. Chỗ lệch đã thấy khi viết hướng dẫn (chưa sửa)

## 1. Cách test trên canvas

**Board là gì.** Canvas là một mặt phẳng lớn, mỗi khung trên đó là một **board**. Mỗi board là một màn hình ở một tình huống cụ thể. Tiêu đề board có dạng "số · tên màn — tình huống", ví dụ "12 · Đơn hàng — QT06 chờ kiểm công nợ (nợ quá hạn)". Hướng dẫn này gọi board theo số đó. Các board được xếp thành hàng theo phân hệ: Chung, Bán hàng, Mua hàng, Kế toán, Kho, Sản xuất, Chất lượng, Truy xuất & thu hồi, Danh mục, Nhà máy & quản trị.

**Ba cách đổi dữ liệu để test:**

1. **Đổi ô trong panel "Trạng thái hiển thị".**
   - Bấm chọn một board. Panel "Trạng thái hiển thị" mở ra ở bên phải.
   - Panel có các ô chọn. Các ô hay gặp:
     - `vaitro` hoặc `nguoiXem`: đang xem với vai trò nào.
     - `tinhhuong`, `buoc`, `cheDo`, `trangthai`, `hopthoai`, `start`, `man`: board đang ở bước nào hoặc mở hộp thoại nào.
     - `ma`, `chon`: đang xem phiếu hay mã nào.
     - `ketNoi`: nhà máy đang có hay mất kết nối mạng.
     - `noi` hoặc `side`: xem ở máy chủ trung tâm (`cloud`) hay máy chủ đặt tại nhà máy (`nm`, `local`).
     - `nhamay`: nhà máy NM1 hay NM2.
   - Đổi một ô thì board vẽ lại ngay với dữ liệu tương ứng.
   - Board nhỏ chỉ có vài ô, vì nó gọi lại một board lớn với tình huống đặt sẵn. Muốn thử hết lựa chọn thì mở board lớn của phân hệ, thường là board đầu hàng.
2. **Bấm ngay trong board.** Tab, bộ lọc, nút "Lưu" / "Duyệt" / "Từ chối" và hộp thoại đều bấm được. Hãy thử lưu khi bỏ trống ô bắt buộc, nhập số vượt mức, rồi xem câu báo và trạng thái sau khi bấm. Mockup không lưu thật. Thay đổi do bấm chỉ hiện trên board đang mở, không sang board khác. Đổi một ô trong panel thường làm board nạp lại từ đầu, mất các thao tác đã bấm. Vì vậy hãy chỉnh ô trước rồi mới bấm. Nhiều board còn có ô "Xem như" ở thanh trên cùng để đổi vai trò ngay trong board, dùng được cả khi panel không có ô `vaitro`.
3. **So cùng một mã giữa các board.** Một đơn, phiếu hoặc lô xuất hiện ở nhiều board phải có cùng trạng thái, số lượng, số tiền và người làm. Xem mục 3.

**Ghi kết quả test.** Mỗi dòng trong các bảng ở mục 4 là một trường hợp. Gợi ý ghi lỗi:
- số board;
- các ô đã chỉnh, ví dụ `vaitro` = `Kế toán`, `hopthoai` = `tien-ve`;
- đã bấm gì;
- thấy gì;
- lẽ ra phải thấy gì.

**Những điều cần biết trước khi test:**
- Mockup chỉ chạy trên canvas. Mở file `.dc.html` trên máy sẽ không chạy.
- Mã chứng từ sinh tại nhà máy luôn có tiền tố nhà máy. Ví dụ: phiếu nhập `PN-NM1-2610-0031`, phiếu xuất `PX-NM1-…`, phiếu chuyển `PC-NM1-…`, phiếu kiểm kho `PK-NM1-…`, phiếu hủy `PH-NM1-…`, yêu cầu kiểm `YC-NM1-…`, phiếu kiểm chất lượng `QC-NM1-…`, phiếu chứng nhận `CN-NM1-…`, mẫu lưu `ML-NM1-…`. Thấy mã kiểu cũ không có `NM1` / `NM2`, ví dụ `PN-2610-0031`, `KK-…`, `YC-QC-…`, là lỗi.
- Mã do máy chủ trung tâm sinh thì không có tiền tố nhà máy: đơn hàng `ĐH-…`, PO `PO-…`, lệnh sản xuất `LSX-…`, truy xuất `TX-…`, hồ sơ thu hồi `TH-…`.
- "Ngoại tuyến" là nhà máy mất kết nối với máy chủ trung tâm. Máy chủ đặt tại nhà máy vẫn chạy.

## 2. Menu bên trái theo vai trò

Mỗi vai trò chỉ thấy các mục menu của mình. Cách test:
1. Mở một board có ô `vaitro`.
2. Lần lượt đổi từng vai trò.
3. So menu bên trái với bảng dưới. Mục thừa hoặc thiếu đều là lỗi.

Bảng sinh từ dữ liệu menu trong mockup ngày 04/11. "Việc cần làm" thì mọi vai trò đều thấy.

| Vai trò | Mục menu phải thấy (theo nhóm) |
|---|---|
| Admin | Việc cần làm; Bán hàng: Đơn hàng, Khách hàng; Mua hàng: Đơn mua, Nhà cung cấp, Trả hàng NCC; Kế toán: Công nợ khách hàng, Công nợ NCC, Sổ thu chi; Kho: Tồn kho, Nhập kho, Xuất kho, Chuyển kho, Kiểm kho, Hủy hàng; Sản xuất: Lệnh sản xuất, Tiến độ lệnh; Chất lượng: Yêu cầu kiểm, Phiếu kiểm, Phiếu chứng nhận, Mẫu lưu; Truy xuất: Truy xuất, Hồ sơ thu hồi; Danh mục: Nguyên vật liệu, Công thức, Sản phẩm, Hồ sơ pháp lý, Đơn vị, Kho, Nhà cung cấp (danh mục), Nhà máy, Khu vực làm việc; Quản trị: Người dùng & vai trò, Tham số & định dạng mã, Nhật ký hệ thống |
| CSKH | Việc cần làm; Bán hàng: Khách hàng; Truy xuất: Hồ sơ thu hồi |
| Giám đốc | Việc cần làm; Bán hàng: Đơn hàng, Khách hàng; Mua hàng: Đơn mua, Nhà cung cấp, Trả hàng NCC; Kế toán: Công nợ khách hàng, Công nợ NCC, Sổ thu chi; Kho: Tồn kho, Nhập kho, Xuất kho, Chuyển kho, Kiểm kho, Hủy hàng; Sản xuất: Lệnh sản xuất, Tiến độ lệnh; Chất lượng: Yêu cầu kiểm, Phiếu kiểm, Phiếu chứng nhận, Mẫu lưu; Truy xuất: Truy xuất, Hồ sơ thu hồi; Danh mục: Nguyên vật liệu, Công thức, Sản phẩm, Hồ sơ pháp lý, Đơn vị, Kho, Nhà cung cấp (danh mục), Nhà máy, Khu vực làm việc; Quản trị: Người dùng & vai trò, Tham số & định dạng mã, Nhật ký hệ thống |
| HR | Việc cần làm; Quản trị: Người dùng & vai trò, Nhật ký hệ thống |
| Kế hoạch | Việc cần làm; Bán hàng: Đơn hàng; Mua hàng: Đơn mua; Kho: Tồn kho, Nhập kho, Xuất kho, Chuyển kho, Hủy hàng; Sản xuất: Lệnh sản xuất, Tiến độ lệnh; Chất lượng: Yêu cầu kiểm, Phiếu kiểm, Phiếu chứng nhận; Danh mục: Nguyên vật liệu, Công thức, Sản phẩm, Hồ sơ pháp lý, Đơn vị, Nhà cung cấp (danh mục) |
| Kế toán | Việc cần làm; Bán hàng: Đơn hàng; Kế toán: Công nợ khách hàng, Công nợ NCC, Sổ thu chi; Kho: Tồn kho, Nhập kho, Hủy hàng; Danh mục: Nhà cung cấp (danh mục) |
| Kế toán trưởng | Việc cần làm; Bán hàng: Đơn hàng; Kế toán: Công nợ khách hàng, Công nợ NCC, Sổ thu chi; Truy xuất: Hồ sơ thu hồi; Danh mục: Nhà cung cấp (danh mục) |
| Mua hàng | Việc cần làm; Mua hàng: Đơn mua, Nhà cung cấp, Trả hàng NCC; Kho: Tồn kho, Nhập kho, Xuất kho; Danh mục: Nguyên vật liệu, Sản phẩm, Hồ sơ pháp lý, Đơn vị, Nhà cung cấp (danh mục) |
| Người truy xuất | Việc cần làm; Truy xuất: Truy xuất, Hồ sơ thu hồi |
| QC | Việc cần làm; Kho: Hủy hàng; Sản xuất: Lệnh sản xuất, Tiến độ lệnh; Chất lượng: Yêu cầu kiểm, Phiếu kiểm, Phiếu chứng nhận, Mẫu lưu; Truy xuất: Hồ sơ thu hồi; Danh mục: Nguyên vật liệu, Công thức, Sản phẩm, Hồ sơ pháp lý, Đơn vị, Nhà cung cấp (danh mục) |
| QC trưởng | Việc cần làm; Chất lượng: Yêu cầu kiểm, Phiếu kiểm, Phiếu chứng nhận; Truy xuất: Hồ sơ thu hồi; Danh mục: Nguyên vật liệu, Sản phẩm, Hồ sơ pháp lý, Đơn vị |
| R&D | Việc cần làm; Danh mục: Công thức, Hồ sơ pháp lý |
| Sales | Việc cần làm; Bán hàng: Đơn hàng, Khách hàng; Kế toán: Công nợ khách hàng; Kho: Tồn kho, Xuất kho, Hủy hàng; Chất lượng: Phiếu chứng nhận; Truy xuất: Hồ sơ thu hồi |
| Thủ kho | Việc cần làm; Mua hàng: Đơn mua, Trả hàng NCC; Kho: Tồn kho, Nhập kho, Xuất kho, Chuyển kho, Kiểm kho, Hủy hàng; Sản xuất: Lệnh sản xuất; Chất lượng: Yêu cầu kiểm, Phiếu kiểm; Truy xuất: Truy xuất; Danh mục: Nguyên vật liệu, Sản phẩm, Đơn vị, Nhà cung cấp (danh mục) |
| Thủ kho trưởng | Việc cần làm; Kho: Tồn kho, Nhập kho, Xuất kho, Chuyển kho, Kiểm kho, Hủy hàng; Chất lượng: Yêu cầu kiểm, Phiếu kiểm; Danh mục: Nguyên vật liệu, Sản phẩm, Hồ sơ pháp lý, Đơn vị, Kho, Nhà cung cấp (danh mục), Nhà máy |
| Thủ kho điều phối | Việc cần làm; Mua hàng: Đơn mua, Trả hàng NCC; Kho: Tồn kho, Nhập kho, Xuất kho, Chuyển kho, Kiểm kho, Hủy hàng; Sản xuất: Lệnh sản xuất, Tiến độ lệnh; Chất lượng: Yêu cầu kiểm, Phiếu kiểm; Truy xuất: Truy xuất; Danh mục: Nguyên vật liệu, Sản phẩm, Đơn vị |
| Trưởng BP Mua hàng | Việc cần làm; Mua hàng: Đơn mua, Nhà cung cấp, Trả hàng NCC; Danh mục: Nguyên vật liệu, Sản phẩm, Hồ sơ pháp lý, Đơn vị, Nhà cung cấp (danh mục) |
| Vận chuyển | Việc cần làm; Kho: Chuyển kho |

Phải kiểm thêm:
- Bấm từng mục menu phải mở đúng màn. Không mục nào dẫn tới trang trống.
- Menu không còn mục "Giao hàng". Giao hàng chỉ ghi nhận trong tab Giao hàng của đơn.
- Danh mục › Nhà cung cấp có vai trò được xem, không để trống.
- Trả hàng NCC có vai trò Trưởng BP Mua hàng.
- Hai mục trong Danh mục mở màn khác tên:
  - Danh mục › Kho mở màn Nhà máy, vì kho khai báo trong nhà máy.
  - Danh mục › Khu vực làm việc mở màn Khu (board 111).
- Ô `vaitro` của nhiều board chỉ có vài vai trò liên quan. Vai trò không có trong ô là vai trò không vào màn đó.

## 3. So cùng một mã giữa các phân hệ

Một chứng từ đi qua nhiều phân hệ thì mọi board nhắc tới nó phải khớp nhau về trạng thái, số lượng, số tiền, ngày và người làm. Bảng dưới liệt kê các mã xuất hiện ở từ hai phân hệ trở lên. Giá trị đúng của từng mã ghi ở bảng "Mã mẫu" cuối mỗi phân hệ trong mục 4.

Cách test: mở lần lượt các board ghi trong bảng, tìm mã đó, so từng ô. Chỗ lệch đã biết ghi ở mục 5; chỗ lệch mới thì báo lỗi.

| Mã | Là gì | Mở các board này để so |
|---|---|---|
| B261018-02 | Lô BTP của mẻ 3, lô bột bị khóa, yêu cầu kiểm | Sản xuất: 62; Nhà máy, khu vực & quản trị hệ thống: 120, 122, 123 |
| KH-0012 | Khách An Khang, nợ quá hạn | Chung: 2, 7; Bán hàng: 9, 10, 12 đến 15, 22 đến 24; Mua hàng & Kế toán: 36, 39 |
| L-BOT-01 | Lô bột sữa nguyên kem tại NM1-TONG | Kho: 41, 51; Sản xuất: 62; Truy xuất & thu hồi: 88, 90; Nhà máy, khu vực & quản trị hệ thống: 108 (gán cứng Silo 1 khu NM1-KBTP1), 122, 123 |
| LSX-2610-0009 | Lệnh BTP Đang chạy, đơn ĐH-2610-0028, SP-0001 | Sản xuất: 52, 62, 63, 64, 65, 66; Nhà máy, khu vực & quản trị hệ thống: 108, 111, 123 |
| LSX-2610-0011 | Ba lệnh Chờ phát khi mất mạng | Sản xuất: 52, 61, 62; Nhà máy, khu vực & quản trị hệ thống: 108, 111 |
| PC-NM1-2610-0013 | Phiếu chuyển kho NM1-TONG → NM1-DP | Chung: 2, 6, 8; Kho: 42, 49, 49b; Nhà máy, khu vực & quản trị hệ thống: 120 |
| PK-NM1-2610-0005 | Phiếu kiểm kho lô A260928 | Chung: 2, 7, 8; Kho: 42, 50, 50b |
| PN-NM1-2610-0031 | Phiếu nhập hàng từ nhà cung cấp, nhận thiếu 1 bao | Chung: 2, 7, 8; Kho: 41 (tham chiếu), 42, 43, 44 |
| PO-2610-0020 | Đơn mua trên 100 triệu, chờ Giám đốc duyệt thêm | Chung: 2, 5, 7; Mua hàng & Kế toán: 31 |
| PX-NM1-2610-0044 | Phiếu xuất bán thiếu 48 lon (432/480) | Chung: 2, 8; Kho: 42, 45 |
| SP-0004 | Nhãn C · Sữa bột người lớn · 900 g | Sản xuất: 57, 58; Danh mục: 99, 101 |
| TH-2609-0003 | Hồ sơ thu hồi chờ đóng | Chung: 2, 5, 7; Truy xuất & thu hồi: 92, 96 |
| TH-2610-0003 | Hồ sơ thu hồi lô A261011 (độ ẩm 5,4 %) chờ Giám đốc quyết | Chung: 2, 4, 5, 7, 8; Truy xuất & thu hồi: 92, 93, 94 |
| YC-NM1-2610-0021 | Yêu cầu kiểm nguyên vật liệu chờ QC trưởng duyệt | Chung: 2, 3, 4; Chất lượng: 68, 70, 73, 74 |
| YC-NM1-2610-0023 | Lô BTP của mẻ 3, lô bột bị khóa, yêu cầu kiểm | Sản xuất: 62; Chất lượng: 68, 71; Nhà máy, khu vực & quản trị hệ thống: 120, 122 |
| ĐH-2610-0022 | Đơn bán cho Nhà thuốc Minh Châu | Chung: 8; Bán hàng: 9, 27, 28, 22 |
| ĐH-2610-0034 | Đơn của khách KH-0012 An Khang, xin tăng hạn mức | Chung: 2, 5, 7; Bán hàng: 9, 12, 13, 14, 15, 22 |
| ĐH-2610-0048 | Hai đơn xin duyệt hủy | Chung: 2, 5, 7; Sản xuất: 53, 54 |

## 4. Trường hợp test theo từng phân hệ

Mỗi board có một bảng trường hợp: cột "Làm gì" là ô cần chỉnh trong panel "Trạng thái hiển thị" hoặc nút cần bấm, cột "Phải thấy" là kết quả đúng lấy từ mockup ngày 04/11. Cuối mỗi phân hệ có bảng mã mẫu và giá trị phải khớp.

### 4.1. Chung — đăng nhập, việc cần làm, tổng quan Giám đốc, hồ sơ và biểu mẫu in

Phần này kiểm màn đăng nhập (board 1), màn Việc cần làm của từng vai trò kèm chuông thông báo và menu tài khoản (board 2 đến 6), màn Tổng quan của Giám đốc (board 7) và màn tra cứu, in lại phiếu đã ký (board 8). Lưu ý chung: các board 3 đến 6 là board 2 đã chỉnh sẵn ô, nên cách kiểm và kết quả giống board 2.

#### 1 · Đăng nhập (web)
Mở board này để kiểm: màn đăng nhập hiện đúng từng tình huống (bình thường, sai mật khẩu, tài khoản bị khóa, đăng nhập lần đầu).
Ô chỉnh trong "Trạng thái hiển thị": `trangThai` → `Bình thường`, `Sai mật khẩu`, `Tài khoản bị khóa tạm`, `Tài khoản đã khóa (nghỉ việc)`, `Đăng nhập lần đầu` (mặc định). Board này không có ô vai trò. Danh sách ô tổng hợp không ghi ô này, nhưng trong file board có khai báo, nên panel sẽ hiện.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Đăng nhập lần đầu | `trangThai` = `Đăng nhập lần đầu` | Khung xanh "Đăng nhập lần đầu · NV0562. Đổi mật khẩu tạm Admin / HR đã cấp trước khi dùng hệ thống." Có 2 ô trống "Mật khẩu mới", "Nhập lại mật khẩu mới", gợi ý "Tối thiểu 8 ký tự, có chữ và số" và nút "Đổi mật khẩu và vào hệ thống". Không có ô "Mã nhân viên" (quy tắc: lần đầu hoặc sau mật khẩu tạm thì bắt đổi mật khẩu). |
| 2 | Bình thường | `trangThai` = `Bình thường` | Form có ô "Mã nhân viên" = `NV0123`, ô "Mật khẩu" đã điền sẵn, ô tích "Ghi nhớ trên máy này", nút "Đăng nhập". Không có khung báo lỗi. |
| 3 | Sai mật khẩu | `trangThai` = `Sai mật khẩu` | Form như dòng 2 (mã `NV0123`), thêm khung đỏ phía trên: "Sai mã nhân viên hoặc mật khẩu. Kiểm tra lại, chú ý chữ hoa / thường." |
| 4 | Tài khoản bị khóa tạm do lâu không dùng | `trangThai` = `Tài khoản bị khóa tạm` | Khung đỏ: "Tài khoản đang bị khóa tạm do không đăng nhập quá 90 ngày. Liên hệ Admin để mở khóa." Form vẫn hiện, ô mã là `NV0226` (quy tắc: tự khóa khi quá 90 ngày không đăng nhập). |
| 5 | Tài khoản đã khóa vì nghỉ việc | `trangThai` = `Tài khoản đã khóa (nghỉ việc)` | Khung đỏ: "Tài khoản đã khóa do nghỉ việc — không đăng nhập được, thẻ NV cũng bị chặn. Nếu có nhầm lẫn, liên hệ HR." Ô mã là `NV0457` (quy tắc: thẻ của tài khoản đã khóa bị chặn ngay). |
| 6 | Phần chân khung | Mọi tình huống | Dòng "Quên mật khẩu? Liên hệ Admin để được cấp mật khẩu tạm." và nhãn "Có ở cloud và ở máy chủ nhà máy" (nhãn này cho biết màn vẫn chạy khi nhà máy mất mạng). |
| 7 | Bấm nút | Bấm "Đăng nhập" hoặc "Đổi mật khẩu và vào hệ thống" | Mockup chỉ vẽ màn: không kiểm mật khẩu, không báo lỗi thêm, không chuyển trang. Ghi nhận là đúng thiết kế, không phải lỗi. |

#### 2 · Việc cần làm — chờ tôi duyệt
Mở board này để kiểm: mỗi vai trò thấy đúng những việc của mình ở đúng tab, nút duyệt và từ chối chạy đúng, hộp trống, chuông thông báo và menu tài khoản.
Ô chỉnh trong "Trạng thái hiển thị": `vaitro` → 17 vai trò (mặc định `Thủ kho trưởng`); `tab` → `Chờ tôi duyệt` (mặc định), `Được giao cho tôi`, `Tôi đã gửi`; `popover` → `Đóng` (mặc định), `Thông báo`, `Tài khoản`. Trên màn, ba tab tên là "Chờ duyệt", "Được giao", "Đã gửi", mỗi tab kèm số việc chưa xong. Ngoài panel còn có ô chọn "Xem như" ở góc trên phải màn, thêm vai trò `R&D`. Sau khi chỉnh panel, nên bấm tab và chuông ngay trên màn để thử tiếp.

Cách mockup chia việc: việc thuộc về một người (theo tên), không theo tên vai trò. Vì vậy `Thủ kho trưởng` và `QC trưởng` là cùng một người (Trần Thị Mai, đang giữ ủy quyền QC trưởng đến 21/10), thấy cùng một danh sách. `QC` và `Người truy xuất` cũng cùng một người (Ngô Thu Trang).

Số việc mỗi vai trò thấy lúc mở (Chờ duyệt / Được giao / Đã gửi):

| Vai trò | Chờ duyệt | Được giao | Đã gửi | Hộp trống |
|---|---|---|---|---|
| `Thủ kho trưởng`, `QC trưởng` | 17 | 4 | 2 | không có hộp trống |
| `Giám đốc` | 8 | 0 | 0 | tab "Được giao" và "Đã gửi" |
| `Kế toán trưởng` | 5 | 0 | 0 | tab "Được giao" và "Đã gửi" |
| `Trưởng BP Mua hàng` | 5 | 0 | 1 | tab "Được giao" |
| `Thủ kho` | 0 | 11 | 9 | tab "Chờ duyệt" |
| `Thủ kho điều phối` | 0 | 1 | 1 | tab "Chờ duyệt" |
| `Kế hoạch` | 0 | 8 | 5 | tab "Chờ duyệt" |
| `Mua hàng` | 0 | 6 | 7 | tab "Chờ duyệt" |
| `Sales` | 0 | 6 | 3 | tab "Chờ duyệt" |
| `QC`, `Người truy xuất` | 0 | 7 | 1 | tab "Chờ duyệt" |
| `Kế toán` | 0 | 5 | 0 | "Chờ duyệt" và "Đã gửi" |
| `CSKH` | 0 | 2 | 0 | "Chờ duyệt" và "Đã gửi" |
| `HR` | 0 | 1 | 1 | tab "Chờ duyệt" |
| `Admin` | 0 | 1 | 0 | "Chờ duyệt" và "Đã gửi" |
| `Vận chuyển` (và `R&D` ở ô "Xem như") | 0 | 0 | 0 | cả ba tab |

Hộp trống hiện một dòng: "Không có việc nào ở mục này."

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Thủ kho trưởng, tab chờ duyệt | Mặc định (`vaitro` = `Thủ kho trưởng`, `tab` = `Chờ tôi duyệt`) | Tiêu đề "Việc cần làm", dòng "Việc đang đợi Trần Thị Mai (Thủ kho trưởng, QC trưởng) từ mọi phân hệ". Tab "Chờ duyệt 17". Khung "9 việc chờ quá 1 ngày". Khung "Đang giữ vai trò ủy quyền: QC trưởng — thay Võ Thanh Hà (công tác), NM1, đến hết 21/10/2026." Danh sách chia nhóm "Kho · Thủ kho trưởng NM1" rồi "Chất lượng · QC trưởng (ủy quyền đến 21/10)". Dòng đầu: PN-NM1-2610-0031 "Xác nhận chênh lệch nhập", chờ từ 17/10 09:12, ghi "quá 1 ngày". Phân trang "1–10 / 17"; sang trang 2 thấy "11–17 / 17". |
| 2 | Chuyển phạm vi vai trò | Bấm "Chỉ Thủ kho trưởng · 11", rồi "Chỉ QC trưởng (ủy quyền) · 12" (bấm `vaitro` = `QC trưởng` để thấy nút thứ hai), rồi "Mọi vai trò của tôi · 23" | Chế độ "Chỉ Thủ kho trưởng": khung quá hạn còn "6 việc chờ quá 1 ngày", chỉ còn nhóm Kho. Chế độ chỉ QC trưởng: "3 việc chờ quá 1 ngày". Chỉ người giữ hai vai trò cùng lúc (Trần Thị Mai) mới có nhóm nút phạm vi này. Các vai trò khác không có. |
| 3 | Nút bị khóa vì chưa tới lượt | Với Thủ kho trưởng xem 17 việc, tìm PK-NM1-2610-0005 (kk05d), YC-NM1-2610-0023, YC-NM1-2610-0021 (kết luận) | PK-NM1-2610-0005 ghi "Đang chờ Thủ kho" kèm nút "Xem như Thủ kho"; YC-NM1-2610-0023 ghi "Đang chờ Kế hoạch" kèm "Xem như Kế hoạch"; dòng "Duyệt kết luận QC" của YC-NM1-2610-0021 ghi "Đang chờ QC" kèm "Xem như QC". Ba dòng này chưa có nút Duyệt và Từ chối. |
| 4 | Duyệt nhanh | Với YC-NM1-2610-0022, bấm nút "Duyệt" (biểu tượng dấu tích) | Dòng chuyển thành "Đã duyệt · Trần Thị Mai" (màu xanh), thanh báo "Đã duyệt · YC-NM1-2610-0022 — đã ghi nhận.", số trên tab "Chờ duyệt" giảm 1, số "việc chờ quá 1 ngày" không đổi vì dòng này không quá hạn. |
| 5 | Từ chối thiếu lý do | Với YC-NM1-2610-0021, bấm "Từ chối", để trống ô lý do, bấm "Từ chối" trong hộp thoại | Hộp thoại "Từ chối · YC-NM1-2610-0021", nhãn "Lý do gửi lại cho người lập", ô có dấu sao bắt buộc. Báo đỏ "Ghi lý do trước khi từ chối." Hộp thoại vẫn mở. Nhập lý do rồi bấm lại thì dòng thành "Đã từ chối · Trần Thị Mai", kèm "Lý do: ...". Thanh báo "Đã từ chối YC-NM1-2610-0021 — lý do đã gửi cho người lập." |
| 6 | Từ chối đề nghị ngừng dùng mã | Với NVL-PGA-0003 (hoặc SP-0006), bấm "Từ chối" | Hộp thoại nhãn "Lý do từ chối", nút "Xác nhận từ chối". Để trống thì báo "Nhập lý do từ chối — người đề xuất sẽ thấy lý do này." Sau khi lưu: "Đã từ chối · Trần Thị Mai", "Lý do: ... — mã giữ Đang dùng". |
| 7 | Nút có tên khác | Với TH-2609-0003 (duyệt phương án khắc phục) bấm "Trả lại sửa"; với `Thủ kho` bấm "Không thực hiện được" ở PC-NM1-2610-0021; với `Kế hoạch` xem "Xác nhận" ở LSX-2610-0009 | Trả lại sửa: để trống thì báo "Ghi lý do trước khi trả lại sửa."; sau khi lưu dòng ghi "Trả lại sửa", thanh báo "Trả lại sửa · TH-2609-0003 — lý do đã gửi cho người lập." Không thực hiện được: để trống thì báo "Ghi lý do trước khi báo không thực hiện được." Việc của Kế hoạch ở LSX-2610-0009 chỉ có nút xác nhận, không có nút từ chối. |
| 8 | Một việc xong mở khóa việc kia | Đổi `vaitro` = `Thủ kho`, ở PK-NM1-2610-0005 bấm "Gửi kết quả đếm"; quay lại `Thủ kho trưởng` | Dòng của PK-NM1-2610-0005 hết chữ "Đang chờ Thủ kho", có đủ nút Duyệt và Từ chối. Tương tự: `Kế hoạch` gửi lại YC-NM1-2610-0023 thì `QC trưởng` duyệt được; `QC` gửi QC trưởng duyệt YC-NM1-2610-0021 thì dòng kết luận mở khóa sau khi QC trưởng duyệt yêu cầu kiểm. |
| 9 | Giám đốc: việc chỉ mở ra xem | `vaitro` = `Giám đốc` | Tab "Chờ duyệt 8", khung "2 việc chờ quá 1 ngày" (ĐH-2610-0054, TH-2609-0002). Chỉ PO-2610-0020 (duyệt thêm PO trên ngưỡng) có nút Duyệt, Từ chối. Các dòng còn lại (TH-2610-0003, ĐH-2610-0039, ĐH-2610-0048...) chỉ có nút "Mở". ĐH-2610-0034 ghi "Đang chờ Kế toán" (chờ khách trả nợ quá hạn); TH-2609-0003 ghi "Đang chờ QC trưởng". Nhóm tên là "Giám đốc". |
| 10 | Kế toán trưởng | `vaitro` = `Kế toán trưởng` | Chờ duyệt 5: ĐH-2610-0054, ĐH-2610-0034, ĐH-2610-0039, ĐH-2610-0048, TH-2609-0002 (cùng việc với Giám đốc, trừ PO-2610-0020, TH-2610-0003 và TH-2609-0003). Một trong hai người duyệt là đủ (quy tắc: Giám đốc hoặc Kế toán trưởng, một người duyệt là đủ). Hai tab còn lại trống. |
| 11 | Tab "Đã gửi": nhắc người duyệt | `vaitro` = `Thủ kho`, `tab` = `Tôi đã gửi`, bấm "Nhắc" ở PN-NM1-2610-0031 | 9 dòng. Mỗi dòng ghi "Đang chờ" kèm người nhận, ví dụ "Việc của Thủ kho trưởng" và nút "Xem như Thủ kho trưởng". Sau khi bấm Nhắc: thanh báo "Đã nhắc Trần Thị Mai về PN-NM1-2610-0031.", nút đổi thành "Đã nhắc". Dòng PO-2610-0019 của `Mua hàng` ghi lý do "người lập không tự duyệt". |
| 12 | Kết quả duyệt truyền về người gửi | Làm bước 4 (duyệt YC-NM1-2610-0022), rồi đổi `vaitro` = `Thủ kho`, xem tab "Đã gửi" | Dòng YC-NM1-2610-0022 hiện "Đã duyệt · Trần Thị Mai" thay cho "Đang chờ". Nếu đã từ chối ở bước 5 thì dòng YC-NM1-2610-0021 ở `Kế hoạch` hiện "Đã từ chối · Trần Thị Mai" cùng lý do. |
| 13 | Chuông thông báo | `popover` = `Thông báo` | Bảng mở sẵn: "Thông báo", nút "Đánh dấu tất cả đã đọc", hai tab "Chưa đọc 3" và "Tất cả". Với Thủ kho trưởng, tab Chưa đọc có 3 mục: PN-NM1-2610-0031 (10 phút trước · Kho), lô A241012 hết hạn kèm đề nghị hủy PH-NM1-2610-0012 (13/10 06:00 · Hệ thống), LSX-2610-0011 chưa tới server NM1 quá 10 phút (2 giờ trước). Tab "Tất cả" có 6 mục (thêm nhắc nợ KH-0012, ủy quyền QC trưởng hết hạn 21/10, và tin "Server nhà máy NM1 mất kết nối từ 08:12"). Bấm "Đánh dấu tất cả đã đọc": số đỏ trên chuông biến mất, tab Chưa đọc hiện "Không còn thông báo chưa đọc.", tab Tất cả vẫn 6 mục nhưng hết tô nền. |
| 14 | Chuông theo vai trò | Đổi `vaitro` rồi nhìn số đỏ | Chưa đọc: `Giám đốc` 3 (PO-2610-0020, TH-2610-0003, ĐH-2610-0039), `Kế toán trưởng` 1, `Kế toán` 1 (ĐH-2610-0034 chờ kiểm công nợ), `Admin` 1 (HR đề nghị mở khóa NV0226), `Mua hàng` 4, `Trưởng BP Mua hàng` 2, `Sales` 2. `HR`, `Vận chuyển`, `R&D`: không có số đỏ, tab Tất cả chỉ có tin mất kết nối NM1. Tin mất kết nối NM1 hiện cho mọi vai trò. |
| 15 | Menu tài khoản của Thủ kho trưởng | `popover` = `Tài khoản` | Thẻ tên "Trần Thị Mai", dòng "NV0045 · Thủ kho trưởng NM1". Hai thẻ vai trò: "Thủ kho trưởng" (NM1-TONG · NM1-DP · NM1-BTP · NM1-MAUQC) và "QC trưởng · tạm" (NM1 · 15/10 → 21/10/2026). Khối "Đang giữ ủy quyền QC trưởng — Thay Võ Thanh Hà (NV0088, công tác) · Nhà máy NM1 · 15/10 → 21/10/2026 · còn 3 ngày" và "HR Hoàng Thị Lan lập 14/10/2026 16:20 — hết hạn hệ thống tự gỡ", liên kết "Xem ở Ủy quyền tạm". Các mục: "Hồ sơ của tôi", "Vai trò & ủy quyền", "Đổi mật khẩu", "Đăng xuất". |
| 16 | Menu tài khoản của vai trò khác | `popover` = `Tài khoản`, lần lượt `Ngô Thu Trang` (`QC`), `Tạ Văn Hùng` (`Trưởng BP Mua hàng`), `Giám đốc` | `QC`: hai thẻ vai trò "QC" (NM1) và "Người truy xuất" (Mọi nhà máy). `Trưởng BP Mua hàng`: "Trưởng BP Mua hàng" và "Mua hàng". Các vai trò này không có khối ủy quyền. `Giám đốc`, `Admin`, `CSKH`, `Vận chuyển` chưa có hồ sơ riêng: chỉ một thẻ vai trò, dòng phụ là tên vai trò, không có mã nhân viên. |
| 17 | Đổi mật khẩu | Từ menu tài khoản bấm "Đổi mật khẩu", thử lần lượt: bỏ trống ô hiện tại; mật khẩu mới `abc`; mật khẩu mới `abcdefg1` nhưng nhập lại `abcdefg2`; nhập đúng | Hộp thoại "Đổi mật khẩu · Trần Thị Mai", gợi ý "Ít nhất 8 ký tự, có cả chữ và số". Lỗi lần lượt: "Nhập mật khẩu hiện tại." / "Mật khẩu mới ít nhất 8 ký tự, có cả chữ và số." / "Nhập lại không khớp mật khẩu mới." Đúng thì hộp thoại đóng, thanh báo "Đã đổi mật khẩu. Lần đăng nhập sau dùng mật khẩu mới." (Cần bấm ra khỏi ô trước khi bấm "Lưu mật khẩu" để ô nhận giá trị.) |

#### 3 · Việc cần làm — được giao cho tôi · chuông thông báo mở
Mở board này để kiểm: tab "Được giao" của Thủ kho trưởng, kèm bảng chuông đang mở.
Ô chỉnh trong "Trạng thái hiển thị": không có, chỉ bấm trong board (board này gọi board 2 với `vaitro` = `Thủ kho trưởng`, `tab` = `Được giao cho tôi`, `popover` = `Thông báo`). Có thể bấm tab và đổi "Xem như" ở góc trên.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Danh sách được giao | Mở board | Tab "Được giao 4" đang chọn. Cột: Việc, Liên quan, Cần làm, Giao bởi, Tình trạng · hạn. Nhóm "Kho · Thủ kho trưởng NM1" có PC-NM1-2610-0018 "Xử lý hàng hư khi nhận chuyển kho" (Chưa xử lý, hạn Hôm nay, giao bởi Hồ Văn Nam). Nhóm "Chất lượng · QC trưởng (ủy quyền đến 21/10)" có CN-12 và CN-13 "Ký phiếu chứng nhận" (đều Chưa ký, hạn Hôm nay) và TH-2610-0001 "Báo cơ quan tiến độ thu hồi" (Chưa làm, hạn 24/10). Không có phân trang vì chỉ 4 dòng. |
| 2 | Chuông mở | Mở board | Bảng thông báo mở sẵn với 3 mục chưa đọc, giống dòng 13 của board 2. Chuông hiện số 3. |
| 3 | Đóng chuông | Bấm biểu tượng chuông | Bảng đóng, số 3 vẫn còn (chưa đánh dấu đã đọc). Bấm "Việc chờ duyệt ở Việc cần làm →" trong bảng thì bảng đóng và chuyển sang tab "Chờ duyệt". |
| 4 | Việc giao bởi hệ thống | Xem dòng CN-12, CN-13 | "Giao bởi" ghi "Hệ thống sau kết luận Đạt 17/10 16:20" và "...18/10 08:05"; ghi chú "Lô chưa giao được tới khi có phiếu ký." |

#### 4 · Việc cần làm — tôi đã gửi · menu tài khoản mở
Mở board này để kiểm: tab "Đã gửi" của Thủ kho trưởng, kèm menu tài khoản đang mở.
Ô chỉnh trong "Trạng thái hiển thị": không có, chỉ bấm trong board (board này gọi board 2 với `vaitro` = `Thủ kho trưởng`, `tab` = `Tôi đã gửi`, `popover` = `Tài khoản`).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Danh sách đã gửi | Mở board | Tab "Đã gửi 2". Cột: Việc, Chứng từ, Tóm tắt, Đang chờ, Gửi lúc. Dòng PK-NM1-2610-0003 "Duyệt điều chỉnh kiểm kho" (sổ 200 kg, đếm 175 kg, điều chỉnh −25 kg), đang chờ Thủ kho trưởng NM2, lý do "người ra lệnh không tự duyệt". Dòng TH-2610-0003 "Quyết định thu hồi", đang chờ Giám đốc, nút "Xem như Giám đốc". |
| 2 | Menu tài khoản mở | Mở board | Menu mở sẵn với nội dung như dòng 15 của board 2 (tên, hai thẻ vai trò, khối ủy quyền, 4 mục). |
| 3 | Nhắc người duyệt | Bấm "Nhắc" ở PK-NM1-2610-0003 | Thanh báo "Đã nhắc Nguyễn Văn Tùng về PK-NM1-2610-0003." Nút đổi thành "Đã nhắc". |
| 4 | Việc đang chờ Giám đốc không tự xong | Bấm "Xem như Giám đốc" ở TH-2610-0003, xem tab "Chờ duyệt" | Đổi sang Giám đốc; TH-2610-0003 chỉ có nút "Mở để quyết" (không có nút duyệt nhanh), nên dòng "Đã gửi" của Thủ kho trưởng vẫn "Đang chờ". |

#### 5 · Việc cần làm — Giám đốc (chờ duyệt)
Mở board này để kiểm: màn Việc cần làm của Giám đốc ở tab chờ duyệt.
Ô chỉnh trong "Trạng thái hiển thị": không có, chỉ bấm trong board (board này gọi board 2 với `vaitro` = `Giám đốc`, `tab` = `Chờ tôi duyệt`, `popover` = `Đóng`).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Danh sách | Mở board | Dòng "Việc đang đợi Lê Quang Minh (Giám đốc) từ mọi phân hệ", không có khung ủy quyền. Tab "Chờ duyệt 8", "Được giao 0", "Đã gửi 0". Khung "2 việc chờ quá 1 ngày". 8 dòng, một nhóm "Giám đốc": PO-2610-0020, ĐH-2610-0054, ĐH-2610-0034, TH-2610-0003, TH-2609-0003, ĐH-2610-0039, ĐH-2610-0048, TH-2609-0002. Không có phân trang. |
| 2 | Duyệt PO trên ngưỡng | Bấm "Duyệt" ở PO-2610-0020 | Dòng "Đã duyệt · Lê Quang Minh"; thanh báo "Đã duyệt · PO-2610-0020 — đã ghi nhận." Số tab còn 7. Số tiền tóm tắt: 2.000 kg × 88.000 đ = 176.000.000 đ. |
| 3 | Từ chối PO | Bấm "Từ chối" ở PO-2610-0020 và để trống lý do | Báo "Ghi lý do trước khi từ chối." |
| 4 | Việc bị khóa | Xem ĐH-2610-0034 và TH-2609-0003 | ĐH-2610-0034 "Đang chờ Kế toán" với nút "Xem như Kế toán" (khách An Khang cần trả nợ quá hạn, đơn 1.344.600.000 đ, hạn mức 1.500.000.000 đ). TH-2609-0003 "Đang chờ QC trưởng". Bấm "Xem như QC trưởng", duyệt phương án khắc phục TH-2609-0003, quay lại Giám đốc: dòng đổi sang "Chờ bạn". |
| 5 | Cùng việc với Kế toán trưởng | Đổi "Xem như" sang `Kế toán trưởng` | 5 việc chung (ĐH-2610-0054, ĐH-2610-0034, ĐH-2610-0039, ĐH-2610-0048, TH-2609-0002); không còn PO-2610-0020, TH-2610-0003, TH-2609-0003. |

#### 6 · Việc cần làm — Thủ kho (được giao)
Mở board này để kiểm: tab "Được giao" của Thủ kho (Lê Văn Hải), có phân trang.
Ô chỉnh trong "Trạng thái hiển thị": không có, chỉ bấm trong board (board này gọi board 2 với `vaitro` = `Thủ kho`, `tab` = `Được giao cho tôi`, `popover` = `Đóng`).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Danh sách và phân trang | Mở board | "Được giao 11", "Chờ duyệt 0", "Đã gửi 9". Nhóm "Kho · Thủ kho NM1-TONG". Dòng đầu PN-NM1-2610-0033 "Nhận hàng BTP vào kho" (Chưa nhận, hạn Hôm nay, 50 thùng, 1.200 lon). Phân trang "1–10 / 11"; trang 2 chỉ có PK-NM1-2610-0005 "Đếm kiểm điểm" (Đang kiểm). |
| 2 | Nút làm việc | Ở PC-NM1-2610-0021 bấm "Bắt đầu xuất" | Dòng thành "Đang xuất · Lê Văn Hải"; thanh báo "Đang xuất · PC-NM1-2610-0021 — đã ghi nhận." |
| 3 | Không thực hiện được | Bấm "Không thực hiện được" ở PC-NM1-2610-0021, bỏ trống lý do | Báo "Ghi lý do trước khi báo không thực hiện được." |
| 4 | Nhận hàng chuyển kho | Bấm "Xác nhận đã nhận" ở PC-NM1-2610-0013 hoặc PC-NM2-2610-0014 | Dòng thành "Đã nhận đủ · Lê Văn Hải". Tab "Đã gửi" của chính Thủ kho và của Kế hoạch (PC-NM1-2610-0013) đổi sang kết quả "Đã nhận đủ". |
| 5 | Không có hộp duyệt | Bấm tab "Chờ duyệt" | "Không có việc nào ở mục này." |
| 6 | Việc giao cho Thủ kho điều phối | Đổi `vaitro` = `Thủ kho điều phối` | Chỉ 1 việc được giao: LSX-2610-0010 "Lấy hàng xuất SX"; tab Đã gửi 1 việc: YC-NM1-2610-0027. Nhóm "Kho · Thủ kho kho điều phối NM1-DP". |

#### 7 · Tổng quan — Dashboard Giám đốc
Mở board này để kiểm: số liệu tổng quan đổi đúng theo kỳ, khớp với các board khác. Màn chỉ xem, hiện cho Giám đốc.
Ô chỉnh trong "Trạng thái hiển thị": `ky` → `Hôm nay`, `7 ngày` (mặc định), `Tháng này`. Trên màn cũng có 3 nút kỳ để bấm.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Kỳ 7 ngày | `ky` = `7 ngày` | Đầu trang "Tổng quan nhà máy", "Thứ Bảy, 24/10/2026 · số liệu cập nhật lúc 13:55". Thành phẩm nhập kho · 7 ngày: 14.880 lon, "Kế hoạch 16.800 lon · đạt 89%". Lô đạt QC: 11 / 12 lô, "1 lô NVL Không đạt · L-BOT-22" (màu đỏ). Tiền hàng đã giao: 412 triệu đ, "9 lần giao · 6 khách". |
| 2 | Kỳ hôm nay | `ky` = `Hôm nay` | Nhãn thẻ đổi thành "... · hôm nay". Thành phẩm 1.920 lon, "Kế hoạch 2.400 lon · đạt 80%". Lô đạt QC 3 / 3 lô, "Không có lô Không đạt" (màu xanh). Tiền hàng đã giao 0 đ, "2 lần giao đang chờ ghi nhận". |
| 3 | Kỳ tháng này | `ky` = `Tháng này` | Thành phẩm 49.920 lon, kế hoạch 57.600 lon, đạt 87%. Lô đạt QC 34 / 37 lô, "3 lô Không đạt trong tháng". Tiền hàng đã giao 1,38 tỷ đ, "31 lần giao · 14 khách". |
| 4 | Phần không đổi theo kỳ | Đổi `ky` qua lại | Giữ nguyên: Đơn đang sản xuất 4 ("2 đơn hạn giao trong 7 ngày tới"), Đơn quá hạn giao 6 ("1 đơn còn đang sản xuất · ĐH-2610-0028"), Công nợ quá hạn 46,2 triệu đ ("3 khách · lâu nhất KH-0012 quá 4 ngày"), biểu đồ 14 ngày. |
| 5 | Biểu đồ sản lượng 14 ngày | Rê chuột lên cột ngày 18/10 và 22/10 | Kế hoạch mỗi ngày 2.400 lon. Hai cột thấp tô màu "Dưới 80% kế hoạch": 18/10 là 1.440 lon (ghi chú "dừng máy 47 phút"), 22/10 là 1.680 lon ("mẻ dừng sự cố, đã chạy mẻ bù"). Cột 24/10 là 1.920 lon, đúng bằng 80% nên không bị tô. |
| 6 | Việc chờ Giám đốc duyệt | Xem khung "Chờ Giám đốc duyệt" | "Xem tất cả 8 →" và đúng 8 dòng: TH-2610-0003, PO-2610-0020 (176.000.000 đ), ĐH-2610-0054 (500.000.000 đ), ĐH-2610-0034, ĐH-2610-0039 (hoàn 0 đ), ĐH-2610-0048 (đã thu đủ 83.160.000 đ), TH-2609-0002 (hoàn 16.128.000 đ), TH-2609-0003. Khớp với 8 việc ở board 5. Số "8" cạnh mục "Việc cần làm" trên menu cũng bằng 8. |
| 7 | Đơn cần chú ý | Xem bảng "Đơn hàng cần chú ý" | 5 đơn: ĐH-2610-0028 (trễ 2 ngày, 622.500.000), ĐH-2610-0024 (trễ 8 ngày, Giao một phần), ĐH-2610-0026 (trễ 4 ngày, Sẵn sàng giao), ĐH-2610-0030 (còn 1 ngày, 512.500.000), ĐH-2610-0034 (hạn 08/11, 1.245.000.000, Chờ kiểm công nợ). Giá tiền là chưa tính VAT. |
| 8 | Chuông và tài khoản | Bấm chuông, bấm tên | Chuông "3"; có 5 mục thông báo. Tài khoản "Lê Quang Minh · Giám đốc · Tất cả nhà máy". Nhãn "Chỉ trên cloud" ở đầu trang. Bảng không có ô chọn vai trò. |

#### 8 · Hồ sơ & biểu mẫu in
Mở board này để kiểm: tra cứu phiếu đã lập, chỉ thấy phiếu thuộc phân hệ của vai trò, in lại có đóng dấu và ghi số lần in.
Ô chỉnh trong "Trạng thái hiển thị": `vaitro` → `Giám đốc` (mặc định), `Thủ kho`, `QC trưởng`, `Kế toán`; `cachxem` → `Danh sách` (mặc định), `Theo hồ sơ lô / đơn`.

Số hồ sơ mỗi vai trò thấy (tổng 18 phiếu): `Giám đốc` 18; `Thủ kho` 7 (nhóm Kho); `QC trưởng` 7 (Chất lượng 5, Truy xuất & thu hồi 2); `Kế toán` 3 (Kế toán, Bán hàng, Mua hàng, mỗi nhóm 1). Dòng mô tả trên đầu ghi "Phạm vi Giám đốc: tất cả phân hệ" hoặc "Phạm vi Thủ kho: Kho" và tương tự.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Danh sách của Giám đốc | `vaitro` = `Giám đốc`, `cachxem` = `Danh sách` | "18 hồ sơ", "Mới nhất trước". Dòng đầu TH-2610-0003 "Hồ sơ thu hồi" (24/10/2026, Chờ ký), rồi QC-NM1-2610-0058 và TX-2610-0003 (23/10). Dòng cuối QC-NM1-2609-0041 (22/09). Các nhóm lọc có số: Tất cả 18, Bán hàng 1, Kế toán 1, Kho 7, Sản xuất 1, Chất lượng 5, Truy xuất & thu hồi 2, Mua hàng 1. |
| 2 | Lọc theo trạng thái | Bấm "Chờ ký", "Đã ký / phát hành", "Đã hủy", "Mọi trạng thái" | Chờ ký 4 phiếu (PK-NM1-2610-0005, QC-NM1-2610-0058, ĐH-2610-0035 · PL01, TH-2610-0003). Đã hủy 1 phiếu (PX-NM1-2610-0044). Đã ký / phát hành 13 phiếu (hóa đơn 0000902 ghi "Đã phát hành"). |
| 3 | Vai trò bị giới hạn | Đổi `vaitro` lần lượt `Thủ kho`, `QC trưởng`, `Kế toán` | `Thủ kho` 7 phiếu, chỉ nhóm Kho. `QC trưởng` 7 phiếu, không còn phiếu Kho. `Kế toán` 3 phiếu: hóa đơn 0000902, đơn mua PO-2610-0018, phụ lục ĐH-2610-0035 · PL01. Đổi vai trò thì bộ lọc nhóm quay về "Tất cả". Tên người dùng ở góc: Nguyễn Văn Tú, Võ Thanh Hà, Trần Thị Ngọc (Giám đốc là Lê Quang Minh). |
| 4 | Không có kết quả | `vaitro` = `QC trưởng`, bấm "Đã hủy"; hoặc `Kế toán` + "Đã hủy" | Dòng "Không có hồ sơ khớp bộ lọc. Thử bỏ bớt điều kiện hoặc tìm theo số lô / đơn hàng." Tiêu đề "0 hồ sơ". |
| 5 | Tìm kiếm | Gõ `A260920` vào ô "Tìm hồ sơ" (cách xem Danh sách) | Còn 4 phiếu cho Giám đốc: hóa đơn 0000902, PX-NM1-2610-0034, CN-NM1-2609-0014, QC-NM1-2609-0041. Số trên nhóm lọc cũng cập nhật theo ô tìm. Ô "Từ ngày", "Đến ngày" chỉ là chữ cố định (01/09 đến 24/10/2026), đổi không có tác dụng. |
| 6 | Xem theo hồ sơ lô / đơn | `cachxem` = `Theo hồ sơ lô / đơn` | Ô tìm tự điền `ĐH-2610-0022`. Tiêu đề "Hồ sơ ĐH-2610-0022 · 2 phiếu", xếp theo thứ tự phát sinh: 1 PX-NM1-2610-0034 (15/10, Đã ký), 2 hóa đơn 0000902 (18/10, Đã phát hành). Nút "In cả bộ hồ sơ". Với `Thủ kho` còn 1 phiếu; `Kế toán` 1 phiếu; `QC trưởng` không thấy phiếu nào: "Không tìm thấy phiếu nào gắn với “ĐH-2610-0022” trong phạm vi vai trò của bạn." Xóa ô tìm thì hiện hướng dẫn "Nhập số lô, đơn hàng hoặc lệnh sản xuất — hoặc bấm một gợi ý ở trên...". |
| 7 | Bốn gợi ý nhanh | Bấm lần lượt `ĐH-2610-0022`, `A260920`, `LSX-2610-0010`, `PO-2610-0018` (Giám đốc) | Số phiếu: 2, 4, 2, 2. `LSX-2610-0010`: LSX-2610-0010 rồi PX-NM1-2610-0042. `PO-2610-0018`: PO-2610-0018 rồi PN-NM1-2610-0031. Thử lại với `Thủ kho`: `LSX-2610-0010` chỉ còn PX-NM1-2610-0042 (lệnh sản xuất thuộc nhóm Sản xuất nên bị ẩn). |
| 8 | In phiếu đã ký | Giám đốc, bấm "In" ở PX-NM1-2610-0034 | Hộp thoại "In phiếu xuất kho bán hàng PX-NM1-2610-0034", dòng phụ "ĐH-2610-0022 · YX-2610-0012 · lô A260920 · Nhà thuốc Minh Châu · lập 15/10/2026 bởi Nguyễn Văn Tú". Lựa chọn "Bản lưu tại thời điểm ký — đóng dấu BẢN SAO", chân trang "In lại ngày 24/10/2026 bởi Lê Quang Minh (Giám đốc)". Ô "Số bản" = 1, có ô "Lý do in lại" (dấu sao) gồm Khách hàng yêu cầu, Đánh giá / thanh tra, Bản cũ thất lạc, hư hỏng, + Khác. "Khổ A4 dọc · Đã in 2 lần trước đây". Bấm "In": thanh báo "Đã gửi lệnh in PX-NM1-2610-0034 · đã ghi vào Nhật ký hệ thống", cột "Đã in" từ "2 lần" thành "3 lần". |
| 9 | In phiếu chờ ký và phiếu đã hủy | Bấm "In" ở PK-NM1-2610-0005 (Chờ ký) và ở PX-NM1-2610-0044 (Đã hủy) | Phiếu chờ ký: "Bản chờ ký — đóng dấu BẢN NHÁP", "Dùng để trình ký tay; bản chính thức có sau khi ký", "Chưa in lần nào", không có ô lý do. Phiếu đã hủy: "Bản đã hủy — đóng dấu ĐÃ HỦY", "Chỉ để đối chiếu, không có giá trị sử dụng", không có ô lý do. |
| 10 | Tải PDF | Bấm "PDF" ở một phiếu | Thanh báo "Đã tải <số phiếu>.pdf — bản lưu tại thời điểm ký". |
| 11 | In cả bộ hồ sơ | Xem theo hồ sơ `A260920`, bấm "In cả bộ hồ sơ" | Thanh báo "Đã gửi lệnh in 4 phiếu của hồ sơ A260920 · mỗi phiếu đóng dấu BẢN SAO". Số lần in từng phiếu không đổi (khác với in từng phiếu ở dòng 8). |

#### Mã mẫu dùng trong phần này (Chung)
| Mã | Là gì | Xuất hiện ở board | Giá trị phải khớp (trạng thái, số lượng, tiền...) |
|---|---|---|---|
| ĐH-2610-0034 | Đơn của khách KH-0012 An Khang, xin tăng hạn mức | 2, 5, 7 | Tiền trong Việc cần làm là 1.344.600.000 đ (đã tính VAT), trong Tổng quan là 1.245.000.000 đ (chưa VAT); hạn 08/11; trạng thái "Chờ kiểm công nợ"; chờ Kế toán ghi nhận tiền về rồi mới tới Giám đốc duyệt tăng hạn mức |
| PO-2610-0020 | Đơn mua trên 100 triệu, chờ Giám đốc duyệt thêm | 2, 5, 7 | 176.000.000 đ (2.000 kg × 88.000 đ); Trưởng BP Mua hàng đã duyệt; Giám đốc có nút Duyệt, Từ chối |
| TH-2610-0003 | Hồ sơ thu hồi lô A261011 (độ ẩm 5,4 %) chờ Giám đốc quyết | 2, 4, 5, 7, 8 | Chờ Giám đốc; bên QC trưởng ở tab "Đã gửi" ghi "Đang chờ"; Hồ sơ & biểu mẫu in: 24/10, Chờ ký |
| ĐH-2610-0054 | Đơn của khách mới KH-0064, xin hạn mức ban đầu | 2, 5, 7 | 500.000.000 đ; quá 1 ngày; Giám đốc và Kế toán trưởng đều thấy |
| ĐH-2610-0039, ĐH-2610-0048 | Hai đơn xin duyệt hủy | 2, 5, 7 | ĐH-2610-0039 hoàn 0 đ (44.820.000 đ chưa thu); ĐH-2610-0048 đã thu đủ 83.160.000 đ |
| TH-2609-0002 | Hoàn tiền cho khách thu hồi KH-0044 | 2, 5, 7 | 16.128.000 đ (96 lon × 168.000 đ); quá 1 ngày |
| TH-2609-0003 | Hồ sơ thu hồi chờ đóng | 2, 5, 7 | Giám đốc thấy "Đang chờ QC trưởng" cho tới khi QC trưởng duyệt phương án khắc phục |
| PN-NM1-2610-0031 | Phiếu nhập hàng từ nhà cung cấp, nhận thiếu 1 bao | 2, 7, 8 | Việc cần làm: chờ Thủ kho trưởng xác nhận lệch (79/80 bao, 1.975,0 kg); Tổng quan: "chờ xác nhận lệch"; Hồ sơ & biểu mẫu in: "Đã ký" (xem mục lệch) |
| PK-NM1-2610-0005 | Phiếu kiểm kho lô A260928 | 2, 7, 8 | Việc cần làm: Thủ kho đếm, rồi Thủ kho trưởng duyệt; Tổng quan và Hồ sơ & biểu mẫu in: "chờ ký" |
| PX-NM1-2610-0044 | Phiếu xuất bán thiếu 48 lon (432/480) | 2, 8 | Việc cần làm: Sales quyết định xuất một phần hay hủy; Hồ sơ & biểu mẫu in: "Đã hủy" |
| YC-NM1-2610-0021 | Yêu cầu kiểm nguyên vật liệu chờ QC trưởng duyệt | 2, 3, 4 | Chờ từ 17/10 10:30, quá 1 ngày; duyệt xong thì mở khóa dòng kết luận của QC |
| PC-NM1-2610-0013 | Phiếu chuyển kho NM1-TONG → NM1-DP | 2, 6, 8 | Việc cần làm: chờ nhận và quét (440 kg bột sữa gầy); Hồ sơ & biểu mẫu in: "Đã ký" 20/10 (xem mục lệch) |
| ĐH-2610-0022 | Đơn bán cho Nhà thuốc Minh Châu | 8 | Hồ sơ gồm PX-NM1-2610-0034 (Đã ký, 15/10, đã in 2 lần) và hóa đơn 0000902 (Đã phát hành, 18/10, đã in 1 lần) |
| KH-0012 | Khách An Khang, nợ quá hạn | 2, 7 | Việc cần làm: nhắc nợ "quá hạn 3 ngày"; Tổng quan: "quá hạn 4 ngày" (xem mục lệch) |
| LSX-2610-0010 | Lệnh sản xuất | 6, 8 | Hồ sơ: LSX-2610-0010 (17/10) rồi PX-NM1-2610-0042 (18/10) |

### 4.2. Bán hàng — đơn hàng, khách hàng, giao hàng, hóa đơn

Phân hệ này kiểm vòng đời một đơn bán: tạo đơn (board 9 đến 11), kiểm công nợ (board 12 đến 15), hủy đơn đã chốt (board 16 đến 18), sửa đơn đã chốt bằng phụ lục (board 19 đến 21), hồ sơ khách hàng (board 22 đến 24), yêu cầu xuất và ghi nhận giao (board 25, 26), hóa đơn (board 27, 28). Mọi board từ 11 đến 27 đều chạy trên cùng một bộ dữ liệu mẫu (45 đơn, 10 khách), nên cùng một mã đơn phải ra cùng trạng thái và cùng số tiền ở mọi board.

Cách đọc quyền theo vai trò (áp dụng cho cả phân hệ):
- Nút thao tác chỉ bấm được khi vai trò đúng. Vai trò khác không mất nút, mà thấy dòng "<tên nút> · việc của <vai trò> · <lý do>" kèm nút "Xem như <vai trò>" (bấm để đổi sang vai trò đó). Trong hộp thoại đang mở, nút xác nhận được thay bằng dòng "Việc của <vai trò> · <lý do>" kèm nút "Xem như <vai trò>".
- Vai trò được phép theo từng việc: Sales (nhận đơn, báo khách, hủy, sửa, yêu cầu xuất, ghi nhận giao); Kế toán (đề xuất hạn mức ban đầu, ghi ý kiến công nợ, thêm hóa đơn); Giám đốc hoặc Kế toán trưởng, một người là đủ (quyết hạn mức, duyệt hủy và quyết số tiền hoàn). Khi bị chặn, tên nêu trong dòng chặn là người đầu danh sách: Giám đốc nếu việc của Giám đốc hoặc Kế toán trưởng.
- Cổng vào màn: màn Đơn hàng chỉ mở cho `Sales`, `Kế toán`, `Kế toán trưởng`, `Giám đốc`, `Kế hoạch` (cộng Admin). `CSKH` vào Đơn hàng thấy thanh cảnh báo "Vai trò CSKH không có quyền vào màn này." kèm liên kết "Về Việc cần làm"; nội dung phía dưới vẫn hiện nhưng mọi nút đều bị chặn như trên. Màn Khách hàng chỉ mở cho `Sales`, `CSKH`, `Giám đốc` (cộng Admin); `Kế toán`, `Kế toán trưởng`, `Kế hoạch` vào đó thấy cảnh báo tương tự.
- Các board không có ô `vaitro` (9, 10, 11, 23, 24) vẫn đổi vai trò được bằng ô chọn "Xem như vai trò" ở góc phải thanh đầu trang.
- Mọi màn thuộc phân hệ này chỉ chạy trên máy chủ trung tâm (biểu tượng "chỉ có trên cloud" ở đầu trang), nên không có ca mất mạng hay xung đột đồng bộ để thử.

#### 9 · Đơn hàng — danh sách
Mở board này để kiểm: danh sách đơn, các tab trạng thái, bộ lọc, tìm kiếm, nút Sửa và Xóa theo vai trò.
Ô chỉnh trong "Trạng thái hiển thị": không có, chỉ bấm trong board (đổi vai trò bằng "Xem như vai trò").

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Số đơn theo tab | Mở board, đọc số trên từng tab | Chân bảng "45 / 45 đơn hàng". Số trên tab: Nháp 4, Kiểm công nợ 5, Chờ thu tiền 3, Đã chốt · đang SX 8, Nhập kho · duyệt · xuất kho 0, Giao hàng 7, Đã giao 11, Yêu cầu hủy 3, Đã hủy · từ chối 4 (cộng lại đủ 45). Có thêm tab "Cần xử lý" theo vai trò đang xem. |
| 2 | `Sales` thấy nút gì | Vai trò `Sales` | Nút "+ Tạo đơn hàng". Dòng đơn Nháp có nút "Sửa". Chỉ dòng đơn Nháp (ĐH-2610-0037, ĐH-2610-0042, ĐH-2610-0057) có thêm nút "Xóa". Đơn đã chốt trở đi không có Sửa, Xóa. |
| 3 | Xóa đơn nháp | Bấm "Xóa" ở ĐH-2610-0037 | Hộp xác nhận "Đơn nháp chưa có hợp đồng. Xóa xong không khôi phục được." Xác nhận xong có thông báo "Đã xóa ĐH-2610-0037." và chân bảng còn "44 / 44 đơn hàng". |
| 4 | Vai trò chỉ xem | `Kế toán`, `Kế toán trưởng`, `Giám đốc`, `Kế hoạch` | Không còn nút Sửa, Xóa ở dòng nào. Nút tạo đơn thành "+ Tạo đơn hàng · việc của Sales · Sales nhận đơn" kèm "Xem như Sales". |
| 5 | Vai trò bị chặn cả màn | `CSKH` | Thanh cảnh báo "Vai trò CSKH không có quyền vào màn này."; nút tạo đơn bị chặn như dòng 4. |
| 6 | Lọc và tìm | Chọn bộ lọc "Khách hàng" = KH-0012; chọn "Hình thức thanh toán" = Mua nợ; gõ `YX-2610-0015` vào ô tìm | Lọc KH-0012 còn 5 đơn mở và 2 đơn đã giao (ĐH-2609-0018, ĐH-2609-0025). Gõ `YX-2610-0015` ra đúng ĐH-2610-0031 (tìm được cả mã yêu cầu xuất, mã phiếu xuất, mã lệnh SX, số hóa đơn). |
| 7 | Dòng nhắc việc | Nhìn cột "Giao mong muốn" của ĐH-2610-0026 và ĐH-2610-0049 | Chữ nhấn mạnh "còn 2 ngày, chưa yêu cầu xuất" (ĐH-2610-0026) và "còn 3 ngày, chưa yêu cầu xuất" (ĐH-2610-0049). |
| 8 | Đơn đang sửa | Nhìn dòng ĐH-2610-0045 và ĐH-2610-0052 | Dòng phụ ghi "đang sửa → phiên bản 2" (đơn có yêu cầu sửa chưa chốt). |

#### 10 · Đơn hàng — tạo / sửa
Mở board này để kiểm: biểu mẫu tạo đơn hàng, ô bắt buộc, giới hạn số liệu, điền sẵn theo khách.
Ô chỉnh trong "Trạng thái hiển thị": `start` → `tao-moi` (mặc định, mở sẵn biểu mẫu), `danh-sach` (mở danh sách), `xem` (mở chi tiết ĐH-2610-0033).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mặc định | `start` = `tao-moi` | Biểu mẫu tạo đơn. Ngày đặt hàng 18/10/2026, hình thức thanh toán "Cọc + trả nốt trước giao", VAT 8, tiền cọc 0. Chân biểu mẫu báo "Còn 7 ô bắt buộc chưa nhập" (khách hàng, ngày giao, hình thức giao, phương thức thanh toán và 3 ô của dòng hàng). |
| 2 | Lưu khi bỏ trống | Bấm "Lưu đơn hàng" ngay | Các ô khách hàng, ngày giao hàng mong muốn, hình thức giao, phương thức thanh toán báo "Bắt buộc."; dòng hàng báo "Nhập đủ: Sản phẩm, Số lượng đặt, Đơn giá."; ô tiền cọc báo "Hình thức Cọc + trả nốt bắt buộc có tiền cọc > 0." |
| 3 | Điền sẵn theo khách | Chọn khách KH-0012 | Hình thức "Mua nợ", phương thức "Chuyển khoản", số ngày nợ 30, địa chỉ giao theo hồ sơ khách. Dưới ô khách có gợi ý "Khách đang tạm khóa do nợ quá hạn — đơn Mua nợ sẽ dừng ở kiểm công nợ." Chọn khách KH-0007 (cọc mặc định 30%) rồi nhập 1 dòng hàng: ô tiền cọc tự tính bằng 30% tổng đơn. |
| 4 | Giá trị vượt mức | Nhập cọc lớn hơn tổng đơn; VAT = 25; ngày giao trước ngày đặt; số lượng 0; ngày nợ 0 khi Mua nợ | "Cọc không lớn hơn tổng đơn (<số tiền tổng>)."; "VAT từ 0 đến 20%."; "Ngày giao không trước ngày đặt."; "Số lượng > 0."; "Số ngày nợ > 0." |
| 5 | Dòng hàng trùng | Thêm 2 dòng cùng sản phẩm và cùng đơn vị | Dòng 2 báo "Trùng sản phẩm và đơn vị với dòng 1 — gộp số lượng." Nhập 1 thùng Nhãn A Số 3 thì dòng ghi chú "Quy đổi: 24 lon · 19,2 kg bột (1 thùng = 24 lon)." |
| 6 | Hình thức giao | Chọn "Giao tận nơi" | Hiện thêm ô "Địa chỉ giao", bắt buộc. Chọn "Khách tự lấy tại nhà máy" thì ô này ẩn. |
| 7 | Lưu thành công | Điền đủ, bấm "Lưu đơn hàng" | Thông báo "Đã tạo ĐH-2610-0059." Đơn nằm đầu danh sách ở trạng thái Nháp, nhật ký ghi "Tạo đơn (nháp)". |
| 8 | Quyền | Đổi "Xem như vai trò" sang `Kế toán` rồi lưu | Biểu mẫu vẫn lưu được (board mở thẳng biểu mẫu nên không chặn theo vai trò; xem mục chỗ lệch). Ở board 9, `Kế toán` không có nút tạo đơn. |
| 9 | Hợp đồng khi tạo đơn | Đọc khối "Hợp đồng" ở cột phải; nhập số hợp đồng mà không chọn file; rồi nhập hiệu lực đến trước hiệu lực từ | Khối có 4 ô không bắt buộc: Số hợp đồng, Hiệu lực từ, Hiệu lực đến, File hợp đồng (gợi ý "Ảnh / PDF, tối đa 5MB mỗi tệp. Chưa có thì upload sau."). Có số / ngày mà chưa có file báo "Tải file hợp đồng."; có file mà trống số báo "Nhập số hợp đồng."; ngày đến trước ngày từ báo "Ngày hết hiệu lực không trước ngày bắt đầu." Bỏ trống cả khối vẫn lưu nháp được. (sửa 05/11: hợp đồng theo từng đơn, không lấy từ hồ sơ khách) |

#### 11 · Đơn hàng — chi tiết
Mở board này để kiểm: trang chi tiết một đơn đang chờ thu tiền, lịch thanh toán, và việc Sales hủy thẳng đơn chưa chốt.
Ô chỉnh trong "Trạng thái hiển thị": `start` → `xem` (mặc định, mở ĐH-2610-0033), `danh-sach`, `tao-moi`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở mặc định | `start` = `xem` | ĐH-2610-0033, khách KH-0044 Nhà thuốc Minh Châu, trạng thái "Chờ thu tiền". Việc tiếp theo thuộc Kế toán: "Ghi nhận tiền cọc 15.000.000 đ ở Công nợ khách hàng". |
| 2 | Số tiền | Đọc phần dòng hàng và tab "Thanh toán" | Hai dòng hàng của Nhãn B Số 3 (SP-0002): 40 thùng × 4.100.000 đ = 960 lon, 768 kg bột; 240 lon × 175.000 đ = 240 lon, 192 kg bột. Tạm tính 206.000.000 đ, VAT 8% 16.480.000 đ, tổng cộng 222.480.000 đ. Cọc 15.000.000 đ (6,7% giá trị đơn) "Chưa thu"; khoản trả nốt trước giao 207.480.000 đ; "Chưa thu lần nào". Phương thức "Tiền mặt". |
| 3 | `Sales` thấy nút gì | Vai trò `Sales` | "Xem ở Công nợ KH →", "Mô phỏng · Kế toán ghi nhận tiền về", và "Hủy đơn" nằm trong menu ⋯. Không có nút Sửa (đơn Chờ thu tiền không sửa được). |
| 4 | Sales hủy thẳng đơn chưa chốt | Bấm ⋯ rồi "Hủy đơn"; bỏ trống lý do rồi xác nhận; sau đó nhập lý do | Hộp "Hủy đơn · ĐH-2610-0033": "Đơn chưa chốt, chưa thu tiền: chuyển Đã hủy, giữ lại để tra cứu." Bỏ trống lý do báo "Bắt buộc." Có lý do thì thông báo "ĐH-2610-0033: Hủy đơn.", trạng thái "Đã hủy", khung đỏ "Đã hủy: <lý do>", không qua bước duyệt, không có tiền hoàn. (quy tắc: đơn chưa chốt — Nháp, Chờ thu tiền — không đi quy trình hủy đơn đã chốt.) |
| 5 | Cùng ca ở đơn khác | Mở ĐH-2610-0044 rồi ĐH-2610-0043 từ board 9 (cả hai Chờ thu tiền, trả đủ trước SX); bấm ⋯ rồi "Hủy đơn" | Hủy xong cũng thành "Đã hủy" với lý do vừa nhập. (Bỏ Chờ ký HĐ 05/11 — ĐH-2610-0032 nay là đơn Nháp chưa có hợp đồng.) |
| 6 | Vai trò khác | `Kế toán`, `Kế toán trưởng`, `Giám đốc`, `Kế hoạch`; `CSKH` | Thấy "Hủy đơn · việc của Sales · Sales hủy đơn" trong menu ⋯ kèm "Xem như Sales". Nút mô phỏng thu tiền hiện cho mọi vai trò (nó mô phỏng việc Kế toán làm ở màn khác). `CSKH` thêm cảnh báo không có quyền vào màn. |
| 7 | Chuyển trạng thái sau khi thu | Bấm "Mô phỏng · Kế toán ghi nhận tiền về" rồi xác nhận | Hộp ghi "[Mô phỏng] Kế toán ghi nhận 15.000.000 đ (cọc trước SX) ở Công nợ khách hàng → đơn Đã chốt." Sau đó đơn "Đã chốt", đã thu 15.000.000 đ (phiếu thu TC-2610-0025), nhật ký thêm "Đủ khoản trước SX → Đã chốt" và dòng báo Kế hoạch có sản phẩm SP-0002 1.200 lon cần lên lệnh. |
| 8 | Đơn chưa có hợp đồng | Từ board 9 mở ĐH-2610-0042 (Nháp, KH-0065, trả đủ trước SX), vai trò `Sales` | Khung vàng "Đơn chưa có hợp đồng — chưa chốt được. Bấm "Upload hợp đồng" để tải bản khách đã ký." Việc tiếp theo: "Upload hợp đồng khách đã ký rồi chốt đơn"; nút chính "Upload hợp đồng", không có "Chốt đơn". Ô "Hợp đồng" ở Thông tin đơn: "Chưa có hợp đồng" · "upload trước khi chốt đơn". |
| 9 | Upload hợp đồng | Bấm "Upload hợp đồng"; bỏ trống file rồi lưu; chọn hiệu lực đến trước hôm nay; sau đó điền đủ | Hộp có Số hợp đồng (điền sẵn HĐ-2610-0042), Hiệu lực từ (điền sẵn hôm nay), Hiệu lực đến, File hợp đồng — đều bắt buộc. Thiếu báo "Bắt buộc."; ngày đến đã qua báo "Hợp đồng đã hết hạn — chọn ngày từ hôm nay." Đủ thì thông báo "ĐH-2610-0042: đã lưu hợp đồng.", nhật ký "Tải hợp đồng HĐ-2610-0042 · hiệu lực <từ> – <đến>: <tên file>"; khung vàng mất, nút chính thành "Chốt đơn", "Thay hợp đồng" vào menu ⋯; ô Hợp đồng ghi số, "hiệu lực <từ> – <đến>" và tên file. |
| 10 | Chốt sau khi có hợp đồng | Bấm "Chốt đơn" | Hộp "Chốt đơn theo hợp đồng đã tải. Có khoản trước SX 90.720.000 đ → Chờ thu tiền." kèm số + file hợp đồng; xong đơn "Chờ thu tiền", nhật ký "Chốt đơn theo hợp đồng HĐ-2610-0042 → Chờ thu tiền". Đơn đã chốt chỉ xem hợp đồng, không còn nút upload. |

#### 12 · Đơn hàng — QT06 chờ kiểm công nợ (nợ quá hạn)
Mở board này để kiểm: đơn Mua nợ (khách mua chịu, trả sau khi nhận hàng) bị dừng vì khách đang nợ quá hạn.
Ô chỉnh trong "Trạng thái hiển thị": `vaitro` → `Sales` (mặc định), `CSKH`, `Kế toán`, `Kế toán trưởng`, `Giám đốc`, `Kế hoạch`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở mặc định | `vaitro` = `Sales` | ĐH-2610-0034, KH-0012, trạng thái "Chờ kiểm công nợ"; 300 thùng Nhãn A Số 3 × 4.150.000 đ, tổng 1.344.600.000 đ, Mua nợ 30 ngày, cọc 0. Thông báo "Kết quả kiểm công nợ: Có nợ quá hạn → Sales báo khách: trả hết nợ quá hạn / chuyển trả trước / từ chối." Việc tiếp theo ghi "Hệ thống · Kế toán". |
| 2 | Bảng kiểm công nợ | Mở khung "Kiểm công nợ" trong phần Việc tiếp theo | Hạn mức 1.500.000.000 đ; công nợ ĐH-2609-0018 337.840.000 đ "Quá hạn 4 ngày" (hạn 14/10/2026); ĐH-2609-0025 272.160.000 đ "Trong hạn"; Mua nợ đã chốt chưa giao ĐH-2610-0028 672.300.000 đ. Dư nợ 1.282.300.000 đ; đơn này trừ cọc 1.344.600.000 đ; cộng lại 2.626.900.000 đ "Vượt 1.126.900.000 đ". Bước "Không nợ quá hạn" đánh dấu lỗi, các bước sau chưa tới. |
| 3 | `Sales` thấy nút gì | Vai trò `Sales` | Nút "Báo khách nợ quá hạn". Bấm: hộp ghi "Khách có nợ quá hạn: ĐH-2609-0018 337.840.000 đ (quá 4 ngày). Báo khách chọn: trả hết nợ quá hạn / chuyển trả trước / từ chối. Đơn chuyển Chờ xử lý nợ." Xác nhận "Đã báo khách" thì đơn sang "Chờ xử lý nợ" (khớp board 13). |
| 4 | Vai trò chỉ xem | `Kế toán`, `Kế toán trưởng`, `Giám đốc`, `Kế hoạch` | Chỉ thấy "Báo khách nợ quá hạn · việc của Sales · Sales báo khách" kèm "Xem như Sales". Không có nút nào khác. |
| 5 | Vai trò bị chặn | `CSKH` | Cảnh báo "Vai trò CSKH không có quyền vào màn này."; nút bị chặn như dòng 4. |
| 6 | Mã mẫu khác cùng nhóm | Từ board 9 mở ĐH-2610-0038 (KH-0064 chưa có hạn mức) | Thông báo kết quả: khách đã có đề xuất hạn mức ban đầu 500.000.000 đ theo ĐH-2610-0054 đang chờ duyệt, duyệt xong hệ thống kiểm lại đơn này. Nút "Đề xuất hạn mức ban đầu" thuộc Kế toán; `Sales` chỉ thấy dòng chặn "… · việc của Kế toán". |

#### 13 · Đơn hàng — QT06 chờ xử lý nợ
Mở board này để kiểm: đơn chờ khách trả nợ quá hạn, hoặc chuyển trả trước, hoặc từ chối.
Ô chỉnh trong "Trạng thái hiển thị": `vaitro` → `Kế toán` (mặc định), `Sales`, `CSKH`, `Kế toán trưởng`, `Giám đốc`, `Kế hoạch`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở mặc định | `vaitro` = `Kế toán` | ĐH-2610-0034, trạng thái "Chờ xử lý nợ" (nhãn đỏ), việc tiếp theo của Sales "Báo khách trả nợ quá hạn, hoặc chuyển sang trả trước". Thông báo "Đang chờ từ 18/10/2026 · nhắc Sales 21/10/2026 · tự Từ chối 25/10/2026." (quy tắc: quá 3 ngày nhắc, quá 7 ngày tự từ chối). |
| 2 | `Kế toán` thấy nút gì | Vai trò `Kế toán` | "Xem ở Công nợ KH →" và "Mô phỏng · Kế toán ghi nhận trả nợ quá hạn". Hai nút "Khách chuyển trả trước" và "Khách từ chối" bị chặn: "việc của Sales" kèm "Xem như Sales". |
| 3 | Khách trả nợ | Bấm nút mô phỏng trả nợ, xác nhận "Ghi nhận & kiểm lại" | Ghi nhận 337.840.000 đ cho ĐH-2609-0018 (còn nợ về 0, cờ tạm khóa của KH-0012 tắt). Hệ thống kiểm lại: 2.289.060.000 đ lớn hơn hạn mức 1.500.000.000 đ, phiên bản đơn chưa xin tăng, nên đơn về "Chờ kiểm công nợ" với thông báo "Hệ thống kiểm lại: vượt hạn mức — Sales xin tăng hạn mức." |
| 4 | Khách chuyển trả trước | Đổi sang `Sales`, bấm "Khách chuyển trả trước" | Ô "Hình thức mới" (Trả đủ trước SX hoặc Cọc + trả nốt trước giao, mặc định cái sau). Xác nhận thì đơn chốt theo hợp đồng của đơn và thành "Chờ thu tiền", hình thức mới, ngày nợ về 0. Đổi sang "Cọc + trả nốt" mà để cọc 0 vẫn qua (xem mục chỗ lệch). |
| 5 | Khách từ chối | `Sales`, bấm "Khách từ chối" | Bỏ trống lý do báo "Bắt buộc."; có lý do thì đơn thành "Từ chối", khung đỏ ghi lý do. |
| 6 | Vai trò khác | `Sales` thấy cả hai nút; `Giám đốc`, `Kế toán trưởng`, `Kế hoạch` giống `Kế toán` (có nút mô phỏng và liên kết, hai nút của Sales bị chặn); `CSKH` có cảnh báo không có quyền vào màn | Nút mô phỏng không bị chặn theo vai trò vì nó đại diện cho việc Kế toán làm ở màn khác. |

#### 14 · Đơn hàng — QT06 chờ duyệt hạn mức
Mở board này để kiểm: Giám đốc hoặc Kế toán trưởng quyết hạn mức mới khi khách vượt hạn mức; hộp thoại đã mở sẵn.
Ô chỉnh trong "Trạng thái hiển thị": `vaitro` → `Giám đốc` (mặc định), `Kế toán trưởng`, `Sales`, `CSKH`, `Kế toán`, `Kế hoạch`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở mặc định | `vaitro` = `Giám đốc` | Hộp "Quyết hạn mức mới · ĐH-2610-0034". Câu mở đầu: "Đề xuất 2.300.000.000 đ — Võ Thị Lan: …Hiện tại: hạn mức 1.500.000.000 đ, dư nợ 944.460.000 đ, đơn này 1.344.600.000 đ → cần 2.289.060.000 đ." Bảng dữ kiện: dư nợ hiện tại 944.460.000 đ (công nợ 272.160.000 đ + Mua nợ chưa giao 672.300.000 đ), "Đơn này − cọc" 1.344.600.000 đ, ý kiến Kế toán của Ngô Bảo Ngọc. Ô "Hạn mức mới" điền sẵn 2300000000. |
| 2 | Quyết đúng mức đề xuất | Giữ 2.300.000.000, bấm "Lưu hạn mức & kiểm lại" | Hạn mức KH-0012 thành 2.300.000.000 đ (vĩnh viễn). Kiểm lại: 2.289.060.000 đ không vượt, đơn thành "Đã chốt" (Mua nợ, cọc 0) với thông báo "Hệ thống kiểm lại: đủ điều kiện — đơn chốt theo hợp đồng HĐ-2610-0034 → Đã chốt." |
| 3 | Quyết thấp hơn đề xuất (cọc tối thiểu) | Nhập 2000000000, lưu | Đơn về "Chờ kiểm công nợ", thông báo "Hệ thống kiểm lại: cần cọc tối thiểu 289.060.000 đ." (cọc tối thiểu = dư nợ + đơn − hạn mức mới = 944.460.000 + 1.344.600.000 − 2.000.000.000). Khung kết quả ghi cọc tối thiểu 289.060.000 đ (không đủ giá trị đơn nên chưa phải trả đủ). |
| 4 | Ô sai | Nhập 0; xóa trống ô | 0 báo "Hạn mức > 0."; trống báo "Bắt buộc." |
| 5 | Vai trò được duyệt | `Giám đốc`, `Kế toán trưởng` | Thấy "Quyết hạn mức mới" bấm được (một người là đủ). `Kế toán` thấy thêm "Ghi ý kiến công nợ" (bắt buộc nhập ý kiến). |
| 6 | Vai trò chỉ xem | `Sales`, `Kế hoạch`, `Kế toán` (với việc quyết) | Chân hộp thoại thay nút bằng "Việc của Giám đốc · GĐ hoặc KTT, một người là đủ" kèm "Xem như Giám đốc". `CSKH` thêm cảnh báo không có quyền vào màn. |
| 7 | Hạn mức ban đầu | Từ board 9 mở ĐH-2610-0054 (KH-0064 chưa có hạn mức), vai trò `Giám đốc` | Nút "Duyệt hạn mức ban đầu" và "Không duyệt". "Không duyệt" cần lý do, đơn về "Nháp" và hình thức đổi sang "Cọc + trả nốt trước giao". |

#### 15 · Đơn hàng — QT06 chờ khách (cọc tối thiểu)
Mở board này để kiểm: khách phải chọn giữa đặt cọc tối thiểu, chuyển trả trước hoặc từ chối.
Ô chỉnh trong "Trạng thái hiển thị": `vaitro` → `Sales` (mặc định), `CSKH`, `Kế toán`, `Kế toán trưởng`, `Giám đốc`, `Kế hoạch`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở mặc định | `vaitro` = `Sales` | ĐH-2610-0034 "Chờ khách". Thông báo: "Chờ khách chọn: cọc tối thiểu 289.060.000 đ / chuyển trả trước / từ chối. Hạn mức mới 2.000.000.000 đ do Lê Quang Minh (Giám đốc) quyết 18/10 14:00." Hạn mức KH-0012 hiện 2.000.000.000 đ. |
| 2 | `Sales` thấy nút gì | Vai trò `Sales` | Ba nút: "Khách đồng ý cọc — ghi cọc mới", "Khách chuyển trả trước", "Khách từ chối". |
| 3 | Ghi cọc đủ | Bấm nút ghi cọc; ô số tiền điền sẵn 289060000; xác nhận | Cọc ghi vào đơn, kiểm lại thấy đủ nên đơn chốt theo hợp đồng của đơn và thành "Chờ thu tiền" (chờ thu cọc). |
| 4 | Ghi cọc thiếu hoặc vượt | Nhập 100000000; rồi nhập 1500000000 (lớn hơn tổng đơn) | 100.000.000 đ lưu được nhưng kiểm lại vẫn thiếu: đơn về "Chờ kiểm công nợ" với cọc tối thiểu 289.060.000 đ. 1.500.000.000 đ báo "Cọc không lớn hơn tổng đơn." |
| 5 | Vai trò chỉ xem | `Kế toán`, `Kế toán trưởng`, `Giám đốc`, `Kế hoạch` | Ba dòng chặn "… · việc của Sales", không có nút bấm được. `CSKH` cảnh báo không có quyền vào màn. |
| 6 | Hai lối còn lại | `Sales` bấm "Khách chuyển trả trước" hoặc "Khách từ chối" | Giống board 13: chuyển trả trước thì đơn thành "Chờ thu tiền"; từ chối (bắt buộc lý do) thì thành "Từ chối". |

#### 16 · Đơn hàng — QT07 yêu cầu hủy đơn đang SX
Mở board này để kiểm: Sales gửi yêu cầu hủy một đơn đã chốt đang sản xuất, kèm bảng ảnh hưởng và tiền đề xuất hoàn.
Ô chỉnh trong "Trạng thái hiển thị": `vaitro` → `Sales` (mặc định), `CSKH`, `Kế toán`, `Kế toán trưởng`, `Giám đốc`, `Kế hoạch`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở mặc định | `vaitro` = `Sales` | Hộp "Yêu cầu hủy đơn · ĐH-2610-0031" (khách KH-0007; 200 thùng Nhãn A Số 3, tổng 896.400.000 đ). Lý do điền sẵn "Khách đổi kế hoạch kinh doanh, rút đơn trước khi sản xuất xong". Câu nhắc "Giám đốc hoặc Kế toán trưởng sẽ quyết số tiền hoàn." |
| 2 | Bảng ảnh hưởng | Đọc phần dữ kiện của hộp | Lệnh LSX-2610-0011 (Chờ phát): "Đã phát, chưa tới nhà máy — gửi lệnh hủy…"; LSX-2610-0012 (Mới tạo): "Hủy ngay, giải phóng giữ chỗ NVL"; giữ chỗ nguyên liệu 3.840 kg bột; lô thành phẩm A241205 dùng lại được; yêu cầu xuất YX-2610-0015 (480 lon): "Hủy yêu cầu và phiếu xuất PX-NM1-2610-0043 (chưa xuất kho)"; tiền đã thu TC-2610-0009 100.000.000 đ "Mặc định giữ toàn bộ cọc" và TC-2610-0012 79.640.000 đ "Phần vượt cọc — mặc định hoàn". Dòng "Đề xuất hoàn (mặc định)": "Giữ cọc 100.000.000 đ · hoàn 79.640.000 đ". |
| 3 | Gửi yêu cầu | Xóa trống lý do rồi bấm "Gửi yêu cầu hủy"; sau đó nhập lại lý do | Trống báo "Bắt buộc." Có lý do thì thông báo "ĐH-2610-0031: đã gửi yêu cầu hủy — chờ Giám đốc / Kế toán trưởng quyết số tiền hoàn." Đơn thành "Chờ duyệt hủy"; nhật ký thêm "Đề xuất hoàn 79.640.000 đ — chờ GĐ / KTT quyết (Việc cần làm)". |
| 4 | Vai trò chỉ xem | `Kế toán`, `Kế toán trưởng`, `Giám đốc`, `Kế hoạch` | Chân hộp: "Việc của Sales · Sales ghi yêu cầu hủy" kèm "Xem như Sales". Ở trang đơn phía sau, "Yêu cầu hủy đơn", "Yêu cầu sửa đơn", "Đổi ngày giao dự kiến", "Hủy yêu cầu xuất" đều bị chặn như vậy. |
| 5 | Vai trò bị chặn cả màn | `CSKH` | Cảnh báo "Vai trò CSKH không có quyền vào màn này." và chặn như dòng 4. |
| 6 | Đơn không có tiền đã thu | Từ board 9 mở ĐH-2610-0039 | Đã ở "Chờ duyệt hủy" với dòng "Đề xuất hoàn 0 đ (chưa thu tiền)". |

#### 17 · Đơn hàng — QT07 duyệt hủy, quyết số tiền hoàn
Mở board này để kiểm: Giám đốc hoặc Kế toán trưởng duyệt hủy và quyết số tiền hoàn; hộp thoại đã mở sẵn.
Ô chỉnh trong "Trạng thái hiển thị": `vaitro` → `Kế toán trưởng` (mặc định), `Giám đốc`, `Sales`, `CSKH`, `Kế toán`, `Kế hoạch`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở mặc định | `vaitro` = `Kế toán trưởng` | Hộp "Duyệt hủy · quyết số tiền hoàn · ĐH-2610-0031". Nhắc "Mặc định giữ toàn bộ cọc, hoàn phần đã thu vượt cọc." Dữ kiện giống board 16 cộng dòng "Lý do khách hủy" (Võ Thị Lan · 18/10 09:15). Ô "Số tiền hoàn cho khách" điền sẵn 79640000; gợi ý "Đã thu 179.640.000 đ · đề xuất 79.640.000 đ". |
| 2 | Duyệt đúng đề xuất | Giữ 79640000, bấm "Duyệt hủy" | Thông báo "ĐH-2610-0031: đã duyệt hủy, hoàn 79.640.000 đ. Chờ Kế hoạch hủy lệnh SX." Đơn thành "Đang hủy"; yêu cầu xuất YX-2610-0015 và phiếu PX-NM1-2610-0043 thành "Đã hủy"; việc tiếp theo của Kế toán "Ghi nhận hoàn 79.640.000 cho khách". |
| 3 | Số hoàn vượt mức | Nhập 200000000; nhập -1 | Cả hai báo "Từ 0 đến 179.640.000 đ." (không được hoàn quá số đã thu). Nhập 0 thì hợp lệ: giữ lại toàn bộ 179.640.000 đ, đơn vẫn sang "Đang hủy". |
| 4 | Không duyệt | Bấm "Không duyệt hủy"; bỏ trống rồi nhập lý do | Trống báo "Bắt buộc." Có lý do thì đơn trở lại "Đang sản xuất" (trạng thái trước khi yêu cầu), yêu cầu hủy bị gỡ. |
| 5 | Vai trò được duyệt | `Kế toán trưởng`, `Giám đốc` | Cả hai bấm được "Duyệt hủy" và "Không duyệt hủy"; một người là đủ. Khung "Ảnh hưởng khi hủy" mở sẵn. |
| 6 | Vai trò chỉ xem | `Sales`, `Kế toán`, `Kế hoạch` | Chân hộp "Việc của Giám đốc · GĐ hoặc KTT, một người là đủ" kèm "Xem như Giám đốc". Khung "Ảnh hưởng khi hủy" thu gọn sẵn. `Sales` vẫn thấy "Hủy yêu cầu xuất" và nút mô phỏng kho xuất hàng. |
| 7 | Vai trò bị chặn | `CSKH` | Cảnh báo không có quyền vào màn, chặn như dòng 6. |
| 8 | Đơn chưa có số để so | Từ board 9 mở ĐH-2610-0048 (trả đủ trước SX, đã thu 83.160.000 đ) | Khi duyệt hủy, số hoàn mặc định là 0 đ (toàn bộ khoản trả đủ được coi như cọc). |

#### 18 · Đơn hàng — QT07 Kế hoạch hủy lệnh SX
Mở board này để kiểm: đơn đã duyệt hủy, đang chờ Kế hoạch hủy lệnh sản xuất và xử lý hàng.
Ô chỉnh trong "Trạng thái hiển thị": `vaitro` → `Kế hoạch` (mặc định), `Sales`, `CSKH`, `Kế toán`, `Kế toán trưởng`, `Giám đốc`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở mặc định | `vaitro` = `Kế hoạch` | ĐH-2610-0031 "Đang hủy" (nhãn đỏ). Việc tiếp theo của Kế toán: "Ghi nhận hoàn 79.640.000 đ cho khách". Tab "Hủy đơn" cho thấy quyết định "Hoàn 79.640.000 đ · giữ lại 100.000.000 đ — Bùi Minh Châu (Kế toán trưởng) · 18/10 10:20 · Giữ toàn bộ cọc theo hợp đồng." |
| 2 | Nút theo vai trò | Mọi vai trò | Cả sáu vai trò đều thấy "Xem khoản hoàn ở Công nợ KH →", "Mở lệnh LSX-2610-0011 →" và nút "Mô phỏng · Kế hoạch đã hủy lệnh SX, xử lý hàng" (không bị chặn theo vai trò, vì mô phỏng việc Kế hoạch làm ở màn khác). |
| 3 | Hoàn tất hủy | Bấm nút mô phỏng; ô "TP / BTP của đơn" điền sẵn "Dùng lại được — về tồn chung"; xác nhận "Xác nhận → Đã hủy" | Thông báo "ĐH-2610-0031 → Đã hủy." Hai lệnh LSX-2610-0011, LSX-2610-0012 thành "Đã hủy". Khung đỏ ghi lý do, "Bùi Minh Châu (Kế toán trưởng) duyệt · hoàn 79.640.000 đ / đã thu 179.640.000 đ". Ở board 9, dòng đơn ghi phụ "hoàn 79.640.000 đ". |
| 4 | Yêu cầu xuất đã hủy | Nhìn tab "Giao hàng" | YX-2610-0015 và PX-NM1-2610-0043 đều "Đã hủy"; không còn nút "Hủy yêu cầu xuất". |
| 5 | Quyền khác | `CSKH` | Cảnh báo không có quyền vào màn; các nút vẫn hiện như dòng 2. |

#### 19 · Đơn hàng — QT08 yêu cầu sửa đơn đã chốt
Mở board này để kiểm: biểu mẫu sửa đơn đã chốt, bảng kiểm ảnh hưởng, kiểm công nợ phiên bản mới.
Ô chỉnh trong "Trạng thái hiển thị": `vaitro` → `Sales` (mặc định), `CSKH`, `Kế toán`, `Kế toán trưởng`, `Giám đốc`, `Kế hoạch`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở mặc định | `vaitro` = `Sales` | Biểu mẫu "Yêu cầu sửa đơn đã chốt · ĐH-2610-0035", dòng phụ "Phiên bản 1 → 2 · khách KH-0052 · Mua nợ". Ngày giao mới 10/11/2026; lý do điền sẵn; dòng Nhãn C Ít đường (SP-0005) 80 thùng thay vì 50. Tổng: bản cũ 1.007.100.000 đ, bản mới 1.131.840.000 đ, chênh lệch +124.740.000 đ. |
| 2 | Bảng kiểm ảnh hưởng | Đọc bảng "Kiểm ảnh hưởng" | Giá trị đơn tăng 124.740.000 đ (gồm VAT 8%); SP-0005 1.200 → 1.920 lon (+720 lon); ngày giao 05/11/2026 → 10/11/2026; "Không giảm phần đã sản xuất"; hai lệnh LSX-2610-0013, LSX-2610-0014 (Mới tạo) "Sửa thẳng lệnh theo phiên bản mới"; giữ chỗ nguyên liệu 5.280 → 5.856 kg bột (giữ thêm 576 kg); công nợ "Dư nợ 476.820.000 đ + phiên bản mới 1.131.840.000 đ = 1.608.660.000 đ / hạn mức 2.000.000.000 đ" kết quả "Đủ điều kiện". |
| 3 | Lưu phiên bản | Bấm "Tạo phiên bản mới" | Thông báo "ĐH-2610-0035: đã tạo phiên bản 2 — chờ ký phụ lục." Đơn vẫn "Đang sản xuất", khung vàng "Đang sửa đơn: phiên bản 2 chờ ký phụ lục. Phiên bản 1 vẫn hiệu lực tới khi chốt." (khớp board 20). |
| 4 | Không đổi gì | Đặt lại ngày giao 05/11/2026 và số lượng 50, lưu | "Chưa có thay đổi nào so với phiên bản 1." |
| 5 | Giá trị sai | Ngày giao 17/10/2026; số lượng 0; đơn giá 0 | "Ngày giao không trước hôm nay."; "Số lượng > 0."; "Đơn giá > 0."; bỏ trống lý do báo "Bắt buộc." |
| 6 | Giảm dưới phần đã yêu cầu xuất | Từ board 9 mở ĐH-2610-0031, bấm ⋯ rồi "Yêu cầu sửa đơn", giảm 200 thùng xuống 10 thùng | "Không giảm SP-0001 dưới 480 lon đã yêu cầu xuất — hủy phần đó bằng yêu cầu hủy đơn." |
| 7 | Công nợ không đủ | Trên ĐH-2610-0035, nâng SP-0005 lên 500 thùng, lưu | Dòng công nợ "Không đủ", cảnh báo "Kiểm công nợ phiên bản mới không đủ điều kiện — lưu xong Sales báo khách: giữ đơn cũ hoặc xử lý công nợ." Lưu xong thông báo "đã tạo phiên bản 2 — không đủ điều kiện công nợ." |
| 8 | Vai trò | Đổi sang `Kế toán` rồi lưu | Vẫn lưu được vì biểu mẫu mở sẵn, không chặn theo vai trò (xem mục chỗ lệch). Ở trang chi tiết, nút "Yêu cầu sửa đơn" của các vai trò khác bị chặn "việc của Sales · Sales thỏa thuận lại với khách". |

#### 20 · Đơn hàng — QT08 chờ ký phụ lục
Mở board này để kiểm: phiên bản 2 đã tạo, đang chờ Sales tải phụ lục khách đã ký.
Ô chỉnh trong "Trạng thái hiển thị": `vaitro` → `Sales` (mặc định), `CSKH`, `Kế toán`, `Kế toán trưởng`, `Giám đốc`, `Kế hoạch`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở mặc định | `vaitro` = `Sales` | ĐH-2610-0035 vẫn "Đang sản xuất", khung vàng "Đang sửa đơn: phiên bản 2 chờ ký phụ lục. Phiên bản 1 vẫn hiệu lực tới khi chốt." Việc tiếp theo của Sales: "Ký phụ lục với khách và tải lên". Tab "Sửa đơn" cảnh báo, các bước: Kiểm ảnh hưởng và Kiểm công nợ xong, Ký phụ lục đang làm. |
| 2 | `Sales` thấy nút gì | Vai trò `Sales` | "Tải phụ lục đã ký", "Bỏ yêu cầu sửa", "Yêu cầu hủy đơn". Không còn "Yêu cầu sửa đơn" và "Đổi ngày giao dự kiến" (đang có phiên bản chờ ký). |
| 3 | Tải phụ lục | Bấm "Tải phụ lục đã ký"; tệp điền sẵn `phu-luc-1-DH-2610-0035.jpg`; xóa tệp rồi lưu; thêm lại tệp rồi "Lưu phụ lục" | Không có tệp báo "Bắt buộc." Có tệp: thông báo "ĐH-2610-0035: đã tải phụ lục. Đơn chốt phiên bản 2 — báo Kế hoạch cập nhật lệnh SX." (đơn Mua nợ nên không có chênh lệch tiền để ghi nhận), giá trị đơn thành 1.131.840.000 đ, SP-0005 thành 80 thùng, ngày giao 10/11/2026, trạng thái vẫn "Đang sản xuất". Bảng "Lịch sử sửa đơn" có Bản 1 (1.007.100.000 đ) và Bản 2 (1.131.840.000 đ, ghi chú kèm tên phụ lục). |
| 4 | Bỏ yêu cầu sửa | Bấm "Bỏ yêu cầu sửa"; trống lý do rồi nhập lý do | Trống báo "Bắt buộc." Có lý do thì yêu cầu bị gỡ, đơn giữ phiên bản 1, nút "Yêu cầu sửa đơn" hiện lại. |
| 5 | Vai trò chỉ xem | `Kế toán`, `Kế toán trưởng`, `Giám đốc`, `Kế hoạch` | Ba nút của Sales đều thành dòng chặn "… · việc của Sales" kèm "Xem như Sales". `CSKH` có cảnh báo không có quyền vào màn. |
| 6 | Có chênh lệch tiền | Từ board 9 mở ĐH-2610-0045 (trả đủ trước SX, đã thu 204.120.000 đ; đang sửa lên 60 thùng) | Bước "Chênh lệch tiền" đang chờ: "Chờ Kế toán ghi nhận thu thêm"; chênh lệch +40.824.000 đ (tổng mới 244.944.000 đ). Có nút "Mô phỏng · Kế toán ghi nhận chênh lệch" để chốt phiên bản. |

#### 21 · Đơn hàng — QT08 Kế hoạch cập nhật lệnh SX
Mở board này để kiểm: phụ lục đã ký, đơn chốt phiên bản 2, Kế hoạch cập nhật lệnh sản xuất.
Ô chỉnh trong "Trạng thái hiển thị": `vaitro` → `Kế hoạch` (mặc định), `Sales`, `CSKH`, `Kế toán`, `Kế toán trưởng`, `Giám đốc`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở mặc định | `vaitro` = `Kế hoạch` | ĐH-2610-0035 phiên bản 2: 80 thùng SP-0005, tổng 1.131.840.000 đ, giao 10/11/2026. Việc tiếp theo của Kế hoạch: "Cập nhật lệnh SX theo phiên bản 2". Bảng "Lịch sử sửa đơn": Bản 2 lúc 18/10 15:10, người Võ Thị Lan, ghi chú "… · phụ lục phu-luc-1-DH-2610-0035.jpg". Nhật ký: "Tải phụ lục đã ký: phu-luc-1-DH-2610-0035.jpg". |
| 2 | Nút theo vai trò | Mọi vai trò | Cả sáu vai trò thấy "Mở lệnh LSX-2610-0013", "Mở lệnh LSX-2610-0014" và "Mô phỏng · Kế hoạch đã cập nhật lệnh SX". `Sales` còn có "Yêu cầu hủy đơn" và "Đổi ngày giao dự kiến"; vai trò khác thấy hai nút này bị chặn "việc của Sales". Không còn "Yêu cầu sửa đơn" (đơn chưa xong cập nhật lệnh). |
| 3 | Hoàn tất | Bấm nút mô phỏng, xác nhận | Hộp ghi "Đã cập nhật lệnh theo phiên bản 2: LSX-2610-0013 (Mới tạo: Sửa thẳng lệnh theo phiên bản mới); LSX-2610-0014 (…). Giữ chỗ NVL 5.280 → 5.856 kg bột." Xác nhận thì nhật ký thêm "Cập nhật lệnh SX theo phiên bản 2", khung "Đang sửa đơn" biến mất, nút "Yêu cầu sửa đơn" hiện lại cho `Sales`. |
| 4 | Vai trò bị chặn | `CSKH` | Cảnh báo không có quyền vào màn; các nút vẫn hiện như dòng 2. |

#### 22 · Khách hàng — danh sách
Mở board này để kiểm: danh sách khách; đồng thời đây là màn gốc nhận mọi tổ hợp ô, kể cả 14 tình huống quy trình.
Ô chỉnh trong "Trạng thái hiển thị": `screen` → `khach-hang` (mặc định), `don-hang`; `start` → `danh-sach` (mặc định), `tao-moi`, `xem`; `vaitro` → `Sales` (mặc định), `CSKH`, `Kế toán`, `Kế toán trưởng`, `Giám đốc`, `Kế hoạch`; `tinhhuong` → `Mặc định` (mặc định), `QT06 · Chờ kiểm công nợ`, `QT06 · Chờ xử lý nợ`, `QT06 · Chờ duyệt hạn mức`, `QT06 · Chờ khách (cọc tối thiểu)`, `QT07 · Yêu cầu hủy đơn đang SX`, `QT07 · Chờ duyệt hủy`, `QT07 · Đang hủy (Kế hoạch hủy lệnh)`, `QT08 · Yêu cầu sửa đơn`, `QT08 · Chờ ký phụ lục`, `QT08 · Kế hoạch cập nhật lệnh SX`, `QT09 · Yêu cầu xuất`, `QT09 · Ghi nhận giao`, `QT10 · Thêm hóa đơn`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Danh sách khách | Mặc định | Chân bảng "10 / 10 khách hàng". Tab: Tất cả 10, Đang hoạt động 8, Tạm dừng giao dịch 1 (KH-0063), Ngừng hoạt động 1 (KH-0060). Dòng KH-0012: hạn mức 1.500.000.000 đ, dư nợ 1.282.300.000 đ, đơn hàng 7 (5 đang mở), phụ "tạm khóa · nợ quá hạn". Chỉ KH-0012, KH-0052, KH-0060 có hạn mức; các khách còn lại hiện "—". |
| 2 | Quyền theo vai trò | `vaitro` lần lượt | `Sales`: nút "+ Tạo khách hàng" bấm được. `CSKH`, `Giám đốc`: xem được nhưng nút thành "+ Tạo khách hàng · việc của Sales" kèm "Xem như Sales". `Kế toán`, `Kế toán trưởng`, `Kế hoạch`: cảnh báo "Vai trò … không có quyền vào màn này." |
| 3 | Chuyển sang đơn hàng | `screen` = `don-hang` | Danh sách đơn như board 9 ("45 / 45 đơn hàng"). Với `CSKH` hiện cảnh báo không có quyền vào màn Đơn hàng; ba vai trò kế toán, kế hoạch, giám đốc thì vào được. |
| 4 | Mở biểu mẫu hoặc chi tiết | `start` = `tao-moi`; `start` = `xem` (mỗi lần thử với `screen` = `khach-hang` rồi `don-hang`) | Khách: biểu mẫu tạo khách (như board 23) và chi tiết KH-0012 (như board 24). Đơn: biểu mẫu tạo đơn (như board 10) và chi tiết ĐH-2610-0033 (như board 11). |
| 5 | Tình huống quy trình | Chọn từng giá trị `tinhhuong` khác `Mặc định` | Mỗi giá trị mở đúng đơn của board tương ứng, vai trò mặc định là `vaitro` đang chọn (mặc định `Sales`, không phải vai trò mặc định riêng của từng board): ba giá trị QT06 đầu và `QT06 · Chờ khách (cọc tối thiểu)` mở ĐH-2610-0034 (board 12 đến 15); ba giá trị QT07 mở ĐH-2610-0031 (board 16 đến 18); ba giá trị QT08 mở ĐH-2610-0035 (board 19 đến 21); `QT09 · Yêu cầu xuất` mở ĐH-2610-0026 (board 25); `QT09 · Ghi nhận giao` mở ĐH-2610-0025 (board 26); `QT10 · Thêm hóa đơn` mở ĐH-2610-0022 (board 27). Hộp thoại mở sẵn y như board đó. |
| 6 | Ô bị bỏ qua | `tinhhuong` khác `Mặc định` cùng `screen` = `khach-hang` hoặc `start` = `tao-moi` | Màn luôn là Đơn hàng, mở trang chi tiết đơn; `screen` và `start` không có tác dụng. |
| 7 | Lọc khách | Chọn "Hình thức thanh toán" = Mua nợ; gõ `ANKHANG` hoặc `0315443322` vào ô tìm | Lọc Mua nợ ra KH-0012, KH-0052, KH-0060, KH-0064. Gõ mã công ty hoặc mã số thuế ra đúng KH-0012. |

#### 23 · Khách hàng — tạo / sửa
Mở board này để kiểm: biểu mẫu hồ sơ khách, kiểm tra định dạng, ô hiện theo hình thức thanh toán.
Ô chỉnh trong "Trạng thái hiển thị": `start` → `tao-moi` (mặc định), `danh-sach`, `xem` (mở chi tiết KH-0012, từ đó bấm "Sửa" để thử chế độ sửa).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở mặc định | `start` = `tao-moi` | Biểu mẫu "Tạo khách hàng". Mặc định: trạng thái "Đang hoạt động", hình thức "Cọc + trả nốt trước giao", phương thức "Chuyển khoản", tỷ lệ cọc 30, số ngày nợ ẩn, hạn mức "Chưa có". Không có ô "Mã khách hàng" (mã tự cấp khi lưu). |
| 2 | Lưu khi bỏ trống | Bấm "Lưu khách hàng" ngay | "Bắt buộc." ở tên khách hàng, tên công ty, số điện thoại. |
| 3 | Sai định dạng | Mã số thuế `123`; email `abc`; số điện thoại `abc` | "MST gồm 10 chữ số (chi nhánh thêm -xxx)."; "Email chưa đúng định dạng."; "Số điện thoại chưa đúng." Email nhận hóa đơn sai cũng báo "Email chưa đúng định dạng." |
| 4 | Trùng mã số thuế | Nhập `0402334455` | "MST đã có ở KH-0044 · Nhà thuốc Minh Châu." |
| 5 | Ô hiện theo hình thức | Đổi hình thức sang "Mua nợ"; đổi phương thức sang "Tiền mặt" | "Mua nợ" hiện ô số ngày nợ (mặc định 30), ẩn tỷ lệ cọc; ngày nợ 0 báo "Số ngày nợ > 0." Tỷ lệ cọc 0 hoặc 101 báo "Tỷ lệ cọc lớn hơn 0, tối đa 100%." "Tiền mặt" ẩn ba ô ngân hàng, số tài khoản, chủ tài khoản. |
| 6 | Tài khoản ngân hàng | Phương thức "Chuyển khoản"; số tài khoản `ab12`; rồi số `123456789` bỏ trống chủ tài khoản | "Số tài khoản chỉ gồm chữ số."; "Nhập chủ tài khoản." Chủ tài khoản được lưu viết hoa. |
| 7 | Lưu thành công | Điền tên, công ty, số điện thoại hợp lệ, lưu | Thông báo "Đã tạo KH-0066." Khách mới có hạn mức "Chưa có", 0 đơn; chi tiết có nút "Xóa" (khách chưa có đơn). |
| 8 | Chế độ sửa | Từ chi tiết KH-0012 bấm "Sửa"; đổi mã thành KH-0007 | Ô "Mã khách hàng" hiện và sửa được; trùng báo "Mã khách hàng đã có." Ô "Hạn mức công nợ" chỉ đọc "1.500.000.000 đ (vĩnh viễn)". |

#### 24 · Khách hàng — chi tiết
Mở board này để kiểm: hồ sơ KH-0012 với công nợ, hạn mức, tạm khóa, lịch sử nhắc nợ.
Ô chỉnh trong "Trạng thái hiển thị": `start` → `xem` (mặc định, mở KH-0012), `danh-sach`, `tao-moi`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở mặc định | `start` = `xem` | KH-0012 Công ty TNHH Phân phối An Khang, cờ "Tạm khóa · nợ quá hạn". Người liên hệ Lê Thị Hồng; mã số thuế 0315443322. |
| 2 | Công nợ và hạn mức | Đọc khối "Công nợ & hạn mức" | Hạn mức 1.500.000.000 đ (còn 217.700.000 đ); dư nợ tính hạn mức 1.282.300.000 đ; tổng phải thu 610.000.000 đ; quá hạn 337.840.000 đ (ĐH-2609-0018 · 4 ngày); tới hạn gần nhất 272.160.000 đ (ĐH-2609-0025, hạn 01/11/2026). Khối "Đơn hàng": 7 đơn, đang mở 5 đơn, đơn gần nhất ĐH-2610-0057 (đặt 18/10/2026, Nháp). |
| 3 | Thanh toán và tài khoản | Đọc cột phụ | Hình thức "Mua nợ · 30 ngày", phương thức "Chuyển khoản", ngân hàng "BIDV · CN Sài Gòn", số tài khoản 3110 0098 7712, chủ tài khoản "CONG TY TNHH PHAN PHOI AN KHANG", email nhận hóa đơn ketoan@ankhang.vn. |
| 4 | Lịch sử nhắc nợ | Đọc bảng "Lịch sử liên hệ nhắc nợ" | Một dòng: 17/10 15:30, Võ Thị Lan, ĐH-2609-0018, "Liên hệ được", "khách hẹn chuyển 337.840.000 đ ngày 20/10". Bảng chỉ xem. |
| 5 | `Sales` thấy nút gì | Vai trò `Sales` | "Tạo đơn cho khách", "Sửa", menu ⋯ có "Ngừng hoạt động". Không có "Xóa" (khách đã có đơn). Bấm "Tạo đơn cho khách": sang biểu mẫu tạo đơn với KH-0012, Mua nợ, Chuyển khoản, 30 ngày điền sẵn. |
| 6 | Ngừng hoạt động | Bấm ⋯ rồi "Ngừng hoạt động"; bỏ trống lý do rồi nhập lý do | Hộp ghi "Khách không chọn được khi tạo đơn mới; hồ sơ, đơn cũ và công nợ được giữ. Còn 5 đơn đang mở vẫn xử lý bình thường." Trống báo "Bắt buộc." Xong thì trạng thái "Ngừng hoạt động" và menu ⋯ đổi thành "Kích hoạt lại". |
| 7 | Vai trò chỉ xem | `CSKH`, `Giám đốc` | Xem được toàn bộ hồ sơ; ba nút trên đều thành dòng chặn "… · việc của Sales" kèm "Xem như Sales". `Kế toán`, `Kế toán trưởng`, `Kế hoạch`: cảnh báo không có quyền vào màn Khách hàng, nút cũng bị chặn. |
| 8 | Khách ở trạng thái khác | Từ board 22 mở KH-0063 (Tạm dừng) và KH-0060 (Ngừng) | KH-0063 chỉ có "Ngừng hoạt động", không có "Tạo đơn cho khách". KH-0060 có "Kích hoạt lại" và cờ tạm khóa. |
| 9 | Không còn hợp đồng ở khách | Đọc danh sách (board 22), biểu mẫu (board 23), chi tiết KH-0012 | Không có cột / khối / nút hợp đồng nào (sửa 05/11: hợp đồng chuyển sang từng đơn — xem board 10 ca 9, board 11 ca 8–10). |

#### 25 · Đơn hàng — QT09 yêu cầu xuất (giao hàng chỉ ghi nhận)
Mở board này để kiểm: Sales yêu cầu xuất một phần từ lô thành phẩm đã đạt; hệ thống kiểm tiền trước giao ngay lúc yêu cầu.
Ô chỉnh trong "Trạng thái hiển thị": `vaitro` → `Sales` (mặc định), `CSKH`, `Kế toán`, `Kế toán trưởng`, `Giám đốc`, `Kế hoạch`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở mặc định | `vaitro` = `Sales` | ĐH-2610-0026 (KH-0058, 10 thùng Nhãn A Số 3, tổng 44.820.000 đ, đã thu 44.820.000 đ phiếu TC-2610-0007) ở "Sẵn sàng giao", tab "Giao hàng" mở sẵn, hộp "Yêu cầu xuất · ĐH-2610-0026". Khung nhắc "Còn 2 ngày tới ngày giao mong muốn (20/10/2026) — còn 144 lon chưa yêu cầu xuất." Yêu cầu YX-2610-0013 (96 lon) đang "Bị trả về" vì nhà máy chỉ còn 72 lon đạt. |
| 2 | Giá trị điền sẵn | Đọc hộp | Ô lô "A260920 · SP-0001 · NM1 · còn 144 lon"; số lượng 144; ngày giao 20/10/2026. Giá trị phần xuất 26.892.000 đ (144/240 lon của đơn); phải thu trước khi xuất 0 đ; đã thu 44.820.000 đ; kết quả "Đủ điều kiện — nhà máy tự lập phiếu xuất". |
| 3 | Gửi yêu cầu | Bấm "Gửi yêu cầu xuất" | Thông báo "đã gửi yêu cầu xuất YX-2610-0024 → máy chủ nhà máy tự lập phiếu PX-NM1-2610-0053 → Chờ lấy hàng, kho lấy hàng (phiếu xuất không qua duyệt)." Phiếu mới hiện ở bảng "Phiếu xuất bán của đơn". |
| 4 | Vượt số còn lại | Nhập số lượng 145; nhập 0 | Cả hai báo "Từ 1 đến 144 lon." Bỏ trống số lượng, lô hoặc ngày báo "Bắt buộc." |
| 5 | Vai trò chỉ xem | `Kế toán`, `Kế toán trưởng`, `Giám đốc`, `Kế hoạch`, `CSKH` | Chân hộp "Việc của Sales · Sales yêu cầu xuất từ đơn" kèm "Xem như Sales". Ở trang đơn: "Hủy yêu cầu xuất", "Yêu cầu hủy đơn", "Yêu cầu sửa đơn", "Đổi ngày giao dự kiến" cũng bị chặn như vậy. `CSKH` thêm cảnh báo không có quyền vào màn. |
| 6 | Hủy yêu cầu bị trả về | `Sales`, bấm "Hủy yêu cầu xuất" | Chọn YX-2610-0013; bỏ trống lý do báo "Bắt buộc."; xong yêu cầu thành "Đã hủy" và số lon chưa yêu cầu xuất trở lại 240. Nhật ký thêm "Gộp khoản trả nốt của YX-2610-0013 về khoản gốc". |
| 7 | Đơn Mua nợ, khách tạm khóa | Từ board 9 mở ĐH-2610-0028 (KH-0012) | Yêu cầu YX-2610-0018 (216 lon) ở "Chờ thanh toán · khách tạm khóa" (nhãn đỏ), chưa có phiếu xuất. Đơn Mua nợ của khách nợ quá hạn không được xuất; khác với ĐH-2610-0025 (KH-0052 không bị khóa) đã có phiếu xuất ngay. |
| 8 | Thiếu tiền trước giao | Từ board 9 mở ĐH-2610-0049 (cọc 30.000.000 đ, trả nốt 59.640.000 đ), bấm "Yêu cầu xuất" với số lon tối đa | Kết quả kiểm ghi "Thiếu 59.640.000 đ trước giao", vẫn lưu, yêu cầu ở "Chờ thanh toán" đến khi Kế toán ghi nhận tiền về (quá 14 ngày thì đề xuất hủy đơn). |

#### 26 · Đơn hàng — QT09 ghi nhận giao, khách trả một phần
Mở board này để kiểm: Sales ghi nhận khách nhận hàng theo từng phiếu xuất, khách chỉ nhận một phần.
Ô chỉnh trong "Trạng thái hiển thị": `vaitro` → `Sales` (mặc định), `CSKH`, `Kế toán`, `Kế toán trưởng`, `Giám đốc`, `Kế hoạch`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở mặc định | `vaitro` = `Sales` | ĐH-2610-0025 (KH-0052, Mua nợ 30 ngày, 10 thùng, tổng 44.820.000 đ) ở "Đang giao"; việc tiếp theo của Sales "Ghi nhận giao khi khách nhận hàng: SL nhận, ảnh biên bản". Hộp "Ghi nhận giao · ĐH-2610-0025" mở sẵn: phiếu PX-NM1-2610-0045 "Đã xuất · YX-2610-0017", đã xuất 240 lon (SP-0001, lô A241205). |
| 2 | Điền sẵn khách nhận một phần | Đọc ô | Số lượng khách nhận 216 với gợi ý "Không nhận 24 lon — chọn lý do."; lý do "Hư"; "Còn lấy — giao lại khi QC kiểm lại đạt"; ngày nhận 18/10/2026; người ký "Nguyễn Thị Lan Anh"; biên bản `bien-ban-PX-2610-0045.jpg`. |
| 3 | Lưu khách còn lấy | Bấm "Lưu ghi nhận" | Thông báo "ĐH-2610-0025: đã ghi nhận giao PX-NM1-2610-0045 → Giao một phần." Nhật ký: ghi lô A241205 về khách, ghi công nợ phần khách nhận hạn 17/11, báo kho nhập 24 lon hàng khách trả (khóa, QC kiểm lại), khách còn lấy. Bảng giao hàng thêm dòng "Hàng khách trả — Chờ kho nhập — 24 lon". |
| 4 | Khách không lấy phần còn lại | Đổi ô thành "Không lấy — giảm số lượng đơn", lưu | Đơn thành "Đã giao" (216 lon coi như đủ sau khi giảm 24 lon); thanh tiến độ ghi giảm 24 lon khách không lấy lại. Đơn Mua nợ chưa thu tiền nên không phát sinh hoàn tiền. |
| 5 | Nhận đủ | Nhập 240 | Ô lý do và ô "còn lấy" ẩn; đơn thành "Đã giao". |
| 6 | Giá trị sai và thiếu | Nhập 241; xóa người ký; bỏ ảnh biên bản; để 216 mà bỏ chọn lý do | 241 báo "Từ 0 đến 240 lon."; ba ô còn lại báo "Bắt buộc." |
| 7 | Vai trò chỉ xem | `Kế toán`, `Kế toán trưởng`, `Giám đốc`, `Kế hoạch`, `CSKH` | Chân hộp "Việc của Sales · Sales ghi nhận khi khách nhận hàng" kèm "Xem như Sales". Các nút "Ghi nhận giao", "Đổi ngày giao dự kiến" ở trang đơn thành dòng chặn. `CSKH` thêm cảnh báo không có quyền vào màn. |
| 8 | Đã có một phần để so | Từ board 9 mở ĐH-2610-0024 | "Giao một phần": khách nhận 192/240 lon, 48 lon từ chối còn lấy, phiếu nhập hàng khách trả PN-NM1-2610-0029 và yêu cầu QC kiểm lại YC-NM1-2610-0026 (lô khóa, chờ kiểm). |

#### 27 · Đơn hàng — QT10 Kế toán lập hóa đơn (gắn phiếu xuất, in A4)
Mở board này để kiểm: Kế toán thêm hóa đơn cho một phiếu xuất đã ghi nhận giao.
Ô chỉnh trong "Trạng thái hiển thị": `vaitro` → `Kế toán` (mặc định), `Sales`, `CSKH`, `Kế toán trưởng`, `Giám đốc`, `Kế hoạch`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở mặc định | `vaitro` = `Kế toán` | ĐH-2610-0022 (KH-0044, 4 thùng Nhãn A Số 3, tổng 17.928.000 đ, đã thu 17.928.000 đ phiếu TC-2610-0005) "Đã giao". Hộp "Thêm hóa đơn · ĐH-2610-0022": phiếu xuất PX-NM1-2610-0034, số hóa đơn `0000902`, ngày 18/10/2026, tệp `hoa-don-0000902.pdf`. Chưa có hóa đơn nào ("Số hóa đơn: Chưa có"). |
| 2 | Lưu hóa đơn | Bấm "Lưu hóa đơn" | Phần Hóa đơn hiện: 0000902, 18/10/2026, phiếu xuất PX-NM1-2610-0034, tệp, người lập Ngô Bảo Ngọc. Nhật ký "Lập hóa đơn 0000902 (18/10/2026) · gắn phiếu xuất PX-NM1-2610-0034". Gửi tới minhchau.pharma@gmail.com. |
| 3 | Ô bắt buộc | Xóa số hóa đơn hoặc ngày | "Bắt buộc." (tệp hóa đơn không bắt buộc). |
| 4 | Trùng số hoặc trùng phiếu | Sau khi lưu, bấm lại "Thêm hóa đơn": nhập `0000902`; rồi nhập `0000903` cho cùng phiếu | `0000902` báo "Đơn đã có hóa đơn số 0000902."; `0000903` báo "Phiếu xuất PX-NM1-2610-0034 đã có hóa đơn." (mỗi hóa đơn gắn một phiếu xuất; một đơn nhiều hóa đơn khi có nhiều phiếu). |
| 5 | Vai trò chỉ xem | `Sales`, `Kế toán trưởng`, `Giám đốc`, `Kế hoạch`, `CSKH` | Chân hộp "Việc của Kế toán · Kế toán nhập số hóa đơn" kèm "Xem như Kế toán"; ở trang đơn thành "Thêm hóa đơn · việc của Kế toán". Kế toán trưởng cũng không lập được hóa đơn. `CSKH` thêm cảnh báo không có quyền vào màn. |
| 6 | Đơn nhiều phiếu | Từ board 9 mở ĐH-2610-0024 (một phiếu đã ghi nhận) và ĐH-2610-0025 (chưa ghi nhận giao) | ĐH-2610-0024 có "Thêm hóa đơn" với phiếu PX-NM1-2610-0036. ĐH-2610-0025 chưa có phiếu "Đã ghi nhận" nên không có nút này. |
| 7 | Đối chiếu bản in | Đối chiếu với board 28 | Số hóa đơn 0000902, ngày 18/10/2026, đơn ĐH-2610-0022, phiếu PX-NM1-2610-0034, lô A260920 phải trùng bản in. |

#### 28 · Hóa đơn bán hàng — bản thể hiện in A4 (ĐH-2610-0022)
Mở board này để kiểm: bản in A4 của hóa đơn khớp phiếu xuất và đơn gốc, và đúng theo từng trạng thái in.
Ô chỉnh trong "Trạng thái hiển thị": `trangthai` → `Xem trước` (mặc định), `Đã phát hành`, `Bản sao in lại`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | `Xem trước` | Mặc định | Dấu chìm "BẢN XEM TRƯỚC"; số "(chưa cấp)"; mã của cơ quan thuế và mã tra cứu ghi "(cấp khi phát hành)"; ô chữ ký "Chữ ký số hiện sau khi phát hành" (viền đứt). |
| 2 | `Đã phát hành` | Chọn giá trị này | Không có dấu chìm; số hóa đơn 0000902; mã cơ quan thuế và mã tra cứu là chỗ giữ chỗ "[MÃ CQT CẤP]", "[MÃ TRA CỨU]"; ô "Đã ký số — Ký bởi: Công ty Cổ phần Đầu tư MD Group — Ký ngày: 18/10/2026". |
| 3 | `Bản sao in lại` | Chọn giá trị này | Dấu chìm "BẢN SAO"; vẫn số 0000902 và khung "Đã ký số"; thêm dòng "In lại ngày 24/10/2026 bởi Trần Thị Ngọc (Kế toán) · từ hồ sơ hóa đơn trên MES". (quy tắc: in lại đóng dấu BẢN SAO, ghi người in và ngày in.) |
| 4 | Đối chiếu với đơn và phiếu xuất | So với board 11, 27 và ĐH-2610-0022 | Người mua Phạm Thu Châu, đơn vị Nhà thuốc Minh Châu, mã số thuế 0402334455, địa chỉ 61 Hùng Vương, Q. Hải Châu, Đà Nẵng (khớp KH-0044). "Theo đơn hàng: ĐH-2610-0022"; "Phiếu xuất kho: PX-NM1-2610-0034 · Lô A260920". Hàng: Nhãn A Số 3 800 g, 24 lon/thùng, thùng, số lượng 4. Số hóa đơn 0000902 khớp board 27. |
| 5 | Số tiền | Đọc bảng hàng | Đơn giá 4.482.000, thành tiền 17.928.000, "Cộng tiền bán hàng hóa, dịch vụ" 17.928.000, bằng chữ "Mười bảy triệu chín trăm hai mươi tám nghìn đồng." Tổng này khớp tổng đơn và số đã thu 17.928.000 đ; đơn giá thì lệch đơn gốc (xem mục chỗ lệch). |
| 6 | Khổ giấy và bố cục | Đo bản in | Khổ 794 × 1123 (A4 dọc), bảng có 1 dòng hàng và 7 dòng trống, đủ khung chữ ký bên mua và bên bán, dòng nhắc kiểm tra đối chiếu cuối trang. |

#### Mã mẫu dùng trong phần này (Bán hàng)
| Mã | Là gì | Xuất hiện ở board | Giá trị phải khớp (trạng thái, số lượng, tiền...) |
|---|---|---|---|
| ĐH-2610-0034 | Đơn Mua nợ của KH-0012 | 9, 12, 13, 14, 15, 22 | 300 thùng Nhãn A Số 3 × 4.150.000 đ; tổng 1.344.600.000 đ (VAT 8%); cọc 0; ban đầu "Chờ kiểm công nợ"; dư nợ khi kiểm 1.282.300.000 đ; sau khi khách trả nợ dư nợ 944.460.000 đ, cần 2.289.060.000 đ. |
| KH-0012 | Công ty TNHH Phân phối An Khang | 9, 10, 12 đến 15, 22 đến 24 | Hạn mức 1.500.000.000 đ (thành 2.000.000.000 đ sau khi Giám đốc quyết ở tình huống chờ khách); tạm khóa từ 15/10; 7 đơn, 5 đang mở; nợ quá hạn 337.840.000 đ (ĐH-2609-0018). |
| ĐH-2609-0018 | Đơn đã giao của KH-0012, còn nợ | 12 đến 15, 24 | Còn nợ 337.840.000 đ, hạn 14/10/2026 (quá 4 ngày); đã trả 200.000.000 đ phiếu TC-2610-0001. |
| ĐH-2610-0031 | Đơn đang sản xuất của KH-0007 bị yêu cầu hủy | 9, 16, 17, 18, 22 | 200 thùng Nhãn A Số 3; tổng 896.400.000 đ; đã thu 179.640.000 đ (cọc 100.000.000 đ + trước giao 79.640.000 đ); hoàn đề xuất và quyết 79.640.000 đ; lệnh LSX-2610-0011 (Chờ phát), LSX-2610-0012 (Mới tạo); yêu cầu xuất YX-2610-0015 (480 lon, phiếu PX-NM1-2610-0043). |
| ĐH-2610-0035 | Đơn Mua nợ của KH-0052 bị sửa | 9, 19, 20, 21, 22 | Bản 1: SP-0004 200 thùng × 3.700.000 đ + SP-0005 50 thùng × 3.850.000 đ = 1.007.100.000 đ, giao 05/11/2026. Bản 2: SP-0005 80 thùng, 1.131.840.000 đ, giao 10/11/2026; chênh lệch +124.740.000 đ; hạn mức 2.000.000.000 đ, dư nợ 476.820.000 đ. |
| ĐH-2610-0026 | Đơn sẵn sàng giao của KH-0058 | 9, 25, 22 | 10 thùng; tổng 44.820.000 đ đã thu đủ (TC-2610-0007); lô A260920 còn 144 lon chưa yêu cầu xuất; YX-2610-0013 (96 lon) "Bị trả về". |
| ĐH-2610-0025 | Đơn Mua nợ đang giao của KH-0052 | 9, 26, 22 | 10 thùng = 240 lon; tổng 44.820.000 đ; YX-2610-0017, phiếu PX-NM1-2610-0045 "Đã xuất" lô A241205; ghi nhận 216 lon nhận, 24 lon không nhận. |
| ĐH-2610-0022 | Đơn đã giao của KH-0044 | 9, 27, 28, 22 | 4 thùng = 96 lon; tổng 17.928.000 đ, đã thu đủ (TC-2610-0005); YX-2610-0012, phiếu PX-NM1-2610-0034, lô A260920; hóa đơn 0000902 ngày 18/10/2026. |
| ĐH-2610-0033 | Đơn chờ thu tiền (mặc định của chi tiết đơn) | 9, 11, 22 | 2 dòng hàng Nhãn B Số 3; tổng 222.480.000 đ; cọc 15.000.000 đ chưa thu; "Chờ thu tiền". |
| ĐH-2610-0043, ĐH-2610-0044 | Đơn chưa chốt để thử Sales hủy thẳng | 9, 11 | Cả hai ở "Chờ thu tiền", trả đủ trước SX (ĐH-2610-0044: 112.050.000 đ). |
| ĐH-2610-0042, ĐH-2610-0032 | Đơn nháp chưa có hợp đồng | 9, 11 | ĐH-2610-0042: KH-0065, trả đủ trước SX 90.720.000 đ — thử upload hợp đồng rồi chốt. ĐH-2610-0032: KH-0031, "chờ khách ký hợp đồng". Đơn đã có hợp đồng trong dữ liệu mẫu: số `HĐ-<mã đơn bỏ "ĐH-">`, hiệu lực từ ngày đặt đến cùng ngày năm sau (gồm cả các đơn đang ở luồng công nợ: ĐH-2610-0034, 0038, 0053, 0054, 0055). |
| KH-0044 | Nhà thuốc Minh Châu | 11, 22 đến 24, 27, 28 | MST 0402334455; phương thức mặc định "Tiền mặt"; email hóa đơn minhchau.pharma@gmail.com. |

### 4.3. Mua hàng & Kế toán

Phần này kiểm luồng mua nguyên vật liệu từ đầu đến cuối: Hàng đợi mua (board 29 và 32), đơn mua hàng gửi nhà cung cấp (board 31, 31a, 31b), hồ sơ và duyệt nhà cung cấp (board 33, 34), trả hàng nhà cung cấp (board 35), rồi công nợ, sổ thu chi và các hộp thoại ghi nhận tiền của Kế toán (board 36 đến 40).

Quy ước dùng trong phần này: NVL là nguyên vật liệu; NCC là nhà cung cấp; PO là đơn mua hàng gửi cho NCC; COA là giấy chứng nhận phân tích do NCC gửi kèm lô hàng; HSD là hạn sử dụng. Ngày hôm nay trong mockup luôn là 18/10/2026.

Hai điều cần biết trước khi test:
- Các board Mua hàng (29, 31, 31a, 31b, 32, 33, 34, 35) dùng chung một kho dữ liệu lưu trong trình duyệt. Làm gì ở board này thì board kia thấy (ví dụ gửi email yêu cầu COA ở board 31a thì PO đó ở board 31 đổi trạng thái sau khi mở lại board). Muốn quay về dữ liệu gốc, bấm "Đặt lại dữ liệu mẫu" ở đầu màn Đơn mua.
- Các board Kế toán (36 đến 40) không lưu dữ liệu giữa các lần tải lại; chỉ giữ trong lúc board đang mở. Ô `hopthoai` chỉ tự mở hộp thoại khi `vaitro` và `screen` khớp với hộp thoại đó (xem board 36).

#### 29 · Đơn mua — hàng đợi mua
Mở board này để kiểm: bảng nhu cầu mua đang thiếu, ai được sửa và lập PO, và việc trả dòng về Kế hoạch.
Ô chỉnh trong "Trạng thái hiển thị": `vaitro` → `Mua hàng` (làm được mọi việc), `Trưởng BP Mua hàng`, `Kế hoạch`, `Giám đốc`, `Thủ kho` (chỉ xem), `Kế toán` (bị chặn). `start` → đổi sang `tao-moi` hoặc `xem` không làm hiện thêm gì ở board này, để mặc định `danh-sach`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở mặc định | `vaitro` = `Mua hàng` | Có 5 dòng, mỗi dòng là một NVL tại một kho nhận. Bột sữa gầy NM1-TONG (kho tổng nhà máy 1): nhu cầu 7.900 kg, tồn kho 400 và đang về 6.000, thiếu 2.100 kg, cần trước 26/10/2026. Lon thiếc 900 g NM1-TONG: thiếu 1.200 cái, cần 27/10/2026. Premix vitamin & khoáng NM1-TONG: thiếu 300 kg, cần 05/11/2026. Bột sữa gầy NM2-TONG (nhà máy 2): nhu cầu 1.600, tồn kho 175 và đang về 1.000, thiếu 825 kg, cần 10/11/2026. Whey protein cô đặc 80% NM1-TONG: thiếu 1.000 kg, cần 01/12/2026. |
| 2 | Hàng đang về nhưng giao sau ngày cần thì không được tính | Bấm "Xem nhu cầu" ở dòng Bột sữa gầy NM2-TONG và dòng đầu | Bột sữa gầy NM2-TONG vẫn thiếu 825 dù PO-2610-0022 sắp về 1.000 kg, vì PO đó giao 05/12/2026, sau ngày cần 10/11/2026. Ở dòng đầu, các nhu cầu LSX-2610-0012, NC-2610-0001, LSX-2610-0014 ghi "PO-2610-0026 về 01/12/2026 — sau ngày cần, không tính". (quy tắc: PO về sau ngày cần không bù cho nhu cầu đó) |
| 3 | Dòng chưa có NCC đã duyệt | Nhìn dòng Premix vitamin & khoáng | Ô chọn dòng bị tắt, cột NCC ghi "Chưa có NCC đã duyệt" và "Mua hàng duyệt NCC trước". Sau khi duyệt NCC-0005 ở board 34, dòng này tự chọn sẵn NCC-0005. |
| 4 | Cảnh báo ngày giao | Dòng Lon thiếc 900 g và Whey protein; rồi chọn NCC `Southland Milk Co-operative` ở dòng Bột sữa gầy NM1-TONG, sau đó đổi ngày giao thành 20/11/2026 | Lon thiếc: "NCC giao ~10 ngày — sớm nhất 28/10/2026". Whey: "NCC giao ~45 ngày — sớm nhất 02/12/2026". Với Southland ngày giao mặc định 26/10 báo "NCC giao ~30 ngày — sớm nhất 17/11/2026"; đổi sang 20/11/2026 thì báo "sau ngày cần 26/10/2026 — báo Kế hoạch". |
| 5 | Số lượng mua lệch số thiếu | Dòng Bột sữa gầy NM1-TONG: nhập 3.000, rồi 1.000 | 3.000: "dư 900 — trừ cho lần sau". 1.000: "còn thiếu 1.100 — ở lại hàng đợi". |
| 6 | Trả dòng về Kế hoạch thiếu lý do | Chọn một dòng, bấm "Trả về Kế hoạch" khi chưa chọn lý do; rồi chọn `+ Khác` và để trống ô ghi rõ | "Chọn lý do trả về Kế hoạch." rồi "Ghi rõ lý do trả về." |
| 7 | Trả dòng về Kế hoạch thành công | Chọn lý do `Giá quá cao`, bấm "Trả về Kế hoạch" | Dòng rời bảng; thông báo "Đã trả 1 dòng về Kế hoạch (màn Cân đối NVL)…". Phần "đã trả về Kế hoạch" tăng từ 1 lên 2 dòng. Dòng có sẵn: Lecithin đậu nành NM1-TONG, 25 kg, lý do "Không NCC nào giao kịp ngày cần — NCC sớm nhất giao 05/11", người trả Mai Anh Thư, 18/10 10:20. |
| 8 | Vai trò chỉ xem | `vaitro` = `Trưởng BP Mua hàng`, rồi `Giám đốc`, `Thủ kho` | Vào được màn, mọi ô nhập và ô chọn bị tắt, hiện "Việc của Mua hàng · Mua hàng lập PO từ hàng đợi" kèm nút "Xem như Mua hàng". Không có nút "Lập PO". |
| 9 | Kế hoạch | `vaitro` = `Kế hoạch` | Có thêm nút "+ Thêm nhu cầu". Ở phần đã trả về, nút "Vẫn mua — giao lại Mua hàng" bấm được (các vai trò khác thì không). |
| 10 | Vai trò bị chặn | `vaitro` = `Kế toán` | Hiện "Vai trò Kế toán không có quyền vào màn này. Về Việc cần làm". |

#### 31 · Đơn mua — PO
Mở board này để kiểm: danh sách PO theo trạng thái, các bước Chờ COA & HSD, Chờ chọn thanh toán, duyệt theo mức tiền, hủy và đóng PO.
Ô chỉnh trong "Trạng thái hiển thị": `vaitro` → `Mua hàng`, `Trưởng BP Mua hàng`, `Giám đốc`, `Kế hoạch`, `Thủ kho`, `Kế toán`. `start` → `danh-sach` (mặc định), `xem` (mở sẵn PO-2610-0023), `tao-moi` (không mở form PO mà chuyển sang Hàng đợi mua, vì PO chỉ lập từ đó).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Thanh tab | Mở màn, đọc số trên từng tab | Tất cả 20; Chờ COA & HSD 3; Chờ chọn thanh toán 1; Chờ duyệt 3; Đã duyệt 1; Đã gửi NCC 3; Nhận một phần 1; Đã nhận đủ 6; Đã đóng 0; Từ chối 1; Đã hủy 1. |
| 2 | PO ở trạng thái Chờ COA & HSD | Tab Chờ COA & HSD, mở từng PO | PO-2610-0025 ghi "chưa gửi email yêu cầu NCC": nút "Gửi email yêu cầu COA & HSD" bấm được, nút "Kiểm COA & HSD NCC gửi" bị tắt kèm ghi chú "Gửi email yêu cầu trước". PO-2610-0026 và PO-2610-0024 ghi "đã gửi yêu cầu 18/10 11:05" và "18/10 08:30 — chờ NCC phản hồi": nút đổi thành "Soạn email nhắc NCC", nút kiểm COA bấm được. |
| 3 | Kiểm COA & HSD: thiếu thông tin | Mở PO-2610-0024, bấm "Kiểm COA & HSD NCC gửi", không nhập gì, bấm "Đạt · chọn thanh toán" | Hộp thoại vẫn mở, ghi "Chưa đủ thông tin — Còn 8 mục cần nhập" (6 chỉ tiêu, ngày sản xuất kèm HSD, và file COA). PO vẫn ở Chờ COA & HSD. |
| 4 | Kiểm COA & HSD: không đạt | Đưa file COA, ngày sản xuất 05/10/2026, HSD 04/04/2028; nhập Độ ẩm 5,6 | "Không đạt — 1 mục: Độ ẩm 5,6 % (yêu cầu ≤ 5,0 %)"; nút "Đạt · chọn thanh toán" bị tắt, chân hộp thoại ghi "Có NVL không đạt — hủy PO, chọn lại NCC." HSD 30/10/2026 (trước ngày giao 01/11/2026) báo "Hết hạn trước ngày giao"; ngày sản xuất sau HSD báo "Ngày sản xuất sau hạn sử dụng"; nhập chữ vào ô số báo "Nhập số". |
| 5 | Kiểm COA & HSD: đạt, và hủy PO khi không đạt | Nhập đủ giá trị đạt (Độ ẩm 3,8; Chất béo 27,1; Protein 34,5; Vi sinh 2.000; Coliforms và Salmonella `Đạt`) rồi xác nhận. Làm lại ở PO-2610-0026 với Độ ẩm 5,6 ở dòng Whey và hủy PO | Đạt: PO-2610-0024 sang Chờ chọn thanh toán, thông báo "COA & HSD đạt — bước tiếp: chọn hình thức thanh toán, sau đó Trưởng BP Mua hàng duyệt." Không đạt: PO-2610-0026 thành Đã hủy với lý do "COA / HSD không đạt — Whey protein cô đặc 80%: Độ ẩm 5,6 % (yêu cầu ≤ 5,0 %)"; NCC-0002 bị khóa cho Whey; ở Hàng đợi mua dòng Whey ghi "Đã từ chối: NCC-0002 — Độ ẩm 5,6 % (yêu cầu ≤ 5,0 %)". PO-2610-0020 có thêm nút "Xem kết quả kiểm COA & HSD" để xem lại, chỉ đọc. |
| 6 | Bước Chờ chọn thanh toán | Mở PO-2610-0027 (19.200.000 đ), bấm "Chọn hình thức thanh toán" | Mặc định theo NCC-0004: Trả sau 30 ngày. Chọn `Cọc + trả nốt trước giao` rồi để trống tỷ lệ cọc: "Bắt buộc."; nhập 100: "Tỷ lệ cọc 1–99 %." Nhập 30: gợi ý "Cọc 5.760.000 đ · trả nốt 13.440.000 đ"; lưu thì PO sang Chờ duyệt, thông báo "PO-2610-0027: Cọc 30% + trả nốt trước giao · Chuyển khoản — PO chuyển Chờ duyệt." Chọn `Trả sau` với số ngày 0: "Nhập số ngày > 0." |
| 7 | Hình thức Cọc + trả nốt trước giao đã có sẵn | Mở PO-2610-0023 (`start` = `xem` cũng mở PO này) | Hình thức "Cọc 30% + trả nốt trước giao"; kế hoạch trả "Cọc 55.500.000 đ khi gửi PO · trả nốt 129.500.000 đ trước khi NCC giao" (30% của 185.000.000 đ). Thanh tiến trình đứng ở bước Giám đốc duyệt, dòng trạng thái ghi "chờ Giám đốc duyệt (> 100 triệu) · Trưởng BP đã duyệt". |
| 8 | Duyệt theo mức tiền | `vaitro` = `Trưởng BP Mua hàng`: bấm "Duyệt" ở PO-2610-0019 (92.500.000 đ), rồi ở PO-2610-0020 (176.000.000 đ). Sau đó `vaitro` = `Giám đốc` duyệt PO-2610-0020 và PO-2610-0023 | 0019 thành Đã duyệt. 0020 vẫn Chờ duyệt, thông báo "Trưởng BP Mua hàng đã duyệt — chuyển Giám đốc duyệt (> 100 triệu)", chỉ còn nút của Giám đốc. Giám đốc duyệt xong thì sang Đã duyệt và hiện nút "Gửi email PO cho NCC". "Từ chối" bỏ trống lý do: "Bắt buộc." (quy tắc: PO trên 100 triệu cần thêm Giám đốc duyệt) |
| 9 | Hủy PO, đóng phần còn lại | Hủy PO-2610-0018 (đã có phiếu nhập); hủy PO-2610-0017; bấm "Đóng phần còn lại" ở PO-2609-0009 | 0018: "PO đã có phiếu nhập — không hủy được." 0017 thành Đã hủy, ghi "chưa gửi email báo NCC · NCC hết hàng" và có nút "Email báo hủy PO cho NCC". 0009 (nhận 2.725/5.000 kg) bỏ trống lý do: "Bắt buộc." Hủy PO đã duyệt chỉ `Trưởng BP Mua hàng` làm được. |
| 10 | Vai trò | Lần lượt `Mua hàng`, `Giám đốc`, `Kế hoạch`, `Thủ kho`, `Kế toán` | `Mua hàng` ở PO chờ duyệt thấy "Bạn là người tạo PO này — người tạo không tự duyệt" và nút Duyệt thành "Việc của Trưởng BP Mua hàng". `Trưởng BP Mua hàng` làm được mọi bước PO (kiểm COA, chọn thanh toán, duyệt, gửi email). `Giám đốc`, `Kế hoạch`, `Thủ kho` vào xem, nút bị thay bằng "Việc của …". `Kế toán` thấy "Vai trò Kế toán không có quyền vào màn này." |

#### 31a · Đơn mua — gửi yêu cầu COA & HSD cho NCC qua email (kèm phiếu yêu cầu)
Mở board này để kiểm: soạn và gửi email yêu cầu COA, HSD cho NCC, kèm phiếu yêu cầu liệt kê chỉ tiêu cần có.
Ô chỉnh trong "Trạng thái hiển thị": `ma` → `PO-2610-0026`, `PO-2610-0025`, `PO-2610-0024`. `vaitro` → `Mua hàng`, `Trưởng BP Mua hàng`, `Kế toán`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | `ma` = `PO-2610-0026` | Mở mặc định | Trạng thái "Đã gửi yêu cầu 18/10/2026 11:05", cảnh báo vàng "Đã gửi yêu cầu cho PO này lúc 18/10/2026 11:05. Nếu NCC chưa phản hồi, dùng mẫu "Nhắc NCC gửi COA & HSD"." Mẫu tự chọn là nhắc, người nhận export@lactoingredients.nl, phiếu có 2 NVL: Whey protein cô đặc 80% (NVL-BOT-0003) và Bột sữa gầy (NVL-BOT-0002), mỗi dòng 1.000 kg, giao 01/12/2026, mỗi NVL có 6 chỉ tiêu. |
| 2 | `ma` = `PO-2610-0025` | Đổi `ma` | "Chờ gửi yêu cầu", không có cảnh báo vàng, mẫu "Yêu cầu COA & HSD". Người nhận banhang@baobidonga.vn; phiếu có Lon thiếc 900 g (NVL-BBI-0002) 1.200 cái giao 27/10/2026 với 2 chỉ tiêu (Thôi nhiễm kim loại, Ngoại quan). |
| 3 | `ma` = `PO-2610-0024` | Đổi `ma` | "Đã gửi yêu cầu 18/10/2026 08:30", mẫu nhắc, người nhận kinhdoanh@suaphuongnam.vn; Bột sữa nguyên kem 26% béo 825 kg giao 01/11/2026, 6 chỉ tiêu. Mọi mã đều có hạn phản hồi 20/10/2026 và phiếu tên YC-COA_<mã PO>_<mã NCC>.pdf. |
| 4 | Gửi thành công | `ma` = `PO-2610-0025`, bấm "Gửi email" | Hiện "Đã gửi PO-2610-0025 tới banhang@baobidonga.vn", nội dung phụ "…kèm YC-COA_PO-2610-0025_NCC-0004.pdf · lưu email vào lịch sử PO · nhắc bạn nếu NCC chưa phản hồi trước 20/10/2026. Khi NCC gửi COA, vào PO bấm "Kiểm COA & HSD NCC gửi"." Mở lại board 31: PO này ghi "đã gửi yêu cầu 18/10 <giờ> — chờ NCC phản hồi" và nút kiểm COA bấm được. |
| 5 | Lỗi người nhận | Xóa hết người nhận rồi gửi; thêm chữ `abc@` rồi gửi | "Chưa gửi được: thêm người nhận." và "Chưa gửi được: sửa email không hợp lệ (abc@)."; chip email sai tô đỏ, ghi "Email không hợp lệ". |
| 6 | Mẫu bổ sung còn placeholder | Chọn mẫu "Yêu cầu bổ sung hồ sơ còn thiếu", gửi ngay | "Chưa gửi được: ghi rõ NVL và hồ sơ còn thiếu." (phải thay dòng [GHI RÕ NVL VÀ HỒ SƠ CÒN THIẾU]). |
| 7 | Hạn phản hồi sai | Mở "Cấu hình phiếu": đặt hạn 17/10/2026, rồi để trống | "Chưa gửi được: hạn phản hồi đã qua." rồi "Chưa gửi được: chọn hạn NCC phản hồi (Cấu hình phiếu)." |
| 8 | Trường lạ, tiêu đề trống, phiếu thiếu tên | Gõ `{Mã lạ}` vào nội dung; xóa cả tiêu đề và nội dung; xóa tên NCC trên phiếu | "Có trường chưa nhận ra: {Mã lạ} — sửa lại hoặc xóa trước khi gửi."; "Chưa gửi được: sửa trường chưa nhận ra."; "Chưa gửi được: nhập tiêu đề · nhập nội dung."; "Chưa gửi được: phiếu thiếu tiêu đề / tên NCC." |
| 9 | Lưu nháp, hủy nháp | Bấm "Lưu nháp", rồi "Hủy nháp" | "Đã lưu nháp email và phiếu cho <mã PO> — mở lại PO này sẽ thấy đúng bản đang soạn." và "Đã hủy nháp — email và phiếu trở về dữ liệu của PO." |
| 10 | Vai trò | `vaitro` = `Trưởng BP Mua hàng`; rồi `Kế toán` | `Trưởng BP Mua hàng`: người gửi đổi thành Tạ Văn Hùng, Cc là thu.mai@mespowder.vn, gửi được. `Kế toán`: banner "Vai trò Kế toán không có quyền vào màn này.", mọi ô bị tắt, hiện "Việc của Mua hàng · Mua hàng / Trưởng BP Mua hàng gửi yêu cầu COA & HSD" và nút "Xem như Mua hàng". |

#### 31b · Đơn mua — gửi PO cho NCC qua email (kèm PDF đơn đặt hàng)
Mở board này để kiểm: email gửi PO và phiếu PO in kèm, gồm tiền, thuế, bằng chữ và điều khoản thanh toán.
Ô chỉnh trong "Trạng thái hiển thị": `ma` → `PO-2610-0022`, `PO-2610-0018`, `PO-2610-0017`. `vaitro` → `Mua hàng`, `Trưởng BP Mua hàng`, `Kế toán`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | `ma` = `PO-2610-0022` | Mở mặc định | Trạng thái Đã duyệt, mẫu "Gửi PO mới", tiêu đề "[MD Group] Đơn đặt hàng PO-2610-0022 – Southland Milk Co-operative". Phiếu: 1.000 kg × 86.500 đ = 86.500.000 đ, thuế 5% 4.325.000 đ, tổng 90.825.000 đ, bằng chữ "Chín mươi triệu tám trăm hai mươi lăm nghìn đồng chẵn."; giao 05/12/2026 tại "Kho tổng NM2 · Long An"; điều khoản "Trả trước 100% trước khi giao". |
| 2 | `ma` = `PO-2610-0018` | Đổi `ma` | Trạng thái Đã gửi NCC (gửi lúc 09/10/2026 14:10), mẫu tự chọn "Gửi lại PO đã sửa", cảnh báo "PO này đã gửi NCC lúc 09/10/2026 14:10. Gửi lại sẽ thay bản trước — nhớ ghi rõ nội dung thay đổi trong email." Phiếu: 3.000 kg × 88.000 đ = 264.000.000 đ, thuế 5% 13.200.000 đ, tổng 277.200.000 đ, bằng chữ "Hai trăm bảy mươi bảy triệu hai trăm nghìn đồng chẵn."; giao 20/10/2026; "Trả sau 30 ngày kể từ ngày nhận hàng". |
| 3 | `ma` = `PO-2610-0017` | Đổi `ma` | Đã gửi NCC (07/10/2026 09:20). Lon thiếc 800 g: 18.000 cái × 3.200 đ = 57.600.000 đ, thuế 10% 5.760.000 đ, tổng 63.360.000 đ, bằng chữ "Sáu mươi ba triệu ba trăm sáu mươi nghìn đồng chẵn."; giao 22/10/2026. |
| 4 | Gửi PO mới thành công | `ma` = `PO-2610-0022`, bấm "Gửi email" | "Đã gửi PO-2610-0022 tới sales@southlandmilk.co.nz"; nội dung phụ có "PO chuyển "Đã gửi NCC", lưu email vào lịch sử PO · nhắc bạn nếu NCC chưa phản hồi sau 2 ngày." Mở lại board 31: PO-2610-0022 thành Đã gửi NCC, có dòng nhật ký "Gửi email PO cho NCC tới sales@southlandmilk.co.nz · lưu bản PDF đã gửi". |
| 5 | Gửi lại chưa ghi thay đổi | `ma` = `PO-2610-0018`, gửi ngay | "Chưa gửi được: ghi rõ nội dung thay đổi trong email." Mẫu "Báo hủy PO" để nguyên: "Chưa gửi được: ghi rõ lý do." |
| 6 | Chiết khấu, thuế | Mở "Cấu hình phiếu" ở `PO-2610-0022`: chiết khấu 10; rồi thuế 8; rồi chiết khấu 150 hoặc `abc` | Chiết khấu 10%: sau chiết khấu 77.850.000 đ, thuế 3.892.500 đ, tổng 81.742.500 đ. Thuế 8% (không chiết khấu): tổng 93.420.000 đ. 150 hoặc `abc`: "Chưa gửi được: chiết khấu 0–100% (Cấu hình phiếu)." |
| 7 | Lỗi người nhận và phiếu | Xóa hết người nhận; nhập `x@y`; xóa tên NCC trên phiếu | "Chưa gửi được: thêm người nhận."; "Chưa gửi được: sửa email không hợp lệ (x@y)."; "Chưa gửi được: phiếu PO thiếu tiêu đề / tên NCC." |
| 8 | PO có hình thức Cọc + trả nốt trước giao | Ở board 31 `vaitro` = `Giám đốc` duyệt PO-2610-0023, đổi sang `Mua hàng`, bấm "Gửi email PO cho NCC" | Phiếu mở ra đúng PO-2610-0023, điều khoản "Cọc 30% + trả nốt trước giao", NCC Lacto Ingredients B.V., tổng 185.000.000 đ + thuế 5% = 194.250.000 đ, tài khoản NCC là ING Bank N.V. · NL91 INGB 0001 2345 67. |
| 9 | Ngôn ngữ | Bấm "English" cạnh mẫu email | Điều khoản đổi thành "100% advance payment before delivery" cho PO-2610-0022 (NCC nước ngoài). Mẫu "Báo hủy" và "Báo đóng" không có bản tiếng Anh nên giữ tiếng Việt. |
| 10 | Vai trò | `vaitro` = `Trưởng BP Mua hàng` và `Kế toán` | `Trưởng BP Mua hàng` gửi được, người gửi Tạ Văn Hùng. `Kế toán`: "Vai trò Kế toán không có quyền vào màn này.", ô bị tắt, "Việc của Mua hàng · Mua hàng / Trưởng BP Mua hàng gửi PO cho NCC". |

#### 32 · Đơn mua — lập PO: nhập đơn giá ở Hàng đợi mua rồi lập PO (không qua báo giá)
Mở board này để kiểm: Mua hàng nhập số lượng, NCC, đơn giá, ngày giao ngay ở Hàng đợi mua rồi lập PO, không có bước báo giá.
Ô chỉnh trong "Trạng thái hiển thị": `vaitro` → `Mua hàng` (lập được), các vai trò khác chỉ xem. `start` mặc định là `tao-moi`: board mở thẳng Hàng đợi mua (không có form PO riêng).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Chưa nhập đơn giá | Chọn dòng Bột sữa gầy NM1-TONG, bấm "Lập PO" | Ô đơn giá trống, báo "Bột sữa gầy (NM1-TONG): nhập đơn giá"; chưa có PO nào mới. |
| 2 | Lập một PO | Chọn dòng Bột sữa gầy NM1-TONG, NCC `Công ty TNHH Nguyên liệu Sữa Phương Nam`, đơn giá 88.000, bấm "Lập PO" | Thông báo "Đã lập PO-2610-0028 (Công ty TNHH Nguyên liệu Sữa Phương Nam, Chờ COA & HSD). Bước tiếp: tab Đơn mua (PO) → Chờ COA & HSD, gửi NCC email yêu cầu COA và hạn dùng." PO: 2.100 kg × 88.000 đ = 184.800.000 đ, hình thức Trả sau 30 ngày (theo hồ sơ NCC), giao 26/10/2026. Nhật ký có "Lập PO từ Hàng đợi mua · Bột sữa gầy 2.100 × 88.000 đ" và "Chờ gửi email yêu cầu NCC cung cấp COA & HSD cho 1 NVL". |
| 3 | Gộp PO theo NCC và kho | Chọn 3 dòng: Bột sữa gầy NM1-TONG và Whey NM1-TONG đều NCC `Lacto Ingredients B.V.` (giá 84.000 và 185.000), Lon thiếc 900 g NCC `Công ty CP Bao bì Kim loại Đông Á` giá 3.500; lập PO | Tạo 2 PO: PO-2610-0028 (Lacto, 2 dòng, 2.100 × 84.000 + 1.000 × 185.000 = 361.400.000 đ, hình thức "Cọc 30% + trả nốt trước giao" lấy từ hồ sơ NCC) và PO-2610-0029 (Đông Á, 1.200 × 3.500 = 4.200.000 đ). Cả hai ở Chờ COA & HSD. |
| 4 | Báo lỗi nhiều dòng | Chọn nhiều dòng thiếu giá cùng lúc; nhập số lượng 0; đặt ngày giao 10/10/2026 | Các lỗi nối bằng dấu "·", ví dụ "Bột sữa gầy (NM1-TONG): số lượng > 0" và "Bột sữa gầy (NM1-TONG): ngày giao đã qua". Chỉ dòng chưa có NCC mới bị chặn chọn. |
| 5 | Mua một phần | Dòng Bột sữa gầy NM1-TONG: số lượng 1.000, đơn giá 88.000, lập PO | PO-2610-0028 với 1.000 kg; dòng vẫn còn ở hàng đợi, thiếu còn 1.100 kg. |
| 6 | Hủy PO thì điền lại | Ở tab Đơn mua (PO), hủy PO-2610-0025 với lý do "Giá tăng", quay lại Hàng đợi mua | Dòng Lon thiếc 900 g quay lại, ghi "PO-2610-0025 đã hủy" và "— Giá tăng. Đã điền lại SL, NCC, đơn giá, ngày giao như PO cũ."; số lượng 1.200, đơn giá 3.500 điền sẵn. |
| 7 | NCC bị từ chối vì COA | Làm theo case 5 của board 31 rồi quay lại Hàng đợi mua | Dòng Whey không còn NCC chọn được; NCC-0002 mờ đi kèm chữ "đã từ chối COA / HSD". |
| 8 | Vai trò | `Trưởng BP Mua hàng`, `Kế hoạch`, `Giám đốc`, `Thủ kho` | Không lập được PO (nút "Lập PO" không có), hiện "Việc của Mua hàng · Mua hàng lập PO từ hàng đợi". `Kế toán` bị chặn. |

#### 33 · Nhà cung cấp — danh sách & duyệt
Mở board này để kiểm: danh sách NCC theo trạng thái, tạo hồ sơ NCC, và lỗi khi nhập hồ sơ.
Ô chỉnh trong "Trạng thái hiển thị": `screen` → `ncc` (bắt buộc đổi, xem phần chỗ lệch), cũng thử `bao-gia`, `po`, `tra-hang`; `vaitro` → `Mua hàng` (tạo, sửa), `Trưởng BP Mua hàng`, `Giám đốc` (chỉ xem), `Kế hoạch`, `Thủ kho`, `Kế toán` (bị chặn); `start` → `danh-sach`, `tao-moi` (mở sẵn form tạo hồ sơ), `xem` (mở sẵn chi tiết NCC-0005).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Màn mặc định | Mở không chỉnh gì | Hiện Hàng đợi mua (vì `screen` mặc định là `bao-gia`), không phải danh sách NCC. Đổi `screen` = `ncc` mới thấy danh sách. |
| 2 | Danh sách và thanh tab | `screen` = `ncc` | Tất cả 8; Chờ duyệt 2 (NCC-0005, NCC-0006); Đã duyệt 4 (NCC-0001 đến 0004); Từ chối 1 (NCC-0007, lý do "Chứng nhận ATTP hết hạn 31/05/2026"); Ngừng dùng 1 (NCC-0008, "Giao trễ 4/6 PO quý 3/2026"). Cột hồ sơ pháp lý: NCC-0006 và NCC-0007 ghi "Thiếu", còn lại "Đủ". |
| 3 | Lọc theo NVL | Bộ lọc "NVL cung cấp" = `NVL-BOT-0003 · Whey protein cô đặc 80%` | Chỉ còn NCC-0002 (được phép) và NCC-0006 (đề xuất). |
| 4 | Tạo hồ sơ, bỏ trống | `vaitro` = `Mua hàng`, bấm "+ Tạo hồ sơ NCC", bấm lưu ngay | Các ô báo "Bắt buộc.": Tên NCC, Mã số thuế (MST), Địa chỉ, Người liên hệ, Số điện thoại, Hình thức thanh toán mặc định, NVL đề xuất cung cấp. Form tự nhảy sang tab có lỗi. |
| 5 | Tạo hồ sơ, nhập sai | MST `0312345678`; email `abc`; hình thức `Cọc + trả nốt trước giao` với tỷ lệ cọc 100; hình thức `Trả sau` bỏ trống số ngày; thêm một chứng nhận ISO 22000 không số, không ngày | "MST đã có: NCC-0001 · Công ty TNHH Nguyên liệu Sữa Phương Nam (Đã duyệt)."; "Email chưa đúng định dạng."; "Tỷ lệ cọc 1–99 %."; "Bắt buộc." ở số ngày trả sau; dòng chứng nhận "Nhập đủ: Số, Ngày hết hạn." |
| 6 | Tạo hồ sơ thành công | MST mới `0999999999`, hình thức `Cọc + trả nốt trước giao` tỷ lệ cọc 40, thêm "Giấy phép kinh doanh" có số, chọn ít nhất 1 NVL, lưu | "Đã tạo NCC-0009."; trạng thái Chờ duyệt, thấy ở tab Chờ duyệt (3). Mở chi tiết ghi "Cọc 40% + trả nốt trước giao · Chuyển khoản". |
| 7 | Hình thức thanh toán của NCC-0002 | Mở chi tiết NCC-0002 | "Cọc 30% + trả nốt trước giao · Chuyển khoản"; tài khoản ING Bank N.V. (SWIFT INGBNL2A) · NL91 INGB 0001 2345 67 · LACTO INGREDIENTS B.V.; chứng nhận Halal "Sắp hết hạn · còn 44 ngày". |
| 8 | Sửa hồ sơ | Nhìn cột nút ở mọi dòng | `Mua hàng` thấy nút "Sửa" ở cả 8 dòng, kể cả NCC đã duyệt; không có nút "Xóa". |
| 9 | Vai trò | `Trưởng BP Mua hàng`, `Giám đốc`; `Kế hoạch` | `Trưởng BP Mua hàng`, `Giám đốc`: vào xem, không có nút "+ Tạo hồ sơ NCC", hiện "Việc của Mua hàng". `Kế hoạch`, `Thủ kho`, `Kế toán`: "Vai trò … không có quyền vào màn này." |

#### 34 · Nhà cung cấp — chi tiết & duyệt
Mở board này để kiểm: duyệt hoặc từ chối NCC, ngừng dùng NCC, và bảng lịch sử NCC.
Ô chỉnh trong "Trạng thái hiển thị": `vaitro` → `Trưởng BP Mua hàng` (mặc định, duyệt được), `Mua hàng`, `Kế hoạch`, `Giám đốc`, `Thủ kho`, `Kế toán`. `start` → `xem` (mặc định, mở chi tiết NCC-0005), `danh-sach`, `tao-moi`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở mặc định | Giữ `xem` | NCC-0005 Công ty TNHH Premix Việt, MST 0109876543, Chờ duyệt. Banner "Hồ sơ đủ — sẵn sàng duyệt." và "Hàng đợi mua có 2 nhu cầu đang chờ có NCC đã duyệt: LSX-2610-0016 (Lecithin đậu nành), NC-2610-0002 (Premix vitamin & khoáng)." NVL được phép cung cấp: "Chưa có — chỉ có sau khi duyệt". Hai nút "Từ chối" và "Duyệt NCC". |
| 2 | Duyệt NCC | Bấm "Duyệt NCC", thử bỏ chọn hết NVL, rồi chọn lại và lưu | Hộp thoại "Duyệt nhà cung cấp" điền sẵn 2 NVL đề xuất (NVL-PGA-0001, NVL-PGA-0004). Bỏ hết: "Bắt buộc." Lưu: "NCC-0005: đã duyệt.", trạng thái Đã duyệt, người duyệt Tạ Văn Hùng, ngày 18/10/2026. Ở Hàng đợi mua dòng Premix có sẵn NCC-0005. |
| 3 | Hồ sơ chưa đủ | Đóng chi tiết, mở NCC-0006 Emerald Whey Ltd, bấm "Duyệt NCC" | Banner "Chưa duyệt được: thiếu chứng nhận ATTP / ISO / FSSC còn hạn." Bấm duyệt: "Hồ sơ chưa đủ: cần giấy phép kinh doanh và chứng nhận còn hạn. Bổ sung hồ sơ (Sửa) hoặc Từ chối." |
| 4 | Từ chối | Ở NCC-0006 bấm "Từ chối", lưu khi trống; rồi nhập lý do "Thiếu FSSC" | "Bắt buộc." rồi "NCC-0006: đã từ chối."; trạng thái Từ chối, banner "Từ chối bởi Tạ Văn Hùng ngày 18/10/2026 — lý do: Thiếu FSSC". |
| 5 | Ngừng dùng | Mở NCC-0001 (Đã duyệt), bấm "Ngừng dùng", lưu khi trống | Thông báo trong hộp thoại: "NCC bị ẩn khỏi danh sách chọn, chặn PO mới; hồ sơ được giữ. Hệ thống báo Mua hàng 4 PO đang mở: PO-2610-0024, PO-2610-0020, PO-2610-0018, PO-2609-0009." Lưu khi trống lý do: "Bắt buộc." |
| 6 | Lịch sử nhà cung cấp | Mở lần lượt NCC-0001, NCC-0008, NCC-0002 | Chú thích "Chỉ để tra cứu khi chọn NCC — không chấm điểm." NCC-0001 có 9 dòng: 7 lần Trả hàng (TH-NCC-2610-0004, 2610-0006, 2610-0003, 2610-0001, 2609-0004, 2609-0003, 2609-0002), Giao thiếu PO-2609-0009 ngày 25/09 ("Đợt 1 nhận 2.725 / 5.000 kg (PN-NM1-2609-0050); thiếu 2.275 kg — NCC hẹn giao 24/10") và Giao trễ PO-2609-0007 ngày 15/09 ("Hẹn giao 13/09, nhận 15/09 — trễ 2 ngày"). NCC-0008 có 4 dòng Giao trễ. NCC-0002: "Chưa có lần trả hàng, giao trễ hay giao thiếu nào." |
| 7 | Chứng nhận sắp hết hạn | Mở NCC-0003 và NCC-0002 | NCC-0003: ISO 22000 "Sắp hết hạn · còn 18 ngày" và banner "Có chứng nhận sắp hết hạn — nhắc NCC gửi bản mới." NCC-0002: Halal còn 44 ngày. |
| 8 | Gửi duyệt lại | Mở NCC-0007 (Từ chối) hoặc NCC-0008 (Ngừng dùng) | Nút "Gửi duyệt lại" chỉ `Mua hàng` bấm được; ở `Trưởng BP Mua hàng` hiện "Việc của Mua hàng". Bấm xong NCC về Chờ duyệt, danh sách NVL được phép được xóa để chọn lại khi duyệt. |
| 9 | Vai trò | `vaitro` = `Mua hàng`; rồi `Kế hoạch` | `Mua hàng`: không có "Duyệt NCC" / "Từ chối", hiện "Việc của Trưởng BP Mua hàng · chỉ Trưởng BP Mua hàng duyệt NCC" kèm nút "Xem như Trưởng BP Mua hàng". `Kế hoạch`, `Thủ kho`, `Kế toán` bị chặn; `Giám đốc` chỉ xem. |

#### 35 · Trả hàng nhà cung cấp
Mở board này để kiểm: tạo phiếu trả hàng NCC, các bước xác nhận và duyệt xuất trả, và việc khóa sửa hoặc xóa phiếu.
Ô chỉnh trong "Trạng thái hiển thị": `vaitro` → `Mua hàng` (mặc định), `Trưởng BP Mua hàng` (duyệt xuất trả), `Kế hoạch`, `Giám đốc`, `Thủ kho` (chỉ xem), `Kế toán` (bị chặn). `start` → `danh-sach`, `tao-moi` (mở sẵn form tạo phiếu), `xem` (mở sẵn TH-NCC-2610-0006).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Danh sách | Mở mặc định | 9 phiếu. Tab: Chờ NCC xác nhận 1 (TH-NCC-2610-0005); Không thống nhất 1 (2609-0003); NCC chấp nhận 0; Chờ duyệt xuất trả 1 (2610-0006); Chờ kho xuất trả 2 (2610-0004, 2610-0003); Đã xuất trả 1 (2610-0001); Chờ ký xác nhận 1 (2609-0004); Hoàn tất 1 (2609-0001); Chuyển hủy 1 (2609-0002). |
| 2 | Tạo phiếu bỏ trống | Bấm "+ Tạo phiếu trả hàng", lưu ngay | "Bắt buộc." ở Phiếu mua hàng (PO), Nguồn hàng trả, Lý do trả, Hướng xử lý; dòng hàng "Nhập đủ: NVL, Số lô NCC, Số lượng trả." |
| 3 | Trả vượt số đã nhận | PO-2610-0015, nguồn `Đã nhập kho`, phiếu nhập PN-NM1-2610-0019, NVL Bột sữa gầy, lô L-BOT-22, số lô NCC S-1272, số lượng 5 | "Vượt số đã nhận theo PO: đã nhận 500, đã trả ở phiếu khác 500." (đã trả 25 kg ở TH-NCC-2610-0001 và 475 kg ở TH-NCC-2610-0003). |
| 4 | PO trả trước mà chọn giảm công nợ | PO-2609-0008, hướng xử lý `Giảm công nợ` | "PO trả trước — không có khoản phải trả để giảm trừ; chọn Đổi 1-1." |
| 5 | Từ chối ở cửa kho | PO-2610-0017, nguồn `Từ chối ở cửa kho`, lý do `Thiếu chứng từ`, số lượng 20.000, rồi 500 | Phải có "Biên bản giao nhận" (nếu để trống: "Bắt buộc."). 20.000: "Vượt số chưa nhận theo PO (18.000)." 500: "Đã tạo TH-NCC-2610-0007.", trạng thái Chờ NCC xác nhận, không có lô. Lý do `QC không đạt` thêm ô bắt buộc "Phiếu kiểm QC". |
| 6 | Nhánh NCC không chấp nhận | Ở TH-NCC-2610-0005 bấm "NCC không chấp nhận" (để trống rồi nhập nội dung); ở TH-NCC-2609-0003 xem hai nút | Nội dung biên bản để trống: "Bắt buộc." Nhập xong phiếu sang Không thống nhất. TH-NCC-2609-0003 có hai nút "Nhà máy chịu — chuyển hủy hàng" (cần lý do) và "Đã thống nhất — NCC nhận lại". |
| 7 | Duyệt xuất trả | `vaitro` = `Trưởng BP Mua hàng`, mở TH-NCC-2610-0006: "Từ chối" để trống lý do, rồi nhập "Thiếu ảnh"; sau đó "Duyệt xuất trả" | "Bắt buộc." Từ chối xong phiếu quay về NCC chấp nhận, banner "Trưởng BP Mua hàng từ chối yêu cầu xuất trả: Thiếu ảnh — sửa phiếu rồi gửi lại.", phiếu sửa được và có nút "Gửi yêu cầu xuất trả NCC". Duyệt: sang Chờ kho xuất trả, thông báo "TH-NCC-2610-0006: đã duyệt — Kho lập phiếu xuất trả." |
| 8 | Khóa sửa và xóa | Nhìn cột nút ở từng dòng | Chỉ TH-NCC-2610-0005 (Chờ NCC xác nhận) có "Sửa" và "Xóa". Các phiếu còn lại không có nút nào. Phiếu Giảm công nợ chưa ghi ghi "Giảm trừ khoản phải trả: Kế toán chưa ghi."; TH-NCC-2609-0004 ghi "Kế toán đã ghi 9.800.000 đ". |
| 9 | Vai trò | `Mua hàng`, `Trưởng BP Mua hàng`, `Kế hoạch`, `Kế toán` | `Trưởng BP Mua hàng` vào được màn này (đúng menu). Ở TH-NCC-2610-0005 nút NCC chấp nhận / không bị chuyển thành "Việc của Mua hàng"; ở TH-NCC-2610-0006 `Mua hàng` thấy "Việc của Trưởng BP Mua hàng". `Kế hoạch` và `Kế toán` bị chặn. |

#### 36 · Kế toán — Công nợ khách hàng
Mở board này để kiểm: số liệu công nợ khách, các hộp thoại ghi nhận hoàn tiền, ghi kết quả nợ quá 90 ngày, ghi liên hệ nhắc nợ, và phân vai Kế toán.
Ô chỉnh trong "Trạng thái hiển thị": `screen` → `cnkh`, `cnncc`, `so`; `vaitro` → `Kế toán`, `Kế toán trưởng`, `Sales`, `Mua hàng`, `Giám đốc`; `hopthoai` → `khong`, `tien-ve`, `hoan-tien`, `ket-qua-90`, `lien-he`, `tra-ncc`, `giam-tru`, `huy`. Hộp thoại chỉ tự mở khi khớp: `tien-ve`, `hoan-tien`, `ket-qua-90` cần `Kế toán` + `cnkh`; `lien-he` cần `Sales` + `cnkh`; `tra-ncc`, `giam-tru` cần `Kế toán` + `cnncc`; `huy` cần `Kế toán` + `so`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở mặc định | `vaitro` = `Kế toán`, `screen` = `cnkh`, `hopthoai` = `khong` | 10 khách. Năm thẻ: Công nợ phải thu 1.125.400.000 đ; Nợ quá hạn 421.240.000 đ (2 khách đang tạm khóa); Quá hạn trên 90 ngày 60.720.000 đ (1 khoản chờ ghi kết quả GĐ / KTT); Chờ thu trước SX / giao 1.933.200.000 đ; Chờ hoàn cho khách 12.000.000 đ. Chân bảng "10 khách · 2 tạm khóa · tuổi nợ tính đến 18/10/2026". Hai nút trang: "Ghi nhận hoàn tiền", "Ghi nhận tiền về". |
| 2 | Khách tạm khóa | Chọn KH-0012 (Công ty TNHH Phân phối An Khang) | Chip "Tạm khóa do nợ quá hạn" (tạm khóa là dấu chặn đơn Mua nợ mới và chặn giao đơn Mua nợ). Banner "Tạm khóa từ 15/10/2026… Đã nhắc Sales, Kế toán 17/10, nhắc lại 24/10." và banner "ĐH-2610-0034 (1.344.600.000 đ, Mua nợ) đang chờ kiểm công nợ — vướng nợ quá hạn; dư nợ cộng đơn này cũng vượt hạn mức (2.626.900.000 đ > 1.500.000.000 đ)." |
| 3 | `hopthoai` = `hoan-tien` | Điền sẵn, lưu; rồi xóa ảnh và xóa ngày thử lại | Điền sẵn khoản KH-0058 · ĐH-2609-0029 · 12.000.000 đ (số tiền hoàn chỉ đọc), ngày chi 18/10/2026, Chuyển khoản, ảnh unc-hoan-taman-18-10.pdf; banner "Hủy đơn đã chốt 14/10 — Giám đốc Lê Quang Minh quyết hoàn 12.000.000 đ / cọc 24.000.000 đ". Thiếu ảnh: "Bắt buộc ảnh chứng từ chuyển / chi tiền."; thiếu ngày: "Nhập ngày dạng dd/mm/yyyy." Lưu: "TC-2610-0016: đã ghi nhận hoàn 12.000.000 đ cho KH-0058 (ĐH-2609-0029)."; thẻ Chờ hoàn cho khách về 0 đ ("không có") và nút "Ghi nhận hoàn tiền" ở đầu trang biến mất. |
| 4 | `hopthoai` = `ket-qua-90` | Điền sẵn, lưu; rồi xóa kết quả và biên bản thử lại | Khoản KH-0060 · ĐH-2606-0014 · còn 60.720.000 đ, hạn 10/07/2026, quá hạn 100 ngày. Banner "Hệ thống không xóa nợ: dư nợ, nợ quá hạn và cờ tạm khóa giữ nguyên sau khi ghi kết quả." Thiếu: "Ghi kết quả GĐ / KTT đã quyết." và "Đính kèm biên bản / quyết định." Lưu: "ĐH-2606-0014: đã ghi kết quả xử lý nợ quá 90 ngày. Dư nợ giữ nguyên — hệ thống không xóa nợ." Thẻ đổi sang "đã ghi kết quả" nhưng số 60.720.000 đ và Nợ quá hạn 421.240.000 đ không đổi; chọn KH-0060 thấy banner "ĐH-2606-0014: đã ghi kết quả nợ quá 90 ngày 18/10/2026 — Giám đốc Lê Quang Minh quyết…". |
| 5 | `hopthoai` = `lien-he` | `vaitro` = `Sales`; rồi `Kế toán` | `Sales`: hộp thoại "Ghi lần liên hệ nhắc nợ" về khoản ĐH-2609-0018 (KH-0012, quá hạn 4 ngày, còn 337.840.000 đ), chọn "Liên hệ được" hoặc "Không liên hệ được", ghi chú không bắt buộc; lưu: "Đã ghi lần liên hệ nhắc nợ ĐH-2609-0018." và thêm dòng nhật ký "Liên hệ nhắc nợ ĐH-2609-0018: liên hệ được". `Kế toán`: hộp thoại không mở. Nút "Ghi liên hệ" chỉ hiện cho `Sales` ở khoản quá hạn. |
| 6 | `hopthoai` = `tien-ve` | `Kế toán`, `cnkh` | Mở "Ghi nhận tiền về" điền sẵn KH-0012, 337.840.000 đ (kiểm chi tiết ở board 39). Lưu: "TC-2610-0016: ghi nhận 337.840.000 đ của KH-0012, cấn 1 khoản. Hết nợ quá hạn — đã tắt cờ tạm khóa." Thẻ: Công nợ phải thu 787.560.000 đ, Nợ quá hạn 83.400.000 đ (1 khách tạm khóa). |
| 7 | Các hộp thoại khác | `hopthoai` = `tra-ncc`, `giam-tru`, `huy` khi `screen` = `cnkh` | Không mở gì, vì ba hộp thoại này chỉ mở ở `cnncc` (hai hộp đầu) và `so` (hộp cuối). Đổi `screen` mới thấy, kiểm tiếp ở board 37, 38, 40. |
| 8 | `Kế toán trưởng` | `vaitro` = `Kế toán trưởng`, `hopthoai` = `tien-ve` | Số liệu như `Kế toán` nhưng không có nút ghi nhận, hộp thoại không mở, hiện "Việc của Kế toán · ghi nhận tiền về / hoàn tiền". |
| 9 | `Sales`, `Mua hàng`, `Giám đốc` | Lần lượt đổi `vaitro`, thử cả `screen` = `cnncc` | `Sales`: luôn ở công nợ khách (đổi `screen` sang `cnncc` hay `so` vẫn hiện `cnkh`), chú thích "Bạn xem công nợ khách hàng và ghi lần liên hệ nhắc nợ." `Giám đốc`: xem được cả 3 màn, không có nút. `Mua hàng`: "Vai trò Mua hàng không có quyền vào màn này." |

#### 37 · Kế toán — Công nợ NCC
Mở board này để kiểm: số tiền phải trả NCC, PO trả trước, phiếu trả hàng chờ giảm trừ, và hai hộp thoại trả NCC và giảm trừ.
Ô chỉnh trong "Trạng thái hiển thị": `screen` mặc định `cnncc`; `vaitro` → `Kế toán` (ghi nhận), `Kế toán trưởng`, `Giám đốc` (chỉ xem), `Sales` (bị đưa về công nợ khách), `Mua hàng` (bị chặn); `hopthoai` → `khong` (mặc định), `tra-ncc`, `giam-tru`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở mặc định | `vaitro` = `Kế toán` | Thẻ: Còn phải trả NCC 823.250.000 đ (5 PO trả sau đã nhận hàng); Đến hạn trong 7 ngày 627.250.000 đ (2 PO); Quá hạn trả 152.000.000 đ; Trả trước chờ ghi nhận 2 PO; Giảm trừ chưa ghi được 2 phiếu. Chân bảng "5 PO còn phải trả · tổng 823.250.000 đ". Nút trang "Ghi nhận đã trả NCC". |
| 2 | Bảng khoản phải trả | Đọc từng dòng theo NCC | PO-2607-0009 370.000.000 đ hạn 18/10/2026 "Đến hạn hôm nay". PO-2609-0004 64.000.000 đ "Quá hạn 3 ngày". PO-2609-0010 88.000.000 đ "Quá hạn 6 ngày", ghi "tạm giữ: NCR lô L-BOT-32 chờ NCC bồi hoàn". PO-2609-0009 phải trả 267.050.000 đ, giảm trừ 9.800.000 đ, còn 257.250.000 đ hạn 25/10/2026 "Còn 7 ngày". PO-2610-0015 44.000.000 đ "Chưa đến hạn" kèm "2 phiếu trả chưa ghi". PO-2609-0007 "Đã trả đủ" (147.000.000 đ). PO-2610-0016, 0017, 0018 "Chưa nhận hàng", không có nút. |
| 3 | PO trả trước | Đọc bảng PO trả trước | PO-2609-0008 84.000.000 đ "Đã trả đủ" (TC-2609-0004 · 22/09). PO-2610-0022 86.500.000 đ "Chờ ghi nhận trả trước", nút "Ghi nhận trả" bấm được. PO-2610-0023 185.000.000 đ "Chờ PO duyệt" ("Trưởng BP Mua hàng chưa duyệt"), nút bị tắt. |
| 4 | Bảng phiếu trả hàng | Đọc bảng | TH-NCC-2610-0003 (475 kg) dự kiến 41.800.000 đ "Chờ kho xuất trả", nút "Xem". TH-NCC-2610-0001 dự kiến 2.200.000 đ "Chờ ghi giảm trừ", nút "Ghi nhận giảm trừ". TH-NCC-2609-0004 9.800.000 đ "Đã ghi giảm trừ" (Ngô Bảo Ngọc · 16/10 15:20). TH-NCC-2609-0003 dự kiến 4.900.000 đ "Chưa ghi được" ("NCC chưa chấp nhận" / chờ đo ẩm). |
| 5 | `hopthoai` = `giam-tru`: điền sẵn, lưu | Lưu thẳng; rồi thử số tiền 999.000.000 và để trống | Điền sẵn TH-NCC-2610-0001 · Đã xuất trả, PO-2610-0015, đơn giá 88.000 đ/kg, số tiền 2.200.000 (25 kg × 88.000). Lưu: "TH-NCC-2610-0001: ghi nhận giảm trừ 2.200.000 đ vào khoản phải trả PO-2610-0015. Chờ Mua hàng ký xác nhận để hoàn tất phiếu trả." Còn phải trả NCC thành 821.050.000 đ. Vượt: "Lớn hơn số còn phải trả của PO (44.000.000 đ)." Trống: "Nhập số tiền giảm trừ." |
| 6 | Phiếu chưa xuất trả thì không ghi được | Bấm "Xem" ở TH-NCC-2610-0003 (hoặc mở lại hộp thoại sau case 5) | Banner "Phiếu trả đang "Chờ kho xuất trả" — chỉ ghi giảm trừ sau khi kho xuất trả xong."; nút Lưu bị tắt, nút còn lại đổi thành "Đóng". Số tiền chỉ đọc (41.800.000). |
| 7 | `hopthoai` = `tra-ncc` | Điền sẵn, lưu (kiểm chi tiết ở board 40) | PO-2607-0009 370.000.000 đ; lưu ra "TC-2610-0016: ghi nhận đã trả 370.000.000 đ cho NCC-0002 (PO-2607-0009) — PO đã trả đủ." |
| 8 | Vai trò | `Kế toán trưởng`, `Giám đốc`; `Sales`; `Mua hàng` | `Kế toán trưởng`, `Giám đốc`: số liệu giống, không có nút, hộp thoại không mở, hiện "Việc của Kế toán · ghi nhận đã trả NCC, giảm trừ". `Sales`: tự chuyển sang công nợ khách. `Mua hàng`: "Vai trò Mua hàng không có quyền vào màn này." |

#### 38 · Kế toán — Sổ thu chi
Mở board này để kiểm: bảng sổ, bộ lọc, hủy bản ghi nhập sai (bản ghi chỉ chuyển Đã hủy, không xóa).
Ô chỉnh trong "Trạng thái hiển thị": `screen` mặc định `so`; `vaitro` → `Kế toán` (hủy được), `Kế toán trưởng`, `Giám đốc` (chỉ xem), `Sales`, `Mua hàng`; `hopthoai` → `khong` (mặc định), `huy` (mở sẵn hủy TC-2610-0013), các giá trị khác không mở ở màn này.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở mặc định | `vaitro` = `Kế toán` | 21 bản ghi, trang 1–10 / 21. Thẻ: Tổng thu (tiền về) 807.196.000 đ (15 bản ghi); Hoàn tiền khách 29.200.000 đ (2 bản ghi); Trả nhà cung cấp 231.000.000 đ (2 bản ghi); Bản ghi đã hủy 2. Chân bảng "21 / 21 bản ghi · từ 01/08 đến 18/10/2026". Dòng đầu là TC-2610-0015 (KH-0031, 40.824.000 đ, Chuyển khoản). |
| 2 | Bộ lọc và tìm | Trạng thái `Đã hủy`; Mục đích `Trả NCC`; gõ `ĐH-2610-0030` | Đã hủy: 2 bản ghi (TC-2609-0003, TC-2610-0004). Trả NCC: 3 bản ghi (TC-2609-0003 đã hủy, TC-2609-0004, TC-2610-0010). Tìm `ĐH-2610-0030`: 3 bản ghi (TC-2610-0003, TC-2610-0004 đã hủy, TC-2610-0011). |
| 3 | Bản ghi đã hủy khóa sửa | Nhìn TC-2610-0004 và TC-2609-0003 | Không có nút "Hủy" ở dòng đã hủy; ghi lý do và giờ hủy, ví dụ "11/10 15:20 · Nhập trùng TC-2610-0003 — cùng một lần chuyển khoản". Mở chi tiết TC-2609-0003: chip "Đã hủy", không có nút "Hủy bản ghi", nhật ký có "Hủy bản ghi · Ghi nhận khi ủy nhiệm chi chưa được ngân hàng duyệt — ghi lại TC-2609-0004 khi tiền đã đi". |
| 4 | `hopthoai` = `huy`: thiếu lý do | Bấm "Hủy bản ghi" khi chưa nhập lý do | Hộp thoại "Hủy bản ghi nhập sai" cho TC-2610-0013 · Tiền về của khách · 30.000.000 đ; banner "Hủy sẽ gỡ 1 khoản đã cấn (Cọc ĐH-2610-0036 30.000.000 đ). Dư nợ, nợ quá hạn, cờ tạm khóa tính lại ngay." Báo "Bắt buộc lý do hủy." |
| 5 | `huy` thành công | Nhập lý do "Nhập trùng", lưu | "TC-2610-0013: đã hủy (Nhập trùng). Đã gỡ 1 khoản cấn — dư nợ, nợ quá hạn tính lại." Tổng thu còn 777.196.000 đ (14 bản ghi), Bản ghi đã hủy 3. |
| 6 | Hủy bản ghi trả NCC | Bấm "Hủy" ở TC-2610-0010 | Banner "Hủy sẽ cộng lại 147.000.000 đ vào khoản phải trả PO-2609-0007."; lưu có lý do: "TC-2610-0010: đã hủy (…). Khoản phải trả PO-2609-0007 tính lại." |
| 7 | Ghi nhận ở màn khác rồi sang sổ | Ở menu trái của cùng board ghi nhận tiền về (case 6 của board 36), rồi bấm Sổ thu chi | Có thêm bản ghi mới TC-2610-0016 (22 bản ghi); thẻ Tổng thu tăng 337.840.000 đ. Dữ liệu này mất khi tải lại board. |
| 8 | Vai trò | `Kế toán trưởng`, `Giám đốc`; `Sales`; `Mua hàng` | `Kế toán trưởng`, `Giám đốc`: xem, không có nút "Hủy", hiện "Việc của Kế toán · hủy bản ghi nhập sai". `Sales` bị đưa về công nợ khách. `Mua hàng`: "Vai trò Mua hàng không có quyền vào màn này." |

#### 39 · Kế toán — Ghi nhận tiền về (KH-0012)
Mở board này để kiểm: hộp thoại "Ghi nhận tiền về" mở sẵn cho KH-0012, các ô bắt buộc, số tiền, cấn khoản và kết quả sau khi lưu. Cấn khoản nghĩa là chia số tiền khách trả vào từng khoản phải thu.
Ô chỉnh trong "Trạng thái hiển thị": `screen` mặc định `cnkh`; `vaitro` → `Kế toán` (mở được hộp thoại), `Kế toán trưởng`, `Sales`, `Mua hàng`, `Giám đốc` (hộp thoại không mở); `hopthoai` mặc định `tien-ve`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở sẵn | `vaitro` = `Kế toán` | Hộp thoại "Ghi nhận tiền về" có hai tab "Thông tin tiền về" và "Cấn khoản". Khách KH-0012 · Công ty TNHH Phân phối An Khang, số tiền 337.840.000, ngày 18/10/2026, Chuyển khoản, ảnh sao-ke-ankhang-18-10.jpg. Tab Cấn khoản: ĐH-2609-0018 Công nợ sau giao hạn 14/10/2026 "quá hạn 4 ngày" còn 337.840.000 đ, cấn 337.840.000; ĐH-2609-0025 hạn 01/11/2026 còn 272.160.000 đ, để trống. Tổng "Đã cấn hết". Banner "Khách đang tạm khóa. Ghi nhận này trả hết các khoản quá hạn — lưu xong cờ tạm khóa tự tắt." |
| 2 | Thiếu ô bắt buộc | Xóa số tiền; xóa ảnh; bỏ chọn khách | "Nhập số tiền khách trả."; "Bắt buộc ảnh chứng từ (sao kê / ủy nhiệm chi / phiếu nộp tiền)."; "Chọn khách hàng." |
| 3 | Số tiền vượt | Số tiền 700.000.000 | "Lớn hơn tổng còn phải thu (610.000.000 đ). Ghi nhận đúng số cần thu — chưa giữ tiền thừa." (610.000.000 = 337.840.000 + 272.160.000). |
| 4 | Ngày sai | Ngày 25/10/2026; rồi `2026-10-18` | "Không ghi nhận tiền về ở ngày tương lai." và "Nhập ngày dạng dd/mm/yyyy." |
| 5 | Cấn không khớp | Cấn 300.000.000 cho ĐH-2609-0018 trong khi số tiền là 337.840.000; rồi cấn 400.000.000 | Chỉ báo "Còn 37.840.000 đ chưa cấn". Lưu: "Tổng số cấn (300.000.000 đ) phải bằng số tiền ghi nhận (337.840.000 đ)." Cấn 400.000.000: ô báo "Vượt số còn phải thu." và lỗi tổng số cấn. Form tự nhảy sang tab Cấn khoản. |
| 6 | Trả một phần | Số tiền 100.000.000, cấn 100.000.000 vào ĐH-2609-0018, lưu | Banner "Khách đang tạm khóa. Còn khoản quá hạn chưa cấn đủ — cờ tạm khóa giữ nguyên." Lưu: "TC-2610-0016: ghi nhận 100.000.000 đ của KH-0012, cấn 1 khoản." Quá hạn còn 237.840.000 đ; KH-0012 vẫn tạm khóa. |
| 7 | Trả đủ khoản quá hạn | Giữ giá trị mặc định, lưu | "TC-2610-0016: ghi nhận 337.840.000 đ của KH-0012, cấn 1 khoản. Hết nợ quá hạn — đã tắt cờ tạm khóa." KH-0012 hiện "Không tạm khóa"; Nợ quá hạn toàn màn còn 83.400.000 đ. |
| 8 | Thu đủ cọc | Chọn khách KH-0044, số tiền 15.000.000, ảnh bất kỳ, lưu | Hệ thống tự cấn vào cọc ĐH-2610-0033; thông báo thêm "ĐH-2610-0033 đã thu đủ cọc — báo Bán hàng "Đã thu đủ", đơn chuyển Đã chốt." |
| 9 | Vai trò | `Kế toán trưởng`, `Sales`, `Giám đốc`, `Mua hàng` | Hộp thoại không tự mở; `Kế toán trưởng`, `Sales`, `Giám đốc` thấy "Việc của Kế toán · ghi nhận tiền về / hoàn tiền"; `Mua hàng` còn thấy "Vai trò Mua hàng không có quyền vào màn này." |

#### 40 · Kế toán — Ghi nhận đã trả NCC (PO-2607-0009)
Mở board này để kiểm: hộp thoại "Ghi nhận đã trả NCC" mở sẵn cho PO-2607-0009, các ô bắt buộc, số tiền và kết quả sau khi lưu.
Ô chỉnh trong "Trạng thái hiển thị": `screen` mặc định `cnncc`; `vaitro` → `Kế toán` (mở được hộp thoại), `Kế toán trưởng`, `Giám đốc` (không mở), `Sales`, `Mua hàng`; `hopthoai` mặc định `tra-ncc`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở sẵn | `vaitro` = `Kế toán` | PO-2607-0009 (NCC-0002 Lacto Ingredients B.V.), số tiền 370.000.000, ngày 18/10/2026, Chuyển khoản, ảnh unc-lacto-18-10.pdf. Gợi ý "Lacto Ingredients B.V. · phải trả 370.000.000 đ, hạn 18/10/2026"; banner "Khoản phải trả PO-2607-0009: 370.000.000 đ · hạn 18/10/2026 (đến hạn hôm nay)."; có liên kết "Mở PO-2607-0009 ở Mua hàng". Danh sách PO chọn được: PO-2607-0009, 2609-0004, 2609-0010, 2609-0009, 2610-0015, 2610-0022. |
| 2 | Lưu đủ | Giữ mặc định, lưu | "TC-2610-0016: ghi nhận đã trả 370.000.000 đ cho NCC-0002 (PO-2607-0009) — PO đã trả đủ." Thẻ Còn phải trả NCC thành 453.250.000 đ (4 PO), Đến hạn trong 7 ngày 257.250.000 đ (1 PO). |
| 3 | Trả một phần | Số tiền 100.000.000 | "… ghi nhận đã trả 100.000.000 đ cho NCC-0002 (PO-2607-0009) — còn 270.000.000 đ." |
| 4 | Số tiền vượt | Số tiền 999.000.000 | "Lớn hơn số còn phải trả (370.000.000 đ)." |
| 5 | Thiếu ô bắt buộc | Bỏ chọn PO, xóa số tiền, xóa ảnh; rồi ngày 30/10/2026 | "Chọn PO."; "Nhập số tiền đã trả."; "Bắt buộc ảnh chứng từ (ủy nhiệm chi / phiếu chi tiền mặt)."; "Không ghi nhận ở ngày tương lai." |
| 6 | PO có giảm trừ, quá hạn | Chọn PO-2609-0009; rồi PO-2609-0010 | 0009: số tiền tự điền 257.250.000, gợi ý "phải trả 267.050.000 đ, đã giảm trừ 9.800.000 đ, hạn 25/10/2026", banner "còn 7 ngày". 0010: 88.000.000 đ, banner đỏ "(quá hạn 6 ngày)". |
| 7 | PO trả trước | Chọn PO-2610-0022 (NCC-0003), ảnh bất kỳ, lưu | Số tiền tự điền 86.500.000; gợi ý "Southland Milk Co-operative · PO trả trước 86.500.000 đ", không có banner hạn. Lưu: "… ghi nhận đã trả 86.500.000 đ cho NCC-0003 (PO-2610-0022) — PO đã trả đủ." Thẻ Trả trước chờ ghi nhận về "1 PO". |
| 8 | PO không có trong danh sách | Tìm PO-2610-0023, PO-2610-0016, PO-2610-0018 | Không chọn được: PO-2610-0023 trả trước chưa duyệt; ba PO kia chưa nhận hàng. |
| 9 | Vai trò | `Kế toán trưởng`, `Giám đốc`, `Sales`, `Mua hàng` | Hộp thoại không mở; `Kế toán trưởng`, `Giám đốc` thấy "Việc của Kế toán · ghi nhận đã trả NCC, giảm trừ"; `Sales` bị đưa về công nợ khách; `Mua hàng` bị chặn. |

#### Mã mẫu dùng trong phần này (Mua hàng & Kế toán)
| Mã | Là gì | Xuất hiện ở board | Giá trị phải khớp (trạng thái, số lượng, tiền...) |
|---|---|---|---|
| PO-2610-0026 | PO Whey + Bột sữa gầy, NCC-0002 | 31, 31a, 29, 33/34 (PO đang mở của NCC-0002) | Chờ COA & HSD; 2 NVL × 1.000 kg; 269.000.000 đ; giao 01/12/2026; đã gửi yêu cầu COA 18/10 11:05 tới export@lactoingredients.nl |
| PO-2610-0025 | PO Lon thiếc 900 g, NCC-0004 | 31, 31a | Chờ COA & HSD; 1.200 cái × 3.500 đ = 4.200.000 đ; giao 27/10/2026; chưa gửi yêu cầu COA |
| PO-2610-0024 | PO Bột sữa nguyên kem, NCC-0001 | 31, 31a, 34 (nằm trong 4 PO mở khi ngừng dùng NCC-0001) | Chờ COA & HSD; 825 kg × 98.000 đ = 80.850.000 đ; giao 01/11/2026; đã gửi yêu cầu 18/10 08:30 |
| PO-2610-0027 | PO Lon thiếc 800 g, NCC-0004 | 31 | Chờ chọn thanh toán; 6.000 cái × 3.200 đ = 19.200.000 đ; giao 30/10/2026 |
| PO-2610-0023 | PO Whey, NCC-0002, kho NM2-TONG | 31, 31b (khi đã duyệt), 37 | Chờ Giám đốc duyệt; 1.000 kg × 185.000 đ = 185.000.000 đ; Cọc 30% + trả nốt trước giao (cọc 55.500.000 đ, trả nốt 129.500.000 đ). Ở board 37 đang bị ghi là Trả trước (xem chỗ lệch) |
| PO-2610-0022 | PO Bột sữa gầy, NCC-0003, kho NM2-TONG | 31, 31b, 37, 40 | Đã duyệt; 1.000 kg × 86.500 đ = 86.500.000 đ (90.825.000 đ sau thuế 5% trên phiếu PO); Trả trước 100%; giao 05/12/2026 |
| PO-2610-0018 | PO Bột sữa gầy, NCC-0001 | 31, 31b, 37, 35 | Đã gửi NCC; 3.000 kg × 88.000 đ = 264.000.000 đ (277.200.000 đ sau thuế 5%); giao 20/10/2026; phiếu nhập PN-NM1-2610-0031 |
| PO-2610-0017 | PO Lon thiếc 800 g, NCC-0004 | 31, 31b, 37 | Đã gửi NCC; 18.000 cái × 3.200 đ = 57.600.000 đ (63.360.000 đ sau thuế 10%); giao 22/10/2026 |
| PO-2610-0020 / 0019 | PO chờ Trưởng BP duyệt | 31 | 0020: 2.000 kg × 88.000 đ = 176.000.000 đ (vượt 100 triệu, cần thêm Giám đốc); 0019: 1.000 kg × 92.500 đ = 92.500.000 đ (chỉ Trưởng BP) |
| PO-2609-0009 | PO Bột sữa nguyên kem, NCC-0001, nhận một phần | 31, 35, 37, 40 | Nhận một phần 2.725 / 5.000 kg × 98.000 đ; giá trị PO 490.000.000 đ; phải trả đến nay 267.050.000 đ, đã giảm trừ 9.800.000 đ, còn 257.250.000 đ hạn 25/10/2026 |
| PO-2607-0009 | PO Whey, NCC-0002, đã nhận đủ | 37, 40 | 2.000 kg × 185.000 đ = 370.000.000 đ; hạn trả 18/10/2026 (đến hạn hôm nay) |
| NCC-0005 / NCC-0006 | NCC chờ duyệt | 33, 34, 29 | NCC-0005 hồ sơ đủ, NVL đề xuất NVL-PGA-0001, NVL-PGA-0004; NCC-0006 thiếu chứng nhận ATTP / ISO / FSSC, không duyệt được |
| NCC-0001 | NCC Phương Nam | 33, 34, 35, 37 | Đã duyệt; 9 dòng lịch sử (7 trả hàng, 1 giao thiếu, 1 giao trễ); Trả sau 30 ngày |
| NCC-0002 | NCC Lacto | 31, 33, 34, 37 | Đã duyệt; Cọc 30% + trả nốt trước giao (ở board 37 đang ghi Trả sau 60 ngày, xem chỗ lệch) |
| TH-NCC-2610-0001 | Phiếu trả 25 kg lô L-BOT-22, Giảm công nợ | 35, 34 (lịch sử NCC-0001), 37 | Đã xuất trả (PX-NM1-2610-0040); giảm trừ dự kiến 2.200.000 đ (25 kg × 88.000 đ); Kế toán chưa ghi |
| TH-NCC-2610-0003 | Phiếu trả 475 kg lô L-BOT-22 (QC-NM1-2610-0044) | 35, 37 | Chờ kho xuất trả (PX-NM1-2610-0046, đã lấy 250/475 kg); dự kiến 41.800.000 đ |
| TH-NCC-2609-0004 | Phiếu trả 100 kg lô L-BOT-33 | 35, 37 | Chờ ký xác nhận; Kế toán đã ghi giảm trừ 9.800.000 đ ngày 16/10 15:20 |
| TH-NCC-2610-0006 | Phiếu trả 25 kg lô L-BOT-33, Đổi 1-1 | 35 | Chờ duyệt xuất trả; người gửi Mai Anh Thư |
| KH-0012 | Công ty TNHH Phân phối An Khang | 36, 39 | Tạm khóa; quá hạn 337.840.000 đ (ĐH-2609-0018, 4 ngày); công nợ hiện tại 610.000.000 đ; hạn mức 1.500.000.000 đ |
| KH-0060 | Cửa hàng Mẹ & Bé Thanh Sơn | 36 | ĐH-2606-0014 còn 60.720.000 đ, quá hạn 100 ngày |
| TC-2610-0013 | Bản ghi tiền về 30.000.000 đ (KH-0058) | 38 | Đã ghi nhận, cấn vào cọc ĐH-2610-0036; hủy được với lý do |
| TC-2610-0016 | Bản ghi mới sinh khi lưu ở bất kỳ hộp thoại nào | 36 đến 40 | Số mới nhất sau TC-2610-0015 |

### 4.4. Kho

Phân hệ Kho kiểm các luồng: tồn kho theo lô và kho kèm xử lý sự cố tem (board 41), nhập kho (42, 43, 44), xuất kho (45, 45b, 46, 47, 48), chuyển kho (49, 49a, 49b), kiểm kho (50, 50b, 50c) và hủy hàng (51). Board 42 là màn gốc của cả năm màn nhập, xuất, chuyển, kiểm kê, hủy; các board 43 đến 51 mở lại đúng màn đó ở một tình huống cố định.

Cách đọc chữ viết tắt trong phần này: NCC là nhà cung cấp; PO là đơn mua; NSX và HSD là ngày sản xuất và hạn sử dụng; QC là bộ phận kiểm tra chất lượng; LSX là lệnh sản xuất; ĐH là đơn hàng; BTP là bán thành phẩm; NCR là phiếu báo lỗi hàng do Kế hoạch lập; FEFO là cách chọn lô hết hạn sớm nhất để xuất trước. Hàng tính bằng kg đóng bao 25 kg; thành phẩm tính bằng lon đóng thùng 24 lon; lon rỗng tính bằng cái đóng kiện 1.200 cái.

Hai việc làm chung cho mọi board Kho, nhắc một lần ở đây:
- Thanh trên cùng của board có ô "Xem như" (đổi vai trò), nút chọn "Máy chủ NM1" hoặc "Cloud" (chạy tại máy chủ nhà máy hay xem bản đồng bộ trên máy chủ trung tâm) và một nút trạng thái kết nối (bấm để đổi trực tuyến, ngoại tuyến). Board 41 và 42 có sẵn ô `noi` và `ketNoi` trong panel; các board còn lại phải bấm các nút này ngay trong board.
- Vai trò không có quyền vào màn thì thấy câu "Vai trò <tên> không có quyền vào màn này." kèm nút về Việc cần làm. Vai trò có vào màn nhưng không có quyền làm một việc thì thấy dòng "Việc của <vai trò> · <tên nút>" kèm nút "Xem như <vai trò>" thay cho nút đó. Hai trường hợp này gọi chung là "bị chặn" trong các bảng dưới.
  - Tồn kho: `QC` bị chặn cả màn.
  - Nhập kho: `Sales`, `QC` bị chặn cả màn.
  - Xuất kho: `Kế toán`, `QC` bị chặn cả màn.
  - Chuyển kho: `Mua hàng`, `Sales`, `QC`, `Kế toán` bị chặn cả màn.
  - Kiểm kho: `Kế hoạch`, `Mua hàng`, `Sales`, `QC`, `Kế toán` bị chặn cả màn.
  - Hủy hàng: chỉ `Mua hàng` bị chặn cả màn.

#### 41 · Tồn kho (lô × kho, trạng thái theo bao, sự cố tem)
Mở board này để kiểm: bảng tồn theo lô và kho khớp với các phiếu Kho, và panel "Sự cố tem" (tem hỏng, tem mất, hủy tem) cho từng loại sự cố.
Ô chỉnh trong "Trạng thái hiển thị": `suCoTem` → `Ẩn` / `Chọn loại sự cố` / `Tem hỏng — in lại` / `Tem mất — cấp mã mới` / `Hủy tem`; `vaitro` → `Thủ kho` / `Thủ kho điều phối` / `Thủ kho trưởng` / `Kế hoạch` / `Sales` / `Mua hàng` / `QC`; `noi` → `nm` / `cloud`; `ketNoi` → `Trực tuyến` / `Ngoại tuyến`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Tem mất (mặc định) | Để `suCoTem` = `Tem mất — cấp mã mới`, `vaitro` = `Thủ kho`. Bấm "Quét tem mới bằng đầu đọc". | Tiêu đề "Sự cố tem · A-BAO-000233", trạng thái bao "Chờ kiểm". Các bước đều có dấu tích: lấy lô L-BOT-01 tại NM1-TONG, khóa mã cũ A-BAO-000233, cấp mã mới A-BAO-000412 cùng lô mang trạng thái Chờ kiểm. Sau khi bấm quét có thông báo "Đã quét A-BAO-000412 — khớp lô L-BOT-01, kích hoạt mã (trạng thái Chờ kiểm như bao cũ); mã cũ A-BAO-000233 đã khóa." |
| 2 | Tem hỏng | Đổi `suCoTem` = `Tem hỏng — in lại`, rồi bấm quét. | Mã không đổi: A-BAO-000231, dòng "Lần in thứ 2 của mã này.". Thông báo "Đã quét A-BAO-000231 — khớp lô L-BOT-01, kích hoạt mã." (không có câu "mã cũ đã khóa"). |
| 3 | Hủy tem, bao còn / hết | Đổi `suCoTem` = `Hủy tem`. Ở ô "Bao còn trong kho?" chọn "Còn — cần tem mới", sau đó chọn "Không — chỉ khóa mã, thu tem". | Chọn "Còn": thêm bước cấp mã mới A-BAO-000412 cùng lô, mang trạng thái Chờ kiểm, và có nút quét. Chọn "Không": chỉ khóa mã, thu tem vật lý bỏ vào hộp tem hủy, nút quét biến mất. |
| 4 | Chưa chọn loại / ẩn panel | Đổi `suCoTem` = `Chọn loại sự cố`, rồi `Ẩn`. | `Chọn loại sự cố`: ba thẻ lựa chọn và dòng nhắc "Khóa mã tem không đổi trạng thái bao — mã mới mang trạng thái và lý do khóa của bao cũ.". `Ẩn`: không có panel Sự cố tem. |
| 5 | Vai trò xử lý tem | Đổi `vaitro` lần lượt qua `Thủ kho điều phối`, `Thủ kho trưởng`, `Kế hoạch`, `Sales`, `Mua hàng`, `QC` (giữ `suCoTem` = `Tem mất — cấp mã mới`). | `Thủ kho` và `Thủ kho điều phối` thấy giống nhau, có nút quét. `Thủ kho trưởng`, `Kế hoạch`, `Sales`, `Mua hàng`: bị chặn, thấy "Việc của Thủ kho · sự cố tem do thủ kho xử lý" và không có nút quét. `QC`: bị chặn cả màn. |
| 6 | Nút trên từng dòng tồn | Với `vaitro` = `Thủ kho`, rồi `Kế hoạch`, rồi `Sales`, xem các nút "Gửi QC" và "Hủy hàng" ở dòng lô. | `Thủ kho`: có cả hai nút (chỉ ở dòng không đang chuyển, không có cờ "Đang kiểm kê"). `Kế hoạch`: có "Gửi QC", thiếu "Hủy hàng" và có dòng chặn "Việc của Thủ kho · tạo phiếu hủy trên dòng tồn". `Sales`: bị chặn cả hai. |
| 7 | Tồn khớp với phiếu | Tìm lô L-BOT-01 tại NM1-TONG. Bật công tắc hiện hàng đang chuyển. | Ba phần: 900 kg "Chờ kiểm" (gửi QC YC-NM1-2610-0022); 25 kg "Khóa" lý do "Chờ hủy · PH-NM1-2610-0013"; 300 kg đang chuyển theo PC-NM1-2610-0009 (trạng thái Chờ kiểm). Khớp với phiếu hủy PH-NM1-2610-0013 (25 kg) và phiếu chuyển PC-NM1-2610-0009 (300 kg). Lô A260928 (480 lon, NM1-BTP) có cờ "Đang kiểm kê", khớp phiếu kiểm PK-NM1-2610-0005. |
| 8 | Xem bản trên cloud | Đổi `noi` = `cloud`. | Dòng xanh "Bản đồng bộ trên cloud — chỉ xem, tồn NM1 tính đến <giờ> (đồng bộ liên tục). Gửi QC, tạo phiếu hủy, sự cố tem làm tại máy chủ nhà máy." Mất nút "Gửi QC", "Hủy hàng" và các nút quét tem. |
| 9 | Nhà máy mất mạng | Đổi `ketNoi` = `Ngoại tuyến` (với `noi` = `nm`). Bấm quét tem ở tình huống 1. | Dòng vàng "Máy chủ nhà máy NM1 mất kết nối cloud từ 08:12 — Tồn kho vẫn chạy đủ tại nhà máy, không giới hạn thời gian. 3 thao tác chờ gửi lên cloud.". Sau khi quét thông báo thêm "Đã ghi tại máy chủ NM1, chờ gửi lên cloud." và số thao tác chờ gửi tăng lên 4. Bấm nút kết nối để có mạng lại: "Có lại kết nối NM1 — đã gửi 4 thao tác lên cloud.". |
| 10 | Cloud khi nhà máy mất mạng | Đổi `noi` = `cloud` và `ketNoi` = `Ngoại tuyến`. | Câu "tồn NM1 tính đến 18/10 08:12 — nhà máy NM1 mất kết nối, số liệu có thể đã đổi tại nhà máy". Vẫn chỉ xem. |

#### 42 · Nhập kho — danh sách (màn gốc của cả năm màn Kho)
Mở board này để kiểm: danh sách và các tab trạng thái của từng màn Kho, quyền theo vai trò, các mã phiếu mẫu (ô `ma`) và trạng thái mất mạng.
Ô chỉnh trong "Trạng thái hiển thị": `screen` → `nhap` / `xuat` / `chuyen` / `kiem-ke` / `huy`; `start` → `danh-sach` / `tao-moi` / `xem`; `vaitro` → `Thủ kho` / `Thủ kho điều phối` / `Thủ kho trưởng` / `Kế hoạch` / `Sales` / `Mua hàng` / `QC` / `Kế toán`; `xem` → `yeu-cau` / `phieu` (chỉ có tác dụng khi `screen` = `chuyen`); `nhamay` → `NM1` / `NM2` (chỉ có tác dụng khi `screen` = `chuyen`, `xem` = `yeu-cau` và `vaitro` = `Kế hoạch`); `noi` → `nm` / `cloud`; `ketNoi` → `Trực tuyến` / `Ngoại tuyến`; `ma` → 12 lựa chọn, thử từng mã ở bảng sau (chỉ có tác dụng khi `start` = `xem`).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Nhập kho | `screen` = `nhap`, `start` = `danh-sach`. | 17 phiếu. Các tab: Chờ nhận hàng 3, Đang nhận 1, Chờ xác nhận lệch 2, Đã nhập 9, Đã hủy 2. Bộ lọc "Loại nhập" và "Kho". Nút "+ Nhận hàng mua (quét PO)". |
| 2 | Xuất kho | `screen` = `xuat`. | 17 phiếu. Tab: Chờ lấy hàng 2, Đang lấy hàng 1, Chờ bên yêu cầu 1, Đã xuất 11, Xuất một phần 1, Đã hủy 1. Khối "Yêu cầu xuất chờ lập phiếu" có một dòng TH-NCC-2610-0004. |
| 3 | Chuyển kho | `screen` = `chuyen`. Thử `xem` = `yeu-cau`, rồi `phieu`. | Ba tab: "Yêu cầu chuyển liên nhà máy" (12 chờ lập phiếu), "Phiếu chuyển liên nhà máy" (10), "Phiếu chuyển nội bộ" (5). `yeu-cau` mở tab thứ nhất; `phieu` mở tab thứ hai. |
| 4 | Kiểm kho | `screen` = `kiem-ke`. | 7 phiếu. Tab: Đang kiểm 3, Chờ duyệt điều chỉnh 1, Đã điều chỉnh 2, Khớp 1. Nút "+ Ra lệnh kiểm kho" chỉ `Thủ kho trưởng` có. |
| 5 | Hủy hàng | `screen` = `huy`. | 11 phiếu. Tab: Chờ xác nhận 3, Đã xác nhận 3, Đã hủy 4, Từ chối 1. Nút "+ Tạo phiếu hủy" chỉ `Thủ kho` và `Thủ kho điều phối` có. |
| 6 | Vai trò bị chặn cả màn | Giữ `screen` = `nhap`, đổi `vaitro` = `Sales`, rồi `QC`. Lặp với `chuyen` và `kiem-ke`. | Câu "Vai trò Sales không có quyền vào màn này." Nhập kho chặn `Sales`, `QC`; chuyển kho chặn `Mua hàng`, `Sales`, `QC`, `Kế toán`; kiểm kho chặn thêm `Kế hoạch`. |
| 7 | Mở sẵn hộp thoại tạo, sai vai trò | `screen` = `nhap`, `start` = `tao-moi`, `vaitro` = `Kế hoạch`. Bấm "Lưu phiếu". | Hộp thoại "Nhận hàng mua — quét PO". Lưu báo "Vai trò Kế hoạch không lập được phiếu này — việc của Thủ kho." Với `Thủ kho` bấm lưu để trống thì báo "Bắt buộc." ở các ô bắt buộc. `screen` = `chuyen` với `start` = `tao-moi` không mở hộp thoại nào. |
| 8 | Mã phiếu có tiền tố nhà máy | Ở nhập kho, tạo phiếu bằng `Thủ kho` (quét PO, tải một tệp chứng từ, lưu). Ở hủy hàng, `Thủ kho`, tạo phiếu hủy. | Mã mới có dạng PN-NM1-2610-0034 và PH-NM1-2610-0019 (có "NM1"). Mọi mã trong danh sách đều có tiền tố nhà máy (PN-NM1-, PN-NM2-, PX-NM1-, PC-NM1-, PC-NM2-, PK-NM1-, PK-NM2-, PH-NM1-). Mã yêu cầu chuyển YCC-2610-xxxx do máy chủ trung tâm cấp nên không có tiền tố. |
| 9 | Nhà máy mất mạng | `ketNoi` = `Ngoại tuyến`, `noi` = `nm`. Ở nhập kho mở PN-NM1-2609-0050 (đã nhập), đổi `vaitro` = `Kế toán`. | Thanh trên: "Máy chủ NM · ngoại tuyến từ 08:12 · 3 thao tác chờ gửi". Nút của Kế toán đổi tên thành "Lưu hóa đơn, chứng từ · Chờ gửi lên". Các nút làm tại kho vẫn dùng được. |
| 10 | Máy chủ nhà máy so với trung tâm | Đổi `noi` = `cloud`, thử `ketNoi` = `Trực tuyến` rồi `Ngoại tuyến`. | `cloud`: chỉ xem, dòng "Bản đồng bộ trên cloud — chỉ xem, tính đến <giờ>" (ngoại tuyến thì "tính đến 18/10 08:12 (NM1 mất kết nối)"). Mất nút tạo và các nút làm tại kho. Còn lại chỉ các nút việc văn phòng: "Lưu hóa đơn, chứng từ" (Kế toán), "Lập phiếu NCR" (Kế hoạch), "Ghi giá trị hàng hủy" (Kế toán). Bấm một nút này khi ngoại tuyến thì thông báo thêm "NM1 ngoại tuyến — lưu trên cloud, nhà máy nhận khi có kết nối." |

Thử từng mã của ô `ma` (đặt `start` = `xem`; mã quyết định màn mở ra, `screen` bị bỏ qua):

| Giá trị `ma` | Phải thấy khi mở |
|---|---|
| `(đầu danh sách)` | Mở phiếu đầu hoặc phiếu mặc định của màn đang chọn: nhập là PN-NM2-2610-0036 (Chờ nhận hàng); xuất là PX-NM1-2610-0050 (Đã xuất); chuyển là PC-NM1-2610-0013 (Đang chuyển); kiểm kê là PK-NM1-2610-0003 (Chờ duyệt điều chỉnh); hủy là PH-NM1-2610-0013 (Chờ xác nhận). |
| `PN-NM1-2610-0031` | Nhập mua từ PO-2610-0018, kho NM1-TONG. Trạng thái Chờ xác nhận lệch. Hai lô S-1290 (40 bao, 1.000 kg) và S-1291 (39 bao, 975 kg), cộng 79 bao đã quét đủ, 1.975 kg; 1 bao 25 kg hỏng trả NCC. |
| `PN-NM1-2610-0030` | Nhập từ sản xuất (BTP), kho NM1-BTP, từ LSX-2610-0009. Chờ xác nhận lệch. Lô B261017: 48 thùng (1.152 lon) đã quét đủ; 2 thùng móp (48 lon) không nhập, chờ NCR. |
| `PX-NM1-2610-0042` | Xuất sản xuất từ NM1-DP cho LSX-2610-0010. Trạng thái Chờ lấy hàng, chưa quét bao nào. Bốn dòng: 1.360 kg, 480 kg, 360 kg, 200 kg, cộng 2.400 kg. |
| `PX-NM1-2610-0044` | Xuất bán, kho NM1-BTP, ĐH-2610-0030 (lần xuất 1/2). Trạng thái Chờ bên yêu cầu. Lô A260928: cần 480 lon, đã lấy 432 lon, thiếu 48 lon; lệch tồn mở phiếu kiểm PK-NM1-2610-0005. |
| `PC-NM1-2610-0013` | Chuyển nội bộ NM1-TONG sang NM1-DP, theo LSX-2610-0014. Đang chuyển. 440 kg: L-BOT-28 416 kg và L-BOT-30 24 kg, chờ NM1-DP quét nhận. |
| `PC-NM1-2610-0009` | Chuyển từ NM1-TONG sang NM2-TONG, Đang chuyển. 300 kg lô L-BOT-01 (12 bao), giờ đến dự kiến 16/10 18:00 nên báo xe trễ 2 ngày. |
| `PC-NM1-2610-0006` | Chuyển từ NM2-BTP sang NM1-BTP, trạng thái Đã nhận. 240 lon lô A260920 (10 thùng), 1 thùng hư 24 lon đã Gửi QC (YC-NM1-2610-0025). |
| `PK-NM1-2610-0003` | Kiểm điểm lô lệch tại NM1-TONG. Lô L-LEC-03: sổ 200 kg, đếm 175 kg, chênh lệch -25 kg. Trạng thái Chờ duyệt điều chỉnh, chờ Nguyễn Văn Tùng duyệt chéo. |
| `PK-NM1-2610-0005` | Kiểm điểm lô A260928 tại NM1-BTP, sổ 480 lon, chưa đếm. Trạng thái Đang kiểm, nguồn là PX-NM1-2610-0044. |
| `PH-NM1-2610-0013` | Hủy hàng lỗi tại NM1-TONG: lô L-BOT-01, 25 kg, "Bao rách, nhiễm ẩm". Hẹn hủy 22/10/2026. Trạng thái Chờ xác nhận. |
| `PH-NM1-2610-0014` | Hủy bột hỏng mẻ (tự động) tại NM1-BTP: lô M261012-02, 420 kg. Hẹn hủy 20/10/2026. Trạng thái Đã xác nhận. |

#### 43 · Nhập kho — chi tiết & xác nhận lệch
Mở board này để kiểm: phiếu nhập PN-NM1-2610-0031 đang chờ xác nhận lệch; việc của Thủ kho trưởng; cách số lô NCC, NSX, HSD do thủ kho nhập theo hàng thực; và đường đi để tạo ra một phiếu lệch.
Ô chỉnh trong "Trạng thái hiển thị": `start` → `danh-sach` / `tao-moi` / `xem`; `vaitro` → `Thủ kho` / `Thủ kho điều phối` / `Thủ kho trưởng` / `Kế hoạch` / `Sales` / `Mua hàng` / `QC` / `Kế toán`; `ma` → các mã ở bảng của board 42.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Màn chi tiết phiếu lệch | Giữ mặc định: `start` = `xem`, `vaitro` = `Thủ kho trưởng`, `ma` = `PN-NM1-2610-0031`. | Hai dòng báo: "Lệch so với dự kiến: 1 bao S-1291 rách trả NCC — nhận 79/80 bao theo hóa đơn — chờ Thủ kho trưởng xác nhận chênh lệch (nhập theo SL thực) hoặc yêu cầu đếm lại." và "Kiểm ngoại quan: 1 kiện hư — phần ổn nhập tiếp." Hai dòng hàng: S-1290 (hạn 05/10/2027, ngày sản xuất 05/10/2026, 40/40 bao, 1.000 kg), S-1291 (06/10/2027, 39/39 bao, 975 kg). Cột "Mã lô nội bộ" ghi "cấp khi nhập xong". Bảng biên bản hàng không đạt: S-1291, "Kiện 40 (chưa dán tem)", 1 bao 25 kg, "Bao rách, lọt bột", ảnh IMG_1709.jpg, liên kết TH-NCC-2610-0004. |
| 2 | Kiểm tệp và hạn dùng | Xem bảng "Kiểm file đánh giá bên ngoài và HSD". | Mỗi lô một dòng "File đánh giá bên ngoài": 1 file, "Có". Mỗi lô một dòng "HSD còn lại khi nhận" yêu cầu "≥ 2/3 hạn dùng (66,7 %)", thực tế khoảng 96 %, kết quả "Đạt". Không có dòng cảnh báo "trước hạn dùng" nào. |
| 3 | Xác nhận chênh lệch | Bấm "Xác nhận chênh lệch". Để trống ô ghi chú rồi xác nhận; sau đó dùng ghi chú gợi ý "Đã kiểm tại chỗ — nhập theo SL thực". | Để trống: lỗi "Bắt buộc.". Có ghi chú: thông báo "PN-NM1-2610-0031 → Đã nhập — tồn NM1-TONG đã cập nhật (L-BOT-37, L-BOT-38).". Trạng thái Đã nhập; sinh hai lô nội bộ L-BOT-37 (1.000 kg) và L-BOT-38 (975 kg) trạng thái Đạt. Dòng báo "Đã nhập — tồn NM1-TONG đã cập nhật theo lô × kho · đã xác nhận chênh lệch: ...". Xuất hiện thêm cảnh báo chờ Kế toán lưu hóa đơn, chứng từ. |
| 4 | Yêu cầu đếm lại | Bấm "Yêu cầu đếm lại". Thử bỏ trống lý do, rồi nhập lý do. | Bỏ trống: "Bắt buộc.". Có lý do: "PN-NM1-2610-0031 về Đang nhận — đếm lại.", trạng thái Đang nhận. |
| 5 | Quyền theo vai trò | Đổi `vaitro` qua `Thủ kho`, `Thủ kho điều phối`, `Kế hoạch`, `Kế toán`, `Mua hàng`, `Sales`. | `Thủ kho`, `Thủ kho điều phối`, `Kế hoạch`, `Kế toán`, `Mua hàng`: thấy dòng chặn "Việc của Thủ kho trưởng · Yêu cầu đếm lại / Xác nhận chênh lệch". `Sales`: bị chặn cả màn. Có nút "In phiếu" ở mọi vai trò. |
| 6 | Phiếu lệch do hàng hư của sản xuất | `ma` = `PN-NM1-2610-0030`. Đổi `vaitro` = `Kế hoạch`. | Dòng đỏ "Chờ Kế hoạch lập phiếu NCR cho 2 kiện hư." Chỉ `Kế hoạch` thấy nút "Lập phiếu NCR". Lập với hướng "Hủy hàng — tạo phiếu hủy" thì có mã NCR-2610-0012 và tạo phiếu hủy PH-NM1-2610-0019 chờ xác nhận. |
| 7 | Từ nhận hàng đến lệch (số lượng) | `start` = `danh-sach`, `vaitro` = `Thủ kho`. Mở PN-NM1-2610-0028 (Đang nhận, lon DA-2610-A, đã quét 6/9 kiện, đã tạo 8 mã). Bấm "Hoàn tất nhận". | Lỗi "Còn 2 tem đã in chưa quét — quét hoặc ghi sự cố tem trước." Bấm "Quét 1 kiện" hai lần, rồi bấm "Tạo mã" (hàng loạt, mặc định 1 mã) và quét thêm một kiện. Khi quét tiếp mà không còn mã đã in: "Không còn tem chưa quét — tạo mã & in tem cho kiện còn lại trước." |
| 8 | Hoàn tất khi còn lệch | Tiếp tục tình huống 7, bấm "Hoàn tất nhận". Để trống ô "Ghi chú lệch", rồi điền. | Lỗi ở ô ghi chú: "Có lệch (… kiện hư) — ghi chú lệch để Thủ kho trưởng xác nhận." (số kiện thiếu thay đổi theo số đã quét). Điền ghi chú: thông báo "PN-NM1-2610-0028 → Chờ xác nhận lệch, đã báo Thủ kho trưởng.". |
| 9 | Thủ kho nhập số lô, ngày theo hàng thực | `start` = `tao-moi`, `vaitro` = `Thủ kho`. Bấm "Quét QR đơn mua". Sửa số lô NCC, NSX, HSD theo nhãn bao. | Phiếu điền sẵn PO-2610-0018, NCC "Công ty TNHH Nguyên liệu Sữa Phương Nam", NVL-BOT-0002, lô gợi ý PNM-260912-03, NSX 12/09/2026, HSD 12/03/2028, 41 kiện, 1.025 kg, kèm câu gợi ý "sửa theo nhãn bao nếu khác". Ghi chú dưới dòng: "HSD còn 93% hạn dùng — đạt." Số lô NCC, NSX, HSD là ô nhập tay, mã lô nội bộ L-... chỉ cấp khi nhập xong. |
| 10 | Chặn khi lưu phiếu | Ở tình huống 9, thử: (a) lưu khi chưa tải tệp chứng từ; (b) đặt HSD trước hoặc bằng NSX; (c) NSX 01/01/2026 và HSD 01/01/2027; (d) số kiện hoặc khối lượng bằng 0. | (a) "Thiếu file chứng từ — tải ≥ 1 file; NCC không có thì không nhận lô này (xóa dòng), NCC chở về."; (b) "HSD phải sau NSX."; (c) "HSD còn dưới 2/3 hạn dùng — không nhập lô này: xóa dòng, báo Mua hàng trả NCC."; (d) "Số kiện > 0." hoặc "Khối lượng > 0.". Lưu thành công: "Đã tạo PN-NM1-2610-0034.", phiếu ở trạng thái Đang nhận. |

#### 44 · Phiếu nhập kho — bản in A4 (PN-NM1-2610-0031)
Mở board này để kiểm: bản in của phiếu PN-NM1-2610-0031 khớp phiếu gốc ở board 42 và 43, và từng lựa chọn của ô `trangthai`.
Ô chỉnh trong "Trạng thái hiển thị": `trangthai` → `Chờ xác nhận lệch` / `Đã hoàn tất` / `Bản sao in lại` (mặc định `Đã hoàn tất`).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Đã hoàn tất | `trangthai` = `Đã hoàn tất`. | Số PN-NM1-2610-0031, ngày 17 tháng 10 năm 2026. Dòng chân trang "Trạng thái: Đã hoàn tất · Trang 1/1". Không có dấu "BẢN SAO". |
| 2 | Chờ xác nhận lệch | `trangthai` = `Chờ xác nhận lệch`. | Chân trang "Trạng thái: Chờ xác nhận lệch · Trang 1/1". Các số liệu hàng vẫn in đủ như tình huống 1 (xem mục lệch ở cuối phần này). |
| 3 | Bản sao in lại | `trangthai` = `Bản sao in lại`. | Dấu chìm "BẢN SAO"; chân trang "Trạng thái: Đã hoàn tất (bản sao)"; thêm dòng "In lại ngày 24/10/2026 bởi Lê Văn Hải (Thủ kho) · từ hồ sơ phiếu trên MES". |
| 4 | Khớp phần đầu phiếu | So với board 43 (`ma` = `PN-NM1-2610-0031`). | Loại nhập "Nhập mua hàng" (bản gốc: Mua hàng); NCC Công ty TNHH Nguyên liệu Sữa Phương Nam; chứng từ "Đơn mua PO-2610-0018 · Hóa đơn HĐ 0004512"; kho "NM1-TONG · Kho tổng NM1". Ô người giao hàng để chỗ trống mẫu "[NGƯỜI GIAO HÀNG]". |
| 5 | Khớp dòng hàng | So với bảng dòng hàng ở board 43. | Dòng 1: NVL-BOT-0002, S-1290, NSX 05/10/2026, HSD 05/10/2027, chứng từ 1.000, thực nhập 1.000 (40 bao × 25 kg). Dòng 2: S-1291, NSX 06/10/2026, HSD 06/10/2027, chứng từ 1.000, thực nhập 975 (39 bao × 25 kg, 1 bao rách trả NCC). Dòng cộng: chứng từ 2.000, thực nhập 1.975; chữ "Một nghìn chín trăm bảy mươi lăm kilôgam." |
| 6 | Khớp hàng hư và chữ ký | Xem phần ghi chú kiểm đếm và chữ ký. | "Lô S-1291: 1 bao 25 kg rách, lọt bột → để riêng chờ NCC chở về, không nhập tồn · phiếu trả NCC TH-NCC-2610-0004", khớp bảng biên bản ở board 43. Người lập và Thủ kho: Lê Văn Hải; Thủ kho trưởng: Trần Thị Mai; "Số chứng từ gốc kèm theo: 3". |

#### 45 · Xuất kho — danh sách
Mở board này để kiểm: danh sách phiếu xuất, các tab trạng thái, cột "Lô xuất" (lô do hệ thống đề xuất), khối yêu cầu xuất trả NCC chờ lập phiếu và quyền theo vai trò.
Ô chỉnh trong "Trạng thái hiển thị": `start` → `danh-sach` / `tao-moi` / `xem`; `vaitro` → `Thủ kho` / `Thủ kho điều phối` / `Thủ kho trưởng` / `Kế hoạch` / `Sales` / `Mua hàng` / `QC` / `Kế toán`; `ma` → các mã ở bảng của board 42 (chỉ có tác dụng khi `start` = `xem`).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Danh sách và tab | Giữ mặc định (`vaitro` = `Thủ kho trưởng`, `start` = `danh-sach`). Bấm lần lượt từng tab. | 17 phiếu. Chờ lấy hàng 2 (PX-NM1-2610-0042 và PX-NM1-2610-0043); Đang lấy hàng 1 (PX-NM1-2610-0046); Chờ bên yêu cầu 1 (PX-NM1-2610-0044); Đã xuất 11; Xuất một phần 1 (PX-NM1-2610-0047); Đã hủy 1 (PX-NM1-2610-0048). |
| 2 | Hệ thống đề xuất lô | Xem cột "Lô xuất" của PX-NM1-2610-0042, PX-NM1-2610-0044, PX-NM1-2610-0046. | PX-0042: lô L-BOT-26, L-BOT-24, L-WHE-04, HH-261015, ghi chú nhỏ "FEFO · trừ giữ chỗ". PX-0044: lô A260928, "lô gắn đơn". PX-0046: lô L-BOT-22, "theo phiếu trả". |
| 3 | Bộ lọc | Chọn "Loại xuất" = Xuất bán, rồi "Bên yêu cầu" = Sales, rồi "Kho" = NM1-BTP. | Mỗi bộ lọc thu hẹp danh sách; hàng chọn Xuất bán + Sales + NM1-BTP chỉ còn phiếu xuất bán. |
| 4 | Yêu cầu chờ lập phiếu | Xem khối "Yêu cầu xuất chờ lập phiếu" (ghi chú "Xuất trả NCC đã duyệt"). Đổi `vaitro` = `Thủ kho`. | Một dòng TH-NCC-2610-0004 (Phương Nam, 1 bao 25 kg rách khi nhận PN-NM1-2610-0031). `Thủ kho trưởng` thấy chặn; `Thủ kho` thấy nút "Lập phiếu xuất" mở hộp thoại tạo phiếu điền sẵn. TH-NCC-2610-0003 không còn ở đây vì đã có PX-NM1-2610-0046. |
| 5 | Quyền tạo phiếu | Đổi `vaitro` qua `Thủ kho`, `Thủ kho điều phối`, `Sales`, `Kế toán`. | Nút "+ Tạo phiếu xuất" chỉ `Thủ kho` có; các vai trò khác thấy chặn "Việc của Thủ kho". `Kế toán` và `QC` bị chặn cả màn. |
| 6 | Phiếu chờ bên yêu cầu | `start` = `xem`, `ma` = `PX-NM1-2610-0044`. Thử `vaitro` = `Sales`, rồi `Thủ kho`. | Dòng đỏ "Thiếu 48 lon lô A260928 ở NM1-BTP · lệch tồn → PK-NM1-2610-0005 · lô gắn đơn, không thay được. Chờ Sales · Võ Thị Lan chọn nhận phần đã lấy hoặc hủy yêu cầu." `Sales` có nút "Hủy yêu cầu" và "Nhận phần đã lấy"; vai trò khác bị chặn. |
| 7 | Quyết định của Sales | Với `Sales`, bấm "Nhận phần đã lấy". Làm lại ở phiếu khác bằng "Hủy yêu cầu". | "Nhận phần đã lấy": trạng thái Xuất một phần, trừ tồn lô A260928 đúng 432 lon (480 → 48). "Hủy yêu cầu": trạng thái Đã hủy, lý do thêm "Sales hủy yêu cầu, trả hàng đã lấy về lại kho", không trừ tồn. |
| 8 | Phiếu đã hủy / xuất một phần | Mở PX-NM1-2610-0048 và PX-NM1-2610-0047 từ danh sách. | PX-0048: Đã hủy, lý do "Thiếu 7,128 kg lô L-LEC-02 ở NM1-DP · lệch tồn → PK-NM1-2610-0008 ...", không có khối quét. PX-0047: Xuất một phần, "thiếu Bột hỗn hợp vi lượng Số 3 160 kg, đã báo Kế hoạch". |
| 9 | Mất mạng và cloud | `start` = `xem`, `ma` = `PX-NM1-2610-0042`. Bấm "Cloud", rồi nút kết nối. | Cloud: dòng "Bản đồng bộ trên cloud — chỉ xem ..." và mất nút làm tại kho. Ngoại tuyến tại nhà máy: dòng vàng "mất kết nối cloud từ 08:12" với "3 thao tác chờ gửi lên cloud". Dòng giải thích có câu "Phiếu xuất bán / trả NCC / chuyển kho chỉ lập từ yêu cầu đã sao xuống trước lúc mất mạng." |

#### 45b · Xuất kho — quét lấy hàng từng bao / thùng
Mở board này để kiểm: khối "Quét lấy hàng" của phiếu xuất, cách hệ thống chặn bao sai lô hoặc sai trạng thái, và báo thiếu hàng khi lấy.
Ô chỉnh trong "Trạng thái hiển thị": `start` → `danh-sach` / `tao-moi` / `xem`; `vaitro` → `Thủ kho` / `Thủ kho điều phối` / `Thủ kho trưởng` / `Kế hoạch` / `Sales` / `Mua hàng` / `QC` / `Kế toán`; `ma` → `(đầu danh sách)` / `PX-NM1-2610-0042` / `PX-NM1-2610-0043` / `PX-NM1-2610-0046` / `PX-NM1-2610-0048` / `PC-NM1-2610-0011` / `PC-NM2-2610-0014` / `PC-NM1-2610-0013` / `PK-NM1-2610-0005` / `PK-NM1-2610-0006` / `PK-NM2-2610-0004`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Quét bao đầu tiên | Giữ mặc định (`vaitro` = `Thủ kho điều phối`, `ma` = `PX-NM1-2610-0042`). Ở "Kết quả đọc (mô phỏng)" chọn "Mã hợp lệ — bao kế tiếp", bấm "Quét". | Khối có 4 dòng lô: L-BOT-26 (55 bao), L-BOT-24 (20 bao), L-WHE-04 (15 bao), HH-261015 (8 bao), tổng 98 bao, tóm tắt "Đã quét 0/98 bao" rồi "Còn 97 chưa quét". Thông báo "Đã quét mã A-BAO-... thành công", "Đúng lô L-BOT-26 · đã quét 1/55 bao của lô.". Trạng thái phiếu chuyển Chờ lấy hàng → Đang lấy hàng. |
| 2 | Chặn bao sai (mã mô phỏng) | Lần lượt chọn các kết quả: "Bao sai lô (không đúng lô đề xuất)", "Bao sai trạng thái (Khóa / Chờ kiểm)", "Lô hết hạn", "Lô dưới ngưỡng SX", "Mã tem đã khóa (sự cố tem)", "Lô đang kiểm kê", "Mã không có trong hệ thống", rồi bấm "Quét". | Mỗi lần có thông báo đỏ "Quét mã A-BAO-... thất bại" và lý do, ví dụ "Bao không thuộc lô trên phiếu — đặt lại, lấy đúng lô.", "Lô đã hết hạn dùng — không xuất.", "Lô còn hạn dưới ngưỡng tối thiểu cho SX (30 ngày) — không xuất cho sản xuất, lấy lô đề xuất.", "Mã tem đã khóa ở Sự cố tem — dùng tem mã thay thế.", "Kho / lô có cờ đang kiểm kê — chờ kiểm xong.", "Mã không có trong hệ thống — kiểm tra tem, báo Thủ kho trưởng.". Tiến độ không tăng. |
| 3 | Quét trùng | Quét một bao hợp lệ, rồi chọn "Quét trùng bao đã quét", bấm "Quét". | Thông báo đỏ "Mã đã quét rồi — không tính hai lần.". Nếu chưa quét bao nào thì báo "Dữ liệu mẫu không có mã phù hợp cho trường hợp này.". |
| 4 | Vai trò không quét được | Giữ `ma` = `PX-NM1-2610-0046` (trả NCC, kho NM1-TONG). Mặc định `vaitro` = `Thủ kho điều phối`. | Khối quét bị chặn: "Quét ở đây là việc của Thủ kho · thủ kho NM1-TONG" kèm nút "Xem như Thủ kho". Đổi `vaitro` = `Thủ kho`: thấy khối quét với lô L-BOT-22 (hàng "Không đạt"), tiến độ 10/19 bao (250 kg trên 475 kg). Lựa chọn mô phỏng riêng "Bao Đạt (không phải hàng trả)" báo "Bao đang Đạt — chỉ xuất trả bao Khóa / Không đạt theo phiếu trả.". |
| 5 | Xuất bán theo lô của đơn | `ma` = `PX-NM1-2610-0043`, `vaitro` = `Thủ kho`. | Phiếu xuất bán Chờ lấy hàng, lô A241205, 480 lon = 20 thùng. Gợi ý quét ghi quy tắc "thùng Đạt, còn hạn, đúng lô của đơn". Không có lựa chọn mô phỏng "Lô dưới ngưỡng SX". |
| 6 | Báo thiếu hàng khi lấy | Ở PX-NM1-2610-0042 với `vaitro` = `Thủ kho điều phối`, bấm "Thiếu hàng khi lấy". Chọn lô L-BOT-26, nhập SL thực 1.300; thử nhập số lớn hơn 1.360. | Nhập số không nhỏ hơn số cần: lỗi "Nhập SL thực có, nhỏ hơn 1.360." Nhập 1.300: thông báo "Đã ghi lệch tồn, mở PK-NM1-2610-0009; thêm lô thay thế." Phiếu có thêm lô thay thế L-BOT-35 × 60 (lô kế tiếp theo FEFO), lô L-BOT-26 có cờ "Đang kiểm kê". Với phiếu xuất bán (PX-0043) thì không có lô thay thế, trạng thái đổi sang Chờ bên yêu cầu. |
| 7 | Hoàn tất lấy hàng | Bấm "Hoàn tất lấy hàng" khi còn bao chưa quét, rồi khi đã quét đủ. | Còn thiếu: "Còn N dòng chưa lấy đủ — quét tiếp hoặc báo thiếu hàng.". Đủ: Đã xuất (hoặc Xuất một phần nếu có phần thiếu đã báo), trừ tồn lô theo SL thực xuất và trừ KG giữ chỗ của lệnh. |
| 8 | Phiếu đã hủy, và mã của màn khác | `ma` = `PX-NM1-2610-0048`, rồi `ma` = `PC-NM1-2610-0011`. | PX-0048 (Đã hủy) không có khối quét. `PC-NM1-2610-0011` mở phiếu chuyển (mã quyết định màn), không phải phiếu xuất. |

#### 46 · Phiếu xuất kho sản xuất — bản in A4 (PX-NM1-2610-0042)
Mở board này để kiểm: bản in phiếu xuất sản xuất khớp PX-NM1-2610-0042, và ba lựa chọn của ô `trangthai`.
Ô chỉnh trong "Trạng thái hiển thị": `trangthai` → `Chờ lấy hàng` / `Đã xuất` / `Bản sao in lại` (mặc định `Bản sao in lại`).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Chờ lấy hàng | `trangthai` = `Chờ lấy hàng`. | Cột "SL thực xuất", dòng cộng trống; dòng chữ thành đường chấm "....". Chân trang "Trạng thái: Chờ lấy hàng · Trang 1/1". Cột "SL theo chứng từ" vẫn đầy đủ. |
| 2 | Đã xuất | `trangthai` = `Đã xuất`. | SL thực xuất 1.360 / 480 / 360 / 200; cộng 2.400; "Hai nghìn bốn trăm kilôgam.". Không dấu chìm. |
| 3 | Bản sao in lại | `trangthai` = `Bản sao in lại`. | Giống tình huống 2, thêm dấu chìm "BẢN SAO", chân trang "Đã xuất (bản sao)" và dòng "In lại ngày 24/10/2026 bởi Hồ Văn Nam (Thủ kho)...". |
| 4 | Khớp với phiếu gốc | So với board 45b hoặc 42 (`ma` = `PX-NM1-2610-0042`). | Số PX-NM1-2610-0042, ngày 18/10/2026, loại "Xuất sản xuất", kho "NM1-DP · Kho điều phối NM1", chứng từ LSX-2610-0010, người yêu cầu Đỗ Minh Khang (Kế hoạch). Bốn lô và hạn dùng: L-BOT-26 (25/08/2026 đến 25/08/2027), L-BOT-24 (15/07/2026 đến 15/07/2027), L-WHE-04 (10/02/2026 đến 10/02/2027), HH-261015 (15/10/2026 đến 15/04/2027). Số lượng chứng từ 1.360, 480, 360, 200, cộng 2.400 — đúng như phiếu gốc. |

#### 47 · Phiếu xuất kho bán hàng — bản in A4 (PX-NM1-2610-0034)
Mở board này để kiểm: bản in phiếu xuất bán khớp PX-NM1-2610-0034, và ba lựa chọn của ô `trangthai`.
Ô chỉnh trong "Trạng thái hiển thị": `trangthai` → `Chờ lấy hàng` / `Đã xuất` / `Bản sao in lại` (mặc định `Đã xuất`).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Đã xuất | Giữ `trangthai` = `Đã xuất`. | Thực xuất 96 lon, cộng 96, "Chín mươi sáu lon." Chân trang "Trạng thái: Đã xuất". |
| 2 | Chờ lấy hàng | `trangthai` = `Chờ lấy hàng`. | Cột "SL thực xuất" và dòng cộng để trống, dòng chữ là đường chấm. |
| 3 | Bản sao in lại | `trangthai` = `Bản sao in lại`. | Dấu chìm "BẢN SAO", chân trang "Đã xuất (bản sao)", dòng "In lại ngày 24/10/2026 bởi Nguyễn Văn Tú (Thủ kho)...". |
| 4 | Khớp với phiếu gốc | Mở PX-NM1-2610-0034 từ danh sách xuất kho (board 45) rồi so. | Phiếu gốc: Xuất bán, kho NM1-BTP, ĐH-2610-0022, lô A260920, 96 lon, trạng thái Đã xuất, ghi chú "Khách tự lấy tại NM1". Bản in: ĐH-2610-0022, yêu cầu YX-2610-0012 của Võ Thị Lan, lô A260920 (20/09/2026 đến 20/09/2028), "4 thùng × 24 lon", 96 lon, khách "Nhà thuốc Minh Châu". Ngày 15/10/2026 là ngày lập phiếu, người lập "Hệ thống MES", thủ kho Nguyễn Văn Tú. |

#### 48 · Xuất kho — tạo (hệ thống đề xuất lô)
Mở board này để kiểm: hộp thoại tạo phiếu xuất (chỉ xuất trả NCC lập tay), việc hệ thống tự điền hàng và đề xuất lô, và cách chặn vai trò không có quyền.
Ô chỉnh trong "Trạng thái hiển thị": `start` → `danh-sach` / `tao-moi` / `xem`; `vaitro` → `Thủ kho` / `Thủ kho điều phối` / `Thủ kho trưởng` / `Kế hoạch` / `Sales` / `Mua hàng` / `QC` / `Kế toán`; `ma` → các mã ở bảng của board 42 (chỉ có tác dụng khi `start` = `xem`).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Hộp thoại mặc định | Giữ mặc định (`start` = `tao-moi`, `vaitro` = `Thủ kho`). | Hộp thoại "Tạo phiếu xuất kho". "Loại xuất" chỉ có "Trả NCC". "Chứng từ yêu cầu" điền sẵn TH-NCC-2610-0004. Kho xuất NM1-TONG, bên yêu cầu "Mua hàng · Mai Anh Thư". Phần "Lô hệ thống đề xuất" ghi "Để riêng chờ NCC chở về · bao rách khi nhận PN-NM1-2610-0031 (ngoài hệ thống, không tạo tồn)", SL 25 kg, không có lô để chọn. Nút lưu: "Tạo phiếu kèm lô đề xuất". |
| 2 | Lưu phiếu | Bấm "Tạo phiếu kèm lô đề xuất". | Thông báo "Đã tạo PX-NM1-2610-0051.", phiếu Trả NCC, trạng thái Chờ lấy hàng (không qua duyệt). Khối quét không có lô; có nút "Giao hàng để riêng cho NCC" để chuyển sang Đang lấy hàng, rồi "Hoàn tất lấy hàng" để sang Đã xuất. |
| 3 | Chặn theo vai trò | Đổi `vaitro` = `Thủ kho điều phối`, `Thủ kho trưởng`, `Kế hoạch`, `Sales`, `Mua hàng`, rồi bấm lưu. | Lưu báo "Vai trò <tên> không lập được phiếu này — việc của Thủ kho.". Với `Thủ kho điều phối` ô "Loại xuất" không có lựa chọn nào. `Kế toán`, `QC` bị chặn cả màn. |
| 4 | Xem đề xuất lô (FEFO) | `start` = `xem`, `ma` = `PX-NM1-2610-0042`, `vaitro` = `Thủ kho điều phối`. | Khối quét ghi từng lô kèm "Cần 1.360 kg = 55 bao · Tồn 2.400 kg · HSD 25/08/2027" (lô L-BOT-26), tương tự cho L-BOT-24, L-WHE-04, HH-261015. Bảng "Giữ chỗ của lệnh LSX-2610-0010" ghi 1.360, 480, 360, 200 kg. Hệ thống tự lập phiếu này, người dùng không chọn hay đổi lô. |
| 5 | Mở hộp thoại từ khối yêu cầu | `start` = `danh-sach`, `vaitro` = `Thủ kho`. Ở khối "Yêu cầu xuất chờ lập phiếu" bấm "Lập phiếu xuất". | Mở lại hộp thoại tạo phiếu, đã điền TH-NCC-2610-0004. Sau khi lưu, dòng yêu cầu này biến mất khỏi khối chờ (đã có phiếu). |
| 6 | Mất mạng | Bấm nút kết nối để chuyển sang Ngoại tuyến, rồi lưu phiếu. | Thông báo thêm "Đã ghi tại máy chủ NM1, chờ gửi lên cloud.", số thao tác chờ gửi tăng 3 lên 4. |

#### 49 · Chuyển kho — tab Phiếu chuyển (trạng thái thành bộ lọc), xem PC-NM1-2610-0013
Mở board này để kiểm: phiếu chuyển giữa các kho cùng và khác nhà máy, bộ lọc trạng thái, thao tác của kho xuất và kho nhận, và xử lý hàng thiếu, hư, xe trễ.
Ô chỉnh trong "Trạng thái hiển thị": `start` → `danh-sach` / `tao-moi` / `xem`; `vaitro` → `Thủ kho` / `Thủ kho điều phối` / `Thủ kho trưởng` / `Kế hoạch` / `Sales` / `Mua hàng` / `QC` / `Kế toán`; `ma` → `(đầu danh sách)` / `PN-NM1-2610-0031` / `PN-NM1-2610-0030` / `PX-NM1-2610-0042` / `PX-NM1-2610-0044` / `PC-NM1-2610-0013` / `PC-NM1-2610-0016` / `PC-NM2-2610-0019` / `PC-NM1-2610-0020` / `PC-NM1-2610-0021` / `PC-NM1-2610-0009` / `PC-NM1-2610-0006` / `PK-NM1-2610-0003` / `PK-NM1-2610-0005` / `PH-NM1-2610-0013` / `PH-NM1-2610-0014`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Phiếu đang chuyển, nội bộ | Giữ mặc định (`ma` = `PC-NM1-2610-0013`, `vaitro` = `Thủ kho điều phối`). | NM1-TONG → NM1-DP, theo LSX-2610-0014, trạng thái Đang chuyển. Hai dòng: L-BOT-28 416 kg và L-BOT-30 24 kg (trạng thái lô giữ nguyên Đạt, "Đang chuyển · PC-NM1-2610-0013", không thuộc kho nào). Khối "Quét nhận vào NM1-DP", dự kiến 18 bao. Phạm vi "Cùng nhà máy — không có vận chuyển", không có ô giờ đến. |
| 2 | Bộ lọc trạng thái | Bỏ phiếu đang mở. Ở tab liên nhà máy dùng ô "Trạng thái" lần lượt các giá trị. | Tab liên nhà máy (10 phiếu): Chờ xuất 2 (PC-NM2-2610-0019, PC-NM1-2610-0011); Đang chuyển 3 (PC-NM2-2610-0014, PC-NM2-2610-0012, PC-NM1-2610-0009); Nhận thiếu 1 (PC-NM1-2610-0007); Chờ xác nhận thất lạc 1 (PC-NM1-2610-0005); Đã nhận 1 (PC-NM1-2610-0006); Thất lạc 1 (PC-NM1-2610-0015); Đã hủy 1 (PC-NM1-2610-0017); Chờ xử lý hàng hư 0. Tab nội bộ (5 phiếu): Chờ xuất 1 (0021), Đang chuyển 1 (0013), Chờ xử lý hàng hư 1 (0018), Đã hủy 2 (0016, 0020). |
| 3 | Lập phiếu là chấp nhận | Mở PC-NM2-2610-0019 (`ma`) với `vaitro` = `Thủ kho`. | Dòng "Lập từ yêu cầu chuyển YCC-2610-0029 (tab Yêu cầu chuyển) — lập phiếu là chấp nhận." Trạng thái Chờ xuất; 240 lon lô A250710 (10 thùng) từ NM1-BTP sang NM2-BTP. Dòng nhắc "phiếu lập là đã chấp nhận, không qua bước xác nhận" và không có bước Thủ kho trưởng xác nhận. Nút: "Hoàn tất quét xuất", "Không thực hiện được", "Hủy phiếu" (chỉ `Kế hoạch`). |
| 4 | Kho xuất không thực hiện được | Ở PC-NM2-2610-0019 bấm "Không thực hiện được". Thử: không chọn lý do; chọn "+ Khác" mà bỏ trống ghi chú; chọn "Hàng thực tế không có". | Không chọn: "Bắt buộc.". "+ Khác" thiếu ghi chú: "Chọn Khác thì phải ghi chú.". Hợp lệ: phiếu Đã hủy, yêu cầu YCC-2610-0029 quay về "Chờ lập phiếu" kèm lý do; thông báo nói Kế hoạch NM1 lập phiếu lại hoặc từ chối. |
| 5 | Phiếu tự lập đã hủy, phiếu tự lập đang chờ | Mở PC-NM1-2610-0016 và PC-NM1-2610-0020, rồi PC-NM1-2610-0021. | 0016: Đã hủy, "Kho xuất không thực hiện được: Hàng thực tế không có · phần thiếu về Cân đối NVL". 0020: Đã hủy, lý do khác — lô L-BOT-01 đang Chờ kiểm (YC-NM1-2610-0022). 0021: Chờ xuất, 170 kg, dòng báo "Hệ thống tự lập (chuyển nội bộ, không qua yêu cầu) ... gom 2 nhu cầu". |
| 6 | Xe trễ | `ma` = `PC-NM1-2610-0009`. Đổi `vaitro` = `Kế hoạch`. | Dòng đỏ "Xe trễ 2 ngày so với giờ đến dự kiến 16/10/2026 18:00." Nút "Ghi xử lý xe trễ" (cần kết quả liên hệ và giờ mới) và "Xe không tới — lập biên bản thất lạc". Biên bản thất lạc có mã BB-TL-2610-0003, trạng thái Chờ xác nhận thất lạc. |
| 7 | Nhận có thiếu, hư | `ma` = `PC-NM1-2610-0009`, `vaitro` = `Thủ kho` (kho nhận NM2-TONG). Bấm "Hoàn tất nhận" khi chưa quét bao nào. | Lỗi "Chưa quét nhận bao / thùng nào — quét ở khối Quét nhận. Xe không tới: Kế hoạch lập biên bản thất lạc." Đi quét nhận ở board 49b. |
| 8 | Hàng hư và thất lạc | Mở PC-NM1-2610-0006 (`ma`), rồi mở PC-NM1-2610-0005 từ danh sách (tab liên nhà máy). | PC-0006: Đã nhận, dòng "Hàng hư khi nhận: Gửi QC — YC-NM1-2610-0025 (lô Chờ kiểm)", hư 24 lon. PC-0005: Chờ xác nhận thất lạc, thiếu 25 kg, biên bản BB-TL-2610-0001; `Thủ kho trưởng` có "Xác nhận thất lạc" (ghi nhận giá trị 2.200.000 đ) hoặc "Không xác nhận — tìm tiếp" (phiếu về Nhận thiếu). |
| 9 | Vai trò | Với PC-NM1-2610-0013 đổi `vaitro` qua `Thủ kho`, `Thủ kho trưởng`, `Kế hoạch`. | `Thủ kho điều phối` thấy "Hoàn tất nhận" (kho nhận là NM1-DP). `Thủ kho` thấy chặn "Việc của Thủ kho điều phối"; các vai trò khác thấy chặn tương tự. `Sales`, `Mua hàng`, `QC`, `Kế toán` bị chặn cả màn. |

#### 49a · Chuyển kho — tab Yêu cầu chuyển: Kế hoạch NM2 gom yêu cầu cùng đợt & lập phiếu (lập phiếu = chấp nhận)
Mở board này để kiểm: yêu cầu chuyển liên nhà máy gom theo kho xuất và kho nhận; Kế hoạch nhà máy nguồn chọn các yêu cầu đi cùng đợt và lập phiếu, hoặc từ chối; lập phiếu là chấp nhận nên không còn bước Thủ kho trưởng xác nhận.
Ô chỉnh trong "Trạng thái hiển thị": `vaitro` → `Kế hoạch` / `Thủ kho điều phối` / `Thủ kho` / `Thủ kho trưởng` / `Giám đốc`; `nhamay` → `NM2` / `NM1`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Màn mặc định | Giữ `vaitro` = `Kế hoạch`, `nhamay` = `NM2`. | Chỉ yêu cầu có kho xuất ở NM2, cửa sổ hạn xuất mặc định "5 ngày". Hai nhóm: NM2-TONG → NM1-TONG (YCC-2610-0038, YCC-2610-0023, YCC-2610-0021) và NM2-BTP → NM1-BTP (YCC-2610-0037). Các nút cửa sổ: Hôm nay (1), 2 ngày (2), 5 ngày (4), 10 ngày (6), Tất cả (6). Dòng đỏ "1 yêu cầu hạn xuất hôm nay — quá 00:00 mà chưa lên phiếu sẽ tự về Cân đối NVL." (YCC-2610-0023, hạn xuất 18/10). YCC-2610-0024 và 0025 (hạn xuất 28/10) chỉ hiện khi chọn "10 ngày" hoặc "Tất cả". Hạn xuất là ngày cần trừ 2 ngày. |
| 2 | Lập phiếu từ nhiều yêu cầu | Tích YCC-2610-0038 (Bột sữa gầy 200 kg) và YCC-2610-0021 (Bột sữa gầy 120 kg), bấm "Lập phiếu chuyển". | Dòng tóm tắt "2 yêu cầu · 1 nhóm → lập 1 phiếu chuyển". Thông báo "Đã lập PC-NM1-2610-0022 (NM2-TONG → NM1-TONG, 2 yêu cầu) → Chờ xuất. Thủ kho kho xuất lấy hàng và quét xuất ở tab Phiếu chuyển." Hai yêu cầu sang trạng thái "Trên phiếu" cùng mã phiếu; một dòng lô 320 kg lấy từ L-BOT-36. Phiếu mới ở Chờ xuất, không qua xác nhận. |
| 3 | Chọn thiếu yêu cầu gấp | Chỉ tích YCC-2610-0038, chưa tích YCC-2610-0023 và 0021. | Dòng vàng "Còn 2 yêu cầu cùng nhóm chưa chọn, hạn xuất trong 2 ngày: YCC-2610-0023 · Premix vitamin & khoáng 20 kg (hạn 18/10/2026); YCC-2610-0021 · Bột sữa gầy 120 kg (hạn 20/10/2026) — không đi đợt này dễ quá hạn." kèm nút thêm cả hai. |
| 4 | Giao một phần | Tích YCC-2610-0038, sửa ô số giao từ 200 xuống 150. Thử cả hai cách xử lý phần còn lại (giữ lại chờ đợt sau, hoặc từ chối). | Hiện "Phần còn lại 50 kg". Lập phiếu: yêu cầu gốc còn 150 kg, "Trên phiếu"; sinh yêu cầu mới YCC-2610-0040 (50 kg, "Phần còn lại của YCC-2610-0038 sau PC-...") ở Chờ lập phiếu, hoặc ở Từ chối nếu chọn từ chối ("về Cân đối NVL"). |
| 5 | Giao vượt hoặc bằng 0 | Sửa số giao YCC-2610-0038 thành 250, rồi thành 0. | "YCC-2610-0038: giao phải lớn hơn 0 và không vượt yêu cầu 200 kg." Không lập phiếu. |
| 6 | Từ chối yêu cầu | Tích YCC-2610-0021, bấm "Từ chối" khi chưa chọn lý do; rồi chọn lý do "Tồn đã dành cho kế hoạch sản xuất của nhà máy nguồn". | Không chọn: "Chọn lý do từ chối.". Có lý do: "Đã từ chối 1 yêu cầu (YCC-2610-0021) — nhả KG đã giữ ở kho xuất; phần lệnh còn thiếu về Cân đối NVL của nhà máy nhận." Yêu cầu sang tab "Không chuyển" với trạng thái Từ chối. |
| 7 | Nhà máy NM1 | Đổi `nhamay` = `NM1`. | Chỉ yêu cầu kho xuất NM1, cửa sổ 5 ngày: nhóm NM1-TONG → NM2-TONG (YCC-2610-0031, 0032, 0033) và NM1-BTP → NM2-BTP (YCC-2610-0035). YCC-2610-0034 (6.000 lon) và 0036 (hạn xuất 24/10) bị ẩn bởi cửa sổ. Lập phiếu YCC-2610-0031 (NVL-BOT-0001 500 kg) lấy từ lô L-BOT-31 (hạn dùng sớm nhất). |
| 8 | Vai trò chỉ xem | Đổi `vaitro` qua `Thủ kho điều phối`, `Thủ kho`, `Thủ kho trưởng`, `Giám đốc`. | Ba thủ kho chỉ xem: "Chỉ xem — lập phiếu là việc của Kế hoạch nhà máy nguồn.", mỗi nhóm có dòng chặn "Việc của Kế hoạch NM2" và nút "+ Thêm yêu cầu chuyển" cũng bị chặn. `Giám đốc`: "Xem yêu cầu của mọi nhà máy (chỉ xem)." |
| 9 | Yêu cầu nhà máy mình gửi đi, rút lại | Với `Kế hoạch`, `nhamay` = `NM2`, đổi hướng thành "NM2 xin về (NM2 nhận)". Tích YCC-2610-0035 và bấm "Rút yêu cầu" khi chưa chọn lý do, rồi chọn "Đã chọn cách bù khác (mua / lùi ngày)". | Không chọn: "Chọn lý do rút yêu cầu.". Có lý do: "Đã rút 1 yêu cầu (YCC-2610-0035) — nhả KG đã giữ ở kho xuất." Yêu cầu sang trạng thái Đã rút. Nhà máy nhận không có nút lập phiếu. |
| 10 | Tab trạng thái | Với `nhamay` = `NM2`, hướng "NM2 cấp đi", đổi ô phân đoạn qua "Trên phiếu chuyển", "Không chuyển", "Tất cả". | Trên phiếu chuyển 2: YCC-2610-0018 → PC-NM2-2610-0014 (Đang chuyển), YCC-2610-0017 → PC-NM2-2610-0012 (Đang chuyển). Không chuyển 2: YCC-2610-0039 (Đã rút, "Đã chọn cách bù khác ... PO-2610-0021 giao 19/10"), YCC-2610-0022 (Quá hạn xuất). Tất cả 10. |

#### 49b · Chuyển kho — quét nhận (lành / hư, thiếu theo mã)
Mở board này để kiểm: kho nhận quét từng bao / thùng, ghi lành hoặc hư, hoàn tất nhận với hàng thiếu, và kho xuất quét xuất.
Ô chỉnh trong "Trạng thái hiển thị": `start` → `danh-sach` / `tao-moi` / `xem`; `vaitro` → `Thủ kho` / `Thủ kho điều phối` / `Thủ kho trưởng` / `Kế hoạch` / `Sales` / `Mua hàng` / `QC` / `Kế toán`; `ma` → `(đầu danh sách)` / `PX-NM1-2610-0042` / `PX-NM1-2610-0043` / `PX-NM1-2610-0046` / `PX-NM1-2610-0048` / `PC-NM1-2610-0011` / `PC-NM2-2610-0014` / `PC-NM1-2610-0013` / `PK-NM1-2610-0005` / `PK-NM1-2610-0006` / `PK-NM2-2610-0004`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Vai trò mặc định bị chặn | Giữ mặc định (`ma` = `PC-NM2-2610-0014`, `vaitro` = `Thủ kho điều phối`). | Phiếu NM2-BTP → NM1-BTP, Đang chuyển, 336 lon lô A260920 (14 thùng), dự kiến tới 18/10 14:00. Khối quét bị chặn: "Quét ở đây là việc của Thủ kho · thủ kho NM1-BTP Nguyễn Văn Tú" với nút "Xem như Thủ kho". |
| 2 | Quét nhận lành | Đổi `vaitro` = `Thủ kho`. Ở "Kết quả đọc (mô phỏng)" chọn "Mã hợp lệ — thùng kế tiếp", bấm "Quét". | Khối "Quét nhận vào NM1-BTP". Thông báo "Đã quét mã A-BAO-... thành công", "Đúng phiếu, nhận lành. Đã quét 1/14 thùng của lô.". Tóm tắt "Đã quét 1/14 thùng", "Còn 13 chưa quét". |
| 3 | Quét nhận hư | Chọn "Thùng hư — thùng kế tiếp, ghi hư", bấm "Quét". | Thông báo vàng "Đã quét mã ... — ghi hư" và "Sẽ đổi sang Khóa (Hư khi nhận chuyển kho) khi hoàn tất nhận. Đã quét 2/14 thùng của lô.". Tóm tắt thêm "Hư 1". Chọn lại kiểu "Mã hợp lệ" với cùng mã: "bỏ ghi hư — nhận lành". |
| 4 | Chặn mã sai | Chọn "Thùng không thuộc phiếu chuyển này", "Mã tem đã khóa (sự cố tem)", "Mã không có trong hệ thống", rồi quét. Quét lại một thùng đã quét. | "Thùng không nằm trên phiếu PC-NM2-2610-0014 — để riêng, báo Thủ kho trưởng."; "Mã tem đã khóa ở Sự cố tem — dùng tem mã thay thế."; "Mã không có trong hệ thống — kiểm tra tem, báo Thủ kho trưởng."; quét trùng đúng loại báo "Mã đã quét rồi — không tính hai lần." hoặc "Mã đã ghi hư.". |
| 5 | Hoàn tất khi chưa quét | Bấm "Hoàn tất nhận" khi chưa quét. | Lỗi "Chưa quét nhận bao / thùng nào — quét ở khối Quét nhận. Xe không tới: Kế hoạch lập biên bản thất lạc." |
| 6 | Nhận đủ | Quét đủ 14 thùng lành, bấm "Hoàn tất nhận". | Trạng thái Đã nhận; thông báo "PC-NM2-2610-0014: NM1-BTP đã nhận đủ.". Lô A260920 tại NM1-BTP tăng từ 120 lon lên 456 lon. Phiếu nhập PN-NM2-2610-0036 chuyển sang Đã nhập. |
| 7 | Nhận có chênh lệch | Làm lại ở bản mới (tải lại board): quét 12 thùng lành, 1 thùng hư, bỏ 1 thùng chưa quét; bấm "Hoàn tất nhận". Thử không điền mô tả và ảnh. | Nút đỏ "Hoàn tất nhận — có chênh lệch theo mã quét"; nội dung nêu thiếu 1 (kèm mã) "vẫn là hàng đang chuyển trên phiếu, tìm 7 ngày" và hư 1 "chỉ đúng các mã này đổi sang Khóa (Hư khi nhận chuyển kho)". "Mô tả chênh lệch" và "Ảnh hàng hư" để trống báo "Bắt buộc.". Hợp lệ: trạng thái "Chờ xử lý hàng hư", hư 24 lon, thiếu 24 lon giữ trên phiếu; PN-NM2-2610-0036 thành Đã nhập kèm "thiếu 24, hư 24 — xử lý trên phiếu chuyển". |
| 8 | Kho xuất quét xuất | `ma` = `PC-NM1-2610-0011` (Chờ xuất, NM1-TONG sang NM2-TONG, 6.000 cái lon rỗng = 5 kiện), `vaitro` = `Thủ kho`. Bấm "Hoàn tất quét xuất" khi chưa quét đủ, rồi quét đủ 5 kiện. | Chưa đủ: "Còn 5 bao / thùng chưa quét xuất — quét đủ ở khối Quét xuất rồi hoàn tất." Đủ: hỏi ô "Giờ đến dự kiến" (mặc định 2026-10-18 17:00), phiếu sang Đang chuyển và tự sinh phiếu nhập ở NM2-TONG, trạng thái Chờ nhận hàng. |

#### 50 · Kiểm kho
Mở board này để kiểm: phiếu kiểm kho, kết quả đếm của PK-NM1-2610-0003 đang chờ duyệt chéo, việc duyệt hoặc từ chối điều chỉnh, và ra lệnh kiểm mới.
Ô chỉnh trong "Trạng thái hiển thị": `start` → `danh-sach` / `tao-moi` / `xem`; `vaitro` → `Thủ kho` / `Thủ kho điều phối` / `Thủ kho trưởng` / `Kế hoạch` / `Sales` / `Mua hàng` / `QC` / `Kế toán`; `ma` → `(đầu danh sách)` / `PN-NM1-2610-0031` / `PN-NM1-2610-0030` / `PX-NM1-2610-0042` / `PX-NM1-2610-0044` / `PC-NM1-2610-0013` / `PC-NM1-2610-0009` / `PC-NM1-2610-0006` / `PK-NM1-2610-0003` / `PK-NM1-2610-0005` / `PH-NM1-2610-0013` / `PH-NM1-2610-0014`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Phiếu chờ duyệt chéo | Giữ mặc định (`vaitro` = `Thủ kho trưởng`, `ma` = `PK-NM1-2610-0003`). | Kho NM1-TONG, loại "Kiểm điểm (lô lệch)". Lô L-LEC-03: sổ 200 kg, thực đếm 175 kg, chênh lệch -25 kg, lý do "Thiếu 1 bao (25 kg), tìm khắp kho không thấy". Dòng báo "Tổng chênh lệch -25 — chờ Nguyễn Văn Tùng (Thủ kho trưởng NM2) duyệt chéo." và "Cờ đang kiểm kê trên 1 lô trong kho NM1-TONG — chặn xuất / chuyển các lô này tới khi kiểm xong." Người ra lệnh Trần Thị Mai. |
| 2 | Duyệt điều chỉnh | Bấm "Duyệt điều chỉnh (Nguyễn Văn Tùng · duyệt chéo)". | Thông báo "PK-NM1-2610-0003 đã duyệt điều chỉnh.", trạng thái Đã điều chỉnh. Lô L-LEC-03 ở Tồn kho còn 175 kg, cờ "Đang kiểm kê" bị gỡ (so với board 41). |
| 3 | Từ chối điều chỉnh | Bấm "Từ chối điều chỉnh (...)". Thử không nhập lý do, rồi có lý do. | Trống: "Bắt buộc.". Có lý do: về Đang kiểm, dòng "Đếm lại: <lý do>", cột "Thực đếm" quay về "chưa chốt". |
| 4 | Quyền theo vai trò | Đổi `vaitro` qua `Thủ kho`, `Thủ kho điều phối`, `Kế hoạch`. | Chỉ `Thủ kho trưởng` thấy nút duyệt. `Thủ kho`, `Thủ kho điều phối` thấy chặn "Việc của Thủ kho trưởng · Từ chối điều chỉnh / Duyệt điều chỉnh" nhưng có nút "In báo cáo kiểm kho". `Kế hoạch`, `Mua hàng`, `Sales`, `Kế toán`, `QC` bị chặn cả màn. |
| 5 | Phiếu đang kiểm và phiếu khớp | Mở PK-NM1-2610-0005 (`ma`), rồi mở PK-NM1-2610-0002 từ danh sách. | 0005: Đang kiểm, lô A260928 sổ 480 lon chưa chốt, nguồn "PX-NM1-2610-0044 thiếu hàng khi lấy lô A260928". 0002: Khớp, lô A241205 sổ 960 và thực đếm 960. |
| 6 | Ra lệnh kiểm | `start` = `tao-moi`, `vaitro` = `Thủ kho trưởng`. Lưu khi để trống; chọn "Kiểm điểm (lô lệch)" mà không có lô; rồi điền đủ. | Để trống: "Bắt buộc." ở Loại kiểm, Kho. Kiểm điểm không có lô: "Thêm ít nhất một lô.". Nguồn lệch tồn là ô bắt buộc khi chọn kiểm điểm. Lưu xong: mã PK-NM1-2610-0009, trạng thái Đang kiểm, lô được chọn có cờ "Đang kiểm kê". Với "Kiểm toàn kho định kỳ" cờ đặt trên cả kho. |
| 7 | Không tự duyệt | Với phiếu vừa tạo ở tình huống 6, chuyển `vaitro` = `Thủ kho` quét và chốt có chênh lệch (xem board 50b), rồi quay lại `Thủ kho trưởng`. | Phiếu Chờ duyệt điều chỉnh nhưng nút duyệt xám và dòng "Người lập không tự duyệt — Trần Thị Mai lập phiếu này, chờ Thủ kho trưởng khác duyệt." |
| 8 | Phiếu có bao tìm lại | Mở PK-NM1-2610-0007 từ danh sách. | Đã điều chỉnh. Lô L-CAC-05: sổ 400 kg, đếm 375 kg (-25) và dòng "Tìm lại 1 bao" 25 kg, được nhập lại thành lô trạng thái Khóa "Tìm lại sau thất lạc / hủy nhầm" (khớp Tồn kho). |
| 9 | Mất mạng và cloud | Bấm "Ngoại tuyến", rồi duyệt điều chỉnh; sau đó bấm "Cloud". | Ngoại tuyến: thông báo thêm "Đã ghi tại máy chủ NM1, chờ gửi lên cloud.". Cloud: không có nút duyệt, từ chối, in; dòng "chỉ xem". |

#### 50b · Kiểm kho — quét đếm (khớp / thiếu / thừa / lạ)
Mở board này để kiểm: khối "Quét đếm" so mã quét với sổ, ghi khớp, thiếu, thừa, mã lạ, bao không tem, rồi chốt kết quả.
Ô chỉnh trong "Trạng thái hiển thị": `start` → `danh-sach` / `tao-moi` / `xem`; `vaitro` → `Thủ kho` / `Thủ kho điều phối` / `Thủ kho trưởng` / `Kế hoạch` / `Sales` / `Mua hàng` / `QC` / `Kế toán`; `ma` → `(đầu danh sách)` / `PX-NM1-2610-0042` / `PX-NM1-2610-0043` / `PX-NM1-2610-0046` / `PX-NM1-2610-0048` / `PC-NM1-2610-0011` / `PC-NM2-2610-0014` / `PC-NM1-2610-0013` / `PK-NM1-2610-0005` / `PK-NM1-2610-0006` / `PK-NM2-2610-0004`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Vai trò mặc định bị chặn | Giữ mặc định (`vaitro` = `Thủ kho điều phối`, `ma` = `PK-NM1-2610-0005`). | Phiếu Đang kiểm, kho NM1-BTP, lô A260928, sổ 480 lon = 20 thùng. Khối quét bị chặn: "Quét ở đây là việc của Thủ kho · thủ kho NM1-BTP Nguyễn Văn Tú" kèm nút "Xem như Thủ kho". |
| 2 | Khớp | Đổi `vaitro` = `Thủ kho`. Chọn "Mã hợp lệ — thùng kế tiếp", bấm "Quét". | Thông báo "Khớp sổ · lô A260928 đã quét 1/20 thùng.". Tóm tắt "Đã quét 1/20 thùng", "Còn 19 chưa quét". |
| 3 | Thừa | Chọn "Bao thừa của lô đang đếm (tìm lại)", bấm "Quét". | Thông báo vàng "Đã quét mã A-BAO-... — thừa so với sổ", "Thuộc lô A260928 nhưng ngoài sổ — ghi thừa (tìm lại). Khi duyệt điều chỉnh: Khóa, chờ QC.". Tóm tắt thêm "Thừa 1". |
| 4 | Lạ | Chọn lần lượt "Bao của lô ngoài phạm vi kiểm", "Bao đã HỦY", "Mã không có trong hệ thống". | Mỗi mã thêm vào nhóm "Mã lạ quét được trong kho NM1-BTP": "Mã lạ: lô ..., ngoài phạm vi kiểm.", "Mã lạ: lô L-BOT-32, đã HỦY, sổ ghi ở NM1-TONG.", "Mã lạ: không có trong hệ thống.". Câu "Không tự cộng vào lô nào — Thủ kho trưởng xử lý khi duyệt". Tóm tắt "Lạ N". |
| 5 | Quét trùng | Quét một thùng hợp lệ, rồi chọn "Quét trùng bao đã đếm". | "Mã đã quét rồi — không tính hai lần." (đầu thông báo "Quét mã ... thất bại"). |
| 6 | Bao mất tem | Bấm "Ghi bao không tem". Nhập số 0, rồi số 2 với lý do. | Số 0: lỗi "Số bao > 0.". Hợp lệ: tóm tắt "Không tem 2 (đếm tay)", dòng lô có thêm "2 thùng không tem (đếm tay)". |
| 7 | Chốt | Bấm "Chốt kết quả đếm" khi chưa quét gì; rồi sau khi quét 18/20 thùng; rồi sau khi quét đủ 20/20 và không thừa, không lạ. | Chưa quét: "Chưa quét bao / thùng nào — quét ở khối Quét đếm.". Quét 18/20: Chờ duyệt điều chỉnh, thực đếm 432 lon, chênh lệch -48, lý do "Thiếu 2 thùng khi quét (...)". Quét đủ: trạng thái Khớp, gỡ cờ, ghi vào lịch sử PX-NM1-2610-0044 là PK đã chốt và báo Sales. |
| 8 | Phiếu khác | `ma` = `PK-NM1-2610-0006` (`vaitro` = `Thủ kho`), rồi `ma` = `PK-NM2-2610-0004`. | 0006: NM1-BTP, lô B261011 sổ 1.152 lon = 48 thùng, nguồn truy xuất TX-2610-0003. 0004: kiểm toàn kho định kỳ NM2-TONG, lô L-BOT-31 sổ 700 kg = 28 bao; kho NM2-TONG, người quét là thủ kho Lê Thị Thu. |

#### 50c · Biên bản kiểm kê kho — bản in A4 (PK-NM1-2610-0008)
Mở board này để kiểm: biên bản khớp phiếu kiểm PK-NM1-2610-0008, và từng lựa chọn của ô `trangthai`.
Ô chỉnh trong "Trạng thái hiển thị": `trangthai` → `Chờ duyệt điều chỉnh` / `Đã điều chỉnh` / `Bản sao in lại` (mặc định `Đã điều chỉnh`).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Đã điều chỉnh | Giữ `trangthai` = `Đã điều chỉnh`. | Không dấu chìm. Thời gian khóa "18/10/2026 06:50 – 07:35 · đã gỡ cờ sau khi duyệt". Cột xử lý "đã trừ 25 kg" và "đã nhập lại, Khóa chờ QC". Đoạn "Đã điều chỉnh tồn theo duyệt của Thủ kho trưởng Trần Thị Mai lúc 07:35...". Ô ký Thủ kho trưởng ghi Trần Thị Mai. |
| 2 | Chờ duyệt điều chỉnh | `trangthai` = `Chờ duyệt điều chỉnh`. | Dấu chìm xanh "CHƯA DUYỆT". Thời gian khóa "Từ 18/10/2026 06:50 · lô đang khóa kiểm kê, chờ duyệt điều chỉnh". Cột xử lý "đề xuất trừ 25 kg", "đề xuất nhập lại, Khóa chờ QC". Đoạn "Đề xuất điều chỉnh: ... Chờ Thủ kho trưởng duyệt — người lập không tự duyệt." Ô ký Thủ kho trưởng để trống. |
| 3 | Bản sao in lại | `trangthai` = `Bản sao in lại`. | Dấu chìm đỏ "BẢN SAO"; nội dung như tình huống 1 (đã duyệt); chân trang "Trạng thái: Đã điều chỉnh (bản sao)", "In lại ngày 02/11/2026 bởi Trần Thị Mai (Thủ kho trưởng)...". |
| 4 | Khớp phiếu gốc | So với phiếu PK-NM1-2610-0008 trong danh sách kiểm kho (board 50, mở từ danh sách). | Số PK-NM1-2610-0008, ngày 18/10/2026, kho "NM1-DP · Kho điều phối NM1", căn cứ PX-NM1-2610-0048 thiếu hàng khi lấy lô L-LEC-02 (Lệnh LSX-2610-0011), người đếm Hồ Văn Nam, thời gian đếm 07:15 – 07:20. |
| 5 | Khớp số liệu | So với hai dòng của phiếu gốc. | Dòng 1: L-LEC-02, sổ 40, đếm 15, thiếu 25 kg. Dòng 2: L-LEC-02 bao tìm lại, sổ 0, đếm 25, thừa 25 kg. Cộng: sổ 40, đếm 40, thừa 25, thiếu 25; chênh lệch ròng 0 kg. "Ảnh hưởng: PX-NM1-2610-0048 đã tự hủy; lệnh LSX-2610-0011 chờ phát lại ..." — khớp trạng thái Đã hủy của PX-0048. |

#### 51 · Hủy hàng — phiếu hủy
Mở board này để kiểm: phiếu hủy hàng tạo tay và tự động, quy trình xác nhận hoặc từ chối, thực hiện hủy và các việc của QC và Kế toán.
Ô chỉnh trong "Trạng thái hiển thị": `start` → `danh-sach` / `tao-moi` / `xem`; `vaitro` → `Thủ kho` / `Thủ kho điều phối` / `Thủ kho trưởng` / `Kế hoạch` / `Sales` / `Mua hàng` / `QC` / `Kế toán`; `ma` → các mã ở bảng của board 42 (chỉ có tác dụng khi `start` = `xem`).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Danh sách và tab | Giữ mặc định. Bấm từng tab. | 11 phiếu: Chờ xác nhận 3 (PH-NM1-2610-0013, 0012, 0011), Đã xác nhận 3 (0018, 0014, 0010), Đã hủy 4, Từ chối 1 (PH-NM1-2610-0017). Cột "Nguồn" ghi "hệ thống tự tạo" cho phiếu hết hạn và bột hỏng. |
| 2 | Xác nhận hủy | `start` = `xem`, `ma` = `PH-NM1-2610-0013`, `vaitro` = `Thủ kho trưởng`. Bấm "Xác nhận hủy". | Phiếu lô L-BOT-01, 25 kg, trạng thái trước "Đạt", lý do "Bao rách, nhiễm ẩm"; dòng "Phần trên phiếu đã Khóa (lý do Chờ hủy) — chờ Thủ kho trưởng xác nhận." Sau khi bấm: Đã xác nhận, dòng "chờ thủ kho NM1-TONG thực hiện hủy, lập biên bản". |
| 3 | Từ chối | Ở phiếu tình huống 2 (làm lại bản mới) bấm "Từ chối". Thử bỏ trống lý do; chọn "Về trạng thái trước" và "Gửi QC kiểm". | Bỏ trống: "Bắt buộc.". "Về trạng thái trước": phiếu Từ chối, lô trở lại Đạt. "Gửi QC kiểm": phiếu Từ chối, lô sang Chờ kiểm với yêu cầu mã YC-NM1-2610-0030. |
| 4 | Phiếu tự động không từ chối được | `ma` = `PH-NM1-2610-0014`, rồi mở PH-NM1-2610-0012 và PH-NM1-2610-0011 từ danh sách. | PH-0014 (Đã xác nhận): 420 kg lô M261012-02, hẹn hủy 20/10/2026. PH-0012 và PH-0011 (Chờ xác nhận): không có nút "Từ chối"; chỉ có "Dời ngày hủy". Lô hết hạn: "đã hết hạn 6 ngày" (A241012, 36 lon) và "đã hết hạn 8 ngày" (L-PGA-07, 75 kg). Dời về ngày trước 18/10/2026 báo "Không trước hôm nay.". |
| 5 | Thực hiện hủy | Mở PH-NM1-2610-0018 (Đã xác nhận, lô B261014, 1.152) với `vaitro` = `Thủ kho`, bấm "Thực hiện hủy, lập biên bản". | Ô "Số biên bản hủy" điền sẵn "BB-HUY-NM1-2610-0018". Sau khi làm: Đã hủy, lô sang trạng thái Hủy (không hoàn tác). Thủ kho trưởng chỉ có việc xác nhận hoặc từ chối nên bị chặn nút này. |
| 6 | QC và Kế toán | Mở PH-NM1-2610-0002 (Đã hủy, 948 lon). Thử `vaitro` = `QC`, rồi `Kế toán`. | `QC`: nút "Xác nhận đã hủy mẫu lưu" (cột "QC hủy mẫu lưu liên quan" đang là "Đã báo QC — chờ QC hủy mẫu lưu liên quan"). `Kế toán`: nút "Ghi giá trị hàng hủy" ("Giá trị hàng hủy: Chưa ghi"); ghi xong có dòng "Ghi giá trị hàng hủy ... (chỉ ghi nhận)". PH-NM1-2609-0010 đã có "4.900.000 đ" và PH-NM1-2609-0009 có "83.600.000 đ" do Ngô Bảo Ngọc ghi. |
| 7 | Tạo phiếu hủy | `start` = `tao-moi`, `vaitro` = `Thủ kho`. Lưu để trống; chọn kho NM1-TONG, một lô, số lượng lớn hơn tồn; rồi hợp lệ. | Để trống: "Bắt buộc.". Vượt tồn: "Vượt tồn của lô (N).". Số lượng 0 hoặc âm: "Số lượng > 0.". Lưu xong: mã PH-NM1-2610-0019 (có "NM1"), lô được khóa với lý do "Chờ hủy · PH-NM1-2610-0019", chỉ phần SL trên phiếu bị tách ra khóa. Danh sách lô không có lô đã "Chờ hủy" hay "Hết hạn dùng". |
| 8 | Quyền | Đổi `vaitro` qua `Thủ kho điều phối`, `Kế hoạch`, `Sales`, `Kế toán`, `QC`, `Mua hàng`. | Nút "+ Tạo phiếu hủy": `Thủ kho`, `Thủ kho điều phối` có; `Kế hoạch`, `Sales`, `Kế toán`, `QC` thấy chặn "Việc của Thủ kho · kho phát hiện lỗi lập phiếu". `Mua hàng` bị chặn cả màn. |
| 9 | Mất mạng, cloud | Bấm "Cloud" ở phiếu Đã hủy chưa ghi giá trị; rồi "Ngoại tuyến". | Cloud: chỉ còn nút "Ghi giá trị hàng hủy" của Kế toán. Cloud và ngoại tuyến: thông báo thêm "NM1 ngoại tuyến — lưu trên cloud, nhà máy nhận khi có kết nối.". Tại nhà máy ngoại tuyến, nút này hiện "Ghi giá trị hàng hủy · Chờ gửi lên". |

#### Mã mẫu dùng trong phần này (Kho)
| Mã | Là gì | Xuất hiện ở board | Giá trị phải khớp (trạng thái, số lượng, tiền...) |
|---|---|---|---|
| PN-NM1-2610-0031 | Phiếu nhập mua từ PO-2610-0018 | 41 (tham chiếu), 42, 43, 44 | Chờ xác nhận lệch; 79 bao đã quét, 1.975 kg (S-1290 1.000 kg, S-1291 975 kg); 1 bao 25 kg hỏng, TH-NCC-2610-0004. Bản in: chứng từ 2.000, thực nhập 1.975 |
| PN-NM1-2610-0030 | Phiếu nhập BTP từ LSX-2610-0009 | 42, 43 | Chờ xác nhận lệch; lô B261017, 48 thùng = 1.152 lon; 2 thùng móp (48 lon) chờ NCR |
| PN-NM1-2610-0028 | Phiếu nhập lon rỗng từ PO-2610-0016 | 43 | Đang nhận; lô DA-2610-A, 9 kiện = 10.800 cái, đã quét 6, đã tạo 8 mã, 1 kiện hư 1.200 cái trả NCC (TH-NCC-2610-0005) |
| PN-NM2-2610-0036 | Phiếu nhập tự sinh từ PC-NM2-2610-0014 | 42, 49b | Chờ nhận hàng; 14 thùng = 336 lon A260920; thành Đã nhập khi PC-NM2-2610-0014 nhận xong |
| PX-NM1-2610-0042 | Phiếu xuất sản xuất cho LSX-2610-0010, NM1-DP | 42, 45, 45b, 46, 48 | Chờ lấy hàng; 2.400 kg = 1.360 + 480 + 360 + 200 (98 bao); lô L-BOT-26, L-BOT-24, L-WHE-04, HH-261015 |
| PX-NM1-2610-0043 | Phiếu xuất bán ĐH-2610-0031 | 45, 45b | Chờ lấy hàng; 480 lon lô A241205 = 20 thùng |
| PX-NM1-2610-0044 | Phiếu xuất bán ĐH-2610-0030 (lần 1/2) | 42, 45 | Chờ bên yêu cầu; lô A260928: cần 480 lon, đã lấy 432, thiếu 48; mở PK-NM1-2610-0005 |
| PX-NM1-2610-0046 | Phiếu trả NCC (TH-NCC-2610-0003) | 45, 45b | Đang lấy hàng; L-BOT-22 "Không đạt"; 475 kg = 19 bao, đã lấy 10 bao = 250 kg |
| PX-NM1-2610-0034 | Phiếu xuất bán ĐH-2610-0022 | 45, 47 | Đã xuất; 96 lon lô A260920 (4 thùng); khách tự lấy tại NM1 |
| PC-NM1-2610-0013 | Chuyển nội bộ NM1-TONG sang NM1-DP | 42, 49, 49b | Đang chuyển; 440 kg = L-BOT-28 416 + L-BOT-30 24 (18 bao) |
| PC-NM1-2610-0009 | Chuyển NM1-TONG sang NM2-TONG | 42, 49, 49b | Đang chuyển; 300 kg L-BOT-01 (12 bao); đến dự kiến 16/10 18:00, xe trễ 2 ngày |
| PC-NM1-2610-0006 | Chuyển NM2-BTP sang NM1-BTP | 42, 49 | Đã nhận; 240 lon A260920 (10 thùng); hư 24 lon, Gửi QC YC-NM1-2610-0025 |
| PC-NM2-2610-0014 | Chuyển NM2-BTP sang NM1-BTP cho ĐH-2610-0026 và 0028 | 49b | Đang chuyển; 336 lon A260920 = 14 thùng, đến dự kiến 18/10 14:00; nhận xong thì NM1-BTP từ 120 lên 456 lon |
| PC-NM2-2610-0019 | Chuyển NM1-BTP sang NM2-BTP, lập từ YCC-2610-0029 | 49 | Chờ xuất; 240 lon A250710 = 10 thùng |
| PK-NM1-2610-0003 | Kiểm điểm lô L-LEC-03, NM1-TONG | 42, 50 | Chờ duyệt điều chỉnh; sổ 200 kg, đếm 175 kg, chênh lệch -25 kg; duyệt chéo Nguyễn Văn Tùng |
| PK-NM1-2610-0005 | Kiểm điểm lô A260928, NM1-BTP | 42, 50, 50b | Đang kiểm; sổ 480 lon = 20 thùng, chưa đếm; cờ "Đang kiểm kê" ở Tồn kho |
| PK-NM1-2610-0008 | Kiểm điểm lô L-LEC-02, NM1-DP | 50, 50c | Đã điều chỉnh; sổ 40 kg, đếm 15 kg (thiếu 25 kg) và bao tìm lại 25 kg (thừa 25 kg); ròng 0 kg |
| PH-NM1-2610-0013 | Hủy hàng lỗi L-BOT-01, NM1-TONG | 41, 42, 51 | Chờ xác nhận; 25 kg; hẹn hủy 22/10/2026; Tồn kho: Khóa "Chờ hủy · PH-NM1-2610-0013" |
| PH-NM1-2610-0014 | Hủy bột hỏng mẻ (tự động), NM1-BTP | 42, 51 | Đã xác nhận; lô M261012-02 420 kg; hẹn hủy 20/10/2026 |
| PH-NM1-2610-0018 | Hủy BTP không đạt QC, NM1-BTP | 51 | Đã xác nhận; lô B261014 1.152 lon; hẹn hủy 22/10/2026 |
| YCC-2610-0038 | Yêu cầu chuyển NM2-TONG sang NM1-TONG | 49a | Chờ lập phiếu; Bột sữa gầy 200 kg; cần 24/10, hạn xuất 22/10 |
| L-BOT-01 | Lô bột sữa nguyên kem tại NM1-TONG | 41, 51 | 900 kg Chờ kiểm (YC-NM1-2610-0022); 25 kg Khóa chờ hủy; 300 kg đang chuyển theo PC-NM1-2610-0009 |

### 4.5. Sản xuất — lệnh sản xuất, tiến độ, công thức

Phần này kiểm các luồng của phân hệ Sản xuất ở nhà máy 1 (NM1), gồm các board 52 đến 67. Đó là: lấy dòng đơn hàng để lên lệnh (board 53, 54), tạo lệnh hỗn hợp và lệnh bán thành phẩm (55, 57, 58), cân đối nguyên liệu thiếu (56), xem và phát lệnh (52, 59, 60), máy chủ nhà máy ngoại tuyến và đồng bộ lại (52, 61, 62), tiến độ mẻ (63, 64) và công thức (65, 66, 67).

Cách gọi dùng chung trong phần này:
- Lệnh hỗn hợp là lệnh trộn bột vi lượng đóng thành bao (viết tắt HH). Lệnh BTP (bán thành phẩm) là lệnh trộn bột sữa thành phẩm chưa đóng lon.
- NVL là nguyên vật liệu. Silo là bồn chứa bột của từng khu. NM1-DP là kho điều phối của nhà máy 1, NM1-TONG là kho tổng.
- Máy chủ nhà máy NM1 là máy đặt tại nhà máy. "Ngoại tuyến" nghĩa là máy này mất liên lạc với máy chủ trung tâm.
- Hôm nay trong mockup là 18/10/2026. Giờ ghi trong nhật ký khi bạn bấm nút lấy theo đồng hồ máy, nên phút có thể khác.

#### 52 · Lệnh sản xuất (danh sách lệnh đã phát và chưa phát)
Mở board này để kiểm: danh sách lệnh theo từng khu và từng ngày, nút gửi lại, nút hủy, vai trò nào bấm được gì, và khác biệt giữa máy chủ trung tâm với máy chủ nhà máy.
Ô chỉnh trong "Trạng thái hiển thị":
- `vaitro`: `Kế hoạch` (đủ quyền); `QC`, `Thủ kho điều phối`, `Thủ kho`, `Giám đốc` (xem được); `QC trưởng`, `Thủ kho trưởng`, `Sales` (bị chặn cả màn).
- `side`: `cloud` (máy chủ trung tâm), `local` (máy chủ nhà máy).
- `ketNoi`: `Ngoại tuyến` (mặc định), `Trực tuyến`.
- `start`: mỗi giá trị mở sẵn một màn con, xem các board 53 đến 64.
- `tab`: chỉ có tác dụng khi `start` mở form tạo lệnh (board 54, 55, 57, 58).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Màn mặc định | Mở board, không đổi ô nào. | Thẻ "Đã phát" đang chọn (12 lệnh), kèm "Chờ phát" 21, "Chưa phát" 5, "Hoàn thành" 12. Khu hỗn hợp NM1 có 6 lệnh, ngày "CN 18/10 · Hôm nay" gồm LSX-2610-0020 (Đang chạy, thứ tự 1, "0/1 mẻ xong") và LSX-2610-0021 (Đã nhận, "NM1 nhận 18/10 07:10 · chờ chạy"). Đầu trang có "NM1 ngoại tuyến 08:12". |
| 2 | Lệnh chưa tới được nhà máy | Ở khu hỗn hợp, bấm ngày "T7 24/10". | LSX-2610-0011 "Chờ phát", dòng "chưa tới nhà máy từ 08:20 · đã gửi 6 lần". LSX-2610-0022 "Chờ phát", "chưa tới nhà máy từ 08:25 · đã gửi 5 lần". Mỗi dòng có nút "Gửi lại" và "Hủy". |
| 3 | Gửi lại khi vẫn mất mạng | Bấm biểu tượng "Gửi lại" ở LSX-2610-0011. | Báo vàng "Gửi lại LSX-2610-0011: server nhà máy NM1 vẫn ngoại tuyến." Số lần gửi tăng lên 7, lệnh vẫn "Chờ phát". |
| 4 | Gửi lại khi có mạng | Đổi `ketNoi` = `Trực tuyến`, rồi bấm "Gửi lại" ở LSX-2610-0011. | Lệnh thành "Đã nhận". Báo "LSX-2610-0011 đã phát — server nhà máy NM1 đã nhận · thứ tự sản xuất 5. Máy chủ nhà máy tự kiểm điều kiện: đạt — phát sang Khu hỗn hợp NM1, tự lập phiếu xuất SX PX-NM1-2610-0051 ..." Không còn bước Kế hoạch xác nhận cho lệnh xuống máy tính khu. |
| 5 | Hủy lệnh đã nhận khi nhà máy mất mạng bị chặn | Giữ `ketNoi` = `Ngoại tuyến`. Bấm ô khu "Khu bán thành phẩm NM1", bấm "Hủy" ở LSX-2610-0026 (Đã nhận). | Hộp "Hủy lệnh LSX-2610-0026 (Đã nhận)" có banner đỏ "NM1 đang ngoại tuyến — cần nhà máy xác nhận chưa chạy mẻ nên chưa hủy được. Thử lại khi có kết nối." Nút "Gửi lệnh hủy" mờ, dù đã chọn lý do. |
| 6 | Hủy được khi có mạng | Đổi `ketNoi` = `Trực tuyến`, mở lại hộp hủy LSX-2610-0026, chọn lý do "Tạo trùng đơn", bấm "Gửi lệnh hủy". | Banner xanh "Gửi lệnh hủy xuống server nhà máy: nhà máy xác nhận chưa chạy mẻ → Đã hủy ...". Sau khi gửi: "Đã hủy LSX-2610-0026 — nhà máy xác nhận chưa chạy mẻ." Lệnh sang nhóm "Hoàn thành" với trạng thái "Đã hủy". |
| 7 | Hủy lệnh Chờ phát vẫn được khi mất mạng | `ketNoi` = `Ngoại tuyến`, hủy LSX-2610-0022. | Banner "Server nhà máy chưa nhận lệnh: hủy ngay, cloud ngừng gửi lại, giải phóng giữ chỗ ..." Sau khi hủy: "Đã hủy LSX-2610-0022 — ngừng gửi lại xuống nhà máy." |
| 8 | Lệnh chưa phát | Bấm thẻ "Chưa phát". | Khu hỗn hợp: LSX-2610-0013 "Đủ điều kiện phát"; LSX-2610-0016 "Mới tạo · Chờ NVL" (đang thiếu nguyên liệu, chưa giữ chỗ, chưa phát được) với dòng "thiếu Bột sữa gầy 57,68 kg → chờ Kế hoạch xử lý ở Cân đối NVL"; LSX-2610-0017 "Đủ điều kiện phát". Khu BTP: LSX-2610-0012 "Chưa phát được · chưa đạt: Công thức hiệu lực, Chứng từ"; LSX-2610-0014 "Mới tạo · Chờ NVL". |
| 9 | Lệnh sản xuất tồn kho (không theo đơn) | Bấm khu hỗn hợp, ngày 18/10, xem LSX-2610-0020 và LSX-2610-0021. | Hai lệnh này không có mã đơn hàng, cột khách ghi "Sản xuất tồn kho". Ngược lại LSX-2610-0018 (khu BTP, ngày 20/10) có đơn ĐH-2610-0046. |
| 10 | Đổi thứ tự sản xuất | Khu BTP, ngày "T3 20/10": bấm nút đưa LSX-2610-0025 lên trước LSX-2610-0018. | Báo "LSX-2610-0025 chuyển tới vị trí 3 trong thứ tự sản xuất Khu bán thành phẩm NM1 — NM1 ngoại tuyến, thứ tự mới gửi xuống khi có kết nối." Lệnh Đang chạy luôn đứng đầu, không có tay kéo. |
| 11 | Vai trò chỉ xem | Đổi `vaitro` = `QC` (hoặc `Thủ kho`, `Thủ kho điều phối`, `Giám đốc`). | Mất nút "Tạo lệnh sản xuất", nút Hủy, nút Gửi lại, tay kéo đổi thứ tự. Có dòng "Việc của Kế hoạch · tạo / sửa / phát / hủy lệnh" kèm nút "Xem như Kế hoạch". Chỉ `Giám đốc` thấy thêm mục Cân đối NVL (như `Kế hoạch`). |
| 12 | Vai trò bị chặn | Đổi `vaitro` = `QC trưởng` (hoặc `Thủ kho trưởng`, `Sales`). | Banner vàng "Vai trò QC trưởng không có quyền vào màn này." kèm đường dẫn "Về Việc cần làm". |
| 13 | Máy chủ nhà máy | Đổi `side` = `local`. | Banner "Server nhà máy NM1 (local) — chỉ xem lệnh nhà máy đã nhận. Tạo, sửa, phát, hủy lệnh trên cloud." và "Mất kết nối cloud từ 08:12 — chế độ ngoại tuyến. 37 sự kiện chờ đồng bộ." Chỉ còn thẻ "Nhà máy đã nhận" (9 lệnh) và "Hoàn thành" (10). LSX-2610-0011, 0022, 0025 (Chờ phát) và lệnh "Mới tạo" không hiện. Không có nút nào sửa dữ liệu. LSX-2610-0021 ghi "Chờ chạy". Đổi `ketNoi` = `Trực tuyến` thì banner mất kết nối biến mất. |

#### 53 · Lệnh sản xuất — tab chờ lên lệnh
Mở board này để kiểm: dòng đơn hàng đã chốt còn số lon chưa lên lệnh, được gom theo sản phẩm, và cách chọn dòng để đưa sang form tạo lệnh.
Ô chỉnh trong "Trạng thái hiển thị": `start` → `nhu-cau` (mặc định, mở tab này với 2 dòng SP-0001 đã chọn), `tao-nhu-cau` (nhảy thẳng vào form), `hang-doi` (về danh sách lệnh). Ghi chú: tên thẻ trên màn là "Chờ phát", không phải "Chờ lên lệnh" như tên board.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Lệnh bán thành phẩm | Mở board, không đổi gì. | Thẻ "Chờ phát" có số 21 (dòng đơn). Nút chọn "Lệnh bán thành phẩm" có 13 dòng. Năm nhóm xếp theo hạn lên lệnh: SP-0004 (6.000 lon, 5 dòng đơn, "Sát hạn lên lệnh", hạn giao sớm nhất 04/11, lên lệnh trước 21/10); SP-0005 (3.100 lon, 3 dòng, sát hạn, lên lệnh trước 22/10); SP-0001 (6.000 lon, 3 dòng, lên lệnh trước 26/10); SP-0002 (1.200 lon); SP-0003 (240 lon). |
| 2 | Gộp dòng, phân bổ một phần | Xem nhóm SP-0001. | Đã chọn sẵn ĐH-2610-0046 (đặt 1.800, đã lên lệnh 1.200, còn lại 600, chọn 600) và ĐH-2610-0045 (đặt 2.400, chọn 2.400). ĐH-2610-0048 (3.000 lon) chưa chọn. Nút "Lên lệnh · 2 dòng (3.000 lon)". |
| 3 | Số lon vượt phần còn lại | Sửa số lon của ĐH-2610-0046 thành 700. | Ô số lon viền đỏ, nút thành "Lên lệnh · 2 dòng (3.100 lon)". Bấm nút: form tạo lệnh mở ra, dòng "Nhu cầu đơn hàng" đỏ "ĐH-2610-0046 phân bổ 700 lon > còn lại 600 lon." và "2 / 8 điều kiện chưa đạt", nút "Tạo lệnh" mờ. |
| 4 | Chuyển sang form | Bỏ đổi trên (đặt lại 600), bấm "Lên lệnh · 2 dòng (3.000 lon)". | Form mở ở tab "Nhu cầu": SP-0001 gộp ĐH-2610-0045 và ĐH-2610-0046, 3.000 lon. Có "1 / 8 điều kiện chưa đạt": "Chưa tải tệp — Kế hoạch tải 1 tệp giấy tờ xuất xứ NVL khi tạo lệnh (bắt buộc)." |
| 5 | Lệnh hỗn hợp | Bấm nút chọn "Lệnh hỗn hợp". | 8 dòng đơn. SP-0001 chỉ còn ĐH-2610-0048: đặt 3.000, đã lên lệnh 1.500 (phần của LSX-2610-0016), còn lại 1.500. SP-0004 có 2 dòng (2.700 lon), SP-0005 có 3 dòng (3.100 lon). |
| 6 | Vai trò | Đổi `vaitro` = `QC`. | Ô tick và ô số lon bị khóa, nút "Lên lệnh" không bấm được và có dòng "Việc của Kế hoạch · lên lệnh sản xuất". `QC trưởng`, `Thủ kho trưởng`, `Sales` thì bị báo không có quyền vào màn. |

#### 54 · Tạo lệnh từ nhu cầu — SP-0001 gộp 3 dòng đơn
Mở board này để kiểm: form tạo lệnh khi gộp nhiều dòng đơn cùng sản phẩm, trong đó có một dòng chỉ phân bổ một phần, và các điều kiện chặn nút "Tạo lệnh".
Ô chỉnh trong "Trạng thái hiển thị": `start` → `tao-nhu-cau` (mặc định, form đã điền), `nhu-cau` (về tab chờ lên lệnh), `tao-moi` (form trống).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Gộp 3 dòng, phân bổ một phần | Mở board, xem tab "Nhu cầu". | SP-0001 gộp ĐH-2610-0046 (600 lon), ĐH-2610-0045 (2.400 lon) và ĐH-2610-0048 chỉ 1.200 lon trên 3.000 lon, kèm gợi ý "dư 1.800 lon". Tổng 4.200 lon, 3.360 kg BTP, hạn giao sớm nhất 09/11/2026. |
| 2 | Đủ điều kiện | Xem dòng tóm tắt và các dòng điều kiện. | "Đủ 8 điều kiện — tạo được lệnh." Số mẻ "2 mẻ × 1.680 kg = 3.360 kg (≤ 3.000 kg/mẻ)", sản xuất 28/10/2026 xong 28/10/2026, "CT-BTP-0002 v5". "Dàn silo": giữ đúng NVL của 4 silo đã dùng ngày 28/10 (LSX-2610-0012). "Chứng từ: Đủ 7 chứng từ". |
| 3 | Thiếu nguyên liệu vẫn tạo được | Xem dòng "Tồn NVL khả dụng". | Cảnh báo vàng "⚠ Thiếu Bột sữa nguyên kem 26% béo 935,6 kg; Bột sữa gầy 649,68 kg; Bột hỗn hợp vi lượng Số 3 (bao HH) 200 kg — vẫn tạo được: lệnh sẽ ở Chờ NVL (không giữ chỗ, không phát)." |
| 4 | Bấm tạo lệnh khi thiếu nguyên liệu | Bấm "Tạo lệnh". | Báo vàng "Đã tạo LSX-2610-0028 (Mới tạo · Chờ NVL) — tồn NVL thiếu ...: không giữ chỗ, chưa phát được. Cách bù: ..." Về danh sách, thẻ "Chưa phát" khu BTP có LSX-2610-0028 trạng thái "Mới tạo · Chờ NVL". Nhật ký lệnh ghi ĐH-2610-0046 "600/1.800 lon", ĐH-2610-0048 "1.200/3.000 lon". |
| 5 | Vượt phần còn lại của đơn | Sửa số lon ĐH-2610-0048 thành 3.100. | Ô đỏ "vượt 100". Dòng nhu cầu đỏ "ĐH-2610-0048 phân bổ 3.100 lon > còn lại 3.000 lon." và "1 / 8 điều kiện chưa đạt", nút "Tạo lệnh" mờ. |
| 6 | Thiếu ô bắt buộc: giấy tờ xuất xứ | Ở tab "Kế hoạch sản xuất", bỏ tệp giấy tờ xuất xứ NVL. | Dòng "Giấy tờ xuất xứ NVL" đỏ "Chưa tải tệp — Kế hoạch tải 1 tệp giấy tờ xuất xứ NVL khi tạo lệnh (bắt buộc)." Nút "Tạo lệnh" mờ. |
| 7 | Ngày và khối lượng mẻ sai | Đặt ngày sản xuất là 10/10/2026; sau đó 12/11/2026; sau đó đặt ngày về 28/10 và nhập khối lượng mẻ 3.500. | "Sản xuất 10/10/2026 → dự kiến xong 10/10/2026 — ngày sản xuất trước hôm nay". Với 12/11: "— sau hạn giao 09/11/2026". Với 3.500 kg: "KL mẻ vượt mức tối đa 3.000 kg của khu." |
| 8 | Đổi sang khu hỗn hợp | Ở tab "Khu sản xuất" bấm "Khu hỗn hợp NM1". | Form chỉ giữ ĐH-2610-0048 (1.200 lon), vì hai dòng kia đã lên lệnh hỗn hợp đủ. Vẫn "Đủ 8 điều kiện". |
| 9 | `start` = `tao-moi` | Đổi ô `start`. | Form trống ở tab "Khu sản xuất", mọi điều kiện ở trạng thái chờ, "Chọn khu, sản phẩm và dòng đơn để kiểm 8 điều kiện.", nút "Tạo lệnh" mờ. |

#### 55 · Tạo lệnh — bước Nguyên liệu (nguồn bột hỗn hợp, cách bù phần thiếu)
Mở board này để kiểm: bảng nguyên liệu của lệnh BTP, ba cách lấy bột hỗn hợp, và cách bù phần nguyên liệu thiếu (mua hay chuyển từ nhà máy khác).
Ô chỉnh trong "Trạng thái hiển thị": `start` → `tao-nhu-cau` (mặc định, form SP-0001 như board 54, đang ở bước Nguyên liệu), `tao-moi` (form trống, bảng nguyên liệu rỗng), `nhu-cau` (không mở form, nên không thấy bước này).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Bảng nguyên liệu | Mở board với `start` = `tao-nhu-cau`. | 4 nguyên liệu. Bột sữa nguyên kem 26% béo: cần 1.937,6 kg, dùng được 1.002 kg, "Thiếu 935,6 kg". Bột sữa gầy: cần 672 kg, dùng được 22,32 kg, "Thiếu 649,68 kg". Whey protein cô đặc 80%: cần 470,4 kg, "Đủ". Bột hỗn hợp Số 3: cần 280 kg, dùng được 80 kg, "Thiếu 200 kg". |
| 2 | Nguồn bột hỗn hợp: lệnh đã dành hết | Ở khối "Bột hỗn hợp vi lượng Số 3 (bao HH)", xem lệnh LSX-2610-0011. | Lệnh hỗn hợp chạy 24/10, ra 320 kg, "Đã dành 320 kg cho LSX-2610-0012", ghi "Hết khả dụng", ô chọn bị khóa. |
| 3 | Nguồn bột hỗn hợp: còn đủ | Xem lệnh LSX-2610-0019. | Ra 480 kg, "Đã dành 80 kg cho LSX-2610-0025", "Còn 400 kg", đủ cho phần cần 280 kg nên không có cảnh báo. Bấm để chọn làm nguồn. |
| 4 | Nguồn bột hỗn hợp: còn thiếu | Xem lệnh LSX-2610-0023 và LSX-2610-0022. | LSX-2610-0023: "Đã dành 200 kg cho LSX-2610-0010", "Còn 40 kg", cảnh báo "Còn 40 kg < cần 280 kg — phần thiếu lên lệnh hỗn hợp mới". LSX-2610-0022: "Còn 120 kg", cùng cảnh báo với 120 kg. |
| 5 | Lên lệnh hỗn hợp mới | Chọn lựa chọn thứ ba (lệnh hỗn hợp mới). | Chữ "Lưu lệnh này xong mở form lệnh hỗn hợp CT-HH-0003 cho 280 kg, cùng ngày, xếp trước lệnh này". Kho điều phối NM1-DP đang có 240 kg, thiếu 40 kg. |
| 6 | Bù phần thiếu bằng cách mua | Ở "Bột sữa nguyên kem 26% béo", để mặc định "Mua". | Chữ "Đưa 935,6 kg vào Hàng đợi mua — Mua hàng lập PO" (Hàng đợi mua là danh sách nhu cầu mua cho bộ phận Mua hàng). |
| 7 | Bù bằng chuyển từ nhà máy khác | Ở "Bột sữa gầy" chọn "Chuyển kho liên nhà máy". | Chữ "Các nhà máy khác còn khả dụng tổng 717,32 kg". Hộp "Chọn nhà máy nguồn · Bột sữa gầy · thiếu 649,68 kg" gợi ý NM3 300 kg, NM5 200 kg, NM2 117,32 kg, NM7 32,36 kg, "Chuyển 649,68 kg · đủ phần thiếu". Với Bột sữa nguyên kem, tổng các nhà máy khác là 1.650 kg. |
| 8 | Nhập vượt mức nhà máy nguồn | Trong hộp trên, sửa NM3 thành 999. | Báo "NM3 chỉ còn khả dụng 300 kg — phần vượt không được tính" và "Tổng nhập ... vượt phần thiếu 649,68 kg — chỉ chuyển đủ phần thiếu". Không chọn nhà máy nào thì báo "Nhập KG lấy từ ít nhất 1 nhà máy". |
| 9 | Hệ quả khi tạo lệnh | Chọn chuyển cho Bột sữa gầy, bấm "Tạo lệnh". | Nhật ký lệnh ghi bốn yêu cầu chuyển YCC-2610-0033 đến YCC-2610-0036 (NM2, NM3, NM5, NM7), trạng thái "Chờ lập phiếu". Bột sữa nguyên kem 935,6 kg vào Hàng đợi mua. |
| 10 | Giấy tờ xuất xứ theo từng nguyên liệu | Ở tab "Nguyên liệu & tồn kho", xem cột giấy tờ. | Mỗi nguyên liệu có các giấy tờ riêng bấm xem trước được, ví dụ Bột sữa gầy: "C/O mẫu D" (giấy chứng nhận xuất xứ), "Phiếu kiểm nghiệm L-BOT-34", "Kiểm dịch". Bột hỗn hợp Số 3 có "Phiếu kiểm HH-261015". Có nút bổ sung tệp cho từng nguyên liệu. |

#### 56 · Cân đối NVL (phần thiếu phát sinh sau khi lên lệnh)
Mở board này để kiểm: các phần nguyên liệu thiếu phát sinh sau khi lệnh đã tạo, và cách Kế hoạch chọn xử lý (mua, chuyển từ nhà máy khác, lùi ngày sản xuất).
Ô chỉnh trong "Trạng thái hiển thị": `start` → `can-doi` (mặc định), `hang-doi` (về danh sách lệnh). Nên thử thêm `vaitro` = `Kế hoạch`, `QC`, `Giám đốc`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Danh sách phần thiếu | Mở board. | Có 6 dòng chờ xử lý (cộng thêm 1 dòng đã đủ), sắp theo ngày cần. Ví dụ: LSX-2610-0009 Premix vitamin & khoáng 30 kg (cần 19/10, "Hao hụt vượt định mức"); LSX-2610-0012 Bột sữa gầy 168 kg (cần 28/10, "Chuyển kho nội bộ không thực hiện được", PC-NM1-2610-0016 đã hủy vì "Hàng thực tế không có"); LSX-2610-0016 Lecithin đậu nành 25 kg ("Mua hàng trả về"). |
| 2 | Lệnh bị hụt sau khi giữ chỗ | Xem các dòng của LSX-2610-0014. | Bột sữa nguyên kem 358 kg và Bột sữa gầy 1.040 kg, lý do "Tồn giảm sau khi giữ chỗ" (lô L-BOT-01 chờ kiểm hoặc khóa, L-BOT-22 475 kg "Không đạt"). Dòng nguyên kem ghi đã có yêu cầu chuyển "NM2 · Chờ lập phiếu · hạn xuất 31/10 · 200 kg · đã trừ vào số thiếu". |
| 3 | Yêu cầu chuyển quá hạn | Xem dòng Bột sữa gầy 150 kg. | Lý do "Yêu cầu chuyển quá hạn xuất" của YCC-2610-0031. Lựa chọn mặc định là "Gửi lại YCC-2610-0031 cho Kế hoạch NM3 lập phiếu (hạn xuất mới)". Bấm "Xác nhận": "Bột sữa gầy (LSX-2610-0014): gửi lại YCC-2610-0031 cho Kế hoạch NM3 lập phiếu ...". |
| 4 | Dòng đã có hàng đang về | Xem dòng LSX-2610-0016 Bột sữa gầy 57,68 kg. | Lý do "NCC giao trễ". Hiện "Đã có yêu cầu chuyển đủ 57,68 kg — chờ nhà máy nguồn, không cần xử lý thêm" (YCC-2610-0024 từ NM2), không có nút "Xác nhận". |
| 5 | Mua | Ở dòng Premix 30 kg để "Mua", bấm "Xác nhận". | Báo "Premix vitamin & khoáng (LSX-2610-0009): 30 kg vào Hàng đợi mua." Dòng biến mất khỏi danh sách và vào mục đã xử lý. Chuyển kho liên nhà máy bị khóa ở dòng này vì "các nhà máy khác hết tồn khả dụng"; lùi ngày bị khóa vì "lệnh đã phát". |
| 6 | Lùi ngày thiếu ô bắt buộc | Dòng Lecithin 25 kg: chọn "Lùi ngày sản xuất lệnh", không chọn ngày, bấm "Xác nhận"; sau đó chọn ngày 06/11/2026. | Báo đỏ "Chọn ngày sản xuất mới sau 30/10/2026". Sau khi chọn ngày: "Lecithin đậu nành (LSX-2610-0016): lùi ngày sản xuất LSX-2610-0016 từ 30/10/2026 sang 06/11/2026 — chờ hàng về theo nguồn hiện có." Gợi ý ở dòng này: "Mua hàng đã báo không giao kịp — chọn Mua là chấp nhận hàng về sau ngày cần". |
| 7 | Vai trò | Đổi `vaitro` = `QC`. | Mục Cân đối NVL không có trong menu; mở trực tiếp thì thấy dòng "Việc của Kế hoạch · Kế hoạch quyết định cách bù phần thiếu", mọi nút "Xác nhận" không dùng được. `Giám đốc` có mục menu nhưng cũng chỉ xem. `QC trưởng`, `Thủ kho trưởng`, `Sales` bị báo không có quyền vào màn. |

#### 57 · Tạo lệnh — khu hỗn hợp, SP-0004 gộp 2 dòng đơn
Mở board này để kiểm: lệnh hỗn hợp gộp hai dòng đơn của SP-0004, và việc thiếu bột sữa gầy chỉ làm lệnh vào trạng thái Chờ NVL chứ không chặn việc tạo.
Ô chỉnh trong "Trạng thái hiển thị": `start` → `tao-hh` (mặc định), `tao-moi` (form trống), `tao-btp` (khu bán thành phẩm, xem board 58).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Form đã điền | Mở board. | Khu hỗn hợp NM1, SP-0004 gộp ĐH-2610-0036 (1.500 lon) và ĐH-2610-0042 (1.200 lon) = 2.700 lon. Sản xuất 27/10/2026, 1 mẻ × 202,5 kg, công thức "CT-HH-0005 v1". "Đủ 8 điều kiện — tạo được lệnh." |
| 2 | Thiếu bột sữa gầy | Mở tab "Nguyên liệu & tồn kho". | Bột sữa gầy cần 165,645 kg, dùng được 22,32 kg, "Thiếu 143,325 kg". Bốn nguyên liệu còn lại "Đủ": Canxi cacbonat 24,3 kg; Premix 8,1 kg; Lecithin 4,05 kg; Vitamin D3 0,405 kg. Dòng "Tồn NVL khả dụng" hiện cảnh báo vàng nhưng không đỏ. |
| 3 | Tạo lệnh khi thiếu | Bấm "Tạo lệnh". | Báo vàng "Đã tạo LSX-2610-0028 (Mới tạo · Chờ NVL) — tồn NVL thiếu Bột sữa gầy 143,325 kg: không giữ chỗ, chưa phát được. Cách bù: Bột sữa gầy: 143,325 kg vào Hàng đợi mua. Hàng về → bấm Kiểm tra lại trên lệnh." |
| 4 | Chứng từ của lệnh hỗn hợp | Bấm dòng "Chứng từ". | Đủ 5 chứng từ: hai đơn "Đã chốt", công thức "CT-HH-0005 v1 · hiệu lực", "Hồ sơ công bố & nhãn — Không áp dụng — hỗn hợp nội bộ", và giấy tờ bổ sung "bien-ban-kiem-tra-ATTP-lo-NVL.pdf". |
| 5 | Xếp silo sai | Ở tab "Dàn silo", chọn Bột sữa gầy rồi bấm Silo 3. | Banner đỏ "Silo 3 gán cứng Canxi cacbonat (CaCO3) — không thả Bột sữa gầy vào được." Với Silo 5: "Silo 5 đang bảo trì — không nhận nguyên liệu." |
| 6 | Chỉ còn hai dòng đơn để gộp | Ở tab "Nhu cầu", xem danh sách dòng đơn của SP-0004. | Khu hỗn hợp chỉ cho chọn ĐH-2610-0036 (1.500 lon) và ĐH-2610-0042 (1.200 lon); các dòng khác của SP-0004 đã lên lệnh hỗn hợp đủ. Bỏ tick ĐH-2610-0042 thì tổng còn 1.500 lon và khối lượng mẻ tự tính lại. |
| 7 | `start` = `tao-moi` | Đổi ô `start`. | Form trống, nút "Tạo lệnh" mờ, mọi điều kiện đang chờ. |

#### 58 · Tạo lệnh — khu bán thành phẩm (SP-0004)
Mở board này để kiểm: lệnh BTP bị chặn khi mẫu nhãn chưa được duyệt, khi thiếu giấy tờ xuất xứ, và cách chọn nguồn bột hỗn hợp.
Ô chỉnh trong "Trạng thái hiển thị": `start` → `tao-btp` (mặc định), `tao-hh`, `tao-moi`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Hai điều kiện chưa đạt | Mở board. | Khu bán thành phẩm NM1, SP-0004, ĐH-2610-0036 (1.500 lon, 1.350 kg), sản xuất 29/10/2026, "CT-BTP-0003 v3". "2 / 8 điều kiện chưa đạt", nút "Tạo lệnh" mờ. |
| 2 | Mẫu nhãn chưa duyệt | Bấm dòng "Chứng từ". | Đỏ "Chưa đạt: Mẫu nhãn SP-0004 (v3 · chờ QC trưởng duyệt) — bổ sung ở danh mục Sản phẩm SP-0004." Bảng liệt kê: đơn ĐH-2610-0036 "Đã chốt"; công thức CT-BTP-0003 "v3 · hiệu lực"; "Tự công bố 02/2026/NMA-CB — Hiệu lực · 10/02/2026"; "Mẫu nhãn SP-0004 mau-nhan-SP-0004-v3.pdf — v3 · chờ QC trưởng duyệt". |
| 3 | Thiếu giấy tờ xuất xứ | Xem dòng "Giấy tờ xuất xứ NVL". | Đỏ "Chưa tải tệp — Kế hoạch tải 1 tệp giấy tờ xuất xứ NVL khi tạo lệnh (bắt buộc)." Tải một tệp thì dòng này xanh, còn "1 / 8 điều kiện chưa đạt" (mẫu nhãn), nút vẫn mờ. |
| 4 | Thiếu nguyên liệu nhưng không phải điều kiện chặn | Mở tab "Nguyên liệu & tồn kho". | Bột sữa gầy cần 450 kg, dùng được 22,32 kg, "Thiếu 427,68 kg", dòng "Tồn NVL khả dụng" chỉ cảnh báo. Ba nguyên liệu còn lại "Đủ"; riêng Bột hỗn hợp vi lượng người lớn (NVL-HHP-0005) chưa có giấy tờ nào đính kèm. Lệnh sẽ thành "Chờ NVL" khi đủ các điều kiện khác. |
| 5 | Nguồn bột hỗn hợp: kho điều phối | Xem khối "Bột hỗn hợp vi lượng người lớn (bao HH)". | Cần 112,5 kg, thứ tự 1 ngày 29/10. Kho điều phối NM1-DP có 300 kg lô HH-261012 nên đủ, không thiếu. |
| 6 | Nguồn bột hỗn hợp: từ lệnh hỗn hợp khác | Xem ba lệnh ứng viên. | LSX-2610-0020 (Đang chạy, "Còn 250 kg"), LSX-2610-0021 (Đã nhận, "Đã dành 80 kg cho LSX-2610-0024", "Còn 170 kg"), LSX-2610-0013 (Mới tạo, "Đã dành 260 kg cho LSX-2610-0014", "Hết khả dụng", không chọn được). |
| 7 | Thiếu hồ sơ công bố | Chưa thử được. | Mọi mã sản phẩm mẫu (SP-0001 đến SP-0005) đều có hồ sơ công bố hiệu lực, nên board này không tái hiện được trường hợp thiếu hồ sơ. Ghi vào phần "Chỗ lệch" bên dưới. |

#### 59 · Chi tiết lệnh — Mới tạo, chưa phát được (LSX-2610-0012)
Mở board này để kiểm: hộp chi tiết của một lệnh Mới tạo không phát được vì công thức đã đổi phiên bản, cùng các nút theo vai trò.
Ô chỉnh trong "Trạng thái hiển thị": `start` → `xem` (mặc định, mở LSX-2610-0012), `hang-doi` (về danh sách, bấm mã lệnh để mở chi tiết lệnh khác).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Lệnh chưa phát được | Mở board. | LSX-2610-0012, trạng thái "Mới tạo", banner đỏ "Chưa phát được — 2 điều kiện chưa đạt": "Công thức hiệu lực: Lệnh giữ CT-BTP-0002 v4 nhưng v5 hiệu lực từ 18/10/2026 — sửa lệnh (Mới tạo) để cập nhật định mức" và "Chứng từ: Chưa đạt: Công thức BTP (v4 · đã có bản mới)". |
| 2 | Thông tin lệnh | Xem phần thông tin. | Đơn ĐH-2610-0031, khách KH-0007 Đại lý Minh Phát, SP-0001 4.800 lon, hạn giao 30/10/2026. "2 mẻ × 1.920 kg = 3.840 kg", sản xuất 28/10/2026, Khu bán thành phẩm NM1 · Bồn trộn #1. Giấy tờ xuất xứ "giay-to-xuat-xu-NVL-0012.pdf". "Server nhà máy nhận: —". |
| 3 | Bảng nguyên liệu | Xem bảng. | 4 dòng, mỗi dòng "Đủ": Bột sữa nguyên kem 26% béo 2.176 kg (Silo 1); Bột sữa gầy 768 kg (Silo 2); Whey protein 576 kg (Silo 3); Bột hỗn hợp Số 3 320 kg (Silo 4). Kho điều phối có sẵn 2.400, 600, 900 và 240 kg. |
| 4 | Việc kho theo lệnh | Xem khối các bước kho. | Hạn "Chuyển kho nội bộ không thực hiện được". Bước 1 xong (tự lập PC-NM1-2610-0016). Bước 2 "Đã hủy — kho xuất không thực hiện được: Hàng thực tế không có. Phần thiếu đã vào Cân đối NVL, Kế hoạch chọn cách xử lý", có nút "Mở Cân đối NVL" (sang board 56). |
| 5 | Nhật ký | Xem nhật ký lệnh. | 4 dòng, mới nhất trước: 18/10/2026 08:50 Lê Văn Hải (phiếu chuyển kho hủy); 18/10/2026 07:00 Hệ thống ("CT-BTP-0002 v5 hiệu lực — lệnh Mới tạo cần sửa ..."); 16/10/2026 15:30 hai dòng. |
| 6 | Nút của Kế hoạch | Xem chân hộp. | Có "Sửa lệnh", "Hủy lệnh", "Phát lệnh". Bấm "Phát lệnh" sang board 60. |
| 7 | Vai trò khác | Đổi `vaitro` = `QC`. | Các nút trên mất, có dòng "Việc của Kế hoạch · sửa / phát / hủy lệnh". `QC trưởng`, `Thủ kho trưởng`, `Sales` bị báo không có quyền. |
| 8 | Lệnh tồn kho đã hủy | Về danh sách (`start` = `hang-doi`), mở LSX-2610-0027 trong nhóm "Hoàn thành". | Banner đỏ "Đã hủy: Đổi kế hoạch — gộp vào LSX-2610-0008". "Đơn hàng: Không — sản xuất tồn kho", "Khách hàng: —". Có nút "Tạo lại (sao chép lệnh)". |
| 9 | Lệnh đã nhận và đang chạy | Mở LSX-2610-0024 rồi LSX-2610-0020. | LSX-2610-0024: banner "Nhà máy đã nhận lúc 18/10 07:20. Muốn đổi thì hủy rồi tạo lại." LSX-2610-0020: "Đang chạy — chỉ kết thúc sớm hoặc thêm mẻ bù." và có nút "Kết thúc sớm". |

#### 60 · Phát lệnh đầu hàng — kiểm lại LSX-2610-0012
Mở board này để kiểm: hộp "Phát lệnh" kiểm lại các điều kiện, trường hợp công thức đổi phiên bản, và kho điều phối thiếu nhưng không chặn.
Ô chỉnh trong "Trạng thái hiển thị": `start` → `phat` (mặc định), `hang-doi`. Thêm `ketNoi` → `Ngoại tuyến`, `Trực tuyến`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Công thức đổi phiên bản chặn phát | Mở board với `ketNoi` = `Ngoại tuyến`. | "Đã đạt (6/10): Nhu cầu đơn hàng · Ngày sản xuất & dự kiến xong · Số mẻ & khối lượng mẻ · Giấy tờ xuất xứ NVL · Tồn NVL khả dụng · Dàn silo". Hai dòng đỏ: "Công thức hiệu lực — Lệnh giữ CT-BTP-0002 v4 nhưng v5 hiệu lực từ 18/10/2026 ..." và "Chứng từ — Chưa đạt: Công thức BTP (v4 · đã có bản mới)". Tóm tắt đỏ "Chưa phát được: 2 điều kiện chưa đạt." Nút "Phát lệnh" mờ, có nút "Sửa lệnh". |
| 2 | Kho điều phối thiếu không chặn | Xem dòng "Kho điều phối NM1-DP". | Dòng ở trạng thái chờ (không đỏ): "NM1-DP hiện thiếu Bột sữa gầy 168 kg; Bột hỗn hợp vi lượng Số 3 (bao HH) 80 kg — không chặn phát". |
| 3 | Dòng kết nối theo `ketNoi` | Đổi `ketNoi`. | `Ngoại tuyến`: "Ngoại tuyến từ 08:12 — phát được, nhưng lệnh sẽ Chờ phát, cloud tự gửi lại khi có kết nối". `Trực tuyến`: không còn dòng kết nối. |
| 4 | Sửa lệnh cho khớp công thức mới | Bấm "Sửa lệnh", rồi "Lưu thay đổi". | Form "Sửa lệnh LSX-2610-0012 (Mới tạo)", "Đủ 8 điều kiện — tạo được lệnh." Sau khi lưu: "Đã lưu LSX-2610-0012 (Mới tạo). Phiếu xuất SX tự lập khi lệnh phát sang khu." Nhật ký: "Sửa lệnh Mới tạo · cập nhật giữ chỗ NVL (công thức CT-BTP-0002 v5)". |
| 5 | Phát khi mất mạng | Sau khi sửa, mở lại "Phát lệnh", `ketNoi` = `Ngoại tuyến`, bấm "Phát lệnh". | Tóm tắt "Đủ điều kiện · NM1 ngoại tuyến: lệnh sẽ Chờ phát, tự gửi lại khi có kết nối." Sau khi phát: "LSX-2610-0012 chưa tới server nhà máy NM1 (ngoại tuyến) → Chờ phát, tự gửi lại khi có kết nối." |
| 6 | Phát khi có mạng | Làm tương tự với `ketNoi` = `Trực tuyến`. | "LSX-2610-0012 đã phát — server nhà máy NM1 đã nhận · thứ tự sản xuất 7. Máy chủ nhà máy tự kiểm điều kiện: đạt — phát sang Khu bán thành phẩm NM1, tự lập phiếu xuất SX PX-NM1-2610-0051 từ NM1-DP (Chờ lấy hàng)." Không còn bước Kế hoạch xác nhận. |

#### 61 · Máy chủ nhà máy NM1 — lệnh đã nhận, ngoại tuyến, chỉ xem
Mở board này để kiểm: màn Lệnh sản xuất khi chạy tại nhà máy, mất liên lạc với trung tâm, chỉ xem.
Ô chỉnh trong "Trạng thái hiển thị": `start` → `hang-doi` (mặc định), `xem` (mở chi tiết LSX-2610-0012). Board cố định `side` = `local`; thử thêm `ketNoi` và `vaitro`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Chế độ ngoại tuyến | Mở board. | Hai banner: "Server nhà máy NM1 (local) — chỉ xem lệnh nhà máy đã nhận. Tạo, sửa, phát, hủy lệnh trên cloud." và "Mất kết nối cloud từ 08:12 — chế độ ngoại tuyến. 37 sự kiện chờ đồng bộ. Nhà máy chạy tiếp lệnh đã nhận, không giới hạn thời gian ngoại tuyến." |
| 2 | Chỉ có lệnh đã nhận | Xem hai thẻ. | "Nhà máy đã nhận" 9 lệnh và "Hoàn thành" 10 lệnh. Không có thẻ "Chờ phát", "Chưa phát". Lệnh Chờ phát (LSX-2610-0011, 0022, 0025) và lệnh Mới tạo không xuất hiện. |
| 3 | Trạng thái gọi khác ở nhà máy | Xem LSX-2610-0021. | Trạng thái "Chờ chạy", dòng "chờ chạy · nhận 18/10 07:10", thay vì "Đã nhận" như trên máy chủ trung tâm. |
| 4 | Không có nút sửa dữ liệu | Thử mọi vai trò (`vaitro` = `Kế hoạch`...). | Không có nút "Tạo lệnh sản xuất", "Hủy", "Gửi lại", "Phát lệnh", tay kéo. Kể cả `Kế hoạch` cũng chỉ xem. |
| 5 | Có lại mạng | Đổi `ketNoi` = `Trực tuyến`. | Banner "Mất kết nối cloud ..." biến mất; đầu trang đổi thành "NM1 trực tuyến". Banner "chỉ xem" vẫn còn. |
| 6 | Tiến độ ở nhà máy | Từ LSX-2610-0020, bấm nút tiến độ mẻ. | Màn Tiến độ của máy chủ nhà máy: không có nút "Hủy mẻ 3" hay "Thêm 1 mẻ bù vào lệnh". |

#### 62 · Lệnh SX — có lại kết nối (xung đột đồng bộ LSX-2610-0009)
Mở board này để kiểm: sau khi nhà máy có mạng lại, các lệnh Chờ phát được gửi xuống, và lô bột bị khóa từ trung tâm tới muộn gây xung đột.
Ô chỉnh trong "Trạng thái hiển thị": `start` → `dong-bo` (mặc định); thử thêm `ketNoi`. Lưu ý: màn không có banner chữ báo đồng bộ, hãy kiểm qua dữ liệu như dưới đây.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Lệnh Chờ phát thành Đã nhận | Mở board, bấm "Đã phát", xem khu hỗn hợp ngày "T7 24/10" và khu BTP. | Đầu trang "NM1 trực tuyến". LSX-2610-0011, LSX-2610-0022 và LSX-2610-0025 đã thành "Đã nhận" (nhận 18/10 10:24), không còn nút "Gửi lại". Nhật ký mỗi lệnh có dòng "Có lại kết nối — cloud gửi lại lệnh, server nhà máy NM1 đã nhận". |
| 2 | Phiếu chuyển kho tự lập | Mở nhật ký LSX-2610-0011. | "NM1-DP thiếu Lecithin đậu nành 7,128 kg → tự lập phiếu chuyển nội bộ PC-NM1-2610-0022 (NM1-TONG → NM1-DP, Chờ xuất); hàng về tự bổ sung vào PX-NM1-2610-0051". |
| 3 | Xung đột khóa lô | Khu BTP, ngày "T2 19/10": mở LSX-2610-0009, bấm tiến độ mẻ. | Mẻ 3 "Xong" (18/10 09:20 đến 10:10), ghi "lô BTP tự Khóa (xung đột khi mất kết nối), QC kiểm lại". Tab "Chiết rót": lô B261018-02, 1.200 lon, trạng thái "Khóa", "xung đột khi mất kết nối · QC kiểm lại", phiếu YC-NM1-2610-0023. |
| 4 | Lô bột bị khóa tới muộn | Tab "Silo & nguyên liệu", xem Silo 1. | Có thêm lần nạp lô L-BOT-01 "nạp bổ sung 18/10 09:18 — lệnh khóa lô từ trung tâm (09:05) tới sau khi đã nạp (xung đột)", đánh dấu đỏ. |
| 5 | Nhật ký đồng bộ | Tab "Nhật ký lệnh". | Dòng của Hệ thống: "Đồng bộ: xung đột — lệnh khóa lô L-BOT-01 từ trung tâm (QC trưởng khóa trên cloud lúc 09:05 ...) ... tự Khóa lô B261018-02 sinh ra từ phần đã nạp, tạo YC-NM1-2610-0023". |
| 6 | Con số phải khớp | Tab "Chiết rót" và khối chỉ số. | Lon đạt "3.600 / 3.600", "Lon loại 10 (0,3%)" (5 + 3 + 2 của ba mẻ). Mẻ 1 có B261017, mẻ 2 có B261018-01. Lô B261018-02 và L-BOT-01 phải cùng bị khóa ở màn tồn lô. |
| 7 | Mất mạng trở lại | Bấm nút trạng thái kết nối ở đầu trang. | Đầu trang thành "NM1 ngoại tuyến" kèm giờ hiện tại; lệnh đã nhận ở trên giữ nguyên "Đã nhận". |

#### 63 · Tiến độ lệnh sản xuất — mẻ dừng sự cố
Mở board này để kiểm: màn Tiến độ với một mẻ dừng vì sự cố, khối chỉ số, và lệnh bị chặn phát sang khu.
Ô chỉnh trong "Trạng thái hiển thị": `start` → `me` (mặc định), `me-huy` (đã mở sẵn hộp hủy mẻ, xem board 64). Thử thêm `vaitro`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mẻ dừng sự cố | Mở board. | LSX-2610-0009 (Đang chạy, 3 mẻ × 960 kg). "Mẻ xong 2 / 3", "Khối lượng đã trộn 1.920 / 2.880 kg", "Mẻ dừng do sự cố 1". Mẻ 3 "Dừng — sự cố", từ 18/10 07:20, ghi "07:41 Bồn trộn #1 quá tải động cơ — công nhân khởi động lại 2 lần không được, chờ kỹ thuật". |
| 2 | Chỉ số lon | Xem khối chất lượng. | "Lon đạt / kế hoạch 2.400 / 2.400", "Lon loại 8 (0,3%)". Tab "Chiết rót" có mẻ 1 (lô B261017, "Chờ kiểm", phiếu PN-NM1-2610-0030) và mẻ 2 (lô B261018-01, "Chờ nhập kho", PN-NM1-2610-0033). |
| 3 | Kết thúc sớm bị chặn | Về danh sách, mở LSX-2610-0009, bấm "Kết thúc sớm". | Banner đỏ "Mẻ 3 đang dừng do sự cố — hủy mẻ hoặc chờ chạy tiếp mẻ đó trước khi kết thúc sớm." Nút "Kết thúc sớm" mờ. |
| 4 | Lệnh bị chặn phát sang khu vì Silo 5 bảo trì | Trong danh sách bên trái, bấm LSX-2610-0024 (Đã nhận, khu BTP, tồn kho). | Hộp điều kiện phát sang khu: "Lệnh đã tới nhà máy (Đã nhận)" đạt; "Silo trong phương án không bảo trì" đỏ "Silo 5 đang bảo trì — Kế hoạch xếp lại hoặc chờ"; dòng phiếu xuất ở trạng thái chờ. Có chữ "Chưa phát sang khu: Silo 5 đang bảo trì ... đủ điều kiện thì máy chủ nhà máy tự phát, không cần xác nhận." |
| 5 | Lệnh đã phát sang khu | Bấm LSX-2610-0009 và LSX-2610-0020. | "Đạt · máy chủ nhà máy đã phát sang Khu bán thành phẩm NM1 17/10 12:50" (0009) và "... Khu hỗn hợp NM1 17/10 15:10" (0020). |
| 6 | Lọc danh sách | Bấm các nút "Đang chạy", "Chờ chạy", "Hoàn thành". | Số lệnh lần lượt 2, 7, 10 (tổng 19). Nhóm "Hoàn thành" thu gọn mặc định. |
| 7 | Nhật ký mất mạng | Tab "Nhật ký lệnh" của LSX-2610-0009. | Có dòng 18/10 08:12 "Mất kết nối server nhà máy NM1 — tiến độ dưới đây là bản cloud nhận lần cuối". |
| 8 | Vai trò | Đổi `vaitro` = `QC`, rồi `Thủ kho`. | `QC`: xem được, nút "Hủy mẻ" mất và có dòng "Việc của Kế hoạch · hủy mẻ". `Thủ kho`: bị báo "Vai trò Thủ kho không có quyền vào màn này." (chỉ vào được danh sách lệnh, không vào được tiến độ). `QC trưởng`, `Thủ kho trưởng`, `Sales` cũng bị chặn. |

#### 64 · Tiến độ lệnh sản xuất — hủy mẻ, mẻ bù
Mở board này để kiểm: Kế hoạch hủy một mẻ bị sự cố, bột hỏng thành lô bị khóa chờ hủy, và thêm mẻ bù.
Ô chỉnh trong "Trạng thái hiển thị": `start` → `me-huy` (mặc định, hộp hủy mẻ đã mở sẵn), `me`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Hộp hủy mẻ | Mở board. | Hộp "Hủy mẻ 3 của LSX-2610-0009" đã điền sẵn lý do "Bồn trộn #1 sự cố không khắc phục được" và 420 kg bột bỏ (tối đa 960 kg). Nút "Hủy mẻ 3" bấm được. |
| 2 | Thiếu ô bắt buộc | Xóa lý do. Sau đó nhập lại lý do và đổi số kg thành 1000, rồi thành 0. | Nút "Hủy mẻ 3" mờ khi lý do trống. Số kg lớn hơn 960 hoặc bằng 0: ô viền đỏ, nút mờ. |
| 3 | Hủy mẻ | Điền hợp lệ, bấm "Hủy mẻ 3". | Mẻ 3 thành "Đã hủy". Báo vàng "Đã hủy mẻ 3 của LSX-2610-0009. Bột hỏng 420 kg: lô B261018-03 Khóa — chờ hủy, phiếu hủy PH-NM1-2610-0019 chờ Thủ kho trưởng xác nhận. Thêm mẻ bù để đủ số lượng đơn?" |
| 4 | Số liệu sau khi hủy | Xem khối chỉ số. | "Mẻ xong 2 / 3", "Mẻ hủy / không chạy 1", "Mẻ dừng do sự cố 0". Mẻ 3 có hai mã liên kết B261018-03 và PH-NM1-2610-0019. Nhật ký thêm "Hủy mẻ 3 · lý do: ... · bột bỏ 420 kg" và "Lô B261018-03 Khóa (chờ hủy) · tạo phiếu hủy PH-NM1-2610-0019". |
| 5 | Thêm mẻ bù | Bấm "Thêm 1 mẻ bù vào lệnh". | Báo "Đã thêm mẻ bù 4 vào LSX-2610-0009 — giữ thêm Bột sữa nguyên kem 26% béo 544 kg, Bột sữa gầy 192 kg, Whey protein cô đặc 80% 144 kg, Bột hỗn hợp vi lượng Số 3 (bao HH) 80 kg. Mẻ bù chạy sau các mẻ còn lại." Mẻ 4 có thẻ "mẻ bù", trạng thái "Chờ". |
| 6 | Chỉ số sau khi thêm mẻ bù | Xem khối chỉ số. | "Mẻ xong 2 / 4 (gồm 1 mẻ bù)", "Khối lượng đã trộn 1.920 / 3.840 kg". |
| 7 | Đóng hộp không hủy | Đổi `start` về `me`, bấm "Hủy mẻ" ở mẻ 3. | Hộp hiện lại, bấm đóng thì mẻ 3 vẫn "Dừng — sự cố". |
| 8 | Vai trò | Đổi `vaitro` = `QC`. | Hộp hủy mẻ không hiện, nút "Hủy mẻ" không có, thay bằng dòng "Việc của Kế hoạch · hủy mẻ". |

#### 65 · Công thức (danh sách)
Mở board này để kiểm: danh sách công thức, lệnh còn chạy theo phiên bản cũ, ngừng sử dụng, và quyền theo người xem.
Ô chỉnh trong "Trạng thái hiển thị": `nguoiXem` → `Kế hoạch` (mặc định), `R&D` (sửa được như Kế hoạch), `QC` (chỉ xem).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Danh sách | Mở board. | 4 công thức, chân bảng "4 / 4 công thức". CT-BTP-0002 v5 (lưu 18/10/2026 07:00, 3.000 kg, 4 thành phần, ra SP-0001, SP-0002, SP-0003, SP-0006, SP-0007, Nguyễn Thị Yến · R&D). CT-BTP-0003 v3 (01/10/2026 14:00, SP-0004, SP-0005, Đỗ Minh Khang · Kế hoạch). CT-HH-0003 v2 (20/08/2026 09:40, 250 kg, 5 thành phần). CT-HH-0005 v1 (10/09/2026 15:20, 250 kg, 5 thành phần). |
| 2 | Lệnh còn chạy bản cũ | Xem dòng CT-BTP-0002 và bảng "Lệnh đang chạy phiên bản cũ". | "3 lệnh còn chạy phiên bản 4": LSX-2610-0009 (Đang chạy, "phát 15/10 — giữ bản cũ tới hết lệnh"), LSX-2610-0010 (Đã nhận), LSX-2610-0012 (Mới tạo, "phải sửa lệnh để cập nhật v5"). Số lệnh này lệch với board 52 (xem phần "Chỗ lệch"). |
| 3 | Lọc và tìm | Gõ `lecithin`; sau đó gõ chuỗi lạ; sau đó chọn loại "Hỗn hợp" rồi "BTP". | `lecithin`: hiện CT-HH-0003 và CT-HH-0005 ("2 / 4 công thức"). Chuỗi lạ: danh sách trống. "Hỗn hợp": hai mã CT-HH. "BTP": hai mã CT-BTP. |
| 4 | Ngừng sử dụng thiếu lý do | Bấm "Ngừng sử dụng CT-BTP-0002", bấm "Ngừng sử dụng" khi chưa nhập gì. | Hộp "Ngừng sử dụng công thức" hiện "3 lệnh đang mở dùng công thức này: LSX-2610-0009 (Đang chạy), LSX-2610-0010 (Đã nhận), LSX-2610-0012 (Mới tạo)". Báo đỏ "Nhập lý do ngừng sử dụng." |
| 5 | Ngừng sử dụng thành công và dùng lại | Nhập lý do "Thay bằng bản mới", bấm "Ngừng sử dụng"; sau đó chọn lọc "Tất cả (kể cả ngừng sử dụng)"; bấm nút dùng lại. | "Đã ngừng sử dụng CT-BTP-0002. Lệnh đã tạo vẫn chạy tiếp; không tạo được lệnh mới với công thức này." Chân bảng "3 / 4 công thức · 1 ngừng sử dụng". Khi lọc tất cả: dòng ghi "Ngừng sử dụng" và "18/10/2026 · Thay bằng bản mới". Sau khi dùng lại: "Đã dùng lại CT-BTP-0002 — trạng thái Đang sử dụng." |
| 6 | Xem chi tiết nhanh | Bấm mã CT-BTP-0002. | Hộp có hai thẻ "Thành phần (4)" và "Lịch sử phiên bản (3)". Dung sai ghi "± 5 kg", "± 3 kg", "± 2 kg", "± 1 kg"; tổng 3.000 kg; trộn 20 phút, 35 vòng / phút. Lịch sử v5, v4, v3 kèm người lưu. |
| 7 | Vai trò | Đổi `nguoiXem` = `QC`. | Không còn nút thêm công thức và nút sửa, ngừng sử dụng trên từng dòng; có dòng "Việc của Kế hoạch · R&D / Kế hoạch nhập công thức" với nút "Xem như Kế hoạch". Vẫn mở xem chi tiết được. `R&D` và `Kế hoạch` thấy đầy đủ nút giống nhau. |

#### 66 · Công thức — chi tiết (xem, đang sửa, lệch tổng)
Mở board này để kiểm: xem một công thức theo phiên bản, sửa để tạo phiên bản mới, và các điều kiện chặn lưu (tổng lệch, dung sai, thông số trộn).
Ô chỉnh trong "Trạng thái hiển thị": `nguoiXem` → `R&D` (mặc định), `Kế hoạch`, `QC`; `cheDo` → `Xem`, `Đang sửa — lệch tổng` (mặc định), `Thêm công thức mới` (cùng màn với board 67).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Xem phiên bản hiện hành | `cheDo` = `Xem`. | CT-BTP-0002 v5 "đang hiệu lực từ 18/10/2026 07:00 · Nguyễn Thị Yến (R&D)". Thành phần: Bột sữa nguyên kem 1.730 kg (bản trước 1.700, đánh dấu đổi), Bột sữa gầy 600 kg, Whey 420 kg (bản trước 450, đánh dấu đổi), Bột hỗn hợp Số 3 250 kg. Tổng 3.000 kg (100,0%). Dung sai ±5, ±3, ±2, ±1 kg. Trộn 20 phút, 35 vòng / phút, thứ tự nạp bốn nguyên liệu. Có nút "Sửa công thức". |
| 2 | Mặt hàng và lệnh đang dùng | Cuộn xuống phần mặt hàng và lệnh. | Ra SP-0001, SP-0002, SP-0003, SP-0006 (ghi "chờ duyệt ngừng dùng"), SP-0007. Lệnh dùng: LSX-2610-0009, 0010, 0012 ghi v4 (bản cũ). |
| 3 | Xem phiên bản cũ | Bấm "Phiên bản 3". | Banner phiên bản cũ; tiêu đề "Thành phần — phiên bản 3": 1.670, 600, 480, 250 kg, tổng 3.000 kg, hiệu lực 15/05/2026 09:00 → 02/09/2026 10:15. Nút "Sửa công thức" vẫn sửa từ bản hiện hành. |
| 4 | Đang sửa, lệch tổng | `cheDo` = `Đang sửa — lệch tổng`. | Chữ "Đang sửa — lưu sẽ tạo phiên bản 6", bảng nháp có Bột sữa gầy 599,5 kg. Tổng 2.999,5 (99,98%) màu đỏ. Banner đỏ "Tổng thành phần 2.999,5 kg, lệch KL mẻ chuẩn 3.000 kg — sửa khối lượng cho khớp mới lưu được." Bấm "Lưu phiên bản 6" thì không lưu, vẫn ở chế độ sửa. |
| 5 | Sửa cho khớp rồi lưu | Đổi Bột sữa gầy thành 600, bấm "Lưu phiên bản 6". | Banner đỏ mất. Báo "Đã lưu CT-BTP-0002 phiên bản 6 — có hiệu lực cho lệnh tạo từ bây giờ." Lịch sử: v6 "đang hiệu lực" (ghi chú "Lưu từ màn Công thức"), v5 "hết hiệu lực". |
| 6 | Dung sai là ô bắt buộc | Khi đang sửa, xóa dung sai của Whey. | Banner đỏ "Nhập dung sai (kg, ≥ 0) cho mọi nguyên liệu." Bấm "Lưu phiên bản 6" thì ô dung sai đó viền đỏ, không lưu. |
| 7 | Thiếu dòng hoặc khối lượng | Bấm "+ Thêm nguyên liệu" để có dòng trống; sau đó chọn nguyên liệu nhưng để trống khối lượng. | Dòng trống: "Chọn nguyên liệu và nhập khối lượng > 0 cho mọi dòng (hoặc bỏ dòng trống)." Có nguyên liệu, thiếu khối lượng: "Nhập khối lượng > 0 cho nguyên liệu chưa có khối lượng." |
| 8 | Thông số trộn | Xóa thời gian trộn (hoặc nhập số không nguyên), bấm lưu. | "Nhập thời gian và tốc độ trộn chuẩn (số > 0)." Hai ô viền đỏ. Nút lên xuống đổi thứ tự nạp; dòng đầu không lên được, dòng cuối không xuống được. |
| 9 | Quyền theo người xem | `nguoiXem` = `QC`, thử với `cheDo` = `Xem` và `Đang sửa — lệch tổng`. | Cả hai đều ở chế độ xem. Không có nút "Sửa công thức", có dòng "Việc của Kế hoạch · R&D / Kế hoạch nhập công thức" kèm "Xem như Kế hoạch". Với `Kế hoạch`: sửa và lưu được, người lưu ghi "Đỗ Minh Khang (Kế hoạch)". |

#### 67 · Công thức — tạo mới
Mở board này để kiểm: form thêm công thức mới, mã tự sinh, ô bắt buộc (nhất là dung sai) và quyền lưu.
Ô chỉnh trong "Trạng thái hiển thị": `nguoiXem` → `R&D` (mặc định), `Kế hoạch`, `QC`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Form mới | Mở board. | "Công thức mới", loại "Hỗn hợp (HH)" đang chọn, mã tự sinh CT-HH-0006, khối lượng mẻ chuẩn 250. Một dòng nguyên liệu trống. Ghi chú "Hỗn hợp chỉ dùng nguyên liệu, phụ gia — không dùng bao hỗn hợp (NVL-HHP)." Có nút "Lưu công thức". |
| 2 | Lưu khi để trống | Bấm "Lưu công thức". | Ô tên, dòng nguyên liệu, khối lượng, dung sai và hai ô thông số trộn viền đỏ. Banner đỏ "Thêm ít nhất một nguyên liệu." |
| 3 | Đổi loại | Bấm "Bán thành phẩm (BTP)". | Mã đổi thành CT-BTP-0004, khối lượng mẻ chuẩn 3000, danh sách nguyên liệu có thêm hai bao hỗn hợp (10 mục thay vì 8). Ghi chú "BTP dùng được cả bao hỗn hợp (NVL-HHP)." Bấm lại HH thì dòng nhập bị đặt lại, tên giữ nguyên. |
| 4 | Dung sai là ô bắt buộc | Loại HH, tên "Hỗn hợp vi lượng Số 4", dòng 1 Bột sữa gầy 200 kg dung sai 1, dòng 2 Canxi cacbonat 50 kg bỏ trống dung sai; bấm lưu. | Ô dung sai trống viền đỏ, banner đỏ "Nhập dung sai (kg, ≥ 0) cho mọi nguyên liệu." |
| 5 | Tổng lệch khối lượng mẻ | Đổi Canxi cacbonat thành 20 kg, dung sai 0,2. | Banner đỏ hiện ngay (không cần bấm lưu): "Tổng thành phần 220 kg, lệch KL mẻ chuẩn 250 kg — sửa khối lượng cho khớp mới lưu được." Tổng 220 (88,0%). |
| 6 | Thiếu thông số trộn | Đổi Canxi cacbonat về 50 kg, để trống thời gian và tốc độ trộn, bấm lưu. | Tổng khớp nên không còn banner lệch; báo đỏ "Nhập thời gian và tốc độ trộn chuẩn (số > 0)." và hai ô viền đỏ. |
| 7 | Lưu thành công | Nhập thời gian 12 và tốc độ 45, bấm lưu. | "Đã lưu công thức mới CT-HH-0006 (phiên bản 1) — trạng thái Đang sử dụng." Mở màn chi tiết CT-HH-0006: "Công thức hỗn hợp", phiên bản 1 "từ 18/10/2026 · Nguyễn Thị Yến (R&D)", ghi chú "Công thức mới", thành phần Bột sữa gầy 200 kg (±1), Canxi cacbonat 50 kg (±0,2), chưa ra mặt hàng nào, chưa có lệnh dùng. |
| 8 | Quyền theo người xem | Đổi `nguoiXem` = `QC`; sau đó `Kế hoạch`. | `QC`: vẫn thấy form nhưng không có nút "Lưu công thức", có dòng "Việc của Kế hoạch · R&D / Kế hoạch nhập công thức" kèm "Xem như Kế hoạch". `Kế hoạch`: lưu được, người lưu ghi "Đỗ Minh Khang (Kế hoạch)". |

#### Mã mẫu dùng trong phần này (Sản xuất)
| Mã | Là gì | Xuất hiện ở board | Giá trị phải khớp (trạng thái, số lượng, tiền...) |
|---|---|---|---|
| LSX-2610-0012 | Lệnh BTP Mới tạo, SP-0001, đơn ĐH-2610-0031 | 52, 56, 59, 60, 65, 66 | Khu bán thành phẩm NM1, 2 mẻ × 1.920 kg = 3.840 kg, sản xuất 28/10/2026, giữ CT-BTP-0002 v4 (v5 hiệu lực từ 18/10). Chưa phát được: 2 điều kiện đỏ. PC-NM1-2610-0016 đã hủy, Bột sữa gầy 168 kg ở Cân đối NVL. |
| LSX-2610-0024 | Lệnh BTP tồn kho, Đã nhận, SP-0004 | 52, 63 | CT-BTP-0003 v3, 1 mẻ × 960 kg, ngày 22/10. Bị chặn phát sang khu vì Silo 5 đang bảo trì. |
| LSX-2610-0009 | Lệnh BTP Đang chạy, đơn ĐH-2610-0028, SP-0001 | 52, 62, 63, 64, 65, 66 | 3 mẻ × 960 kg, ngày 19/10, giữ CT-BTP-0002 v4. Mẻ 3: dừng sự cố (board 63) hoặc hủy 420 kg → B261018-03 và PH-NM1-2610-0019 (board 64) hoặc xong, lô B261018-02 bị khóa (board 62). |
| LSX-2610-0011, 0022, 0025 | Ba lệnh Chờ phát khi mất mạng | 52, 61, 62 | Mất mạng: "Chờ phát", đã gửi 6, 5 và 4 lần. Có mạng lại: "Đã nhận" 18/10 10:24. |
| LSX-2610-0026 | Lệnh BTP tồn kho Đã nhận, SP-0002 | 52 | Hủy khi ngoại tuyến bị chặn; hủy khi trực tuyến thành "Đã hủy". |
| LSX-2610-0016 | Lệnh hỗn hợp Chờ NVL, đơn ĐH-2610-0048 (phân bổ 1.500 / 3.000 lon) | 52, 53, 56 | Thiếu Bột sữa gầy 57,68 kg (đã có YCC-2610-0024 từ NM2) và Lecithin 25 kg (Mua hàng trả về). |
| LSX-2610-0014 | Lệnh BTP Chờ NVL, SP-0004 | 52, 56, 58 | Thiếu Bột sữa nguyên kem 358 kg (sau khi trừ 200 kg đang chuyển), Bột sữa gầy 1.040 kg và 150 kg. |
| LSX-2610-0028 | Lệnh mới sinh ra khi bấm "Tạo lệnh" | 54, 55, 57 | Luôn là "Mới tạo · Chờ NVL" trong dữ liệu mẫu hiện tại. |
| ĐH-2610-0048 | Đơn Siêu thị Hà Thành | 53, 54 | SP-0001 3.000 lon (phân bổ 1.200 ở form BTP; 1.500 đã lên lệnh hỗn hợp) và SP-0002 1.200 lon. Hạn giao 11/11/2026. |
| SP-0004 | Nhãn C · Sữa bột người lớn · 900 g | 57, 58 | Mẫu nhãn v3 "chờ QC trưởng duyệt" (chặn lệnh BTP); tự công bố 02/2026/NMA-CB hiệu lực. |
| CT-BTP-0002 | Công thức sữa bột trẻ em Số 3 | 52, 56, 59, 60, 65, 66 | v5 hiệu lực từ 18/10/2026 07:00 (1.730 / 600 / 420 / 250 kg); v4 (1.700 / 600 / 450 / 250). Tổng luôn 3.000 kg. |
| B261018-02, L-BOT-01, YC-NM1-2610-0023 | Lô BTP của mẻ 3, lô bột bị khóa, yêu cầu kiểm | 62 | B261018-02: 1.200 lon, "Khóa", chờ QC kiểm lại. L-BOT-01: nạp bổ sung 18/10 09:18, lệnh khóa lúc 09:05. |
| B261018-03, PH-NM1-2610-0019 | Lô bột hỏng và phiếu hủy khi hủy mẻ 3 | 64 | 420 kg, lô "Khóa — chờ hủy", phiếu chờ Thủ kho trưởng xác nhận. |

### 4.6. Chất lượng — yêu cầu kiểm, phiếu kiểm, phiếu chứng nhận, mẫu lưu

Phân hệ này kiểm bốn luồng, mỗi luồng là một cặp màn hình dùng chung dữ liệu. Board 68 đến 71 là yêu cầu kiểm (kho hoặc kế hoạch gửi, QC trưởng duyệt hoặc từ chối). Board 72 đến 76 là phiếu kiểm (QC lấy mẫu, tải file đánh giá bên ngoài, QC trưởng duyệt kết luận, mở lại lô nguyên liệu không đạt). Board 77, 79, 80, 81 là phiếu chứng nhận (ký riêng sau khi duyệt kết luận). Board 78, 82 đến 86 là mẫu lưu (ghi, lấy ra đánh giá, niêm phong lại, sửa hạn lưu, hủy kèm biên bản).

Từ viết tắt dùng trong phần này: QC là bộ phận kiểm soát chất lượng; NVL là nguyên vật liệu; BTP là bán thành phẩm (thùng lon chưa qua QC); TP là thành phẩm (sản phẩm đã đạt, mang mã sản phẩm như SP-0001); HSD là hạn sử dụng; NCC là nhà cung cấp. "Phần lô" là một lô nằm ở một kho hoặc một chỗ cụ thể (ví dụ lô L-BOT-01 có phần ở kho tổng và phần đang chuyển kho).

Cách dùng chung cho các board có ô `vaitro`, `chon`, `kichban`, `hopthoai` (board 68 đến 76):
- Đổi bất kỳ ô nào trong panel là dữ liệu mẫu nạp lại từ đầu, mọi thao tác đã bấm (duyệt, từ chối, gửi) bị mất. Muốn thử chuỗi thao tác thì chỉ bấm trong board, đừng đổi ô giữa chừng.
- Các board này đều gọi chung một màn hình. Ô `screen` = `yc` là danh sách yêu cầu kiểm, `pk` là danh sách phiếu kiểm. Chọn mã `QC-...` trong `chon` khi `screen` = `yc` thì chưa thấy gì thay đổi; phải đặt `screen` = `pk`. Chọn mã `YC-...` khi `screen` = `pk` cũng vậy.
- Hộp thoại chỉ mở khi mã đang chọn đúng trạng thái: `tu-choi` và `bo-sung` cần yêu cầu đang `Chờ duyệt`; `gui-lai` cần `Yêu cầu bổ sung`; `duyet-kl` cần phiếu `Chờ duyệt kết luận`; `mo-lai` cần phiếu Không đạt của NVL; `lay-mau` cần phiếu chưa lấy mẫu. Sai trạng thái thì hộp thoại không mở và không có thông báo.
- Mã mới do hệ thống cấp nối tiếp mã lớn nhất đang có: yêu cầu mới là `YC-NM1-2610-0030`, phiếu kiểm mới là `QC-NM1-2610-0064` (riêng `YC-NM1-2610-0021` đã giữ sẵn `QC-NM1-2610-0060`).
- Mọi mã sinh ở nhà máy phải có `NM1`: `YC-NM1-2610-xxxx`, `QC-NM1-2610-xxxx`, `CN-NM1-2610-xxxx`, `ML-NM1-2610-xxxx`.

#### 68 · Yêu cầu kiểm — QC trưởng xem YC-NM1-2610-0021
Mở board này để kiểm: danh sách yêu cầu kiểm với đủ trạng thái, số liệu đầu trang và quyền của từng vai trò.
Ô chỉnh trong "Trạng thái hiển thị": `screen` → `yc`, `pk`; `vaitro` → `QC`, `QC trưởng`, `Thủ kho`, `Kế hoạch`, `Thủ kho trưởng`, `Thủ kho điều phối`; `chon` → từng mã `YC-NM1-...` và `QC-NM1-...`; `kichban` → `hom-nay`, `qc-dang-nhap`; `hopthoai` → `khong` và 8 hộp thoại còn lại (xem các board sau).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Số liệu và tab của danh sách yêu cầu | `screen` = `yc`, `vaitro` = `QC trưởng`, `kichban` = `hom-nay` | Bốn ô thống kê: Chờ QC trưởng duyệt 4; Chờ bên gửi bổ sung 1; Đã duyệt · QC đang kiểm 3; Lô sắp hết hạn khi đang chờ kiểm 1 (ghi "L-PGA-09 · 23/10/2026"). Tab: Tất cả 22, Chờ duyệt 4, Yêu cầu bổ sung 1, Đã duyệt · đang kiểm 3, Đã đóng 14. Có phân trang (22 dòng, 10 dòng mỗi trang). |
| 2 | Từng mã yêu cầu cho thấy đúng trạng thái | Đổi `chon` lần lượt qua các mã YC | Chờ duyệt: `YC-NM1-2610-0027` (hàng tìm lại), `-0026` (hàng khách trả), `-0022` (lô L-BOT-01, 1.200,0 kg), `-0021` (lô L-PGA-09, 150,0 kg). Yêu cầu bổ sung: `-0023`. Đã duyệt · đang kiểm: `-0025`, `-0019`, `-0010`. Từ chối: `-0014`. Đã hủy: `-0024`. Đã kết luận: `-0029`, `-0028`, `-0012`, `-0011`, `-0009`, `-0008`, `-0007`, `-0006`, `-0005`, `YC-NM1-2609-0022`, `-0021`, `-0018`. |
| 3 | Yêu cầu sắp hết hạn | `chon` = `YC-NM1-2610-0021` | Khung chi tiết có cảnh báo "Lô hết hạn 23/10/2026 (còn 5 ngày). Chưa có kết luận đến hạn thì yêu cầu tự hủy, lô bị khóa." Số 5 ngày tính từ ngày hiện hành của mockup là 18/10/2026. |
| 4 | Yêu cầu đã bị từ chối ghi rõ lý do | `chon` = `YC-NM1-2610-0014` | Trạng thái "Từ chối"; khung từ chối hiện lý do "Đã mở 2 bao kiểm tra tại chỗ: bột khô, tơi; chỉ ướt vỏ bao ngoài. Không cần kiểm — lô về Đạt." do Võ Thanh Hà, 14/10 09:10. Nhật ký ghi "Từ chối — lô về Đạt". |
| 5 | Yêu cầu tự hủy do hết hạn | `chon` = `YC-NM1-2610-0024` | Trạng thái "Đã hủy". Nhật ký do "Hệ thống" ghi: lô hết hạn 10/10 khi chưa có kết luận, yêu cầu tự hủy, lô thành Khóa · Hết hạn dùng và có đề nghị hủy PH-NM1-2610-0011. |
| 6 | Quyền theo vai trò: nút gửi yêu cầu | `vaitro` = `Thủ kho`, rồi `Kế hoạch`, rồi `Thủ kho điều phối` | Cả ba thấy nút "+ Gửi yêu cầu kiểm" và bảng lô có thể gửi. |
| 7 | Quyền theo vai trò: chỉ xem | `vaitro` = `QC`, rồi `Thủ kho trưởng`, rồi `QC trưởng` | Không có nút gửi; thay bằng dòng "Việc của Thủ kho · Thủ kho hoặc Kế hoạch gửi" và nút "Xem như Thủ kho". Riêng `QC trưởng` còn thấy bảng lô có thể gửi và dòng "Bạn đang giữ vai trò QC trưởng ủy quyền thay Võ Thanh Hà, 15/10 → 21/10/2026." |
| 8 | Chỉ QC trưởng duyệt | `chon` = `YC-NM1-2610-0022`, `vaitro` = `QC trưởng`, rồi đổi sang `Kế hoạch` | `QC trưởng` thấy "Duyệt — tạo phiếu kiểm", "Yêu cầu bổ sung", "Từ chối". Vai trò khác thấy "Việc của QC trưởng" và "Đang chờ QC trưởng duyệt (Trần Thị Mai, ủy quyền thay Võ Thanh Hà 15/10 → 21/10)." |
| 9 | Kịch bản QC đang nhập | `kichban` = `qc-dang-nhap` | `YC-NM1-2610-0021` thành "Đã duyệt · đang kiểm", đã có phiếu `QC-NM1-2610-0060`; tab Chờ duyệt còn 3, Đã duyệt 4. Đặt `screen` = `pk` thấy thêm phiếu `QC-NM1-2610-0060`. |
| 10 | Danh sách phiếu kiểm | `screen` = `pk`, `kichban` = `hom-nay` | Bốn ô: Đang kiểm 2; Chờ duyệt kết luận 1; Đã duyệt tháng 10 là 9 (Đạt 6 · Không đạt 3); Lô NVL Không đạt còn trong kho 1 (L-BOT-22). Tab: Tất cả 15, Đang kiểm 2, Chờ duyệt kết luận 1, Đã duyệt 12. |
| 11 | Từng mã phiếu kiểm cho thấy đúng trạng thái | `screen` = `pk`, đổi `chon` qua các mã QC | Đang kiểm: `QC-NM1-2610-0061` (chưa lấy mẫu), `-0059` (đã lấy mẫu, chưa có file), `-0060` (chỉ có ở `qc-dang-nhap`). Chờ duyệt kết luận: `-0058`. Đã duyệt Đạt: `-0057`, `-0056` (cả hai chờ ký), `-0055` (đã ký CN-NM1-2610-0018), `-0052`, `-0051`, `-0049`, `QC-NM1-2609-0050`, `-0049`. Đã duyệt Không đạt: `-0063` (thành phẩm), `-0044` (NVL, còn mở lại được), `-0062` (đã mở lại thành Đạt), `QC-NM1-2609-0048`. |

#### 69 · Yêu cầu kiểm — Thủ kho gửi yêu cầu mới
Mở board này để kiểm: hộp thoại gửi yêu cầu kiểm cho lô nghi lỗi và việc kiểm tra thiếu ô bắt buộc.
Ô chỉnh trong "Trạng thái hiển thị": `vaitro` → `Thủ kho` (mặc định), `Kế hoạch`, `Thủ kho điều phối`, `QC`, `QC trưởng`, `Thủ kho trưởng`; `hopthoai` → `gui-yc` (mặc định), `khong`; `kichban` → `hom-nay`, `qc-dang-nhap`; `chon`, `screen` như board 68.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Hộp thoại mở sẵn | Mặc định (`hopthoai` = `gui-yc`) | Hộp "Gửi yêu cầu kiểm" có hai tab "Lô & phần lô" và "Lý do & ảnh". Danh sách lô gửi được: L-BOT-19, L-BOT-28, L-WHE-05, L-PGA-07 (lô A241205 và A260920 không có vì đã có yêu cầu đang mở). Dòng "Người duyệt" ghi "QC trưởng · Trần Thị Mai (ủy quyền)". |
| 2 | Lô không gửi được | Bấm lô `L-PGA-07` | Lô mờ, ghi lý do: Lý do khóa "Hết hạn dùng" chỉ có đường hủy — không gửi QC. Không chọn được phần lô nào. |
| 3 | Thiếu lý do | Chọn `L-BOT-19`, giữ phần lô đã chọn sẵn, để trống lý do, bấm "Gửi yêu cầu" | Báo "Nhập lý do / hiện tượng nghi lỗi — bắt buộc." và hộp thoại tự nhảy sang tab "Lý do & ảnh". Loại yêu cầu hiện "Khoanh vùng". |
| 4 | Không chọn phần lô nào | Bỏ chọn hết phần lô rồi bấm "Gửi yêu cầu" | Báo "Chọn ít nhất 1 phần lô (lô × kho)." và nhảy về tab "Lô & phần lô"; dòng kết quả ghi "Chưa chọn phần lô nào." |
| 5 | Gửi thành công | Nhập lý do (ví dụ "bao có mùi lạ"), bấm "Gửi yêu cầu" | Báo "Đã gửi YC-NM1-2610-0030 · lô L-BOT-19 vào Chờ kiểm, chặn xuất ngay. Chờ QC trưởng duyệt." Dòng mới đứng đầu danh sách, trạng thái "Chờ duyệt", người gửi Lê Văn Hải. Tab Chờ duyệt tăng 4 → 5. |
| 6 | Lô có phần ở nhiều chỗ | Chọn `L-BOT-28` | Có ba phần lô đang chuyển kho (PC-NM1-2610-0005 25 kg, PC-NM1-2610-0013 416 kg, PC-NM2-2610-0012 175 kg), đều chọn được. |
| 7 | Vai trò không được gửi | `vaitro` = `QC`, rồi `Thủ kho trưởng`, rồi `QC trưởng` | Hộp thoại vẫn mở nhưng cuối hộp ghi "Việc của Thủ kho · Thủ kho hoặc Kế hoạch gửi" và nút "Xem như Thủ kho"; không gửi được. |
| 8 | Gửi từ bảng lô gợi ý | `hopthoai` = `khong`, `vaitro` = `Thủ kho`, bấm nút gửi ở dòng `L-CAC-05` | Hộp thoại mở với lô L-CAC-05, loại yêu cầu "Tìm lại sau thất lạc". Các dòng `L-BOT-35`, `B261017`, `B261018-01` không có nút gửi, mỗi dòng ghi lý do (ví dụ B261018-01: "Nhập kho BTP xong mới gửi được"). |

#### 70 · Yêu cầu kiểm — QC trưởng từ chối (bắt buộc lý do)
Mở board này để kiểm: hộp thoại từ chối yêu cầu kiểm, bắt buộc ghi lý do, và lô trở về trạng thái trước khi gửi.
Ô chỉnh trong "Trạng thái hiển thị": `vaitro` → `QC trưởng` (mặc định), `QC`, `Thủ kho`, `Kế hoạch`, `Thủ kho trưởng`, `Thủ kho điều phối`; `hopthoai` → `tu-choi` (mặc định), `bo-sung`, `khong`; `chon` → `YC-NM1-2610-0022` (mặc định), `YC-NM1-2610-0023`, `YC-NM1-2610-0021`; `kichban`, `screen`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Hộp thoại từ chối | Mặc định | Tiêu đề "Từ chối yêu cầu kiểm YC-NM1-2610-0022", lô L-BOT-01, loại "NVL nghi lỗi", gửi bởi Lê Văn Hải. Mục "Lô về trạng thái trước khi gửi": NM1-TONG → Khóa · Khóa từ trung tâm · NCC báo nghi vón cục; Đang chuyển · PC-NM1-2610-0009 → cùng trạng thái đó. |
| 2 | Thiếu lý do | Bấm "Từ chối yêu cầu" khi ô lý do trống | Báo "Nhập lý do từ chối — bắt buộc." Hộp không đóng, yêu cầu vẫn "Chờ duyệt". |
| 3 | Từ chối thành công | Nhập lý do rồi bấm "Từ chối yêu cầu" | Báo "Đã từ chối YC-NM1-2610-0022. Lô L-BOT-01 về trạng thái trước khi gửi; người gửi nhận thông báo kèm lý do." Trạng thái thành "Từ chối"; hai phần lô về Khóa; tab Chờ duyệt 4 → 3, Đã đóng 14 → 15; nhật ký "Từ chối — lô về trạng thái trước khi gửi". |
| 4 | Vai trò khác không từ chối được | `vaitro` = `Kế hoạch` (hoặc `QC`, `Thủ kho`) | Hộp thoại cuối hộp ghi "Việc của QC trưởng" và nút "Xem như QC trưởng"; không từ chối được. |
| 5 | Yêu cầu bổ sung thay cho từ chối | `hopthoai` = `bo-sung`, để trống rồi bấm gửi | Báo "Ghi rõ cần bổ sung gì — bắt buộc." Nhập nội dung rồi gửi: "Đã gửi yêu cầu bổ sung cho Lê Văn Hải. Lô giữ Chờ kiểm trong lúc chờ." Trạng thái thành "Yêu cầu bổ sung". |
| 6 | Sai trạng thái thì hộp không mở | `chon` = `YC-NM1-2610-0023` | Hộp thoại không mở (yêu cầu này không ở Chờ duyệt). |
| 7 | Kịch bản QC đang nhập | `kichban` = `qc-dang-nhap`, `chon` = `YC-NM1-2610-0021` | Hộp thoại không mở vì yêu cầu này đã ở "Đã duyệt · đang kiểm". |

#### 71 · Yêu cầu kiểm — Kế hoạch bổ sung yêu cầu B261018-02 (xung đột)
Mở board này để kiểm: yêu cầu kiểm sinh ra do xung đột khi nhà máy mất kết nối, QC trưởng đòi bổ sung và người gửi gửi lại.
Ô chỉnh trong "Trạng thái hiển thị": `vaitro` → `Kế hoạch` (mặc định), `QC trưởng`, `QC`, `Thủ kho`, `Thủ kho trưởng`, `Thủ kho điều phối`; `chon` → `YC-NM1-2610-0023` (mặc định); `hopthoai` → `khong` (mặc định), `gui-lai`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Nội dung xung đột | Mặc định | `YC-NM1-2610-0023`, trạng thái "Yêu cầu bổ sung", loại "Xung đột khi mất kết nối", lô B261018-02, 1.200 lon, người gửi Đỗ Minh Khang. Lý do kể: silo 1 của LSX-2610-0009 nạp bao lô L-BOT-01 lúc 09:18 khi ngoại tuyến, lệnh khóa lô từ trung tâm tới sau, lúc 10:24; mẻ 3 chạy 09:20–10:10. |
| 2 | Yêu cầu của QC trưởng | Xem khung ghi chú | Thẻ "QC trưởng yêu cầu bổ sung" của Trần Thị Mai, 18/10 10:50: "Gửi kèm số bao L-BOT-01 đã nạp vào silo 1 lúc 09:18 và giờ quét từng bao, để QC lấy mẫu đúng các thùng chiết đầu mẻ 3." Phần lô: Khu chiết rót NM1, trước đó Khóa · Xung đột khi mất kết nối, hiện Chờ kiểm. |
| 3 | Chỉ người gửi mới gửi lại | `vaitro` = `Kế hoạch`, bấm "Bổ sung & gửi lại" | Hộp thoại "Bổ sung & gửi lại" có ô "Nội dung bổ sung *" và ô tệp (không bắt buộc). |
| 4 | Thiếu nội dung | Để trống, bấm "Gửi lại" | Báo "Nhập nội dung bổ sung — bắt buộc." |
| 5 | Gửi lại thành công | Nhập nội dung rồi "Gửi lại" | Báo "Đã bổ sung và gửi lại YC-NM1-2610-0023. Yêu cầu quay về Chờ duyệt ở Việc cần làm của QC trưởng." Trạng thái "Chờ duyệt"; thêm ghi chú "Bên gửi bổ sung"; nhật ký "Bổ sung và gửi lại" do Đỗ Minh Khang. Thống kê: Chờ QC trưởng duyệt 4 → 5, Chờ bên gửi bổ sung 1 → 0. |
| 6 | Vai trò khác không gửi lại được | `vaitro` = `QC trưởng` (hoặc `QC`, `Thủ kho`, `Thủ kho trưởng`, `Thủ kho điều phối`) | Không có nút gửi lại; thay bằng "Việc của Kế hoạch · người gửi bổ sung" và nút "Xem như Kế hoạch". Dòng chờ: "Đang chờ Đỗ Minh Khang (Kế hoạch) bổ sung và gửi lại." |
| 7 | Mở sẵn hộp gửi lại | `hopthoai` = `gui-lai` | Hộp thoại gửi lại mở sẵn cho `YC-NM1-2610-0023`; đổi `chon` sang mã không ở "Yêu cầu bổ sung" thì hộp không mở. |
| 8 | Yêu cầu bổ sung từng xảy ra | `chon` = `YC-NM1-2610-0010` (đặt `screen` = `yc`) | Đã duyệt: nhật ký có QC trưởng Võ Thanh Hà yêu cầu bổ sung (12/10), Nguyễn Văn Tú bổ sung và gửi lại ("48 thùng · 1.152 lon, toàn bộ ở NM1-BTP", 13/10), rồi duyệt tạo phiếu `QC-NM1-2610-0058`. |

#### 72 · Phiếu kiểm — QC trưởng duyệt kết luận QC-NM1-2610-0058
Mở board này để kiểm: màn chi tiết phiếu kiểm đang chờ QC trưởng duyệt kết luận, quyền từng vai trò và hộp thoại duyệt.
Ô chỉnh trong "Trạng thái hiển thị": `screen` → `pk` (mặc định), `yc`; `vaitro` → `QC trưởng` (mặc định), `QC`, `Thủ kho`, `Kế hoạch`, `Thủ kho trưởng`, `Thủ kho điều phối`; `chon` → `QC-NM1-2610-0058` (mặc định) và các mã khác; `kichban`; `hopthoai` → `khong` (mặc định).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Chi tiết phiếu | Mặc định | `QC-NM1-2610-0058`, trạng thái "Chờ duyệt kết luận", lô B261011, BTP-0412 (nhãn kế hoạch SP-0001, thùng lon 800 g chưa QC). Lấy mẫu: Ngô Thu Trang 14/10 10:30, 2 lon kiểm nghiệm · 1 lon lưu, mẫu lưu `ML-NM1-2610-0030`. Hai file `KN-QC-2610-0058.pdf` và `KN-QC-2610-0058-vi-sinh.pdf`. QC đề xuất Đạt, gửi 17/10 09:50. Liên quan: truy xuất `TX-2610-0003`. |
| 2 | Chỉ QC trưởng thấy nút duyệt | Mặc định, rồi `vaitro` = `QC` | `QC trưởng` thấy nút "Duyệt kết luận". `QC` (và mọi vai trò khác) thấy "Việc của QC trưởng" cùng nút "Xem như QC trưởng"; không sửa được gì. |
| 3 | Dòng chờ | Xem cạnh nút | "QC đề xuất Đạt lúc gửi · 17/10 09:50 — QC trưởng xem file đánh giá bên ngoài rồi duyệt." |
| 4 | Duyệt Đạt | Bấm "Duyệt kết luận", giữ lựa chọn Đạt, bấm "Duyệt kết luận: Đạt" | Báo "Đã duyệt Đạt. Lô B261011 → Đạt, BTP đổi thành TP SP-0001 (cùng mã lô). Đã lập phiếu chứng nhận chờ ký — QC trưởng cấp số và ký ở Phiếu chứng nhận (tab Chờ ký); lô chưa giao được tới khi có phiếu ký." Phiếu thành "Đã duyệt", kết luận Đạt, người duyệt "Trần Thị Mai (QC trưởng ủy quyền)". Mục phiếu chứng nhận ghi "Đã lập phiếu chứng nhận chất lượng — chờ QC trưởng ký." và chưa có số CN. |
| 5 | Yêu cầu gốc đóng lại | Sau bước 4, đặt `screen` = `yc` (không đổi ô để khỏi mất dữ liệu: bấm tab "Yêu cầu kiểm") | `YC-NM1-2610-0010` thành "Đã kết luận"; nhật ký thêm "Kết luận Đạt (QC-NM1-2610-0058)". Thống kê phiếu: Chờ duyệt kết luận 1 → 0, Đã duyệt tháng 10 là 10 (Đạt 7). |
| 6 | Mục "Lối ra" khi không đạt | `chon` = `QC-NM1-2610-0063` | Đã duyệt Không đạt. Hiện "Lối ra sau kết luận" với ba nút: hủy phần trong kho (Sang Kho · hủy hàng), bù đơn bằng lệnh mới (Sang Lệnh sản xuất), đã giao một phần (Sang Hồ sơ thu hồi). Nút "Mở lại lô" không có vì đây là thành phẩm. |
| 7 | Nhật ký phiếu | Xem cuối trang | Dòng sau cùng được tô nổi bật; có nút "Xem tất cả" khi quá 5 dòng. |

#### 73 · Phiếu kiểm — hộp duyệt kết luận Đạt, lập phiếu chứng nhận chờ ký (BTP → TP)
Mở board này để kiểm: hộp thoại duyệt kết luận, bắt buộc ghi lý do khi khác đề xuất, và hậu quả được liệt kê trước khi duyệt.
Ô chỉnh trong "Trạng thái hiển thị": `hopthoai` → `duyet-kl` (mặc định), `khong`; `vaitro` → `QC trưởng` (mặc định), `QC`, `Thủ kho`, `Kế hoạch`, `Thủ kho trưởng`, `Thủ kho điều phối`; `chon` → `QC-NM1-2610-0058` (mặc định); `kichban` → `hom-nay`, `qc-dang-nhap`; `screen`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Hộp thoại mở sẵn | Mặc định | "Duyệt kết luận QC `QC-NM1-2610-0058`", lô B261011, hai file đánh giá ("2 file"). "QC đề xuất: Đạt — Ngô Thu Trang · theo 2 file đánh giá bên ngoài · gửi 17/10 09:50". Lựa chọn Đạt chọn sẵn; nút "Duyệt kết luận: Đạt" màu chính. |
| 2 | Hậu quả khi duyệt Đạt cho thành phẩm | Xem mục "Sau khi duyệt" | Bốn dòng: lô B261011 → Đạt ở phần đang Chờ kiểm (NM1-BTP · 1.152 lon); BTP-0412 đổi thành TP SP-0001 trên cùng mã lô; lập phiếu chứng nhận chờ ký (QC trưởng cấp số và ký ở Phiếu chứng nhận); có phiếu ký thì đơn hàng đủ lô Đạt chuyển Sẵn sàng giao. |
| 3 | Chọn kết luận khác đề xuất mà thiếu lý do | Chọn "Không đạt", bấm "Duyệt kết luận: Không đạt" | Hiện ô "Lý do kết luận khác đề xuất *". Báo "Kết luận khác đề xuất của QC — bắt buộc ghi lý do." Nút đổi màu đỏ. |
| 4 | Hậu quả khi không đạt | Vẫn chọn "Không đạt" | "Lô B261011 → Không đạt (NM1-BTP · 1.152 lon), chỉ có đường hủy." và "Báo Kế hoạch và Kho." |
| 5 | Duyệt khác đề xuất có lý do | Nhập lý do rồi bấm duyệt | Báo "Đã duyệt Không đạt. Lô B261011 → Không đạt, chỉ có đường hủy. Đã báo Kế hoạch và Kho — lối ra ở cuối phiếu." Lô đổi sang Không đạt; mục lý do của người duyệt hiện đúng chữ vừa nhập; nhật ký thêm "Duyệt kết luận Không đạt — lô → Không đạt". |
| 6 | Chưa có số phiếu chứng nhận sau khi duyệt Đạt | Duyệt Đạt rồi xem mục phiếu chứng nhận | Chỉ ghi "chờ QC trưởng ký". Không có mã `CN-NM1-...`. Nút "Xem / in phiếu chứng nhận" cũng chưa có. |
| 7 | Chỉ QC trưởng duyệt | `vaitro` = `QC` (hoặc vai trò khác) | Cuối hộp ghi "Việc của QC trưởng", nút "Xem như QC trưởng"; không duyệt được. |
| 8 | Lô nguyên liệu gần hết hạn (duyệt Đạt vẫn bị hạn chế) | Ở board 74 gửi phiếu `QC-NM1-2610-0060` cho QC trưởng, rồi ở bước duyệt chọn Đạt (khác đề xuất Không đạt nên phải ghi lý do) | Dòng hậu quả: "Lô L-PGA-09 → Đạt (NM1-TONG · 150,0 kg) nhưng còn 5 ngày, dưới ngưỡng tối thiểu cho SX (30 ngày) — không xuất SX / nạp silo được; vẫn chuyển kho, trả NCC hoặc hủy." Hộp duyệt chỉ mở khi phiếu đã ở Chờ duyệt kết luận. |

#### 74 · Phiếu kiểm — QC tải file đánh giá bên ngoài, kết quả vượt mức → đề xuất Không đạt
Mở board này để kiểm: QC tải file đánh giá bên ngoài, chọn đề xuất Đạt hoặc Không đạt rồi gửi QC trưởng; kịch bản QC đang nhập; lấy mẫu.
Ô chỉnh trong "Trạng thái hiển thị": `kichban` → `qc-dang-nhap` (mặc định), `hom-nay`; `vaitro` → `QC` (mặc định), `QC trưởng`, `Thủ kho`, `Kế hoạch`, `Thủ kho trưởng`, `Thủ kho điều phối`; `chon` → `QC-NM1-2610-0060` (mặc định), `QC-NM1-2610-0061`, `QC-NM1-2610-0059`; `hopthoai` → `khong` (mặc định), `lay-mau`; `screen`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Phiếu đang nhập, đề xuất nháp Không đạt | Mặc định (`QC-NM1-2610-0060`) | Lô L-PGA-09 (NVL), trạng thái "Đang kiểm". Mẫu lấy 18/10 10:40: 100 g kiểm nghiệm · 100 g lưu, mẫu lưu `ML-NM1-2610-0034` kèm "chờ niêm phong, cất tủ ở Mẫu lưu". Một file `KN-QC-2610-0060-ly-hoa.pdf`. Đề xuất đang chọn "Không đạt". Ghi chú nhập tay: "Mẫu lấy ở 3 bao: 2 bao có cục cứng 1–2 cm. Đã có phiếu lý hóa ngoài; phiếu vi sinh có 21/10." Ghi chú dưới file: "1 file · hệ thống chỉ lưu file, không đọc nội dung". |
| 2 | Hệ thống không tự so mức | Đọc kỹ cạnh nút đề xuất | Hệ thống chỉ lưu file và không so với giới hạn nào; QC tự chọn Đạt hay Không đạt dựa trên file (quy tắc: người tải không tự duyệt, QC trưởng duyệt). |
| 3 | Gửi QC trưởng | Bấm nút gửi duyệt khi có 1 file và đã chọn đề xuất | Báo "Đã gửi QC-NM1-2610-0060 cho QC trưởng duyệt." Phiếu thành "Chờ duyệt kết luận", dòng chờ "Đã gửi 18/10 ... — chờ QC trưởng duyệt kết luận. Người tải file không tự duyệt." Nhật ký: "Tải 1 file đánh giá bên ngoài · QC đề xuất Không đạt — gửi QC trưởng duyệt". |
| 4 | Thiếu file hoặc chưa chọn đề xuất | Đặt `chon` = `QC-NM1-2610-0059` (đã lấy mẫu, chưa có file); hoặc ở phiếu `-0060` bấm bỏ file | Nút gửi bị khóa; hiện "Tải ít nhất 1 file đánh giá bên ngoài rồi chọn đề xuất để gửi duyệt." |
| 5 | Tải file | Ở phiếu `-0059`, bấm chọn tệp và chọn một tệp bất kỳ | Tệp hiện trong danh sách kèm kích thước; ảnh có xem trước. Chọn đề xuất xong thì nút gửi mở. |
| 6 | Chưa lấy mẫu | Đặt `chon` = `QC-NM1-2610-0061`; hoặc `hopthoai` = `lay-mau` | Phiếu "Đang kiểm", "Chưa lấy mẫu". Hộp "Lấy mẫu" điền sẵn: mẫu kiểm nghiệm `2 lon`, mẫu lưu `1 lon`, nơi lưu mẫu "Tủ mẫu thành phẩm TM-01". |
| 7 | Thiếu lượng mẫu | Xóa ô lượng mẫu kiểm nghiệm, bấm lưu | Báo "Nhập lượng mẫu kiểm nghiệm và mẫu lưu." |
| 8 | Lấy mẫu thành công | Giữ giá trị mặc định, bấm lưu | Báo "Đã ghi lấy mẫu, cấp mã mẫu lưu ML-NM1-2610-0035." (ở `kichban` = `hom-nay` là `ML-NM1-2610-0034`). Nhật ký ghi "Lấy mẫu: 2 lon kiểm nghiệm · 1 lon lưu (…)". Chỉ vai trò `QC` lấy mẫu được; vai trò khác thấy "Việc của QC". |
| 9 | Vai trò không phải QC | `vaitro` = `QC trưởng` hoặc `Thủ kho` | Chỉ xem: không có ô tải file, không chọn đề xuất, không có nút gửi; vẫn thấy đề xuất nháp của QC. |
| 10 | Kịch bản `hom-nay` | `kichban` = `hom-nay` | Không có phiếu `QC-NM1-2610-0060`; `YC-NM1-2610-0021` còn "Chờ duyệt"; Đang kiểm 2 (không phải 3). |

#### 75 · Phiếu kiểm — mở lại lô NVL Không đạt
Mở board này để kiểm: QC trưởng mở lại lô nguyên liệu đã Không đạt khi có kết quả kiểm nghiệm ngoài đạt, bắt buộc ghi lý do và đính kèm file.
Ô chỉnh trong "Trạng thái hiển thị": `hopthoai` → `mo-lai` (mặc định), `khong`; `vaitro` → `QC trưởng` (mặc định), `QC`, `Thủ kho`, `Kế hoạch`, `Thủ kho trưởng`, `Thủ kho điều phối`; `chon` → `QC-NM1-2610-0044` (mặc định), `QC-NM1-2610-0062`, `QC-NM1-2610-0063`; `kichban`; `screen`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Hộp thoại mở lại | Mặc định (`QC-NM1-2610-0044`) | "Mở lại lô Không đạt": lô L-BOT-22 (Bột sữa gầy), hạn dùng 01/06/2027 · còn 226 ngày, phần đang Không đạt "NM1-TONG · 475,0 kg". Nhật ký giữ lần Không đạt. |
| 2 | Thiếu lý do | Để trống, bấm mở lại | Báo "Nhập lý do mở lại — bắt buộc." |
| 3 | Thiếu file kết quả | Nhập lý do, chưa gắn file, bấm mở lại | Báo "Đính kèm file kết quả kiểm nghiệm — bắt buộc." |
| 4 | Mở lại thành công | Nhập lý do, gắn một tệp, bấm mở lại | Báo "Đã mở lại lô L-BOT-22 → Đạt. Nhật ký giữ lần Không đạt của QC-NM1-2610-0044; báo Mua hàng và Kho." Khung "Đã mở lại lô → Đạt" hiện người mở (Trần Thị Mai), lý do, tên file. Ô thống kê "Lô NVL Không đạt còn trong kho" từ 1 xuống 0 ("Không có"). Nút "Mở lại lô" biến mất. |
| 5 | Trước khi mở lại: lối ra | `hopthoai` = `khong`, xem cuối phiếu | "Lối ra sau kết luận": "Trả NCC — Phiếu trả TH-NCC-2610-0003 · NCC đồng ý · chờ Kho xuất trả" (nút "Mở TH-NCC-2610-0003") và "Hoặc hủy phần còn trong kho" (nút "Sang Kho · hủy hàng"). Dòng "Có kết quả kiểm nghiệm ngoài đạt thì mở lại lô." |
| 6 | Lô đã mở lại từ trước | `chon` = `QC-NM1-2610-0062` | Kết luận ban đầu Không đạt (lý do khác đề xuất Đạt: vitamin D3 9,1 mg/kg…), khung mở lại ghi Trần Thị Mai, 16/10 14:00, file `KQ-kiem-nghiem-ngoai-L-PGA-12.pdf`; không còn nút mở lại. |
| 7 | Thành phẩm không mở lại được | `chon` = `QC-NM1-2610-0063` | Không có nút "Mở lại lô"; chỉ có ba lối ra (hủy, bù đơn, hồ sơ thu hồi). Quy tắc: chỉ nguyên liệu mới mở lại được; thành phẩm và BTP không đạt chỉ hủy. |
| 8 | Chỉ QC trưởng mở lại | `vaitro` = `QC` (hoặc vai trò khác) ở `QC-NM1-2610-0044` | Nút "Mở lại lô" bị thay bằng "Việc của QC trưởng" và "Xem như QC trưởng". |

#### 76 · Phiếu kiểm — đã duyệt, phiếu chứng nhận CN-NM1-2610-0018 đã ký riêng, xem / in
Mở board này để kiểm: phiếu kiểm đã duyệt có phiếu chứng nhận đã ký riêng, và bản phiếu chứng nhận in từ đây.
Ô chỉnh trong "Trạng thái hiển thị": `hopthoai` → `xem-cn` (mặc định), `khong`; `chon` → `QC-NM1-2610-0055` (mặc định), `QC-NM1-2610-0056`, `QC-NM1-2610-0057`; `vaitro`; `kichban`; `screen`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Bản phiếu chứng nhận đã ký | Mặc định | Khung "Phiếu chứng nhận chất lượng `CN-NM1-2610-0018`" kiểu A4. Sản phẩm SP-0001 · Nhãn A · Sữa bột trẻ em Số 3 · 800 g; số lô A261011; HSD 11/10/2028; phiếu kiểm `QC-NM1-2610-0055`; lấy mẫu "12/10 14:00 · Ngô Thu Trang"; mẫu lưu `ML-NM1-2610-0027`; một dòng file `KN-QC-2610-0055.pdf`; "ĐÃ KÝ ĐIỆN TỬ" Trần Thị Mai, 15/10 16:40. |
| 2 | Số lượng trên bản in | Xem dòng "Số lượng lô" | Khung này hiện "2 lon", còn phiếu chứng nhận gốc ở board 81 ghi "24 lon" (xem mục lệch cuối phần). Hai nơi nên cùng một số. |
| 3 | In | Bấm "In / tải PDF" | Báo "Đã gửi lệnh in phiếu chứng nhận CN-NM1-2610-0018 — bản PDF lưu kèm phiếu kiểm QC-NM1-2610-0055." |
| 4 | Đóng | Bấm "✕ Đóng" | Khung đóng lại; vẫn ở phiếu kiểm. Chi tiết phiếu ghi "Phiếu chứng nhận chất lượng CN-NM1-2610-0018 — đã ký điện tử · Trần Thị Mai · 15/10 16:40" và nút "Xem / in phiếu chứng nhận". |
| 5 | Ngày ký tách khỏi ngày duyệt | Xem nhật ký phiếu | Duyệt kết luận Đạt 15/10 16:05; ký phiếu chứng nhận, cấp số `CN-NM1-2610-0018`, lúc 15/10 16:40 (ký là bước riêng, sau duyệt). Có thêm dòng 17/10 10:20 khoanh vùng lô theo `TH-2610-0003`. |
| 6 | Phiếu chờ ký chưa có bản in ở đây | `chon` = `QC-NM1-2610-0056` hoặc `-0057` | Mục phiếu chứng nhận ghi "Đã lập phiếu chứng nhận chất lượng — chờ QC trưởng ký" kèm nút "Mở Phiếu chứng nhận" (sang màn Phiếu chứng nhận); không có số CN; khung A4 không hiện dù `hopthoai` = `xem-cn`. |
| 7 | Phiếu chưa duyệt không có khung | `chon` = `QC-NM1-2610-0058` | Không hiện khung phiếu chứng nhận. |

#### 77 · Chất lượng — Phiếu chứng nhận (danh sách, QC trưởng)
Mở board này để kiểm: danh sách phiếu chứng nhận với tab Chờ ký và Đã ký, quyền ký riêng của QC trưởng, và các trạng thái hiển thị của cả hai màn.
Ô chỉnh trong "Trạng thái hiển thị": `screen` → `cn` (mặc định), `ml`; `vaitro` → `QC trưởng` (mặc định), `QC`, `Thủ kho trưởng`, `Kế hoạch`, `Sales`; `trangthai` → `danh-sach` (mặc định), `ban-in-cho-ky`, `ky`, `da-ky`, `ban-in-da-ky` (cho `screen` = `cn`), `can-huy`, `huy-mau`, `chi-tiet-mau`, `lay-ra`, `ghi-mau`, `da-huy` (cho `screen` = `ml`). Ô `trangthai` chỉ được đọc khi board mở; nếu đổi mà màn không đổi thì làm mới board.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Tab và số liệu | Mặc định | Bốn ô: Chờ ký 2; Đã ký 8; Đã dùng ở giao hàng 7; Sắp có phiếu 7. Tab: Chờ ký 2, Đã ký 8, Tất cả 10. Thanh thông báo "Đang giữ vai trò ủy quyền QC trưởng — thay Võ Thanh Hà, 15/10 → 21/10/2026." |
| 2 | Phiếu chờ ký chưa có số | Xem tab Chờ ký | Hai dòng: lô B261013 (SP-0002, `QC-NM1-2610-0057`, "Đạt · 2 file đánh giá") và lô B261012 (SP-0001, `QC-NM1-2610-0056`, "Đạt · 1 file đánh giá"). Cột số phiếu ghi "— cấp số khi ký", trạng thái "Chờ ký", giao hàng "Chưa giao được". Có nút ký ở mỗi dòng. |
| 3 | Bảng "Sắp có phiếu" | Cuộn xuống | Bảy lô BTP đang trong QC thành phẩm, ví dụ B261011 "Chờ QC trưởng duyệt kết luận" (`QC-NM1-2610-0058`), B261015 "Đang kiểm" (`QC-NM1-2610-0059`), A260920 "Đang kiểm · chưa lấy mẫu" (`QC-NM1-2610-0061`), B261018-02 "Kiểm lại lô xung đột" (`YC-NM1-2610-0023`). |
| 4 | Tìm kiếm | Gõ `B261013` vào ô tìm | Chỉ còn dòng của lô B261013. Gõ mã không có thì báo "Không có phiếu khớp điều kiện lọc." |
| 5 | Vai trò chỉ xem | `vaitro` = `QC`, rồi `Kế hoạch`, rồi `Sales` | Không có nút ký; có dòng "Bạn xem và in phiếu đã ký. Việc của QC trưởng" và nút "Xem như QC trưởng". |
| 6 | Vai trò không được vào màn này | `vaitro` = `Thủ kho trưởng` | Thanh cảnh báo "Vai trò Thủ kho trưởng không có quyền vào màn này." với liên kết "Về Việc cần làm". |
| 7 | Chuyển sang mẫu lưu | `screen` = `ml` | Màn Mẫu lưu (xem board 78); với `QC trưởng` có cảnh báo không có quyền vào màn này, vì QC trưởng không nằm trong danh sách vai trò của màn Mẫu lưu. |
| 8 | Các trạng thái của màn phiếu | Lần lượt `trangthai` = `ban-in-cho-ky`, `ky`, `da-ky`, `ban-in-da-ky` | `ban-in-cho-ky`: bản in lô B261013 chưa ký (board 79). `ky`: hộp ký phiếu (board 80). `da-ky`: tab Đã ký. `ban-in-da-ky`: bản in `CN-NM1-2610-0018` (board 81). |

#### 78 · Chất lượng — Mẫu lưu (danh sách, QC)
Mở board này để kiểm: danh sách mẫu lưu, các tab Đang lưu, Cần hủy, Đã hủy và quyền hủy riêng của QC.
Ô chỉnh trong "Trạng thái hiển thị": `screen` → `ml` (mặc định), `cn`; `vaitro` → `QC` (mặc định), `QC trưởng`, `Thủ kho trưởng`, `Kế hoạch`, `Sales`; `trangthai` → `danh-sach` (mặc định), `can-huy`, `huy-mau`, `chi-tiet-mau`, `lay-ra`, `ghi-mau`, `da-huy`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Số liệu đầu trang | Mặc định | "Mẫu lưu theo lô ở kho NM1-MAUQC". Bốn ô: Đang lưu 21; Cần hủy 3 ("2 hết hạn lưu · 1 theo phiếu hủy lô"); Sắp hết hạn lưu 1 ("Còn ≤ 30 ngày"); Đã hủy 2. Tab: Đang lưu 21, Cần hủy 3, Đã hủy 2. |
| 2 | Cảnh báo cho QC | Xem đầu danh sách | "Cần hủy: 2 mẫu đã hết hạn lưu, 1 mẫu cần hủy theo phiếu hủy lô PH-NM1-2610-0018." và nút "Xem mẫu cần hủy". |
| 3 | Từng loại trạng thái trong danh sách | Đọc cột Trạng thái | `ML-NM1-2610-0033` "Hủy theo lô"; `ML-NM1-2610-0027` và `ML-NM1-2609-0028` "Giữ · hồ sơ thu hồi"; `ML-NM1-2507-0012` "Đang mở đánh giá"; `ML-NM1-2411-0003` "Sắp hết hạn" (còn 18 ngày); `ML-NM1-2410-0014` "Hết hạn lưu" (quá 3 ngày); `ML-NM1-2410-0013` "Hết hạn lưu" (hết hạn hôm nay); các mẫu còn lại "Đang lưu". |
| 4 | Lọc | Chọn "Nguyên vật liệu" ở ô loại mẫu, rồi gõ mã lô | Chỉ còn mẫu NVL (các lô L-...); ô tìm lọc theo mã mẫu, lô, mặt hàng, phiếu kiểm. |
| 5 | Chỉ QC thấy nút thao tác | `vaitro` = `QC trưởng`, `Kế hoạch`, `Sales`, `Thủ kho trưởng` | Không có "+ Ghi mẫu lưu", ô chọn dòng hay nút hủy; thay bằng "Việc của QC" và "Xem như QC". Cả bốn vai trò này còn thấy thanh "Vai trò … không có quyền vào màn này." |
| 6 | Các trạng thái của màn | Lần lượt `trangthai` = `can-huy`, `huy-mau`, `chi-tiet-mau`, `lay-ra`, `ghi-mau`, `da-huy` | `can-huy`: tab Cần hủy (board 82). `huy-mau`: hộp hủy hai mẫu (board 83). `chi-tiet-mau`: chi tiết `ML-NM1-2610-0027` (board 84). `lay-ra`: hộp lấy ra đánh giá (board 85). `ghi-mau`: hộp ghi mẫu lưu (board 86). `da-huy`: tab Đã hủy với `ML-NM1-2409-0004` (biên bản `BB-ML-2609-0002`) và `ML-NM1-2609-0015` (biên bản `BB-ML-2609-0003`). |

#### 79 · Phiếu chứng nhận — bản in chờ ký, chưa có số (B261013, QC trưởng)
Mở board này để kiểm: bản in A4 của phiếu chứng nhận ở trạng thái chờ ký, đối chiếu từng ô với phiếu kiểm gốc.
Ô chỉnh trong "Trạng thái hiển thị": `screen` → `cn` (mặc định), `ml`; `vaitro` → `QC trưởng` (mặc định), `QC`, `Thủ kho trưởng`, `Kế hoạch`, `Sales`; `trangthai` → `ban-in-cho-ky` (mặc định) và 10 giá trị còn lại.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Số phiếu và dấu chưa ký | Mặc định | Đầu phiếu "Số phiếu Cấp số khi ký" (không có mã CN). Dấu "CHƯA KÝ"; chân phiếu "CHỜ QC TRƯỞNG KÝ — Phiếu chưa ký không dùng để giao hàng". Trạng thái "Chờ ký". |
| 2 | Ô sản phẩm và lô khớp phiếu kiểm `QC-NM1-2610-0057` | Đối chiếu | Sản phẩm SP-0002 · Nhãn B — Sữa bột trẻ em Số 3 · lon 800 g; số lô B261013; ngày sản xuất 13/10/2026; HSD 13/10/2028; số lượng lô 1.152 lon. |
| 3 | Ô lấy mẫu và mẫu lưu | Đối chiếu | Lấy mẫu "14/10/2026 · Ngô Thu Trang"; mẫu lưu `ML-NM1-2610-0029`; phiếu kiểm `QC-NM1-2610-0057`. |
| 4 | Ô kết luận | Đối chiếu | "Kết luận Đạt"; QC trưởng duyệt "Trần Thị Mai · 17/10/2026 16:20" (khớp ngày duyệt trên phiếu kiểm). |
| 5 | Bảng file đính kèm | Đối chiếu với phiếu kiểm | Phiếu này liệt kê 2 file: `KN-QC-2610-0057-hoa-ly.pdf` (PDF) và `KN-QC-2610-0057-vi-sinh.jpg` (Ảnh), người tải Ngô Thu Trang; dòng kết luận "ĐẠT — theo 2 file đánh giá bên ngoài đính kèm". Phiếu kiểm gốc ở board 68 và 72 chỉ ghi 1 file (xem mục lệch). |
| 6 | Nút ký chỉ cho QC trưởng | `vaitro` = `QC trưởng`, rồi `QC` | `QC trưởng` thấy nút "Ký phiếu". `QC` thấy "Việc của QC trưởng", nút "Xem như QC trưởng" và dòng "Chờ QC trưởng ký." Cả hai không có nút "Tải PDF" hay "In phiếu" vì phiếu chưa ký. |
| 7 | Phiếu chưa ký chưa dùng giao hàng | Xem cuối trang | "Lô chưa giao được — phiếu chưa ký." và "Chưa gửi kèm phiếu xuất bán nào." Ghi chú lô: "NM1-BTP 1.152 lon · chưa giao được, chờ phiếu ký". |

#### 80 · Phiếu chứng nhận — hộp ký phiếu chờ ký: QC trưởng ký, cấp số
Mở board này để kiểm: hộp ký riêng sau khi duyệt kết luận, số phiếu chỉ được cấp khi ký.
Ô chỉnh trong "Trạng thái hiển thị": `screen` → `cn` (mặc định), `ml`; `vaitro` → `QC trưởng` (mặc định), `QC`, `Thủ kho trưởng`, `Kế hoạch`, `Sales`; `trangthai` → `ky` (mặc định) và 10 giá trị còn lại.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Hộp ký mở sẵn | Mặc định | "Ký phiếu chứng nhận — lô B261013": sản phẩm SP-0002 · Nhãn B — Sữa bột trẻ em Số 3 · lon 800 g; NSX · HSD 13/10/2026 · 13/10/2028; phiếu kiểm `QC-NM1-2610-0057` · 2 file đánh giá bên ngoài; kết luận Đạt Trần Thị Mai · 17/10/2026 16:20. Dòng "Số phiếu được cấp khi ký": `CN-NM1-2610-0019`. |
| 2 | Chưa đánh dấu đã xem file | Bấm "Ký phiếu" khi chưa tích ô xác nhận | Báo "Đánh dấu đã xem file đánh giá bên ngoài trước khi ký." Phiếu vẫn "Chờ ký", chưa có số. |
| 3 | Ký thành công | Tích "Tôi đã xem file đánh giá bên ngoài…", bấm "Ký phiếu" | Báo "Đã ký CN-NM1-2610-0019 — lô B261013 được phép giao." Phiếu thành "Đã ký" mang số `CN-NM1-2610-0019`, người ký Trần Thị Mai (QC trưởng ủy quyền thay Võ Thanh Hà). Tab Chờ ký 2 → 1, Đã ký 8 → 9. Nhật ký: "Ký phiếu CN-NM1-2610-0019 (QC trưởng ủy quyền) — lô được phép giao" và "Lưu bản PDF CN-NM1-2610-0019.pdf; báo Kế hoạch, Kho, Sales". Ghi chú lô đổi thành "… giao được". |
| 4 | Số tiếp theo | Ký tiếp phiếu lô B261012 | Số cấp là `CN-NM1-2610-0020` (không trùng, không nhảy). |
| 5 | Chỉ QC trưởng ký | `vaitro` = `QC` (hoặc `Kế hoạch`, `Sales`) | Hộp ký mở nhưng cuối hộp ghi "Việc của QC trưởng" và nút "Xem như QC trưởng"; không ký được. |
| 6 | Hủy hộp | Bấm "Hủy" | Hộp đóng; phiếu vẫn "Chờ ký", chưa có số. |

#### 81 · Phiếu chứng nhận — đã ký CN-NM1-2610-0018, dùng khi xuất bán (QC xem)
Mở board này để kiểm: bản in A4 của phiếu đã ký, các lần phiếu được gửi kèm khi giao hàng, và đối chiếu với phiếu kiểm gốc.
Ô chỉnh trong "Trạng thái hiển thị": `screen` → `cn` (mặc định), `ml`; `vaitro` → `QC` (mặc định), `QC trưởng`, `Thủ kho trưởng`, `Kế hoạch`, `Sales`; `trangthai` → `ban-in-da-ky` (mặc định) và 10 giá trị còn lại.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Số phiếu và dấu đã ký | Mặc định | Số phiếu `CN-NM1-2610-0018`, trạng thái "Đã ký". "ĐÃ KÝ ĐIỆN TỬ" 15/10/2026 16:40, Trần Thị Mai, "QC trưởng (ủy quyền thay Võ Thanh Hà)". Tệp phiếu `CN-NM1-2610-0018.pdf`. |
| 2 | Ô khớp phiếu kiểm `QC-NM1-2610-0055` | Đối chiếu | Sản phẩm SP-0001 · Nhãn A — Sữa bột trẻ em Số 3 · lon 800 g; số lô A261011; sản xuất 11/10/2026; HSD 11/10/2028; số lượng lô 24 lon; lấy mẫu "12/10/2026 · Ngô Thu Trang"; mẫu lưu `ML-NM1-2610-0027`; kết luận Trần Thị Mai · 15/10/2026 16:05; một file `KN-QC-2610-0055.pdf`. |
| 3 | Lô hiện tại sau khi đã giao | Xem "Lô hiện tại" | "Khóa — Khoanh vùng · TH-2610-0003 từ 17/10 10:20 · NM1-BTP còn 2 lon". Phiếu đã ký vẫn hiện nhưng lô bị khóa theo hồ sơ thu hồi. Liên quan: `TH-2610-0003`, `TX-2610-0003`. |
| 4 | Lần giao kèm phiếu | Xem "Giao kèm phiếu" | Một dòng: 16/10/2026 · Đại lý Minh Phát `KH-0007` · đơn `ĐH-2610-0019` · 20 lon. Dòng ghi nhãn "biên bản" nhưng mã là `PX-NM1-2610-0035` (phiếu xuất) — xem mục lệch. |
| 5 | Tải PDF và in | Bấm "Tải PDF", rồi "In phiếu" | Báo "Đang tải CN-NM1-2610-0018.pdf kèm 1 file đánh giá bên ngoài." và "Đã gửi CN-NM1-2610-0018.pdf kèm 1 file đánh giá bên ngoài tới máy in." |
| 6 | Vai trò chỉ xem và in | `vaitro` = `QC`, `Kế hoạch`, `Sales`, `QC trưởng` | Tất cả xem và in được; không ai ký lại (phiếu đã ký không có nút "Ký phiếu"). |
| 7 | Phiếu đã ký nhưng lô khóa hoặc đã hết hạn | Mở tab Đã ký, bấm `CN-NM1-2609-0017` và `CN-NM1-2410-0012` | `CN-NM1-2609-0017`: lô A260912 Khóa theo thu hồi `TH-2609-0005`; nhật ký ghi "phiếu chỉ còn giá trị lưu hồ sơ". `CN-NM1-2410-0012`: lô A241012 Khóa · hết hạn dùng, đề nghị hủy `PH-NM1-2610-0012`, cũng "chỉ còn giá trị lưu hồ sơ". |
| 8 | Phiếu đã dùng nhiều lần | Bấm `CN-NM1-2507-0009` | Hai lần giao: `PX-NM1-2508-0006` (Siêu thị Bách hóa Phương Đông, 480 lon, 05/08/2025) và `PX-NM1-2511-0019` (Đại lý Tâm An, 240 lon, 12/11/2025). |

#### 82 · Mẫu lưu — cần hủy (hết hạn lưu + theo phiếu hủy lô)
Mở board này để kiểm: tab Cần hủy gom các mẫu đến hạn hủy theo từng nhóm và QC chọn nhiều mẫu để hủy chung.
Ô chỉnh trong "Trạng thái hiển thị": `screen` → `ml` (mặc định), `cn`; `vaitro` → `QC` (mặc định), `QC trưởng`, `Thủ kho trưởng`, `Kế hoạch`, `Sales`; `trangthai` → `can-huy` (mặc định) và 10 giá trị còn lại.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Nhóm mẫu cần hủy | Mặc định | Ba nhóm: "Hết hạn lưu" gồm `ML-NM1-2410-0014` (hạn 15/10/2026, quá 3 ngày) rồi `ML-NM1-2410-0013` (hạn 18/10/2026, hết hạn hôm nay); "Lô đã có phiếu hủy được xác nhận" gồm `ML-NM1-2610-0033` (lô B261014, `PH-NM1-2610-0018 · Đã xác nhận`); "Lô đang chờ xác nhận phiếu hủy — chưa hủy mẫu" gồm `ML-NM1-2410-0010` (`PH-NM1-2610-0012 · Chờ xác nhận`). |
| 2 | Mẫu chờ xác nhận chưa được chọn | Xem dòng `ML-NM1-2410-0010` | Không có ô chọn và không có nút hủy; chỉ ba dòng trên (mỗi dòng đã đến hạn) có ô chọn. |
| 3 | Mẫu giữ theo thu hồi không vào đây | Xem danh sách | `ML-NM1-2610-0027`, `ML-NM1-2609-0028`, `ML-NM1-2608-0018` không nằm ở tab Cần hủy vì đang giữ theo hồ sơ thu hồi. |
| 4 | Chọn nhiều mẫu | Chọn ô của `ML-NM1-2410-0014` và `ML-NM1-2410-0013` | Thanh "Đã chọn 2" và nút "Hủy mẫu đã chọn"; khi chưa chọn hiện "Chọn nhiều mẫu để hủy chung một biên bản." |
| 5 | Chỉ QC thấy ô chọn | `vaitro` = `QC trưởng` (hoặc vai trò khác) | Không có ô chọn, không có nút hủy, không có cảnh báo đầu trang; có thanh "Vai trò … không có quyền vào màn này." |
| 6 | Tab số liệu | Xem nhãn tab | Tab "Cần hủy 3" tô đỏ; không tính mẫu đang chờ xác nhận. |

#### 83 · Mẫu lưu — hủy mẫu hết hạn, lập biên bản
Mở board này để kiểm: hộp hủy mẫu, hai tab "Mẫu hủy" và "Biên bản", ô bắt buộc và kết quả sau khi hủy.
Ô chỉnh trong "Trạng thái hiển thị": `screen` → `ml` (mặc định), `cn`; `vaitro` → `QC` (mặc định), `QC trưởng`, `Thủ kho trưởng`, `Kế hoạch`, `Sales`; `trangthai` → `huy-mau` (mặc định) và 10 giá trị còn lại.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Hộp hủy mở sẵn | Mặc định | "Hủy 2 mẫu lưu, lập biên bản"; hai ô chọn của `ML-NM1-2410-0014` và `ML-NM1-2410-0013` đã đánh dấu. Tab "Mẫu hủy" liệt kê mã mẫu, lô A241015 và A241018, số lượng 1 lon, lý do "Hết hạn lưu 15/10/2026" và "Hết hạn lưu 18/10/2026". Người hủy "Ngô Thu Trang (QC)"; mã biên bản dự kiến `BB-ML-2610-0001`. Nút "Hủy 2 mẫu". |
| 2 | Thiếu cách hủy và file biên bản | Bấm "Hủy 2 mẫu" khi chưa điền | Báo "Chọn cách hủy." và "Đính kèm biên bản hủy."; hộp nhảy sang tab "Biên bản" (tab có chấm lỗi). |
| 3 | Chỉ thiếu file | Chọn cách hủy ("Đổ bỏ, thu gom theo quy trình chất thải nhà máy" hoặc "Chuyển khu hàng hủy, hủy cùng lô"), chưa gắn file | Chỉ còn báo "Đính kèm biên bản hủy." (ảnh hoặc PDF có chữ ký). |
| 4 | Hủy thành công | Chọn cách hủy, nhập người chứng kiến, gắn file, bấm "Hủy 2 mẫu" | Báo "Đã hủy 2 mẫu, biên bản BB-ML-2610-0001." Hai mẫu sang tab Đã hủy (2 → 4), tab Cần hủy 3 → 1, Đang lưu 21 → 19. Nhật ký mẫu: "Hủy mẫu (hết hạn lưu 15/10/2026), lập biên bản BB-ML-2610-0001". |
| 5 | Hủy cả mẫu thuộc lô đang hủy | Chọn thêm `ML-NM1-2610-0033` trong tab Cần hủy rồi mở hộp hủy | Hộp ghi "Có mẫu thuộc lô đang hủy theo phiếu PH-NM1-2610-0018." Sau khi hủy, báo thêm "Đã báo Kho: PH-NM1-2610-0018 sang bước thực hiện hủy." |
| 6 | Mẫu giữ theo hồ sơ thu hồi không hủy được | Mở chi tiết `ML-NM1-2610-0027` | Nút "Hủy mẫu, lập biên bản" bị khóa, ghi "Đang giữ theo hồ sơ thu hồi." |
| 7 | Vai trò không phải QC | `vaitro` = `QC trưởng` | Hộp thoại (nếu mở) cuối ghi "Việc của QC" và nút "Xem như QC"; không hủy được. |

#### 84 · Mẫu lưu — chi tiết mẫu đã lấy ra đánh giá
Mở board này để kiểm: màn chi tiết một mẫu lưu và lịch sử lấy ra, niêm phong lại, sửa hạn lưu.
Ô chỉnh trong "Trạng thái hiển thị": `screen` → `ml` (mặc định), `cn`; `vaitro` → `QC` (mặc định), `QC trưởng`, `Thủ kho trưởng`, `Kế hoạch`, `Sales`; `trangthai` → `chi-tiet-mau` (mặc định) và 10 giá trị còn lại.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Chi tiết `ML-NM1-2610-0027` | Mặc định | Mẫu lưu của lô A261011 · SP-0001; trạng thái "Giữ · hồ sơ thu hồi". Phiếu kiểm `QC-NM1-2610-0055`; lấy mẫu "12/10/2026 14:00 · Ngô Thu Trang"; niêm phong 17/10/2026 10:05; HSD của lô 11/10/2028; hạn lưu 11/04/2029; gợi ý HSD + 6 tháng = 11/04/2029. Liên quan `TX-2610-0003` và `TH-2610-0003`. Khung "Giữ mẫu theo hồ sơ thu hồi `TH-2610-0003` — không hủy đến khi đóng hồ sơ (lưu ≥ HSD + 12 tháng)". |
| 2 | Lịch sử đã lấy ra và niêm phong lại | Xem nhật ký | 17/10 09:40 mở niêm phong để đánh giá — truy xuất `TX-2610-0003` (QC nghi lỗi: độ ẩm); 17/10 10:05 niêm phong lại, kết quả "độ ẩm đo lại 5,4 % — vượt mức cho phép theo phiếu kiểm nghiệm"; 17/10 10:20 khoanh vùng lô, chặn hủy mẫu lưu. |
| 3 | Thao tác còn lại với mẫu đã niêm phong | Xem khung "Thao tác" | Có "Lấy mẫu ra đánh giá" và "Sửa hạn lưu"; nút "Hủy mẫu, lập biên bản" khóa kèm "Đang giữ theo hồ sơ thu hồi." Không có "Niêm phong lại" vì mẫu đang đóng. |
| 4 | Mẫu đang mở đánh giá | Quay danh sách (nút "← Danh sách mẫu lưu") và mở `ML-NM1-2507-0012` | Trạng thái "Đang mở đánh giá", niêm phong ghi "Đang mở để đánh giá". Có "Niêm phong lại" và "Sửa hạn lưu"; không có "Lấy mẫu ra đánh giá". Nhật ký: mở niêm phong theo yêu cầu của cơ quan quản lý (CV 1186/ATTP-HK ngày 15/10/2026). |
| 5 | Sửa hạn lưu | Bấm "Sửa hạn lưu" ở mẫu đang lưu bình thường (ví dụ `ML-NM1-2610-0029`) | Hộp có "Hạn lưu *" (điền sẵn 13/04/2029), dòng "HSD lô 13/10/2028 · gợi ý HSD + 6 tháng = 13/04/2029", nút "Dùng gợi ý", ô "Lý do thay đổi". |
| 6 | Hạn lưu bỏ trống | Xóa ô hạn lưu, bấm "Lưu" | Ô hạn lưu báo "Bắt buộc." |
| 7 | Sửa hạn lưu thành công | Đổi sang ngày khác, nhập lý do, bấm "Lưu" | Báo "ML-NM1-2610-0029: đã lưu thay đổi." Hạn lưu mới hiện ở chi tiết; nhật ký "Sửa hạn lưu 13/04/2029 → … — (lý do)". Không đổi ngày thì hộp tự đóng, không có thông báo. |
| 8 | Mẫu hủy bình thường chưa hủy được | Mở `ML-NM1-2610-0029` | Nút hủy khóa, ghi "Hủy được khi hết hạn lưu (còn 908 ngày) hoặc khi lô có phiếu hủy đã được Thủ kho trưởng xác nhận." |

#### 85 · Mẫu lưu — lấy mẫu ra đánh giá
Mở board này để kiểm: hộp lấy mẫu lưu ra đánh giá (không cần duyệt), rồi niêm phong lại và ghi kết quả.
Ô chỉnh trong "Trạng thái hiển thị": `screen` → `ml` (mặc định), `cn`; `vaitro` → `QC` (mặc định), `QC trưởng`, `Thủ kho trưởng`, `Kế hoạch`, `Sales`; `trangthai` → `lay-ra` (mặc định) và 10 giá trị còn lại.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Hộp mở sẵn | Mặc định | "Lấy mẫu ra đánh giá — `ML-NM1-2610-0029`", lô B261013, mặt hàng Nhãn B (SP-0002). Ô "Lý do *" chọn một trong: Khiếu nại của khách hàng; Truy xuất — QC nghi lỗi; Thu hồi sản phẩm; Cơ quan quản lý yêu cầu; + Khác. Có ô "Chứng từ liên quan" và "Ghi chú". |
| 2 | Thiếu lý do | Bấm "Ghi lấy mẫu ra" khi chưa chọn lý do | Ô lý do báo "Chọn lý do." |
| 3 | Lấy ra thành công | Chọn "Truy xuất — QC nghi lỗi", nhập chứng từ `TX-2610-0003`, bấm "Ghi lấy mẫu ra" | Báo "ML-NM1-2610-0029: đã ghi lấy mẫu ra đánh giá. Đánh giá xong thì niêm phong lại." Trạng thái mẫu thành "Đang mở đánh giá", niêm phong "Đang mở để đánh giá"; nhật ký "Mở niêm phong để đánh giá — Truy xuất — QC nghi lỗi (TX-2610-0003)". Không cần ai duyệt. |
| 4 | Niêm phong lại thiếu kết quả | Bấm "Niêm phong lại", để trống, xác nhận | Ô kết quả báo "Nhập kết quả đánh giá." |
| 5 | Niêm phong lại thành công | Nhập kết quả (ví dụ "độ ẩm 4,6 %"), xác nhận | Báo "ML-NM1-2610-0029: đã niêm phong lại." Trạng thái mẫu về "Đang lưu", niêm phong ghi giờ vừa bấm; nhật ký "Niêm phong lại · kết quả đánh giá: …". |
| 6 | Chỉ QC thao tác | `vaitro` = `QC trưởng` (hoặc vai trò khác) | Cuối hộp ghi "Việc của QC" và nút "Xem như QC"; không ghi được. Nền màn có thanh "không có quyền vào màn này". |

#### 86 · Mẫu lưu — ghi mẫu lưu mới
Mở board này để kiểm: ghi mẫu lưu mới cho lô đã lấy mẫu ở Phiếu kiểm, mã mẫu đã được cấp sẵn từ lúc lấy mẫu.
Ô chỉnh trong "Trạng thái hiển thị": `screen` → `ml` (mặc định), `cn`; `vaitro` → `QC` (mặc định), `QC trưởng`, `Thủ kho trưởng`, `Kế hoạch`, `Sales`; `trangthai` → `ghi-mau` (mặc định) và 10 giá trị còn lại.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Hộp ghi mẫu mở sẵn | Mặc định | "Ghi mẫu lưu", mã mẫu `ML-NM1-2610-0031` (cấp từ lúc lấy mẫu). Lô B261015 chọn sẵn; BTP-0412 phiếu kiểm `QC-NM1-2610-0059`, HSD 15/10/2028, lấy mẫu "18/10/2026 08:40 · Ngô Thu Trang". Số lượng mẫu `1` (đơn vị lon). Hạn lưu điền sẵn 15/04/2029, gợi ý "= 15/04/2029". Mã này trùng với mẫu đang "chờ niêm phong" ở phiếu `QC-NM1-2610-0059`. |
| 2 | Thiếu lô | Mở hộp từ nút "+ Ghi mẫu lưu", chưa chọn lô, bấm "Lưu mẫu, niêm phong" | Ô lô báo "Chọn lô." |
| 3 | Số lượng sai | Xóa số lượng hoặc nhập `0` rồi lưu | Báo "Nhập số lượng > 0." |
| 4 | Thiếu hạn lưu | Xóa ô hạn lưu rồi lưu | Báo "Bắt buộc." |
| 5 | Ghi thành công | Giữ giá trị mặc định, bấm "Lưu mẫu, niêm phong" | Báo "Đã ghi mẫu lưu ML-NM1-2610-0031 cho lô B261015 — niêm phong." Mẫu mới đứng đầu tab Đang lưu (21 → 22) với số lượng 1 lon, hạn lưu 15/04/2029. Nhật ký: "Lấy 2 mẫu: 1 kiểm nghiệm (QC-NM1-2610-0059), 1 lưu — cấp mã ML-NM1-2610-0031 ở phiếu kiểm" rồi "Ghi mẫu lưu ML-NM1-2610-0031, niêm phong · hạn lưu 15/04/2029". |
| 6 | Hết lô để ghi | Mở lại hộp ghi mẫu sau bước 5 | Danh sách lô để chọn trống (chỉ có một lô chờ niêm phong trong dữ liệu mẫu). |
| 7 | Chỉ QC ghi | `vaitro` = `QC trưởng` (hoặc vai trò khác) | Không có nút "+ Ghi mẫu lưu"; thay bằng "Việc của QC" và "Xem như QC"; hộp thoại nếu mở cũng ghi "Việc của QC". |

#### Mã mẫu dùng trong phần này (Chất lượng)
| Mã | Là gì | Xuất hiện ở board | Giá trị phải khớp (trạng thái, số lượng, tiền...) |
|---|---|---|---|
| `YC-NM1-2610-0021` | Yêu cầu kiểm lô L-PGA-09 (NVL nghi vón cục) | 68, 70, 73, 74 | Chờ duyệt; 150,0 kg; gửi bởi Đỗ Minh Khang 17/10 10:30; ở `qc-dang-nhap` thành Đã duyệt, phiếu `QC-NM1-2610-0060`; HSD 23/10/2026 (còn 5 ngày) |
| `YC-NM1-2610-0022` | Yêu cầu kiểm lô L-BOT-01 | 68, 69, 70 | Chờ duyệt; 1.200,0 kg (900 ở kho tổng + 300 đang chuyển `PC-NM1-2610-0009`); gửi bởi Lê Văn Hải 18/10 10:30 |
| `YC-NM1-2610-0023` | Yêu cầu kiểm lô B261018-02 do xung đột khi mất kết nối | 68, 71 | Yêu cầu bổ sung; 1.200 lon; gửi bởi Đỗ Minh Khang 18/10 10:35; sau gửi lại là Chờ duyệt |
| `YC-NM1-2610-0010` | Yêu cầu kiểm BTP lô B261011 | 68, 71, 72 | Đã duyệt · đang kiểm; 1.152 lon (48 thùng); phiếu `QC-NM1-2610-0058`; sau QC trưởng duyệt kết luận thành Đã kết luận |
| `QC-NM1-2610-0058` | Phiếu kiểm lô B261011 | 68, 72, 73 | Chờ duyệt kết luận; QC đề xuất Đạt; 2 file; mẫu lưu `ML-NM1-2610-0030` (1 lon lưu, 2 lon kiểm nghiệm); truy xuất `TX-2610-0003`; ở board 77 lô B261011 hiện "Chờ QC trưởng duyệt kết luận" |
| `QC-NM1-2610-0060` | Phiếu kiểm lô L-PGA-09 (chỉ ở `qc-dang-nhap`) | 68, 70, 73, 74 | Đang kiểm; 100 g kiểm nghiệm · 100 g lưu; mẫu lưu `ML-NM1-2610-0034`; 1 file; đề xuất nháp Không đạt |
| `QC-NM1-2610-0061` | Phiếu kiểm lô A260920 (hàng hư khi nhận chuyển kho) | 68, 74; 77 (bảng Sắp có phiếu) | Đang kiểm, chưa lấy mẫu; từ `YC-NM1-2610-0025`; 24 lon |
| `QC-NM1-2610-0059` | Phiếu kiểm lô B261015 | 68, 74, 86; 77 | Đang kiểm; đã lấy mẫu 18/10 08:40; mẫu lưu `ML-NM1-2610-0031` chờ niêm phong; chưa có file |
| `QC-NM1-2610-0057` / lô B261013 | Phiếu kiểm và phiếu chứng nhận chờ ký | 68, 76, 77, 79, 80 | Đã duyệt Đạt 17/10 16:20; SP-0002; 1.152 lon; mẫu lưu `ML-NM1-2610-0029`; phiếu chứng nhận Chờ ký, chưa có số, số sẽ cấp `CN-NM1-2610-0019` |
| `QC-NM1-2610-0056` / lô B261012 | Phiếu kiểm và phiếu chứng nhận chờ ký | 68, 76, 77 | Đã duyệt Đạt 18/10 08:05; SP-0001; 1.152 lon; mẫu lưu `ML-NM1-2610-0028`; số sẽ cấp `CN-NM1-2610-0020` |
| `QC-NM1-2610-0055` / `CN-NM1-2610-0018` | Phiếu kiểm và phiếu chứng nhận đã ký lô A261011 | 68, 76, 77, 81, 84 | Đạt, ký 15/10 16:40 bởi Trần Thị Mai; SP-0001; lô 24 lon (20 đã giao `KH-0007` ngày 16/10, 2 lon lấy mẫu, 2 lon còn Khóa); mẫu lưu `ML-NM1-2610-0027`; khoanh vùng `TH-2610-0003` |
| `QC-NM1-2610-0044` | Phiếu kiểm lô NVL L-BOT-22, Không đạt | 68, 75 | Không đạt (độ ẩm 5,8 %); 475,0 kg; mẫu lưu `ML-NM1-2610-0012`; phiếu trả NCC `TH-NCC-2610-0003`; mở lại được; sau mở lại là Đạt |
| `QC-NM1-2610-0063` | Phiếu kiểm lô B261014, thành phẩm Không đạt | 68, 72, 75; 82 | Không đạt; 1.152 lon; mẫu lưu `ML-NM1-2610-0033`; phiếu hủy `PH-NM1-2610-0018` đã xác nhận 18/10 08:20; mẫu ở trạng thái "Hủy theo lô" |
| `QC-NM1-2610-0062` | Phiếu kiểm lô L-PGA-12, đã mở lại | 68, 75; 78 | Kết luận Không đạt, mở lại thành Đạt 16/10 14:00; mẫu lưu `ML-NM1-2610-0032` (200 g) |
| `ML-NM1-2410-0014`, `ML-NM1-2410-0013` | Hai mẫu hết hạn lưu | 78, 82, 83 | Hạn lưu 15/10/2026 (quá 3 ngày) và 18/10/2026 (hết hạn hôm nay); sau hủy là Đã hủy, biên bản `BB-ML-2610-0001` |
| `ML-NM1-2610-0027` | Mẫu lưu lô A261011 đang giữ theo thu hồi | 78, 84 | Giữ · hồ sơ thu hồi `TH-2610-0003`; hạn lưu 11/04/2029; không hủy được |
| `ML-NM1-2610-0031` | Mẫu của lô B261015 chờ niêm phong | 74 (phiếu `-0059`), 86 | Chờ niêm phong; sau ghi thành Đang lưu, hạn 15/04/2029 |

### 4.7. Truy xuất & thu hồi

Phân hệ này kiểm hai luồng nối nhau. Luồng thứ nhất là truy xuất nguồn gốc: tạo phiếu, truy ngược, truy xuôi, dòng thời gian, công đoạn sản xuất và cân bằng khối lượng (các board 87 đến 91). Luồng thứ hai là hồ sơ thu hồi: mở hồ sơ từ kết quả truy xuất, đánh giá rủi ro, Giám đốc quyết định, khoanh vùng hoặc thu hồi theo khách, hủy hàng, đổi lô hoặc hoàn tiền, hành động khắc phục và phòng ngừa (CAPA) chờ duyệt, rồi Giám đốc duyệt đóng hồ sơ (các board 92 đến 96).

Hai điều cần nhớ khi test:
- Ngày "hôm nay" trong mockup luôn là 18/10/2026. Mọi dòng "còn N ngày" tính từ ngày này. Bản ghi mới tạo mang ngày 18/10/2026 cộng giờ máy của người test.
- Ô chọn "Xem như vai trò" nằm ở thanh đầu của chính board. Đổi vai trò ở đó cho kết quả giống đổi ô `vaitro` trong panel.

#### 87 · Truy xuất — danh sách phiếu
Mở board này để kiểm: danh sách phiếu truy xuất, từng thẻ chi tiết của phiếu TX-2610-0003, và việc vai trò nào được làm, vai trò nào chỉ xem.
Ô chỉnh trong "Trạng thái hiển thị": `man` → `Danh sách` (mặc định), `Tạo phiếu`, `TX-2610-0003 · dòng thời gian`, `TX-2610-0003 · chuỗi ngược`, `TX-2610-0003 · cân bằng khối lượng`, `TX-2610-0003 · công đoạn sản xuất`, `Kết quả truy xuôi L-BOT-01`. `vaitro` → `Người truy xuất` (mặc định), `QC trưởng`, `QC`, `Thủ kho trưởng`, `Thủ kho điều phối`, `Thủ kho`, `Giám đốc`, `Admin`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Danh sách mặc định | `man` = `Danh sách`, `vaitro` = `Người truy xuất` | Bốn ô số: "Phiếu tháng 10" = 3 (ghi chú "1 ngược · 2 xuôi"); "Thời gian tra chuỗi trung bình" = "0,5 giây"; "Lệch cân bằng" = 1 (ghi chú "B261011 → kiểm kho PK-NM1-2610-0006"); "Gắn hồ sơ thu hồi" = 8. Các thẻ lọc: Tất cả 9, Truy ngược 2, Truy xuôi 7, Có lệch 1, Đã gắn thu hồi 8. Có nút "+ Tạo phiếu truy xuất". |
| 2 | Dòng đầu của danh sách | Nhìn dòng TX-2610-0003 | Truy ngược; nguồn "QC nghi lỗi", chứng từ ML-NM1-2610-0030; mã vào "AT000001 → A261011"; người tạo Ngô Thu Trang, 17/10/2026 09:00; tra chuỗi "0,6 giây"; kết quả "13 lô · 2 mẻ · 9 nút silo · 7 NCC · 1 khách nhận 20 lon" (nút silo là một lần nạp vào bồn chứa bột; NCC là nhà cung cấp); có nhãn "Lệch cân bằng" và liên kết hồ sơ thu hồi TH-2610-0003; trạng thái "Hoàn thành". |
| 3 | Lọc theo thẻ | Bấm lần lượt `Truy ngược`, `Truy xuôi`, `Có lệch`, `Đã gắn thu hồi` | Truy ngược còn 2 dòng (TX-2610-0003, TX-2609-0011). Có lệch chỉ còn TX-2610-0003. Đã gắn thu hồi còn 8 dòng, thiếu TX-2609-0015 (nguồn "Kiểm tra nội bộ", không có hồ sơ thu hồi). |
| 4 | Chuỗi ngược của TX-2610-0003 | `man` = `TX-2610-0003 · chuỗi ngược` | Tiêu đề "TX-2610-0003", nhãn "Truy ngược" và "Hoàn thành". Bốn ô tóm tắt: "Nguyên liệu và bao bì 11 lô (7 nhà cung cấp)", "Mẻ sản xuất 2 mẻ (9 nút silo)", "Lô có vấn đề 1 lô (A261011)", "Cân bằng khối lượng: Lệch 1 lô (đang kiểm kho · không chặn báo cáo)". Bốn thẻ: Làm từ gì, Công đoạn sản xuất, Chuỗi chi tiết, Hồ sơ và cân bằng (thẻ cuối có dấu "!"). Cây "Chuỗi ngược từ lô A261011" bắt đầu bằng A261011 (trạng thái Khóa), thùng AT000001, PX-NM1-2610-0035, KH-0007; lô L-BOT-01 hiện "Chờ kiểm", L-BOT-27 hiện "Hết". |
| 5 | Công đoạn sản xuất | `man` = `TX-2610-0003 · công đoạn sản xuất` | Sản lượng "24 lon", chiết rót "1.181 / 1.200 lon", hiệu suất bột "98,4 %". Chất lượng: lô "Khóa", "Đạt lúc xuất xưởng" (QC-NM1-2610-0055), mẫu lưu ML-NM1-2610-0027 "đo lại 17/10: ẩm 5,4 %", NCR (phiếu báo lỗi) "theo TH-2610-0003". Thời gian chạy "4 giờ 7 phút", gián đoạn "18 phút · 1 lần". Bảng 4 công đoạn: Nạp silo, Trộn mẻ 1, Chiết rót & ghép mí (gián đoạn "Kẹt lon ở băng tải vào máy ghép mí · 08:42–09:00", thời gian chạy 2 giờ 17 phút), Dán nhãn A & đóng thùng. Dòng tổng: "4 công đoạn · từ 10/10/2026 15:40 đến 11/10/2026 13:25 (21 giờ 45 phút)". |
| 6 | Phiếu không có thẻ công đoạn | Bấm vào dòng TX-2610-0001 hoặc TX-2610-0002 | Chỉ có ba thẻ: Hàng đang ở đâu, Chuỗi chi tiết, Hồ sơ và cân bằng. Thẻ Công đoạn sản xuất chỉ có với phiếu truy ra lô thành phẩm A261011, A260820, A260914. |
| 7 | Vai trò được làm | `vaitro` = `Người truy xuất`, mở phiếu `Kết quả truy xuôi L-BOT-01` | Có nút "Xuất báo cáo"; bấm xong hiện "Báo cáo: bao-cao-TX-2610-0004.pdf" và thông báo "Đã xuất bao-cao-TX-2610-0004.pdf." Sau đó mới có nút "Trả kết quả"; bấm xong hiện thông báo "Đã trả kết quả cho bên yêu cầu." và dòng "Đã trả: Trần Thị Mai · QC trưởng (ủy quyền) · 18/10/2026 giờ hiện tại". |
| 8 | Vai trò chỉ xem | `vaitro` = `Giám đốc`, `Admin`, `Thủ kho`, `Thủ kho điều phối` | Không có nút tạo phiếu, xuất báo cáo, trả kết quả. Thay vào đó có dòng "Việc của Người truy xuất · chỉ vai trò này tạo và chạy truy xuất" kèm nút "Xem như Người truy xuất"; bấm nút thì đổi sang vai trò đó và nút tạo xuất hiện. |
| 9 | Vai trò bị chặn vào màn | `vaitro` = `QC trưởng`, `QC`, `Thủ kho trưởng` | Dải cảnh báo "Vai trò QC trưởng không có quyền vào màn này." (đổi theo tên vai trò) kèm liên kết "Về Việc cần làm". Cũng không có nút tạo phiếu, thay bằng dòng "Việc của Người truy xuất". Phần danh sách bên dưới vẫn vẽ ra. |
| 10 | Phiếu đã gắn hoặc chưa gắn hồ sơ thu hồi | Mở TX-2610-0003, rồi mở TX-2609-0015 | TX-2610-0003 có liên kết "Hồ sơ thu hồi TH-2610-0003" và không có nút "Mở hồ sơ thu hồi". TX-2609-0015 chưa có hồ sơ nên có nút "Mở hồ sơ thu hồi". Cả hai phiếu đã có báo cáo và đã trả kết quả, nên không còn nút "Xuất báo cáo" hay "Trả kết quả". |
| 11 | Phiếu truy ngược có công đoạn lỗi | Mở TX-2609-0011 (A260820), thẻ Công đoạn sản xuất | Chất lượng lô hiện "Hủy", dòng "Chưa có phiếu QC lô" và "xuất xưởng không qua QC lô TP"; sản lượng có dòng đỏ "Sau giao: khách báo 6 lon phồng nắp"; nguyên nhân "lô lon L-LON-09 (DA-2608-B)". |

#### 88 · Truy xuất — tạo phiếu
Mở board này để kiểm: hộp thoại "Tạo phiếu truy xuất" nhận mã lô, mã đơn hàng, mã khách hàng, mã nguyên vật liệu hoặc mã QR, rồi chạy truy ngược hoặc truy xuôi.
Ô chỉnh trong "Trạng thái hiển thị": không có, chỉ bấm trong board. Vai trò mặc định là `Người truy xuất`; muốn thử vai trò khác thì dùng ô "Xem như vai trò" ở thanh đầu board.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Thiếu ô bắt buộc, theo thứ tự | Bấm "Tạo phiếu & chạy truy xuất" khi để trống; rồi chọn nguồn "QC nghi lỗi" và bấm lại; rồi điền lý do và bấm lại | Ba lần báo lỗi lần lượt: "Chọn nguồn yêu cầu." rồi "Nhập lý do truy xuất." rồi "Tra mã đầu vào ra lô trước khi chạy." Chưa có phiếu mới nào được tạo. |
| 2 | Nguồn yêu cầu đổi ô chứng từ | Chọn lần lượt nguồn `Thu hồi`, `QC nghi lỗi`, `Cơ quan quản lý`, `Kiểm tra nội bộ` | `Thu hồi`: ô "Chứng từ gốc" tự gắn, gợi ý "Tự gắn mã hồ sơ thu hồi khi mở truy xuất từ hồ sơ". `QC nghi lỗi`: gợi ý "Tự gắn mã yêu cầu kiểm QC khi mở truy xuất từ màn Chất lượng." `Cơ quan quản lý`: hiện ô "Công văn của cơ quan" với nút "Chọn tệp" và nút "Bỏ". `Kiểm tra nội bộ`: không có ô chứng từ nào. |
| 3 | Tra mã không ra | Loại mã `Số lô` nhập Z999; `Đơn hàng` nhập ĐH-2610-0001; `Khách hàng` nhập KH-0001; `Mã NVL` nhập NVL-X; `QR lon / thùng / bao` nhập AL000030; mã trống | Lần lượt: "Không tìm thấy lô Z999 — kiểm lại số lô."; "Đơn ĐH-2610-0001 chưa giao lô nào — không có gì để truy."; "Không tìm thấy lô nào giao cho KH-0001 trong 30 ngày."; "Không có lô nào của NVL-X đã dùng cho sản xuất."; "Không đọc được mã AL000030 — quét lại hoặc nhập số lô."; "Nhập mã đầu vào." |
| 4 | Tra mã ra một lô | Bấm các mã mẫu: `A261011`; QR `AT000001`; QR `AL000007`; đơn `ĐH-2610-0019`; khách `KH-0007` | Cả năm cùng ra lô A261011 ("Lô TP · SP-0001 · 24 lon") và hướng tự chọn là Ngược. Dòng giải thích: "QR lon AL000007 → thùng AT000001 → lô A261011"; "Đơn ĐH-2610-0019 · KH-0007 · 20 lon A261011 giao 16/10"; "KH-0007 Đại lý Minh Phát · lô đã nhận trong 30 ngày: A261011 (20 lon, 16/10)". |
| 5 | Tra mã ra nhiều lô | Loại mã `Mã NVL`, nhập NVL-BOT-0001, bấm "Tra mã" | Ba lô để chọn: L-BOT-01 (Chờ kiểm), L-BOT-27 (Hết, đã nạp hết vào LSX-2610-0009), L-BOT-19 (Khóa). Chưa lô nào được chọn nên bấm chạy vẫn báo "Tra mã đầu vào ra lô trước khi chạy." Mã NVL-PGA-0001 chỉ ra một lô L-PGA-05 và hướng tự chọn là Xuôi; QR bao `L-BOT-01-B017` ra lô L-BOT-01, hướng Xuôi. |
| 6 | Lô chưa có liên kết theo hướng đã chọn | Lô `L-PGA-05`, chọn hướng `Ngược`, bấm chạy | Báo lỗi "Lô L-PGA-05 chưa có liên kết theo hướng ngược." Chọn `Xuôi` thì chạy được. |
| 7 | Chạy thành công, lô có số lệch | Lô `B261011`, hướng `Ngược` (mặc định), lý do bất kỳ, bấm chạy | Mở ngay phiếu TX-2610-0004. Thông báo đầu trang: "Đã tạo TX-2610-0004 và chạy truy ngược — 13 lô · 2 mẻ · 9 nút silo · 7 NCC · lô cùng mẻ A261011 đã giao 20 lon." Ô tóm tắt "Cân bằng khối lượng: Lệch 1 lô". Nhật ký ghi "Lệch 1 lô (B261011) — ghi vào kết quả, không chờ; đã có PK-NM1-2610-0006 đang kiểm, không mở kiểm kho mới". |
| 8 | Lô là nguyên liệu mua, truy ngược | Lô `L-BOT-27`, hướng `Ngược` | Chạy được nhưng chuỗi chỉ có đúng lô này, dòng tóm tắt "Lô NVL mua: nhà cung cấp, PO, file đánh giá bên ngoài — không có cấp trên trong nhà máy". |
| 9 | Vai trò khác không tạo được | Dùng "Xem như vai trò" chọn `Giám đốc` rồi mở lại hộp thoại | Không có nút "Tạo phiếu & chạy truy xuất"; có dòng "Việc của Người truy xuất · chỉ vai trò này tạo và chạy truy xuất" và nút "Xem như Người truy xuất". Bấm "Hủy" thì về danh sách. |

#### 89 · Truy xuất — TX-2610-0003 cân bằng khối lượng (lệch B261011)
Mở board này để kiểm: bảng cân bằng khối lượng (số lượng vào phải bằng số đã dùng, giao, hủy, mẫu lưu, còn tồn và đang chuyển) và biên bản chênh lệch của lô B261011.
Ô chỉnh trong "Trạng thái hiển thị": không có, chỉ bấm trong board. Board này mở bằng vai trò `Thủ kho`, là vai trò có quyền xem màn Truy xuất nên không bị chặn.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở được bằng vai trò có quyền | Mở board, không đổi gì | Không có dải cảnh báo thiếu quyền. Đang ở thẻ "Hồ sơ và cân bằng" (có dấu "!" trên tên thẻ). Bảng cân bằng mặc định chỉ hiện lô lệch: B261011, loại Lô BTP, đơn vị lon, số vào 1.157, mẫu lưu 3, tồn 1.152, cột Lệch "−2". |
| 2 | Xem đủ các lô | Bấm "Xem cả 13 lô" | Bảng hiện 13 dòng, chỉ B261011 có "Lệch", 12 dòng còn lại ghi "Khớp". Nút đổi thành "Chỉ xem lô lệch". Ví dụ A261011: vào 24, giao khách 20, mẫu lưu 2, tồn 2, khớp. |
| 3 | Dòng lệch gắn kiểm kho | Nhìn cột Xử lý của B261011 | Nhãn "Lệch", liên kết PK-NM1-2610-0006 và dòng "biên bản: Nguyễn Văn Tú · 17/10/2026 09:40". |
| 4 | Biên bản chênh lệch đã lập | Cuộn xuống khối "Biên bản chênh lệch" | Lô B261011; SL lệch "2 lon"; Thủ kho lập "Nguyễn Văn Tú · 17/10/2026 09:40"; kiểm kho lô lệch PK-NM1-2610-0006; nguyên nhân "Chiết rót đếm 1.157 lon, phiếu nhập BTP 11/10 ghi 1.155 lon — nghi đếm trùng 2 lon ở đầu dòng". Không có dòng "Lô đang kiểm theo phiếu kiểm kho có sẵn" vì đây là phiếu đã tạo biên bản. |
| 5 | Biên bản dùng lại kiểm kho có sẵn | Vào board 88, tạo phiếu mới cho lô B261011, mở thẻ "Hồ sơ và cân bằng" | Có dòng thông báo "Lô đang kiểm theo phiếu kiểm kho có sẵn — đã gắn phiếu truy xuất này vào." và vẫn dùng PK-NM1-2610-0006, không mở kiểm kho mới. |
| 6 | Hồ sơ từng lô | Cuộn bảng "Hồ sơ từng lô trong chuỗi" | 13 dòng. A261011: phiếu QC-NM1-2610-0055 và CN-NM1-2610-0018, mẫu lưu ML-NM1-2610-0027, NCR "NCR theo TH-2610-0003", trạng thái Khóa. B261011: YC-NM1-2610-0010 và QC-NM1-2610-0058, trạng thái "Chờ kiểm", kho "672 lon NM1-BTP · 480 lon NM1-DP". |
| 7 | Vai trò xem thẻ này | Dùng "Xem như vai trò" chọn `Thủ kho điều phối`, `Giám đốc`, `Admin` | Thấy cùng nội dung. Riêng `QC trưởng`, `QC`, `Thủ kho trưởng` có thêm dải "Vai trò … không có quyền vào màn này." |

#### 90 · Truy xuất — kết quả truy xuôi L-BOT-01
Mở board này để kiểm: kết quả truy xuôi từ lô nguyên liệu L-BOT-01 (hàng đang ở đâu), nhật ký, và cảnh báo nhà máy mất kết nối.
Ô chỉnh trong "Trạng thái hiển thị": không có, chỉ bấm trong board. Vai trò mặc định `Người truy xuất`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Đầu phiếu | Mở board | Phiếu TX-2610-0004, "Truy xuôi", "Hoàn thành"; nguồn "QC nghi lỗi", chứng từ YC-NM1-2610-0022; vào bằng "Số lô L-BOT-01"; người tạo Ngô Thu Trang. Danh sách phía sau có 4 phiếu tháng 10 ("1 ngược · 3 xuôi"). |
| 2 | Cảnh báo mất kết nối | Nhìn dải vàng đầu phiếu | "Server nhà máy NM1 ngoại tuyến từ 08:12." và câu "Sự kiện nạp silo / mẻ sau 08:12 chưa về cloud — kết quả có thể thiếu; chạy lại khi có kết nối." Phiếu truy xuôi L-BOT-27 cũng có dải này; các phiếu khác không có. |
| 3 | Bốn ô tóm tắt | Nhìn hàng ô tóm tắt | "Đã giao khách 20 lon (1 khách)"; "Còn trong nhà máy 1.154 lon (4 kho · + 1.225 kg L-BOT-01)"; "Mẫu lưu · hủy 5 lon (5 mẫu lưu · 0 hủy)"; "Cân bằng khối lượng: Lệch 1 lô". |
| 4 | Hàng đang ở đâu | Thẻ "Hàng đang ở đâu" | 6 phần: A261011 2 lon ở NM1-DP (Khóa · Khoanh vùng · TH-2610-0003 từ 17/10 10:20); B261011 672 lon ở NM1-BTP và 480 lon ở NM1-DP (Chờ kiểm); L-BOT-01 900 kg ở NM1-TONG (Chờ kiểm · YC-NM1-2610-0022); 25 kg ở PH-NM1-2610-0013 (Khóa chờ hủy · bao rách); 300 kg đang chuyển PC-NM1-2610-0009 (NM1-TONG → NM2-TONG). |
| 5 | Khách đã nhận | Cuộn bảng khách | 1 dòng: KH-0007 Đại lý Minh Phát, đơn ĐH-2610-0019, phiếu xuất PX-NM1-2610-0035, lô A261011, 20 lon, 16/10/2026 09:30. |
| 6 | Cân bằng khối lượng 3 lô | Thẻ "Hồ sơ và cân bằng" | Nút "Xem cả 3 lô". Chỉ B261011 lệch "−2". L-BOT-01: vào 1.625 kg = dùng sản xuất 400 + tồn 925 + đang chuyển 300, khớp. |
| 7 | Thẻ công đoạn không có | Nhìn các thẻ | Chỉ ba thẻ: Hàng đang ở đâu, Chuỗi chi tiết, Hồ sơ và cân bằng. Lô nguyên liệu không có thẻ Công đoạn sản xuất. |
| 8 | Mở hồ sơ thu hồi từ phiếu này | Bấm "Mở hồ sơ thu hồi" ở đầu phiếu | Phiếu chưa có hồ sơ nên có nút này, kèm ghi chú "Do QC trưởng mở khi cần." Nếu canvas chuyển được sang Hồ sơ thu hồi thì hộp thoại mở ở chế độ nhập số lô, ô lô đã điền L-BOT-01 và dòng "Từ kết quả truy xuất TX-2610-0004". |

#### 91 · Truy xuất — TX-2610-0003 dòng thời gian (truy ngược A261011)
Mở board này để kiểm: dòng thời gian các sự kiện của chuỗi ngược từ lô A261011, gồm nhóm theo ngày, bộ lọc, chiều sắp xếp và thẻ chi tiết từng sự kiện.
Ô chỉnh trong "Trạng thái hiển thị": không có, chỉ bấm trong board. Vai trò mặc định `Người truy xuất`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở đúng thẻ | Mở board | Đang ở thẻ "Chuỗi chi tiết", nút "Dòng thời gian" đang chọn (bên cạnh là nút "Cây"). Tiêu đề "Chuỗi ngược từ lô A261011", dòng phụ "10/10/2026 → 16/10/2026 · 20 sự kiện · 3 ngày". Có ô "Hiện", nút "⇅ Cũ → mới", nút "Mở hết" và "Thu gọn". |
| 2 | Ba nhóm ngày | Nhìn danh sách | Ngày 10 (T7) có 11 sự kiện, ngày 11 (CN) có 7 sự kiện, ngày 16 (T6) có 2 sự kiện. Cộng lại 20. |
| 3 | Bộ lọc "Hiện" | Chọn lần lượt từng lựa chọn | Có 5 lựa chọn: "Tất cả · 20", "Nguyên liệu · 13", "Mẻ sản xuất · 2", "Thành phẩm · 3", "Giao & vận chuyển · 2". Không có lựa chọn QC vì chuỗi này không có sự kiện lấy mẫu. Chọn "Giao & vận chuyển" thì chỉ còn nhóm ngày 16 với 07:50 PX-NM1-2610-0035 và 09:30 KH-0007 (20 lon). Dòng phụ vẫn ghi "20 sự kiện · 1 ngày" (xem mục lệch cuối trang). |
| 4 | Chiều sắp xếp | Bấm "⇅ Cũ → mới" | Nút đổi thành "⇅ Mới → cũ"; thứ tự ngày đảo thành 16, 11, 10. |
| 5 | Thu gọn và mở hết | Bấm "Thu gọn", rồi "Mở hết"; bấm riêng tiêu đề một ngày | "Thu gọn" ẩn nội dung các ngày; "Mở hết" mở cả nhóm ngày lẫn thẻ chi tiết từng sự kiện; bấm tiêu đề một ngày chỉ đóng hoặc mở ngày đó. |
| 6 | Thẻ chi tiết sự kiện | Mở sự kiện L-LON-12 (ngày 11) | Có các mục "Loại", "Thời điểm", "Mặt hàng", "Thao tác", "Nhà cung cấp" (NCC-0004 Bao bì Đông Á, lô NCC DA-2609-A, PO-2609-0004), "File đánh giá" (DGN-DA-2609-A.pdf), "Trạng thái lô" (Đạt). |
| 7 | Sự kiện có giờ xếp trước sự kiện chỉ có ngày | Nhìn ngày 11 | Hai sự kiện có giờ nằm trên cùng: 05:50 nạp L-BOT-27 (144 kg, Hết) và 06:20 mẻ LSX-2610-0004 · mẻ 1 (960 kg). Sau đó là các sự kiện chỉ ghi ngày: lô A261011 (24 lon, Khóa), thùng AT000001, lô B261011 (1.157 lon, Chờ kiểm), L-LON-12, L-THU-05. |
| 8 | Ngày 10 bắt đầu bằng nạp nguyên liệu | Nhìn ngày 10 | Các dòng đầu: 08:10 Nạp L-BOT-28 (192 kg, Đạt), 08:12 L-CAC-04 (19,286 kg), 08:14 L-LEC-03 (16,596 kg), 08:16 L-PGA-09 (12 kg, Chờ kiểm), 08:18 L-DHA-02 (0,118 kg), 08:30 mẻ LSX-2610-0003 · mẻ 1 (240 kg); buổi chiều 15:40 nạp L-BOT-01 (400 kg, Chờ kiểm). |
| 9 | Quay lại dạng cây | Bấm nút "Cây" | Trở về cây "Chuỗi ngược từ lô A261011" như board 87 dòng 4. |

#### 92 · Hồ sơ thu hồi — danh sách
Mở board này để kiểm: danh sách hồ sơ, cột "Việc đang chờ" theo từng vai trò, và từng bước của hồ sơ thông qua ô `buoc`.
Ô chỉnh trong "Trạng thái hiển thị": `buoc` → `Danh sách` (mặc định), `Mở từ truy xuất`, `Đánh giá rủi ro`, `Chờ GĐ quyết`, `Khoanh vùng · QC kiểm lại`, `Đang thu hồi`, `Hủy · đổi lô / hoàn tiền`, `CAPA chờ duyệt`, `Chờ GĐ đóng`, `Đã đóng`. `vaitro` → `QC trưởng` (mặc định), `Giám đốc`, `QC`, `CSKH`, `Sales`, `Kế toán trưởng`, `Kế toán`, `Thủ kho`, `Thủ kho trưởng`, `Người truy xuất`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Danh sách mặc định | `buoc` = `Danh sách`, `vaitro` = `QC trưởng` | Bốn ô: "Hồ sơ đang mở" 6 ("1 chưa có quyết định"); "Đang thu hồi" 2 ("thu về 792 / 1.056 lon (75%)"); "Chờ tôi" 2 ("theo vai trò QC trưởng (ủy quyền)"); "Đã đóng" 2. Thẻ: Tất cả 8, Chờ tôi 2, Mở 2, Đang thu 2, Đã xử lý lô 2, Đã đóng 2. |
| 2 | Từng dòng của danh sách | Đọc cột Quyết định, Thu hồi, Hạn, Việc đang chờ | TH-2610-0003 "Đề xuất thu hồi", chờ Giám đốc quyết định. TH-2610-0002 "Khoanh vùng", chờ QC kiểm lại. TH-2610-0001 thu hồi 85% (408 / 480), hạn 02/11/2026 "còn 15 ngày". TH-2609-0005 thu hồi 66,7% (384 / 576), hạn 22/10/2026 "còn 4 ngày" (chữ nhấn màu vì còn ít hơn 7 ngày). TH-2609-0003 97,5% (468 / 480), "Chờ QC trưởng duyệt CAPA". TH-2609-0002 "Chờ GĐ / KTT duyệt số tiền hoàn". TH-2609-0004 và TH-2609-0001 "Đã đóng". |
| 3 | Chờ tôi theo vai trò | Đổi `vaitro` | `QC trưởng` 2 (TH-2610-0002, TH-2609-0003). `Giám đốc` 2 (TH-2610-0003, TH-2609-0002). `CSKH` 2 (TH-2610-0001, TH-2609-0005). `Kế toán trưởng` 1 (TH-2609-0002). `QC`, `Sales`, `Người truy xuất` 0. Dòng chờ mình được tô nền. |
| 4 | Bước Mở từ truy xuất | `buoc` = `Mở từ truy xuất` | Hộp thoại "Mở hồ sơ thu hồi" mở sẵn (xem board 93). |
| 5 | Bước Đánh giá rủi ro | `buoc` = `Đánh giá rủi ro` | Hồ sơ TH-2610-0003, trạng thái "Mở", quyết định "Chưa đánh giá", việc chờ "Chờ QC trưởng đánh giá rủi ro". Thanh bước: 1 và 2 có dấu ✓, bước 3 đang chọn. Nhấn nút "Gửi Giám đốc quyết định" khi chưa chọn đủ mức nguy hại, phạm vi, đề xuất, nhận định thì báo "Chọn mức nguy hại, phạm vi, đề xuất và ghi nhận định." Điền đủ rồi gửi: thông báo "Đã gửi Giám đốc quyết định.", sang bước 4, quyết định hiện "Đề xuất thu hồi" (hoặc khoanh vùng theo ô đã chọn). Ô "SL ngoài thị trường" tự điền "20 lon · 1 khách (theo truy xuất)", "Còn trong kho" tự điền "A261011: 2 lon · B261011: 1.152 lon". Vai trò khác `QC trưởng` thấy "Việc của QC trưởng · QC trưởng đánh giá rủi ro". |
| 6 | Bước Chờ GĐ quyết | `buoc` = `Chờ GĐ quyết` | Xem board 94. |
| 7 | Bước Khoanh vùng · QC kiểm lại | `buoc` = `Khoanh vùng · QC kiểm lại` | Hồ sơ TH-2610-0002 chỉ có 6 bước (không có thu hồi khách, hủy, hoàn tiền, CAPA). Lô L-BOT-19 "Khóa" (lý do Khoanh vùng), kiểm lại "Chưa gửi kiểm · Chờ kho gửi yêu cầu kiểm", có nút "Mở Yêu cầu kiểm". Lô A261007 "Đạt" (QC-NM1-2610-0052, 12/10/2026). Chỉ số "1 / 2 lô có kết quả". `QC trưởng` bấm "Mô phỏng: duyệt đạt": "Lô đạt — hệ thống mở khóa." Bấm "Duyệt không đạt": "Lô không đạt — chuyển hủy phần trong kho.", lô vào "Khóa · Chờ hủy", hồ sơ thành "Đã xử lý lô", việc chờ "Chờ Giám đốc duyệt đóng hồ sơ". `QC` thấy "Việc của QC trưởng · QC trưởng duyệt kết luận QC". |
| 8 | Khoanh vùng nhưng lô đã giao khách không đạt | Ở TH-2610-0003 (board 94) ký `Khoanh vùng`, `QC trưởng` duyệt B261011 đạt rồi A261011 không đạt | Hồ sơ quay lại bước Giám đốc quyết định, việc chờ "Kiểm lại không đạt — chờ Giám đốc quyết định lại", dải "Hồ sơ quay lại bước này: Lô A261011 kiểm lại không đạt, đã giao 20 lon — Giám đốc quyết định lại: thu hồi phần đã giao hay giữ khoanh vùng." (quy tắc: thành phẩm đã giao một phần mà không đạt thì hồ sơ quay lại Giám đốc). |
| 9 | Bước Đang thu hồi | `buoc` = `Đang thu hồi` | Xem board 95. |
| 10 | Bước Hủy · đổi lô / hoàn tiền | `buoc` = `Hủy · đổi lô / hoàn tiền` | Hồ sơ TH-2609-0003, "Đã xử lý lô", việc chờ "Chờ GĐ / KTT duyệt số tiền hoàn". Bước Hủy: phiếu PH-NM1-2610-0002, "948 lon (A260820: 588 · A260821: 360)", Trần Thị Mai xác nhận 04/10/2026 15:00, "Đã hủy". Bước đổi lô / hoàn tiền: KH-0052 "Đổi lô mới" ĐH-2610-0029 "Đã giao" (ghi chú "khách đã bán lẻ 12 lon — chỉ xử lý phần thu về"); KH-0058 "Hoàn tiền" đề nghị "19.200.000 đ" "Chờ duyệt". |
| 11 | Duyệt số tiền hoàn theo vai trò | Ở bước trên, đổi `vaitro` | `Giám đốc` và `Kế toán trưởng` có ô số tiền sẵn "19.200.000" và nút "Duyệt" (một người duyệt là đủ). Nhập 0 rồi duyệt: "Nhập số tiền hoàn lớn hơn 0." Nhập 15.000.000 rồi duyệt: "Đã duyệt 15.000.000 đ — Kế toán ghi nhận hoàn tiền ở Sổ thu chi.", việc chờ đổi thành "Chờ QC lập CAPA". Sau đó `Kế toán` thấy nút "Mô phỏng: Kế toán ghi nhận" → "Kế toán đã ghi nhận hoàn tiền." `QC trưởng`, `Sales` thấy "Việc của Giám đốc · một người duyệt số tiền là đủ". |
| 12 | Bước CAPA chờ duyệt | `buoc` = `CAPA chờ duyệt`, `vaitro` = `QC trưởng` | CAPA là hành động khắc phục và phòng ngừa. Nguyên nhân gốc "Lô lon L-LON-09 (lô NCC DA-2608-B) ghép mí không kín — NCC Bao bì Đông Á; kiểm mí ở chiết rót lấy mẫu thưa nên không phát hiện." Hai hành động "Chờ duyệt": nhóm Bao bì (phụ trách Vũ Đức Anh, hạn 31/10/2026) và nhóm Sản xuất (Đỗ Minh Khang, hạn 25/10/2026). Dòng "Lập: Vũ Đức Anh · gửi 15/10/2026 10:00". Có nút "Duyệt CAPA" và "Trả lại sửa". |
| 13 | Trả lại CAPA | Bấm "Trả lại sửa" khi để trống, rồi nhập lý do "Thiếu hạn" và bấm lại | Lần đầu: "Nhập lý do trả lại." Lần hai: "Đã trả CAPA cho QC sửa.", dòng "QC trưởng trả lại: Thiếu hạn", hai hành động về "Mở", việc chờ "CAPA bị trả lại — QC sửa". Đổi sang `QC`: thêm hành động mà thiếu nhóm, nguyên nhân hoặc hành động thì báo "Chọn nhóm, nhập nguyên nhân và hành động."; bấm "Gửi QC trưởng duyệt" thì "Đã gửi QC trưởng duyệt CAPA." và hai hành động về "Chờ duyệt" |
| 14 | Duyệt CAPA | `QC trưởng` bấm "Duyệt CAPA" | "Đã duyệt CAPA — hồ sơ chờ Giám đốc duyệt đóng.", hai hành động "Đã duyệt", chuyển sang bước Đóng hồ sơ. `Giám đốc` và `QC` ở bước chờ duyệt chỉ thấy "Việc của QC trưởng · QC trưởng duyệt CAPA". |
| 15 | Bước Chờ GĐ đóng | `buoc` = `Chờ GĐ đóng` | Xem board 96. |
| 16 | Bước Đã đóng | `buoc` = `Đã đóng` | Hồ sơ TH-2609-0001: mọi bước ✓, "100% (240 / 240 lon · 1 khách)", hạn "04/10/2026 · đã kết thúc thu gom". Bước Đóng hồ sơ: "Xong"; "Đã đóng 26/09/2026 09:00 · Lê Quang Minh duyệt. Lưu đến 02/03/2029." Không còn nút "Duyệt đóng hồ sơ" dù là `Giám đốc`. |
| 17 | Vai trò bị chặn vào màn | `vaitro` = `Kế toán`, `Thủ kho`, `Thủ kho trưởng` | Dải "Vai trò … không có quyền vào màn này." với liên kết "Về Việc cần làm". `Chờ tôi` = 0. Nội dung bên dưới vẫn vẽ (xem mục lệch). |
| 18 | Vai trò chỉ xem | `vaitro` = `Người truy xuất`, `QC`, `Sales` ở bước không phải việc của mình | Không có nút thao tác; chỉ có dòng "Việc của <vai trò phụ trách>" kèm nút "Xem như <vai trò phụ trách>". Riêng `Người truy xuất` chỉ có việc ở hồ sơ mới mở bằng số lô (bước truy xuất chưa xong, board 93 dòng 8). |

#### 93 · Hồ sơ thu hồi — mở từ kết quả truy xuất
Mở board này để kiểm: hộp thoại "Mở hồ sơ thu hồi" từ kết quả truy xuất TX-2610-0003, việc hệ thống khóa lô ngay khi mở, và chế độ nhập số lô.
Ô chỉnh trong "Trạng thái hiển thị": không có, chỉ bấm trong board. Mặc định `QC trưởng`; thử vai trò khác bằng ô "Xem như vai trò".

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Danh sách phía sau | Nhìn nền | Dải "Kết quả truy xuất chờ QC trưởng xem xét: TX-2610-0003 · lô A261011 · chuỗi 13 lô · 1 khách (KH-0007) đã nhận 20 lon." kèm nút "Mở hồ sơ từ kết quả này". Chỉ còn 7 hồ sơ (chưa có TH-2610-0003): "Hồ sơ đang mở" 5, "0 chưa có quyết định". |
| 2 | Nội dung hộp thoại | Nhìn hộp thoại "Mở hồ sơ thu hồi" | Chế độ "Từ kết quả truy xuất": TX-2610-0003 "Hoàn thành", Truy ngược, 17/10/2026 09:00 · Ngô Thu Trang · tra chuỗi 0,6 giây. "Mã đầu vào: QR thùng AT000001 → lô A261011 (SP-0001, 24 lon)"; "lô B261011 cùng mẻ lệch 2 lon → PK-NM1-2610-0006"; khách KH-0007 Đại lý Minh Phát 20 lon. Ô Nguồn mặc định "Truy xuất phát hiện" (có 5 lựa chọn). Ô kết luận đã điền sẵn. Dòng "Mở hồ sơ sẽ khóa ngay cả lô A261011, chặn xuất kho và giao hàng." |
| 3 | Thiếu kết luận | Xóa trắng ô "Kết luận lỗi cả lô", bấm "Mở hồ sơ & khóa lô" | Báo "Nhập kết luận lỗi cả lô." Chưa tạo hồ sơ. |
| 4 | Mở thành công | Điền kết luận, bấm "Mở hồ sơ & khóa lô" | Vào hồ sơ TH-2610-0003 ở bước Truy xuất. Thông báo "Đã mở TH-2610-0003 — hệ thống đã khóa cả lô A261011, chặn xuất / giao." Trạng thái "Mở", quyết định "Chưa đánh giá", việc chờ "Chờ QC trưởng đánh giá rủi ro". Hai lô: A261011 "Nghi lỗi · Khóa · Khoanh vùng"; B261011 "Liên quan · Chờ kiểm" (giữ nguyên vì đã bị chặn xuất theo QC-NM1-2610-0058). Nhật ký có dòng "Gắn B261011 (cùng mẻ, đang Chờ kiểm) vào hồ sơ". Quay lại danh sách: dải chờ biến mất, "Hồ sơ đang mở" thành 6. |
| 5 | Mở lần hai | Sau bước 4, mở lại hộp thoại | Chế độ "Từ kết quả truy xuất" hiện "Không còn kết quả truy xuất nào chưa mở hồ sơ — TX-2610-0003 đã gắn vào TH-2610-0003." và nút mở bị ẩn. |
| 6 | Chỉ QC trưởng được mở | `Xem như vai trò` chọn `Giám đốc`, `QC`, `CSKH`, `Sales`, `Kế toán trưởng`, `Người truy xuất` | Không có nút "Mở hồ sơ & khóa lô"; có dòng "Việc của QC trưởng · chỉ QC trưởng mở hồ sơ" và nút "Xem như QC trưởng". Nút "+ Mở hồ sơ thu hồi" ở danh sách cũng thay bằng dòng "Việc của QC trưởng · chỉ QC trưởng mở hồ sơ thu hồi". |
| 7 | Chế độ nhập số lô, thiếu ô | Chọn "Nhập số lô nghi lỗi", xóa kết luận, bấm mở; rồi điền kết luận, để trống số lô, bấm mở | Lần một: "Nhập kết luận lỗi cả lô." Lần hai: "Nhập số lô nghi lỗi." Nút "Mô phỏng quét" điền lô A261007 và dòng "Đã quét QR lon AT004512 → lô A261007 · SP-0003 · NM1". |
| 8 | Hồ sơ mở bằng số lô | Nhập A261007 (chữ thường cũng được), bấm mở | Thông báo "Đã mở … — hệ thống đã khóa cả lô A261007, chặn xuất / giao." Việc chờ "Đang truy xuất"; phiếu truy xuất TX-2610-0005 hướng "Ngược + xuôi", "Đang truy xuất". `Người truy xuất` thấy nút "Mô phỏng: truy xuất xong" → "Truy xuất xong." rồi sang bước đánh giá rủi ro, phiếu ghi "Không có lô liên quan, chưa giao khách". Vai trò khác thấy "Việc của Người truy xuất · chạy truy xuất ở màn Truy xuất". |

#### 94 · Hồ sơ thu hồi — chờ Giám đốc quyết định
Mở board này để kiểm: bước Giám đốc quyết định thu hồi hay khoanh vùng, và bảng lệnh khóa lô gửi tới từng nhà máy ("Đã áp dụng" hay "Chờ nhà máy áp dụng").
Ô chỉnh trong "Trạng thái hiển thị": không có, chỉ bấm trong board. Mặc định `Giám đốc`; thử `QC trưởng` và vai trò khác bằng "Xem như vai trò".

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Đầu hồ sơ | Mở board | TH-2610-0003, "Mở", "Đề xuất thu hồi", việc chờ "Chờ Giám đốc quyết định" (nhãn "Việc của bạn"). Bốn ô: "Thu hồi —", "Hạn thu hồi — (sau quyết định)", "Lô trong hồ sơ 2 (1 đang khóa)", "Lưu hồ sơ đến 11/04/2029". Thanh bước: 1 đến 3 có ✓, bước 4 đang chọn. |
| 2 | Đánh giá của QC trưởng | Nhìn khối "Đánh giá của QC trưởng" | "Mức 2 · trung bình"; phạm vi "Tới đại lý"; ngoài thị trường "20 lon"; đề xuất "Thu hồi"; người đánh giá Trần Thị Mai, 18/10/2026 08:40; nhận định "Độ ẩm vượt mức cho phép → nguy cơ vón cục…". |
| 3 | Lệnh khóa lô hiện tại | Nhìn bảng "Lệnh khóa lô tới nhà máy" | Một dòng: NM1, "Khóa lô · lý do Khoanh vùng", lô A261011, gửi "17/10 10:20", "Đã áp dụng 10:20", ghi chú "B261011 đang Chờ kiểm (đã chặn xuất) — giữ trạng thái, không cần lệnh khóa". Tổng: "mọi nhà máy đã áp dụng". |
| 4 | Ký khi chưa chọn | Bấm "Ký quyết định" khi chưa chọn | Báo "Chọn Thu hồi hoặc Khoanh vùng." Ô `Thu hồi` có chú thích "QC trưởng đề xuất". |
| 5 | Ký Thu hồi | Chọn `Thu hồi`, bấm "Ký quyết định" | Thông báo "Đã ký quyết định Thu hồi — lô đổi lý do khóa sang Thu hồi, hạn 17/11/2026. Lệnh khóa gửi NM1: chờ nhà máy áp dụng (NM1 đang mất kết nối)." Trạng thái thành "Đang thu", quyết định "Thu hồi", sang bước Báo cơ quan. Cả A261011 và B261011 thành "Khóa · Thu hồi" (B261011 đổi từ Chờ kiểm). Ô "Hạn thu hồi" "17/11/2026 (còn 30 ngày)", "Lô trong hồ sơ 2 (2 đang khóa)". |
| 6 | Trạng thái áp dụng khóa lô sau khi ký | Bấm lại bước 4 "Giám đốc quyết định" | Bảng có thêm dòng "Đổi lý do khóa → Thu hồi", lô "A261011, B261011", gửi "18/10 giờ hiện tại", trạng thái "Chờ nhà máy áp dụng", ghi chú "NM1 mất kết nối từ 08:12 — QC trưởng gọi điện báo nhà máy; có kết nối lại nhà máy tự áp dụng". Tổng "1 lệnh chờ nhà máy áp dụng". Dòng giải thích: "Mọi lô trong hồ sơ đã chuyển lý do khóa "Thu hồi" — chỉ còn đường hủy." |
| 7 | Ký Khoanh vùng | Mở lại board, chọn `Khoanh vùng`, ký | Thông báo "Đã ký quyết định Khoanh vùng — QC kiểm lại từng lô." Thanh bước rút còn 6 bước, sang bước "QC kiểm lại lô bị khóa"; hai lô cùng có kiểm lại "Chờ kiểm · QC kiểm lại"; bảng khóa lô không thêm dòng, vẫn "mọi nhà máy đã áp dụng". |
| 8 | Vai trò khác không ký được | "Xem như vai trò" chọn `QC trưởng`, `Kế toán trưởng`, `Sales` | Không có form ký. Có dòng "Việc của Giám đốc · Giám đốc ký quyết định" và nút "Xem như Giám đốc". Việc chờ hiện "Chờ Giám đốc quyết định" nhưng không tô là của mình. |
| 9 | Bảng khóa lô nhiều dòng, nhiều ngày | `buoc` = `Đang thu hồi` ở board 92, bấm bước 4 | TH-2610-0001 có 3 dòng: "Khóa lô · lý do Khoanh vùng" (L-PGA-05, "Đã áp dụng 09:15"); "Khóa thêm theo truy xuất · Khoanh vùng" (HH-260916, A260918, A260922, gửi "02/10 11:25", "Đã áp dụng 03/10 16:05", ghi chú "Gửi lúc NM1 mất kết nối — áp dụng khi có kết nối lại"); "Đổi lý do khóa → Thu hồi" ("Đã áp dụng 16:05", ghi chú nhắc lô B261003 sinh ra ngoại tuyến, hủy theo PH-NM1-2610-0010). Tổng "mọi nhà máy đã áp dụng". |

#### 95 · Hồ sơ thu hồi — đang thu hồi theo khách
Mở board này để kiểm: bước thông báo khách và thu hàng của hồ sơ TH-2610-0001, phần trăm thu hồi theo từng khách, việc nhắc khách, nhập kho hàng thu hồi, rồi chuyển sang hủy hàng.
Ô chỉnh trong "Trạng thái hiển thị": không có, chỉ bấm trong board. Mặc định `CSKH` (chăm sóc khách hàng); thử vai trò khác bằng "Xem như vai trò".

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Đầu hồ sơ | Mở board | TH-2610-0001, "Đang thu", "Thu hồi", việc chờ "Chờ khách trả hàng · còn 72 lon". Bốn ô: "Thu hồi 85% (408 / 480 lon · 3 khách)", "Hạn thu hồi 02/11/2026 (còn 15 ngày)", "Lô trong hồ sơ 5 (5 đang khóa)", "Lưu hồ sơ đến 18/09/2029". Bước 1 đến 5 có ✓, bước 6 đang chọn. |
| 2 | Bảng khách | Nhìn bảng "Khách cần thu hồi" | KH-0031 giao 192, thu 192, 100%, thông báo 03/10 10:40, nhắc "—". KH-0044 giao 96, thu 72, 75%, nhắc 15/10 09:00. KH-0012 giao 192, thu 144, 75%, nhắc 16/10 14:20. Người thông báo: Đinh Mỹ Linh. |
| 3 | Nút của CSKH | Nhìn cột thao tác | Khách đã thu đủ (KH-0031) không có nút. KH-0044 và KH-0012 có nút "Ghi đã nhắc" (đã thông báo rồi nên không còn "Ghi đã thông báo"). Bấm "Ghi đã nhắc" ở KH-0044: "Đã ghi lần nhắc KH-0044." và cột nhắc đổi thành 18/10 giờ hiện tại. |
| 4 | Phiếu nhập hàng thu hồi | Nhìn bảng "Hàng thu hồi nhập kho" | PN-NM1-2610-0024 (14/10/2026 10:10, 312 lon, "3 khách · lô A260918") và PN-NM1-2610-0032 (18/10/2026 08:50, 96 lon, "KH-0012 · lô A260918"). 312 + 96 = 408, khớp số "Đã thu về". |
| 5 | Vai trò khác CSKH | "Xem như vai trò" chọn `QC trưởng`, `Giám đốc`, `Sales`... | Không có nút ghi nhắc. Có dòng "Việc của CSKH · CSKH thông báo, nhắc khách" và nút "Xem như CSKH". |
| 6 | Thủ kho nhập đủ phần còn lại | Chọn `Thủ kho` (hoặc `Thủ kho trưởng`), bấm "Mô phỏng: kho nhập đủ phần còn lại" | Thông báo "PN-NM1-2610-0033 đã nhập: thu về đủ 100%, chuyển sang hủy hàng." Phiếu mới 72 lon, ghi chú "Phần còn lại · 2 khách". Dải "Kết thúc thu gom. Thu về đủ 480 / 480 lon (100%). Chuyển sang hủy hàng." Sang bước Hủy hàng thu hồi; việc chờ "Chờ kho hủy hàng". Vai trò khác không có nút này mà thấy "Việc của Thủ kho". |
| 7 | Hết hạn thu hồi | Mở lại board (chưa làm dòng 6), bấm "Mô phỏng: hết hạn thu hồi" | Thông báo "Hết hạn thu hồi — chuyển sang hủy hàng." và dải "Kết thúc thu gom. Hết hạn thu hồi — thu về 408 / 480 lon (85%)." Chuyển sang bước hủy dù chưa thu đủ. |
| 8 | Thu hàng khi chưa thông báo hết khách | Ở board 94 ký Thu hồi, báo đầu cho cơ quan, rồi để `Thủ kho` bấm nhập đủ trước khi CSKH ghi thông báo | Cảnh báo vàng "Chưa thông báo hết khách — CSKH thông báo trước khi khách gửi hàng về." Không có phiếu nhập nào được tạo. |
| 9 | Hủy hàng | Chọn `Thủ kho trưởng`, bấm "Mô phỏng: Thủ kho trưởng xác nhận hủy" | Thông báo "PH-NM1-2610-0019 đã xác nhận — lô chuyển Hủy. Sales đổi lô / hoàn tiền cho khách." Phiếu hủy "480 lon thu về + hàng tồn của 4 lô". Bốn lô L-PGA-05, HH-260916, A260918, A260922 thành "Hủy · đã hủy · PH-NM1-2610-0019"; B261003 vẫn "Khóa · chờ hủy PH-NM1-2610-0010 (21/10)". Trạng thái hồ sơ "Đã xử lý lô". `Thủ kho` bấm được thì chỉ thấy "Việc của Thủ kho trưởng · xác nhận phiếu hủy". |
| 10 | Đổi lô hoặc hoàn tiền sau khi hủy | Làm xong dòng 6 và dòng 9, rồi chọn `Sales` ở bước "Đổi lô mới / hoàn tiền" | Cả 3 khách đều có hai nút "Đổi lô mới" và "Đề nghị hoàn tiền". Bấm "Đổi lô mới" cho KH-0031: "Đã tạo đơn thay thế ĐH-2610-0042 cho KH-0031." Bấm "Đề nghị hoàn tiền" cho KH-0044 (96 lon × 175.000 đ): "Đã gửi đề nghị hoàn tiền — chờ Giám đốc hoặc Kế toán trưởng duyệt số tiền." và số đề nghị "16.800.000 đ". |
| 11 | Các bước sau chưa tới | Mở lại board, bấm bước 7 "Hủy hàng thu hồi" rồi bước 8 "Đổi lô mới / hoàn tiền" khi còn đang thu | "Chưa tới bước này — hủy sau khi thu về đủ hoặc hết hạn thu hồi." Bước 8 báo "Chưa tới bước này — đổi lô / hoàn tiền sau khi hủy xong hàng thu hồi." |

#### 96 · Hồ sơ thu hồi — TH-2609-0003 CAPA đã duyệt, chờ Giám đốc duyệt đóng
Mở board này để kiểm: bước cuối, danh sách kiểm tra trước khi đóng, và việc chỉ Giám đốc được duyệt đóng hồ sơ.
Ô chỉnh trong "Trạng thái hiển thị": không có, chỉ bấm trong board. Mặc định `Giám đốc`; thử vai trò khác bằng "Xem như vai trò".

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Đầu hồ sơ | Mở board | TH-2609-0003, "Đã xử lý lô", "Thu hồi", việc chờ "Chờ Giám đốc duyệt đóng hồ sơ". Bốn ô: "Thu hồi 97,5% (468 / 480 lon · 2 khách)", "Hạn thu hồi 06/10/2026 (đã kết thúc thu gom)", "Lô trong hồ sơ 2 (0 đang khóa)", "Lưu hồ sơ đến 20/02/2029". Bước 1 đến 9 có ✓, bước 10 đang chọn. |
| 2 | Danh sách kiểm tra | Nhìn khối kiểm tra | Bảy dòng đều ✓: "Quyết định: Thu hồi · Lê Quang Minh · 06/09/2026"; "Phạm vi: Tới người dùng · Mức 2 · trung bình"; "% thu hồi: 97,5% · 468 / 480 lon"; "Xử lý lô: Hủy · PH-NM1-2610-0002"; "Đổi lô / hoàn tiền: KH-0052 đổi lô mới ĐH-2610-0029 · KH-0058 hoàn tiền 19.200.000 đ"; "Báo cáo cơ quan: báo đầu · cập nhật tiến độ · báo kết thúc"; "CAPA: 2 hành động · QC trưởng đã duyệt". |
| 3 | Chỉ Giám đốc đóng được | `Xem như vai trò` chọn `QC trưởng`, `Sales`, `Kế toán trưởng`, `CSKH` | Không có nút "Duyệt đóng hồ sơ"; có dòng "Việc của Giám đốc · Giám đốc duyệt đóng hồ sơ" và nút "Xem như Giám đốc". |
| 4 | Duyệt đóng | `Giám đốc` bấm "Duyệt đóng hồ sơ" | Thông báo "Đã đóng hồ sơ." Trạng thái "Đã đóng", việc chờ "Đã đóng". Dòng "Đã đóng 18/10/2026 giờ hiện tại · Lê Quang Minh duyệt. Lưu đến 20/02/2029." Nhật ký thêm "Duyệt đóng hồ sơ" và "Đóng hồ sơ, lưu đến 20/02/2029, không xóa". Nút duyệt biến mất. Về danh sách (board 92): TH-2609-0003 sang thẻ "Đã đóng", thẻ này thành 3. |
| 5 | Đóng khi thiếu báo kết thúc | Ở board 92 chọn `buoc` = `CAPA chờ duyệt`, `QC trưởng` duyệt CAPA, đổi sang `Giám đốc` | Danh sách kiểm tra có dòng "!" "Báo cáo cơ quan: báo đầu · cập nhật tiến độ — chưa báo kết thúc" và dòng nhắc "Chưa có lần "báo kết thúc" gửi cơ quan — QC trưởng nên gửi trước khi đóng." Nút "Duyệt đóng hồ sơ" vẫn bấm được. |
| 6 | Đóng hồ sơ khoanh vùng khi còn lô chờ hủy | Ở board 92 `buoc` = `Khoanh vùng · QC kiểm lại`, `Duyệt không đạt` lô L-BOT-19, rồi `Giám đốc` mở bước Đóng hồ sơ | Dòng "! Xử lý lô: L-BOT-19: Không đạt · A261007: Đạt" nhưng vẫn đóng được, báo "Đã đóng hồ sơ." |

#### Mã mẫu dùng trong phần này (Truy xuất & thu hồi)
| Mã | Là gì | Xuất hiện ở board | Giá trị phải khớp (trạng thái, số lượng, tiền...) |
|---|---|---|---|
| TX-2610-0003 | Phiếu truy ngược từ thùng AT000001 ra lô A261011 | 87, 89, 91, 92, 93, 94 | Hoàn thành, tra chuỗi 0,6 giây, "13 lô · 2 mẻ · 9 nút silo · 7 NCC · 1 khách nhận 20 lon", lệch B261011 → PK-NM1-2610-0006, gắn hồ sơ TH-2610-0003 |
| TX-2610-0004 | Phiếu truy xuôi L-BOT-01 (nguồn YC-NM1-2610-0022) | 87, 90 | Hoàn thành, còn 925 kg tồn + 300 kg đang chuyển, 1 khách nhận 20 lon, chưa gắn hồ sơ thu hồi |
| A261011 | Lô thành phẩm (nhãn A, 800 g), 24 lon | 87, 89, 90, 91, 92, 93, 94 | 20 lon giao KH-0007, 2 lon mẫu lưu, 2 lon còn lại, trạng thái Khóa · Khoanh vùng · TH-2610-0003 |
| B261011 | Lô bán thành phẩm cùng mẻ LSX-2610-0004 | 87, 88, 89, 90, 92, 93, 94 | Vào 1.157 lon, mẫu lưu 3, tồn 1.152 (672 NM1-BTP + 480 NM1-DP), lệch −2 lon, trạng thái Chờ kiểm (QC-NM1-2610-0058) |
| PK-NM1-2610-0006 | Phiếu kiểm kho cho lô lệch B261011 | 87, 88, 89, 90, 92, 93 | Thủ kho Nguyễn Văn Tú lập biên bản 17/10/2026 09:40, lệch 2 lon |
| KH-0007 | Đại lý Minh Phát, khách nhận lô A261011 | 87, 88, 90, 91, 93 | 20 lon, đơn ĐH-2610-0019, phiếu xuất PX-NM1-2610-0035, 16/10/2026 09:30 |
| L-BOT-01 | Lô bột sữa nguyên liệu, nhập 1.625 kg | 88, 90 | Dùng sản xuất 400 kg, tồn 925 kg (900 kg Chờ kiểm + 25 kg Khóa chờ hủy), đang chuyển 300 kg |
| TH-2610-0003 | Hồ sơ thu hồi mở từ TX-2610-0003 | 92, 93, 94 | Lô nghi lỗi A261011; Mức 2 · trung bình; 20 lon ở 1 khách; lưu đến 11/04/2029; hạn thu hồi sau khi ký là 17/11/2026 |
| TH-2610-0002 | Hồ sơ khoanh vùng lô L-BOT-19 | 92 | Quyết định Khoanh vùng 09/10/2026; L-BOT-19 Khóa chưa gửi kiểm; A261007 Đạt (QC-NM1-2610-0052) |
| TH-2610-0001 | Hồ sơ thu hồi lô premix L-PGA-05 | 92, 94, 95 | 480 lon giao 3 khách, thu 408 lon (85%), hạn 02/11/2026, 5 lô trong hồ sơ |
| TH-2609-0003 | Hồ sơ thu hồi lô A260820 (lon hở mí) | 92, 96 | 468 / 480 lon (97,5%), phiếu hủy PH-NM1-2610-0002 948 lon, KH-0058 hoàn 19.200.000 đ, lưu đến 20/02/2029 |
| PH-NM1-2610-0010 | Phiếu hủy lô B261003 (sinh ra khi NM1 mất kết nối) | 92, 95 | 96 lon, hẹn hủy 21/10 |

### 4.8. Danh mục — nguyên vật liệu, sản phẩm, hồ sơ pháp lý chung, đơn vị

Phần này kiểm các màn trong menu Danh mục: nguyên vật liệu (các board 97, 98, 98b, 98c, 98d), sản phẩm (99, 100, 101, 103), hồ sơ pháp lý chung (104a, 104b) và đơn vị (105b, 105c, 105d).

Ba điều cần biết trước khi test:

- "Tham chiếu" nghĩa là nơi đang dùng mã đó (tồn kho, phiếu đang mở, đơn mua đang mở, công thức). Còn tham chiếu thì không ngừng dùng được.
- Khi một vai trò không thuộc nhóm được làm việc, màn hiện dòng "Việc của <vai trò được làm> · <lý do>" kèm nút "Xem như <vai trò>". Bấm nút đó để đổi sang vai trò làm được.
- Ngày "hôm nay" trong màn hồ sơ pháp lý chung và màn sản phẩm là 29/10/2026. Mọi số ngày còn lại tính từ ngày này.

#### 97 · Nguyên vật liệu — danh sách
Mở board này để kiểm: danh sách nguyên vật liệu, hộp xem chi tiết, quyền thêm / sửa / xin ngừng dùng theo vai trò, và nguyên liệu kỵ nhau, ảnh, tồn khả dụng.
Ô chỉnh trong "Trạng thái hiển thị": `vaitro` = `Thủ kho` (mặc định), `Mua hàng`, `Kế hoạch`, `QC`, `Thủ kho trưởng`, `Trưởng BP Mua hàng`, `QC trưởng`, `Admin`; `xem` = `Không` (mặc định), `NVL-BOT-0001`, `NVL-PGA-0004`, `NVL-HHP-0003`, `NVL-PGA-0003`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Danh sách mặc định | `xem` = `Không`, `vaitro` = `Thủ kho` | Chân bảng ghi "14 / 15 nguyên vật liệu" (mã `NVL-PGA-0002` đã ngừng nên bị ẩn). Bảng chia trang, 10 dòng mỗi trang. Có nút "+ Thêm nguyên vật liệu". |
| 2 | Lọc theo trạng thái | Ô "Trạng thái" chọn "Tất cả" | Chân bảng ghi "15 / 15". `NVL-PGA-0002` hiện nhãn "Ngừng sử dụng" kèm chữ "từ 30/06/2026 — thay bằng NVL-PGA-0009". `NVL-PGA-0003` hiện "Chờ duyệt ngừng". |
| 3 | Tồn khả dụng | Xem dòng `NVL-BOT-0001` | Cột "Tồn khả dụng" ghi "7.350 kg", dòng nhỏ "TONG 4.250 · NM2 TONG 700 · DP 2.400". Chỉ tính lô Đạt, không tính lô Chờ kiểm, Khóa, Không đạt hay đang chuyển. `NVL-PGA-0004` ghi "215 kg". `NVL-BBI-0002` ghi "—". |
| 4 | Hộp xem, mã đã có giao dịch | `xem` = `NVL-BOT-0001` | Có HSD chuẩn "540 ngày"; "Đơn vị tính" kèm chữ "· đã có giao dịch, khóa ĐVT"; mục "Nguyên liệu kỵ nhau" có 2 nhãn `NVL-PGA-0004` và `NVL-PGA-0003`; mục ảnh có 2 ảnh, ảnh đầu gắn "Ảnh chính" (quy tắc: tối đa 5 ảnh, ảnh đầu là ảnh chính). |
| 5 | Mã chưa có tồn, chưa có ảnh | `xem` = `NVL-PGA-0003` | Dải cảnh báo "Chờ duyệt ngừng: Lê Văn Hải (Kho) đề nghị 17/10 — chờ Thủ kho trưởng duyệt". Mục ảnh ghi "Chưa có ảnh". Nút ở chân hộp là "Xem đề nghị" (không phải "Xin ngừng sử dụng"). |
| 6 | Nguyên liệu hỗn hợp tự sản xuất | `xem` = `NVL-HHP-0003` | Có dòng "Công thức sinh ra" `CT-HH-0003`. Mục nhà cung cấp ghi "Sản xuất nội bộ ở khu hỗn hợp (lệnh HH)". "Cách bù khi dưới tồn tối thiểu" ghi "Lên lệnh hỗn hợp (sản xuất nội bộ)". |
| 7 | Vai trò được thêm / sửa | `vaitro` = `Mua hàng`, `Kế hoạch`, `QC`, `Thủ kho` (gom một dòng) | Thấy nút "+ Thêm nguyên vật liệu" và biểu tượng Sửa ở các dòng "Đang sử dụng". Dòng đã "Chờ duyệt ngừng" không có biểu tượng Sửa. |
| 8 | Vai trò chỉ xem | `vaitro` = `Thủ kho trưởng`, `Trưởng BP Mua hàng`, `QC trưởng`, `Admin` (gom một dòng) | Không có nút thêm. Thay vào đó hiện "Việc của Mua hàng · bộ phận đề xuất tạo mã" kèm nút "Xem như Mua hàng". Dòng không có biểu tượng Sửa. Mở hộp xem thì nút "Xin ngừng sử dụng" và "Sửa" cũng thay bằng dòng "Việc của Mua hàng · ...". |
| 9 | Tên nút ngừng dùng theo vai trò | `vaitro` = `Kế hoạch`, rồi `Thủ kho` | `Kế hoạch` thấy "Ngừng sử dụng" (Kế hoạch tự ngừng, không qua duyệt). Các vai trò khác thấy "Xin ngừng sử dụng". |
| 10 | Đề nghị ngừng đang chờ: ai xem được | `xem` = `NVL-PGA-0003`, lần lượt `Thủ kho trưởng`, `QC trưởng`, `Admin` | `Thủ kho trưởng` và `QC trưởng` thấy nút "Xem đề nghị". `Admin` thấy "Việc của Mua hàng · bộ phận đề xuất gửi đề nghị". |

#### 98 · Nguyên vật liệu — thêm / ngừng dùng mã
Mở board này để kiểm: thêm mã mới (bắt buộc có ít nhất 1 chỉ tiêu COA, tức giấy chứng nhận phân tích của nhà cung cấp), báo trùng tên, và luồng ngừng dùng có kiểm tham chiếu.
Ô chỉnh trong "Trạng thái hiển thị": `cheDo` = `Thêm mã mới` (mặc định), `Thêm mã — trùng tên`, `Thêm mã — chưa có chỉ tiêu`, `Ngừng dùng — còn tham chiếu`, `Ngừng dùng — chờ duyệt`; `vaitro` = `Thủ kho` (mặc định), `Mua hàng`, `Kế hoạch`, `QC`, `Thủ kho trưởng`, `Trưởng BP Mua hàng`, `QC trưởng`, `Admin`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Thêm mã đầy đủ | `cheDo` = `Thêm mã mới`, `vaitro` = `Thủ kho`, bấm "Lưu và cấp mã" | Form mặc định nhóm `Bột`, HSD chuẩn "180 ngày", 3 chỉ tiêu COA (Độ ẩm, Chất béo, Protein). Thông báo "Đã cấp mã NVL-BOT-0004 — trạng thái Đang dùng, HSD chuẩn 180 ngày, kèm 3 chỉ tiêu COA." (quy tắc: mã tự sinh, không qua duyệt). |
| 2 | Mã đổi theo nhóm | Đổi ô "Nhóm" lần lượt sang `Phụ gia`, `Bao bì`, `Nguyên liệu hỗn hợp` | Mã gợi ý đổi thành `NVL-PGA-0012`, `NVL-BBI-0005`, `NVL-HHP-0006`. Với `Bao bì` mục "Nguyên liệu kỵ nhau" biến mất. Với `Nguyên liệu hỗn hợp` hiện thêm ô bắt buộc "Công thức sinh ra NVL này". |
| 3 | Hạn dùng chuẩn bắt buộc | Xóa trống ô "HSD chuẩn", bấm "Lưu và cấp mã" | Ô đỏ với chữ "Nhập HSD chuẩn là số nguyên > 0." Cạnh nút Lưu hiện "Nhập HSD chuẩn". Chưa cấp mã. Với nhóm hỗn hợp mà chưa chọn công thức thì báo "Chọn công thức hỗn hợp sinh ra NVL này." |
| 4 | Trùng tên | `cheDo` = `Thêm mã — trùng tên` | Ô Tên đỏ, dưới ô ghi "Trùng tên với mã đang dùng NVL-BOT-0001." (bấm mã để mở). Cạnh nút ghi "Trùng tên — dùng mã có sẵn hoặc sửa tên". Không có nút "Lưu và cấp mã". |
| 5 | Chưa có chỉ tiêu COA | `cheDo` = `Thêm mã — chưa có chỉ tiêu` | Dải đỏ "Chưa có chỉ tiêu nào. Cần ít nhất 1 chỉ tiêu COA mới tạo được nguyên vật liệu — thêm từ gợi ý hoặc thêm chỉ tiêu mới." Cạnh nút Lưu ghi "Cần ít nhất 1 chỉ tiêu COA". Bấm một gợi ý (vd "+ Độ ẩm") thì dòng báo biến mất. |
| 6 | Chỉ tiêu COA sai | Bấm "+ Thêm chỉ tiêu", để trống tên; hoặc nhập tối thiểu lớn hơn tối đa | "Nhập tên chỉ tiêu." / "Tối thiểu lớn hơn tối đa." / "Nhập tối thiểu hoặc tối đa." / "Trùng tên chỉ tiêu." Cạnh nút Lưu ghi "Sửa N chỉ tiêu COA chưa hợp lệ". |
| 7 | Nguyên liệu kỵ nhau (chọn nhiều) | Mở "Nguyên liệu kỵ nhau", tìm "lec", tick nhiều mã, bấm "Xong" | Tìm không phân biệt dấu. Dòng thông tin "Đã chọn N · M nguyên liệu". Nút "Chọn cả N kết quả" tick hết kết quả đang lọc. Các mã đã chọn thành nhãn có dấu × để bỏ. Chưa chọn thì ghi "Chưa chọn nguyên liệu kỵ nào." |
| 8 | Tối đa 5 ảnh | Mục "Ảnh nguyên vật liệu": chọn 7 ảnh một lần | Chỉ nhận 5 ảnh, báo "Tối đa 5 ảnh — đã bỏ 2 ảnh thừa." Đếm "5/5 ảnh · ảnh đầu là ảnh chính". Hết chỗ thì không còn ô "Thêm ảnh". Bấm "Đặt làm ảnh chính" đưa ảnh lên đầu. |
| 9 | Vai trò không được thêm | `vaitro` = `Thủ kho trưởng` (hoặc `Trưởng BP Mua hàng`, `QC trưởng`, `Admin`) | Không có nút "Lưu và cấp mã". Thay bằng "Việc của Mua hàng · bộ phận đề xuất tạo mã" và nút "Xem như Mua hàng". |
| 10 | Ngừng dùng khi còn tham chiếu | `cheDo` = `Ngừng dùng — còn tham chiếu` | Tiêu đề "Xin ngừng dùng NVL-PGA-0004" (với `Kế hoạch` là "Ngừng dùng NVL-PGA-0004"). Bảng "Kiểm tham chiếu" nhãn "Còn tham chiếu" ở 3 dòng: Tồn kho (240 kg, khả dụng 215 kg), Phiếu đang mở (`PK-NM1-2610-0003`, `YC-NM1-2610-0027`), Công thức hiệu lực (`CT-HH-0003`, `CT-HH-0005`, `LSX-2610-0013`); "Đơn mua đang mở" nhãn "Hết". Dải "Còn 3 tham chiếu. Xử lý hết rồi bấm Kiểm lại." Nút "Gửi đề nghị" mờ, không bấm được. Bấm "Kiểm lại" ra "Đã kiểm lại: vẫn còn 3 tham chiếu." |
| 11 | Ngừng dùng chờ duyệt | `cheDo` = `Ngừng dùng — chờ duyệt`, `vaitro` = `Thủ kho` | Trạng thái "Chờ duyệt ngừng", mã `NVL-PGA-0003`, "Người duyệt: Thủ kho trưởng". Có nút "Rút đề nghị" (chỉ người đề xuất rút được). Phần duyệt hiện "Việc của Thủ kho trưởng · trưởng bên đề xuất duyệt, người gửi không tự duyệt". Bấm "Rút đề nghị" ra "Đã rút đề nghị — mã giữ Đang dùng." (quy tắc: người đề xuất rút được). |
| 12 | Duyệt và từ chối | Giữ `cheDo` như dòng 11, đổi `vaitro` = `Thủ kho trưởng` | Thấy "Từ chối" và "Duyệt ngừng dùng"; không còn nút "Rút đề nghị" (hiện "Việc của Thủ kho"). Bấm "Duyệt ngừng dùng": "NVL-PGA-0003 đã chuyển Ngừng dùng." Nếu bấm "Từ chối" rồi "Xác nhận từ chối" mà để trống lý do: "Nhập lý do từ chối — người đề xuất sẽ thấy lý do này." Có lý do thì "Đã từ chối đề nghị — NVL-PGA-0003 giữ Đang dùng; người đề xuất thấy lý do." |
| 13 | Ai duyệt thì tùy bộ phận đề xuất | `cheDo` = `Ngừng dùng — chờ duyệt`, lần lượt `QC trưởng`, `Trưởng BP Mua hàng`, `Admin` | Đề nghị này do Thủ kho gửi nên chỉ `Thủ kho trưởng` duyệt được. Ba vai trò còn lại thấy dòng "Việc của Thủ kho trưởng · ..." và không có nút duyệt (quy tắc: trưởng bên đề xuất duyệt, người gửi không tự duyệt). |

#### 98b · Nguyên vật liệu — thêm mã: chưa có chỉ tiêu COA
Mở board này để kiểm: không lưu được mã khi bộ chỉ tiêu COA đang trống.
Ô chỉnh trong "Trạng thái hiển thị": không có, chỉ bấm trong board (board cố định `vaitro` = `Thủ kho`, `cheDo` = `Thêm mã — chưa có chỉ tiêu`).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở board | Không làm gì | Bảng chỉ tiêu COA trống, dải đỏ "Chưa có chỉ tiêu nào. Cần ít nhất 1 chỉ tiêu COA mới tạo được nguyên vật liệu — thêm từ gợi ý hoặc thêm chỉ tiêu mới." Cạnh nút Lưu ghi "Cần ít nhất 1 chỉ tiêu COA". |
| 2 | Bấm Lưu khi trống | Bấm "Lưu và cấp mã" | Không có thông báo "Đã cấp mã". Dòng đỏ vẫn còn. |
| 3 | Gợi ý theo nhóm | Xem dòng "Gợi ý cho nhóm Bột:" | Có các nút "+ Độ ẩm", "+ Chất béo", "+ Protein", "+ Tổng vi sinh vật hiếu khí", "+ Coliforms", "+ Salmonella", "+ Aflatoxin M1". Bấm "+ Độ ẩm" thì bảng có 1 dòng (đơn vị "%", tối đa "5,0") và dải đỏ biến mất. |
| 4 | Chỉ tiêu loại "Đạt / không đạt" | Bấm "+ Thêm chỉ tiêu", đổi kiểu sang "Đạt / không đạt", để trống yêu cầu | Báo "Nhập yêu cầu, vd Không phát hiện." Có yêu cầu thì mới lưu được. |
| 5 | Lưu sau khi sửa đủ | Thêm 1 chỉ tiêu hợp lệ, bấm "Lưu và cấp mã" | "Đã cấp mã NVL-BOT-0004 — trạng thái Đang dùng, HSD chuẩn 180 ngày, kèm 1 chỉ tiêu COA." |

#### 98c · Nguyên vật liệu — sửa mã đã có giao dịch
Mở board này để kiểm: sửa thông tin, bộ chỉ tiêu COA, nguyên liệu kỵ nhau và ảnh của mã đã có giao dịch; danh sách thay đổi trước khi lưu; mã bị khóa không sửa được.
Ô chỉnh trong "Trạng thái hiển thị": `ma` = `NVL-BOT-0001` (mặc định), `NVL-BOT-0003`, `NVL-PGA-0001`, `NVL-HHP-0003`, `NVL-BBI-0002`, `NVL-PGA-0003`, `NVL-PGA-0002`; `vaitro` = `Thủ kho` (mặc định), `Mua hàng`, `Kế hoạch`, `QC`, `Thủ kho trưởng`, `QC trưởng`, `Admin`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở mã đã có giao dịch | `ma` = `NVL-BOT-0001` | Tiêu đề "Sửa nguyên vật liệu NVL-BOT-0001" nhãn "Đang sử dụng". Có 6 chỉ tiêu COA, 2 ảnh ("2/5 ảnh · ảnh đầu là ảnh chính"), 2 nguyên liệu kỵ (`NVL-PGA-0004`, `NVL-PGA-0003`). Mục "Thay đổi" ghi 0, nút Lưu mờ, lý do "Chưa có thay đổi để lưu". |
| 2 | Sửa một ô và lưu | Đổi "Tồn tối thiểu" từ 2.000 sang 2.500, bấm Lưu | Mục "Thay đổi" hiện "Tồn tối thiểu: 2.000 kg → 2.500 kg". Sau khi lưu: "Đã lưu thay đổi NVL-BOT-0001 — 1 mục, ghi nhật ký." Dòng đầu nhật ký mới ghi "Sửa tồn tối thiểu" ở "29/10/2026 · vừa xong". |
| 3 | Trùng tên | Đổi Tên thành "Bột sữa gầy" | "Trùng tên với mã đang dùng" kèm mã `NVL-BOT-0002`. Bấm Lưu thì không lưu, hiện "Còn N chỗ cần sửa". |
| 4 | Thiếu ô bắt buộc | Xóa "HSD chuẩn" hoặc "Điều kiện bảo quản" | "Nhập HSD chuẩn là số nguyên > 0." / "Nhập điều kiện bảo quản." Mục "Kiểm trước khi lưu" có dấu "!" ở dòng "Còn trường thông tin chung chưa hợp lệ". |
| 5 | Sửa và bỏ chỉ tiêu COA | Đổi giới hạn một chỉ tiêu; xóa một chỉ tiêu | Dòng đổi có nhãn "Đã sửa", dòng mới có nhãn "Mới", chỉ tiêu bị xóa nằm ở danh sách "bỏ" kèm nút hoàn tác. Hiện dải "Lô đã kiểm giữ giới hạn lúc kiểm; lô nhập sau khi lưu sẽ kiểm theo bộ chỉ tiêu mới." Đếm dạng "6 chỉ tiêu · 1 sửa, 1 bỏ". |
| 6 | Xóa hết chỉ tiêu COA | Xóa cả 6 dòng | Dải đỏ "Chưa có chỉ tiêu nào. Cần ít nhất 1 chỉ tiêu COA." Dòng kiểm "Chưa có chỉ tiêu COA". Không lưu được. |
| 7 | Nguyên liệu kỵ nhau | Thêm `NVL-BOT-0002` vào danh sách kỵ, bỏ `NVL-PGA-0003` | Nhãn mới có viền "mới"; đếm "2 đã chọn · 1 mới, 1 bỏ". "Thay đổi" ghi "Nguyên liệu kỵ nhau: 2 mã → 2 mã (1 mới, 1 bỏ)". Danh sách chọn không có chính `NVL-BOT-0001`. |
| 8 | Ảnh tối đa 5 | Thêm 4 ảnh vào mã đang có 2 ảnh | Nhận 3 ảnh, báo "Tối đa 5 ảnh — đã bỏ 1 ảnh thừa." |
| 9 | Nhóm bao bì và hỗn hợp | `ma` = `NVL-BBI-0002`, rồi `NVL-HHP-0003` | `NVL-BBI-0002`: không có mục kỵ nhau, 2 chỉ tiêu COA. `NVL-HHP-0003`: ô công thức đã chọn `CT-HH-0003`, nhà cung cấp ghi "Sản xuất nội bộ ở khu hỗn hợp (lệnh HH)", 3 chỉ tiêu COA. |
| 10 | Mã bị khóa | `ma` = `NVL-PGA-0003`, rồi `NVL-PGA-0002` | Mọi ô xám, không sửa được. `NVL-PGA-0003`: "Mã Chờ duyệt ngừng. đang có đề nghị ngừng dùng chờ Thủ kho trưởng duyệt — rút đề nghị rồi mới sửa được." `NVL-PGA-0002`: "Mã Ngừng sử dụng. từ 30/06/2026, chỉ giữ để truy xuất — không sửa được." Nút Lưu mờ, lý do "Mã chờ duyệt ngừng — không sửa được" / "Mã ngừng sử dụng — không sửa được". |
| 11 | Vai trò không được sửa | `vaitro` = `Thủ kho trưởng` (hoặc `QC trưởng`, `Admin`) | Không có nút Lưu; hiện "Việc của Mua hàng · bộ phận đề xuất sửa danh mục" kèm nút "Xem như Mua hàng". |

#### 98d · Nguyên vật liệu — sửa mã chưa có giao dịch
Mở board này để kiểm: sửa mã chưa có giao dịch (cùng form với 98c) và hai mã bị khóa theo trạng thái.
Ô chỉnh trong "Trạng thái hiển thị": `ma` = `NVL-BBI-0002` (mặc định), `NVL-BBI-0004`, `NVL-PGA-0003`, `NVL-PGA-0002`; `vaitro` = `Mua hàng` (mặc định), `Thủ kho`, `Kế hoạch`, `QC`, `Thủ kho trưởng`, `Admin`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mã chưa có giao dịch | `ma` = `NVL-BBI-0002` | Nhóm `Bao bì`, đơn vị "cái", HSD chuẩn "1095 ngày", 2 chỉ tiêu COA (Độ dày, Kích thước), không có mục nguyên liệu kỵ nhau. Nhà cung cấp `NCC-0004` "Bao bì Kim loại Đông Á" · Đã duyệt. Sửa tên và lưu thì ra "Đã lưu thay đổi NVL-BBI-0002 — 1 mục, ghi nhật ký." |
| 2 | Đổi đơn vị tính | Với `NVL-BBI-0002` đổi "Đơn vị tính" (kg, g, lít, cái) rồi lưu | Lưu được; "Thay đổi" ghi "Đơn vị tính: cái → ...". Đây là mã chưa có giao dịch nên không bị khóa đơn vị. |
| 3 | Trùng tên với mã đang dùng | Đổi tên `NVL-BBI-0004` thành "Lon thiếc 900 g, nắp nhôm" | "Trùng tên với mã đang dùng" kèm mã `NVL-BBI-0002`. Không lưu được. |
| 4 | Khóa theo trạng thái | `ma` = `NVL-PGA-0003`, rồi `NVL-PGA-0002` | Giống 98c dòng 10: mọi ô xám, dải cảnh báo, nút Lưu mờ. |
| 5 | Vai trò | `vaitro` = `Thủ kho trưởng` hoặc `Admin` | Không có nút Lưu; hiện "Việc của Mua hàng · bộ phận đề xuất sửa danh mục". Các vai trò `Mua hàng`, `Thủ kho`, `Kế hoạch`, `QC` lưu được. |

#### 99 · Sản phẩm
Mở board này để kiểm: danh sách sản phẩm, hộp xem chi tiết, form tạo / sửa, quyền theo vai trò và duyệt mẫu nhãn.
Ô chỉnh trong "Trạng thái hiển thị": `start` = `danh-sach` (mặc định), `tao-moi`, `sua`, `xem`; `vaitro` = `Kế hoạch` (mặc định), `R&D`, `Thủ kho`, `QC`, `QC trưởng`, `Thủ kho trưởng`, `Admin`. (Ô `screen` không chỉnh được.)

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Danh sách mặc định | `start` = `danh-sach` | Chân bảng "7 / 8 sản phẩm" (`SP-0008` đã ngừng nên ẩn). Mỗi dòng có tiêu đề dạng "Sữa bột trẻ em · Cao cấp · 1–3 tuổi", barcode, quy cách. Ô "Trạng thái" chọn "Mọi trạng thái" thì ra 8 / 8. |
| 2 | Lọc theo trạng thái | Ô "Trạng thái" chọn "Chờ duyệt ngừng", rồi "Ngừng sử dụng" | "Chờ duyệt ngừng": chỉ `SP-0006` (có biểu tượng Sửa). "Ngừng sử dụng": chỉ `SP-0008` (không có biểu tượng Sửa, còn biểu tượng Sao chép). |
| 3 | Hộp xem | `start` = `xem` (mở `SP-0001`) | Thông tin chung: Cấu trúc "Dạng bột", Nhóm "Sữa bột trẻ em", Phân loại "Cao cấp", Độ tuổi "1–3 tuổi", Barcode `8936012345017`, Sản xuất tại "NM1 · Bình Dương", Công thức `CT-BTP-0002`, Hạn sử dụng "720 ngày". Quy cách "Lon: Lon 800 g · 24 lon/thùng (19,2 kg) — mỗi thùng 19,2 kg". Mẫu nhãn `mau-nhan-SP-0001-v2.pdf · v2` Đã duyệt. "Hồ sơ pháp lý chung áp dụng" có 5 hồ sơ. Đơn hàng đang mở: `ĐH-2610-0028`, `ĐH-2610-0031`. |
| 4 | Duyệt mẫu nhãn | Mở `SP-0004` ở hộp xem, `vaitro` = `QC trưởng` | Mẫu nhãn phiên bản 3 nhãn "Chờ QC trưởng duyệt" và có nút "Duyệt mẫu nhãn". Bấm thì ra "Đã duyệt mẫu nhãn mau-nhan-SP-0004-v3.pdf." và nhãn thành "Đã duyệt". Các vai trò khác không có nút duyệt (quy tắc: chỉ QC trưởng duyệt mẫu nhãn). |
| 5 | Sản phẩm chưa có mẫu nhãn | Mở `SP-0007` hoặc `SP-0006` ở hộp xem | Mẫu nhãn ghi "Chưa có mẫu nhãn", trạng thái "Chưa có". |
| 6 | Vai trò được tạo / sửa | `vaitro` = `Kế hoạch`, `Thủ kho`, `QC` | Có nút "+ Tạo sản phẩm", biểu tượng Sửa, Sao chép; hộp xem có "Sửa mẫu nhãn & hồ sơ" và "Sao chép để tạo mới". |
| 7 | Vai trò chỉ xem | `vaitro` = `QC trưởng`, `Thủ kho trưởng`, `Admin` | Không có nút tạo. Hiện "Việc của R&D · bộ phận đề xuất tạo / sửa mã" kèm nút "Xem như R&D". Không có biểu tượng Sửa hay Sao chép. |
| 8 | Vai trò `R&D` | `vaitro` = `R&D` | Đầu trang hiện dải "Vai trò R&D không có quyền vào màn này." với liên kết "Về Việc cần làm", dù phần dưới vẫn hiện nút tạo (xem mục Chỗ lệch). |
| 9 | Màn tạo mới và sửa | `start` = `tao-moi`, rồi `sua` | Xem chi tiết ở board 100 và 103. |

#### 100 · Sản phẩm — tạo mới
Mở board này để kiểm: form tạo sản phẩm với các ô Cấu trúc, Nhóm, Phân loại, Độ tuổi chọn theo tầng, thêm / sửa / xóa lựa chọn ngay trong ô chọn, quy cách đóng gói nhiều tầng, và các lỗi bắt buộc.
Ô chỉnh trong "Trạng thái hiển thị": `start` = `tao-moi` (mặc định), `danh-sach`, `sua`, `xem`, `ngung-dung`; `vaitro` = `Kế hoạch` (mặc định), `R&D`, `Thủ kho`, `QC`, `QC trưởng`, `Thủ kho trưởng`, `Admin`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Bấm Tạo khi để trống | `start` = `tao-moi`, bấm "Tạo sản phẩm" | Dải đỏ "Còn 14 chỗ cần sửa trước khi lưu." (9 ô thông tin, 1 quy cách, 4 ô bản công bố). Lỗi từng ô, vd "Chọn / nhập cấu trúc sản phẩm.", "Chọn / nhập barcode sản phẩm.", "Chọn dụng cụ đóng gói.", "Chọn hình thức công bố.", "Nhập số công bố.", "Chọn ngày công bố.", "Đính kèm ít nhất bản công bố." |
| 2 | Chọn theo tầng | Chọn Cấu trúc `Dạng bột`, rồi Nhóm `Sữa bột trẻ em`; sau đó đổi Cấu trúc sang `Dạng nước` | Khi chưa chọn cấu trúc, ô Nhóm xám ghi "Chọn cấu trúc sản phẩm trước"; chưa chọn nhóm thì Phân loại và Độ tuổi xám ghi "Chọn nhóm sản phẩm trước". Nhóm của `Dạng bột`: Sữa bột trẻ em, Sữa bột người lớn, Bột ăn dặm, Bánh ăn dặm. Đổi cấu trúc thì Nhóm, Phân loại, Độ tuổi bị xóa chọn. Độ tuổi của `Sữa bột trẻ em` gồm 5 mức từ "0–6 tháng" đến "Trên 6 tuổi". |
| 3 | Thêm lựa chọn ngay trong ô | Ở ô Phân loại bấm "+ Khác", gõ "Hạng đặc biệt", bấm "Thêm" | Đóng hộp và chọn luôn, thông báo "Đã thêm Hạng đặc biệt và chọn luôn." Gõ tên đã có (kể cả khác hoa thường) thì ra "Đã có sẵn: ...". Để trống thì "Nhập ít nhất 1 lựa chọn." Có thể gõ nhiều giá trị cách nhau bằng dấu phẩy. |
| 4 | Sửa tên lựa chọn | "+ Khác" ở ô Phân loại, đổi tên `Cao cấp` thành `Cao cấp+`, bấm "Lưu tên" | Dòng ghi "3 sản phẩm dùng". Sau khi lưu: `Đã đổi "Cao cấp" thành "Cao cấp+" — cập nhật cả sản phẩm đang dùng.` Đổi thành tên trùng lựa chọn khác trong cùng tầng: `Tên "..." đã có.`; để trống: "Tên không được trống." |
| 5 | Xóa lựa chọn | "+ Khác" ở ô Phân loại | Lựa chọn đang có sản phẩm dùng (vd `Cao cấp`, 3 sản phẩm) có nút xóa bị khóa, gợi ý "Đang có 3 sản phẩm dùng — không xóa được". Lựa chọn chưa ai dùng (vd Độ tuổi `0–6 tháng` của nhóm Sữa bột trẻ em, ghi "chưa dùng") thì xóa được: `Đã xóa "0–6 tháng".` (quy tắc: chỉ xóa lựa chọn chưa sản phẩm nào dùng). |
| 6 | Barcode và hạn sử dụng | Gõ barcode `123`; rồi `8936012345017`; đặt Hạn sử dụng `0` | `123`: "Barcode gồm 8–14 chữ số." `8936012345017`: "Barcode đã dùng ở SP-0001." Hạn sử dụng: "Nhập số ngày > 0." Ô Công thức chỉ có `CT-BTP-0002`, `CT-BTP-0003`, không có "+ Khác". |
| 7 | Quy cách nhiều tầng | Ở "Quy cách đóng gói" chọn dụng cụ `Hộp`, bấm "+ Thêm cấp" để thêm `Túi` ở trong cùng và `Thùng` ở ngoài cùng | Chuỗi hiện "Túi → Hộp → Thùng", tối đa 4 cấp. Nhập khối lượng tịnh túi 100 g, "Số túi / hộp" 4, "Số hộp / thùng" 24. Dòng tóm tắt "Hộp: Túi 100 g · 4 túi/hộp (400 g) · 24 hộp/thùng (9,6 kg)". Ô khối lượng hộp để trống thì tự tính "= 4 × 100 g". |
| 8 | Quy cách sai | Nhập khối lượng hộp 450 g khi túi 100 g × 4; trộn "g" với "ml"; để trống số túi / hộp; thêm quy cách trùng | "Khác tổng từ cấp trong: 4 × 100 g = 400 g." / "Không trộn đơn vị khối lượng (g, kg) với thể tích (ml, l) trong một quy cách." / "Nhập số túi / hộp (số nguyên > 0)." / "Trùng với quy cách khác." Một sản phẩm có thể thêm nhiều quy cách bằng "+ Thêm quy cách đóng gói". |
| 9 | Hồ sơ pháp lý chung tự gắn | Chọn "Sản xuất tại" `NM1 · Bình Dương`, rồi đổi sang `NM2 · Long An` | `NM1`: tự áp dụng `HS-0001`, `HS-0002`, `HS-0004` (khóa, không bỏ tick được); `HS-0005`, `HS-0006` là tùy chọn. `NM2`: `HS-0003` thay `HS-0002`. Khi tick `HS-0006` (đã hết hạn) hiện dải "HS-0006 hết hạn — cần gia hạn ở Hồ sơ pháp lý chung." |
| 10 | Lưu đủ | Điền đủ rồi bấm "Tạo sản phẩm" | "Đã tạo sản phẩm SP-0009 với 1 quy cách đóng gói — trạng thái Đang sử dụng." Dòng mới được tô nổi trong danh sách. |
| 11 | Mẫu nhãn mới | Tải một file ở mục "Mẫu nhãn theo quy cách" | Nhãn "Chờ QC trưởng duyệt", phiên bản 1. Quy cách chưa chọn dụng cụ thì chỗ tải mờ, ghi "Chưa chọn dụng cụ đóng gói — chưa tải được mẫu nhãn". |
| 12 | Giá trị `ngung-dung` | `start` = `ngung-dung` | Hiện y như danh sách (không có màn ngừng dùng riêng cho sản phẩm; xem mục Chỗ lệch). |

#### 101 · Sản phẩm — xem chi tiết
Mở board này để kiểm: hộp xem chi tiết một sản phẩm, gồm thông tin, quy cách, mẫu nhãn, bản công bố, hồ sơ pháp lý và đơn hàng đang mở.
Ô chỉnh trong "Trạng thái hiển thị": `start` = `xem` (mặc định), `danh-sach`, `tao-moi`, `sua`, `ngung-dung`; `vaitro` = `QC` (mặc định), `Kế hoạch`, `R&D`, `Thủ kho`, `QC trưởng`, `Thủ kho trưởng`, `Admin`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở `SP-0001` | `start` = `xem` | Giống board 99 dòng 3: barcode `8936012345017`, hạn sử dụng 720 ngày, quy cách "Lon 800 g · 24 lon/thùng (19,2 kg)". |
| 2 | Hồ sơ pháp lý chung kèm trạng thái | Cuộn tới "Hồ sơ pháp lý chung áp dụng" | 5 hồ sơ: `HS-0001` (Hiệu lực), `HS-0002` (Hiệu lực, hết hạn 30/06/2027), `HS-0004` (Hiệu lực), `HS-0005` Halal (Hiệu lực), `HS-0006` (Hết hạn). Bấm tên file để mở xem trước. |
| 3 | Bản công bố | Cuộn tới mục bản công bố | Hình thức "Đăng ký bản công bố", số `05/2026/NMA-CB`, ngày "12/05/2026", trạng thái "Hiệu lực", file `ban-cong-bo-SP-0001.pdf`. |
| 4 | Vai trò sửa được | `vaitro` = `QC` hoặc `Kế hoạch` | Chân hộp có "Sửa mẫu nhãn & hồ sơ" và "Sao chép để tạo mới". Bấm "Sửa mẫu nhãn & hồ sơ" mở form với dải "Chỉ sửa được mẫu nhãn và hồ sơ pháp lý ...". |
| 5 | Vai trò chỉ xem | `vaitro` = `QC trưởng`, `Thủ kho trưởng`, `Admin` | Chân hộp chỉ có "Đóng". `QC trưởng` còn có nút "Duyệt mẫu nhãn" ở sản phẩm có mẫu nhãn chờ duyệt (`SP-0004`). |
| 6 | Sản phẩm đã ngừng | Mở `SP-0008` từ danh sách (chọn "Mọi trạng thái") | Nhãn "Ngừng sử dụng", trạng thái bản công bố "Hết hiệu lực"; không có nút "Sửa mẫu nhãn & hồ sơ" dù là vai trò sửa được. |

#### 103 · Sản phẩm — sửa SP-0007: quy cách hộp (túi → hộp → thùng)
Mở board này để kiểm: sản phẩm có quy cách ba tầng, và phần nào khóa khi sửa.
Ô chỉnh trong "Trạng thái hiển thị": `start` = `sua` (mặc định), `danh-sach`, `tao-moi`, `xem`, `ngung-dung`; `vaitro` = `Kế hoạch` (mặc định), `R&D`, `Thủ kho`, `QC`, `QC trưởng`, `Thủ kho trưởng`, `Admin`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở form sửa | `start` = `sua` | Tiêu đề "Sửa sản phẩm SP-0007", mã "SP-0007 · mã không đổi". Dải "Chỉ sửa được mẫu nhãn và hồ sơ pháp lý (bản công bố, hồ sơ riêng, hồ sơ chung tùy chọn). Thông tin sản phẩm, mục khác và quy cách đóng gói gắn với mã SP-0007 và barcode nên khóa — muốn đổi thì sao chép thành sản phẩm mới." |
| 2 | Quy cách ba tầng | Xem mục "Quy cách đóng gói" | Dụng cụ `Hộp`; chuỗi "Túi → Hộp → Thùng". Túi 100 g, "Số túi / hộp" 4, hộp 400 g (tự tính), "Số hộp / thùng" 24, "Khối lượng tịnh mỗi thùng: 9,6 kg". Tóm tắt "Hộp: Túi 100 g · 4 túi/hộp (400 g) · 24 hộp/thùng (9,6 kg)". Cạnh quy cách ghi "Gắn với mã sản phẩm — không sửa (muốn đổi: sao chép thành sản phẩm mới)". |
| 3 | Các ô bị khóa | Thử gõ vào Cấu trúc, Nhóm, Barcode, quy cách | Mọi ô thông tin, mục khác, quy cách đều xám; không có "+ Thêm mục", "+ Thêm quy cách đóng gói". Sản phẩm này chưa có lô hay đơn nào mà vẫn khóa (quy tắc: sản phẩm đã lưu chỉ sửa mẫu nhãn và hồ sơ pháp lý). |
| 4 | Sao chép thành sản phẩm mới | Bấm "Sao chép thành sản phẩm mới" | Form "Tạo sản phẩm · sao chép từ SP-0007" mở, quy cách và thông tin được giữ, barcode trống. Dải "Đã sao chép từ SP-0007: ... Cần nhập mới: barcode, bản công bố, mẫu nhãn từng quy cách. Mã SP mới cấp khi lưu." Ô đã mở khóa. |
| 5 | Tải mẫu nhãn và lưu | Ở form sửa tải một file mẫu nhãn, bấm "Lưu" | Mẫu nhãn quy cách 1 từ "Chưa có" thành "Chờ QC trưởng duyệt". Thông báo "Đã lưu SP-0007 — ghi nhật ký." |
| 6 | Hồ sơ pháp lý của sản phẩm nơi sản xuất NM2 | Xem mục "Hồ sơ pháp lý chung" | Tự áp dụng `HS-0001`, `HS-0004`, `HS-0003` (Sắp hết hạn, còn 42 ngày, gắn nhãn tự áp dụng theo NM2). Dải cảnh báo "HS-0003 sắp hết hạn (còn 42 ngày) — cần gia hạn ở Hồ sơ pháp lý chung." |
| 7 | Vai trò không sửa được | `vaitro` = `QC trưởng`, `Thủ kho trưởng`, `Admin` | Form vẫn mở theo `start`, nhưng ở danh sách và hộp xem các vai trò này không có biểu tượng Sửa. |

#### 104a · Hồ sơ pháp lý chung — danh sách
Mở board này để kiểm: danh sách hồ sơ, phạm vi áp dụng (toàn bộ sản phẩm / theo nơi sản xuất / chọn theo sản phẩm), cảnh báo hết hạn, xóa hồ sơ và quyền theo vai trò.
Ô chỉnh trong "Trạng thái hiển thị": `start` = `danh-sach` (mặc định), `tao-moi`, `sua`, `xem`; `vaitro` = `Giám đốc` (mặc định), `Admin`, `QC trưởng`, `QC`, `R&D`, `Kế hoạch`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Danh sách và cảnh báo | `start` = `danh-sach` | 7 hồ sơ, chân bảng "7 / 7 hồ sơ". Dải vàng "Cần gia hạn: HS-0006 đã hết hạn, đang gắn 3 sản phẩm · HS-0003 còn 42 ngày." Tab: Tất cả 7, Hiệu lực 5, Sắp hết hạn 1, Hết hạn 1. |
| 2 | Ba mức trạng thái | Bấm lần lượt các tab | "Sắp hết hạn": `HS-0003` (hết hạn 10/12/2026, nhắc trước 90 ngày, "Còn 42 ngày"). "Hết hạn": `HS-0006` (hết hạn 30/09/2026, "Quá hạn 29 ngày"). `HS-0001` ghi "Không thời hạn" và vẫn là Hiệu lực. |
| 3 | Phạm vi áp dụng | Ô "Phạm vi áp dụng" chọn từng loại | "Toàn bộ sản phẩm": `HS-0001`, `HS-0004` (mỗi hồ sơ "7 sản phẩm"). "Theo nơi sản xuất": `HS-0002` ("NM1 · Bình Dương · 6 sản phẩm"), `HS-0003` ("NM2 · Long An · 1 sản phẩm"), `HS-0007` ("Gia công bên ngoài · 0 sản phẩm"). "Chọn theo sản phẩm": `HS-0005` (2 sản phẩm), `HS-0006` (3 sản phẩm). |
| 4 | Hộp xem | `start` = `xem` (mở `HS-0006`) | Tiêu đề "HS-0006 · Giấy xác nhận nội dung quảng cáo — nhóm sữa bột trẻ em", nhãn "Hết hạn", "Quá hạn 29 ngày", số hiệu `214/2025/XNQC`, nhắc trước 30 ngày, phạm vi "Chọn theo sản phẩm", "Sản phẩm đang áp dụng" 3: `SP-0001`, `SP-0002`, `SP-0003`. |
| 5 | Giám đốc và Admin sửa được | `vaitro` = `Giám đốc` hoặc `Admin` | Có nút "+ Thêm hồ sơ"; mỗi dòng có biểu tượng Sửa và Xóa; hộp xem có "Xóa hồ sơ" và "Sửa / gia hạn". |
| 6 | Vai trò chỉ xem | `vaitro` = `QC trưởng`, `QC`, `R&D`, `Kế hoạch` (gom một dòng) | Không có nút thêm, Sửa, Xóa. Hiện "Việc của Giám đốc · Giám đốc tạo / sửa / xóa hồ sơ pháp lý chung" kèm nút "Xem như Giám đốc". Vẫn mở xem được từng hồ sơ. |
| 7 | Xóa hồ sơ đang gắn sản phẩm | `Giám đốc`, mở `HS-0006`, bấm "Xóa hồ sơ" | Hộp "Xóa HS-0006?" kèm dải "Hồ sơ đang gắn 3 sản phẩm (SP-0001, SP-0002, SP-0003). Xóa xong, các sản phẩm này sẽ không còn hồ sơ này trong mục Hồ sơ pháp lý chung." Bấm "Xóa hồ sơ": "Đã xóa HS-0006 — gỡ khỏi 3 sản phẩm, ghi nhật ký." Dải cảnh báo chỉ còn `HS-0003`; tab "Hết hạn" về 0. |
| 8 | Xóa hồ sơ chưa gắn sản phẩm | Xóa `HS-0007` | Hộp xóa không có dải cảnh báo. Thông báo "Đã xóa HS-0007 — gỡ khỏi 0 sản phẩm, ghi nhật ký." |
| 9 | Sửa / gia hạn | `start` = `sua` (mở `HS-0003`) | Mã "HS-0003 · mã không đổi — sửa ngày hết hạn và file khi gia hạn". Ghi chú "Đã nộp hồ sơ gia hạn ngày 15/10/2026." Đổi hạn thành 10/12/2027 và Lưu: "Đã lưu HS-0003 — áp dụng lại cho 1 sản phẩm, ghi nhật ký." Trạng thái thành Hiệu lực. |

#### 104b · Hồ sơ pháp lý chung — thêm mới
Mở board này để kiểm: form thêm hồ sơ với ba phạm vi áp dụng và các lỗi bắt buộc.
Ô chỉnh trong "Trạng thái hiển thị": `start` = `tao-moi` (mặc định), `danh-sach`, `sua`, `xem`; `vaitro` = `Giám đốc` (mặc định), `Admin`, `QC trưởng`, `QC`, `R&D`, `Kế hoạch`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Bấm Thêm khi để trống | Bấm "Thêm hồ sơ" | Dải đỏ "Còn 8 chỗ cần sửa trước khi lưu." Lỗi: "Nhập tên hồ sơ.", "Chọn loại hồ sơ.", "Nhập số hiệu.", "Nhập nơi cấp.", "Chọn ngày cấp.", "Chọn ngày hết hạn, hoặc tick Không thời hạn.", "Chọn phạm vi áp dụng.", "Đính kèm file hồ sơ." |
| 2 | Số hiệu trùng, ngày sai | Nhập số hiệu `125/2024/GCNATTP`; ngày cấp 01/01/2027, ngày hết hạn 01/01/2026 | "Số hiệu đã có ở HS-0002." / "Ngày hết hạn phải sau ngày cấp." |
| 3 | Không thời hạn | Tick "Không thời hạn" | Ô ngày hết hạn và ô "Nhắc trước khi hết hạn" bị mờ; dấu * của ngày hết hạn biến mất. Hồ sơ lưu ra ghi "Không thời hạn" và luôn là Hiệu lực. |
| 4 | Phạm vi toàn bộ sản phẩm | Chọn "Toàn bộ sản phẩm" | Dòng "Áp dụng cho 7 sản phẩm". Lưu: "Đã thêm HS-0008 — tự gắn vào 7 sản phẩm thuộc phạm vi." (quy tắc: tự gắn cả sản phẩm tạo sau). |
| 5 | Phạm vi theo nơi sản xuất | Chọn "Theo nơi sản xuất" | Hiện 3 ô tick: "NM1 · Bình Dương" (6 SP), "NM2 · Long An" (1 SP), "Gia công bên ngoài" (0 SP). Không tick ô nào mà lưu: "Chọn ít nhất 1 nơi sản xuất." Tick NM1 và NM2: "Áp dụng cho 7 sản phẩm". |
| 6 | Phạm vi chọn theo sản phẩm | Chọn "Chọn theo sản phẩm" | Hiện danh sách `SP-0001` đến `SP-0007` để tick (không có `SP-0008` đã ngừng). Không tick mà lưu: "Chọn ít nhất 1 sản phẩm." Tick 2 sản phẩm: "Áp dụng cho 2 sản phẩm". |
| 7 | Vai trò | Đổi `vaitro` sang `QC` | Không có nút thêm ở danh sách; chỉ Giám đốc và Admin thấy nút. |

#### 105b · Đơn vị — danh sách
Mở board này để kiểm: danh sách đơn vị, đơn vị đang được dùng thì khóa, đơn vị chưa ai dùng thì sửa / xóa được, và quyền theo vai trò.
Ô chỉnh trong "Trạng thái hiển thị": `vaitro` = `Admin` (mặc định), `Thủ kho trưởng`, `Kế hoạch`, `Mua hàng`, `QC`; `cheDo` = `Danh sách` (mặc định), `Thêm đơn vị`, `Sửa đơn vị mới tạo`, `Xem tham chiếu (khóa)`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Danh sách | `cheDo` = `Danh sách`, `vaitro` = `Admin` | Tiêu đề bảng "Danh sách đơn vị", đếm "11 đơn vị · 9 đang được dùng". Trang 1 có 10 dòng, `ml` nằm ở trang 2. |
| 2 | Đơn vị đang dùng thì khóa | Xem dòng `kg` | Trạng thái "Khóa sửa / xóa", cột Tham chiếu "14 NVL · 9 công thức · 1.240 chứng từ · 4 báo cáo". Thay biểu tượng Sửa / Xóa là biểu tượng khóa, gợi ý "Đang có 1.267 tham chiếu — không sửa, không xóa". |
| 3 | Đơn vị chưa có tham chiếu | Xem dòng `hop` và `ml` | Trạng thái "Mới tạo · sửa được", cột Tham chiếu "Chưa có", có biểu tượng Sửa và Xóa. Chỉ hai dòng này sửa / xóa được. |
| 4 | Lọc | Ô "Tham chiếu" chọn "Đang được dùng (khóa)", rồi "Chưa có tham chiếu"; ô "Loại" chọn `Thể tích` | "Đang được dùng (khóa)": 9 dòng. "Chưa có tham chiếu": `hop`, `ml`. `Thể tích`: `l`, `ml`. Lọc không khớp thì ghi "Không có đơn vị nào khớp bộ lọc." kèm nút "Bỏ lọc". |
| 5 | Thêm đơn vị | `Admin` bấm "+ Thêm đơn vị", nhập mã `gói`, rồi mã `kg`, rồi tên `gam` | Mã `gói`: "Chỉ chữ thường không dấu, số, gạch dưới; tối đa 10 ký tự." Mã `kg`: "Mã kg đã có — không tạo trùng." Tên `gam`: "Tên gam đã có ở đơn vị khác." Để trống mã và tên rồi bấm: "Nhập mã." / "Nhập tên." |
| 6 | Lưu đơn vị mới | Nhập mã `goi`, tên `gói`, loại `Đếm`, bấm "Thêm đơn vị" | "Đã thêm đơn vị goi (gói). Còn sửa / xóa được cho tới khi có NVL, sản phẩm hay chứng từ dùng." Đơn vị mới ở dòng cuối, trạng thái "Mới tạo · sửa được". Đếm thành "12 đơn vị · 9 đang được dùng". |
| 7 | Quy đổi | Trong hộp thêm, chọn đơn vị gốc `gam`, nhập số lượng 0 | "Nhập số lượng > 0 của gam." Nhập 12 thì dòng gợi ý "Sẽ lưu: 1 gói = 12 gam". Thêm loại mới: chọn "+ Khác", để trống tên rồi bấm thêm: "Nhập tên loại." |
| 8 | Xóa đơn vị chưa dùng | Bấm Xóa ở dòng `ml` | Hộp "Xóa đơn vị" với "Chưa có NVL, sản phẩm, công thức hay chứng từ nào dùng đơn vị này. Xóa xong ghi nhật ký hệ thống." Xóa xong: "Đã xóa đơn vị ml (mi-li-lít)." |
| 9 | Vai trò chỉ xem | `vaitro` = `Thủ kho trưởng`, `Kế hoạch`, `Mua hàng`, `QC` (gom một dòng) | Không có nút thêm, không có biểu tượng Sửa / Xóa / khóa. Hiện "Việc của Admin · chỉ Admin thêm / sửa / xóa đơn vị" kèm nút "Xem như Admin". Vẫn bấm vào cột Tham chiếu để xem được. |

#### 105c · Đơn vị — sửa đơn vị mới tạo (chưa có tham chiếu)
Mở board này để kiểm: hộp sửa đơn vị `hop` chưa có tham chiếu.
Ô chỉnh trong "Trạng thái hiển thị": không có, chỉ bấm trong board (board cố định `vaitro` = `Admin`, `cheDo` = `Sửa đơn vị mới tạo`).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở hộp sửa | Không làm gì | Tiêu đề "Sửa đơn vị · hop". Dải "Đơn vị này chưa có tham chiếu nên còn sửa được. Khi đã được dùng, đơn vị sẽ khóa." Mã `hop`, tên `hộp`, loại `Đếm`; dòng `hop` được tô nổi phía sau. |
| 2 | Báo trùng và sai dạng | Đổi mã thành `kg`; xóa trống tên | Mã: "Mã kg đã có — không tạo trùng." Tên: "Nhập tên." sau khi bấm "Lưu". Nút "Lưu" mờ khi còn lỗi. |
| 3 | Lưu | Đổi tên thành `hộp lớn`, bấm "Lưu" | "Đã lưu đơn vị hop." Dòng `hop` có tên mới. |
| 4 | Đổi mã thành mã đã có tham chiếu | Đổi mã thành `lon` | "Mã lon đã có — không tạo trùng." (không được trùng mã đơn vị đang dùng). |

#### 105d · Đơn vị — đơn vị đang dùng: xem tham chiếu, khóa sửa / xóa
Mở board này để kiểm: hộp xem tham chiếu của đơn vị đang dùng (`kg`), chứng minh vì sao khóa.
Ô chỉnh trong "Trạng thái hiển thị": không có, chỉ bấm trong board (board cố định `vaitro` = `Admin`, `cheDo` = `Xem tham chiếu (khóa)`).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở hộp tham chiếu | Không làm gì | Tiêu đề "Tham chiếu của đơn vị kg (ki-lô-gam)". Bốn dòng: Nguyên vật liệu 14, Công thức 9, Chứng từ (phiếu, đơn, lệnh) 1.240, Báo cáo 4 (dòng Sản phẩm bị ẩn vì bằng 0). |
| 2 | Ví dụ mở được | Bấm vào `NVL-BOT-0003`, `CT-HH-0005`, `PN-NM1-2610-0032` | Mỗi mã là liên kết sang màn của mã đó. |
| 3 | Lý do khóa | Đọc dải cuối | "Đơn vị đang có 1.267 tham chiếu nên khóa sửa và xóa — số liệu đã ghi phải giữ nguyên nghĩa. Cần đơn vị khác thì thêm đơn vị mới." Chân hộp chỉ có nút "Đóng", không có nút Lưu hay Xóa. |
| 4 | Đơn vị khác | Đóng hộp, bấm cột Tham chiếu của `tan` và `thung` | `tan`: chỉ dòng Báo cáo 3, không có ví dụ, tổng 3 tham chiếu vẫn khóa. `thung`: Sản phẩm 8, Chứng từ 214, Báo cáo 1, ví dụ `SP-0001`, `ĐH-2610-0041`. |

#### Mã mẫu dùng trong phần này (Danh mục)
| Mã | Là gì | Xuất hiện ở board | Giá trị phải khớp (trạng thái, số lượng, tiền...) |
|---|---|---|---|
| `NVL-BOT-0001` | Bột sữa nguyên kem 26% béo | 97, 98, 98c | Đang sử dụng, đơn vị kg, HSD chuẩn 540 ngày, tồn tối thiểu 2.000 kg, tồn khả dụng 7.350 kg, 6 chỉ tiêu COA, 2 ảnh, kỵ `NVL-PGA-0004` và `NVL-PGA-0003`. Là mã bị báo trùng tên ở board 98. |
| `NVL-BOT-0002` | Bột sữa gầy | 98c (báo trùng tên) | Đang sử dụng; tồn khả dụng 2.476 kg |
| `NVL-PGA-0004` | Lecithin đậu nành | 97, 98 | Đang sử dụng; tồn khả dụng 215 kg; còn tham chiếu ở tồn kho, phiếu đang mở, công thức nên không ngừng dùng được; kỵ `NVL-BOT-0001` |
| `NVL-PGA-0003` | Bột dầu thực vật | 97, 98, 98c, 98d | Chờ duyệt ngừng, Lê Văn Hải (Thủ kho) đề nghị 17/10; người duyệt Thủ kho trưởng; khóa sửa |
| `NVL-PGA-0002` | DHA dạng bột | 97, 98c, 98d | Ngừng sử dụng từ 30/06/2026; thay bằng `NVL-PGA-0009`; khóa sửa |
| `NVL-HHP-0003` | Bột hỗn hợp vi lượng Số 3 | 97, 98c | Công thức sinh ra `CT-HH-0003`; sản xuất nội bộ; 3 chỉ tiêu COA |
| `NVL-BBI-0002` | Lon thiếc 900 g, nắp nhôm | 97, 98c, 98d | Chưa có tồn, chưa có giao dịch; 2 chỉ tiêu COA; đơn vị cái |
| `NVL-BOT-0004`, `NVL-PGA-0012`, `NVL-BBI-0005`, `NVL-HHP-0006` | Mã sẽ cấp khi thêm | 98, 98b | Theo nhóm Bột, Phụ gia, Bao bì, Nguyên liệu hỗn hợp |
| `SP-0001` | Sữa bột trẻ em Cao cấp 1–3 tuổi | 99, 101, 104a | Barcode `8936012345017`, hạn sử dụng 720 ngày, NM1, 1 quy cách "Lon 800 g · 24 lon/thùng (19,2 kg)", mẫu nhãn v2 Đã duyệt, 5 hồ sơ chung áp dụng |
| `SP-0004` | Sữa bột người lớn Phổ thông | 99, 101 | Mẫu nhãn phiên bản 3 "Chờ QC trưởng duyệt" (dùng để thử duyệt) |
| `SP-0006` | Sữa bột trẻ em Phổ thông 1–3 tuổi | 99 | Chờ duyệt ngừng |
| `SP-0007` | Sữa bột trẻ em Cao cấp 3–6 tuổi, NM2 · Long An | 99, 100, 103, 104a | Quy cách "Hộp: Túi 100 g · 4 túi/hộp (400 g) · 24 hộp/thùng (9,6 kg)"; bản công bố `06/2026/NMA-CB`; chưa có mẫu nhãn; áp dụng `HS-0001`, `HS-0003`, `HS-0004` |
| `SP-0008` | Sữa bột trẻ em Trung cấp 3–6 tuổi | 99, 101 | Ngừng sử dụng; bản công bố Hết hiệu lực; mẫu nhãn v1 Đã duyệt 20/09/2026 |
| `HS-0003` | Giấy chứng nhận ATTP của NM2 | 103, 104a, 104b | Hết hạn 10/12/2026, nhắc trước 90 ngày, Sắp hết hạn, còn 42 ngày, áp dụng 1 sản phẩm (`SP-0007`) |
| `HS-0006` | Giấy xác nhận nội dung quảng cáo nhóm sữa trẻ em | 99 (tùy chọn), 104a | Hết hạn 30/09/2026, quá hạn 29 ngày, gắn `SP-0001`, `SP-0002`, `SP-0003` |
| `HS-0007` | Hợp đồng gia công | 104a | Phạm vi "Gia công bên ngoài", 0 sản phẩm; xóa không có cảnh báo |
| `kg`, `hop`, `ml` | Đơn vị | 105b, 105c, 105d | `kg`: 1.267 tham chiếu, khóa. `hop`, `ml`: chưa có tham chiếu, sửa / xóa được |

### 4.9. Nhà máy, khu vực & quản trị hệ thống

Phần này kiểm các luồng cấu hình nền: nhà máy và kho (board 106–110), khu vực làm việc và dàn silo (board 111–112), tài khoản người dùng (board 113, 113b–113e), vai trò và quyền (board 114, 115, 115b, 116), ủy quyền tạm (board 117), tham số và định dạng mã (board 119, 119b), nhật ký hệ thống (board 120–123). Ngày "hôm nay" trên các board này là 18/10/2026. Silo là bồn chứa bột của khu sản xuất. "Ngoại tuyến" là lúc máy chủ nhà máy mất kết nối với hệ thống trung tâm.

#### 106 · Nhà máy — danh sách
Mở board này để kiểm: danh sách nhà máy, các màn xem chi tiết, và hộp "Ngừng hoạt động" của nhà máy, kho, khu (board 107–110 là các trạng thái mở sẵn của cùng màn này).
Ô chỉnh trong "Trạng thái hiển thị": `start` → `danh-sach`, `xem`, `xem-kho`, `xem-khu`, `tao-moi`, `sua`, `ngung-dung`, `sua-thong-tin`; `vaitro` → `Admin`, `Thủ kho trưởng`, `Giám đốc`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Danh sách ba nhà máy | `start` = `danh-sach`, `vaitro` = `Admin` | Ba dòng: NM1 (Nhà máy 1 · Bình Dương), NM2 (Nhà máy 2 · Long An), NM3 (Nhà máy 3 · Đồng Nai, Ngừng hoạt động). Chân bảng "3 / 3 nhà máy". NM1 có "4 kho" ("4 đang hoạt động") và "4 khu · 2 khu sản xuất", "11 silo". NM2 có "4 kho" ("3 đang hoạt động · 1 ngừng") và "3 khu · 3 khu sản xuất". NM3 chưa có kho, "Chưa có khu". Có nút "+ Tạo nhà máy". |
| 2 | Tìm kiếm | Gõ `NM2-DP` hoặc tên kho vào ô tìm | Chỉ còn NM2; chân bảng "1 / 3 nhà máy". Gõ chuỗi không có thì bảng trống. |
| 3 | Xem thông tin nhà máy | `start` = `xem` | Tab "Thông tin" của NM1: tiền tố `A`, điện thoại 0274 3567 210, email nm1@mespowder.vn, người phụ trách Trần Thị Mai, "4 kho", "4 khu", "11 silo". Dòng kết nối đỏ: "Server nhà máy ngoại tuyến từ 08:12". Ba tab: "Thông tin", "Kho" (4), "Khu vực làm việc & dàn silo" (4). |
| 4 | Nhà máy đã ngừng | Bấm biểu tượng xem ở dòng NM3 | Tiền tố `C`, người phụ trách "—", kết nối "Chưa có server nhà máy — dự án tạm dừng 15/08/2026". Không có nút "+ Thêm kho", không có "+ Thêm khu". |
| 5 | Sửa thông tin nhà máy ngay trên tab Thông tin | `start` = `sua-thong-tin`; xóa ô tiền tố, bấm Lưu | Hộp sửa hiện lỗi "Nhập tiền tố mã định danh." và biểu ngữ "Còn N chỗ cần sửa". Gõ `B` thì báo "Tiền tố này đã dùng cho NM2 · Nhà máy 2 · Long An." Gõ `ABCDE` thì báo "Tiền tố gồm 1–4 chữ in hoa hoặc số." Sửa đúng rồi Lưu thì hiện "Đã lưu thông tin nhà máy NM1 · …". |
| 6 | Ngừng hoạt động nhà máy bị chặn | `start` = `ngung-dung` | Hộp "Ngừng hoạt động nhà máy NM2?" báo đỏ: "Chưa ngừng được Nhà máy 2 · Long An: còn 3 kho và 2 khu đang dùng, cùng lệnh sản xuất và tài khoản gắn phạm vi nhà máy này. Ngừng hoạt động các kho / khu trước." Nút duy nhất là "Đóng", không có nút xác nhận. |
| 7 | Chỉ Admin được sửa | `vaitro` = `Thủ kho trưởng`, rồi `Giám đốc` | Hai vai trò này thấy màn nhưng chỉ xem: không có "+ Tạo nhà máy", không có nút Sửa và Ngừng hoạt động. Dòng gợi ý "Việc của Admin · Admin tạo / sửa nhà máy, kho và khu" kèm nút "Xem như Admin". |
| 8 | Vai trò không được vào màn | Đổi vai trò ở thanh trên cùng sang `Sales` | Biểu ngữ "Vai trò Sales không có quyền vào màn này." kèm liên kết "Về Việc cần làm". |

#### 107 · Nhà máy — chi tiết · tab Kho
Mở board này để kiểm: kho điều phối của NM1 và các khu mà kho này cấp nguyên liệu.
Ô chỉnh trong "Trạng thái hiển thị": `start` → mặc định `xem-kho` (các lựa chọn khác như board 106); `vaitro` → `Admin`, `Thủ kho trưởng`, `Giám đốc`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Thẻ kho điều phối đang mở | Giữ `start` = `xem-kho` | Bốn kho của NM1: NM1-TONG (Kho tổng), NM1-DP (Kho điều phối), NM1-BTP, NM1-MAUQC. NM1-DP mở sẵn: "12" lô / mẫu và "4" khu được cấp: NM1-KHH1, NM1-KBTP1, NM1-CR1, NM1-DG1. |
| 2 | Số lô theo kho | Mở lần lượt từng thẻ kho | NM1-TONG 22 dòng, NM1-DP 12 dòng, NM1-BTP 17 dòng, NM1-MAUQC 5 dòng. Dòng hàng bị khóa hay chờ kiểm có chữ màu cảnh báo, ví dụ L-BOT-01 "900 kg Chờ kiểm · 25 kg Khóa". |
| 3 | Một nhà máy có nhiều kho điều phối | Bấm "+ Thêm kho", để loại kho là mặc định | Loại mặc định tự nhảy sang "Kho điều phối" (vì NM1 đã đủ kho tổng, kho BTP, kho mẫu lưu). Mã kho hiện trước là `NM1-DP2`. Gõ tên "Kho điều phối 2 NM1", Lưu: "Đã thêm kho NM1-DP2 · Kho điều phối 2 NM1 cho NM1." |
| 4 | Thêm kho trùng loại không được nhân đôi | "+ Thêm kho", chọn loại "Kho tổng (nguyên liệu)", gõ tên bất kỳ, Lưu | "NM1 đã có kho tổng — mỗi nhà máy chỉ một kho loại này." (kho BTP và kho mẫu lưu QC cũng vậy). |
| 5 | Thêm kho thiếu hoặc trùng tên | Để trống tên, Lưu; rồi gõ "Kho điều phối NM1", Lưu | "Nhập tên kho." rồi "Tên này đã có ở kho khác của NM1." |
| 6 | Đổi tên kho | Bấm Sửa ở NM1-DP, xóa tên, Lưu | "Nhập tên kho." Gõ tên mới hợp lệ: "Đã lưu kho NM1-DP · <tên mới>." |
| 7 | Ngừng kho đang có hàng | Bấm "Ngừng" ở NM1-DP | "Ngừng sử dụng kho NM1-DP?" báo đỏ "còn 12 lô / mẫu đang lưu. Xuất / chuyển hết hàng và đóng phiếu mở trước." Không có nút xác nhận. |
| 8 | Ngừng kho vừa tạo (chưa có hàng) | Sau dòng 3, bấm "Ngừng" ở NM1-DP2 | Hộp cho phép: "Kho Kho điều phối 2 NM1 không còn tồn hay phiếu mở…". Xác nhận thì thẻ chuyển "Ngừng hoạt động", thông báo "Kho NM1-DP2 chuyển Ngừng hoạt động." |
| 9 | Chỉ xem | `vaitro` = `Giám đốc` | Không có "+ Thêm kho", Sửa, Ngừng. Thẻ kho vẫn mở xem được. |

#### 108 · Nhà máy — chi tiết · tab Khu vực làm việc & dàn silo
Mở board này để kiểm: khu NM1-KHH1 (khu hỗn hợp) mở sẵn, dàn silo của khu, các lệnh sản xuất đang xếp vào silo và hộp ngừng dùng khu.
Ô chỉnh trong "Trạng thái hiển thị": `start` → mặc định `xem-khu`; `vaitro` → `Admin`, `Thủ kho trưởng`, `Giám đốc`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Khu hỗn hợp NM1 | Giữ `start` = `xem-khu` | Thẻ NM1-KHH1: loại "Sản xuất nguyên liệu hỗn hợp", kho điều phối cấp nguyên liệu NM1-DP, khối lượng mẻ tối đa "300 kg", thiết bị "Robot nạp bao #1 · RBT-NM1-002", công nhân "6 người · Châu Văn Lực", dàn silo "5 hoạt động / 6 silo · tổng 21.000 kg". |
| 2 | Dàn silo | Nhìn sáu silo | Silo 1, 2, 4, 6 "Hoạt động"; Silo 5 "Bảo trì" (hình mờ). Silo 3 gán cứng "NVL-PGA-0007" kèm "Canxi cacbonat (CaCO3)"; các silo còn lại "Không gán cứng". Mỗi silo có mã thiết bị đo dạng SILO-NM1-H1. Silo 1 ghi "2 lệnh đang xếp NVL", Silo 5 ghi "Chưa lệnh nào dùng". |
| 3 | Lệnh đang xếp vào khu | Nhìn bảng lệnh | LSX-2610-0011 "Chờ phát" và LSX-2610-0013 "Mới tạo", cùng xếp vào "S1, S2, S3, S4, S6" (không có S5). |
| 4 | Khu bán thành phẩm có lệnh đang chạy | Bấm thẻ NM1-KBTP1 | Dàn silo "4 hoạt động / 5 silo · tổng 29.000 kg", khối lượng mẻ "3.000 kg". Bốn lệnh: LSX-2610-0009 "Đang chạy", LSX-2610-0010 "Đã nhận", LSX-2610-0012 và LSX-2610-0014 "Mới tạo". Silo 1 gán cứng NVL-BOT-0001. |
| 5 | Khu không có silo | Bấm NM1-CR1 (chiết rót) hoặc NM1-DG1 (đóng gói) | Dàn silo ghi "Không có"; phần silo trống. Không có lệnh. |
| 6 | Ngừng khu còn lệnh | Bấm "Ngừng" ở NM1-KHH1 | Báo đỏ "còn 2 lệnh sản xuất chưa xong (LSX-2610-0011, LSX-2610-0013). Hoàn thành hoặc hủy lệnh trước." Chỉ có nút "Đóng". |
| 7 | Ngừng khu không còn lệnh | Bấm "Ngừng" ở NM1-CR1, xác nhận | Thông báo "Khu NM1-CR1 chuyển Ngừng hoạt động."; thẻ mờ đi. |
| 8 | Nút mở màn sửa khu theo vai trò | `vaitro` = `Admin`, rồi `Giám đốc` | Admin thấy nút xanh "Sửa khu & dàn silo ↗"; Giám đốc và Thủ kho trưởng thấy nút "Xem cấu hình dàn silo ↗" (chỉ xem), không có nút Ngừng. |

#### 109 · Nhà máy — tạo mới, khai báo kho ngay trên form
Mở board này để kiểm: form tạo nhà máy có sẵn bốn dòng kho, tiền tố mã định danh bắt buộc, và tạo khu ngay trong form.
Ô chỉnh trong "Trạng thái hiển thị": `start` → mặc định `tao-moi`; `vaitro` → `Admin`, `Thủ kho trưởng`, `Giám đốc`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Form mới | Giữ `start` = `tao-moi`, `vaitro` = `Admin` | Tiêu đề "Tạo nhà máy", mã `NM4`. Bốn dòng kho dựng sẵn: Kho tổng (NM4-TONG), Kho điều phối (NM4-DP), Kho BTP (NM4-BTP), Kho mẫu lưu QC (NM4-MAUQC), tên đang trống. Nút "Tạo nhà máy". |
| 2 | Lưu khi để trống hết | Bấm "Tạo nhà máy" | "Còn 7 chỗ cần sửa trước khi lưu." Lỗi: "Nhập tên nhà máy.", "Nhập tiền tố mã định danh.", "Nhập địa chỉ nhà máy.", và "Nhập tên kho." ở cả bốn dòng kho. Điện thoại và email không bắt buộc. |
| 3 | Tiền tố sai hoặc trùng | Gõ tiền tố `A`; rồi `ABCDE` | `A`: "Tiền tố này đã dùng cho NM1 · Nhà máy 1 · Bình Dương." `ABCDE`: "Tiền tố gồm 1–4 chữ in hoa hoặc số." Chữ thường tự đổi thành chữ hoa khi kiểm. |
| 4 | Trùng tên, sai điện thoại, sai email | Tên "Nhà máy 2 · Long An"; điện thoại `123`; email `abc` | "Tên này đã có ở nhà máy khác.", "Số điện thoại gồm 9–11 chữ số.", "Email chưa đúng định dạng." |
| 5 | Nhiều kho điều phối | Bấm "+ Thêm kho" hai lần | Dòng mới mặc định là kho điều phối; mã lần lượt `NM4-DP2`, `NM4-DP3`. Đổi dòng mới sang "Kho tổng (nguyên liệu)" rồi Lưu: "Nhà máy chỉ có một kho tổng." |
| 6 | Tạo khu ngay trong form | Bấm "+ Tạo khu"; Lưu khi chưa đặt tên | Hộp "Tạo khu cho NM4", mã xem trước `NM4-KBTP1`. Lỗi "Nhập tên khu." Silo sức chứa 0: "Nhập sức chứa lớn hơn 0 cho mọi silo." Xóa hết kho điều phối: "Nhà máy chưa có kho điều phối — thêm ở bảng Kho trước." |
| 7 | Lưu thành công | Điền đủ tên, tiền tố `D`, địa chỉ, tên bốn kho, Lưu | Chuyển sang chi tiết NM4 tab khu, thông báo "Đã tạo nhà máy NM4 với 4 kho." (có thêm " · thêm N khu" nếu đã tạo khu). Danh sách thành "4 / 4 nhà máy". |
| 8 | Vai trò chỉ xem | `vaitro` = `Giám đốc` | Có form nhưng không có nút "Tạo nhà máy"; thay bằng "Việc của Admin · Admin tạo / sửa nhà máy, kho và khu". |

#### 110 · Nhà máy — sửa nhà máy & kho (khu mở màn riêng)
Mở board này để kiểm: sửa NM1 cùng danh sách kho; kho đã có hàng thì không đổi loại được; khu sửa ở màn riêng.
Ô chỉnh trong "Trạng thái hiển thị": `start` → mặc định `sua`; `vaitro` → `Admin`, `Thủ kho trưởng`, `Giám đốc`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Form sửa NM1 | Giữ `start` = `sua` | Tiêu đề "Sửa NM1 · Nhà máy 1 · Bình Dương"; tiền tố `A` đã điền. Bốn kho với mã NM1-TONG, NM1-DP, NM1-BTP, NM1-MAUQC. Nút "Lưu thay đổi". |
| 2 | Kho đã có hàng thì khóa loại kho | Nhìn cột Loại kho | Cả bốn ô loại kho bị khóa, ghi chú "22 lô đang chứa — khóa loại kho", "12 lô…", "17 lô…", "5 lô…" theo thứ tự kho. |
| 3 | Thêm kho điều phối thứ hai | "+ Thêm kho", nhập tên "Kho điều phối 2 NM1", Lưu | Dòng mới nền nhạt, mã `NM1-DP2`. Lưu xong về chi tiết tab Kho: "Đã lưu NM1 · thêm 1 kho." |
| 4 | Xóa tiền tố khi sửa | Xóa ô tiền tố, Lưu | "Nhập tiền tố mã định danh." Gõ `B`: "Tiền tố này đã dùng cho NM2 · Nhà máy 2 · Long An." Không tự trùng với chính NM1 khi giữ nguyên `A`. |
| 5 | Dòng khu | Nhìn bảng khu | Bốn khu có sẵn, mỗi khu có nút mở màn sửa riêng (board 111). "+ Thêm khu" mở màn thêm khu (board 112). |
| 6 | Chỉ xem | `vaitro` = `Thủ kho trưởng` | Không có nút "Lưu thay đổi"; có dòng "Việc của Admin…" kèm "Xem như Admin". |

#### 111 · Khu — sửa khu, kho điều phối & dàn silo (màn riêng)
Mở board này để kiểm: sửa khu và dàn silo, chặn đổi loại khu khi còn lệnh, chuyển silo sang bảo trì khi có lệnh bị ảnh hưởng.
Ô chỉnh trong "Trạng thái hiển thị": `cheDo` → `Sửa khu — dàn silo`, `Thêm khu`, `Đổi loại khu — bị chặn`, `Chuyển bảo trì — lệnh bị ảnh hưởng`; `vaitro` → `Admin`, `Kế hoạch`, `Giám đốc`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Sửa khu hỗn hợp NM1 | `cheDo` = `Sửa khu — dàn silo`, `vaitro` = `Admin` | Tiêu đề "Sửa khu NM1-KHH1 · Khu hỗn hợp NM1". "Dàn silo — 5 / 6 silo hoạt động". Silo 3 ghi "NVL-PGA-0007 (gán cứng)". Silo 1 ghi "2 lệnh dùng", Silo 5 ghi "không lệnh nào dùng". Dòng báo "Silo 5 đang bảo trì — không lệnh nào của khu dùng silo này · đã kiểm:" kèm hai lệnh LSX-2610-0011, LSX-2610-0013. |
| 2 | Bảng bảy khu | Nhìn danh sách phía trên | Bảy khu: NM1 bốn khu, NM2 ba khu (NM2-KBTP2 "Ngừng dùng"). Chân bảng "7 / 7 khu". Lọc nhà máy NM2 thì còn "3 / 7 khu". |
| 3 | Đổi loại khu bị chặn | `cheDo` = `Đổi loại khu — bị chặn` | Ô "Loại khu" bị khóa, không chọn được vì khu NM1-KHH1 còn 2 lệnh chưa xong. Nút Lưu vẫn bấm được. Mockup không hiện câu giải thích (xem phần chỗ lệch). Mở khu NM1-CR1 (không lệnh) thì ô Loại khu đổi được. |
| 4 | Chuyển silo sang bảo trì khi có lệnh chưa phát | `cheDo` = `Chuyển bảo trì — lệnh bị ảnh hưởng` | Hộp "Chuyển bảo trì Silo 2 — Khu hỗn hợp NM1", nền vàng: "2 lệnh chưa phát đang xếp nguyên liệu vào Silo 2. Xác nhận sẽ báo Kế hoạch xếp lại dàn silo; các lệnh này bị chặn phát tới khi xếp lại." Liệt kê LSX-2610-0011 (Chờ phát), LSX-2610-0013 (Mới tạo): "báo Kế hoạch xếp lại, chặn phát tới khi xong". |
| 5 | Xác nhận chuyển bảo trì | Bấm "Xác nhận chuyển bảo trì" | Silo 2 thành "Bảo trì"; thông báo vàng "Chuyển bảo trì Silo 2 (Khu hỗn hợp NM1) — đã báo Kế hoạch xếp lại dàn silo cho:" kèm hai lệnh. Nhật ký cuối trang thêm hai dòng mới (Admin chuyển Silo 2 sang bảo trì; hệ thống báo Kế hoạch). Số silo thành "4 / 6 silo hoạt động". |
| 6 | Silo còn bột của lệnh đang chạy | Mở khu NM1-KBTP1, bấm "Chuyển bảo trì" ở Silo 1 | Nền đỏ: "Không chuyển bảo trì được: Silo 1 còn bột của lệnh đang chạy / đã nhận. Chờ silo xả sạch rồi làm lại." Liệt kê 4 lệnh, trong đó LSX-2610-0009 và LSX-2610-0010 ghi "silo còn bột / đã chốt — chặn". Không có nút xác nhận. Ngừng dùng silo ra kết quả tương tự. |
| 7 | Đưa silo bảo trì trở lại | Ở NM1-KHH1 bấm "Đưa vào hoạt động" cho Silo 5 | Silo 5 trở lại "Hoạt động", thông báo "Silo 5 (Khu hỗn hợp NM1) đã đưa vào hoạt động." và số silo thành "6 / 6 silo hoạt động". Dòng "Silo … đang bảo trì" ở trên biến mất. |
| 8 | Ngừng dùng cả khu | Bấm "Ngừng dùng khu" ở NM1-KHH1 | "Không ngừng dùng được Khu hỗn hợp NM1: còn 2 lệnh chưa xong. Hoàn thành hoặc hủy lệnh trước." Ở NM1-CR1: "Đã ngừng dùng Khu chiết rót NM1." |
| 9 | Vai trò không phải Admin | `vaitro` = `Kế hoạch` rồi `Giám đốc` | Kế hoạch: biểu ngữ "Vai trò Kế hoạch không có quyền vào màn này."; Giám đốc: không có biểu ngữ này. Cả hai đều thấy "Việc của Admin · Admin cấu hình khu & dàn silo", không có nút Chuyển bảo trì, Ngừng dùng khu, Lưu, "+ Thêm silo". Hộp ở dòng 4 (mở sẵn khi `cheDo` = `Chuyển bảo trì — lệnh bị ảnh hưởng`) không có nút xác nhận, chỉ có "Đóng". |

#### 112 · Khu — thêm khu (màn riêng)
Mở board này để kiểm: form thêm khu mới kèm dàn silo, mã khu tự sinh.
Ô chỉnh trong "Trạng thái hiển thị": `cheDo` → mặc định `Thêm khu` (các lựa chọn khác như board 111); `vaitro` → `Admin`, `Kế hoạch`, `Giám đốc`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Form thêm khu có sẵn | `cheDo` = `Thêm khu`, `vaitro` = `Admin` | Tiêu đề "Thêm khu — NM1"; tên "Khu bán thành phẩm 2 NM1", loại bán thành phẩm, kho điều phối `NM1-DP · Kho điều phối NM1`, khối lượng mẻ 2000; mã khu tự sinh `NM1-KBTP2`. Bốn silo (8.000, 5.000, 5.000, 3.000), tổng "4 silo · tổng sức chứa 21.000 kg"; Silo 1 gán cứng NVL-BOT-0001. |
| 2 | Thiếu tên khu | Xóa ô tên | Nút "Lưu khu" bị mờ, bấm không được. |
| 3 | Sức chứa không hợp lệ | Sửa sức chứa một silo thành 0 | Ô đó viền đỏ, "Lưu khu" bị mờ. Nhập lại số lớn hơn 0 thì Lưu bấm được. |
| 4 | Bớt silo | Bấm bỏ Silo 2 | Silo đánh số lại từ Silo 1; tổng sức chứa giảm (còn 3 silo, 16.000 kg). Khi chỉ còn một silo thì nút bỏ bị khóa. |
| 5 | Đổi nhà máy hoặc loại khu | Chọn nhà máy NM2; chọn loại "Chiết rót" | Chọn NM2: kho điều phối chỉ còn `NM2-DP · Kho điều phối NM2`, mã đổi sang `NM2-KBTP1`…. Chọn "Chiết rót": phần dàn silo ẩn đi và Lưu không đòi silo. |
| 6 | Lưu thành công | Bấm "Lưu khu" | Chuyển sang màn sửa khu mới, thông báo "Đã tạo khu NM1-KBTP2 · Khu bán thành phẩm 2 NM1 · lấy NVL từ NM1-DP · 4 silo." Bảng khu thành "8 / 8 khu". |
| 7 | Không phải Admin | `vaitro` = `Giám đốc` | Không có nút "Lưu khu"; có dòng "Việc của Admin…". |

#### 113 · Người dùng & vai trò — tài khoản
Mở board này để kiểm: danh sách tài khoản, bộ lọc, ngăn thông tin bên phải, và các hộp tạo, sửa, xóa, đổi vai trò, khóa, mở khóa (board 113b–113e là bốn hộp mở sẵn).
Ô chỉnh trong "Trạng thái hiển thị": `vaitro` → `Admin`, `HR`, `Giám đốc`, `Thủ kho trưởng`; `cheDo` → `Danh sách`, `Tạo tài khoản`, `Sửa — đổi nhà máy`, `Xóa tài khoản`, `Đổi vai trò — phạm vi nhà máy`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Danh sách mặc định | `cheDo` = `Danh sách`, `vaitro` = `Admin` | Danh sách phân trang 10 dòng, chữ "38 / 143 tài khoản". Ngăn bên phải mở sẵn NV0045 Trần Thị Mai: hai vai trò "Thủ kho trưởng" (4 kho NM1) và "QC trưởng · tạm" (ủy quyền thay Võ Thanh Hà, 15/10 → 21/10/2026). |
| 2 | Lọc | Lọc nhà máy NM2; lọc trạng thái "Khóa tạm"; lọc vai trò "Thủ kho điều phối" | NM2: chỉ tài khoản gắn NM2. "Khóa tạm": NV0226 và NV0533. Vai trò "Thủ kho điều phối" có trong ô lọc vai trò; nút xóa bộ lọc đưa về đủ danh sách. |
| 3 | Tài khoản của chính mình | `vaitro` = `Admin`, chọn NV0001; hoặc `vaitro` = `HR`, chọn NV0008 | Không có nút Đổi vai trò, Xóa, Ủy quyền cho tài khoản của chính mình. |
| 4 | Tài khoản đã khóa | Chọn NV0457 (Trần Quốc Duy, "Đã khóa", nghỉ việc 15/10/2026) | Không sửa, không đổi vai trò, không ủy quyền được. |
| 5 | Khóa tạm: chỉ Admin mở | Chọn NV0226 với `vaitro` = `Admin`, rồi `HR` | Admin có nút "Mở khóa / cấp mật khẩu tạm"; HR chỉ thấy "Việc của Admin · xác minh, mở khóa, mật khẩu tạm". |
| 6 | Đặt ngày khóa: chỉ HR | `vaitro` = `HR`, chọn NV0390, bấm đặt ngày khóa | Hộp có ngày nghỉ việc (sẵn 31/10/2026) và ba cách: khóa ngay, khóa vào ngày nghỉ, khóa ngày khác. Xóa ngày nghỉ: "Nhập ngày nghỉ việc dạng dd/mm/yyyy." Admin thấy "Việc của HR" thay cho nút. |
| 7 | Chỉ xem | `vaitro` = `Giám đốc`; rồi `Thủ kho trưởng` | Không có "Tạo tài khoản", Sửa, Xóa, Đổi vai trò; hiện "Việc của HR…". `Thủ kho trưởng` còn thêm biểu ngữ "Vai trò Thủ kho trưởng không có quyền vào màn này." |
| 8 | HR không đụng được tài khoản Admin | `vaitro` = `HR`, chọn NV0001 (Nguyễn Hoàng Long, Admin) | Đổi vai trò bị chặn: "Việc của Admin · tài khoản giữ vai trò chỉ Admin gán". |

#### 113b · Tài khoản — tạo mới: chọn nhà máy & khu vực làm việc
Mở board này để kiểm: form tạo tài khoản công nhân, các ô bắt buộc, chọn nhà máy trước rồi chọn khu.
Ô chỉnh trong "Trạng thái hiển thị": không có, chỉ bấm trong board (board mở sẵn với `vaitro` = `HR`, `cheDo` = `Tạo tài khoản`).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Form điền sẵn | Mở board | Mã NV `NV0563`, tên Trịnh Thị Hoa, chức danh "Công nhân đóng gói", bộ phận Sản xuất, điện thoại 0903 105 630, mã thẻ NV `TNV-0563`, ngày hiệu lực 01/11/2026, nhà máy NM2, khu "Khu bán thành phẩm NM2" (NM2-KBTP1). Các ô bắt buộc có dấu sao: Mã NV, Ngày hiệu lực, Nhà máy làm việc; công nhân thì thêm Mã thẻ NV và Khu vực làm việc. |
| 2 | Lưu thành công | Bấm "Tạo tài khoản" | "Đã tạo tài khoản NV0563 · Trịnh Thị Hoa. Lần đăng nhập đầu phải đổi mật khẩu." Vai trò tự gán "Công nhân", phạm vi "Khu vực làm việc: khu bán thành phẩm NM2". |
| 3 | Thiếu mã NV | Xóa mã NV, bấm Tạo tài khoản | "Nhập mã NV." (hiện sau lần bấm Lưu đầu tiên). |
| 4 | Thiếu mã thẻ của công nhân | Xóa mã thẻ NV, Lưu | "Công nhân phải có mã thẻ NV để đăng nhập PC xưởng." Đổi chức danh sang "Chuyên viên nhân sự" (không phải công nhân) thì mã thẻ hết bắt buộc, gợi ý đổi thành "Không bắt buộc — chỉ dùng đăng nhập PC xưởng". |
| 5 | Mã trùng báo ngay | Gõ mã NV `NV0562`; mã thẻ `TNV-0561` | "Mã NV đã dùng cho NV0562 · Phùng Thị Hà My." và "Mã thẻ đã dùng cho NV0561 · Lương Văn Tâm." (báo ngay khi gõ, không cần bấm Lưu). Điện thoại hoặc email trùng báo tương tự, "SĐT đã dùng cho …", "Email đã dùng cho …". |
| 6 | Ngày hiệu lực sai | Xóa hoặc gõ `2026-11-01`, Lưu | "Nhập ngày hiệu lực dạng dd/mm/yyyy." |
| 7 | Công nhân phải có nhà máy và khu | Đổi nhà máy sang "Mọi nhà máy (văn phòng công ty)", Lưu | "Công nhân phải thuộc một nhà máy cụ thể." Chọn lại NM1: ô khu được xóa và chọn lại được; bỏ trống khu thì "Công nhân phải gắn một khu vực làm việc." |
| 8 | Đổi nhà máy thì khu bị xóa | Đổi NM2 sang NM1 | Ô khu về trống, danh sách khu chỉ còn bốn khu NM1. |

#### 113c · Tài khoản — sửa: đổi nhà máy làm việc (NM1 → NM2)
Mở board này để kiểm: đổi nhà máy làm việc kéo theo phạm vi vai trò theo nhà máy.
Ô chỉnh trong "Trạng thái hiển thị": không có, chỉ bấm trong board (mở sẵn với `vaitro` = `HR`, `cheDo` = `Sửa — đổi nhà máy`).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Hộp sửa NV0164 | Mở board | "Sửa thông tin · Võ Thị Lan"; mã NV `NV0164` ghi "không đổi"; nhà máy làm việc đã chọn NM2 (trong hồ sơ hiện là NM1); mã thẻ trống (không bắt buộc vì không phải công nhân); ngày hiệu lực 02/03/2024. |
| 2 | Lưu đổi nhà máy | Bấm Lưu | "Đã lưu thông tin NV0164 — vai trò theo nhà máy chuyển sang Nhà máy 2 · Long An." Vai trò "Sales" từ "Nhà máy NM1" thành "Nhà máy NM2". Nhật ký tài khoản có dòng "…đổi nơi làm việc: Nhà máy 1 · Bình Dương → Nhà máy 2 · Long An". |
| 3 | Ngày hiệu lực sai | Xóa ngày, Lưu | "Nhập ngày hiệu lực dạng dd/mm/yyyy." Hộp không đóng. |
| 4 | Trùng mã thẻ | Gõ mã thẻ `TNV-0561` | "Mã thẻ đã dùng cho NV0561 · Lương Văn Tâm." Nút Lưu mờ. |
| 5 | Bỏ nhà máy (văn phòng công ty) | Chọn "Mọi nhà máy (văn phòng công ty)" | Gợi ý "Thấy dữ liệu mọi nhà máy (tùy quyền vai trò) · NM3 ngừng hoạt động, không gán"; vai trò Sales chuyển thành "Mọi nhà máy". |

#### 113d · Tài khoản — xóa tài khoản chưa từng dùng
Mở board này để kiểm: chỉ tài khoản chưa từng đăng nhập và chưa có thao tác nào mới xóa được.
Ô chỉnh trong "Trạng thái hiển thị": không có, chỉ bấm trong board (mở sẵn với `vaitro` = `HR`, `cheDo` = `Xóa tài khoản`).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Xóa được | Mở board (NV0562 Phùng Thị Hà My, "Chưa đăng nhập") | Biểu ngữ vàng "Xóa hẳn tài khoản chưa từng dùng. Mã NV NV0562 không cấp lại; thao tác ghi nhật ký hệ thống." Có nút đỏ "Xóa tài khoản". |
| 2 | Bấm xóa | Bấm "Xóa tài khoản" | "Đã xóa tài khoản NV0562 · Phùng Thị Hà My (Nhà máy 2 · Long An)." Tài khoản biến khỏi danh sách (còn "37 / 143"), ngăn bên phải chọn tài khoản kế tiếp. |
| 3 | Đã từng dùng thì không xóa | Đóng hộp, chọn NV0164 (đã đăng nhập 18/10 08:02), mở lại hộp xóa | Biểu ngữ đỏ "Không xóa được: tài khoản đã đăng nhập hoặc đã có thao tác (18/10 08:02) — chứng từ, nhật ký phải giữ tên người làm. Dùng Đặt ngày khóa để khóa tài khoản và giữ lịch sử thao tác." Không có nút xóa; có nút "Đặt ngày khóa thay". |
| 4 | Tài khoản của chính mình | `vaitro` = `HR` trong board 113, chọn NV0008 | Không mở được hộp xóa (không có nút Xóa). |
| 5 | Giữ vai trò chỉ Admin gán | Với `vaitro` = `HR`, chọn NV0001 rồi mở hộp xóa | "Không xóa được: tài khoản giữ vai trò chỉ Admin gán / gỡ." |

#### 113e · Tài khoản — đổi vai trò: mỗi vai trò ở mọi nhà máy hoặc một nhà máy
Mở board này để kiểm: chọn nhiều vai trò, mỗi vai trò một phạm vi nhà máy riêng; Admin và Người truy xuất chỉ Admin gán.
Ô chỉnh trong "Trạng thái hiển thị": không có, chỉ bấm trong board (mở sẵn với `vaitro` = `Admin`, `cheDo` = `Đổi vai trò — phạm vi nhà máy`).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Hộp đổi vai trò NV0188 | Mở board | "Đổi vai trò · Lâm Thảo Vy". Đã chọn `Sales` (phạm vi "Nhà máy NM2") và `CSKH` (phạm vi "Mọi nhà máy"). Danh sách 19 vai trò, trong đó có "Thủ kho điều phối". |
| 2 | Phạm vi theo từng vai trò | Mở ô phạm vi của Sales | Ba lựa chọn: "Mọi nhà máy", "Nhà máy NM1", "Nhà máy NM2". Đổi riêng từng vai trò, vai trò kia giữ nguyên. |
| 3 | Admin luôn mọi nhà máy | Chọn thêm vai trò `Admin` | Phạm vi "Mọi nhà máy" và ô bị khóa, không đổi được. |
| 4 | Lưu | Bấm Lưu | "Đã đổi vai trò của Lâm Thảo Vy." Tài khoản hiện hai thẻ "Sales · Nhà máy NM2" và "CSKH · Mọi nhà máy". Nhật ký: "…đổi vai trò: Sales (Nhà máy NM2), CSKH (Mọi nhà máy)". |
| 5 | Bỏ hết vai trò | Bỏ chọn cả hai | Lưu được; nhật ký ghi "không còn vai trò". |
| 6 | HR không gán được vai trò đặc biệt | Trong board 113 chọn `vaitro` = `HR`, mở hộp đổi vai trò | `Admin` và `Người truy xuất` mờ, chỉ vào được khi trỏ: "Chỉ Admin gán". Ghi chú "Vai trò Admin và Người truy xuất chỉ Admin gán / gỡ được." |

#### 114 · Người dùng & vai trò — vai trò × quyền
Mở board này để kiểm: bảng quyền theo vai trò, Admin sửa quyền và phạm vi nhà máy, danh mục quyền, và việc mỗi vai trò chỉ thấy phần của mình (board 115, 115b, 116 là các trạng thái mở sẵn).
Ô chỉnh trong "Trạng thái hiển thị": `vaitro` → `Admin`, `HR`, `Giám đốc`, `Kế toán trưởng`, `Kế toán`, `Sales`, `CSKH`, `Kế hoạch`, `Mua hàng`, `Trưởng BP Mua hàng`, `Thủ kho`, `Thủ kho điều phối`, `Thủ kho trưởng`, `QC`, `QC trưởng`, `Người truy xuất`; `chedo` → `xem`, `sua-quyen`, `pham-vi-nha-may`, `danh-muc-quyen`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Admin xem | `vaitro` = `Admin`, `chedo` = `xem` | Danh sách 19 vai trò bên trái, chọn sẵn "Thủ kho trưởng": "8 quyền · 9 thao tác", phạm vi mặc định "Kho được gán", nhà máy "Theo nhà máy của tài khoản", hai người giữ (Trần Thị Mai, Nguyễn Văn Tùng). Có nút "Sửa quyền". |
| 2 | Vai trò Thủ kho điều phối | Chọn "Thủ kho điều phối" | "7 quyền · 9 thao tác", phạm vi "Kho điều phối", một người giữ (Hồ Văn Nam). Có nhóm "Sự cố tem" (tạo, sửa, hủy) và nhóm "Xuất kho". Mô tả nói kho điều phối chỉ phục vụ sản xuất, không chứa thành phẩm. |
| 3 | Vai trò Admin không sửa | Chọn "Admin" | Biểu ngữ vàng "Toàn quyền ở mọi nhà máy — … Không sửa quyền vai trò Admin…"; chữ "toàn quyền" thay số quyền; không có nút "Sửa quyền". |
| 4 | HR xem toàn bảng nhưng không sửa | `vaitro` = `HR` | Vẫn thấy cả 19 vai trò; không có nút "Sửa quyền"; hiện "Việc của Admin · chỉ Admin thêm / xóa / sửa quyền" kèm "Xem như Admin". HR vẫn có hai tab xem, trong đó tab "Danh mục quyền" chỉ để xem (thêm, sửa, xóa bị chặn). |
| 5 | Vai trò khác chỉ thấy phần mình | `vaitro` = `Kế toán`, rồi `Sales`, `QC`, `Người truy xuất`… | Chỉ một vai trò trong danh sách (vai trò của mình); dòng "Quyền của vai trò <tên>." kèm "Việc của Admin · xem cả bảng quyền". Không có "Sửa quyền". Riêng `Giám đốc` không có biểu ngữ chặn; các vai trò khác (trừ Admin, HR) có "Vai trò … không có quyền vào màn này." |
| 6 | Lọc và tìm | Gõ "hủy" vào ô tìm; chọn một quy trình | Chỉ còn các quyền có chữ "hủy" hoặc đúng quy trình đã chọn; không có kết quả thì hiện "Không có quyền nào khớp bộ lọc." |
| 7 | Chuyển giữa hai cách xem | Bấm tab "Danh mục quyền" (cạnh tab "Quyền theo vai trò"; chỉ Admin và HR có) | Chuyển sang bảng danh mục (xem board 116). Vai trò khác không thấy tab này. |

#### 115 · Vai trò × quyền — Admin sửa quyền (tick Xem/Tạo/Sửa/Duyệt/Hủy)
Mở board này để kiểm: Admin bật tắt từng thao tác của vai trò Thủ kho trưởng rồi lưu.
Ô chỉnh trong "Trạng thái hiển thị": không có, chỉ bấm trong board (mở sẵn với `vaitro` = `Admin`, `chedo` = `sua-quyen`).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Chế độ sửa | Mở board | Vai trò "Thủ kho trưởng" đang sửa; mỗi quyền có năm ô tick Xem, Tạo, Sửa, Duyệt, Hủy và ô chọn phạm vi. Có công tắc chỉ hiện quyền đang bật. Không đổi sang vai trò khác được khi đang sửa. |
| 2 | Tick một thao tác tự kéo theo Xem | Với một quyền đang tắt, tick "Hủy" | Ô "Xem" tự bật theo. Bỏ tick "Xem" thì mọi thao tác của quyền đó tắt. |
| 3 | Đếm thay đổi | Đổi hai quyền khác nhau | Chỗ "N thay đổi" tăng đúng 2; Bấm "Lưu quyền": "Đã lưu quyền của vai trò Thủ kho trưởng (2 thay đổi) — áp dụng từ lần đăng nhập tới của người giữ vai trò, ghi nhật ký." |
| 4 | Hủy sửa | Bấm Hủy | Quyền về như cũ ("8 quyền · 9 thao tác"). |
| 5 | Phạm vi một quyền | Đổi ô phạm vi của một quyền sang "Chỉ NM1" | Lưu được; quyền đó hiện phạm vi "Chỉ NM1" khi xem lại. Các lựa chọn gồm "Theo vai trò", "Mọi nhà máy", "Nhà máy", "Chỉ NM1", "Chỉ NM2". |

#### 115b · Vai trò × quyền — phạm vi nhà máy của vai trò (theo tài khoản / mọi NM / NM cố định)
Mở board này để kiểm: ba kiểu phạm vi nhà máy cho cả một vai trò.
Ô chỉnh trong "Trạng thái hiển thị": không có, chỉ bấm trong board (mở sẵn với `vaitro` = `Admin`, `chedo` = `pham-vi-nha-may`).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Mở sẵn vai trò Kế hoạch | Mở board | Vai trò "Kế hoạch" ở chế độ sửa; nút phân đoạn chọn "Nhà máy cố định", hai ô NM1 và NM2 đã tick. Số thay đổi "2 thay đổi" (đổi kiểu phạm vi và đổi phạm vi quyền "Tạo / sửa mã NVL, SP" sang "Chỉ NM1"). |
| 2 | Ba kiểu phạm vi | Bấm lần lượt "Theo nhà máy của tài khoản", "Mọi nhà máy", "Nhà máy cố định" | Ghi chú đổi theo: "Mỗi người chỉ thao tác ở nhà máy gán cho tài khoản của họ…"; "Người giữ vai trò thấy và thao tác ở mọi nhà máy, kể cả nhà máy mở sau này."; "Chỉ thao tác ở nhà máy đã chọn, dù tài khoản gán nhà máy nào. Nhà máy mở sau phải tick thêm." |
| 3 | Nhà máy đã ngừng | Nhìn ô thứ ba | "NM3 · Đồng Nai (ngừng)" bị mờ, trỏ vào thấy "Nhà máy đang ngừng hoạt động", không tick được. |
| 4 | Bỏ hết nhà máy | Ở kiểu "Nhà máy cố định", bỏ tick NM1 và NM2 | Lỗi đỏ "Chọn ít nhất 1 nhà máy."; bấm "Lưu quyền" không có tác dụng. |
| 5 | Lưu | Tick lại NM1, bấm "Lưu quyền" | "Đã lưu quyền của vai trò Kế hoạch (2 thay đổi)…". Xem lại: nhà máy của vai trò "Cố định: NM1, NM2". Với vai trò Giám đốc (chọn ở board 114) nhà máy mặc định là "Mọi nhà máy". |

#### 116 · Vai trò × quyền — danh mục quyền (thêm / sửa / xóa)
Mở board này để kiểm: Admin thêm, sửa, xóa một quyền trong danh mục; xóa thì gỡ khỏi mọi vai trò.
Ô chỉnh trong "Trạng thái hiển thị": không có, chỉ bấm trong board (mở sẵn với `vaitro` = `Admin`, `chedo` = `danh-muc-quyen`).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Danh mục | Mở board | "187 quyền · 35 quy trình". Mỗi dòng có phạm vi, số vai trò đang giữ và vài tên vai trò. Ví dụ "Tạo / sửa mã NVL, SP (mã tự sinh theo định dạng)": "4 vai trò", "Kế hoạch, Mua hàng, Thủ kho +1". |
| 2 | Thêm thiếu thông tin | Bấm "+ Thêm quyền", để trống tên, Lưu | "Nhập tên quyền / bước." Chọn quy trình "+ Quy trình mới…" mà để trống tên: "Nhập tên quy trình mới." |
| 3 | Thêm trùng | Thêm quyền cùng tên với quyền có sẵn trong cùng quy trình | `Quy trình "<tên quy trình>" đã có quyền này.` |
| 4 | Thêm và cấp luôn cho vai trò | Thêm quyền mới, tick cấp cho `Kế toán` và `Sales` | "Đã thêm quyền "<tên>" vào <quy trình> và cấp cho Kế toán, Sales." Quyền mới nằm ngay dưới quyền cuối cùng của quy trình đó; mở vai trò Kế toán ở board 114 thấy quyền đó (chỉ có thao tác Xem). |
| 5 | Sửa quyền | Bấm sửa một dòng, đổi tên, Lưu | `Đã lưu quyền "<tên mới>".` Vai trò đang giữ quyền đó vẫn giữ, theo tên mới. |
| 6 | Xóa quyền đang được cấp | Bấm xóa quyền "Tạo / sửa mã NVL, SP…" | Hộp cảnh báo "Đang cấp cho 4 vai trò: Kế hoạch, Mua hàng, Thủ kho, QC. Xóa sẽ gỡ quyền này khỏi tất cả." Xác nhận: `Đã xóa quyền "…" khỏi danh mục và khỏi mọi vai trò.` |
| 7 | Xóa quyền chưa cấp | Xóa quyền vừa thêm ở dòng 2 mà không tick cấp | Hộp báo "Chưa cấp cho vai trò nào." Xóa được ngay. |
| 8 | Không phải Admin | Ở board 114 chọn `vaitro` = `HR` rồi mở tab Danh mục quyền | Chỉ xem, không có nút thêm, sửa, xóa; hiện "Việc của Admin…". |

#### 117 · Người dùng & vai trò — ủy quyền tạm
Mở board này để kiểm: danh sách các lần ủy quyền tạm, thu hồi sớm, và bốn dạng biểu mẫu lập ủy quyền mới.
Ô chỉnh trong "Trạng thái hiển thị": `vaitro` → `Admin`, `HR`, `Giám đốc`; `bieuMau` → `Hợp lệ`, `Thiếu ngày hết hạn`, `Vai trò không ủy quyền được`, `Tự ủy quyền cho mình`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Danh sách gần nhất | `vaitro` = `Admin`, `bieuMau` = `Hợp lệ` | Năm lần ủy quyền: Võ Thanh Hà → Trần Thị Mai, QC trưởng, 15/10 → 21/10/2026 "Hiệu lực" ("còn 3 ngày"); Lê Quang Minh → Bùi Minh Châu, Giám đốc, 22/10 → 30/10/2026 "Sắp bắt đầu"; Tạ Văn Hùng → Mai Anh Thư "Thu hồi sớm"; Bùi Minh Châu → Ngô Bảo Ngọc và Đỗ Minh Khang → Phạm Thu Hương "Hết hạn". Chữ "5 / 5 lần ủy quyền gần nhất". |
| 2 | Xem tất cả | Bấm "Xem tất cả" | Thêm hai lần cũ (tháng 8) "Hết hạn": "7 / 7 lần ủy quyền". |
| 3 | Lập ủy quyền hợp lệ | Với `bieuMau` = `Hợp lệ`, bấm "Lưu ủy quyền" | Biểu mẫu: Nguyễn Văn Tùng (NV0150, Thủ kho trưởng NM2) → Phan Văn Lộc (NV0233, Thủ kho), vai trò Thủ kho trưởng, kho NM2-TONG, NM2-DP, NM2-BTP, bắt đầu 20/10/2026, hết hạn 24/10/2026. Lưu: "Đã lưu ủy quyền tạm Thủ kho trưởng cho Phan Văn Lộc (20/10 → 24/10/2026). Đã báo cả 2 người." Dòng mới "Sắp bắt đầu" ("bắt đầu sau 2 ngày · vừa lập"), nút Lưu mờ để không lưu hai lần. |
| 4 | Thiếu ngày hết hạn | `bieuMau` = `Thiếu ngày hết hạn` | Ô hết hạn trống, viền đỏ: "Bắt buộc ngày hết hạn — đến ngày đó hệ thống tự gỡ vai trò tạm." Nút Lưu mờ, cạnh đó "Sửa các ô báo đỏ để lưu". Gõ một ngày thì lỗi biến mất và Lưu bấm được. |
| 5 | Vai trò không ủy quyền được | `bieuMau` = `Vai trò không ủy quyền được` | Người vắng "Nguyễn Minh Khoa · NV0171 · Sales"; ô vai trò "— không có vai trò ủy quyền được —" viền đỏ: "Nguyễn Minh Khoa chỉ giữ vai trò Sales — không có vai trò duyệt để ủy quyền." Lưu bị khóa. |
| 6 | Tự ủy quyền | `bieuMau` = `Tự ủy quyền cho mình` | Người nhận là chính người đang xem, ví dụ "Nguyễn Hoàng Long · Admin (bạn)" khi `vaitro` = `Admin`, viền đỏ: "Không tự ủy quyền cho chính mình." Lưu bị khóa. |
| 7 | Thu hồi sớm | Ở dòng Võ Thanh Hà → Trần Thị Mai bấm "Thu hồi" | "Đã thu hồi sớm QC trưởng · tạm của Trần Thị Mai. Đã báo cả 2 người." Dòng thành "Thu hồi sớm", ghi chú "<tên người đang xem> thu hồi 18/10". Dòng "Hết hạn" không có nút thu hồi. |
| 8 | Giám đốc chỉ xem | `vaitro` = `Giám đốc` | Xem được danh sách và biểu mẫu; không có "Lưu ủy quyền" và "Thu hồi"; hiện "Việc của HR · HR / Admin lập ủy quyền tạm" kèm "Xem như HR". |

#### 119 · Tham số & định dạng mã (sửa được định dạng mã)
Mở board này để kiểm: bảng tham số mặc định, bảng định dạng mã chứng từ và mã danh mục, và việc chỉ Admin được sửa.
Ô chỉnh trong "Trạng thái hiển thị": `vaitro` → `Admin`, `HR`, `Kế hoạch`, `Thủ kho trưởng`, `Giám đốc`; `man` → `Tham số`, `Định dạng mã`, `Định dạng mã — đang sửa`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Bảng tham số | `man` = `Tham số`, `vaitro` = `Admin` | "23 tham số" chia 5 nhóm: Tài khoản (3), Bán hàng, giao hàng & công nợ (7), Mua hàng & kho (6), Sản xuất & đồng bộ (4), Chất lượng & truy xuất (3). Ví dụ: không đăng nhập "90 ngày" thì tự khóa; PO trên "100.000.000 đ" cần Giám đốc duyệt; "Mất kết nối bao lâu thì vào ngoại tuyến" "30 giây". |
| 2 | Không còn tham số ngoại tuyến tối đa 8 giờ | Tìm trong nhóm "Sản xuất & đồng bộ" | Chỉ có bốn dòng: phát lệnh không tới server nhà máy "10 phút" (NM2 riêng "15 phút (sửa 09/10)", lần sửa cuối "09/10 · Nguyễn Hoàng Long"), mất kết nối "30 giây", giữ hàng đợi gửi lên "30 ngày", giờ lệch "5 phút". Không có dòng giới hạn thời gian ngoại tuyến. |
| 3 | Thời hạn lưu mẫu mặc định | Nhóm "Chất lượng & truy xuất" | "Thời hạn lưu mẫu mặc định (QC quyết từng SP)" giá trị `24` đơn vị "tháng sau HSD" (HSD là hạn sử dụng). Hai dòng còn lại: lưu hồ sơ truy xuất "12 tháng sau HSD", hoàn thành thu hồi "30 ngày". |
| 4 | Tham số cố định | Dòng "Độ dài mật khẩu tối thiểu (có cả chữ và số)" | Hiện "8 ký tự" kèm chữ "cố định", không có ô nhập. |
| 5 | Sửa và lưu tham số | Đổi `24` thành `36` | Ô viền nổi, cột lần sửa cuối "Chưa lưu", nút "Lưu (1)" bật. Lưu: "Đã lưu 1 tham số." Cột lần sửa cuối "18/10 · Nguyễn Hoàng Long". |
| 6 | Định dạng mã | `man` = `Định dạng mã` | Hai bảng: mã chứng từ (20 dòng, 2 trang) và mã danh mục / lô / tem (12 dòng). Ví dụ Đơn hàng `ĐH-YYMM-NNNN` mã mới nhất `ĐH-2610-0041`, mã kế `ĐH-2610-0042`; Mã nhân viên `NV` + 4 chữ số, mã kế `NV0563`; Kho và Số lô nhà cung cấp bị khóa, ghi lý do. Tem QR có năm dòng con (Tem bao, lon, thùng, pallet, mẫu). |
| 7 | Không phải Admin | `vaitro` = `Giám đốc`; rồi `HR`, `Kế hoạch`, `Thủ kho trưởng` | Giám đốc: ô nhập bị mờ, "Việc của Admin · chỉ Admin sửa tham số, định dạng mã", không có nút Lưu; không có biểu ngữ chặn. HR, Kế hoạch, Thủ kho trưởng: thêm biểu ngữ "Vai trò … không có quyền vào màn này." |

#### 119b · Định dạng mã — Admin sửa định dạng mã Đơn hàng
Mở board này để kiểm: hộp sửa định dạng mã, kiểm tiền tố và số chữ số, xem trước mã kế tiếp.
Ô chỉnh trong "Trạng thái hiển thị": không có, chỉ bấm trong board (mở sẵn với `vaitro` = `Admin`, `man` = `Định dạng mã — đang sửa`).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Hộp sửa Đơn hàng | Mở board | Định dạng cũ `ĐH-YYMM-NNNN`, mới `ĐH-YYMM-NNNNN` (5 chữ số), mã kế tiếp `ĐH-2610-00042`. Lý do đã gõ sẵn "Dự kiến > 9.999 đơn / tháng khi mở NM2". Ghi chú "Số chạy tiếp tục từ 00042, đánh lại từ 1 mỗi tháng." |
| 2 | Lưu | Bấm Lưu | "Đã lưu định dạng Đơn hàng: ĐH-YYMM-NNNNN — áp dụng cho mã cấp từ nay, ghi nhật ký hệ thống." Dòng Đơn hàng có nhãn "Sửa … · trước: ĐH-YYMM-NNNN" và mã kế `ĐH-2610-00042`. |
| 3 | Tiền tố trùng | Đổi tiền tố thành `PO` | `Tiền tố PO đã dùng cho Đơn mua (PO) — chọn tiền tố khác để quét mã không nhầm.` Lưu bị mờ. |
| 4 | Tiền tố sai ký tự | Gõ `đh_1` hoặc xóa trống | "Chỉ chữ in hoa, số và dấu gạch ngang." hoặc "Nhập tiền tố." |
| 5 | Số chữ số quá ít | Mở Mã nhân viên (đang chạy số 562), chọn 2 chữ số | "Số đang chạy 563 cần ít nhất 3 chữ số." Lưu bị mờ. |
| 6 | Đổi kỳ đánh lại số | Ở Đơn hàng đổi phần ngày từ `YYMM` sang `YYMMDD` | Ghi chú "Đổi kỳ đánh số nên số chạy bắt đầu lại từ 00001, đánh lại mỗi ngày." (mã kế `ĐH-261029-00001`). |
| 7 | Về định dạng gốc | Sau khi đã lưu một định dạng, mở lại và bấm "Về định dạng gốc" | "Đã trả Đơn hàng về định dạng gốc ĐH-YYMM-NNNN." Lý do sửa là ô không bắt buộc. |

#### 120 · Nhật ký hệ thống — thao tác chứng từ (Admin)
Mở board này để kiểm: bốn loại nhật ký, bộ lọc, mở chi tiết một dòng, và xuất file.
Ô chỉnh trong "Trạng thái hiển thị": `nguoixem` → `Admin`, `HR`; `tab` → `Thao tác chứng từ`, `Tài khoản`, `Quét mã`, `Trạng thái lô`; `chitiet` → `Không mở`, `Đề nghị chuyển kho PC-NM1-2610-0013`, `Xung đột B261018-02`, `Quét L-BOT-01 khi ngoại tuyến`, `Mã đã khóa A-BAO-000233`, `Ủy quyền QC trưởng`, `Hủy LSX-2610-0007`; `xuatfile` → `Đóng`, `Mở`.

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Bốn tab và số dòng | `nguoixem` = `Admin`; đổi `tab` lần lượt | Khoảng thời gian mặc định "30 ngày qua". Thao tác chứng từ "76 / 77 dòng", Tài khoản "20 / 21", Quét mã "17 / 17", Trạng thái lô "38 / 40". Dòng báo "1 dòng cũ hơn khoảng thời gian đang chọn — chọn Thời gian "Tất cả" để xem." (với Trạng thái lô là 2 dòng). |
| 2 | Lọc | Chọn Thời gian "Hôm nay (18/10)"; chọn nhà máy NM2; chọn "Thao tác" = "Hủy" | Thao tác chứng từ "Hôm nay": 42 dòng. Số dòng giảm theo từng bộ lọc; ô "Đối tượng" gõ `PN-NM1-2610-0031` chỉ còn dòng có mã đó. Không khớp thì hiện trạng thái trống, nút bỏ lọc đưa thời gian về "Tất cả". |
| 3 | Chi tiết đề nghị chuyển kho | `chitiet` = `Đề nghị chuyển kho PC-NM1-2610-0013` | Ngăn chi tiết: Kế hoạch Đỗ Minh Khang, 17/10/2026 10:05, nguồn "Web". Phiếu chuyển PC-NM1-2610-0013, "Chờ xuất", NM1-TONG → NM1-DP, 440,0 kg NVL-BOT-0002 (Bột sữa gầy), phần thiếu so với lượng giữ chỗ của LSX-2610-0014. Nút "Mở phiếu chuyển". |
| 4 | Chi tiết hủy lệnh | `chitiet` = `Hủy LSX-2610-0007` | Ngày 16/10/2026 09:05 Đỗ Minh Khang: trạng thái "Mới tạo" → "Đã hủy", lý do "Tạo trùng đơn — thay bằng LSX-2610-0010", giữ chỗ nguyên liệu "2.400,0 kg" → "0,0 kg". |
| 5 | Chi tiết ủy quyền | `chitiet` = `Ủy quyền QC trưởng` | Tự nhảy sang tab Tài khoản: 14/10/2026 16:20 Hoàng Thị Lan (HR) ủy quyền cho Trần Thị Mai (NV0045): vai trò "Thủ kho trưởng" → "Thủ kho trưởng + QC trưởng · tạm", người vắng Võ Thanh Hà · NV0088, 15/10 → 21/10/2026. |
| 6 | Chi tiết xung đột và quét ngoại tuyến | `chitiet` = `Xung đột B261018-02`; rồi `Quét L-BOT-01 khi ngoại tuyến` | Xem board 122 và 123. |
| 7 | Mã đã khóa A-BAO-000233 | `chitiet` = `Mã đã khóa A-BAO-000233` | Mockup không mở được ngăn chi tiết nào (xem phần chỗ lệch). |
| 8 | Xuất file | `xuatfile` = `Mở` | Hộp xuất file: tên `NhatKy_audit_log_18-10-2026.xlsx`, "76" dòng, kèm bộ lọc hiện tại. Chọn CSV thì đuôi `.csv`. Bấm nút "Xuất 76 dòng": "Đã tạo file NhatKy_audit_log_18-10-2026.xlsx · 76 dòng theo bộ lọc hiện tại." Đổi tab sang "Quét mã" rồi mở lại: tên `NhatKy_scan_log_…`, 17 dòng. |
| 9 | Vai trò HR | `nguoixem` = `HR` | Chỉ còn một tab "Tài khoản"; xem board 121. Chọn người xem khác (đổi ở thanh trên cùng, ví dụ `Sales`): "Việc của Admin…", không có tab nào. |

#### 121 · Nhật ký hệ thống — HR chỉ xem nhật ký tài khoản
Mở board này để kiểm: HR chỉ thấy nhật ký tài khoản, và file xuất cũng chỉ gồm loại này.
Ô chỉnh trong "Trạng thái hiển thị": không có, chỉ bấm trong board (mở sẵn với `nguoixem` = `HR`, `tab` = `Tài khoản`).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Chỉ một tab | Mở board | Chỉ có tab "Tài khoản" (20 dòng, "20 / 21 dòng nhật ký tài khoản"); không có tab Thao tác chứng từ, Quét mã, Trạng thái lô. |
| 2 | Các loại thay đổi | Mở ô "Loại thay đổi" | Chín loại: Tạo tài khoản, Sửa thông tin, Đổi vai trò, Đặt ngày khóa, Khóa, Mở khóa, Cấp mật khẩu tạm, Ủy quyền tạm, Hết ủy quyền. |
| 3 | Dòng tiêu biểu | Nhìn bảng | NV0562 Phùng Thị Hà My "Tạo tài khoản" (HR Hoàng Thị Lan, 17/10 15:20); NV0457 Trần Quốc Duy "Khóa" bởi Hệ thống 15/10 00:00; NV0390 Nguyễn Văn Tú "Đặt ngày khóa" 16/10. |
| 4 | Dòng cũ | Nhìn dưới bảng | "1 dòng cũ hơn khoảng thời gian đang chọn…" (dòng đổi vai trò của Võ Thanh Hà ngày 20/08/2026); chọn Thời gian "Tất cả" thì hiện đủ 21 dòng. |
| 5 | Xuất file của HR | Bấm "Xuất file" | Hộp "Xuất file — nhật ký tài khoản" có ghi chú "Với vai trò HR, file chỉ gồm nhật ký tài khoản."; tên `NhatKy_account_change_log_18-10-2026.xlsx`. |

#### 122 · Nhật ký hệ thống — chi tiết: khóa lô B261018-02 do xung đột đồng bộ
Mở board này để kiểm: một lô bị khóa vì lệnh khóa lô nguyên liệu từ trung tâm tới sau khi nhà máy đã dùng lô đó lúc mất kết nối.
Ô chỉnh trong "Trạng thái hiển thị": không có, chỉ bấm trong board (mở sẵn với `nguoixem` = `Admin`, `tab` = `Trạng thái lô`, `chitiet` = `Xung đột B261018-02`).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Chi tiết xung đột | Mở board | Tiêu đề "Lô B261018-02 · Chờ kiểm → Khóa". Ngày giờ 18/10/2026 10:24, nguồn "Đồng bộ lại" (ghi lúc ngoại tuyến, đẩy lên khi có kết nối), người làm "Hệ thống · khi đồng bộ lại", máy chủ nhà máy NM1. |
| 2 | Số lượng bị đổi | Nhìn khối thông tin | "Cả lô · khu chiết rót NM1 (chưa nhập kho) · 1.200 lon · BTP-0412". Trạng thái "Chờ kiểm" → "Khóa"; lý do khóa "—" → "Xung đột khi mất kết nối". |
| 3 | Vì sao xung đột | Đọc phần Lý do | Mẻ 3 (09:20–10:10) dùng bao L-BOT-01 nạp silo 1 lúc 09:18; lệnh khóa L-BOT-01 từ trung tâm (QC trưởng khóa trên hệ thống trung tâm lúc 09:05) tới sau đó; lô khóa theo chuỗi liên kết; QC kiểm lại theo YC-NM1-2610-0023. |
| 4 | Thông tin đồng bộ | Nhìn khối đồng bộ | Mã sự kiện `7f3c9a12-4b0e-4d61-9a2e-0c51e8d2a907`, số thứ tự "NM1 · #18.452", xảy ra "18/10 09:18:07 tại server NM1 (ngoại tuyến)", nhận "18/10 10:24:05", "Gửi 2 lần — lần 2 (10:24:31) trùng mã sự kiện, cloud bỏ qua, không ghi 2 lần". |
| 5 | Các dòng liên quan | Nhìn "Liên quan" | Bốn dòng: xung đột đồng bộ B261018-02 (chứng từ), quét bao nạp silo A-BAO-000229, lô L-BOT-01 "Đạt → Khóa" (khóa từ trung tâm), và yêu cầu kiểm YC-NM1-2610-0023. Bấm một dòng thì chuyển sang chi tiết dòng đó. |
| 6 | Liên kết | Bấm "Mở yêu cầu kiểm" | Mở màn yêu cầu kiểm chất lượng; mã YC-NM1-2610-0023 "Chờ QC trưởng duyệt", lô B261018-02 · 1.200 lon. |

#### 123 · Nhật ký hệ thống — chi tiết: quét bao khi ngoại tuyến, đồng bộ lại
Mở board này để kiểm: lần quét bao nạp silo lúc nhà máy mất kết nối được ghi lại và đồng bộ lên sau.
Ô chỉnh trong "Trạng thái hiển thị": không có, chỉ bấm trong board (mở sẵn với `nguoixem` = `Admin`, `tab` = `Quét mã`, `chitiet` = `Quét L-BOT-01 khi ngoại tuyến`).

| # | Trường hợp | Làm gì (chỉnh ô / bấm) | Phải thấy |
|---|---|---|---|
| 1 | Chi tiết lần quét | Mở board | Tiêu đề "Quét bao nạp silo · thành công". Đầu khung: "Thành công · Quét bao nạp silo · lô L-BOT-01". Người quét Lương Văn Tâm (Công nhân), PC khu BTP NM1, 18/10/2026 09:18, nguồn "Đồng bộ lại". |
| 2 | Mã quét và chứng từ | Nhìn khối thông tin | Mã bao `A-BAO-000229`, lô `L-BOT-01`, chứng từ "LSX-2610-0009 · mẻ 3 · silo 1". |
| 3 | Vì sao vẫn "Đạt" | Đọc ghi chú | "Đạt trên tồn nhà máy — lệnh khóa lô từ trung tâm (QC trưởng khóa trên cloud 09:05) chưa tới (ngoại tuyến từ 08:12)". |
| 4 | Thông tin đồng bộ | Nhìn khối đồng bộ | Cùng mã sự kiện `7f3c9a12-…` và số thứ tự "NM1 · #18.452" với board 122 (cùng một sự kiện); gửi hai lần, lần hai bị bỏ vì trùng. |
| 5 | Quét bị chặn để đối chiếu | Đóng chi tiết, lọc "Kết quả" = "Chặn" | Bảy dòng chặn: A-BAO-000301 "Sai công thức" (Lương Văn Tâm, PC xưởng, 06:05), A-BAO-000355 và A260928-013 "Đang kiểm kê", B261017-021 "Sai nhãn hiệu", A241012-002 "Hết hạn", B261011-004 "Sai trạng thái", A260920-011 "Sai lô". |
| 6 | Dòng liên quan | Nhìn "Liên quan" | Ba dòng: xung đột B261018-02, lô L-BOT-01 "Đạt → Khóa", lô B261018-02 "Chờ kiểm → Khóa". |

#### Mã mẫu dùng trong phần này (Nhà máy, khu vực & quản trị hệ thống)
| Mã | Là gì | Xuất hiện ở board | Giá trị phải khớp (trạng thái, số lượng, tiền...) |
|---|---|---|---|
| NM1 | Nhà máy 1 · Bình Dương | 106–110, 111, 112, 113 | Tiền tố `A`; 4 kho, 4 khu, 11 silo; người phụ trách Trần Thị Mai; "ngoại tuyến từ 08:12" |
| NM2 | Nhà máy 2 · Long An | 106–110, 111, 113b, 113c | Tiền tố `B`; 4 kho (3 đang hoạt động), 3 khu, 13 silo; "đang kết nối" |
| NM3 | Nhà máy 3 · Đồng Nai | 106, 114 (ô nhà máy), 115b | Tiền tố `C`; Ngừng hoạt động; không kho, không khu; không tick được |
| NM1-DP | Kho điều phối NM1 | 106–108, 110, 111, 112 | 12 lô / mẫu; cấp nguyên liệu cho 4 khu NM1 |
| NM1-KHH1 | Khu hỗn hợp NM1 | 108, 110, 111 | 6 silo (5 hoạt động, Silo 5 bảo trì); mẻ tối đa 300 kg; 2 lệnh chưa xong |
| NM1-KBTP1 | Khu bán thành phẩm NM1 | 108, 111 | 5 silo (4 hoạt động); mẻ tối đa 3.000 kg; 4 lệnh chưa xong |
| LSX-2610-0009 | Lệnh sản xuất khu NM1-KBTP1 | 108, 111, 123 | "Đang chạy"; mẻ 3 nạp Silo 1 bằng bao lô L-BOT-01 lúc 09:18 ngày 18/10 |
| LSX-2610-0011 / 0013 | Hai lệnh khu NM1-KHH1 | 108, 111 | "Chờ phát" / "Mới tạo"; cùng xếp vào Silo 1, 2, 3, 4, 6 |
| NV0045 | Trần Thị Mai | 113, 114, 117, 120 | Thủ kho trưởng NM1; QC trưởng tạm 15/10 → 21/10/2026 thay Võ Thanh Hà (NV0088) |
| NV0562 | Phùng Thị Hà My | 113, 113b, 113d, 121 | Sales NM2; chưa đăng nhập; xóa được |
| NV0563 | Mã nhân viên kế tiếp (Trịnh Thị Hoa) | 113b, 119 | Mã kế tiếp của định dạng Mã nhân viên (đang chạy số 562) |
| NV0164 | Võ Thị Lan | 113, 113c, 113d | Sales; NM1 → NM2 khi sửa; đã đăng nhập 18/10 08:02 (không xóa được) |
| NV0188 | Lâm Thảo Vy | 113, 113e | Sales + CSKH; Sales "Nhà máy NM2", CSKH "Mọi nhà máy" |
| NV0150 → NV0233 | Nguyễn Văn Tùng ủy quyền Thủ kho trưởng cho Phan Văn Lộc | 117 | 20/10 → 24/10/2026; kho NM2-TONG, NM2-DP, NM2-BTP |
| Thủ kho điều phối | Vai trò (Hồ Văn Nam, NV0418) | 113, 113e, 114 | 7 quyền · 9 thao tác; phạm vi "Kho điều phối" |
| ĐH-2610-0041 | Mã Đơn hàng mới nhất | 119, 119b | Mã kế `ĐH-2610-0042`; sau khi sửa 5 chữ số: `ĐH-2610-00042` |
| L-BOT-01 | Lô bột sữa nguyên kem (NVL-BOT-0001) | 108 (gán cứng Silo 1 khu NM1-KBTP1), 122, 123 | NM1-TONG ghi 900 kg Chờ kiểm, 25 kg Khóa; QC trưởng khóa lúc 09:05 ngày 18/10 |
| B261018-02 | Lô bán thành phẩm bị khóa do xung đột | 120, 122, 123 | 1.200 lon; "Chờ kiểm" → "Khóa"; lý do "Xung đột khi mất kết nối"; chưa nhập kho |
| YC-NM1-2610-0023 | Yêu cầu kiểm lô B261018-02 | 120, 122 | "Chờ QC trưởng duyệt", tạo 18/10 10:35 bởi Đỗ Minh Khang |
| PC-NM1-2610-0013 | Đề nghị chuyển kho NM1-TONG → NM1-DP | 120 | "Chờ xuất"; 440,0 kg NVL-BOT-0002 |
| LSX-2610-0007 | Lệnh sản xuất bị hủy | 120 | "Mới tạo" → "Đã hủy"; giữ chỗ 2.400,0 kg → 0,0 kg |

## 5. Chỗ lệch đã thấy khi viết hướng dẫn (chưa sửa)

Đây là chỗ mockup tự lệch giữa các board hoặc lệch với tài liệu quy trình, phát hiện khi đọc mã mockup để viết hướng dẫn. Chưa sửa gì. Người test gặp các chỗ này thì đánh dấu "đã biết", không cần báo lại. Số dòng trong ngoặc là chỗ tra trong file mockup hoặc tài liệu.

### 5.1. Chung toàn mockup

- Menu bên trái không giống nhau giữa các màn. 10 màn Danh mục (Nguyên vật liệu, Sản phẩm, Hồ sơ pháp lý, Đơn vị, Công thức, Nhà máy, Khu) có thêm mục "Hồ sơ pháp lý"; các màn khác không có. Ở màn Sản phẩm và Hồ sơ pháp lý, mục Sản phẩm cho R&D thay vì Mua hàng; các màn khác cho Mua hàng. Bảng ở mục 2 theo bản có mục Hồ sơ pháp lý và Sản phẩm cho Mua hàng. Ai được đề xuất tạo sản phẩm (R&D hay Mua hàng) đang chờ chốt.
- Hai màn Tổng quan Giám đốc (board 7) và Hồ sơ & biểu mẫu in (board 8) không có lối vào từ menu của 137 màn còn lại. Chỉ hai màn này dẫn qua lại với nhau.
- "Hôm nay" của dữ liệu mẫu khác nhau giữa các phân hệ: Kho và Nhà máy lấy 18/10, Tổng quan lấy 24/10, Sản phẩm và Hồ sơ pháp lý lấy 29/10. Vì vậy số ngày quá hạn, số ngày còn lại và ngày "In lại" lệch nhau giữa các board. Khi test, so ngày trong cùng phân hệ trước, rồi ghi riêng chỗ lệch giữa phân hệ.

### 5.2. Chung — đăng nhập, việc cần làm, tổng quan Giám đốc, hồ sơ và biểu mẫu in

- Số ngày quá hạn của khách KH-0012 khác nhau: Việc cần làm ghi "quá hạn 3 ngày" (`HopDuyet.dc.html:436`), Tổng quan ghi "quá hạn 4 ngày" (`TongQuanGiamDoc-g1dx.dc.html:281`). Hai board dùng hai mốc ngày khác nhau (Việc cần làm quanh 17–21/10, Tổng quan 24/10), nên cần thống nhất mốc.
- Tổng quan kỳ `7 ngày` ghi 14.880 lon (`TongQuanGiamDoc-g1dx.dc.html:298`), nhưng cộng 7 cột gần nhất của biểu đồ 14 ngày (18/10 đến 24/10) được 14.400 lon (`:304`). Kỳ `Hôm nay` (1.920) và `Tháng này` khớp kế hoạch.
- Tổng quan ghi "Đã nhắc nợ 25/10" trong khi ngày xem là 24/10 (`TongQuanGiamDoc-g1dx.dc.html`, khung tài chính, dòng KH-0012).
- Phiếu nhập PN-NM1-2610-0031: Việc cần làm và Tổng quan đều ghi chờ xác nhận lệch, còn Hồ sơ & biểu mẫu in ghi "Đã ký", đã in 1 lần (`HoSoBieuMau-p7rn.dc.html:256`). Tương tự phiếu hủy PH-NM1-2610-0013 (Việc cần làm: đang chờ xác nhận; Hồ sơ: "Đã ký", `:258`) và phiếu chuyển kho PC-NM1-2610-0013 (Việc cần làm: chờ nhận và quét; Hồ sơ: "Đã ký" ngày 20/10, `:259`). Có thể do hai board ở hai thời điểm khác nhau, nhưng nên ghi rõ mốc.
- Phiếu xuất PX-NM1-2610-0044: Việc cần làm bảo Sales chọn xuất một phần hoặc hủy (`HopDuyet.dc.html:403`), Hồ sơ & biểu mẫu in đã ghi "Đã hủy" ngày 19/10 (`HoSoBieuMau-p7rn.dc.html:260`).
- Các mốc ngày của cùng một chứng từ không khớp: QC-NM1-2610-0058 là 17/10 ở Việc cần làm nhưng lập 23/10 ở Hồ sơ (`:264`); TH-2610-0003 chờ từ 18/10 ở Việc cần làm và Tổng quan nhưng lập 24/10 ở Hồ sơ (`:270`), người lập là Võ Thanh Hà trong Hồ sơ nhưng là Trần Thị Mai (ủy quyền QC trưởng) trong Việc cần làm.
- Hồ sơ & biểu mẫu in ghi Trần Thị Mai ký phiếu chứng nhận chất lượng CN-NM1-2609-0014 (23/09, `:261`) và biên bản hủy mẫu lưu BB-ML-2609-0003 (30/09, `:265`), trong khi bà chỉ giữ vai trò QC trưởng từ 15/10 theo ủy quyền; trước đó QC trưởng là Võ Thanh Hà.
- Người lập hóa đơn 0000902 là Trần Thị Ngọc (Hồ sơ), còn Kế toán ở Việc cần làm là Ngô Bảo Ngọc.
- Việc "Nhận & quét chuyển kho" các phiếu về NM1-DP (PC-NM1-2610-0013, PC-NM2-2610-0014) và việc "Đếm kiểm điểm" PK-NM1-2610-0005 nằm ở mục chú thích Thủ kho điều phối Hồ Văn Nam, nhưng gán vai trò `Thủ kho` nên hiện cho Lê Văn Hải (`HopDuyet.dc.html:357–360`); Hồ Văn Nam chỉ thấy 1 việc được giao. Quy trình ghi thủ kho kho nhận mới là người nhận hàng chuyển kho.
- Thanh báo sau khi bấm "Xác nhận" ở việc LSX-2610-0009 của Kế hoạch ghi "Đã xác nhận · me:LSX-2610-0009" (còn tiền tố `me:` vì thanh báo không lược bỏ, `HopDuyet.dc.html:491`).
- Vai trò `Vận chuyển` (và `R&D` ở ô "Xem như") không có việc nào, dòng giới thiệu hiện ngoặc rỗng "Việc đang đợi Phan Văn Toàn () từ mọi phân hệ" (`HopDuyet.dc.html:593`).
- Việc ĐH-2610-0034 của Giám đốc chờ Kế toán ghi nhận tiền về, nhưng việc "Ghi nhận tiền về" của Kế toán không có nút làm, nên trong mockup Giám đốc không bao giờ mở khóa được dòng này (tương tự "Gửi PO cho NCC" chờ Kế toán ghi nhận trả trước).
- Quy trình ghi nhà máy mất mạng thì Việc cần làm hiện chip "mất kết nối từ HH:MM · N thao tác chờ gửi" (`docs/mes-powder-quy-trinh.md:2305`); board Việc cần làm chỉ có một tin trong chuông, không có chip này.
- Hồ sơ & biểu mẫu in: lý do in lại chỉ hỏi với phiếu đã ký, lựa chọn "+ Khác" không có ô nhập chữ; nút "In cả bộ hồ sơ" không tăng số lần in và ghi "BẢN SAO" cho cả phiếu chờ ký (hộp thoại in từng phiếu lại đóng dấu BẢN NHÁP); nút "PDF" của phiếu chờ ký, đã hủy vẫn ghi "bản lưu tại thời điểm ký" (`HoSoBieuMau-p7rn.dc.html:304, 334`). Khi không có phiếu nào khớp, tiêu đề vẫn hiện "0 phiếu" và nút "In cả bộ hồ sơ".
- Quy trình ghi màn Tổng quan hiện cho "Giám đốc, Admin" ở một chỗ (`mes-powder-quy-trinh.md:972`) và chỉ Giám đốc ở bảng quyền (`:587`); mockup chỉ có Giám đốc.

### 5.3. Bán hàng — đơn hàng, khách hàng, giao hàng, hóa đơn

- Bản in hóa đơn ghi "Hình thức thanh toán: TM/CK" (`HoaDonBanIn-a4hd.dc.html:63`), còn hồ sơ KH-0044 và ĐH-2610-0022 đều là "Tiền mặt" (`BanHang-wvhq.dc.html:1358`).
- Bản in ghi đơn giá 4.482.000 đ/thùng và không có dòng thuế GTGT (`HoaDonBanIn-a4hd.dc.html:97-112`); đơn gốc là 4.150.000 đ/thùng cộng VAT 8% (tổng 17.928.000 đ). Số tổng khớp nhưng đơn giá và phần thuế không khớp đơn.
- Mã QR trên bản in có nhãn "Mã QR phiếu PX-NM1-2610-0042" (`HoaDonBanIn-a4hd.dc.html:52`), còn phiếu xuất của hóa đơn là PX-NM1-2610-0034 (dòng 63-64 của chính bản in); mã 0042 không có ở dữ liệu đơn.
- Dòng "In lại ngày 24/10/2026 bởi Trần Thị Ngọc (Kế toán)" (`HoaDonBanIn-a4hd.dc.html:144`): người Kế toán trong dữ liệu mẫu là Ngô Bảo Ngọc, và ngày làm việc của mockup là 18/10/2026.
- Biểu mẫu tạo đơn (board 10) và sửa đơn đã chốt (board 19) mở thẳng và lưu được với mọi vai trò, không có dòng chặn theo vai trò như các nút khác (`BanHang-wvhq.dc.html:960` `saveForm` không kiểm vai trò); quy trình ghi chỉ Sales nhận đơn và sửa đơn.
- "Khách chuyển trả trước" cho phép chọn "Cọc + trả nốt trước giao" với cọc 0 (`BanHang-wvhq.dc.html:1891-1893`), trong khi biểu mẫu đơn bắt buộc cọc lớn hơn 0 cho hình thức này (`BanHang-wvhq.dc.html:1667`).
- Sửa đơn Mua nợ mà công nợ không đủ (bước "cong-no"): mockup chỉ có nút "Giữ đơn cũ" cho Sales (`BanHang-wvhq.dc.html:2001`), trong khi quy trình QT08 còn có đường "chuyển trả trước (đổi hình thức)" và kiểm công nợ lại; banner mockup nói "giữ đơn cũ hoặc xử lý công nợ" nhưng chưa có nút xử lý.
- Ghi nhận giao: nhập số khách nhận 0 và chọn "Không lấy" làm đơn thành "Đã giao" (`BanHang-wvhq.dc.html:1966`, vì toàn bộ số lượng bị giảm); cần xác nhận với quy trình QT09 có muốn đơn hủy hết phần còn lại hiện là "Đã giao" hay "Đã hủy".

### 5.4. Mua hàng & Kế toán

- Board 33 có tiêu đề "Nhà cung cấp — danh sách & duyệt" nhưng `screen` mặc định là `bao-gia`, nên mở ra là Hàng đợi mua (MuaHang-7mvk.dc.html:577, ô `screen` mặc định `bao-gia`); phải đổi `screen` = `ncc` mới thấy danh sách NCC.
- Hình thức thanh toán của NCC-0002 và PO-2610-0023 khác nhau giữa hai phân hệ: Mua hàng ghi "Cọc 30% + trả nốt trước giao" (MuaHang-7mvk.dc.html:1223 và :1237), màn Kế toán ghi NCC-0002 "Trả sau 60 ngày" và PO-2610-0023 "Trả trước" (KeToan-k2vm.dc.html:585 và :600).
- Quy trình ghi Kế toán ghi nhận "trả trước / cọc / trả nốt theo PO" (mes-powder-quy-trinh.md:674), nhưng hộp thoại "Ghi nhận đã trả NCC" chỉ phân loại trả trước hoặc trả sau (KeToan-k2vm.dc.html:735), không có dòng riêng cho khoản cọc và khoản trả nốt.
- PO-2610-0026 chọn hình thức "Cọc 30% + trả nốt trước giao" nhưng ghi chú của PO lại nói "trên 1 container nên trả sau 60 ngày" (MuaHang-7mvk.dc.html:1233).
- Ngày gửi PO không khớp giữa hai board: PO-2610-0018 ghi gửi 09/10/2026 14:10 ở board 31b (GuiPO-r6mx.dc.html:501) nhưng nhật ký ở board 31 ghi "10/10 08:00 Gửi email PO cho NCC"; PO-2610-0017 ghi 07/10/2026 09:20 ở board 31b (GuiPO-r6mx.dc.html:503) nhưng board 31 ghi "07/10 14:20 Gửi NCC".
- Phiếu PO ở board 31b mở trực tiếp (không đi từ board 31) hiện tài khoản NCC là chỗ trống "[NGÂN HÀNG · SỐ TÀI KHOẢN · CHỦ TÀI KHOẢN]" (GuiPO-r6mx.dc.html:657), trong khi mở từ PO bên board 31 thì có đúng tài khoản của NCC.
- Phiếu PO ở board 31b tính cả thuế (ví dụ PO-2610-0022 là 90.825.000 đ) còn danh sách PO ở board 31 chưa gồm thuế (86.500.000 đ); không phải lỗi, nhưng người test nên so đúng chiều.
- Màn Kế toán ghi PO-2610-0016 có phiếu trả TH-NCC-2610-0002 và "2.000 lon từ chối ở cửa kho" (KeToan-k2vm.dc.html:595), nhưng màn Trả hàng nhà cung cấp không có phiếu TH-NCC-2610-0002 nào (đi từ 0001 sang 0003).
- Điều "người tạo không tự duyệt" chỉ hiện với vai trò `Mua hàng` (người tạo), còn vai trò `Trưởng BP Mua hàng` luôn duyệt được vì không PO nào mẫu do Trưởng BP tạo; nên không kiểm được trường hợp Trưởng BP tự duyệt PO của chính mình bằng dữ liệu mẫu.
- Ở board 33, `start` = `tao-moi` mở sẵn form tạo hồ sơ NCC kể cả khi `vaitro` không phải `Mua hàng` (các vai trò khác không có nút "+ Tạo hồ sơ NCC" nhưng form vẫn mở được qua `start`).

### 5.5. Kho

- Bản in phiếu nhập luôn in đủ số thực nhập kể cả khi chọn `Chờ xác nhận lệch`, và luôn in sẵn tên Thủ kho trưởng Trần Thị Mai; hai bản in phiếu xuất để trống số thực xuất khi `Chờ lấy hàng`, biên bản kiểm kê để trống chữ ký khi chưa duyệt (PhieuNhapIn-p4nk.dc.html:97-99; PhieuXuatIn-x6qk.dc.html:99-101; BienBanKiemKeIn-k7bb.dc.html:112). Quy trình: tồn chỉ cập nhật sau khi Thủ kho trưởng xác nhận lệch (mes-powder-quy-trinh.md:126).
- Bản in phiếu xuất sản xuất mặc định `Bản sao in lại` và in 2.400 kg thực xuất, trong khi phiếu gốc PX-NM1-2610-0042 còn Chờ lấy hàng, chưa quét bao nào; người lập in là "Hồ Văn Nam", phiếu gốc ghi "Hệ thống" (PhieuXuatIn-x6qk.dc.html:95; KhoVH-xv2s.dc.html:1472).
- Nút "In phiếu" và "In báo cáo kiểm kho" ở mọi phiếu đều mở cùng một bản in mẫu cố định (PN-NM1-2610-0031, PX-NM1-2610-0042 kể cả phiếu trả NCC, PK-NM1-2610-0008), không in đúng phiếu đang mở (KhoVH-xv2s.dc.html:1122, 2029).
- Tiền tố nhà máy trong mã phiếu sinh ra: phiếu nhập tự sinh khi kho NM1 quét xuất sang NM2 vẫn đặt mã PN-NM1-2610-… dù kho nhận ở NM2 (KhoVH-xv2s.dc.html:1929); phiếu chuyển lập từ yêu cầu của Kế hoạch NM2 vẫn mang mã PC-NM1-2610-… (KhoVH-xv2s.dc.html:1271). Dữ liệu mẫu cũng không thống nhất: PC-NM2-2610-0019 xuất từ NM1-BTP nhưng mang NM2, còn PC-NM1-2610-0006, 0007, 0015 xuất từ NM2 nhưng mang NM1. Quy trình: mã chứng từ sinh tại nhà máy có tiền tố nhà máy (mes-powder-quy-trinh.md:909).
- Mã biên bản và NCR mẫu không có tiền tố nhà máy (BB-HUY-2610-0002, BB-HUY-2609-0010, BB-TL-2610-0001, NCR-2610-0012), trong khi số biên bản hủy điền sẵn cho phiếu mới là BB-HUY-NM1-2610-0018 (KhoVH-xv2s.dc.html:1542, 1498, 1689, 2093).
- Tồn kho (board 41) thiếu 3 lô NM2-TONG mà màn Kho có: L-BOT-36 (1.240 kg), L-LEC-05 (40 kg), L-PGA-14 (50 kg); các lô này là tồn Đạt để lập phiếu chuyển ở board 49a (KhoVH-xv2s.dc.html:778-780; TonLo.dc.html không có).
- Phiếu kiểm toàn kho PK-NM2-2610-0004 chỉ liệt kê 1 lô (L-BOT-31, 700 kg) dù banner nói cờ kiểm kê đặt trên cả kho NM2-TONG, kho này còn 3 lô khác (KhoVH-xv2s.dc.html:1528).
- Board 48 (tên có "hệ thống đề xuất lô") chỉ cho tạo phiếu Trả NCC, và yêu cầu mẫu duy nhất còn lại là TH-NCC-2610-0004 (hàng để riêng, không có lô), nên trong hộp thoại không thấy lô nào được đề xuất; việc đề xuất lô theo hạn dùng chỉ thấy ở chi tiết PX-NM1-2610-0042 (KhoVH-xv2s.dc.html:1722, 1389).
- Mặc định vai trò của board 49b và 50b là `Thủ kho điều phối`, nhưng phiếu mặc định ở kho NM1-BTP chỉ `Thủ kho` quét được, nên mở ra là bị chặn quét (KhoVH-xv2s.dc.html:1432).
- Ngày "In lại" trên bản in (24/10/2026 và 02/11/2026) sau ngày hiện tại của dữ liệu mẫu (18/10/2026) (PhieuNhapIn-p4nk.dc.html:79, BienBanKiemKeIn-k7bb.dc.html:88).
- Tài liệu quy trình tự mâu thuẫn một chỗ: mục sửa 27/10 vẫn nói giữ bước Thủ kho trưởng xác nhận chuyển kho liên nhà máy (mes-powder-quy-trinh.md:372), còn mục 30/10 và bảng vai trò ghi bỏ bước này, lập phiếu là chấp nhận (mes-powder-quy-trinh.md:532, 708, 919). Mockup theo bản 30/10.
- Không thấy cảnh báo "trước hạn dùng" ở màn nhập kho hay Tồn kho (còn lại chỉ có kiểm HSD còn ≥ 2/3 khi nhận, cờ "Dưới ngưỡng SX" và "Đã hết hạn"), khớp quy trình (mes-powder-quy-trinh.md:335, 941).

### 5.6. Sản xuất — lệnh sản xuất, tiến độ, công thức

- Tên board 57 và 58 ghi "bị chặn" khi thiếu tồn nguyên liệu. Mockup và quy trình thì thiếu tồn vẫn tạo được lệnh, lệnh thành "Chờ NVL" (LenhSX-hxoc.dc.html:1698, 1786; mes-powder-quy-trinh.md:737). Chỉ có mẫu nhãn chưa duyệt chặn tạo lệnh BTP (LenhSX-hxoc.dc.html:1669). Ngoài ra tên board 58 nói thiếu bột hỗn hợp, nhưng kho điều phối có 300 kg, cần 112,5 kg nên đủ.
- Điều kiện "thiếu hồ sơ công bố" của lệnh BTP có trong logic (LenhSX-hxoc.dc.html:1668) nhưng cả 5 mã sản phẩm mẫu đều có hồ sơ (LenhSX-hxoc.dc.html:1469-1473), nên không tái hiện được trên board nào.
- Quy trình cho Kế hoạch tạo lệnh sản xuất tồn kho không theo đơn (mes-powder-quy-trinh.md:737), nhưng form tạo lệnh chỉ chọn từ dòng đơn (LenhSX-hxoc.dc.html:1627). Lệnh tồn kho chỉ có sẵn trong dữ liệu mẫu, và "Tạo lại (sao chép lệnh)" từ một lệnh tồn kho đã hủy (ví dụ LSX-2610-0027) mất tính chất tồn kho, form đòi chọn dòng đơn (LenhSX-hxoc.dc.html:1773).
- Thẻ tab tên "Chờ phát" (LenhSX-hxoc.dc.html:2074-2075) trong khi tên board 53 và quy trình gọi là "Chờ lên lệnh", và trùng tên với trạng thái lệnh "Chờ phát" (lệnh đã phát nhưng chưa tới nhà máy).
- Board 62: banner "Có lại kết nối NM1 ... đã đồng bộ 37 sự kiện" và khối xử lý xung đột (nút xác nhận hướng xử lý) được tính trong mã (LenhSX-hxoc.dc.html:2426-2428) nhưng phần giao diện (dòng 577-1220) không có chỗ hiển thị. Xung đột chỉ thấy qua dữ liệu mẻ 3 của LSX-2610-0009. Sau đồng bộ lệnh này có 3/3 mẻ xong nhưng vẫn "Đang chạy".
- Board 61 với `start` = `xem` mở LSX-2610-0012 trên máy chủ nhà máy, trong khi lệnh này mới tạo và chưa từng gửi xuống nhà máy (LenhSX-hxoc.dc.html:1335; nhà máy chỉ nhận lệnh đã phát theo mes-powder-quy-trinh.md:255).
- Hủy mẻ khi nhà máy ngoại tuyến được áp dụng ngay (mẻ thành "Đã hủy", LenhSX-hxoc.dc.html:1938), còn quy trình ghi lệnh hủy mẻ xếp chờ gửi và nhà máy chỉ áp dụng khi mẻ còn dừng sự cố (mes-powder-quy-trinh.md:257).
- Màn Công thức báo CT-BTP-0002 có 3 lệnh còn chạy bản v4 (CongThuc-qdhl.dc.html:301-318), trong khi màn Lệnh sản xuất có 6 lệnh mở dùng v4: LSX-2610-0009, 0010, 0012, 0018, 0025, 0026 (LenhSX-hxoc.dc.html:1526-1555). Hộp "Ngừng sử dụng" cũng chỉ liệt kê 3 lệnh. Ngoài ra ngừng sử dụng một công thức ở board 65 không làm form tạo lệnh bên Lệnh sản xuất từ chối công thức đó, vì hai màn giữ dữ liệu riêng, dù thông báo nói "không tạo được lệnh mới".
- Form tạo lệnh viết "x / 8 điều kiện" nhưng liệt kê 9 dòng (khu sản xuất cộng 8 dòng còn lại; LenhSX-hxoc.dc.html:2228, 1678-1701).
- Hộp "Không tạo lệnh cho ..." (bắt buộc nhập lý do, báo "Đã báo NV tiếp thị") có đủ logic nhưng trên form không có nút nào mở nó (LenhSX-hxoc.dc.html:1966, và dòng 577-1220 không gọi `fm.rej`), nên không thử được.

### 5.7. Chất lượng — yêu cầu kiểm, phiếu kiểm, phiếu chứng nhận, mẫu lưu

- Phiếu chứng nhận chờ ký lô B261013 ghi 2 file đánh giá (`KN-QC-2610-0057-hoa-ly.pdf`, `KN-QC-2610-0057-vi-sinh.jpg`; lịch sử "Tải 2 file") ở ChatLuongCN-t9bw.dc.html:744, trong khi phiếu kiểm `QC-NM1-2610-0057` chỉ có 1 file `KN-QC-2610-0057.pdf` ở ChatLuong-q4ls.dc.html:718. Bản in ở board 79 và phiếu kiểm ở board 68, 72 không khớp số file.
- Bản in phiếu chứng nhận mở từ phiếu kiểm lấy "Số lượng lô" bằng số đang còn trong kho (ChatLuong-q4ls.dc.html:1175), nên `CN-NM1-2610-0018` ở board 76 hiện số lượng nhỏ hơn (còn 2 lon) trong khi board 81 và phiếu gốc ghi 24 lon (ChatLuongCN-t9bw.dc.html:748). Tương tự `CN-NM1-2609-0015` hiện 0 lon (lô đã giao hết) so với 1.154 lon trên phiếu gốc.
- Hộp "Lấy mẫu" ở phiếu kiểm vẫn có ô "Nơi lưu mẫu" điền sẵn "Tủ mẫu thành phẩm TM-01" hoặc "Tủ mẫu nguyên liệu TN-01" (ChatLuong-q4ls.dc.html:782). Quy trình (mes-powder-quy-trinh.md:933 và 358–359) chốt nơi lưu mẫu là kho mẫu lưu QC (`NM1-MAUQC`), không còn tủ hay ngăn; màn Mẫu lưu ghi đúng `NM1-MAUQC`. Hộp "Sửa hạn lưu" ở Mẫu lưu chỉ cho sửa hạn lưu, không có ô nơi lưu.
- Khung giữ mẫu theo hồ sơ thu hồi nói "lưu ≥ HSD + 12 tháng", nhưng `ML-NM1-2610-0027` (ChatLuongCN-t9bw.dc.html:782) có hạn lưu 11/04/2029, tức HSD + 6 tháng; chỉ `ML-NM1-2609-0028` được sửa đến 12/09/2029 (HSD + 12 tháng). `ML-NM1-2608-0018` (hồ sơ `TH-2610-0001`) cũng chưa dời hạn.
- Bản in `CN-NM1-2610-0018` ghi nhãn "biên bản" nhưng điền mã `PX-NM1-2610-0035` (phiếu xuất), vì dữ liệu để mã phiếu xuất ở cột biên bản (ChatLuongCN-t9bw.dc.html:750, 742). Cột "Phiếu xuất" để trống.
- Mã biên bản hủy mẫu `BB-ML-2610-xxxx` (ChatLuongCN-t9bw.dc.html:909) không có tiền tố `NM1`, trong khi quy trình (mes-powder-quy-trinh.md:909) yêu cầu mã chứng từ sinh ở nhà máy có tiền tố nhà máy; biên bản hủy mẫu không nằm trong danh sách ví dụ của quy trình nên cần xác nhận.
- Hộp "Gửi yêu cầu kiểm": chặn phần lô thuộc NM2 chỉ khi tên kho bắt đầu bằng `NM2` (ChatLuong-q4ls.dc.html:788), nên phần đang chuyển `PC-NM2-2610-0012` của lô L-BOT-28 vẫn chọn được. Cần xác nhận có đúng ý quy tắc "yêu cầu kiểm lập theo từng nhà máy".
- Hai quy tắc không thử được với dữ liệu mẫu: BTP mới nhập không được từ chối (không có yêu cầu BTP mới nhập nào ở Chờ duyệt) và người gửi không tự duyệt (QC trưởng Trần Thị Mai không phải người gửi hay người tải file ở phiếu nào). Mã nguồn có sẵn thông báo cho hai trường hợp này nhưng không có mã mẫu để kích hoạt.
- Yêu cầu `YC-NM1-2610-0014` ghi 800,0 kg ở lô L-WHE-05 (ChatLuong-q4ls.dc.html:645) nhưng lô này hiện chỉ còn 350 kg (dòng 579), không có ghi chú giải thích phần chênh.
- Thao tác ở mỗi board không truyền sang board khác (ví dụ duyệt Đạt `QC-NM1-2610-0058` ở board 72 không làm board 77 thêm phiếu chờ ký cho B261011); đây là hạn chế của mockup, không phải lỗi dữ liệu.

### 5.8. Truy xuất & thu hồi

- Giờ của cùng một sự việc không khớp giữa hai màn. Truy xuất ghi QC trưởng nhận kết quả TX-2610-0003 lúc 17/10 09:05 và mở hồ sơ TH-2610-0003 lúc 09:10 (TruyXuat.dc.html:943); Hồ sơ thu hồi ghi nhận kết quả lúc 10:15 và mở hồ sơ lúc 10:20 (ThuHoi-r8hw.dc.html:678); tồn kho A261011 ghi "Khoanh vùng · TH-2610-0003 từ 17/10 10:20" (TruyXuat.dc.html:785).
- Chỗ để 2 lon A261011 còn lại khác nhau: Truy xuất ghi NM1-DP (TruyXuat.dc.html:785, 718), Hồ sơ thu hồi ghi NM1-BTP (ThuHoi-r8hw.dc.html:672, 680).
- Hồ sơ TH-2609-0002 gắn phiếu TX-2609-0010 (ThuHoi-r8hw.dc.html:767) nhưng danh sách Truy xuất không có phiếu TX-2609-0010 (TruyXuat.dc.html:962), nên mã này không bấm mở được.
- Phiếu TX-2609-0013 (truy xuôi L-BOT-32) hiện số cũ không khớp số hiện tại: ô "Đã giao khách" ghi "Chưa giao" và "Còn trong nhà máy" ghi "0 lon (2 kho)", trong khi bảng bên dưới liệt kê A260914 1.152 lon "chưa giao" ở NM1-BTP và 950 kg L-BOT-32 "Khóa · Khoanh vùng"; còn bảng trạng thái lô ghi A260914 "giao hết KH-0052 25/09" và L-BOT-32 "Hủy" (TruyXuat.dc.html:893-898, 714; phiếu TX-2609-0015 cùng lô A260914 ghi giao 1.152 lon cho KH-0052).
- Phiếu TX-2609-0011 (truy ngược A260820): bảng cân bằng ghi giao khách 480, tồn 120, không có số hủy (TruyXuat.dc.html:814), còn cột kho/tồn ghi "đã hủy 588 lon · PH-NM1-2610-0002" (TruyXuat.dc.html:738) và hồ sơ TH-2609-0003 ghi hủy 588 lon.
- Hộp thoại "Lập biên bản chênh lệch" (ô nguyên nhân, nút "Lập biên bản & mở kiểm kho") không bao giờ hiện: mọi phiếu có lô B261011 đều tạo sẵn biên bản (TruyXuat.dc.html:935), và B261011 là lô duy nhất lệch (TruyXuat.dc.html:795). Vì vậy không test được ca "Thủ kho lập biên bản mới" và dòng "Việc của Thủ kho" ở thẻ cân bằng.
- Mở hồ sơ thu hồi từ phiếu TX-2610-0004 (nguồn QC nghi lỗi): hồ sơ ghi phiếu đó với nguồn "Truy xuất phát hiện" (ThuHoi-r8hw.dc.html:902). Hồ sơ mở bằng số lô sinh phiếu mã TX-2610-0005 (ThuHoi-r8hw.dc.html:900) trong khi mã kế tiếp của màn Truy xuất là TX-2610-0004 (TruyXuat.dc.html:969). Ở board 93 (chưa có TH-2610-0003), hồ sơ mới mở bằng số lô lấy mã TH-2610-0003, trùng mã mà đường "từ kết quả truy xuất" sẽ dùng.
- Vai trò `Kế toán`, `Thủ kho`, `Thủ kho trưởng` bị dải "không có quyền vào màn này" ở Hồ sơ thu hồi (menu chỉ cho Admin, CSKH, Giám đốc, Kế toán trưởng, Người truy xuất, QC, QC trưởng, Sales; TruyXuat.dc.html:591) nhưng vẫn bấm được "Mô phỏng: Kế toán ghi nhận", nhập kho và xác nhận hủy (ThuHoi-r8hw.dc.html:1173, 1176, 1187). Quy trình để các bước này ở màn Kho và Sổ thu chi, nên đây là cách mô phỏng rút gọn; cần xác nhận có giữ không. Nút "Mô phỏng: hết hạn thu hồi" cũng hiện cho mọi vai trò.
- Quy trình ghi báo cơ quan là bắt buộc theo luật, nhưng mockup chỉ chặn ở "báo đầu"; thiếu "báo kết thúc" hoặc còn lô "Chờ hủy" ở nhánh khoanh vùng thì chỉ hiện dấu "!" mà Giám đốc vẫn đóng được (ThuHoi-r8hw.dc.html:1209-1222).
- Ở dòng thời gian, sau khi lọc bằng ô "Hiện" thì dòng phụ vẫn ghi số sự kiện chưa lọc (lọc "Giao & vận chuyển" vẫn ghi "20 sự kiện · 1 ngày") (TruyXuat.dc.html:1166).
- Khi hồ sơ quay lại Giám đốc vì lô đã giao kiểm lại không đạt, quyết định cũ bị xóa và thanh bước đổi lại theo đề xuất của QC trưởng (ThuHoi-r8hw.dc.html:844, 989). Hồ sơ ký Khoanh vùng sẽ hiện lại đủ 10 bước của nhánh thu hồi nếu đề xuất ban đầu là Thu hồi. Chỉ ghi nhận, chưa rõ là chủ ý.

### 5.9. Danh mục — nguyên vật liệu, sản phẩm, hồ sơ pháp lý chung, đơn vị

- Sửa mã nguyên vật liệu đã có giao dịch: quy trình ghi "mã đã có giao dịch thì khóa ĐVT" và hộp xem ở board 97 cũng ghi "· đã có giao dịch, khóa ĐVT", nhưng màn sửa (board 98c) vẫn cho đổi "Đơn vị tính" của `NVL-BOT-0001`. Mã tính ra cờ khóa nhưng ô chọn không dùng nó. (SuaNVL-e5nv.dc.html:301 và :637; quy trình mes-powder-quy-trinh.md:1228)
- Vai trò sửa sản phẩm: quy trình cho Mua hàng · Kế hoạch · Thủ kho · Thủ kho điều phối · QC tạo / sửa mã SP (mes-powder-quy-trinh.md:588, 589). Mockup thay Mua hàng bằng R&D. Menu lại không cho R&D vào màn Sản phẩm, nên chọn `vaitro` = `R&D` hiện dải "không có quyền vào màn này" mà vẫn thấy nút tạo. Ô `vaitro` của board 99 cũng không có `Mua hàng`. (DanhMucSP-zd4p.dc.html:736; DanhMuc-15tr.dc.html menu `dm_sp`)
- Ngừng dùng sản phẩm: quy trình có luồng đề nghị ngừng dùng cho SP (mes-powder-quy-trinh.md:378, 592–596), nhưng màn Sản phẩm không có nút hay màn ngừng dùng. Chỉ có hai dữ liệu mẫu có sẵn (`SP-0006` Chờ duyệt ngừng, `SP-0008` Ngừng sử dụng). Giá trị `ngung-dung` của ô `start` ở board 100, 101, 103 chỉ ra danh sách; còn màn gốc (board 99) không có giá trị đó. (DanhMucSP-zd4p.dc.html:606–616)
- Nguyên vật liệu `Chờ duyệt ngừng`: danh sách ẩn biểu tượng Sửa, nhưng hộp xem vẫn hiện nút "Sửa"; bấm vào thì màn sửa khóa hết. (DanhMuc-15tr.dc.html:491 và :516)
- Ngày "hôm nay" của hồ sơ pháp lý chung là 29/10/2026, còn quy trình đã cập nhật đến 04/11/2026. Số ngày còn lại (vd `HS-0003` còn 42 ngày) sẽ lệch 6 ngày so với ngày test thật. (HoSoPhapLy-h7pl.dc.html:457; DanhMucSP-zd4p.dc.html:537)
- Board 98, chế độ `Thêm mã — trùng tên`: ô Tên chỉ nhận ra đúng chuỗi "Bột sữa nguyên kem 26% béo"; gõ tên khác thì ô quay về "Bột sữa nguyên kem 28% béo" chứ không giữ chữ vừa gõ. (TaoMa-29ia.dc.html:694)
- Board 105b, sửa đơn vị `hop`: quy đổi cũ "1 hộp = 12 gói (theo quy cách)" không đọc được thành số + đơn vị gốc vì không có đơn vị `gói`, nên bấm Lưu mà không chọn đơn vị gốc thì cột Quy đổi thành "—". (DonVi-u7dv.dc.html:383, :429)

### 5.10. Nhà máy, khu vực & quản trị hệ thống

- Tài liệu quy trình ghi số điện thoại là ô bắt buộc khi tạo tài khoản (mockup ghi "các ô bắt buộc (mã NV, SĐT, mã thẻ NV, ngày hiệu lực…)"); mockup chỉ đánh dấu bắt buộc Mã NV, Ngày hiệu lực, Nhà máy (và mã thẻ, khu với công nhân). Ô "SĐT" không có dấu sao, để trống vẫn tạo được, chỉ kiểm trùng. (NguoiDung.dc.html:299, 556; mes-powder-quy-trinh.md:941)
- Tài liệu ghi mã nhân viên của tài khoản đã xóa "không cấp lại"; mockup chỉ so trùng với các tài khoản còn trong danh sách, nên sau khi xóa NV0562 có thể tạo lại đúng mã `NV0562`. (NguoiDung.dc.html:461, 531–534, 586; mes-powder-quy-trinh.md:1105)
- Ghi chú đầu tab "Tài khoản" của nhật ký còn câu "Tài khoản không bao giờ bị xóa — nghỉ việc thì khóa", trái với quy tắc mới (04/11) là xóa được tài khoản chưa từng dùng. (NhatKy-n5jd.dc.html:494; mes-powder-quy-trinh.md:390)
- Chế độ `chitiet` = `Mã đã khóa A-BAO-000233` trỏ tới dòng `s01` không tồn tại trong dữ liệu nhật ký, nên không mở ra ngăn chi tiết nào. (NhatKy-n5jd.dc.html:499, 456)
- Đổi loại khu bị chặn (`cheDo` = `Đổi loại khu — bị chặn`): ô Loại khu chỉ bị khóa, không có câu giải thích lý do (còn lệnh chưa xong); biến báo chặn `kindBlock` được tạo nhưng không dùng, và nút Lưu không bị khóa. Quy tắc nói "chặn đổi loại khu khi khu còn lệnh chưa hoàn thành". Câu liệt kê lệnh `ordersText` có trong mã nhưng không in ra màn hình. (KhuVuc.dc.html:407, 497–498; mes-powder-quy-trinh.md:220)
- Cùng một trạng thái khu và silo nhưng chữ khác giữa hai board: màn Nhà máy (106–110) ghi khu "Đang hoạt động / Ngừng hoạt động" và silo "Ngừng hoạt động"; màn Khu (111–112) ghi "Đang dùng / Ngừng dùng" và silo "Ngừng dùng". Quy trình ghi "Đang dùng / Ngừng dùng". (NhaMay-qd07.dc.html:699, 750; KhuVuc.dc.html:390, 450; mes-powder-quy-trinh.md:1108)
- Nhật ký (board 120–123) cho thấy NM1 đã có mạng lại và đồng bộ lúc 10:24 ngày 18/10, nhưng board 106, 111 vẫn ghi "Server nhà máy ngoại tuyến từ 08:12" cho NM1. (NhaMay-qd07.dc.html:616; KhuVuc.dc.html:486; NhatKy-n5jd.dc.html:456)
- Ủy quyền tạm (board 117) không kiểm định dạng ngày hết hạn và không kiểm ngày hết hạn có sau ngày bắt đầu; chỉ kiểm bỏ trống. Gõ chữ bất kỳ vẫn lưu được. (UyQuyen.dc.html:319)
- Ngày ghi trên lần sửa định dạng mã (board 119b) là "29/10", trong khi các màn khác lấy hôm nay là 18/10/2026. (CauHinh-cocg.dc.html:452)
- Mô tả vai trò "Thủ kho điều phối" ở board 114 nhắc riêng kho `NM1-DP`, trong khi nhà máy được có nhiều kho điều phối (NM1-DP2…). (VaiTroQuyen.dc.html:384)
