# MES Powder — Bộ quy trình nghiệp vụ (nguồn chính)

Cập nhật: 04/11/2026 (đồng bộ theo mockup — xem "Quyết định đã chốt 30/10 – 04/11" ở mục Vai trò × Chức năng: bỏ báo giá, kiểm COA & HSD trước PO, PO / COA gửi email, thanh toán Cọc + trả nốt trước giao; yêu cầu chuyển YCC-, lập phiếu là chấp nhận; mô hình SP mới, nhiều kho điều phối, xóa bản ghi chưa dùng; Vai trò × quyền sửa được, vai trò Thủ kho điều phối; Sales hủy thẳng đơn chưa chốt; MES in hóa đơn gắn phiếu xuất; lệnh tồn kho, Cân đối NVL, hủy lệnh khi mất mạng bị chặn; ký chứng nhận tách riêng; mẫu lưu lấy ra / niêm phong lại / sửa hạn lưu; truy xuất thêm loại mã; thêm màn Tổng quan, Hồ sơ & biểu mẫu in, Đơn vị, Hồ sơ pháp lý chung). Trước đó 29/10/2026 (QT25 Truy xuất: bỏ mục tiêu thời gian truy xuất 4 giờ — sau bước tạo phiếu mọi bước do hệ thống chạy, có kết quả ngay; phiếu chỉ ghi thời điểm tạo / có kết quả làm bằng chứng; lô lệch khối lượng không chặn báo cáo — biên bản và QT17 chạy song song, gắn bổ sung vào phiếu). Trước đó 28/10/2026 (bỏ vai trò Trưởng bộ phận và rà soát quyền hằng quý; ngừng mã danh mục do trưởng của bên đề xuất duyệt, Kế hoạch tự ngừng). Trước đó 26/10/2026 (mẫu lưu: bỏ tủ / ngăn và điều kiện bảo quản — chỉ ghi lô, số lượng, hạn lưu, ghi chú). Trước đó 24/10/2026 (đợt 12: thiếu NVL vẫn tạo được lệnh nhưng không giữ chỗ, không phát; hệ thống tính nhu cầu mua gộp theo NVL, trừ hàng đang đặt, gửi thẳng Mua hàng; NVL có thời gian giao hàng. Đợt 11: Kế hoạch bấm Kiểm tra lại NVL trên lệnh, không có bước thủ kho xác nhận soạn NVL; kho tổng thiếu → tự lập yêu cầu mua, báo Mua hàng. Đợt 10: phiếu xuất SX do máy chủ nhà máy tự lập khi lệnh phát sang khu, kho điều phối chung, nơi nhận = khu của lệnh; xuất SX không còn Chờ bên yêu cầu. Đợt 9: ngưỡng hạn còn lại tối thiểu khi dùng cho sản xuất (mặc định 30 ngày), bỏ cảnh báo cận date; phiếu chuyển không có trạng thái "Trên xe". đợt 8: nhu cầu sản xuất theo dòng đơn — mỗi lệnh 1 mã SP, gộp / tách dòng đơn theo số lon, tab Chờ lên lệnh ở màn Lệnh SX; bỏ NV tiếp thị khỏi điều kiện LSX, còn 8 điều kiện; chỉ sản xuất theo đơn. Đợt 7: phiếu xuất Chờ lấy hàng / Đang lấy hàng thay Đã duyệt; phiếu nhập tự sinh, không duyệt — Thủ kho trưởng chỉ xác nhận chênh lệch. Đợt 6: bỏ duyệt phiếu xuất cho mọi loại; trả NCC do Trưởng BP Mua hàng duyệt yêu cầu xuất trả. Đợt 5: phiếu xuất SX vào thẳng Chờ lấy hàng, không qua Thủ kho trưởng. Đợt 4: phiếu xuất bán do máy chủ nhà máy tự lập từ yêu cầu xuất bán, vào thẳng Chờ lấy hàng; tách khoản trả nốt theo phần xuất. Đợt 3: bỏ COA và bộ chỉ tiêu QC cho cả NVL lẫn BTP / TP — chỉ nhận file đánh giá bên ngoài, QC trưởng kết luận Đạt / Không đạt. Đợt 2: bỏ quản lý vị trí kệ — tồn theo lô × kho, trạng thái theo từng bao. Đợt 1: Giao hàng chỉ ghi nhận, bỏ màn Giao hàng — ghi ở tab Giao hàng của đơn; một đơn nhiều hóa đơn). Trước đó 23/10 (màn Đơn hàng & Khách hàng: bỏ NV tiếp thị, thông tin thanh toán điền sẵn theo khách; popup chi tiết danh mục bỏ tham chiếu). Trước đó 20/10 đợt 3: chốt câu khóa lô tại nhà máy, nhận chuyển kho chưa có phiếu, dữ liệu khách ở nhà máy, mã công thức 4 số, mã SP theo quy cách. Chia lại theo 7 mảng (mục D `mes-powder-danh-gia-ket-qua.md`): 23 QT cũ → 26 QT mới (đã bỏ Hiệu chuẩn, đánh số lại 16/10; đã bỏ Khiếu nại 16/10). Vẽ lại từ `soQuyTrinhGocHoanChinh.drawio` (owner anhkhoaxn11), chia cột theo phòng ban, đánh dấu lỗ hổng.

**Cách dùng file này**
- Đây là nguồn dữ liệu gốc. Muốn sửa quy trình → sửa khối `quy-trinh` tương ứng rồi chạy `mes-powder-build-html.py` để dựng lại trang xem HTML.
- Cú pháp khối: `mang:` tên mảng, `tu:` QT cũ tương ứng, `cot:` danh sách cột (phòng ban) ngăn bởi `|`. Mỗi dòng bước: `id | cột (từ 0) | hàng (từ 0) | loại | nội dung` (`\n` = xuống dòng). Sau dòng `---` là mũi tên: `từ -> tới : nhãn : kiểu` (kiểu `g` = luồng đề xuất, `n` = nối ghi chú).
- Loại bước: S bắt đầu, E kết thúc, T thủ công, Y hệ thống làm, D quyết định, R gọi quy trình khác, G ⚠ THIẾU (đề xuất thêm), C ⚠ CẦN CHỐT, F ⚠ SỬA so với bản gốc.

## Bảng đổi số (23 QT cũ → 26 QT mới)

| Mảng | QT mới | Từ QT cũ |
|---|---|---|
| 1 · Nền tảng | 01 Phân quyền · 02 Danh mục · 03 Công thức / BOM · 04 Sự cố tem | 1 · mới · mới · 8 (phần sự cố) |
| 2 · Bán hàng | 05 Nhận đơn · 06 Kiểm công nợ · 07 Hủy đơn · 08 Sửa đơn · 09 Giao hàng · 10 Ghi nhận thu chi & công nợ | 3 · 4 · mới · mới · 21 (giao) · 21 (thu tiền) |
| 3 · Mua hàng | 11 Phê duyệt NCC · 12 Mua NVL · 13 Trả hàng NCC | 2 · 5 · 7 |
| 4 · Kho | 14 Nhập kho · 15 Xuất kho · 16 Chuyển kho · 17 Kiểm kho · 18 Hủy hàng | 6+9+8 (tạo mã) · 20 · 13+16 · 10 · 19 |
| 5 · Sản xuất | 19 Tạo & phát lệnh · 20 Vận hành mẻ (HH / BTP) · 21 Chiết rót & đóng gói | 11 · 12+14 · 15 |
| 6 · Chất lượng | 22 QC đầu vào · 23 QC thành phẩm · 24 Mẫu lưu | 17 (NVL) · 17 (BTP/TP) · 18 |
| 7 · Truy xuất & thu hồi | 25 Truy xuất · 26 Thu hồi | 23 · 22 |

Thay đổi khi chia lại:
- Gộp 3 cặp: Nhận NVL + Nhập kho khác; Chuyển kho nội bộ + Chuyển kho 2 NM; SX khu HH + SX khu BTP.
- Tách 2: QC → đầu vào / thành phẩm; Bán hàng → giao hàng / thu tiền (bỏ luôn quyết định giả CK / tiền mặt và ô cụt "quyết định lưu kho").
- Thêm 4 QT mới: Danh mục, Công thức / BOM, Hủy đơn, Sửa đơn (Hiệu chuẩn từng thêm, đã bỏ 16/10). Kiểm công nợ (QT4 cũ) giữ là QT riêng vì được gọi từ cả Nhận đơn và Sửa đơn.
- Tạo mã khi nhập gom vào QT11; QT04 chỉ còn xử lý tem hỏng / mất / hủy.
- Mọi tham chiếu "QTn" trong ô đã đổi sang số mới. File đánh giá vẫn dùng số cũ — tra bảng trên.

Sửa logic 15/10 (QT09 Giao hàng và các QT liên quan):
- QT09 bắt đầu khi mọi lô TP của đơn đã QC ĐẠT; QT23 gọi sang QT09 (trước đây 2 QT không nối nhau).
- Trả nốt và trả nợ quá hạn trước khi giao đi qua QT10 (thêm QT09 vào điểm vào "khoản trước giao").
- QT05 sinh lịch thanh toán khi có HĐ; QT09 chỉ đọc lịch + cờ tạm khóa của khách, không rẽ lại theo hình thức thanh toán (bỏ trùng logic với QT05).
- Kiểm thanh toán trước khi chốt lịch giao; 2 vòng chờ (không liên hệ được; chưa thu đủ / khách bị tạm khóa) có lối ra sang QT07 Hủy đơn.
- Xuất kho để bán lấy đúng lô của đơn, không theo FEFO (QT15).
- Khách từ chối / nhận một phần: biên bản, nhập lại kho loại "hàng khách trả" (QT14), QC kiểm lại; khách vẫn lấy thì QT23 đạt sẽ gọi lại QT09, không lấy thì QT07.
- QT10 ghi công nợ theo phần đã giao.

Bổ sung 15/10 (QT11 Phê duyệt NCC):
- Chuyển 2 ô THIẾU thành bước thật: QC đánh giá mẫu + COA + chứng nhận trước khi duyệt; đánh giá lại định kỳ / khi điểm lỗi vượt ngưỡng (QT13) / chứng nhận sắp hết hạn.
- Thêm kiểm trùng MST, trạng thái NCC (CHỜ DUYỆT / ĐÃ DUYỆT / TỪ CHỐI / TẠM NGƯNG / LOẠI), lưu lý do ở mọi nhánh không đạt, danh sách NVL được phép cung cấp.
- Tạm ngưng có hạn khắc phục: khắc phục được thì đánh giá lại, không thì Loại. Loại không xóa hồ sơ; NVL mất NCC duy nhất thì báo Kế hoạch.
- Thêm biểu mẫu "Hồ sơ NCC". 2 ô cần chốt: ai ký duyệt; chu kỳ, thang điểm, ngưỡng.

Sửa 16/10 (QT11 Phê duyệt NCC):
- QC đánh giá mẫu thành TÙY CHỌN: thêm quyết định "Bật đánh giá mẫu?" sau bước kiểm hồ sơ. Tắt → đủ hồ sơ là sang Trưởng BP duyệt luôn, không xin mẫu / COA.
- Đánh giá lại định kỳ (chấm điểm lỗi khi bị trả hàng nhiều) thành TÙY CHỌN: nhánh dưới chỉ chạy khi bật. Tắt → không đặt ngày đánh giá lại, không tự Tạm ngưng / Loại theo điểm.
- Hồ sơ NCC: trường mẫu + COA, điểm đánh giá, ngày đánh giá lại chỉ bắt buộc khi bật tùy chọn tương ứng.

Bổ sung 16/10 (QT12 Mua NVL, QT13 Trả hàng NCC):
- QT12: 3 ô THIẾU thành bước thật — hệ thống lọc NCC ĐÃ DUYỆT đúng NVL (chưa có → gọi QT11); xin báo giá ≥ 2 NCC, bảng so sánh, ghi lý do nếu không chọn giá thấp nhất; NCC giao bắt buộc kèm COA, số lô, NSX, HSD. (Bỏ báo giá 04/11 — xem QT12.)
- QT12: tồn đủ tính theo tồn khả dụng (lô ĐẠT, còn hạn, trừ giữ chỗ); theo dõi PO nhận một phần, giao trễ / thiếu ghi vào điểm NCC. 2 ô cần chốt: miễn so sánh giá khi nào; ngưỡng PO cần GĐ duyệt.
- QT13: nhánh NCC không chấp nhận — biên bản không thống nhất, rồi kiểm nghiệm bên thứ 3 (mẫu lưu QT24) / chấp nhận tổn thất (QT18) / tranh chấp (tạm giữ thanh toán). Bên thứ 3 kết luận lô đạt thì mở khóa lô. 1 ô cần chốt: ai quyết, đơn vị kiểm nghiệm, ai chịu phí.
- Thêm biểu mẫu "Phiếu mua hàng (PO)" và "Phiếu trả hàng NCC".

Bổ sung 16/10 (QT18 Hủy hàng):
- Ô THIẾU "cảnh báo cận date" thành nhánh thật: hệ thống quét HSD hằng ngày, gắn cờ CẬN DATE theo số ngày cấu hình từng nhóm.
- Cận date: báo Kho, Kế hoạch, Sales; đẩy lô lên đầu FEFO; Kế hoạch / Sales ưu tiên dùng / bán. Không kịp thì đến hạn hệ thống xử lý như lô hết hạn.
- Hết hạn: tự KHÓA lô, chặn xuất (QT15 / QT19 / QT20), tạo đề nghị hủy → đi tiếp luồng hủy. 1 ô cần chốt: số ngày, mấy mức cảnh báo, ai nhận.

Sửa 16/10 (QT14 Nhập kho, QT15 Xuất kho — phiên song song):
- QT14: gộp 2 bước kiểm ngoại quan thành 1 quyết định kiểm từng bao cho cả 3 loại nhập; bao hư: NVL mua → trả NCC (QT13), từ SX → phiếu NCR / QT18, khách trả → ghi biên bản, vẫn nhập.
- QT15: đề xuất lô → tạo phiếu → duyệt rồi mới lấy hàng; kiểm lô ngay mỗi lần quét; thiếu hàng ghi lệch tồn (QT17), tìm lô thay thế. Biểu mẫu Phiếu xuất kho, Phiếu nhập kho có thêm trường.

Bổ sung 16/10 (QT14 Nhập kho — 2 ô THIẾU thành bước thật; chốt QC không kiểm khi nhập):
- NVL mua: Kho nhập số lô NCC, NSX, HSD từng lô, tải COA; hệ thống kiểm COA khớp lô, chỉ tiêu trong giới hạn, HSD còn đủ — không đạt thì báo Mua hàng / trả NCC. TP / BTP từ SX: lô, NSX, HSD hệ thống tự điền từ lệnh SX.
- Cất hàng: hệ thống gợi ý vị trí kệ / ô; thủ kho quét mã ô khi cất, sai ô thì cất lại; tồn ghi theo vị trí.
- QC không kiểm khi nhập kho: bỏ gọi QT22 / QT23; lô vào là ĐẠT, xuất được ngay; hàng khách trả nhập lại ĐẠT. Mọi lô TP của đơn đã nhập kho thì gọi QT09.
- Chưa sửa theo quyết định này: QT09 (vẫn ghi bắt đầu khi QT23 ĐẠT), QT15 (vẫn chặn CHỜ KIỂM), QT21, QT22, QT23.

Sửa 16/10 (QT19 Tạo & phát lệnh — giữ chỗ theo kg; mất kết nối cloud ↔ local):
- Giữ chỗ NVL theo KG, không theo lô: ô THIẾU "giữ chỗ lô NVL theo FEFO" thành bước hệ thống — KL từng NVL = định mức × số mẻ; tồn khả dụng = KL lô ĐẠT, còn hạn − KL đã giữ. Lô cụ thể chọn lúc xuất (QT15, FEFO), xuất SX trừ dần số KG đã giữ của lệnh. QT15 sửa theo.
- Ô THIẾU "mất kết nối cloud ↔ local" thành bước thật, gắn vào luồng lệnh: (1) phát lệnh mà server local không nhận được → lệnh CHỜ PHÁT, cloud tự gửi lại, quá N phút báo Kế hoạch; (2) đang chạy lệnh mà mất kết nối quá N giây → chế độ ngoại tuyến, chạy tiếp lệnh đang chạy và lệnh đã nhận (QT20, QT21), lệnh mới nằm CHỜ PHÁT; mọi sự kiện của lệnh (mẻ, quét bao, cân, lon / thùng, xuất NVL) vào hàng đợi local, gắn mã lệnh + mã duy nhất + số thứ tự; kiểm lô theo bản sao trạng thái lô trên local; mã QR lấy từ dải mã cấp trước.
- Có lại kết nối: đẩy hàng đợi lên cloud theo thứ tự, cloud bỏ trùng theo mã sự kiện; cloud cập nhật tiến độ lệnh, gửi xuống lệnh CHỜ PHÁT, lô bị KHÓA, công thức mới; lệnh còn chạy thì tiếp tục, xong thì kết thúc. Xung đột (lô đã dùng nhưng cloud đã KHÓA / HỦY, tồn âm) → Kế hoạch + QC xử lý, QC kiểm lại lô liên quan (QT23), tồn âm → QT17.
- 1 ô cần chốt: ngoại tuyến tối đa bao lâu thì dừng lệnh; có cho tạo lệnh khẩn ở local không; dải mã QR cấp trước bao nhiêu.

Sửa 16/10 (bỏ QT Hiệu chuẩn thiết bị đo — số cũ QT25):
- Xóa QT Hiệu chuẩn khỏi bộ quy trình. Không QT nào khác gọi tới. Đánh số lại: Truy xuất QT26 → QT25, Thu hồi QT27 → QT26; mọi tham chiếu trong ô đã đổi theo. Các ghi chú "Sửa / Bổ sung" cũ phía trên ghi QT26 / QT27 là số cũ.
- Thiết bị đo vẫn còn trong danh mục (QT02).

Sửa 16/10 (QT26 Thu hồi):
- Bỏ ô THIẾU "diễn tập thu hồi định kỳ" — không làm. Lỗ hổng chính mục Thu hồi bỏ ý này theo.

Sửa 16/10 (QT25 Truy xuất; tách QT26 Thu hồi thành QT26 Khiếu nại + QT27 Thu hồi):
- QT25: bỏ vòng lặp giả "Nhận yêu cầu? Không → quay lại" và quyết định "Cần thu hồi?" (hệ thống không quyết thu hồi). Thêm phiếu yêu cầu truy xuất (nguồn, lý do, mã đầu vào, nhật ký ai truy xuất); 2 hướng ngược / xuôi cùng gom hồ sơ QC, COA, mẫu lưu, NCR; truy ngược có thêm lô bao bì (lon / thùng); cân bằng khối lượng từng lô (SX = giao + tồn + đang chuyển + hủy + mẫu lưu), lệch thì biên bản + QT17. Không có nhánh "chuỗi đứt / đối chiếu giấy": chốt 16/10 sản xuất bắt buộc ghi đủ liên kết lô ở từng bước, hệ thống chặn thao tác nếu không ghi được. Kết quả trả về bên yêu cầu — QT25 chỉ là bước con, không gọi QT27 (bỏ gọi vòng tròn 25 ↔ 26). Chuyện Admin chỉ định vai trò truy xuất thuộc QT01.
- QT26 Khiếu nại (mới, tách từ QT22 cũ): mọi khiếu nại đều ghi phiếu gắn lô và QC đánh giá, kể cả khi khách đồng ý đổi trả — không đóng bằng thương lượng. QC kiểm hàng khách gửi về (nếu có) + mẫu lưu, kết luận 1 trong 2: lỗi đơn lẻ (đổi trả, hướng dẫn bảo quản) / lỗi cả lô hoặc nhiều lô (KHÓA lô ngay → QT27). Bỏ quy tắc "lần sau lỗi không xử lý".
- QT27 Thu hồi: điểm vào gồm cả nội bộ (QT23 không đạt sau khi đã giao, QT25, NVL lỗi đã dùng, cơ quan yêu cầu). Thứ tự: KHÓA lô nghi lỗi → QT25 truy xuất → KHÓA thêm lô liên quan → đánh giá rủi ro, phạm vi → GĐ quyết thu hồi hay chỉ khoanh vùng (QT23 kiểm lại) → báo cơ quan (bắt buộc theo luật, không còn là ô THIẾU) → thông báo khách theo danh sách QT25 → nhập kho hàng thu hồi giữ KHÓA (QT14 cần thêm loại nhập "thu hồi") → theo dõi % thu hồi → tái chế (QT19) / hủy (QT18) → đổi lô mới / hoàn tiền (QT05 / QT10) → nguyên nhân gốc, CAPA (NVL → QT13, QT11) → đóng hồ sơ.
- 3 ô cần chốt: mục tiêu thời gian truy xuất và thời hạn lưu hồ sơ; quy định đổi trả và mức khiếu nại cần GĐ biết; ai ký quyết định thu hồi, mức nào bắt buộc thu hồi. Thêm biểu mẫu Phiếu truy xuất, Phiếu khiếu nại, Hồ sơ thu hồi.

Bổ sung 16/10 (QT01 Phân quyền — vòng đời tài khoản):
- 2 ô THIẾU thành bước thật: gán vai trò theo bảng Vai trò × Chức năng (không gán quyền lẻ); khóa tài khoản khi nghỉ việc / chuyển bộ phận.
- Vẽ lại theo vòng đời, 4 điểm vào từ 1 quyết định "Loại thay đổi?": nhân viên mới / đổi vai trò; nghỉ việc; quên mật khẩu / bị khóa. Thêm nhánh rà soát định kỳ.
- Phiếu đề nghị tài khoản do HR lập; hệ thống kiểm trùng mã NV, gợi ý vai trò theo chức danh. Vai trò nhóm quan trọng → Admin duyệt, còn lại → Trưởng BP duyệt. Từ chối ghi lý do, trả HR sửa.
- Đổi vai trò (chuyển BP / đổi chức danh): hệ thống liệt kê việc dở của vai trò cũ, Trưởng BP bàn giao, rồi gỡ vai trò cũ + gán vai trò mới trong 1 giao dịch.
- Nghỉ việc: đến ngày nghỉ tự KHÓA, đăng xuất mọi phiên, chặn thẻ / mã quét; không xóa tài khoản (tên còn trong nhật ký, hồ sơ mẻ, phiếu đã duyệt).
- Rà soát: tài khoản không đăng nhập quá N ngày tự khóa; định kỳ Trưởng BP xác nhận danh sách vai trò của bộ phận.
- Quy tắc chung: người tạo phiếu không tự duyệt phiếu của mình; mọi thay đổi tài khoản / vai trò ghi nhật ký (ai đề nghị, ai duyệt, trước / sau, thời điểm).
- Vai trò "Người truy xuất" (QT25) do Admin gán ở QT01 như mọi vai trò khác — không còn quy tắc riêng trong QT25.
- Thêm biểu mẫu "Tài khoản" và "Vai trò × Chức năng (dự thảo)". 3 ô cần chốt: nhóm vai trò quan trọng; công nhân dùng tài khoản riêng hay chung theo ca; N ngày không đăng nhập, chu kỳ rà soát.

Sửa 16/10 (bỏ QT26 Khiếu nại; QT27 Thu hồi bỏ tái chế):
- Xóa QT26 Khiếu nại khỏi bộ quy trình, bỏ biểu mẫu "Phiếu khiếu nại". Đánh số lại: Thu hồi QT27 → QT26; mọi tham chiếu trong ô đã đổi theo. Các ghi chú "Sửa / Bổ sung" cũ phía trên ghi QT26 Khiếu nại / QT27 Thu hồi là số cũ.
- Khách / đại lý báo lỗi cả lô (QC kết luận) giờ là 1 điểm vào trực tiếp của QT26 Thu hồi. QT23 không còn điểm vào "lô nghi lỗi từ khiếu nại"; QT25 không còn bên yêu cầu là khiếu nại.
- QT26 Thu hồi: bỏ quyết định "Xử lý lô thu hồi?" và nhánh tái chế (QT19). Thu đủ / hết hạn thu hồi → hủy lô (QT18) → đổi lô mới / hoàn tiền. Hồ sơ thu hồi: xử lý lô chỉ còn hủy.
- Bảng Vai trò × Chức năng bỏ phần khiếu nại của QC và CSKH / Sales.

Sửa 16/10 (QT01 Phân quyền — bỏ duyệt, bỏ bàn giao, đặt ngày khóa):
- Bỏ bước duyệt vai trò (Trưởng BP / Admin) và nhánh từ chối; bỏ ô cần chốt "nhóm vai trò quan trọng". HR (hoặc Admin) nhập thông tin, chọn vai trò, hệ thống kiểm trùng rồi tạo / đổi vai trò luôn.
- Bỏ bước liệt kê việc dở và bàn giao (cả khi đổi vai trò lẫn khi nghỉ việc).
- Nghỉ việc: HR đặt ngày khóa tài khoản (mặc định = ngày nghỉ, chọn khóa ngay hoặc ngày khác, sửa được trước ngày khóa); hệ thống báo trước N ngày, đến ngày đặt thì tự khóa.
- Biểu mẫu Tài khoản: bỏ trạng thái Chờ duyệt, người duyệt, lý do từ chối; thêm ngày khóa tài khoản. Ô cần chốt c3 thêm "báo trước ngày khóa bao nhiêu ngày".

Sửa 16/10 (QT01 công nhân; số mặc định cho mọi ô chốt thời gian):
- QT01: công nhân SX / đóng gói dùng tài khoản riêng, gắn khu vực làm việc, đăng nhập bằng quét thẻ, chỉ thao tác lệnh của khu mình (bỏ ô cần chốt c2). Biểu mẫu Tài khoản thêm khu vực làm việc.
- Mọi ô cần chốt về thời gian được gán số mặc định, hệ thống cho cấu hình lại sau. Ô chỉ có thời gian → thành ô ⚙ MẶC ĐỊNH (QT01 c3, QT06 c2, QT09 c4, QT10 c1, QT18 c0, QT25 c1). Ô còn ý khác → giữ CẦN CHỐT, phần thời gian ghi mặc định (QT09 c1, QT11 c2, QT14 c3, QT19 kc, QT26 c1). Các "N" trong bước QT01, QT09, QT19 đã thay bằng số; QT24 ghi thời hạn lưu mẫu mặc định.
- QT06: chốt bỏ hạn mức tạm thời — hạn mức được duyệt luôn là vĩnh viễn (bỏ ô ⚙ vc1, bỏ tham số 30 ngày).
- Thêm mục "Tham số thời gian mặc định" trong Biểu mẫu để gom mọi số ở một chỗ.

Sửa 16/10 (QT09 Giao hàng — giao từng phần; cờ tạm khóa):
- Cho giao từng phần: dòng / lô xong trước giao trước, mỗi đợt 1 phiếu xuất + 1 biên bản; khoản trước giao tính theo giá trị đợt; phần còn lại xong thì QT09 chạy lại. Bỏ ô cần chốt c2.
- Cờ khách tạm khóa do nợ quá hạn chỉ chặn đơn Mua chịu; đơn đã thu đủ vẫn giao. Bỏ ô cần chốt c3.

Sửa 16/10 (chốt ô cần chốt / thiếu ở QT11–QT24):
- QT11: chỉ Trưởng BP Mua hàng duyệt NCC; không có bước đánh giá tại xưởng NCC.
- QT12: chỉ 1 NCC đã duyệt thì mua luôn, không so sánh giá; PO trên 100 triệu cần GĐ duyệt (mặc định, cấu hình lại được).
- QT13: hướng xử lý tranh chấp, đơn vị kiểm nghiệm, chi phí do nhà máy tự quyết; hệ thống chỉ ghi nhận.
- QT14: không cho nợ chứng từ; phiếu nhập không duyệt — chỉ Thủ kho trưởng xác nhận khi lệch (24/10 đợt 7).
- QT15: xuất BTP / bao HH sang khu khác theo FEFO.
- QT16: 2 ô THIẾU thành bước thật — phiếu chuyển kho + lô ĐANG CHUYỂN + ghi liên kết bao → phiếu; thất lạc lập biên bản, phần thất lạc → HỦY.
- QT17: kiểm toàn kho, bỏ đề xuất kiểm cuốn chiếu theo khu.
- QT18: không ghi nhận hình thức hủy, người chứng kiến, ảnh biên bản — bỏ ô THIẾU g1, giữ bước "Thực hiện hủy, lập biên bản" như cũ.
- QT23: lô TP đạt thì sinh phiếu chứng nhận chất lượng xuất xưởng, gửi kèm khi giao.
- QT24: bỏ ô cần chốt "hỏi lại MD".

Sửa 16/10 (QT09, QT11, QT21, QT26):
- QT09: mặc định không liên hệ được quá 30 ngày → khách "mất"; hủy đơn đề xuất giữ toàn bộ cọc, người duyệt QT07 sửa được (cấu hình lại được). Bỏ ô cần chốt c1.
- QT11: bỏ hẳn đánh giá lại định kỳ (nhánh dưới, trạng thái TẠM NGƯNG / LOẠI, điểm NCC). Trả hàng, giao trễ / thiếu chỉ ghi lịch sử NCC. QT12, QT13, QT26, Hồ sơ NCC sửa theo.
- QT21: QC lấy mẫu sau khi thùng đã nhập kho BTP (đổi thứ tự bước). Bỏ ô cần chốt c1.
- QT26: GĐ ký quyết định thu hồi; còn chốt mức nguy hại nào bắt buộc thu hồi.

Sửa 16/10 (mã QR):
- Mã bao HH (QT20) và thùng (QT21) sinh tại server nhà máy, nên mất kết nối cloud vẫn in tem bình thường; lon dùng mã có sẵn trên bao bì, hệ thống không cấp mã lon. Bỏ "dải mã QR cấp trước" ở QT19 (y3, k4, ô cần chốt kc). QT04, QT21, biểu mẫu Mã QR sửa theo.

Sửa 16/10 (chốt các ô cần chốt cuối):
- QT19: không cho tạo lệnh ở server nhà máy, lệnh chỉ tạo trên cloud.
- QT17: thêm nhánh kiểm điểm — lệch tồn phát sinh (QT15 / QT19 / QT25) chỉ khóa và đếm lại đúng vị trí / lô bị lệch; kiểm định kỳ vẫn kiểm toàn kho.
- QT11: thêm thao tác tay "Ngừng dùng NCC" (Trưởng BP Mua hàng, ghi lý do); trạng thái NGỪNG DÙNG, muốn dùng lại thì duyệt lại.
- QT14: bộ chỉ tiêu COA do nhà máy tự quyết, nhập ở danh mục NVL; hệ thống ghi nhận và kiểm theo.
- QT26: mức nguy hại nào phải thu hồi do nhà máy tự quyết; hệ thống ghi nhận.
- Hết ô CẦN CHỐT.

Sửa 16/10 (QC khi nhập kho; QT14 hàng thu hồi):
- "QC không kiểm khi nhập kho" chỉ áp dụng cho BTP. NVL mua vào CHỜ KIỂM → QT22; TP vào CHỜ KIỂM → QT23, QC thành phẩm chặn giao hàng (QT23 gọi QT09, QT14 không gọi QT09 nữa). Khách trả vào KHÓA → QT23 kiểm lại.
- QT14 thêm loại nhập "hàng thu hồi" (từ hồ sơ QT26): lô giữ KHÓA, không vào tồn bán. Bỏ ô SỬA f1 ở QT26.
- QT21: lô TP CHỜ KIỂM tới khi QC ĐẠT thành bước thật. QT22: bộ chỉ tiêu & giới hạn NVL, đối chiếu COA do nhà máy chốt sau, nhập ở danh mục NVL. QT23 sửa điểm vào.

Sửa 16/10 (NVL mua không QC):
- NVL mua không QC khi nhập kho: vào kho là ĐẠT, dựa vào COA kiểm tự động ở QT14. QT14 bỏ gọi QT22; QT22 chỉ chạy khi lô NVL nghi lỗi. Chỉ TP vào CHỜ KIỂM (QT23 chặn giao).

Bổ sung 16/10 (Vòng đời lô hàng): gom mọi chỗ đổi trạng thái lô ở các QT vào mục "Vòng đời lô hàng" (danh sách 6 trạng thái, bảng chuyển trạng thái, sơ đồ, phân biệt với cờ / trạng thái khác); chỉ tổng hợp, không đổi logic QT nào; 18 câu hỏi chờ chốt ghi cuối mục.

Sửa 16/10 (chốt vòng đời lô hàng — 18 câu; chi tiết ở mục "Vòng đời lô hàng"):
- Trạng thái gắn theo phần lô × vị trí; KHÓA luôn kèm lý do khóa (lý do quyết định lối ra; thu hồi / hết hạn chỉ hủy). Bỏ ĐANG CHUYỂN, "trên xe" là vị trí của phiếu chuyển. Còn 5 trạng thái.
- Loại lô: nguyên liệu mua và nguyên liệu hỗn hợp vào là ĐẠT; BTP (thùng sau chiết rót) vào kho BTP ở CHỜ KIỂM, QC đạt thì đổi thành TP trên cùng mã lô. QC nguyên liệu chỉ khi có vấn đề, không kiểm định kỳ.
- QT13: bỏ tranh chấp và kiểm nghiệm bên thứ 3 (nhà máy tự giải quyết ngoài); hàng trả NCC xuất qua loại xuất "trả NCC"; nhận đổi hay giảm nợ đều xuất trả trước; hàng bị từ chối ở cửa kho không tạo lô.
- QT14 / QT21: BTP vào CHỜ KIỂM; NVL dư nhận trạng thái theo khóa cả lô của lô gốc. QT15: quy tắc trạng thái theo loại xuất, thêm loại xuất trả NCC. QT16: vị trí trên xe, nhận thiếu chờ tìm 7 ngày, nhận hư vào khu hàng lỗi. QT17: khóa kiểm kê là cờ riêng. QT18: tạo phiếu hủy là tự khóa, Trưởng kho từ chối có lối ra. QT19: tự khóa lô sinh ra từ mẻ dính xung đột, máy chủ nhà máy tự chặn lô hết hạn. QT20: bao hỗn hợp ra là ĐẠT.
- QT22 / QT23: QC trưởng duyệt mọi kết luận; từ chối yêu cầu kiểm thì lô về trạng thái trước; BTP / TP không đạt chỉ hủy (không sản xuất lại từ BTP / TP, bù bằng lệnh mới); NVL không đạt chỉ xử lý phần trong kho; TP đã giao một phần mà không đạt thì hồ sơ thu hồi quay lại GĐ; thêm thao tác mở lại lô NVL KHÔNG ĐẠT. QT25: sửa công thức cân bằng khối lượng. QT26: thêm bước đổi lý do khóa sang "thu hồi".

Sửa 17/10 (QT20 Vận hành mẻ, QT21 Chiết rót & đóng gói — các ô THIẾU ở sản xuất thành bước thật; md đồng bộ lại theo artifact):
- QT20: quét từng bao → hệ thống kiểm đúng công thức, lô ĐẠT, còn hạn; sai thì báo lỗi, không mở silo, trả bao. Ghi liên kết bao → silo → mẻ ngay lúc quét (không ghi được thì chặn). Đổ lặp tới đủ silo. Bỏ nhánh "đổ đúng chưa" và hủy mẻ / phiếu NCR (sai bao đã bị chặn từ đầu). Khu HH: cân bao theo dung sai công thức, lệch thì bù / bớt rồi cân lại, ghi KL thực tế; ghi liên kết mẻ → bao HH. Khu BTP: ghi thông số trộn vào hồ sơ mẻ. Sự cố dừng máy ghi vào hồ sơ mẻ.
- QT21: một mẻ chiết cho nhiều nhãn hiệu cùng công thức, mỗi nhãn hiệu một lô (số lô, NSX, HSD in sẵn trên bao bì lon — hệ thống không in). Chỉ quét lon đầu của từng nhãn hiệu (kiểm đúng nhãn của mẻ, gắn mẻ → nhãn hiệu → lô), sau đó đếm. Cân từng lon sau đậy nắp, lon lệch loại ra và chiết bù. Đóng thùng không quét lon; dán QR thùng, hệ thống gắn thùng với nhãn hiệu / lô theo bộ đếm. Thùng thiếu kg thì đếm lại, sửa số lon. QC lấy mẫu từng lô (nhãn hiệu) sau khi nhập kho BTP.
- Lỗ hổng chính 5–7 và quyết định 18 của vòng đời lô hàng sửa theo. Còn để ngỏ: hủy mẻ do sự cố không khắc phục được chưa có phiếu NCR.

Chốt 17/10 (Vai trò × Chức năng): thay bản dự thảo ở Biểu mẫu bằng mục riêng "Vai trò × Chức năng" — 18 vai trò (tách GĐ / KTT; thêm Trưởng bộ phận, R&D; Trưởng kho = Thủ kho trưởng; kho điều phối / xuất / nhận / BTP = Thủ kho theo phạm vi kho; Công nhân 1 vai trò theo khu), bảng map tác nhân → vai trò, bảng quyền từng bước T / D của 26 QT theo 7 mảng, 14 câu hỏi chờ quyết; chưa sửa sơ đồ QT nào.

Đổi tên 17/10: mục "Máy trạng thái lô" → **"Vòng đời lô hàng"** (dễ hiểu hơn với người dùng nghiệp vụ). Chỉ đổi tên, không đổi nội dung; mọi tham chiếu trong file, sơ đồ dữ liệu và trang xem HTML đã đổi theo.

Chốt 17/10 (Vai trò × Chức năng — trả lời 14 câu hỏi): SX = Kế hoạch; tem lỗi ở khu SX công nhân chỉ báo; Kế hoạch lập NCR; tách CSKH, R&D (19 vai trò); QC trưởng mở hồ sơ thu hồi, báo cơ quan, duyệt CAPA; GĐ duyệt đóng hồ sơ thu hồi; KTT duyệt mọi phiếu chi; Trưởng BP Mua hàng hủy PO đã duyệt; bỏ QC đánh giá mẫu NCC (QT11); mã danh mục hệ thống tự sinh, không duyệt (QT02); Thủ kho trưởng xác nhận thất lạc (QT16); Admin toàn quyền, ủy quyền tạm có ngày hết hạn (QT01); bộ chỉ tiêu BTP / TP, thời hạn lưu mẫu QC tự quyết (QT23, QT24); sửa cột sơ đồ QT20, QT24, QT26. Còn chờ quyết: hủy mẻ do sự cố.

Chốt 17/10 (hủy mẻ, định dạng mã): QT20 thêm nhánh sự cố không khắc phục được — công nhân báo, Kế hoạch quyết hủy mẻ, bột hỏng KHÓA chờ hủy và tự tạo phiếu hủy (QT18), thêm 1 mẻ bù vào lệnh đang chạy; Vòng đời lô hàng thêm 1 dòng chuyển trạng thái. Định dạng mã danh mục do Claude đề xuất, ghi ở biểu mẫu Danh mục. Hết câu chờ quyết của mục Vai trò × Chức năng.

Chốt 17/10 (định dạng mã danh mục): chốt các mẫu mã đề xuất; thêm nhóm HHP cho nguyên liệu hỗn hợp (`NVL-HHP-0001`); mã kho `{nhà máy}-{loại kho}` — mỗi nhà máy 1 kho mỗi loại. Sơ đồ dữ liệu sửa theo (bảng `code_format`).

Bổ sung 19/10 (Phân hệ & màn hình — mục mới, từ giai đoạn mockup):
- Thêm mục "Phân hệ & màn hình": menu web chia 10 phân hệ (Việc cần làm, Bán hàng, Mua hàng, Kế toán, Kho, Sản xuất, Chất lượng, Truy xuất & thu hồi, Danh mục, Quản trị), hiện theo quyền — không có quyền ở phân hệ nào thì ẩn phân hệ đó; menu máy quét riêng (nhập & cất hàng, lấy hàng xuất, nhận chuyển kho, kiểm kho, dời vị trí, sự cố tem). Màn hình PC xưởng ngoài phạm vi mockup, quy trình giữ nguyên.
- Thêm bảng "Màn hình → quy trình, bước, bảng dữ liệu chính, vai trò được thao tác" làm căn cứ viết test case, và ánh xạ phân hệ Kế toán (gom thu tiền & công nợ của mảng Bán hàng với thanh toán, công nợ NCC của mảng Mua hàng).

Sửa 19/10 (Kế toán — chỉ ghi nhận công nợ, hạn chế tự động; QT10 và các QT gọi sang):
- Hệ thống chỉ ghi nhận tiền và công nợ, đủ để chặn / mở nghiệp vụ bán hàng, mua hàng: không hạch toán, không sổ cái, không tài khoản kế toán, không xuất hóa đơn điện tử, không báo cáo thuế, không đối soát ngân hàng. Chỉ tự động 3 việc: tính dư nợ, nợ quá hạn; bật / tắt cờ tạm khóa khách; nhắc nợ bằng thông báo trong hệ thống cho Sales và Kế toán (không email, không gửi khách).
- QT10 đổi tên "Thu / hoàn tiền & công nợ" → "Ghi nhận thu chi & công nợ", vẽ lại: Kế toán "Ghi nhận tiền về" (số tiền, ngày, CK / tiền mặt, ảnh chứng từ) → hệ thống cấn vào khoản; "Ghi nhận hoàn tiền" theo số GĐ / KTT đã quyết. Bỏ: Kế toán trưởng duyệt phiếu chi (hoàn tiền, trả NCC, hoàn tiền thu hồi chỉ ghi nhận); xuất hóa đơn trong hệ thống (chỉ nhập số hóa đơn + file vào đợt giao); tự sinh phiếu thu; xóa nợ trong hệ thống (nợ quá 90 ngày GĐ / KTT quyết bên ngoài, Kế toán ghi kết quả).
- Sửa chữ ở các QT gọi QT10: QT05, QT06, QT07, QT08, QT09; QT12 (ghi nhận đã trả trước / trả sau, thêm nhánh trả sau), QT13 (ghi nhận giảm trừ khoản phải trả), QT16 / QT18 (chỉ ghi giá trị hàng thất lạc / hàng hủy, bỏ ghi tổn thất theo nghĩa kế toán), QT26 (hoàn tiền thu hồi Kế toán ghi nhận ở QT10).
- Bảng quyền: bỏ "Kế toán trưởng duyệt phiếu chi" và "GĐ / KTT xóa nợ"; Kế toán giữ quyền ghi nhận; Kế toán trưởng xem được mọi công nợ.

Sửa 19/10 (Phân quyền):
- Sales thêm quyền XEM công nợ, hạn mức, lịch sử thanh toán của khách (chỉ xem).
- Màn Vai trò × quyền chỉ để xem; muốn đổi quyền thì sửa mục Vai trò × Chức năng rồi sinh lại dữ liệu nạp. (Bỏ 04/11 — Admin sửa quyền trên màn.)
- Vai trò ủy quyền tạm được: Giám đốc, Kế toán trưởng, Trưởng bộ phận, Thủ kho trưởng, Trưởng BP Mua hàng, QC trưởng, Kế hoạch. Kế toán trưởng vẫn còn quyền duyệt hạn mức / số tiền hoàn nên vẫn ủy quyền được.
- Duyệt ngừng dùng mã NVL / SP hiện trong Việc cần làm của Trưởng bộ phận bên đề xuất. Nhà máy, khu vực làm việc, kho: Admin tạo / sửa / ngừng dùng. Vị trí kệ: Thủ kho trưởng của kho đó làm trực tiếp (tạo, kể cả hàng loạt; sửa; in tem QR ô; ngừng dùng ô đang trống).

Sửa 19/10 (QT01 — tài khoản, đăng nhập, rà soát):
- Máy quét: quét thẻ NV là cách đăng nhập chính cho mọi người dùng máy quét (không chỉ công nhân); quên thẻ thì mã NV + mật khẩu; thẻ của tài khoản đã khóa bị chặn ngay. Mã thẻ bắt buộc với công nhân, không bắt buộc với người khác.
- Đăng nhập lần đầu / sau mật khẩu tạm: bắt đổi mật khẩu. Quy tắc mật khẩu cố định trong code (≥ 8 ký tự, có cả chữ và số) — không phải tham số, không cấu hình qua màn hình.
- Rà soát hằng quý theo TỪNG TÀI KHOẢN: hệ thống gợi ý tài khoản cần xem (không đăng nhập lâu nhưng chưa tới ngưỡng tự khóa; giữ vai trò khác nhóm với chức danh; đang giữ vai trò tạm; đã đặt ngày khóa); Trưởng BP quyết từng dòng (giữ / gỡ vai trò / khóa) rồi xác nhận cả bộ phận; không tự quyết dòng của chính mình; HR chỉ theo dõi tiến độ, nhắc. Vẽ lại nhánh rà soát.
- Ủy quyền tạm hiện "Sắp bắt đầu" khi ngày bắt đầu ở tương lai — suy ra từ ngày, không thêm trạng thái.

Sửa 19/10 (QT02 Danh mục):
- Danh mục chỉ còn 4 loại: NVL, SP, kho, vị trí kệ. Vẽ lại QT02: NVL / SP (bộ phận đề xuất tạo / sửa; ngừng dùng qua đề nghị → Trưởng BP bên đề xuất duyệt; người đề xuất rút được đề nghị khi đang chờ duyệt; kiểm tham chiếu thêm đơn mua đang mở); kho (Admin làm trực tiếp); vị trí kệ (Thủ kho trưởng làm trực tiếp, tạo hàng loạt theo khu / kệ / tầng / ô, in tem QR ô, ngừng dùng ô chặn nếu ô còn hàng). SP có trang chi tiết để QC nhập bộ chỉ tiêu thành phẩm.
- Mã công thức tự sinh `CT-{loại}-{4 số}` (loại HH / BTP; vd `CT-HH-0001`) — thêm vào định dạng mã đã chốt, biểu mẫu Danh mục, QT03.

Sửa 19/10 (bỏ quản lý thiết bị; đơn vị tính không có màn riêng):
- Bỏ hẳn thiết bị đo: xóa khỏi tên QT02, bộ trường bắt buộc, biểu mẫu Danh mục, định dạng mã.
- Thiết bị sản xuất (silo, bồn trộn, máy chiết, robot, cân băng tải) không có màn quản lý, không thuộc danh mục: danh sách do bên làm hệ thống (cũng là bên cung cấp thiết bị) cung cấp, nạp khi triển khai. Đơn vị tính không có màn riêng: nạp khi triển khai, Admin thêm trong màn Tham số khi cần.

Sửa 19/10 (QT03 Công thức): thông số trộn chuẩn có thêm thứ tự nạp; màn Công thức hiện lệnh nào đang chạy phiên bản cũ; mã công thức tự sinh. Công thức thuộc phân hệ Sản xuất; quyền giữ nguyên (R&D, Kế hoạch nhập / sửa; QC, công nhân chỉ xem).

Sửa 19/10 (QT04 Sự cố tem — chỉ làm trên máy quét):
- Tem mất: thủ kho quét mã ô → chọn lô của bao → chọn mã cũ trong lô để khóa → cấp mã mới cùng lô, in, dán, quét xác nhận.
- Hủy tem khi bao vẫn còn trên kệ: sang luồng tem mất để cấp mã mới. Mã đã khóa mà bị quét lại: chặn và hiện mã thay thế.

Sửa 19/10 (đợt 2 — khu vực làm việc & dàn silo, lệnh SX, bỏ máy quét riêng, mua hàng / kho):
- Khu vực làm việc (QT02 ka, ks — Admin, màn Quản trị · Nhà máy & khu vực làm việc): loại khu HH / BTP / chiết rót / đóng gói; khu HH, BTP có khối lượng mẻ tối đa (kg). Mỗi khu HH / BTP có dàn silo riêng (số silo khác nhau): tên, sức chứa (kg), gán cứng 1 NVL (tùy chọn), trạng thái Hoạt động / Bảo trì / Ngừng dùng, mã thiết bị trên SCADA; Admin thêm silo, sửa, chuyển bảo trì / ngừng dùng. Chặn đổi loại khu khi khu còn lệnh chưa hoàn thành; không xóa khu, chỉ ngừng dùng. Silo chuyển bảo trì / ngừng dùng mà lệnh chưa phát đang xếp NVL vào: báo Kế hoạch xếp lại, chặn phát lệnh tới khi xếp lại. Sửa quy tắc cũ "thiết bị SX không có màn quản lý": chỉ silo được quản lý trong cấu hình khu; bồn trộn, máy chiết, robot, thang nâng, cân vẫn do bên cung cấp thiết bị khai báo khi triển khai.
- QT19 Tạo & phát lệnh (vẽ lại): 9 điều kiện tạo lệnh theo thứ tự — khu sản xuất · đơn hàng & khách · công thức hiệu lực · thời gian nhận đơn & dự kiến xong · NV tiếp thị · số mẻ & khối lượng mẻ (≤ mức tối đa của khu) · giấy tờ xuất xứ NVL (1 tệp đính kèm, Kế hoạch tải lên khi tạo; không kiểm chứng từ theo từng lô) · tồn NVL khả dụng · dàn silo. Loại lệnh theo khu. Dàn silo: hệ thống gợi ý xếp NVL → silo theo gán cứng và sức chứa, Kế hoạch kéo thả chỉnh; số NVL của công thức ≤ số silo đang hoạt động, đúng gán cứng, không dùng silo bảo trì; phương án chốt khi tạo lệnh, kiểm lại khi phát. Mỗi khu một hàng đợi phát lệnh, Kế hoạch đổi thứ tự ưu tiên, phát lệnh đầu hàng. Trạng thái lệnh: Mới tạo (đã giữ chỗ KG, vào hàng đợi) → Chờ phát (chỉ khi đã phát mà server nhà máy không nhận) → Đã nhận → Đang chạy → Hoàn thành; Đã hủy. Không có Nháp, không xóa lệnh; hủy lệnh chưa chạy (Mới tạo / Chờ phát / Đã nhận) bắt buộc lý do, giải phóng giữ chỗ; sửa lệnh Đã nhận thì gửi lại xuống nhà máy. Lệnh BTP có kế hoạch nhãn hiệu nhiều dòng (SP, số lô in trên lon nếu đã biết, số lon), lấy từ các dòng đơn cùng công thức. QT20: mở silo theo phương án silo của lệnh.
- Bỏ ứng dụng / menu máy quét riêng: thao tác quét nằm trong màn của từng quy trình (dùng đầu đọc mã) — màn Kho trên web (nhập & cất hàng, lấy hàng xuất, nhận chuyển kho, kiểm kho, dời vị trí), màn PC xưởng (quét bao vào mẻ, lon đầu, dán QR thùng). Bỏ mục "Menu máy quét" và các dòng "Máy quét" ở bảng màn hình, gắn các bước vào màn Kho / PC xưởng tương ứng. Đăng nhập (QT01): web bằng mã NV + mật khẩu; quét thẻ NV chỉ còn ở PC xưởng; mã thẻ bắt buộc với công nhân, không bắt buộc với người khác.
- QT04 Sự cố tem (vẽ lại): bỏ "chỉ làm trên máy quét" — làm ở Kho · Tồn kho, do Thủ kho (kể cả thủ kho kho điều phối với tem lỗi ở khu SX): chọn dòng lô × ô → danh sách bao → "Sự cố tem". Tem hỏng: in lại cùng mã, dán, quét xác nhận. Tem mất: ô + lô lấy từ dòng tồn → chọn mã cũ để khóa → cấp mã mới cùng lô → in, dán, quét xác nhận. Hủy tem: bao còn trên kệ thì đi như tem mất; bao không còn thì chỉ khóa mã, thu tem. Mã đã khóa bị quét ở bất kỳ màn nào: chặn, hiện mã thay thế.
- QT12 Mua NVL: Kế hoạch lập yêu cầu mua; Mua hàng lấy báo giá từ một yêu cầu mua; hủy báo giá thì yêu cầu mua về Mở, lý do hủy lưu vào chứng từ. Màn Đơn mua có 2 tab: Yêu cầu mua & báo giá / PO. Điều khoản thanh toán của NCC và PO chỉ có Trả trước / Trả sau N ngày. (Bỏ báo giá 04/11 — xem QT12.)
- QT13 Trả hàng NCC (vẽ lại phần xuất trả): thêm trạng thái "Chờ kho xuất trả" — Mua hàng gửi yêu cầu xuất trả; Thủ kho lập phiếu xuất loại trả NCC (24/10 đợt 6: Trưởng BP Mua hàng duyệt yêu cầu xuất trả trước, phiếu xuất không duyệt); xuất xong thì phiếu trả → "Đã xuất trả". Giảm trừ do Kế toán ghi ở Công nợ NCC. Không được trả vượt số đã nhận của PO (cộng cả các phiếu trả khác); không được chọn "giảm công nợ" khi PO là trả trước.
- QT15 Xuất kho: thiếu hàng mà không có lô thay thế (bán / chuyển kho / trả NCC) thì phiếu sang "Chờ bên yêu cầu"; chỉ bên yêu cầu chọn nhận phần đã lấy (→ Xuất một phần) hoặc hủy (→ Đã hủy).
- Tên gọi: menu "Kiểm kho" (không dùng "Kiểm kê"); "Thủ kho trưởng" thay "Trưởng kho" ở mọi chỗ còn sót (cột QT17, QT18, nút QT18 t2, Lý do khóa, Bảng chuyển trạng thái, tham số, bảng vai trò).
- Bảng quyền: thêm QT02 ks (Admin cấu hình dàn silo), QT12 tq (Mua hàng hủy báo giá), QT13 tx (Mua hàng gửi yêu cầu xuất trả), QT19 ys (Kế hoạch xếp dàn silo), QT19 q1 (Kế hoạch xếp hàng đợi phát lệnh); "Bên yêu cầu" ở QT15 thêm Mua hàng (xuất trả NCC); sửa chữ các dòng QT04, QT12 t1, QT13 t3, QT15 dời vị trí, QT19 (hủy / sửa lệnh thành bước hl). (Bỏ báo giá 04/11 — xem QT12.)

Sửa 19/10 (đợt 3 — chốt câu hỏi đợt 2; thay các chỗ đợt 2 nói khác):
- Lệnh đã phát **không sửa**. Mới tạo: sửa mọi thứ, hủy ngay (lý do, giải phóng giữ chỗ). Chờ phát / Đã nhận: chỉ hủy rồi tạo lại (sao chép lệnh) — lệnh hủy gửi xuống nhà máy, nhà máy xác nhận chưa chạy mẻ thì mới ĐÃ HỦY; nhà máy đã chạy mẻ (lúc mất kết nối) thì từ chối hủy, lệnh ĐANG CHẠY. Đang chạy: không sửa, không hủy; **kết thúc sớm** (Kế hoạch, lý do, sau khi mẻ đang chạy xong): lệnh → HOÀN THÀNH với số mẻ thực tế, giải phóng giữ chỗ còn lại, bột dư silo xả về kho điều phối, phần thiếu tạo lệnh mới. Ngoại lệ duy nhất trên lệnh đang chạy: thêm mẻ bù khi hủy mẻ do sự cố (QT20 kb). Khách sửa đơn (QT08 r2): lệnh Mới tạo sửa thẳng; đã phát chưa chạy thì hủy rồi tạo lại; đang chạy thì kết thúc sớm (đơn giảm) hoặc tạo thêm lệnh (đơn tăng). Bỏ "sửa lệnh Đã nhận thì gửi lại xuống nhà máy" của đợt 2.
- Silo bảo trì / ngừng dùng theo trạng thái lệnh: Mới tạo → cần xếp lại, chặn phát (như đợt 2); Chờ phát / Đã nhận → PC xưởng chặn Start, Kế hoạch chờ bảo trì xong hoặc hủy rồi tạo lại; Đang chạy → chặn mẻ tiếp, chờ hoặc kết thúc sớm. Admin chuyển bảo trì thì hệ thống hiện danh sách lệnh bị ảnh hưởng (mọi trạng thái) để xác nhận; không cho chuyển khi silo còn bột của lệnh (đang có mẻ chạy dở → luồng sự cố QT20; giữa 2 mẻ → xả bột về kho điều phối trước).
- Silo **nạp một lần dùng cho nhiều mẻ, được nạp bổ sung**, 1 NVL – 1 silo trong 1 lệnh. Mỗi lần nạp kiểm bột đang có trong silo + bao ≤ sức chứa (không giới hạn số mẻ theo sức chứa); mỗi mẻ silo xả đúng KL / mẻ. Vẽ lại phần đầu QT20 (nạp silo, xả cho mẻ) và phần cuối (bột dư).
- Truy xuất qua silo (cách B): mỗi silo của lệnh là 1 nút trong chuỗi — lô NVL → nạp silo → silo → xả → mẻ, mỗi lần nạp / xả ghi thời điểm; lô nạp lúc T là đầu vào của các mẻ xả sau T, tới khi silo xả sạch (công nhân xác nhận) thì đóng nút, lần nạp sau mở nút mới. Cân bằng khối lượng tính ở mức silo: tổng nạp = tổng xả cho mẻ + bột dư + bột còn trong silo.
- Hết lệnh (hoặc kết thúc sớm), bột còn trong silo xả vào bao, dán QR thành lô NVL dư mới (liên kết từ nút silo), nhập về kho điều phối (QT14). Lệnh chỉ HOÀN THÀNH khi mọi silo của lệnh đã xả sạch.
- Hàng đợi phát lệnh = thứ tự chạy ở nhà máy: lệnh Chờ phát giữ vị trí, lệnh sau chờ tới khi nhà máy nhận; cloud gửi lại theo thứ tự; PC xưởng hiện lệnh theo thứ tự. Admin giảm khối lượng mẻ tối đa của khu: lệnh Mới tạo vượt mức bị chặn phát (Kế hoạch sửa), lệnh đã phát vượt mức thì báo Kế hoạch tự quyết.
- Xuất SX thiếu mà hết lô thay thế cũng sang "Chờ bên yêu cầu" (Kế hoạch chọn), hệ thống nhắc Kế hoạch lập yêu cầu mua phần thiếu.
- Trả NCC: SL quy về ĐVT gốc của NVL; tính mọi phiếu trả của cùng PO (kể cả phiếu nhà máy chịu, hủy hàng); thêm chặn SL trả ≤ tồn hiện có của lô; mọi phiếu trả bắt buộc gắn PO; hàng bị từ chối ở cửa kho (không có lô) so với SL ghi trong biên bản từ chối, không tính vào số đã nhận.
- Bảng quyền: QT19 hl chỉ còn hủy; thêm QT19 su (sửa lệnh Mới tạo), QT19 kt (kết thúc sớm), QT20 vs (xác nhận silo xả sạch), QT20 xd (xả bột dư cuối lệnh); sửa chữ QT08 r2, QT20 t3.

Sửa 19/10 (đợt 4 — tối 19/10, chốt sau rà soát mockup; thay các chỗ cũ nói khác):
- NVL cho sản xuất đi qua kho điều phối: kho tổng → chuyển kho (QT16) → kho điều phối → kho điều phối chuẩn bị NVL theo lệnh, xuất cho khu; phiếu xuất SX lập từ kho điều phối (QT15), không xuất SX thẳng từ kho tổng.
- QT19 (vẽ lại đoạn giữ chỗ → phát): khi tạo / phát lệnh mà kho điều phối thiếu so với KG giữ chỗ, hệ thống tự lập đề nghị chuyển kho tổng → kho điều phối đúng phần thiếu; Kế hoạch gửi ngay trong màn Lệnh SX. QT16 thêm nhánh vào từ đề nghị tự lập. Thủ kho kho tổng xuất, Thủ kho kho điều phối nhận & quét. Người yêu cầu chuyển kho là Kế hoạch (sửa bảng Mảng 5 đang ghi Thủ kho kho điều phối; bỏ "chuyển kho" khỏi phần Thủ kho ở QT15 s).
- Lô nghi lỗi gửi QC → CHỜ KIỂM (không KHÓA) — QT22 y1, khớp Vòng đời lô.
- QT02: thêm 4 danh mục của SP (dòng SP, quy cách đóng gói, hạng, thương hiệu) thuộc Danh mục › Sản phẩm, thêm / sửa / ngừng dùng như NVL, SP; bộ chỉ tiêu thành phẩm gắn với từng SP. NCC, kho, nhà máy có màn trong Danh mục.
- Menu web và bảng màn hình cập nhật đúng sidebar hiện tại (mục "Phân hệ & màn hình").

Sửa 20/10 (phân quyền & menu — chốt sau rà soát phân quyền trên mockup, `mes-powder-ra-soat-vai-tro-20-10.md`; thay các chỗ cũ nói khác):
- Admin không còn toàn quyền: quản trị hệ thống + xem mọi màn (QT01 xa), không làm bước nghiệp vụ QT02–QT26 ngoài các bước đã ghi tên Admin (ka, ks). Giám đốc cũng xem mọi màn. Tài khoản Hệ thống chỉ cho thao tác tự động.
- Menu suy ra từ quyền: màn hiện khi vai trò có ít nhất 1 quyền ở bước của màn (bảng `screen_function`); thêm các dòng quyền xem xk, xn, xt, xl, xm, xq, xc.
- QT12 thêm th (Kế hoạch hủy yêu cầu mua khi chưa chọn báo giá); QT15 bỏ "Thủ kho yêu cầu xuất cho kho khác"; QT22 thêm nhánh yêu cầu bổ sung (như QT23); QT10 k3 ghi ở Kế toán › Công nợ KH. (Bỏ báo giá 04/11 — xem QT12.)

Sửa 20/10 (đợt 2 — hướng mất kết nối không giới hạn; chốt 10 câu sau bản đánh giá offline; thay các chỗ cũ nói khác):
- Nguyên tắc chủ dữ liệu: máy chủ nhà máy là chủ "sự thật vật lý" của nhà máy mình — tồn & trạng thái lô của 3 kho, bao / thùng, chứng từ kho (QT14–QT18, QT04), QC (QT22–QT24), mẻ / silo / chiết rót (QT20, QT21), phiên đăng nhập; cloud giữ bản đồng bộ. Cloud là chủ "ý định & quyết định": danh mục, tài khoản, đơn, PO, lệnh SX, đợt giao, hồ sơ thu hồi, truy xuất, kế toán — sao xuống nhà máy bản chỉ đọc phần cần cho nghiệp vụ tại chỗ (PO đã duyệt, đợt giao đã chốt lịch, yêu cầu xuất trả, đề nghị chuyển kho, hồ sơ thu hồi, phiếu chuyển từ nhà máy khác). Mọi việc cloud muốn làm trên dữ liệu nhà máy chủ đi qua một KÊNH LỆNH TỪ TRUNG TÂM có xác nhận / từ chối (QT19 kl): phát lệnh, hủy lệnh, kết thúc sớm, hủy mẻ + mẻ bù, khóa / mở khóa lô (thu hồi, khoanh vùng), khóa tài khoản, silo bảo trì, đổi loại khu, giảm KL mẻ tối đa, yêu cầu xuất kho, đề nghị chuyển kho. Mỗi bản ghi chỉ một nơi được ghi; nơi kia ghi bản ghi của mình, cloud "chiếu" lại (vd nhà máy nhận chuyển kho ghi phiếu nhập → cloud chiếu thành SL đã nhận trên phiếu chuyển của nhà máy xuất).
- Khi nhà máy mất mạng (không giới hạn thời gian): màn Kho (6), Chất lượng (4), Theo dõi mẻ, Lệnh SX (bản tại nhà máy: xem, chuẩn bị NVL), Việc cần làm, Đăng nhập, PC xưởng chạy đủ tại máy chủ nhà máy; Thủ kho trưởng duyệt mọi phiếu tại chỗ; QC gửi yêu cầu / kiểm / kết luận / ký chứng nhận / mẫu lưu tại chỗ; lô hết hạn do máy chủ nhà máy tự KHÓA. Dừng: tạo / hủy / kết thúc sớm lệnh (xếp chờ ở cloud), mở hồ sơ thu hồi, nhận chuyển kho từ nhà máy khác khi phiếu chưa tới, vị trí kệ mới, mọi việc văn phòng. Kế hoạch ở văn phòng trung tâm — lệnh chỉ tạo trên cloud; nhà máy mất mạng lâu thì chạy hết lệnh đã nhận rồi chờ. Bỏ "ngoại tuyến tối đa 8 giờ".
- Thu hồi / khoanh vùng khi nhà máy mất mạng: lệnh khóa lô nằm "chờ nhà máy áp dụng", hồ sơ thu hồi hiện rõ từng nhà máy để QC trưởng gọi điện; khi có mạng nhà máy khóa phần còn, phần đã dùng tự khóa hàng sinh ra (QT19 kz), phần đã giao vào danh sách khách thu hồi. Sau 10/11: QC trưởng tại nhà máy có thao tác "khóa cả lô — khoanh vùng" tại chỗ, gắn hồ sơ khi có mạng (chi tiết: đợt 3).
- Hủy mẻ sự cố: Kế hoạch bấm trên cloud cả khi nhà máy mất mạng → lệnh Chờ gửi; nhà máy chỉ áp dụng khi mẻ vẫn Dừng sự cố (không còn chặn nút). Lô nghi lỗi lúc mất mạng: gửi yêu cầu kiểm và QC kiểm ngay tại nhà máy (bỏ "xử lý bằng tay"). Đề nghị chuyển kho tổng → kho điều phối hệ thống tự lập mà Kế hoạch chưa gửi khi nhà máy mất mạng: Thủ kho trưởng kho tổng xác nhận thẳng, Kế hoạch nhận thông báo sau (QT16 kq). Chuyển kho 2 nhà máy mà bên nhận chưa có phiếu: hàng để bãi chờ (sau 10/11: nhận không phiếu). Văn phòng xem tồn của nhà máy đang mất mạng: số cũ kèm "tính đến HH:MM", vẫn cho tạo lệnh / nhận đơn.
- Bỏ bước Kế hoạch xác nhận lệnh xuống PC xưởng (QT20 d1 thành bước hệ thống tại máy chủ nhà máy). Mã chứng từ sinh tại nhà máy có tiền tố nhà máy (biểu mẫu Mã QR / định dạng mã). Bỏ "bản sao trạng thái lô" ở máy chủ nhà máy (nhà máy có tồn thật). Bỏ màn theo dõi chỉ xem và màn kho riêng tại nhà máy — dùng đúng màn Lệnh SX / Theo dõi mẻ / Kho chạy tại nhà máy, thêm khối tình trạng kết nối. Mục "Phân hệ & màn hình" thêm bảng "Nơi chạy từng màn". Sửa QT01, QT09, QT12, QT13, QT14–QT18, QT19 (vẽ lại đoạn ngoại tuyến, thêm nhánh cloud mất / khởi tạo lại máy chủ nhà máy), QT20–QT24, QT26, Vòng đời lô hàng, bảng quyền (thêm QT16 kq, bỏ QT20 d1), Màn × chức năng, Tham số.

Sửa 20/10 (đợt 3 — chốt 3 câu còn mở sau đợt 2):
- Máy chủ nhà máy chỉ giữ đơn của nhà máy mình và khách của các đơn ấy: mã / tên khách, địa chỉ giao, mã đơn, SP, quy cách, SL, ngày giao, trạng thái — không có giá, tiền, MST, người liên hệ, SĐT, hạn mức, công nợ, hóa đơn. Phiếu xuất bán in tại nhà máy vẫn có tên khách, địa chỉ giao khi mất mạng.
- Sau 10/11 — QC trưởng nhà máy khóa cả lô tại chỗ khi mất mạng: chọn lý do + ghi chú + ảnh, không cần phiếu giấy; chặn xuất kho, nạp silo ngay. Không mở tại chỗ; có mạng thì QC trưởng trên cloud gắn vào hồ sơ thu hồi / khoanh vùng hoặc mở khóa nhầm có lý do.
- Một mã SP = 1 quy cách × số lon / thùng (giữ như sơ đồ dữ liệu); màn Danh mục SP nhóm theo thương hiệu × dòng × hạng.
- Mã công thức đổi sang 4 số: `CT-{loại}-{4 số}` (vd `CT-HH-0001`) — QT03 y2, biểu mẫu Danh mục, định dạng mã.
- Sau 10/11 — nhận chuyển kho chưa có phiếu: quét QR số phiếu trên giấy (gõ tay chỉ nhận đúng mẫu PC-…); lô đã biết, đang đạt thì dùng ngay, lô lạ vào khu chờ đối chiếu. Có mạng: khớp tự đóng; sai số phiếu → Thủ kho trưởng nhà máy nhận chọn lại phiếu; lệch hàng → biên bản chênh lệch, Thủ kho trưởng hai nhà máy xác nhận, Kế toán duyệt cuối.

Sửa 23/10 (màn Đơn hàng, Khách hàng, popup chi tiết danh mục — chốt sau rà soát mockup; thay các chỗ cũ nói khác):
- Đơn hàng **bỏ NV tiếp thị** (không nhập, không hiện ở chi tiết, không tìm theo NV). Người tạo đơn vẫn ghi ở nhật ký đơn.
- Hồ sơ khách hàng thêm **thông tin thanh toán mặc định**: hình thức (Trả đủ trước SX / Cọc + trả nốt trước giao / Mua nợ), phương thức (Chuyển khoản / Tiền mặt), số ngày nợ (Mua nợ), tỷ lệ cọc % (Cọc + trả nốt), tài khoản ngân hàng của khách (ngân hàng · chi nhánh, số tài khoản, chủ tài khoản — khi Chuyển khoản), email nhận hóa đơn điện tử. Tách "phương thức thanh toán" cũ (Tiền mặt / Chuyển khoản / Mua nợ) thành 2 trường hình thức và phương thức.
- QT05 d2: chọn khách thì đơn **điền sẵn** hình thức, phương thức, số ngày nợ và tiền cọc (= tỷ lệ cọc của khách × tổng đơn); Sales sửa được theo từng đơn. Đơn Chuyển khoản hiện tài khoản của khách (đối chiếu tiền về, hoàn tiền) và nội dung chuyển khoản = `{mã đơn} {mã KH}` để Kế toán cấn tiền về đúng đơn ở QT10.
- Tổng tiền đơn hiện theo hàng dọc: Tạm tính → VAT → Tổng cộng → Cọc / trả đủ trước SX (%) → Còn lại. Sửa đơn (QT08) hiện Bản cũ → Bản mới → Chênh lệch.
- Chi tiết đơn **bỏ mục "Kiểm công nợ"** (các bước và bảng tính hạn mức). Logic QT06 giữ nguyên; kết quả kiểm và việc đang chờ hiện ở thông báo đầu trang chi tiết đơn, số liệu hạn mức / dư nợ xem ở Công nợ khách hàng.
- Popup chi tiết danh mục (SP, các danh mục của SP, NVL) **bỏ phần tham chiếu chứng từ**: lô & phiếu chứng nhận, đơn hàng & lệnh đang mở, sản phẩm đang dùng, tồn theo kho, công thức đang dùng, đơn mua đang mở. Giữ dữ liệu gốc của mã (quy cách, bộ chỉ tiêu, công thức áp dụng của SP, NCC được duyệt của NVL). Bảng kiểm tham chiếu khi đề nghị ngừng dùng vẫn giữ.
- Form tạo / sửa kho bỏ ô "Thủ kho phụ trách" và "Thủ kho trưởng"; danh sách, chi tiết kho và màn vị trí kệ không hiện hai thông tin này nữa. Ai duyệt phiếu / quản lý vị trí kệ vẫn theo vai trò Thủ kho, Thủ kho trưởng và phạm vi kho ở Phân quyền.
- ✅ Đã chốt 24/10 (đợt 8): bỏ "NV tiếp thị" khỏi điều kiện tạo LSX — còn 8 điều kiện.

Sửa 24/10 (Giao hàng — chỉ ghi nhận; thay các chỗ cũ nói khác):
- QT09 vẽ lại: hệ thống chỉ ghi nhận giao hàng, không quản lý liên hệ khách, lịch giao, địa chỉ, xe / nhà xe. Bỏ màn Bán hàng › Giao hàng (`BAN_GIAO_HANG`) và chứng từ đợt giao; Sales làm ở Đơn hàng › tab Giao hàng.
- Xuất từng phần theo đơn: "Yêu cầu xuất" (chọn dòng, SL) → yêu cầu xuất bán (cloud, sao xuống) → 1 phiếu xuất bán. Kiểm tiền trước giao theo giá trị phần yêu cầu + cờ tạm khóa (chỉ Mua chịu) ngay lúc yêu cầu.
- Sales ghi kết quả theo từng phiếu xuất: SL khách nhận từng lô, ngày nhận, ảnh biên bản; phần không nhận → nhập kho hàng khách trả gắn phiếu xuất. Trạng thái đơn tự tính Sẵn sàng giao → Đang giao → Giao một phần / Đã giao. Công nợ Mua chịu theo từng lần ghi nhận, hạn = ngày khách nhận + N ngày.
- Hóa đơn: Kế toán thêm vào đơn, một đơn nhiều hóa đơn, không gắn phiếu xuất (QT10 t1).
- Bỏ: liên hệ khách và chờ 7 ngày, khách "mất" sau 30 ngày (bỏ trạng thái khách "mất"), xác nhận lịch / địa chỉ, ngưỡng dời ngày giao 3 ngày (ngày giao trên đơn là dự kiến, Sales sửa trực tiếp, không qua QT08), bước giao hàng của Vận chuyển (Vận chuyển chỉ còn chuyển kho giữa 2 nhà máy). Giữ chờ thu đủ 14 ngày → QT07.

Sửa 24/10 (đợt 2 — bỏ quản lý vị trí kệ; thay các chỗ cũ nói khác):
- Bỏ vị trí kệ khỏi hệ thống: không còn danh mục vị trí kệ (tạo ô, sinh mã ô, in tem QR ô, ngừng dùng ô), không gợi ý ô / quét mã ô khi nhập, không lấy hàng theo ô, bỏ thao tác dời vị trí. Danh mục còn 3 loại: NVL, SP, kho; màn Danh mục › Kho & vị trí kệ thành Danh mục › Kho (QT02 bỏ nhánh vị trí kệ, QT14 bỏ bước gợi ý ô / cất hàng quét ô).
- Tồn theo lô × kho; trạng thái lô gắn theo **từng bao / thùng** (đơn vị có mã) thay cho "lô × vị trí" — cùng lô trong cùng kho vẫn tách được bao ĐẠT / bao KHÓA. Khóa cả lô = khóa mọi bao của lô ở mọi kho. Tem mất cấp mã mới thì mã mới mang trạng thái + lý do khóa của bao cũ (QT04).
- Chuyển kho (QT16): hàng đang chuyển nằm trên phiếu chuyển, không thuộc kho nào (thay vị trí "trên xe"); nhận thiếu giữ trên phiếu, chờ tìm 7 ngày như cũ; nhận hư chỉ KHÓA các bao hư (lý do hư khi nhận), bỏ khu hàng lỗi.
- Hàng bị từ chối ở cửa kho và hàng lỗi chờ trả NCC: để riêng ngoài hệ thống, bỏ "khu chờ trả" (QT13, QT14).
- Kiểm kho (QT17): đếm theo lô trong kho, bỏ cột vị trí; cờ "đang kiểm kê" gắn trên cả kho hoặc một lô trong kho; kiểm điểm khóa đúng lô bị lệch.
- Sự cố tem: Kho · Tồn kho chọn dòng lô (thay dòng lô × ô) → danh sách bao.
- Chấp nhận: hệ thống không chỉ chỗ lấy hàng, thủ kho tự tìm; khi quét vẫn chặn sai lô, sai trạng thái, hết hạn. Bảng dữ liệu `location`, `stock_relocation` bỏ; sơ đồ dữ liệu / SQL / script sinh quyền cần cập nhật theo.

Sửa 24/10 (đợt 3 — bỏ COA và bộ chỉ tiêu QC; thay các chỗ cũ nói khác, kể cả ghi chú 15–19/10 phía trên):
- Hệ thống không còn lưu bộ chỉ tiêu & giới hạn chất lượng: bỏ bộ chỉ tiêu COA của NVL, bỏ bộ chỉ tiêu thành phẩm của SP (QT02 bỏ bước qc), không nhập số liệu kiểm nghiệm, không tự so giới hạn, không đề xuất kết luận.
- Thay bằng **file đánh giá bên ngoài** (PDF / ảnh — phiếu kiểm nghiệm của NCC hoặc đơn vị kiểm nghiệm): hệ thống chỉ lưu file, không đọc nội dung.
- QT14 NVL mua: Kho nhập số lô NCC, NSX, HSD từng lô và tải file đánh giá bên ngoài (bắt buộc, mỗi lô ít nhất 1 file). Thiếu file = thiếu chứng từ → từ chối ở cửa kho. Hệ thống chỉ còn kiểm HSD còn ≥ mức tối thiểu (mặc định 2/3 hạn dùng). Bỏ ô c3, bước lv chỉ kiểm có file + HSD.
- QT12: PO bỏ trường "yêu cầu COA"; NCC giao kèm file đánh giá bên ngoài, số lô, NSX, HSD.
- QT22 / QT23: QC lấy 2 mẫu (1 gửi kiểm nghiệm, 1 lưu QT24) → tải file đánh giá bên ngoài và chọn kết luận Đạt / Không đạt kèm ghi chú → QC trưởng duyệt. Người tải không tự duyệt.
- QT23 phiếu chứng nhận xuất xưởng: chỉ còn lô, SP, kết luận, người duyệt, ngày, đính kèm file đánh giá bên ngoài; bỏ phần chỉ tiêu / kết quả / giới hạn.
- Dữ liệu: bỏ bảng `material_spec_item`, `product_spec_item`; phiếu nhập, phiếu kiểm, phiếu chứng nhận thêm danh sách file đính kèm. Sơ đồ dữ liệu / SQL / script sinh quyền / mockup cần cập nhật theo.

Sửa 24/10 (đợt 4 — yêu cầu xuất bán, phiếu xuất bán tự lập; thay các chỗ cũ nói khác):
- Máy chủ nhà máy tự lập phiếu xuất bán khi yêu cầu xuất bán sao xuống (lô, SL y nguyên) và phiếu vào thẳng **Chờ lấy hàng** — không qua Thủ kho trưởng duyệt; Thủ kho không lập phiếu xuất bán bằng tay. Lô không còn đủ ở nhà máy → không lập phiếu, yêu cầu "Bị trả về" Sales kèm lý do; Sales hủy (bắt buộc lý do) hoặc lập yêu cầu khác (QT09 yn, dn, tr; QT15). Xuất SX, chuyển kho, trả NCC vẫn duyệt (đợt 5: xuất SX cũng bỏ duyệt).
- Một yêu cầu xuất chỉ lấy lô ở 1 nhà máy; tổng SL các yêu cầu chưa hủy của một lô ≤ SL lô gắn đơn; lô phải gắn đơn, đúng SP của dòng đơn (ràng buộc ở CSDL).
- Tách khoản trả nốt trước giao theo từng yêu cầu = giá trị phần xuất × (1 − % cọc); khoản gốc giảm tương ứng; hủy yêu cầu thì gộp lại.

Sửa 24/10 (đợt 5 — phiếu xuất SX không duyệt; thay các chỗ cũ nói khác):
- Phiếu xuất SX do thủ kho kho điều phối lập theo lệnh SX (lô FEFO hệ thống đề xuất, trừ KG đã giữ) vào thẳng **Chờ lấy hàng**, lấy hàng luôn — không qua Thủ kho trưởng duyệt. Thủ kho trưởng chỉ còn duyệt phiếu chuyển kho, trả NCC (đợt 6: bỏ nốt). Phiếu xuất SX vẫn hiện ở danh sách "Yêu cầu xuất chờ lập phiếu" (lập tay theo lệnh).

Sửa 24/10 (đợt 6 — bỏ duyệt phiếu xuất; thay các chỗ cũ nói khác):
- Bỏ hẳn bước Thủ kho trưởng duyệt phiếu xuất (QT15 d1) cho mọi loại: bán, SX, chuyển kho, trả NCC. Phiếu lập ra là Chờ lấy hàng (đợt 7: thay tên Đã duyệt); duyệt một lần ở chứng từ gốc — đơn / yêu cầu xuất bán, lệnh SX, phiếu chuyển (Thủ kho trưởng xác nhận ở QT16), yêu cầu xuất trả NCC. Kho chỉ làm theo, kiểm soát bằng quét đúng lô, đúng SL.
- Trả NCC: Mua hàng gửi yêu cầu xuất trả → Chờ duyệt xuất trả → **Trưởng BP Mua hàng** duyệt → Chờ kho xuất trả (sao xuống nhà máy); từ chối bắt buộc lý do → về Mở (QT13 dx). Người gửi không tự duyệt.
- Thủ kho trưởng vẫn duyệt các việc ghi tăng / giảm tồn không có chứng từ gốc: điều chỉnh sau kiểm kho, thất lạc khi chuyển, hủy hàng; vẫn xác nhận phiếu chuyển, duyệt phiếu nhập (đợt 7: bỏ — chỉ xác nhận chênh lệch khi nhập). Thiếu hàng / lô thay thế khi xuất không cần duyệt (hệ thống tự tìm lô theo quy tắc, bên yêu cầu quyết khi không có lô thay thế).

Sửa 24/10 (đợt 7 — trạng thái phiếu xuất, bỏ duyệt phiếu nhập; thay các chỗ cũ nói khác):
- Phiếu xuất không ai duyệt nên bỏ chữ "Đã duyệt": **Chờ lấy hàng** (vừa lập / tự lập, chưa quét) → **Đang lấy hàng** (tự chuyển khi quét bao / thùng hợp lệ đầu tiên) → Đã xuất / Xuất một phần. Chờ bên yêu cầu chỉ từ Đang lấy hàng; hủy khi Chờ lấy hàng thì hủy thẳng, khi Đang lấy hàng thì trả hàng đã lấy về kho (QT15 t4).
- Phiếu nhập không lập tay, không duyệt: hệ thống tự sinh phiếu **Chờ nhận hàng** từ chứng từ gốc — BTP khi đóng thùng xong (QT21), NVL dư khi xả bột dư (QT20), khách trả, thu hồi, chuyển kho; NVL mua: quét PO là ra phiếu điền sẵn. Kho quét nhận (**Đang nhận**); khớp SL dự kiến, không bao hư → **Đã nhập**; lệch / có bao hư → **Chờ xác nhận lệch** → Thủ kho trưởng xác nhận (nhập theo SL thực) hoặc yêu cầu đếm lại (bắt buộc lý do, về Đang nhận) (QT14 dl, d4). Tạo mã / in / dán tem tại kho chỉ còn với NVL mua; tem thùng BTP dán lúc đóng thùng (QT21 t7), kho chỉ quét tem có sẵn — tương tự bao bột dư, khách trả, thu hồi, chuyển kho (QT14 k2, k3).



Sửa 24/10 (đợt 8 — nhu cầu sản xuất theo dòng đơn; thay các chỗ cũ nói khác, kể cả ghi chú 19/10 đợt 2 về 9 điều kiện LSX):
- **Chỉ sản xuất theo đơn**: không có lệnh sản xuất tồn kho (cả lệnh HH lẫn BTP). Mọi lệnh gắn ít nhất 1 dòng đơn đã chốt.
- **Mỗi lệnh 1 mã SP** (mã SP = quy cách × số lon / thùng, chốt 20/10). Lệnh BTP không còn gộp nhiều mã SP cùng công thức; kế hoạch nhãn hiệu của lệnh là 1 mã SP. Hai mã SP dùng chung bột BTP thì chạy 2 lệnh.
- **Nhu cầu = dòng đơn × loại lệnh**: mỗi dòng đơn đã chốt (đơn Đã chốt / Đang sản xuất) cần 1 lệnh HH và 1 lệnh BTP cùng mã SP. Còn lại của dòng = SL dòng (lon) − tổng số lon phân bổ ở các lệnh chưa hủy cùng loại, cùng SP. Một lệnh gộp được nhiều dòng đơn cùng SP; một dòng tách được ra nhiều lệnh (nhập số lon ít hơn còn lại → phần dư nằm chờ lệnh sau).
- **Màn Lệnh SX thêm tab "Chờ lên lệnh"** (đứng đầu, có số đếm): dòng đơn còn số lon chưa lên lệnh, gom theo mã SP, tách Lệnh bán thành phẩm / Lệnh hỗn hợp. Mỗi nhóm hiện còn thiếu (lon, kg BTP), số dòng, hạn giao sớm nhất, hạn lên lệnh. Kế hoạch tick dòng, sửa số lon, bấm "Lên lệnh" → form tạo lệnh điền sẵn khu, SP, dòng đơn. Không tách màn riêng; danh sách lệnh và Tiến độ giữ nguyên.
- **Form tạo lệnh**: bước "Đơn hàng" (chọn đơn chính rồi tick đơn cùng SP) đổi thành bước **"Nhu cầu"**: chọn 1 mã SP còn nhu cầu → bảng dòng đơn (đơn, khách, hạn giao, đặt, đã lên lệnh, còn lại) tick + nhập số lon. Điều kiện (2) "Nhu cầu đơn hàng": mỗi dòng phân bổ > 0 và ≤ còn lại, đơn còn Đã chốt / Đang sản xuất.
- **Bỏ "NV tiếp thị"** khỏi điều kiện tạo LSX → còn 8 điều kiện. Từ chối tạo lệnh (QT19 t2) báo người tạo đơn (Sales).
- **Hạn lên lệnh** = hạn giao − 14 ngày (⚙ mặc định, cấu hình lại được). Mỗi sáng hệ thống quét dòng chưa lên lệnh đủ: quá hạn lên lệnh tô đỏ, còn ≤ 5 ngày tô vàng ở tab Chờ lên lệnh và báo Kế hoạch ở Việc cần làm (QT19 nh). Đơn chuyển Đã chốt thì báo Kế hoạch ngay (QT05 yc).
- **Hủy lệnh** (Mới tạo / Chờ phát / Đã nhận): số lon phân bổ quay lại Chờ lên lệnh. **Kết thúc sớm**: phân bổ của lệnh giảm theo tỉ lệ số mẻ thực tế, ưu tiên giữ dòng hạn giao sớm; phần thiếu quay lại Chờ lên lệnh (thay "phần thiếu tạo lệnh mới").
- **Đơn hàng** (QT05, QT07, QT08): chi tiết đơn Đã chốt / Đang sản xuất ghi tình trạng lệnh dưới tên từng sản phẩm (đủ lệnh HH + BTP / chưa có lệnh loại nào). Khung "Việc tiếp theo" có nút "Lên lệnh {mã SP}" cho dòng còn thiếu → tab Chờ lên lệnh, dòng đó chọn sẵn. Sửa đơn giảm SL dòng dưới số lon đã phân bổ, hoặc hủy đơn đã có lệnh → báo Kế hoạch; lệnh đang chạy không tự sửa (QT08 r2, QT07 h4).
- **Dữ liệu**: phân bổ ghi ở dòng kế hoạch nhãn hiệu của lệnh — `production_order_brand` thêm `sales_order_line_id` + số lon; ràng buộc tổng số lon phân bổ của một dòng đơn theo loại lệnh ≤ SL dòng (khóa dòng đơn khi tạo / sửa lệnh). `production_order.sales_order_id` chỉ còn là đơn chính (hạn giao sớm nhất) để hiển thị.

Sửa 24/10 (đợt 9 — ngưỡng hạn tối thiểu cho sản xuất, bỏ cận date; thay các chỗ cũ nói khác):
- Thêm tham số **hạn còn lại tối thiểu khi dùng cho sản xuất** (mặc định 30 ngày, cấu hình theo nhóm / mã NVL). Lô NVL / bao hỗn hợp dùng cho SX phải ĐẠT và còn ≥ ngưỡng: đề xuất lô xuất SX (QT15 y0) bỏ qua lô dưới ngưỡng; quét xuất SX (QT15 y2) và quét bao nạp silo (QT20 g2) chặn lô dưới ngưỡng; tồn khả dụng cho SX (QT12 d1, QT19 g1) chỉ tính lô đạt ngưỡng. Xả silo cho mẻ (QT20 ys) chặn khi trong nút silo có lô đã hết hạn. Lô dưới ngưỡng vẫn ĐẠT (không thêm trạng thái), vẫn chuyển kho / trả NCC / hủy được; xuất bán TP không áp ngưỡng này.
- Bỏ cảnh báo cận date: không còn 3 mức báo trước HSD, cờ CẬN DATE, bước "đẩy lô cận date lên đầu" (FEFO đã tự lấy lô gần hết hạn trước), bước Kế hoạch / Sales ưu tiên dùng / bán lô cận date (QT18 tk, dk) và quyền của bước đó. Màn "Hủy hàng" đổi tên thành "Hủy hàng". Giữ: quét HSD hằng ngày tại máy chủ nhà máy, lô đến hạn tự KHÓA (lý do hết hạn) + đề nghị hủy, nhắc Thủ kho trưởng khi lô hết hạn chưa hủy quá 30 ngày.
- Phiếu chuyển kho không có trạng thái "Trên xe": hàng đã quét xuất khỏi kho đi là phiếu Đã xuất (hàng đang chuyển nằm trên phiếu), tới kho nhận là Đã nhận / Nhận một phần.
- Còn chờ khách chốt (không đổi quy trình lúc này): hạn thành phẩm có phải ≤ hạn sớm nhất của NVL trong mẻ hay không (đề xuất mặc định: hạn TP = min(NSX + hạn chuẩn SP, hạn NVL sớm nhất), QC bật được "không phụ thuộc hạn NVL" theo SP khi có số liệu thử độ ổn định).

Sửa 24/10 (đợt 10 — phiếu xuất SX tự lập khi lệnh phát sang khu; thay các chỗ cũ nói khác):
- Máy chủ nhà máy tự lập phiếu xuất SX ngay khi lệnh được phát sang khu sản xuất (lệnh hiện trên PC C# của khu): lấy từ kho điều phối chung của nhà máy, nơi nhận = khu trong lệnh, lô FEFO (ĐẠT, hạn ≥ ngưỡng SX), trừ KG giữ chỗ → Chờ lấy hàng. Thủ kho kho điều phối chỉ lấy hàng, không lập phiếu tay; Kế hoạch không gửi / hủy yêu cầu xuất riêng (QT20 yp, QT19 y4, QT15).
- Điều kiện phát sang khu bỏ mục "kho điều phối đã xuất đủ NVL" (phiếu sinh sau khi phát); công nhân chỉ nạp silo bằng bao đã xuất cho lệnh (QT20 g2).
- Kho điều phối thiếu khi sinh phiếu → phiếu phần có, phần thiếu thành đề nghị chuyển kho tự lập (Kế hoạch gửi); hàng về → tự lập phiếu bổ sung. Lấy hàng thiếu, không có lô thay thế → phiếu tự Xuất một phần, phần thiếu thành đề nghị chuyển kho — xuất SX không qua Chờ bên yêu cầu.
- Lệnh hủy / kết thúc sớm → phiếu xuất SX Chờ lấy hàng tự hủy, Đang lấy hàng thì giao việc trả hàng về kho cho thủ kho.

Sửa 24/10 (đợt 11 — kiểm tra lại NVL trên lệnh, tự lập yêu cầu mua; thay các chỗ cũ nói khác):
- Không có bước thủ kho xác nhận "Đã soạn đủ NVL". Khi hàng chuyển về kho điều phối, Kế hoạch bấm "Kiểm tra lại" trên màn Lệnh SX: hệ thống so lại tồn kho điều phối với KG giữ chỗ, đủ thì lệnh phát được (QT19 kr → dc).
- Kho tổng cũng thiếu → hệ thống tự lập yêu cầu mua phần thiếu (nguồn lệnh SX, từng NVL, KG) và báo Mua hàng ở Việc cần làm; Kế hoạch không phải lập tay (QT19 ym, QT12). Yêu cầu mua dưới tồn tối thiểu vẫn do Kế hoạch lập.

Sửa 24/10 (đợt 12 — tạo lệnh khi thiếu NVL, tính nhu cầu mua; thay các chỗ cũ nói khác, kể cả đợt 11):
- Tồn NVL không còn là điều kiện chặn tạo lệnh. Đủ tồn khả dụng của nhà máy → giữ chỗ như cũ; thiếu → lệnh Mới tạo · Chờ NVL: KHÔNG giữ chỗ, KHÔNG phát được. Hàng về (nhập kho tổng / chuyển về kho điều phối) → Kế hoạch bấm "Kiểm tra lại" trên lệnh: đủ thì giữ chỗ, rồi theo luồng kho điều phối như cũ (QT19 dt, ym, kr). Lệnh Chờ NVL đứng đầu hàng đợi của khu sẽ chặn phát lệnh sau — Kế hoạch đổi thứ tự.
- Nhu cầu mua do hệ thống tính và gửi thẳng Mua hàng, Kế hoạch không lập tay, không xác nhận: từng NVL = tổng NVL các lệnh chưa xuất đủ (kể cả lệnh Chờ NVL) − tồn khả dụng − hàng đã đặt chưa về + phần thiếu so với tồn tối thiểu; mỗi NVL 1 yêu cầu Mở, cộng dồn / giảm theo mỗi lần tính; ngày cần = ngày dự kiến chạy sớm nhất − thời gian giao hàng. Lệnh hủy → yêu cầu chưa có báo giá tự giảm / hủy, đã có báo giá / PO thì báo Mua hàng (QT12 t1). (Bỏ báo giá 04/11 — xem QT12.)
- Danh mục: NVL thêm "thời gian giao hàng (ngày)" mặc định; dòng NCC × NVL được phép cung cấp có thể ghi đè. Trống thì dùng tham số mặc định 14 ngày (cấu hình lại được).




Sửa 26/10 (mẫu lưu — bỏ tủ / ngăn và điều kiện bảo quản; thay các chỗ cũ nói khác):
- Ghi mẫu lưu chỉ còn: lô đã lấy mẫu, số lượng mẫu, hạn lưu (gợi ý HSD + 6 tháng), ghi chú. Không chọn tủ / điều kiện bảo quản, không ghi ngăn; mẫu nằm ở kho mẫu QC của nhà máy.
- Bỏ danh mục điều kiện bảo quản phòng / tủ mẫu (tab "Điều kiện bảo quản" ở màn Mẫu lưu). Sửa trên mẫu đang lưu chỉ còn sửa hạn lưu (QT24 g1). Danh sách, chi tiết mẫu và biên bản hủy không còn cột vị trí / điều kiện.
- Điều kiện bảo quản của NVL ở danh mục NVL (QT02) giữ nguyên — không thuộc mẫu lưu.

Sửa 27/10 (cách bù NVL thiếu — Kế hoạch quyết, Mua hàng chỉ mua; thay các chỗ cũ nói khác):
- Lấp chỗ thiếu NVL bằng cách nào là việc của Kế hoạch. Ngoài mua có 2 cách: chuyển kho liên nhà máy, lùi ngày sản xuất. Mỗi cách sinh chứng từ (đề nghị chuyển kho liên nhà máy, sửa ngày lệnh). Không dùng NVL thay thế (27/10); phiếu chuyển kho đang đi được tính như hàng đang về khi hệ thống tính phần thiếu.
- Tạo / sửa lệnh SX thiếu NVL (QT19): ở bước Nguyên liệu & tồn kho, Kế hoạch chọn cách bù cho từng NVL thiếu — Mua (mặc định) / Chuyển từ nhà máy kia; phần không bù đủ tự vào Hàng đợi mua. Bột hỗn hợp sản xuất nội bộ thì lên lệnh hỗn hợp, không mua.
- Dưới tồn tối thiểu: cách bù đặt sẵn ở danh mục NVL (Mua / Chuyển từ nhà máy kia, thiếu thì mua), hệ thống tự bù theo cấu hình, không hỏi lại mỗi lần (QT02, QT12 s).
- Hàng đợi mua (QT12) chỉ còn phần Kế hoạch đã chọn bù bằng Mua. Mua hàng bỏ nút "Bỏ qua"; không mua được thì "Trả về Kế hoạch" kèm lý do (không NCC nào giao kịp, NCC hết hàng, giá vượt xa bảng giá, khác) — dòng rời hàng đợi tới khi Kế hoạch quyết. Nhu cầu bỏ trạng thái "Bỏ qua".
- Thêm màn Cân đối NVL (module Sản xuất, Kế hoạch): chỉ hiện phần thiếu chưa có cách xử lý — phát sinh sau khi lên lệnh (QC giữ / khóa lô, NCC giao trễ sau ngày cần, chuyển kho bị hủy, hao hụt vượt định mức, lệnh ưu tiên chen vào) hoặc Mua hàng trả về. Kế hoạch chọn Mua (giao lại Mua hàng) / Chuyển từ nhà máy kia / Lùi ngày sản xuất (chỉ lệnh chưa phát); kết quả ghi vào lịch sử lệnh.
- Chuyển kho liên nhà máy (sửa 27/10 chiều): không gắn cứng một nhà máy. Chọn "Chuyển kho liên nhà máy" thì hiện mọi nhà máy khác kèm tồn khả dụng; Kế hoạch nhập KG lấy từ từng nhà máy, được lấy từ nhiều nhà máy (gợi ý nhà máy còn nhiều nhất trước); mỗi nhà máy nguồn 1 đề nghị chuyển, Thủ kho nhà máy nguồn duyệt và tự chọn kho / lô. Tồn khả dụng nhà máy nguồn = lô Đạt còn hạn ≥ ngưỡng SX − giữ chỗ cho lệnh của chính nhà máy đó − tồn tối thiểu của nhà máy đó − KG đã hứa cho đề nghị chuyển khác chưa xuất. Tổng không đủ thì phần còn lại vào Hàng đợi mua. Áp dụng cả lúc tạo lệnh lẫn màn Cân đối NVL.
- Nguồn bột hỗn hợp của lệnh bán thành phẩm (QT19): chọn kho điều phối, hoặc lệnh hỗn hợp chạy trước (ngày trước chưa hoàn thành, hoặc cùng ngày thứ tự trước), hoặc "Lên lệnh hỗn hợp mới". Lệnh hỗn hợp chỉ còn dùng được = sản lượng − KG các lệnh bán thành phẩm khác đã chọn lệnh đó; dành hết thì không chọn được. Chọn lên lệnh mới: lưu lệnh bán thành phẩm (Chờ NVL) xong mở form lệnh hỗn hợp điền sẵn (cùng đơn, cùng ngày, xếp trước); lưu lệnh hỗn hợp thì nguồn của lệnh bán thành phẩm tự gắn vào lệnh đó.
- Bước Nguyên liệu & tồn kho khi tạo lệnh bỏ cột lô (lệnh giữ chỗ theo KG, lô chọn khi lập phiếu xuất); dưới "Tồn dùng được" chỉ ghi phần không tính (Chờ kiểm, Khóa, Không đạt, dưới ngưỡng hạn).
- Một trạng thái thiếu NVL (sửa 27/10 chiều): tồn cấp cho các lệnh đã giữ chỗ theo thứ tự ưu tiên (đã nhận → ưu tiên → ngày sản xuất). Khi tồn Đạt giảm sau khi giữ chỗ (QC giữ / khóa lô, xuống dưới ngưỡng hạn, lệnh ưu tiên chen vào), lệnh Mới tạo đứng sau bị hụt thì hệ thống tự chuyển về Chờ NVL, nhả giữ chỗ, sinh dòng Cân đối NVL (nguyên nhân "Tồn giảm sau khi giữ chỗ"). Bỏ trường hợp lệnh đã giữ chỗ mà báo "chưa đạt: Tồn NVL khả dụng". Dòng trạng thái lệnh Chờ NVL ghi rõ từng NVL đang chờ gì: chờ Kế hoạch xử lý ở Cân đối NVL / đang mua / đang chuyển từ nhà máy X / chờ bột hỗn hợp.
- Duyệt chuyển kho liên nhà máy (QT16, sửa 27/10 chiều): giữ bước "Thủ kho trưởng xác nhận" — với chuyển khác nhà máy là Thủ kho trưởng nhà máy nguồn; không thêm cấp duyệt (tồn khả dụng đã trừ giữ chỗ, tồn tối thiểu, đã hứa của nhà máy nguồn). Gửi đề nghị là giữ số KG ở nhà máy nguồn tới khi xác nhận / hủy. Từ chối (bắt buộc lý do) → nhả KG, phần đó thành dòng Cân đối NVL "Chuyển kho bị từ chối" để Kế hoạch chọn lại; duyệt một phần → phần thiếu như từ chối; quá 24 giờ (mặc định, cấu hình được) chưa xác nhận → nhắc Thủ kho trưởng nhà máy nguồn và thành dòng "Chuyển kho chưa được xác nhận" (Kế hoạch chọn tiếp tục chờ, hoặc đổi cách — khi đó đề nghị tự hủy); Kế hoạch hủy đề nghị → dòng "Chuyển kho bị hủy". Lệch khi xuất / nhận đi theo luồng chênh lệch sẵn có của QT16, phần thiếu cũng về Cân đối NVL.
- Nguồn tạo nhu cầu NVL: lệnh SX, dưới tồn tối thiểu, Kế hoạch lập tay (dự báo, mẫu thử, R&D, dự phòng NVL giao lâu). Chưa có: nhà máy kia xin chuyển kho làm nhà máy mình thiếu — để ngỏ.

Sửa 28/10 (bỏ vai trò Trưởng bộ phận, bỏ rà soát quyền hằng quý; thay các chỗ cũ nói khác):
- Bỏ vai trò **Trưởng bộ phận** (vai trò cộng thêm). Còn 18 vai trò. Việc của vai trò này chuyển như dưới; không còn khái niệm "bộ phận mình" trong phân quyền (`app_user.department` chỉ để hiển thị).
- **Bỏ rà soát quyền hằng quý** (QT01 r1 phần hằng quý, r4, hr, r2, r3, rd, r5, r6; bảng `access_review`, `access_review_line`; tham số chu kỳ rà soát và ngưỡng gợi ý 60 ngày). Giữ tự khóa tài khoản không đăng nhập quá 90 ngày, đặt ngày khóa khi nghỉ việc, ủy quyền tạm có hạn. Bỏ luôn câu hỏi "ai quyết dòng rà soát của chính Trưởng BP" và "ngưỡng gợi ý 60 ngày".
- **Ngừng dùng mã NVL / SP / 4 danh mục của SP (QT02):** bên đề xuất Mua hàng → Trưởng BP Mua hàng duyệt; bên Kho → Thủ kho trưởng duyệt; bên QC → QC trưởng duyệt (vẫn hiện trong Việc cần làm, người gửi không tự duyệt). **Bên Kế hoạch tự ngừng trực tiếp** (QT02 tk), ghi lý do, không qua duyệt — hệ thống vẫn kiểm tham chiếu trước (y3), vẫn lưu 1 dòng đề nghị ở trạng thái NGỪNG TRỰC TIẾP để còn dấu vết.
- Báo trước ngày khóa tài khoản (QT01 ny) chỉ còn báo HR.
- Vai trò ủy quyền tạm được: Giám đốc, Kế toán trưởng, Thủ kho trưởng, Trưởng BP Mua hàng, QC trưởng, Kế hoạch.

## Tổng hợp lỗ hổng chính
1. Số lô NCC, NSX, HSD, file đánh giá bên ngoài: đã bổ sung ở QT14 (sửa 24/10 đợt 3 — bỏ COA và bộ chỉ tiêu: file bắt buộc, hệ thống chỉ lưu; chỉ kiểm HSD khi nhận); HSD tối thiểu khi nhận mặc định ≥ 2/3 hạn dùng (cấu hình lại được).
2. QC khi nhập kho (chốt 16/10): NVL mua và nguyên liệu hỗn hợp không QC, vào kho là ĐẠT (NVL dựa vào file đánh giá bên ngoài tải ở QT14; QT22 chỉ chạy khi NVL có vấn đề, không kiểm định kỳ). BTP (thùng sau chiết rót) vào kho BTP ở CHỜ KIỂM, QC thành phẩm (QT23) đạt thì đổi thành TP mới giao. Không còn bộ chỉ tiêu NVL / TP (24/10 đợt 3).
3. Xuất kho: đã có FEFO cho NVL và BTP / bao HH sang khu khác, xuất bán theo lô của đơn; kiểm lô mỗi lần quét theo quy tắc trạng thái của từng loại xuất (QT15).
4. Trạng thái lô: đã chuẩn hóa ở mục "Vòng đời lô hàng" (chốt 16/10) — 5 trạng thái CHỜ KIỂM / ĐẠT / KHÔNG ĐẠT / KHÓA / HỦY, gắn theo từng bao / thùng (sửa 24/10, thay lô × vị trí), KHÓA luôn kèm lý do khóa; bỏ ĐANG CHUYỂN (hàng đang chuyển nằm trên phiếu chuyển).
5. Liên kết lô qua từng bước: lô NVL → silo → mẻ → lô TP → lon → thùng → phiếu xuất → khách (sửa 19/10 đợt 3: silo nạp nhiều mẻ là 1 nút riêng của lệnh, liên kết theo thời điểm nạp / xả). Chốt 16/10: là BẮT BUỘC — mỗi bước ghi liên kết ngay lúc quét, không ghi được thì chặn thao tác (QT20 bao → silo → mẻ, mẻ → bao HH; QT21 mẻ → nhãn hiệu / lô → thùng; QT16 phiếu chuyển; QT09 thùng → khách). QT25 / QT26 dựa hoàn toàn vào chuỗi này. Đã vẽ vào QT20, QT21 (17/10).
6. Chiết rót (sửa 17/10): một mẻ nhiều nhãn hiệu cùng công thức, mỗi nhãn hiệu một lô in sẵn trên bao bì lon; chỉ quét lon đầu của từng nhãn hiệu, sau đó đếm; đóng thùng không quét lon, thùng gắn với nhãn hiệu / lô theo bộ đếm. Cân từng lon sau đậy nắp, loại lon lệch. Lấy mẫu (chốt 16/10): QC lấy mẫu từng lô sau khi thùng đã nhập kho BTP.
7. Đổ nhầm (sửa 17/10): hệ thống chặn bao sai công thức / lô chưa ĐẠT / hết hạn ngay khi quét, chỉ mở đúng silo — bỏ nhánh "đổ đúng chưa" và hủy mẻ ở QT20. Sự cố dừng máy ghi vào hồ sơ mẻ. Hủy mẻ do sự cố (chốt 17/10): Kế hoạch quyết hủy, bột hỏng đi hủy hàng, thêm 1 mẻ bù vào lệnh đang chạy.
8. Phân quyền (sửa 04/11: màn Vai trò × quyền sửa được; thêm vai trò Thủ kho điều phối — 19 vai trò; xóa được tài khoản chưa từng dùng): đã bổ sung vòng đời tài khoản ở QT01 (HR gán vai trò trực tiếp, không duyệt, không bàn giao; đặt ngày khóa khi nghỉ việc, hệ thống tự khóa; tự khóa khi không dùng) và bảng Vai trò × Chức năng (chốt 17/10, mục riêng). Đã chốt: công nhân dùng tài khoản riêng, gắn khu vực làm việc; mặc định 90 ngày không đăng nhập thì khóa, báo trước ngày khóa 3 ngày (cấu hình lại được; bỏ rà soát hằng quý 28/10). Đã chốt 17/10 đủ 14 câu hỏi về vai trò (19 vai trò — 18 từ 28/10, Admin toàn quyền — sửa 20/10: Admin chỉ quản trị và xem mọi màn, ủy quyền tạm có ngày hết hạn).
9. Đơn hàng: tách đầu đơn + dòng hàng; chốt ngưỡng duyệt GĐ/KTT. Hạn mức (chốt 16/10): luôn vĩnh viễn, không có hạn mức tạm.
10. Mua hàng: PO có duyệt (bỏ báo giá 04/11 — Mua hàng nhập đơn giá ở Hàng đợi mua; kiểm COA & HSD của NCC trước khi PO đi duyệt 30/10), theo dõi PO nhận một phần (QT12); nhánh NCC không chấp nhận trả hàng (QT13); duyệt NCC ở QT11 (bỏ bước QC đánh giá mẫu 17/10); bỏ đánh giá lại định kỳ (chốt 16/10). Đã chốt: chỉ Trưởng BP Mua hàng duyệt NCC; PO trên 100 triệu cần GĐ duyệt (mặc định, cấu hình lại được); tranh chấp với NCC (kể cả kiểm nghiệm bên thứ 3) nhà máy tự xử lý ngoài hệ thống, không có trong quy trình.
11. Thu hồi (sửa 16/10): bỏ QT Khiếu nại; QT26 Thu hồi có báo cơ quan bắt buộc, khoanh vùng, nhập kho hàng thu hồi giữ KHÓA, % thu hồi, CAPA; lô thu hồi chỉ hủy, không tái chế. Đã chốt: GĐ ký quyết định thu hồi. Mức nguy hại nào phải thu hồi do nhà máy tự quyết, hệ thống chỉ ghi nhận. QT14 đã có loại nhập "hàng thu hồi" (lô giữ KHÓA).
12. Bản gốc: 65 mũi tên lơ lửng, nhãn yes/no rời, 3 quyết định 1 nhánh, ~13 ô cụt, Nhận đơn/Vượt mức vẽ trùng 2–3 bản.
13. Giao hàng (sửa 24/10): hệ thống chỉ ghi nhận, không quản lý việc giao (liên hệ khách, lịch, địa chỉ, xe làm ngoài hệ thống). Bỏ màn và chứng từ đợt giao: Sales yêu cầu xuất từng phần từ đơn, mỗi lần 1 phiếu xuất bán; ghi kết quả (SL khách nhận từng lô, ảnh biên bản) trên đơn. Giữ: kiểm tiền trước giao theo giá trị phần xuất, cờ tạm khóa chỉ chặn đơn Mua chịu, chờ thu đủ 14 ngày → hủy đơn (giữ toàn bộ cọc, cấu hình lại được). Hóa đơn: một đơn nhiều hóa đơn, gắn phiếu xuất (04/11). Bỏ chờ liên hệ 7 ngày, khách "mất" 30 ngày, dời ngày giao 3 ngày.
14. Kế toán (chốt 19/10): hệ thống chỉ ghi nhận tiền và công nợ (QT10 "Ghi nhận thu chi & công nợ"), không hạch toán (sửa 04/11: MES lập và in hóa đơn bán hàng gắn phiếu xuất), không duyệt phiếu chi, không xóa nợ; chỉ tự động tính dư nợ / nợ quá hạn, bật / tắt cờ tạm khóa, nhắc nợ trong hệ thống. Còn câu hỏi về thứ tự cấn tiền, tiền về thừa, ghi kết quả nợ quá 90 ngày (cuối mục Vai trò × Chức năng).
15. Danh mục (chốt 19/10; sửa 04/11 theo mockup: SP mô hình mới — bỏ 4 danh mục phụ, thêm Đơn vị và Hồ sơ pháp lý chung là màn Danh mục, Công thức và Khu vực làm việc vào menu Danh mục, nhiều kho điều phối mỗi nhà máy, xóa được bản ghi chưa dùng): còn 3 loại NVL, SP, kho (bỏ vị trí kệ 24/10; đợt 4: SP có thêm 4 danh mục phụ — dòng SP, quy cách đóng gói, hạng, thương hiệu — ở Danh mục › Sản phẩm; NCC, kho, nhà máy có màn trong Danh mục); bỏ thiết bị đo; thiết bị SX và đơn vị tính nạp khi triển khai, không có màn quản lý riêng — trừ silo (sửa 19/10 đợt 2): dàn silo của khu HH / BTP do Admin cấu hình trong khu vực làm việc. Màn hình theo phân hệ ở mục "Phân hệ & màn hình"; không còn máy quét riêng, thao tác quét nằm trong màn Kho / PC xưởng.
16. Lệnh SX (chốt 19/10 đợt 2; sửa 04/11: có lệnh sản xuất tồn kho, lệnh BTP cần hồ sơ công bố + mẫu nhãn đã duyệt, Cân đối NVL, hủy lệnh khi nhà máy mất mạng bị chặn): lệnh thuộc 1 khu, loại lệnh theo khu, khối lượng mẻ ≤ mức tối đa của khu; phương án dàn silo chốt khi tạo, kiểm lại khi phát; hàng đợi phát lệnh riêng từng khu; trạng thái Mới tạo / Chờ phát / Đã nhận / Đang chạy / Hoàn thành / Đã hủy, không Nháp, không xóa (QT19). Đợt 3: chỉ sửa lệnh Mới tạo; lệnh đã phát chỉ hủy (nhà máy xác nhận) hoặc kết thúc sớm khi đang chạy; silo nạp nhiều mẻ, bột dư cuối lệnh về kho điều phối.
17. Mất kết nối (chốt 20/10 đợt 2): máy chủ nhà máy là chủ tồn, trạng thái lô, chứng từ kho, QC, mẻ của nhà máy mình; Kho, Chất lượng, Theo dõi mẻ, Lệnh SX (bản tại nhà máy), PC xưởng chạy đủ khi mất mạng, không giới hạn thời gian. Cloud chủ danh mục, đơn, PO, lệnh, thu hồi; tác động lên nhà máy qua kênh lệnh từ trung tâm có xác nhận / từ chối (QT19 kl). Kế hoạch ở văn phòng, lệnh chỉ tạo trên cloud. Xung đột chỉ còn lệnh khóa lô tới muộn, lô HỦY bị dùng, tồn âm (QT19 kx).

## Vòng đời lô hàng

Một chỗ duy nhất quy định trạng thái lô cho mọi QT (lập 16/10, chốt 18 câu hỏi cùng ngày). Trạng thái gắn theo **từng bao / thùng** (đơn vị có mã) — sửa 24/10, thay cho "lô × vị trí" khi bỏ vị trí kệ: cùng một mã lô, kể cả trong cùng một kho, có thể vừa có bao ĐẠT vừa có bao KHÓA. Tồn xem theo lô × kho, tách số lượng theo trạng thái. "Khóa cả lô" là khóa mọi bao của lô ở mọi kho, kể cả bao nhập lại về sau. "Còn hạn" không phải trạng thái: hệ thống tính từ hạn dùng, đến hạn thì tự chuyển sang KHÓA lý do "hết hạn" (QT18). Lô hết tồn không có trạng thái riêng — màn hình hiện "đã hết" khi tồn bằng 0.

Nơi giữ trạng thái (chốt 20/10 đợt 2): trạng thái từng phần lô do máy chủ nhà máy đang giữ phần đó làm chủ (QC, QC trưởng, Thủ kho trưởng, quét HSD đều tại nhà máy); cloud giữ bản đồng bộ. Thu hồi / khoanh vùng (QT26) và khóa cả lô là LỆNH từ trung tâm tới từng nhà máy, có trạng thái "chờ nhà máy áp dụng"; hết hạn do máy chủ nhà máy tự khóa. Một lô có phần ở 2 nhà máy thì mỗi nhà máy chủ phần của mình, cloud ghép.

### Danh sách trạng thái

| Trạng thái | Nghĩa · vào từ đâu | Xuất SX | Xuất bán | Chuyển kho | Giao | Trả NCC | Truy xuất |
|---|---|---|---|---|---|---|---|
| CHỜ KIỂM | Chờ QC kết luận. BTP mới nhập kho (QT14, QT21); lô đang QC (QT22, QT23). Không tính tồn dùng được | Không | Không | Có (giữ trạng thái) | Không | Không | Có |
| ĐẠT | Dùng bình thường. Nguyên liệu mua (đủ file đánh giá bên ngoài, HSD đạt) khi nhập (QT14); nguyên liệu hỗn hợp ra khỏi mẻ (QT20); BTP QC đạt thì đổi thành TP (QT23) | Có (nguyên liệu, nguyên liệu hỗn hợp; FEFO) | Có (chỉ TP, đúng lô của đơn) | Có | Có (TP, kèm phiếu chứng nhận chất lượng đã được QC trưởng ký — 04/11) | Không | Có |
| KHÔNG ĐẠT | QC kết luận không đạt (QT22, QT23). Nguyên liệu: trả NCC hoặc hủy; QC trưởng có thể mở lại khi nhà máy tự kiểm nghiệm ngoài thấy đạt. BTP / TP: chỉ hủy | Không | Không | Có (giữ trạng thái) | Không | Có (nguyên liệu) | Có |
| KHÓA | Chặn dùng / bán / giao. Luôn đi kèm **lý do khóa** — lý do quyết định lối ra (bảng dưới) | Không | Không | Có (giữ trạng thái, lý do) | Không | Có (lý do hàng hư chờ trả NCC) | Có |
| HỦY | Đã hủy, trạng thái cuối, không mở lại. Hủy hàng (QT18), phần thất lạc khi chuyển kho (QT16) | Không | Không | Không | Không | Không | Có (giữ hồ sơ, không xóa) |

Chặn kiểm ở QT15 theo loại xuất: xuất bán chỉ lấy phần ĐẠT, còn hạn; xuất SX chỉ lấy phần ĐẠT có hạn còn ≥ ngưỡng tối thiểu cho SX (mặc định 30 ngày — 24/10 đợt 9); xuất chuyển kho lấy đúng lô trên phiếu, mọi trạng thái trừ HỦY; xuất trả NCC lấy đúng lô trên phiếu trả, KHÓA hoặc KHÔNG ĐẠT. Mọi lần quét đều chặn nếu kho hoặc lô đang có cờ "đang kiểm kê". Tồn dùng được = các bao ĐẠT, còn hạn, nằm trong kho (không tính hàng đang chuyển trên phiếu chuyển) − KG đã giữ chỗ.

### Loại lô

| Loại | Là gì | Trạng thái khi sinh ra | QC |
|---|---|---|---|
| Nguyên liệu mua | Bột, phụ gia, bao bì | ĐẠT khi nhập kho (QT14) | Chỉ khi lô có vấn đề (QT22); không kiểm khi nhập, không kiểm định kỳ |
| Nguyên liệu hỗn hợp | Bao hỗn hợp từ mẻ khu hỗn hợp | ĐẠT khi ra khỏi mẻ (QT20) | Không |
| BTP | Thùng lon đã chiết rót, chưa QC | CHỜ KIỂM khi nhập kho BTP (QT14, QT21) | Bắt buộc: QC lấy mẫu sau khi nhập kho BTP (QT23) |
| TP | BTP đã QC đạt — cùng mã lô, chỉ đổi loại | ĐẠT (QT23) | QC thành phẩm là chốt chặn cuối: TP đã đạt thì coi như đạt, kể cả khi sau đó phát hiện nguyên liệu lỗi |

### Lý do khóa

| Lý do khóa | Phạm vi | Áp cho | Lối ra được phép |
|---|---|---|---|
| Hàng khách trả | Riêng phần đó | TP | QC thành phẩm kiểm lại (QT23) → ĐẠT / KHÔNG ĐẠT |
| Hư khi nhận chuyển kho | Riêng phần đó | Mọi loại | Thủ kho trưởng chọn: gửi QC (nguyên liệu → QT22, BTP / TP → QT23) hoặc Hủy hàng (QT18) |
| Hàng hư, chờ trả NCC | Riêng phần đó | Nguyên liệu mua | Xuất "trả NCC" (QT15) hoặc Hủy hàng |
| Tìm lại sau thất lạc / điều chỉnh hủy nhầm | Riêng phần đó | Mọi loại | QC kiểm → đạt thì mở |
| Khoanh vùng (nghi lỗi, chưa quyết thu hồi — chỉ trong hồ sơ thu hồi QT26; lô nghi lỗi gửi QC ngoài thu hồi thì CHỜ KIỂM, không KHÓA — QT22) | Cả lô | Mọi loại | QC kiểm (QT23 / QT22) → đạt thì mở |
| Xung đột khi mất kết nối | Cả lô | Nguyên liệu hỗn hợp, BTP, TP | QC kiểm → đạt thì mở; lô gốc khóa vì thu hồi thì vào hồ sơ thu hồi |
| Chờ hủy (kho phát hiện lỗi, đã tạo phiếu hủy) | Phần trên phiếu | Mọi loại | Hủy hàng; Thủ kho trưởng từ chối thì: không lỗi → về trạng thái trước, còn nghi ngờ → gửi QC (lý do đổi thành khoanh vùng) |
| Thu hồi (đã quyết thu hồi, hàng thu hồi nhập về) | Cả lô | Mọi loại | Chỉ Hủy hàng |
| Hết hạn dùng | Cả lô | Mọi loại | Chỉ Hủy hàng (Thủ kho trưởng chỉ được dời ngày hủy) |

Lý do "chỉ Hủy hàng" thì hệ thống không cho gửi yêu cầu QC. Một phần lô có 2 lý do cùng lúc thì lấy lý do chặt hơn. Khóa cả lô áp lên cả phần nhập lại sau (vd nguyên liệu dư trả về); khóa riêng phần thì không lan.

### Bảng chuyển trạng thái

| Từ | Sang | QT + bước | Ai | Điều kiện |
|---|---|---|---|---|
| (lô mới) | ĐẠT | QT14 y2 | Hệ thống, khi phiếu nhập Đã nhập (lệch thì sau khi Thủ kho trưởng xác nhận, d4) | Nguyên liệu mua có file đánh giá bên ngoài, HSD đạt (lv, ld) |
| (lô mới) | ĐẠT | QT20 h9 | Hệ thống | Nguyên liệu hỗn hợp: bao vừa dán mã, không QC |
| (lô mới) | CHỜ KIỂM | QT14 y2 · QT21 g3 | Hệ thống | BTP (thùng sau chiết rót) nhập kho BTP, chờ QC thành phẩm |
| (lô mới) | KHÓA | QT14 y2 | Hệ thống | Hàng khách trả (lý do khách trả, từ QT09 r4); hàng thu hồi (lý do thu hồi, từ QT26 r2) |
| (lô mới) | KHÓA | QT20 ky | Hệ thống, sau Kế hoạch quyết hủy mẻ (kh) | Bột hỏng của mẻ hủy do sự cố: lý do chờ hủy, tự tạo phiếu hủy |
| (lô mới) | (theo lô gốc) | QT14 y2 | Hệ thống | Nguyên liệu dư trả về: không có khóa cả lô và còn hạn → ĐẠT; có khóa cả lô → cùng trạng thái và lý do (thu hồi thì thêm vào hồ sơ thu hồi); hết hạn → KHÓA hết hạn; lô gốc đã HỦY hết → KHÓA chờ hủy + tự tạo phiếu hủy |
| ĐẠT | CHỜ KIỂM | QT22 y1 | Kho / SX gửi yêu cầu (t1), hệ thống chặn ngay | Lô nguyên liệu nghi lỗi |
| KHÓA | CHỜ KIỂM | QT22 y1 · QT23 y1 | Kho / SX gửi yêu cầu (t1) | Chỉ lô có lý do khóa cho phép QC (khách trả, hư khi nhận, khoanh vùng, xung đột, tìm lại) |
| CHỜ KIỂM | ĐẠT | QT22 d2 · QT23 d2 | QC nhập số liệu, QC trưởng duyệt kết luận | Đạt. BTP đạt → đổi thành TP, sinh phiếu chứng nhận Chờ ký; QC trưởng ký riêng (QT23 gk — 04/11), lô TP chỉ giao được khi phiếu Đã ký; mọi lô TP của đơn ĐẠT và đã ký → gọi QT09 |
| CHỜ KIỂM | KHÔNG ĐẠT | QT22 d2 · QT23 d2 | QC nhập số liệu, QC trưởng duyệt kết luận | Không đạt. Nguyên liệu → chỉ xử lý phần còn trong kho (QT13 / QT18); BTP / TP → Hủy hàng; TP đã giao một phần (khoanh vùng) → hồ sơ thu hồi quay lại bước GĐ quyết định |
| CHỜ KIỂM | ĐẠT | QT22 yt | QC trưởng từ chối yêu cầu kiểm, bắt buộc lý do | Trước khi gửi là ĐẠT (nguyên liệu nghi lỗi): QC trưởng xác nhận không cần kiểm |
| CHỜ KIỂM | KHÓA | QT22 yt · QT23 yt | QC trưởng từ chối yêu cầu kiểm, bắt buộc lý do | Trước khi gửi là KHÓA: về KHÓA, giữ lý do cũ. BTP mới nhập không được từ chối, chỉ "yêu cầu bổ sung" |
| KHÔNG ĐẠT | ĐẠT | QT22 ym | QC trưởng, thao tác tay | Chỉ lô nguyên liệu; bắt buộc lý do + file (nhà máy tự kiểm nghiệm ngoài thấy đạt); chặn nếu lô đã hết hạn |
| ĐẠT | KHÓA | QT13 y1 | Hệ thống | Hàng hư phát hiện sau khi nhập, mở phiếu trả NCC (lý do hàng hư chờ trả NCC). Lô KHÔNG ĐẠT giữ nguyên; hàng bị từ chối ở cửa kho không tạo lô |
| ĐẠT | KHÓA | QT16 t4 | Kho nhận quét bao hư, chỉ các bao đó đổi trạng thái | Hư khi nhận chuyển kho (ảnh, lý do) |
| ĐẠT | KHÓA | QT18 t2 | Hệ thống, khi kho tạo phiếu hủy | Lý do chờ hủy |
| KHÓA | ĐẠT | QT18 xr | Thủ kho trưởng từ chối phiếu hủy, bắt buộc lý do | Lô chờ hủy, kiểm lại thấy không lỗi → về trạng thái trước |
| ĐẠT / CHỜ KIỂM | KHÓA | QT18 yc | Hệ thống (quét hạn dùng hằng ngày) | Đến hạn dùng (lý do hết hạn). Đang CHỜ KIỂM thì tự hủy yêu cầu QC đang mở. Lô KHÔNG ĐẠT giữ nguyên, chỉ ghi chú "đã hết hạn" |
| ĐẠT / CHỜ KIỂM | KHÓA | QT26 y1 · y2 · yv | Hệ thống | Lô nghi lỗi và lô liên quan (lý do khoanh vùng); GĐ quyết thu hồi → đổi lý do thành thu hồi |
| ĐẠT / CHỜ KIỂM | KHÓA | QT19 kz | Hệ thống, khi đồng bộ lại | Lệnh khóa lô (thu hồi / khoanh vùng) tới sau khi nhà máy đã nạp silo phần lô đó lúc mất kết nối, hoặc lô HỦY bị dùng; lô sinh ra theo chuỗi liên kết → KHÓA lý do thu hồi (nếu lệnh là thu hồi) hoặc xung đột |
| ĐẠT / CHỜ KIỂM / KHÓA / KHÔNG ĐẠT | HỦY | QT18 y1 | Kho thực hiện hủy (t4), Thủ kho trưởng xác nhận (d2) | Phiếu hủy được xác nhận |
| ĐẠT / CHỜ KIỂM / KHÓA / KHÔNG ĐẠT | HỦY | QT16 g3 · gx · gy | Kế hoạch lập biên bản thất lạc, Thủ kho trưởng xác nhận | Xe không tới, hoặc hàng thiếu khi nhận quá 7 ngày chưa tìm thấy |

Không đổi trạng thái: chuyển kho (hàng nằm trên phiếu chuyển rồi vào kho nhận, giữ nguyên trạng thái và lý do khóa — QT16); xuất trả NCC, xuất bán, xuất SX (chỉ giảm tồn). Mất kết nối (QT19, sửa 20/10 đợt 2): máy chủ nhà máy là chủ trạng thái các bao của mình, kiểm trên tồn thật khi quét, tự khóa lô hết hạn, không chờ cloud; không còn bản sao trạng thái lô.

### Không phải trạng thái lô

- **Cờ / thuộc tính trên lô (đi kèm trạng thái):** "dưới ngưỡng SX" (tính từ HSD và ngưỡng hạn tối thiểu cho SX, không lưu — lô vẫn ĐẠT, không xuất SX / nạp silo được, vẫn chuyển kho / trả NCC / hủy được; thay cờ CẬN DATE bỏ 24/10 đợt 9); lý do khóa; lô gắn đơn (xuất bán lấy đúng lô của đơn, QT15); ghi chú "đã hết hạn" trên lô KHÔNG ĐẠT; "đã hết" khi tồn bằng 0.
- **Hàng đang chuyển, không phải trạng thái:** nằm trên phiếu chuyển (QT16), không thuộc kho nào — thay cho trạng thái ĐANG CHUYỂN cũ. Sửa 24/10: bỏ vị trí kệ nên không còn vị trí "trên xe", khu hàng lỗi, khu chờ trả NCC; hàng bị từ chối ở cửa kho không tạo lô, không tính tồn, để riêng chờ NCC chở về (ngoài hệ thống).
- **Cờ "đang kiểm kê" (QT17):** gắn trên cả kho hoặc trên một lô trong kho, chặn mọi nhập xuất trong lúc đếm; kiểm xong chỉ gỡ cờ, trạng thái và lý do khóa của lô giữ nguyên.
- **Giữ chỗ nguyên liệu theo KG (QT19 g1):** gắn với lệnh SX, không gắn lô.
- **Cờ khách hàng:** "tạm khóa do nợ quá hạn" (QT10) — chặn đơn Mua chịu, không chặn lô (bỏ cờ "mất" 24/10).
- **Trạng thái NCC (QT11):** CHỜ DUYỆT / ĐÃ DUYỆT / TỪ CHỐI / NGỪNG DÙNG.
- **Trạng thái danh mục (QT02):** ĐANG DÙNG / NGỪNG DÙNG (NVL, SP, kho, khu vực làm việc); silo: HOẠT ĐỘNG / BẢO TRÌ / NGỪNG DÙNG (19/10 đợt 2).
- **Mã / tem (QT04, QT14 k4):** kích hoạt / khóa mã — khóa một mã tem, không khóa lô.
- **Trạng thái tài khoản (QT01), đơn hàng (QT05–QT09), PO (QT12), yêu cầu chuyển liên nhà máy (QT16), phiếu chứng nhận (Chờ ký / Đã ký — QT23), phiếu nhập / xuất / chuyển / trả / hủy, lệnh SX (MỚI TẠO / CHỜ PHÁT / ĐÃ NHẬN / ĐANG CHẠY / HOÀN THÀNH / ĐÃ HỦY, QT19), hồ sơ thu hồi (QT26), mẫu lưu (QT24):** vòng đời riêng của chứng từ / đối tượng đó.

### Quyết định đã chốt

1. Trạng thái gắn theo từng bao / thùng (sửa 24/10, thay lô × vị trí); tồn xem theo lô × kho; khóa cả lô là khóa mọi bao của lô.
2. Bỏ trạng thái ĐANG CHUYỂN: hàng đang chuyển nằm trên phiếu chuyển (sửa 24/10, bỏ vị trí "trên xe"); hàng giữ trạng thái thật, không tính tồn dùng được; khóa / hết hạn áp lên hàng đang chuyển như mọi bao khác; nhận xong chỉ đổi kho. Còn 5 trạng thái.
3. Chuyển kho nhận không khớp: thiếu → giữ trên phiếu chuyển, Kế hoạch tìm trong 7 ngày (mặc định), quá hạn → biên bản thất lạc, Thủ kho trưởng xác nhận → HỦY; hư → quét bao hư, các bao đó KHÓA (bao lành giữ trạng thái), Thủ kho trưởng chọn gửi QC hoặc hủy.
4. Trả hàng NCC (chỉ nguyên liệu mua): bỏ tranh chấp và kiểm nghiệm bên thứ 3 khỏi quy trình và hệ thống — nhà máy tự giải quyết ngoài, lô giữ nguyên trạng thái, xong thì xuất "trả NCC" hoặc Hủy hàng. Thêm loại xuất "trả NCC" (lô KHÓA / KHÔNG ĐẠT, gắn phiếu trả). Lô KHÔNG ĐẠT giữ nguyên khi sang Trả hàng. Hàng bị từ chối ở cửa kho không tạo lô.
5. QC nguyên liệu chỉ kiểm khi lô có vấn đề; không kiểm khi nhập, không kiểm định kỳ. Lô nghi lỗi bị chặn ngay khi gửi yêu cầu kiểm — chuyển CHỜ KIỂM, không KHÓA (nhắc lại 19/10 đợt 4).
6. Mất kết nối: phát hiện xung đột thì tự KHÓA mọi lô sinh ra từ mẻ đó theo chuỗi liên kết; lô HỦY bị dùng → ghi nhận đã dùng, kiểm kho đúng lô, sửa số lượng thực hủy; lô gốc khóa vì thu hồi → lô sinh ra vào hồ sơ thu hồi; máy chủ nhà máy tự chặn lô hết hạn.
7. HỦY là trạng thái cuối. Thất lạc tìm lại → nhập như hàng mới gắn lô cũ, KHÓA, QC kiểm; hủy nhầm → phiếu điều chỉnh qua Kiểm kho, KHÓA chờ QC.
8. KHÔNG ĐẠT: nguyên liệu → trả NCC / hủy, QC trưởng có thao tác tay "Mở lại lô KHÔNG ĐẠT" (lý do + file, chặn khi đã hết hạn). BTP / TP → chỉ hủy; không sản xuất lại từ BTP / TP — cần bù thì Kế hoạch tạo lệnh mới từ nguyên liệu.
9. Lý do khóa quyết định lối ra (bảng trên); lý do thu hồi / hết hạn chỉ có đường hủy, không cho gửi QC; 2 lý do cùng lúc lấy lý do chặt hơn.
10. QC trưởng từ chối yêu cầu kiểm → lô về trạng thái trước (bắt buộc lý do); BTP mới nhập không được từ chối, chỉ yêu cầu bổ sung.
11. QC trưởng duyệt mọi kết quả QC trước khi đổi trạng thái; người nhập không tự duyệt; phiếu chứng nhận ghi QC trưởng là người duyệt.
12. QC thành phẩm là chốt chặn cuối. Nguyên liệu KHÔNG ĐẠT chỉ xử lý phần còn trong kho, không dò ngược. TP KHÔNG ĐẠT khi đã giao một phần (khoanh vùng) → hủy phần trong kho, hồ sơ thu hồi quay lại bước GĐ quyết định; hệ thống không tự thu hồi.
13. Hủy hàng: tạo phiếu hủy là tự KHÓA (chờ hủy); lô hết hạn không được từ chối hủy, chỉ dời ngày (quá 30 ngày nhắc); lô chờ hủy bị từ chối → về trạng thái trước hoặc gửi QC.
14. Đến hạn khi đang CHỜ KIỂM → KHÓA hết hạn, hủy yêu cầu QC; đang KHÔNG ĐẠT → giữ nguyên, ghi chú đã hết hạn.
15. Chuyển kho cho mọi trạng thái trừ HỦY, giữ trạng thái; bỏ thao tác dời vị trí (24/10).
16. Không có trạng thái "hết". Cân bằng khối lượng (QT25): SL vào = dùng cho SX + giao khách + trả NCC + hủy + mẫu lưu + tồn (gồm hàng đang chuyển).
17. Nguyên liệu dư trả về nhận trạng thái theo khóa cả lô của lô gốc (bảng chuyển trạng thái). Khóa kiểm kê là cờ riêng, không đổi trạng thái lô.
18. Loại lô: nguyên liệu hỗn hợp ra là ĐẠT; BTP vào kho BTP ở CHỜ KIỂM, QC đạt thì đổi thành TP trên cùng mã lô; TP nằm ở kho BTP, muốn sang kho khác thì Chuyển kho. Các ô THIẾU ở sản xuất (QT20, QT21) đã thành bước thật 17/10, gồm chặn bao sai lô / chưa ĐẠT / hết hạn khi quét bao trước khi mở silo (QT20 g2).
19. (19/10 đợt 3) Bột dư xả từ silo cuối lệnh là lô NVL dư mới, liên kết từ nút silo của lệnh; HSD lấy theo lô sớm nhất đã nạp vào nút đó; trạng thái theo khóa cả lô của các lô đã nạp (lô nào đang khóa cả lô → KHÓA cùng lý do chặt nhất; hết hạn → KHÓA hết hạn; còn lại → ĐẠT) — như NVL dư trả về.
20. (20/10 đợt 2) Trạng thái phần lô do máy chủ nhà máy giữ phần đó làm chủ; QC, QC trưởng, Thủ kho trưởng đổi trạng thái tại nhà máy cả khi mất mạng; hết hạn do nhà máy tự khóa; thu hồi / khoanh vùng là lệnh từ trung tâm, tới muộn thì khóa hàng sinh ra theo chuỗi liên kết (QT19 kz).
21. (04/11) Phiếu chứng nhận ký tách khỏi duyệt kết luận: lô TP ĐẠT nhưng phiếu Chờ ký thì chưa giao được (không thêm trạng thái lô — là trạng thái của phiếu chứng nhận).

## Vai trò × Chức năng

Bản chốt 17/10 cho đủ 26 QT, thay bản dự thảo ở QT01. Quyền = **vai trò × thao tác (xem / tạo / sửa / duyệt / hủy) × phạm vi (mọi nhà máy / nhà máy / kho / khu vực làm việc)**. Quyền luôn gán qua vai trò (QT01), không gán quyền lẻ; một tài khoản giữ được nhiều vai trò. Không có vai trò QS. Quy tắc chung: **người tạo phiếu không tự duyệt phiếu của mình** — hệ thống chặn, kể cả khi người đó giữ cả vai trò tạo lẫn vai trò duyệt. Quyền đổi trạng thái lô khớp đúng bảng chuyển trạng thái ở mục "Vòng đời lô hàng". Sửa 20/10: Admin không còn toàn quyền — quản trị hệ thống và xem mọi màn ở mọi nhà máy (QT01 xa, cùng Giám đốc), không làm bước nghiệp vụ; người làm Admin cần làm nghiệp vụ thì được gán thêm vai trò đó. Không ai tự duyệt phiếu mình tạo, không ai tự sửa vai trò của chính mình. Vai trò có quyền duyệt được ủy quyền tạm cho người khác khi vắng (QT01), bắt buộc ngày hết hạn. Mặc định ai có quyền tạo / sửa / duyệt ở một QT thì xem được chứng từ của QT đó trong phạm vi của mình; bảng chỉ ghi "xem" khi đó là toàn bộ việc của vai trò ở bước.

Sửa 04/11 (thay quyết định 19/10 "màn Vai trò × quyền chỉ để xem"): bảng này là **bộ quyền mặc định** nạp lúc triển khai (`mes-powder-gen-quyen.py`); sau đó **Admin sửa quyền ngay trên màn Vai trò × quyền** (QT01 vq): sửa quyền của vai trò, thêm / sửa / xóa quyền, phạm vi nhà máy theo vai trò và theo từng quyền; áp dụng từ lần đăng nhập tới, ghi nhật ký. 19 vai trò (thêm Thủ kho điều phối 04/11). Menu web hiện theo quyền: không có quyền ở phân hệ nào thì ẩn phân hệ đó (mục "Phân hệ & màn hình"). Vai trò ủy quyền tạm được (`role.delegable`): Giám đốc, Kế toán trưởng, Thủ kho trưởng, Trưởng BP Mua hàng, QC trưởng, Kế hoạch. Câu hỏi còn mở ở cuối mục.

### Danh sách vai trò

| Vai trò | Là ai | Phạm vi mặc định | Việc chính |
|---|---|---|---|
| Admin | Quản trị hệ thống | Mọi nhà máy | Quản trị hệ thống, xem mọi màn ở mọi nhà máy (chỉ xem), sửa Vai trò × quyền (04/11), không làm bước nghiệp vụ (cần làm thì được gán thêm vai trò đó, do HR / Admin khác gán — chốt 20/10); chỉ Admin gán vai trò Admin và Người truy xuất; mở khóa, cấp mật khẩu tạm; cấu hình tham số mặc định, định dạng mã; đơn vị (Danh mục › Đơn vị — thêm / sửa / xóa đơn vị chưa dùng); xóa tài khoản chưa từng dùng; tạo / sửa / ngừng dùng nhà máy, khu vực làm việc (loại khu, khối lượng mẻ tối đa, dàn silo), kho; không tự sửa vai trò của mình |
| HR | Nhân sự | Mọi nhà máy | Tạo / sửa tài khoản, xóa tài khoản chưa từng dùng (04/11), xem Vai trò × quyền, gán vai trò trực tiếp (trừ Admin và Người truy xuất), không duyệt, không bàn giao; nhập ngày nghỉ, đặt ngày khóa tài khoản; ủy quyền tạm khi vắng; không tự sửa vai trò của mình (bỏ theo dõi rà soát hằng quý — 28/10) |
| Giám đốc | GĐ | Mọi nhà máy | Duyệt hạn mức, số tiền hoàn khi hủy đơn và khi thu hồi (cùng Kế toán trưởng, một người duyệt là đủ); duyệt thêm PO trên ngưỡng; ký quyết định thu hồi / khoanh vùng, duyệt đóng hồ sơ thu hồi; quyết công nợ quá 90 ngày bên ngoài hệ thống (Kế toán ghi kết quả); xem mọi màn ở mọi nhà máy (chỉ xem) và màn Tổng quan (04/11); tạo / sửa / xóa hồ sơ pháp lý chung (04/11) |
| Kế toán trưởng | KTT | Mọi nhà máy | Duyệt hạn mức, số tiền hoàn khi hủy đơn và khi thu hồi (cùng Giám đốc, một người duyệt là đủ); xem mọi công nợ khách hàng, NCC và sổ thu chi; quyết công nợ quá 90 ngày bên ngoài hệ thống (Kế toán ghi kết quả). Không còn duyệt phiếu chi (bỏ 19/10) |
| Kế toán | Kế toán | Mọi nhà máy | Đề xuất hạn mức; ghi nhận tiền về / hoàn tiền (không duyệt); lập hóa đơn bán hàng gắn phiếu xuất, in A4 trên MES — một đơn nhiều hóa đơn (chốt 04/11); ghi nhận đã trả NCC, giảm trừ khi trả hàng; ghi kết quả công nợ quá 90 ngày; ghi giá trị hàng hủy (không hạch toán) |
| Sales | Kinh doanh | Mọi nhà máy | Khách hàng, nhận / sửa / hủy đơn, xin tăng hạn mức, yêu cầu xuất từ đơn và ghi nhận kết quả giao (SL khách nhận, ảnh biên bản — 24/10), nhắc nợ; xem công nợ, hạn mức, lịch sử thanh toán của khách (chỉ xem); đổi lô mới / đề nghị hoàn tiền khi thu hồi |
| CSKH | Chăm sóc khách hàng | Mọi nhà máy | Thông báo khách / đại lý khi thu hồi (QT26); không tạo / sửa / hủy đơn |
| Kế hoạch | Kế hoạch sản xuất, đại diện bộ phận SX | Nhà máy | Công thức; tạo / phát lệnh SX trên cloud (xếp dàn silo, hàng đợi phát lệnh từng khu; sửa lệnh Mới tạo, hủy lệnh chưa chạy, kết thúc sớm lệnh đang chạy); lập yêu cầu mua NVL; xử lý xung đột ngoại tuyến cùng QC; gửi yêu cầu xuất kho, yêu cầu chuyển liên nhà máy YCC- (nhà máy nhận) và lập phiếu chuyển từ yêu cầu của nhà máy khác (nhà máy nguồn — lập phiếu là chấp nhận, 30/10), chọn cách bù phần thiếu NVL (Cân đối NVL — 04/11); thêm tay nhu cầu mua, yêu cầu QC kiểm thay bộ phận SX; lập phiếu báo lỗi NCR khi SX giao hàng hư; xem tình trạng giao của đơn; biên bản thất lạc chuyển kho; tự ngừng dùng mã NVL / SP do mình đề nghị, không qua duyệt (QT02 tk — 28/10) |
| R&D | Nghiên cứu công thức | Mọi nhà máy | Nhập / sửa công thức (QT03), không duyệt |
| Mua hàng | Nhân viên mua hàng | Mọi nhà máy | Hồ sơ NCC, Hàng đợi mua (nhập SL, NCC, đơn giá — bỏ báo giá 04/11), PO (gửi email yêu cầu COA & HSD, kiểm COA & HSD, chọn hình thức thanh toán, gửi PO cho NCC qua email; hủy PO chưa duyệt), phiếu trả hàng NCC (không cần duyệt thêm), gửi yêu cầu xuất trả NCC |
| Trưởng BP Mua hàng | Trưởng bộ phận mua hàng | Mọi nhà máy | Duyệt NCC, ngừng dùng NCC, duyệt / từ chối PO, hủy PO đã duyệt, đóng phần còn lại của PO giao thiếu; làm được các việc PO của Mua hàng (kiểm COA & HSD, gửi email); duyệt yêu cầu xuất trả NCC (QT13 dx); duyệt ngừng dùng mã NVL / SP do Mua hàng đề nghị (QT02 d4 — 28/10) |
| Thủ kho | Thủ kho kho tổng, kho BTP, kho xuất / nhận (kho điều phối: vai trò Thủ kho điều phối — 04/11) | Kho được gán | Nhập / xuất / chuyển / đếm / cất hàng / tem; xuất chuyển kho tổng → kho điều phối theo phiếu lệnh SX tự lập (kho tổng), bấm Không thực hiện được khi không lấy được hàng; xem Lệnh SX (QT19 xl); tạo và thực hiện phiếu hủy; gửi yêu cầu QC; biên bản chênh lệch khi truy xuất. Đăng nhập web bằng mã NV + mật khẩu; quét mã ngay trên màn Kho; sự cố tem làm ở Kho · Tồn kho |
| Thủ kho điều phối | Thủ kho được gán kho điều phối (vd NM1-DP; một nhà máy được nhiều kho điều phối) — vai trò riêng từ 04/11, thay quyết định 20/10 số 9 | Kho điều phối được gán | Nhận chuyển kho từ kho tổng theo phiếu lệnh SX tự lập, quét, ký nhận, biên bản chênh lệch; lấy hàng theo phiếu xuất SX máy chủ nhà máy tự lập khi lệnh phát sang khu (không lập tay, không duyệt); nhập bột dư / NVL dư cuối lệnh; xử lý tem lỗi báo từ khu SX; xem Lệnh SX, Theo dõi mẻ; lập phiếu từ yêu cầu chuyển nội bộ; các việc kho chung như Thủ kho trong kho điều phối (kiểm kho, hủy hàng, gửi yêu cầu QC, sự cố tem). Kho điều phối chỉ phục vụ sản xuất — không chứa thành phẩm, không xuất bán, không nhận khách trả, không chuyển liên nhà máy |
| Thủ kho trưởng | Thủ kho trưởng | Kho được gán | Xác nhận chênh lệch khi nhập (bỏ xác nhận yêu cầu chuyển — 30/10, lập phiếu là chấp nhận); xem tồn kho, phiếu xuất, nhà máy, kho, đơn vị, hồ sơ pháp lý chung (phiếu nhập / xuất không duyệt — 24/10 đợt 6, 7), duyệt hủy hàng, ra lệnh kiểm kho và duyệt điều chỉnh (toàn kho và kiểm điểm); chọn gửi QC / hủy hàng hư khi nhận chuyển kho; xác nhận biên bản thất lạc; duyệt ngừng dùng mã NVL / SP do Kho đề nghị (QT02 d4 — 28/10) |
| Vận chuyển | Tài xế | Chuyến được giao | Chuyến xe chuyển kho giữa 2 nhà máy (QT16). Không còn giao hàng cho khách — giao hàng chỉ ghi nhận, Sales ghi (24/10) |
| Công nhân | Công nhân sản xuất và đóng gói; tài khoản riêng, đăng nhập PC xưởng bằng quét thẻ | Khu vực làm việc: HH / BTP / chiết rót & đóng gói (gộp 05/11) | Chỉ thao tác lệnh của khu mình trên PC xưởng (PC C#: quét bao nạp silo, xả bột dư cuối lệnh, lon đầu, dán QR thùng — QT20, QT21) |
| QC | Nhân viên QC | Nhà máy | Lấy mẫu (TP sau khi thùng đã nhập kho BTP), gửi kiểm nghiệm, tải file đánh giá bên ngoài và đề xuất kết luận; tự quyết, sửa thời hạn lưu mẫu; lấy mẫu lưu ra đánh giá, niêm phong lại (04/11); quản lý và tự hủy mẫu lưu hết hạn; nguyên nhân gốc / CAPA |
| QC trưởng | Trưởng QC | Nhà máy | Duyệt / từ chối yêu cầu kiểm, duyệt kết luận (lô chỉ đổi ĐẠT / KHÔNG ĐẠT / KHÓA sau khi QC trưởng duyệt), ký phiếu chứng nhận (tách riêng sau duyệt kết luận — 04/11), duyệt mẫu nhãn SP (QT02 ml — 04/11), mở lại lô NVL KHÔNG ĐẠT; mở hồ sơ thu hồi (chỉ vai trò này), đánh giá rủi ro, báo cơ quan, duyệt CAPA; duyệt ngừng dùng mã NVL / SP do QC đề nghị (QT02 d4 — 28/10) |
| Người truy xuất | Do Admin gán | Mọi nhà máy | Tạo phiếu và chạy truy xuất QT25 — chỉ vai trò này |

### Map tác nhân → vai trò

Tác nhân là từng tên trong dòng `cot:` của 26 QT; tên cột gộp nhiều bộ phận được tách thành từng tác nhân.

| Tác nhân (tên cột trong sơ đồ) | Ở QT | Vai trò |
|---|---|---|
| HR | 01 | HR |
| Admin | 01 | Admin |
| Admin | 02 | Admin (nhà máy, khu vực làm việc, dàn silo, kho, đơn vị); Giám đốc (hồ sơ pháp lý chung — 04/11) |
| Bộ phận đề xuất: Mua hàng / Kế hoạch / Kho / QC | 02 | Mua hàng · Kế hoạch · Thủ kho · Thủ kho điều phối · QC |
| R&D (trong "R&D / Kế hoạch") | 03 | R&D |
| Kế hoạch; "Kế hoạch" trong "R&D / Kế hoạch", "Kế hoạch / Sales", "Kho / Kế hoạch", "Bộ phận yêu cầu", "NCC / Kế hoạch (bên giao từ SX)" | 03, 05, 07, 08, 09, 12, 14, 15, 16, 18, 19, 20, 22, 23 | Kế hoạch |
| Thủ kho; Kho; Kho xuất; Kho nhận; Kho khác; "Kho" trong "Kho / Kế hoạch" | 04, 09, 12–23, 25, 26 | Thủ kho (phạm vi theo kho); phần ở kho điều phối là Thủ kho điều phối |
| Kho điều phối; kho nhận NVL cho SX (QT16, QT19) | 16, 19, 20 | Thủ kho điều phối |
| Sales; "Sales" trong "Kế hoạch / Sales", "Bộ phận yêu cầu" | 05–10, 15, 18, 26 | Sales |
| CSKH | 26 | CSKH |
| Kế toán | 06, 10, 12, 13, 14, 18 | Kế toán |
| Giám đốc; GĐ trong "Người duyệt (GĐ / KTT)" | 06, 07, 26 | Giám đốc |
| Kế toán trưởng; KTT trong "Người duyệt (GĐ / KTT)" | 06, 07 | Kế toán trưởng |
| Vận chuyển | 16 | Vận chuyển |
| Bộ phận Mua hàng; Mua hàng (kể cả trong "Bộ phận yêu cầu") | 11, 12, 13, 14, 15, 22 | Mua hàng |
| Trưởng BP Mua hàng; "Trưởng BP Mua hàng" trong "Trưởng bên đề xuất" | 02, 11, 12 | Trưởng BP Mua hàng |
| QC | 14, 18, 21, 22, 23, 24, 26 | QC |
| QC trưởng; "QC trưởng" trong "Trưởng bên đề xuất" | 02, 22, 23, 26 | QC trưởng |
| Thủ kho trưởng; "Thủ kho trưởng" trong "Trưởng bên đề xuất" | 02, 14, 15, 16, 17, 18 | Thủ kho trưởng |
| Công nhân; Công nhân sản xuất | 20, 21 | Công nhân (khu HH / BTP / chiết rót) |
| Công nhân đóng gói | 21 | Công nhân (khu chiết rót & đóng gói) |
| Người truy xuất (vai trò được giao ở QT01) | 25 | Người truy xuất |
| Bên yêu cầu (QT26 / QC / cơ quan / nội bộ) | 25 | Không thao tác: yêu cầu qua Người truy xuất, nhận báo cáo |
| Các bộ phận | 17 | Không thao tác: chỉ nhận thông báo kiểm kho |

Không phải vai trò người dùng: Hệ thống; Hệ thống (cloud); Server nhà máy / PC C#; PC C# / Hệ thống; Khách hàng; Khách / Đại lý; NCC; Nhà cung cấp; Robot / Thang nâng (HH); Bồn trộn (BTP); Máy chiết rót / đóng gói. Bước loại T / D nằm ở các cột này (khách ký HĐ, NCC xác nhận PO, máy chiết rót, robot…) không gán vai trò; kết quả do người phụ trách bước kế tiếp ghi nhận vào hệ thống.

### Mảng 1 · Nền tảng

| QT | Bước | Vai trò | Thao tác | Phạm vi |
|---|---|---|---|---|
| 01 | d0, a1 · Tạo tài khoản, nhập thông tin, chọn vai trò (trừ Admin và Người truy xuất) rồi tick bỏ / thêm quyền riêng từng người (05/11); đổi vai trò; không tự sửa vai trò, quyền của mình | HR · Admin | tạo, sửa | Mọi nhà máy |
| 01 | a1 · Gán / gỡ vai trò Admin và Người truy xuất | Admin | sửa | Mọi nhà máy |
| 01 | n1 · Nhập ngày nghỉ, đặt / sửa ngày khóa tài khoản | HR | sửa | Mọi nhà máy |
| 01 | m1 · Xác minh, mở khóa, cấp mật khẩu tạm (bắt đổi khi đăng nhập) | Admin | sửa | Mọi nhà máy |
| 01 | u1 · Ủy quyền tạm một vai trò khi vắng (người nhận, ngày bắt đầu, ngày hết hạn bắt buộc; đến hạn tự gỡ) | HR · Admin | tạo | Mọi nhà máy |
| 01 | Nhật ký tài khoản | Admin · HR | xem | Mọi nhà máy |
| 01 | vq · Vai trò × quyền: sửa quyền của vai trò, thêm / sửa / xóa quyền, phạm vi nhà máy theo vai trò và theo quyền (chốt 04/11, thay "chỉ xem") | Admin | sửa | Mọi nhà máy |
| 01 | Tham số mặc định (⚙ ở mọi QT), định dạng mã danh mục và chứng từ (đơn vị tính chuyển sang Danh mục › Đơn vị — QT02 dv, 04/11) | Admin | sửa | Mọi nhà máy |
| 01 | xa · Xem mọi màn ở mọi nhà máy — chỉ xem, không tạo / sửa / duyệt / hủy nghiệp vụ (chốt 20/10, thay "Admin toàn quyền") | Admin · Giám đốc | xem | Mọi nhà máy |
| 01 | xq · Xem Vai trò × quyền | HR | xem | Mọi nhà máy |
| 01 | xt · Xóa tài khoản chưa từng dùng (chưa đăng nhập, chưa có giao dịch); không tự xóa tài khoản của mình (04/11) | HR · Admin | hủy | Mọi nhà máy |
| 01 | tq · Tổng quan Giám đốc: số liệu toàn công ty, việc chờ Giám đốc duyệt, lối tắt sang màn nghiệp vụ — chỉ xem (thêm 04/11) | Giám đốc | xem | Mọi nhà máy |
| 02 | t1, t2 · Tạo / sửa mã NVL (bộ chỉ tiêu COA ≥ 1, nguyên liệu kỵ nhau, ảnh, tồn tối thiểu, cách bù, quy cách đóng gói nhiều cấp — 05/11), SP (cấu trúc, nhóm, phân loại, độ tuổi, mục khác có loại ô nhập — 05/11, quy cách đóng gói nhiều cấp, barcode, mẫu nhãn, bản công bố, hồ sơ pháp lý — 04/11) và lựa chọn của ô chọn SP; sửa thông tin khi trùng | Mua hàng · Kế hoạch · Thủ kho · Thủ kho điều phối · QC | tạo, sửa | Danh mục chung |
| 02 | xo · Xóa lựa chọn của ô chọn SP chưa SP nào dùng (04/11) | Mua hàng · Kế hoạch · Thủ kho · Thủ kho điều phối · QC | hủy | Danh mục chung |
| 02 | ml · Duyệt mẫu nhãn của SP (Chờ duyệt → Đã duyệt) (04/11) | QC trưởng | duyệt | Danh mục chung |
| 02 | y2 · Mã mới do hệ thống tự sinh theo định dạng cấu hình sẵn, không duyệt | Hệ thống | — | — |
| 02 | t3 · Xử lý hết tồn / phiếu / đơn mua đang mở trước khi ngừng mã (danh mục SP: ngừng hoặc chuyển các SP đang dùng trước) | Bên đề xuất (như t1) | sửa | Danh mục chung |
| 02 | tk · Kế hoạch ngừng dùng trực tiếp mã do mình đề nghị, ghi lý do — không qua duyệt (28/10) | Kế hoạch | hủy | Danh mục chung |
| 02 | tg · Gửi đề nghị ngừng dùng mã NVL / SP (Kế hoạch không gửi — tự ngừng ở tk) | Mua hàng · Thủ kho · Thủ kho điều phối · QC | tạo | Danh mục chung |
| 02 | tr · Rút đề nghị ngừng dùng khi đang chờ duyệt (chỉ người đề xuất) | Mua hàng · Thủ kho · Thủ kho điều phối · QC | hủy | Danh mục chung |
| 02 | d4 · Duyệt ngừng dùng mã NVL / SP (hiện trong Việc cần làm; người gửi không tự duyệt) | Trưởng BP Mua hàng (bên Mua hàng) · Thủ kho trưởng (bên Kho, kể cả kho điều phối) · QC trưởng (bên QC) | duyệt | Danh mục chung |
| 02 | ka · Nhà máy (Danh mục › Nhà máy; tiền tố mã định danh), kho (bên trong màn Nhà máy; được nhiều kho điều phối — 04/11), khu vực làm việc (loại khu; khối lượng mẻ tối đa với khu HH / BTP; kho điều phối cấp NVL — Danh mục › Nhà máy › Khu vực làm việc & dàn silo): tạo / sửa / ngừng dùng (làm trực tiếp; không đổi loại khu khi còn lệnh chưa hoàn thành) | Admin | tạo, sửa, hủy | Mọi nhà máy |
| 02 | ks · Dàn silo của khu HH / BTP: thêm silo (tên, sức chứa, gán cứng NVL, mã SCADA), sửa, chuyển bảo trì / ngừng dùng (xem danh sách lệnh bị ảnh hưởng; không chuyển khi silo còn bột của lệnh) | Admin | tạo, sửa, hủy | Mọi nhà máy |
| 02 | dv · Đơn vị: thêm / sửa / xóa đơn vị chưa có tham chiếu; đã dùng thì khóa (04/11) | Admin | tạo, sửa, hủy | Mọi nhà máy |
| 02 | xv · Xem đơn vị (Danh mục › Đơn vị) | Kế hoạch · Mua hàng · Trưởng BP Mua hàng · Thủ kho · Thủ kho điều phối · Thủ kho trưởng · QC · QC trưởng | xem | Mọi nhà máy |
| 02 | hs · Hồ sơ pháp lý chung: tạo / sửa / xóa (04/11) | Giám đốc · Admin | tạo, sửa, hủy | Mọi nhà máy |
| 02 | xh · Xem hồ sơ pháp lý chung | Kế hoạch · R&D · Mua hàng · Trưởng BP Mua hàng · Thủ kho trưởng · QC · QC trưởng | xem | Mọi nhà máy |
| 02 | xk · Xem nhà máy, kho (Danh mục › Nhà máy) | Thủ kho trưởng | xem | Nhà máy |
| 03 | t1, t2 · Nhập / sửa / sao chép công thức; thứ tự dòng là thứ tự nạp (lưu phiên bản mới, không duyệt; bỏ dung sai, thông số trộn chuẩn — 05/11) | R&D · Kế hoạch | tạo, sửa | Mọi nhà máy |
| 03 | Xem công thức (kèm lệnh đang chạy phiên bản cũ); công nhân xem trên PC xưởng, chỉ công thức của lệnh khu mình (không vào màn web) | QC | xem | Nhà máy |
| 04 | t4, dh · Hủy tem (Kho · Tồn kho → dòng lô → bao): bao còn trong kho → cấp mã mới như tem mất; bao không còn → khóa mã, thu tem | Thủ kho · Thủ kho điều phối | hủy | Kho |
| 04 | t5a, t5 · Tem hỏng (Kho · Tồn kho → dòng lô → bao): in lại cùng mã, dán, quét xác nhận | Thủ kho · Thủ kho điều phối | sửa | Kho |
| 04 | t6c, t6 · Tem mất (ô + lô lấy từ dòng tồn): chọn mã cũ để khóa, cấp mã mới cùng lô, in, dán, quét xác nhận | Thủ kho · Thủ kho điều phối | tạo | Kho |
| 04 | Tem lỗi phát hiện ở khu SX: công nhân chỉ báo, Thủ kho điều phối xử lý như các dòng trên | Thủ kho điều phối | tạo, sửa, hủy | Kho điều phối |

### Mảng 2 · Bán hàng

| QT | Bước | Vai trò | Thao tác | Phạm vi |
|---|---|---|---|---|
| 05 | t1–t3 · Tạo / cập nhật hồ sơ khách, nhập đơn (Nháp) — kèm hợp đồng nếu đã có: số, hiệu lực, file (05/11) | Sales | tạo, sửa | Mọi nhà máy |
| 05 | d2 · Chọn hình thức, phương thức thanh toán, tiền cọc, số ngày nợ (điền sẵn theo khách) | Sales | sửa | Mọi nhà máy |
| 05 | t6 · Chốt đơn theo hợp đồng còn hiệu lực của đơn (chưa có thì upload ở chi tiết đơn — 05/11) | Sales | sửa | Mọi nhà máy |
| 05 | hn · Hủy đơn chưa chốt (Chờ thu tiền), bắt buộc lý do — không qua duyệt (chốt 04/11) | Sales | hủy | Mọi nhà máy |
| 05 | xk · Xem hồ sơ khách, lịch sử liên hệ (Bán hàng › Khách hàng) | CSKH | xem | Mọi nhà máy |
| 06 | t4 · Đề xuất hạn mức ban đầu | Kế toán | tạo | Mọi nhà máy |
| 06 | t4d · Duyệt hạn mức ban đầu (vĩnh viễn) | Giám đốc · Kế toán trưởng (một người là đủ) | duyệt | Mọi nhà máy |
| 06 | q1, v4 · Báo khách, chuyển đơn sang trạng thái chờ | Sales | sửa | Mọi nhà máy |
| 06 | q2 · Ghi nhận tiền về (QT10); hệ thống tự cấn, đóng khoản quá hạn | Kế toán | tạo | Mọi nhà máy |
| 06 | v1 · Xin tăng hạn mức | Sales | tạo | Mọi nhà máy |
| 06 | v2 · Xem công nợ, lịch sử thanh toán | Kế toán | xem | Mọi nhà máy |
| 06 | vd1 · Quyết hạn mức mới (luôn vĩnh viễn) | Giám đốc · Kế toán trưởng (một người là đủ) | duyệt | Mọi nhà máy |
| 06 | v5 · Ghi mức cọc mới vào đơn | Sales | sửa | Mọi nhà máy |
| 07 | t0 · Ghi nhận yêu cầu hủy đơn đã chốt, lý do | Sales | hủy | Mọi nhà máy |
| 07 | h2 · Quyết số tiền hoàn (mặc định giữ toàn bộ cọc) | Giám đốc · Kế toán trưởng (một người là đủ) | duyệt | Mọi nhà máy |
| 07 | h4 · Hủy lệnh SX chưa chạy | Kế hoạch | hủy | Nhà máy |
| 07 | h5 · TP / BTP của đơn không dùng lại → chuyển Hủy hàng (phiếu hủy do Thủ kho lập ở QT18); Sales xem phiếu hủy của đơn | Kế hoạch · Sales | xem | Nhà máy |
| 08 | m1 · Thỏa thuận lại, tạo phiên bản đơn mới | Sales | sửa | Mọi nhà máy |
| 08 | t6 · Tải phụ lục đã ký | Sales | sửa | Mọi nhà máy |
| 08 | r2 · Cập nhật lệnh SX theo đơn mới: lệnh Mới tạo sửa; đã phát chưa chạy hủy rồi tạo lại; đang chạy kết thúc sớm / tạo thêm lệnh | Kế hoạch | sửa | Nhà máy |
| 09 | t1 · Nhận thông báo đơn Sẵn sàng giao; xem tab Giao hàng của đơn | Kế hoạch | xem | Nhà máy |
| 09 | t2 · Yêu cầu xuất từ đơn: chọn dòng, SL giao lần này; sửa ngày giao dự kiến | Sales | tạo | Mọi nhà máy |
| 09 | kd · Duyệt xuất giao sau khi nhập kho lô của đơn: Mua nợ kiểm công nợ; Cọc + trả nốt ghi nhận phần còn lại (05/11) | Kế toán | duyệt | Mọi nhà máy |
| 09 | t9 · Phiếu xuất bán Chờ bên yêu cầu: nhận phần đã lấy hoặc hủy yêu cầu | Sales | sửa | Mọi nhà máy |
| 09 | tr · Hủy yêu cầu xuất chưa xuất (bắt buộc lý do), kể cả yêu cầu bị nhà máy trả về | Sales | hủy | Mọi nhà máy |
| 09 | t5 · Ghi nhận kết quả giao theo phiếu xuất: SL khách nhận từng lô, ngày nhận, ảnh biên bản, phần không nhận | Sales | tạo | Mọi nhà máy |
| 09 | dg · Ghi khách còn lấy phần trả về hay không (bắt buộc khi có SL không nhận): còn lấy → đơn giữ Giao một phần, chờ QC kiểm lại; không lấy → giảm SL đơn phần đó, đã thu tiền thì GĐ / KTT quyết số tiền hoàn (QT07 h2) | Sales | sửa | Mọi nhà máy |
| 10 | t1 · Lập hóa đơn bán hàng gắn phiếu xuất của lần giao (một đơn nhiều hóa đơn), in A4 trên MES (chốt 04/11) | Kế toán | tạo | Mọi nhà máy |
| 10 | k2 · Ghi nhận tiền về: số tiền, ngày, CK / tiền mặt, ảnh chứng từ (hệ thống cấn vào khoản) | Kế toán | tạo | Mọi nhà máy |
| 10 | h1 · Ghi nhận hoàn tiền theo số GĐ / KTT đã quyết (không duyệt thêm) | Kế toán | tạo | Mọi nhà máy |
| 10 | Hủy bản ghi nhận thu / chi nhập sai (bắt buộc lý do; không xóa) | Kế toán | hủy | Mọi nhà máy |
| 10 | k3 · Liên hệ khách nhắc nợ, thỏa thuận lịch trả (ngoài hệ thống); ghi lần liên hệ ở Kế toán › Công nợ KH (Bán hàng › Khách hàng hiện lịch sử liên hệ) | Sales | tạo | Mọi nhà máy |
| 10 | g9 · Ghi kết quả xử lý công nợ quá 90 ngày (GĐ / KTT quyết bên ngoài hệ thống; hệ thống không xóa nợ) | Kế toán | sửa | Mọi nhà máy |
| 10 | Xem công nợ, hạn mức, lịch sử thanh toán của khách (chỉ xem — để nhắc nợ, xin tăng hạn mức) | Sales | xem | Mọi nhà máy |
| 10 | Xem mọi công nợ khách hàng, công nợ NCC và sổ thu chi | Kế toán trưởng | xem | Mọi nhà máy |

### Mảng 3 · Mua hàng

| QT | Bước | Vai trò | Thao tác | Phạm vi |
|---|---|---|---|---|
| 11 | t1 · Tìm NCC, xin hồ sơ, tạo hồ sơ NCC (CHỜ DUYỆT) | Mua hàng | tạo | Mọi nhà máy |
| 11 | d1 · Kiểm đủ hồ sơ pháp lý, chứng nhận còn hạn (không có bước đánh giá mẫu) | Mua hàng | sửa | Mọi nhà máy |
| 11 | d3 · Duyệt / từ chối NCC (chỉ vai trò này) | Trưởng BP Mua hàng | duyệt | Mọi nhà máy |
| 11 | dr · Tìm NCC khác hay báo không có NCC | Mua hàng | sửa | Mọi nhà máy |
| 11 | n1 · Ngừng dùng NCC, ghi lý do (chỉ vai trò này) | Trưởng BP Mua hàng | hủy | Mọi nhà máy |
| 12 | t1 · Thêm tay nhu cầu mua NVL (mã NC-) ngoài nhu cầu hệ thống tính — nhu cầu theo lệnh SX / tồn tối thiểu hệ thống tự đưa vào Hàng đợi mua (bỏ phiếu yêu cầu mua và báo giá — 04/11) | Kế hoạch | tạo | Nhà máy |
| 12 | th · Hủy nhu cầu lập tay khi chưa lên PO (bắt buộc lý do) | Kế hoạch | hủy | Nhà máy |
| 12 | d1 · Kiểm tồn khả dụng | Thủ kho · Thủ kho điều phối | xem | Kho |
| 12 | t2 · Nhận dòng ở Hàng đợi mua | Mua hàng | xem | Mọi nhà máy |
| 12 | tv · Trả dòng về Kế hoạch kèm lý do khi không mua được | Mua hàng | sửa | Mọi nhà máy |
| 12 | t3, t4 · Điền SL, chọn NCC, nhập đơn giá, ngày giao ở Hàng đợi mua; lập PO (gộp theo NCC × kho nhận) → Chờ COA & HSD | Mua hàng | tạo, sửa | Mọi nhà máy |
| 12 | ce · Gửi email yêu cầu COA & HSD cho NCC (30/10, 31/10) | Mua hàng · Trưởng BP Mua hàng | sửa | Mọi nhà máy |
| 12 | ck · Kiểm COA & HSD NCC gửi theo bộ chỉ tiêu của NVL (đạt → Chờ chọn thanh toán; không đạt → PO Đã hủy, NVL về Hàng đợi mua) | Mua hàng · Trưởng BP Mua hàng | sửa | Mọi nhà máy |
| 12 | tt · Chọn hình thức thanh toán PO: Trả trước / Cọc + trả nốt trước giao / Trả sau N ngày (→ Chờ duyệt) | Mua hàng · Trưởng BP Mua hàng | sửa | Mọi nhà máy |
| 12 | d3 · Duyệt / từ chối PO (từ chối bắt buộc lý do) | Trưởng BP Mua hàng | duyệt | Mọi nhà máy |
| 12 | c2 · Duyệt thêm PO trên ngưỡng (mặc định 100 triệu) | Giám đốc | duyệt | Mọi nhà máy |
| 12 | gp · Gửi PO cho NCC qua email (→ Đã gửi NCC) | Mua hàng · Trưởng BP Mua hàng | sửa | Mọi nhà máy |
| 12 | hp · Hủy PO (bắt buộc lý do; đã gửi NCC thì email báo hủy): PO chưa duyệt — Mua hàng hoặc Trưởng BP Mua hàng; PO đã duyệt — chỉ Trưởng BP Mua hàng | Mua hàng · Trưởng BP Mua hàng | hủy | Mọi nhà máy |
| 12 | dl · Đóng phần còn lại của PO giao thiếu (bắt buộc lý do) → Đã đóng, phần chưa giao về Hàng đợi mua | Trưởng BP Mua hàng | hủy | Mọi nhà máy |
| 12 | d4, t6 · Ghi nhận đã trả trước / cọc / trả nốt theo PO (số tiền, ngày, CK / tiền mặt, ảnh chứng từ; không duyệt) | Kế toán | tạo | Mọi nhà máy |
| 12 | t8 · Ghi nhận đã trả NCC khoản trả sau (giảm khoản phải trả) | Kế toán | tạo | Mọi nhà máy |
| 12 | y5 · Theo dõi PO nhận một phần, giao trễ / thiếu | Mua hàng | xem | Mọi nhà máy |
| 13 | t1 · Ghi nhận hàng lỗi chờ trả (để riêng ngoài hệ thống) | Thủ kho · Thủ kho điều phối | tạo | Kho |
| 13 | t2 · Tạo phiếu trả hàng NCC (hệ thống KHÓA lô ĐẠT, lý do hàng hư chờ trả NCC) | Mua hàng | tạo | Mọi nhà máy |
| 13 | d1, d2 · Ghi kết quả NCC: chấp nhận / đổi 1-1 / giảm công nợ (PO trả trước không chọn được giảm công nợ) | Mua hàng | sửa | Mọi nhà máy |
| 13 | n1, n2, nd · Biên bản không thống nhất; ghi kết quả nhà máy tự giải quyết (hệ thống chỉ ghi nhận) | Mua hàng | tạo, sửa | Mọi nhà máy |
| 13 | tx · Gửi yêu cầu xuất trả (phiếu trả → Chờ duyệt xuất trả); chặn trả vượt SL đã nhận của PO | Mua hàng | sửa | Mọi nhà máy |
| 13 | dx · Duyệt yêu cầu xuất trả (→ Chờ kho xuất trả) / từ chối bắt buộc lý do (→ Mở); không tự duyệt yêu cầu mình gửi (24/10 đợt 6) | Trưởng BP Mua hàng | duyệt | Mọi nhà máy |
| 13 | t3 · Lập phiếu xuất loại "trả NCC" theo yêu cầu, đúng lô trên phiếu trả (phiếu xuất vào thẳng Chờ lấy hàng — 24/10 đợt 6); xuất xong → Đã xuất trả | Thủ kho | tạo | Kho |
| 13 | t6 · Nhập hàng đổi về như hàng mua (QT14) | Thủ kho | tạo | Kho |
| 13 | t4 · Ghi nhận giảm trừ khoản phải trả NCC | Kế toán | sửa | Mọi nhà máy |
| 13 | t5 · Ký xác nhận, gửi giấy tờ cho kế toán | Mua hàng | sửa | Mọi nhà máy |

### Mảng 4 · Kho

| QT | Bước | Vai trò | Thao tác | Phạm vi |
|---|---|---|---|---|
| 14 | d0, t1 · Nhận hàng: quét đơn mua (phiếu điền sẵn theo PO) hoặc mở phiếu Chờ nhận hàng hệ thống tự sinh; đối chiếu chứng từ | Thủ kho · Thủ kho điều phối | tạo | Kho |
| 14 | d1 · Thiếu chứng từ → từ chối ở cửa kho (không tạo lô) | Thủ kho | hủy | Kho |
| 14 | t2 · Báo NCC, tạo phiếu gửi NCC | Mua hàng | tạo | Mọi nhà máy |
| 14 | l1 · Nhập số lô NCC, NSX, HSD, tải file đánh giá bên ngoài | Thủ kho | tạo | Kho |
| 14 | t3, kb · Kiểm ngoại quan từng bao, ghi bao hư, biên bản | Thủ kho · Thủ kho điều phối | tạo | Kho |
| 14 | nr · Phiếu báo lỗi NCR cho bao hư từ SX | Kế hoạch | tạo | Nhà máy |
| 14 | k1, k3, k6, k7 · Chọn dòng hàng, in / dán / quét tem (NVL mua), quét tem có sẵn (thùng BTP — dán lúc đóng thùng, bao bột dư, khách trả, thu hồi, chuyển kho), dán lại tem nhầm | Thủ kho · Thủ kho điều phối | tạo, sửa | Kho |
| 14 | d4 · Xác nhận chênh lệch khi nhập (SL nhận khác dự kiến / có bao hư) → nhập theo SL thực; hoặc yêu cầu đếm lại (bắt buộc lý do). Phiếu khớp tự Đã nhập, không duyệt (24/10 đợt 7) | Thủ kho trưởng | duyệt | Kho |
| 14 | t4 · Lưu hóa đơn / chứng từ của phiếu nhập NVL mua đã nhập: số hóa đơn, tệp, bản cứng | Kế toán | tạo | Mọi nhà máy |
| 15 | s · Yêu cầu xuất: bán / SX / chuyển kho / trả NCC | Sales (bán) · Kế hoạch (SX — lệnh SX là yêu cầu; chuyển kho) · Thủ kho (lập phiếu xuất trả NCC theo yêu cầu xuất trả; phiếu xuất SX do máy chủ nhà máy tự lập khi lệnh phát sang khu — đợt 10) · Mua hàng (trả NCC: gửi yêu cầu xuất trả từ phiếu trả QT13) | tạo | Theo vai trò |
| 15 | dq0, dq1 · Xuất phần có / hủy yêu cầu; phiếu Chờ bên yêu cầu (thiếu, không có lô thay thế): nhận phần đã lấy (→ Xuất một phần) hoặc hủy (→ Đã hủy) — chỉ bên yêu cầu | Bên yêu cầu (như s) | sửa, hủy | Theo vai trò |
| 15 | t2, t3, d4 · Lấy hàng theo phiếu, quét, lấy lại bao sai, báo hết hàng | Thủ kho · Thủ kho điều phối | sửa | Kho |
| 15 | t4 · Cất lại hàng đã lấy, phiếu → Đã hủy | Thủ kho · Thủ kho điều phối | hủy | Kho |
| 15 | xt · Xem tồn kho của kho mình có nhập / xuất (Kho › Tồn kho; bản cloud chỉ xem, ghi "tính đến …") | Sales · Kế hoạch · Mua hàng · Kế toán · Thủ kho trưởng | xem | Theo vai trò |
| 15 | xp · Xem phiếu xuất của kho mình (phiếu xuất không duyệt — 24/10 đợt 6) | Thủ kho trưởng | xem | Kho |
| 16 | s, y0 · Gửi yêu cầu chuyển liên nhà máy YCC- (nhà máy nhận), rút yêu cầu chưa lên phiếu (mọi yêu cầu chuyển kho do Kế hoạch gửi, không phải Thủ kho) | Kế hoạch | tạo, hủy | Nhà máy |
| 16 | yl · Nhà máy nguồn: gom yêu cầu chuyển, lập phiếu chuyển — lập phiếu là chấp nhận (bỏ Thủ kho trưởng xác nhận — 30/10); lập một phần; từ chối (bắt buộc lý do); hủy phiếu chưa xuất (yêu cầu về Chờ lập phiếu) | Kế hoạch | tạo, hủy | Nhà máy |
| 16 | yn · Lập tay phiếu chuyển nội bộ ngoài phiếu theo lệnh; lập phiếu từ yêu cầu chuyển nội bộ (nếu có) | Kế hoạch · Thủ kho điều phối | tạo | Nhà máy · kho điều phối |
| 16 | r1, g1 · Xuất hàng, quét bao → phiếu (chuyển cho kho điều phối: thủ kho kho tổng) | Thủ kho (kho xuất) | tạo | Kho |
| 16 | kx · Không thực hiện được (lý do bắt buộc) → phiếu Đã hủy | Thủ kho (kho xuất) | hủy | Kho |
| 16 | t1 · Chuyển hàng, truy vết chuyến xe | Vận chuyển | sửa | Chuyến được giao |
| 16 | d3, t3, d4 · Nhận hàng, quét, ký nhận, đối chiếu phiếu (NVL cho SX: Thủ kho điều phối) | Thủ kho · Thủ kho điều phối (kho nhận) | sửa | Kho |
| 16 | t4 · Biên bản chênh lệch; quét bao hư (ĐẠT → KHÓA từng bao, lý do hư khi nhận) | Thủ kho · Thủ kho điều phối (kho nhận) | tạo | Kho |
| 16 | t4 · Chọn hàng hư gửi QC hay hủy | Thủ kho trưởng (kho nhận) | duyệt | Kho |
| 16 | t2 · Xử lý trễ; tìm hàng thiếu trong 7 ngày | Kế hoạch | sửa | Nhà máy |
| 16 | g3 · Lập biên bản thất lạc | Kế hoạch | tạo | Nhà máy |
| 16 | gx · Xác nhận biên bản thất lạc (phần thất lạc → HỦY); không xác nhận thì tìm tiếp | Thủ kho trưởng (kho xuất) | duyệt | Kho |
| 17 | d1 · Ra lệnh kiểm toàn kho | Thủ kho trưởng | tạo | Kho |
| 17 | t2, d2, t3 · Đếm, đối chiếu, ghi chênh lệch (kiểm toàn kho) | Thủ kho · Thủ kho điều phối | tạo | Kho |
| 17 | p2, p3, p6 · Đếm lại lô lệch, ghi chênh lệch (kiểm điểm) | Thủ kho · Thủ kho điều phối | tạo | Kho |
| 17 | d3, p4 · Duyệt điều chỉnh tồn (toàn kho và kiểm điểm) | Thủ kho trưởng | duyệt | Kho |
| 17 | t4 · In báo cáo gửi các bên | Thủ kho · Thủ kho điều phối | xem | Kho |
| 17 | t1 · Nhận thông báo kiểm kho (cột "Các bộ phận") | Mọi vai trò có nhập / xuất ở kho đó | xem | Kho |
| 18 | t1, d1 · Kiểm tra, phát hiện hàng lỗi / hết hạn | Thủ kho · Thủ kho điều phối | tạo | Kho |
| 18 | t2 · Tạo phiếu hủy (phần trên phiếu → KHÓA chờ hủy) | Thủ kho · Thủ kho điều phối | tạo | Kho |
| 18 | d2 · Xác nhận phiếu hủy | Thủ kho trưởng | duyệt | Kho |
| 18 | xr · Từ chối phiếu hủy (lô chờ hủy → về trạng thái trước / gửi QC); lô hết hạn chỉ dời ngày hủy | Thủ kho trưởng | duyệt, sửa | Kho |
| 18 | t3 · Hủy mẫu lưu liên quan | QC | hủy | Nhà máy |
| 18 | t4 · Thực hiện hủy, lập biên bản (lô → HỦY) | Thủ kho · Thủ kho điều phối | hủy | Kho |
| 18 | t5 · Ghi giá trị hàng hủy vào phiếu hủy (chỉ ghi nhận, không hạch toán) | Kế toán | sửa | Mọi nhà máy |

### Mảng 5 · Sản xuất

| QT | Bước | Vai trò | Thao tác | Phạm vi |
|---|---|---|---|---|
| 19 | t1, y1 · Tạo lệnh SX trên cloud từ tab Chờ lên lệnh, hoặc lệnh sản xuất tồn kho không theo đơn (04/11), theo các điều kiện (khu, nhu cầu: 1 mã SP + dòng đơn & số lon hoặc kế hoạch tồn kho, công thức, thời gian, số mẻ & KL mẻ ≤ tối đa của khu, % hao hụt (05/11), dàn silo; tồn NVL thiếu vẫn tạo được — lệnh Chờ NVL, không giữ chỗ, không phát, 24/10 đợt 12), kế hoạch nhãn hiệu của lệnh BTP (SP có hồ sơ công bố hiệu lực, mẫu nhãn đã duyệt — 04/11) (không tạo lệnh ở server nhà máy — không vai trò nào có quyền này) | Kế hoạch | tạo | Nhà máy |
| 19 | ys · Phương án dàn silo: nhận gợi ý xếp NVL → silo, kéo thả chỉnh, chốt khi tạo lệnh; xếp lại khi silo chuyển bảo trì / ngừng dùng | Kế hoạch | tạo, sửa | Nhà máy |
| 19 | t2 · Bổ sung / từ chối khi chưa đủ điều kiện tạo lệnh | Kế hoạch | sửa | Nhà máy |
| 19 | q1 · Hàng đợi phát lệnh của khu: đổi thứ tự ưu tiên | Kế hoạch | sửa | Nhà máy |
| 19 | y2 · Phát lệnh đầu hàng đợi xuống server nhà máy | Kế hoạch | duyệt | Nhà máy |
| 19 | su · Sửa lệnh Mới tạo (số mẻ, KL mẻ, ngày, nhãn hiệu, dàn silo); lệnh đã phát không sửa — hủy rồi tạo lại (QT08 r2) | Kế hoạch | sửa | Nhà máy |
| 19 | hl · Hủy lệnh chưa chạy, bắt buộc lý do, giải phóng giữ chỗ: Mới tạo / Chờ phát hủy ngay; Đã nhận chờ nhà máy xác nhận chưa chạy mẻ; nhà máy mất mạng thì chặn, thử lại khi có kết nối (04/11) (QT07 h4) | Kế hoạch | hủy | Nhà máy |
| 19 | kt · Kết thúc sớm lệnh đang chạy (lý do, sau khi mẻ đang chạy xong): lệnh → Hoàn thành với số mẻ thực tế, giải phóng giữ chỗ còn lại, bột dư silo về kho điều phối | Kế hoạch | sửa | Nhà máy |
| 19 | kr · Kiểm tra lại NVL trên lệnh (lệnh Chờ NVL / kho điều phối thiếu): đủ thì giữ chỗ / cho phát (24/10 đợt 11, 12) | Kế hoạch | sửa | Nhà máy |
| 19 | dc, yd, d2 · Kho điều phối thiếu NVL so với KG giữ chỗ (khi tạo / phát lệnh): hệ thống tự lập phiếu chuyển nội bộ kho tổng → kho điều phối đúng phần thiếu, vào thẳng Chờ xuất; Kế hoạch theo dõi trong màn Lệnh SX (bỏ bước Kế hoạch gửi tg — 30/10) | Kế hoạch | xem | Nhà máy |
| 19 | cb · Chọn cách bù phần thiếu NVL (Mua / chuyển kho liên nhà máy / lùi ngày) khi tạo lệnh và ở màn Cân đối NVL (04/11) | Kế hoạch | sửa | Nhà máy |
| 19 | r1 · Chuyển kho tổng → kho điều phối: thủ kho kho tổng xuất, Thủ kho điều phối nhận & quét | Theo QT16 | — | — |
| 19 | kp · Nhận báo phát lệnh không tới | Kế hoạch | xem | Nhà máy |
| 19 | kf · Xử lý xung đột ngoại tuyến (lệnh khóa lô tới muộn: thu hồi → hồ sơ thu hồi, khoanh vùng → QC kiểm lại; lô HỦY bị dùng → sửa SL thực hủy; tồn âm → kiểm kho) | Kế hoạch · QC | sửa | Nhà máy |
| 19 | xl · Xem lệnh SX và KG giữ chỗ để chuẩn bị NVL (kho điều phối) / xuất chuyển kho tổng → kho điều phối (kho tổng) | Thủ kho · Thủ kho điều phối | xem | Kho |
| 20 | t0, t1 · Lấy hàng theo phiếu xuất SX hệ thống tự lập khi lệnh phát sang khu (quét, giao cho khu; không lập tay — 24/10 đợt 10); không xuất SX thẳng từ kho tổng | Thủ kho điều phối | tạo, sửa | Kho điều phối |
| 20 | t2 · Nhấn Start trên PC C# | Công nhân | sửa | Khu HH / BTP |
| 20 | t3, x1, t4 · Quét QR bao nạp silo, nạp bổ sung khi silo vơi (ghi liên kết lô → silo của lệnh), trả bao sai, đổ bao | Công nhân | tạo | Khu HH / BTP |
| 20 | vs · Xác nhận silo đã xả sạch giữa lệnh (mốc tách truy xuất) | Công nhân | sửa | Khu HH / BTP |
| 20 | h3, b4, h6 · Móc bột silo / bồn, khắc phục sự cố cảm biến (ghi vào hồ sơ mẻ) | Công nhân | sửa | Khu HH / BTP |
| 20 | ha · Bù / bớt bột tới đúng KL, cân lại | Công nhân | sửa | Khu HH |
| 20 | h9 · Dán QR bao HH (bao → ĐẠT, không QC) | Công nhân | tạo | Khu HH |
| 20 | h11 · Chuyển bao HH về kho điều phối / kho BTP | Theo QT16 | — | — |
| 20 | hx · Báo sự cố không khắc phục được | Công nhân | tạo | Khu HH / BTP |
| 20 | kh · Quyết hủy mẻ, ghi lý do, số kg bột bỏ | Kế hoạch | hủy | Nhà máy |
| 20 | kb · Thêm 1 mẻ bù vào lệnh đang chạy | Kế hoạch | sửa | Nhà máy |
| 20 | xd · Hết lệnh / kết thúc sớm: xả bột dư từng silo vào bao, dán QR (lô NVL dư), giao kho điều phối (nhập ở QT14) | Công nhân | tạo | Khu HH / BTP |
| 20 | xm · Xem theo dõi mẻ, tiến độ lệnh | QC | xem | Nhà máy |
| 21 | t1 · Mở van bướm, cấp bột xuống máy chiết | Công nhân | sửa | Khu chiết rót |
| 21 | q1, xq · Quét lon đầu từng nhãn hiệu, đổi lon sai rồi quét lại | Công nhân | tạo, sửa | Khu chiết rót |
| 21 | xl · Loại lon lệch KL, chiết bù | Công nhân | hủy | Khu chiết rót |
| 21 | t2 · Chuẩn bị thùng, lon theo nhãn hiệu | Công nhân | sửa | Khu chiết rót & đóng gói |
| 21 | t4, dt · Bỏ lon vào thùng, xác định thùng đủ | Công nhân | sửa | Khu chiết rót & đóng gói |
| 21 | tx · Thùng thiếu kg: mở thùng, đếm lại, bổ sung (hệ thống sửa số lon của thùng) | Công nhân | sửa | Khu chiết rót & đóng gói |
| 21 | t7 · Dán băng keo, dán QR thùng (ghi thùng → nhãn hiệu / lô) | Công nhân | tạo | Khu chiết rót & đóng gói |
| 21 | t9 · Nhận thùng về kho BTP theo phiếu nhập tự sinh, quét (lệch → Thủ kho trưởng xác nhận ở QT14) | Thủ kho (kho BTP) | tạo | Kho BTP |
| 21 | t8 · Lấy mẫu từng lô sau khi thùng đã nhập kho BTP | QC | tạo | Nhà máy |

### Mảng 6 · Chất lượng

| QT | Bước | Vai trò | Thao tác | Phạm vi |
|---|---|---|---|---|
| 22 | t1, t2 · Gửi yêu cầu kiểm lô NVL nghi lỗi (ĐẠT / KHÓA → CHỜ KIỂM); bổ sung, gửi lại khi QC trưởng yêu cầu | Thủ kho · Thủ kho điều phối · Kế hoạch | tạo, sửa | Kho · nhà máy |
| 22 | d1 · Duyệt / từ chối / yêu cầu bổ sung yêu cầu kiểm (từ chối → lô về trạng thái trước) | QC trưởng | duyệt | Nhà máy |
| 22 | t3 · Lấy 2 mẫu | QC | tạo | Nhà máy |
| 22 | g1 · Tải file đánh giá bên ngoài, đề xuất kết luận | QC | tạo | Nhà máy |
| 22 | d2 · Duyệt kết luận (CHỜ KIỂM → ĐẠT / KHÔNG ĐẠT) | QC trưởng | duyệt | Nhà máy |
| 22 | t4 · Báo Mua hàng lô KHÔNG ĐẠT | QC trưởng | xem | Nhà máy |
| 22 | ym · Mở lại lô NVL KHÔNG ĐẠT (lý do + file, chặn khi hết hạn) | QC trưởng | sửa | Nhà máy |
| 22 | xq · Xem yêu cầu kiểm và kết quả phiếu kiểm của lô mình gửi (QT22, QT23) | Thủ kho · Thủ kho điều phối · Thủ kho trưởng · Kế hoạch | xem | Theo vai trò |
| 23 | t1, t2 · Gửi yêu cầu kiểm (khách trả, khoanh vùng, xung đột, hư khi nhận, tìm lại), bổ sung thông tin | Thủ kho · Thủ kho điều phối · Kế hoạch | tạo, sửa | Kho · nhà máy |
| 23 | d1 · Duyệt / từ chối / yêu cầu bổ sung (BTP mới nhập chỉ được yêu cầu bổ sung) | QC trưởng | duyệt | Nhà máy |
| 23 | t3 · Lấy 2 mẫu | QC | tạo | Nhà máy |
| 23 | yq · Tải file đánh giá bên ngoài, đề xuất kết luận | QC | tạo | Nhà máy |
| 23 | d2 · Duyệt kết luận (BTP → TP ĐẠT / KHÔNG ĐẠT) | QC trưởng | duyệt | Nhà máy |
| 23 | gk · Ký phiếu chứng nhận chất lượng xuất xưởng (phiếu Chờ ký → Đã ký; ký riêng sau khi duyệt kết luận d2 — 04/11) | QC trưởng | duyệt | Nhà máy |
| 23 | t4 · Báo Kế hoạch, Kho | QC trưởng | xem | Nhà máy |
| 23 | dg, d3 · Mọi lô TP của đơn đã ĐẠT? Lô TP đã giao một phần? — hệ thống tự kiểm, không cần người quyết (sơ đồ đặt ở cột QC, Kế hoạch) | Hệ thống | — | — |
| 23 | r1 · Tạo lệnh mới từ NVL để bù đơn | Kế hoạch | tạo | Nhà máy |
| 23 | xc · Xem / tải phiếu chứng nhận (gửi khách khi giao; xem ở Đơn hàng › tab Giao hàng) | Sales · Kế hoạch · QC | xem | Theo vai trò |
| 24 | t1 · Lấy 2 mẫu | QC | tạo | Nhà máy |
| 24 | t2 · Tạo mã mẫu lưu | QC | tạo | Nhà máy |
| 24 | t3 · Niêm phong, lưu ở kho mẫu lưu QC (ghi nơi lưu — 04/11) | QC | sửa | Nhà máy |
| 24 | lr, np · Lấy mẫu ra đánh giá (lý do), niêm phong lại (kết quả đánh giá) (04/11) | QC | sửa | Nhà máy |
| 24 | sh · Sửa hạn lưu (lý do) (04/11) | QC | sửa | Nhà máy |
| 24 | g1 · Thời hạn lưu mẫu: QC tự quyết, phần mềm ghi nhận | QC | tạo, sửa | Nhà máy |
| 24 | d1, t4 · Hết hạn lưu: tự hủy mẫu, lập biên bản (không cần duyệt) | QC | hủy | Nhà máy |

### Mảng 7 · Truy xuất & thu hồi

| QT | Bước | Vai trò | Thao tác | Phạm vi |
|---|---|---|---|---|
| 25 | t1 · Tạo phiếu truy xuất (mã đầu vào: số lô, QR, mã đơn hàng, mã khách, mã NVL — 04/11), chạy truy xuất ngược / xuôi, xuất báo cáo (chỉ vai trò này) | Người truy xuất | tạo | Mọi nhà máy |
| 25 | t3 · Biên bản chênh lệch cân bằng khối lượng | Thủ kho · Thủ kho điều phối | tạo | Kho |
| 25 | r0 · Kiểm điểm lô lệch (QT17) | Thủ kho · Thủ kho trưởng (theo QT17) | — | Kho |
| 26 | o1 · Mở hồ sơ thu hồi khi có kết luận lỗi cả lô (hệ thống khóa cả lô ngay) — chỉ vai trò này | QC trưởng | tạo | Nhà máy |
| 26 | r1 · Truy xuất lô nghi lỗi | Người truy xuất | tạo | Mọi nhà máy |
| 26 | q1 · Đánh giá rủi ro, phạm vi, đề xuất thu hồi / khoanh vùng | QC trưởng | tạo | Nhà máy |
| 26 | d1 · Ký quyết định thu hồi / khoanh vùng (thu hồi → lý do khóa đổi thành "thu hồi") | Giám đốc | duyệt | Mọi nhà máy |
| 26 | t0 · Báo cơ quan quản lý, cập nhật tiến độ | QC trưởng | tạo | Nhà máy |
| 26 | t1 · Thông báo khách / đại lý theo danh sách truy xuất | CSKH | sửa | Mọi nhà máy |
| 26 | r2 · Nhập kho hàng thu hồi (lô giữ KHÓA) | Thủ kho · Thủ kho trưởng (theo QT14) | — | Kho |
| 26 | r4 · Hủy hàng thu hồi | Thủ kho · Thủ kho trưởng (theo QT18) | — | Kho |
| 26 | t3 · Đổi lô mới (đơn thay thế QT05) / đề nghị hoàn tiền (Kế toán ghi nhận ở QT10) | Sales | tạo | Mọi nhà máy |
| 26 | t3 · Duyệt số tiền hoàn khi thu hồi (như hủy đơn) | Giám đốc · Kế toán trưởng (một người là đủ) | duyệt | Mọi nhà máy |
| 26 | q3 · Nguyên nhân gốc, hành động khắc phục (NCR / CAPA) | QC | tạo | Nhà máy |
| 26 | qa · Duyệt nguyên nhân gốc, hành động khắc phục (CAPA) | QC trưởng | duyệt | Nhà máy |
| 26 | gd · Duyệt đóng hồ sơ thu hồi | Giám đốc | duyệt | Mọi nhà máy |

### Quyết định đã chốt 17/10

1. Bộ phận SX khi gửi yêu cầu xuất kho, yêu cầu chuyển kho, yêu cầu QC kiểm là Kế hoạch.
2. Tem lỗi phát hiện ở khu SX: công nhân chỉ báo, thủ kho kho điều phối xử lý.
3. Phiếu báo lỗi NCR khi SX giao hàng có bao hư vào kho: Kế hoạch lập.
4. Tách CSKH và R&D thành vai trò riêng (19 vai trò).
5. QC trưởng báo cơ quan khi thu hồi; thủ kho lập biên bản chênh lệch khi truy xuất.
6. Giám đốc duyệt đóng hồ sơ thu hồi; QC trưởng duyệt CAPA; phiếu trả hàng NCC không cần duyệt thêm; Trưởng BP Mua hàng hủy PO đã duyệt; Kế toán trưởng duyệt mọi phiếu chi, phiếu thu không duyệt; QC tự hủy mẫu lưu hết hạn, không cần duyệt; số tiền hoàn khi thu hồi do Giám đốc hoặc Kế toán trưởng duyệt như hủy đơn.
7. Bỏ bước QC đánh giá mẫu khi duyệt NCC.
8. Mã danh mục do hệ thống tự sinh theo định dạng cấu hình sẵn của từng loại, không có bước duyệt.
9. Giữ: Kế hoạch tự tạo và phát lệnh SX; QC trưởng một mình mở lại lô NVL KHÔNG ĐẠT; Thủ kho trưởng chọn hủy hàng hư rồi xác nhận phiếu hủy; công nhân sửa số lon của thùng. Thêm: Thủ kho trưởng xác nhận biên bản thất lạc trước khi hàng thành HỦY; chỉ QC trưởng mở hồ sơ thu hồi.
10. HR và Admin không tự sửa vai trò của chính mình; chỉ Admin gán vai trò Admin; ~~Trưởng BP khi rà soát được gỡ vai trò, khóa tài khoản trực tiếp~~ (bỏ rà soát 28/10).
11. Giữ nguyên quyền Trưởng BP Mua hàng; ~~Admin toàn quyền~~ (thay bằng quyết định 20/10 số 1); thêm ủy quyền tạm có ngày hết hạn.
12. Hạn mức và số tiền hoàn: Giám đốc hoặc Kế toán trưởng, một người duyệt là đủ, số tiền do người duyệt tự nhập.
13. Thời hạn lưu mẫu: QC tự quyết, phần mềm ghi nhận (sửa 26/10: bỏ điều kiện bảo quản phòng mẫu, không ghi tủ / ngăn). Các bước vận hành mẻ, chiết rót giữ người làm là công nhân như sơ đồ.
14. Đã sửa sơ đồ cho khớp: lấy mẫu lưu do QC; đánh giá rủi ro thu hồi do QC trưởng; chuẩn bị NVL trước mẻ do kho điều phối; nhấn Start do công nhân. QT26 tách cột riêng cho Giám đốc, QC trưởng, CSKH, Sales.

15. Hủy mẻ do sự cố không khắc phục được: công nhân báo, Kế hoạch quyết hủy (ghi lý do, số kg bỏ), bột hỏng đi hủy hàng, Kế hoạch thêm 1 mẻ bù vào lệnh đang chạy.
16. Định dạng mã danh mục: chốt theo đề xuất ở biểu mẫu Danh mục (thêm nhóm HHP cho nguyên liệu hỗn hợp; mỗi nhà máy 1 kho mỗi loại); Admin sửa được trong cấu hình.

### Quyết định đã chốt 19/10

1. Sales xem được công nợ, hạn mức, lịch sử thanh toán của khách (chỉ xem).
2. Bỏ Kế toán trưởng duyệt phiếu chi: hoàn tiền, trả NCC, hoàn tiền thu hồi chỉ ghi nhận (Kế toán). Số tiền hoàn khi hủy đơn / thu hồi vẫn do Giám đốc hoặc Kế toán trưởng quyết. Kế toán trưởng xem được mọi công nợ.
3. Bỏ GĐ / KTT xóa nợ trong hệ thống: công nợ quá 90 ngày quyết bên ngoài, Kế toán ghi kết quả.
4. ~~Màn Vai trò × quyền chỉ để xem; đổi quyền = sửa mục này rồi sinh lại dữ liệu nạp.~~ **Bỏ 04/11** — Admin sửa quyền trên màn Vai trò × quyền (QT01 vq).
5. Vai trò ủy quyền tạm được: Giám đốc, Kế toán trưởng, Thủ kho trưởng, Trưởng BP Mua hàng, QC trưởng, Kế hoạch (bỏ Trưởng bộ phận 28/10).
6. Duyệt ngừng dùng mã NVL / SP hiện trong Việc cần làm; người đề xuất rút được đề nghị khi đang chờ duyệt. Sửa 28/10: người duyệt là Trưởng BP Mua hàng / Thủ kho trưởng / QC trưởng theo bên đề xuất; Kế hoạch tự ngừng, không qua duyệt.
7. Nhà máy, khu vực làm việc, kho: Admin tạo / sửa / ngừng dùng. Bỏ vị trí kệ (24/10): tồn theo lô × kho, không quản lý ô kệ.
8. ~~Rà soát hằng quý theo từng tài khoản: Trưởng BP quyết từng dòng rồi xác nhận cả bộ phận, không tự quyết dòng của mình; HR chỉ theo dõi, nhắc.~~ **Bỏ 28/10** — không rà soát quyền định kỳ.
9. (đợt 2) Admin tạo / sửa khu vực làm việc (loại khu, khối lượng mẻ tối đa) và dàn silo của khu HH / BTP (thêm, sửa, bảo trì, ngừng dùng) — QT02 ka, ks.
10. (đợt 2) Kế hoạch tạo lệnh, xếp dàn silo, xếp hàng đợi phát lệnh từng khu, phát lệnh đầu hàng, hủy lệnh chưa chạy (bắt buộc lý do) — QT19 t1, ys, q1, y2, hl.
11. (đợt 2) Không còn máy quét riêng: Thủ kho đăng nhập web bằng mã NV + mật khẩu, quét mã ngay trên màn Kho; quét thẻ NV chỉ ở PC xưởng (công nhân). Sự cố tem làm ở Kho · Tồn kho.
12. (đợt 2) Kế hoạch lập yêu cầu mua; Mua hàng lấy báo giá, hủy báo giá (bắt buộc lý do) — ~~yêu cầu mua, báo giá~~ bỏ 04/11 (Hàng đợi mua, QT12); Mua hàng gửi yêu cầu xuất trả NCC; Thủ kho lập phiếu xuất trả NCC, Thủ kho trưởng duyệt; Kế toán ghi giảm trừ ở Công nợ NCC.
13. (đợt 2) Phiếu xuất "Chờ bên yêu cầu": chỉ bên yêu cầu (Sales — bán, Kế hoạch — SX / chuyển kho, Mua hàng — trả NCC) chọn nhận phần đã lấy hoặc hủy.
14. (đợt 3) Kế hoạch sửa lệnh Mới tạo (QT19 su), hủy lệnh chưa chạy (hl — chỉ hủy, đã phát thì chờ nhà máy xác nhận), kết thúc sớm lệnh đang chạy (kt). Không có quyền sửa lệnh đã phát.
15. (đợt 3) Công nhân xác nhận silo xả sạch giữa lệnh (QT20 vs) và xả bột dư cuối lệnh (xd); thủ kho kho điều phối nhập bột dư như NVL dư (QT14).

**Đợt 4 (tối 19/10)** — chốt 7 câu "Cần chốt nghiệp vụ" của bản rà soát mockup:

16. NVL cho sản xuất đi qua kho điều phối: kho tổng → chuyển kho (QT16) → kho điều phối → kho điều phối chuẩn bị NVL theo lệnh và xuất cho khu; phiếu xuất SX lập từ kho điều phối (QT15, thủ kho kho điều phối). Không xuất SX thẳng từ kho tổng. Giữ chỗ vẫn theo KG của lệnh, không gắn lô (lô chọn khi xuất, FEFO).
17. Khi tạo / phát lệnh mà kho điều phối thiếu so với KG giữ chỗ, hệ thống tự lập đề nghị chuyển kho tổng → kho điều phối đúng phần thiếu; Kế hoạch gửi ngay trong màn Lệnh SX (QT19 dc, yd, tg, d2; QT16 ya, kg). Thủ kho kho tổng xuất, thủ kho kho điều phối nhận & quét. Người yêu cầu chuyển kho là Kế hoạch — mọi yêu cầu chuyển kho khác cũng do Kế hoạch lập; đã sửa bảng Mảng 5 (trước ghi Thủ kho kho điều phối) và QT15 s.
18. Lô nghi lỗi gửi QC → CHỜ KIỂM (QT22 y1), không KHÓA; lô CHỜ KIỂM không tính tồn khả dụng, không xuất được. KHÓA lý do khoanh vùng chỉ dùng trong hồ sơ thu hồi (QT26).
19. Dòng sản phẩm / Quy cách đóng gói / Hạng / Thương hiệu là danh mục chính thức thuộc Danh mục › Sản phẩm (QT02): thêm / sửa như NVL, SP (mã tự sinh, không duyệt), ngừng dùng như NVL / SP (trưởng bên đề xuất duyệt, Kế hoạch tự ngừng), chặn khi còn SP đang dùng. Nhà cung cấp, Kho, Nhà máy là màn trong Danh mục (Danh mục › Nhà cung cấp là danh sách gốc — tạo mới ở trạng thái Chờ duyệt, duyệt ở Mua hàng › Nhà cung cấp theo QT11). Khuôn cũ phiếu nhập (Main, ChiTietPhieu) bỏ — dùng màn Kho › Nhập kho.
20. QC trưởng 15–21/10/2026: Võ Thanh Hà vắng, mọi việc QC trưởng trong khoảng này do Trần Thị Mai làm theo ủy quyền tạm (QT01 u1); trước 15/10 là Võ Thanh Hà.
21. Mọi board mockup dùng một bộ dữ liệu mẫu chung (người, đơn, lệnh, lô, mã chứng từ); chỗ lệch thì board chủ của loại dữ liệu đó thắng.
22. Cơ chế mockup (không phải chức năng sản phẩm): ô "Xem như" để đổi vai trò khi demo; nút ngoài quyền của vai trò đang xem hiện `Việc của <vai trò>` thay vì ẩn; mã chứng từ là link mở đúng phiếu ở màn chủ của nó.

### Quyết định đã chốt 20/10

Chốt sau rà soát phân quyền trên mockup (`mes-powder-ra-soat-vai-tro-20-10.md`), theo cách các ERP lớn làm: có tài khoản toàn quyền kỹ thuật nhưng khóa lại; quản trị viên hằng ngày chỉ quản trị + xem; người cần thấy hết dùng quyền chỉ xem.

1. **Admin không toàn quyền.** Admin quản trị hệ thống: tài khoản, mở khóa, mật khẩu tạm, gán vai trò Admin / Người truy xuất, ủy quyền tạm (QT01); tham số, định dạng mã, đơn vị tính; nhà máy, khu vực làm việc, dàn silo, kho (QT02 ka, ks); nhật ký. Admin xem được mọi màn ở mọi nhà máy (QT01 xa) nhưng không làm bước nghiệp vụ nào khác của QT02–QT26. Người làm Admin cần làm nghiệp vụ thì được gán thêm vai trò đó (HR hoặc Admin khác gán, không tự gán, có nhật ký); ~~rà soát hằng quý đánh dấu tài khoản vừa có Admin vừa có vai trò có quyền duyệt~~ (bỏ rà soát 28/10 — nhật ký tài khoản vẫn ghi việc gán vai trò).
2. **Tài khoản Hệ thống** chỉ dùng cho thao tác tự động, không ai đăng nhập. Chưa làm vai trò truy cập khẩn cấp; người duyệt vắng thì dùng ủy quyền tạm có hạn (QT01 u1).
3. **Giám đốc xem mọi màn** ở mọi nhà máy (QT01 xa), chỉ duyệt đúng các bước của mình.
4. **Kế hoạch hủy yêu cầu mua** khi chưa có báo giá được chọn, bắt buộc lý do (QT12 th). Sửa 04/11: bỏ báo giá — th là hủy nhu cầu lập tay khi chưa lên PO.
5. **Bỏ "Thủ kho yêu cầu xuất cho kho khác"** ở QT15 s: chuyển hàng giữa các kho chỉ qua QT16 (Kế hoạch lập).
6. **Nhắc nợ (QT10 k3)** ghi ở Kế toán › Công nợ KH; Bán hàng › Khách hàng chỉ hiện lịch sử liên hệ.
7. **Thủ kho trưởng** không gửi yêu cầu kiểm — giữ đúng bảng quyền (Thủ kho trưởng duyệt, Thủ kho thao tác).
8. **QT22 thêm nhánh yêu cầu bổ sung** như QT23: QC trưởng yêu cầu bổ sung (thiếu số lô NCC, file đánh giá bên ngoài…) → bên gửi bổ sung, gửi lại.
9. ~~**Thủ kho điều phối không phải vai trò riêng**~~ (**bỏ 04/11** — thành vai trò riêng, xem "Quyết định đã chốt 30/10 – 04/11"): là Thủ kho có phạm vi kho điều phối (NM1-DP…). Mockup vẫn để trong ô "Xem như" cho dễ demo, ghi rõ "Thủ kho @ NM1-DP".
10. **Menu suy ra từ quyền**: một màn hiện trên menu khi vai trò có ít nhất 1 quyền ở các bước của màn đó (bảng `screen_function`, xem mục "Phân hệ & màn hình"); không giữ ma trận menu riêng. Bổ sung quyền xem để menu đúng: CSKH xem khách (QT05 xk), xem danh sách NCC (QT11 xn — Danh mục › Nhà cung cấp không còn hiện cho mọi vai trò), xem tồn kho (QT15 xt), thủ kho kho điều phối xem lệnh SX (QT19 xl — thủ kho kho tổng không thấy Lệnh SX, xem đề nghị chuyển kho ở Kho › Chuyển kho), QC xem theo dõi mẻ (QT20 xm), bên gửi xem yêu cầu / phiếu kiểm của lô mình (QT22 xq), Sales · Kế hoạch · QC xem phiếu chứng nhận (QT23 xc).

### Mất kết nối — chốt 20/10 (đợt 2, thay 16 quyết định sáng 20/10)

Chốt sau bản đánh giá lại theo hướng nhà máy tự vận hành đầy đủ khi mất kết nối cloud, không giới hạn thời gian (phương án B: Kho + Sản xuất + Chất lượng chạy tại máy chủ nhà máy; văn phòng giữ cloud chủ). Đánh số tiếp các quyết định 20/10 ở trên.

11. Máy chủ nhà máy là chủ tồn, trạng thái lô, bao / thùng, chứng từ kho, QC, mẻ của nhà máy mình; cloud giữ bản đồng bộ và là chủ danh mục, tài khoản, đơn, PO, lệnh, yêu cầu xuất bán, thu hồi, truy xuất, kế toán. Mọi tác động của cloud lên dữ liệu nhà máy chủ đi qua kênh lệnh từ trung tâm có xác nhận / từ chối (QT19 kl) — gồm phát / hủy / kết thúc sớm lệnh, hủy mẻ + mẻ bù, khóa / mở khóa lô, khóa tài khoản, silo bảo trì, đổi loại khu, giảm KL mẻ tối đa, yêu cầu xuất, đề nghị chuyển kho.
12. Nhà máy mất mạng thì người ở nhà máy không vào được màn trên cloud; nhưng Kho, Chất lượng, Theo dõi mẻ, Lệnh SX (bản tại nhà máy), Việc cần làm, Đăng nhập, PC xưởng chạy đủ tại máy chủ nhà máy, không giới hạn thời gian. Lệnh đã nhận chạy tới hết; lệnh mới nằm Chờ phát; bỏ "ngoại tuyến tối đa 8 giờ".
13. Kế hoạch ở văn phòng trung tâm; lệnh chỉ tạo trên cloud; nhà máy mất mạng lâu thì chạy hết lệnh đã nhận rồi chờ (không tạo lệnh tại nhà máy).
14. Đăng nhập tại nhà máy bằng mã NV + mật khẩu (băm mật khẩu sao xuống); PC xưởng quét thẻ. Khóa tài khoản là lệnh từ trung tâm, có hiệu lực khi nhà máy có mạng lại.
15. Thủ kho trưởng duyệt phiếu chuyển / hủy / điều chỉnh kiểm kho, xác nhận chênh lệch khi nhập tại nhà máy như bình thường (trừ phiếu xuất — mọi loại vào thẳng Chờ lấy hàng, 24/10 đợt 6; trừ phiếu nhập — chỉ xác nhận chênh lệch, đợt 7). Phiếu xuất bán / trả NCC / chuyển kho chỉ lập từ yêu cầu đã sao xuống trước lúc mất mạng; xuất SX đủ chức năng; thiếu hàng thì gợi ý lô khác cùng NVL, HSD gần nhất (QT15 y3); không có lô thay thế → Chờ bên yêu cầu, xếp chờ gửi lên.
16. Nhập kho tại nhà máy nhận mọi loại có chứng từ đã sao xuống: thùng BTP, bột dư, NVL dư (từ lệnh), NVL mua (theo PO đã duyệt, kèm file đánh giá bên ngoài, kiểm HSD tại chỗ), khách trả (biên bản), thu hồi (hồ sơ), chuyển kho (phiếu). Thiếu chứng từ → từ chối ở cửa kho (QT14 d1). Tem bao bột dư, bao NVL in tại nhà máy.
17. QC và QC trưởng làm việc tại nhà máy khi mất mạng: gửi yêu cầu kiểm, duyệt, lấy mẫu, kết luận, BTP → TP, ký chứng nhận, mẫu lưu; lô đổi trạng thái ngay trên tồn nhà máy, cloud nhận sau. Bỏ "lô nghi lỗi xử lý bằng tay, có mạng gửi QC".
18. Xung đột khi có mạng lại chỉ còn: lệnh khóa lô (thu hồi / khoanh vùng) tới sau khi nhà máy đã dùng / xuất / chuyển phần lô đó; lô HỦY bị dùng; tồn âm. Xử lý theo QT19 kz, kf. Dùng lô CHỜ KIỂM / KHÔNG ĐẠT không còn là xung đột vì nhà máy chặn ngay lúc quét trên tồn thật.
19. Hủy mẻ sự cố: cho Kế hoạch bấm trên cloud cả khi nhà máy mất mạng → lệnh Chờ gửi; nhà máy áp dụng khi mẻ vẫn Dừng sự cố, khác thì từ chối. Kết thúc sớm, silo bảo trì, đổi loại khu, giảm KL mẻ tối đa: như cũ, qua kênh lệnh.
20. Không còn bước Kế hoạch xác nhận lệnh xuống PC xưởng (QT20 d1): máy chủ nhà máy tự kiểm silo không bảo trì, kho điều phối đã xuất đủ NVL, lệnh không bị hủy; thiếu thì báo lý do trên Lệnh SX, Việc cần làm của Kế hoạch, PC xưởng.
21. Thu hồi / khoanh vùng khi nhà máy mất mạng: hồ sơ hiện từng nhà máy "đã áp dụng / chờ nhà máy áp dụng"; QC trưởng gọi điện; có mạng thì nhà máy khóa phần còn, phần đã nạp silo → khóa hàng sinh ra (lý do thu hồi / xung đột), phần đã giao → danh sách khách. Sau 10/11 (chốt đợt 3): chỉ QC trưởng nhà máy khóa cả lô tại chỗ (lý do + ghi chú + ảnh), chặn xuất / nạp silo ngay; không mở tại chỗ — có mạng thì QC trưởng trên cloud gắn hồ sơ thu hồi / khoanh vùng hoặc mở khóa nhầm có lý do.
22. Lô hết hạn khi mất mạng: máy chủ nhà máy tự KHÓA (QT18 yc chạy tại nhà máy); cloud chỉ hiển thị.
23. ~~Đề nghị chuyển kho tổng → kho điều phối tự lập chưa được Kế hoạch gửi khi mất mạng: Thủ kho trưởng kho tổng xác nhận thẳng (QT16 kq); Kế hoạch nhận thông báo khi có mạng.~~ **Bỏ 30/10** — phiếu chuyển theo lệnh vào thẳng Chờ xuất, không còn bước gửi / xác nhận.
24. Chuyển kho giữa 2 nhà máy: phiếu do nhà máy xuất làm chủ, bản sao tới nhà máy nhận qua cloud trước khi xe chạy; nhà máy nhận mất mạng mà chưa có phiếu → hàng để bãi chờ (sau 10/11, chốt đợt 3: "nhận chuyển kho chưa có phiếu" — quét QR / gõ số phiếu trên giấy; lô đã biết, đang đạt dùng ngay, lô lạ chờ đối chiếu; sai số phiếu → Thủ kho trưởng nhà máy nhận chọn lại; lệch hàng → biên bản chênh lệch, Thủ kho trưởng hai nhà máy xác nhận, Kế toán duyệt).
25. Văn phòng xem tồn / tồn khả dụng của nhà máy đang mất mạng: số cũ kèm "tính đến HH:MM — nhà máy X mất kết nối"; vẫn cho tạo lệnh / nhận đơn; thiếu lộ ra lúc xuất SX (Chờ bên yêu cầu). Truy xuất chạy với dữ liệu cũ, kết quả ghi rõ nhà máy nào chưa gửi từ lúc nào.
26. Giao hàng (sửa 24/10 — chỉ ghi nhận): Sales ghi kết quả giao trên cloud (Đơn hàng › tab Giao hàng), không phụ thuộc mạng nhà máy; nhà máy chỉ xuất bán theo yêu cầu xuất bán đã sao xuống.
27. Mã chứng từ sinh tại nhà máy có tiền tố nhà máy (phiếu nhập / xuất / chuyển / kiểm kho / hủy, yêu cầu kiểm, phiếu kiểm, chứng nhận, mẫu lưu; mã mẻ / bao / thùng đã có). Mã danh mục, đơn, PO, lệnh, yêu cầu xuất bán, truy xuất, thu hồi chỉ sinh ở cloud, không đổi.
28. Công nhân xem công thức trên PC xưởng; màn Công thức không hiện cho công nhân trên web. Cảnh báo "lệnh chưa tới nhà máy quá 10 phút", "lệnh từ trung tâm chờ nhà máy áp dụng", "có hàng bị khóa sau khi có mạng lại" hiện trên Lệnh SX, Theo dõi mẻ, Việc cần làm của Kế hoạch (và QC, QC trưởng với hàng bị khóa).
29. (Chốt 20/10 đợt 3) Máy chủ nhà máy giữ bản sao đơn của nhà máy mình và khách của các đơn ấy, không có giá, tiền, liên hệ, công nợ, hóa đơn (dữ liệu: quyết định 38).

### Quyết định đã chốt 30/10 – 04/11

Đồng bộ tài liệu theo mockup (người dùng chốt 04/11: mockup là bản đúng). Ngày ghi theo ghi chú trong mockup; mục không ghi ngày là chốt 04/11. Mỗi mục ghi rõ thay quyết định nào.

1. (30/10, 31/10) **Kiểm COA & hạn dùng của NCC trước khi PO đi duyệt** (QT12 ce, ck, dc, cx): PO lập xong ở Chờ COA & HSD; Mua hàng gửi NCC 1 email yêu cầu COA và hạn dùng, kiểm theo bộ chỉ tiêu COA của NVL; không đạt thì PO Đã hủy, NCC bị khóa cho NVL đó. Duyệt xong gửi PO cho NCC qua email (QT12 gp — thay "gửi NCC (email / in)"). QT14 vẫn nhận file đánh giá bên ngoài theo lô.
2. (31/10) **Hình thức thanh toán PO và NCC thêm "Cọc + trả nốt trước giao"**, kèm bước Chờ chọn thanh toán (QT12 tt) — thay "chỉ Trả trước / Trả sau N ngày" (19/10 đợt 2). Kế toán ghi nhận cọc, trả nốt ở Công nợ NCC (QT12 t6).
3. (30/10) **Yêu cầu chuyển `YCC-`, lập phiếu là chấp nhận** (QT16 y0, yl): nhà máy nhận gửi yêu cầu, Kế hoạch nhà máy nguồn (nội bộ: Thủ kho điều phối) gom theo kho xuất → kho nhận và lập phiếu. Bỏ bước Thủ kho trưởng xác nhận / từ chối yêu cầu chuyển (QT16 d1) và xác nhận thẳng lúc mất mạng (QT16 kq — thay quyết định 20/10 số 23). Phiếu nội bộ theo lệnh SX tự lập vào thẳng Chờ xuất, bỏ bước Kế hoạch gửi (QT16 kg, QT19 tg — thay quyết định 19/10 số 17). Kho xuất không lấy được hàng thì bấm Không thực hiện được (QT16 kx).
4. (30/10) **NVL: nguyên liệu kỵ nhau** (chọn nhiều, quan hệ hai chiều), **tối đa 5 ảnh**; thêm tồn tối thiểu, cách bù khi dưới tồn tối thiểu.
5. (03/11) Đơn hàng: chi tiết một trang, lịch thanh toán ở cột chính, tab Giao hàng luôn có — không đổi bước.
6. **Màn Vai trò × quyền sửa được** (QT01 vq — thay quyết định 19/10 số 4 "chỉ để xem"): Admin sửa quyền, thêm / sửa / xóa quyền, phạm vi nhà máy theo vai trò và theo quyền. **Thêm vai trò Thủ kho điều phối** (thay quyết định 20/10 số 9) — 19 vai trò.
7. **Cho xóa bản ghi chưa từng dùng**: tài khoản chưa đăng nhập / chưa có giao dịch (QT01 xt), đơn vị (QT02 dv), lựa chọn của ô chọn SP, quy cách chưa có tham chiếu (QT02 xo); bản ghi đã dùng vẫn chỉ khóa / ngừng dùng (thay "không xóa, chỉ khóa / ngừng dùng" cho các bản ghi này).
8. **Mô hình sản phẩm mới** (QT02): một mã SP có cấu trúc / nhóm / phân loại / độ tuổi, quy cách đóng gói nhiều cấp, mẫu nhãn từng quy cách — QC trưởng duyệt (QT02 ml), bản công bố. Thay quyết định 20/10 đợt 3 "mỗi quy cách × số lon / thùng là 1 mã SP" và 4 danh mục SP (dòng SP, quy cách đóng gói, hạng, thương hiệu — quyết định 19/10 số 19).
9. **Một nhà máy được nhiều kho điều phối** (`NM1-DP`, `NM1-DP2`…), mỗi khu chọn 1 kho điều phối cấp NVL — thay "mỗi nhà máy 1 kho mỗi loại" (17/10 số 16). Thêm loại kho mẫu lưu QC.
10. **Bỏ báo giá** (QT12): Mua hàng nhập SL, NCC, đơn giá ở Hàng đợi mua rồi lập PO (gộp theo NCC × kho nhận) — thay "lấy báo giá ≥ 2 NCC, bảng so sánh, hủy báo giá" (16/10, 19/10 đợt 2 số 12). Bỏ bước QT12 tq, c1, y2; th đổi nghĩa thành hủy nhu cầu lập tay; Mua hàng trả dòng không mua được về Kế hoạch (tv); Trưởng BP Mua hàng đóng phần còn lại của PO giao thiếu (dl).
11. **Sales hủy thẳng đơn ở Chờ ký HĐ / Chờ thu tiền**, bắt buộc lý do, không qua duyệt (QT05 hn); đơn đã chốt vẫn hủy qua QT07.
12. **MES lập và in hóa đơn bán hàng A4, hóa đơn gắn phiếu xuất** (QT10 t1) — thay 24/10 "hóa đơn xuất ở phần mềm kế toán riêng, Kế toán chỉ thêm số / ngày / file, không gắn phiếu xuất". Tổng quan Giám đốc nhắc "đã giao, chưa có hóa đơn" kèm lối tắt Lập hóa đơn.
13. **NVL bắt buộc ít nhất 1 chỉ tiêu COA** — thay bản bỏ bộ chỉ tiêu COA của NVL (24/10 đợt 3); QC đầu vào (QT22) vẫn chỉ nhận file đánh giá bên ngoài.
14. **Có lệnh sản xuất tồn kho** (không theo đơn — QT19 t1) — thay "chỉ sản xuất theo đơn" (24/10 đợt 8).
15. **Lệnh BTP thêm điều kiện hồ sơ công bố còn hiệu lực và mẫu nhãn đã duyệt** (QT19 tb, d1).
16. **Phiếu chứng nhận ký tách riêng** sau khi duyệt kết luận (QT23 gk): phiếu Chờ ký → Đã ký, số CN- cấp lúc ký; chỉ lô có phiếu đã ký mới giao được — thay "ký phiếu ngay khi duyệt" (QT23 g2 nay chỉ sinh phiếu Chờ ký).
17. **Mẫu lưu**: lấy ra đánh giá, niêm phong lại (QT24 lr, np), sửa hạn lưu (sh), nơi lưu = kho mẫu lưu QC — thay 26/10 "không ghi tủ / ngăn, nơi lưu"; hủy mẫu ghi cách hủy, người chứng kiến, biên bản.
18. **Truy xuất nhận thêm mã đơn hàng, mã khách hàng, mã NVL** (QT25 t1, y1) — thay "chỉ QR hoặc số lô".
19. **Thêm 4 màn**: Tổng quan Giám đốc (QT01 tq), Hồ sơ & biểu mẫu in, Hồ sơ pháp lý chung (QT02 hs, xh), Đơn vị (QT02 dv, xv) — mục "Phân hệ & màn hình".
20. **Menu theo mockup**: Công thức và Khu vực làm việc nằm trong Danh mục; Đơn vị là màn riêng ở Danh mục, nhiều vai trò xem (thay "đơn vị tính trong Tham số, chỉ Admin").
21. **Trạng thái theo mockup** cho đơn hàng, PO, phiếu trả NCC, yêu cầu chuyển và phiếu chuyển, kiểm kho (Khớp), phiếu xuất (thêm Từ chối), mẫu lưu, khách hàng, phiếu chứng nhận — xem từng QT và mục "Biểu mẫu dữ liệu".
22. **Phân quyền theo menu mockup**: Thủ kho (kho tổng) xem Lệnh SX (QT19 xl); Thủ kho trưởng xem tồn kho, phiếu xuất, nhà máy, kho, đơn vị, hồ sơ pháp lý chung (QT15 xt, xp; QT02 xk, xv, xh); Sales xem phiếu hủy hàng của đơn hủy (QT07 h5); Giám đốc tạo / sửa / xóa hồ sơ pháp lý chung (QT02 hs); Mua hàng và Trưởng BP Mua hàng cùng làm các việc PO (ce, ck, tt, gp, hp).
23. **Cân đối NVL** (QT19 cb, theo mockup): phần NVL thiếu chưa có cách xử lý vào màn Cân đối NVL, Kế hoạch chọn Mua / chuyển kho liên nhà máy / lùi ngày; mặc định Mua.
24. (chốt 04/11) **Hủy lệnh SX khi nhà máy mất mạng: chặn**, báo "chưa hủy được, thử lại khi có kết nối" (QT19 hl, yh) — thay 20/10 đợt 2 "lệnh hủy nằm Chờ gửi, giữ chỗ tới khi nhà máy trả lời"; lệnh Chờ phát (nhà máy chưa nhận) hủy ngay.
25. **Giữ theo tài liệu, mockup sửa theo** (không đổi tài liệu): bỏ QT20 d1 (máy chủ nhà máy tự kiểm khi nhận lệnh, đạt thì tự phát sang khu); nhập NVL không có "cảnh báo trước HSD", số lô NCC / NSX / HSD thủ kho nhập theo hàng thực; các ô bắt buộc (mã NV, SĐT, mã thẻ NV, ngày hiệu lực; HSD chuẩn NVL; ~~dung sai công thức~~; tiền tố mã định danh nhà máy; ~~giấy tờ xuất xứ NVL ở lệnh SX~~ — hai ô gạch bỏ 05/11); mã chứng từ sinh tại nhà máy có tiền tố nhà máy (`PN-NM1-2610-0001`…); không giới hạn thời gian ngoại tuyến.

### Quyết định đã chốt 05/11 (sau họp khách hàng)

Theo mockup sửa sau buổi họp khách hàng 05/11 (mockup là bản đúng). Mỗi mục ghi rõ thay quyết định nào.

1. **Phân quyền từng người** (QT01 a1, y1): tạo tài khoản chọn bộ phận → vai trò → bước 2 tick quyền — quyền tick sẵn theo vai trò (bộ quyền gốc ở màn Vai trò × quyền), HR / Admin bỏ hoặc thêm từng quyền riêng cho người đó; màn Người dùng có "Phân quyền từng người" để sửa sau. Thay "quyền luôn gán qua vai trò, không gán quyền lẻ" (QT01, 19/10).
2. **Mã thẻ NV nhập tay** khi tạo tài khoản (mã in trên thẻ, không quét); mã NV vẫn nhập tay theo hồ sơ nhân sự (04/11).
3. **Khu chiết rót và khu đóng gói gộp thành 1 loại khu "Chiết rót & đóng gói"** (QT02 ka; QT21 làm trong cùng 1 khu, 1 máy chiết rót + cân băng tải) — thay 4 loại khu (19/10 đợt 2).
4. **NVL có quy cách đóng gói** nhiều cấp như SP (QT02 t1): dụng cụ đóng gói (Bao / Thùng / Túi / Chai…), chuỗi cấp trong → ngoài, số cấp trong / cấp ngoài, khối lượng tịnh (bao bì: số cái); dụng cụ và tên cấp chọn từ danh sách, thêm qua "+ Khác"; NVL đã có lô nhập thì khóa quy cách cũ. Bỏ khối NCC ở màn NVL (xem NCC ở Mua hàng).
5. **SP: mục khác có loại ô nhập** (văn bản / số kèm đơn vị / ngày / có-không / danh sách chọn / văn bản dài / tệp) và **hình thức công bố thêm được** qua "+ Khác" (mặc định Tự công bố, Đăng ký bản công bố) — thay "mục khác gõ tự do", "2 hình thức công bố" (04/11).
6. **Hồ sơ pháp lý chung cảnh báo trước 30 ngày** (QT02 hs): còn ≤ 30 ngày là Sắp hết hạn; màn có thanh cảnh báo số hồ sơ sắp hết hạn / đã hết hạn, nút lọc nhanh hồ sơ cần gia hạn; form báo ngay khi ngày hết hạn nhập vào đã / sắp hết hạn. Ô "nhắc trước khi hết hạn" vẫn giữ cho thông báo.
7. **Công thức: bỏ dung sai từng thành phần và thông số trộn chuẩn** (thời gian, tốc độ); thứ tự dòng là thứ tự nạp (nút lên / xuống). **Thêm sao chép công thức** (QT03 t1): lấy thành phần, KL mẻ, mặt hàng của phiên bản hiện hành, mã mới cấp như tạo mới, không chép phiên bản / lịch sử. Thay 04/11 mục 25 ("dung sai công thức" bắt buộc) và thông số trộn chuẩn (19/10). QT20: cân bao HH so với KL công thức (g3), thông số trộn thực tế vẫn ghi vào hồ sơ mẻ (g7) nhưng không có chuẩn để so.
8. **Lệnh SX thêm % hao hụt** (QT19 t1; 0–50%, để trống = 0): khối lượng phải sản xuất = khối lượng cần × (1 + % hao hụt), số mẻ / KL mẻ tự tính theo số này. **Bỏ điều kiện giấy tờ xuất xứ NVL** — thay 19/10 đợt 2 và 04/11 mục 25.
9. **Hợp đồng theo từng đơn** (QT05 t3, t5, t6, tu — sửa chiều 05/11, thay bản "hợp đồng nguyên tắc ở hồ sơ khách"): hồ sơ khách không còn hợp đồng. Sales nhập hợp đồng khách đã ký (số, hiệu lực từ – đến, file) ngay khi tạo đơn — không bắt buộc, lưu nháp được; chưa có thì bấm "Upload hợp đồng" ở chi tiết đơn. Chốt đơn / gửi kiểm công nợ / tự chốt khi đủ điều kiện công nợ chỉ khi đơn có hợp đồng còn hiệu lực; chưa có / hết hạn: chặn chốt, chi tiết đơn báo và nút chính là Upload / Cập nhật hợp đồng. **Bỏ trạng thái Chờ ký HĐ** — thay "Ký hợp đồng → Chờ ký HĐ → tải hợp đồng đã ký" (QT05 t5, t6) và 04/11 mục 11 (Sales hủy thẳng còn ở Chờ thu tiền).
10. **Đơn sau sản xuất** (QT09 s, nk, kd, xk): lô sản xuất cho đơn QC đạt → **Chờ nhập kho** (Thủ kho nhập kho BTP, QT14) → **Chờ kế toán duyệt** (Mua nợ: Kế toán kiểm công nợ — không nợ quá hạn, trong hạn mức — rồi duyệt, chưa đạt thì giữ chờ, báo Sales; Cọc + trả nốt: Kế toán ghi nhận phần còn lại ở Công nợ khách hàng rồi duyệt; Trả đủ trước SX bỏ qua bước này) → **Chờ xuất kho** (hệ thống lập yêu cầu xuất bán cho các lô của đơn, Thủ kho xuất kho, lập phiếu xuất bán) → Đang giao. Tên bước: Đã chốt → "Sản xuất", Đang sản xuất → "Chờ QC kiểm". Đơn gắn lô tồn vẫn qua Sẵn sàng giao → Sales yêu cầu xuất (QT09 t2). Thay "lô TP của đơn QC đạt → Sẵn sàng giao" (24/10).
11. **Bỏ Danh mục › Nhà cung cấp** (QT11 xn): NCC chỉ xem / sửa ở Mua hàng › Nhà cung cấp (Admin, Giám đốc, Mua hàng, Trưởng BP Mua hàng) — thay 19/10 đợt 4 và 04/11 (Danh mục › NCC có vai trò xem).

### Câu hỏi

1. **Thứ tự cấn tiền:** khách trả gộp nhiều khoản / nhiều đơn thì hệ thống tự cấn khoản đến hạn sớm nhất trước, hay Kế toán chọn khoản khi ghi nhận? (dữ liệu chịu được cả hai — `payment_allocation`)
2. **Tiền về thừa** (lớn hơn các khoản đang mở của khách): cho ghi nhận và giữ làm số dư chờ cấn khoản sau, hay chặn — phải ghi nhận đúng số cần thu?
3. **Kết quả công nợ quá 90 ngày:** khi GĐ / KTT quyết xóa nợ bên ngoài, dư nợ trong hệ thống có giảm (Kế toán ghi 1 dòng điều chỉnh) để khách hết bị tạm khóa không, hay giữ nguyên dư nợ, chỉ kèm ghi chú + file?
4. **Bản ghi nhận thu / chi nhập sai:** Kế toán tự hủy (bắt buộc lý do, không xóa) là đủ, hay cần Kế toán trưởng xác nhận?
5. **Giá trị hàng hủy:** Kế toán nhập tay, hay hệ thống tính từ đơn giá? Hệ thống chưa có giá vốn lô (NVL có đơn giá PO; BTP / TP chưa có giá) — đang để Kế toán nhập tay.
6. ~~**Dòng rà soát của chính Trưởng BP:** ai quyết (cấp trên trực tiếp, Admin, hay Giám đốc)? Hiện hệ thống chặn Trưởng BP tự quyết, nên bộ phận chưa xác nhận được tới khi có người quyết dòng đó.~~ **Bỏ 28/10** (không còn rà soát, không còn vai trò Trưởng bộ phận).
7. ~~**Ngưỡng gợi ý "không đăng nhập lâu"** khi rà soát: đang để mặc định 60 ngày (dưới ngưỡng tự khóa 90 ngày), cấu hình lại được — xác nhận số này.~~ **Bỏ 28/10** (không còn rà soát).
8. **Mã công thức — Đã chốt 20/10 (đợt 3): 4 số** (`CT-HH-0001`, tối đa 9999 công thức mỗi loại, số không dùng lại).
9. ~~**(đợt 2) Silo bảo trì khi lệnh đã phát** (Chờ phát / Đã nhận / Đang chạy): quyết định 19/10 chỉ nói lệnh chưa phát. Lệnh đã xuống nhà máy thì chặn mẻ mới tới khi Kế hoạch xếp lại và gửi lại lệnh, hay cho chạy hết lệnh?~~ **Đã chốt (đợt 3):** xử lý theo trạng thái lệnh (ghi chú đợt 3).
10. ~~**(đợt 2) Sức chứa silo so với gì:** đang hiểu là KL một NVL trong 1 mẻ (định mức × KL mẻ / KL mẻ chuẩn) phải ≤ sức chứa silo. Đúng không, hay sức chứa so với tổng KL NVL của cả lệnh?~~ **Đã chốt (đợt 3):** silo nạp nhiều mẻ, được nạp bổ sung; mỗi lần nạp kiểm bột trong silo + bao ≤ sức chứa.
11. ~~**(đợt 2) Một NVL có được xếp vào 2 silo** (khi KL / mẻ vượt sức chứa 1 silo) không? Đang để 1 NVL – 1 silo trong một lệnh.~~ **Đã chốt (đợt 3):** 1 NVL – 1 silo.
12. ~~**(đợt 2) Sửa lệnh Đã nhận gửi lại xuống nhà máy:** trong lúc chờ nhà máy xác nhận bản sửa, lệnh giữ "Đã nhận" (đang để vậy, ghi số lần sửa) hay về "Chờ phát"? Sửa những gì được (số mẻ, KL mẻ, nhãn hiệu, dàn silo; công thức thì không)?~~ **Đã chốt (đợt 3):** lệnh đã phát không sửa — hủy rồi tạo lại, hoặc kết thúc sớm.
13. ~~**(đợt 2) Xuất SX thiếu hàng mà hết lô FEFO thay thế:** cũng sang "Chờ bên yêu cầu" (Kế hoạch chọn) như xuất bán / chuyển kho / trả NCC không? Đang cho cả 4 loại.~~ **Đã chốt (đợt 3):** có, Kế hoạch chọn; nhắc lập yêu cầu mua.
14. ~~**(đợt 2) Hàng đợi phát lệnh:** lệnh Chờ phát (đã phát, nhà máy chưa nhận) còn tính trong hàng đợi của khu không? Đang để chỉ lệnh Mới tạo nằm trong hàng đợi; Chờ phát do cloud tự gửi lại.~~ **Đã chốt (đợt 3):** hàng đợi = thứ tự chạy ở nhà máy, Chờ phát giữ vị trí.
15. **(đợt 3) Lô bột dư xả từ silo:** HSD lấy theo lô sớm nhất đã nạp vào nút silo, trạng thái theo khóa cả lô của các lô đã nạp (như NVL dư trả về) — xác nhận.
16. **(đợt 3) Mốc "silo xả sạch":** công nhân xác nhận trên PC xưởng (đang để) hay lấy từ cân silo trên SCADA khi nối dữ liệu máy? Bột bám thành silo (cân không về đúng 0) thì ngưỡng bao nhiêu kg coi là sạch?
17. ~~**(đợt 3) Hủy lệnh chờ nhà máy xác nhận:** mất kết nối lâu thì giữ chỗ NVL giữ tới khi nhà máy trả lời (đang để vậy), hay quá N giờ thì cloud tự giải phóng và coi như hủy?~~ **Đã chốt 20/10 (đợt 2):** giữ chỗ giữ tới khi nhà máy trả lời — mất mạng không giới hạn, lệnh hủy là lệnh từ trung tâm Chờ gửi (QT19 yh).
18. **(đợt 3) Xả định lượng từ silo cho từng mẻ:** thiết bị có cân / bộ định lượng ở cửa xả silo không, KL xả mỗi mẻ lấy từ đâu (SCADA hay công nhân nhập)? Cần hỏi bên cung cấp thiết bị.
19. ~~**(đợt 4) Tiền tố mã 4 danh mục SP**~~ — **đã chốt 19/10 tối:** thương hiệu `THH-`, dòng SP `DSP-`, quy cách đóng gói `QCD-`, hạng `HSP-` (bỏ `TH-` / `QC-` vì trùng hồ sơ thu hồi / phiếu kiểm). Mockup đã đổi theo.
20. **(đợt 4) Một mã SP nhiều quy cách — Đã chốt 20/10 (đợt 3): mỗi quy cách × số lon / thùng là 1 mã SP** (vd SP-0001 = 800 g × 24, SP-0002 = 400 g × 48, mỗi mã 1 barcode). Dòng đơn, kế hoạch nhãn hiệu, lô BTP / TP trỏ thẳng mã SP. Màn Danh mục SP nhóm các mã cùng thương hiệu × dòng × hạng cho dễ nhìn (giống mockup). Hỏi lại khách 24/10: Sales / phiếu xuất / hóa đơn gọi hàng theo mã từng loại thùng — nếu khách bắt buộc 1 mã chung thì mới thêm cấp mã hàng. **Thay 04/11:** một mã SP có quy cách đóng gói nhiều cấp (mô hình SP mới, QT02).

## Phân hệ & màn hình

Chốt 19/10 từ giai đoạn mockup (mockup web văn phòng, gồm đăng nhập và quản lý người dùng). Menu web chia theo người dùng và **hiện theo quyền**: một màn hiện khi vai trò có ít nhất 1 quyền ở các bước của màn (bảng `screen` + `screen_function`, sửa 20/10); không còn màn nào thì ẩn cả phân hệ. Admin · Giám đốc xem mọi màn (QT01 xa). Màn hình PC xưởng (vận hành mẻ, chiết rót — QT20, QT21) nằm ngoài phạm vi mockup, quy trình giữ nguyên. Sửa 19/10 (đợt 2): **không còn ứng dụng / menu máy quét riêng** — thao tác quét nằm trong màn của từng quy trình, dùng đầu đọc mã: màn Kho trên web (nhập & cất hàng, lấy hàng xuất, nhận chuyển kho, kiểm kho, sự cố tem) và màn PC xưởng (quét bao nạp silo, lon đầu, dán QR thùng). Đăng nhập web bằng mã NV + mật khẩu; quét thẻ NV chỉ ở PC xưởng. Cột "Quy trình, bước" và "Vai trò" dùng đúng mã bước và tên vai trò ở các QT và mục "Vai trò × Chức năng" — bảng dưới là căn cứ viết test case theo màn hình.

### Menu web

- **Tổng quan** — Tổng quan Giám đốc (thêm 04/11; Giám đốc, Admin)
- **Việc cần làm** — việc cần duyệt + việc được giao của người đăng nhập
- **Bán hàng** — Đơn hàng · Khách hàng (bỏ Giao hàng 24/10 — ghi nhận ở tab Giao hàng của đơn)
- **Mua hàng** — Đơn mua (Hàng đợi mua / Đơn mua (PO)) · Nhà cung cấp · Trả hàng nhà cung cấp
- **Kế toán** — Công nợ khách hàng · Công nợ nhà cung cấp · Sổ thu chi
- **Kho** — Tồn kho · Nhập kho · Xuất kho · Chuyển kho · Kiểm kho · Hủy hàng
- **Sản xuất** — Lệnh sản xuất (kèm Cân đối NVL) · Theo dõi mẻ
- **Chất lượng** — Yêu cầu kiểm · Phiếu kiểm · Phiếu chứng nhận · Mẫu lưu
- **Truy xuất & thu hồi** — Truy xuất · Hồ sơ thu hồi
- **Hồ sơ & biểu mẫu in** — tra và in lại phiếu đã ký (thêm 04/11; mọi người dùng, theo phân hệ có quyền)
- **Danh mục** — Nguyên vật liệu · Công thức · Sản phẩm · Đơn vị · Nhà máy (bên trong: Kho · Khu vực làm việc & dàn silo) · Hồ sơ pháp lý chung (bỏ Nhà cung cấp 05/11)
- **Quản trị** — Người dùng & vai trò · Tham số & định dạng mã · Nhật ký hệ thống

Cập nhật 04/11 theo menu mockup: Công thức chuyển từ Sản xuất sang Danh mục; Khu vực làm việc & dàn silo chuyển từ Quản trị sang Danh mục (mở từ màn Nhà máy, cùng Kho); Đơn vị (trước nằm trong Tham số) và Hồ sơ pháp lý chung là màn riêng trong Danh mục; Sản phẩm bỏ 4 danh mục con (dòng SP, quy cách đóng gói, hạng, thương hiệu — thay bằng lựa chọn của ô chọn trong màn Sản phẩm); thêm Tổng quan và Hồ sơ & biểu mẫu in; bỏ Giao hàng (24/10). Sửa 05/11: bỏ Danh mục › Nhà cung cấp — NCC chỉ ở Mua hàng › Nhà cung cấp. Cập nhật 19/10 (đợt 4): Mua hàng › Nhà cung cấp = hồ sơ & duyệt NCC (QT11); ~~Danh mục › Nhà cung cấp = danh sách gốc, tạo mới ở trạng thái Chờ duyệt rồi dẫn sang Mua hàng duyệt (không tự đặt Đã duyệt)~~ (bỏ 05/11). Cơ chế chỉ có ở mockup, không phải chức năng sản phẩm: ô "Xem như" đổi vai trò khi demo; nút ngoài quyền hiện `Việc của <vai trò>`; mã chứng từ là link mở đúng phiếu ở màn chủ của nó.

### Nơi chạy từng màn (chốt 20/10 đợt 2)

Một mã nguồn, một schema, chạy ở cloud và ở từng máy chủ nhà máy. "NM" = màn chạy tại máy chủ nhà máy, đủ chức năng khi mất mạng; "Cloud" = chỉ cloud; "Cả hai" = mỗi nơi tính từ dữ liệu của mình. Người ở nhà máy dùng màn NM qua mạng nội bộ; màn Cloud họ không vào được khi mất mạng. Màn NM có chip "Máy chủ NM · ngoại tuyến từ HH:MM · N thao tác chờ gửi"; nút thuộc cloud hiện "Chờ gửi lên". Không có màn theo dõi riêng hay màn kho riêng tại nhà máy.

| Màn | Nơi chạy | Khi nhà máy mất mạng |
|---|---|---|
| Tổng quan | Cloud | Số liệu của nhà máy mất mạng ghi "tính đến" |
| Đăng nhập | Cả hai | NM xác thực trên bản sao tài khoản |
| Việc cần làm | Cả hai | NM: việc của chứng từ nhà máy; việc từ cloud chỉ hiện nếu đã sao xuống |
| Đơn hàng · Khách hàng | Cloud | NM chỉ xuất bán theo yêu cầu xuất bán đã sao xuống (màn Xuất kho) |
| Đơn mua · Nhà cung cấp · Trả hàng NCC | Cloud | PO đã duyệt, yêu cầu xuất trả sao xuống NM |
| Công nợ KH · Công nợ NCC · Sổ thu chi | Cloud | Tồn / giá trị từ NM ghi "tính đến" |
| Tồn kho · Nhập kho · Xuất kho · Chuyển kho · Kiểm kho · Hủy hàng | NM (bản đồng bộ ở cloud, chỉ xem, "tính đến") — trừ yêu cầu chuyển liên nhà máy YCC- (cloud) | Chạy đủ; chuyển kho khác nhà máy cần phiếu đã tới |
| Lệnh sản xuất · Cân đối NVL | Cloud (tạo, hủy, kết thúc sớm, chọn cách bù) + NM (xem, chuẩn bị NVL, tình trạng lệnh từ trung tâm) | NM xem lệnh đã nhận; cloud tạo lệnh mới → Chờ phát; hủy lệnh Đã nhận bị chặn, báo "chưa hủy được, thử lại khi có kết nối" (chốt 04/11) |
| Theo dõi mẻ | NM (cloud bản đồng bộ) | Chạy đủ; hủy mẻ từ cloud thành lệnh Chờ gửi |
| Yêu cầu kiểm · Phiếu kiểm · Phiếu chứng nhận · Mẫu lưu | NM (cloud bản đồng bộ) | Chạy đủ; chứng nhận tới Giao hàng khi có mạng |
| Truy xuất · Hồ sơ thu hồi | Cloud | Thu hồi: lệnh khóa lô "chờ nhà máy áp dụng"; truy xuất ghi nhà máy chưa gửi từ lúc nào |
| Hồ sơ & biểu mẫu in | Cloud | Phiếu của nhà máy mất mạng có tới lần đồng bộ cuối |
| Danh mục (9 màn, gồm Công thức — sao xuống NM kèm lệnh, PC xưởng xem) · Quản trị (3 màn) | Cloud (sao xuống NM bản chỉ đọc) | Nhật ký NM gộp lên khi có mạng |

### Màn hình → quy trình, bước, bảng dữ liệu, vai trò

| Phân hệ | Màn hình | Quy trình, bước | Bảng dữ liệu chính | Vai trò được thao tác |
|---|---|---|---|---|
| Tổng quan | Tổng quan Giám đốc (thêm 04/11) | QT01 tq — chỉ xem: đơn đang sản xuất / quá hạn giao, TP nhập kho so kế hoạch, lô đạt QC, tiền hàng đã giao, công nợ quá hạn (Hôm nay / 7 ngày / Tháng này); sản lượng TP 14 ngày so kế hoạch; việc chờ Giám đốc duyệt; đơn cần chú ý; sản xuất hôm nay; chất lượng & thu hồi; kho (TP sẵn giao, lô chờ QC, lô hết hạn chưa hủy, NVL sắp hết, phiếu kho chờ xử lý); tài chính (phải thu, phải trả NCC 7 ngày, đã giao chưa có hóa đơn) — lối tắt mở màn nghiệp vụ (Ghi tiền về, Lập hóa đơn… do vai trò có quyền làm) | đọc: sales_order, production_order, production_batch, goods_receipt, lot, qc_request, recall_case, retained_sample, stock_line, ar_entry, ap_entry, sales_order_invoice, kế hoạch sản lượng ngày | Giám đốc (Admin xem — QT01 xa) |
| Việc cần làm | Việc cần làm | Mọi bước duyệt (D) và bước được giao của người đăng nhập, vd QT02 d4 duyệt ngừng mã, QT06 t4d / vd1 hạn mức, QT07 h2 số tiền hoàn, QT12 d3 / c2 PO, QT13 dx yêu cầu xuất trả, QT14 d4, QT16 gx, QT02 ml mẫu nhãn chờ duyệt, QT12 ck / tt PO Chờ COA & HSD / Chờ chọn thanh toán, QT23 gk phiếu chứng nhận chờ ký, QT17 d3 / p4, QT18 d2, QT22 / QT23 d1, d2, QT26 d1 / qa / gd; việc được giao vd QT09 kd đơn Chờ kế toán duyệt (Kế toán — 05/11), QT05 tu hợp đồng của khách hết hạn / chưa có (Sales — 05/11), QT09 t2 / t5 / t9 đơn Sẵn sàng giao, ghi nhận kết quả giao, phiếu xuất bán chờ bên yêu cầu (Sales), QT16 yl yêu cầu chuyển liên nhà máy chờ lập phiếu (Kế hoạch nhà máy nguồn), QT19 cb phần thiếu ở Cân đối NVL và "Lệnh chưa phát sang khu được" (Kế hoạch), QT16 d3 nhận hàng chuyển kho (thủ kho kho nhận) | Đọc trạng thái chờ của: catalog_retire_request, credit_limit_request, sales_order, purchase_order, purchase_request, stock_transfer_request, product (mẫu nhãn), quality_certificate, goods_receipt, goods_issue, stock_transfer, transfer_discrepancy, stocktake, disposal, qc_request, qc_inspection, recall_case, capa | Mọi vai trò — mỗi người chỉ thấy việc của mình (theo quyền × phạm vi) |
| Bán hàng | Đơn hàng | QT05 t1–t6, d2, yl, hn (Sales hủy đơn chưa chốt — 04/11), tu (upload hợp đồng ở chi tiết đơn: số, hiệu lực từ – đến, file — 05/11); QT06 (q1, v1, v4, v5; duyệt t4d / vd1 ở Việc cần làm); QT07 t0, h2; QT08 m1, t6; QT09 kd (Kế toán duyệt xuất giao — 05/11); tab Giao hàng — QT09 t1, t2, t9, tr, t5, dg, QT10 t1 (lập hóa đơn gắn phiếu xuất, in A4 — 04/11) | sales_order, sales_order_version, sales_order_line, payment_schedule, credit_limit_request, sales_order_status_log, sales_issue_request, sales_issue_request_line, delivery_note, delivery_note_line, sales_order_invoice, goods_issue (xem), quality_certificate (xem) | Sales (tạo, sửa, hủy; yêu cầu xuất, ghi nhận kết quả giao); Kế toán (đề xuất hạn mức t4; duyệt xuất giao kd; thêm hóa đơn); Giám đốc · Kế toán trưởng (duyệt hạn mức, số tiền hoàn); Kế hoạch (xem) |
| Bán hàng | Khách hàng | QT05 t2 (không còn hợp đồng — chuyển sang đơn, 05/11); QT06 (hạn mức) | customer, customer_contact_log | Sales (tạo, sửa); CSKH (xem — QT05 xk); lịch sử liên hệ nhắc nợ hiện ở chi tiết khách, chỉ xem (ghi ở Công nợ KH — QT10 k3) |
| Mua hàng | Đơn mua (2 tab: Hàng đợi mua / Đơn mua (PO); sửa 04/11 — bỏ báo giá) | QT12 t1–t8, th, tv, ce, ck, tt, gp, hp, dl, d1–d5, y1–y5 | purchase_request (nhu cầu mua — dòng Hàng đợi mua, kể cả nhu cầu thêm tay), purchase_request_line, purchase_order (hình thức thanh toán, kết quả COA & HSD, email đã gửi), purchase_order_line | Kế hoạch (thêm tay, hủy nhu cầu — t1, th); Mua hàng (Hàng đợi mua, lập PO, gửi email COA / PO, kiểm COA & HSD, chọn thanh toán, hủy PO chưa duyệt); Trưởng BP Mua hàng (như Mua hàng; duyệt / từ chối, hủy PO đã duyệt, đóng phần còn lại); Giám đốc (duyệt trên ngưỡng); Thủ kho · Thủ kho điều phối (xem tồn khả dụng) |
| Mua hàng | Nhà cung cấp | QT11 t1, d1, d3, dr, n1; chi tiết NCC hiện lịch sử trả hàng, giao trễ / giao thiếu (chỉ tra cứu) | supplier, supplier_certificate, supplier_material, supplier_status_log, supplier_history | Mua hàng; Trưởng BP Mua hàng (duyệt, ngừng dùng) |
| Mua hàng | Trả hàng nhà cung cấp | QT13 t1, t2, tx, dx, t5, t6, d1, d2, n1, n2, nd (trạng thái theo mockup: Chờ NCC xác nhận / Không thống nhất / NCC chấp nhận / Chờ duyệt xuất trả / Chờ kho xuất trả / Đã xuất trả / Chờ ký xác nhận / Hoàn tất / Chuyển hủy) | supplier_return, supplier_return_line, goods_issue (xem) | Mua hàng (phiếu trả, gửi yêu cầu xuất trả); Thủ kho (ghi nhận hàng lỗi chờ trả; lập phiếu xuất trả NCC ở màn Xuất kho) |
| Kế toán | Công nợ khách hàng | QT10 k2, yk, h1, ya, y3, k3, g9; QT06 v2 (xem) | customer (hạn mức, cờ tạm khóa), payment_schedule, payment_voucher, payment_allocation, ar_entry | Kế toán (ghi nhận tiền về / hoàn tiền, ghi kết quả nợ quá 90 ngày); Kế toán trưởng (xem); Sales (xem) |
| Kế toán | Công nợ nhà cung cấp | QT12 d4, t6 (trả trước / cọc / trả nốt — 31/10), y4, t8; QT13 t4 | ap_entry, payment_voucher (trả NCC), purchase_order | Kế toán (ghi nhận đã trả, giảm trừ khi trả hàng); Kế toán trưởng (xem) |
| Kế toán | Sổ thu chi | QT10 k2, h1; QT12 t6, t8 — chỉ tra cứu | payment_voucher, payment_allocation | Kế toán (hủy bản ghi nhập sai); Kế toán trưởng (xem) |
| Kho | Tồn kho | Tra cứu cho QT14–QT18 (dòng lô × kho, số bao theo trạng thái); **Sự cố tem** (QT04 t0, d2, t5a, t5, t6c, t6, t4, dh — chọn dòng lô → danh sách bao → "Sự cố tem") | stock_line, lot, inventory_txn, lot_status_log, lot_lock, label_incident, handling_unit, scan_log | Thủ kho, Thủ kho trưởng (kho được gán; sự cố tem: Thủ kho, kể cả Thủ kho điều phối với tem lỗi ở khu SX); Thủ kho điều phối (kho điều phối); Sales · Kế hoạch · Mua hàng · Kế toán · Thủ kho trưởng (xem — QT15 xt; bản cloud chỉ xem, "tính đến") |
| Kho | Nhập kho | QT14 d0, t1, d1, l1, t3, d4, t4; NCR nr; bột dư từ silo về kho điều phối (QT20 xd); nhập — quét QR (QT14 k1–k7; QT21 t9) | goods_receipt, goods_receipt_line, receipt_coa_result, goods_receipt_damage, ncr, goods_receipt_scan, handling_unit, scan_log | Thủ kho · Thủ kho điều phối; Thủ kho trưởng (duyệt); Mua hàng (báo NCC); Kế hoạch (NCR); Kế toán (lưu chứng từ) |
| Kho | Xuất kho | QT15 s, dq0, d1, dq1 (Chờ bên yêu cầu), t1; lấy hàng xuất — quét QR (QT15 t2–t4, d4); phiếu xuất trả NCC (QT13 t3); phiếu xuất SX lập từ kho điều phối theo lệnh (QT20 t1 — đợt 4, không xuất SX từ kho tổng) | goods_issue, goods_issue_line, material_reservation, stock_discrepancy, goods_issue_scan, scan_log | Bên yêu cầu: Sales · Kế hoạch · Mua hàng; Thủ kho (lấy hàng, lập phiếu xuất trả NCC; Thủ kho điều phối lấy hàng theo phiếu xuất SX tự lập); Thủ kho trưởng (xem — QT15 xp; phiếu xuất không duyệt) |
| Kho | Chuyển kho (3 tab: Yêu cầu chuyển liên nhà máy / Phiếu chuyển liên nhà máy / Phiếu chuyển nội bộ — 30/10) | QT16 s, y0, yl (yêu cầu YCC-, lập phiếu là chấp nhận), ya (phiếu nội bộ tự lập từ lệnh SX), yn, r1, g1, kx, t1, t2, t4, g3, gx; nhận chuyển kho — quét QR (QT16 d3, t3, d4, t4) | stock_transfer_request (YCC-: kho xuất, kho nhận, mã hàng, SL, ngày cần, hạn xuất, lệnh liên quan, nguồn, lý do, trạng thái), stock_transfer (lệnh nguồn, cờ tự lập, yêu cầu gắn kèm), stock_transfer_line, transfer_discrepancy, goods_receipt_scan, scan_log | Kế hoạch (gửi yêu cầu — nhà máy nhận; lập phiếu / từ chối — nhà máy nguồn; lập tay phiếu nội bộ); Thủ kho (kho xuất: xuất, quét, không thực hiện được — kho tổng khi chuyển cho kho điều phối; kho nhận: nhận, quét); Thủ kho điều phối (nhận NVL cho SX; lập phiếu từ yêu cầu nội bộ); Thủ kho trưởng (chọn gửi QC / hủy, xác nhận thất lạc); Vận chuyển |
| Kho | Kiểm kho | QT17 d1, d3, t4, p4; đếm — quét QR (QT17 t2, d2, t3, p2, p3, p6) | stocktake, stocktake_lock, stocktake_line, stock_adjustment, scan_log | Thủ kho trưởng (ra lệnh, duyệt điều chỉnh); Thủ kho · Thủ kho điều phối |
| Kho | Hủy hàng | QT18 t1, t2, d2, xr, t3, t4, t5 | disposal, disposal_line | Thủ kho · Thủ kho điều phối; Thủ kho trưởng (xác nhận / từ chối); QC (hủy mẫu lưu); Kế toán (giá trị hàng hủy); Kế hoạch · Sales (xem phiếu hủy hàng của đơn hủy — QT07 h5) |
| Sản xuất | Lệnh sản xuất | Tab Chờ lên lệnh (đợt 8 — dòng đơn đã chốt còn số lon chưa lên lệnh, gom theo mã SP, tách HH / BTP): QT05 yc, QT19 nc, nh. QT19 t1 (kể cả lệnh sản xuất tồn kho — 04/11), tb, ys, tk, t2, y1, g1, cb, q1, yx, xs, y2, kp, su, hl, yh, kt, kf (hàng đợi phát lệnh theo khu, phương án dàn silo kéo thả; sửa lệnh Mới tạo, hủy, kết thúc sớm); QT07 h4, QT08 r2 | sales_order_line (đọc nhu cầu), production_order, production_order_brand (+ sales_order_line_id, số lon phân bổ), production_order_silo, material_reservation, equipment (silo), sync_conflict | Kế hoạch; QC (xung đột ngoại tuyến); Thủ kho · Thủ kho điều phối (xem — QT19 xl) |
| Sản xuất | Lệnh sản xuất › Phiếu chuyển kho theo lệnh (khối trong chi tiết lệnh) | QT19 dc, d2 (kho điều phối đủ NVL so với KG giữ chỗ?), yd (hệ thống tự lập phiếu chuyển nội bộ đúng phần thiếu → Chờ xuất; bỏ bước Kế hoạch gửi — 30/10) → QT16 ya | material_reservation, stock_line (tồn kho điều phối), stock_transfer (source_order_id, auto_drafted), stock_transfer_line | Kế hoạch (xem); Thủ kho kho tổng, Thủ kho điều phối (xem trạng thái chuyển) |
| Sản xuất | Lệnh sản xuất › Cân đối NVL (thêm 04/11 theo mockup) | QT19 cb — phần NVL thiếu chưa có cách xử lý (khi tạo lệnh, Mua hàng trả về QT12 tv, kho xuất không thực hiện được QT16 kx, yêu cầu chuyển bị từ chối / quá hạn, tồn giảm sau khi giữ chỗ): Kế hoạch chọn Mua (→ Hàng đợi mua) / chuyển kho liên nhà máy (→ YCC-) / lùi ngày | material_reservation, purchase_request, stock_transfer_request, production_order | Kế hoạch |
| Sản xuất | Theo dõi mẻ | QT20 kh, kb (hủy mẻ, mẻ bù — lệnh từ trung tâm; d1 do máy chủ nhà máy tự kiểm từ 20/10 đợt 2); xem QT20, QT21 (thao tác ở PC xưởng, ngoài phạm vi mockup) | production_batch, batch_cancellation, filling_run, silo_charge, lot (nút silo), lot_link | Kế hoạch; QC (xem — QT20 xm); Thủ kho điều phối (chuẩn bị NVL — QT20 t0, t1) |
| Chất lượng | Yêu cầu kiểm | QT22 t1, t2, d1; QT23 t1, t2, d1 | qc_request, qc_request_part | Thủ kho · Thủ kho điều phối · Kế hoạch (gửi); QC trưởng (duyệt / từ chối / yêu cầu bổ sung); Thủ kho · Thủ kho điều phối · Thủ kho trưởng · Kế hoạch (xem lô mình gửi — QT22 xq) |
| Chất lượng | Phiếu kiểm | QT22 t3, g1, d2, ym; QT23 t3, yq, d2 | qc_inspection, qc_result_item | QC (lấy mẫu, nhập số liệu); QC trưởng (duyệt kết luận, mở lại lô NVL KHÔNG ĐẠT); Thủ kho · Thủ kho điều phối · Thủ kho trưởng · Kế hoạch (xem kết quả lô mình gửi — QT22 xq) |
| Chất lượng | Phiếu chứng nhận | QT23 g2 (sinh phiếu Chờ ký: kết luận + file đánh giá bên ngoài), gk (QC trưởng ký → Đã ký; tab Chờ ký / Đã ký — 04/11); xem / tải ở Đơn hàng › tab Giao hàng (QT09) | quality_certificate (trạng thái Chờ ký / Đã ký / Đã hủy, người ký, lúc ký, file PDF) | QC trưởng (ký; 15–21/10/2026 do người được ủy quyền ký); Sales · Kế hoạch · QC (xem — QT23 xc) |
| Chất lượng | Mẫu lưu | QT24 t1–t4, g1, d1, lr, np, sh (lấy ra đánh giá, niêm phong lại, sửa hạn lưu — 04/11) | retained_sample (nơi lưu = kho mẫu lưu QC, hạn lưu, trạng thái Đang lưu / Hết hạn lưu / Đã hủy, cờ đang mở niêm phong), lần lấy ra / niêm phong, biên bản hủy (cách hủy, người chứng kiến, file) | QC |
| Truy xuất & thu hồi | Truy xuất | QT25 t1 (mã đầu vào: số lô, QR lon / thùng / bao, mã đơn hàng, mã khách hàng, mã NVL — 04/11), t3 | trace_request, trace_result_lot, trace_result_customer, mass_balance_result, stock_discrepancy | Người truy xuất; Thủ kho · Thủ kho điều phối (biên bản chênh lệch) |
| Truy xuất & thu hồi | Hồ sơ thu hồi | QT26 o1, y1 (lệnh khóa lô theo từng nhà máy: Đã áp dụng HH:MM / Chờ nhà máy áp dụng), q1, d1, t0, t1, t3, q3, qa, gd | recall_case, recall_lot, recall_customer, recall_authority_report, recall_resolution, capa | QC trưởng; Giám đốc; QC; CSKH; Sales; Giám đốc · Kế toán trưởng (số tiền hoàn) |
| Hồ sơ & biểu mẫu in | Hồ sơ & biểu mẫu in (thêm 04/11) | Mọi QT có phiếu in / ký: tìm theo loại biểu mẫu, ngày, số phiếu; tra cả bộ hồ sơ theo số lô / đơn hàng / lệnh SX (các phiếu theo thứ tự phát sinh); xem, in, PDF đúng bản lưu lúc ký (không dựng lại từ dữ liệu hiện tại); in lại đóng dấu BẢN SAO, bắt buộc lý do in lại, ghi người in, ngày in, số lần in vào Nhật ký hệ thống | bản lưu chứng từ đã ký (file PDF lúc ký), nhật ký in, audit_log | Mọi vai trò — chỉ thấy phiếu của phân hệ mình có quyền (vd Thủ kho: Kho; QC trưởng: Chất lượng, Truy xuất & thu hồi; Kế toán: Kế toán, Bán hàng, Mua hàng; Giám đốc: tất cả) |
| Danh mục | Nguyên vật liệu | QT02 t1–t3 (bộ chỉ tiêu COA ≥ 1, nguyên liệu kỵ nhau, tối đa 5 ảnh, tồn tối thiểu, cách bù — 30/10, 04/11; quy cách đóng gói nhiều cấp — 05/11), tg, tr, d4 (qua Việc cần làm), tk (Kế hoạch tự ngừng) | material (ảnh, tồn tối thiểu, cách bù, ghi chú), material_pack, material_pack_level (05/11), material_coa_spec, material_incompatible, catalog_retire_request | Mua hàng · Kế hoạch · Thủ kho · Thủ kho điều phối · QC (tạo, sửa); Mua hàng · Thủ kho · Thủ kho điều phối · QC (đề nghị ngừng); Kế hoạch (tự ngừng); Trưởng BP Mua hàng · Thủ kho trưởng · QC trưởng (duyệt ngừng theo bên đề xuất) |
| Danh mục | Công thức (chuyển từ Sản xuất — 04/11) | QT03 t1 (kể cả sao chép — 05/11), t2, y1–y3 (kèm lệnh đang chạy phiên bản cũ) | formula, formula_version, formula_item, production_order.formula_version_id | R&D · Kế hoạch (tạo, sửa); QC (xem; công nhân xem trên PC xưởng) |
| Danh mục | Sản phẩm | QT02 t1–t3, tg, tr, d4, tk, xo, ml (mô hình mới 04/11: cấu trúc / nhóm / phân loại / độ tuổi, mục khác — có loại ô nhập 05/11, quy cách đóng gói nhiều cấp, barcode, mẫu nhãn từng quy cách — QC trưởng duyệt, bản công bố — hình thức công bố thêm được 05/11, hồ sơ pháp lý riêng / chung; lựa chọn của ô chọn sửa ngay trong ô chọn, chưa dùng thì xóa được; sao chép SP) | product, product_pack_level, product_label (mẫu nhãn, phiên bản, trạng thái), product_declaration (bản công bố), product_legal_doc, product_option (lựa chọn ô chọn), catalog_retire_request | Như NVL; QC trưởng (duyệt mẫu nhãn — QT02 ml) |
| Danh mục | Đơn vị (màn riêng — 04/11; trước nằm trong Tham số) | QT02 dv, xv | uom (mã, tên, loại, quy đổi, trạng thái) | Admin (thêm / sửa / xóa đơn vị chưa có tham chiếu); Kế hoạch · Mua hàng · Trưởng BP Mua hàng · Thủ kho · Thủ kho điều phối · Thủ kho trưởng · QC · QC trưởng (xem — QT02 xv) |
| Danh mục | Nhà máy | QT02 ka (nhà máy: tiền tố mã định danh, địa chỉ, điện thoại, email; bên trong có Kho, Khu vực làm việc & dàn silo) | factory | Admin; Thủ kho trưởng (xem — QT02 xk) |
| Danh mục | Nhà máy › Kho | QT02 ka (loại kho tổng / điều phối / BTP / mẫu lưu QC; được nhiều kho điều phối — 04/11) | warehouse (kho điều phối: các khu được cấp NVL) | Admin; Thủ kho trưởng (xem — QT02 xk) |
| Danh mục | Nhà máy › Khu vực làm việc & dàn silo (chuyển từ Quản trị — 04/11) | QT02 ka (loại khu, khối lượng mẻ tối đa, kho điều phối cấp NVL), ks, ksy (dàn silo của khu HH / BTP) | work_area, equipment (silo), factory (xem) | Admin |
| Danh mục | Hồ sơ pháp lý chung (thêm 04/11) | QT02 hs, xh (Sắp hết hạn khi còn ≤ 30 ngày, thanh cảnh báo + lọc hồ sơ cần gia hạn — 05/11) | legal_document (loại, số hiệu, nơi cấp, ngày cấp, hết hạn, nhắc trước, phạm vi áp dụng, file), product_legal_doc | Giám đốc · Admin (tạo, sửa, xóa); Kế hoạch · R&D · Mua hàng · Trưởng BP Mua hàng · Thủ kho trưởng · QC · QC trưởng (xem — QT02 xh) |
| Quản trị | Người dùng & vai trò | QT01 a1 (tạo: thông tin → vai trò → tick quyền; Phân quyền từng người — 05/11), m1, n1, u1, xt (xóa tài khoản chưa từng dùng — 04/11); Vai trò × quyền (bộ quyền gốc; Admin sửa — QT01 vq, 04/11; HR xem — xq) | app_user, user_role, user_permission (05/11), user_delegation, account_change_log, role, permission, role_permission | HR · Admin (tài khoản, vai trò, ủy quyền); Admin (vai trò Admin / Người truy xuất, mở khóa, mật khẩu tạm, sửa Vai trò × quyền) |
| Quản trị | Tham số & định dạng mã | Tham số mặc định (⚙ ở mọi QT), định dạng mã danh mục và chứng từ (QT02 y2, QT03 y2) — đơn vị tính chuyển sang Danh mục › Đơn vị (04/11) | system_parameter, code_format | Admin |
| Quản trị | Nhật ký hệ thống | Mọi QT — tra theo mã đối tượng (phiếu, lô, lệnh, tài khoản) | audit_log, account_change_log, scan_log, lot_status_log | Admin; HR (nhật ký tài khoản) |
| PC xưởng (ngoài phạm vi mockup) | Vận hành mẻ · Chiết rót · Đóng gói | Đăng nhập quét thẻ NV (QT01 dn); QT20 t3, g2, g1, y1 (quét bao nạp silo theo phương án silo của lệnh), ys (xả cho mẻ), vs (silo xả sạch), xd (bột dư cuối lệnh); QT21 q1, xq (lon đầu), t7 (dán QR thùng) | user_session, silo_charge, lot (nút silo, lô dư), lot_link, production_batch, filling_run, handling_unit, scan_log | Công nhân (khu mình) |

### Màn × chức năng (nạp bảng `screen`, `screen_function`)

Thêm 20/10. Nguồn nạp 2 bảng `screen` (màn của menu) và `screen_function` (màn × chức năng) — `mes-powder-gen-quyen.py` đọc bảng này cùng bảng quyền ở mục "Vai trò × Chức năng". Một màn hiện trên menu khi vai trò của người dùng có ít nhất 1 quyền (`role_permission`) ở các chức năng của màn; không còn màn nào thì ẩn cả phân hệ. Chức năng ghi đúng mã `function_code` của bảng quyền (QT + bước; dòng không có mã bước: `QT10.#4` = dòng thứ 4 của QT10). Sửa 04/11: bỏ cờ `@DIEU_PHOI` — Thủ kho điều phối là vai trò riêng, ghi thẳng trong bảng quyền. Mọi màn (trừ Việc cần làm, Hồ sơ & biểu mẫu in) có thêm `QT01.xa` — Admin · Giám đốc xem mọi màn; sinh dữ liệu tự thêm, không ghi lại ở đây. Việc cần làm và Hồ sơ & biểu mẫu in hiện cho mọi người dùng (Hồ sơ & biểu mẫu in chỉ hiện phiếu của phân hệ người dùng có quyền). Thứ tự và phân hệ theo menu mockup 04/11 (Công thức, Khu vực làm việc vào Danh mục; đổi mã màn `SX_CONG_THUC` → `DM_CONG_THUC`, `QT_KHU_VUC` → `DM_KHU_VUC`; thêm `TONG_QUAN`, `HO_SO_BIEU_MAU`, `DM_DON_VI`, `DM_HO_SO_PHAP_LY`). Bước làm ở PC xưởng (QT20, QT21 của Công nhân) không thuộc màn web nào.

| Mã màn | Phân hệ | Màn hình | Thứ tự | Chức năng (`function_code`) |
|---|---|---|---|---|
| TONG_QUAN | Tổng quan | Tổng quan Giám đốc | 5 | `QT01.tq` |
| VIEC_CAN_LAM | Việc cần làm | Việc cần làm | 10 | (mọi người dùng) |
| BAN_DON_HANG | Bán hàng | Đơn hàng | 20 | `QT05.t1–t3` · `QT05.d2` · `QT05.t6` · `QT05.hn` · `QT06.t4` · `QT06.t4d` · `QT06.q1,v4` · `QT06.v1` · `QT06.vd1` · `QT06.v5` · `QT07.t0` · `QT07.h2` · `QT07.h4` · `QT07.h5` · `QT08.m1` · `QT08.t6` · `QT08.r2` · `QT09.t1` · `QT09.t2` · `QT09.kd` · `QT09.t9` · `QT09.tr` · `QT09.t5` · `QT09.dg` · `QT10.t1` |
| BAN_KHACH_HANG | Bán hàng | Khách hàng | 30 | `QT05.t1–t3` · `QT05.xk` · `QT10.k3` |
| MUA_DON_MUA | Mua hàng | Đơn mua | 50 | `QT12.t1` · `QT12.th` · `QT12.d1` · `QT12.t2` · `QT12.tv` · `QT12.t3,t4` · `QT12.ce` · `QT12.ck` · `QT12.tt` · `QT12.d3` · `QT12.c2` · `QT12.gp` · `QT12.hp` · `QT12.dl` · `QT12.y5` |
| MUA_NCC | Mua hàng | Nhà cung cấp | 60 | `QT11.t1` · `QT11.d1` · `QT11.d3` · `QT11.dr` · `QT11.n1` |
| MUA_TRA_HANG | Mua hàng | Trả hàng nhà cung cấp | 70 | `QT13.t1` · `QT13.t2` · `QT13.d1,d2` · `QT13.n1,n2,nd` · `QT13.tx` · `QT13.dx` · `QT13.t3` · `QT13.t6` · `QT13.t5` |
| KT_CONG_NO_KH | Kế toán | Công nợ khách hàng | 80 | `QT06.q2` · `QT06.v2` · `QT10.k2` · `QT10.h1` · `QT10.#4` · `QT10.k3` · `QT10.g9` · `QT10.#7` · `QT10.#8` |
| KT_CONG_NO_NCC | Kế toán | Công nợ nhà cung cấp | 90 | `QT12.d4,t6` · `QT12.t8` · `QT13.t4` · `QT10.#8` |
| KT_SO_THU_CHI | Kế toán | Sổ thu chi | 100 | `QT10.k2` · `QT10.h1` · `QT10.#4` · `QT10.#8` · `QT12.d4,t6` · `QT12.t8` |
| KHO_TON | Kho | Tồn kho | 110 | `QT04.t4,dh` · `QT04.t5a,t5` · `QT04.t6c,t6` · `QT04.#4` · `QT12.d1` · `QT15.xt` · `QT17.t1` |
| KHO_NHAP | Kho | Nhập kho | 120 | `QT14.d0,t1` · `QT14.d1` · `QT14.t2` · `QT14.l1` · `QT14.t3,kb` · `QT14.nr` · `QT14.k1,k3,k6,k7` · `QT14.d4` · `QT14.t4` · `QT13.t6` · `QT21.t9` |
| KHO_XUAT | Kho | Xuất kho | 130 | `QT15.s` · `QT15.dq0,dq1` · `QT15.t2,t3,d4` · `QT15.t4` · `QT15.xp` · `QT13.t3` · `QT20.t0,t1` |
| KHO_CHUYEN | Kho | Chuyển kho | 140 | `QT16.s,y0` · `QT16.yl` · `QT16.yn` · `QT16.r1,g1` · `QT16.kx` · `QT16.t1` · `QT16.d3,t3,d4` · `QT16.t4` · `QT16.t2` · `QT16.g3` · `QT16.gx` |
| KHO_KIEM | Kho | Kiểm kho | 150 | `QT17.d1` · `QT17.t2,d2,t3` · `QT17.p2,p3,p6` · `QT17.d3,p4` · `QT17.t4` |
| KHO_HUY | Kho | Hủy hàng | 160 | `QT18.t1,d1` · `QT18.t2` · `QT18.d2` · `QT18.xr` · `QT18.t3` · `QT18.t4` · `QT18.t5` · `QT07.h5` |
| SX_LENH | Sản xuất | Lệnh sản xuất | 170 | `QT19.t1,y1` · `QT19.ys` · `QT19.t2` · `QT19.q1` · `QT19.y2` · `QT19.su` · `QT19.hl` · `QT19.kt` · `QT19.kr` · `QT19.dc,yd,d2` · `QT19.cb` · `QT19.kp` · `QT19.kf` · `QT19.xl` · `QT07.h4` · `QT08.r2` · `QT23.r1` |
| SX_THEO_DOI_ME | Sản xuất | Theo dõi mẻ | 180 | `QT20.kh` · `QT20.kb` · `QT20.xm` · `QT20.t0,t1` |
| CL_YEU_CAU_KIEM | Chất lượng | Yêu cầu kiểm | 200 | `QT22.t1,t2` · `QT22.d1` · `QT22.t3` · `QT22.xq` · `QT23.t1,t2` · `QT23.d1` · `QT23.t3` |
| CL_PHIEU_KIEM | Chất lượng | Phiếu kiểm | 210 | `QT22.t3` · `QT22.g1` · `QT22.d2` · `QT22.t4` · `QT22.ym` · `QT22.xq` · `QT23.t3` · `QT23.yq` · `QT23.d2` · `QT23.t4` · `QT21.t8` |
| CL_PHIEU_CHUNG_NHAN | Chất lượng | Phiếu chứng nhận | 220 | `QT23.gk` · `QT23.xc` |
| CL_MAU_LUU | Chất lượng | Mẫu lưu | 230 | `QT24.t1` · `QT24.t2` · `QT24.t3` · `QT24.lr,np` · `QT24.sh` · `QT24.g1` · `QT24.d1,t4` · `QT18.t3` |
| TX_TRUY_XUAT | Truy xuất & thu hồi | Truy xuất | 240 | `QT25.t1` · `QT25.t3` |
| TX_THU_HOI | Truy xuất & thu hồi | Hồ sơ thu hồi | 250 | `QT26.o1` · `QT26.r1` · `QT26.q1` · `QT26.d1` · `QT26.t0` · `QT26.t1` · `QT26.t3` · `QT26.q3` · `QT26.qa` · `QT26.gd` |
| HO_SO_BIEU_MAU | Hồ sơ & biểu mẫu in | Hồ sơ & biểu mẫu in | 255 | (mọi người dùng — chỉ phiếu của phân hệ có quyền) |
| DM_NVL | Danh mục | Nguyên vật liệu | 260 | `QT02.t1,t2` · `QT02.t3` · `QT02.tk` · `QT02.tg` · `QT02.tr` · `QT02.d4` |
| DM_CONG_THUC | Danh mục | Công thức | 265 | `QT03.t1,t2` · `QT03.#2` |
| DM_SAN_PHAM | Danh mục | Sản phẩm | 270 | `QT02.t1,t2` · `QT02.xo` · `QT02.ml` · `QT02.t3` · `QT02.tk` · `QT02.tg` · `QT02.tr` · `QT02.d4` |
| DM_DON_VI | Danh mục | Đơn vị | 275 | `QT02.dv` · `QT02.xv` |
| DM_NHA_MAY | Danh mục | Nhà máy | 280 | `QT02.ka` · `QT02.xk` |
| DM_KHO | Danh mục | Nhà máy › Kho | 285 | `QT02.ka` · `QT02.xk` |
| DM_KHU_VUC | Danh mục | Nhà máy › Khu vực làm việc & dàn silo | 290 | `QT02.ka` · `QT02.ks` |
| DM_HO_SO_PHAP_LY | Danh mục | Hồ sơ pháp lý chung | 295 | `QT02.hs` · `QT02.xh` |
| QT_NGUOI_DUNG | Quản trị | Người dùng & vai trò | 310 | `QT01.d0,a1` · `QT01.a1` · `QT01.n1` · `QT01.m1` · `QT01.u1` · `QT01.vq` · `QT01.xq` · `QT01.xt` |
| QT_THAM_SO | Quản trị | Tham số & định dạng mã | 330 | `QT01.#8` |
| QT_NHAT_KY | Quản trị | Nhật ký hệ thống | 340 | `QT01.#6` |

### Ánh xạ phân hệ Kế toán

| Màn hình | Lấy từ mảng | Quy trình, bước |
|---|---|---|
| Công nợ khách hàng | Bán hàng | QT10 Ghi nhận thu chi & công nợ (k2, yk, h1, ya, y3, k3, g9) — tiền về / hoàn tiền của khách theo lịch thanh toán sinh ở QT05, QT08, QT09; hạn mức, cờ tạm khóa đọc ở QT06 Kiểm công nợ (vẫn ở màn Đơn hàng) và QT09 Giao hàng |
| Công nợ nhà cung cấp | Mua hàng | QT12 Mua NVL (d4, t6 trả trước; y4 phát sinh phải trả; t8 trả sau) và QT13 Trả hàng NCC (t4 giảm trừ) |
| Sổ thu chi | Bán hàng + Mua hàng | Mọi bản ghi nhận thu / chi của QT10, QT12 — chỉ tra cứu |

## Biểu mẫu dữ liệu giữ từ bản gốc
- **Tài khoản (QT01):** ủy quyền tạm (người vắng, vai trò, người nhận, ngày bắt đầu, ngày hết hạn); mã NV, họ tên, bộ phận, chức danh, email / SĐT, vai trò (≥ 1) + quyền riêng từng người (bỏ / thêm so với vai trò — 05/11), phạm vi (nhà máy / kho), khu vực làm việc (bắt buộc với công nhân SX / đóng gói), mã thẻ NV (bắt buộc với công nhân, không bắt buộc với người khác — nhập tay mã in trên thẻ (05/11), chỉ dùng đăng nhập PC xưởng; thẻ của tài khoản đã khóa bị chặn ngay; web đăng nhập bằng mã NV + mật khẩu), trạng thái (Hoạt động / Khóa tạm — quên mật khẩu, không đăng nhập / Đã khóa — nghỉ việc), ngày hiệu lực, ngày nghỉ việc, ngày khóa tài khoản (HR đặt), lần đăng nhập cuối, người tạo. Nhật ký thay đổi: thời điểm, loại (tạo / đổi vai trò / khóa / mở khóa / ủy quyền), vai trò trước / sau, người thực hiện. Mật khẩu: bắt đổi lần đầu / sau mật khẩu tạm; quy tắc cố định trong code (≥ 8 ký tự, có cả chữ và số), không phải tham số. Bỏ rà soát hằng quý (28/10). Sửa 04/11: mã NV nhập khi tạo (kiểm trùng), ngày nghỉ việc và ngày khóa là 2 ô riêng (khóa ngay / vào ngày nghỉ / ngày khác — chỉ HR đặt); tài khoản chưa từng dùng xóa hẳn được, mã NV không cấp lại.
- **Vai trò × Chức năng (QT01):** đã chốt 17/10, sửa 19/10 — xem mục "Vai trò × Chức năng": 19 vai trò (bỏ Trưởng bộ phận 28/10; thêm Thủ kho điều phối 04/11), bảng map tác nhân → vai trò, bảng quyền theo 7 mảng, câu hỏi. Sửa 04/11: màn Vai trò × quyền sửa được — mỗi vai trò: tên, mô tả, phạm vi nhà máy mặc định, ủy quyền được hay không, người đang giữ; mỗi quyền: quy trình, bước, thao tác Xem / Tạo / Sửa / Duyệt / Hủy, phạm vi (Theo vai trò / Mọi nhà máy / Nhà máy của tài khoản / cố định một nhà máy); thêm / sửa / xóa quyền trong danh mục quyền.
- **Danh mục — trường bắt buộc theo loại (3 loại, sửa 24/10 — bỏ vị trí kệ):** NVL: tên, ĐVT, HSD chuẩn, điều kiện bảo quản, nhóm (bột / phụ gia / bao bì / nguyên liệu hỗn hợp — hỗn hợp chọn công thức sinh ra), bộ chỉ tiêu COA bắt buộc ≥ 1 chỉ tiêu (chốt 04/11, thay bản bỏ COA 24/10 đợt 3), tồn tối thiểu, thời gian giao hàng, cách bù khi dưới tồn tối thiểu (Kế hoạch đặt), nguyên liệu kỵ nhau (chọn nhiều, quan hệ hai chiều — 30/10), ảnh (tối đa 5 ảnh JPG / PNG, ảnh đầu là ảnh chính — 30/10), quy cách đóng gói ≥ 1 (dụng cụ, chuỗi cấp trong → ngoài, số cấp trong / cấp ngoài, khối lượng tịnh hoặc số cái — 05/11; bỏ khối NCC), ghi chú. SP (mô hình mới, chốt 04/11 — thay "mỗi quy cách × số lon / thùng là một mã SP" 20/10 và 4 danh mục SP đợt 4): mỗi mã SP 1 barcode; cấu trúc SP, nhóm SP, phân loại, độ tuổi (ô chọn phụ thuộc nhau; lựa chọn sửa ngay trong ô chọn, lựa chọn chưa SP nào dùng xóa được), tên công ty, nơi sản xuất (NM1 / NM2 / gia công bên ngoài), công thức BTP, HSD (ngày), mục khác (tên + loại ô nhập: văn bản / số kèm đơn vị / ngày / có-không / danh sách chọn / văn bản dài / tệp — 05/11; vd thương hiệu, đặc điểm…); quy cách đóng gói nhiều cấp (vd túi → hộp → thùng: đơn vị từng cấp, số lượng cấp dưới, khối lượng tịnh) kèm mẫu nhãn từng quy cách (file, phiên bản, Chờ duyệt / Đã duyệt — QC trưởng duyệt); bản công bố bắt buộc (hình thức chọn từ danh sách, mặc định Tự công bố / Đăng ký bản công bố, thêm được — 05/11; số, ngày, file, trạng thái Hiệu lực), hồ sơ pháp lý riêng, hồ sơ pháp lý chung áp dụng. SP đã lưu chỉ sửa mẫu nhãn và hồ sơ pháp lý; đổi thông tin / quy cách thì sao chép thành SP mới (barcode, bản công bố, mẫu nhãn nhập mới). Trạng thái Đang dùng / Chờ duyệt ngừng / Ngừng dùng. Kho: tên, nhà máy, loại kho (kho tổng / kho điều phối / kho BTP / kho mẫu lưu QC), các khu được cấp NVL (kho điều phối) (Admin tạo, trong màn Nhà máy; bỏ ô thủ kho phụ trách và Thủ kho trưởng 23/10 — người phụ trách lấy theo vai trò và phạm vi kho ở Phân quyền). Không còn thiết bị đo (bỏ 19/10); thiết bị SX nạp khi triển khai, không thuộc danh mục — trừ silo; đơn vị tính là màn Danh mục › Đơn vị (mã, tên, loại, quy đổi, trạng thái; Admin thêm / sửa / xóa khi chưa có tham chiếu — 04/11), cấu hình ở khu vực làm việc (biểu mẫu dưới). Định dạng mã (chốt 17/10, thêm công thức 19/10, Admin sửa được trong cấu hình; hệ thống tự sinh, số thứ tự tự tăng, không dùng lại số của mã đã ngừng): NVL `NVL-{nhóm}-{4 số}`, nhóm BOT bột / PGA phụ gia / BBI bao bì / HHP nguyên liệu hỗn hợp, vd `NVL-BOT-0001`, `NVL-HHP-0001`; SP `SP-{4 số}`, vd `SP-0001`; Kho `{nhà máy}-{loại kho}`, loại TONG / DP (điều phối) / BTP / MAUQC (mẫu lưu QC), vd `NM1-TONG` — mỗi nhà máy 1 kho mỗi loại, riêng kho điều phối được nhiều (`NM1-DP`, `NM1-DP2`… — 04/11); Công thức `CT-{loại}-{4 số}`, loại HH / BTP, vd `CT-HH-0001`, `CT-BTP-0002` (mã công thức do hệ thống sinh, không sửa). ~~Danh mục SP (đợt 4, chốt 19/10 tối): dòng `DSP-{2 số}`, quy cách đóng gói `QCD-{2 số}`, hạng `HSP-{2 số}`, thương hiệu `THH-{2 số}`~~ (bỏ cùng 4 danh mục SP 04/11). Mã khác (theo màn Tham số & định dạng mã): khách hàng `KH-{4 số}`, NCC `NCC-{4 số}`, mã lô nội bộ NVL `L-{viết tắt NVL}-{2 số}`, lô BTP `B{yymmdd}[-{2 số}]`, lô TP `A{yymmdd}`, mã NV `NV{4 số}`, yêu cầu chuyển liên nhà máy `YCC-{yymm}-{4 số}`, nhu cầu mua thêm tay `NC-{yymm}-{4 số}`. Nhà máy có tiền tố mã định danh (1–4 chữ hoa / số, không trùng) dùng trong mã chứng từ, mã bao / thùng.
- **Khu vực làm việc & dàn silo (QT02 ka, ks — thêm 19/10 đợt 2, Admin):** khu: mã, tên, nhà máy, loại (HH / BTP / chiết rót & đóng gói — gộp 05/11; loại lệnh theo khu), khối lượng mẻ tối đa kg (bắt buộc với HH / BTP), kho điều phối cấp NVL (bắt buộc với HH / BTP; một kho điều phối cấp cho nhiều khu — 04/11), trạng thái (Đang dùng / Ngừng dùng — không xóa); không đổi loại khu khi còn lệnh chưa hoàn thành. Silo (chỉ khu HH / BTP, số silo tùy khu): tên, sức chứa (kg), gán cứng 1 NVL (tùy chọn), trạng thái (Hoạt động / Bảo trì / Ngừng dùng), mã thiết bị trên SCADA. Silo chuyển bảo trì / ngừng dùng mà lệnh chưa phát đang xếp NVL vào → báo Kế hoạch xếp lại, chặn phát tới khi xếp lại. Đợt 3: silo nạp một lần dùng cho nhiều mẻ, được nạp bổ sung (mỗi lần nạp: bột trong silo + bao ≤ sức chứa); Admin chuyển bảo trì thì xem danh sách lệnh bị ảnh hưởng, không chuyển được khi silo còn bột của lệnh; lệnh đã phát dùng silo bảo trì bị chặn mẻ mới.
- **Hồ sơ pháp lý chung (QT02 hs, 04/11):** mã, tên hồ sơ, loại (pháp lý doanh nghiệp / an toàn thực phẩm / hệ thống chất lượng / chứng nhận thị trường / quảng cáo / gia công / khác), số hiệu, nơi cấp, ngày cấp, ngày hết hạn (hoặc không thời hạn), nhắc trước khi hết hạn (15–180 ngày; trạng thái Sắp hết hạn khi còn ≤ 30 ngày — 05/11), phạm vi áp dụng (toàn bộ SP / theo nơi sản xuất / chọn SP), file, trạng thái.
- **Hồ sơ NCC (QT11):** tên, MST, địa chỉ, người liên hệ, SĐT, email, NVL được phép cung cấp, chứng nhận (loại, số, ngày hết hạn — bắt buộc trừ giấy phép kinh doanh, file), hình thức thanh toán (Trả trước / Cọc + trả nốt trước giao — tỷ lệ cọc % (31/10) / Trả sau N ngày), phương thức, tài khoản ngân hàng, trạng thái (Chờ duyệt / Đã duyệt / Từ chối / Ngừng dùng), lý do, người duyệt, ngày duyệt, lịch sử trả hàng (QT13) và giao trễ / thiếu (QT12) — hiện ở chi tiết NCC, chỉ tra cứu.
- **Hàng đợi mua (QT12, sửa 04/11 — bỏ báo giá):** mỗi dòng = 1 NVL × kho nhận: nguồn (lệnh SX — phần Kế hoạch chọn bù bằng Mua / dưới tồn tối thiểu / Kế hoạch thêm tay `NC-`), SL thiếu, ngày cần, lệnh liên quan, NCC gợi ý; Mua hàng điền SL đặt, NCC, đơn giá, ngày giao ngay trên dòng; trạng thái dòng Chờ mua / Đang mua (đã lên PO) / Trả về Kế hoạch (lý do) / Đã hủy (nhu cầu lập tay, lý do). Màn Đơn mua 2 tab: Hàng đợi mua / Đơn mua (PO).
- **Phiếu mua hàng (PO):** mã PO, NCC (chỉ NCC ĐÃ DUYỆT đúng NVL), kho nhận, dòng NVL (SL, ĐVT, đơn giá, SL đã nhận), ngày giao, yêu cầu COA & HSD đã gửi (người, lúc, địa chỉ email), kết quả kiểm COA & HSD từng NVL (file COA, NSX, HSD, giá trị chỉ tiêu, người kiểm, lúc kiểm), hình thức thanh toán (Trả trước / Cọc + trả nốt trước giao — tỷ lệ cọc % / Trả sau N ngày — 31/10), phương thức (CK / tiền mặt), người tạo, người duyệt, ngày duyệt, lần gửi email PO, lý do hủy / từ chối / đóng, trạng thái (Chờ COA & HSD / Chờ chọn thanh toán / Chờ duyệt / Đã duyệt / Đã gửi NCC / Nhận một phần / Đã nhận đủ / Từ chối / Đã hủy / Đã đóng — theo mockup 30/10–04/11; bỏ Nháp, bỏ bảng so sánh báo giá).
- **Phiếu trả hàng NCC (QT13):** mã phiếu, PO, phiếu nhập, lô NCC, SL trả, lý do (hư / thiếu chứng từ / QC không đạt), ảnh hàng lỗi, số lô NCC ở dòng có lô, kết quả QC, hướng xử lý (đổi 1-1 / giảm công nợ / hủy), biên bản không thống nhất, phiếu xuất trả NCC, số tiền giảm trừ khoản phải trả (Kế toán ghi nhận ở Công nợ NCC), trạng thái (theo mockup: Chờ NCC xác nhận / Không thống nhất / NCC chấp nhận / Chờ duyệt xuất trả / Chờ kho xuất trả / Đã xuất trả / Chờ ký xác nhận / Hoàn tất / Chuyển hủy — thay Mở / Chờ NCC / Đã hủy hàng / Đóng). PO bắt buộc (đợt 3). SL tính theo ĐVT gốc của NVL; SL trả (dòng có lô) cộng mọi phiếu trả khác của PO, kể cả phiếu nhà máy chịu, không vượt SL đã nhận; SL trả của lô ≤ tồn hiện có của lô; hàng bị từ chối ở cửa kho (không có lô) so với SL trong biên bản từ chối, không tính vào số đã nhận. PO trả trước không chọn giảm công nợ.
- **Khách hàng:** tên, địa chỉ liên hệ, địa chỉ giao, SĐT, email, chức vụ, tên công ty, mã công ty, MST; thông tin thanh toán mặc định (sửa 23/10): hình thức thanh toán, phương thức (Chuyển khoản / Tiền mặt), số ngày nợ, tỷ lệ cọc %, tài khoản ngân hàng (ngân hàng · chi nhánh, số tài khoản, chủ tài khoản), email nhận hóa đơn điện tử; hạn mức công nợ (Kế toán đề xuất, GĐ / KTT duyệt — QT06), công nợ; trạng thái (theo mockup: Đang hoạt động / Tạm dừng giao dịch / Ngừng hoạt động — kèm lý do) và cờ tạm khóa do nợ quá hạn (tự động, QT10; bỏ "mất" 24/10); chi tiết khách hiện lịch sử liên hệ nhắc nợ (chỉ xem, ghi ở Kế toán › Công nợ KH).
- **Đơn hàng:** mã KH, ngày đặt, hợp đồng (số, hiệu lực từ – đến, file — nhập khi tạo đơn hoặc upload ở chi tiết đơn, 05/11), mã/tên/dòng SP, quy cách (lon/bao), SL, ĐVT, đơn giá, ngày giao dự kiến (Sales sửa trực tiếp, ghi nhật ký — 24/10), hình thức giao, VAT, trạng thái, người duyệt, ngày duyệt, lý do hủy, tiền cọc. Đã tách: đầu đơn (KH, ngày, hình thức thanh toán, phương thức thanh toán, tiền cọc, số ngày nợ — điền sẵn theo khách, sửa được; tài khoản khách và nội dung chuyển khoản lấy theo khách khi Chuyển khoản; HĐ, trạng thái; bỏ NV tiếp thị 23/10) + dòng hàng (SP, quy cách, SL, ĐVT, đơn giá, VAT). Sửa đơn sau khi chốt lưu phiên bản cũ. Trạng thái (theo mockup): Nháp → Chờ kiểm công nợ → Chờ xử lý nợ / Chờ duyệt hạn mức / Chờ khách (QT06) → Chờ thu tiền → Đã chốt → Đang sản xuất → Chờ nhập kho → Chờ kế toán duyệt → Chờ xuất kho (lô SX cho đơn — 05/11; đơn gắn lô tồn: Sẵn sàng giao) → Đang giao → Giao một phần / Đã giao; hủy đơn đã chốt: Chờ duyệt hủy → Đang hủy → Đã hủy (QT07); nhánh ra: Từ chối, Đã hủy (Sales hủy thẳng đơn Chờ thu tiền — 04/11; bỏ Chờ ký HĐ 05/11). Chi tiết đơn một trang: lịch thanh toán ở cột chính, tab Giao hàng luôn có (yêu cầu giao, tiến độ theo SP, phiếu xuất, chứng nhận, hóa đơn — 03/11). Lịch thanh toán (sinh khi chốt đơn ở QT05, tính lại khi sửa đơn ở QT08): mỗi khoản gồm loại (cọc / trả đủ / trả nốt / công nợ), số tiền, mốc đến hạn (trước SX / trước giao / sau giao N ngày), số đã thu.
- **Điều kiện công nợ (Mua chịu):** (1) không có nợ quá hạn; (2) dư nợ + (giá trị đơn − cọc) ≤ hạn mức, với dư nợ = công nợ hiện tại + giá trị còn lại của các đơn Mua chịu đã chốt chưa giao. Khóa dòng khách khi kiểm. Cờ "đã xin tăng hạn mức" gắn theo phiên bản đơn.
- **Điều kiện tạo LSX (8 mục theo thứ tự, sửa 24/10 đợt 8):** (1) khu sản xuất — loại lệnh HH / BTP theo khu; (2) nhu cầu đơn hàng — 1 mã SP, các dòng đơn đã chốt cùng SP và số lon phân bổ (mỗi dòng ≤ số lon còn lại); (3) công thức hiệu lực; (4) thời gian nhận đơn & dự kiến xong; (5) % hao hụt (05/11, 0–50%: khối lượng phải sản xuất = cần × (1 + %)), số mẻ & khối lượng mẻ (≤ mức tối đa của khu); (6) ~~giấy tờ xuất xứ NVL — 1 tệp đính kèm của lệnh~~ (bỏ 05/11); (7) tồn NVL khả dụng; (8) dàn silo — phương án NVL → silo (số NVL ≤ số silo đang hoạt động, đúng gán cứng, không dùng silo bảo trì; chốt khi tạo, kiểm lại khi phát). Lệnh BTP thêm kế hoạch nhãn hiệu của 1 mã SP: số lô in trên lon (nếu đã biết), số lon = tổng phân bổ từ các dòng đơn. Chỉ sản xuất theo đơn, không có lệnh tồn kho. Trạng thái lệnh: Mới tạo → Chờ phát (chỉ khi phát mà nhà máy không nhận) → Đã nhận → Đang chạy → Hoàn thành; Đã hủy (hủy lệnh chưa chạy bắt buộc lý do, giải phóng giữ chỗ). Không Nháp, không xóa. Thứ tự trong hàng đợi phát lệnh của khu = thứ tự chạy ở nhà máy (lệnh Chờ phát giữ vị trí). Đợt 3: chỉ sửa lệnh Mới tạo; Chờ phát / Đã nhận chỉ hủy (nhà máy xác nhận chưa chạy mẻ); Đang chạy chỉ kết thúc sớm (lý do, số mẻ thực tế, ngày giờ, người) hoặc thêm mẻ bù khi hủy mẻ.
- **Mã QR (bản gốc):** `{mã cha, mã nhà máy, loại, yyyymmdd, mã con}` vd `abcdef_NM1_NL_20261012_0001`. ⚠ Đề xuất: chỉ là mã định danh + tra CSDL. Chốt 16/10: mã bao HH và thùng sinh tại server nhà máy (mỗi nhà máy một tiền tố, không trùng nhau); lon dùng mã có sẵn trên bao bì, hệ thống không cấp; không có dải mã cấp trước. Chốt 20/10 (đợt 2): mã chứng từ sinh tại nhà máy có tiền tố nhà máy — phiếu nhập `PN-{NM}-{yymm}-{4 số}`, xuất `PX-`, chuyển `PC-`, kiểm kho `PK-`, hủy `PH-`, yêu cầu kiểm `YC-{NM}-`, phiếu kiểm `QC-{NM}-`, chứng nhận `CN-{NM}-`, mẫu lưu `ML-{NM}-` (vd `PN-NM1-2610-0001`); bộ đếm ở máy chủ nhà máy. Mã bao NVL cũng sinh tại nhà máy khi nhập. Mã danh mục, đơn, PO, lệnh, yêu cầu xuất bán, truy xuất, thu hồi chỉ sinh ở cloud, không đổi. Dữ liệu mẫu chung của mockup đổi theo.
- **Phiếu nhập kho:** mã phiếu, loại (mua hàng / trả từ SX / chuyển kho / hàng khách trả / hàng thu hồi), số HĐ NCC, SL dự kiến / SL nhận từng dòng, người xác nhận chênh lệch, lúc xác nhận, ghi chú lệch, lý do yêu cầu đếm lại (24/10 đợt 7 — thay người duyệt / lý do từ chối), mã QR, ngày tạo, người tạo, lý do, ảnh chứng từ, kho, NCC, trạng thái (Chờ nhận hàng / Đang nhận / Chờ xác nhận lệch / Đã nhập / Đã hủy — đợt 7), danh sách NL, đơn mua. Mỗi lô: số lô NCC, NSX, HSD, file đánh giá bên ngoài (bắt buộc, ≥ 1 file), kết quả kiểm HSD. Bổ sung 16/10: danh sách bao hư (mã / SL, lý do, ảnh, hướng xử lý: trả NCC / NCR / ghi biên bản).
- **Phiếu xuất kho:** mã phiếu, ngày yêu cầu, ngày tạo, người tạo, lý do, ảnh chứng từ, kho, trạng thái, danh sách NL, đối tượng nhận, loại xuất (bán / SX / chuyển kho / trả NCC), tổng SL, trạng thái kho, người yêu cầu, kho nhận, người duyệt, thời gian duyệt, lý do từ chối. Bổ sung 16/10: mỗi dòng ghi lô đề xuất, SL đề xuất, SL thực xuất; trạng thái Chờ lấy hàng (mọi loại vào thẳng khi lập, không duyệt — 24/10 đợt 6, đổi tên đợt 7) / Đang lấy hàng (tự chuyển khi quét bao / thùng đầu tiên) / Chờ bên yêu cầu (thiếu, không có lô thay thế, mọi loại xuất kể cả SX — 19/10 đợt 2, 3) / Đã xuất / Xuất một phần / Từ chối (theo mockup, kèm lý do) / Đã hủy.
- **Yêu cầu xuất bán & ghi nhận giao (QT09, sửa 24/10 — thay đợt giao):** yêu cầu xuất bán do Sales lập từ đơn (mã, đơn, dòng, SL giao lần này, ngày giao dự kiến, người lập; chỉ lô ở 1 nhà máy; sao xuống nhà máy; trạng thái Chờ thanh toán / Chờ xuất / Bị trả về / Đã xuất / Đã ghi nhận / Đã hủy; lý do trả về (nhà máy), lý do hủy, người hủy, lúc hủy) → máy chủ nhà máy tự lập 1 phiếu xuất bán, vào thẳng Chờ lấy hàng (đợt 4). Lịch thanh toán: mỗi yêu cầu tách một khoản trả nốt riêng = giá trị phần xuất × (1 − % cọc), khoản gốc giảm tương ứng. Ghi nhận theo phiếu xuất (biên bản giao nhận): lô, SL xuất, SL khách nhận, SL không nhận + lý do (từ chối / hư / thiếu), ngày nhận, ảnh biên bản ký nhận, người ghi nhận. Không có địa chỉ, lịch, xe, tài xế.
- **Hóa đơn bán hàng (QT10, sửa 04/11):** số hóa đơn, ký hiệu, ngày, mã tra cứu, đơn hàng, phiếu xuất gắn kèm (lần giao), khách (tên, MST, địa chỉ, email nhận hóa đơn), dòng hàng (SP, lô, SL, đơn giá, VAT), tổng tiền, người lập, trạng thái (Đã phát hành), số lần in; một đơn nhiều hóa đơn; MES in A4, in lại đóng dấu BẢN SAO và ghi nhật ký (thay bản 24/10: chỉ số, ngày, file, không gắn phiếu xuất).
- **Ghi nhận thu / chi (QT10, QT12, QT13 — thêm 19/10):** loại (thu / chi), mục đích (tiền về của khách / hoàn tiền khách / trả NCC), khách hoặc NCC, đơn / PO (nếu có), số tiền, ngày, CK / tiền mặt, ảnh chứng từ (bắt buộc), người ghi nhận, các khoản đã cấn (khoản trong lịch thanh toán, số tiền), trạng thái (Đã ghi nhận / Đã hủy — nhập sai, kèm lý do). Không duyệt, không hạch toán, hệ thống không tự sinh. Công nợ khách: hạn mức, dư nợ, nợ quá hạn, cờ tạm khóa (tự động), kết quả xử lý nợ quá 90 ngày (Kế toán ghi). Công nợ NCC: khoản phải trả theo PO, đã trả, giảm trừ khi trả hàng.
- **Kiểm kho:** số lượng, đúng hàng, lô & HSD, tình trạng, thời điểm chốt số liệu; trạng thái phiếu (theo mockup): Đang kiểm / Chờ duyệt điều chỉnh / Đã điều chỉnh / Khớp.
- **Truy xuất:** truy ngược = từ lô TP về SX, mua hàng, NCC, đơn hàng, NL, chất lượng; truy xuôi = từ lô NL tới khách hàng.
- **Phiếu truy xuất (QT25):** mã phiếu, nguồn yêu cầu (QT26 / QC / cơ quan / nội bộ), lý do, loại mã + mã đầu vào (QR lon / thùng / bao, số lô, mã đơn hàng, mã khách hàng, mã NVL — 04/11), lô được chọn, hướng (ngược / xuôi), người truy xuất, thời điểm bắt đầu / hoàn thành, chuỗi lô (NVL ↔ silo ↔ mẻ ↔ BTP / TP ↔ lon ↔ thùng ↔ phiếu xuất ↔ khách), danh sách khách + SL đã nhận, hồ sơ QC / COA / mẫu lưu / NCR của từng lô, kết quả cân bằng khối lượng từng lô, biên bản chênh lệch, file báo cáo.
- **Hồ sơ thu hồi (QT26):** mã hồ sơ, nguồn (khách / đại lý báo lỗi / QT23 / QT25 / QT22 / cơ quan), lô nghi lỗi, lô liên quan (từ QT25), mức nguy hại, phạm vi (kho / đại lý / người dùng), quyết định (thu hồi / khoanh vùng), người ký, ngày, báo cáo cơ quan (ngày gửi, file), danh sách khách + SL đã giao + SL thu về, % thu hồi, xử lý lô (hủy, phiếu QT18), đổi lô mới / hoàn tiền (đơn QT05 / ghi nhận hoàn tiền QT10), nguyên nhân gốc, hành động khắc phục (CAPA), trạng thái (Mở / Đang thu / Đã xử lý lô / Đã đóng).
- **Tham số mặc định (cấu hình lại được trong hệ thống; màn Quản trị › Tham số & định dạng mã):** QT12: PO trên 100 triệu đồng cần GĐ duyệt; thời gian NCC giao hàng mặc định 14 ngày (NVL để trống thời gian giao — dùng tính ngày cần ở Hàng đợi mua, 04/11). QT01: tự khóa khi không đăng nhập 90 ngày, báo trước ngày khóa 3 ngày (bỏ rà soát hằng quý và gợi ý 60 ngày — 28/10). Quy tắc mật khẩu không phải tham số (cố định trong code). QT06: trạng thái chờ quá 3 ngày nhắc Sales, quá 7 ngày tự Từ chối. QT09: chờ thu đủ / khách bị khóa 14 ngày rồi sang QT07; hủy đơn đề xuất giữ toàn bộ cọc (bỏ 24/10: chờ liên hệ khách 7 ngày, dời ngày giao 3 ngày, khách "mất" 30 ngày). QT10: quá hạn 3 ngày nhắc (thông báo trong hệ thống cho Sales, Kế toán), rồi nhắc mỗi 7 ngày; khoản trước giao quá 14 ngày báo QT gọi; công nợ sau giao quá 90 ngày báo GĐ / KTT quyết bên ngoài. QT14: HSD còn ≥ 2/3 hạn dùng khi nhận. QT16: hàng thiếu khi nhận chuyển kho chờ tìm 7 ngày rồi lập biên bản thất lạc; hạn xuất yêu cầu chuyển liên nhà máy = ngày cần − thời gian đi 1 ngày − đệm 1 ngày (nội bộ 0; theo màn Kho mockup — 30/10). QT18: lô hết hạn chưa hủy quá 30 ngày thì nhắc Thủ kho trưởng (bỏ cảnh báo cận date 24/10 đợt 9). QT15 / QT19 / QT20: hạn còn lại tối thiểu khi dùng cho SX 30 ngày, cấu hình theo nhóm / mã NVL (thêm 24/10 đợt 9). QT19: phát lệnh không tới quá 10 phút báo Kế hoạch; mất kết nối quá 30 giây vào ngoại tuyến; không giới hạn thời gian ngoại tuyến (bỏ 8 giờ — 20/10 đợt 2); hàng đợi gửi lên giữ 30 ngày sau khi cloud xác nhận; lệch giờ nhà máy – cloud quá 5 phút cảnh báo Admin. QT24: thời hạn lưu mẫu do QC tự quyết (gợi ý ban đầu HSD + 6 tháng). QT25: lưu hồ sơ truy xuất ≥ HSD + 12 tháng (bỏ mục tiêu truy xuất ≤ 4 giờ — 29/10). QT26: hoàn thành thu hồi trong 30 ngày.



# Mảng 1 · Nền tảng

## QT01. Quy trình Phân quyền và Vòng đời tài khoản

Vòng đời tài khoản: tạo → đổi vai trò → khóa khi nghỉ; thêm mở khóa / cấp lại mật khẩu và tự khóa khi lâu không đăng nhập. HR (hoặc Admin) tạo / sửa tài khoản và gán vai trò trực tiếp, không qua bước duyệt, không có bước bàn giao. Quyền gán qua VAI TRÒ theo bảng Vai trò × Chức năng (mục Vai trò × Chức năng) — vai trò là bộ quyền gốc; sửa 05/11: khi tạo tài khoản (hoặc ở Phân quyền từng người) HR / Admin tick bỏ / thêm từng quyền riêng cho người đó; phạm vi dữ liệu theo nhà máy / kho. Không có vai trò QS. Admin quản trị hệ thống và xem mọi màn, không làm bước nghiệp vụ (sửa 20/10); chỉ Admin gán vai trò Admin và Người truy xuất; HR và Admin không tự sửa vai trò của chính mình. Vắng mặt: HR (hoặc Admin) ủy quyền tạm một vai trò cho người khác, bắt buộc ngày hết hạn, đến hạn tự gỡ; ngày bắt đầu ở tương lai thì hiện "Sắp bắt đầu" (suy ra từ ngày). Công nhân SX / đóng gói dùng tài khoản riêng, gắn khu vực làm việc. Nghỉ việc: HR đặt ngày khóa tài khoản, đến ngày đó hệ thống tự khóa. Không xóa tài khoản đã dùng (tên còn trong nhật ký, hồ sơ mẻ, phiếu đã duyệt) — chỉ KHÓA; tài khoản chưa từng dùng (chưa đăng nhập, chưa có giao dịch) xóa hẳn được, mã NV không cấp lại, ghi nhật ký (chốt 04/11). Mọi thay đổi ghi nhật ký: ai làm, vai trò trước / sau, thời điểm. Sửa 19/10 (đợt 2): không còn máy quét riêng — web đăng nhập bằng mã NV + mật khẩu; quét thẻ NV chỉ còn ở PC xưởng (thẻ của tài khoản đã khóa bị chặn ngay); mã thẻ bắt buộc với công nhân, không bắt buộc với người khác. Sửa 19/10: lần đầu / sau mật khẩu tạm bắt đổi mật khẩu; quy tắc mật khẩu cố định trong code (≥ 8 ký tự, có cả chữ và số), không phải tham số. Sửa 28/10: bỏ rà soát quyền hằng quý và vai trò Trưởng bộ phận. Sửa 20/10: Admin không toàn quyền — quản trị hệ thống và xem mọi màn (xa), không làm bước nghiệp vụ; cần làm thì gán thêm vai trò đó. Chốt 04/11 (theo mockup): màn Vai trò × quyền sửa được (thay quyết định 19/10 "chỉ để xem") — Admin sửa quyền của vai trò (tick Xem / Tạo / Sửa / Duyệt / Hủy từng quyền), thêm / sửa / xóa quyền trong danh mục quyền (xóa quyền đang cấp thì gỡ khỏi mọi vai trò), đặt phạm vi nhà máy của vai trò và của từng quyền (Theo vai trò / Mọi nhà máy / Nhà máy của tài khoản / cố định một nhà máy); từng người chỉnh phạm vi vai trò ở Tài khoản › Đổi vai trò; thay đổi áp dụng từ lần đăng nhập tới của người giữ vai trò, ghi nhật ký. Thêm vai trò Thủ kho điều phối (Thủ kho được gán kho điều phối — thay quyết định 20/10 số 9). Tài khoản: mã NV nhập khi tạo, SĐT, mã thẻ (bắt buộc với công nhân), ngày hiệu lực; ngày nghỉ việc và ngày khóa tách riêng (khóa ngay / vào ngày nghỉ / ngày khác), chỉ HR đặt.

```quy-trinh
so: 1
mang: Nền tảng
tu: QT1
ten-ngan: Phân quyền
ten: Quy trình Phân quyền và Vòng đời tài khoản
ghi-chu: Vòng đời tài khoản: tạo → đổi vai trò → khóa khi nghỉ; thêm mở khóa / cấp lại mật khẩu và tự khóa khi lâu không đăng nhập. HR (hoặc Admin) tạo / sửa tài khoản và gán vai trò trực tiếp, không qua bước duyệt, không có bước bàn giao. Quyền gán qua VAI TRÒ theo bảng Vai trò × Chức năng (mục Vai trò × Chức năng) — vai trò là bộ quyền gốc; sửa 05/11: khi tạo tài khoản (hoặc ở Phân quyền từng người) HR / Admin tick bỏ / thêm từng quyền riêng cho người đó; phạm vi dữ liệu theo nhà máy / kho. Không có vai trò QS. Admin quản trị hệ thống và xem mọi màn, không làm bước nghiệp vụ (sửa 20/10); chỉ Admin gán vai trò Admin và Người truy xuất; HR và Admin không tự sửa vai trò của chính mình. Vắng mặt: HR (hoặc Admin) ủy quyền tạm một vai trò cho người khác, bắt buộc ngày hết hạn, đến hạn tự gỡ; ngày bắt đầu ở tương lai thì hiện "Sắp bắt đầu" (suy ra từ ngày). Công nhân SX / đóng gói dùng tài khoản riêng, gắn khu vực làm việc. Nghỉ việc: HR đặt ngày khóa tài khoản, đến ngày đó hệ thống tự khóa. Không xóa tài khoản đã dùng (tên còn trong nhật ký, hồ sơ mẻ, phiếu đã duyệt) — chỉ KHÓA; tài khoản chưa từng dùng (chưa đăng nhập, chưa có giao dịch) xóa hẳn được, mã NV không cấp lại, ghi nhật ký (chốt 04/11). Mọi thay đổi ghi nhật ký: ai làm, vai trò trước / sau, thời điểm. Sửa 19/10 (đợt 2): không còn máy quét riêng — web đăng nhập bằng mã NV + mật khẩu; quét thẻ NV chỉ còn ở PC xưởng (thẻ của tài khoản đã khóa bị chặn ngay); mã thẻ bắt buộc với công nhân, không bắt buộc với người khác. Sửa 19/10: lần đầu / sau mật khẩu tạm bắt đổi mật khẩu; quy tắc mật khẩu cố định trong code (≥ 8 ký tự, có cả chữ và số), không phải tham số. Sửa 28/10: bỏ rà soát quyền hằng quý và vai trò Trưởng bộ phận. Sửa 20/10: Admin không toàn quyền — quản trị hệ thống và xem mọi màn (xa), không làm bước nghiệp vụ; cần làm thì gán thêm vai trò đó. Chốt 04/11 (theo mockup): màn Vai trò × quyền sửa được (thay quyết định 19/10 "chỉ để xem") — Admin sửa quyền của vai trò (tick Xem / Tạo / Sửa / Duyệt / Hủy từng quyền), thêm / sửa / xóa quyền trong danh mục quyền (xóa quyền đang cấp thì gỡ khỏi mọi vai trò), đặt phạm vi nhà máy của vai trò và của từng quyền (Theo vai trò / Mọi nhà máy / Nhà máy của tài khoản / cố định một nhà máy); từng người chỉnh phạm vi vai trò ở Tài khoản › Đổi vai trò; thay đổi áp dụng từ lần đăng nhập tới của người giữ vai trò, ghi nhật ký. Thêm vai trò Thủ kho điều phối (Thủ kho được gán kho điều phối — thay quyết định 20/10 số 9). Tài khoản: mã NV nhập khi tạo, SĐT, mã thẻ (bắt buộc với công nhân), ngày hiệu lực; ngày nghỉ việc và ngày khóa tách riêng (khóa ngay / vào ngày nghỉ / ngày khác), chỉ HR đặt.
cot: HR | Admin | Hệ thống
s | 0 | 0 | S | Nhân viên mới / chuyển BP / đổi chức danh / nghỉ việc / quên mật khẩu / vắng mặt cần ủy quyền
d0 | 0 | 1 | D | Loại thay đổi?
a1 | 0 | 2 | T | Nhập thông tin: mã NV, họ tên, BP, chức danh, nhà máy / kho / khu vực làm việc (bắt buộc với công nhân SX / đóng gói), mã thẻ NV (bắt buộc với công nhân — nhập tay mã in trên thẻ, không quét, 05/11), ngày hiệu lực; chọn vai trò → bước 2 tick quyền (tick sẵn theo vai trò, bỏ / thêm quyền riêng — 05/11)
dn | 1 | 2 | Y | Đăng nhập: web bằng mã NV + mật khẩu (mọi người dùng, kể cả thủ kho — quét mã ngay trên màn Kho); PC xưởng quét thẻ NV (công nhân); không có máy quét riêng; thẻ của tài khoản đã khóa bị chặn ngay; xác thực tại máy chủ nhà máy trên bản sao tài khoản (băm mật khẩu sao xuống), phiên lưu tại nhà máy — không phụ thuộc cloud (20/10 đợt 2)
y0 | 2 | 2 | Y | Kiểm trùng mã NV / email / SĐT / mã thẻ; gợi ý vai trò theo chức danh; chặn tự sửa vai trò của chính mình; chỉ Admin gán vai trò Admin, Người truy xuất
m1 | 1 | 3 | T | Xác minh người yêu cầu; mở khóa / cấp mật khẩu tạm (bắt đổi khi đăng nhập)
dt | 2 | 3 | D | Tạo mới hay\nđổi vai trò?
y1 | 2 | 4 | Y | Tạo tài khoản: gán vai trò + quyền riêng đã tick (bỏ / thêm so với vai trò — 05/11) + phạm vi nhà máy / kho; mật khẩu tạm, bắt đổi lần đầu
c2 | 1 | 4 | Y | Công nhân SX / đóng gói: tài khoản riêng từng người, gắn khu vực làm việc (khu HH / BTP / chiết rót & đóng gói); đăng nhập PC xưởng bằng quét thẻ NV; chỉ thấy và thao tác lệnh của khu mình; hồ sơ mẻ ghi đúng người vận hành
dp | 1 | 5 | Y | Quy tắc mật khẩu cố định trong code (không phải tham số): ≥ 8 ký tự, có cả chữ và số; đổi mật khẩu kiểm theo quy tắc này
y2 | 2 | 5 | Y | Gỡ vai trò cũ, gán vai trò mới trong 1 giao dịch (không có lúc giữ cả 2)
yl | 2 | 6 | Y | Ghi nhật ký: ai làm, vai trò trước / sau, thời điểm; báo nhân viên
e1 | 2 | 7 | E | Kết thúc
n1 | 0 | 8 | T | Nhập ngày nghỉ việc; đặt ngày khóa tài khoản (mặc định = ngày nghỉ; chọn khóa ngay hoặc ngày khác; sửa được trước ngày khóa)
ny | 2 | 9 | Y | Lưu lịch khóa; trước ngày khóa 3 ngày (mặc định) báo HR
nk | 2 | 10 | Y | Đến ngày khóa đã đặt: tự KHÓA tài khoản, đăng xuất mọi phiên, chặn thẻ / mã quét ngay; không xóa; ghi nhật ký; khóa tài khoản là lệnh từ trung tâm (QT19 kl): nhà máy đang mất mạng thì có hiệu lực khi có mạng lại
e2 | 2 | 11 | E | Kết thúc
s3 | 2 | 12 | S | Hằng ngày quét đăng nhập
r1 | 2 | 13 | Y | Hằng ngày: không đăng nhập quá 90 ngày (mặc định) → tự khóa, ghi nhật ký (bỏ rà soát hằng quý — 28/10)
c3 | 1 | 13 | Y | ⚙ MẶC ĐỊNH (cấu hình lại được): không đăng nhập 90 ngày thì tự khóa; báo trước ngày khóa 3 ngày
e3 | 2 | 14 | E | Kết thúc
u1 | 0 | 15 | T | Ủy quyền tạm khi vắng: chọn người vắng, vai trò ủy quyền (Giám đốc, Kế toán trưởng, Thủ kho trưởng, Trưởng BP Mua hàng, QC trưởng, Kế hoạch), người nhận, ngày bắt đầu, ngày hết hạn (bắt buộc)
u2 | 2 | 16 | Y | Gán vai trò tạm cho người nhận trong khoảng ngày (trước ngày bắt đầu hiện "Sắp bắt đầu" — suy ra từ ngày, không thêm trạng thái); người nhận vẫn không được duyệt phiếu chính mình tạo; ghi nhật ký, báo cả 2 người
u3 | 2 | 17 | Y | Đến ngày hết hạn: tự gỡ vai trò tạm, ghi nhật ký
e4 | 2 | 18 | E | Kết thúc
xt | 0 | 19 | T | Xóa tài khoản chưa từng dùng (chưa đăng nhập, chưa có giao dịch): xóa hẳn, mã NV không cấp lại, ghi nhật ký; đã dùng thì chỉ khóa (chốt 04/11)
e5 | 2 | 19 | E | Kết thúc
s4 | 1 | 20 | S | Cần đổi quyền của vai trò
vq | 1 | 21 | T | Admin sửa Vai trò × quyền: tick Xem / Tạo / Sửa / Duyệt / Hủy từng quyền, thêm / sửa / xóa quyền, phạm vi nhà máy theo vai trò và theo quyền (chốt 04/11, thay "chỉ xem")
yq | 2 | 21 | Y | Lưu bộ quyền mới của vai trò; áp dụng từ lần đăng nhập tới của người giữ vai trò; ghi nhật ký (trước / sau, người sửa)
e6 | 2 | 22 | E | Kết thúc
---
s -> d0
d0 -> a1 : Mới / đổi vai trò
d0 -> n1 : Nghỉ việc
d0 -> m1 : Quên mật khẩu / bị khóa
a1 -> y0
dn -> m1 :  : n
y0 -> dt
dt -> y1 : Tạo mới
dt -> y2 : Đổi vai trò
c2 -> y1 :  : n
dp -> y1 :  : n
y1 -> yl
y2 -> yl
m1 -> yl
yl -> e1
n1 -> ny
ny -> nk
nk -> e2
s3 -> r1
c3 -> r1 :  : n
r1 -> e3
d0 -> u1 : Ủy quyền tạm
u1 -> u2
u2 -> u3
u3 -> e4
d0 -> xt : Xóa tài khoản chưa dùng
xt -> e5
s4 -> vq
vq -> yq
yq -> e6
```

## QT02. Quy trình Quản lý danh mục (NVL, SP & danh mục SP, kho)

Danh mục chỉ còn 3 loại (sửa 24/10, bỏ vị trí kệ): NVL, SP, kho — bỏ thiết bị đo; thiết bị SX và đơn vị tính không thuộc danh mục (nạp khi triển khai). NCC vẫn tạo ở QT11. Mã do hệ thống tự sinh theo định dạng của từng loại, không duyệt. NVL, SP (nhánh trên): bộ phận đề xuất tạo / sửa; ngừng dùng (nhánh dưới) qua đề nghị → trưởng của bên đề xuất duyệt (Mua hàng → Trưởng BP Mua hàng, Kho → Thủ kho trưởng, QC → QC trưởng; hiện trong Việc cần làm), Kế hoạch tự ngừng không qua duyệt (28/10), người đề xuất rút được đề nghị khi đang chờ duyệt; kiểm tham chiếu gồm tồn kho, phiếu đang mở, đơn mua đang mở, công thức hiệu lực. Nhà máy, khu vực làm việc, kho (nhánh giữa): làm trực tiếp, không qua đề nghị — Admin tạo / sửa / ngừng dùng. Bộ trường bắt buộc theo loại xem mục "Biểu mẫu dữ liệu". Sửa 19/10 (đợt 2): khu vực làm việc có loại HH / BTP / chiết rót & đóng gói (gộp 05/11), khu HH / BTP có khối lượng mẻ tối đa và dàn silo riêng do Admin cấu hình ngay trong khu (thêm silo, sửa sức chứa / gán cứng NVL / mã SCADA, chuyển bảo trì / ngừng dùng); chặn đổi loại khu khi còn lệnh chưa hoàn thành; không xóa khu, chỉ ngừng dùng. Silo là thiết bị SX duy nhất có màn quản lý; thiết bị khác vẫn nạp khi triển khai. Sửa 19/10 (đợt 4): SP có thêm 4 danh mục chính thức — dòng SP (kèm các hạng áp dụng), quy cách đóng gói (cách đóng gói × khối lượng tịnh, các số lượng mỗi thùng), hạng, thương hiệu — nằm trong Danh mục › Sản phẩm, đi cùng nhánh trên như NVL / SP: bộ phận đề xuất thêm / sửa, mã tự sinh không duyệt; ngừng dùng như NVL / SP (trưởng bên đề xuất duyệt, Kế hoạch tự ngừng), chặn khi còn SP đang dùng. Mỗi mã SP = thương hiệu × dòng × hạng × công thức × quy cách đóng gói × số lon / thùng, 1 barcode (chốt 20/10 đợt 3); màn Danh mục SP nhóm các mã cùng thương hiệu × dòng × hạng thành 1 nhóm hiển thị. NCC, kho, nhà máy có màn trong Danh mục: Danh mục › Nhà cung cấp là danh sách gốc — tạo mới ở trạng thái Chờ duyệt, duyệt theo QT11; kho, nhà máy vẫn do Admin (ka). Chốt 30/10 – 04/11 (theo mockup): (1) NVL bắt buộc ít nhất 1 chỉ tiêu COA (thay bản bỏ COA 24/10 — dùng kiểm COA & HSD của NCC trước PO, QT12); thêm nguyên liệu kỵ nhau (chọn nhiều, quan hệ hai chiều), tối đa 5 ảnh (ảnh đầu là ảnh chính), tồn tối thiểu và cách bù khi dưới tồn tối thiểu (30/10); NVL hỗn hợp chọn công thức sinh ra. (2) Mô hình sản phẩm mới (04/11, thay "mỗi quy cách × số lon / thùng là một mã SP" 20/10 và 4 danh mục SP đợt 4): một mã SP có cấu trúc / nhóm / phân loại / độ tuổi (ô chọn, lựa chọn sửa ngay trong ô chọn), mục khác gõ tự do (thương hiệu…), quy cách đóng gói nhiều cấp, mẫu nhãn từng quy cách — QC trưởng duyệt mẫu nhãn (ml), bản công bố và hồ sơ pháp lý; SP đã lưu chỉ sửa mẫu nhãn và hồ sơ pháp lý, đổi thông tin thì sao chép thành SP mới. (3) Một nhà máy được nhiều kho điều phối (NM1-DP, NM1-DP2…), mỗi khu chọn 1 kho điều phối cấp NVL (04/11). (4) Cho xóa bản ghi chưa từng dùng: đơn vị, lựa chọn của ô chọn SP, quy cách chưa có tham chiếu; bản ghi đã dùng vẫn chỉ khóa / ngừng dùng (04/11). (5) Đơn vị (dv) và Hồ sơ pháp lý chung (hs) là màn trong Danh mục: Admin quản lý đơn vị; Giám đốc (và Admin) quản lý hồ sơ pháp lý chung (tên, loại, số hiệu, nơi cấp, ngày cấp, hết hạn, nhắc trước, phạm vi áp dụng). Nhà máy có tiền tố mã định danh (1–4 chữ hoa / số, không trùng).

```quy-trinh
so: 2
mang: Nền tảng
tu: mới
ten-ngan: Danh mục
ten: Quy trình Quản lý danh mục (NVL, SP & danh mục SP, kho)
ghi-chu: Danh mục chỉ còn 3 loại (sửa 24/10, bỏ vị trí kệ): NVL, SP, kho — bỏ thiết bị đo; thiết bị SX và đơn vị tính không thuộc danh mục (nạp khi triển khai). NCC vẫn tạo ở QT11. Mã do hệ thống tự sinh theo định dạng của từng loại, không duyệt. NVL, SP (nhánh trên): bộ phận đề xuất tạo / sửa; ngừng dùng (nhánh dưới) qua đề nghị → trưởng của bên đề xuất duyệt (Mua hàng → Trưởng BP Mua hàng, Kho → Thủ kho trưởng, QC → QC trưởng; hiện trong Việc cần làm), Kế hoạch tự ngừng không qua duyệt (28/10), người đề xuất rút được đề nghị khi đang chờ duyệt; kiểm tham chiếu gồm tồn kho, phiếu đang mở, đơn mua đang mở, công thức hiệu lực. Nhà máy, khu vực làm việc, kho (nhánh giữa): làm trực tiếp, không qua đề nghị — Admin tạo / sửa / ngừng dùng. Bộ trường bắt buộc theo loại xem mục "Biểu mẫu dữ liệu". Sửa 19/10 (đợt 2): khu vực làm việc có loại HH / BTP / chiết rót & đóng gói (gộp 05/11), khu HH / BTP có khối lượng mẻ tối đa và dàn silo riêng do Admin cấu hình ngay trong khu (thêm silo, sửa sức chứa / gán cứng NVL / mã SCADA, chuyển bảo trì / ngừng dùng); chặn đổi loại khu khi còn lệnh chưa hoàn thành; không xóa khu, chỉ ngừng dùng. Silo là thiết bị SX duy nhất có màn quản lý; thiết bị khác vẫn nạp khi triển khai. Sửa 19/10 (đợt 4): SP có thêm 4 danh mục chính thức — dòng SP (kèm các hạng áp dụng), quy cách đóng gói (cách đóng gói × khối lượng tịnh, các số lượng mỗi thùng), hạng, thương hiệu — nằm trong Danh mục › Sản phẩm, đi cùng nhánh trên như NVL / SP: bộ phận đề xuất thêm / sửa, mã tự sinh không duyệt; ngừng dùng như NVL / SP (trưởng bên đề xuất duyệt, Kế hoạch tự ngừng), chặn khi còn SP đang dùng. Mỗi mã SP = thương hiệu × dòng × hạng × công thức × quy cách đóng gói × số lon / thùng, 1 barcode (chốt 20/10 đợt 3); màn Danh mục SP nhóm các mã cùng thương hiệu × dòng × hạng thành 1 nhóm hiển thị. NCC, kho, nhà máy có màn trong Danh mục: Danh mục › Nhà cung cấp là danh sách gốc — tạo mới ở trạng thái Chờ duyệt, duyệt theo QT11; kho, nhà máy vẫn do Admin (ka). Chốt 30/10 – 04/11 (theo mockup): (1) NVL bắt buộc ít nhất 1 chỉ tiêu COA (thay bản bỏ COA 24/10 — dùng kiểm COA & HSD của NCC trước PO, QT12); thêm nguyên liệu kỵ nhau (chọn nhiều, quan hệ hai chiều), tối đa 5 ảnh (ảnh đầu là ảnh chính), tồn tối thiểu và cách bù khi dưới tồn tối thiểu (30/10); NVL hỗn hợp chọn công thức sinh ra. (2) Mô hình sản phẩm mới (04/11, thay "mỗi quy cách × số lon / thùng là một mã SP" 20/10 và 4 danh mục SP đợt 4): một mã SP có cấu trúc / nhóm / phân loại / độ tuổi (ô chọn, lựa chọn sửa ngay trong ô chọn), mục khác gõ tự do (thương hiệu…), quy cách đóng gói nhiều cấp, mẫu nhãn từng quy cách — QC trưởng duyệt mẫu nhãn (ml), bản công bố và hồ sơ pháp lý; SP đã lưu chỉ sửa mẫu nhãn và hồ sơ pháp lý, đổi thông tin thì sao chép thành SP mới. (3) Một nhà máy được nhiều kho điều phối (NM1-DP, NM1-DP2…), mỗi khu chọn 1 kho điều phối cấp NVL (04/11). (4) Cho xóa bản ghi chưa từng dùng: đơn vị, lựa chọn của ô chọn SP, quy cách chưa có tham chiếu; bản ghi đã dùng vẫn chỉ khóa / ngừng dùng (04/11). (5) Đơn vị (dv) và Hồ sơ pháp lý chung (hs) là màn trong Danh mục: Admin quản lý đơn vị; Giám đốc (và Admin) quản lý hồ sơ pháp lý chung (tên, loại, số hiệu, nơi cấp, ngày cấp, hết hạn, nhắc trước, phạm vi áp dụng). Nhà máy có tiền tố mã định danh (1–4 chữ hoa / số, không trùng).
cot: Bộ phận đề xuất (Mua hàng / Kế hoạch / Kho / QC) | Trưởng bên đề xuất (TBP Mua hàng / Thủ kho trưởng / QC trưởng) | Admin | Hệ thống
s | 0 | 0 | S | Cần mã NVL / SP mới hoặc sửa danh mục
t1 | 0 | 1 | T | Chọn loại (NVL / SP), điền thông tin. NVL: bộ chỉ tiêu COA (≥ 1), nguyên liệu kỵ nhau, tối đa 5 ảnh, tồn tối thiểu, cách bù (30/10, 04/11), quy cách đóng gói nhiều cấp như SP (05/11). SP (04/11): cấu trúc, nhóm, phân loại, độ tuổi (ô chọn; thêm / sửa lựa chọn ngay trong ô chọn), tên công ty, nơi sản xuất, công thức, HSD, mục khác (thương hiệu…; mỗi mục chọn loại ô nhập — 05/11), quy cách đóng gói nhiều cấp, barcode, mẫu nhãn từng quy cách, bản công bố, hồ sơ pháp lý riêng / chung
y0 | 3 | 1 | Y | Hiện bộ trường bắt buộc theo loại; thiếu thì không cho lưu (NVL: ít nhất 1 chỉ tiêu COA; SP: bản công bố có file)
y1 | 3 | 2 | Y | Kiểm tra trùng tên / mã (SP: barcode trùng; lựa chọn: trùng tên trong cùng ô chọn)
d1 | 3 | 3 | D | Trùng?
t2 | 0 | 4 | T | Dùng mã có sẵn hoặc sửa thông tin
f1 | 1 | 4 | F | ⚠ SỬA: mã đã có giao dịch thì khóa ĐVT, quy cách — muốn đổi phải tạo mã mới. SP đã lưu chỉ sửa mẫu nhãn và hồ sơ pháp lý; đổi thông tin / quy cách thì sao chép thành SP mới (04/11)
y2 | 3 | 5 | Y | Hệ thống tự sinh mã theo định dạng của từng loại (vd NVL-BOT-0001, SP-0001; xem biểu mẫu Danh mục), không duyệt; trạng thái ĐANG DÙNG, ghi nhật ký
ml | 1 | 6 | T | SP: QC trưởng duyệt mẫu nhãn từng quy cách (Chờ duyệt → Đã duyệt); lệnh BTP chỉ tạo được khi mẫu nhãn đã duyệt và bản công bố còn hiệu lực (QT19 — 04/11)
xo | 0 | 6 | T | Xóa lựa chọn của ô chọn SP chưa SP nào dùng; đang dùng thì không xóa (04/11)
e1 | 3 | 7 | E | Kết thúc
s4 | 2 | 8 | S | Cần nhà máy / khu vực làm việc / kho / đơn vị (Admin); hồ sơ pháp lý chung (Giám đốc)
ka | 2 | 9 | T | Admin tạo / sửa / ngừng dùng nhà máy (tiền tố mã định danh 1–4 chữ hoa / số, không trùng; địa chỉ, điện thoại, email), khu vực làm việc (loại HH / BTP / chiết rót & đóng gói — gộp 05/11; khối lượng mẻ tối đa với khu HH / BTP; kho điều phối cấp NVL), kho — làm trực tiếp (mã kho {nhà máy}-{loại kho}; mỗi nhà máy 1 kho tổng, 1 kho BTP, 1 kho mẫu lưu QC, được nhiều kho điều phối NM1-DP, NM1-DP2… — 04/11); không xóa, chỉ ngừng dùng
ks | 2 | 10 | T | Khu HH / BTP: Admin cấu hình dàn silo — thêm silo (tên, sức chứa kg, gán cứng 1 NVL tùy chọn, mã thiết bị trên SCADA), sửa, chuyển Hoạt động / Bảo trì / Ngừng dùng
ksy | 3 | 10 | Y | Chặn đổi loại khu khi khu còn lệnh chưa hoàn thành. Silo chuyển bảo trì / ngừng dùng: hiện danh sách lệnh bị ảnh hưởng để Admin xác nhận; chặn khi silo còn bột của lệnh. Lệnh Mới tạo → báo Kế hoạch xếp lại, chặn phát; lệnh đã phát → chặn mẻ mới (QT19). Giảm KL mẻ tối đa: lệnh Mới tạo vượt mức bị chặn phát
e3 | 3 | 11 | E | Kết thúc
dv | 2 | 11 | T | Đơn vị (Danh mục › Đơn vị): Admin thêm / sửa / xóa đơn vị chưa có tham chiếu (mã, tên, loại, quy đổi, trạng thái); đơn vị đã có NVL / SP / công thức / chứng từ dùng thì khóa sửa và xóa (04/11)
hs | 2 | 12 | T | Hồ sơ pháp lý chung (Danh mục › Hồ sơ pháp lý chung): Giám đốc (hoặc Admin) tạo / sửa / xóa — tên, loại, số hiệu, nơi cấp, ngày cấp, ngày hết hạn (hoặc không thời hạn), nhắc trước khi hết hạn, phạm vi áp dụng (toàn bộ SP / theo nơi sản xuất / chọn SP), file; SP chọn hồ sơ chung áp dụng (04/11); còn ≤ 30 ngày là Sắp hết hạn, màn cảnh báo và lọc hồ sơ cần gia hạn (05/11)
s2 | 0 | 12 | S | Cần ngừng dùng mã NVL / SP
y3 | 3 | 13 | Y | Kiểm tra tham chiếu: tồn kho, phiếu đang mở, đơn mua đang mở, công thức hiệu lực
d3 | 3 | 14 | D | Còn tham chiếu?
t3 | 0 | 15 | T | Xử lý hết tồn / phiếu / đơn mua trước
dk | 3 | 15 | D | Bên đề xuất\nlà Kế hoạch?
tk | 0 | 16 | T | Kế hoạch ngừng dùng trực tiếp, ghi lý do — không qua duyệt (28/10)
tg | 0 | 17 | T | Gửi đề nghị ngừng dùng (lý do) → hiện trong Việc cần làm của trưởng bên đề xuất (Mua hàng → Trưởng BP Mua hàng, Kho → Thủ kho trưởng, QC → QC trưởng)
d4 | 1 | 18 | D | Duyệt ngừng?
tr | 0 | 18 | T | Người đề xuất rút đề nghị khi đang chờ duyệt
y4 | 3 | 19 | Y | Trạng thái NGỪNG DÙNG: ẩn khỏi phiếu mới, giữ cho truy xuất (không xóa); lưu đề nghị (người, lý do; NGỪNG TRỰC TIẾP với Kế hoạch)
e | 3 | 20 | E | Kết thúc
---
s -> t1
t1 -> y0
y0 -> y1
y1 -> d1
d1 -> t2 : Có
t2 -> e1
d1 -> y2 : Không
f1 -> y2 :  : n
y2 -> e1
y2 -> ml : SP có mẫu nhãn chờ duyệt
ml -> e1
t1 -> xo : Sửa lựa chọn
xo -> e1
s4 -> ka
ka -> ks : Khu HH / BTP
ka -> e3 : Nhà máy / kho / khu khác
ks -> ksy
ksy -> e3
s4 -> dv : Đơn vị
dv -> e3
s4 -> hs : Hồ sơ pháp lý chung
hs -> e3
s2 -> y3
y3 -> d3
d3 -> t3 : Còn
t3 -> y3 : Kiểm lại
d3 -> dk : Hết
dk -> tk : Có
dk -> tg : Không
tk -> y4
tg -> d4
tg -> tr : Rút khi chờ duyệt
tr -> e
d4 -> e : Không
d4 -> y4 : Có
y4 -> e
```

## QT03. Quy trình Ghi nhận công thức / BOM

Công thức chỉ ghi nhận, không có bước duyệt: người được phân quyền nhập là có hiệu lực. Vẫn giữ phiên bản để biết mẻ nào chạy theo công thức nào. Sửa 19/10: công thức thuộc phân hệ Sản xuất (R&D, Kế hoạch nhập / sửa; QC, công nhân chỉ xem); mã công thức hệ thống tự sinh CT-{loại}-{4 số} (loại HH / BTP), không sửa; thông số trộn chuẩn có thứ tự nạp; màn Công thức hiện lệnh nào đang chạy phiên bản cũ. Sửa 04/11: màn Công thức nằm trong menu Danh mục (theo mockup); ~~mỗi thành phần có dung sai (kg, bắt buộc), thông số trộn chuẩn gồm thời gian, tốc độ~~ (bỏ 05/11 — thứ tự nạp là thứ tự dòng); sao chép công thức có sẵn thành công thức mới (05/11); công nhân xem công thức trên PC xưởng.

```quy-trinh
so: 3
mang: Nền tảng
tu: mới
ten-ngan: Công thức / BOM
ten: Quy trình Ghi nhận công thức / BOM
ghi-chu: Công thức chỉ ghi nhận, không có bước duyệt: người được phân quyền nhập là có hiệu lực. Vẫn giữ phiên bản để biết mẻ nào chạy theo công thức nào. Sửa 19/10: công thức thuộc phân hệ Sản xuất (R&D, Kế hoạch nhập / sửa; QC, công nhân chỉ xem); mã công thức hệ thống tự sinh CT-{loại}-{4 số} (loại HH / BTP), không sửa; thông số trộn chuẩn có thứ tự nạp; màn Công thức hiện lệnh nào đang chạy phiên bản cũ. Sửa 04/11: màn Công thức nằm trong menu Danh mục (theo mockup); ~~mỗi thành phần có dung sai (kg, bắt buộc), thông số trộn chuẩn gồm thời gian, tốc độ~~ (bỏ 05/11 — thứ tự nạp là thứ tự dòng); sao chép công thức có sẵn thành công thức mới (05/11); công nhân xem công thức trên PC xưởng.
cot: R&D / Kế hoạch | Hệ thống
s | 0 | 0 | S | Có công thức mới / thay đổi công thức
t1 | 0 | 1 | T | Nhập công thức: loại (HH / BTP), NVL, tỷ lệ, KL mẻ; thứ tự dòng là thứ tự nạp (nút lên / xuống). Hoặc sao chép công thức có sẵn: lấy thành phần, KL mẻ, mặt hàng của phiên bản hiện hành, mã mới (05/11)
y0 | 1 | 1 | Y | Chỉ vai trò được phân quyền (QT01) mới nhập / sửa được
y1 | 1 | 2 | Y | Kiểm tra: NVL còn đang dùng (QT02), tổng KL thành phần = KL mẻ
d1 | 1 | 3 | D | Hợp lệ?
t2 | 0 | 3 | T | Sửa lại
y2 | 1 | 4 | Y | Công thức mới: tự sinh mã CT-{loại}-{4 số} (vd CT-HH-0001), không sửa được. Lưu phiên bản mới (người nhập, thời điểm); bản cũ → hết hiệu lực, giữ để truy xuất
y3 | 1 | 5 | Y | Lệnh SX mới dùng phiên bản hiệu lực (QT19); lệnh đã phát giữ phiên bản cũ; mẻ ghi số phiên bản; màn Công thức hiện lệnh nào đang chạy phiên bản cũ
e | 1 | 6 | E | Kết thúc
---
s -> t1
y0 -> t1 :  : n
t1 -> y1
y1 -> d1
d1 -> t2 : Không
t2 -> t1
d1 -> y2 : Có
y2 -> y3
y3 -> e
```

## QT04. Quy trình Xử lý tem hỏng / mất / hủy

Phần tạo mã và quét khi nhập đã gom vào QT14 Nhập kho. Mã bao HH (QT20) và thùng (QT21) sinh tại server nhà máy; lon dùng mã có sẵn trên bao bì lon, hệ thống không cấp mã lon. Ở đây chỉ còn xử lý tem có vấn đề sau khi hàng đã vào kho / SX. Chốt 17/10: tem lỗi phát hiện ở khu SX thì công nhân chỉ báo, Thủ kho điều phối xuống xử lý. Sửa 19/10 (đợt 2): không còn máy quét riêng — sự cố tem làm ở Kho · Tồn kho, do Thủ kho (kể cả Thủ kho điều phối với tem lỗi ở khu SX): chọn dòng lô → danh sách bao → "Sự cố tem". Tem hỏng: in lại cùng mã, dán, quét xác nhận. Tem mất: kho + lô lấy từ dòng tồn → chọn mã cũ để khóa → cấp mã mới cùng lô → in, dán, quét xác nhận. Hủy tem: bao còn trong kho thì đi như tem mất; bao không còn thì chỉ khóa mã, thu tem. Mã đã khóa bị quét ở bất kỳ màn nào: chặn, hiện mã thay thế.

```quy-trinh
so: 4
mang: Nền tảng
tu: QT8 (phần sự cố tem)
ten-ngan: Sự cố tem
ten: Quy trình Xử lý tem hỏng / mất / hủy
ghi-chu: Phần tạo mã và quét khi nhập đã gom vào QT14 Nhập kho. Mã bao HH (QT20) và thùng (QT21) sinh tại server nhà máy; lon dùng mã có sẵn trên bao bì lon, hệ thống không cấp mã lon. Ở đây chỉ còn xử lý tem có vấn đề sau khi hàng đã vào kho / SX. Chốt 17/10: tem lỗi phát hiện ở khu SX thì công nhân chỉ báo, Thủ kho điều phối xuống xử lý. Sửa 19/10 (đợt 2): không còn máy quét riêng — sự cố tem làm ở Kho · Tồn kho, do Thủ kho (kể cả Thủ kho điều phối với tem lỗi ở khu SX): chọn dòng lô → danh sách bao → "Sự cố tem". Tem hỏng: in lại cùng mã, dán, quét xác nhận. Tem mất: kho + lô lấy từ dòng tồn → chọn mã cũ để khóa → cấp mã mới cùng lô → in, dán, quét xác nhận. Hủy tem: bao còn trong kho thì đi như tem mất; bao không còn thì chỉ khóa mã, thu tem. Mã đã khóa bị quét ở bất kỳ màn nào: chặn, hiện mã thay thế.
cot: Thủ kho | Hệ thống
s | 0 | 0 | S | Phát hiện tem có vấn đề (trong kho; ở khu SX thì công nhân báo Thủ kho điều phối)
yb | 1 | 0 | Y | Mã đã khóa bị quét ở bất kỳ màn nào (Kho: nhập, xuất, nhận chuyển, kiểm kho; PC xưởng: quét bao nạp silo): chặn, hiện mã thay thế (nếu có)
t0 | 0 | 1 | T | Kho · Tồn kho: chọn dòng lô → mở danh sách bao → "Sự cố tem"
y0 | 1 | 2 | Y | Hiện các bao (mã đang kích hoạt) của lô trong kho; kho + lô lấy từ dòng tồn đã chọn
d2 | 0 | 3 | D | Loại sự cố?
t5a | 0 | 4 | T | Tem hỏng (mã còn đọc / tra được): chọn bao trong danh sách
y4 | 1 | 5 | Y | In lại cùng mã
t5 | 0 | 6 | T | Gỡ tem hỏng, dán tem mới, quét xác nhận
t6c | 0 | 7 | T | Tem mất: chọn mã cũ (của bao bị mất tem) trong danh sách để khóa
y5 | 1 | 8 | Y | Khóa mã cũ, cấp mã mới cùng lô (mã cũ trỏ sang mã thay thế; mã mới mang trạng thái + lý do khóa của bao cũ), in tem
t6 | 0 | 9 | T | Dán tem mới, quét xác nhận
t4 | 0 | 10 | T | Hủy tem: chọn mã cần hủy trong danh sách
dh | 0 | 11 | D | Bao còn trong kho?
y8 | 1 | 12 | Y | Khóa mã, ghi nhật ký; thủ kho thu tem vật lý
e | 1 | 13 | E | Kết thúc
---
s -> t0
t0 -> y0
y0 -> d2
yb -> y5 :  : n
d2 -> t5a : Hỏng
t5a -> y4
y4 -> t5
t5 -> e
d2 -> t6c : Mất
t6c -> y5
y5 -> t6
t6 -> e
d2 -> t4 : Hủy
t4 -> dh
dh -> y5 : Còn → cấp mã mới như tem mất
dh -> y8 : Không
y8 -> e
```

# Mảng 2 · Bán hàng

## QT05. Quy trình Nhận đơn hàng

Sản xuất theo đơn. Sales thỏa thuận SP, SL, giá, ngày giao với khách NGOÀI hệ thống (đã hỏi Kế hoạch, đã xin duyệt nếu giảm giá) rồi mới nhập đơn. Hình thức, phương thức thanh toán, tiền cọc và số ngày nợ điền sẵn theo hồ sơ khách, Sales sửa theo từng đơn. Đơn Mua chịu gọi QT06 Kiểm công nợ. Sửa 05/11: hợp đồng theo từng đơn — Sales nhập hợp đồng khách đã ký (số, hiệu lực từ – đến, file) khi tạo đơn hoặc upload ở chi tiết đơn; Sales bấm Chốt đơn, hệ thống kiểm đơn có hợp đồng và còn hiệu lực; chưa có / hết hạn thì chặn, Sales upload / cập nhật hợp đồng ở chi tiết đơn; hồ sơ khách không còn hợp đồng; bỏ Chờ ký HĐ. Khi chốt đơn, hệ thống sinh lịch thanh toán của đơn (khoản trước SX / trước giao / sau giao); QT09, QT10 chỉ đọc lịch này, không rẽ lại theo hình thức thanh toán. Tiền về khoản trước SX do Kế toán ghi nhận ở QT10 (hệ thống cấn vào khoản, không tự sinh phiếu thu). Trạng thái đơn (theo mockup): Nháp → Chờ kiểm công nợ (Mua nợ) → (chờ của QT06: Chờ xử lý nợ / Chờ duyệt hạn mức / Chờ khách) → Chờ thu tiền (QT10) → Đã chốt → Đang sản xuất; nhánh ra: Từ chối, Đã hủy. Chốt 04/11: đơn ở Chờ thu tiền (chưa chốt) Sales hủy thẳng, bắt buộc lý do, không qua duyệt, không tính tiền hoàn (hn). Hủy / sửa đơn đã chốt: QT07, QT08.

```quy-trinh
so: 5
mang: Bán hàng
tu: QT3
ten-ngan: Nhận đơn
ten: Quy trình Nhận đơn hàng
ghi-chu: Sản xuất theo đơn. Sales thỏa thuận SP, SL, giá, ngày giao với khách NGOÀI hệ thống (đã hỏi Kế hoạch, đã xin duyệt nếu giảm giá) rồi mới nhập đơn. Hình thức, phương thức thanh toán, tiền cọc và số ngày nợ điền sẵn theo hồ sơ khách, Sales sửa theo từng đơn. Đơn Mua chịu gọi QT06 Kiểm công nợ. Sửa 05/11: hợp đồng theo từng đơn — Sales nhập hợp đồng khách đã ký (số, hiệu lực từ – đến, file) khi tạo đơn hoặc upload ở chi tiết đơn; Sales bấm Chốt đơn, hệ thống kiểm đơn có hợp đồng và còn hiệu lực; chưa có / hết hạn thì chặn, Sales upload / cập nhật hợp đồng ở chi tiết đơn; hồ sơ khách không còn hợp đồng; bỏ Chờ ký HĐ. Khi chốt đơn, hệ thống sinh lịch thanh toán của đơn (khoản trước SX / trước giao / sau giao); QT09, QT10 chỉ đọc lịch này, không rẽ lại theo hình thức thanh toán. Tiền về khoản trước SX do Kế toán ghi nhận ở QT10 (hệ thống cấn vào khoản, không tự sinh phiếu thu). Trạng thái đơn (theo mockup): Nháp → Chờ kiểm công nợ (Mua nợ) → (chờ của QT06: Chờ xử lý nợ / Chờ duyệt hạn mức / Chờ khách) → Chờ thu tiền (QT10) → Đã chốt → Đang sản xuất; nhánh ra: Từ chối, Đã hủy. Chốt 04/11: đơn ở Chờ thu tiền (chưa chốt) Sales hủy thẳng, bắt buộc lý do, không qua duyệt, không tính tiền hoàn (hn). Hủy / sửa đơn đã chốt: QT07, QT08.
cot: Khách hàng | Sales | Hệ thống | Kế hoạch
s | 0 | 0 | S | Yêu cầu mua hàng
t1 | 1 | 1 | T | Thỏa thuận với khách (ngoài hệ thống): SP, SL, giá, ngày giao; đã hỏi Kế hoạch, đã xin duyệt nếu giảm giá
t2 | 1 | 2 | Y | Tạo / cập nhật hồ sơ khách hàng
t3 | 1 | 3 | Y | Nhập đơn: đầu đơn + dòng hàng (SP, SL, đơn giá, VAT), ngày giao; kèm hợp đồng nếu đã có (số, hiệu lực từ – đến, file — 05/11) → Đơn: Nháp
d2 | 1 | 4 | D | Hình thức thanh toán?\n(điền sẵn theo khách; sửa cọc, số ngày nợ)
r1 | 2 | 5 | R | QT06: Kiểm công nợ (chỉ Mua chịu)
dr | 2 | 6 | D | Kết quả\nkiểm công nợ?
x1 | 0 | 7 | E | Từ chối đơn (công nợ)
hn | 1 | 10 | T | Khách không ký hợp đồng / không trả tiền: Sales hủy đơn chưa chốt (Chờ thu tiền), bắt buộc lý do → Đã hủy ngay, không qua duyệt (chốt 04/11)
x2 | 1 | 11 | E | Đơn Đã hủy (chưa chốt)
t6 | 1 | 7 | T | Bấm Chốt đơn
t5 | 2 | 7 | D | Đơn có hợp đồng\nvà còn hiệu lực?
tu | 1 | 8 | T | Đơn chưa có / hết hạn hợp đồng: Sales upload hợp đồng khách đã ký ở chi tiết đơn (số, hiệu lực từ – đến, file); Việc cần làm báo Sales (05/11)
yl | 2 | 9 | Y | Sinh lịch thanh toán: khoản trước SX (cọc / trả đủ), trước giao (trả nốt), sau giao (Mua chịu: ngày giao + N ngày)
dk | 2 | 10 | D | Có khoản đến hạn\ntrước SX?
r3 | 2 | 11 | R | QT10: Ghi nhận tiền về khoản trước SX (trả về khi thu đủ)
y2 | 2 | 12 | Y | Đơn → Đã chốt; ghi hình thức thanh toán, số đã thu
yc | 2 | 13 | Y | Dòng đơn vào tab Chờ lên lệnh (màn Lệnh SX), mỗi dòng cần 1 lệnh HH + 1 lệnh BTP cùng mã SP; báo Kế hoạch (thông báo + Việc cần làm)
r2 | 3 | 14 | R | QT19: Tạo và phát lệnh sản xuất
e | 3 | 15 | E | Kết thúc
---
s -> t1
t1 -> t2
t2 -> t3
t3 -> d2
d2 -> t6 : Trả đủ / Cọc + trả nốt
d2 -> r1 : Mua chịu
r1 -> dr
dr -> t6 : Đủ điều kiện
dr -> d2 : Chuyển trả trước
dr -> x1 : Từ chối
t6 -> t5
t5 -> yl : Có
t5 -> tu : Chưa có / hết hạn
tu -> t6 : Upload xong
yl -> dk
dk -> r3 : Có (cọc / trả đủ)
dk -> y2 : Không (Mua chịu, cọc 0)
r3 -> y2 : Đã thu đủ
tu -> hn : Khách không ký hợp đồng
r3 -> hn : Khách hủy khi chưa thu đủ
hn -> x2
y2 -> yc
yc -> r2
r2 -> e
```

## QT06. Quy trình Kiểm công nợ (đơn Mua chịu)

Gọi từ QT05 Nhận đơn và QT08 Sửa đơn. Đầu vào: đơn (phiên bản hiện tại), % cọc. Đầu ra 1 trong 3: Đủ điều kiện / Chuyển trả trước / Từ chối. Kiểm nợ quá hạn trước, hạn mức sau. Dư nợ tính cả đơn Mua chịu đã chốt chưa giao. Một ô kiểm hạn mức dùng chung cho mọi lần kiểm lại; cờ "đã xin tăng" gắn theo phiên bản đơn.

```quy-trinh
so: 6
mang: Bán hàng
tu: QT4
ten-ngan: Kiểm công nợ
ten: Quy trình Kiểm công nợ (đơn Mua chịu)
ghi-chu: Gọi từ QT05 Nhận đơn và QT08 Sửa đơn. Đầu vào: đơn (phiên bản hiện tại), % cọc. Đầu ra 1 trong 3: Đủ điều kiện / Chuyển trả trước / Từ chối. Kiểm nợ quá hạn trước, hạn mức sau. Dư nợ tính cả đơn Mua chịu đã chốt chưa giao. Một ô kiểm hạn mức dùng chung cho mọi lần kiểm lại; cờ "đã xin tăng" gắn theo phiên bản đơn.
cot: Khách hàng | Sales | Kế toán | Hệ thống | Người duyệt (GĐ / KTT)
s | 3 | 0 | S | Đơn Mua chịu cần kiểm (từ QT05 / QT08)
d1 | 3 | 1 | D | Khách đã có hạn mức?
t4 | 2 | 2 | T | Đề xuất hạn mức ban đầu (kèm giá trị đơn này)
t4d | 4 | 3 | D | Duyệt hạn mức\nban đầu?
y0 | 3 | 4 | Y | Lưu hạn mức; đánh dấu đơn này "đã xin tăng" (người duyệt đã thấy giá trị đơn)
y1 | 3 | 5 | Y | Khóa dòng khách; dư nợ = công nợ hiện tại + giá trị còn lại các đơn Mua chịu đã chốt chưa giao (trừ phiên bản cũ của đơn này nếu đang sửa)
dq | 3 | 6 | D | Có nợ quá hạn?
q1 | 1 | 7 | T | Báo khách: trả hết nợ quá hạn / chuyển trả trước / từ chối → Đơn: Chờ xử lý nợ
d3 | 3 | 7 | D | Dư nợ + (đơn − cọc)\n≤ hạn mức?
qd | 0 | 8 | D | Khách chọn?
d4 | 3 | 8 | D | Phiên bản đơn này\nđã xin tăng hạn mức?
q2 | 2 | 9 | T | Ghi nhận tiền về (QT10); hệ thống tự cấn, đóng các khoản quá hạn
v1 | 1 | 9 | T | Gửi yêu cầu tăng hạn mức (giá trị đơn, lý do) → Đơn: Chờ duyệt hạn mức
v2 | 2 | 10 | T | Xem xét công nợ, lịch sử thanh toán
y9 | 3 | 10 | Y | Tính cọc tối thiểu X = dư nợ + đơn − hạn mức; X ≥ giá trị đơn → báo "phải trả đủ"
v4 | 1 | 11 | T | Báo khách: cọc X / chuyển trả trước / từ chối → Đơn: Chờ khách
vd1 | 4 | 11 | T | Quyết hạn mức mới (có thể giữ nguyên); hạn mức áp dụng vĩnh viễn, không có hạn mức tạm
vd2 | 0 | 12 | D | Khách chọn?
v3 | 3 | 12 | Y | Cập nhật hạn mức; đánh dấu đơn "đã xin tăng"
v5 | 1 | 13 | T | Ghi mức cọc mới vào đơn
c2 | 2 | 13 | Y | ⚙ MẶC ĐỊNH (cấu hình lại được): 3 trạng thái chờ (xử lý nợ / duyệt hạn mức / khách) quá 3 ngày nhắc Sales, quá 7 ngày tự Từ chối
e1 | 3 | 14 | E | Trả về: Đủ điều kiện
e2 | 1 | 15 | E | Trả về: Chuyển trả trước (QT05 chọn lại hình thức)
e3 | 0 | 15 | E | Trả về: Từ chối
---
s -> d1
d1 -> t4 : Chưa
d1 -> y1 : Có
t4 -> t4d
t4d -> y0 : Duyệt
t4d -> e2 : Không → đổi hình thức
y0 -> y1
y1 -> dq
dq -> q1 : Có
dq -> d3 : Không
q1 -> qd
qd -> q2 : Trả nợ
qd -> e2 : Chuyển trả trước
qd -> e3 : Từ chối
q2 -> y1 : Kiểm lại
d3 -> e1 : Đủ
d3 -> d4 : Thiếu
d4 -> v1 : Chưa
d4 -> y9 : Rồi
v1 -> v2
v2 -> vd1
vd1 -> v3
v3 -> y1 : Kiểm lại
y9 -> v4
v4 -> vd2
c2 -> v4 :  : n
vd2 -> v5 : Cọc X
vd2 -> e2 : Chuyển trả trước
vd2 -> e3 : Từ chối
v5 -> y1 : Kiểm lại
```

## QT07. Quy trình Hủy đơn đã chốt

Khách hủy sau khi đã cọc / đã chốt. Người duyệt quyết số tiền hoàn (0–100%); Kế toán ghi nhận hoàn tiền ở QT10 (không duyệt thêm). NVL đã mua giữ lại làm tồn chung; TP / BTP đã làm mà không dùng lại được thì sang QT18 Hủy hàng. Chốt 04/11: đơn chưa chốt (Chờ thu tiền) không đi QT07 — Sales hủy thẳng ở QT05 hn. Trạng thái đơn khi hủy (theo mockup): Chờ duyệt hủy (chờ GĐ / KTT quyết số tiền hoàn) → Đang hủy (chờ Kế toán ghi nhận hoàn tiền, hủy lệnh) → Đã hủy.

```quy-trinh
so: 7
mang: Bán hàng
tu: mới
ten-ngan: Hủy đơn
ten: Quy trình Hủy đơn đã chốt
ghi-chu: Khách hủy sau khi đã cọc / đã chốt. Người duyệt quyết số tiền hoàn (0–100%); Kế toán ghi nhận hoàn tiền ở QT10 (không duyệt thêm). NVL đã mua giữ lại làm tồn chung; TP / BTP đã làm mà không dùng lại được thì sang QT18 Hủy hàng. Chốt 04/11: đơn chưa chốt (Chờ thu tiền) không đi QT07 — Sales hủy thẳng ở QT05 hn. Trạng thái đơn khi hủy (theo mockup): Chờ duyệt hủy (chờ GĐ / KTT quyết số tiền hoàn) → Đang hủy (chờ Kế toán ghi nhận hoàn tiền, hủy lệnh) → Đã hủy.
cot: Khách hàng | Sales | Hệ thống | Người duyệt (GĐ / KTT) | Kế hoạch
s | 0 | 0 | S | Khách yêu cầu hủy đơn đã chốt
t0 | 1 | 1 | T | Ghi nhận yêu cầu hủy, lý do → Đơn: Chờ duyệt hủy
h1 | 2 | 2 | Y | Hiện tình trạng đơn: lệnh SX, NVL đã mua, TP đã làm, tiền đã thu
h2 | 3 | 3 | T | Quyết số tiền hoàn lại (0–100% đã thu); mặc định đề xuất giữ toàn bộ cọc, hoàn phần đã thu vượt cọc
h3 | 2 | 4 | R | Đơn → Đang hủy; QT10: Ghi nhận hoàn tiền (số đã quyết; phần giữ lại ghi vào đơn)
h4 | 4 | 5 | T | Hủy lệnh SX chưa chạy (QT19); NVL đã mua giữ lại làm tồn chung. Lệnh gộp nhiều dòng đơn: chỉ bớt số lon của đơn bị hủy (lệnh Mới tạo sửa, đã phát hủy rồi tạo lại cho các dòng còn lại)
h5 | 4 | 6 | D | Đã có TP / BTP\ncủa đơn?
h6 | 4 | 7 | R | QT18: Hủy hàng (nếu không dùng lại được)
h7 | 2 | 8 | Y | Đơn → Đã hủy; ghi lý do, người duyệt, số tiền hoàn
e | 2 | 9 | E | Kết thúc
---
s -> t0
t0 -> h1
h1 -> h2
h2 -> h3
h3 -> h4
h4 -> h5
h5 -> h6 : Có
h5 -> h7 : Không
h6 -> h7
h7 -> e
```

## QT08. Quy trình Sửa đơn đã chốt

Khách đổi SL, ngày giao, SP sau khi đơn đã chốt. Lưu phiên bản cũ. Phần đã SX xử lý như hủy một phần (QT07). Đơn Mua chịu mà giá trị tăng thì gọi lại QT06 với phiên bản mới (cờ "đã xin tăng" reset). Ký phụ lục, ghi nhận thu / hoàn phần chênh lệch qua QT10, rồi cập nhật lệnh SX.

```quy-trinh
so: 8
mang: Bán hàng
tu: mới
ten-ngan: Sửa đơn
ten: Quy trình Sửa đơn đã chốt
ghi-chu: Khách đổi SL, ngày giao, SP sau khi đơn đã chốt. Lưu phiên bản cũ. Phần đã SX xử lý như hủy một phần (QT07). Đơn Mua chịu mà giá trị tăng thì gọi lại QT06 với phiên bản mới (cờ "đã xin tăng" reset). Ký phụ lục, ghi nhận thu / hoàn phần chênh lệch qua QT10, rồi cập nhật lệnh SX.
cot: Khách hàng | Sales | Hệ thống | Kế hoạch
s | 0 | 0 | S | Khách yêu cầu sửa đơn đã chốt (SL, ngày giao, SP)
m1 | 1 | 1 | T | Thỏa thuận lại, hỏi Kế hoạch (ngoài hệ thống)
m2 | 2 | 2 | D | Phần bị sửa\nđã SX chưa?
m3 | 1 | 3 | R | QT07: Hủy một phần (hoàn tiền / xử lý hàng phần đã SX)
m4 | 2 | 4 | Y | Lưu phiên bản cũ; tạo phiên bản mới (chưa "xin tăng hạn mức"), tính lại lịch thanh toán
m5 | 2 | 5 | D | Mua chịu và\ngiá trị đơn tăng?
r1 | 2 | 6 | R | QT06: Kiểm công nợ (phiên bản mới)
dr | 2 | 7 | D | Kết quả\nkiểm công nợ?
x1 | 0 | 8 | E | Giữ đơn cũ, không sửa (báo khách)
t5 | 0 | 9 | T | Ký phụ lục hợp đồng
t6 | 1 | 10 | Y | Tải phụ lục đã ký lên hệ thống
d6 | 2 | 11 | D | Chênh lệch\nso với đã thu?
r3 | 2 | 12 | R | QT10: Ghi nhận thu thêm / hoàn phần chênh lệch
y2 | 2 | 13 | Y | Đơn → Đã chốt (phiên bản mới); ghi số đã thu
r2 | 3 | 14 | R | QT19: Cập nhật lệnh SX — SL dòng tăng: phần thêm vào tab Chờ lên lệnh; SL dòng giảm dưới số lon đã phân bổ: báo Kế hoạch, lệnh Mới tạo sửa số lon, đã phát chưa chạy hủy rồi tạo lại, đang chạy kết thúc sớm / giữ phần dư
e | 3 | 15 | E | Kết thúc
---
s -> m1
m1 -> m2
m2 -> m3 : Rồi
m2 -> m4 : Chưa
m3 -> m4
m4 -> m5
m5 -> r1 : Có
m5 -> t5 : Không
r1 -> dr
dr -> t5 : Đủ điều kiện
dr -> t5 : Chuyển trả trước (đổi hình thức)
dr -> x1 : Từ chối
t5 -> t6
t6 -> d6
d6 -> r3 : Có
d6 -> y2 : Không
r3 -> y2 : Xong
y2 -> r2
r2 -> e
```

## QT09. Quy trình Giao hàng (chỉ ghi nhận)

Sửa 24/10: hệ thống **chỉ ghi nhận** giao hàng, không quản lý việc giao — liên hệ khách, lịch giao, địa chỉ, xe / tài xế / nhà xe làm ngoài hệ thống. Bỏ màn Giao hàng và chứng từ đợt giao: Sales xuất từng phần ngay trên đơn (Đơn hàng › tab Giao hàng, nút "Yêu cầu xuất": chọn dòng, SL giao lần này); mỗi lần sinh 1 yêu cầu xuất bán (cloud, sao xuống nhà máy) → 1 phiếu xuất bán (QT15, đúng lô của đơn). Kiểm tiền ngay lúc yêu cầu: khoản đến hạn trước giao tính theo giá trị phần yêu cầu; cờ tạm khóa chỉ chặn đơn Mua chịu, đơn đã thu đủ vẫn giao; thiếu thì chờ Kế toán ghi nhận tiền về (QT10), quá 14 ngày → QT07. Giao xong, Sales ghi kết quả trên đơn theo từng phiếu xuất: SL khách nhận từng lô, ngày nhận, ảnh biên bản ký nhận — đây là mắt xích lô → khách cho truy xuất / thu hồi. Phần khách không nhận: nhập lại kho (QT14, hàng khách trả, gắn phiếu xuất, lô KHÓA, QC kiểm lại); khách vẫn lấy thì khi QT23 ĐẠT đơn quay về Sẵn sàng giao. Sửa 05/11: lô sản xuất cho đơn QC đạt → Chờ nhập kho (Thủ kho nhập kho) → Chờ kế toán duyệt (Mua nợ: kiểm công nợ; Cọc + trả nốt: ghi nhận phần còn lại; Trả đủ trước SX bỏ qua) → Chờ xuất kho (hệ thống lập yêu cầu xuất bán các lô của đơn, Thủ kho xuất, lập phiếu xuất bán) → Đang giao; đơn gắn lô tồn vẫn Sẵn sàng giao → Sales yêu cầu xuất. Trạng thái đơn hệ thống tự tính: Sẵn sàng giao → Đang giao (đã xuất, chưa ghi nhận) → Giao một phần / Đã giao. Công nợ đơn Mua chịu tính theo từng lần ghi nhận, hạn = ngày khách nhận + N ngày (QT10). Hóa đơn: Kế toán thêm vào đơn, một đơn nhiều hóa đơn, không gắn phiếu xuất (QT10). Ngày giao trên đơn là ngày dự kiến, Sales sửa trực tiếp (ghi nhật ký), không qua QT08. Bỏ 24/10: bước liên hệ khách và vòng chờ 7 ngày, khách "mất" sau 30 ngày, xác nhận lịch / địa chỉ, ngưỡng dời ngày giao 3 ngày, bước giao hàng của Vận chuyển. Sửa 24/10 (đợt 4): phiếu xuất bán do máy chủ nhà máy tự lập khi yêu cầu sao xuống (lô, SL theo yêu cầu) và vào thẳng Chờ lấy hàng — không qua Thủ kho trưởng duyệt (lô cố định, SL theo yêu cầu, tiền đã kiểm; khi quét vẫn chặn sai lô / không đạt / hết hạn); Thủ kho không lập tay. Lô không còn đủ ở nhà máy thì không lập phiếu, yêu cầu trả về Sales kèm lý do. Một yêu cầu chỉ lấy lô ở 1 nhà máy (cần 2 nhà máy thì tách 2 yêu cầu). Tách khoản trả nốt: mỗi lần yêu cầu, hệ thống tách từ khoản "trả nốt trước giao" một khoản riêng gắn yêu cầu = giá trị phần xuất × (1 − % cọc), khoản gốc giảm tương ứng (phần tách ghi thay thế); hủy yêu cầu thì gộp lại. Hủy yêu cầu chưa xuất: bắt buộc lý do. Tổng SL các yêu cầu chưa hủy của một lô không vượt SL lô gắn đơn; lô phải là lô gắn đơn, đúng SP của dòng đơn.

```quy-trinh
so: 9
mang: Bán hàng
tu: QT21 (giao hàng)
ten-ngan: Giao hàng
ten: Quy trình Giao hàng (chỉ ghi nhận)
ghi-chu: Sửa 24/10: hệ thống **chỉ ghi nhận** giao hàng, không quản lý việc giao — liên hệ khách, lịch giao, địa chỉ, xe / tài xế / nhà xe làm ngoài hệ thống. Bỏ màn Giao hàng và chứng từ đợt giao: Sales xuất từng phần ngay trên đơn (Đơn hàng › tab Giao hàng, nút "Yêu cầu xuất": chọn dòng, SL giao lần này); mỗi lần sinh 1 yêu cầu xuất bán (cloud, sao xuống nhà máy) → 1 phiếu xuất bán (QT15, đúng lô của đơn). Kiểm tiền ngay lúc yêu cầu: khoản đến hạn trước giao tính theo giá trị phần yêu cầu; cờ tạm khóa chỉ chặn đơn Mua chịu, đơn đã thu đủ vẫn giao; thiếu thì chờ Kế toán ghi nhận tiền về (QT10), quá 14 ngày → QT07. Giao xong, Sales ghi kết quả trên đơn theo từng phiếu xuất: SL khách nhận từng lô, ngày nhận, ảnh biên bản ký nhận — đây là mắt xích lô → khách cho truy xuất / thu hồi. Phần khách không nhận: nhập lại kho (QT14, hàng khách trả, gắn phiếu xuất, lô KHÓA, QC kiểm lại); khách vẫn lấy thì khi QT23 ĐẠT đơn quay về Sẵn sàng giao. Sửa 05/11: lô sản xuất cho đơn QC đạt → Chờ nhập kho (Thủ kho nhập kho) → Chờ kế toán duyệt (Mua nợ: kiểm công nợ; Cọc + trả nốt: ghi nhận phần còn lại; Trả đủ trước SX bỏ qua) → Chờ xuất kho (hệ thống lập yêu cầu xuất bán các lô của đơn, Thủ kho xuất, lập phiếu xuất bán) → Đang giao; đơn gắn lô tồn vẫn Sẵn sàng giao → Sales yêu cầu xuất. Trạng thái đơn hệ thống tự tính: Sẵn sàng giao → Đang giao (đã xuất, chưa ghi nhận) → Giao một phần / Đã giao. Công nợ đơn Mua chịu tính theo từng lần ghi nhận, hạn = ngày khách nhận + N ngày (QT10). Hóa đơn: Kế toán thêm vào đơn, một đơn nhiều hóa đơn, không gắn phiếu xuất (QT10). Ngày giao trên đơn là ngày dự kiến, Sales sửa trực tiếp (ghi nhật ký), không qua QT08. Bỏ 24/10: bước liên hệ khách và vòng chờ 7 ngày, khách "mất" sau 30 ngày, xác nhận lịch / địa chỉ, ngưỡng dời ngày giao 3 ngày, bước giao hàng của Vận chuyển. Sửa 24/10 (đợt 4): phiếu xuất bán do máy chủ nhà máy tự lập khi yêu cầu sao xuống (lô, SL theo yêu cầu) và vào thẳng Chờ lấy hàng — không qua Thủ kho trưởng duyệt (lô cố định, SL theo yêu cầu, tiền đã kiểm; khi quét vẫn chặn sai lô / không đạt / hết hạn); Thủ kho không lập tay. Lô không còn đủ ở nhà máy thì không lập phiếu, yêu cầu trả về Sales kèm lý do. Một yêu cầu chỉ lấy lô ở 1 nhà máy (cần 2 nhà máy thì tách 2 yêu cầu). Tách khoản trả nốt: mỗi lần yêu cầu, hệ thống tách từ khoản "trả nốt trước giao" một khoản riêng gắn yêu cầu = giá trị phần xuất × (1 − % cọc), khoản gốc giảm tương ứng (phần tách ghi thay thế); hủy yêu cầu thì gộp lại. Hủy yêu cầu chưa xuất: bắt buộc lý do. Tổng SL các yêu cầu chưa hủy của một lô không vượt SL lô gắn đơn; lô phải là lô gắn đơn, đúng SP của dòng đơn.
cot: Sales | Hệ thống | Kho | Khách hàng (ngoài hệ thống) | Kế toán
s | 1 | 0 | S | Lô TP của đơn đã QC ĐẠT (QT23) — đủ cả đơn hoặc một phần
ds | 2 | 0 | D | Lô sản xuất cho đơn\nhay lô tồn gắn đơn?
nk | 2 | 2 | R | QT14: Đơn Chờ nhập kho — Thủ kho nhập kho lô sản xuất của đơn (05/11)
dt | 4 | 2 | D | Trả đủ\ntrước SX?
kd | 4 | 3 | T | Đơn Chờ kế toán duyệt: Mua nợ — kiểm công nợ (không nợ quá hạn, dư nợ trong hạn mức) rồi duyệt xuất giao, chưa đạt thì giữ chờ và báo Sales; Cọc + trả nốt — ghi nhận phần còn lại (QT10) rồi duyệt (05/11)
xk | 2 | 4 | Y | Đơn Chờ xuất kho: hệ thống lập yêu cầu xuất bán các lô của đơn; Thủ kho xuất kho (QT15), lập phiếu xuất bán (05/11)
t1 | 1 | 1 | Y | Báo Sales (Việc cần làm): đơn Sẵn sàng giao, dòng / lô đã ĐẠT
c2 | 2 | 1 | Y | Chỉ ghi nhận (24/10): liên hệ khách, lịch giao, địa chỉ, xe / nhà xe làm ngoài hệ thống; không có chứng từ đợt giao, không có màn Giao hàng — thao tác ở Đơn hàng › tab Giao hàng
t2 | 0 | 2 | T | Yêu cầu xuất từ đơn (tab Giao hàng): chọn dòng, SL giao lần này (chỉ phần lô TP đã ĐẠT của đơn), ngày giao dự kiến
yk | 1 | 3 | Y | Kiểm: khoản đến hạn trước giao (theo giá trị phần yêu cầu) đã thu đủ; đơn Mua chịu: khách không bị tạm khóa do nợ quá hạn (QT10)
dk | 1 | 4 | D | Đủ điều kiện\nxuất?
r0 | 0 | 5 | R | QT10: Ghi nhận tiền về khoản trước giao / nợ quá hạn (trả về khi xong)
c1 | 0 | 6 | Y | ⚙ MẶC ĐỊNH (cấu hình lại được): chưa thu đủ / khách bị khóa quá 14 ngày → QT07; hủy đơn đề xuất giữ toàn bộ cọc (người duyệt ở QT07 sửa được)
y2 | 1 | 6 | Y | Sinh yêu cầu xuất bán (đơn, dòng, SL, lô của đơn — chỉ lô ở 1 nhà máy); tách khoản trả nốt trước giao theo phần xuất; sao xuống máy chủ nhà máy
yn | 2 | 7 | Y | Máy chủ nhà máy tự lập phiếu xuất bán từ yêu cầu (lô, SL y nguyên, không đề xuất lại) → vào thẳng Chờ lấy hàng (không qua Thủ kho trưởng duyệt); Thủ kho không lập tay
dn | 2 | 8 | D | Lô của yêu cầu\ncòn đủ ở nhà máy?
tr | 0 | 8 | T | Yêu cầu bị nhà máy trả về (kèm lý do): Sales hủy yêu cầu (bắt buộc lý do) hoặc lập yêu cầu khác
r2 | 2 | 9 | R | QT15: Kho lấy hàng theo phiếu xuất bán đã duyệt, đúng lô của đơn (không theo FEFO), quét; mất mạng chỉ xuất được yêu cầu đã xuống trước
dx | 2 | 10 | D | Xuất đủ,\nđúng lô?
t9 | 0 | 10 | T | Phiếu Chờ bên yêu cầu (QT15): nhận phần đã lấy hoặc hủy yêu cầu; phần chưa xuất giữ Sẵn sàng giao
y3 | 1 | 11 | Y | Phiếu xuất bán Đã xuất / Xuất một phần → Đơn: Đang giao
t4 | 3 | 12 | T | Nhận hàng, ký biên bản (giao làm ngoài hệ thống: xe nhà máy / khách tự lấy / nhà xe)
t5 | 0 | 13 | T | Ghi nhận kết quả theo phiếu xuất (tab Giao hàng): SL khách nhận từng lô, ngày nhận, ảnh biên bản ký nhận; phần không nhận + lý do (từ chối / hư / thiếu)
d2 | 1 | 14 | D | Khách nhận đủ\nphần đã xuất?
r4 | 2 | 15 | R | QT14: Nhập lại kho phần khách không nhận (loại: hàng khách trả, gắn phiếu xuất), lô → KHÓA (lý do khách trả), QC kiểm lại
y1 | 1 | 16 | Y | Ghi lô → khách (truy xuất); Đơn → Đã giao (mọi dòng đã nhận đủ) / Giao một phần (còn dòng: quay lại t2 khi phần còn lại Sẵn sàng giao)
dg | 0 | 17 | D | Khách vẫn lấy\nphần trả về?\n(bắt buộc ghi khi có SL\nkhách không nhận)
r3 | 1 | 18 | R | QT10: Ghi nhận công nợ theo phần khách nhận (hạn = ngày nhận + N ngày); Kế toán lập hóa đơn gắn phiếu xuất
r9 | 0 | 19 | R | QT07: giảm SL đơn phần khách không lấy (hủy toàn bộ / phần còn lại); đã thu tiền thì GĐ / KTT quyết số tiền hoàn (h2)
e | 1 | 20 | E | Kết thúc
---
s -> ds
ds -> t1 : Lô tồn gắn đơn → Sẵn sàng giao
ds -> nk : Lô sản xuất cho đơn
nk -> dt
dt -> xk : Có
dt -> kd : Cọc + trả nốt / Mua nợ
kd -> xk : Đã duyệt
xk -> y3
t1 -> t2
c2 -> t2 :  : n
t2 -> yk
yk -> dk
dk -> y2 : Đủ
dk -> r0 : Chưa
r0 -> y2 : Đã thu / hết nợ quá hạn
r0 -> r9 : Quá hạn, khách không trả
c1 -> r0 :  : n
y2 -> yn
yn -> dn
dn -> r2 : Đủ
dn -> tr : Không
tr -> t2 : Lập yêu cầu khác
tr -> e : Hủy yêu cầu
r2 -> dx
dx -> y3 : Có
dx -> t9 : Thiếu, không có lô thay
t9 -> y3 : Nhận phần đã lấy
t9 -> e : Hủy yêu cầu
y3 -> t4
t4 -> t5
t5 -> d2
d2 -> y1 : Nhận đủ
d2 -> r4 : Có phần không nhận
r4 -> y1 : Ghi phần đã nhận
r4 -> dg
y1 -> r3
r3 -> e
dg -> e : Có → đơn giữ Giao một phần; QC kiểm lại đạt (QT23) thì về Sẵn sàng giao
dg -> r9 : Không → giảm SL đơn phần đó
r9 -> e
```

## QT10. Quy trình Ghi nhận thu chi và Công nợ

Sửa 19/10 — chỉ ghi nhận tiền và công nợ, đủ để chặn / mở nghiệp vụ bán hàng, mua hàng: không hạch toán, không sổ cái, không tài khoản kế toán, không báo cáo thuế, không đối soát ngân hàng. Kế toán "Ghi nhận tiền về" (số tiền, ngày, CK / tiền mặt, ảnh chứng từ) → hệ thống cấn vào khoản trong lịch thanh toán (sinh ở QT05, tính lại ở QT08, theo từng lần xuất ở QT09); "Ghi nhận hoàn tiền" theo số GĐ / KTT đã quyết (QT07, QT08, QT26) — không duyệt thêm, không tự sinh phiếu thu. Hóa đơn (sửa 04/11, thay bản 24/10 "hóa đơn xuất ở phần mềm kế toán riêng, Kế toán chỉ thêm số / ngày / file, không gắn phiếu xuất"): Kế toán lập hóa đơn bán hàng trên MES theo phiếu xuất đã ghi nhận giao — mỗi hóa đơn gắn phiếu xuất của lần giao, một đơn nhiều hóa đơn; MES in hóa đơn khổ A4 (bản thể hiện của hóa đơn điện tử, có mã tra cứu); in lại đóng dấu BẢN SAO, ghi người in, ngày in vào nhật ký (màn Hồ sơ & biểu mẫu in). Tổng quan Giám đốc nhắc "đã giao, chưa có hóa đơn" kèm lối tắt Lập hóa đơn. Hệ thống chỉ tự động 3 việc: tính dư nợ, nợ quá hạn; bật / tắt cờ tạm khóa khách (chặn đơn Mua chịu ở QT06, QT09); nhắc nợ bằng thông báo trong hệ thống cho Sales và Kế toán (không email, không gửi khách). Công nợ sau giao quá 90 ngày: GĐ / KTT quyết bên ngoài, Kế toán ghi kết quả — hệ thống không xóa nợ. Hai điểm vào: Sales ghi nhận khách nhận hàng (QT09) và tiền về / khoản hoàn (QT05–QT09, QT26 — khoản trước SX / trước giao trả kết quả về QT gọi). Thanh toán, công nợ NCC ở QT12, QT13; cả hai gom vào phân hệ Kế toán (mục "Phân hệ & màn hình").

```quy-trinh
so: 10
mang: Bán hàng
tu: QT21 (thu tiền)
ten-ngan: Ghi nhận thu chi & công nợ
ten: Quy trình Ghi nhận thu chi và Công nợ
ghi-chu: Sửa 19/10 — chỉ ghi nhận tiền và công nợ, đủ để chặn / mở nghiệp vụ bán hàng, mua hàng: không hạch toán, không sổ cái, không tài khoản kế toán, không báo cáo thuế, không đối soát ngân hàng. Kế toán "Ghi nhận tiền về" (số tiền, ngày, CK / tiền mặt, ảnh chứng từ) → hệ thống cấn vào khoản trong lịch thanh toán (sinh ở QT05, tính lại ở QT08, theo từng lần xuất ở QT09); "Ghi nhận hoàn tiền" theo số GĐ / KTT đã quyết (QT07, QT08, QT26) — không duyệt thêm, không tự sinh phiếu thu. Hóa đơn (sửa 04/11, thay bản 24/10 "hóa đơn xuất ở phần mềm kế toán riêng, Kế toán chỉ thêm số / ngày / file, không gắn phiếu xuất"): Kế toán lập hóa đơn bán hàng trên MES theo phiếu xuất đã ghi nhận giao — mỗi hóa đơn gắn phiếu xuất của lần giao, một đơn nhiều hóa đơn; MES in hóa đơn khổ A4 (bản thể hiện của hóa đơn điện tử, có mã tra cứu); in lại đóng dấu BẢN SAO, ghi người in, ngày in vào nhật ký (màn Hồ sơ & biểu mẫu in). Tổng quan Giám đốc nhắc "đã giao, chưa có hóa đơn" kèm lối tắt Lập hóa đơn. Hệ thống chỉ tự động 3 việc: tính dư nợ, nợ quá hạn; bật / tắt cờ tạm khóa khách (chặn đơn Mua chịu ở QT06, QT09); nhắc nợ bằng thông báo trong hệ thống cho Sales và Kế toán (không email, không gửi khách). Công nợ sau giao quá 90 ngày: GĐ / KTT quyết bên ngoài, Kế toán ghi kết quả — hệ thống không xóa nợ. Hai điểm vào: Sales ghi nhận khách nhận hàng (QT09) và tiền về / khoản hoàn (QT05–QT09, QT26 — khoản trước SX / trước giao trả kết quả về QT gọi). Thanh toán, công nợ NCC ở QT12, QT13; cả hai gom vào phân hệ Kế toán (mục "Phân hệ & màn hình").
cot: Kế toán | Sales | Khách hàng | Hệ thống
s2 | 3 | 0 | S | Sales ghi nhận khách nhận hàng — đủ / một phần (QT09)
t1 | 0 | 1 | T | Lập hóa đơn bán hàng theo phiếu xuất đã ghi nhận giao (hóa đơn gắn phiếu xuất; một đơn nhiều hóa đơn); in hóa đơn A4 trên MES (chốt 04/11)
dm | 3 | 2 | D | Đơn Mua chịu?
y1 | 3 | 3 | Y | Ghi công nợ phải thu = giá trị phần khách đã nhận − cọc chưa cấn trừ; hạn = ngày khách nhận + N ngày (khoản công nợ trong lịch thanh toán)
k1 | 2 | 4 | S | Khách chuyển khoản / nộp tiền mặt; hoặc có khoản hoàn đã được GĐ / KTT quyết (QT07, QT08, QT26)
dk | 0 | 5 | D | Tiền về\nhay hoàn?
k2 | 0 | 6 | T | Ghi nhận tiền về: số tiền, ngày, CK / tiền mặt, ảnh chứng từ (không tự sinh phiếu thu)
yk | 3 | 6 | Y | Cấn số tiền vào khoản của khách trong lịch thanh toán / công nợ (thứ tự cấn: xem câu hỏi)
h1 | 0 | 7 | T | Ghi nhận hoàn tiền: số tiền theo quyết định của GĐ / KTT, ngày, CK / tiền mặt, ảnh chứng từ — chỉ ghi nhận, không duyệt
ya | 3 | 8 | Y | Tự động: tính lại dư nợ, nợ quá hạn; hết nợ quá hạn thì tắt cờ tạm khóa; khoản trước SX / trước giao đủ → báo QT gọi "Đã thu / hoàn đủ"
dq | 3 | 9 | D | Còn khoản\nquá hạn?
y3 | 3 | 10 | Y | Bật cờ khách "tạm khóa do nợ quá hạn" (chặn đơn Mua chịu ở QT06 / QT09); nhắc nợ: thông báo trong hệ thống cho Sales và Kế toán (không email, không gửi khách)
c1 | 1 | 10 | Y | ⚙ MẶC ĐỊNH (cấu hình lại được): quá hạn 3 ngày thì nhắc, sau đó nhắc mỗi 7 ngày; khoản trước giao quá 14 ngày → báo QT gọi (Từ chối / Hủy); công nợ sau giao quá 90 ngày → báo GĐ / KTT quyết bên ngoài
k3 | 1 | 11 | T | Sales liên hệ khách nhắc nợ, thỏa thuận lịch trả (ngoài hệ thống); ghi lần liên hệ
dg | 3 | 12 | D | Công nợ sau giao\nquá 90 ngày?
g9 | 0 | 13 | T | GĐ / KTT quyết bên ngoài hệ thống; Kế toán ghi kết quả vào khoản công nợ (ghi chú + file) — hệ thống không xóa nợ
e | 3 | 14 | E | Kết thúc (khoản trước SX / trước giao: trả về QT gọi "Đã thu / hoàn đủ")
---
s2 -> t1
t1 -> dm
dm -> y1 : Có
dm -> e : Không (đã thu đủ trước giao)
y1 -> ya
k1 -> dk
dk -> k2 : Tiền về
dk -> h1 : Hoàn
k2 -> yk
yk -> ya
h1 -> ya
ya -> dq
dq -> e : Không
dq -> y3 : Có
c1 -> y3 :  : n
y3 -> k3
k3 -> dg
dg -> g9 : Có
dg -> e : Chưa → nhắc lại theo lịch
g9 -> e
```

# Mảng 3 · Mua hàng

## QT11. Quy trình Phê duyệt Nhà cung cấp

Chỉ còn nhánh duyệt NCC mới; bỏ đánh giá lại định kỳ (chốt 16/10). Không có bước QC đánh giá mẫu (bỏ 17/10): đủ hồ sơ pháp lý, chứng nhận còn hạn là sang Trưởng BP Mua hàng duyệt. Trạng thái NCC: CHỜ DUYỆT → ĐÃ DUYỆT / TỪ CHỐI; ĐÃ DUYỆT → NGỪNG DÙNG (Trưởng BP Mua hàng thao tác tay, ghi lý do); muốn dùng lại thì duyệt lại như NCC mới. Chỉ NCC ĐÃ DUYỆT, đúng NVL được phép cung cấp, mới chọn được ở QT12. Mọi nhánh không đạt đều lưu lý do. Không xóa hồ sơ NCC (giữ cho truy xuất). Trả hàng (QT13), giao trễ / thiếu (QT12) chỉ ghi vào lịch sử NCC để tra cứu, không chấm điểm.

```quy-trinh
so: 11
mang: Mua hàng
tu: QT2
ten-ngan: Phê duyệt NCC
ten: Quy trình Phê duyệt Nhà cung cấp
ghi-chu: Chỉ còn nhánh duyệt NCC mới; bỏ đánh giá lại định kỳ (chốt 16/10). Không có bước QC đánh giá mẫu (bỏ 17/10): đủ hồ sơ pháp lý, chứng nhận còn hạn là sang Trưởng BP Mua hàng duyệt. Trạng thái NCC: CHỜ DUYỆT → ĐÃ DUYỆT / TỪ CHỐI; ĐÃ DUYỆT → NGỪNG DÙNG (Trưởng BP Mua hàng thao tác tay, ghi lý do); muốn dùng lại thì duyệt lại như NCC mới. Chỉ NCC ĐÃ DUYỆT, đúng NVL được phép cung cấp, mới chọn được ở QT12. Mọi nhánh không đạt đều lưu lý do. Không xóa hồ sơ NCC (giữ cho truy xuất). Trả hàng (QT13), giao trễ / thiếu (QT12) chỉ ghi vào lịch sử NCC để tra cứu, không chấm điểm.
cot: Bộ phận Mua hàng | Trưởng BP Mua hàng | Hệ thống
s | 0 | 0 | S | Cần NCC mới (QT12: NVL chưa có NCC đã duyệt / mở rộng nguồn)
t1 | 0 | 1 | T | Tìm NCC; xin hồ sơ pháp lý (GPKD, chứng nhận ATTP / ISO, công bố SP)
y0 | 2 | 1 | Y | Kiểm trùng theo MST; hiện trạng thái và lý do cũ nếu NCC đã có trong hệ thống
d0 | 2 | 2 | D | NCC đã có\ntrong hệ thống?
y1 | 2 | 3 | Y | Tạo hồ sơ NCC → CHỜ DUYỆT: NVL đề xuất cung cấp, chứng nhận (loại, số, hạn)
d1 | 0 | 4 | D | Đủ hồ sơ pháp lý,\nchứng nhận còn hạn?
c1 | 1 | 4 | Y | Chỉ Trưởng BP Mua hàng duyệt NCC, không cần ký cùng; không có bước đánh giá tại xưởng NCC trong hệ thống
d3 | 1 | 5 | D | Duyệt NCC?
yr | 2 | 5 | Y | Ghi lý do không đạt (hồ sơ / không duyệt); NCC → TỪ CHỐI
yd | 2 | 6 | Y | NCC → ĐÃ DUYỆT: NVL được phép cung cấp; hiện ở danh sách chọn của QT12
dr | 0 | 6 | D | Tìm NCC khác?
e0 | 0 | 7 | E | Không có NCC: báo Kế hoạch / QT12
e1 | 2 | 7 | E | Kết thúc
s2 | 1 | 8 | S | Trưởng BP Mua hàng quyết ngừng dùng NCC (vd chất lượng kém, trả hàng nhiều, chứng nhận hết hạn)
n1 | 1 | 9 | T | Chọn NCC, ghi lý do ngừng dùng
n2 | 2 | 10 | Y | NCC → NGỪNG DÙNG: ẩn khỏi danh sách chọn QT12, chặn PO mới; báo Mua hàng các PO đang mở; giữ hồ sơ (không xóa); NVL không còn NCC đã duyệt → báo Kế hoạch
e2 | 2 | 11 | E | Kết thúc
---
s -> t1
t1 -> y0
y0 -> d0
d0 -> e1 : Đã duyệt → dùng luôn
d0 -> y1 : Chưa có / từ chối / ngừng dùng
y1 -> d1
d1 -> yr : Thiếu
c1 -> d3 :  : n
d3 -> yd : Duyệt
d3 -> yr : Không
yr -> dr
dr -> t1 : Có
dr -> e0 : Không
yd -> e1
s2 -> n1
n1 -> n2
n2 -> e2
d1 -> d3 : Đủ
```

## QT12. Quy trình Mua nguyên vật liệu

Sửa 30/10 – 04/11 (theo mockup): bỏ báo giá và phiếu yêu cầu mua — Mua hàng làm ngay ở Hàng đợi mua: điền SL (làm tròn quy cách), chọn NCC đã duyệt đúng NVL (QT11), nhập đơn giá, ngày giao (mặc định = ngày cần); các dòng cùng NCC × kho nhận gộp 1 PO (chốt 04/11). Hàng đợi mua: mỗi dòng = 1 NVL × kho nhận, chỉ gồm phần Kế hoạch chọn bù bằng Mua (QT19 cb), NVL dưới tồn tối thiểu có cách bù Mua (đặt ở danh mục NVL) và nhu cầu Kế hoạch thêm tay; thiếu = nhu cầu − tồn khả dụng − PO và phiếu chuyển kho đang về, tính theo ngày cần; không mua được thì Mua hàng trả dòng về Kế hoạch kèm lý do. Lập PO xong → Chờ COA & HSD: Mua hàng gửi NCC 1 email yêu cầu COA và hạn dùng cho mọi NVL trong PO, nhận phản hồi rồi kiểm COA & HSD theo bộ chỉ tiêu COA của NVL (QT02) — đạt thì Chờ chọn thanh toán; không đạt thì PO Đã hủy, NCC bị khóa cho NVL đó, NVL quay lại Hàng đợi mua chọn NCC khác (30/10, 31/10). Hình thức thanh toán PO: Trả trước / Cọc + trả nốt trước giao / Trả sau N ngày, điền sẵn theo NCC (31/10). Duyệt PO như cũ (Trưởng BP Mua hàng; trên ngưỡng thêm Giám đốc); duyệt xong gửi PO cho NCC qua email (30/10). Trạng thái PO: Chờ COA & HSD → Chờ chọn thanh toán → Chờ duyệt → Đã duyệt → Đã gửi NCC → Nhận một phần → Đã nhận đủ; nhánh ra: Từ chối (không duyệt — NVL về Hàng đợi mua), Đã hủy, Đã đóng (Trưởng BP Mua hàng đóng phần còn lại của PO giao thiếu). PO không ghi nguồn: hàng về cấp cho lệnh theo ưu tiên. Giữ từ trước: chỉ NCC ĐÃ DUYỆT (chưa có thì gọi QT11); NCC giao kèm file đánh giá bên ngoài / số lô / NSX / HSD (QT14); tồn đủ tính theo tồn khả dụng; theo dõi PO nhận một phần, giao trễ / thiếu ghi lịch sử NCC; trả hàng / giảm công nợ ở QT13; trả tiền NCC ngoài hệ thống, Kế toán chỉ ghi nhận ở màn Công nợ NCC — không duyệt, không tự sinh phiếu chi (19/10).

```quy-trinh
so: 12
mang: Mua hàng
tu: QT5
ten-ngan: Mua NVL
ten: Quy trình Mua nguyên vật liệu
ghi-chu: Sửa 30/10 – 04/11 (theo mockup): bỏ báo giá và phiếu yêu cầu mua — Mua hàng làm ngay ở Hàng đợi mua: điền SL (làm tròn quy cách), chọn NCC đã duyệt đúng NVL (QT11), nhập đơn giá, ngày giao (mặc định = ngày cần); các dòng cùng NCC × kho nhận gộp 1 PO (chốt 04/11). Hàng đợi mua: mỗi dòng = 1 NVL × kho nhận, chỉ gồm phần Kế hoạch chọn bù bằng Mua (QT19 cb), NVL dưới tồn tối thiểu có cách bù Mua (đặt ở danh mục NVL) và nhu cầu Kế hoạch thêm tay; thiếu = nhu cầu − tồn khả dụng − PO và phiếu chuyển kho đang về, tính theo ngày cần; không mua được thì Mua hàng trả dòng về Kế hoạch kèm lý do. Lập PO xong → Chờ COA & HSD: Mua hàng gửi NCC 1 email yêu cầu COA và hạn dùng cho mọi NVL trong PO, nhận phản hồi rồi kiểm COA & HSD theo bộ chỉ tiêu COA của NVL (QT02) — đạt thì Chờ chọn thanh toán; không đạt thì PO Đã hủy, NCC bị khóa cho NVL đó, NVL quay lại Hàng đợi mua chọn NCC khác (30/10, 31/10). Hình thức thanh toán PO: Trả trước / Cọc + trả nốt trước giao / Trả sau N ngày, điền sẵn theo NCC (31/10). Duyệt PO như cũ (Trưởng BP Mua hàng; trên ngưỡng thêm Giám đốc); duyệt xong gửi PO cho NCC qua email (30/10). Trạng thái PO: Chờ COA & HSD → Chờ chọn thanh toán → Chờ duyệt → Đã duyệt → Đã gửi NCC → Nhận một phần → Đã nhận đủ; nhánh ra: Từ chối (không duyệt — NVL về Hàng đợi mua), Đã hủy, Đã đóng (Trưởng BP Mua hàng đóng phần còn lại của PO giao thiếu). PO không ghi nguồn: hàng về cấp cho lệnh theo ưu tiên. Giữ từ trước: chỉ NCC ĐÃ DUYỆT (chưa có thì gọi QT11); NCC giao kèm file đánh giá bên ngoài / số lô / NSX / HSD (QT14); tồn đủ tính theo tồn khả dụng; theo dõi PO nhận một phần, giao trễ / thiếu ghi lịch sử NCC; trả hàng / giảm công nợ ở QT13; trả tiền NCC ngoài hệ thống, Kế toán chỉ ghi nhận ở màn Công nợ NCC — không duyệt, không tự sinh phiếu chi (19/10).
cot: Kế hoạch | Kho | Mua hàng | Trưởng BP Mua hàng | Kế toán | Nhà cung cấp | Hệ thống
s | 0 | 0 | S | Nhu cầu NVL: lệnh SX (QT19 — phần Kế hoạch chọn bù bằng Mua), dưới tồn tối thiểu (cách bù Mua đặt ở danh mục NVL), Kế hoạch thêm tay; hệ thống tính lại khi tạo / sửa / hủy lệnh, khi nhập kho / PO đổi và mỗi đêm
t1 | 0 | 1 | T | Hàng đợi mua (hệ thống gộp, không có phiếu yêu cầu mua riêng): mỗi dòng = 1 NVL × kho nhận; thiếu = nhu cầu − tồn khả dụng − PO và phiếu chuyển kho đang về, tính theo ngày cần; ngày cần = ngày dự kiến chạy sớm nhất − thời gian giao hàng (NCC × NVL, mặc định theo NVL; NVL để trống thì 14 ngày ⚙); danh sách lệnh liên quan. Kế hoạch thêm tay nhu cầu ngoài phần hệ thống tính (mã NC-). Hiện ở tab Hàng đợi mua của màn Đơn mua + Việc cần làm của Mua hàng. Lệnh hủy / giảm → phần chưa lên PO tự giảm; đã có PO → báo Mua hàng tự xử lý với NCC
th | 0 | 3 | T | Hủy nhu cầu lập tay khi chưa lên PO: bắt buộc lý do
d1 | 1 | 2 | D | Tồn khả dụng đủ?\n(lô ĐẠT, hạn ≥ ngưỡng SX,\ntrừ giữ chỗ)
e0 | 1 | 3 | E | Không cần mua
t2 | 2 | 3 | T | Nhận dòng ở Hàng đợi mua
tv | 2 | 4 | T | Không mua được (không có NCC, không kịp ngày cần…): trả dòng về Kế hoạch kèm lý do (chốt 04/11)
e4 | 0 | 5 | E | Về Kế hoạch: Cân đối NVL — chọn cách bù khác (chuyển kho liên nhà máy, lùi ngày) hoặc giao lại để mua (QT19 cb)
y1 | 6 | 4 | Y | Lọc NCC ĐÃ DUYỆT được phép cung cấp NVL này (QT11); ẩn NCC chưa duyệt / bị từ chối / ngừng dùng / đang bị khóa cho NVL này (COA không đạt)
d2 | 6 | 5 | D | Có NCC\nđã duyệt?
r0 | 6 | 6 | R | QT11: Phê duyệt NCC mới
t3 | 2 | 6 | T | Ngay ở Hàng đợi mua: điền SL (làm tròn quy cách), chọn NCC đã duyệt, nhập đơn giá, ngày giao (mặc định = ngày cần) — không có báo giá, không bảng so sánh (bỏ 04/11)
t4 | 2 | 7 | Y | Lập PO: các dòng cùng NCC × kho nhận gộp 1 PO (NVL, SL, đơn giá, ngày giao, kho nhận) → PO: Chờ COA & HSD
ce | 2 | 8 | T | Gửi NCC 1 email yêu cầu COA và hạn dùng cho mọi NVL trong PO (mẫu email sửa được; ghi người gửi, lúc gửi, địa chỉ nhận) (31/10)
cn | 5 | 8 | T | Gửi COA, NSX, HSD từng NVL
ck | 2 | 9 | T | Kiểm COA & HSD NCC gửi: tải file COA, nhập NSX, HSD, giá trị từng chỉ tiêu theo bộ chỉ tiêu COA của NVL (QT02) (30/10)
dc | 6 | 9 | D | COA & HSD\nđạt?
cx | 6 | 10 | Y | Không đạt: PO → Đã hủy (lý do COA / HSD); NCC bị khóa cho NVL không đạt; NVL quay lại Hàng đợi mua để chọn NCC khác
tt | 2 | 10 | T | Chọn hình thức thanh toán (điền sẵn theo NCC, sửa được): Trả trước / Cọc + trả nốt trước giao (tỷ lệ cọc %) / Trả sau N ngày; phương thức CK / tiền mặt → PO: Chờ duyệt (31/10)
d3 | 3 | 11 | D | Duyệt PO?
c2 | 4 | 11 | Y | ⚙ MẶC ĐỊNH (cấu hình lại được): PO trên 100 triệu đồng cần GĐ duyệt thêm sau Trưởng BP Mua hàng
yr | 6 | 11 | Y | Không duyệt: PO → Từ chối (bắt buộc lý do); NVL quay lại Hàng đợi mua
y3 | 6 | 12 | Y | PO → Đã duyệt
gp | 2 | 13 | T | Gửi PO cho NCC qua email (mẫu email sửa được) → PO: Đã gửi NCC (30/10)
hp | 3 | 13 | T | Hủy PO (bắt buộc lý do): PO chưa duyệt — Mua hàng / Trưởng BP Mua hàng; PO đã duyệt — chỉ Trưởng BP Mua hàng; đã gửi NCC thì gửi email báo hủy; NVL quay lại Hàng đợi mua
t5 | 5 | 14 | T | Xác nhận PO (SL, ngày giao), xuất hóa đơn
d4 | 4 | 15 | D | Hình thức\nthanh toán?
t6 | 4 | 16 | T | Trả trước / cọc theo PO (ngoài hệ thống); Kế toán ghi nhận đã trả: số tiền, ngày, CK / tiền mặt, ảnh chứng từ — không duyệt. Cọc + trả nốt trước giao: ghi khoản cọc, rồi khoản trả nốt trước khi NCC giao (31/10)
y4 | 6 | 16 | Y | Ghi khoản phải trả NCC theo PO; hạn = ngày nhận hàng + N ngày theo điều khoản
t7 | 5 | 17 | T | Giao hàng kèm file đánh giá bên ngoài, số lô, NSX, HSD (bắt buộc)
r1 | 1 | 18 | R | QT14 (PO đã duyệt sao xuống máy chủ nhà máy): Nhập kho — đối chiếu PO, ghi lô NCC / NSX / HSD, tải file đánh giá bên ngoài; hàng lỗi → QT13
y5 | 6 | 19 | Y | Cập nhật SL đã nhận theo dòng PO; giao trễ / thiếu → ghi lịch sử NCC
d5 | 6 | 20 | D | PO nhận đủ?
dl | 3 | 21 | T | PO giao thiếu, không chờ phần còn lại: Trưởng BP Mua hàng đóng phần còn lại (bắt buộc lý do) → PO Đã đóng; phần chưa giao quay lại Hàng đợi mua; gửi email báo NCC
e | 6 | 22 | E | Kết thúc (PO → Đã nhận đủ / Đã đóng)
s3 | 4 | 23 | S | Đến hạn trả khoản phải trả NCC (PO trả sau)
t8 | 4 | 24 | T | Trả NCC (ngoài hệ thống); Kế toán ghi nhận đã trả — giảm khoản phải trả (màn Công nợ NCC)
e3 | 4 | 25 | E | Kết thúc
---
s -> t1
t1 -> d1
d1 -> e0 : Đủ
t1 -> th : Không cần mua nữa
th -> e0
d1 -> t2 : Thiếu
t2 -> tv : Không mua được
tv -> e4
t2 -> y1
y1 -> d2
d2 -> r0 : Không
r0 -> y1 : NCC mới đã duyệt
r0 -> tv : Không có NCC
d2 -> t3 : Có
t3 -> t4
t4 -> ce
ce -> cn
cn -> ck
ck -> dc
dc -> cx : Không đạt
cx -> t2 : Chọn NCC khác
dc -> tt : Đạt
tt -> d3
c2 -> d3 :  : n
d3 -> yr : Không
yr -> t2 : NVL về Hàng đợi mua
d3 -> y3 : Duyệt
y3 -> gp
t4 -> hp : Hủy PO
gp -> hp : Hủy PO
hp -> t2 : NVL về Hàng đợi mua
gp -> t5
t5 -> d4
d4 -> t6 : Trả trước / Cọc + trả nốt
d4 -> y4 : Trả sau
t6 -> t7
y4 -> t7
t7 -> r1
r1 -> y5
y5 -> d5
d5 -> t7 : Thiếu → chờ giao tiếp
d5 -> dl : Thiếu, không chờ
dl -> t2 : Phần chưa giao về Hàng đợi mua
d5 -> e : Đủ
s3 -> t8
t8 -> e3
```

## QT13. Quy trình Trả hàng Nhà cung cấp

Sửa 16/10 (vòng đời lô hàng): bỏ tranh chấp và kiểm nghiệm bên thứ 3 khỏi quy trình — NCC không chấp nhận thì nhà máy tự giải quyết ngoài hệ thống, lô giữ nguyên trạng thái, xong thì xuất trả NCC hoặc hủy (QT18). Hàng trả NCC xuất qua loại xuất "trả NCC" (QT15), đổi 1-1 hay giảm công nợ đều xuất trả trước; không thêm trạng thái. Lô KHÔNG ĐẠT giữ nguyên; lô ĐẠT bị khóa lý do "hàng hư, chờ trả NCC"; hàng bị từ chối ở cửa kho không tạo lô. Lần trả hàng ghi vào lịch sử NCC để tra cứu. Sửa 19/10 (đợt 2): phiếu trả thêm trạng thái "Chờ kho xuất trả" — Mua hàng gửi yêu cầu xuất trả; Thủ kho lập phiếu xuất loại trả NCC (24/10 đợt 6: Trưởng BP Mua hàng duyệt yêu cầu xuất trả trước, phiếu xuất không duyệt); xuất xong → "Đã xuất trả". Giảm trừ do Kế toán ghi ở Công nợ NCC. Không được trả vượt số đã nhận của PO (cộng cả các phiếu trả khác); không được chọn "giảm công nợ" khi PO là trả trước.

```quy-trinh
so: 13
mang: Mua hàng
tu: QT7
ten-ngan: Trả hàng NCC
ten: Quy trình Trả hàng Nhà cung cấp
ghi-chu: Sửa 16/10 (vòng đời lô hàng): bỏ tranh chấp và kiểm nghiệm bên thứ 3 khỏi quy trình — NCC không chấp nhận thì nhà máy tự giải quyết ngoài hệ thống, lô giữ nguyên trạng thái, xong thì xuất trả NCC hoặc hủy (QT18). Hàng trả NCC xuất qua loại xuất "trả NCC" (QT15), đổi 1-1 hay giảm công nợ đều xuất trả trước; không thêm trạng thái. Lô KHÔNG ĐẠT giữ nguyên; lô ĐẠT bị khóa lý do "hàng hư, chờ trả NCC"; hàng bị từ chối ở cửa kho không tạo lô. Lần trả hàng ghi vào lịch sử NCC để tra cứu. Sửa 19/10 (đợt 2): phiếu trả thêm trạng thái "Chờ kho xuất trả" — Mua hàng gửi yêu cầu xuất trả; Thủ kho lập phiếu xuất loại trả NCC (24/10 đợt 6: Trưởng BP Mua hàng duyệt yêu cầu xuất trả trước, phiếu xuất không duyệt); xuất xong → "Đã xuất trả". Giảm trừ do Kế toán ghi ở Công nợ NCC. Không được trả vượt số đã nhận của PO (cộng cả các phiếu trả khác); không được chọn "giảm công nợ" khi PO là trả trước.
cot: Kho | Mua hàng | Nhà cung cấp | Kế toán | Hệ thống
s | 0 | 0 | S | Hàng hư phát hiện sau nhập / thiếu chứng từ (từ chối ở cửa kho, QT14) / QC nguyên liệu kết luận không đạt (QT22)
t1 | 0 | 1 | T | Để riêng hàng lỗi chờ trả, ngoài hệ thống (hàng đã nhập giữ KHÓA / KHÔNG ĐẠT trong tồn; hàng bị từ chối ở cửa kho: không tạo lô, không tính tồn); ghi nhận SP lỗi
y1 | 4 | 2 | Y | Lô đang ĐẠT → KHÓA, lý do "hàng hư, chờ trả NCC"; lô KHÔNG ĐẠT giữ nguyên; hàng bị từ chối ở cửa kho không có lô → bỏ qua
t2 | 1 | 3 | Y | Tạo phiếu trả hàng (gắn PO, phiếu nhập / biên bản giao nhận), liên hệ NCC → phiếu Chờ NCC xác nhận
yq | 4 | 3 | Y | Phiếu trả bắt buộc gắn PO; SL theo ĐVT gốc của NVL. Chặn SL trả vượt SL đã nhận của PO (cộng mọi phiếu trả khác của PO) và vượt tồn hiện có của lô; hàng từ chối ở cửa kho so với biên bản từ chối
d1 | 2 | 4 | D | NCC chấp nhận?
n1 | 1 | 5 | T | Lập biên bản không thống nhất (ảnh, kết quả QC QT22, file đánh giá bên ngoài, số lô), gửi NCC
n2 | 1 | 6 | T | Nhà máy tự giải quyết với NCC ngoài hệ thống (thương lượng, kiểm nghiệm, pháp lý); lô giữ nguyên trạng thái trong lúc chờ
nd | 1 | 7 | D | Kết quả?
tx | 1 | 8 | T | Gửi yêu cầu xuất trả → phiếu trả: Chờ duyệt xuất trả
dx | 1 | 9 | D | Trưởng BP Mua hàng\nduyệt yêu cầu xuất trả?
r2 | 4 | 8 | R | QT18: Hủy hàng (nhà máy chịu tổn thất)
t3 | 0 | 10 | T | Lập phiếu xuất loại "trả NCC" theo yêu cầu xuất trả, đúng lô trên phiếu trả (KHÓA / KHÔNG ĐẠT)
r3 | 0 | 11 | R | QT15: Xuất kho — phiếu vào thẳng Chờ lấy hàng, kho lấy hàng, quét đúng lô, giao NCC
y3 | 4 | 12 | Y | Xuất xong: phiếu trả → Đã xuất trả; tồn giảm, truy xuất ghi "đã trả NCC"
d2 | 2 | 13 | D | Đổi 1-1 hay giảm công nợ?
yg | 4 | 13 | Y | PO trả trước: không cho chọn "giảm công nợ" (chỉ đổi 1-1)
t6 | 0 | 14 | T | Hàng đổi về → nhập kho như hàng mua mới (QT14)
t4 | 3 | 14 | T | Kế toán ghi nhận giảm trừ khoản phải trả NCC (màn Công nợ NCC)
t5 | 1 | 15 | T | Ký xác nhận, gửi giấy tờ pháp lý cho kế toán
y2 | 4 | 16 | Y | Ghi lịch sử trả hàng của NCC (tra cứu khi chọn NCC)
e | 4 | 17 | E | Kết thúc
---
s -> t1
t1 -> y1
y1 -> t2
yq -> t2 :  : n
t2 -> d1
d1 -> tx : Có
d1 -> n1 : Không
n1 -> n2
n2 -> nd
nd -> tx : NCC nhận lại
nd -> r2 : Nhà máy chịu
tx -> dx
dx -> t3 : Duyệt → Chờ kho xuất trả, sao xuống nhà máy
dx -> tx : Từ chối (bắt buộc lý do) → phiếu về Mở, sửa gửi lại
t3 -> r3
r3 -> y3
y3 -> d2
yg -> d2 :  : n
d2 -> t6 : Đổi
d2 -> t4 : Giảm nợ
t6 -> t5
t4 -> t5
t5 -> y2
r2 -> y2
y2 -> e
```


# Mảng 4 · Kho

## QT14. Quy trình Nhập kho (NVL mua, BTP từ chiết rót, NVL dư trả về, hàng khách trả, hàng thu hồi)

Gộp QT6 (nhận NVL mua) + QT9 (nhập TP / BTP / NVL dư từ SX) + phần tạo mã của QT8. Không in tem trước: thủ kho tạo mã, in tem, dán và quét tại chỗ từng bao — chỉ với NVL mua (sửa 24/10 đợt 7: thùng BTP dán QR lúc đóng thùng ở QT21, bao bột dư dán lúc xả ở QT20, hàng khách trả / thu hồi / chuyển kho giữ mã cũ → kho chỉ quét tem có sẵn). Sửa 16/10: gộp 2 bước kiểm ngoại quan thành 1 quyết định kiểm từng bao cho mọi loại nhập; chỉ tách bao hư, phần ổn nhập tiếp: NVL mua → trả NCC (QT13); từ SX → phiếu NCR, không dùng lại được thì QT18; khách trả / thu hồi → ghi biên bản, vẫn nhập. Bổ sung 16/10, sửa 24/10 đợt 3: ghi số lô NCC / NSX / HSD từng lô, tải file đánh giá bên ngoài (bắt buộc; bỏ COA và bộ chỉ tiêu — hệ thống chỉ lưu file, chỉ kiểm HSD). Chốt 16/10 về QC khi nhập: NVL mua không QC — vào kho là ĐẠT, xuất được ngay; BTP (thùng lon sau chiết rót) vào kho BTP ở CHỜ KIỂM → QC thành phẩm (QT23), đạt thì đổi thành TP mới giao (QT23 gọi QT09); hàng khách trả vào KHÓA (lý do khách trả) → QT23 kiểm lại; hàng thu hồi (QT26) vào KHÓA (lý do thu hồi), chỉ chờ hủy; NVL dư nhận trạng thái theo khóa cả lô của lô gốc. Thiếu chứng từ thì từ chối ở cửa kho, không tạo lô. Nhập do chuyển kho ở QT16; tem hỏng / mất / hủy về sau ở QT04. Sửa 20/10 (đợt 2 — offline): toàn bộ QT chạy tại máy chủ nhà máy (nhà máy là chủ tồn, lô, bao, phiếu nhập); chứng từ nguồn — PO đã duyệt, biên bản giao nhận, hồ sơ thu hồi, phiếu chuyển từ nhà máy khác — là bản sao cloud gửi xuống trước; chưa sao xuống thì coi như thiếu chứng từ (d1). Mã bao NVL sinh tại nhà máy (tiền tố nhà máy). Thủ kho trưởng xác nhận chênh lệch tại chỗ (đợt 7: phiếu khớp không duyệt); Kế toán t4 làm khi có mạng; cloud nhận phiếu rồi chiếu SL đã nhận sang PO / đợt giao / hồ sơ thu hồi / phiếu chuyển.

```quy-trinh
so: 14
mang: Kho
tu: QT6 + QT9 + QT8 (tạo mã)
ten-ngan: Nhập kho
ten: Quy trình Nhập kho (NVL mua, BTP từ chiết rót, NVL dư trả về, hàng khách trả, hàng thu hồi)
ghi-chu: Gộp QT6 (nhận NVL mua) + QT9 (nhập TP / BTP / NVL dư từ SX) + phần tạo mã của QT8. Không in tem trước: thủ kho tạo mã, in tem, dán và quét tại chỗ từng bao — chỉ với NVL mua (sửa 24/10 đợt 7: thùng BTP dán QR lúc đóng thùng ở QT21, bao bột dư dán lúc xả ở QT20, hàng khách trả / thu hồi / chuyển kho giữ mã cũ → kho chỉ quét tem có sẵn). Sửa 16/10: gộp 2 bước kiểm ngoại quan thành 1 quyết định kiểm từng bao cho mọi loại nhập; chỉ tách bao hư, phần ổn nhập tiếp: NVL mua → trả NCC (QT13); từ SX → phiếu NCR, không dùng lại được thì QT18; khách trả / thu hồi → ghi biên bản, vẫn nhập. Bổ sung 16/10, sửa 24/10 đợt 3: ghi số lô NCC / NSX / HSD từng lô, tải file đánh giá bên ngoài (bắt buộc; bỏ COA và bộ chỉ tiêu — hệ thống chỉ lưu file, chỉ kiểm HSD). Chốt 16/10 về QC khi nhập: NVL mua không QC — vào kho là ĐẠT, xuất được ngay; BTP (thùng lon sau chiết rót) vào kho BTP ở CHỜ KIỂM → QC thành phẩm (QT23), đạt thì đổi thành TP mới giao (QT23 gọi QT09); hàng khách trả vào KHÓA (lý do khách trả) → QT23 kiểm lại; hàng thu hồi (QT26) vào KHÓA (lý do thu hồi), chỉ chờ hủy; NVL dư nhận trạng thái theo khóa cả lô của lô gốc. Thiếu chứng từ thì từ chối ở cửa kho, không tạo lô. Nhập do chuyển kho ở QT16; tem hỏng / mất / hủy về sau ở QT04. Sửa 20/10 (đợt 2 — offline): toàn bộ QT chạy tại máy chủ nhà máy (nhà máy là chủ tồn, lô, bao, phiếu nhập); chứng từ nguồn — PO đã duyệt, biên bản giao nhận, hồ sơ thu hồi, phiếu chuyển từ nhà máy khác — là bản sao cloud gửi xuống trước; chưa sao xuống thì coi như thiếu chứng từ (d1). Mã bao NVL sinh tại nhà máy (tiền tố nhà máy). Thủ kho trưởng xác nhận chênh lệch tại chỗ (đợt 7: phiếu khớp không duyệt); Kế toán t4 làm khi có mạng; cloud nhận phiếu rồi chiếu SL đã nhận sang PO / đợt giao / hồ sơ thu hồi / phiếu chuyển.
cot: NCC / Kế hoạch (bên giao từ SX) | Kho | Mua hàng | QC | Thủ kho trưởng | Kế toán | Hệ thống
s | 0 | 0 | S | Có hàng cần nhập (NCC giao / SX giao / khách trả)
d0 | 1 | 1 | D | Loại nhập?
t1 | 1 | 2 | T | Quét QR đơn mua → phiếu nhập điền sẵn theo PO (SL dự kiến = SL giao theo hóa đơn / phiếu giao); đối chiếu hóa đơn, chứng từ
y0 | 6 | 2 | Y | Tự sinh phiếu nhập Chờ nhận hàng từ lệnh SX — BTP: khi đóng thùng xong (QT21), kèm số thùng dự kiến; NVL dư: khi xả bột dư — không ai lập tay; tự điền lô SX, NSX = ngày SX, HSD = NSX + HSD chuẩn (QT02) (tại máy chủ nhà máy, kể cả khi mất mạng — gồm bột dư silo, QT20 xd)
y6 | 6 | 3 | Y | Tự sinh phiếu nhập Chờ nhận hàng từ phần khách không nhận đã ghi trên phiếu xuất bán (QT09); giữ mã lon / thùng, lô, HSD cũ
yh | 6 | 1 | Y | Tự sinh phiếu nhập Chờ nhận hàng loại "hàng thu hồi" từ hồ sơ thu hồi (QT26): khách, lô, SL thu về; giữ mã lon / thùng, lô cũ
d1 | 1 | 3 | D | Đủ chứng từ?
c1 | 2 | 3 | Y | Không cho nợ chứng từ: thiếu chứng từ là không nhận, báo Mua hàng và trả NCC; không tạo lô, hàng để riêng chờ trả (không tính tồn) hoặc NCC chở về
t2 | 2 | 5 | T | Báo mua hàng, tạo phiếu gửi NCC
r1 | 2 | 6 | R | QT13: Trả hàng NCC
t3 | 1 | 6 | D | Kiểm ngoại quan\ntừng bao / thùng: ổn?
th | 6 | 6 | Y | Ghi bao hư: mã / SL, lý do, ảnh
dh | 6 | 7 | D | Bao hư thuộc\nloại nhập?
nr | 0 | 7 | T | Kế hoạch lập phiếu báo lỗi NCR (lý do, SL, người chịu trách nhiệm)
rr | 0 | 8 | R | QT18: Hủy hàng (bao không dùng lại được)
kb | 1 | 8 | T | Ghi tình trạng bao hư vào biên bản; vẫn nhập
k1 | 1 | 7 | T | Thủ kho chọn dòng hàng trên phiếu, nhập số bao / thùng
f1 | 5 | 8 | F | ⚠ SỬA: mã QR chỉ là mã định danh duy nhất + tra CSDL; không nhúng loại / ngày vào mã
k2 | 6 | 8 | Y | NVL mua: tạo mã cho bao đang nhập (gắn lô, phiếu), in 1 tem tại chỗ. BTP / NVL dư / khách trả / thu hồi / chuyển kho: không tạo mã, không in — dùng tem có sẵn (thùng BTP dán lúc đóng thùng, QT21)
k3 | 1 | 9 | T | NVL mua: dán tem lên bao, quét ngay. Hàng đã có tem: quét tem có sẵn
k4 | 6 | 10 | Y | Đối chiếu mã với phiếu / dòng hàng; kích hoạt mã, ghi nhật ký
k6 | 1 | 11 | T | Gỡ tem dán nhầm, dán lại đúng bao
k5 | 6 | 11 | D | Khớp?
k7 | 1 | 12 | D | Đã quét đủ số bao?
c2 | 3 | 13 | Y | Phiếu nhập không duyệt (24/10 đợt 7): chứng từ gốc là PO / lệnh SX / ghi nhận giao / hồ sơ thu hồi / phiếu chuyển; Thủ kho trưởng chỉ xác nhận khi lệch
dl | 6 | 13 | D | SL nhận khớp dự kiến,\nkhông bao hư?
d4 | 4 | 14 | D | Thủ kho trưởng xác nhận\nchênh lệch?
l1 | 1 | 4 | T | Nhập số lô NCC, NSX, HSD cho từng lô; tải file đánh giá bên ngoài (bắt buộc, ≥ 1 file / lô)
lv | 6 | 4 | Y | Kiểm: mỗi lô có file đánh giá bên ngoài; HSD còn ≥ mức tối thiểu. Không đọc nội dung file
c3 | 5 | 5 | Y | ⚙ MẶC ĐỊNH (cấu hình lại được): HSD còn ≥ 2/3 hạn dùng khi nhận (cấu hình theo NVL)
ld | 6 | 5 | D | Đủ file, HSD\nhợp lệ?
y2 | 6 | 14 | Y | Cập nhật tồn theo lô × kho; trạng thái ghi trên từng bao: BTP → CHỜ KIỂM (chặn xuất tới khi QC đạt và đổi thành TP); NVL mua → ĐẠT, xuất được ngay (không QC); NVL dư → theo khóa cả lô của lô gốc (không khóa, còn hạn → ĐẠT; có khóa cả lô → cùng lý do; lô gốc đã HỦY → KHÓA chờ hủy + phiếu hủy); khách trả → KHÓA lý do khách trả, chờ QC kiểm lại; thu hồi → KHÓA lý do thu hồi, không vào tồn bán
d6 | 6 | 15 | D | Loại hàng?
t4 | 5 | 16 | T | Kế toán lưu hóa đơn / chứng từ của phiếu nhập NVL mua đã nhập: số hóa đơn, tệp, đã nhận bản cứng (file đánh giá bên ngoài đi theo lô)
rt | 6 | 16 | R | QT23: QC thành phẩm (BTP mới nhập, đạt → TP) / kiểm lại hàng khách trả
e | 6 | 17 | E | Kết thúc
---
s -> d0
d0 -> t1 : NVL mua
d0 -> y0 : Từ SX
d0 -> y6 : Khách trả
d0 -> yh : Hàng thu hồi
t1 -> d1
c1 -> d1 :  : n
d1 -> t2 : Không
t2 -> r1
y0 -> t3
y6 -> t3
yh -> t3
t3 -> k1 : Ổn
t3 -> th : Có bao hư
th -> k1 : Phần ổn nhập tiếp
th -> dh
dh -> t2 : NVL mua → trả NCC
dh -> nr : Từ SX
dh -> kb : Khách trả / thu hồi
nr -> rr
kb -> k1
k1 -> k2
f1 -> k2 :  : n
k2 -> k3
k3 -> k4
k4 -> k5
k5 -> k6 : Không
k6 -> k3
k5 -> k7 : Có
k7 -> k2 : Bao tiếp theo
k7 -> dl : Đủ → phiếu tự kiểm
c2 -> dl :  : n
dl -> y2 : Khớp → Đã nhập
dl -> d4 : Lệch → Chờ xác nhận lệch
d1 -> l1 : Có
l1 -> lv
lv -> ld
c3 -> ld :  : n
ld -> t2 : Không
ld -> t3 : Có
d4 -> y2 : Xác nhận → nhập theo SL thực, Đã nhập
d4 -> k1 : Yêu cầu đếm lại (lý do) → Đang nhận
y2 -> d6
d6 -> t4 : NVL mua
d6 -> rt : BTP từ SX / khách trả
d6 -> e : NVL dư / thu hồi
t4 -> e
rt -> e
r1 -> e
rr -> e
```

## QT15. Quy trình Xuất kho

Sửa 16/10: hệ thống đề xuất lô theo loại xuất rồi mới tạo phiếu và duyệt; kho chỉ lấy hàng sau khi phiếu đã duyệt (không lấy trước rồi phải cất lại). Xuất bán lấy đúng lô gắn với đơn, không theo FEFO; NVL xuất SX theo FEFO, bỏ qua lô có hạn còn dưới ngưỡng tối thiểu cho SX (sửa 24/10 đợt 9, thay "lô cận date lên đầu"), trừ vào số KG đã giữ chỗ cho lệnh ở QT19 — QT19 giữ theo kg, không giữ lô; chuyển kho lấy lô trong phiếu chuyển (QT16). Mỗi lần quét, hệ thống kiểm ngay lô có đúng phiếu và đúng quy tắc trạng thái của loại xuất (bán / SX: chỉ ĐẠT, còn hạn; chuyển kho: mọi trạng thái trừ HỦY; trả NCC: KHÓA / KHÔNG ĐẠT theo phiếu trả), kho / lô không có cờ đang kiểm kê — sai thì báo lỗi ngay trên màn lấy hàng (Kho trên web, quét bằng đầu đọc mã), kho lấy lại, bộ phận yêu cầu không cần biết. Thiếu hàng tách riêng: hệ thống ghi lệch tồn (gọi QT17), tìm lô thay thế; không có thì bộ phận yêu cầu chọn nhận phần đã lấy hoặc hủy yêu cầu. Sửa 19/10 (đợt 2): thiếu mà không có lô thay thế (bán / chuyển kho / trả NCC) thì phiếu sang "Chờ bên yêu cầu"; chỉ bên yêu cầu chọn nhận phần đã lấy (→ Xuất một phần) hoặc hủy (→ Đã hủy). Xuất trả NCC: Mua hàng gửi yêu cầu xuất trả (QT13), Thủ kho lập phiếu. Sửa 19/10 (đợt 4): xuất SX lập **từ kho điều phối** — NVL cho SX đi kho tổng → chuyển kho (QT16) → kho điều phối; Thủ kho điều phối chuẩn bị NVL theo lệnh và lập phiếu xuất SX cho khu (yêu cầu là lệnh SX của Kế hoạch; Kế hoạch là bên yêu cầu khi phiếu Chờ bên yêu cầu). Không xuất SX thẳng từ kho tổng. Lô đề xuất theo FEFO trong tồn kho điều phối, trừ vào KG giữ chỗ của lệnh. Kho điều phối thiếu thì hệ thống tự lập phiếu chuyển nội bộ phần thiếu, vào thẳng Chờ xuất (QT19, QT16 — 30/10), không lấy từ kho tổng. Sửa 20/10: bỏ "Thủ kho yêu cầu xuất cho kho khác" — chuyển giữa các kho chỉ qua QT16. Sửa 20/10 (đợt 2 — offline): QT chạy tại máy chủ nhà máy; yêu cầu xuất bán / trả NCC / chuyển kho là bản sao từ cloud (chỉ lập phiếu từ yêu cầu đã xuống trước lúc mất mạng), xuất SX lập từ lệnh đã nhận; lô đề xuất tính trên tồn thật của nhà máy; Thủ kho trưởng duyệt tại chỗ; phiếu Chờ bên yêu cầu (y6) xếp chờ gửi lên, bên yêu cầu ở văn phòng chọn khi có mạng; mã phiếu có tiền tố nhà máy. Sửa 24/10 (đợt 4): phiếu xuất bán do máy chủ nhà máy tự lập từ yêu cầu xuất bán đã sao xuống (lô, SL theo yêu cầu, không đề xuất lại) và vào thẳng Chờ lấy hàng — bỏ qua d1 (không Thủ kho trưởng duyệt); Thủ kho không lập tay; lô không còn đủ thì trả yêu cầu về Sales kèm lý do. Sửa 24/10 (đợt 5): phiếu xuất SX (Thủ kho điều phối lập theo lệnh, lô FEFO hệ thống đề xuất) cũng vào thẳng Chờ lấy hàng, lấy hàng luôn — bỏ qua d1. Chỉ chuyển kho, trả NCC còn qua Thủ kho trưởng duyệt. Sửa 24/10 (đợt 6): bỏ hẳn bước Thủ kho trưởng duyệt phiếu xuất (d1) cho mọi loại — duyệt một lần ở chứng từ gốc (đơn / yêu cầu xuất bán, lệnh SX, phiếu chuyển do Thủ kho trưởng xác nhận ở QT16, yêu cầu xuất trả do Trưởng BP Mua hàng duyệt ở QT13); kho chỉ làm theo, kiểm soát bằng quét đúng lô, đúng SL.

```quy-trinh
so: 15
mang: Kho
tu: QT20
ten-ngan: Xuất kho
ten: Quy trình Xuất kho
ghi-chu: Sửa 16/10: hệ thống đề xuất lô theo loại xuất rồi mới tạo phiếu và duyệt; kho chỉ lấy hàng sau khi phiếu đã duyệt (không lấy trước rồi phải cất lại). Xuất bán lấy đúng lô gắn với đơn, không theo FEFO; NVL xuất SX theo FEFO, bỏ qua lô có hạn còn dưới ngưỡng tối thiểu cho SX (sửa 24/10 đợt 9, thay "lô cận date lên đầu"), trừ vào số KG đã giữ chỗ cho lệnh ở QT19 — QT19 giữ theo kg, không giữ lô; chuyển kho lấy lô trong phiếu chuyển (QT16). Mỗi lần quét, hệ thống kiểm ngay lô có đúng phiếu và đúng quy tắc trạng thái của loại xuất (bán / SX: chỉ ĐẠT, còn hạn; chuyển kho: mọi trạng thái trừ HỦY; trả NCC: KHÓA / KHÔNG ĐẠT theo phiếu trả), kho / lô không có cờ đang kiểm kê — sai thì báo lỗi ngay trên màn lấy hàng (Kho trên web, quét bằng đầu đọc mã), kho lấy lại, bộ phận yêu cầu không cần biết. Thiếu hàng tách riêng: hệ thống ghi lệch tồn (gọi QT17), tìm lô thay thế; không có thì bộ phận yêu cầu chọn nhận phần đã lấy hoặc hủy yêu cầu. Sửa 19/10 (đợt 2): thiếu mà không có lô thay thế (bán / chuyển kho / trả NCC) thì phiếu sang "Chờ bên yêu cầu"; chỉ bên yêu cầu chọn nhận phần đã lấy (→ Xuất một phần) hoặc hủy (→ Đã hủy). Xuất trả NCC: Mua hàng gửi yêu cầu xuất trả (QT13), Thủ kho lập phiếu. Sửa 19/10 (đợt 4): xuất SX lập **từ kho điều phối** — NVL cho SX đi kho tổng → chuyển kho (QT16) → kho điều phối; Thủ kho điều phối chuẩn bị NVL theo lệnh và lập phiếu xuất SX cho khu (yêu cầu là lệnh SX của Kế hoạch; Kế hoạch là bên yêu cầu khi phiếu Chờ bên yêu cầu). Không xuất SX thẳng từ kho tổng. Lô đề xuất theo FEFO trong tồn kho điều phối, trừ vào KG giữ chỗ của lệnh. Kho điều phối thiếu thì hệ thống tự lập phiếu chuyển nội bộ phần thiếu, vào thẳng Chờ xuất (QT19, QT16 — 30/10), không lấy từ kho tổng. Sửa 20/10: bỏ "Thủ kho yêu cầu xuất cho kho khác" — chuyển giữa các kho chỉ qua QT16. Sửa 20/10 (đợt 2 — offline): QT chạy tại máy chủ nhà máy; yêu cầu xuất bán / trả NCC / chuyển kho là bản sao từ cloud (chỉ lập phiếu từ yêu cầu đã xuống trước lúc mất mạng), xuất SX lập từ lệnh đã nhận; lô đề xuất tính trên tồn thật của nhà máy; Thủ kho trưởng duyệt tại chỗ; phiếu Chờ bên yêu cầu (y6) xếp chờ gửi lên, bên yêu cầu ở văn phòng chọn khi có mạng; mã phiếu có tiền tố nhà máy. Sửa 24/10 (đợt 4): phiếu xuất bán do máy chủ nhà máy tự lập từ yêu cầu xuất bán đã sao xuống (lô, SL theo yêu cầu, không đề xuất lại) và vào thẳng Chờ lấy hàng — bỏ qua d1 (không Thủ kho trưởng duyệt); Thủ kho không lập tay; lô không còn đủ thì trả yêu cầu về Sales kèm lý do. Sửa 24/10 (đợt 5): phiếu xuất SX (Thủ kho điều phối lập theo lệnh, lô FEFO hệ thống đề xuất) cũng vào thẳng Chờ lấy hàng, lấy hàng luôn — bỏ qua d1. Chỉ chuyển kho, trả NCC còn qua Thủ kho trưởng duyệt. Sửa 24/10 (đợt 6): bỏ hẳn bước Thủ kho trưởng duyệt phiếu xuất (d1) cho mọi loại — duyệt một lần ở chứng từ gốc (đơn / yêu cầu xuất bán, lệnh SX, phiếu chuyển do Thủ kho trưởng xác nhận ở QT16, yêu cầu xuất trả do Trưởng BP Mua hàng duyệt ở QT13); kho chỉ làm theo, kiểm soát bằng quét đúng lô, đúng SL.
cot: Bộ phận yêu cầu (Kế hoạch / Sales / Mua hàng) | Kho | Thủ kho trưởng | Hệ thống
s | 0 | 0 | S | Yêu cầu xuất (SX / bán / chuyển kho / trả NCC)
c1 | 2 | 1 | Y | Xuất bao hỗn hợp sang khu khác lấy lô theo FEFO (như NVL)
y0 | 3 | 1 | Y | Đề xuất lô: bán → lô TP của đơn; NVL cho SX → chỉ trong kho điều phối, FEFO, chỉ lô có hạn còn ≥ ngưỡng tối thiểu cho SX, đủ số KG đã giữ cho lệnh (QT19; máy chủ nhà máy tự lập phiếu khi lệnh phát sang khu, nơi nhận = khu của lệnh — 24/10 đợt 10); bao hỗn hợp sang khu khác → FEFO; bán / SX chỉ lấy phần ĐẠT, còn hạn. Chuyển kho → lô trên phiếu chuyển, mọi trạng thái trừ HỦY; trả NCC → lô trên phiếu trả (KHÓA / KHÔNG ĐẠT)
d0 | 3 | 2 | D | Đủ lô khả dụng\ncho SL yêu cầu?
dq0 | 0 | 3 | D | Xuất phần có\nhay hủy yêu cầu?\n(xuất SX: tự xuất phần có,\nthiếu → phiếu chuyển nội bộ)
y1 | 3 | 3 | Y | Tạo phiếu xuất kèm lô và SL đề xuất → phiếu Chờ lấy hàng (mọi loại xuất, không qua duyệt — duyệt đã nằm ở chứng từ gốc: đơn / yêu cầu xuất bán, lệnh SX, phiếu chuyển, yêu cầu xuất trả NCC)
t2 | 1 | 5 | T | Lấy hàng theo phiếu, quét QR từng bao / thùng
y2 | 3 | 6 | Y | Kiểm ngay mỗi lần quét: lô đúng phiếu; trạng thái đúng quy tắc loại xuất (bán: ĐẠT, còn hạn; SX: ĐẠT, hạn còn ≥ ngưỡng tối thiểu cho SX); kho / lô không có cờ đang kiểm kê; bao đầu tiên hợp lệ → phiếu Đang lấy hàng
t3 | 1 | 7 | T | Màn lấy hàng báo lỗi: để bao lại chỗ cũ, lấy bao đúng lô
d2 | 3 | 7 | D | Bao vừa quét\nhợp lệ?
d3 | 3 | 8 | D | Đã quét đủ SL\ntrên phiếu?
d4 | 1 | 9 | D | Trong kho còn bao\nđúng lô?
y3 | 3 | 10 | Y | Ghi lệch tồn (sổ có, thực tế không), báo Thủ kho trưởng; tìm lô thay thế cùng quy tắc (NVL: lô FEFO kế tiếp; xuất bán: không thay được)
r1 | 2 | 11 | R | QT17: Kiểm kho lô bị lệch
d5 | 3 | 11 | D | Có lô thay thế?
y4 | 3 | 12 | Y | Thêm lô thay thế vào phiếu, ghi nhật ký
y6 | 3 | 13 | Y | Bán / chuyển kho / trả NCC: phiếu Đang lấy hàng → Chờ bên yêu cầu, báo bên yêu cầu (chỉ bên yêu cầu được chọn). Xuất SX (24/10 đợt 10): không chờ — phiếu tự Xuất một phần, phần thiếu thành phiếu chuyển nội bộ tự lập, vào thẳng Chờ xuất (QT16 — 30/10); kho tổng cũng thiếu → hệ thống tự lập yêu cầu mua phần thiếu, báo Mua hàng (đợt 11)
dq1 | 0 | 14 | D | Chờ bên yêu cầu:\nnhận phần đã lấy\nhay hủy?
t4 | 1 | 15 | T | Trả hàng đã lấy về lại kho; phiếu → Đã hủy (phiếu còn Chờ lấy hàng — chưa quét — thì hủy thẳng, không phải trả hàng). Xuất SX: lệnh hủy / kết thúc sớm → phiếu tự hủy theo, Đang lấy hàng thì hệ thống giao việc trả hàng cho thủ kho
y5 | 3 | 16 | Y | Cập nhật tồn theo SL thực xuất; phiếu → Đã xuất / Xuất một phần; ghi lô → đối tượng nhận; xuất SX: trừ KG đã giữ của lệnh
e | 3 | 17 | E | Kết thúc
---
s -> y0
c1 -> y0 :  : n
y0 -> d0
d0 -> y1 : Đủ
d0 -> dq0 : Thiếu
dq0 -> y1 : Xuất phần có
dq0 -> e : Hủy yêu cầu
y1 -> t2
t2 -> y2
y2 -> d2
d2 -> t3 : Không
t3 -> t2 : Lấy lại, quét lại
d2 -> d3 : Có
d3 -> y5 : Đủ
d3 -> d4 : Chưa
d4 -> t2 : Còn → quét tiếp
d4 -> y3 : Hết
y3 -> d5
y3 -> r1
r1 -> e
d5 -> y4 : Có
d5 -> y6 : Không
y6 -> dq1
y4 -> t2 : Lấy tiếp
dq1 -> y5 : Nhận phần đã lấy → Xuất một phần
y6 -> y5 : Xuất SX → tự Xuất một phần
dq1 -> t4 : Hủy yêu cầu
t4 -> e
y5 -> e
```

## QT16. Quy trình Chuyển kho (cùng nhà máy / giữa 2 nhà máy)

Gộp QT13 (nội bộ: kho tổng ↔ kho điều phối ↔ kho BTP) + QT16 (giữa 2 nhà máy). Chỉ chuyển khác nhà máy mới có bước vận chuyển và kiểm hàng đến. Sửa 16/10 (vòng đời lô hàng): bỏ trạng thái ĐANG CHUYỂN — hàng xuất đi nằm trên phiếu chuyển (sửa 24/10: không còn vị trí "trên xe"; tồn đang chuyển không thuộc kho nào), giữ nguyên trạng thái và lý do khóa, không tính tồn dùng được; chuyển được mọi trạng thái trừ HỦY. Nhận thiếu: chờ tìm 7 ngày rồi biên bản thất lạc, Thủ kho trưởng xác nhận → HỦY (chốt 17/10); nhận hư: chỉ các bao hư KHÓA, bao lành giữ trạng thái. Sửa 24/10: bỏ vị trí kệ, không còn thao tác dời vị trí trong cùng kho. Sửa 19/10 (đợt 4): NVL cho SX đi kho tổng → kho điều phối qua QT này. Khi tạo / phát lệnh mà kho điều phối thiếu so với KG giữ chỗ, hệ thống tự lập phiếu chuyển nội bộ đúng phần thiếu (NVL, KG — lô chọn khi xuất theo FEFO), gắn lệnh nguồn, vào thẳng Chờ xuất (sửa 30/10 — bỏ bước Kế hoạch gửi). Mọi yêu cầu chuyển kho (kể cả loại khác) do Kế hoạch lập, không phải Thủ kho. Thủ kho kho tổng xuất (kho xuất), Thủ kho điều phối nhận & quét (kho nhận). Sửa 20/10 (đợt 2 — offline): phiếu chuyển do nhà máy xuất làm chủ; nhà máy nhận ghi phiếu nhập + biên bản chênh lệch của mình, cloud chiếu SL đã nhận về phiếu của nhà máy xuất. Khác nhà máy: bản sao phiếu tới nhà máy nhận qua cloud trước khi xe chạy; nhà máy nhận mất mạng mà chưa có phiếu → hàng để bãi chờ (sau 10/11: nhận không phiếu). Cùng nhà máy: ~~đề nghị tự lập chưa được Kế hoạch gửi khi mất mạng → Thủ kho trưởng kho tổng xác nhận thẳng (kq)~~ bỏ 30/10 — phiếu theo lệnh vào thẳng Chờ xuất, không còn bước gửi / xác nhận. Chốt 30/10 (theo mockup): chuyển giữa 2 nhà máy đi qua yêu cầu chuyển `YCC-` — nhà máy nhận gửi yêu cầu (cách bù khi tạo lệnh, Cân đối NVL hoặc Kế hoạch thêm tay), hệ thống giữ số KG ở nhà máy nguồn tới hạn xuất (hạn xuất = ngày cần − thời gian đi − đệm); Kế hoạch nhà máy nguồn gom yêu cầu theo kho xuất → kho nhận → mã hàng, chọn các yêu cầu đi cùng đợt vận chuyển và lập phiếu — lập phiếu là chấp nhận, bỏ bước Thủ kho trưởng xác nhận / từ chối yêu cầu (bỏ d1); từ chối hoặc quá hạn xuất thì phần thiếu về Cân đối NVL của nhà máy nhận. Kho điều phối chỉ nhận chuyển nội bộ; liên nhà máy đi giữa kho tổng (NVL) hoặc kho BTP (thành phẩm). Kho xuất không lấy được hàng thì bấm Không thực hiện được (lý do bắt buộc) → phiếu Đã hủy: nội bộ theo lệnh → phần thiếu về Cân đối NVL; liên nhà máy → yêu cầu quay về Chờ lập phiếu. Liên nhà máy: khi kho xuất quét xuất, hệ thống tự sinh phiếu nhập loại chuyển kho ở nhà máy nhận (Chờ nhận hàng); quét nhận, thiếu / hư làm trên phiếu chuyển. Trạng thái yêu cầu chuyển: Chờ lập phiếu / Chờ xác nhận / Trên phiếu / Từ chối / Bị trả về / Quá hạn xuất / Đã rút. Trạng thái phiếu chuyển: Chờ xuất / Đang chuyển / Chờ xử lý hàng hư / Nhận thiếu / Chờ xác nhận thất lạc / Đã nhận / Thất lạc / Đã hủy. Màn Kho › Chuyển kho 3 tab: Yêu cầu chuyển liên nhà máy / Phiếu chuyển liên nhà máy / Phiếu chuyển nội bộ.

```quy-trinh
so: 16
mang: Kho
tu: QT13 + QT16
ten-ngan: Chuyển kho
ten: Quy trình Chuyển kho (cùng nhà máy / giữa 2 nhà máy)
ghi-chu: Gộp QT13 (nội bộ: kho tổng ↔ kho điều phối ↔ kho BTP) + QT16 (giữa 2 nhà máy). Chỉ chuyển khác nhà máy mới có bước vận chuyển và kiểm hàng đến. Sửa 16/10 (vòng đời lô hàng): bỏ trạng thái ĐANG CHUYỂN — hàng xuất đi nằm trên phiếu chuyển (sửa 24/10: không còn vị trí "trên xe"; tồn đang chuyển không thuộc kho nào), giữ nguyên trạng thái và lý do khóa, không tính tồn dùng được; chuyển được mọi trạng thái trừ HỦY. Nhận thiếu: chờ tìm 7 ngày rồi biên bản thất lạc, Thủ kho trưởng xác nhận → HỦY (chốt 17/10); nhận hư: chỉ các bao hư KHÓA, bao lành giữ trạng thái. Sửa 24/10: bỏ vị trí kệ, không còn thao tác dời vị trí trong cùng kho. Sửa 19/10 (đợt 4): NVL cho SX đi kho tổng → kho điều phối qua QT này. Khi tạo / phát lệnh mà kho điều phối thiếu so với KG giữ chỗ, hệ thống tự lập phiếu chuyển nội bộ đúng phần thiếu (NVL, KG — lô chọn khi xuất theo FEFO), gắn lệnh nguồn, vào thẳng Chờ xuất (sửa 30/10 — bỏ bước Kế hoạch gửi). Mọi yêu cầu chuyển kho (kể cả loại khác) do Kế hoạch lập, không phải Thủ kho. Thủ kho kho tổng xuất (kho xuất), Thủ kho điều phối nhận & quét (kho nhận). Sửa 20/10 (đợt 2 — offline): phiếu chuyển do nhà máy xuất làm chủ; nhà máy nhận ghi phiếu nhập + biên bản chênh lệch của mình, cloud chiếu SL đã nhận về phiếu của nhà máy xuất. Khác nhà máy: bản sao phiếu tới nhà máy nhận qua cloud trước khi xe chạy; nhà máy nhận mất mạng mà chưa có phiếu → hàng để bãi chờ (sau 10/11: nhận không phiếu). Cùng nhà máy: ~~đề nghị tự lập chưa được Kế hoạch gửi khi mất mạng → Thủ kho trưởng kho tổng xác nhận thẳng (kq)~~ bỏ 30/10 — phiếu theo lệnh vào thẳng Chờ xuất, không còn bước gửi / xác nhận. Chốt 30/10 (theo mockup): chuyển giữa 2 nhà máy đi qua yêu cầu chuyển `YCC-` — nhà máy nhận gửi yêu cầu (cách bù khi tạo lệnh, Cân đối NVL hoặc Kế hoạch thêm tay), hệ thống giữ số KG ở nhà máy nguồn tới hạn xuất (hạn xuất = ngày cần − thời gian đi − đệm); Kế hoạch nhà máy nguồn gom yêu cầu theo kho xuất → kho nhận → mã hàng, chọn các yêu cầu đi cùng đợt vận chuyển và lập phiếu — lập phiếu là chấp nhận, bỏ bước Thủ kho trưởng xác nhận / từ chối yêu cầu (bỏ d1); từ chối hoặc quá hạn xuất thì phần thiếu về Cân đối NVL của nhà máy nhận. Kho điều phối chỉ nhận chuyển nội bộ; liên nhà máy đi giữa kho tổng (NVL) hoặc kho BTP (thành phẩm). Kho xuất không lấy được hàng thì bấm Không thực hiện được (lý do bắt buộc) → phiếu Đã hủy: nội bộ theo lệnh → phần thiếu về Cân đối NVL; liên nhà máy → yêu cầu quay về Chờ lập phiếu. Liên nhà máy: khi kho xuất quét xuất, hệ thống tự sinh phiếu nhập loại chuyển kho ở nhà máy nhận (Chờ nhận hàng); quét nhận, thiếu / hư làm trên phiếu chuyển. Trạng thái yêu cầu chuyển: Chờ lập phiếu / Chờ xác nhận / Trên phiếu / Từ chối / Bị trả về / Quá hạn xuất / Đã rút. Trạng thái phiếu chuyển: Chờ xuất / Đang chuyển / Chờ xử lý hàng hư / Nhận thiếu / Chờ xác nhận thất lạc / Đã nhận / Thất lạc / Đã hủy. Màn Kho › Chuyển kho 3 tab: Yêu cầu chuyển liên nhà máy / Phiếu chuyển liên nhà máy / Phiếu chuyển nội bộ.
cot: Kế hoạch | Kho xuất | Thủ kho trưởng | Vận chuyển | Kho nhận | Hệ thống
s | 0 | 0 | S | Cần chuyển hàng giữa 2 kho
ya | 5 | 0 | Y | Từ QT19 (tạo / phát lệnh): kho điều phối thiếu so với KG giữ chỗ → hệ thống tự lập luôn phiếu chuyển nội bộ kho tổng → kho điều phối đúng phần thiếu (từng NVL, KG; lô chọn khi xuất theo FEFO), gắn lệnh nguồn → Chờ xuất; không qua bước Kế hoạch gửi, không qua xác nhận (30/10); đã có phiếu chưa xuất thì cập nhật SL, không lập trùng
y0 | 0 | 1 | T | Liên nhà máy: nhà máy nhận gửi yêu cầu chuyển YCC- (kho xuất, kho nhận, mã hàng, SL, ngày cần, lệnh liên quan, lý do) — từ cách bù khi tạo lệnh, Cân đối NVL (QT19 cb) hoặc Kế hoạch thêm tay; hệ thống giữ số KG ở nhà máy nguồn tới hạn xuất → Chờ lập phiếu; nhà máy nhận rút được yêu cầu chưa lên phiếu
yl | 0 | 2 | T | Kế hoạch nhà máy nguồn gom yêu cầu theo kho xuất → kho nhận → mã hàng, chọn các yêu cầu đi cùng đợt vận chuyển, chọn lô, lập phiếu chuyển — lập phiếu là chấp nhận, không có bước Thủ kho trưởng xác nhận (30/10); lập một phần thì phần còn lại thành yêu cầu mới (chờ lập phiếu hoặc từ chối); từ chối bắt buộc lý do; quá hạn xuất chưa lập phiếu → Quá hạn xuất, nhả KG đã giữ
yn | 0 | 3 | T | Nội bộ cùng nhà máy ngoài phiếu theo lệnh: Kế hoạch lập tay phiếu chuyển nội bộ (kho đi, kho đến, lô, SL; lô mọi trạng thái trừ HỦY, giữ nguyên trạng thái); yêu cầu chuyển nội bộ (nếu có) do Thủ kho điều phối lập phiếu
e0 | 0 | 4 | E | Từ chối / quá hạn / không thực hiện được → phần thiếu về Cân đối NVL của nhà máy nhận (QT19 cb)
r1 | 1 | 3 | R | QT15: Xuất kho — phiếu chuyển Chờ xuất, kho xuất lấy hàng theo lô (phiếu theo lệnh → FEFO trong kho tổng; thủ kho kho tổng)
kx | 1 | 4 | T | Không lấy được hàng: thủ kho kho xuất bấm Không thực hiện được (lý do bắt buộc: hàng thực tế không có / kho nhận hết chỗ / khác) → phiếu Đã hủy; nội bộ theo lệnh → phần thiếu về Cân đối NVL; liên nhà máy → yêu cầu quay về Chờ lập phiếu kèm lý do
g1 | 5 | 4 | Y | Phiếu chuyển (kho đi, kho đến, lô, SL, xe / người chuyển); ghi liên kết bao → phiếu chuyển khi quét xuất (bắt buộc, không ghi được thì chặn) → Đang chuyển; hàng nằm trên phiếu chuyển (tồn đang chuyển, không thuộc kho nào), giữ trạng thái + lý do khóa (khóa / hết hạn vẫn áp lên), không tính tồn dùng được ở cả 2 kho; liên nhà máy: tự sinh phiếu nhập loại chuyển kho ở nhà máy nhận (Chờ nhận hàng)
d2 | 5 | 5 | D | Khác nhà máy?
t1 | 3 | 6 | T | Chuyển hàng; truy vết chuyến xe
d3 | 4 | 7 | D | Hàng đã đến?
t2 | 0 | 8 | T | Kế hoạch xử lý nội bộ (trễ / thất lạc)
t3 | 4 | 9 | T | Kiểm hàng, quét QR, ký nhận (NVL cho SX: Thủ kho điều phối)
g3 | 0 | 10 | T | Thất lạc (xe không tới, hoặc hàng thiếu quá 7 ngày chưa tìm thấy): Kế hoạch lập biên bản (phiếu chuyển, lô, SL, chuyến xe, người chịu trách nhiệm) → Chờ xác nhận thất lạc
d4 | 4 | 10 | D | Khớp phiếu chuyển?
t4 | 2 | 11 | T | Biên bản chênh lệch. Thiếu: phiếu Nhận thiếu, giữ trên phiếu chuyển, Kế hoạch tìm 7 ngày (mặc định), tìm thấy thì quét nhận, quá hạn → thất lạc. Hư: phiếu Chờ xử lý hàng hư, quét từng bao hư → bao đó KHÓA (lý do hư khi nhận), bao lành giữ trạng thái, ảnh + lý do; Thủ kho trưởng chọn gửi QC (NVL → QT22, BTP / TP → QT23) hoặc hủy (QT18)
y1 | 5 | 12 | Y | Chuyển phần đã nhận từ phiếu chuyển vào kho nhận, giữ nguyên trạng thái; cập nhật tồn 2 kho trong 1 giao dịch → Đã nhận
e | 5 | 15 | E | Kết thúc
gx | 2 | 13 | D | Thủ kho trưởng\nxác nhận thất lạc?
gy | 5 | 14 | Y | Phần thất lạc → HỦY (trạng thái cuối), phiếu Thất lạc, ghi giá trị hàng thất lạc (không hạch toán); bồi thường (nếu có) xử lý ngoài hệ thống, ghi số tiền
---
s -> y0 : Giữa 2 nhà máy
s -> yn : Cùng nhà máy
ya -> r1 : Chờ xuất
y0 -> yl
yl -> r1 : Lập phiếu (Chờ xuất)
yl -> e0 : Từ chối / quá hạn
yn -> r1
r1 -> g1
r1 -> kx : Không lấy được hàng
kx -> e0 : Nội bộ theo lệnh
kx -> yl : Liên nhà máy — yêu cầu về Chờ lập phiếu
g1 -> d2
d2 -> t1 : Có
d2 -> t3 : Không
t1 -> d3
d3 -> t2 : Không
t2 -> d3 : Về muộn
t2 -> g3 : Thất lạc
d3 -> t3 : Có
t3 -> d4
d4 -> t4 : Không
t4 -> y1 : Phần nhận được
t4 -> g3 : Thiếu quá 7 ngày
d4 -> y1 : Có
y1 -> e
g3 -> gx
gx -> gy : Xác nhận
gx -> t2 : Không → tìm tiếp
gy -> e
```

## QT17. Quy trình Kiểm kho

Hai nhánh: kiểm toàn kho định kỳ (trên) — khóa nhập / xuất cả kho; kiểm điểm (dưới) — khi lệch tồn phát sinh giữa 2 đợt (QT15 quét hết hàng, QT19 tồn âm sau đồng bộ, QT25 cân bằng khối lượng lệch), chỉ khóa đúng lô bị lệch trong kho đó, phần còn lại của kho chạy bình thường. Bản gốc có 2 điểm End cho nhánh định kỳ → gộp còn 1. Sửa 16/10 (vòng đời lô hàng): "khóa" khi kiểm kho là cờ riêng "đang kiểm kê" trên cả kho hoặc một lô trong kho, không đổi trạng thái lô; kiểm xong chỉ gỡ cờ. Điều chỉnh tăng (hủy nhầm, hàng tìm lại) vào KHÓA chờ QC. Sửa 20/10 (đợt 2 — offline): cả hai nhánh chạy tại máy chủ nhà máy; thêm nguồn kiểm điểm "khởi tạo lại máy chủ nhà máy" (QT19 c3).

```quy-trinh
so: 17
mang: Kho
tu: QT10
ten-ngan: Kiểm kho
ten: Quy trình Kiểm kho
ghi-chu: Hai nhánh: kiểm toàn kho định kỳ (trên) — khóa nhập / xuất cả kho; kiểm điểm (dưới) — khi lệch tồn phát sinh giữa 2 đợt (QT15 quét hết hàng, QT19 tồn âm sau đồng bộ, QT25 cân bằng khối lượng lệch), chỉ khóa đúng lô bị lệch trong kho đó, phần còn lại của kho chạy bình thường. Bản gốc có 2 điểm End cho nhánh định kỳ → gộp còn 1. Sửa 16/10 (vòng đời lô hàng): "khóa" khi kiểm kho là cờ riêng "đang kiểm kê" trên cả kho hoặc một lô trong kho, không đổi trạng thái lô; kiểm xong chỉ gỡ cờ. Điều chỉnh tăng (hủy nhầm, hàng tìm lại) vào KHÓA chờ QC. Sửa 20/10 (đợt 2 — offline): cả hai nhánh chạy tại máy chủ nhà máy; thêm nguồn kiểm điểm "khởi tạo lại máy chủ nhà máy" (QT19 c3).
cot: Thủ kho trưởng | Kho | Các bộ phận | Hệ thống
s | 0 | 0 | S | Bắt đầu
d1 | 0 | 1 | D | Có lệnh kiểm kho?
e0 | 2 | 2 | E | Sản xuất bình thường
t1 | 2 | 3 | T | Nhận thông báo kiểm kho
y1 | 3 | 4 | Y | Kiểm toàn kho: gắn cờ "đang kiểm kê" cả kho (chặn nhập xuất, không đổi trạng thái lô), chốt số liệu tại thời điểm
t2 | 1 | 5 | T | Đếm: số lượng, đúng hàng, lô & HSD, tình trạng
d2 | 1 | 6 | D | Khớp hệ thống?
t3 | 1 | 7 | T | Ghi chênh lệch kèm lý do
d3 | 0 | 8 | D | Duyệt điều chỉnh?
y2 | 3 | 9 | Y | Điều chỉnh tồn, ghi nhật ký; phần tăng (hủy nhầm, hàng tìm lại) vào KHÓA chờ QC, lô cũ vẫn HỦY trong nhật ký
y3 | 3 | 10 | Y | Gỡ cờ đang kiểm kê (trạng thái lô giữ nguyên)
t4 | 1 | 11 | T | In báo cáo gửi các bên
e | 1 | 12 | E | Kết thúc
s2 | 3 | 13 | S | Lệch tồn phát sinh: QT15 quét hết hàng / QT19 tồn âm sau đồng bộ / QT25 cân bằng khối lượng lệch / QT19 c3 khởi tạo lại máy chủ nhà máy
p1 | 3 | 14 | Y | Kiểm điểm: gắn cờ "đang kiểm kê" chỉ ở lô bị lệch trong kho đó (không đổi trạng thái lô; phần còn lại của kho nhập xuất bình thường); tạo phiếu kiểm điểm
p2 | 1 | 15 | T | Đếm lại lô: số lượng, lô & HSD, tình trạng
p3 | 1 | 16 | D | Khớp hệ thống?
p6 | 1 | 17 | T | Ghi chênh lệch kèm lý do
p4 | 0 | 18 | D | Duyệt điều chỉnh?
p5 | 3 | 19 | Y | Điều chỉnh tồn (nếu lệch), ghi nhật ký; gỡ cờ đang kiểm kê (trạng thái lô giữ nguyên); báo bên gọi (QT15 / QT19 / QT25)
e2 | 3 | 20 | E | Kết thúc
---
s -> d1
d1 -> e0 : Không
d1 -> t1 : Có
t1 -> y1
y1 -> t2
t2 -> d2
d2 -> y3 : Khớp
d2 -> t3 : Lệch
t3 -> d3
d3 -> t2 : Không → kiểm lại
d3 -> y2 : Có
y2 -> y3
y3 -> t4
t4 -> e
s2 -> p1
p1 -> p2
p2 -> p3
p3 -> p5 : Khớp
p3 -> p6 : Lệch
p6 -> p4
p4 -> p2 : Không → đếm lại
p4 -> p5 : Có
p5 -> e2
```

## QT18. Quy trình Hủy hàng trong kho

Bản gốc có 2 điểm Begin (ô thứ 2 phải là End). Bỏ bước "khóa kho" toàn bộ: chỉ cần khóa lô cần hủy. Bổ sung 16/10: hệ thống quét HSD hằng ngày; lô hết hạn tự KHÓA, chặn xuất và tạo đề nghị hủy, đi tiếp luồng hủy như cũ. Sửa 24/10 (đợt 9): bỏ cảnh báo cận date (3 mức báo trước, cờ CẬN DATE, bước Kế hoạch / Sales ưu tiên dùng / bán) — lô dùng cho SX đã có ngưỡng hạn tối thiểu ở QT15 / QT20, FEFO tự lấy lô gần hết hạn trước. Sửa 16/10 (vòng đời lô hàng): tạo phiếu hủy là tự KHÓA phần trên phiếu (lý do chờ hủy); lô hết hạn không được từ chối hủy, chỉ dời ngày; lô chờ hủy bị từ chối thì về trạng thái trước hoặc gửi QC. HỦY là trạng thái cuối. Sửa 19/10: Kế toán chỉ ghi giá trị hàng hủy, không ghi tổn thất theo nghĩa kế toán. Sửa 20/10 (đợt 2 — offline): quét HSD (s2, ya, yc) và toàn bộ phiếu hủy chạy tại máy chủ nhà máy — lô hết hạn khi mất mạng vẫn bị khóa ngay; cloud chỉ tính lại để hiển thị; Kế toán t5 làm khi có mạng.

```quy-trinh
so: 18
mang: Kho
tu: QT19
ten-ngan: Hủy hàng
ten: Quy trình Hủy hàng trong kho
ghi-chu: Bản gốc có 2 điểm Begin (ô thứ 2 phải là End). Bỏ bước "khóa kho" toàn bộ: chỉ cần khóa lô cần hủy. Bổ sung 16/10: hệ thống quét HSD hằng ngày; lô hết hạn tự KHÓA, chặn xuất và tạo đề nghị hủy, đi tiếp luồng hủy như cũ. Sửa 24/10 (đợt 9): bỏ cảnh báo cận date (3 mức báo trước, cờ CẬN DATE, bước Kế hoạch / Sales ưu tiên dùng / bán) — lô dùng cho SX đã có ngưỡng hạn tối thiểu ở QT15 / QT20, FEFO tự lấy lô gần hết hạn trước. Sửa 16/10 (vòng đời lô hàng): tạo phiếu hủy là tự KHÓA phần trên phiếu (lý do chờ hủy); lô hết hạn không được từ chối hủy, chỉ dời ngày; lô chờ hủy bị từ chối thì về trạng thái trước hoặc gửi QC. HỦY là trạng thái cuối. Sửa 19/10: Kế toán chỉ ghi giá trị hàng hủy, không ghi tổn thất theo nghĩa kế toán. Sửa 20/10 (đợt 2 — offline): quét HSD (s2, ya, yc) và toàn bộ phiếu hủy chạy tại máy chủ nhà máy — lô hết hạn khi mất mạng vẫn bị khóa ngay; cloud chỉ tính lại để hiển thị; Kế toán t5 làm khi có mạng.
cot: Thủ kho trưởng | Kho | QC | Kế toán | Hệ thống
s | 1 | 0 | S | Kiểm tra định kỳ / phát hiện hàng lỗi
s2 | 4 | 0 | S | Hằng ngày: hệ thống tự quét HSD
t1 | 1 | 1 | T | Kiểm tra, tạo phiếu kiểm kho
c0 | 4 | 2 | Y | ⚙ MẶC ĐỊNH (cấu hình lại được): lô hết hạn chưa hủy quá 30 ngày thì nhắc Thủ kho trưởng. Không còn cảnh báo cận date (bỏ 24/10 đợt 9)
ya | 4 | 1 | Y | Quét HSD tồn của nhà máy (tại máy chủ nhà máy, kể cả khi mất mạng); lô đến hạn → khóa
d1 | 1 | 2 | D | Hết hạn / không đạt?
e0 | 0 | 3 | E | Tiếp tục nhập xuất, sản xuất
yc | 4 | 6 | Y | Tại máy chủ nhà máy — Hết hạn: tự KHÓA cả lô, lý do hết hạn, chặn xuất (QT15 / QT19 / QT20); lô CHỜ KIỂM → hủy yêu cầu QC đang mở; lô KHÔNG ĐẠT giữ nguyên, ghi chú đã hết hạn; tạo đề nghị hủy
t2 | 1 | 7 | T | Tạo phiếu hủy, gửi Thủ kho trưởng; hệ thống tự KHÓA phần trên phiếu (lý do chờ hủy)
d2 | 0 | 8 | D | Xác nhận?
t3 | 2 | 9 | T | Hủy mẫu lưu liên quan
t4 | 1 | 10 | T | Thực hiện hủy, lập biên bản
xr | 0 | 9 | T | Từ chối (bắt buộc lý do): lô hết hạn → không được từ chối, chỉ dời ngày hủy; lô chờ hủy → không lỗi: về trạng thái trước (ĐẠT) / còn nghi ngờ: gửi QC (lý do → khoanh vùng)
xe | 0 | 10 | E | Kết thúc (về trạng thái trước / gửi QC / chờ đợt hủy sau)
y1 | 4 | 11 | Y | Cập nhật tồn, lô → HỦY (trạng thái cuối, không mở lại)
t5 | 3 | 12 | T | Ghi giá trị hàng hủy vào phiếu hủy (chỉ ghi nhận, không hạch toán)
e | 3 | 13 | E | Kết thúc
---
s -> t1
t1 -> d1
d1 -> e0 : Không
d1 -> t2 : Có
s2 -> ya
c0 -> ya :  : n
ya -> yc : Đến hạn
yc -> t2
t2 -> d2
d2 -> xr : Không
xr -> xe
d2 -> t3 : Có
t3 -> t4
t4 -> y1
y1 -> t5
t5 -> e
```


# Mảng 5 · Sản xuất

## QT19. Quy trình Tạo và Phát lệnh sản xuất

Điều kiện tạo LSX (sửa 24/10 đợt 8 — 8 mục theo thứ tự): khu sản xuất (loại lệnh HH / BTP theo khu) · nhu cầu đơn hàng (1 mã SP; các dòng đơn đã chốt cùng SP và số lon phân bổ, mỗi dòng ≤ số lon còn lại) · công thức hiệu lực · thời gian nhận đơn & dự kiến xong · % hao hụt (05/11) · số mẻ & khối lượng mẻ (≤ mức tối đa của khu) · ~~giấy tờ xuất xứ NVL~~ (bỏ 05/11) · tồn NVL khả dụng · dàn silo. Nhu cầu (đợt 8): ~~chỉ sản xuất theo đơn, không có lệnh tồn kho~~ (sửa 04/11: có lệnh sản xuất tồn kho, không theo đơn); mỗi lệnh 1 mã SP; mỗi dòng đơn đã chốt cần 1 lệnh HH và 1 lệnh BTP cùng mã SP; còn lại của dòng = SL dòng − số lon phân bổ ở các lệnh chưa hủy cùng loại; một lệnh gộp được nhiều dòng, một dòng tách được ra nhiều lệnh; Kế hoạch làm từ tab Chờ lên lệnh. Dàn silo: hệ thống gợi ý xếp NVL → silo của khu theo gán cứng và sức chứa, Kế hoạch kéo thả chỉnh; số NVL của công thức ≤ số silo đang hoạt động, đúng gán cứng, không dùng silo bảo trì; phương án chốt khi tạo lệnh, kiểm lại khi phát (silo chuyển bảo trì / ngừng dùng → báo Kế hoạch xếp lại, chặn phát tới khi xếp lại). Mỗi khu một hàng đợi phát lệnh: Kế hoạch đổi thứ tự ưu tiên, phát lệnh đầu hàng. Trạng thái lệnh: MỚI TẠO (tạo xong, đã giữ chỗ KG, vào hàng đợi) → CHỜ PHÁT (chỉ khi đã phát mà server nhà máy không nhận) → ĐÃ NHẬN → ĐANG CHẠY → HOÀN THÀNH; ĐÃ HỦY. Không có Nháp, không xóa lệnh; hủy lệnh chưa chạy (Mới tạo / Chờ phát / Đã nhận) bắt buộc lý do, giải phóng giữ chỗ. Sửa 19/10 (đợt 3): chỉ sửa lệnh Mới tạo; lệnh đã phát chỉ hủy (nhà máy xác nhận chưa chạy mẻ) rồi tạo lại; lệnh đang chạy chỉ kết thúc sớm (hoặc thêm mẻ bù); hàng đợi = thứ tự chạy ở nhà máy, lệnh Chờ phát giữ vị trí. Lệnh BTP có kế hoạch nhãn hiệu nhiều dòng (SP, số lô in trên lon nếu đã biết, số lon), lấy từ các dòng đơn cùng công thức. Sửa 16/10: giữ chỗ NVL theo KG, không gắn lô — lô cụ thể chọn lúc xuất kho (QT15, FEFO). Bổ sung 16/10: xử lý mất kết nối cloud ↔ local gắn vào luồng lệnh — phát lệnh không tới thì lệnh CHỜ PHÁT, cloud gửi lại; đang chạy lệnh mà mất kết nối thì server nhà máy chạy tiếp lệnh, ghi sự kiện vào hàng đợi local, có lại kết nối thì đồng bộ theo thứ tự, bỏ trùng theo mã sự kiện, xử lý xung đột. Sửa 19/10 (đợt 4): NVL cho SX đi qua kho điều phối (kho tổng → chuyển kho → kho điều phối → xuất cho khu, QT15). Sau khi giữ chỗ (lúc tạo) và lúc phát, hệ thống so tồn ĐẠT, còn hạn ở kho điều phối với KG giữ chỗ của lệnh; thiếu thì tự lập phiếu chuyển nội bộ kho tổng → kho điều phối đúng phần thiếu, vào thẳng Chờ xuất (sửa 30/10 — bỏ bước Kế hoạch gửi; QT16). Lệnh vẫn vào hàng đợi, nhưng chỉ phát được khi kho điều phối đủ. Thủ kho kho tổng xuất, Thủ kho điều phối nhận & quét. Sửa 20/10 (đợt 2 — offline): phát lệnh, hủy lệnh, kết thúc sớm đi qua kênh lệnh từ trung tâm (kl) cùng với hủy mẻ, khóa lô, khóa tài khoản, silo bảo trì — nhà máy áp dụng trong 1 giao dịch, kiểm điều kiện thực tế, trả ĐÃ ÁP DỤNG / TỪ CHỐI. Máy chủ nhà máy là chủ tồn & trạng thái lô của mình (không còn bản sao trạng thái lô); mọi thay đổi trên dữ liệu nhà máy chủ (kho, QC, xưởng) luôn ghi hàng đợi gửi lên, không chỉ sự kiện của lệnh. Ngoại tuyến không giới hạn thời gian; Kế hoạch ở văn phòng, lệnh chỉ tạo trên cloud. Thêm nhánh cloud mất / khôi phục từ sao lưu và khởi tạo lại máy chủ nhà máy. Chốt 30/10 – 04/11 (theo mockup): có lệnh sản xuất tồn kho — Kế hoạch tạo lệnh không gắn đơn (chọn SP, số mẻ / số lon), điều kiện "nhu cầu đơn hàng" thay bằng kế hoạch sản xuất tồn kho (04/11). Lệnh BTP thêm điều kiện chứng từ: SP có hồ sơ công bố còn hiệu lực và mẫu nhãn đã duyệt (QT02 — 04/11); thiếu thì bổ sung ở danh mục Sản phẩm. Tồn NVL thiếu: Kế hoạch chọn cách bù ngay khi tạo lệnh (mặc định Mua → Hàng đợi mua QT12; chuyển kho liên nhà máy → yêu cầu YCC- QT16; lùi ngày); phần thiếu phát sinh sau (Mua hàng trả về, kho xuất không thực hiện được, yêu cầu chuyển bị từ chối / quá hạn, tồn giảm sau khi giữ chỗ) vào màn Cân đối NVL để Kế hoạch chọn lại (cb). % hao hụt (05/11): 0–50%, để trống = 0; khối lượng phải sản xuất = khối lượng cần × (1 + %), số mẻ / KL mẻ tự tính theo số này. Hủy lệnh: Mới tạo / Chờ phát (nhà máy chưa nhận) hủy ngay; Đã nhận gửi lệnh hủy xuống nhà máy; nhà máy đang mất mạng thì chặn, báo "chưa hủy được, thử lại khi có kết nối" (chốt 04/11, thay "lệnh hủy nằm Chờ gửi").

```quy-trinh
so: 19
mang: Sản xuất
tu: QT11
ten-ngan: Tạo & phát lệnh
ten: Quy trình Tạo và Phát lệnh sản xuất
ghi-chu: Điều kiện tạo LSX (sửa 24/10 đợt 8 — 8 mục theo thứ tự): khu sản xuất (loại lệnh HH / BTP theo khu) · nhu cầu đơn hàng (1 mã SP; các dòng đơn đã chốt cùng SP và số lon phân bổ, mỗi dòng ≤ số lon còn lại) · công thức hiệu lực · thời gian nhận đơn & dự kiến xong · % hao hụt (05/11) · số mẻ & khối lượng mẻ (≤ mức tối đa của khu) · ~~giấy tờ xuất xứ NVL~~ (bỏ 05/11) · tồn NVL khả dụng · dàn silo. Nhu cầu (đợt 8): ~~chỉ sản xuất theo đơn, không có lệnh tồn kho~~ (sửa 04/11: có lệnh sản xuất tồn kho, không theo đơn); mỗi lệnh 1 mã SP; mỗi dòng đơn đã chốt cần 1 lệnh HH và 1 lệnh BTP cùng mã SP; còn lại của dòng = SL dòng − số lon phân bổ ở các lệnh chưa hủy cùng loại; một lệnh gộp được nhiều dòng, một dòng tách được ra nhiều lệnh; Kế hoạch làm từ tab Chờ lên lệnh. Dàn silo: hệ thống gợi ý xếp NVL → silo của khu theo gán cứng và sức chứa, Kế hoạch kéo thả chỉnh; số NVL của công thức ≤ số silo đang hoạt động, đúng gán cứng, không dùng silo bảo trì; phương án chốt khi tạo lệnh, kiểm lại khi phát (silo chuyển bảo trì / ngừng dùng → báo Kế hoạch xếp lại, chặn phát tới khi xếp lại). Mỗi khu một hàng đợi phát lệnh: Kế hoạch đổi thứ tự ưu tiên, phát lệnh đầu hàng. Trạng thái lệnh: MỚI TẠO (tạo xong, đã giữ chỗ KG, vào hàng đợi) → CHỜ PHÁT (chỉ khi đã phát mà server nhà máy không nhận) → ĐÃ NHẬN → ĐANG CHẠY → HOÀN THÀNH; ĐÃ HỦY. Không có Nháp, không xóa lệnh; hủy lệnh chưa chạy (Mới tạo / Chờ phát / Đã nhận) bắt buộc lý do, giải phóng giữ chỗ. Sửa 19/10 (đợt 3): chỉ sửa lệnh Mới tạo; lệnh đã phát chỉ hủy (nhà máy xác nhận chưa chạy mẻ) rồi tạo lại; lệnh đang chạy chỉ kết thúc sớm (hoặc thêm mẻ bù); hàng đợi = thứ tự chạy ở nhà máy, lệnh Chờ phát giữ vị trí. Lệnh BTP có kế hoạch nhãn hiệu nhiều dòng (SP, số lô in trên lon nếu đã biết, số lon), lấy từ các dòng đơn cùng công thức. Sửa 16/10: giữ chỗ NVL theo KG, không gắn lô — lô cụ thể chọn lúc xuất kho (QT15, FEFO). Bổ sung 16/10: xử lý mất kết nối cloud ↔ local gắn vào luồng lệnh — phát lệnh không tới thì lệnh CHỜ PHÁT, cloud gửi lại; đang chạy lệnh mà mất kết nối thì server nhà máy chạy tiếp lệnh, ghi sự kiện vào hàng đợi local, có lại kết nối thì đồng bộ theo thứ tự, bỏ trùng theo mã sự kiện, xử lý xung đột. Sửa 19/10 (đợt 4): NVL cho SX đi qua kho điều phối (kho tổng → chuyển kho → kho điều phối → xuất cho khu, QT15). Sau khi giữ chỗ (lúc tạo) và lúc phát, hệ thống so tồn ĐẠT, còn hạn ở kho điều phối với KG giữ chỗ của lệnh; thiếu thì tự lập phiếu chuyển nội bộ kho tổng → kho điều phối đúng phần thiếu, vào thẳng Chờ xuất (sửa 30/10 — bỏ bước Kế hoạch gửi; QT16). Lệnh vẫn vào hàng đợi, nhưng chỉ phát được khi kho điều phối đủ. Thủ kho kho tổng xuất, Thủ kho điều phối nhận & quét. Sửa 20/10 (đợt 2 — offline): phát lệnh, hủy lệnh, kết thúc sớm đi qua kênh lệnh từ trung tâm (kl) cùng với hủy mẻ, khóa lô, khóa tài khoản, silo bảo trì — nhà máy áp dụng trong 1 giao dịch, kiểm điều kiện thực tế, trả ĐÃ ÁP DỤNG / TỪ CHỐI. Máy chủ nhà máy là chủ tồn & trạng thái lô của mình (không còn bản sao trạng thái lô); mọi thay đổi trên dữ liệu nhà máy chủ (kho, QC, xưởng) luôn ghi hàng đợi gửi lên, không chỉ sự kiện của lệnh. Ngoại tuyến không giới hạn thời gian; Kế hoạch ở văn phòng, lệnh chỉ tạo trên cloud. Thêm nhánh cloud mất / khôi phục từ sao lưu và khởi tạo lại máy chủ nhà máy. Chốt 30/10 – 04/11 (theo mockup): có lệnh sản xuất tồn kho — Kế hoạch tạo lệnh không gắn đơn (chọn SP, số mẻ / số lon), điều kiện "nhu cầu đơn hàng" thay bằng kế hoạch sản xuất tồn kho (04/11). Lệnh BTP thêm điều kiện chứng từ: SP có hồ sơ công bố còn hiệu lực và mẫu nhãn đã duyệt (QT02 — 04/11); thiếu thì bổ sung ở danh mục Sản phẩm. Tồn NVL thiếu: Kế hoạch chọn cách bù ngay khi tạo lệnh (mặc định Mua → Hàng đợi mua QT12; chuyển kho liên nhà máy → yêu cầu YCC- QT16; lùi ngày); phần thiếu phát sinh sau (Mua hàng trả về, kho xuất không thực hiện được, yêu cầu chuyển bị từ chối / quá hạn, tồn giảm sau khi giữ chỗ) vào màn Cân đối NVL để Kế hoạch chọn lại (cb). % hao hụt (05/11): 0–50%, để trống = 0; khối lượng phải sản xuất = khối lượng cần × (1 + %), số mẻ / KL mẻ tự tính theo số này. Hủy lệnh: Mới tạo / Chờ phát (nhà máy chưa nhận) hủy ngay; Đã nhận gửi lệnh hủy xuống nhà máy; nhà máy đang mất mạng thì chặn, báo "chưa hủy được, thử lại khi có kết nối" (chốt 04/11, thay "lệnh hủy nằm Chờ gửi").
cot: Kế hoạch | Hệ thống (cloud) | Kho điều phối | Server nhà máy / PC C#
s | 0 | 0 | S | Dòng đơn đã chốt còn số lon chưa lên lệnh (QT05 yc); hoặc cần sản xuất tồn kho, không theo đơn (chốt 04/11)
nc | 1 | 0 | Y | Tab Chờ lên lệnh: dòng đơn gom theo mã SP, tách lệnh HH / BTP; mỗi dòng hiện đặt · đã lên lệnh · còn lại · hạn lên lệnh (hạn giao − 14 ngày ⚙)
nh | 1 | 1 | Y | Mỗi sáng 07:00: dòng chưa lên lệnh đủ mà quá hạn lên lệnh → tô đỏ, còn ≤ 5 ngày → tô vàng; báo Kế hoạch ở Việc cần làm
t1 | 0 | 1 | T | Kế hoạch chọn mã SP, tick dòng đơn, sửa số lon → Lên lệnh (lệnh tồn kho: chọn SP, số mẻ / số lon, không gắn đơn — 04/11); form điền sẵn, nhập theo thứ tự: khu sản xuất (loại lệnh theo khu) · nhu cầu (SP, dòng đơn, số lon — hoặc kế hoạch sản xuất tồn kho) · công thức hiệu lực (QT03) · thời gian nhận đơn & dự kiến xong · % hao hụt (05/11) · số mẻ & khối lượng mẻ · dàn silo (tồn NVL: hệ thống chỉ kiểm, thiếu vẫn tạo được — 24/10 đợt 12)
tb | 0 | 2 | T | Lệnh BTP: kế hoạch nhãn hiệu của 1 mã SP — số lô in trên lon (nếu đã biết), số lon = tổng phân bổ, ghi các dòng đơn phục vụ; SP phải có hồ sơ công bố còn hiệu lực và mẫu nhãn đã duyệt (QT02 — 04/11)
ys | 1 | 2 | Y | Gợi ý phương án dàn silo: xếp từng NVL của công thức vào silo đang hoạt động của khu theo gán cứng, rồi theo sức chứa
tk | 0 | 3 | T | Kế hoạch kéo thả chỉnh phương án silo
d1 | 1 | 4 | D | Đủ điều kiện tạo?\n(số lon mỗi dòng ≤ còn lại; KL mẻ ≤ tối đa của khu; số NVL ≤ silo\nhoạt động, đúng gán cứng, không silo\nbảo trì; lệnh BTP: hồ sơ công bố\nhiệu lực, mẫu nhãn đã duyệt\n— tồn NVL không chặn tạo)
t2 | 0 | 5 | T | Bổ sung / sửa, hoặc từ chối kèm lý do (không lưu nháp)
y1 | 1 | 5 | Y | Tạo lệnh → MỚI TẠO; ghi phân bổ dòng đơn → lệnh (trừ vào còn lại ở tab Chờ lên lệnh); chốt phương án silo; vào cuối hàng đợi phát lệnh của khu
dt | 1 | 6 | D | Tồn NVL khả dụng của nhà máy\nđủ cho lệnh? (lô ĐẠT, hạn ≥\nngưỡng SX, trừ phần đã giữ)
g1 | 1 | 7 | Y | Đủ → giữ chỗ NVL theo KG cho lệnh: KL từng NVL = định mức × số mẻ; không gắn lô (lô chọn khi xuất, QT15). Tồn khả dụng = KL lô ĐẠT, hạn còn ≥ ngưỡng tối thiểu cho SX − KL đã giữ
dc | 1 | 8 | D | Kho điều phối đủ NVL\nso với KG giữ chỗ?
yd | 1 | 9 | Y | Tự lập phiếu chuyển nội bộ kho tổng → kho điều phối đúng phần thiếu (từng NVL, KG; lô chọn khi xuất theo FEFO), gắn lệnh nguồn → Chờ xuất (QT16 ya); hiện trong màn Lệnh SX; không còn bước Kế hoạch gửi (bỏ tg — 30/10). Đã có phiếu chưa xuất thì cập nhật SL, không lập trùng
ym | 2 | 9 | Y | Thiếu → lệnh Mới tạo · Chờ NVL: KHÔNG giữ chỗ, KHÔNG phát được (24/10 đợt 12); phần thiếu đi theo cách bù Kế hoạch chọn (cb)
rm | 3 | 9 | R | QT12: Mua NVL (Hàng đợi mua) hoặc QT16: yêu cầu chuyển liên nhà máy YCC- — hàng về kho tổng (QT14) rồi chuyển sang kho điều phối
cb | 0 | 8 | T | Chọn cách bù phần thiếu (mặc định Mua): Mua → Hàng đợi mua (QT12); chuyển kho liên nhà máy → yêu cầu YCC- (QT16); lùi ngày. Phần thiếu phát sinh sau (Mua hàng trả về, kho xuất không thực hiện được, yêu cầu chuyển bị từ chối / quá hạn, tồn giảm sau khi giữ chỗ) vào màn Cân đối NVL để Kế hoạch chọn lại (chốt 04/11 theo mockup)
kr | 0 | 10 | T | Hàng về (nhập kho tổng hoặc chuyển về kho điều phối): Kế hoạch bấm "Kiểm tra lại" trên màn Lệnh SX — hệ thống so lại tồn với KG giữ chỗ (không cần thủ kho xác nhận soạn NVL)
r1 | 2 | 10 | R | QT16: Chuyển kho tổng → kho điều phối — thủ kho kho tổng xuất, Thủ kho điều phối nhận & quét; kho tổng không lấy được hàng → phiếu Đã hủy, phần thiếu về Cân đối NVL (cb); phiếu xuất SX tự lập khi lệnh phát sang khu (QT20 yp)
q1 | 0 | 11 | T | Hàng đợi phát lệnh của khu = thứ tự chạy ở nhà máy: Kế hoạch đổi thứ tự ưu tiên, chỉ phát lệnh đầu hàng (lệnh Chờ phát giữ vị trí, lệnh sau chờ)
yx | 1 | 12 | D | Kiểm lại khi phát:\nphương án silo còn hợp lệ, KL mẻ\n≤ mức tối đa hiện tại của khu?
xs | 0 | 13 | T | Silo bảo trì / ngừng dùng hoặc KL mẻ vượt mức mới: hệ thống báo, Kế hoạch xếp lại silo / sửa lệnh (chặn phát tới khi xong)
d2 | 1 | 13 | D | Lúc phát: kho điều phối\nđủ NVL so với KG giữ chỗ?
y2 | 1 | 14 | Y | Phát lệnh đầu hàng: lập lệnh PHÁT LỆNH gửi xuống máy chủ nhà máy qua kênh lệnh từ trung tâm (một kênh cho mọi tác động của cloud lên nhà máy: phát / hủy / kết thúc sớm lệnh, hủy mẻ + mẻ bù, khóa / mở khóa lô, khóa tài khoản, silo bảo trì, đổi loại khu, giảm KL mẻ, yêu cầu xuất, phiếu chuyển nội bộ theo lệnh)
dp | 1 | 15 | D | Máy chủ nhà máy\nxác nhận đã nhận?
kp | 1 | 16 | Y | Lệnh → CHỜ PHÁT, giữ vị trí trong hàng đợi (lệnh sau chờ); lệnh phát nằm Chờ gửi, tự gửi lại khi có kết nối; quá 10 phút (mặc định) báo Kế hoạch trên Lệnh SX, Việc cần làm
y3 | 3 | 16 | Y | Lưu tại máy chủ nhà máy: lệnh, công thức, phương án silo, kế hoạch nhãn hiệu; kiểm lô NVL trên TỒN THẬT của nhà máy (máy chủ nhà máy là chủ tồn & trạng thái lô kho mình — không còn bản sao trạng thái lô); lệnh → ĐÃ NHẬN, trả xác nhận lên cloud
y4 | 3 | 17 | Y | Tự kiểm điều kiện xuống PC xưởng (silo không bảo trì, lệnh không bị hủy — QT20 d1); đủ thì phát sang khu: hiển thị khu điều khiển, gửi PC C#, đồng thời tự lập phiếu xuất SX từ kho điều phối cho khu và phiếu chuyển nội bộ cho phần kho điều phối còn thiếu (QT15, QT20 yp — 24/10 đợt 10); mẻ đầu chạy → ĐANG CHẠY (QT20, QT21); chạy hết mẻ và mọi silo xả sạch → HOÀN THÀNH; không đạt → báo Kế hoạch lý do (việc được giao "Lệnh chưa phát sang khu được" ở Việc cần làm, Lệnh SX)
k1 | 3 | 18 | D | Trong lúc chạy lệnh:\nmất kết nối cloud\nquá 30 giây?
k2 | 3 | 19 | Y | Ngoại tuyến, KHÔNG giới hạn thời gian: chạy tiếp lệnh đang chạy và lệnh đã nhận tới hết; lệnh mới nằm CHỜ PHÁT trên cloud. Kho (QT14–QT18, QT04), QC (QT22–QT24), PC xưởng (QT20, QT21), Đăng nhập (QT01), Việc cần làm chạy đủ tại máy chủ nhà máy; chip "mất kết nối từ HH:MM · N thao tác chờ gửi" trên Lệnh SX, Theo dõi mẻ, Việc cần làm tại nhà máy
k3 | 3 | 20 | Y | Mọi thay đổi trên dữ liệu nhà máy chủ (tồn, lô, bao / thùng, chứng từ kho, QC, mẻ, nạp / xả silo, chiết rót, phiên đăng nhập, nhật ký) ghi vào hàng đợi gửi lên TRONG CÙNG GIAO DỊCH — kể cả khi đang có kết nối (chỉ một đường đồng bộ); mỗi sự kiện có mã duy nhất, số thứ tự theo nhà máy, nội dung là bản ghi sau thay đổi
k4 | 3 | 21 | Y | Kiểm lô khi quét trên tồn thật của nhà máy; lô hết hạn do máy chủ nhà máy tự KHÓA (QT18 yc chạy tại nhà máy); mã mẻ / bao / thùng / chứng từ kho / QC sinh tại nhà máy với tiền tố nhà máy. Lệnh từ trung tâm chưa tới (khóa lô thu hồi, hủy lệnh, hủy mẻ, khóa tài khoản) thì nhà máy chưa biết — xử lý khi có mạng (kl, kx)
kc | 0 | 21 | Y | Không cho tạo lệnh ở máy chủ nhà máy — Kế hoạch ở văn phòng trung tâm, lệnh chỉ tạo trên cloud; nhà máy mất mạng lâu thì chạy hết lệnh đã nhận rồi chờ (chốt 20/10). ⚙ MẶC ĐỊNH (cấu hình lại được): phát lệnh không tới quá 10 phút báo Kế hoạch; mất kết nối quá 30 giây vào ngoại tuyến; không giới hạn thời gian ngoại tuyến (bỏ 8 giờ); hàng đợi gửi lên giữ 30 ngày sau khi cloud xác nhận; lệch giờ nhà máy – cloud quá 5 phút thì cảnh báo Admin
kd | 3 | 22 | D | Có lại kết nối?
k5 | 3 | 23 | Y | Máy chủ nhà máy chủ động nối cloud (cloud không gọi vào nhà máy): đẩy hàng đợi lên theo số thứ tự (cloud bỏ qua sự kiện trùng mã); kéo xuống lệnh từ trung tâm và bản sao chưa tới (danh mục, tài khoản, PO đã duyệt, yêu cầu xuất bán, phiếu chuyển nội bộ theo lệnh, hồ sơ thu hồi, phiếu chuyển từ nhà máy khác)
k6 | 1 | 24 | Y | Cloud áp dụng sự kiện nhà máy vào bản đồng bộ (không kiểm lại — nhà máy là chủ sự thật vật lý; chỉ dừng khi thiếu tham chiếu, báo Admin) rồi CHIẾU sang chứng từ cloud chủ: tiến độ lệnh, KG đã xuất của giữ chỗ, SL đã nhận của PO, đơn Đang giao khi phiếu xuất bán đã xuất, SL đã nhận trên phiếu chuyển của nhà máy khác, đơn Sẵn sàng giao khi đủ lô TP ĐẠT (QT23 dg); gửi xuống nhà máy khác phần liên quan
kx | 1 | 25 | D | Có xung đột?\n(lệnh khóa lô tới sau khi nhà máy đã\ndùng / xuất / chuyển phần lô đó;\nlô HỦY bị dùng; tồn âm)
kf | 0 | 26 | T | Kế hoạch + QC trưởng xử lý: lệnh khóa lý do thu hồi → lô sinh ra vào hồ sơ thu hồi (QT26), phần đã giao → danh sách khách thu hồi; lý do khoanh vùng → QC kiểm lại; lô HỦY bị dùng → ghi nhận đã dùng, sửa SL thực hủy trên biên bản; tồn âm → kiểm điểm đúng lô (QT17)
kz | 1 | 26 | Y | Nhà máy áp lệnh khóa lô tới muộn: khóa phần còn trong kho và phần đang chuyển; phần đã nạp silo → tự KHÓA mọi lô sinh ra theo chuỗi liên kết (bao hỗn hợp, BTP, TP) — lý do thu hồi nếu lệnh là thu hồi, còn lại lý do xung đột; ghi nhật ký xung đột; cảnh báo "có hàng bị khóa sau khi có mạng lại" trên Lệnh SX, Theo dõi mẻ, Việc cần làm (Kế hoạch, QC, QC trưởng)
kr | 0 | 27 | R | QT23: QC kiểm lại lô BTP / TP liên quan (lý do xung đột); lý do thu hồi thì chỉ hủy theo QT26
k7 | 3 | 27 | Y | Thoát ngoại tuyến; ghi nhật ký phiên mất kết nối: thời gian, số sự kiện gửi, số lệnh áp dụng / từ chối, xung đột
e | 3 | 28 | E | Kết thúc (lệnh HOÀN THÀNH, dữ liệu mẻ đã về cloud)
s2 | 0 | 29 | S | Thay đổi lệnh: sửa / hủy (QT07 h4, QT08 r2), kết thúc sớm, silo bảo trì
dh | 0 | 30 | D | Lệnh đang ở?
su | 0 | 31 | T | Mới tạo: sửa (dòng đơn & số lon, số mẻ, KL mẻ, ngày, nhãn hiệu, dàn silo, thứ tự hàng đợi) hoặc hủy (lý do) → ĐÃ HỦY ngay, giải phóng giữ chỗ, số lon phân bổ quay lại Chờ lên lệnh
hl | 0 | 32 | T | Chờ phát / Đã nhận: không sửa — chỉ hủy (lý do) rồi tạo lại (sao chép lệnh); Chờ phát (nhà máy chưa nhận) hủy ngay, cloud ngừng gửi lại, giải phóng giữ chỗ. Silo bảo trì: chờ bảo trì xong (PC xưởng chặn Start) hoặc hủy
yh | 1 | 33 | Y | Gửi lệnh HỦY LỆNH qua kênh lệnh từ trung tâm (cloud ngừng gửi lại lệnh phát): nhà máy xác nhận chưa chạy mẻ → ĐÃ HỦY, giải phóng giữ chỗ; đã chạy mẻ (lúc mất kết nối) → từ chối, lệnh ĐANG CHẠY; nhà máy đang mất mạng → chặn, báo "chưa hủy được, thử lại khi có kết nối", lệnh giữ nguyên (chốt 04/11, thay "lệnh Chờ gửi")
kt | 0 | 34 | T | Đang chạy: không sửa, không hủy. Kết thúc sớm (lý do) là lệnh từ trung tâm — nhà máy áp khi không còn mẻ chạy dở → HOÀN THÀNH với số mẻ thực tế; giải phóng giữ chỗ còn lại; bột dư silo xả về kho điều phối (QT20 xd); phân bổ của lệnh giảm theo số mẻ thực tế (giữ dòng hạn giao sớm trước), phần thiếu quay lại tab Chờ lên lệnh. Ngoại lệ: thêm mẻ bù (QT20 kb, cũng qua kênh lệnh). Silo bảo trì: chặn mẻ tiếp, chờ hoặc kết thúc sớm
e2 | 1 | 35 | E | Kết thúc
kl | 3 | 24 | Y | Áp dụng từng lệnh từ trung tâm trong 1 giao dịch, kiểm điều kiện thực tế tại thời điểm áp (lệnh chưa chạy mẻ? mẻ còn Dừng sự cố? silo không còn bột? không còn mẻ dở? phần lô còn trong kho?) → ĐÃ ÁP DỤNG hoặc TỪ CHỐI kèm lý do; gửi kết quả lên; màn cloud hiện trạng thái từng lệnh ngay cạnh thao tác
s3 | 1 | 36 | S | Cloud mất, hoặc khôi phục từ bản sao lưu
c1 | 1 | 37 | Y | Nhà máy chạy tiếp, hàng đợi giữ sự kiện tới khi cloud xác nhận + 30 ngày. Cloud về: kéo tiếp. Khôi phục từ sao lưu: so số thứ tự đã áp dụng cuối của từng nhà máy với số thứ tự ở nhà máy → yêu cầu gửi lại từ đó; lệnh cloud đã phát sau thời điểm sao lưu còn trong sổ lệnh đã nhận của nhà máy → nhà máy gửi lại danh sách + kết quả để cloud dựng lại trạng thái lệnh
e3 | 1 | 38 | E | Kết thúc
s4 | 3 | 39 | S | Máy chủ nhà máy hỏng, khởi tạo lại
c2 | 3 | 40 | Y | Nạp gói từ cloud: toàn bộ bản sao chỉ đọc (danh mục, tài khoản…) + mọi dữ liệu nhà máy chủ của nhà máy đó theo bản đồng bộ + lệnh đang mở; đặt mốc kéo xuống; hàng đợi gửi lên tiếp từ số cloud đã nhận + 1
c3 | 3 | 41 | Y | Lô có biến động từ lần cloud xác nhận cuối tới lúc hỏng (sự kiện chưa gửi đã mất) → tự tạo phiếu kiểm điểm (QT17), gắn cờ đang kiểm kê; mẻ đang dở đóng bằng tay; PC xưởng nối lại
c4 | 0 | 42 | T | Kế hoạch (cùng Thủ kho trưởng, Admin) xác nhận khởi tạo xong
e4 | 3 | 43 | E | Kết thúc
---
s -> nc
nh -> nc : Nhắc hạn lên lệnh
nc -> t1 : Chọn SP, dòng đơn, số lon
t1 -> tb : Lệnh BTP
t1 -> ys : Lệnh HH
tb -> ys
ys -> tk
tk -> d1
d1 -> t2 : Không
t2 -> t1
d1 -> y1 : Có
y1 -> dt
dt -> g1 : Đủ
dt -> ym : Thiếu
g1 -> dc
dc -> q1 : Đủ
dc -> yd : Thiếu
yd -> r1 : Chờ xuất
ym -> cb
cb -> rm : Mua / chuyển liên nhà máy
rm -> kr : Hàng về kho tổng
r1 -> kr : Hàng về kho điều phối
r1 -> cb : Không thực hiện được
kr -> dt : Kiểm tra lại
q1 -> yx
yx -> xs : Không
xs -> yx : Xếp lại
yx -> d2 : Hợp lệ
d2 -> yd : Thiếu → phiếu chuyển phần còn thiếu, chặn phát
d2 -> y2 : Có
y2 -> dp
dp -> kp : Không
kp -> dp : Gửi lại
dp -> y3 : Có
y3 -> y4
y4 -> k1
k1 -> e : Không → chạy đến khi xong
k1 -> k2 : Có
k2 -> k3
k3 -> k4
k4 -> kd
kc -> kd :  : n
kd -> k3 : Chưa → chạy tiếp
kd -> k5 : Có
k5 -> kl
kl -> k6
k6 -> kx
kx -> k7 : Không
kx -> kz : Có
kz -> kf
kf -> kr
kr -> k7
k7 -> k1 : Lệnh còn chạy
k7 -> e : Lệnh đã xong
s2 -> dh
dh -> su : Mới tạo
dh -> hl : Chờ phát / Đã nhận
dh -> kt : Đang chạy
su -> e2
hl -> yh
yh -> e2
kt -> e2
s3 -> c1
c1 -> e3
s4 -> c2
c2 -> c3
c3 -> c4 : Mất sự kiện → kiểm điểm (QT17)
c4 -> e4
```

## QT20. Quy trình Vận hành mẻ (khu HH / khu BTP)

Gộp QT12 (khu HH) + QT14 (khu BTP). Phần chung: nhận lệnh → quét QR từng bao → hệ thống kiểm bao (đúng công thức, lô ĐẠT, hạn còn ≥ ngưỡng tối thiểu cho SX — 24/10 đợt 9) và ghi liên kết bao → silo → mẻ → mở đúng silo → đổ, lặp tới đủ silo; sai bao thì chặn ngay nên không còn nhánh đổ nhầm / hủy mẻ. Rẽ nhánh ở "Khu nào?": HH đi robot + thang nâng, cân bao so với KL công thức (công thức không còn dung sai — 05/11), ghi liên kết mẻ → bao HH; BTP đi bồn trộn (ghi thông số trộn) rồi sang chiết rót. Sự cố dừng máy ghi vào hồ sơ mẻ. Chốt 17/10: sự cố không khắc phục được thì Kế hoạch quyết hủy mẻ (ghi lý do, số kg bột bỏ); hồ sơ mẻ → ĐÃ HỦY; bột hỏng thành phần lô KHÓA chờ hủy, tự tạo phiếu hủy (QT18), truy xuất tính vào cột hủy; Kế hoạch thêm 1 mẻ bù vào lệnh đang chạy, hệ thống giữ thêm NVL theo kg. Khi code: 1 màn hình, 2 cấu hình. Sửa 19/10 (đợt 2): silo mở cho từng bao theo phương án dàn silo của lệnh (QT19 — NVL nào vào silo nào đã chốt khi tạo lệnh); PC xưởng đăng nhập bằng quét thẻ NV; quét bao bằng đầu đọc mã ở PC xưởng (không có máy quét riêng). Sửa 19/10 (đợt 3): silo nạp một lần dùng cho nhiều mẻ, nạp bổ sung khi vơi (bột trong silo + bao ≤ sức chứa); mỗi mẻ silo xả đúng KL / mẻ; truy xuất qua nút silo của lệnh theo thời điểm nạp / xả, silo xả sạch thì đóng nút; hết lệnh / kết thúc sớm thì xả bột dư thành lô NVL dư về kho điều phối (QT14). Sửa 20/10 (đợt 2 — offline): bỏ bước Kế hoạch xác nhận d1 — máy chủ nhà máy tự kiểm (QT19 y4). Hủy mẻ (kh) và mẻ bù (kb) là lệnh từ trung tâm: Kế hoạch bấm trên cloud cả khi nhà máy mất mạng, lệnh Chờ gửi; nhà máy áp dụng khi mẻ vẫn Dừng sự cố, khác thì từ chối.

```quy-trinh
so: 20
mang: Sản xuất
tu: QT12 + QT14
ten-ngan: Vận hành mẻ
ten: Quy trình Vận hành mẻ (khu HH / khu BTP)
ghi-chu: Gộp QT12 (khu HH) + QT14 (khu BTP). Phần chung: nhận lệnh → quét QR từng bao → hệ thống kiểm bao (đúng công thức, lô ĐẠT, hạn còn ≥ ngưỡng tối thiểu cho SX — 24/10 đợt 9) và ghi liên kết bao → silo → mẻ → mở đúng silo → đổ, lặp tới đủ silo; sai bao thì chặn ngay nên không còn nhánh đổ nhầm / hủy mẻ. Rẽ nhánh ở "Khu nào?": HH đi robot + thang nâng, cân bao so với KL công thức (công thức không còn dung sai — 05/11), ghi liên kết mẻ → bao HH; BTP đi bồn trộn (ghi thông số trộn) rồi sang chiết rót. Sự cố dừng máy ghi vào hồ sơ mẻ. Chốt 17/10: sự cố không khắc phục được thì Kế hoạch quyết hủy mẻ (ghi lý do, số kg bột bỏ); hồ sơ mẻ → ĐÃ HỦY; bột hỏng thành phần lô KHÓA chờ hủy, tự tạo phiếu hủy (QT18), truy xuất tính vào cột hủy; Kế hoạch thêm 1 mẻ bù vào lệnh đang chạy, hệ thống giữ thêm NVL theo kg. Khi code: 1 màn hình, 2 cấu hình. Sửa 19/10 (đợt 2): silo mở cho từng bao theo phương án dàn silo của lệnh (QT19 — NVL nào vào silo nào đã chốt khi tạo lệnh); PC xưởng đăng nhập bằng quét thẻ NV; quét bao bằng đầu đọc mã ở PC xưởng (không có máy quét riêng). Sửa 19/10 (đợt 3): silo nạp một lần dùng cho nhiều mẻ, nạp bổ sung khi vơi (bột trong silo + bao ≤ sức chứa); mỗi mẻ silo xả đúng KL / mẻ; truy xuất qua nút silo của lệnh theo thời điểm nạp / xả, silo xả sạch thì đóng nút; hết lệnh / kết thúc sớm thì xả bột dư thành lô NVL dư về kho điều phối (QT14). Sửa 20/10 (đợt 2 — offline): bỏ bước Kế hoạch xác nhận d1 — máy chủ nhà máy tự kiểm (QT19 y4). Hủy mẻ (kh) và mẻ bù (kb) là lệnh từ trung tâm: Kế hoạch bấm trên cloud cả khi nhà máy mất mạng, lệnh Chờ gửi; nhà máy áp dụng khi mẻ vẫn Dừng sự cố, khác thì từ chối.
cot: Kế hoạch | Kho điều phối | Công nhân | PC C# / Hệ thống | Robot / Thang nâng (HH) | Bồn trộn (BTP)
s | 0 | 0 | S | Lệnh từ server local (QT19)
d1 | 3 | 1 | D | Máy chủ nhà máy tự kiểm:\nlệnh Đã nhận, không bị hủy, silo\nkhông bảo trì? (không đạt → báo lý do)
t0 | 0 | 1 | T | Kế hoạch xử lý lý do chưa phát sang khu được (silo bảo trì: xếp lại / chờ; lệnh hủy)
yp | 3 | 2 | Y | Phát lệnh sang khu SX (hiện trên PC C# của khu) và tự lập phiếu xuất SX từ kho điều phối, nơi nhận = khu của lệnh: lô FEFO, hạn ≥ ngưỡng SX, trừ KG giữ chỗ → Chờ lấy hàng (QT15). Kho điều phối thiếu → phiếu phần có, phần thiếu tự lập phiếu chuyển nội bộ (QT19 yd, vào thẳng Chờ xuất — 30/10); hàng về → tự lập phiếu bổ sung
t1 | 1 | 3 | T | Thủ kho điều phối lấy hàng theo phiếu tự lập (quét → Đang lấy hàng → Đã xuất), giao cho khu — không lập phiếu tay, không xuất SX thẳng từ kho tổng
t2 | 2 | 3 | T | Công nhân nhấn Start trên PC C# — tạo mẻ (chặn nếu silo trong phương án đang bảo trì / ngừng dùng)
dn | 3 | 4 | D | Silo đủ bột cho mẻ?\n(từng NVL: bột trong silo\n≥ KL / mẻ)
t3 | 2 | 5 | T | Quét QR bao nạp silo (nạp lần đầu hoặc nạp bổ sung khi silo vơi)
g2 | 3 | 6 | D | Bao đã xuất cho lệnh, đúng NVL\ncủa silo theo phương án, lô ĐẠT,\nhạn ≥ ngưỡng SX, bột trong silo\n+ bao ≤ sức chứa?
x1 | 2 | 7 | T | Màn hình báo lỗi, không mở silo; trả bao về kho điều phối, lấy bao đúng
g1 | 3 | 7 | Y | Ghi liên kết lô bao → silo của lệnh ngay lúc quét (lần nạp: lô, kg, thời điểm); không ghi được thì chặn, không mở silo
y1 | 3 | 8 | Y | Mở van nạp của silo xếp cho NVL của bao (1 NVL – 1 silo theo phương án silo của lệnh), màn hình nhấp nháy
t4 | 2 | 9 | T | Đổ bao vào silo vừa mở
ys | 3 | 10 | Y | Từng silo xả đúng KL / mẻ theo công thức (cân định lượng); chặn xả khi trong nút silo có lô đã hết hạn (24/10 đợt 9); ghi liên kết silo → mẻ (lần xả: kg, thời điểm). Truy xuất: lô nạp lúc T là đầu vào của các mẻ xả sau T, tới khi silo xả sạch
vs | 2 | 10 | T | Silo xả sạch giữa lệnh (bột về 0, vệ sinh): công nhân xác nhận → đóng nút silo hiện tại, lần nạp sau mở nút mới (tách truy xuất)
d4 | 3 | 11 | D | Khu nào?
h1 | 4 | 12 | T | Robot tới từng silo hứng bột (2 silo/lần)
b1 | 5 | 12 | T | Mở xả van; bồn trộn nhận bột
h3 | 2 | 13 | T | Mở vỏ silo, móc bột còn dính
h2 | 4 | 13 | D | Van silo xả hết?
b2 | 5 | 13 | T | Đóng van xả, nhấn bắt đầu trộn
b4 | 2 | 14 | T | Mở nắp bồn, móc cho rớt xuống
g7 | 3 | 14 | Y | Ghi thông số trộn thực tế (thời gian, tốc độ) vào hồ sơ mẻ BTP — không có thông số chuẩn để so (bỏ 05/11)
h4 | 4 | 14 | T | Đóng van; robot vào thang nâng
h5 | 4 | 15 | D | Cảm biến an toàn OK?
b3 | 5 | 15 | D | Trộn xong, xả hết?
h6 | 2 | 16 | T | Công nhân báo sự cố trên PC C#, khắc phục
g4 | 3 | 16 | Y | Ghi sự cố / dừng máy vào hồ sơ mẻ: thời gian dừng, nguyên nhân, người xử lý (khu HH và khu BTP)
b5 | 5 | 16 | R | QT21: Chiết rót và đóng gói
h7 | 4 | 17 | T | Nâng lên vị trí, xả 2 lần vào bao
h8 | 3 | 18 | Y | Cân bao HH
g3 | 3 | 19 | D | KL bao đúng KL\ncông thức (QT03)?
ha | 2 | 20 | T | Lệch: bù / bớt bột tới đúng KL, cân lại
yk | 3 | 20 | Y | Ghi KL thực tế, chênh lệch so với công thức vào hồ sơ mẻ
h9 | 2 | 21 | T | Lấy bao ra, dán QR bao HH (mã sinh tại server nhà máy); bao hỗn hợp vừa dán mã là ĐẠT (không QC)
yl | 3 | 22 | Y | Ghi liên kết mẻ → bao HH (mã bao, KL); không ghi được thì chặn
h10 | 4 | 23 | T | Thang hạ, xe về vị trí gốc
h11 | 1 | 24 | R | QT16: Chuyển bao HH về kho điều phối / sang kho BTP
y2 | 3 | 25 | Y | Trả trạng thái mẻ về local + cloud, đóng hồ sơ mẻ
hx | 2 | 17 | D | Khắc phục được?
kh | 0 | 17 | T | Kế hoạch quyết hủy mẻ: ghi lý do, số kg bột bỏ — lệnh từ trung tâm, nhà máy áp khi mẻ vẫn Dừng sự cố
ky | 3 | 17 | Y | Hồ sơ mẻ → ĐÃ HỦY; bột hỏng ghi thành phần lô của mẻ, KHÓA lý do chờ hủy, tự tạo phiếu hủy; truy xuất tính phần này vào cột hủy
kr | 1 | 18 | R | QT18: Hủy hàng (bột hỏng của mẻ)
kb | 0 | 19 | T | Kế hoạch thêm 1 mẻ bù vào lệnh đang chạy; hệ thống giữ thêm NVL theo kg (QT19) — cùng lệnh hủy mẻ
dm | 3 | 26 | D | Lệnh còn mẻ?
xd | 2 | 27 | T | Hết lệnh (hoặc Kế hoạch kết thúc sớm — QT19 kt): xả bột dư từng silo vào bao, dán QR — lô NVL dư mới (HSD theo lô sớm nhất đã nạp vào nút silo)
yd | 3 | 28 | Y | Ghi liên kết silo → lô dư, silo xả sạch (đóng nút silo của lệnh); lệnh chỉ HOÀN THÀNH khi mọi silo của lệnh đã xả sạch
rd | 1 | 29 | R | QT14: Nhập NVL dư (bột dư từ silo) về kho điều phối
e | 3 | 30 | E | Kết thúc
---
s -> d1
d1 -> t0 : Không
t0 -> d1
d1 -> yp : Có
yp -> t1
t1 -> t2
t2 -> dn
dn -> t3 : Chưa → nạp
t3 -> g2
g2 -> x1 : Không
x1 -> t3 : Quét bao đúng
g2 -> g1 : Có
g1 -> y1
y1 -> t4
t4 -> dn
dn -> ys : Đủ
vs -> ys :  : n
ys -> d4
d4 -> h1 : HH
d4 -> b1 : BTP
h1 -> h2
h2 -> h3 : Không
h3 -> h2
h2 -> h4 : Có
h4 -> h5
h5 -> g4 : Không
h5 -> h7 : Có
h7 -> h8
h8 -> g3
g3 -> ha : Lệch
ha -> h8 : Cân lại
g3 -> yk : Đạt
yk -> h9
h9 -> yl
yl -> h10
h10 -> h11
h11 -> y2
b1 -> b2
b2 -> g7
g7 -> b3
b3 -> b4 : Không
b4 -> b3
b3 -> b5 : Có
b5 -> y2
g4 -> h6
h6 -> hx
hx -> h5 : Có, khu HH
hx -> b3 : Có, khu BTP
hx -> kh : Không
b3 -> g4 : Sự cố
kh -> ky
ky -> kr
kr -> kb
kb -> t1 : Chạy mẻ bù
y2 -> dm
dm -> t2 : Còn → mẻ tiếp
dm -> xd : Hết / kết thúc sớm
xd -> yd
yd -> rd
rd -> e
```

## QT21. Quy trình Chiết rót và Đóng gói

Một mẻ chiết cho nhiều nhãn hiệu cùng công thức; mỗi nhãn hiệu một lô (số lô, NSX, HSD in sẵn trên bao bì lon — hệ thống không in). Mỗi nhãn hiệu chỉ quét barcode lon đầu tiên: hệ thống kiểm đúng nhãn của mẻ, gắn mẻ → nhãn hiệu → lô và bắt đầu đếm. Vừa chiết vừa đếm lon đạt (cân từng lon, lon lệch bị loại, chiết bù); đủ số lon kế hoạch thì quét lon đầu của nhãn hiệu sau. Đóng thùng không quét lon: dán QR thùng, hệ thống gắn thùng với nhãn hiệu / lô đang chạy theo bộ đếm. Thùng vào kho BTP ở CHỜ KIỂM, QC lấy mẫu từng lô sau khi nhập kho. Sửa 20/10 (đợt 2 — offline): mọi bước chạy tại máy chủ nhà máy / PC xưởng; nhập thùng về kho BTP (t9) và Thủ kho trưởng duyệt tại chỗ.

```quy-trinh
so: 21
mang: Sản xuất
tu: QT15
ten-ngan: Chiết rót & đóng gói
ten: Quy trình Chiết rót và Đóng gói
ghi-chu: Một mẻ chiết cho nhiều nhãn hiệu cùng công thức; mỗi nhãn hiệu một lô (số lô, NSX, HSD in sẵn trên bao bì lon — hệ thống không in). Mỗi nhãn hiệu chỉ quét barcode lon đầu tiên: hệ thống kiểm đúng nhãn của mẻ, gắn mẻ → nhãn hiệu → lô và bắt đầu đếm. Vừa chiết vừa đếm lon đạt (cân từng lon, lon lệch bị loại, chiết bù); đủ số lon kế hoạch thì quét lon đầu của nhãn hiệu sau. Đóng thùng không quét lon: dán QR thùng, hệ thống gắn thùng với nhãn hiệu / lô đang chạy theo bộ đếm. Thùng vào kho BTP ở CHỜ KIỂM, QC lấy mẫu từng lô sau khi nhập kho. Sửa 20/10 (đợt 2 — offline): mọi bước chạy tại máy chủ nhà máy / PC xưởng; nhập thùng về kho BTP (t9) và Thủ kho trưởng duyệt tại chỗ.
cot: Công nhân sản xuất | Máy chiết rót / đóng gói | Công nhân đóng gói | QC | Hệ thống | Kho
s | 0 | 0 | S | Mẻ BTP xả xong (QT20)
yn | 4 | 1 | Y | Tải danh sách nhãn hiệu của mẻ (cùng công thức): nhãn hiệu, số lô in trên lon, số lon kế hoạch từng nhãn (từ lệnh SX, QT19)
t1 | 0 | 2 | T | Mở van bướm điện, nguyên liệu đổ xuống
t2 | 2 | 2 | T | Chuẩn bị thùng, lon theo từng nhãn hiệu (mã, NSX, HSD, số lô in sẵn trên bao bì lon)
q1 | 0 | 3 | T | Quét barcode lon đầu tiên của nhãn hiệu
dq | 4 | 4 | D | Đúng nhãn hiệu\ncủa mẻ?
xq | 0 | 5 | T | Sai: chặn chiết rót, đổi đúng lon rồi quét lại
yq | 4 | 5 | Y | Gắn mẻ → nhãn hiệu → số lô; bộ đếm nhãn hiệu về 0, bắt đầu đếm
t3 | 1 | 6 | T | Chiết rót; lon đầu mẻ gắn hậu tố -00X
d1 | 1 | 7 | D | Lon đầy?
d2 | 1 | 8 | D | Đậy nắp OK?
g2 | 1 | 9 | T | Cân từng lon (khối lượng tịnh) trên cân kiểm tra
yx | 4 | 9 | Y | Ghi KL tịnh từng lon, số lon loại vào hồ sơ mẻ (theo nhãn hiệu)
dc | 1 | 10 | D | KL tịnh trong\ndung sai?
xl | 0 | 11 | T | Lệch: loại lon ra khỏi dây chuyền, chiết bù lon khác
ct | 1 | 11 | T | Đếm lon đạt, cộng vào nhãn hiệu đang chạy
t4 | 2 | 12 | T | Bỏ lon vào thùng (không quét lon)
dt | 2 | 13 | D | Thùng đầy hoặc\nđủ số lon nhãn hiệu?
d3 | 1 | 14 | D | Cân băng tải: đủ kg thùng\n(theo số lon trong thùng)?
tx | 2 | 15 | T | Thùng thiếu kg: mở thùng, đếm lại lon, bổ sung lon thiếu
yd | 4 | 15 | Y | Số lon đếm lại lệch bộ đếm: sửa số lon của thùng, ghi lệch vào hồ sơ mẻ
t7 | 2 | 17 | T | Dán băng keo, dán QR thùng (mã sinh tại server nhà máy)
yt | 4 | 18 | Y | Ghi thùng → nhãn hiệu / số lô / mẻ, số lon trong thùng theo bộ đếm; không ghi được thì chặn
dn | 4 | 19 | D | Đủ số lon\ncủa nhãn hiệu?
ye | 4 | 20 | Y | Chốt nhãn hiệu: số lon thực tế, số lon loại, chênh lệch so với kế hoạch
dm | 4 | 21 | D | Còn nhãn hiệu\ntrong mẻ?
t9 | 5 | 22 | T | Nhận thùng về kho BTP: mở phiếu nhập hệ thống tự sinh khi đóng thùng xong, quét thùng (tại máy chủ nhà máy); lệch mới cần Thủ kho trưởng xác nhận (QT14)
t8 | 3 | 23 | T | Sau khi thùng đã nhập kho BTP: QC lấy 2 lon mỗi lô (nhãn hiệu) kiểm & lưu mẫu (QT23, QT24)
g3 | 4 | 24 | Y | Các lô BTP (theo nhãn hiệu) vào kho BTP ở CHỜ KIỂM (chặn xuất / giao) tới khi QC đạt và đổi thành TP (QT23)
e | 4 | 25 | E | Kết thúc
---
s -> yn
yn -> t1
yn -> t2
t1 -> q1
t2 -> q1
q1 -> dq
dq -> xq : Sai
xq -> q1 : Quét lại
dq -> yq : Đúng
yq -> t3
t3 -> d1
d1 -> t3 : Không
d1 -> d2 : Có
d2 -> t3 : Không
d2 -> g2 : Có
g2 -> yx
yx -> dc
dc -> xl : Lệch
xl -> t3 : Chiết bù
dc -> ct : Đạt
ct -> t4
t4 -> dt
dt -> t3 : Chưa → chiết tiếp
dt -> d3 : Rồi
d3 -> t7 : Có
t7 -> yt
yt -> dn
dn -> t3 : Chưa → chiết tiếp
dn -> ye : Đủ
ye -> dm
dm -> q1 : Còn → nhãn hiệu sau
dm -> t9 : Hết
t9 -> t8
t8 -> g3
g3 -> e
d3 -> tx : Không
tx -> yd
yd -> d3 : Cân lại
```


# Mảng 6 · Chất lượng

## QT22. Quy trình QC đầu vào (NVL)

Tách từ QT17 cũ. Chốt 16/10: nguyên liệu mua không QC khi nhập (dựa vào file đánh giá bên ngoài tải ở QT14), không kiểm định kỳ; QT22 chỉ chạy khi lô có vấn đề. Sửa 16/10 (vòng đời lô hàng): QC trưởng duyệt mọi kết luận; từ chối yêu cầu kiểm thì lô về trạng thái trước; KHÔNG ĐẠT chỉ xử lý phần còn trong kho → trả NCC (QT13) hoặc hủy; QC trưởng có thao tác tay mở lại lô KHÔNG ĐẠT (lý do + file, chặn khi đã hết hạn). Chốt lại 19/10 (đợt 4): lô nghi lỗi gửi QC → CHỜ KIỂM, không KHÓA (mọi màn Kho, Tồn kho, Lệnh SX, Chất lượng hiện cùng một trạng thái); lô CHỜ KIỂM không tính tồn khả dụng, không xuất được nhưng vẫn chuyển kho được (giữ trạng thái). KHÓA lý do khoanh vùng chỉ khi lô nằm trong hồ sơ thu hồi (QT26). Sửa 20/10: thêm nhánh yêu cầu bổ sung như QT23 (d1 → t2 → t1). Sửa 20/10 (đợt 2 — offline): mọi bước làm tại máy chủ nhà máy (QC, QC trưởng ở nhà máy); lô đổi trạng thái ngay trên tồn nhà máy, cloud nhận sau. QT23 dg / d3 (đủ lô TP của đơn → QT09) do cloud chiếu sau đồng bộ; chứng nhận (g2) ký tại nhà máy, Giao hàng dùng khi đã lên cloud. Mã yêu cầu kiểm / phiếu kiểm / chứng nhận / mẫu lưu có tiền tố nhà máy.

```quy-trinh
so: 22
mang: Chất lượng
tu: QT17 (NVL)
ten-ngan: QC đầu vào
ten: Quy trình QC đầu vào (NVL)
ghi-chu: Tách từ QT17 cũ. Chốt 16/10: nguyên liệu mua không QC khi nhập (dựa vào file đánh giá bên ngoài tải ở QT14), không kiểm định kỳ; QT22 chỉ chạy khi lô có vấn đề. Sửa 16/10 (vòng đời lô hàng): QC trưởng duyệt mọi kết luận; từ chối yêu cầu kiểm thì lô về trạng thái trước; KHÔNG ĐẠT chỉ xử lý phần còn trong kho → trả NCC (QT13) hoặc hủy; QC trưởng có thao tác tay mở lại lô KHÔNG ĐẠT (lý do + file, chặn khi đã hết hạn). Chốt lại 19/10 (đợt 4): lô nghi lỗi gửi QC → CHỜ KIỂM, không KHÓA (mọi màn Kho, Tồn kho, Lệnh SX, Chất lượng hiện cùng một trạng thái); lô CHỜ KIỂM không tính tồn khả dụng, không xuất được nhưng vẫn chuyển kho được (giữ trạng thái). KHÓA lý do khoanh vùng chỉ khi lô nằm trong hồ sơ thu hồi (QT26). Sửa 20/10: thêm nhánh yêu cầu bổ sung như QT23 (d1 → t2 → t1). Sửa 20/10 (đợt 2 — offline): mọi bước làm tại máy chủ nhà máy (QC, QC trưởng ở nhà máy); lô đổi trạng thái ngay trên tồn nhà máy, cloud nhận sau. QT23 dg / d3 (đủ lô TP của đơn → QT09) do cloud chiếu sau đồng bộ; chứng nhận (g2) ký tại nhà máy, Giao hàng dùng khi đã lên cloud. Mã yêu cầu kiểm / phiếu kiểm / chứng nhận / mẫu lưu có tiền tố nhà máy.
cot: Kho / Kế hoạch | QC | QC trưởng | Mua hàng | Hệ thống
s | 0 | 0 | S | Lô nguyên liệu có vấn đề (SX / kho phát hiện, hư khi nhận chuyển kho QT16, xung đột QT19, khoanh vùng QT26)
t1 | 0 | 1 | T | Gửi yêu cầu kiểm, tạo phiếu
y1 | 4 | 2 | Y | Lô → CHỜ KIỂM (không KHÓA — chốt 19/10 đợt 4), chặn xuất ngay, không tính tồn khả dụng. Chỉ nhận lô ĐẠT hoặc KHÓA có lý do cho phép QC; lý do thu hồi / hết hạn / chờ hủy → không cho gửi
d1 | 2 | 3 | D | QC trưởng duyệt yêu cầu?
t2 | 0 | 4 | T | Bổ sung thông tin (số lô NCC, file đánh giá bên ngoài…), gửi lại
yt | 4 | 4 | Y | Từ chối (bắt buộc lý do): lô về trạng thái trước khi gửi — ĐẠT → ĐẠT; KHÓA → KHÓA giữ lý do cũ
t3 | 1 | 4 | T | Lấy 2 mẫu: 1 gửi kiểm nghiệm, 1 lưu (QT24)
g1 | 1 | 5 | T | QC tải file đánh giá bên ngoài, chọn đề xuất Đạt / Không đạt + ghi chú (không còn bộ chỉ tiêu, hệ thống không so giới hạn); người tải không tự duyệt
d2 | 2 | 6 | D | QC trưởng duyệt kết luận:\nĐạt?
t4 | 2 | 7 | T | Thông báo Mua hàng
y2 | 4 | 7 | Y | Lô → ĐẠT, cho phép xuất
y3 | 4 | 8 | Y | Lô → KHÔNG ĐẠT. Chỉ xử lý phần còn trong kho; không dò ngược lô đã sản xuất (QC thành phẩm là chốt chặn cuối)
r1 | 3 | 9 | R | QT13: Trả hàng NCC (hoặc hủy nếu nhà máy chịu)
e | 4 | 10 | E | Kết thúc
s2 | 2 | 11 | S | QC trưởng mở lại lô KHÔNG ĐẠT (nhà máy tự kiểm nghiệm ngoài thấy đạt)
ym | 4 | 12 | Y | Bắt buộc lý do + file đính kèm; chặn nếu lô đã hết hạn; lô → ĐẠT, nhật ký giữ lần KHÔNG ĐẠT trước
e2 | 4 | 13 | E | Kết thúc
---
s -> t1
t1 -> y1
y1 -> d1
d1 -> t2 : Yêu cầu bổ sung
t2 -> t1
d1 -> yt : Từ chối
yt -> e
d1 -> t3 : Duyệt
t3 -> g1
g1 -> d2
d2 -> y2 : Đạt
y2 -> e
d2 -> t4 : Không đạt
t4 -> y3
y3 -> r1
r1 -> e
s2 -> ym
ym -> e2
```

## QT23. Quy trình QC thành phẩm (BTP → TP)

Tách từ QT17 cũ. BTP = thùng lon đã chiết rót, vào kho BTP ở CHỜ KIỂM; QC lấy mẫu sau khi nhập kho BTP; đạt thì lô đổi thành TP (cùng mã lô) — chỉ TP có phiếu chứng nhận mới được giao, mọi lô TP của đơn ĐẠT thì gọi QT09. Lô TP khách trả cũng kiểm lại ở đây. Sửa 16/10 (vòng đời lô hàng): QC trưởng duyệt mọi kết luận; từ chối yêu cầu kiểm thì lô KHÓA về KHÓA giữ lý do, BTP mới nhập chỉ được yêu cầu bổ sung; KHÔNG ĐẠT chỉ có đường hủy (không sản xuất lại từ BTP / TP, cần bù thì lệnh mới từ nguyên liệu); TP đã giao một phần (khoanh vùng) mà không đạt thì hồ sơ thu hồi quay lại bước GĐ quyết định. Sửa 20/10 (đợt 2 — offline): mọi bước làm tại máy chủ nhà máy (QC, QC trưởng ở nhà máy); lô đổi trạng thái ngay trên tồn nhà máy, cloud nhận sau. QT23 dg / d3 (đủ lô TP của đơn → QT09) do cloud chiếu sau đồng bộ; chứng nhận (g2) ký tại nhà máy, Giao hàng dùng khi đã lên cloud. Mã yêu cầu kiểm / phiếu kiểm / chứng nhận / mẫu lưu có tiền tố nhà máy. Chốt 04/11 (theo mockup): ký phiếu chứng nhận tách khỏi duyệt kết luận — duyệt Đạt thì hệ thống sinh phiếu chứng nhận ở trạng thái Chờ ký (lô TP đã Đạt nhưng chưa giao được); QC trưởng ký riêng (gk) → Đã ký, lưu bản PDF, báo Kế hoạch, Kho, Sales; chỉ lô có phiếu Đã ký mới giao được và mới tính vào "mọi lô TP của đơn đã đạt" (dg).

```quy-trinh
so: 23
mang: Chất lượng
tu: QT17 (BTP / TP)
ten-ngan: QC thành phẩm
ten: Quy trình QC thành phẩm (BTP → TP)
ghi-chu: Tách từ QT17 cũ. BTP = thùng lon đã chiết rót, vào kho BTP ở CHỜ KIỂM; QC lấy mẫu sau khi nhập kho BTP; đạt thì lô đổi thành TP (cùng mã lô) — chỉ TP có phiếu chứng nhận mới được giao, mọi lô TP của đơn ĐẠT thì gọi QT09. Lô TP khách trả cũng kiểm lại ở đây. Sửa 16/10 (vòng đời lô hàng): QC trưởng duyệt mọi kết luận; từ chối yêu cầu kiểm thì lô KHÓA về KHÓA giữ lý do, BTP mới nhập chỉ được yêu cầu bổ sung; KHÔNG ĐẠT chỉ có đường hủy (không sản xuất lại từ BTP / TP, cần bù thì lệnh mới từ nguyên liệu); TP đã giao một phần (khoanh vùng) mà không đạt thì hồ sơ thu hồi quay lại bước GĐ quyết định. Sửa 20/10 (đợt 2 — offline): mọi bước làm tại máy chủ nhà máy (QC, QC trưởng ở nhà máy); lô đổi trạng thái ngay trên tồn nhà máy, cloud nhận sau. QT23 dg / d3 (đủ lô TP của đơn → QT09) do cloud chiếu sau đồng bộ; chứng nhận (g2) ký tại nhà máy, Giao hàng dùng khi đã lên cloud. Mã yêu cầu kiểm / phiếu kiểm / chứng nhận / mẫu lưu có tiền tố nhà máy. Chốt 04/11 (theo mockup): ký phiếu chứng nhận tách khỏi duyệt kết luận — duyệt Đạt thì hệ thống sinh phiếu chứng nhận ở trạng thái Chờ ký (lô TP đã Đạt nhưng chưa giao được); QC trưởng ký riêng (gk) → Đã ký, lưu bản PDF, báo Kế hoạch, Kho, Sales; chỉ lô có phiếu Đã ký mới giao được và mới tính vào "mọi lô TP của đơn đã đạt" (dg).
cot: Kho / Kế hoạch | QC | QC trưởng | Kế hoạch | Hệ thống
s | 0 | 0 | S | Lô BTP mới nhập kho BTP (QT14, QT21); lô TP khách trả (QT14); lô bị khoanh vùng / xung đột / hư khi nhận / tìm lại (QT26, QT19, QT16, QT17)
t1 | 0 | 1 | T | Gửi yêu cầu kiểm, tạo phiếu
y1 | 4 | 2 | Y | Lô → CHỜ KIỂM, chặn xuất (BTP mới đã ở CHỜ KIỂM). Lý do khóa thu hồi / hết hạn / chờ hủy → không cho gửi
d1 | 2 | 3 | D | QC trưởng duyệt yêu cầu?
t2 | 0 | 4 | T | Bổ sung thông tin, gửi lại
yt | 4 | 4 | Y | Từ chối (bắt buộc lý do): lô KHÓA về KHÓA, giữ lý do cũ. BTP mới nhập không được từ chối, chỉ yêu cầu bổ sung
t3 | 1 | 4 | T | Lấy 2 mẫu: 1 gửi kiểm nghiệm, 1 lưu (QT24)
yq | 1 | 6 | T | QC tải file đánh giá bên ngoài, chọn đề xuất Đạt / Không đạt + ghi chú (không còn bộ chỉ tiêu, hệ thống không so giới hạn); người tải không tự duyệt
d2 | 2 | 7 | D | QC trưởng duyệt kết luận:\nĐạt?
t4 | 2 | 8 | T | Thông báo Kế hoạch, Kho
y2 | 4 | 8 | Y | Lô → ĐẠT; lô BTP đổi thành TP (cùng mã lô)
g2 | 1 | 9 | Y | Lô TP: sinh phiếu chứng nhận chất lượng xuất xưởng ở trạng thái CHỜ KÝ (lô, SP, kết luận, QC trưởng duyệt, ngày, đính kèm file đánh giá bên ngoài) — lô TP đã Đạt, chưa giao được
gk | 2 | 10 | T | QC trưởng ký phiếu chứng nhận (tách khỏi duyệt kết luận — 04/11) → ĐÃ KÝ, số phiếu CN- cấp lúc ký: lưu bản PDF, báo Kế hoạch, Kho, Sales; lô được phép giao, gửi kèm khi giao (QT09)
y3 | 4 | 9 | Y | Lô → KHÔNG ĐẠT (giữ khóa); BTP / TP không đạt chỉ có đường hủy, không sản xuất lại từ BTP / TP
dg | 1 | 10 | D | Mọi lô TP của đơn\nđã ĐẠT, phiếu\nchứng nhận đã ký?
d3 | 3 | 10 | D | Lô TP đã giao\nmột phần?
r9 | 1 | 11 | R | QT09: Giao hàng
r6 | 2 | 11 | R | QT26: hồ sơ khoanh vùng quay lại bước GĐ quyết định (kèm kết quả QC, danh sách khách đã nhận)
r2 | 4 | 11 | R | QT18: Hủy phần còn trong kho
r1 | 3 | 12 | R | QT19: Kế hoạch tạo lệnh mới từ nguyên liệu để bù đơn (nếu cần)
e | 4 | 13 | E | Kết thúc
---
s -> t1
t1 -> y1
y1 -> d1
d1 -> t2 : Yêu cầu bổ sung
t2 -> t1
d1 -> yt : Từ chối (lô KHÓA)
yt -> e
d1 -> t3 : Duyệt
yq -> d2
d2 -> y2 : Đạt
y2 -> g2
g2 -> gk
gk -> dg
dg -> r9 : Có
dg -> e : Không / không thuộc đơn
r9 -> e
d2 -> t4 : Không đạt
t4 -> y3
y3 -> d3
d3 -> r6 : Có
d3 -> r2 : Không
r6 -> r2
r2 -> r1 : Cần bù
r2 -> e : Không cần bù
r1 -> e
t3 -> yq
```

## QT24. Quy trình Đánh giá và Quản lý mẫu lưu

Chốt 17/10: QC lấy mẫu sau khi thùng đã nhập kho BTP (NVL: khi lô cần kiểm, QT22). Thời hạn lưu do QC tự quyết, phần mềm ghi nhận; không ghi tủ / ngăn, không quản lý điều kiện bảo quản (sửa 26/10); sửa 04/11: ghi nơi lưu mẫu = kho mẫu lưu QC của nhà máy (loại kho MAUQC, vd NM1-MAUQC). Mẫu hết hạn lưu thì QC tự hủy, lập biên bản, không cần duyệt. Sửa 20/10 (đợt 2 — offline): mọi bước làm tại máy chủ nhà máy (QC, QC trưởng ở nhà máy); lô đổi trạng thái ngay trên tồn nhà máy, cloud nhận sau. QT23 dg / d3 (đủ lô TP của đơn → QT09) do cloud chiếu sau đồng bộ; chứng nhận (g2) ký tại nhà máy, Giao hàng dùng khi đã lên cloud. Mã yêu cầu kiểm / phiếu kiểm / chứng nhận / mẫu lưu có tiền tố nhà máy. Chốt 04/11 (theo mockup): QC lấy mẫu lưu ra đánh giá (lý do bắt buộc — truy xuất, thu hồi, nghi lỗi…; chứng từ liên quan) → mẫu đang mở niêm phong; đánh giá xong niêm phong lại, ghi kết quả đánh giá (bắt buộc); QC sửa hạn lưu (hạn mới, lý do; gợi ý HSD + 6 tháng); hủy mẫu ghi cách hủy, người chứng kiến, biên bản (ảnh / PDF có chữ ký). Trạng thái mẫu lưu: Đang lưu (có thể đang mở niêm phong) / Hết hạn lưu / Đã hủy.

```quy-trinh
so: 24
mang: Chất lượng
tu: QT18
ten-ngan: Mẫu lưu
ten: Quy trình Đánh giá và Quản lý mẫu lưu
ghi-chu: Chốt 17/10: QC lấy mẫu sau khi thùng đã nhập kho BTP (NVL: khi lô cần kiểm, QT22). Thời hạn lưu do QC tự quyết, phần mềm ghi nhận; không ghi tủ / ngăn, không quản lý điều kiện bảo quản (sửa 26/10); sửa 04/11: ghi nơi lưu mẫu = kho mẫu lưu QC của nhà máy (loại kho MAUQC, vd NM1-MAUQC). Mẫu hết hạn lưu thì QC tự hủy, lập biên bản, không cần duyệt. Sửa 20/10 (đợt 2 — offline): mọi bước làm tại máy chủ nhà máy (QC, QC trưởng ở nhà máy); lô đổi trạng thái ngay trên tồn nhà máy, cloud nhận sau. QT23 dg / d3 (đủ lô TP của đơn → QT09) do cloud chiếu sau đồng bộ; chứng nhận (g2) ký tại nhà máy, Giao hàng dùng khi đã lên cloud. Mã yêu cầu kiểm / phiếu kiểm / chứng nhận / mẫu lưu có tiền tố nhà máy. Chốt 04/11 (theo mockup): QC lấy mẫu lưu ra đánh giá (lý do bắt buộc — truy xuất, thu hồi, nghi lỗi…; chứng từ liên quan) → mẫu đang mở niêm phong; đánh giá xong niêm phong lại, ghi kết quả đánh giá (bắt buộc); QC sửa hạn lưu (hạn mới, lý do; gợi ý HSD + 6 tháng); hủy mẫu ghi cách hủy, người chứng kiến, biên bản (ảnh / PDF có chữ ký). Trạng thái mẫu lưu: Đang lưu (có thể đang mở niêm phong) / Hết hạn lưu / Đã hủy.
cot: QC | Hệ thống
s | 0 | 0 | S | Lô BTP đã nhập kho BTP / lô NVL cần kiểm
t1 | 0 | 1 | T | QC lấy 2 mẫu
r1 | 1 | 1 | R | Mẫu 1 → kiểm nghiệm (QT23; NVL: QT22)
t2 | 0 | 2 | T | Mẫu 2 → tạo mã mẫu lưu
y1 | 1 | 3 | Y | Ghi mẫu lưu lên hệ thống (gắn với lô)
t3 | 0 | 4 | T | Niêm phong, lưu ở kho mẫu lưu QC của nhà máy (vd NM1-MAUQC) — ghi nơi lưu mẫu (04/11) → Đang lưu
g1 | 1 | 4 | Y | Thời hạn lưu do QC tự quyết, nhập trong hệ thống (gợi ý ban đầu HSD + 6 tháng); hệ thống ghi nhận, nhắc khi hết hạn
d1 | 0 | 5 | D | Hết thời hạn lưu?
t4 | 0 | 6 | T | QC tự hủy mẫu, lập biên bản: cách hủy, người chứng kiến, biên bản ảnh / PDF có chữ ký (không cần duyệt) → Đã hủy
e | 0 | 7 | E | Kết thúc
lr | 0 | 8 | T | Lấy mẫu ra đánh giá (lý do bắt buộc: truy xuất, thu hồi, nghi lỗi…; chứng từ liên quan; ghi chú) → mẫu đang mở niêm phong (04/11)
np | 0 | 9 | T | Đánh giá xong: niêm phong lại, ghi kết quả đánh giá (bắt buộc) (04/11)
sh | 1 | 8 | T | Sửa hạn lưu: hạn mới (gợi ý HSD + 6 tháng), lý do thay đổi; ghi nhật ký (04/11)
---
s -> t1
t1 -> r1
r1 -> e
t1 -> t2
t2 -> y1
y1 -> t3
g1 -> t3 :  : n
t3 -> d1
d1 -> t3 : Chưa
d1 -> lr : Cần đánh giá lại
lr -> np
np -> d1
sh -> d1 :  : n
d1 -> t4 : Rồi
t4 -> e
```


# Mảng 7 · Truy xuất & thu hồi

## QT25. Quy trình Truy xuất nguồn gốc

Sửa 16/10: là bước con, được gọi từ QT26 Thu hồi, QC, cơ quan quản lý hoặc kiểm tra nội bộ; kết quả trả về bên yêu cầu, QT25 không tự quyết thu hồi. Mọi lần truy xuất đều có phiếu (ai, lúc nào, vì sao, mã đầu vào) để làm bằng chứng với cơ quan. Truy ngược và truy xuôi cùng gom hồ sơ QC / file đánh giá bên ngoài / mẫu lưu / NCR của mọi lô trong chuỗi; truy ngược phải ra cả lô bao bì (lon, thùng). Sau khi có chuỗi, hệ thống cân bằng khối lượng từng lô (SL vào = dùng cho SX + giao + trả NCC + hủy + mẫu lưu + tồn gồm hàng đang chuyển); lệch thì biên bản + QT17. Quyền truy xuất gán ở QT01, không định nghĩa lại ở đây. Chốt 16/10: chuỗi liên kết lô luôn đủ — sản xuất bắt buộc ghi liên kết ở từng bước (QT14 / QT15 / QT16 / QT20 / QT21), không có nhánh "đứt chuỗi" hay đối chiếu giấy. Sửa 29/10: bỏ mục tiêu thời gian truy xuất (4 giờ, tham số trace.target_hours). Người chỉ làm bước tạo phiếu (t1); từ y0 tới y6 hệ thống chạy, có kết quả trong vài giây nên mục tiêu giờ không đo được gì. Phiếu vẫn ghi thời điểm tạo và thời điểm có kết quả làm bằng chứng với cơ quan. Việc tốn thời gian người (thông báo khách, báo cơ quan) thuộc QT26 — tham số recall.complete_days. Sửa 29/10 (chiều): lô lệch khối lượng không chặn báo cáo — hệ thống ghi lô lệch vào kết quả, xuất báo cáo và trả bên yêu cầu ngay; Thủ kho lập biên bản (t3), QT17 kiểm kho chạy song song, xong thì biên bản và kết quả kiểm kho gắn bổ sung vào phiếu và báo lại bên yêu cầu. Sửa 04/11 (theo mockup): mã đầu vào thêm loại — chọn loại mã: số lô · QR lon / thùng / bao · mã đơn hàng · mã khách hàng · mã NVL; mã đơn / khách / NVL tra ra nhiều lô, người truy xuất chọn lô để chạy.

```quy-trinh
so: 25
mang: Truy xuất & thu hồi
tu: QT23
ten-ngan: Truy xuất
ten: Quy trình Truy xuất nguồn gốc
ghi-chu: Sửa 16/10: là bước con, được gọi từ QT26 Thu hồi, QC, cơ quan quản lý hoặc kiểm tra nội bộ; kết quả trả về bên yêu cầu, QT25 không tự quyết thu hồi. Mọi lần truy xuất đều có phiếu (ai, lúc nào, vì sao, mã đầu vào) để làm bằng chứng với cơ quan. Truy ngược và truy xuôi cùng gom hồ sơ QC / file đánh giá bên ngoài / mẫu lưu / NCR của mọi lô trong chuỗi; truy ngược phải ra cả lô bao bì (lon, thùng). Sau khi có chuỗi, hệ thống cân bằng khối lượng từng lô (SL vào = dùng cho SX + giao + trả NCC + hủy + mẫu lưu + tồn gồm hàng đang chuyển); lệch thì biên bản + QT17. Quyền truy xuất gán ở QT01, không định nghĩa lại ở đây. Chốt 16/10: chuỗi liên kết lô luôn đủ — sản xuất bắt buộc ghi liên kết ở từng bước (QT14 / QT15 / QT16 / QT20 / QT21), không có nhánh "đứt chuỗi" hay đối chiếu giấy. Sửa 29/10: bỏ mục tiêu thời gian truy xuất (4 giờ, tham số trace.target_hours). Người chỉ làm bước tạo phiếu (t1); từ y0 tới y6 hệ thống chạy, có kết quả trong vài giây nên mục tiêu giờ không đo được gì. Phiếu vẫn ghi thời điểm tạo và thời điểm có kết quả làm bằng chứng với cơ quan. Việc tốn thời gian người (thông báo khách, báo cơ quan) thuộc QT26 — tham số recall.complete_days. Sửa 29/10 (chiều): lô lệch khối lượng không chặn báo cáo — hệ thống ghi lô lệch vào kết quả, xuất báo cáo và trả bên yêu cầu ngay; Thủ kho lập biên bản (t3), QT17 kiểm kho chạy song song, xong thì biên bản và kết quả kiểm kho gắn bổ sung vào phiếu và báo lại bên yêu cầu. Sửa 04/11 (theo mockup): mã đầu vào thêm loại — chọn loại mã: số lô · QR lon / thùng / bao · mã đơn hàng · mã khách hàng · mã NVL; mã đơn / khách / NVL tra ra nhiều lô, người truy xuất chọn lô để chạy.
cot: Bên yêu cầu (QT26 / QC / cơ quan / nội bộ) | Người truy xuất (vai trò được giao ở QT01) | Hệ thống | Kho
s | 0 | 0 | S | Yêu cầu truy xuất: thu hồi (QT26), QC nghi lỗi, cơ quan quản lý, kiểm tra nội bộ
t1 | 1 | 1 | T | Tạo phiếu yêu cầu truy xuất: nguồn, lý do, loại mã + mã đầu vào (số lô · QR lon / thùng / bao · mã đơn hàng · mã khách hàng · mã NVL — 04/11), hướng truy
y0 | 2 | 1 | Y | Kiểm quyền (QT01); ghi nhật ký ai truy xuất, lúc nào; ghi thời điểm tạo phiếu
c1 | 3 | 1 | Y | ⚙ MẶC ĐỊNH (cấu hình lại được): lưu hồ sơ truy xuất ≥ HSD + 12 tháng (bỏ mục tiêu 4 giờ — 29/10)
y1 | 2 | 2 | Y | Tra mã → lô: QR lon → thùng → lô TP; QR bao → lô NVL / HH; số lô nhập tay thì kiểm tồn tại; mã đơn hàng → các lô TP đã giao / phân bổ cho đơn; mã khách → các lô khách đã nhận; mã NVL → các lô của NVL — nhiều lô thì người truy xuất chọn lô
d2 | 2 | 3 | D | Hướng truy?
y2 | 2 | 4 | Y | Ngược (từ lô TP): phiếu xuất ← lô TP ← thùng / lon ← mẻ (hồ sơ mẻ, thông số, công nhân, cân, công thức) ← silo / bao HH ← lô NVL + lô bao bì (lon, thùng) ← PO, NCC, file đánh giá bên ngoài
y3 | 2 | 5 | Y | Xuôi (từ lô NVL / HH / bao bì): mẻ đã dùng → lô BTP / TP → lon / thùng → phiếu xuất → khách + SL đã nhận; phần còn tồn kho (gồm hàng đang chuyển), đã hủy, đã trả NCC
y4 | 2 | 6 | Y | Gom hồ sơ của mọi lô trong chuỗi: phiếu QC (QT22 / QT23), file đánh giá bên ngoài, mẫu lưu (QT24), NCR, trạng thái lô hiện tại
y5 | 2 | 7 | Y | Cân bằng khối lượng từng lô: SL vào (nhập kho / sản xuất ra) = dùng cho SX + giao khách + trả NCC + hủy + mẫu lưu + tồn (gồm hàng đang chuyển)
d4 | 2 | 8 | D | Khớp?
yl | 2 | 9 | Y | Ghi lô lệch (lô, SL lệch) vào kết quả; báo Thủ kho lập biên bản — không chờ, báo cáo xuất ngay
y6 | 2 | 10 | Y | Xuất báo cáo truy xuất: chuỗi lô, danh sách khách + SL đã nhận (đầu vào QT26), hồ sơ QC, kết quả cân bằng (lô lệch ghi "đang kiểm kho"), thời điểm tạo phiếu và thời điểm có kết quả
e | 1 | 11 | E | Trả kết quả về bên yêu cầu; lưu hồ sơ truy xuất, không xóa
t3 | 3 | 10 | T | Thủ kho lập biên bản chênh lệch: lô, SL lệch, nguyên nhân nếu rõ (song song, sau khi đã trả kết quả)
r0 | 3 | 11 | R | QT17: Kiểm kho lô chênh lệch
yb | 2 | 12 | Y | Gắn biên bản + kết quả kiểm kho vào phiếu truy xuất (bổ sung, không đổi chuỗi lô / khách); báo lại bên yêu cầu
e2 | 2 | 13 | E | Đóng nhánh lệch
---
s -> t1
t1 -> y0
c1 -> y0 :  : n
y0 -> y1
y1 -> d2
d2 -> y2 : Ngược
d2 -> y3 : Xuôi
y2 -> y4
y3 -> y4
y4 -> y5
y5 -> d4
d4 -> y6 : Khớp
d4 -> yl : Lệch
yl -> y6
yl -> t3 : song song
t3 -> r0
r0 -> yb
yb -> e2
y6 -> e
```

## QT26. Quy trình Thu hồi sản phẩm

Tách từ QT22 cũ (phần thu hồi). Sửa 16/10: điểm vào gồm cả nội bộ — khách / đại lý báo lỗi cả lô (QC kết luận), QT23 không đạt sau khi lô đã giao, QT25 phát hiện, NVL lỗi đã dùng (QT22 / QT13), cơ quan yêu cầu. Thứ tự: KHÓA lô nghi lỗi → QT25 truy xuất (nguyên nhân + lô liên quan + khách) → KHÓA thêm lô liên quan → đánh giá rủi ro, phạm vi → GĐ quyết thu hồi hay chỉ khoanh vùng → báo cơ quan (bắt buộc theo luật) → thông báo khách theo danh sách QT25 → nhập kho hàng thu hồi giữ KHÓA → theo dõi % thu hồi → hủy (không tái chế) → đổi lô mới / hoàn tiền → nguyên nhân gốc, CAPA → đóng hồ sơ. Hồ sơ lưu ≥ HSD + 12 tháng. Chốt 17/10: chỉ QC trưởng mở hồ sơ thu hồi (mở là hệ thống khóa cả lô ngay); QC trưởng đánh giá rủi ro và báo cơ quan; CSKH thông báo khách; Sales đổi lô / hoàn tiền (số tiền GĐ hoặc KTT duyệt như hủy đơn); QC trưởng duyệt CAPA; GĐ duyệt đóng hồ sơ. Sửa 20/10 (đợt 2 — offline): khóa lô (y1, y2, yv) là lệnh từ trung tâm tới từng nhà máy đang giữ phần lô; hồ sơ hiện Đã áp dụng / Chờ nhà máy áp dụng. Sau 10/11: QC trưởng tại nhà máy có thao tác "khóa cả lô — khoanh vùng" tại chỗ, gắn hồ sơ khi có mạng (chưa vẽ).

```quy-trinh
so: 26
mang: Truy xuất & thu hồi
tu: QT22 (phần thu hồi)
ten-ngan: Thu hồi
ten: Quy trình Thu hồi sản phẩm
ghi-chu: Tách từ QT22 cũ (phần thu hồi). Sửa 16/10: điểm vào gồm cả nội bộ — khách / đại lý báo lỗi cả lô (QC kết luận), QT23 không đạt sau khi lô đã giao, QT25 phát hiện, NVL lỗi đã dùng (QT22 / QT13), cơ quan yêu cầu. Thứ tự: KHÓA lô nghi lỗi → QT25 truy xuất (nguyên nhân + lô liên quan + khách) → KHÓA thêm lô liên quan → đánh giá rủi ro, phạm vi → GĐ quyết thu hồi hay chỉ khoanh vùng → báo cơ quan (bắt buộc theo luật) → thông báo khách theo danh sách QT25 → nhập kho hàng thu hồi giữ KHÓA → theo dõi % thu hồi → hủy (không tái chế) → đổi lô mới / hoàn tiền → nguyên nhân gốc, CAPA → đóng hồ sơ. Hồ sơ lưu ≥ HSD + 12 tháng. Chốt 17/10: chỉ QC trưởng mở hồ sơ thu hồi (mở là hệ thống khóa cả lô ngay); QC trưởng đánh giá rủi ro và báo cơ quan; CSKH thông báo khách; Sales đổi lô / hoàn tiền (số tiền GĐ hoặc KTT duyệt như hủy đơn); QC trưởng duyệt CAPA; GĐ duyệt đóng hồ sơ. Sửa 20/10 (đợt 2 — offline): khóa lô (y1, y2, yv) là lệnh từ trung tâm tới từng nhà máy đang giữ phần lô; hồ sơ hiện Đã áp dụng / Chờ nhà máy áp dụng. Sau 10/11: QC trưởng tại nhà máy có thao tác "khóa cả lô — khoanh vùng" tại chỗ, gắn hồ sơ khi có mạng (chưa vẽ).
cot: Giám đốc | QC trưởng | QC | Kho | CSKH | Sales | Khách / Đại lý | Hệ thống
s | 2 | 0 | S | Lô nghi lỗi cả lô: khách / đại lý báo lỗi, QC kết luận lỗi cả lô; QT23 KHÔNG ĐẠT sau khi đã giao; QT25 phát hiện; NVL lỗi đã dùng (QT22 / QT13); cơ quan yêu cầu
o1 | 1 | 1 | T | QC trưởng xác nhận lỗi cả lô, mở hồ sơ thu hồi (chỉ QC trưởng)
y1 | 7 | 2 | Y | Khóa cả lô nghi lỗi, lý do khoanh vùng — lập lệnh KHÓA LÔ gửi tới từng nhà máy đang giữ phần lô (kênh lệnh từ trung tâm); hồ sơ hiện từng nhà máy: Đã áp dụng HH:MM / Chờ nhà máy áp dụng (nhà máy mất mạng → QC trưởng gọi điện); có mạng: nhà máy khóa phần còn, phần đã dùng → QT19 kz, phần đã giao → danh sách khách (t1); chặn xuất / giao (QT15 / QT09); tạo hồ sơ thu hồi (nguồn, lô, ngày)
r1 | 2 | 3 | R | QT25: Truy xuất ngược (nguyên nhân: NVL / mẻ / bao bì) + xuôi (lô liên quan, khách đã nhận, SL)
y2 | 7 | 4 | Y | Khóa thêm (lệnh KHÓA LÔ tới từng nhà máy, như y1) mọi lô liên quan theo kết quả truy xuất (cùng lô NVL / cùng mẻ / cùng ca / cùng lô bao bì), lý do khoanh vùng; lô sinh ra khi mất kết nối (QT19) và NVL dư trả về (QT14) của các lô này tự vào danh sách
q1 | 1 | 5 | T | QC trưởng đánh giá rủi ro: mức nguy hại, phạm vi (còn trong kho / đại lý / tới người dùng), SL ngoài thị trường; đề xuất thu hồi hay khoanh vùng
d1 | 0 | 6 | D | GĐ quyết định?
c1 | 0 | 7 | Y | Mức nguy hại nào phải thu hồi do nhà máy tự quyết, GĐ ký; hệ thống chỉ ghi nhận mức nguy hại và quyết định. ⚙ MẶC ĐỊNH (cấu hình lại được): hoàn thành thu hồi trong 30 ngày kể từ quyết định
r5 | 2 | 7 | R | QT23: QC kiểm lại từng lô bị khóa (đạt → mở khóa; không đạt → hủy phần trong kho; TP đã giao một phần mà không đạt → quay lại GĐ quyết định)
yv | 7 | 8 | Y | Đổi lý do khóa của mọi lô trong hồ sơ → "thu hồi" (chỉ còn đường hủy, không cho gửi QC) — lệnh tới từng nhà máy, như y1
t0 | 1 | 9 | T | QC trưởng báo cơ quan quản lý: quyết định thu hồi, lô, phạm vi, kế hoạch; cập nhật tiến độ theo yêu cầu (bắt buộc theo luật)
t1 | 4 | 10 | T | Thông báo khách / đại lý theo danh sách từ QT25: lô, SL, lý do, cách trả hàng; ghi thời điểm thông báo
t2 | 6 | 11 | T | Ngừng bán, gom hàng, gửi về
r2 | 3 | 12 | R | QT14: Nhập kho hàng thu hồi — lô KHÓA lý do thu hồi, không vào tồn bán; ghi SL thu về theo khách (nhập tại máy chủ nhà máy theo hồ sơ đã sao xuống)
y3 | 7 | 13 | Y | Theo dõi tiến độ: SL thu về / SL đã giao từng khách; % thu hồi; nhắc khách chưa trả
d2 | 7 | 14 | D | Thu về đủ\nhoặc hết hạn thu hồi?
r4 | 3 | 15 | R | QT18: Hủy hàng (biên bản, người chứng kiến, báo cơ quan nếu cần)
t3 | 5 | 16 | T | Đổi lô mới / hoàn tiền cho khách: tạo đơn thay thế (QT05) hoặc hoàn tiền (số tiền GĐ hoặc KTT duyệt như hủy đơn; Kế toán ghi nhận ở QT10, không duyệt thêm); ghi vào hồ sơ
q3 | 2 | 17 | T | Nguyên nhân gốc, hành động khắc phục (NCR / CAPA): NVL → QT13 trả NCC; SX → sửa công thức / thiết bị / thao tác (QT03, QT20, QT21); bao bì → NCC bao bì
qa | 1 | 18 | D | QC trưởng\nduyệt CAPA?
gd | 0 | 19 | T | Giám đốc duyệt đóng hồ sơ thu hồi
y4 | 7 | 20 | Y | Đóng hồ sơ thu hồi: quyết định, phạm vi, % thu hồi, xử lý lô, báo cáo cơ quan, CAPA; lưu ≥ HSD + 12 tháng, không xóa
e | 7 | 21 | E | Kết thúc
---
s -> o1
o1 -> y1
y1 -> r1
r1 -> y2
y2 -> q1
q1 -> d1
c1 -> d1 :  : n
d1 -> r5 : Khoanh vùng, không thu hồi
r5 -> gd : Đạt / hủy xong
r5 -> d1 : Không đạt, đã giao một phần
d1 -> yv : Thu hồi
yv -> t0
t0 -> t1
t1 -> t2
t2 -> r2
r2 -> y3
y3 -> d2
d2 -> t2 : Chưa → nhắc khách
d2 -> r4 : Đủ / hết hạn
r4 -> t3
t3 -> q3
q3 -> qa
qa -> q3 : Không → sửa
qa -> gd : Duyệt
gd -> y4
y4 -> e
```
