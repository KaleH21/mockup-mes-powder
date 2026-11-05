# MES Powder — Sơ đồ dữ liệu (thực thể, bảng, quan hệ)

Cập nhật: 04/11/2026 — đồng bộ theo mockup (mockup là bản đúng; ngày chốt theo ghi chú trong mockup 30/10, 31/10, 03/11, còn lại chốt 04/11): 140 bảng — chi tiết ở dòng "Thay đổi 04/11" dưới. Trước đó 29/10/2026 — bỏ mục tiêu thời gian truy xuất (QT25 do hệ thống chạy, có kết quả ngay): `trace_request` bỏ `target_hours`, chỉ ghi thời điểm tạo / có kết quả; bỏ tham số `trace.target_hours`. Trước đó 28/10/2026 — bỏ vai trò Trưởng bộ phận và rà soát quyền hằng quý: bỏ `access_review`, `access_review_line`, trigger xác nhận rà soát, 2 tham số rà soát; `catalog_retire_request` thêm trạng thái NGUNG_TRUC_TIEP (Kế hoạch tự ngừng), `department` thành mã; 135 bảng. Trước đó 26/10/2026 — mẫu lưu bỏ tủ / ngăn và điều kiện bảo quản: bỏ `sample_storage_condition`, `retained_sample` bỏ `storage_position`, `storage_condition_id`, thêm `note`; 137 bảng. Trước đó 24/10/2026 (đợt 9) — bỏ vị trí kệ: tồn theo lô × kho, trạng thái theo bao qua dòng tồn, hàng đang chuyển nằm trên phiếu chuyển; bỏ cảnh báo cận date, thêm ngưỡng hạn tối thiểu cho sản xuất; 138 bảng. Trước đó 24/10 — giao hàng chỉ ghi nhận: bỏ đợt giao (`delivery`, `delivery_line`) → yêu cầu xuất bán từ đơn (`sales_issue_request`, dòng), ghi nhận giao theo phiếu xuất bán (`delivery_note.goods_issue_id`), một đơn nhiều hóa đơn (`sales_order_invoice`), bỏ khách "mất"; 141 bảng. Trước đó 20/10/2026 (đợt 3) — chốt câu 35–37: bản sao khách / đơn xuống nhà máy giữ khóa ngoại nhưng bỏ cột tiền, liên hệ, công nợ; QC trưởng khóa cả lô tại nhà máy khi mất mạng, chỉ mở trên cloud; nhận chuyển kho chưa có phiếu (sau 10/11); mã công thức 4 số. Đợt 2: chủ dữ liệu theo dòng cloud ↔ máy chủ nhà máy (máy chủ nhà máy chủ tồn, lô, chứng từ kho, QC, mẻ; cloud chủ danh mục, đơn, PO, lệnh, thu hồi), kênh lệnh từ trung tâm, hàng đợi gửi lên cho mọi bảng nhà máy chủ; trước đó 20/10/2026 — Admin không còn toàn quyền, menu suy ra từ quyền (bảng `screen`, `screen_function`, view `v_user_screen`); 19/10/2026 — đợt 4 (danh mục SP tách thương hiệu / dòng / hạng / quy cách, đề nghị chuyển kho tự lập từ lệnh SX, xuất SX chỉ từ kho điều phối); đợt 3 (nút silo trong chuỗi lô, sửa / hủy / kết thúc sớm lệnh, hàng đợi, trả NCC); đợt 2 (khu vực làm việc & dàn silo, lệnh SX, bỏ máy quét riêng, mua hàng / kho; trước đó đồng bộ quyết định giai đoạn mockup 17–19/10 và 17/10 lần 2 — khớp mục "Vai trò × Chức năng"). Nguồn nghiệp vụ: `claude/mes-powder-quy-trinh.md` (26 QT / 7 mảng, mục "Vòng đời lô hàng", "Biểu mẫu dữ liệu", "Tham số mặc định", nhật ký sửa 16–17/10). Stack: NestJS + PostgreSQL. Hệ thống 2 phần: cloud (trung tâm) và server tại từng nhà máy (2 nhà máy, chạy được khi mất kết nối).

**Cách dùng file này**
- Mục 1–9: quy tắc chung, quyết định thiết kế, cloud ↔ nhà máy, lô, liên kết lô + 3 truy vấn, ô chờ quyết, điểm nối IoT, tham số, câu hỏi.
- Mục 10: chi tiết từng bảng (mục đích, nơi, QT, cột, khóa, unique, check).
- `claude/mes-powder-du-lieu.sql`: DDL + trigger + dữ liệu nạp, sinh từ cùng một nguồn với mục 10, **đã chạy trên PostgreSQL 16** (lần cuối 20/10; bản 04/11 chạy sạch trên PostgreSQL 18 trống). Chuỗi dữ liệu mẫu NVL → khách cho 3 truy vấn ở mục 5.1–5.3 chạy 17/10; phép thử ràng buộc (mục 5.4–5.9) nằm ở `claude/mes-powder-phep-thu.sql`, chạy lại 19/10 (đợt 4) sau file DDL. Phần DDL và mục 10 sinh cùng lúc bằng `claude/mes-powder-gen-du-lieu.py` từ mô hình bảng `claude/mes-powder-mo-hinh-du-lieu.json` (cùng nội dung với dòng `MODEL` của trang sơ đồ dữ liệu); dữ liệu nạp quyền sinh bằng `claude/mes-powder-gen-quyen.py` từ file quy trình; trigger và dữ liệu nạp khác viết tay. Ghép: `python3 mes-powder-gen-du-lieu.py mes-powder-mo-hinh-du-lieu.json <thư mục ra> --ghep mes-powder-du-lieu.md mes-powder-du-lieu.sql seed_quyen.sql` (giữ phần viết tay, thay phần sinh).
- Thay đổi 17/10 (lần 2): thêm 4 bảng — `user_delegation` (ủy quyền tạm), `code_format` (định dạng mã danh mục), `catalog_retire_request` (đề nghị ngừng mã, Trưởng BP bên đề xuất duyệt), `batch_cancellation` (hủy mẻ do sự cố); bỏ `supplier_sample_eval` (bỏ đánh giá mẫu NCC). Nạp sẵn 19 vai trò, 196 thao tác và bảng Vai trò × Thao tác đúng mục "Vai trò × Chức năng". Thêm loại lô HONG (bột hỏng của mẻ hủy) và 1 dòng chuyển trạng thái (38 dòng). Thêm người duyệt: Kế toán trưởng duyệt phiếu chi; Trưởng BP Mua hàng hủy PO đã duyệt; Thủ kho trưởng xác nhận thất lạc; QC trưởng duyệt CAPA, đánh giá rủi ro thu hồi; GĐ duyệt đóng hồ sơ thu hồi; GĐ / KTT duyệt số tiền hoàn khi thu hồi. Bộ chỉ tiêu BTP / TP, điều kiện bảo quản và hạn lưu mẫu thôi chờ quyết (QC tự quyết, phần mềm ghi nhận); mẫu lưu hết hạn QC tự hủy, không qua phiếu hủy.
- Thay đổi 19/10 (giai đoạn mockup): thêm 2 bảng — `access_review_line` (rà soát hằng quý theo từng tài khoản), `payment_allocation` (cấn tiền ghi nhận vào khoản); bỏ `sales_invoice` (hóa đơn thu gọn thành 3 cột trên `delivery`). `payment_voucher` thành bản ghi nhận thu / chi (bỏ trạng thái chờ duyệt, `approved_by`, số kỳ vọng, các check duyệt); `ar_entry` bỏ loại XOA_NO; `payment_schedule` thêm kết quả xử lý nợ quá 90 ngày. Danh mục còn 4 loại: `catalog_retire_request` chỉ NVL / SP, thêm DA_RUT (người đề xuất rút); `location` thêm lần in tem QR, trigger chặn ngừng dùng ô còn hàng; `code_format` thêm công thức `CT-{loai}-{so:2}`, bỏ thiết bị đo; `formula.code` check định dạng. `equipment` chỉ còn thiết bị SX nạp khi triển khai (bỏ loại THIET_BI_DO và 3 cột thiết bị đo). Sự cố tem: `label_incident` thêm ô, lô, cờ hủy-sang-mất, quét xác nhận; `scan_log` thêm mã thay thế. Quyền: 208 thao tác, 246 dòng gán (trước 196 / 229); `role.delegable` theo danh sách chốt 7 vai trò. 3 trigger mới (cấn tiền, xác nhận rà soát, ngừng dùng ô). Tham số thêm `account.review_idle_hint_days`; quy tắc mật khẩu cố định trong code, không có trong `system_parameter`.
- Thay đổi 19/10 (đợt 2): thêm 1 bảng — `production_order_silo` (phương án dàn silo của lệnh: lệnh, NVL, silo). Silo **không tách bảng**: thêm cột vào `equipment` (sức chứa, gán cứng NVL, trạng thái BAO_TRI; silo bắt buộc khu, sức chứa, mã SCADA) — lý do ở quyết định 22. `work_area` thêm khối lượng mẻ tối đa (bắt buộc với HH / BTP), bỏ loại KHAC. `production_order` thêm khu, thứ tự hàng đợi, trạng thái phương án silo, số lần sửa gửi lại nhà máy; giấy tờ xuất xứ NVL thành bắt buộc. `production_order_brand` thêm số lô in trên lon, dòng đơn nguồn. `batch_material_scan.silo_equipment_id` thôi chờ quyết (theo phương án silo). Bỏ máy quét: `user_session` bỏ MAY_QUET, quét thẻ chỉ ở PC xưởng; `label_incident` tem mất bắt buộc ô (từ dòng tồn). Mua hàng: điều khoản thanh toán NCC / báo giá tách kiểu + số ngày; `quotation` thêm trạng thái, lý do hủy; `supplier_return` thêm CHO_KHO_XUAT_TRA + người / lúc gửi yêu cầu xuất trả; `goods_issue` thêm CHO_BEN_YEU_CAU + người quyết của bên yêu cầu. 12 trigger mới + 1 hàm kiểm phương án silo (mục 10–15 phần viết tay của file sql) + 1 ràng buộc loại trừ (hàng đợi). Quyền: 216 thao tác, 256 dòng gán (trước 208 / 246). Phép thử mới ở mục 5.7.
- Thay đổi 19/10 (đợt 3 — chốt câu hỏi đợt 2): vẫn 131 bảng. Silo nạp một lần dùng cho nhiều mẻ → `lot` thêm loại SILO (nút silo của lệnh: lệnh, silo, thời điểm xả sạch), `lot_link` bỏ DO_VAO_ME, thêm NAP_SILO (lô → nút silo) và XA_SILO (nút silo → lô mẻ), NVL_DU nhận cả bột dư từ nút silo, bỏ cột ⏸ `silo_equipment_id`; `batch_material_scan` đổi tên `silo_charge` (quét bao nạp silo, có nút silo). `production_order`: bỏ 2 cột bản sửa (lệnh đã phát không sửa), thêm yêu cầu hủy + xác nhận của nhà máy, kết thúc sớm (thời điểm, người, lý do, số mẻ thực tế); hàng đợi gồm lệnh Mới tạo + Chờ phát. `supplier_return.purchase_order_id` bắt buộc. Trigger: sửa 7 hàm (loại liên kết lô, silo, phương án silo, lệnh, nhãn hiệu, quét nạp silo, dòng trả NCC) + ràng buộc hàng đợi; thêm 3 trigger (nạp / xả qua nút silo, đóng nút silo, chặn mẻ mới khi silo bảo trì) + hàm tính bột trong silo. Quyền: 219 thao tác, 259 dòng gán. Phép thử mới ở mục 5.8; 5.4 sửa 2, 5.7 viết lại 7 phép theo chốt mới.
- Thay đổi 19/10 (đợt 4 — tối 19/10, chốt sau rà soát mockup): 136 bảng (+5 ở Nền tảng). Danh mục SP: thêm `brand` (thương hiệu), `product_line` (dòng SP), `product_grade` (hạng), `product_line_grade` (hạng áp dụng của dòng), `pack_spec` (quy cách đóng gói); `product` thay `brand_name` bằng khóa ngoại tới thương hiệu, thêm dòng, hạng, quy cách; `code_format` thêm 4 loại mã; `catalog_retire_request` nhận cả 4 danh mục mới. Bộ chỉ tiêu thành phẩm vẫn là `product_spec_item` gắn từng SP (bộ chuẩn Chất lượng dùng). NVL cho SX đi qua kho điều phối: `stock_transfer` thêm lệnh nguồn `source_order_id`, cờ `auto_drafted`, trạng thái DE_NGHI (hệ thống tự lập, chờ Kế hoạch gửi) và DA_HUY, người / lúc gửi; `requested_by` = Kế hoạch; `stock_transfer_line` thêm `material_id`, `lot_id` chỉ bắt buộc từ lúc xuất. Đã sinh lại `mes-powder-mo-hinh-du-lieu.json` (thêm khóa tùy chọn `trg` / `uNote` để mục 10 hiện dòng Trigger và ghi chú Unique), DDL và dữ liệu nạp quyền: 221 thao tác, 261 dòng gán (trước 219 / 259) — QT16 ya / kg, QT19 dc / yd / tg / d2 của Kế hoạch thay QT19 d2 / r1 của Thủ kho; Thủ kho thêm tạo ở QT20 t0 / t1 (lập phiếu xuất SX từ kho điều phối). `code_format` nạp thêm 4 mẫu mã (chốt 19/10 tối: THH- / DSP- / QCD- / HSP-). Trigger mới (mục 16–17 phần viết tay của file sql): SP đúng 4 danh mục, chặn ngừng dùng thương hiệu / dòng / hạng / quy cách khi còn SP ĐANG DÙNG, chặn bỏ hạng khỏi dòng / bỏ số lượng khỏi quy cách (và đổi KL tịnh quy cách) khi còn SP dùng; đề nghị tự lập (kho TONG → DIEU_PHOI cùng nhà máy, lệnh còn mở, DE_NGHI chỉ sang CHO_XAC_NHAN / DA_HUY, người gửi giữ vai trò Kế hoạch, mọi dòng có lô trước DA_XUAT, lô đúng NVL); lệnh DA_HUY / HOAN_THANH → đề nghị DE_NGHI → DA_HUY; mục 15 thêm: phiếu xuất SAN_XUAT chỉ từ kho DIEU_PHOI. Sửa check của `stock_transfer` cho khỏi mâu thuẫn với trigger tự hủy: `auto_drafted = false or status in ('DE_NGHI', 'DA_HUY') or sent_at is not null` (bản sửa tay ghi `status = 'DE_NGHI'` — đề nghị bị hủy khi chưa gửi sẽ bị chặn). Phép thử mới ở mục 5.9.
- Thay đổi 20/10 (phân quyền & menu — chốt sau rà soát phân quyền trên mockup): 138 bảng (+2 ở Nền tảng) — `screen` (34 màn của menu web, 10 phân hệ) và `screen_function` (màn × chức năng, 247 dòng; cột `warehouse_type` để thủ kho kho điều phối mới thấy Lệnh SX, Theo dõi mẻ); thêm view `v_user_screen` (màn mỗi người dùng thấy) và trigger kiểm chức năng của màn có trong bảng quyền. Admin không còn được thêm mọi thao tác: chỉ quản trị + `QT01.xa` (xem mọi màn, cùng Giám đốc). Bảng quyền: 226 thao tác, 280 dòng gán (Admin 15). Phép thử mục 5.10 ở `claude/mes-powder-phep-thu-20-10.sql` (20 / 20 đúng); 2 phép đếm cũ 5.7 Q2, 5.9 Q7 thay bằng 5.10 Q2.
- Thay đổi 20/10 (đợt 2 — hướng mất kết nối không giới hạn; chốt phương án B + câu 1a: Kế hoạch ở văn phòng, lệnh chỉ tạo trên cloud): chủ dữ liệu theo DÒNG (quyết định 34): bảng nhóm kho / lô / QC / xưởng (49 bảng) do máy chủ nhà máy của dòng làm chủ, cloud giữ bản đồng bộ; cloud chủ danh mục, tài khoản, bán hàng, mua hàng, kế toán, lệnh SX, thu hồi, truy xuất (56 bảng sao xuống phần nhà máy cần, 29 bảng chỉ cloud). Một schema, một mã nguồn cho cả cloud và nhà máy; bảng mới `sync_policy` ghi nhóm từng bảng, sinh từ cột "Nơi" của mô hình (trường `site` = CLOUD / CLOUD_ONLY / NM / NM_ONLY / NOI_PHAT_SINH, `derived` = cột dẫn xuất). 140 bảng: thêm `sync_policy`, `site_command` (kênh lệnh từ trung tâm, quyết định 35), `command_inbox` (sổ lệnh đã nhận ở nhà máy); `sync_event` đổi thành `sync_outbox` (ghi mọi thay đổi trên bảng nhà máy chủ, quyết định 36); bỏ `lot_status_replica` (nhà máy có tồn thật). `lot` bỏ 2 cột cận date → view `v_lot_expiry`; `lot_lock` thêm nhà máy áp dụng + mã lệnh; `sync_conflict` ghi tại nhà máy (bỏ khóa ngoại tới inbox của cloud); `batch_cancellation` thêm mã lệnh HUY_ME; `stock_transfer` thêm cờ xác nhận lúc mất mạng (QT16 kq); `stocktake` thêm nguồn KHOI_TAO_LAI; `code_format` thêm 9 mẫu mã chứng từ nhà máy (quyết định 37); `downstream_change` bỏ op KHOA. Trigger mới (mục 18–21 phần viết tay của file sql): chặn ghi sai nơi, ghi hàng đợi gửi lên trong cùng giao dịch, trạng thái lệnh chỉ đi tới + chiếu kết quả nhà máy sang lệnh. Tham số: bỏ `offline.max_hours`, thêm `sync.outbox_retain_days`, `sync.clock_skew_warn_minutes`. Quyền: thêm QT16.kq (Thủ kho trưởng), bỏ QT20.d1 (Kế hoạch) — vẫn 226 thao tác, 280 dòng gán. Phép thử mục 5.11 ở `claude/mes-powder-phep-thu-20-10-dot2.sql` (42 / 42 đúng); 5.10 chạy lại 20 / 20.
- Thay đổi 20/10 (đợt 3 — chốt câu 35–37): vẫn 140 bảng. `sync_policy` thêm cột `masked_columns` — cột cloud chủ nhưng không sao xuống máy chủ nhà máy (quyết định 38): khách hàng 13 cột (MST, mã ĐKKD, người liên hệ, chức vụ, SĐT, email, địa chỉ liên hệ, tài khoản ngân hàng, cách thanh toán mặc định, hạn mức, cờ / lúc khóa nợ, lúc mất khách), đơn 2 cột (số hoàn, số giữ lại), phiên bản đơn 7 cột (cách thanh toán, % cọc, số ngày nợ, 3 cột tiền, file HĐ), dòng đơn 2 cột (đơn giá, thuế suất), đợt giao 4 cột (giá trị đợt, số / ngày / file hóa đơn). 9 cột vốn bắt buộc (SĐT khách, cờ khóa nợ, cách thanh toán, % cọc, 3 cột tiền, đơn giá, thuế suất) nới ở mức bảng, bắt buộc lại bằng trigger `trg_masked_required` khi ghi ở cloud / công cụ nạp. Hàm `sync_down_row(bảng, dòng)` bỏ các cột đó trước khi sao xuống. Mục 22 phần viết tay của file sql. Câu 35, 36 (sau 10/11) chốt cách làm, chưa đổi bảng. Câu 32 chốt giữ 1 mã SP / quy cách × số lon (không đổi bảng). Mã công thức đổi 2 → 4 số: `CT-{loai}-{so:4}` (check `formula.code` `-[0-9]{4,}$`, `code_format` CT). Phép thử mục 5.12 ở `claude/mes-powder-phep-thu-20-10-dot3.sql` (16 / 16 đúng); 5.10, 5.11 chạy lại 20 / 20, 42 / 42.
- Ký hiệu: ⏸ = chờ quyết (chỉ chừa chỗ, chưa thiết kế nghiệp vụ). Tên bảng / cột tiếng Anh snake_case; giá trị trạng thái viết mã không dấu (CHO_KIEM = CHỜ KIỂM…).

- Thay đổi 24/10 (giao hàng chỉ ghi nhận — file quy trình mục "Sửa 24/10"): 141 bảng. Đổi tên `delivery` → `sales_issue_request` (yêu cầu xuất bán Sales lập từ đơn, xuất từng phần, 1 yêu cầu = 1 phiếu xuất bán; bỏ địa chỉ, chờ liên hệ, 3 cột hóa đơn; trạng thái CHO_THANH_TOAN / CHO_XUAT / DA_XUAT / DA_GHI_NHAN / DA_HUY), `delivery_line` → `sales_issue_request_line`. `goods_issue.delivery_id` → `sales_issue_request_id`; `delivery_note` gắn `goods_issue_id` (1 phiếu xuất bán = 1 ghi nhận, `signed_at` bắt buộc = ngày khách nhận; trigger `trg_delivery_note`: chỉ phiếu BAN đã xuất — mục 23 phần viết tay của file sql). Bảng mới `sales_order_invoice` (CLOUD_ONLY — số, ngày, file; một đơn nhiều hóa đơn, không gắn phiếu xuất; trả lời câu 19). `payment_schedule.delivery_id` → `sales_issue_request_id`; `ar_entry.delivery_id` → `delivery_note_id` (công nợ theo lần ghi nhận); `trace_result_customer.delivery_id` → `goods_issue_id`; `customer_contact_log` bỏ `delivery_id` (chỉ nhắc nợ). Khách bỏ trạng thái MAT và `lost_at` (masked còn 12 cột). Tham số: bỏ `delivery.contact_wait_days`, `delivery.reschedule_free_days`, `customer.lost_after_days`; giữ `delivery.payment_wait_days` (14 ngày). Quyền: 223 thao tác, 277 dòng gán, 33 màn (bỏ `BAN_GIAO_HANG`, chức năng QT09 sang `BAN_DON_HANG`). Phép thử mục 5.13 ở `claude/mes-powder-phep-thu-24-10.sql` (19 / 19 đúng) — thay các phép cũ dính đợt giao / số đếm (ghi ở đầu file đó).

- Thay đổi 24/10 (đợt 3 — yêu cầu xuất bán): `sales_issue_request` thêm trạng thái BI_TRA_VE (máy chủ nhà máy không lập được phiếu vì lô không còn đủ) + `return_reason`, cột hủy `cancel_reason`, `cancelled_by`, `cancelled_at` (check bắt buộc lý do). Trigger `trg_sales_issue_line`: dòng lấy lô gắn đơn, cùng nhà máy với yêu cầu, đúng SP của dòng đơn, tổng SL các yêu cầu chưa hủy ≤ SL gắn đơn; `trg_goods_issue_ban`: phiếu xuất bán chỉ lập (máy chủ nhà máy tự lập) từ yêu cầu Chờ xuất, đúng nhà máy và đơn, và vào thẳng Đã duyệt — không Thủ kho trưởng duyệt (đợt 4) — mục 23b phần viết tay của file sql. Lịch thanh toán: mỗi yêu cầu tách khoản trả nốt riêng = giá trị phần xuất × (1 − % cọc) (`payment_schedule.sales_issue_request_id`, dòng gốc THAY_THE). Quyền theo file quy trình 24/10 (đợt 2 bỏ thao tác vị trí kệ — bảng `location`, `stock_relocation` chưa bỏ ở mô hình; đợt 3 thêm QT09.tr): 219 thao tác, 273 dòng gán. 5.13 chạy lại 29 / 29.
- Thay đổi 24/10 (đợt 5 — xuất SX không duyệt): trigger `trg_goods_issue` bắt phiếu xuất SX (`SAN_XUAT`) lập ra ở DA_DUYET, `approved_by` trống — Thủ kho trưởng chỉ còn duyệt phiếu chuyển kho, trả NCC (phép thử mục 5.13 X1–X3).
- Thay đổi 24/10 (đợt 6 — bỏ duyệt phiếu xuất): `goods_issue` bỏ trạng thái CHO_DUYET / TU_CHOI và cột `approved_by`, `approved_at`, `reject_reason`, mặc định DA_DUYET; trigger `trg_goods_issue` bắt mọi phiếu xuất lập ra ở DA_DUYET (duyệt nằm ở chứng từ gốc). `supplier_return` thêm trạng thái CHO_DUYET_XUAT_TRA và `export_approved_by`, `export_approved_at`, `export_reject_reason`: Mua hàng gửi yêu cầu xuất trả → CHO_DUYET_XUAT_TRA; Trưởng BP Mua hàng (không phải người gửi) duyệt → CHO_KHO_XUAT_TRA, từ chối bắt buộc lý do → MO (trigger `trg_supplier_return`). Quyền: bỏ QT15.d1, thêm QT13.dx — 217 thao tác, 271 dòng gán. Phép thử mục 5.13 X1–X3, R1–R8 (41 / 41 đúng).
- Thay đổi 24/10 (đợt 7 — trạng thái phiếu xuất, phiếu nhập không duyệt): `goods_issue` đổi DA_DUYET thành CHO_LAY_HANG (mặc định), thêm DANG_LAY_HANG — quét bao / thùng đầu tiên thì tự chuyển (trigger `trg_goods_issue_scan_start`); CHO_BEN_YEU_CAU / DA_XUAT chỉ từ DANG_LAY_HANG. `goods_receipt` trạng thái CHO_NHAN_HANG (tự sinh, mặc định) / DANG_NHAN / CHO_XAC_NHAN_LECH / DA_NHAP / DA_HUY, bỏ `approved_by`, `approved_at`, `reject_reason`, thêm `discrepancy_confirmed_by`, `discrepancy_confirmed_at`, `discrepancy_note`, `recount_reason`; trigger `trg_goods_receipt`: DA_NHAP thẳng chỉ khi không lệch (SL nhận = dự kiến, không bao hư), lệch phải qua CHO_XAC_NHAN_LECH → Thủ kho trưởng (không phải người lập) xác nhận; đếm lại bắt buộc lý do; quét bao đầu tiên → DANG_NHAN (`trg_goods_receipt_scan_start`). Phép thử 5.13 S1–S6, N1–N10 (57 / 57 đúng).

- Thay đổi 24/10 (đợt 9 — bỏ vị trí kệ, bỏ cận date, ngưỡng hạn tối thiểu cho SX; file quy trình mục "Sửa 24/10 (đợt 2)" và "(đợt 9)"): 138 bảng. Bỏ `location`, `stock_relocation`, `expiry_alert`, view `v_lot_expiry`, trigger ngừng dùng ô (mục 9 phần ràng buộc), định dạng mã VI_TRI, tham số `expiry.alert_levels_days` / `expiry.alert_recipients`. `stock_line` = lô × kho × trạng thái × lý do khóa: bỏ `location_id`, thêm `stock_transfer_id` (hàng đang chuyển — đúng một trong kho / phiếu chuyển, check), unique `(lot_id, warehouse_id, stock_transfer_id, status, lock_reason)`; mỗi bao / thùng nằm ở đúng 1 dòng tồn (`handling_unit.stock_line_id`) nên trạng thái theo từng bao. `location_id` ở `lot_status_log`, `inventory_txn`, `stock_discrepancy`, `label_incident` → `warehouse_id`; `lot_status_log` thêm `handling_unit_ids`; bỏ `goods_receipt_line.suggested_location_id`, `goods_receipt_scan.putaway_location_id`, `stock_transfer.in_transit_location_id`, `stocktake_lock.location_id`, `stocktake_line.location_id`, `sample_storage_condition.location_id`; `retained_sample.storage_location_id` → `storage_position` (chữ: tủ + ngăn). `inventory_txn` bỏ DOI_VI_TRI; `scan_log` bỏ CAT_HANG / DOI_VI_TRI / SAI_O, thêm DUOI_NGUONG_SX. Thêm tham số `production.min_shelf_days` (30 ngày, ghi đè theo mã / nhóm NVL / nhà máy), hàm `production_min_shelf_days()`, view `v_lot_shelf` (số ngày còn lại, hết hạn, dưới ngưỡng SX) và 3 trigger: `trg_goods_issue_scan_shelf` (quét xuất SX), `trg_silo_charge_shelf` (quét bao nạp silo OK), `trg_lot_link_shelf` (xả silo khi nút có lô đã hết hạn) — mục 21 phần ràng buộc. Phiếu chuyển không có trạng thái "Trên xe" (DA_XUAT = hàng đang chuyển). Quyền: bỏ QT18.tk,dk → 216 thao tác, 269 dòng gán. Phép thử 5.14.
- Thay đổi 24/10 (đợt 10 — phiếu xuất SX tự lập khi lệnh phát sang khu): giữ 1 kho điều phối chung mỗi nhà máy; `goods_issue` SAN_XUAT do máy chủ nhà máy tự lập khi lệnh phát sang khu (nơi nhận = khu của lệnh, suy từ `production_order.work_area_id`); trigger `trg_goods_issue` chặn phiếu SAN_XUAT sang CHO_BEN_YEU_CAU (thiếu → XUAT_MOT_PHAN, phần thiếu thành đề nghị chuyển kho). Hủy phiếu chưa lấy khi lệnh hủy / kết thúc sớm do ứng dụng làm. Phép thử 5.13 X4–X5.
- Thay đổi 24/10 (đợt 11 — tự lập yêu cầu mua): `purchase_request` nguồn LENH_SX do hệ thống tự lập khi kho tổng thiếu NVL cho lệnh, báo Mua hàng; không đổi cấu trúc bảng. Bước thủ kho xác nhận soạn NVL không có trong dữ liệu (Kế hoạch bấm Kiểm tra lại trên lệnh — ứng dụng so tồn kho điều phối với `material_reservation`).
- Thay đổi 24/10 (đợt 12 — lệnh Chờ NVL, nhu cầu mua do hệ thống tính): `production_order.material_reserved_at` (null = Chờ NVL: tồn chưa đủ khi tạo, chưa giữ chỗ) — trigger `trg_production_order_material` chặn phát lệnh chưa giữ chỗ. `material.purchase_lead_days`, `supplier_material.lead_days` (thời gian giao hàng; trống → tham số `purchase.default_lead_days` = 14 ngày). `purchase_request.source` NHU_CAU_SX / LAP_TAY (thay LENH_SX / TON_TOI_THIEU), bỏ `production_order_id`; `purchase_request_line` thêm `suggested_supplier_id`, `production_order_ids`; trigger `trg_purchase_request_line_auto`: mỗi NVL 1 dòng trong các yêu cầu NHU_CAU_SX đang MO của nhà máy. Quyền: thêm QT19.kr (Kế hoạch kiểm tra lại NVL) — 217 thao tác, 270 dòng gán. Phép thử 5.13 P1–P7, Q1.
- Thay đổi 26/10 (mẫu lưu — file quy trình mục "Sửa 26/10"): 137 bảng. Bỏ bảng `sample_storage_condition` (điều kiện bảo quản phòng / tủ mẫu) và tham chiếu của nó; `retained_sample` bỏ `storage_position` (tủ + ngăn), `storage_condition_id`, thêm `note` (ghi chú khi ghi mẫu lưu). Mẫu nằm ở kho mẫu QC của nhà máy, không ghi vị trí trong kho. `material.storage_condition` (điều kiện bảo quản NVL ở danh mục) giữ nguyên. Nhóm NM còn 46 bảng.
- Thay đổi 28/10 (bỏ vai trò Trưởng bộ phận, bỏ rà soát quyền — file quy trình mục "Sửa 28/10"): 135 bảng. Bỏ `access_review`, `access_review_line`, trigger `trg_access_review_confirm`, tham số `account.review_period_months`, `account.review_idle_hint_days`; `account_change_log.change_type` bỏ RA_SOAT. `catalog_retire_request`: `department` chỉ nhận MUA_HANG / KE_HOACH / KHO / QC (quyết người duyệt: Trưởng BP Mua hàng / Thủ kho trưởng / QC trưởng); thêm trạng thái NGUNG_TRUC_TIEP — Kế hoạch tự ngừng, không người duyệt (check: KE_HOACH ⇔ NGUNG_TRUC_TIEP). Quyền: 18 vai trò, 214 thao tác, 267 dòng gán; thêm `QT02.tk`; bỏ `QT01.r2`, `QT01.r5`, `QT01.hr`; dòng không mã của QT01 đánh số lại (Nhật ký `QT01.#6`, Vai trò × quyền `QT01.#7`, Tham số `QT01.#8`). Phép thử: `claude/mes-powder-phep-thu-28-10.sql` (mục 5.15).
- Thay đổi 04/11 (đồng bộ theo mockup — danh sách quyết định 04/11): 140 bảng (bỏ 7, thêm 12). **Bỏ:** `quotation`, `quotation_line` (bỏ báo giá — Mua hàng nhập đơn giá ở Hàng đợi mua rồi lập PO), `brand`, `product_line`, `product_grade`, `product_line_grade`, `pack_spec` (mô hình SP mới). **Thêm:** `product_option` (lựa chọn Cấu trúc / Nhóm / Phân loại / Độ tuổi), `product_pack` + `product_pack_level` (1 SP nhiều quy cách, mỗi quy cách nhiều tầng), `product_label` (mẫu nhãn theo quy cách, QC trưởng duyệt), `product_document` (bản công bố, hồ sơ riêng của SP), `legal_document` + `legal_document_scope` (Hồ sơ pháp lý chung: phạm vi mọi SP / nhà máy / SP chọn, hạn, nhắc trước hạn), `document_snapshot` + `document_print_log` (Hồ sơ & biểu mẫu in: bản lưu lúc ký, mỗi lần in lại), `transfer_request` (yêu cầu chuyển YCC-, chốt 30/10), `purchase_order_coa_result` (kiểm COA & HSD của PO theo chỉ tiêu NVL, 30/10–31/10), `retained_sample_event` (mẫu lưu lấy ra / niêm phong lại / sửa hạn lưu). **PO:** trạng thái Chờ COA & HSD → Chờ chọn thanh toán → Chờ duyệt → Đã duyệt → Đã gửi NCC → Nhận một phần / Đã nhận đủ, Đã đóng, Từ chối, Đã hủy (bỏ Nháp); thêm kho nhận, yêu cầu / kết quả COA, cọc + trả nốt (`payment_terms` COC_TRA_NOT + `deposit_pct`, 31/10), phương thức thanh toán, từ chối, đóng phần còn lại; bỏ `purchase_request_id`, `quotation_id`, `selection_reason`, `only_one_supplier`; dòng PO có COA, NSX, HSD. NCC: cọc + trả nốt, phương thức, tài khoản ngân hàng; chứng nhận NCC bắt buộc hạn trừ giấy phép kinh doanh; lịch sử NCC ghi số ngày trễ / SL thiếu theo PO. Yêu cầu mua: dòng theo NVL × kho nhận, trạng thái dòng (Mở / Đã lập PO / Trả về Kế hoạch / Hủy), bỏ DANG_MUA. Trả NCC: trạng thái theo mockup (Chờ NCC xác nhận … Hoàn tất / Chuyển hủy), nguồn (đã nhập kho / bao hư khi nhận / từ chối ở cửa kho), nhiều ảnh, số lô NCC bắt buộc với dòng có lô, bỏ lý do "Thiếu chứng từ". **Kho:** phiếu chuyển "lập là chấp nhận" — trạng thái Chờ xuất / Đang chuyển / Chờ xử lý hàng hư / Nhận thiếu / Chờ xác nhận thất lạc / Đã nhận / Thất lạc / Đã hủy, bỏ người yêu cầu / người gửi / người xác nhận / từ chối, thêm giờ đến dự kiến; phiếu tự lập từ lệnh SX vào thẳng Chờ xuất; dòng chuyển gom yêu cầu chuyển. Nhiều kho điều phối mỗi nhà máy (NM1-DP, NM1-DP2), khu HH / BTP chọn kho điều phối cấp NVL (`work_area.supply_warehouse_id`). Kiểm kho: KHOP thay DONG. Phiếu nhập: Kế toán lưu hóa đơn / chứng từ (tệp, đã nhận bản cứng). **Nền tảng:** vai trò × quyền sửa được, phạm vi nhà máy theo vai trò (`role.factory_scope`) và theo quyền (`role_permission.scope_mode`); vai trò thứ 19 Thủ kho điều phối; xóa được bản ghi chưa từng dùng (tài khoản chưa đăng nhập, đơn vị, lựa chọn SP, quy cách, quyền, hồ sơ pháp lý) — nhật ký tài khoản thêm XOA; Đơn vị có loại, quy đổi, trạng thái (màn Danh mục › Đơn vị); NVL thêm ảnh (≤ 5), nguyên liệu kỵ nhau, tồn tối thiểu + cách bù, ghi chú, bắt buộc ≥ 1 chỉ tiêu COA; nhà máy thêm địa chỉ, điện thoại, email; công thức thêm thời gian / tốc độ trộn chuẩn và thứ tự nạp; `code_format` thêm mã KH, NCC, NV, lô, ĐH, PO, NC, YCC, HS, bỏ 4 mã danh mục SP. **Bán hàng:** trạng thái đơn theo mockup (thêm Chờ kiểm công nợ, Đang sản xuất, Chờ duyệt hủy, Đang hủy); Sales hủy thẳng ở Chờ ký HĐ / Chờ thu tiền (bỏ bắt buộc người duyệt khi hủy, thêm `cancelled_by`); đơn có địa chỉ giao, phiên bản có phương thức thanh toán, tiền cọc bằng số tiền, VAT và ngày giao ở đầu đơn; khách thêm ngân hàng, chủ tài khoản, phương thức / số ngày nợ / % cọc mặc định, email hóa đơn, trạng thái Tạm dừng giao dịch; hóa đơn bán hàng lập trên MES, in A4, gắn phiếu xuất bán; ghi nhận giao: khách nhận thiếu thì ghi khách còn lấy phần không nhận hay không. **Sản xuất:** lệnh sản xuất tồn kho (`demand_kind` TON_KHO); máy chủ nhà máy tự kiểm khi nhận lệnh (kết quả, lý do, lúc kiểm); lệnh BTP cần bản công bố còn hiệu lực + mẫu nhãn đã duyệt của quy cách (`production_order_brand.product_pack_id`). **Chất lượng, truy xuất:** phiếu chứng nhận Chờ ký → Đã ký (số phiếu, người ký, lúc ký khi ký); mẫu lưu có nơi lưu, đang lấy ra, cách hủy, người chứng kiến; phiếu kiểm có file đánh giá ngoài, ghi chú QC, lý do kết luận khác đề xuất; yêu cầu kiểm có nội dung bổ sung; CAPA có lý do trả lại; hoàn tiền thu hồi chờ duyệt; hồ sơ thu hồi có SL ngoài thị trường / còn trong kho; truy xuất nhận thêm mã đơn hàng, khách hàng, mã NVL và công văn cơ quan. Trigger đổi / mới ở phần viết tay của file sql: mục 1 (cho xóa bản ghi chưa dùng), 13 (thay báo giá bằng kiểm COA & HSD của PO), 14 (trạng thái trả NCC), 16a–16e (lựa chọn SP, duyệt mẫu nhãn, điều kiện lệnh BTP, chỉ tiêu COA bắt buộc, kho cấp NVL của khu), 17a–17d (phiếu chuyển lập là chấp nhận, yêu cầu chuyển), 28 (Hàng đợi mua theo NVL × kho), 29a–29c (xóa tài khoản, hóa đơn gắn phiếu xuất, mẫu lưu). Lượt này sửa tay đồng thời mô hình JSON, mục 10 và DDL (script sinh không có trên máy); đã chạy toàn bộ file sql trên PostgreSQL 18 trống 04/11. Dữ liệu nạp quyền sinh lại theo file quy trình 04/11 (script tạm thay `mes-powder-gen-quyen.py`): 19 vai trò, 239 thao tác (trước 214), 351 dòng gán (trước 267 — Thủ kho điều phối 40 dòng), 37 màn (trước 33; thêm Tổng quan, Hồ sơ & biểu mẫu in, Danh mục › Đơn vị, Hồ sơ pháp lý chung; Công thức, Khu vực làm việc chuyển vào Danh mục), 261 dòng màn × chức năng; mã mới QT01.vq / xq / xt / tq, QT02.xo / ml / dv / xv / hs / xh / xk, QT05.hn, QT12.tv / t3,t4 / ce / ck / tt / gp / hp / dl, QT15.xp, QT16.yl / yn / kx, QT19.cb, QT23.gk, QT24.lr,np / sh; bỏ QT01.#7, QT12.#9, QT12.tq, QT16.ya,kg / d1 / kq, QT23.g2; `screen_function` bỏ cột `warehouse_type` (cờ @DIEU_PHOI), view `v_user_screen` không còn xét loại kho. Các phép thử cũ ở mục 5 về báo giá, đề nghị chuyển kho, 4 danh mục SP không còn đúng với bảng / trạng thái mới — giữ làm lịch sử.

## Số bảng theo mảng

| Mảng | Số bảng | Trong đó chờ quyết |
|---|---|---|
| 0 · Lô & mã định danh (dùng chung) | 10 | — (silo → mẻ đã chốt 19/10 đợt 3) |
| 1 · Nền tảng (QT01–04) | 39 | — |
| 2 · Bán hàng (QT05–10) | 17 | — |
| 3 · Mua hàng (QT11–13) | 13 | — |
| 4 · Kho (QT14–18) | 19 | — |
| 5 · Sản xuất (QT19–21, gồm đồng bộ) | 24 | 5 bảng + cột ở 2 bảng |
| 6 · Chất lượng (QT22–24) | 8 | — |
| 7 · Truy xuất & thu hồi (QT25–26) | 10 | — |
| **Tổng** | **140** | **5 bảng + 4 cột** |

Nơi đặt (sửa 20/10 đợt 2 — nhóm của `sync_policy`; số bảng sửa 04/11): 47 bảng **nhà máy chủ** (NM — máy chủ nhà máy của dòng ghi, sao lên cloud; cloud chỉ đọc bản đồng bộ) · 57 bảng **cloud chủ, sao xuống** (CLOUD — phần nhà máy cần, lọc theo nhà máy, kéo theo dòng cha theo khóa ngoại) · 28 bảng **chỉ cloud** (CLOUD_ONLY — thu chi, công nợ, truy xuất, phần còn lại của thu hồi…) · 6 bảng **nơi phát sinh** (NOI_PHAT_SINH — phiên, tệp, nhật ký, bộ đếm mã, bản lưu & nhật ký in) · 2 bảng **chỉ máy chủ nhà máy** (NM_ONLY — hàng đợi gửi lên, phiên mất kết nối). Mục 3 có bảng tóm tắt; cột Nơi của từng bảng ở mục 10.

## 1. Quy tắc chung (áp cho mọi bảng)

1. **Khóa chính `id uuid`** (UUIDv7 sinh tại nơi tạo dòng — cloud hoặc server nhà máy) → 2 nhà máy và cloud tạo dòng độc lập, không bao giờ đụng khóa khi đồng bộ.
2. **Không xóa cứng:** mọi bảng có trigger chặn `DELETE` (trừ hàng đợi gửi lên `sync_outbox` — dọn sau 30 ngày kể từ khi cloud xác nhận; bỏ `lot_status_replica` 20/10 đợt 2). Sửa 04/11: xóa được bản ghi chưa từng dùng ở tài khoản (chưa đăng nhập), đơn vị, lựa chọn SP, quy cách SP, quyền, hồ sơ pháp lý chung — khóa ngoại chặn khi đã có dòng trỏ tới; bản ghi đã dùng vẫn chỉ khóa / ngừng dùng. Bỏ dùng = trạng thái NGUNG_DUNG / DA_KHOA / DA_HUY / HUY, hoặc cột `revoked_at` / `released_at`.
3. **Người tạo / thời điểm:** mọi bảng nghiệp vụ có `created_at`, `created_by`; bảng sửa được có thêm `updated_at`, `updated_by`. Bảng nhật ký / hàng đợi có cột người + thời điểm riêng. Thao tác tự động ghi người tạo = tài khoản "Hệ thống".
4. **Phân theo nhà máy:** chứng từ và dữ liệu vận hành có `factory_id` bắt buộc. Danh mục chung (SP, NVL, công thức), khách hàng, NCC dùng chung 2 nhà máy (xem câu hỏi 14).
5. **Người tạo không tự duyệt:** check `approved_by <> created_by` (phiếu nhập, xuất, PO, hạn mức, điều chỉnh kho, phiếu hủy, CAPA, hoàn tiền thu hồi, đề nghị ngừng mã), `approved_by <> entered_by` (kết quả QC), `confirmed_by <> resolved_by` (biên bản thất lạc), `decided_by <> user_id` (dòng rà soát tài khoản — Trưởng BP không tự quyết dòng của mình). Bản ghi nhận thu / chi không có bước duyệt (bỏ 19/10).
6. **Nhật ký thay đổi:** `audit_log` cho mọi bảng (trước / sau); nhật ký chuyên biệt cho trạng thái lô, đơn, NCC, tài khoản.
7. **Giá trị liệt kê** dùng `text` + `check (… in …)` thay cho enum của PostgreSQL → thêm giá trị không cần đổi kiểu.
8. **Quyền:** chỉ gán qua vai trò (`user_role`), không gán quyền lẻ. Không ai tự gán / tự gỡ vai trò của chính mình (check `user_id <> created_by`, `revoked_by <> user_id`); vai trò Admin và Người truy xuất chỉ người đang giữ vai trò Admin gán được (trigger). Vai trò ủy quyền tạm là dòng `user_role` có `valid_until`, sinh từ `user_delegation`, chỉ cho vai trò `role.delegable` — chốt 19/10, bỏ Trưởng bộ phận 28/10: Giám đốc, Kế toán trưởng, Thủ kho trưởng, Trưởng BP Mua hàng, QC trưởng, Kế hoạch. Sửa 04/11: màn Vai trò × quyền sửa được (Admin cấp / gỡ quyền, thêm / sửa / xóa quyền ở Danh mục quyền), phạm vi nhà máy đặt theo vai trò (`role.factory_scope`) và theo từng quyền (`role_permission.scope_mode`); bảng quyền nạp sẵn vẫn lấy từ file quy trình.

## 2. Quyết định thiết kế quan trọng

1. **Trạng thái lô nằm ở phần lô, không nằm ở lô.** `lot` chỉ giữ thông tin lô (mã, loại, NSX, HSD). Trạng thái ở `stock_line` = lô × kho × trạng thái × lý do khóa (sửa 24/10 đợt 9 — bỏ vị trí kệ; hàng đang chuyển: dòng trên phiếu chuyển); mỗi bao / thùng nằm ở đúng 1 dòng tồn nên trạng thái theo từng bao — cùng lô cùng kho vẫn tách được bao ĐẠT với bao KHÓA (hư khi nhận, chờ hủy). Đổi trạng thái một phần = chuyển SL sang dòng khác + 1 dòng `lot_status_log` + cặp −/+ trong sổ kho. KHÓA bắt buộc có lý do (check). Lý do khóa là danh mục 9 dòng quyết định lối ra; khóa cả lô là bảng riêng `lot_lock` để áp cả phần nhập lại sau (trigger chặn thêm phần ĐẠT / CHỜ KIỂM khi lô đang khóa cả lô). Bảng chuyển trạng thái hợp lệ chép đúng mục "Vòng đời lô hàng" vào `lot_status_transition`; mỗi dòng nhật ký trỏ về chuyển trạng thái đã dùng.
2. **Một đồ thị liên kết lô → lô cho cả chuỗi, mẻ là một nút.** Mỗi mẻ có 1 "lô mẻ" (`lot_kind = ME`, không có tồn). Chuỗi thành: lô NVL —đổ vào mẻ→ lô mẻ HH —ra mẻ→ lô HH (bao HH) —đổ vào mẻ→ lô mẻ BTP —ra mẻ→ lô BTP/TP từng nhãn hiệu; lô bao bì lon / thùng —bao bì→ lô BTP/TP. Nhờ nút mẻ, 1 mẻ nhiều đầu vào × nhiều nhãn hiệu không phải chia tỷ lệ khối lượng cho từng cặp. Thùng → phiếu xuất (`goods_issue_scan`) → biên bản (`delivery_note_line`) → khách là các mắt xích cuối. Sửa 19/10 (đợt 3): bao không đổ thẳng vào mẻ — lô NVL / HH —nạp silo→ **nút silo của lệnh** (`lot_kind = SILO`) —xả→ lô mẻ; nhiều lô trộn trong silo, nhiều mẻ cùng lấy ra, nên truy xuất qua nút silo so thời điểm (mục 5).
3. **Liên kết bắt buộc được ép ở CSDL, không chỉ ở ứng dụng:** (a) dòng quét bao nạp silo (`silo_charge`, đợt 3) trạng thái OK phải trỏ tới `lot_link` và nút silo (check); (b) lô HH / BTP / bột hỏng phải có liên kết "ra mẻ", lô NVL dư phải có liên kết về lô gốc — kiểm lúc COMMIT bằng ràng buộc trễ, thiếu là cả giao dịch bị hủy → thao tác quét bị chặn; (c) trigger kiểm đúng loại lô cha / con theo từng loại liên kết. Đã thử: cả 3 đều chặn đúng.
4. **Mã định danh tách khỏi lô** (`handling_unit`: bao NVL, bao HH, thùng). Mã = tiền tố nhà máy (`factory.unit_code_prefix`) + số tăng từ `code_sequence` của server nhà máy → 2 nhà máy không trùng, mất kết nối vẫn in tem. Lon không có dòng (dùng mã in sẵn); quét lon đầu ghi ở `filling_run.first_can_code`, thùng gắn lô theo bộ đếm. Khóa / thay tem (QT04) đổi `label_status` của mã, không đụng trạng thái lô.
5. **Ai là chủ dữ liệu (sửa 20/10 đợt 2 — chủ theo dòng).** Một bản ghi chỉ một nơi được ghi. Bảng có `factory_id` thuộc nhóm lô & mã định danh, kho, QC, dữ liệu xưởng: máy chủ nhà máy của dòng đó là chủ, cloud giữ bản đồng bộ (`sync_policy` nhóm NM). Danh mục, tài khoản, quyền, tham số, lệnh SX (chỉ tạo trên cloud — check `created_site = 'CLOUD'` giữ nguyên; Kế hoạch ở văn phòng), bán hàng, mua hàng, kế toán, thu hồi, truy xuất: cloud chủ (nhóm CLOUD, phần cần cho nghiệp vụ tại chỗ sao xuống chỉ đọc theo `factory_id`, kéo theo dòng cha theo khóa ngoại để máy chủ nhà máy giữ nguyên khóa ngoại; nhóm CLOUD_ONLY không xuống). Nơi không phải chủ muốn tác động thì (a) ghi bản ghi của mình và cloud **chiếu** lại cột dẫn xuất (nhà máy nhận chuyển kho ghi `goods_receipt` → cloud chiếu `stock_transfer_line.received_qty` của nhà máy xuất; `goods_issue_scan` → `material_reservation.issued_kg`; mẻ đầu → `production_order.status`), hoặc (b) gửi **lệnh** qua `site_command` (quyết định 35). Mọi thay đổi trên dòng nhà máy chủ **luôn** ghi `sync_outbox` trong cùng giao dịch — kể cả khi có kết nối — nên chỉ có một đường đồng bộ. Trước 20/10 đợt 2: cloud chủ trạng thái lô, tồn, mọi chứng từ; nhà máy chỉ chủ dữ liệu xưởng và giữ bản sao trạng thái lô.
6. **Bỏ trùng khi đồng bộ bằng khóa chính:** `sync_event_inbox.event_id` là khóa chính → `INSERT … ON CONFLICT DO NOTHING`; áp dụng theo `seq_no` từng nhà máy (`factory_sync_state.last_applied_seq`). Các bảng nhận dữ liệu từ sự kiện có `source_event_id` unique để áp dụng lại cũng không ghi 2 lần.
7. **Sổ kho `inventory_txn` là nguồn cân bằng khối lượng.** Đổi trạng thái / chuyển / dời / hủy là cặp −/+ (tổng lô không đổi); nhập, xuất SX, xuất bán, trả NCC, lấy mẫu là dòng một chiều. Cân bằng lấy "SX ra" từ liên kết lô (dữ liệu xưởng) so với sổ kho (dữ liệu kho) → lệch giữa hai bên lộ ra (thử: nhãn B SX 6 lon, phiếu nhập ghi 5 → lệch 1).
8. **Đơn = đầu đơn + phiên bản bất biến + dòng.** Sửa đơn thêm phiên bản, không sửa dòng cũ. Lịch thanh toán gắn phiên bản (khoản cũ → THAY_THE). Cờ "đã xin tăng hạn mức" không lưu thành cột mà suy ra từ `credit_limit_request` của phiên bản — phiên bản mới tự về "chưa". Hạn mức là 1 cột trên khách, không có ngày hết hạn (luôn vĩnh viễn).
9. **Giữ chỗ NVL theo KG** (`material_reservation`): không có cột lô; xuất SX trừ dần `issued_kg`; hủy lệnh / kết thúc sớm tự giải phóng phần còn lại (trigger); tồn dùng được cho SX = phần ĐẠT có hạn còn ≥ ngưỡng tối thiểu cho SX (`production.min_shelf_days`, 24/10 đợt 9), đang ở kho (không tính hàng đang chuyển) − KG còn giữ.
10. **Bản chụp thay cho phiên bản hóa:** kết quả kiểm COA / QC chép lại giới hạn lúc kiểm; phiếu truy xuất chép lại chuỗi lô, khách, cân bằng → sửa danh mục về sau không làm sai bằng chứng cũ.
11. **Tham số một bảng** (`system_parameter`): giá trị chung, ghi đè theo nhà máy hoặc nhóm (TP / NVL / BTP / mã NVL); lịch sử sửa nằm ở `audit_log`. Chứng từ chép giá trị tham số đã dùng khi cần làm bằng chứng (vd `retained_sample.retain_until`).
12. **Vai trò × Chức năng nạp sẵn vào CSDL:** 19 vai trò (`role`), 226 thao tác (`permission`, mã = QT + bước, vd `QT14.d4` × DUYET) và 280 dòng gán (`role_permission`; 20/10 — trước đó 221 / 261, 216 / 256, 208 / 246, 196 / 229), sinh thẳng từ bảng quyền 7 mảng của file quy trình. Sửa 20/10: Admin **không** còn được thêm mọi thao tác — chỉ nhận đúng các dòng của bảng quyền (quản trị QT01, nhà máy / khu vực / kho / dàn silo QT02 ka, ks, và `QT01.xa` xem mọi màn — Giám đốc cũng có `QT01.xa`). Sửa bảng quyền ở file quy trình thì sinh lại dữ liệu nạp, không sửa tay. **Sửa 04/11:** 19 vai trò (thêm Thủ kho điều phối), 239 thao tác, 351 dòng gán (bản nạp 04/11); màn Vai trò × quyền sửa được, nên dữ liệu nạp chỉ là bảng quyền ban đầu (quyết định 44).
13. **Hủy mẻ do sự cố (QT20) là 1 quyết định của Kế hoạch trên cloud** (`batch_cancellation`): cùng 1 giao dịch đổi mẻ → ĐÃ HỦY, tạo lô bột hỏng loại HONG nối từ lô mẻ bằng liên kết RA_ME (truy xuất thấy, cân bằng khối lượng tính vào ô hủy), phần lô KHÓA lý do chờ hủy, tự tạo phiếu hủy nguồn HUY_ME (không được từ chối, chỉ dời ngày), cộng 1 vào `production_order.makeup_batch_count` và giữ thêm NVL theo KG (`material_reservation.makeup_kg`). Quyết định đi xuống nhà máy bằng lệnh `site_command` kind HUY_ME (kèm mẻ bù), `batch_cancellation.site_command_id`: Kế hoạch bấm được cả khi nhà máy mất mạng, lệnh CHO_GUI; nhà máy áp dụng khi mẻ còn DUNG_SU_CO, khác thì TU_CHOI kèm lý do (sửa 20/10 đợt 2 — trước: chặn nút khi mất mạng).
14. **Mã danh mục tự sinh, không duyệt (định dạng chốt 17/10):** `code_format` giữ mẫu mã từng loại (NVL, SP, công thức, kho — bỏ vị trí kệ 24/10 đợt 9; sửa 19/10: thêm công thức, 20/10 đợt 3 đổi sang 4 số `CT-{loai}-{so:4}`, bỏ thiết bị đo; NVL hỗn hợp nhóm HHP; mỗi nhà máy 1 kho mỗi loại — sửa 04/11: kho thứ 2 cùng loại thêm số, vd NM1-DP2) + bảng đổi giá trị → chữ trong mã; số thứ tự lấy từ `code_sequence`, chỉ tăng, không dùng lại số của mã đã ngừng. Ngừng dùng mã NVL / SP mới có đề nghị và duyệt (`catalog_retire_request`); kho do Admin làm trực tiếp. **Sửa 04/11:** thêm mẫu mã khách hàng KH-, NCC-, mã NV NV, lô NVL nội bộ L-, lô BTP B{yymmdd}, lô TP A{yymmdd}, chứng từ cloud ĐH-, PO-, NC-, YCC-, HS-; bỏ THH- / DSP- / QCD- / HSP-.
15. **Mẫu lưu QC tự quản:** hạn lưu (gợi ý HSD + 6 tháng) do QC tự quyết; không ghi tủ / ngăn, không quản lý điều kiện bảo quản (bỏ `sample_storage_condition` 26/10); hết hạn QC tự hủy, ghi người hủy + biên bản ngay trên `retained_sample`, không qua phiếu hủy (mẫu đã ra khỏi tồn lúc lấy).
16. **Kế toán chỉ ghi nhận (19/10).** `payment_voucher` là bản ghi nhận thu / chi do Kế toán nhập (số tiền, ngày, CK / tiền mặt, ảnh chứng từ bắt buộc) — không duyệt, không tự sinh, nhập sai thì hủy kèm lý do. Tiền về / hoàn tiền của khách cấn vào khoản qua bảng mới `payment_allocation` (1 lần ghi nhận cấn được nhiều khoản; trigger chặn cấn vượt số tiền hoặc cấn vào bản đã hủy); cấn vào khoản công nợ thì ghi thêm `ar_entry` THU. Trả NCC ghi `payment_voucher` TRA_NCC + `ap_entry` TRA_TIEN. Ba việc tự động (dư nợ, nợ quá hạn, cờ tạm khóa, nhắc nợ trong hệ thống) tính từ `payment_schedule` + `ar_entry`, không cần bảng riêng. `ar_entry` bỏ XOA_NO; nợ quá 90 ngày GĐ / KTT quyết bên ngoài, Kế toán ghi kết quả ở `payment_schedule.escalation_*` (chỉ khoản công nợ).
17. **Hóa đơn: bỏ `sales_invoice`, thu gọn thành 3 cột trên `delivery`** (`invoice_no`, `invoice_date`, `invoice_file_id`). Lý do chọn cách này: hệ thống không xuất hóa đơn nên không cần giữ số tiền trước thuế / tiền thuế; 1 đợt giao = 1 phiếu xuất = 1 biên bản = 1 hóa đơn theo phần đã giao, nên 3 cột trên đợt giao là đủ để tra cứu — bỏ được 1 bảng và 4 khóa ngoại. Nếu sau này 1 đợt cần nhiều hóa đơn thì mới tách lại (câu hỏi 19). **Sửa 24/10:** bỏ đợt giao; hóa đơn tách thành bảng `sales_order_invoice` gắn đơn (số, ngày, file — một đơn nhiều hóa đơn, không gắn phiếu xuất). **Sửa 04/11:** hóa đơn bán hàng lập trên MES (in A4, bản thể hiện của hóa đơn điện tử), mỗi hóa đơn gắn 1 phiếu xuất bán (`sales_order_invoice.goods_issue_id`, trigger: phiếu BAN đã xuất của đúng đơn); trạng thái Nháp / Đã phát hành / Đã hủy.
18. ~~**Rà soát hằng quý theo từng tài khoản (19/10):** `access_review` = kỳ của 1 bộ phận; `access_review_line` = 1 dòng / tài khoản (gợi ý của hệ thống, quyết định giữ / gỡ vai trò / khóa, vai trò bị gỡ, người quyết, thời điểm), check người quyết ≠ tài khoản đó; trigger chỉ cho xác nhận bộ phận khi mọi dòng đã có quyết định. Gợi ý "vai trò khác nhóm với chức danh" so với `job_title_role`.~~ **Bỏ 28/10** — không rà soát quyền định kỳ; bỏ `access_review`, `access_review_line`.
19. **Danh mục 4 loại, thiết bị nạp khi triển khai (19/10; sửa đợt 2 — silo có màn quản lý, quyết định 22):** `equipment` chỉ còn thiết bị SX (silo, bồn trộn, máy chiết, robot, thang nâng, cân băng tải); trừ silo, không có màn quản lý, nạp từ danh sách của bên cung cấp thiết bị; giữ `batch_equipment_usage`, `iot_source_ref` làm điểm nối. `uom` nạp khi triển khai, Admin thêm ở màn Tham số. Vị trí kệ: bỏ hẳn 24/10 đợt 9 (bảng `location`). Mã công thức `CT-HH-0001` check theo `formula_kind`.
20. **Sự cố tem (19/10; sửa đợt 2 — làm ở Kho · Tồn kho, không còn máy quét riêng):** `label_incident` ghi kho và lô lấy từ dòng tồn lô × kho đã chọn (tem mất bắt buộc cả hai — check; sửa 24/10 đợt 9, thay ô), mã cũ → mã mới (mã cũ trỏ `handling_unit.replaced_by_id`), cờ `from_cancel` khi hủy tem mà bao còn trong kho (ghi như tem mất; mã mới vào cùng dòng tồn với mã cũ nên giữ trạng thái), thời điểm quét xác nhận; `scan_log` có `replacement_code` để hiện mã thay thế khi quét trúng mã đã khóa.
21. **Tài khoản (19/10; sửa đợt 2):** mã thẻ chỉ bắt buộc với công nhân (check cũ giữ nguyên), chỉ dùng đăng nhập PC xưởng — web đăng nhập bằng mã NV + mật khẩu; `user_session` bỏ MAY_QUET, check QUET_THE chỉ với PC_CSHARP; quy tắc mật khẩu (≥ 8 ký tự, có chữ và số) cố định trong code — không có cột / tham số; "Sắp bắt đầu" của ủy quyền suy ra từ `starts_at`, không thêm giá trị trạng thái. Màn Công thức tra "lệnh đang chạy phiên bản cũ" = `production_order` DANG_CHAY nối `formula_version` có `is_current = false` (đã thử, mục 5.6).
22. **Khu vực làm việc & dàn silo (19/10 đợt 2) — silo gộp vào `equipment`, không tách bảng.** `work_area`: loại HH / BTP / CHIET_ROT / DONG_GOI (bỏ KHAC), `max_batch_kg` bắt buộc đúng với khu HH / BTP (check); trigger chặn đổi loại khu khi khu còn lệnh chưa HOAN_THANH / DA_HUY; không xóa (trigger chung). Silo = dòng `equipment` loại SILO, thêm `capacity_kg`, `hard_material_id`, trạng thái BAO_TRI (chỉ silo); check silo bắt buộc khu, sức chứa > 0, mã SCADA (`iot_source_ref`); trigger chỉ cho silo ở khu HH / BTP; tên silo không trùng trong 1 khu. **Lý do chọn gộp (ít bảng hơn):** silo vốn đã là dòng `equipment` — `silo_charge` (trước là `batch_material_scan`), `lot_link`, `batch_equipment_usage`, `batch_downtime` đều trỏ `equipment`, `iot_source_ref` chính là mã SCADA; tách bảng `silo` thì thêm 1 bảng, lặp mã / tên / SCADA và phải đổi 4 khóa ngoại, trong khi chỉ thêm 2 cột (để trống với thiết bị khác, check bảo đảm). Silo chuyển BAO_TRI / NGUNG_DUNG → trigger đánh dấu mọi lệnh MOI_TAO đang xếp NVL vào silo đó `silo_plan_status = CAN_XEP_LAI` (Việc cần làm của Kế hoạch; chặn phát).
23. **Lệnh SX theo khu, hàng đợi, trạng thái (19/10 đợt 2):** `production_order.work_area_id` bắt buộc; trigger: loại lệnh = loại khu, cùng nhà máy, khu đang dùng, `batch_weight_kg ≤ max_batch_kg`; `origin_docs_file_id` (giấy tờ xuất xứ NVL — 1 tệp của lệnh) bắt buộc, không kiểm COA theo lô. Hàng đợi = thứ tự chạy ở nhà máy (đợt 3): `queue_priority` bắt buộc khi MOI_TAO / CHO_PHAT (Chờ phát giữ vị trí), ràng buộc loại trừ trễ (không trùng trong 1 khu, đổi thứ tự trong 1 giao dịch được); chỉ phát được lệnh không có lệnh Mới tạo / Chờ phát nào đứng trước; lúc phát kiểm lại KL mẻ ≤ mức tối đa hiện tại của khu. Trạng thái chỉ đi MOI_TAO → CHO_PHAT / DA_NHAN → DANG_CHAY → HOAN_THANH, hủy từ MOI_TAO / CHO_PHAT / DA_NHAN (lý do bắt buộc — check cũ; trigger tự giải phóng `material_reservation`); không nháp, không quay lại, không xóa. Đợt 3 (thay cách "sửa lệnh Đã nhận rồi gửi lại" của đợt 2, bỏ 2 cột bản sửa): chỉ sửa lệnh MOI_TAO (trigger khóa các cột kế hoạch khi đã phát, trừ cộng mẻ bù); hủy lệnh Chờ phát / Đã nhận ghi `cancel_requested_at` rồi chỉ thành DA_HUY khi có `nm_cancel_confirmed_at` (nhà máy xác nhận chưa chạy mẻ); lệnh đang chạy chỉ kết thúc sớm: HOAN_THANH + `ended_early_at`, lý do, `actual_batch_count` (check), không còn mẻ DANG_CHAY / DUNG_SU_CO (trigger). HOAN_THANH chỉ khi mọi nút silo của lệnh đã xả sạch.
24. **Phương án dàn silo = bảng mới `production_order_silo` (lệnh, NVL, silo, KL / mẻ, cờ kéo thả).** Unique (lệnh, NVL) và (lệnh, silo) ⇒ 1 NVL – 1 silo, số NVL ≤ số silo dùng được. Trigger từng dòng: silo của khu lệnh, đang hoạt động, đúng gán cứng, NVL có trong công thức của lệnh, KL / mẻ ≤ sức chứa, chỉ sửa khi lệnh Mới tạo (đợt 3). "Chốt khi tạo": lệnh tạo ở MOI_TAO phải có phương án đủ mọi NVL lúc COMMIT (ràng buộc trễ). "Kiểm lại khi phát": chuyển sang CHO_PHAT / DA_NHAN chạy lại hàm kiểm `silo_plan_problem` và đòi `silo_plan_status = DA_CHOT`. Gợi ý xếp (theo gán cứng, sức chứa) và kéo thả là việc của ứng dụng, CSDL chỉ giữ kết quả + cờ `is_adjusted`.
25. **Kế hoạch nhãn hiệu lệnh BTP nhiều dòng:** `production_order_brand` thêm `printed_lot_no` (số lô in trên lon nếu đã biết), `sales_order_line_id` (dòng đơn nguồn); unique (lệnh, SP, số lô in — null coi như bằng nhau); trigger chỉ lệnh BTP, SP phải dùng công thức của lệnh (các dòng đơn cùng công thức).
26. **Mua hàng, trả NCC, xuất kho (19/10 đợt 2):** điều khoản thanh toán NCC và báo giá tách `payment_terms` (TRA_TRUOC / TRA_SAU) + `payment_days` như PO, check số ngày chỉ đi với trả sau. `quotation` có trạng thái MO / DA_CHON / DA_HUY, hủy bắt buộc lý do + thời điểm; trigger: chỉ lấy báo giá từ yêu cầu mua MO / DANG_MUA, có báo giá → yêu cầu DANG_MUA, hủy hết báo giá → yêu cầu về MO; unique NCC × yêu cầu chỉ tính báo giá chưa hủy. `supplier_return`: thêm CHO_KHO_XUAT_TRA (bắt buộc người + lúc Mua hàng gửi yêu cầu xuất trả); phiếu xuất TRA_NCC chỉ lập được khi phiếu trả đang chờ kho; DA_XUAT_TRA chỉ khi phiếu xuất đã xuất; GIAM_CONG_NO bị chặn khi PO trả trước; tổng SL trả theo NVL của mọi phiếu trả cùng PO ≤ SL đã nhận (trigger trên dòng trả). `goods_issue`: thêm CHO_BEN_YEU_CAU (chỉ từ DA_DUYET), ra chỉ sang XUAT_MOT_PHAN / DA_HUY do đúng `requested_by` quyết (`requester_decision_by`). **Sửa 04/11:** bỏ báo giá (quyết định 39).
27. **Bỏ máy quét riêng (19/10 đợt 2):** thao tác quét nằm ở màn Kho trên web và PC xưởng — dữ liệu quét không đổi (`scan_log`, `goods_receipt_scan`, `goods_issue_scan`, `stocktake_line`, `batch_material_scan` — đợt 3 đổi tên `silo_charge`); chỉ bỏ loại thiết bị MAY_QUET ở `user_session`.
28. **Silo nạp nhiều mẻ, truy xuất qua nút silo — cách B (19/10 đợt 3).** Mỗi silo của lệnh là 1 "nút silo" (`lot`, `lot_kind = SILO`, như lô mẻ: không tồn, không HSD; `production_order_id`, `silo_equipment_id`); mỗi lệnh × silo chỉ 1 nút đang mở (unique có điều kiện). Quét bao nạp silo = `silo_charge` + `lot_link` NAP_SILO (lô → nút); silo xả cho mẻ = `lot_link` XA_SILO (nút → lô mẻ); mỗi dòng có `linked_at`. Truy xuất: lô nạp lúc T là đầu vào của các mẻ xả sau T (`nạp.linked_at ≤ xả.linked_at`), tới khi silo xả sạch — `silo_emptied_at` đóng nút, lần nạp sau mở nút mới. Trigger: nạp đúng NVL của nút, đúng silo của phương án, silo đang hoạt động, lệnh Đã nhận / Đang chạy, bột trong nút + nạp ≤ sức chứa (`silo_content()`); xả cho mẻ chỉ mẻ của đúng lệnh, ≤ bột đang có; đóng nút khi bột = 0. Silo còn nút đang mở thì không chuyển bảo trì / ngừng dùng; tạo mẻ mới bị chặn khi silo trong phương án không hoạt động. Không cần bảng mới: dùng lại `lot` + `lot_link`, cân bằng khối lượng ở mức silo = tổng nạp − xả cho mẻ − bột dư.
29. **Bột dư cuối lệnh về kho điều phối (19/10 đợt 3):** xả thành lô NVL dư mới (`source_lot_id` = nút silo, liên kết NVL_DU từ nút — ràng buộc trễ cũ bắt buộc liên kết này), HSD lấy theo lô sớm nhất đã nạp vào nút, nhập kho điều phối qua QT14 rồi đóng nút.
30. **Trả NCC (19/10 đợt 3):** `supplier_return.purchase_order_id` bắt buộc; dòng trả theo ĐVT gốc của NVL (trigger so `material.uom_code`); dòng có lô: tổng trả theo NVL của mọi phiếu trả cùng PO ≤ SL đã nhận, SL trả của lô (cộng các phiếu chưa xuất xong) ≤ tồn hiện có của lô; dòng không lô (từ chối ở cửa kho) không tính vào số đã nhận, so với biên bản từ chối ở ứng dụng.
31. ~~**Danh mục SP tách 4 danh mục phụ (19/10 đợt 4):** `brand`, `product_line`, `product_grade`, `pack_spec`, mỗi dòng `product` = 1 quy cách × số lon / thùng.~~ **Bỏ 04/11** — thay bằng mô hình SP mới (quyết định 41).
32. **Phiếu chuyển tự lập từ lệnh SX (19/10 đợt 4; sửa 04/11 — chốt 30/10):** NVL cho SX đi kho tổng → kho điều phối cấp NVL của khu → xuất SX từ kho điều phối. Khi tạo / phát lệnh, ứng dụng so tồn dùng được ở kho điều phối của khu với `material_reservation` còn giữ của lệnh; thiếu thì máy chủ nhà máy lập luôn `stock_transfer` (`auto_drafted`, `source_order_id`) ở Chờ xuất — bỏ trạng thái Đề nghị và bước Kế hoạch gửi; dòng ghi NVL + KG thiếu, lô gán khi thủ kho kho tổng xuất theo FEFO (trigger: mọi dòng có `lot_id` trước Đang chuyển). Lệnh hủy / kết thúc → phiếu tự lập còn Chờ xuất của lệnh thành Đã hủy. Phiếu xuất SX: trigger chặn `goods_issue` SAN_XUAT lập từ kho không phải loại DIEU_PHOI.
33. **Menu suy ra từ quyền (20/10):** `screen` giữ 34 màn của menu web (mã, phân hệ, tên, thứ tự; Việc cần làm `always_visible`), `screen_function` gắn màn với mã chức năng của bảng quyền (`function_code`, không khóa ngoại vì `permission` unique theo chức năng × hành động — trigger kiểm có trong `permission`). Người dùng thấy màn khi một vai trò còn hiệu lực của họ (`user_role` chưa thu hồi, trong hạn) có quyền còn hiệu lực ở ít nhất 1 chức năng của màn; dòng có `warehouse_type` chỉ tính khi phạm vi vai trò là kho loại đó (thủ kho kho điều phối thấy Lệnh SX qua `QT19.xl`, Theo dõi mẻ qua `QT20.t0,t1`; thủ kho kho tổng không). View `v_user_screen` trả danh sách màn từng người dùng; phân hệ không còn màn nào thì ẩn. Nguồn nạp: mục "Màn × chức năng" của file quy trình, `mes-powder-gen-quyen.py` sinh cùng lúc với bảng quyền và dừng nếu có chức năng có vai trò mà không thuộc màn nào (trừ bước PC xưởng của Công nhân). Không giữ ma trận menu riêng. **Sửa 04/11:** 37 màn, 12 phân hệ theo menu mockup (thêm Tổng quan, Hồ sơ & biểu mẫu in — luôn hiện như Việc cần làm); bỏ `screen_function.warehouse_type`: Thủ kho điều phối là vai trò riêng nên không cần cờ loại kho.
34. **Chủ theo dòng, một schema hai nơi (20/10 đợt 2).** `sync_policy(table_name, owner_group, factory_column, derived_columns)`: nhóm CLOUD (cloud chủ, sao xuống theo `factory_id` nếu có, kéo theo dòng cha), NM (nhà máy chủ dòng của mình, sao lên), CLOUD_ONLY, NM_ONLY, NOI_PHAT_SINH (nơi tạo dòng là chủ, gộp lên cloud). Nạp sẵn bằng `mes-powder-gen-du-lieu.py` từ trường `site` / `derived` của mô hình bảng (cột Nơi của mục 10) — không sửa tay. Ứng dụng đặt `app.site` (CLOUD / NM) và `app.factory_id` cho mỗi kết nối; trigger `trg_site_guard` chặn: cloud ghi bảng nhóm NM (trừ cập nhật chỉ cột dẫn xuất); nhà máy ghi bảng nhóm CLOUD; nhà máy ghi dòng nhóm NM của nhà máy khác. Bộ áp dụng đồng bộ đặt `app.sync_apply = on` để ghi bản sao; không đặt `app.site` (công cụ nạp, phép thử cũ) thì trigger không làm gì. Lô có phần ở 2 nhà máy: `stock_line` tách theo `factory_id`, đầu lô `lot` chủ = nhà máy tạo lô; cận date không lưu — view `v_lot_expiry` tính từ `exp_date` + tham số, mỗi nơi tự tính.
35. **Kênh lệnh từ trung tâm (`site_command`, `command_inbox`).** Cloud lập lệnh `(factory_id, seq, kind, payload, status CHO_GUI → DA_GUI → DA_AP_DUNG | TU_CHOI, result_text)`; kind: PHAT_LENH, HUY_LENH, KET_THUC_SOM, HUY_ME, ME_BU, KHOA_LO, MO_KHOA_LO, KHOA_TAI_KHOAN, SILO_BAO_TRI, DOI_LOAI_KHU, GIAM_KL_ME, YEU_CAU_XUAT, DE_NGHI_CHUYEN. Nhà máy kéo theo `seq`, ghi `command_inbox` (nhóm NM), áp dụng trong 1 giao dịch kèm kiểm điều kiện thực tế, ghi kết quả (TU_CHOI bắt buộc lý do) — kết quả lên cloud qua hàng đợi, trigger `trg_command_inbox_result` chiếu sang lệnh (kiểm sổ lệnh khớp nhà máy, số thứ tự, loại). Trạng thái lệnh chỉ đi tới, nội dung lệnh không sửa (`trg_site_command_status`). Thay `downstream_change.op = 'KHOA'`; `production_order.nm_ack_at` / `nm_cancel_confirmed_at` / kết thúc sớm, `batch_cancellation`, `lot_lock`, `app_user` (khóa) được chiếu từ kết quả lệnh. `lot_lock` thành dòng áp dụng của từng nhà máy (`factory_id`, `site_command_id`, `applied_at`; unique theo lô × lý do × nhà máy); lệnh khóa tới sau khi nhà máy đã nạp silo phần lô đó → nhà máy ghi `sync_conflict` (có `site_command_id`) và tự khóa hàng sinh ra (QT19 kz).
36. **Vận chuyển đồng bộ: outbox, nhà máy chủ động nối.** `sync_outbox` (thay `sync_event`) ghi bằng trigger `trg_sync_outbox` AFTER INSERT / UPDATE trên mọi bảng nhóm NM và NOI_PHAT_SINH khi `app.site = NM` (trừ `code_sequence`): `event_type = DONG`, `table_name`, `record_key`, `op`, `payload` = bản ghi sau thay đổi, `seq_no` từ sequence của máy chủ nhà máy, `offline` theo `app.offline`; sự kiện SX có nghĩa giữ `event_type` cũ. Nhà máy `POST /sync/push` từ seq cloud đã xác nhận, `GET /sync/pull?after=` lấy bản sao nhóm CLOUD (`downstream_change`) + lệnh; cloud áp dụng tuần tự theo seq từng nhà máy dưới `pg_advisory_xact_lock(factory_id)`, upsert theo khóa chính với `app.sync_apply = on`, không kiểm lại nghiệp vụ (nhà máy là chủ sự thật vật lý; chỉ dừng luồng khi thiếu tham chiếu, báo Admin), rồi chạy bộ chiếu. Bỏ trùng: `sync_event_inbox.event_id` khóa chính + `source_event_id` unique (giữ). Không dùng đồng hồ để quyết; `occurred_at` chỉ hiển thị; lệch giờ quá `sync.clock_skew_warn_minutes` thì cảnh báo. Outbox giữ `sync.outbox_retain_days` ngày sau khi cloud xác nhận rồi dọn (bảng duy nhất được xóa). Cloud khôi phục từ sao lưu: so `factory_sync_state.last_applied_seq` với nhà máy, yêu cầu gửi lại; nhà máy gửi lại `command_inbox` để cloud dựng lại trạng thái lệnh. Khởi tạo lại nhà máy: gói = nhóm CLOUD + dòng nhóm NM của nhà máy theo bản đồng bộ + lệnh đang mở; lô / vị trí có biến động sau lần xác nhận cuối → `stocktake` KIEM_DIEM nguồn `KHOI_TAO_LAI` (QT19 c3).
37. **Mã chứng từ nhà máy có tiền tố nhà máy (20/10 đợt 2).** `code_format` thêm 9 mẫu `{loai}-{nha_may}-{yymm}-{so:4}` (phiếu nhập PN, xuất PX, chuyển PC, kiểm kho PK, hủy PH, yêu cầu kiểm YC, phiếu kiểm QC, chứng nhận CN, mẫu lưu ML — vd `PN-NM1-2610-0001`); bộ đếm ở `code_sequence` `owner_site = 'NM'`, `factory_id` bắt buộc (check). Mã bao NVL cũng sinh tại máy chủ nhà máy khi nhập. Mã danh mục, đơn, PO, lệnh, đợt giao, truy xuất, thu hồi giữ bộ đếm cloud.
38. **Bản sao khách / đơn xuống nhà máy bỏ cột tiền, liên hệ, công nợ (20/10 đợt 3 — chốt câu 37).** Giữ khóa ngoại yêu cầu xuất bán (trước 24/10: đợt giao) → đơn → khách ở máy chủ nhà máy (phiếu xuất bán in được tên khách, địa chỉ giao khi mất mạng), chỉ sao xuống đơn có `factory_id` = nhà máy đó và khách của các đơn ấy. Cột không sao xuống ghi ở `sync_policy.masked_columns` (sinh từ trường `masked` của mô hình bảng); bộ sao xuống đọc dòng qua `sync_down_row(bảng, dòng jsonb)` — bản sao nhà máy để trống các cột đó. Cột vốn bắt buộc được nới ở mức bảng; trigger `trg_masked_required` bắt buộc lại khi `app.site` khác NM (cloud, công cụ nạp). Mua hàng (NCC, PO) giữ như cũ — chưa che.
39. **Bỏ báo giá (chốt 04/11).** Bỏ `quotation`, `quotation_line` và trigger báo giá. Nhu cầu mua (`purchase_request_line`) gộp thành Hàng đợi mua theo NVL × kho nhận; Mua hàng nhập đơn giá, chọn NCC rồi lập PO (dòng cùng NCC × kho nhận gộp 1 PO; dòng nhu cầu trỏ `po_line_id`), hoặc trả về Kế hoạch kèm lý do để chọn cách bù khác. PO hủy / từ chối / đóng phần còn lại → gỡ liên kết, dòng nhu cầu về Mở.
40. **PO kiểm COA & HSD trước khi duyệt, cọc + trả nốt (30/10, 31/10).** PO lập ra ở Chờ COA & HSD (trigger); Mua hàng gửi NCC 1 email yêu cầu COA và hạn dùng cho mọi NVL, kiểm từng NVL theo chỉ tiêu COA của danh mục NVL (`purchase_order_coa_result`, chép giới hạn lúc kiểm; dòng PO giữ file COA, NSX, HSD, kết quả). Sang Chờ chọn thanh toán chỉ khi mọi dòng đạt và đủ kết quả mọi chỉ tiêu; không đạt thì hủy PO, NVL quay lại Hàng đợi mua. Hình thức thanh toán chọn sau COA: Trả trước / Cọc + trả nốt trước giao (`deposit_pct`) / Trả sau N ngày — cùng kiểu ở NCC; PO trả trước hoặc cọc + trả nốt không chọn giảm công nợ khi trả hàng.
41. **Mô hình SP mới (chốt 04/11).** 1 mã SP (1 barcode) có nhiều quy cách (`product_pack`), mỗi quy cách nhiều tầng (`product_pack_level`: tầng 1 có KL / thể tích tịnh, tầng trên ghi số đơn vị tầng dưới). Ô Cấu trúc / Nhóm / Phân loại / Độ tuổi chọn từ `product_option` (trigger đúng loại, đang dùng); thương hiệu và thông tin khác gõ tự do (`extra_attributes`). Mỗi quy cách một mẫu nhãn có phiên bản, QC trưởng duyệt (`product_label`, trigger vai trò); bản công bố và hồ sơ riêng ở `product_document`. Sau khi lưu, thông tin SP và quy cách khóa theo mã — đổi thì sao chép thành mã mới. Lệnh BTP chọn quy cách ở từng dòng nhãn hiệu; điều kiện thêm: SP có bản công bố còn hiệu lực và quy cách có mẫu nhãn hiện hành đã duyệt (trigger trên `production_order_brand`).
42. **Hồ sơ pháp lý chung (chốt 04/11).** `legal_document` (mã HS-, loại, số, cơ quan cấp, ngày cấp, hạn — trống = không thời hạn, nhắc trước N ngày, nhiều file) + `legal_document_scope` (từng nhà máy hoặc từng SP); phạm vi mọi SP / SP của nhà máy / SP chọn. Trạng thái hiệu lực tính từ hạn, không lưu. Xóa được.
43. **Yêu cầu chuyển YCC- và phiếu chuyển "lập là chấp nhận" (chốt 30/10).** `transfer_request` do nhà máy nhận gửi trên cloud (1 NVL / SP × SL × ngày cần, kho xuất → kho nhận, nguồn: Kế hoạch thêm tay / cân đối NVL / cách bù khi tạo lệnh / phần còn lại), sao xuống nhà máy nguồn; Kế hoạch nhà máy nguồn (nội bộ: Thủ kho điều phối) gom yêu cầu cùng kho xuất → kho nhận vào 1 phiếu chuyển (dòng trỏ `transfer_request_id`) — lập phiếu là chấp nhận, hoặc từ chối kèm lý do. Trạng thái yêu cầu chỉ đi tới (trigger), Trên phiếu / phiếu chuyển do cloud chiếu từ phiếu của nhà máy nguồn. Một nhà máy có nhiều kho điều phối; mỗi khu HH / BTP chọn 1 kho điều phối cấp NVL (`work_area.supply_warehouse_id`, trigger cùng nhà máy, loại DIEU_PHOI).
44. **Phạm vi quyền theo vai trò / theo quyền (chốt 04/11).** `role.factory_scope` (mọi nhà máy / nhà máy của tài khoản / cố định 1 nhà máy) áp cho các quyền để "Theo vai trò"; `role_permission.scope_mode` cho từng quyền (theo vai trò / mọi nhà máy / nhà máy của tài khoản / cố định). Phạm vi từng người vẫn ở `user_role` (đổi vai trò). Phạm vi thật của 1 thao tác = giao của phạm vi quyền và phạm vi gán vai trò.
45. **Xóa bản ghi chưa dùng (chốt 04/11).** `forbid_delete` cho qua ở tài khoản, đơn vị, lựa chọn SP, quy cách SP (2 bảng), quyền, hồ sơ pháp lý chung (2 bảng); khóa ngoại không cascade chặn khi đã có dòng trỏ tới. Tài khoản thêm trigger: chỉ xóa khi chưa có phiên đăng nhập, gỡ luôn dòng gán vai trò, nhật ký tài khoản giữ lại (bỏ trỏ, ghi mã NV) và thêm dòng XOA.
46. **Bản lưu & nhật ký in (chốt 04/11).** `document_snapshot` giữ PDF của phiếu / biên bản / hóa đơn tại lúc ký; in lại luôn từ bản lưu, đóng dấu BẢN SAO, mỗi lần in 1 dòng `document_print_log` (người, lúc, số bản, lý do) — số lần in đếm từ đây.

## 3. Cloud ↔ server nhà máy

Sửa 20/10 (đợt 2) — chủ theo dòng; nhóm từng bảng nạp sẵn ở `sync_policy` (quyết định 34–36). Thay bảng cũ (cloud chủ trạng thái lô, tồn, mọi chứng từ; nhà máy chỉ chủ dữ liệu xưởng, giữ `lot_status_replica`).

| Nhóm (`sync_policy`) | Chủ | Chiều | Bảng |
|---|---|---|---|
| CLOUD — cloud chủ, sao xuống chỉ đọc (lọc `factory_id` nếu có, kéo theo dòng cha theo khóa ngoại) — 57 bảng; khách / đơn / yêu cầu xuất bán bỏ cột tiền, liên hệ, công nợ (`masked_columns`, quyết định 38) | Cloud | Cloud → nhà máy (`downstream_change`) | danh mục (factory, work_area, uom, material, material_spec_item, product + product_option / product_pack / product_pack_level / product_label / product_document, legal_document + scope, product_spec_item, formula + version / item, warehouse, equipment, lock_reason, lot_status_transition, code_format, system_parameter, sync_policy); tài khoản & quyền (app_user gồm băm mật khẩu, role, permission, role_permission, user_role, user_delegation, screen, screen_function); lệnh (production_order + brand / silo, material_reservation — cột dẫn xuất `issued_kg`, batch_cancellation, site_command); chứng từ nhà máy cần (customer, sales_order + version / line, sales_order_lot, delivery + line, delivery_note + line, supplier, purchase_request, purchase_order + line, transfer_request (cột dẫn xuất trạng thái / phiếu chuyển), supplier_return + line, recall_case, recall_lot, trace_request) |
| NM — máy chủ nhà máy của dòng chủ, sao lên — 47 bảng | Nhà máy | Nhà máy → cloud (`sync_outbox`) | lô & mã: lot, handling_unit, stock_line, lot_link, inventory_txn, lot_status_log, lot_lock (dòng áp dụng), scan_log, label_incident; kho: 18 bảng (goods_receipt…, stock_transfer — cột dẫn xuất SL đã nhận do cloud chiếu khi chuyển 2 nhà máy, …, disposal_line); QC: qc_request, qc_request_part, qc_inspection, qc_result_item, quality_certificate, retained_sample, retained_sample_event; xưởng: production_batch, batch_operator, batch_equipment_usage, silo_charge, filling_run, carton_recount, 5 bảng ⏸ của mẻ, ncr; sync_conflict, command_inbox |
| NOI_PHAT_SINH — nơi tạo dòng là chủ — 6 bảng | Nơi phát sinh | Nhà máy → cloud (gộp) | user_session, audit_log, file_attachment, document_snapshot, document_print_log; code_sequence (mỗi nơi giữ bộ đếm của mình, không gộp) |
| NM_ONLY — 2 bảng | Nhà máy | — | sync_outbox, offline_session |
| CLOUD_ONLY — 28 bảng | Cloud | — | thu chi & công nợ (sales_order_invoice, payment_schedule, payment_voucher, payment_allocation, ar_entry, ap_entry), credit_limit_request, customer_contact_log, sales_order_status_log, supplier_* (certificate, material, history, status_log), purchase_request_line, purchase_order_coa_result, account_change_log, job_title_role, catalog_retire_request, trace_result_lot / customer, mass_balance_result, recall_customer / authority_report / resolution, capa, sync_event_inbox, factory_sync_state, downstream_change |

Bộ chiếu ở cloud (chạy sau khi áp dụng sự kiện nhà máy): `goods_issue_scan` SAN_XUAT → `material_reservation.issued_kg`; mẻ đầu DANG_CHAY → lệnh DANG_CHAY, mọi mẻ xong + silo xả sạch → HOAN_THANH; `goods_receipt` MUA_HANG → `purchase_order_line.received_qty`, PO NHAN_MOT_PHAN / DA_NHAN_DU; `goods_issue` BAN DA_XUAT → yêu cầu xuất bán DA_XUAT, đơn DANG_GIAO (24/10); `goods_receipt` CHUYEN_KHO của nhà máy nhận → `stock_transfer_line.received_qty` / `damaged_qty` của nhà máy xuất (cột dẫn xuất, rồi sao xuống nhà máy xuất); kết luận QC TP ĐẠT đủ lô của đơn → đơn SAN_SANG_GIAO (QT23 dg); `goods_receipt` THU_HOI → SL thu về của khách; `command_inbox` → `site_command` (trigger) → `production_order.nm_ack_at` / `nm_cancel_confirmed_at` / kết thúc sớm, `batch_cancellation`, `app_user` (khóa).

Luồng mất kết nối (QT19 k1–k7, kl, không giới hạn thời gian): mọi màn Kho / Chất lượng / Theo dõi mẻ và PC xưởng chạy trên tồn thật tại máy chủ nhà máy; hàng đợi gửi lên ghi liên tục (cờ `offline`); lệnh cloud lập trong lúc đó nằm CHO_GUI. Có mạng → nhà máy đẩy hàng đợi theo seq, kéo bản sao + lệnh; áp lệnh có kiểm điều kiện; xung đột chỉ còn lệnh khóa lô tới muộn (QT19 kz), lô HỦY bị dùng, tồn âm → `sync_conflict` ghi tại nhà máy. Mỗi lần mất kết nối ghi `offline_session`. Cloud mất / khôi phục từ sao lưu, khởi tạo lại máy chủ nhà máy: quyết định 36, QT19 c1–c4.

## 4. Lô — trạng thái, lý do khóa, nhật ký

- 5 trạng thái ở `stock_line.status`: CHO_KIEM / DAT / KHONG_DAT / KHOA / HUY. "Còn hạn", "đã hết", "đang chuyển", "đang kiểm kê", "dưới ngưỡng SX" **không** là trạng thái: còn hạn tính từ `lot.exp_date`; đã hết = tổng SL 0; đang chuyển = dòng tồn có `stock_transfer_id` (thay vị trí "trên xe" 24/10 đợt 9); đang kiểm kê = `stocktake_lock`; dưới ngưỡng SX = view `v_lot_shelf` (tính từ `exp_date` + `production.min_shelf_days`; bỏ cận date và `v_lot_expiry` 24/10 đợt 9).
- 4 loại lô + lô mẻ + lô bột hỏng: `lot_kind` NVL_MUA (gồm bao bì) / HH / BTP / TP / ME / HONG. BTP đạt QC → đổi `lot_kind` thành TP trên cùng dòng (`converted_to_tp_at`). HONG = bột hỏng của mẻ hủy do sự cố (QT20): không HSD, nối từ lô mẻ, sinh ra là KHÓA chờ hủy.
- Lý do khóa (`lock_reason`, nạp sẵn): KHACH_TRA, TIM_LAI, HU_KHI_NHAN, HU_CHO_TRA_NCC, KHOANH_VUNG, XUNG_DOT, CHO_HUY, HET_HAN, THU_HOI — mỗi dòng có phạm vi, cho gửi QC không, lối ra, độ chặt.
- Chuyển trạng thái (`lot_status_transition`, nạp sẵn 38 dòng): tách từ bảng chuyển trạng thái của mục "Vòng đời lô hàng" theo từng trạng thái nguồn, thêm 1 dòng "KHÓA → KHÓA đổi sang lý do chặt hơn" theo quy tắc 2 lý do cùng lúc. Sửa 17/10: thêm dòng "lô mới → KHÓA chờ hủy" của bột hỏng mẻ hủy (QT20 ky); dòng thất lạc (QT16) ghi thêm Thủ kho trưởng xác nhận.
- Nhật ký (`lot_status_log`): lô, phần lô, kho, các bao bị đổi (`handling_unit_ids`), SL, từ → sang (kèm lý do khóa), QT + bước, dòng chuyển trạng thái đã dùng, người, thời điểm, chứng từ, lý do, file, sự kiện nguồn.
- Phần lô gửi QC lưu trạng thái trước ở `qc_request_part` (và `stock_line.prev_status`) → QC trưởng / Thủ kho trưởng từ chối thì trả về đúng trạng thái + lý do cũ.

## 5. Liên kết lô và 3 truy vấn của truy xuất (QT25)

Các loại liên kết trong `lot_link` (cha → con, kèm `qty` + `uom_code`):

| link_type | Cha → con | Ghi lúc | Ghi chú |
|---|---|---|---|
| NAP_SILO | lô NVL / lô HH → nút silo của lệnh (`lot_kind = SILO`) | quét bao nạp silo (QT20 g1), kể cả nạp bổ sung | bắt buộc có mã bao; thay DO_VAO_ME (bỏ 19/10 đợt 3) |
| XA_SILO | nút silo → lô mẻ | silo xả định lượng cho mẻ (QT20 ys) | chỉ mẻ của đúng lệnh, ≤ bột đang có |
| RA_ME | lô mẻ → lô HH / lô BTP-TP / lô bột hỏng | dán QR bao HH (QT20); quét lon đầu của nhãn hiệu (QT21); Kế hoạch hủy mẻ (QT20 ky) | lô HH / BTP / HONG không có dòng này → không COMMIT được |
| BAO_BI | lô bao bì lon / thùng → lô BTP-TP | chiết rót (QT21) | cách biết lô bao bì: xem câu hỏi 5 |
| NVL_DU | lô gốc → lô NVL dư trả về; nút silo → lô bột dư cuối lệnh (đợt 3) | nhập kho NVL dư (QT14); xả bột dư (QT20 xd) | lô dư nhận trạng thái theo khóa cả lô của lô gốc / các lô đã nạp vào nút |

Mắt xích sau lô: thùng → phiếu xuất = `goods_issue_scan`; phiếu xuất bán → ghi nhận giao → khách = `delivery_note.goods_issue_id` → `delivery_note_line` → `goods_issue.sales_order_id` → `sales_order.customer_id` (sửa 24/10 — bỏ đợt giao). Bao → phiếu chuyển = `goods_issue_scan` của phiếu xuất loại CHUYEN_KHO.

**Qua nút silo (19/10 đợt 3, cách B):** từ lô mẻ đi ngược qua XA_SILO tới nút silo, rồi chỉ lấy các NAP_SILO có `linked_at` ≤ `linked_at` của lần xả đó (lô nạp sau lần xả không thể có trong mẻ); đi xuôi thì ngược lại. Silo không lần nào xả sạch trong lệnh thì cách này cho kết quả như "mọi lô nạp vào silo là đầu vào của mọi mẻ sau đó"; có xả sạch thì nút bị đóng, nút mới tách truy xuất. Cân bằng khối lượng (5.3) cho lô NVL đã nạp silo tính ở mức nút: tổng nạp = tổng xả cho mẻ + bột dư (+ bột còn trong nút đang mở). Truy vấn và kết quả mẫu 5.1–5.3 dưới đây chạy 17/10 trên chuỗi cũ (DO_VAO_ME — bao đổ thẳng vào mẻ); với chuỗi mới chỉ thêm 1 bước qua nút silo với điều kiện thời điểm trên (đã thử ở 5.8 S10).

### 5.1 Truy ngược (từ lô TP về mẻ, NVL, bao bì, NCC)

```sql
with recursive edge as (           -- gộp nhiều lần quét cùng cặp lô thành 1 cạnh
  select parent_lot_id, child_lot_id, link_type, uom_code, production_batch_id,
         sum(qty) as qty, count(*) as so_lan_quet
  from lot_link
  group by parent_lot_id, child_lot_id, link_type, uom_code, production_batch_id
),
nguoc as (
  select l.id as lot_id, 0 as depth, array[l.id] as path,
         null::text as link_type, null::numeric as qty, null::text as uom, null::uuid as batch_id
  from lot l where l.id = $1
  union all
  select e.parent_lot_id, n.depth + 1, n.path || e.parent_lot_id,
         e.link_type, e.qty, e.uom_code, e.production_batch_id
  from nguoc n join edge e on e.child_lot_id = n.lot_id
  where e.parent_lot_id <> all (n.path)          -- chặn vòng lặp
)
select n.depth as cap, repeat('  ', n.depth) || l.lot_no as lo, l.lot_kind as loai,
       coalesce(m.code, p.code, 'mẻ ' || b2.batch_no) as mat_hang,
       n.link_type as qua_lien_ket, n.qty || ' ' || n.uom as kl_vao_lo_con,
       b.batch_no as me, s.name as ncc, l.supplier_lot_no as lo_ncc, l.exp_date as hsd
from nguoc n
join lot l on l.id = n.lot_id
left join material m on m.id = l.material_id
left join product p on p.id = l.product_id
left join production_batch b on b.id = n.batch_id
left join production_batch b2 on b2.id = l.production_batch_id and l.lot_kind = 'ME'
left join supplier s on s.id = l.supplier_id
order by n.path;
```

Kết quả chạy thử từ lô TP `A261011` (nhãn A):

```
 cap |        lo        |  loai   |   mat_hang   | qua_lien_ket | kl_vao_lo_con |    me     |      ncc      | lo_ncc
-----+------------------+---------+--------------+--------------+---------------+-----------+---------------+-------
   0 | A261011          | TP      | SP-A         |              |               |           |               |
   1 |   A-ME-0002      | ME      | mẻ A-ME-0002 | RA_ME        | 24.000 LON    | A-ME-0002 |               |
   2 |     A-HH-0001    | HH      | HH-X         | DO_VAO_ME    | 25.000 KG     | A-ME-0002 |               |
   3 |       A-ME-0001  | ME      | mẻ A-ME-0001 | RA_ME        | 25.000 KG     | A-ME-0001 |               |
   4 |         L-BOT-01 | NVL_MUA | BOT-A        | DO_VAO_ME    | 20.000 KG     | A-ME-0001 | Công ty NVL 1 | S-111
   4 |         L-PG-01  | NVL_MUA | PG-B         | DO_VAO_ME    | 5.000 KG      | A-ME-0001 | Công ty NVL 1 | S-222
   1 |   L-THUNG-01     | NVL_MUA | THUNG-24     | BAO_BI       | 1.000 CAI     | A-ME-0002 | Công ty NVL 1 | S-444
   1 |   L-LON-01       | NVL_MUA | LON-800      | BAO_BI       | 24.000 CAI    | A-ME-0002 | Công ty NVL 1 | S-333
```

Hồ sơ QC / COA / mẫu lưu / NCR của từng lô gom thêm bằng `lot_id` (qc_inspection, goods_receipt_line.coa_file_id, retained_sample, ncr) rồi chép vào `trace_result_lot.documents`.

### 5.2 Truy xuôi (từ lô NVL tới lô TP, khách đã nhận, phần còn tồn)

```sql
with recursive edge as (
  select parent_lot_id, child_lot_id, link_type, uom_code, sum(qty) as qty
  from lot_link group by parent_lot_id, child_lot_id, link_type, uom_code
),
xuoi as (
  select l.id as lot_id, 0 as depth, array[l.id] as path, null::text as link_type
  from lot l where l.id = $1
  union all
  select e.child_lot_id, x.depth + 1, x.path || e.child_lot_id, e.link_type
  from xuoi x join edge e on e.parent_lot_id = x.lot_id
  where e.child_lot_id <> all (x.path)
),
khach as (                                      -- thùng → phiếu xuất → biên bản → khách
  select dnl.lot_id, c.code as khach, sum(dnl.accepted_qty) as sl_nhan, max(gi.code) as phieu_xuat
  from delivery_note_line dnl
  join delivery_note dn on dn.id = dnl.delivery_note_id
  join goods_issue gi on gi.id = dn.goods_issue_id        -- sửa 24/10: ghi nhận giao gắn thẳng phiếu xuất bán
  join sales_order so on so.id = gi.sales_order_id
  join customer c on c.id = so.customer_id
  group by dnl.lot_id, c.code
),
ton as (                                        -- sửa 24/10 đợt 9: hàng đang chuyển = dòng tồn trên phiếu chuyển
  select sl.lot_id,
         sum(sl.qty) filter (where sl.status <> 'HUY' and sl.stock_transfer_id is null) as con_ton,
         sum(sl.qty) filter (where sl.status <> 'HUY' and sl.stock_transfer_id is not null) as dang_chuyen
  from stock_line sl
  group by sl.lot_id
)
select x.depth as cap, repeat('  ', x.depth) || l.lot_no as lo, l.lot_kind as loai, x.link_type as qua_lien_ket,
       string_agg(k.khach || ': ' || k.sl_nhan || ' (' || k.phieu_xuat || ')', '; ') as khach_da_nhan,
       max(t.con_ton) as con_ton, max(t.dang_chuyen) as dang_chuyen,
       (select string_agg(hu.code, ',') from handling_unit hu where hu.lot_id = l.id and hu.unit_type = 'THUNG') as thung
from xuoi x
join lot l on l.id = x.lot_id
left join khach k on k.lot_id = x.lot_id
left join ton t on t.lot_id = x.lot_id
group by x.path, x.depth, l.id, l.lot_no, l.lot_kind, x.link_type
order by x.path;
```

Kết quả chạy thử từ lô NVL `L-BOT-01`:

```
 cap |       lo        |  loai   | qua_lien_ket |    khach_da_nhan     | con_ton | dang_chuyen |  thung
-----+-----------------+---------+--------------+----------------------+---------+---------+---------
   0 | L-BOT-01        | NVL_MUA |              |                      |  20.000 |         |
   1 |   A-ME-0001     | ME      | DO_VAO_ME    |                      |         |         |
   2 |     A-HH-0001   | HH      | RA_ME        |                      |   0.000 |         |
   3 |       A-ME-0002 | ME      | DO_VAO_ME    |                      |         |         |
   4 |         B261011 | TP      | RA_ME        |                      |   2.000 |   2.000 | AT000002
   4 |         A261011 | TP      | RA_ME        | KH1: 20.000 (PX-001) |   2.000 |         | AT000001
```

### 5.3 Cân bằng khối lượng từng lô (SX = giao + tồn + đang chuyển + hủy + mẫu lưu)

Công thức tổng quát cho mọi loại lô: **SL vào** (lô SX và lô bột hỏng: Σ liên kết RA_ME; lô mua: Σ nhập mua / NVL dư; cộng hàng tìm lại) **+ điều chỉnh kiểm kho = dùng cho SX + giao (trừ hàng khách trả / thu hồi về) + trả NCC + mẫu + hủy + tồn + đang chuyển**. Với lô TP thì dùng cho SX và trả NCC = 0 → đúng công thức "SX = giao + tồn + đang chuyển + hủy + mẫu lưu". Lô bột hỏng của mẻ hủy: SL vào = số kg bỏ, toàn bộ ra ô hủy.

```sql
with recursive lots(id) as (                      -- lô bắt đầu + mọi lô truy xuôi được
  select $1::uuid
  union                                           -- UNION (không ALL) tự chặn vòng lặp
  select k.child_lot_id from lot_link k join lots on k.parent_lot_id = lots.id
),
so_kho as (
  select t.lot_id,
    sum(t.qty_delta) filter (where t.txn_category in ('NHAP_MUA','NHAP_NVL_DU'))                     as nhap_mua,
    sum(t.qty_delta) filter (where t.txn_category = 'NHAP_TIM_LAI')                                  as tim_lai,
    -sum(t.qty_delta) filter (where t.txn_category = 'XUAT_SX')                                      as dung_sx,
    -sum(t.qty_delta) filter (where t.txn_category in ('XUAT_BAN','NHAP_KHACH_TRA','NHAP_THU_HOI'))  as giao,
    -sum(t.qty_delta) filter (where t.txn_category = 'XUAT_TRA_NCC')                                 as tra_ncc,
    -sum(t.qty_delta) filter (where t.txn_category in ('LAY_MAU_LUU','LAY_MAU_KIEM'))                as mau,
    sum(t.qty_delta) filter (where t.txn_category = 'DIEU_CHINH')                                    as dieu_chinh
  from inventory_txn t group by t.lot_id
),
ton as (
  select sl.lot_id,
    sum(sl.qty) filter (where sl.status = 'HUY')                                     as huy,
    sum(sl.qty) filter (where sl.status <> 'HUY' and sl.stock_transfer_id is null)     as con_ton,
    sum(sl.qty) filter (where sl.status <> 'HUY' and sl.stock_transfer_id is not null) as dang_chuyen
  from stock_line sl group by sl.lot_id
),
sx_ra as (select child_lot_id as lot_id, sum(qty) as qty from lot_link where link_type = 'RA_ME' group by child_lot_id),
bang as (
  select l.lot_no, l.lot_kind, l.uom_code,
    case when l.lot_kind in ('HH','BTP','TP','HONG') then coalesce(r.qty, 0) else coalesce(k.nhap_mua, 0) end
      + coalesce(k.tim_lai, 0) as sl_vao,
    coalesce(k.dung_sx, 0) as dung_sx, coalesce(k.giao, 0) as giao, coalesce(k.tra_ncc, 0) as tra_ncc,
    coalesce(k.mau, 0) as mau, coalesce(t.huy, 0) as huy, coalesce(t.con_ton, 0) as con_ton,
    coalesce(t.dang_chuyen, 0) as dang_chuyen, coalesce(k.dieu_chinh, 0) as dieu_chinh
  from lot l join lots on lots.id = l.id
  left join so_kho k on k.lot_id = l.id
  left join ton t on t.lot_id = l.id
  left join sx_ra r on r.lot_id = l.id
  where l.lot_kind <> 'ME'                         -- lô mẻ không có tồn; hao hụt mẻ tính riêng
)
select *, sl_vao + dieu_chinh - (dung_sx + giao + tra_ncc + mau + huy + con_ton + dang_chuyen) as lech
from bang order by lot_no;
```

Kết quả chạy thử (cố tình cho phiếu nhập kho nhãn B ghi 5 lon trong khi chiết rót đếm 6):

```
  lot_no   | lot_kind | sl_vao | dung_sx |  giao  | mau   |  huy  | con_ton | dang_chuyen | lech
-----------+----------+--------+---------+--------+-------+-------+---------+---------+------
 A-HH-0001 | HH       | 25.000 |  25.000 |      0 |     0 |     0 |   0.000 |       0 | 0.000
 A261011   | TP       | 24.000 |       0 | 20.000 | 2.000 |     0 |   2.000 |       0 | 0.000
 B261011   | TP       |  6.000 |       0 |      0 |     0 | 1.000 |   2.000 |   2.000 | 1.000   ← lệch → biên bản + kiểm kho
 L-BOT-01  | NVL_MUA  | 40.000 |  20.000 |      0 |     0 |     0 |  20.000 |       0 | 0.000
```

Kết quả mỗi lần chạy ghi vào `mass_balance_result`; check `diff = 0 or stock_discrepancy_id is not null` bắt buộc lệch phải mở phiếu lệch tồn → kiểm điểm (QT17).

### 5.4 Ràng buộc đã thử (cả 10 đều bị chặn đúng — chạy lại 19/10: 10 / 10 đúng; đợt 2: 10 / 10; đợt 3, đợt 4: 10 / 10)

| Thử | Kết quả |
|---|---|
| `DELETE` 1 lô | chặn: "Không xóa cứng…" |
| Tạo lô HH không có liên kết ra mẻ | chặn lúc COMMIT, cả giao dịch hủy |
| Ghi quét bao OK không kèm `lot_link` (đợt 3: quét bao nạp silo — `silo_charge`) | chặn (check) |
| Liên kết lô TP "đổ vào mẻ" (đợt 3: "nạp silo" vào lô mẻ) | chặn: sai loại lô cha / con |
| Phần lô KHÓA không có lý do | chặn (check) |
| Người tạo tự duyệt phiếu nhập | chặn (check) |
| Gửi lại cùng 1 sự kiện 2 lần | chỉ 1 dòng |
| Lô đang khoanh vùng cả lô, thêm phần ĐẠT | chặn (trigger) |
| Công nhân không gắn khu vực / không có mã thẻ | chặn (check) |
| Tạo lệnh SX với nơi tạo = server nhà máy | chặn (check) |

### 5.5 Ràng buộc mới 17/10 (lần 2) — đã thử, 20 / 20 đúng; chạy lại 19/10: 17 / 17 đúng, bỏ 3 phép về phiếu chi; đợt 2, đợt 3, đợt 4: 17 / 17

| Thử | Kết quả |
|---|---|
| HR gán vai trò Người truy xuất | chặn (trigger): chỉ Admin gán |
| Admin gán vai trò Người truy xuất | cho qua |
| HR tự gán vai trò cho chính mình | chặn (check) |
| Ủy quyền tạm vai trò Sales (không có quyền duyệt) | chặn (trigger) |
| Ủy quyền tạm không có ngày hết hạn | chặn (bắt buộc) |
| Ủy quyền QC trưởng 7 ngày + dòng vai trò tạm khớp phiếu | cho qua |
| Dòng vai trò tạm lệch hạn / phạm vi so với phiếu ủy quyền | chặn (trigger) |
| ~~Phiếu chi chốt khi Kế toán trưởng chưa duyệt~~ | **bỏ 19/10** — quy tắc Kế toán trưởng duyệt phiếu chi đã bỏ |
| ~~Người lập phiếu chi tự duyệt~~ | **bỏ 19/10** — `payment_voucher` không còn `approved_by` |
| ~~Kế toán lập, Kế toán trưởng duyệt, chốt phiếu chi~~ | **bỏ 19/10** — không còn trạng thái chờ duyệt; thay bằng 5.6 "ghi nhận hoàn tiền không qua duyệt" |
| Lô bột hỏng không có liên kết ra mẻ | chặn lúc COMMIT |
| Hủy mẻ đủ bước: mẻ ĐÃ HỦY, lô bột hỏng nối từ lô mẻ, phiếu hủy tự tạo, cộng 1 mẻ bù | cho qua; cân bằng khối lượng lô bột hỏng: vào 480 kg = hủy 480 kg, lệch 0 |
| Mẻ ĐÃ HỦY không ghi giờ kết thúc | chặn (check) |
| Từ chối phiếu hủy bột hỏng của mẻ hủy | chặn (check): chỉ dời ngày |
| Thủ kho trưởng tự xác nhận biên bản thất lạc do chính mình lập | chặn (check) |
| Đóng hồ sơ thu hồi khi GĐ chưa duyệt đóng | chặn (check) |
| QC trưởng tự duyệt CAPA do chính mình lập | chặn (check) |
| Hoàn tiền thu hồi chưa có GĐ / KTT duyệt (19/10: bản ghi nhận hoàn tiền đã có, vẫn chặn vì thiếu người duyệt số tiền) | chặn (check) |
| Mẫu lưu ĐÃ HỦY không ghi người hủy | chặn (check) |
| Hủy PO không ghi lý do | chặn (check) |

### 5.6 Ràng buộc mới 19/10 — đã thử, 46 / 46 đúng (đợt 2, đợt 3, đợt 4: 46 / 46)

Chạy `claude/mes-powder-phep-thu.sql` sau `claude/mes-powder-du-lieu.sql` trên PostgreSQL 16.15 (CSDL trống), lần cuối 19/10 đợt 4: 5.4 → 10 / 10 (11 dòng kiểm), 5.5 → 17 / 17 (18 dòng kiểm, bỏ 3), 5.6 → 46 / 46, 5.7 → 81 / 81, 5.8 → 42 / 42, 5.9 → 45 / 45. Đợt 4 sửa dữ liệu nền: `product` bỏ `brand_name` → nạp trước thương hiệu, dòng, hạng, hạng của dòng, quy cách; SP-0001 / SP-0002 trỏ tới 4 danh mục; 5.7 "Q2" đếm 221 thao tác. Đợt 3 sửa dữ liệu nền: LSX-001 / 002 tạo ở Mới tạo kèm phương án silo trong 1 giao dịch rồi phát, chạy (phương án chỉ sửa khi Mới tạo); 5.4 "quét bao OK không kèm lot_link" ghi vào `silo_charge`, 5.4 "liên kết lô TP sai loại" dùng NAP_SILO. Đợt 2 sửa dữ liệu nền cho khớp ràng buộc mới, không đổi ý phép thử cũ: khu HH có KL mẻ tối đa, thêm khu BTP + 3 silo, công thức có thành phần, LSX-001 / LSX-002 thuộc khu BTP và có tệp giấy tờ xuất xứ, LSX-001 có phương án silo; 5.4 "quét bao OK không kèm lot_link" ghi đúng silo (chỉ còn thiếu liên kết); 5.4 "lệnh nơi tạo = nhà máy" đủ cột mới (chỉ còn sai nơi tạo); 5.6 "nạp silo" kèm khu, sức chứa, mã SCADA.

| Thử | Kết quả |
|---|---|
| Ghi nhận hoàn tiền cho khách không qua duyệt | cho qua |
| Ghi nhận tiền về thiếu ảnh chứng từ | chặn (bắt buộc) |
| Ghi nhận 40 triệu, cấn khoản cọc 30 + trả nốt 10 | cho qua |
| Cấn thêm vượt số tiền đã ghi nhận | chặn (trigger) |
| Cấn vào bản ghi nhận đã hủy | chặn (trigger) |
| Hủy bản ghi nhận không ghi lý do | chặn (check) |
| Bản ghi thu mà mục đích là hoàn tiền | chặn (check) |
| Ghi xóa nợ (`ar_entry` loại XOA_NO) | chặn (check) |
| Ghi kết quả nợ quá 90 ngày vào khoản không phải công nợ / vào khoản công nợ | chặn / cho qua |
| Đợt giao có file hóa đơn mà không có số / có đủ số + file | chặn / cho qua; `sales_invoice` không còn |
| Trưởng BP tự quyết dòng rà soát của chính mình | chặn (check) (bỏ 28/10 — không còn bảng) |
| Gỡ vai trò mà không ghi vai trò bị gỡ | chặn (check) (bỏ 28/10 — không còn bảng) |
| Xác nhận rà soát bộ phận khi còn dòng chưa quyết | chặn (trigger) (bỏ 28/10 — không còn bảng) |
| Quyết đủ từng dòng (dòng của Trưởng BP do Admin quyết) rồi xác nhận | cho qua (bỏ 28/10 — không còn bảng) |
| Dòng rà soát có gợi ý lạ | chặn (check) (bỏ 28/10 — không còn bảng) |
| Ủy quyền ngày bắt đầu ở tương lai vẫn HIEU_LUC — "Sắp bắt đầu" suy ra từ ngày | đúng |
| Ủy quyền tạm vai trò Kế hoạch | cho qua |
| Đề nghị ngừng dùng kho / thiết bị | chặn (check) |
| Người khác rút đề nghị ngừng dùng / người đề xuất rút | chặn / cho qua |
| ~~Ngừng dùng ô còn hàng / ô trống (có ghi lần in tem QR)~~ — bỏ 24/10 đợt 9 (không còn vị trí kệ) | — |
| Mã công thức sai loại `CT-BTP-05` cho HH / thiếu chữ số `CT-HH-1` / đúng `CT-HH-02` | chặn / chặn / cho qua |
| Định dạng mã nạp sẵn có công thức, không còn thiết bị đo; thêm định dạng thiết bị đo | đúng; chặn (check) |
| Truy vấn "lệnh đang chạy phiên bản cũ" | trả đúng LSX-001 |
| Thông số trộn chuẩn có thứ tự nạp | đúng |
| Nạp thiết bị loại thiết bị đo / thêm silo (đợt 2: kèm khu, sức chứa, mã SCADA) | chặn / cho qua; `equipment` không còn 3 cột thiết bị đo |
| Nhật ký quét có mã thay thế khi không phải mã đã khóa / quét trúng mã đã khóa | chặn / cho qua |
| Tem mất không chọn lô; hủy tem bao còn trên kệ ghi như tem hỏng | chặn (check) |
| Tem mất đủ bước: ô + lô từ dòng tồn, khóa mã cũ, cấp mã mới cùng lô, quét xác nhận (24/10 đợt 9: kho + lô — xem 5.14 L2) | cho qua |
| Quyền nạp sẵn: Sales có XEM công nợ, không có quyền ghi nhận; Kế toán trưởng không còn quyền duyệt ở thu chi, vẫn xem mọi công nợ; không còn thao tác "phiếu chi", "xóa nợ" | đúng |
| 7 vai trò ủy quyền được đúng danh sách chốt; không có tham số mật khẩu | đúng |

### 5.7 Ràng buộc mới 19/10 (đợt 2) — đã thử, 79 / 79 đúng; đợt 3 viết lại 7 phép theo chốt mới, chạy lại 81 / 81; đợt 4: 81 / 81 (Q2 đếm 221 thao tác)

| Thử | Kết quả |
|---|---|
| Khu BTP không có KL mẻ tối đa; khu loại "khác" | chặn (check) |
| Silo không gắn khu / thiếu mã SCADA; bồn trộn ở trạng thái Bảo trì, có sức chứa | chặn (check) |
| Silo gắn khu chiết rót | chặn (trigger): chỉ khu HH / BTP |
| Hai silo trùng tên trong 1 khu | chặn (unique) |
| Đổi loại khu còn lệnh đang chạy / khu không còn lệnh; xóa khu | chặn (trigger) / cho qua; chặn (không xóa cứng) |
| Lệnh HH ở khu BTP; KL mẻ 600 kg > tối đa 500 kg | chặn (trigger) |
| Lệnh không có tệp giấy tờ xuất xứ NVL; lệnh Mới tạo không có thứ tự hàng đợi | chặn (bắt buộc / check) |
| Tạo lệnh mà phương án silo thiếu NVL | chặn lúc COMMIT |
| Xếp NVL vào silo gán cứng NVL khác; quá sức chứa; 2 NVL vào 1 silo | chặn (trigger / trigger / unique) |
| Tạo 2 lệnh Mới tạo đủ phương án silo, giữ chỗ KG | cho qua |
| Hai lệnh cùng thứ tự trong hàng đợi của khu | chặn (ràng buộc loại trừ, lúc COMMIT) |
| Phát lệnh không ở đầu hàng; đổi thứ tự trong 1 giao dịch rồi phát đầu hàng | chặn / cho qua |
| Silo chuyển Bảo trì → 2 lệnh chưa phát dùng silo đó thành "cần xếp lại", lệnh đang chạy không đổi | đúng |
| Phát lệnh khi cần xếp lại; đánh dấu đã xếp lại khi vẫn dùng silo bảo trì; xếp NVL vào silo bảo trì | chặn (trigger) |
| Xếp lại sang silo khác rồi chốt; phát lệnh → Đã nhận, ra khỏi hàng đợi | cho qua; đúng |
| Đã nhận → Hoàn thành; Đã nhận → Mới tạo | chặn (trigger) |
| Sửa lệnh Đã nhận (số mẻ) — đợt 3: lệnh đã phát không sửa | chặn (trigger); lệnh giữ nguyên |
| Hủy lệnh không lý do; hủy kèm lý do → giữ chỗ giải phóng hết | chặn (check); cho qua, đúng |
| Hủy lệnh đang chạy; xóa lệnh | chặn (trigger) |
| Lệnh HH ở khu HH; kế hoạch nhãn hiệu cho lệnh HH; nhãn hiệu khác công thức | cho qua; chặn; chặn (trigger) |
| Nhãn hiệu nhiều dòng trên lệnh Mới tạo (cùng SP, 2 số lô in + 1 dòng chưa biết số lô); trùng dòng; thêm nhãn hiệu vào lệnh đã phát (đợt 3) | cho qua; chặn (unique, null coi như bằng nhau); chặn (trigger) |
| Quét bao nạp sai silo của phương án; nạp OK không ghi nút silo; nạp OK đúng silo, mở nút silo + liên kết lô → nút (đợt 3) | chặn (trigger); chặn (check); cho qua |
| Phiên máy quét; web đăng nhập bằng quét thẻ; web mật khẩu + PC xưởng quét thẻ | chặn; chặn; cho qua |
| Tem mất không ghi ô của dòng tồn (24/10 đợt 9: không ghi kho — xem 5.14 L1) | chặn (check) |
| NCC trả sau không số ngày; trả trước có số ngày; điều khoản chữ tự do | chặn (check) |
| Lấy báo giá → yêu cầu Đang mua; hủy báo giá không lý do; hủy có lý do → yêu cầu về Mở; lấy lại báo giá cùng NCC; báo giá từ yêu cầu đã xong | đúng; chặn; đúng; cho qua; chặn |
| Trả vượt SL đã nhận của PO (cộng phiếu trả khác; dòng có lô — đợt 3) / trả vừa đủ | chặn (trigger) / cho qua |
| Giảm công nợ khi PO trả trước / trả sau | chặn (trigger) / cho qua |
| Kho lập phiếu xuất trả khi Mua hàng chưa gửi yêu cầu; Chờ kho xuất trả không ghi lúc gửi | chặn (trigger / check) |
| Gửi yêu cầu xuất trả → Thủ kho lập phiếu → cập nhật Đã xuất trả khi phiếu chưa xuất / sau khi Thủ kho trưởng duyệt, xuất xong | cho qua → chặn / cho qua |
| Phiếu chưa duyệt sang Chờ bên yêu cầu; Thủ kho tự chọn thay bên yêu cầu; Chờ bên yêu cầu → Đã xuất | chặn (trigger / check / trigger) |
| Đã duyệt, thiếu không có lô thay thế → Chờ bên yêu cầu; Sales (bên yêu cầu) nhận phần đã lấy → Xuất một phần | cho qua |
| Quyền mới (QT02.ks, QT19.ys / q1 / hl, QT12.tq, QT13.tx, Mua hàng ở QT15 dq), 221 thao tác (sau đợt 4; đợt 3: 219), không còn "máy quét", không còn MAY_QUET, có bảng phương án silo | đúng |

### 5.8 Ràng buộc mới 19/10 (đợt 3) — đã thử, 42 / 42 đúng (đợt 4: 42 / 42)

| Thử | Kết quả |
|---|---|
| Nạp bổ sung vào nút silo (25 → 225 kg); nạp thêm vượt sức chứa 400 kg | cho qua; chặn (trigger) |
| Nạp lô NVL khác vào nút silo; mở nút cho silo đang bảo trì; mở nút thứ 2 cho cùng lệnh × silo khi nút cũ chưa đóng | chặn (trigger / trigger / unique) |
| Silo xả 150 kg cho mẻ; xả vượt bột đang có; xả cho mẻ của lệnh khác | cho qua; chặn; chặn (trigger) |
| Nạp bổ sung sau lần xả; truy xuất cách B: đầu vào của mẻ chỉ gồm lô nạp trước lần xả | cho qua; đúng |
| Xác nhận silo xả sạch khi còn bột; chuyển silo bảo trì khi còn bột; hoàn thành lệnh khi silo chưa xả sạch | chặn (trigger) |
| Lô bột dư trỏ về nút silo mà không có liên kết; xả bột dư thành lô NVL dư (HSD theo lô sớm nhất), đóng nút; cân bằng ở mức silo nạp 425 = xả 150 + dư 275 | chặn lúc COMMIT; cho qua; đúng |
| Kết thúc sớm không lý do; khi còn mẻ chạy dở; mẻ xong rồi kết thúc sớm (1 mẻ thực tế) → giữ chỗ còn lại giải phóng; kết thúc sớm lệnh chưa chạy | chặn (check / trigger); cho qua, đúng; chặn |
| Hủy lệnh Đã nhận khi nhà máy chưa xác nhận; gửi hủy (lệnh vẫn Đã nhận); nhà máy xác nhận → Đã hủy | chặn; cho qua, đúng; cho qua |
| Phát lệnh đầu hàng không tới → Chờ phát giữ vị trí; phát lệnh sau khi lệnh Chờ phát còn đứng trước; lệnh Mới tạo lấy thứ tự trùng lệnh Chờ phát; nhà máy nhận rồi phát lệnh sau | cho qua; chặn; chặn (loại trừ); cho qua |
| Giảm KL mẻ tối đa của khu xuống dưới KL mẻ của lệnh Mới tạo rồi phát | chặn (trigger) |
| Silo chuyển bảo trì → lệnh Mới tạo thành "cần xếp lại", lệnh đã phát không đổi; Start mẻ mới của lệnh đã phát dùng silo bảo trì | đúng; chặn (trigger) |
| Phiếu trả không gắn PO; dòng trả khác ĐVT gốc; trả vượt tồn của lô; dòng không lô (từ chối ở cửa kho) vượt số đã nhận | chặn (bắt buộc / trigger / trigger); cho qua |
| Xuất SX thiếu → Chờ bên yêu cầu, Kế hoạch nhận phần đã lấy | cho qua |
| Quyền đợt 3 (QT19.su, kt; QT19.hl chỉ hủy; QT20.vs, xd); cấu trúc (silo_charge, không còn DO_VAO_ME, cột silo trên lot_link, cột bản sửa) | đúng |

### 5.9 Ràng buộc mới 19/10 (đợt 4) — đã thử, 45 / 45 đúng

| Thử | Kết quả |
|---|---|
| Tạo SP với hạng không thuộc dòng; số lon / thùng ngoài quy cách; KL tịnh lon khác quy cách; trùng tổ hợp thương hiệu × dòng × hạng × công thức × quy cách × số lon | chặn (trigger ×3 / unique) |
| Tạo SP đúng 4 danh mục (Nhãn A, Sữa bột trẻ em, Số 2, QCD-01, 12 lon) | cho qua |
| Thương hiệu trùng tên khác hoa / thường; quy cách có số lượng 0 / không có số lượng nào; gán 1 hạng cho dòng 2 lần | chặn (unique / check / unique có điều kiện) |
| Bỏ 24 khỏi QCD-01 khi SP dùng 24; thêm 48; đổi KL tịnh quy cách khi còn SP dùng; bỏ hạng Số 1 khỏi dòng khi SP dùng | chặn; cho qua; chặn; chặn (trigger) |
| Đề nghị ngừng dùng thương hiệu / dòng / hạng / quy cách; đề nghị ngừng dùng khách hàng | cho qua; chặn (check) |
| Duyệt → ngừng Nhãn B khi SP-0002 ĐANG DÙNG; ngừng SP-0002 rồi ngừng Nhãn B; tạo SP với thương hiệu đã ngừng; ngừng hạng còn SP dùng | chặn; cho qua; chặn; chặn (trigger) |
| Cấu trúc: `product` không còn `brand_name`, có 4 khóa ngoại; `code_format` có THH / DSP / HSP / QCD, 9 loại đang dùng | đúng |
| Đề nghị tự lập không lệnh nguồn; ngược chiều (kho điều phối → kho tổng); phiếu người lập ở DE_NGHI | chặn (check / trigger / check) |
| Hệ thống tự lập đề nghị cho LSX-106 (dòng NVL + 120 kg, chưa lô); lập đề nghị thứ 2 khi đề nghị cũ chưa gửi; cập nhật SL thiếu 120 → 150 kg; dòng không lô không NVL | cho qua; chặn (unique có điều kiện); cho qua; chặn (check) |
| Thủ kho bấm Gửi; gửi không ghi người / lúc gửi; Kế hoạch gửi → CHO_XAC_NHAN; quay về DE_NGHI | chặn; chặn; cho qua; chặn (trigger) |
| Gán lô khác NVL; xuất khi dòng chưa có lô; gán lô FEFO rồi xuất; bỏ lô sau khi xuất | chặn; chặn; cho qua; chặn (trigger) |
| Lập đề nghị mới khi đề nghị cũ đã gửi; hủy LSX-106 → đề nghị chưa gửi thành DA_HUY, đề nghị đã gửi giữ DA_XUAT; lập đề nghị cho lệnh đã hủy | cho qua; đúng; chặn (trigger) |
| Phiếu xuất SX lập từ kho tổng; từ kho điều phối; đổi kho phiếu SX sang kho tổng | chặn; cho qua; chặn (trigger) |
| Bảng chuyển trạng thái: lô nghi lỗi ĐẠT → CHỜ KIỂM ở QT22 y1, không dòng QT22 nào → KHÓA, khoanh vùng chỉ ở QT26 / QT18 | đúng |
| Quyền đợt 4 (QT16.ya,kg, QT19.dc,yd,tg,d2 của Kế hoạch; QT20.t0,t1 tạo của Thủ kho; Thủ kho không còn quyền QT19); 19 vai trò, 221 thao tác, 242 + 19 dòng gán | đúng |

### 5.10 Admin không toàn quyền, menu suy ra từ quyền (20/10) — đã thử, 20 / 20 đúng

File riêng `claude/mes-powder-phep-thu-20-10.sql` (chạy sau `mes-powder-du-lieu.sql` trên CSDL trống). Thay 2 phép đếm cũ 5.7 Q2 (221 thao tác) và 5.9 Q7 (Admin 221 dòng) của `mes-powder-phep-thu.sql`.

| Thử | Kết quả |
|---|---|
| Admin không có quyền duyệt nào, không có bước nghiệp vụ QT03–QT26, có `QT01.xa`; Giám đốc có `QT01.xa`; mô tả vai trò Admin không còn "toàn quyền" | đúng |
| Đếm: 19 vai trò, 226 thao tác, 280 dòng gán, Admin 15 dòng | đúng |
| Quyền mới: Kế hoạch hủy yêu cầu mua (`QT12.th`); QT22 gửi + bổ sung (`QT22.t1,t2` tạo / sửa); `QT15.s` bỏ "kho khác"; 7 quyền xem mới cho menu | đúng |
| 34 màn / 10 phân hệ, chỉ Việc cần làm hiện cho mọi người, mọi màn khác có `QT01.xa`; mọi chức năng có vai trò (trừ PC xưởng) thuộc ít nhất 1 màn | đúng |
| Gắn chức năng không có trong bảng quyền; màn thuộc phân hệ lạ; gắn trùng chức năng vào cùng màn | chặn (trigger / check / unique) |
| Menu: Admin, Giám đốc 34 màn; CSKH = Việc cần làm, Khách hàng, Hồ sơ thu hồi; HR = Việc cần làm, Người dùng & vai trò, Nhật ký; Sales 10 màn; ~~Trưởng bộ phận = NVL, Sản phẩm, Người dùng & vai trò~~ (bỏ vai trò 28/10) | đúng |
| Thủ kho kho tổng không thấy Lệnh SX / Theo dõi mẻ, thủ kho kho điều phối thấy (cùng vai trò, khác phạm vi kho) | đúng |
| Thu hồi vai trò → chỉ còn Việc cần làm; gỡ 1 quyền của màn còn quyền khác → vẫn thấy màn | đúng |

### 5.11 Chủ dữ liệu theo dòng, kênh lệnh, hàng đợi gửi lên (20/10 đợt 2) — đã thử, 42 / 42 đúng

File riêng `claude/mes-powder-phep-thu-20-10-dot2.sql` (chạy sau `mes-powder-du-lieu.sql` trên CSDL trống, PostgreSQL 16; nơi chạy giả lập bằng `set_config('app.site' / 'app.factory_id' / 'app.sync_apply' / 'app.offline', …, true)`). Chạy lại cùng lúc: 5.10 → 20 / 20. File `mes-powder-phep-thu.sql` (5.4–5.9) chưa chạy lại lần này; khi chạy, phép 5.9 C15 đổi kết quả mong đợi (18 định dạng mã đang dùng, không còn 9).

| Thử | Kết quả |
|---|---|
| `sync_policy` có đúng 1 dòng / bảng (140), 5 nhóm 56 / 49 / 29 / 4 / 2; nhóm của tồn, phiếu nhập, QC, mẻ, lệnh, khách, thu chi, hàng đợi, tệp; cột dẫn xuất phiếu chuyển | đúng |
| Cấu trúc: không còn `lot_status_replica`, `sync_event`, cột cận date của lô, op KHOA, `offline.max_hours`; có `site_command`, `command_inbox`, `v_lot_expiry`, 2 tham số đồng bộ | đúng |
| Máy chủ NM1 ghi khách hàng / tạo lệnh SX / lập lệnh trung tâm (bảng cloud chủ) | chặn (trigger) |
| Máy chủ NM1 ghi phần lô của NM2; ghi khóa cả lô không gắn nhà máy | chặn (trigger) |
| Máy chủ NM1 (mất kết nối) nhập phần lô của mình → cùng giao dịch 1 dòng hàng đợi DONG / INSERT / ngoại tuyến / người ghi / payload | cho qua; đúng |
| Cloud sửa SL phần lô của nhà máy; bộ áp dụng đồng bộ ghi bản đồng bộ (không sinh hàng đợi ở cloud) | chặn; cho qua, đúng |
| Cloud chiếu SL đã nhận lên phiếu chuyển của NM1 (cột dẫn xuất); cloud sửa SL yêu cầu | cho qua; chặn |
| Máy chủ nhà máy ghi mà chưa đặt `app.factory_id` | chặn |
| Máy chủ NM1 lưu ảnh (nơi phát sinh) → vào hàng đợi, seq_no tăng dần; lập phiếu kiểm điểm nguồn KHOI_TAO_LAI | cho qua; đúng |
| Lệnh KHOA_LO lập khi NM1 mất mạng (Chờ gửi); sửa nội dung lệnh; Từ chối không lý do | cho qua; chặn; chặn |
| NM1 kéo lệnh (sổ lệnh Đã nhận) → lệnh Đã gửi; NM1 áp: dòng khóa NM1 kèm mã lệnh; khóa lần 2 cùng lô / lý do; NM2 áp phần của NM2; xung đột lệnh khóa tới muộn (không khóa ngoại tới inbox) | đúng; cho qua; chặn (unique); cho qua; cho qua |
| Sổ lệnh Đã áp dụng → lệnh Đã áp dụng; đưa lệnh về Chờ gửi; sổ lệnh lệch loại; từ chối hủy mẻ không lý do / có lý do → lệnh Từ chối kèm lý do | đúng; chặn; chặn; chặn; cho qua, đúng |
| Xác nhận lúc mất mạng cho phiếu chuyển không phải đề nghị tự lập | chặn (check) |
| 18 định dạng mã (9 danh mục + 9 chứng từ nhà máy `{loai}-{nha_may}-{yymm}-{so:4}`); bộ đếm nhà máy không ghi nhà máy; 2 nhà máy cùng bộ đếm PN tháng 10 | đúng; chặn; cho qua |
| `v_lot_expiry`: NVL còn 20 ngày → mức 2; còn 200 ngày → 0; quá hạn → đã hết hạn, mức 3 | đúng — bỏ 24/10 đợt 9, thay bằng `v_lot_shelf` (5.14 S1) |
| Quyền: QT16.kq (Thủ kho trưởng duyệt), không còn QT20.d1, vẫn 226 / 280; màn Chuyển kho có QT16.kq, Theo dõi mẻ không còn QT20.d1 | đúng |

### 5.12 Bản sao khách / đơn xuống nhà máy bỏ cột tiền, liên hệ, công nợ; mã công thức 4 số (20/10 đợt 3) — đã thử, 16 / 16 đúng

File riêng `claude/mes-powder-phep-thu-20-10-dot3.sql` (chạy sau `mes-powder-du-lieu.sql` trên CSDL trống, PostgreSQL 16).

| Thử | Kết quả |
|---|---|
| `sync_policy.masked_columns`: khách 13, đơn 2, phiên bản đơn 7, dòng đơn 2, đợt giao 4; bảng khác trống | đúng |
| `sync_down_row`: khách giữ mã, tên, địa chỉ giao, trạng thái, bỏ MST / liên hệ / SĐT / hạn mức / cờ khóa nợ; dòng đơn giữ SP, SL, ngày giao, bỏ đơn giá / thuế suất; bảng không che giữ nguyên | đúng |
| Cloud / công cụ nạp tạo khách thiếu SĐT; cloud xóa SĐT khách; cloud tạo phiên bản đơn thiếu tổng tiền | chặn (trigger) |
| Cloud tạo khách đủ SĐT; máy chủ nhà máy ghi bản sao khách, đơn, phiên bản đơn không có tiền / liên hệ | cho qua |
| Máy chủ nhà máy tự sửa khách (không qua đồng bộ); ghi bản sao đơn trỏ tới khách chưa có ở nhà máy | chặn (trigger; khóa ngoại) |
| Mã công thức 2 số `CT-HH-01`; sai loại `CT-BTP-0005` cho HH; đúng `CT-HH-0001`; định dạng nạp sẵn `CT-{loai}-{so:4}` | chặn; chặn; cho qua; đúng |

### 5.13 Giao hàng chỉ ghi nhận (24/10) — đã thử, 19 / 19 đúng; đợt 3–4 thêm 11 phép, chạy lại 30 / 30

File riêng `claude/mes-powder-phep-thu-24-10.sql` (chạy sau `mes-powder-du-lieu.sql` trên CSDL trống, PostgreSQL 16). Thay các phép cũ dính đợt giao / số đếm: 5.6 N9a–N9b, 5.7 X2–X5 (dữ liệu nền dùng `delivery`), 5.10 Q2 / S1 / M1 / M4, 5.11 P1 / Q1, 5.12 S1.

| Thử | Kết quả |
|---|---|
| Cấu trúc: không còn `delivery`, `delivery_line`, cột `delivery_id`; có `sales_issue_request` (+ dòng), `sales_order_invoice`; 141 bảng, CLOUD 56 / NM 49 / CLOUD_ONLY 30; masked khách 12, yêu cầu xuất bán 1 | đúng |
| Khách bỏ MAT, `lost_at`; bỏ 3 tham số giao hàng, giữ chờ thu đủ 14 ngày; đặt khách trạng thái MAT | đúng; chặn |
| Phiếu xuất bán không gắn yêu cầu xuất bán; phiếu thứ 2 cho cùng yêu cầu; yêu cầu mang trạng thái cũ CHO_LIEN_HE | chặn (check; unique; check) |
| Ghi nhận giao cho phiếu bán chưa xuất xong; gắn phiếu chuyển kho; thiếu ngày khách nhận; ghi nhận lần 2 cùng phiếu | chặn (trigger; trigger; not null; unique) |
| Phiếu xuất bán Đã xuất → Sales ghi nhận giao (ngày nhận, người ký, ảnh biên bản) | cho qua |
| 2 hóa đơn cho cùng đơn; trùng số hóa đơn trong đơn; hóa đơn không có số | cho qua; chặn; chặn |
| Quyền / màn (chạy lại đợt 3): 219 thao tác, 273 dòng gán (đợt 2 bỏ thao tác vị trí kệ, đợt 3 thêm hủy yêu cầu xuất), Admin 15, 33 màn, không còn `BAN_GIAO_HANG`; Sales QT09.t2 / t5, Kế toán QT10.t1 tạo; Vận chuyển không còn QT09; menu Sales có Đơn hàng, Khách hàng; Vận chuyển chỉ Việc cần làm, Chuyển kho | đúng |
| Đợt 3 — dòng yêu cầu lấy lô không gắn đơn; lô ở nhà máy khác; lô khác SP của dòng đơn; tổng 2 yêu cầu vượt SL gắn đơn | chặn (trigger) |
| Đợt 3 — hủy yêu cầu không lý do; nhà máy trả về không lý do; lập phiếu xuất bán khi yêu cầu còn Chờ thanh toán | chặn (check; check; trigger) |
| Đợt 3 — yêu cầu 200 / 240 lon; hủy có lý do rồi yêu cầu khác lấy đủ 240; yêu cầu Chờ xuất → máy chủ nhà máy tự lập phiếu xuất bán ở Đã duyệt | cho qua |
| Đợt 4 — máy chủ nhà máy lập phiếu xuất bán ở Chờ duyệt | chặn (trigger) |

### 5.14 Bỏ vị trí kệ, bỏ cận date, ngưỡng hạn tối thiểu cho SX (24/10 đợt 9) — đã thử, 23 / 23 đúng

File `claude/mes-powder-phep-thu-24-10-kho.sql` (chạy sau `mes-powder-du-lieu.sql` trên CSDL trống). Thay các phép thử cũ dính vị trí kệ / cận date / số đếm: 5.4-5, 5.4-8, 5.5-12a, 5.6 N18a–b, N24c, 5.7 T1, 5.9 C15 (dữ liệu nền `location`), 5.13 K2, Q1.

| Phép thử | Kết quả |
|---|---|
| Cấu trúc: không còn `location`, `stock_relocation`, `expiry_alert`, `v_lot_expiry`, cột `*location_id`; có `v_lot_shelf`, `stock_line.stock_transfer_id`; 138 bảng, CLOUD 55 / NM 47 / CLOUD_ONLY 30 / NOI_PHAT_SINH 4 / NM_ONLY 2; không còn mã VI_TRI, giá trị DOI_VI_TRI / CAT_HANG / SAI_O / TREN_XE / HANG_LOI | đúng |
| Tham số: bỏ `expiry.alert_*`, có `production.min_shelf_days` = 30, giữ nhắc lô hết hạn chưa hủy 30 ngày; quyền 216 thao tác / 269 dòng gán / Admin 15 / 33 màn, không còn QT18.tk,dk, màn KHO_HUY tên "Hủy hàng" | đúng |
| Dòng tồn không kho, không phiếu chuyển / vừa kho vừa phiếu chuyển | chặn (check) |
| Cùng lô, cùng kho: dòng ĐẠT (bao lành) + dòng KHÓA hư khi nhận (bao hư) | cho qua |
| Dòng ĐẠT thứ 2 cùng lô × kho × trạng thái | chặn (unique) |
| Hàng đang chuyển: dòng tồn trên phiếu chuyển, không thuộc kho nào | cho qua |
| Tem mất không ghi kho / ghi đủ lô + kho | chặn (check) / cho qua |
| Cờ đang kiểm kê trên 1 lô trong kho | cho qua |
| `v_lot_shelf`: NVL còn 10 ngày dưới ngưỡng 30, còn 100 ngày đạt, lô hết hạn, TP không xét ngưỡng | đúng |
| Quét xuất SX lô còn 10 ngày / còn 100 ngày; quét xuất chuyển kho lô còn 10 ngày; ghi đè ngưỡng theo mã NVL = 7 ngày | chặn / cho qua / cho qua / cho qua |
| Quét bao nạp silo OK lô còn 10 ngày / lần quét bị chặn vẫn ghi nhật ký / lô còn 100 ngày | chặn / cho qua / cho qua |
| Xả silo cho mẻ khi nút có lô đã nạp nay hết hạn / mọi lô còn hạn | chặn / cho qua |

### 5.15 Bỏ vai trò Trưởng bộ phận, bỏ rà soát quyền (28/10) — đã thử, 26 / 26 đúng

File riêng `claude/mes-powder-phep-thu-28-10.sql` (chạy sau `mes-powder-du-lieu.sql` trên CSDL trống, PostgreSQL 16.15). Thay các phép đếm cũ 5.10 Q2, 5.13 Q1, 5.14 K2, 5.14 Q1, phép menu 5.10 M6 (Trưởng bộ phận) và 5 phép rà soát ở 5.6.

| Thử | Kết quả |
|---|---|
| 135 bảng — CLOUD 55 / CLOUD_ONLY 28 / NM 46 / NM_ONLY 2 / NOI_PHAT_SINH 4 | đúng |
| 18 vai trò (không còn TRUONG_BP), 214 thao tác, 267 dòng gán, Admin 15 dòng | đúng |
| Không còn quyền `QT01.r2`, `r5`, `hr`, bảng `access_review(+line)`, 2 tham số rà soát; giữ tự khóa 90 ngày | đúng |
| `QT02.d4` đúng Trưởng BP Mua hàng, Thủ kho trưởng, QC trưởng; `QT02.tk` chỉ Kế hoạch; `tg`, `tr` là Mua hàng, Thủ kho, QC; Kế hoạch vẫn tạo / sửa mã | đúng |
| Vai trò ủy quyền được còn 6; mọi vai trò có quyền duyệt (trừ Admin) ủy quyền được | đúng |
| Dòng không mã QT01 đánh số lại (#6 Nhật ký, #7 Vai trò × quyền, #8 Tham số); màn gắn đúng; mọi chức năng có vai trò thuộc ít nhất 1 màn | đúng |
| Nhật ký tài khoản loại RA_SOAT | chặn (check) |
| Menu: Trưởng BP Mua hàng, Thủ kho trưởng, QC trưởng thấy NVL, Sản phẩm; HR giữ nguyên | đúng |
| Kế hoạch tự ngừng (NGUNG_TRUC_TIEP, không người duyệt) / Kế hoạch gửi chờ duyệt | cho qua / chặn (check) |
| Mua hàng ngừng trực tiếp; ngừng trực tiếp có người duyệt; bộ phận ghi chữ tự do | chặn (check) |
| Mua hàng gửi → tự duyệt / Trưởng BP Mua hàng duyệt | chặn / cho qua |
| Kho đề nghị bị từ chối có lý do; QC gửi → đổi sang NGUNG_TRUC_TIEP / QC trưởng duyệt | cho qua; chặn / cho qua |

## 6. Các ô chờ quyết ở sản xuất / chất lượng (⏸ — chỉ chừa chỗ, chưa thiết kế nghiệp vụ)

Lưu ý: file quy trình (sửa 17/10) đã vẽ các ô ở Vận hành mẻ / Chiết rót thành bước thật; theo yêu cầu lần này, sơ đồ dữ liệu vẫn để chúng ở trạng thái chờ quyết (xem câu hỏi 1). Đã thôi chờ quyết (chốt 17/10): bộ chỉ tiêu BTP / TP (`product_spec_item`, QC nhập ở danh mục SP), điều kiện bảo quản mẫu (`sample_storage_condition`), hủy mẻ do sự cố (`batch_cancellation`). Đã chốt 19/10 (đợt 2–3): liên kết silo → mẻ (ô số 2, dưới).

| # | Ô chờ quyết | Chừa chỗ ở đâu | Đã có sẵn (không phụ thuộc ô này) |
|---|---|---|---|
| 1 | Vận hành mẻ — chặn bao sai | cột ⏸ `silo_charge.block_reason` | `scan_result` OK / CHAN; kiểm lô ĐẠT, còn hạn theo vòng đời lô hàng; `scan_log` ghi lý do chặn |
| 2 | ~~Vận hành mẻ — liên kết silo → mẻ~~ **Đã chốt 19/10 (đợt 2–3), thôi chờ quyết:** phương án silo của lệnh (`production_order_silo`) cho biết NVL nào vào silo nào; silo nạp nhiều mẻ nên mỗi silo của lệnh là 1 nút trong chuỗi lô (`lot_kind = SILO`): lô —NAP_SILO→ nút —XA_SILO→ lô mẻ, nối theo thời điểm (cách B), xả sạch thì đóng nút; quét bao nạp silo ở `silo_charge`. Bỏ 2 cột ⏸ `lot_link.silo_equipment_id`, `batch_material_scan.silo_equipment_id` (silo nằm ở nút) | — | liên kết bao → nút silo → mẻ (bắt buộc); xác nhận van mở từ SCADA vẫn thuộc phần IoT (mục 7) |
| 3 | Vận hành mẻ — phiếu NCR (luồng duyệt, nội dung) | bảng ⏸ `ncr` (mã, nguồn, lô, mẻ, SL, jsonb, trạng thái tự do) | các bảng khác đã trỏ được tới `ncr`; người lập = Kế hoạch (chốt 17/10) |
| 4 | Vận hành mẻ — thông số trộn | bảng ⏸ `batch_mixing_param` (1 dòng / mẻ, jsonb) | thông số trộn chuẩn ở `formula_version.mixing_params` |
| 5 | Vận hành mẻ — sự cố dừng máy (trường bắt buộc, nối dữ liệu máy) | bảng ⏸ `batch_downtime` (mẻ, thiết bị, từ – đến, jsonb) | mẻ có trạng thái DUNG_SU_CO; không khắc phục được thì hủy mẻ (`batch_cancellation`, đã chốt) |
| 6 | Vận hành mẻ — KL thực tế vs công thức (bao HH ra mẻ) | bảng ⏸ `batch_weight_check` (mẻ, bao, mục tiêu, thực tế, jsonb) | KL từng bao ở `handling_unit.qty` |
| 7 | Chiết rót — in NSX / HSD / lô lên lon | cột ⏸ `filling_run.printed_lot_no / printed_mfg_date / printed_exp_date` | `lot.lot_no`, `mfg_date`, `exp_date` của lô BTP; số lô in trên lon dự kiến ở kế hoạch nhãn hiệu `production_order_brand.printed_lot_no` (nếu đã biết — 19/10 đợt 2) |
| 8 | Chiết rót — cân từng lon | bảng ⏸ `filling_can_weight` | bộ đếm lon đạt / loại ở `filling_run` |

## 7. Điểm nối dữ liệu cảm biến (IoT / SCADA — chưa thiết kế)

Không có bảng dữ liệu cảm biến. Chỉ chừa 3 điểm nối để sau gắn chuỗi thời gian vào:
- `equipment.iot_source_ref` — mã thiết bị / tag gốc trên SCADA (unique). Danh sách thiết bị SX do bên cung cấp thiết bị đưa, nạp khi triển khai (không có màn quản lý — chốt 19/10); riêng silo do Admin thêm ở cấu hình khu vực làm việc, mã SCADA bắt buộc (19/10 đợt 2).
- `batch_equipment_usage` (mẻ, thiết bị, từ – đến) — khoảng thời gian thiết bị chạy cho mẻ nào.
- `production_batch.started_at / ended_at`, `batch_downtime.started_at / ended_at`, `filling_run.started_at / ended_at`.

Truy vấn sau này: dữ liệu cảm biến của mẻ X = chuỗi thời gian có tag = `iot_source_ref` của thiết bị trong `batch_equipment_usage` của X, trong khoảng `started_at – ended_at`. Hai ô ⏸ "thông số trộn" và "cân từng lon" có thể chuyển hẳn sang phần dữ liệu máy khi quyết IoT.

## 8. Tham số mặc định (nạp sẵn vào `system_parameter`)

| Khóa | Giá trị | QT | Ý nghĩa |
|---|---|---|---|
| account.idle_lock_days | 90 ngày | Phân quyền | Không đăng nhập quá N ngày thì tự khóa |
| account.lock_notice_days | 3 ngày | Phân quyền | Báo trước ngày khóa |
| credit.wait_remind_days / wait_auto_reject_days | 3 / 7 ngày | Kiểm công nợ | Chờ quá 3 ngày nhắc Sales, quá 7 ngày tự Từ chối |
| delivery.payment_wait_days | 14 ngày | Giao hàng | Yêu cầu xuất bán chưa thu đủ / khách bị khóa → Hủy đơn (24/10: bỏ chờ liên hệ 7 ngày, dời ngày giao 3 ngày, khách "mất" 30 ngày) |
| cancel.retain_full_deposit | bật | Giao hàng / Hủy đơn | Hủy đơn đề xuất giữ toàn bộ cọc |
| ar.overdue_first_remind_days / repeat | 3 / 7 ngày | Ghi nhận thu chi & công nợ | Nhắc nợ lần đầu / nhắc lặp (thông báo trong hệ thống cho Sales, Kế toán) |
| ar.pre_delivery_escalate_days | 14 ngày | Ghi nhận thu chi & công nợ | Khoản trước giao quá hạn → báo quy trình gọi |
| ar.escalate_director_days | 90 ngày | Ghi nhận thu chi & công nợ | Công nợ sau giao → báo GĐ / KTT quyết bên ngoài hệ thống |
| po.director_approval_threshold_vnd | 100.000.000 | Mua NVL | PO trên mức này cần GĐ duyệt |
| receipt.min_remaining_shelf_ratio | 0,667 (2/3) | Nhập kho | HSD còn tối thiểu khi nhận, ghi đè theo mã NVL |
| transfer.missing_search_days | 7 ngày | Chuyển kho | Chờ tìm hàng thiếu rồi lập biên bản thất lạc |
| production.min_shelf_days | 30 ngày (ghi đè theo mã / nhóm NVL, nhà máy) | Xuất kho · Lệnh SX · PC xưởng | Hạn còn lại tối thiểu khi dùng cho SX (thêm 24/10 đợt 9, thay 3 mức cảnh báo cận date) |
| expiry.undestroyed_remind_days | 30 ngày | Hủy hàng | Lô hết hạn chưa hủy → nhắc Thủ kho trưởng |
| dispatch.alert_minutes | 10 phút | Tạo & phát lệnh | Phát lệnh không tới → báo Kế hoạch |
| offline.enter_after_seconds | 30 giây | Tạo & phát lệnh | Mất kết nối → ngoại tuyến |
| sync.outbox_retain_days | 30 ngày | Tạo & phát lệnh | Hàng đợi gửi lên giữ N ngày sau khi cloud xác nhận rồi dọn (bỏ `offline.max_hours` — không giới hạn thời gian ngoại tuyến, 20/10 đợt 2) |
| sync.clock_skew_warn_minutes | 5 phút | Tạo & phát lệnh | Giờ máy chủ nhà máy lệch cloud quá N phút thì cảnh báo Admin |
| sample.retain_months_after_exp | 6 tháng | Mẫu lưu | Gợi ý hạn lưu = HSD + N tháng; QC tự quyết từng mẫu |
| trace.retain_months_after_exp | 12 tháng | Truy xuất | Lưu hồ sơ truy xuất ≥ HSD + N tháng |
| recall.complete_days | 30 ngày | Thu hồi | Hoàn thành thu hồi kể từ quyết định |
| recall.retain_months_after_exp | 12 tháng | Thu hồi | Lưu hồ sơ thu hồi ≥ HSD + N tháng |

## 9. Câu hỏi — chỗ quy trình chưa đủ để thiết kế

1. **Các ô ở Vận hành mẻ / Chiết rót:** file quy trình bản 17/10 đã vẽ chặn bao sai, liên kết silo, thông số trộn, sự cố, cân bao HH, cân từng lon thành bước thật. Giữ "chờ quyết" như yêu cầu lần này, hay coi là đã chốt để thiết kế bảng đầy đủ?
2. **NVL hỗn hợp có phải 1 mã trong danh mục NVL không?** Đang tạm đặt nhóm HỖN HỢP gắn với công thức HH. HSD của bao hỗn hợp tính thế nào: theo HSD chuẩn của mã hỗn hợp, hay theo NVL hết hạn sớm nhất đã đổ vào?
3. **Một mẻ hỗn hợp ra mấy lô hỗn hợp** (1 lô / mẻ hay 1 lô / lệnh)? Sơ đồ chịu được cả hai, chỉ cần chốt để đặt mã lô.
4. **Số lô in sẵn trên lon:** cùng 1 số lô có kéo dài qua nhiều mẻ không? Có thể trùng giữa 2 nhà máy hoặc giữa các nhãn hiệu không? (đang unique theo nhà máy + số lô + SP)
5. **Lô bao bì lon / thùng:** lúc chiết, hệ thống biết lon / thùng thuộc lô bao bì nào bằng cách nào — quét bao bì, theo phiếu xuất bao bì cho lệnh, hay lấy theo FEFO? Liên kết bao bì → lô TP là bắt buộc nên phải chốt cách ghi.
6. **Mã trên lon** là mã riêng từng lon hay mã chung (mã vạch SP + số lô)? Truy xuất "từ QR lon" cần biết để tra ra lô.
7. ~~**Mã bao NVL lúc nhập kho** sinh ở cloud hay ở server nhà máy? (bao hỗn hợp, thùng đã chốt sinh ở server nhà máy)~~ **Đã chốt 20/10 (đợt 2):** sinh tại máy chủ nhà máy khi nhập (tiền tố nhà máy) — nhập kho chạy tại nhà máy.
8. ~~**Lệnh sản xuất:** một lệnh gồm cả mẻ hỗn hợp lẫn mẻ BTP, hay hỗn hợp có lệnh riêng?~~ **Đã chốt 19/10 (đợt 2):** lệnh thuộc 1 khu, loại lệnh HH / BTP theo khu.
9. **Bao hỗn hợp vừa ra khỏi mẻ (đã ĐẠT)** nằm ở đâu trước khi Chuyển kho? Sửa 24/10 đợt 9: không còn vị trí kệ (cũng không còn "khu sản xuất") — dòng tồn bắt buộc có kho hoặc phiếu chuyển, nên bao HH vừa ra khỏi mẻ phải vào 1 kho; đề xuất: kho điều phối của nhà máy (cần chốt).
10. **Mẫu kiểm nghiệm** (dùng hết khi kiểm) tính vào ô nào của cân bằng khối lượng — "mẫu lưu" hay "hủy"? Đang gộp chung cột "mẫu".
11. **Bộ chỉ tiêu COA và bộ chỉ tiêu QC của NVL** là 1 bộ hay 2 bộ? Theo từng nhà máy hay chung? (đang 1 bộ, mỗi chỉ tiêu có 2 cờ dùng cho COA / dùng cho QC, chung 2 nhà máy)
12. **Thứ tự "lý do chặt hơn"** của 9 lý do khóa chưa có trong quy trình. Đang để: thu hồi > hết hạn > chờ hủy > khoanh vùng = xung đột > hư chờ trả NCC > hư khi nhận > khách trả = tìm lại. Và phần lô đang KHÔNG ĐẠT khi cả lô bị khoanh vùng / thu hồi thì giữ KHÔNG ĐẠT hay chuyển KHÓA?
13. ~~**Cùng 1 lô ở cùng 1 ô vừa có phần ĐẠT vừa có phần KHÓA** (vd phiếu hủy một phần mà chưa dời hàng): đang cho phép bằng cách tách dòng tồn theo trạng thái. Được không, hay bắt buộc phần khóa phải dời sang ô khác?~~ — chốt 24/10 đợt 9: trạng thái theo từng bao, cùng lô × kho tách dòng tồn theo trạng thái.
14. **Khách hàng, NCC, danh mục dùng chung 2 nhà máy;** hạn mức và công nợ tính gộp cả 2 nhà máy — đúng không?
15. ~~**Trạng thái các chứng từ chưa có trong quy trình** (đang đặt tạm): phiếu nhập (đang nhận / chờ duyệt / đã duyệt / từ chối / hủy), phiếu chuyển, phiếu kiểm kho, đợt giao (bỏ 24/10 — thay bằng yêu cầu xuất bán). Đã chốt 19/10 (đợt 2): trạng thái lệnh SX (Mới tạo / Chờ phát / Đã nhận / Đang chạy / Hoàn thành / Đã hủy), phiếu trả NCC thêm Chờ kho xuất trả, phiếu xuất thêm Chờ bên yêu cầu, yêu cầu mua về Mở khi hủy hết báo giá.~~ **Đã chốt 04/11:** trạng thái theo mockup cho đơn hàng, PO, yêu cầu mua, phiếu trả NCC, phiếu chuyển, kiểm kho, phiếu xuất, mẫu lưu, khách hàng (mục 10).
16. ~~**Tồn tối thiểu của NVL** (điểm vào "dưới tồn tối thiểu" của Mua NVL) chưa có trường trong danh mục: thêm vào danh mục NVL không, theo kho hay toàn nhà máy?~~ **Đã chốt 04/11 (theo mockup):** `material.min_stock_qty` + `replenish_method` ở danh mục NVL, một mức cho cả hệ thống.
17. ~~**Mức nguy hại khi thu hồi** do nhà máy tự đặt: cần danh mục riêng hay ghi chữ tự do? (đang chữ tự do)~~ **Đã chốt 04/11 (theo mockup):** 3 mức chọn từ danh sách (Mức 1 · nghiêm trọng / Mức 2 · trung bình / Mức 3 · thấp), vẫn lưu chữ ở `recall_case.hazard_level`.
18. **Đơn vị của lô TP** là lon hay thùng? Đang tính tồn TP theo lon, thùng chỉ là mã định danh chứa N lon.

### Câu hỏi 19/10

19. ~~Một đợt giao có thể cần nhiều hóa đơn không?~~ **Đã chốt 24/10:** bỏ đợt giao; hóa đơn gắn đơn, một đơn nhiều hóa đơn (`sales_order_invoice`: số, ngày, file), không gắn phiếu xuất. **Sửa 04/11:** hóa đơn lập trên MES, gắn phiếu xuất bán (quyết định 17).
20. **NCC hoàn tiền cho nhà máy** (đã trả trước rồi trả hàng / giảm trừ) ghi thế nào? `payment_voucher` hiện có: thu của khách, hoàn cho khách, trả NCC; phần giảm trừ khi trả hàng chỉ ghi ở `ap_entry`.
21. Các câu hỏi nghiệp vụ 19/10 (thứ tự cấn tiền, tiền về thừa, kết quả nợ quá 90 ngày, hủy bản ghi nhập sai, giá trị hàng hủy, ~~ai quyết dòng rà soát của Trưởng BP, ngưỡng gợi ý 60 ngày~~ (bỏ 28/10); mã công thức đã chốt 4 số — 20/10 đợt 3) ở cuối mục "Vai trò × Chức năng" của file quy trình. Sơ đồ dữ liệu đã chịu được các phương án: cấn tay hay tự động đều ghi `payment_allocation`; quyết giảm dư nợ thì ghi `ar_entry` DIEU_CHINH; giá trị hàng hủy nhập tay ở `disposal.destroyed_value`.

### Câu hỏi 19/10 (đợt 2)

22. ~~**Silo bảo trì khi lệnh đã phát** (Chờ phát / Đã nhận / Đang chạy): trigger hiện chỉ đánh dấu lệnh Mới tạo (đúng chữ "lệnh chưa phát"). Lệnh đã xuống nhà máy thì chặn mẻ mới tới khi xếp lại và gửi lại, hay chạy hết lệnh?~~ **Đã chốt (đợt 3):** xử lý theo trạng thái lệnh — Mới tạo: cần xếp lại, chặn phát; Chờ phát / Đã nhận: chặn mẻ mới, chờ hoặc hủy rồi tạo lại; Đang chạy: chặn mẻ tiếp, chờ hoặc kết thúc sớm; không chuyển bảo trì khi silo còn bột.
23. ~~**Sức chứa silo so với gì:** đang kiểm KL NVL / mẻ (`kg_per_batch`) ≤ `capacity_kg`. Đúng không, hay so với tổng KL NVL của cả lệnh? Một NVL có được chia 2 silo khi vượt sức chứa không (đang 1 NVL – 1 silo trong 1 lệnh)?~~ **Đã chốt (đợt 3):** silo nạp nhiều mẻ, được nạp bổ sung; mỗi lần nạp kiểm bột trong nút + bao ≤ sức chứa; 1 NVL – 1 silo.
24. ~~**Sửa lệnh Đã nhận:** trong lúc chờ nhà máy nhận bản sửa, lệnh giữ DA_NHAN (`revision_no > nm_ack_revision`) hay về CHO_PHAT? Sửa được những gì (đang: số mẻ, KL mẻ, ngày xong, nhãn hiệu, dàn silo; công thức không)?~~ **Đã chốt (đợt 3):** lệnh đã phát không sửa — hủy (nhà máy xác nhận) rồi tạo lại, hoặc kết thúc sớm khi đang chạy; bỏ 2 cột bản sửa.
25. ~~**Hàng đợi phát lệnh:** lệnh CHO_PHAT còn tính trong hàng đợi không (đang: chỉ MOI_TAO có thứ tự; CHO_PHAT do cloud tự gửi lại)? Giảm KL mẻ tối đa của khu khi đang có lệnh chưa chạy vượt mức mới thì chặn hay chỉ cảnh báo (đang chưa chặn)?~~ **Đã chốt (đợt 3):** hàng đợi = thứ tự chạy ở nhà máy, Chờ phát giữ vị trí; giảm KL mẻ tối đa: lệnh Mới tạo vượt mức bị chặn phát.
26. ~~**Xuất SX thiếu hàng mà hết lô FEFO thay thế:** cũng sang CHO_BEN_YEU_CAU (Kế hoạch chọn) như 3 loại kia không? CSDL đang cho cả 4 loại.~~ **Đã chốt (đợt 3):** có — Kế hoạch chọn, hệ thống nhắc lập yêu cầu mua.
27. ~~**Trả NCC vượt SL đã nhận:** đang so cùng ĐVT với dòng PO và tính mọi phiếu trả của PO (kể cả phiếu nhà máy chịu, hủy hàng). Phiếu trả không gắn PO (hàng bị từ chối ở cửa kho) chưa kiểm — có cần không?~~ **Đã chốt (đợt 3):** quy về ĐVT gốc; tính mọi phiếu trả của PO; thêm chặn theo tồn lô; PO bắt buộc; dòng không lô không tính vào số đã nhận.

### Câu hỏi 19/10 (đợt 3)

28. **Lô bột dư xả từ silo:** HSD theo lô sớm nhất đã nạp vào nút (đang để, ứng dụng tính), trạng thái theo khóa cả lô của các lô đã nạp như NVL dư trả về — xác nhận.
29. **Mốc silo xả sạch** (`lot.silo_emptied_at`): công nhân xác nhận trên PC xưởng (đang để) hay lấy từ cân silo trên SCADA? Bột bám thành silo (cân không về đúng 0) thì sai số bao nhiêu kg coi là sạch? CSDL đang đòi bột trong nút = 0 theo sổ nạp / xả.
30. **Hủy lệnh chờ nhà máy xác nhận:** mất kết nối lâu thì giữ chỗ NVL giữ tới khi nhà máy trả lời (đang để), hay quá N giờ cloud tự giải phóng?
31. **KL xả từ silo cho từng mẻ** (`lot_link` XA_SILO): lấy từ cân / bộ định lượng của thiết bị qua SCADA hay công nhân nhập? Cần hỏi bên cung cấp thiết bị.

### Câu hỏi 19/10 (đợt 4)

32. ~~**Một mã SP nhiều quy cách — Đã chốt 20/10 (đợt 3): giữ mỗi quy cách × số lon / thùng là 1 dòng `product`** (1 mã SP, 1 `can_barcode`; unique thương hiệu × dòng × hạng × công thức × quy cách × số lon đã có). Không thêm `product_pack`. Màn Danh mục SP nhóm hiển thị theo thương hiệu × dòng × hạng (chỉ là cách hiện, không phải bảng). Hỏi lại khách 24/10; nếu khách bắt buộc 1 mã chung thì mới thêm cấp mã hàng.~~ **Đảo lại 04/11:** 1 mã SP nhiều quy cách nhiều tầng theo mockup (`product_pack`, quyết định 41).
33. ~~**Tiền tố mã 4 danh mục SP — Đã chốt 19/10 tối: THH- / DSP- / QCD- / HSP-** (thương hiệu `THH-{so:2}`, dòng SP `DSP-{so:2}`, quy cách đóng gói `QCD-{so:2}`, hạng `HSP-{so:2}`; bỏ `TH-` / `QC-` của mockup vì trùng hồ sơ thu hồi `TH-2610-…` / phiếu kiểm `QC-2610-…`). Đã nạp vào `code_format`; không còn là câu hỏi mở.~~ **Bỏ 04/11:** 4 danh mục SP đã bỏ cùng mô hình SP mới.
34. ~~**Đề nghị chuyển kho tự lập:** SL đề nghị = đúng phần thiếu (đang để) hay làm tròn lên theo bao (25 kg)? Kế hoạch có được sửa SL trước khi gửi không (đang cho sửa, không thấp hơn phần thiếu — chưa ép ở CSDL)?~~ **Hết câu hỏi 04/11:** bỏ bước đề nghị — hệ thống lập luôn phiếu chuyển ở Chờ xuất theo đúng phần thiếu; thủ kho kho tổng xuất theo bao thực tế.

### Câu hỏi 20/10 (đợt 2)

35. **QC trưởng khóa cả lô tại nhà máy khi mất mạng — Đã chốt 20/10 (đợt 3), làm sau 10/11.** Chỉ QC trưởng nhà máy được khóa tại chỗ; không mở tại chỗ. Không cần phiếu giấy: chọn lý do khóa (danh mục `lock_reason`), ghi chú, có thể chụp ảnh; dòng `lot_lock` nguồn nhà máy (không có `site_command_id`) chặn xuất kho và nạp silo phần lô của nhà máy đó ngay. Có mạng: khóa hiện ở Việc cần làm của QC trưởng trên cloud — gắn vào hồ sơ thu hồi / khoanh vùng (giữ khóa) hoặc mở khóa nhầm có lý do (lệnh MO_KHOA_LO xuống nhà máy). Nhà máy kia thấy khóa khi có mạng. Khóa nhầm mà vẫn mất mạng: chờ có mạng. Hỏi lại khách 24/10.
36. **Nhận chuyển kho chưa có phiếu — Đã chốt 20/10 (đợt 3), làm sau 10/11.** Phiếu chuyển in kèm hàng có QR, thủ kho quét số phiếu (gõ tay chỉ nhận đúng mẫu `PC-{nhà máy xuất}-…`). Hàng nhận dùng được ngay nếu lô đã có ở nhà máy nhận và đang đạt; lô lạ vào khu chờ đối chiếu, chưa dùng. Có mạng: cloud đối chiếu với phiếu của nhà máy xuất — khớp tự đóng; sai số phiếu nhưng lô và SL khớp một phiếu đang trên đường tới → Thủ kho trưởng nhà máy nhận chọn lại phiếu; lệch SL / lô → biên bản chênh lệch (`transfer_discrepancy`), Thủ kho trưởng hai nhà máy cùng xác nhận, Kế toán duyệt cuối. Thiết kế bảng khi làm (`goods_receipt` CHUYEN_KHO cho phép trống `stock_transfer_id` + số phiếu quét / gõ). Hỏi lại khách 24/10.
37. **Bản sao xuống nhà máy kéo theo dòng cha theo khóa ngoại — Đã chốt 20/10 (đợt 3):** giữ khóa ngoại, máy chủ nhà máy chỉ giữ đơn của nhà máy đó và khách của các đơn ấy, không có giá, tiền, liên hệ, công nợ (quyết định 38). Hỏi lại khách 24/10: nếu khách không muốn nhà máy giữ chút dữ liệu khách nào thì phiếu xuất bán in tại nhà máy khi mất mạng sẽ không có tên khách.

## 10. Chi tiết từng bảng

## 0 · Lô & mã định danh (dùng chung) — 10 bảng

### `lot`

Lô. Một mã lô cho mọi phần ở mọi kho. TRẠNG THÁI KHÔNG NẰM Ở ĐÂY mà ở dòng tồn lô × kho (stock_line) — mỗi bao / thùng nằm ở đúng 1 dòng tồn nên trạng thái theo từng bao (24/10 đợt 9). Lô mẻ (ME) là nút trung gian của chuỗi liên kết, không có tồn. BTP đạt QC đổi thành TP trên cùng dòng (đổi lot_kind). Hàng khách trả, thu hồi, tìm lại sau thất lạc dùng lại lô cũ; NVL dư trả về là lô mới trỏ về lô gốc. Bột hỏng của mẻ hủy do sự cố là lô HONG nối từ lô mẻ (RA_ME), KHÓA chờ hủy ngay khi sinh ra. Sửa 19/10 (đợt 3): silo nạp một lần dùng cho nhiều mẻ → mỗi silo của lệnh là 1 nút SILO (như lô mẻ, không tồn): lô NVL —nạp silo→ SILO —xả→ lô mẻ; silo xả sạch thì đóng nút (silo_emptied_at), lần nạp sau mở nút mới; mỗi lệnh × silo chỉ 1 nút đang mở. Bột dư cuối lệnh là lô NVL dư mới trỏ về nút SILO. Sửa 24/10 (đợt 9): bỏ cận date; số ngày còn lại, hết hạn, dưới ngưỡng SX không lưu — view v_lot_shelf tính từ exp_date + tham số production.min_shelf_days, mỗi nơi tự tính.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** tạo QT14 (NVL mua, NVL dư), QT20 (lô mẻ, lô HH), QT21 (lô BTP theo nhãn hiệu), QT20 ky (lô bột hỏng của mẻ hủy); sửa QT23 y2 (BTP → TP), QT18 ya (hết hạn: view v_lot_shelf); nút SILO QT20 g1 (mở khi nạp đầu), vs / yd (đóng khi xả sạch); lô bột dư từ silo QT20 xd → QT14
- **Khóa chính:** `id`
- **Khóa ngoại:** `material_id` → `material.id` · `product_id` → `product.id` · `production_batch_id` → `production_batch.id` · `production_order_id` → `production_order.id` · `silo_equipment_id` → `equipment.id` · `supplier_id` → `supplier.id` · `uom_code` → `uom.code` · `coa_file_id` → `file_attachment.id` · `source_lot_id` → `lot.id`
- **Unique:** `(factory_id, lot_no, material_id, product_id)` · `(production_order_id, silo_equipment_id where lot_kind = 'SILO' and silo_emptied_at is null)` — null coi như bằng nhau
- **Check:** `(lot_kind in ('NVL_MUA','HH') and material_id is not null and product_id is null) or (lot_kind in ('BTP','TP') and product_id is not null and material_id is null) or (lot_kind = 'ME' and production_batch_id is not null and material_id is null and product_id is null) or (lot_kind = 'HONG' and production_batch_id is not null and material_id is null and product_id is null) or (lot_kind = 'SILO' and material_id is not null and product_id is null)` · `lot_kind <> 'NVL_MUA' or source_lot_id is not null or (supplier_id is not null and supplier_lot_no is not null and mfg_date is not null and exp_date is not null)` · `lot_kind in ('ME','HONG','SILO') or exp_date is not null` · `exp_date is null or mfg_date is null or exp_date > mfg_date` · `lot_kind <> 'TP' or converted_to_tp_at is not null` · `(lot_kind = 'SILO') = (silo_equipment_id is not null and production_order_id is not null)` · `silo_emptied_at is null or lot_kind = 'SILO'`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `lot_no` | text | có | mã lô; BTP / TP = số lô in sẵn trên lon |
| `lot_kind` | text | có | HONG: bột hỏng của mẻ hủy do sự cố (QT20), không HSD, chỉ đi hủy. SILO: nút silo của lệnh (19/10 đợt 3) — không tồn, không HSD · giá trị: NVL_MUA / HH / ME / SILO / BTP / TP / HONG |
| `material_id` | uuid |  | NVL_MUA, HH · → material |
| `product_id` | uuid |  | BTP, TP · → product |
| `production_batch_id` | uuid |  | ME: mẻ của nó; HH / BTP / HONG: mẻ sinh ra · → production_batch |
| `production_order_id` | uuid |  | SILO: lệnh của nút silo · → production_order |
| `silo_equipment_id` | uuid |  | SILO: silo của nút · → equipment |
| `silo_emptied_at` | timestamptz |  | SILO: thời điểm silo xả sạch — đóng nút, lần nạp sau mở nút mới (bột trong nút phải = 0, trigger) |
| `supplier_id` | uuid |  | → supplier |
| `supplier_lot_no` | text |  | số lô NCC |
| `mfg_date` | date |  | NSX |
| `exp_date` | date |  | HSD |
| `uom_code` | text | có | → uom |
| `coa_file_id` | uuid |  | → file_attachment |
| `source_lot_id` | uuid |  | NVL dư trả về: lô gốc; bột dư xả từ silo: nút SILO · → lot |
| `expired_note` | boolean | có | ghi chú "đã hết hạn" trên lô KHÔNG ĐẠT · mặc định false |
| `converted_to_tp_at` | timestamptz |  | BTP → TP (QT23) |
| `origin_site` | text | có | nơi tạo dòng · giá trị: CLOUD / NM |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `handling_unit`

Mã định danh, TÁCH KHỎI LÔ: bao NVL, bao HH, thùng — 1 lô có nhiều mã. Lon KHÔNG có dòng ở đây: lon dùng mã in sẵn trên bao bì, hệ thống không cấp. Mã chỉ là định danh + tra CSDL, không nhúng loại / ngày.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** tạo QT14 k2 (bao NVL), QT20 h9 (bao HH), QT21 t7 (thùng); khóa / thay QT04; đổi dòng tồn QT14, QT15, QT16, đổi trạng thái từng bao (QT16 t4, QT18 t2, QT22 / QT23); QT21 tx sửa số lon
- **Khóa chính:** `id`
- **Khóa ngoại:** `lot_id` → `lot.id` · `uom_code` → `uom.code` · `stock_line_id` → `stock_line.id` · `production_batch_id` → `production_batch.id` · `filling_run_id` → `filling_run.id` · `receipt_line_id` → `goods_receipt_line.id` · `replaced_by_id` → `handling_unit.id`
- **Unique:** `(code)` · `(source_event_id where source_event_id is not null)`
- **Check:** `qty > 0` · `unit_type <> 'THUNG' or filling_run_id is not null` · `unit_type <> 'BAO_HH' or production_batch_id is not null` · `unit_type <> 'BAO_NVL' or receipt_line_id is not null`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `code` | text | có | tiền tố nhà máy + số tăng dần |
| `unit_type` | text | có | giá trị: BAO_NVL / BAO_HH / THUNG |
| `lot_id` | uuid | có | → lot |
| `qty` | numeric(12,3) | có | kg (bao) / số lon (thùng) |
| `uom_code` | text | có | → uom |
| `stock_line_id` | uuid |  | dòng tồn (lô × kho × trạng thái) đang chứa mã này — trạng thái của bao = trạng thái dòng tồn; đổi trạng thái 1 bao = chuyển bao sang dòng khác (24/10 đợt 9); null khi đã xuất / đã dùng · → stock_line |
| `production_batch_id` | uuid |  | mẻ sinh ra (bao HH, thùng) · → production_batch |
| `filling_run_id` | uuid |  | thùng: lượt chiết của nhãn hiệu · → filling_run |
| `receipt_line_id` | uuid |  | bao NVL: dòng phiếu nhập · → goods_receipt_line |
| `label_status` | text | có | trạng thái mã tem, không phải trạng thái lô · giá trị: KICH_HOAT / KHOA · mặc định 'KICH_HOAT' |
| `replaced_by_id` | uuid |  | tem mất → mã mới (QT04) · → handling_unit |
| `source_event_id` | uuid |  | sự kiện tạo ra (bỏ trùng khi đồng bộ) |
| `origin_site` | text | có | nơi tạo dòng · giá trị: CLOUD / NM |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `stock_line`

Tồn theo lô × kho (sửa 24/10 đợt 9 — bỏ vị trí kệ; thay "phần lô × vị trí"). TRẠNG THÁI LÔ GẮN Ở ĐÂY (vòng đời lô hàng, chốt 16/10). Mỗi dòng = 1 lô × 1 kho (hoặc 1 phiếu chuyển khi hàng đang chuyển) × 1 trạng thái × 1 lý do khóa. Mỗi bao / thùng (handling_unit.stock_line_id) nằm ở đúng 1 dòng, nên trạng thái theo từng bao: cùng lô cùng kho vẫn tách được bao ĐẠT và bao KHÓA (vd hư khi nhận, chờ hủy). Đổi trạng thái 1 phần / 1 bao = chuyển SL (và bao) sang dòng khác + ghi lot_status_log + 2 dòng inventory_txn. Hàng đang chuyển: warehouse_id null, stock_transfer_id = phiếu chuyển — không thuộc kho nào, không tính tồn dùng được.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT14, QT15, QT16, QT17, QT18, QT22, QT23, QT26, QT19 (đồng bộ)
- **Khóa chính:** `id`
- **Khóa ngoại:** `lot_id` → `lot.id` · `warehouse_id` → `warehouse.id` · `stock_transfer_id` → `stock_transfer.id` · `uom_code` → `uom.code` · `lock_reason` → `lock_reason.code` · `prev_lock_reason` → `lock_reason.code`
- **Unique:** `(lot_id, warehouse_id, stock_transfer_id, status, lock_reason)` — null coi như bằng nhau
- **Check:** `(status = 'KHOA') = (lock_reason is not null)` · `qty >= 0` · `(warehouse_id is null) = (stock_transfer_id is not null)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `lot_id` | uuid | có | → lot |
| `warehouse_id` | uuid |  | null khi hàng đang chuyển (nằm trên phiếu chuyển) · → warehouse |
| `stock_transfer_id` | uuid |  | hàng đang chuyển: phiếu chuyển đang chở — thay vị trí "trên xe" (24/10 đợt 9) · → stock_transfer |
| `qty` | numeric(14,3) | có |  |
| `uom_code` | text | có | → uom |
| `status` | text | có | giá trị: CHO_KIEM / DAT / KHONG_DAT / KHOA / HUY |
| `lock_reason` | text |  | bắt buộc khi KHÓA · → lock_reason |
| `prev_status` | text |  | trạng thái trước — để "về trạng thái trước" khi QC trưởng / Thủ kho trưởng từ chối · giá trị: CHO_KIEM / DAT / KHONG_DAT / KHOA |
| `prev_lock_reason` | text |  | → lock_reason |
| `version` | integer | có | khóa lạc quan · mặc định 1 |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `lock_reason`

Danh mục 9 lý do khóa (bảng "Lý do khóa"): phạm vi, có cho gửi QC không, lối ra được phép, độ chặt (2 lý do cùng lúc → lấy lý do chặt hơn).

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud chủ → nhà máy
- **QT:** nạp khi triển khai
- **Khóa chính:** `code`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `code` | text | có |  |
| `name` | text | có |  |
| `scope` | text | có | giá trị: RIENG_PHAN / CA_LO / PHAN_TREN_PHIEU |
| `applies_to` | text | có | loại lô áp dụng |
| `allow_qc` | boolean | có |  |
| `allowed_exits` | text[] | có | QC / HUY / TRA_NCC / VE_TRUOC / HO_SO_THU_HOI |
| `strictness` | smallint | có | số lớn hơn = chặt hơn |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `lot_status_transition`

Bảng chuyển trạng thái hợp lệ — chép đúng bảng chuyển trạng thái của mục "Vòng đời lô hàng", tách mỗi trạng thái nguồn thành 1 dòng. Tầng ứng dụng chỉ cho đổi trạng thái khi khớp 1 dòng ở đây; nhật ký trỏ về dòng đã dùng.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc
- **QT:** nạp khi triển khai
- **Khóa chính:** `id`
- **Khóa ngoại:** `lock_reason` → `lock_reason.code`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `from_status` | text |  | null = lô mới · giá trị: CHO_KIEM / DAT / KHONG_DAT / KHOA |
| `to_status` | text | có | giá trị: CHO_KIEM / DAT / KHONG_DAT / KHOA / HUY |
| `lock_reason` | text |  | lý do khi sang KHÓA · → lock_reason |
| `qt_code` | text | có |  |
| `step_code` | text | có |  |
| `actor_rule` | text | có |  |
| `condition_text` | text | có |  |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `lot_lock`

Khóa CẢ LÔ (khoanh vùng, xung đột, thu hồi, hết hạn): áp lên mọi phần của lô, kể cả phần nhập lại về sau (NVL dư, hàng thu hồi). Mở khóa = ghi released_at. Sửa 20/10 (đợt 2): dòng khóa do máy chủ nhà máy ghi (nhà máy chủ tồn & trạng thái lô); thu hồi / khoanh vùng từ trung tâm là lệnh KHOA_LO (site_command) — nhà máy áp dụng thì ghi dòng ở đây kèm site_command_id; lô có phần ở 2 nhà máy thì mỗi nhà máy 1 dòng.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT18 yc (tại nhà máy), QT19 kl / kz, QT26 y1 / y2 / yv (lệnh KHÓA LÔ), QT14 (NVL dư theo lô gốc)
- **Khóa chính:** `id`
- **Khóa ngoại:** `factory_id` → `factory.id` · `lot_id` → `lot.id` · `lock_reason` → `lock_reason.code` · `recall_case_id` → `recall_case.id` · `sync_conflict_id` → `sync_conflict.id` · `site_command_id` → `site_command.id` · `released_by` → `app_user.id`
- **Unique:** `(lot_id, lock_reason, factory_id where released_at is null)` — null coi như bằng nhau

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid |  | nhà máy áp dụng khóa (dòng ghi tại máy chủ nhà máy); trống = dòng cũ / ghi ở cloud trước 20/10 · → factory |
| `lot_id` | uuid | có | → lot |
| `lock_reason` | text | có | → lock_reason |
| `recall_case_id` | uuid |  | → recall_case |
| `sync_conflict_id` | uuid |  | → sync_conflict |
| `site_command_id` | uuid |  | lệnh KHÓA LÔ từ trung tâm sinh ra dòng này (thu hồi / khoanh vùng — QT26); trống = nhà máy tự khóa (hết hạn, NVL dư, xung đột) · → site_command |
| `applied_at` | timestamptz |  | thời điểm máy chủ nhà máy áp dụng |
| `released_at` | timestamptz |  |  |
| `released_by` | uuid |  | → app_user |
| `release_note` | text |  |  |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `lot_status_log`

Nhật ký đổi trạng thái lô: ai, lúc nào, từ → sang (kèm lý do khóa), QT + bước, phần lô và SL bị đổi, chứng từ, lý do, file.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** mọi QT đổi trạng thái (QT13, 14, 16, 18, 19, 21, 22, 23, 26)
- **Khóa chính:** `id`
- **Khóa ngoại:** `lot_id` → `lot.id` · `stock_line_id` → `stock_line.id` · `warehouse_id` → `warehouse.id` · `from_lock_reason` → `lock_reason.code` · `to_lock_reason` → `lock_reason.code` · `transition_id` → `lot_status_transition.id` · `actor_id` → `app_user.id` · `attachment_file_id` → `file_attachment.id`
- **Check:** `to_status <> 'KHOA' or to_lock_reason is not null`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `lot_id` | uuid | có | → lot |
| `stock_line_id` | uuid |  | phần bị đổi; null nếu ghi cho cả lô · → stock_line |
| `warehouse_id` | uuid |  | kho của phần bị đổi; null khi hàng đang chuyển · → warehouse |
| `handling_unit_ids` | uuid[] |  | các bao / thùng bị đổi khi đổi theo bao (24/10 đợt 9); null khi đổi cả phần lô |
| `qty` | numeric(14,3) |  |  |
| `from_status` | text |  | null = lô mới · giá trị: CHO_KIEM / DAT / KHONG_DAT / KHOA / HUY |
| `from_lock_reason` | text |  | → lock_reason |
| `to_status` | text | có | giá trị: CHO_KIEM / DAT / KHONG_DAT / KHOA / HUY |
| `to_lock_reason` | text |  | → lock_reason |
| `qt_code` | text | có | QT14… |
| `step_code` | text | có | y2, d2… |
| `transition_id` | uuid | có | → lot_status_transition |
| `actor_id` | uuid | có | → app_user |
| `occurred_at` | timestamptz | có | mặc định now() |
| `ref_table` | text |  |  |
| `ref_id` | uuid |  |  |
| `reason_text` | text |  |  |
| `attachment_file_id` | uuid |  | → file_attachment |
| `source_event_id` | uuid |  |  |

<sub>Cột chung: `— (nhật ký / hàng đợi có cột thời điểm + người riêng)`</sub>

### `lot_link`

Liên kết lô cha → lô con kèm khối lượng — 1 đồ thị tổng quát cho cả chuỗi: lô NVL / bao HH —nạp→ nút silo của lệnh —xả→ lô mẻ → lô HH / lô BTP-TP / lô bột hỏng (mẻ hủy); lô bao bì (lon, thùng) → lô BTP-TP; lô gốc → lô NVL dư; nút silo → lô bột dư. Qua nút silo (19/10 đợt 3): lô nạp lúc T là đầu vào của các mẻ xả sau T (so linked_at), tới khi silo xả sạch. BẮT BUỘC: thao tác quét chỉ thành công khi dòng này ghi được trong cùng giao dịch; ràng buộc trễ chặn lô HH / BTP không có liên kết vào. Trigger: nạp đúng silo của phương án, silo đang hoạt động, bột trong nút + nạp ≤ sức chứa; xả / bột dư ≤ bột đang có.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT20 g1 (nạp silo), ys (xả cho mẻ), yl (mẻ → bao HH), xd / yd (bột dư); QT20 ky (mẻ hủy → lô bột hỏng); QT21 yq (mẻ → nhãn hiệu / lô), bao bì; QT14 (NVL dư); QT19 (đồng bộ)
- **Khóa chính:** `id`
- **Khóa ngoại:** `parent_lot_id` → `lot.id` · `child_lot_id` → `lot.id` · `uom_code` → `uom.code` · `production_batch_id` → `production_batch.id` · `handling_unit_id` → `handling_unit.id` · `operator_id` → `app_user.id`
- **Unique:** `(source_event_id, parent_lot_id, child_lot_id where source_event_id is not null)`
- **Check:** `parent_lot_id <> child_lot_id` · `qty > 0` · `link_type not in ('XA_SILO','RA_ME','BAO_BI') or production_batch_id is not null` · `link_type <> 'NAP_SILO' or handling_unit_id is not null`
- **Xả silo (24/10 đợt 9):** XA_SILO chặn khi nút silo có lô đã nạp hết hạn tại thời điểm xả (trigger trg_lot_link_shelf)

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `parent_lot_id` | uuid | có | → lot |
| `child_lot_id` | uuid | có | → lot |
| `link_type` | text | có | NAP_SILO: lô NVL / HH → nút SILO (quét bao nạp silo); XA_SILO: nút SILO → lô mẻ (silo xả cho mẻ); NVL_DU: lô gốc → lô dư, hoặc nút SILO → lô bột dư. Bỏ DO_VAO_ME (bao không đổ thẳng vào mẻ — đợt 3) · giá trị: NAP_SILO / XA_SILO / RA_ME / BAO_BI / NVL_DU |
| `qty` | numeric(14,3) | có |  |
| `uom_code` | text | có | → uom |
| `production_batch_id` | uuid |  | → production_batch |
| `handling_unit_id` | uuid |  | bao được quét · → handling_unit |
| `operator_id` | uuid |  | → app_user |
| `linked_at` | timestamptz | có | thời điểm nạp / xả — truy xuất qua nút SILO chỉ nối lần nạp có linked_at ≤ linked_at của lần xả (cách B) |
| `source_event_id` | uuid |  |  |
| `origin_site` | text | có | nơi tạo dòng · giá trị: CLOUD / NM |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `inventory_txn`

Sổ kho: mọi thay đổi SL của phần lô. Đổi trạng thái / chuyển / hủy luôn là cặp −/+ (tổng lô không đổi). Nguồn số cho cân bằng khối lượng (QT25).

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT14, 15, 16, 17, 18, 22, 23, 24, 26, QT19
- **Khóa chính:** `id`
- **Khóa ngoại:** `stock_line_id` → `stock_line.id` · `lot_id` → `lot.id` · `warehouse_id` → `warehouse.id` · `uom_code` → `uom.code` · `actor_id` → `app_user.id`
- **Check:** `qty_delta <> 0`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `stock_line_id` | uuid | có | → stock_line |
| `lot_id` | uuid | có | → lot |
| `warehouse_id` | uuid |  | null khi dòng tồn đang trên phiếu chuyển · → warehouse |
| `qty_delta` | numeric(14,3) | có |  |
| `uom_code` | text | có | → uom |
| `txn_category` | text | có | giá trị: NHAP_MUA / NHAP_SX / NHAP_KHACH_TRA / NHAP_THU_HOI / NHAP_NVL_DU / NHAP_TIM_LAI / XUAT_SX / XUAT_BAN / XUAT_TRA_NCC / CHUYEN_DI / CHUYEN_DEN / DOI_TRANG_THAI / HUY / DIEU_CHINH / LAY_MAU_LUU / LAY_MAU_KIEM |
| `ref_table` | text | có |  |
| `ref_id` | uuid | có |  |
| `actor_id` | uuid | có | → app_user |
| `occurred_at` | timestamptz | có | mặc định now() |
| `source_event_id` | uuid |  |  |

<sub>Cột chung: `— (nhật ký / hàng đợi có cột thời điểm + người riêng)`</sub>

### `scan_log`

Nhật ký mọi lần quét, kể cả lần bị chặn (sai lô, sai trạng thái, hết hạn, đang kiểm kê, dưới ngưỡng hạn tối thiểu cho SX, sai nhãn hiệu, không ghi được liên kết, mã đã khóa — kèm mã thay thế). Chỉ để tra cứu — liên kết thật nằm ở lot_link / goods_issue_scan / goods_receipt_scan.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT04, 14, 15, 16, 17, 20, 21
- **Khóa chính:** `id`
- **Khóa ngoại:** `user_id` → `app_user.id`
- **Check:** `(result = 'CHAN') = (block_reason is not null)` · `replacement_code is null or block_reason is not distinct from 'MA_BI_KHOA'`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `device_id` | text |  |  |
| `user_id` | uuid |  | → app_user |
| `scanned_code` | text | có |  |
| `scan_context` | text | có | giá trị: NHAP_KHO / XUAT_KHO / NHAN_CHUYEN / KIEM_KHO / QUET_BAO_ME / LON_DAU / DONG_THUNG / SU_CO_TEM |
| `ref_table` | text |  |  |
| `ref_id` | uuid |  |  |
| `result` | text | có | giá trị: OK / CHAN |
| `block_reason` | text |  | giá trị: SAI_LO / SAI_TRANG_THAI / HET_HAN / DANG_KIEM_KE / DUOI_NGUONG_SX / SAI_CONG_THUC / SAI_NHAN_HIEU / KHONG_GHI_DUOC_LIEN_KET / MA_BI_KHOA / KHAC |
| `message` | text |  |  |
| `replacement_code` | text |  | mã thay thế hiện cho người quét khi quét trúng mã đã khóa (QT04) |
| `scanned_at` | timestamptz | có | mặc định now() |
| `source_event_id` | uuid |  |  |

<sub>Cột chung: `— (nhật ký / hàng đợi có cột thời điểm + người riêng)`</sub>


## 1 · Nền tảng — 39 bảng

### `factory`

Nhà máy. Mỗi nhà máy một tiền tố mã định danh để mã bao HH / thùng sinh ở 2 server nhà máy không bao giờ trùng nhau.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud là chủ → sao xuống mọi server nhà máy
- **QT:** tạo / sửa / ngừng dùng QT02 ka (Admin); mọi QT đọc
- **Khóa chính:** `id`
- **Unique:** `(code)` · `(unit_code_prefix)`
- **Check:** `unit_code_prefix ~ '^[A-Z0-9]{1,4}$'`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `code` | text | có | NM1, NM2 |
| `name` | text | có |  |
| `unit_code_prefix` | text | có | tiền tố mã định danh, vd "A", "B" |
| `address` | text |  | địa chỉ nhà máy (in trên phiếu) |
| `phone` | text |  |  |
| `email` | text |  |  |
| `status` | text | có | giá trị: DANG_DUNG / NGUNG_DUNG · mặc định 'DANG_DUNG' |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `work_area`

Khu vực làm việc, 4 loại: sản xuất nguyên liệu hỗn hợp (HH) / sản xuất bán thành phẩm (BTP) / chiết rót / đóng gói. Khu HH, BTP có khối lượng mẻ tối đa và dàn silo riêng (equipment loại SILO, Admin cấu hình ngay trong khu — sửa 19/10 đợt 2). Loại lệnh SX theo khu; KL mẻ của lệnh ≤ mức tối đa của khu. Không đổi loại khu khi còn lệnh chưa hoàn thành (trigger); không xóa, chỉ ngừng dùng. Công nhân gắn khu; PC C# chỉ hiện lệnh / mẻ của khu; mỗi khu một hàng đợi phát lệnh. Sửa 04/11: mỗi khu chọn 1 kho điều phối cấp NVL (`supply_warehouse_id`); một kho điều phối cấp được cho nhiều khu, một nhà máy có nhiều kho điều phối.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud chủ → sao xuống nhà máy đó
- **QT:** tạo / sửa / ngừng dùng QT02 ka (Admin); dàn silo QT02 ks; dùng QT01, QT19 (loại lệnh, KL mẻ tối đa, hàng đợi), QT20, QT21
- **Khóa chính:** `id`
- **Khóa ngoại:** `supply_warehouse_id` → `warehouse.id`
- **Unique:** `(factory_id, code)`
- **Check:** `(area_type in ('HH','BTP')) = (max_batch_kg is not null)` · `max_batch_kg is null or max_batch_kg > 0` · `area_type not in ('HH','BTP') or supply_warehouse_id is not null`
- **Trigger (04/11):** `supply_warehouse_id` phải là kho loại DIEU_PHOI, đang dùng, cùng nhà máy với khu (trg_work_area_supply)

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `code` | text | có |  |
| `name` | text | có |  |
| `area_type` | text | có | loại lệnh SX theo loại khu (HH / BTP); không đổi khi khu còn lệnh chưa hoàn thành (trigger) · giá trị: HH / BTP / CHIET_ROT / DONG_GOI |
| `max_batch_kg` | numeric(12,3) |  | khối lượng mẻ tối đa (kg) — bắt buộc với khu HH / BTP; KL mẻ của lệnh không được vượt |
| `supply_warehouse_id` | uuid |  | kho điều phối cấp NVL cho khu (chốt 04/11) — bắt buộc với khu HH / BTP; kho loại DIEU_PHOI cùng nhà máy (trigger) · → warehouse |
| `status` | text | có | giá trị: DANG_DUNG / NGUNG_DUNG · mặc định 'DANG_DUNG' |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `app_user`

Tài khoản, kể cả công nhân SX / đóng gói (tài khoản riêng, gắn khu vực làm việc). Đăng nhập web bằng mã NV + mật khẩu; quét thẻ NV chỉ ở PC xưởng (bỏ máy quét riêng — 19/10 đợt 2); thẻ của tài khoản đã khóa bị chặn ngay. Đăng nhập lần đầu / sau mật khẩu tạm: bắt đổi mật khẩu. Quy tắc mật khẩu cố định trong code (≥ 8 ký tự, có cả chữ và số), không phải tham số. Nghỉ việc thì đến ngày khóa HR đặt hệ thống tự khóa. Xóa được khi tài khoản chưa từng đăng nhập và chưa có giao dịch (chốt 04/11): trigger chặn khi đã có phiên đăng nhập, khóa ngoại chặn khi đã có dữ liệu trỏ tới; xóa thì gỡ luôn dòng gán vai trò và ghi nhật ký XOA. Có 1 tài khoản "Hệ thống" để ghi người tạo cho thao tác tự động.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud chủ → sao xuống nhà máy (tài khoản có phạm vi nhà máy đó) để đăng nhập quét thẻ khi mất kết nối
- **QT:** tạo / sửa QT01 (HR, Admin); tự khóa QT01 (hệ thống: đến ngày khóa, 90 ngày không đăng nhập)
- **Khóa chính:** `id`
- **Khóa ngoại:** `home_factory_id` → `factory.id` · `work_area_id` → `work_area.id`
- **Unique:** `(employee_code)` · `(email where email is not null)` · `(phone where phone is not null)` · `(badge_code where badge_code is not null)`
- **Check:** `not is_worker or (work_area_id is not null and badge_code is not null)` · `scheduled_lock_date is null or resign_date is not null`
- **Xóa (04/11):** chỉ xóa khi chưa có `user_session`; gỡ `user_role` của tài khoản, nhật ký tài khoản giữ lại (bỏ trỏ tới tài khoản, ghi mã NV vào `detail`) và thêm dòng XOA (trg_app_user_delete)

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `employee_code` | text | có | mã NV (kiểm trùng) |
| `full_name` | text | có |  |
| `department` | text | có | bộ phận |
| `job_title` | text | có | chức danh |
| `email` | text |  |  |
| `phone` | text |  |  |
| `home_factory_id` | uuid |  | nhà máy chính; phạm vi quyền nằm ở user_role · → factory |
| `is_worker` | boolean | có | công nhân SX / đóng gói · mặc định false |
| `work_area_id` | uuid |  | bắt buộc với công nhân · → work_area |
| `badge_code` | text |  | mã thẻ NV: chỉ để đăng nhập PC xưởng; bắt buộc với công nhân, không bắt buộc với người khác |
| `password_hash` | text |  | quy tắc mật khẩu cố định trong code: ≥ 8 ký tự, có cả chữ và số (không phải tham số) |
| `must_change_password` | boolean | có | đăng nhập lần đầu / sau khi Admin cấp mật khẩu tạm: bắt đổi · mặc định true |
| `status` | text | có | KHOA_TAM: quên mật khẩu / không đăng nhập; DA_KHOA: nghỉ việc · giá trị: HOAT_DONG / KHOA_TAM / DA_KHOA · mặc định 'HOAT_DONG' |
| `lock_reason` | text |  |  |
| `effective_date` | date | có | ngày hiệu lực |
| `resign_date` | date |  | ngày nghỉ việc |
| `scheduled_lock_date` | date |  | ngày khóa tài khoản HR đặt (mặc định = ngày nghỉ) — ô riêng, tách khỏi ngày nghỉ việc (04/11) |
| `last_login_at` | timestamptz |  |  |
| `is_system` | boolean | có | mặc định false |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `role`

Vai trò — 19 vai trò nạp sẵn theo mục "Vai trò × Chức năng" (bỏ Trưởng bộ phận 28/10; thêm Thủ kho điều phối 04/11). Màn Vai trò × quyền sửa được (chốt 04/11): Admin sửa quyền của vai trò, phạm vi nhà máy của vai trò và của từng quyền. Quyền chỉ gán qua vai trò, không gán quyền lẻ. Vai trò Admin, Người truy xuất chỉ Admin gán; vai trò có quyền duyệt được ủy quyền tạm khi vắng.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud chủ → nhà máy
- **QT:** QT01; nạp khi triển khai
- **Khóa chính:** `id`
- **Khóa ngoại:** `scope_factory_id` → `factory.id`
- **Unique:** `(code)`
- **Check:** `(factory_scope = 'CO_DINH') = (scope_factory_id is not null)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `code` | text | có |  |
| `name` | text | có |  |
| `description` | text |  |  |
| `admin_assign_only` | boolean | có | chỉ Admin gán được (Admin, Người truy xuất) — trigger kiểm khi gán · mặc định false |
| `delegable` | boolean | có | vai trò ủy quyền tạm được (chốt 19/10): Giám đốc, Kế toán trưởng, Thủ kho trưởng, Trưởng BP Mua hàng, QC trưởng, Kế hoạch (bỏ Trưởng bộ phận 28/10) · mặc định false |
| `factory_scope` | text | có | phạm vi nhà máy của vai trò (chốt 04/11): mọi nhà máy / nhà máy của tài khoản / cố định 1 nhà máy — áp cho các quyền để "Theo vai trò" · giá trị: MOI_NHA_MAY / NHA_MAY_TAI_KHOAN / CO_DINH · mặc định 'NHA_MAY_TAI_KHOAN' |
| `scope_factory_id` | uuid |  | nhà máy cố định (chỉ khi CO_DINH) · → factory |
| `status` | text | có | giá trị: DANG_DUNG / NGUNG_DUNG · mặc định 'DANG_DUNG' |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `permission`

Danh sách thao tác: chức năng (QT + bước) × hành động (xem / tạo / sửa / duyệt / hủy). Nạp sẵn từ bảng quyền 7 mảng của mục "Vai trò × Chức năng". Sửa 04/11: Admin thêm / sửa quyền ở Danh mục quyền; xóa được khi quyền chưa gán cho vai trò nào (khóa ngoại chặn).

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud chủ → nhà máy
- **QT:** nạp khi triển khai; Admin bổ sung
- **Khóa chính:** `id`
- **Unique:** `(function_code, action)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `function_code` | text | có | QT + bước theo bảng Vai trò × Chức năng, vd QT14.d4; bước không có mã: QT01.#8 |
| `action` | text | có | giá trị: XEM / TAO / SUA / DUYET / HUY |
| `qt_code` | text |  |  |
| `description` | text | có |  |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `role_permission`

Bảng Vai trò × Thao tác, nạp sẵn theo mục "Vai trò × Chức năng" (Admin không còn mọi thao tác — chỉ quản trị và QT01.xa xem mọi màn). Sửa 04/11: Admin cấp / gỡ quyền trên màn Vai trò × quyền; mỗi quyền có phạm vi riêng: theo vai trò (dùng phạm vi của vai trò), mọi nhà máy, nhà máy của tài khoản, hoặc cố định 1 nhà máy. Gỡ quyền = ghi revoked_at, không xóa dòng.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud chủ → nhà máy
- **QT:** QT01 (màn Vai trò × quyền — sửa được 04/11)
- **Khóa chính:** `id`
- **Khóa ngoại:** `role_id` → `role.id` · `permission_id` → `permission.id` · `scope_factory_id` → `factory.id` · `revoked_by` → `app_user.id`
- **Unique:** `(role_id, permission_id where revoked_at is null)`
- **Check:** `(scope_mode = 'CO_DINH') = (scope_factory_id is not null)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `role_id` | uuid | có | → role |
| `permission_id` | uuid | có | → permission |
| `scope_mode` | text | có | phạm vi của quyền (chốt 04/11) · giá trị: THEO_VAI_TRO / MOI_NHA_MAY / NHA_MAY_TAI_KHOAN / CO_DINH · mặc định 'THEO_VAI_TRO' |
| `scope_factory_id` | uuid |  | nhà máy cố định (chỉ khi CO_DINH) · → factory |
| `revoked_at` | timestamptz |  |  |
| `revoked_by` | uuid |  | → app_user |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `screen`

Màn hình của menu web (thêm 20/10): phân hệ, tên, thứ tự. Nạp sẵn từ mục "Màn × chức năng" (phần "Phân hệ & màn hình") của file quy trình. Menu hiện màn khi vai trò của người dùng có ít nhất 1 quyền ở các chức năng của màn (screen_function, view v_user_screen); phân hệ không còn màn nào thì ẩn. Không có màn quản lý: đổi = sửa file quy trình rồi sinh lại dữ liệu nạp.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud chủ → nhà máy
- **QT:** QT01; nạp khi triển khai
- **Khóa chính:** `id`
- **Unique:** `(code)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `code` | text | có | mã màn, vd KHO_XUAT |
| `module` | text | có | phân hệ trên menu (12 phân hệ theo menu mockup 04/11 — thêm Tổng quan, Hồ sơ & biểu mẫu in) · giá trị: TONG_QUAN / VIEC_CAN_LAM / BAN_HANG / MUA_HANG / KE_TOAN / KHO / SAN_XUAT / CHAT_LUONG / TRUY_XUAT_THU_HOI / HO_SO_BIEU_MAU / DANH_MUC / QUAN_TRI |
| `name` | text | có |  |
| `sort_order` | integer | có | thứ tự trên menu |
| `always_visible` | boolean | có | hiện cho mọi người dùng, không xét quyền (Việc cần làm; Hồ sơ & biểu mẫu in — chỉ hiện phiếu của phân hệ có quyền, 04/11) · mặc định false |
| `status` | text | có | giá trị: DANG_DUNG / NGUNG_DUNG · mặc định 'DANG_DUNG' |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `screen_function`

Màn × chức năng (thêm 20/10): các bước quy trình (permission.function_code) làm hoặc xem ở màn đó. Người dùng thấy màn khi một vai trò còn hiệu lực của họ có quyền (role_permission còn hiệu lực) ở ít nhất 1 chức năng của màn. QT01.xa (Admin · Giám đốc xem mọi màn) có ở mọi màn trừ Việc cần làm, Hồ sơ & biểu mẫu in. Sửa 04/11: bỏ cột warehouse_type (cờ @DIEU_PHOI) — Thủ kho điều phối là vai trò riêng.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud chủ → nhà máy
- **QT:** QT01; nạp khi triển khai
- **Khóa chính:** `id`
- **Khóa ngoại:** `screen_id` → `screen.id`
- **Unique:** `(screen_id, function_code)`
- **Trigger:** function_code phải có trong permission (trg_screen_function_ma)

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `screen_id` | uuid | có | → screen |
| `function_code` | text | có | mã chức năng của bảng quyền, vd QT15.d1 — phải có trong permission (trigger kiểm khi nạp) |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `user_role`

Gán vai trò cho tài khoản kèm phạm vi: toàn hệ thống / nhà máy / kho / khu vực làm việc → Quyền = vai trò × thao tác × phạm vi. Đổi vai trò = thu hồi dòng cũ + thêm dòng mới trong 1 giao dịch. Không ai tự gán / tự gỡ vai trò của chính mình (check); vai trò chỉ Admin gán thì trigger kiểm người gán là Admin. Ủy quyền tạm sinh dòng có valid_until, đến hạn tự gỡ.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud chủ → nhà máy
- **QT:** QT01 y1, y2, u2, u3
- **Khóa chính:** `id`
- **Khóa ngoại:** `user_id` → `app_user.id` · `role_id` → `role.id` · `factory_id` → `factory.id` · `warehouse_id` → `warehouse.id` · `work_area_id` → `work_area.id` · `delegation_id` → `user_delegation.id` · `revoked_by` → `app_user.id`
- **Unique:** `(user_id, role_id, scope_type, factory_id, warehouse_id, work_area_id where revoked_at is null)` — null coi như bằng nhau
- **Check:** `(scope_type = 'TOAN_HT' and factory_id is null and warehouse_id is null and work_area_id is null) or (scope_type = 'NHA_MAY' and factory_id is not null and warehouse_id is null and work_area_id is null) or (scope_type = 'KHO' and warehouse_id is not null and work_area_id is null) or (scope_type = 'KHU_VUC' and work_area_id is not null and warehouse_id is null)` · `user_id <> created_by` · `revoked_by is null or revoked_by <> user_id` · `(delegation_id is null) = (valid_until is null)` · `valid_until is null or valid_until > valid_from`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `user_id` | uuid | có | → app_user |
| `role_id` | uuid | có | → role |
| `scope_type` | text | có | giá trị: TOAN_HT / NHA_MAY / KHO / KHU_VUC |
| `factory_id` | uuid |  | → factory |
| `warehouse_id` | uuid |  | → warehouse |
| `work_area_id` | uuid |  | → work_area |
| `valid_from` | timestamptz | có | mặc định now() |
| `valid_until` | timestamptz |  | hết hạn — chỉ với vai trò ủy quyền tạm |
| `delegation_id` | uuid |  | dòng sinh từ ủy quyền tạm · → user_delegation |
| `revoked_at` | timestamptz |  |  |
| `revoked_by` | uuid |  | → app_user |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `user_delegation`

Ủy quyền tạm khi vắng (QT01 u1–u3): HR hoặc Admin giao 1 vai trò của người vắng cho người nhận trong khoảng ngày, bắt buộc ngày hết hạn. Lưu là sinh 1 dòng user_role tạm (valid_until = ngày hết hạn); đến hạn hệ thống tự gỡ, ghi nhật ký, báo cả 2 người. Người nhận vẫn không được duyệt phiếu mình tạo.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc
- **QT:** QT01 u1, u2, u3
- **Khóa chính:** `id`
- **Khóa ngoại:** `delegator_id` → `app_user.id` · `role_id` → `role.id` · `delegate_id` → `app_user.id` · `factory_id` → `factory.id` · `warehouse_id` → `warehouse.id` · `work_area_id` → `work_area.id` · `revoked_by` → `app_user.id`
- **Check:** `delegator_id <> delegate_id` · `ends_at > starts_at` · `delegate_id <> created_by` · `status = 'HIEU_LUC' or revoked_at is not null`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `delegator_id` | uuid | có | người vắng · → app_user |
| `role_id` | uuid | có | vai trò ủy quyền (vai trò có delegable) · → role |
| `delegate_id` | uuid | có | người nhận · → app_user |
| `scope_type` | text | có | phạm vi = phạm vi vai trò đó của người vắng · giá trị: TOAN_HT / NHA_MAY / KHO / KHU_VUC |
| `factory_id` | uuid |  | → factory |
| `warehouse_id` | uuid |  | → warehouse |
| `work_area_id` | uuid |  | → work_area |
| `starts_at` | timestamptz | có | ngày bắt đầu |
| `ends_at` | timestamptz | có | ngày hết hạn (bắt buộc) |
| `reason` | text |  |  |
| `status` | text | có | HET_HAN: hệ thống tự gỡ khi đến hạn; màn hình hiện "Sắp bắt đầu" khi starts_at ở tương lai — suy ra từ ngày, không thêm giá trị trạng thái · giá trị: HIEU_LUC / HET_HAN / THU_HOI_SOM · mặc định 'HIEU_LUC' |
| `revoked_at` | timestamptz |  |  |
| `revoked_by` | uuid |  | HR / Admin thu hồi sớm; hệ thống khi hết hạn · → app_user |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `job_title_role`

Bảng gợi ý Chức danh → Vai trò khi HR tạo tài khoản.

- **Nơi:** Chỉ cloud — chỉ cloud
- **QT:** QT01 y0
- **Khóa chính:** `id`
- **Khóa ngoại:** `role_id` → `role.id`
- **Unique:** `(job_title, role_id)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `job_title` | text | có |  |
| `role_id` | uuid | có | → role |
| `active` | boolean | có | mặc định true |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `user_session`

Phiên đăng nhập (web, PC xưởng C#). Web: mã NV + mật khẩu; PC xưởng: quét thẻ NV (hoặc mã NV + mật khẩu). Không còn máy quét riêng (bỏ MAY_QUET 19/10 đợt 2). Khóa tài khoản → đóng mọi phiên, chặn thẻ.

- **Nơi:** Nơi phát sinh là chủ — nơi tạo dòng là chủ; dòng tạo ở máy chủ nhà máy gộp lên cloud qua sync_outbox
- **QT:** QT01 nk
- **Khóa chính:** `id`
- **Khóa ngoại:** `user_id` → `app_user.id` · `factory_id` → `factory.id`
- **Check:** `login_method <> 'QUET_THE' or device_type = 'PC_CSHARP'`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `user_id` | uuid | có | → app_user |
| `factory_id` | uuid |  | null = phiên trên cloud · → factory |
| `device_type` | text | có | PC_CSHARP = PC xưởng · giá trị: WEB / PC_CSHARP |
| `device_id` | text |  |  |
| `login_method` | text | có | QUET_THE chỉ ở PC xưởng · giá trị: MAT_KHAU / QUET_THE |
| `started_at` | timestamptz | có | mặc định now() |
| `last_seen_at` | timestamptz |  |  |
| `ended_at` | timestamptz |  |  |
| `end_reason` | text |  | giá trị: DANG_XUAT / HET_HAN / KHOA_TAI_KHOAN |

<sub>Cột chung: `— (nhật ký / hàng đợi có cột thời điểm + người riêng)`</sub>

### `account_change_log`

Nhật ký thay đổi tài khoản / vai trò: ai làm, loại, vai trò trước / sau, thời điểm.

- **Nơi:** Chỉ cloud — chỉ cloud
- **QT:** QT01 yl, nk, r3, u2, u3; xóa tài khoản chưa dùng (04/11)
- **Khóa chính:** `id`
- **Khóa ngoại:** `user_id` → `app_user.id` · `actor_id` → `app_user.id`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `user_id` | uuid |  | tài khoản bị thay đổi; trống khi tài khoản đã bị xóa (mã NV giữ ở detail — 04/11) · → app_user |
| `change_type` | text | có | giá trị: TAO / SUA_THONG_TIN / DOI_VAI_TRO / DAT_NGAY_KHOA / KHOA / MO_KHOA / CAP_MAT_KHAU / UY_QUYEN / HET_UY_QUYEN / XOA |
| `roles_before` | jsonb |  |  |
| `roles_after` | jsonb |  |  |
| `detail` | jsonb |  |  |
| `actor_id` | uuid | có | → app_user |
| `occurred_at` | timestamptz | có | mặc định now() |

<sub>Cột chung: `— (nhật ký / hàng đợi có cột thời điểm + người riêng)`</sub>

### `audit_log`

Nhật ký thay đổi chung cho mọi bảng nghiệp vụ (dữ liệu trước / sau). Ghi bằng trigger.

- **Nơi:** Nơi phát sinh là chủ — nơi tạo dòng là chủ; dòng tạo ở máy chủ nhà máy gộp lên cloud qua sync_outbox
- **QT:** mọi QT
- **Khóa chính:** `id`
- **Khóa ngoại:** `actor_id` → `app_user.id` · `factory_id` → `factory.id`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `table_name` | text | có |  |
| `record_id` | uuid | có |  |
| `action` | text | có | giá trị: TAO / SUA / DOI_TRANG_THAI / KHOA / HUY |
| `before_data` | jsonb |  |  |
| `after_data` | jsonb |  |  |
| `actor_id` | uuid |  | → app_user |
| `factory_id` | uuid |  | → factory |
| `origin_site` | text | có | giá trị: CLOUD / NM |
| `occurred_at` | timestamptz | có | mặc định now() |

<sub>Cột chung: `— (nhật ký / hàng đợi có cột thời điểm + người riêng)`</sub>

### `system_parameter`

Tham số cấu hình — mọi số trong mục "Tham số mặc định". Giá trị chung, có thể ghi đè theo nhà máy hoặc theo nhóm (TP / NVL / BTP / mã NVL). Lịch sử sửa nằm ở audit_log.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud chủ → nhà máy (tham số ngoại tuyến, hạn tối thiểu cho SX…)
- **QT:** Admin cấu hình (QT01); đọc ở QT01, 06, 09, 10, 12, 14, 16, 18, 19, 24, 25, 26
- **Khóa chính:** `id`
- **Khóa ngoại:** `factory_id` → `factory.id`
- **Unique:** `(param_key, factory_id, group_code)` — null coi như bằng nhau
- **Check:** `(scope_type = 'NHA_MAY') = (factory_id is not null)` · `(scope_type = 'NHOM') = (group_code is not null)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `param_key` | text | có |  |
| `scope_type` | text | có | giá trị: TOAN_HT / NHA_MAY / NHOM · mặc định 'TOAN_HT' |
| `factory_id` | uuid |  | → factory |
| `group_code` | text |  | vd TP, NVL, BTP hoặc mã NVL |
| `value` | jsonb | có |  |
| `default_value` | jsonb | có |  |
| `unit` | text |  | giá trị: NGAY / GIO / PHUT / GIAY / VND / TY_LE / THANG / BAT_TAT / DANH_SACH |
| `qt_code` | text | có |  |
| `description` | text | có |  |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `uom`

Đơn vị tính — màn riêng Danh mục › Đơn vị (chốt 04/11, thay mục trong Tham số): loại, quy đổi về đơn vị gốc, trạng thái. Xóa được khi chưa có tham chiếu (khóa ngoại chặn); đã dùng thì ngừng dùng.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud chủ → nhà máy
- **QT:** Danh mục › Đơn vị (thêm / sửa / ngừng dùng / xóa khi chưa dùng); nạp khi triển khai
- **Khóa chính:** `code`
- **Khóa ngoại:** `base_uom_code` → `uom.code`
- **Check:** `(base_uom_code is null) = (factor is null)` · `factor is null or factor > 0` · `base_uom_code is null or base_uom_code <> code`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `code` | text | có | KG, G, BAO, THUNG, LON, CAI |
| `name` | text | có |  |
| `uom_type` | text | có | loại đơn vị · giá trị: KHOI_LUONG / THE_TICH / DEM · mặc định 'DEM' |
| `base_uom_code` | text |  | đơn vị gốc để quy đổi (vd tấn → kg); trống = chính nó là gốc hoặc quy đổi theo NVL / quy cách · → uom |
| `factor` | numeric(18,6) |  | 1 đơn vị này = factor × đơn vị gốc |
| `conversion_note` | text |  | quy đổi theo NVL / quy cách SP, vd "1 bao = 25 kg (theo NVL)" |
| `usage_note` | text |  | dùng ở đâu |
| `status` | text | có | giá trị: DANG_DUNG / NGUNG_DUNG · mặc định 'DANG_DUNG' |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `material`

Danh mục NVL: bột, phụ gia, bao bì (lon, thùng, nắp…). Mã đã có giao dịch thì khóa ĐVT (QT02 f1). Lô bao bì là lô của NVL nhóm BAO_BI. Sửa 04/11: tối đa 5 ảnh, nguyên liệu kỵ nhau (chọn nhiều), tồn tối thiểu + cách bù, ghi chú; NVL (trừ HON_HOP) bắt buộc ít nhất 1 chỉ tiêu COA đang dùng (trigger kiểm lúc COMMIT).

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud chủ → nhà máy
- **QT:** tạo / sửa QT02 (mã tự sinh y2, không duyệt); ngừng dùng QT02 tg, d4
- **Khóa chính:** `id`
- **Khóa ngoại:** `uom_code` → `uom.code` · `produced_by_formula_id` → `formula.id`
- **Unique:** `(code)`
- **Check:** `shelf_life_days > 0` · `(material_group = 'HON_HOP') = (produced_by_formula_id is not null)` · `purchase_lead_days is null or purchase_lead_days >= 0` · `cardinality(image_file_ids) <= 5` · `not (id = any(incompatible_material_ids))` · `min_stock_qty is null or min_stock_qty >= 0`
- **Trigger (04/11):** NVL ĐANG DÙNG (trừ nhóm HON_HOP) phải có ít nhất 1 chỉ tiêu `material_spec_item` dùng cho COA đang dùng — kiểm lúc COMMIT (trg_material_coa_spec)

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `code` | text | có | hệ thống tự sinh theo code_format, vd NVL-BOT-0001; không sửa |
| `name` | text | có |  |
| `material_group` | text | có | vào mã: BOT → BOT, PHU_GIA → PGA, BAO_BI → BBI, HON_HOP → HHP; HON_HOP = NVL hỗn hợp (bao HH) — tạm đặt ở đây, xem câu hỏi · giá trị: BOT / PHU_GIA / BAO_BI / HON_HOP |
| `uom_code` | text | có | → uom |
| `shelf_life_days` | integer | có | HSD chuẩn |
| `storage_condition` | text | có |  |
| `purchase_lead_days` | integer |  | thời gian NCC giao hàng mặc định (ngày) — tính ngày cần của yêu cầu mua; null → tham số purchase.default_lead_days (24/10 đợt 12) |
| `coa_required` | boolean | có | mặc định true |
| `min_stock_qty` | numeric(14,3) |  | tồn tối thiểu (ĐVT của NVL) — phần thiếu vào nhu cầu mua |
| `replenish_method` | text |  | cách bù khi dưới tồn tối thiểu (Kế hoạch đặt, hệ thống tự bù theo cách này) |
| `image_file_ids` | uuid[] | có | ảnh NVL, tối đa 5 (chốt 30/10) · mặc định '{}' |
| `incompatible_material_ids` | uuid[] | có | nguyên liệu kỵ nhau, chọn nhiều (chốt 30/10) · mặc định '{}' |
| `note` | text |  |  |
| `produced_by_formula_id` | uuid |  | chỉ với HON_HOP · → formula |
| `uom_locked` | boolean | có | đã có giao dịch → không đổi ĐVT · mặc định false |
| `status` | text | có | giá trị: DANG_DUNG / NGUNG_DUNG · mặc định 'DANG_DUNG' |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `material_spec_item`

Bộ chỉ tiêu COA và giới hạn của từng NVL (nhà máy tự nhập). Kiểm COA tự động khi nhập (QT14) và so kết quả QC NVL (QT22). Kết quả kiểm luôn chép lại giới hạn lúc kiểm, nên sửa giới hạn không làm sai kết quả cũ. Mỗi NVL mua (không phải HON_HOP) bắt buộc ít nhất 1 chỉ tiêu COA (chốt 04/11). Kiểm COA & HSD trước khi lập PO dùng bộ này (purchase_order_coa_result).

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc
- **QT:** tạo / sửa QT02; dùng QT12 (kiểm COA & HSD của PO), QT14 lv, QT22 g1
- **Khóa chính:** `id`
- **Khóa ngoại:** `material_id` → `material.id`
- **Unique:** `(material_id, criterion_code where status = 'DANG_DUNG')`
- **Check:** `min_value is null or max_value is null or min_value <= max_value`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `material_id` | uuid | có | → material |
| `criterion_code` | text | có |  |
| `criterion_name` | text | có |  |
| `unit` | text |  |  |
| `value_type` | text | có | giá trị: SO / CHU / DAT_KHONG |
| `min_value` | numeric |  |  |
| `max_value` | numeric |  |  |
| `expected_text` | text |  |  |
| `used_for_coa` | boolean | có | mặc định true |
| `used_for_qc` | boolean | có | mặc định true |
| `sort_order` | integer | có | mặc định 0 |
| `status` | text | có | giá trị: DANG_DUNG / NGUNG_DUNG · mặc định 'DANG_DUNG' |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `product`

Danh mục SP (mô hình mới chốt 04/11): 1 mã SP có nhiều quy cách đóng gói, mỗi quy cách nhiều tầng (product_pack, product_pack_level); ô Cấu trúc / Nhóm / Phân loại / Độ tuổi chọn từ product_option; thương hiệu và thông tin khác gõ tự do ở "mục khác" (extra_attributes). Mỗi quy cách một mẫu nhãn, QC trưởng duyệt (product_label); bản công bố và hồ sơ pháp lý riêng ở product_document, hồ sơ pháp lý chung ở legal_document. Sau khi lưu, thông tin SP, mục khác và quy cách khóa theo mã + barcode — muốn đổi thì sao chép thành mã mới; chỉ sửa mẫu nhãn và hồ sơ pháp lý. Nhiều SP dùng chung 1 công thức BTP. Lô BTP / TP gắn SP. Bộ chỉ tiêu thành phẩm ở product_spec_item.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud chủ → nhà máy
- **QT:** tạo / sửa QT02 (mã tự sinh y2, không duyệt); duyệt mẫu nhãn (QC trưởng); ngừng dùng QT02 tg, d4; bộ chỉ tiêu BTP / TP ở product_spec_item (QT02 qc, QT23 g1)
- **Khóa chính:** `id`
- **Khóa ngoại:** `formula_id` → `formula.id` · `structure_option_id` → `product_option.id` · `group_option_id` → `product_option.id` · `class_option_id` → `product_option.id` · `age_option_id` → `product_option.id` · `made_at_factory_id` → `factory.id`
- **Unique:** `(code)` · `(can_barcode where can_barcode is not null)`
- **Check:** `shelf_life_days > 0`
- **Trigger (04/11):** ô Cấu trúc / Nhóm / Phân loại / Độ tuổi phải là lựa chọn đúng loại, đang dùng (trg_product_options)

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `code` | text | có | hệ thống tự sinh, vd SP-0001; không sửa |
| `name` | text | có |  |
| `formula_id` | uuid | có | công thức BTP · → formula |
| `structure_option_id` | uuid | có | Cấu trúc, vd Dạng bột / Dạng nước · → product_option |
| `group_option_id` | uuid | có | Nhóm, vd Sữa bột trẻ em · → product_option |
| `class_option_id` | uuid |  | Phân loại, vd Cao cấp / Trung cấp · → product_option |
| `age_option_id` | uuid |  | Độ tuổi, vd 1–3 tuổi · → product_option |
| `company_name` | text | có | tên công ty chủ sản phẩm (in trên nhãn) |
| `made_at_factory_id` | uuid |  | nơi sản xuất · → factory |
| `extra_attributes` | jsonb | có | mục khác [{t, v}] — vd Thương hiệu: Nhãn A (gõ tự do, thay bảng thương hiệu) · mặc định '[]' |
| `shelf_life_days` | integer | có |  |
| `can_barcode` | text |  | mã in sẵn trên bao bì lon để kiểm "đúng nhãn hiệu của mẻ" |
| `uom_locked` | boolean | có | mặc định false |
| `status` | text | có | giá trị: DANG_DUNG / NGUNG_DUNG · mặc định 'DANG_DUNG' |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `product_option`

Lựa chọn của các ô chọn ở SP (chốt 04/11): Cấu trúc, Nhóm, Phân loại, Độ tuổi — thay các danh mục thương hiệu / dòng / hạng. Xóa được khi chưa SP nào dùng (khóa ngoại chặn); đã dùng thì ngừng dùng.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud chủ → nhà máy
- **QT:** QT02 (Danh mục › Sản phẩm)
- **Khóa chính:** `id`
- **Unique:** `(option_kind, lower(name))`
- **Check:** `sort_order >= 0`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `option_kind` | text | có | giá trị: CAU_TRUC / NHOM / PHAN_LOAI / DO_TUOI |
| `name` | text | có |  |
| `sort_order` | integer | có | mặc định 0 |
| `status` | text | có | giá trị: DANG_DUNG / NGUNG_DUNG · mặc định 'DANG_DUNG' |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `product_pack`

Quy cách đóng gói của 1 SP (chốt 04/11): 1 SP nhiều quy cách; mỗi quy cách chọn dụng cụ đóng gói và các tầng (product_pack_level, vd Lon → Thùng). Khóa theo mã SP sau khi lưu; xóa được khi chưa dùng (khóa ngoại chặn).

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud chủ → nhà máy
- **QT:** QT02 (Danh mục › Sản phẩm, quy cách đóng gói)
- **Khóa chính:** `id`
- **Khóa ngoại:** `product_id` → `product.id`
- **Unique:** `(product_id, line_no)`
- **Check:** `line_no > 0`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `product_id` | uuid | có | → product |
| `line_no` | integer | có | thứ tự quy cách trong SP |
| `pack_tool` | text | có | dụng cụ đóng gói tầng trong cùng, vd Lon / Hộp / Túi |
| `status` | text | có | giá trị: DANG_DUNG / NGUNG_DUNG · mặc định 'DANG_DUNG' |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `product_pack_level`

Tầng của quy cách (chốt 04/11): tầng 1 = đơn vị nhỏ nhất (lon / gói) có khối lượng / thể tích tịnh; tầng trên ghi số đơn vị tầng dưới (vd 1 thùng = 24 lon).

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud chủ → nhà máy
- **QT:** QT02
- **Khóa chính:** `id`
- **Khóa ngoại:** `pack_id` → `product_pack.id` · `net_uom_code` → `uom.code`
- **Unique:** `(pack_id, level_no)`
- **Check:** `level_no > 0` · `(level_no = 1) = (child_qty is null)` · `child_qty is null or child_qty > 0` · `level_no <> 1 or (net_qty is not null and net_uom_code is not null)` · `net_qty is null or net_qty > 0`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `pack_id` | uuid | có | → product_pack |
| `level_no` | integer | có | 1 = trong cùng |
| `unit_name` | text | có | tên đơn vị của tầng, vd Lon, Thùng |
| `child_qty` | integer |  | số đơn vị tầng dưới trong 1 đơn vị tầng này (tầng 1 để trống) |
| `net_qty` | numeric(12,3) |  | khối lượng / thể tích tịnh mỗi đơn vị — bắt buộc ở tầng 1 |
| `net_uom_code` | text |  | g / kg / ml / l · → uom |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `product_label`

Mẫu nhãn theo từng quy cách của SP (chốt 04/11): tải bản mới = dòng mới Chờ duyệt (bản cũ ghi superseded_at); QC trưởng duyệt. Lệnh BTP chỉ dùng quy cách có mẫu nhãn hiện hành đã duyệt.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud chủ → nhà máy
- **QT:** QT02 (Duyệt mẫu nhãn — QC trưởng); QT19 (điều kiện lệnh BTP)
- **Khóa chính:** `id`
- **Khóa ngoại:** `product_pack_id` → `product_pack.id` · `file_id` → `file_attachment.id` · `approved_by` → `app_user.id`
- **Unique:** `(product_pack_id, version_no)` · `(product_pack_id where superseded_at is null)`
- **Check:** `status = 'CHO_DUYET' or (approved_by is not null and approved_at is not null)` · `status <> 'TU_CHOI' or reject_reason is not null` · `approved_by is null or approved_by <> created_by`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `product_pack_id` | uuid | có | → product_pack |
| `version_no` | integer | có |  |
| `file_id` | uuid | có | file mẫu nhãn (PDF / ảnh) · → file_attachment |
| `status` | text | có | giá trị: CHO_DUYET / DA_DUYET / TU_CHOI · mặc định 'CHO_DUYET' |
| `approved_by` | uuid |  | QC trưởng duyệt / từ chối · → app_user |
| `approved_at` | timestamptz |  |  |
| `reject_reason` | text |  |  |
| `superseded_at` | timestamptz |  | có bản mới thay |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `product_document`

Hồ sơ pháp lý riêng của 1 SP (chốt 04/11): bản công bố sản phẩm (bắt buộc với SP dùng cho lệnh BTP — tự công bố hoặc đăng ký bản công bố, số, ngày, file) và các hồ sơ riêng khác (loại, số, hạn, file). Hồ sơ dùng chung nhiều SP ở legal_document.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud chủ → nhà máy
- **QT:** QT02 (Danh mục › Sản phẩm); QT19 (điều kiện lệnh BTP)
- **Khóa chính:** `id`
- **Khóa ngoại:** `product_id` → `product.id` · `file_id` → `file_attachment.id`
- **Unique:** `(product_id where doc_kind = 'CONG_BO' and status = 'DANG_DUNG')`
- **Check:** `doc_kind <> 'CONG_BO' or (declaration_kind is not null and issued_date is not null and file_id is not null)` · `doc_kind = 'CONG_BO' or declaration_kind is null` · `exp_date is null or issued_date is null or exp_date > issued_date`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `product_id` | uuid | có | → product |
| `doc_kind` | text | có | CONG_BO: bản công bố sản phẩm; RIENG: hồ sơ riêng khác · giá trị: CONG_BO / RIENG |
| `declaration_kind` | text |  | hình thức công bố (chỉ CONG_BO) · giá trị: TU_CONG_BO / DANG_KY |
| `doc_type` | text |  | loại hồ sơ (RIENG) |
| `doc_no` | text | có |  |
| `issued_date` | date |  | ngày công bố / tiếp nhận / cấp |
| `exp_date` | date |  | hết hạn (trống = không thời hạn) |
| `file_id` | uuid |  | → file_attachment |
| `status` | text | có | giá trị: DANG_DUNG / NGUNG_DUNG · mặc định 'DANG_DUNG' |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `legal_document`

Hồ sơ pháp lý chung (màn Danh mục › Hồ sơ pháp lý chung — chốt 04/11): giấy tờ doanh nghiệp, ATTP, chứng nhận thị trường, quảng cáo…; phạm vi áp dụng: mọi SP, SP của nhà máy, hoặc SP chọn (legal_document_scope). Hạn trống = không thời hạn; nhắc trước hạn N ngày. Trạng thái Hiệu lực / Sắp hết hạn / Hết hạn tính từ hạn, không lưu. Xóa được (chưa có bảng nào trỏ tới).

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud chủ → nhà máy
- **QT:** Danh mục › Hồ sơ pháp lý chung (thêm / sửa / xóa); đọc ở SP, lệnh SX
- **Khóa chính:** `id`
- **Unique:** `(code)`
- **Check:** `cardinality(file_ids) > 0` · `remind_days >= 0` · `exp_date is null or issued_date is null or exp_date > issued_date`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `code` | text | có | HS-0001 (code_format HO_SO_PHAP_LY) |
| `name` | text | có |  |
| `doc_type` | text | có | vd Pháp lý doanh nghiệp, An toàn thực phẩm, Chứng nhận thị trường |
| `doc_no` | text | có |  |
| `issuing_org` | text |  | cơ quan cấp |
| `issued_date` | date |  |  |
| `exp_date` | date |  | trống = không thời hạn |
| `remind_days` | integer | có | nhắc trước hạn N ngày · mặc định 60 |
| `scope` | text | có | NHA_MAY: SP sản xuất tại nhà máy chọn; CHON_SP: SP chọn · giá trị: TAT_CA / NHA_MAY / CHON_SP · mặc định 'TAT_CA' |
| `file_ids` | uuid[] | có | các file của hồ sơ · mặc định '{}' |
| `note` | text |  |  |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `legal_document_scope`

Phạm vi của hồ sơ pháp lý chung (chốt 04/11): mỗi dòng 1 nhà máy (scope NHA_MAY) hoặc 1 SP (scope CHON_SP).

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud chủ → nhà máy
- **QT:** Danh mục › Hồ sơ pháp lý chung
- **Khóa chính:** `id`
- **Khóa ngoại:** `legal_document_id` → `legal_document.id` · `factory_id` → `factory.id` · `product_id` → `product.id`
- **Unique:** `(legal_document_id, factory_id, product_id)` — null coi như bằng nhau
- **Check:** `(factory_id is null) <> (product_id is null)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `legal_document_id` | uuid | có | → legal_document |
| `factory_id` | uuid |  | scope NHA_MAY · → factory |
| `product_id` | uuid |  | scope CHON_SP · → product |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `warehouse`

Kho thuộc 1 nhà máy (kho tổng, kho điều phối, kho BTP, kho mẫu QC…). Sửa 04/11: một nhà máy có nhiều kho điều phối; mỗi khu HH / BTP chọn kho điều phối cấp NVL (work_area.supply_warehouse_id).

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud chủ → nhà máy đó
- **QT:** QT02 ka (Admin tạo / sửa / ngừng dùng)
- **Khóa chính:** `id`
- **Khóa ngoại:** `manager_id` → `app_user.id`
- **Unique:** `(factory_id, code)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `code` | text | có | hệ thống tự sinh {nhà máy}-{loại kho}, kho thứ 2 trở đi cùng loại thêm số: NM1-DP, NM1-DP2 — một nhà máy có nhiều kho điều phối (chốt 04/11) |
| `name` | text | có |  |
| `warehouse_type` | text | có | giá trị: TONG / DIEU_PHOI / BTP / MAU_QC / KHAC |
| `manager_id` | uuid |  | người phụ trách · → app_user |
| `status` | text | có | giá trị: DANG_DUNG / NGUNG_DUNG · mặc định 'DANG_DUNG' |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `equipment`

Thiết bị sản xuất (silo, bồn trộn, máy chiết, robot, thang nâng, cân băng tải). Sửa 19/10 (đợt 2): SILO là thiết bị duy nhất có màn quản lý — dàn silo của từng khu HH / BTP do Admin cấu hình trong Quản trị · Nhà máy & khu vực làm việc (thêm, sửa, bảo trì, ngừng dùng; không xóa): tên, sức chứa, gán cứng 1 NVL (tùy chọn), trạng thái Hoạt động / Bảo trì / Ngừng dùng, mã thiết bị trên SCADA. Thiết bị khác không có màn quản lý: do bên cung cấp thiết bị khai báo, nạp khi triển khai. Gộp silo vào bảng này (không tách bảng riêng) vì silo đã là dòng equipment: silo_charge / lot_link / batch_equipment_usage / batch_downtime đều trỏ equipment, iot_source_ref đã là mã SCADA — tách bảng thì trùng mã / tên / SCADA và phải đổi 4 khóa ngoại. Bỏ thiết bị đo (19/10). ĐIỂM NỐI IoT: iot_source_ref.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud chủ → nhà máy đó (silo đi kèm phương án silo của lệnh)
- **QT:** silo: QT02 ka, ks, ksy (Admin); phương án silo QT19 ys / yx; mở silo QT20 y1. Thiết bị khác: nạp khi triển khai; dùng QT20, QT21 (batch_equipment_usage)
- **Khóa chính:** `id`
- **Khóa ngoại:** `work_area_id` → `work_area.id` · `hard_material_id` → `material.id`
- **Unique:** `(factory_id, code)` · `(iot_source_ref where iot_source_ref is not null)` · `(work_area_id, name where equipment_type = 'SILO')`
- **Check:** `equipment_type <> 'SILO' or (work_area_id is not null and capacity_kg > 0 and iot_source_ref is not null)` · `equipment_type = 'SILO' or (capacity_kg is null and hard_material_id is null and status <> 'BAO_TRI')`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `code` | text | có | mã theo danh sách của bên cung cấp thiết bị (silo: Admin đặt khi thêm silo) |
| `name` | text | có |  |
| `equipment_type` | text | có | giá trị: SILO / BON_TRON / MAY_CHIET / ROBOT / THANG_NANG / CAN_BANG_TAI / KHAC |
| `work_area_id` | uuid |  | khu chứa thiết bị — bắt buộc với SILO (chỉ khu HH / BTP, trigger) · → work_area |
| `location_text` | text |  | vị trí |
| `capacity_kg` | numeric(12,3) |  | sức chứa (kg) — chỉ silo, bắt buộc; KL NVL / mẻ xếp vào silo không vượt |
| `hard_material_id` | uuid |  | gán cứng 1 NVL (tùy chọn, chỉ silo): silo chỉ nhận NVL này · → material |
| `iot_source_ref` | text |  | mã thiết bị / tag gốc trên SCADA — bắt buộc với SILO; ĐIỂM NỐI IoT |
| `status` | text | có | silo: DANG_DUNG = Hoạt động / BAO_TRI / NGUNG_DUNG; BAO_TRI chỉ cho silo. Silo chuyển bảo trì / ngừng dùng → lệnh MOI_TAO đang xếp NVL vào bị đánh dấu CAN_XEP_LAI (trigger); không chuyển BAO_TRI / NGUNG_DUNG khi silo còn nút SILO đang mở (còn bột của lệnh — trigger) · giá trị: DANG_DUNG / BAO_TRI / NGUNG_DUNG · mặc định 'DANG_DUNG' |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `formula`

Công thức (HH hoặc BTP), thuộc phân hệ Sản xuất. Mã do hệ thống tự sinh CT-{loại}-{4 số} (sửa 20/10 đợt 3: 2 → 4 số), không sửa. Nội dung nằm ở phiên bản.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud chủ → nhà máy
- **QT:** QT03 (mã tự sinh y2)
- **Khóa chính:** `id`
- **Unique:** `(code)`
- **Check:** `code ~ ('^CT-' || formula_kind || '-[0-9]{4,}$')`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `code` | text | có | hệ thống tự sinh CT-{loại}-{4 số} (loại HH / BTP, vd CT-HH-0001, CT-BTP-0002); không sửa |
| `name` | text | có |  |
| `formula_kind` | text | có | giá trị: HH / BTP |
| `status` | text | có | giá trị: DANG_DUNG / NGUNG_DUNG · mặc định 'DANG_DUNG' |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `formula_version`

Phiên bản công thức. Chỉ ghi nhận, không duyệt: lưu là có hiệu lực, bản cũ hết hiệu lực nhưng giữ nguyên để truy xuất; lệnh đã phát giữ phiên bản cũ. Không sửa dòng đã lưu. Màn Công thức hiện lệnh nào đang chạy phiên bản cũ: production_order.formula_version_id trỏ tới phiên bản is_current = false, lệnh DANG_CHAY.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud chủ → nhà máy (gửi kèm lệnh)
- **QT:** QT03 y2
- **Khóa chính:** `id`
- **Khóa ngoại:** `formula_id` → `formula.id`
- **Unique:** `(formula_id, version_no)` · `(formula_id where is_current)`
- **Check:** `batch_weight_kg > 0` · `mixing_time_min is null or mixing_time_min > 0` · `mixing_speed_rpm is null or mixing_speed_rpm > 0`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `formula_id` | uuid | có | → formula |
| `version_no` | integer | có |  |
| `batch_weight_kg` | numeric(12,3) | có | KL mẻ |
| `mixing_time_min` | numeric(8,2) |  | thời gian trộn chuẩn (phút) |
| `mixing_speed_rpm` | numeric(8,2) |  | tốc độ trộn chuẩn (vòng / phút) |
| `mixing_params` | jsonb |  | thông số trộn khác (QT03 t1); thứ tự nạp ở formula_item.load_order (04/11) |
| `effective_from` | timestamptz | có | mặc định now() |
| `superseded_at` | timestamptz |  |  |
| `is_current` | boolean | có | mặc định true |
| `note` | text |  |  |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `formula_item`

Thành phần của phiên bản: NVL (hoặc NVL hỗn hợp), KL / mẻ, dung sai. Tổng KL thành phần = KL mẻ (kiểm khi lưu, QT03 y1).

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud chủ → nhà máy
- **QT:** QT03
- **Khóa chính:** `id`
- **Khóa ngoại:** `formula_version_id` → `formula_version.id` · `material_id` → `material.id`
- **Unique:** `(formula_version_id, line_no)` · `(formula_version_id, material_id)` · `(formula_version_id, load_order where load_order is not null)`
- **Check:** `qty_kg > 0 and tolerance_kg >= 0` · `load_order is null or load_order > 0`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `formula_version_id` | uuid | có | → formula_version |
| `line_no` | integer | có |  |
| `material_id` | uuid | có | → material |
| `qty_kg` | numeric(12,3) | có |  |
| `tolerance_kg` | numeric(12,3) | có | dung sai từng thành phần |
| `load_order` | integer |  | thứ tự nạp của thành phần (thông số trộn chuẩn — 04/11) |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `label_incident`

Sự cố tem (QT04, sửa 19/10 đợt 2: làm ở Kho · Tồn kho, không còn máy quét riêng): chọn dòng lô × kho → danh sách bao → Sự cố tem. Hỏng → in lại cùng mã, dán, quét xác nhận; mất → kho + lô lấy từ dòng tồn, chọn mã cũ để khóa, cấp mã mới cùng lô (in, dán, quét xác nhận); hủy → khóa mã, thu tem; hủy khi bao còn trong kho → ghi như tem mất (cấp mã mới, from_cancel). Mã mới vào cùng dòng tồn với mã cũ — mang trạng thái + lý do khóa của bao cũ (24/10 đợt 9). Mã cũ trỏ mã mới qua handling_unit.replaced_by_id; mã đã khóa bị quét ở bất kỳ màn nào → scan_log chặn, hiện mã thay thế.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT04 t0, y0 · t5a, y4, t5 · t6c, y5, t6 · t4, dh, y8 (màn Kho · Tồn kho)
- **Khóa chính:** `id`
- **Khóa ngoại:** `handling_unit_id` → `handling_unit.id` · `new_handling_unit_id` → `handling_unit.id` · `warehouse_id` → `warehouse.id` · `lot_id` → `lot.id`
- **Check:** `(incident_type = 'MAT') = (new_handling_unit_id is not null)` · `incident_type <> 'MAT' or lot_id is not null` · `not from_cancel or incident_type = 'MAT'` · `incident_type <> 'MAT' or warehouse_id is not null`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `incident_type` | text | có | giá trị: HONG / MAT / HUY |
| `handling_unit_id` | uuid | có | mã cũ · → handling_unit |
| `new_handling_unit_id` | uuid |  | mã mới (tem mất) · → handling_unit |
| `warehouse_id` | uuid |  | kho của dòng tồn đã chọn ở Kho · Tồn kho (tem mất — bắt buộc) · → warehouse |
| `lot_id` | uuid |  | lô của dòng tồn đã chọn (tem mất — bắt buộc) · → lot |
| `from_cancel` | boolean | có | hủy tem khi bao còn trong kho → chuyển sang luồng tem mất · mặc định false |
| `confirmed_scan_at` | timestamptz |  | quét xác nhận tem mới / tem in lại (đầu đọc mã ở màn Kho) |
| `reprint_count` | smallint | có | mặc định 0 |
| `note` | text |  |  |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `file_attachment`

Tệp đính kèm (COA, ảnh, hợp đồng, phụ lục, biên bản, báo cáo). Bảng khác trỏ tới bằng cột *_file_id.

- **Nơi:** Nơi phát sinh là chủ — nơi tạo dòng là chủ; dòng tạo ở máy chủ nhà máy gộp lên cloud qua sync_outbox
- **QT:** mọi QT có đính kèm
- **Khóa chính:** `id`
- **Khóa ngoại:** `factory_id` → `factory.id`
- **Unique:** `(storage_key)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid |  | → factory |
| `storage_key` | text | có |  |
| `file_name` | text | có |  |
| `mime_type` | text | có |  |
| `size_bytes` | bigint | có |  |
| `sha256` | text | có |  |
| `kind` | text | có | giá trị: COA / ANH / HOP_DONG / PHU_LUC / BIEN_BAN / BAO_CAO / CHUNG_NHAN / KHAC |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `document_snapshot`

Bản lưu của phiếu / biên bản / hóa đơn tại thời điểm ký (màn Hồ sơ & biểu mẫu in — chốt 04/11): in lại luôn từ bản lưu này, không dựng lại từ dữ liệu hiện tại.

- **Nơi:** Nơi phát sinh là chủ — nơi tạo dòng là chủ; dòng tạo ở máy chủ nhà máy gộp lên cloud qua sync_outbox
- **QT:** Hồ sơ & biểu mẫu in; mọi QT có phiếu ký
- **Khóa chính:** `id`
- **Khóa ngoại:** `factory_id` → `factory.id` · `file_id` → `file_attachment.id` · `signed_by` → `app_user.id`
- **Unique:** `(source_table, record_id, signed_at)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid |  | nhà máy của chứng từ (trống = cloud) · → factory |
| `doc_type` | text | có | loại biểu mẫu, vd Phiếu nhập kho, Hóa đơn bán hàng |
| `source_table` | text | có | bảng của chứng từ |
| `record_id` | uuid | có |  |
| `doc_code` | text | có | số phiếu |
| `file_id` | uuid | có | PDF bản lưu lúc ký · → file_attachment |
| `signed_by` | uuid |  | → app_user |
| `signed_at` | timestamptz | có |  |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `document_print_log`

Mỗi lần in lại bản lưu (chốt 04/11): đóng dấu BẢN SAO, ghi người in, ngày in, số bản, lý do — số lần in đếm từ đây.

- **Nơi:** Nơi phát sinh là chủ — nơi tạo dòng là chủ; dòng tạo ở máy chủ nhà máy gộp lên cloud qua sync_outbox
- **QT:** Hồ sơ & biểu mẫu in
- **Khóa chính:** `id`
- **Khóa ngoại:** `snapshot_id` → `document_snapshot.id` · `printed_by` → `app_user.id`
- **Check:** `copies > 0` · `reason <> 'KHAC' or reason_note is not null`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `snapshot_id` | uuid | có | → document_snapshot |
| `printed_by` | uuid | có | → app_user |
| `printed_at` | timestamptz | có | mặc định now() |
| `copies` | integer | có | mặc định 1 |
| `reason` | text | có | giá trị: KHACH_YEU_CAU / THANH_TRA / BAN_CU_HONG / KHAC |
| `reason_note` | text |  |  |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `code_sequence`

Bộ đếm sinh mã: số phiếu (cloud), mã danh mục theo code_format (cloud — chỉ tăng, không dùng lại số của mã đã ngừng) và mã định danh bao HH / thùng (server nhà máy, có tiền tố nhà máy nên không trùng).

- **Nơi:** Nơi phát sinh là chủ — mỗi nơi giữ bộ đếm của mình (owner_site), không gộp
- **QT:** QT02 y2, QT14, QT20, QT21 và mọi chứng từ
- **Khóa chính:** `id`
- **Khóa ngoại:** `factory_id` → `factory.id`
- **Unique:** `(factory_id, code_type, period)` — null coi như bằng nhau
- **Check:** `owner_site = 'CLOUD' or factory_id is not null`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid |  | → factory |
| `code_type` | text | có | vd PN (phiếu nhập), BAO_HH, THUNG, ME; mã danh mục: MA_NVL_BOT, MA_SP, MA_TB_CAN_NM1…; mã chứng từ nhà máy (20/10 đợt 2): PN, PX, PC, PK, PH, YCQC, PKQC, CN, ML — owner_site NM, factory_id bắt buộc |
| `period` | text | có | yyyymm / yyyy / '-' nếu không theo kỳ |
| `last_value` | bigint | có | mặc định 0 |
| `owner_site` | text | có | giá trị: CLOUD / NM |

<sub>Cột chung: `— (nhật ký / hàng đợi có cột thời điểm + người riêng)`</sub>

### `code_format`

Định dạng mã từng loại: hệ thống tự sinh mã theo mẫu, số thứ tự tự tăng (bộ đếm ở code_sequence), không dùng lại số của mã đã ngừng; mã mới không có bước duyệt. Danh mục: NVL, SP, công thức, kho, khách hàng, NCC, mã nhân viên, lô (NVL nội bộ, BTP, TP) — thêm 04/11 theo màn Định dạng mã; bỏ thương hiệu / dòng / hạng / quy cách (04/11). Chứng từ cloud: đơn hàng, PO, nhu cầu mua, yêu cầu chuyển YCC-, hồ sơ pháp lý. Chứng từ sinh tại máy chủ nhà máy có tiền tố nhà máy: PN-{NM}-{yymm}-{4 số}, PX-, PC-, kiểm kho PK-, PH-, yêu cầu kiểm YC-{NM}-, QC-, CN-, ML-.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc
- **QT:** QT02 y2, ky; QT03 y2; Admin cấu hình (QT01)
- **Khóa chính:** `id`
- **Unique:** `(entity_type where status = 'DANG_DUNG')`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `entity_type` | text | có | giá trị: NVL / SP / CT / KHO / PHIEU_NHAP / PHIEU_XUAT / PHIEU_CHUYEN / PHIEU_KIEM_KHO / PHIEU_HUY / YEU_CAU_KIEM / PHIEU_KIEM / CHUNG_NHAN / MAU_LUU / KHACH_HANG / NCC / MA_NV / LO_NVL / LO_BTP / LO_TP / DON_HANG / PO / NHU_CAU_MUA / YEU_CAU_CHUYEN / HO_SO_PHAP_LY |
| `pattern` | text | có | mẫu, vd NVL-{nhom}-{so:4}; {so:N} = số thứ tự N chữ số |
| `tokens` | jsonb |  | đổi giá trị trong danh mục → chữ trong mã, vd nhom: BOT→BOT, PHU_GIA→PGA, BAO_BI→BBI |
| `counter_scope` | text |  | bộ đếm tính riêng theo phần nào của mã (vd nhom; loai + nha_may); null = 1 bộ đếm chung |
| `example` | text | có | mã mẫu hiện ở màn hình cấu hình |
| `status` | text | có | giá trị: DANG_DUNG / NGUNG_DUNG · mặc định 'DANG_DUNG' |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `catalog_retire_request`

Đề nghị ngừng dùng mã NVL / SP (QT02 nhánh dưới; bỏ 4 danh mục thương hiệu / dòng / hạng / quy cách 04/11 — lựa chọn của SP ngừng / xóa trực tiếp): bộ phận đề xuất gửi, hệ thống kiểm tham chiếu (tồn kho, phiếu đang mở, đơn mua đang mở, công thức hiệu lực; danh mục SP: còn SP ĐANG DÙNG), trưởng của bên đề xuất duyệt (sửa 28/10: Mua hàng → Trưởng BP Mua hàng, Kho → Thủ kho trưởng, QC → QC trưởng; hiện trong Việc cần làm) → mã NGỪNG DÙNG. Kế hoạch tự ngừng không qua duyệt (QT02 tk): dòng lập thẳng ở NGUNG_TRUC_TIEP, mã NGỪNG DÙNG ngay — vẫn kiểm tham chiếu, giữ người + lý do làm dấu vết. Người đề xuất rút được khi đang chờ duyệt (DA_RUT — chỉ người tạo, check). Kho không qua đề nghị: Admin làm trực tiếp.

- **Nơi:** Chỉ cloud — chỉ cloud
- **QT:** QT02 s2, y3, d3, t3, tk, tg, tr, d4, y4
- **Khóa chính:** `id`
- **Khóa ngoại:** `approved_by` → `app_user.id`
- **Check:** `approved_by is null or approved_by <> created_by` · `status <> 'DA_DUYET' or approved_by is not null` · `status <> 'TU_CHOI' or reject_reason is not null` · `status <> 'DA_RUT' or updated_by is not distinct from created_by` · `(department = 'KE_HOACH') = (status = 'NGUNG_TRUC_TIEP')` · `status <> 'NGUNG_TRUC_TIEP' or approved_by is null`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `entity_table` | text | có | bảng danh mục · giá trị: material / product |
| `record_id` | uuid | có | dòng danh mục xin ngừng |
| `department` | text | có | bộ phận đề xuất (Mua hàng / Kế hoạch / Kho / QC) — quyết người duyệt: MUA_HANG → Trưởng BP Mua hàng, KHO → Thủ kho trưởng, QC → QC trưởng; KE_HOACH tự ngừng (28/10) · giá trị: MUA_HANG / KE_HOACH / KHO / QC |
| `reason` | text | có |  |
| `reference_check` | jsonb |  | kết quả kiểm tham chiếu lúc gửi (y3): tồn kho, phiếu đang mở, đơn mua đang mở, công thức hiệu lực; danh mục SP: SP ĐANG DÙNG tham chiếu |
| `status` | text | có | NGUNG_TRUC_TIEP: Kế hoạch tự ngừng, không qua duyệt (28/10) · giá trị: CHO_DUYET / DA_DUYET / TU_CHOI / DA_RUT / NGUNG_TRUC_TIEP · mặc định 'CHO_DUYET' |
| `approved_by` | uuid |  | trưởng bên đề xuất (d4): Trưởng BP Mua hàng / Thủ kho trưởng / QC trưởng theo department (sửa 28/10) · → app_user |
| `approved_at` | timestamptz |  |  |
| `reject_reason` | text |  |  |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `sync_policy`

Nhóm đồng bộ từng bảng (thêm 20/10 đợt 2 — quyết định 34): ai là chủ, chiều đồng bộ, cột nhà máy dùng để xác định chủ dòng, cột dẫn xuất (do cloud chiếu từ dữ liệu nơi kia). Nạp sẵn từ mô hình bảng (cột Nơi của mục 10) bằng mes-powder-gen-du-lieu.py; trigger chặn ghi sai nơi và trigger ghi hàng đợi gửi lên đọc bảng này. Sửa 20/10 đợt 3: thêm masked_columns — cột cloud chủ nhưng không sao xuống nhà máy (bộ sao xuống bỏ đi qua hàm sync_down_row).

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud ghi (nạp khi triển khai), sao xuống mọi máy chủ nhà máy
- **QT:** QT19 (đồng bộ); nạp khi triển khai
- **Khóa chính:** `table_name`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `table_name` | text | có | tên bảng |
| `owner_group` | text | có | CLOUD: cloud chủ, sao xuống phần nhà máy cần; CLOUD_ONLY: chỉ cloud; NM: máy chủ nhà máy của dòng làm chủ, sao lên; NM_ONLY: chỉ máy chủ nhà máy; NOI_PHAT_SINH: nơi tạo dòng là chủ, gộp lên cloud · giá trị: CLOUD / CLOUD_ONLY / NM / NM_ONLY / NOI_PHAT_SINH |
| `factory_column` | text |  | cột xác định nhà máy chủ của dòng (thường factory_id); trống = theo dòng cha |
| `derived_columns` | text[] | có | cột dẫn xuất: cloud chiếu từ dữ liệu nơi kia (vd SL đã nhận trên phiếu chuyển của nhà máy xuất); người dùng không sửa tay · mặc định '{}' |
| `masked_columns` | text[] | có | cột không sao xuống máy chủ nhà máy (bản sao nhà máy để trống) — tiền, liên hệ, công nợ của khách / đơn (quyết định 38) · mặc định '{}' |
| `note` | text |  |  |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>


## 2 · Bán hàng — 17 bảng

### `customer`

Khách hàng. Hạn mức luôn vĩnh viễn (không có cột hạn mức tạm, không có ngày hết hạn). Cờ tạm khóa do nợ quá hạn chỉ chặn đơn Mua chịu. Bỏ trạng thái "mất" (24/10).

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc; không sao xuống nhà máy: company_code, tax_code, contact_name, contact_title, phone, email, contact_address, bank_account, default_payment_method, credit_limit, is_credit_blocked, credit_blocked_at, bank_name, bank_account_name, default_payment_channel, default_credit_days, default_deposit_pct, invoice_email (quyết định 38)
- **QT:** tạo / sửa QT05 t2; hạn mức QT06 y0, v3; cờ tạm khóa QT10 ya, y3 (tự động)
- **Khóa chính:** `id`
- **Unique:** `(code)` · `(tax_code where tax_code is not null)`
- **Check:** `credit_limit is null or credit_limit >= 0` · `is_credit_blocked = (credit_blocked_at is not null)` · `default_deposit_pct is null or default_deposit_pct between 0 and 100` · `default_credit_days is null or default_credit_days >= 0`
- **Bắt buộc ở cloud:** cột `phone`, `is_credit_blocked` bắt buộc khi ghi ở cloud / công cụ nạp; bản sao ở máy chủ nhà máy để trống (trg_masked_required — quyết định 38)

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `code` | text | có |  |
| `company_name` | text | có |  |
| `company_code` | text |  | không sao xuống nhà máy |
| `tax_code` | text |  | không sao xuống nhà máy |
| `contact_name` | text |  | không sao xuống nhà máy |
| `contact_title` | text |  | chức vụ · không sao xuống nhà máy |
| `phone` | text |  | bắt buộc ở cloud (trg_masked_required) · không sao xuống nhà máy |
| `email` | text |  | không sao xuống nhà máy |
| `contact_address` | text |  | không sao xuống nhà máy |
| `delivery_address` | text |  |  |
| `bank_account` | text |  | số tài khoản của khách · không sao xuống nhà máy |
| `bank_name` | text |  | ngân hàng · không sao xuống nhà máy |
| `bank_account_name` | text |  | chủ tài khoản · không sao xuống nhà máy |
| `default_payment_method` | text |  | giá trị: TRA_DU / COC_TRA_NOT / MUA_CHIU · không sao xuống nhà máy |
| `default_payment_channel` | text |  | phương thức thanh toán mặc định: tiền mặt / chuyển khoản / TM-CK · giá trị: TIEN_MAT / CHUYEN_KHOAN / TM_CK · không sao xuống nhà máy |
| `default_credit_days` | integer |  | số ngày nợ mặc định (Mua chịu) · không sao xuống nhà máy |
| `default_deposit_pct` | numeric(5,2) |  | tỷ lệ cọc mặc định (Cọc + trả nốt) · không sao xuống nhà máy |
| `invoice_email` | text |  | email nhận hóa đơn · không sao xuống nhà máy |
| `credit_limit` | numeric(18,2) |  | null = chưa có hạn mức · không sao xuống nhà máy |
| `is_credit_blocked` | boolean |  | cờ "tạm khóa do nợ quá hạn" — hệ thống tự bật / tắt (QT10 ya, y3) · bắt buộc ở cloud (trg_masked_required) · mặc định false · không sao xuống nhà máy |
| `credit_blocked_at` | timestamptz |  | không sao xuống nhà máy |
| `status` | text | có | Đang hoạt động / Tạm dừng giao dịch / Ngừng hoạt động (theo mockup 04/11) · giá trị: HOAT_DONG / TAM_DUNG / NGUNG_DUNG · mặc định 'HOAT_DONG' |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `customer_contact_log`

Các lần Sales liên hệ khách nhắc nợ (QT10 k3). Bỏ liên hệ khi giao (24/10 — giao hàng chỉ ghi nhận).

- **Nơi:** Chỉ cloud — chỉ cloud
- **QT:** QT10 k3
- **Khóa chính:** `id`
- **Khóa ngoại:** `customer_id` → `customer.id` · `sales_order_id` → `sales_order.id` · `payment_schedule_id` → `payment_schedule.id`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `customer_id` | uuid | có | → customer |
| `sales_order_id` | uuid |  | → sales_order |
| `payment_schedule_id` | uuid |  | → payment_schedule |
| `purpose` | text | có | giá trị: GIAO_HANG / NHAC_NO / THU_HOI |
| `contacted_at` | timestamptz | có |  |
| `result` | text | có | giá trị: LIEN_HE_DUOC / KHONG_LIEN_HE_DUOC |
| `note` | text |  |  |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `credit_limit_request`

Đề xuất hạn mức ban đầu / yêu cầu tăng hạn mức, gắn phiên bản đơn. Cờ "đã xin tăng" của 1 phiên bản = có dòng ở đây cho phiên bản đó (sửa đơn tạo phiên bản mới nên cờ tự về chưa).

- **Nơi:** Chỉ cloud — chỉ cloud
- **QT:** QT06 t4, t4d, v1, vd1
- **Khóa chính:** `id`
- **Khóa ngoại:** `customer_id` → `customer.id` · `sales_order_version_id` → `sales_order_version.id` · `decided_by` → `app_user.id`
- **Check:** `decided_by is null or decided_by <> created_by` · `status <> 'DA_DUYET' or approved_limit is not null`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `customer_id` | uuid | có | → customer |
| `sales_order_version_id` | uuid | có | → sales_order_version |
| `request_kind` | text | có | giá trị: BAN_DAU / TANG |
| `order_value` | numeric(18,2) | có |  |
| `current_limit` | numeric(18,2) |  |  |
| `requested_limit` | numeric(18,2) |  |  |
| `reason` | text |  |  |
| `status` | text | có | giá trị: CHO_DUYET / DA_DUYET / TU_CHOI · mặc định 'CHO_DUYET' |
| `approved_limit` | numeric(18,2) |  |  |
| `decided_by` | uuid |  | GĐ hoặc KTT (một người là đủ) · → app_user |
| `decided_at` | timestamptz |  |  |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `sales_order`

Đầu đơn (phần không đổi theo phiên bản): khách, nhà máy SX / giao, Sales, trạng thái, số phiên bản hiện tại. Không xóa đơn: hủy = trạng thái DA_HUY. Sửa 04/11: Sales hủy thẳng đơn ở Chờ ký HĐ / Chờ thu tiền, không cần duyệt; từ Đã chốt trở đi hủy qua Chờ duyệt hủy → Đang hủy.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc; cột status do cloud chiếu từ dữ liệu nhà máy; không sao xuống nhà máy: refund_amount, retained_amount (quyết định 38)
- **QT:** tạo QT05; đổi trạng thái QT06, QT07, QT08, QT09, QT10
- **Khóa chính:** `id`
- **Khóa ngoại:** `customer_id` → `customer.id` · `sales_user_id` → `app_user.id` · `cancelled_by` → `app_user.id` · `cancel_approved_by` → `app_user.id`
- **Unique:** `(code)`
- **Check:** `status <> 'DA_HUY' or cancel_reason is not null`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `code` | text | có |  |
| `customer_id` | uuid | có | → customer |
| `sales_user_id` | uuid | có | → app_user |
| `order_date` | date | có |  |
| `delivery_address` | text |  | địa chỉ giao của đơn (mặc định từ khách) |
| `current_version_no` | integer | có | mặc định 1 |
| `status` | text | có | theo mockup (04/11): thêm Chờ kiểm công nợ, Đang sản xuất, Chờ duyệt hủy, Đang hủy · giá trị: NHAP / CHO_KIEM_CONG_NO / CHO_XU_LY_NO / CHO_DUYET_HAN_MUC / CHO_KHACH / CHO_KY_HD / CHO_THU_TIEN / DA_CHOT / DANG_SAN_XUAT / SAN_SANG_GIAO / DANG_GIAO / GIAO_MOT_PHAN / DA_GIAO / CHO_DUYET_HUY / DANG_HUY / TU_CHOI / DA_HUY · mặc định 'NHAP' |
| `status_changed_at` | timestamptz | có | mốc tính "chờ quá 3 / 7 ngày" · mặc định now() |
| `cancel_reason` | text |  |  |
| `cancelled_at` | timestamptz |  |  |
| `cancelled_by` | uuid |  | người hủy — Sales hủy thẳng ở Chờ ký HĐ / Chờ thu tiền (04/11) · → app_user |
| `refund_amount` | numeric(18,2) |  | số hoàn khi hủy (QT07) · không sao xuống nhà máy |
| `retained_amount` | numeric(18,2) |  | phần giữ lại · không sao xuống nhà máy |
| `cancel_approved_by` | uuid |  | GĐ hoặc KTT duyệt hủy (đơn từ Đã chốt trở đi, qua Chờ duyệt hủy); hủy thẳng ở Chờ ký HĐ / Chờ thu tiền không cần (04/11) · → app_user |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `sales_order_version`

Phiên bản đơn: điều khoản thương mại + HĐ / phụ lục. Sửa đơn đã chốt → thêm phiên bản mới; dòng cũ không bao giờ sửa.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc; không sao xuống nhà máy: payment_method, deposit_pct, credit_days, total_before_vat, vat_amount, total_amount, contract_file_id, payment_channel, deposit_amount (quyết định 38)
- **QT:** QT05 (phiên bản 1), QT08 m4 (phiên bản sau)
- **Khóa chính:** `id`
- **Khóa ngoại:** `sales_order_id` → `sales_order.id` · `contract_file_id` → `file_attachment.id`
- **Unique:** `(sales_order_id, version_no)` · `(sales_order_id where superseded_at is null)`
- **Check:** `deposit_pct between 0 and 100` · `payment_method <> 'MUA_CHIU' or credit_days is not null` · `version_no = 1 or change_reason is not null` · `deposit_amount is null or deposit_amount >= 0` · `vat_pct is null or vat_pct between 0 and 100`
- **Bắt buộc ở cloud:** cột `payment_method`, `deposit_pct`, `total_before_vat`, `vat_amount`, `total_amount` bắt buộc khi ghi ở cloud / công cụ nạp; bản sao ở máy chủ nhà máy để trống (trg_masked_required — quyết định 38)

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `sales_order_id` | uuid | có | → sales_order |
| `version_no` | integer | có |  |
| `payment_method` | text |  | bắt buộc ở cloud (trg_masked_required); KHONG_THU: đơn đổi lô thu hồi (04/11) · giá trị: TRA_DU / COC_TRA_NOT / MUA_CHIU / KHONG_THU · không sao xuống nhà máy |
| `deposit_pct` | numeric(5,2) |  | bắt buộc ở cloud (trg_masked_required) · mặc định 0 · không sao xuống nhà máy |
| `credit_days` | integer |  | số ngày nợ (Mua chịu) · không sao xuống nhà máy |
| `payment_channel` | text |  | phương thức thanh toán: tiền mặt / chuyển khoản / TM-CK (04/11) · giá trị: TIEN_MAT / CHUYEN_KHOAN / TM_CK · không sao xuống nhà máy |
| `deposit_amount` | numeric(18,2) |  | tiền cọc bằng số tiền (mockup nhập số tiền; % cọc tính ra) · không sao xuống nhà máy |
| `vat_pct` | numeric(5,2) |  | VAT ở đầu đơn (mockup) — dòng đơn chép theo |
| `delivery_date` | date |  | ngày giao ở đầu đơn (mockup) — dòng đơn chép theo |
| `total_before_vat` | numeric(18,2) |  | bắt buộc ở cloud (trg_masked_required) · không sao xuống nhà máy |
| `vat_amount` | numeric(18,2) |  | bắt buộc ở cloud (trg_masked_required) · không sao xuống nhà máy |
| `total_amount` | numeric(18,2) |  | bắt buộc ở cloud (trg_masked_required) · không sao xuống nhà máy |
| `contract_file_id` | uuid |  | HĐ (bản 1) / phụ lục (bản sau) · → file_attachment · không sao xuống nhà máy |
| `signed_at` | timestamptz |  |  |
| `change_reason` | text |  |  |
| `superseded_at` | timestamptz |  |  |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `sales_order_line`

Dòng hàng thuộc 1 phiên bản đơn.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc; không sao xuống nhà máy: unit_price, vat_rate (quyết định 38)
- **QT:** QT05 t3, QT08 m4
- **Khóa chính:** `id`
- **Khóa ngoại:** `version_id` → `sales_order_version.id` · `product_id` → `product.id` · `uom_code` → `uom.code`
- **Unique:** `(version_id, line_no)`
- **Check:** `qty > 0 and unit_price >= 0`
- **Bắt buộc ở cloud:** cột `unit_price`, `vat_rate` bắt buộc khi ghi ở cloud / công cụ nạp; bản sao ở máy chủ nhà máy để trống (trg_masked_required — quyết định 38)

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `version_id` | uuid | có | → sales_order_version |
| `line_no` | integer | có |  |
| `product_id` | uuid | có | → product |
| `pack_spec` | text | có | quy cách (lon / bao) |
| `qty` | numeric(14,3) | có |  |
| `uom_code` | text | có | → uom |
| `unit_price` | numeric(18,2) |  | bắt buộc ở cloud (trg_masked_required) · không sao xuống nhà máy |
| `vat_rate` | numeric(5,2) |  | bắt buộc ở cloud (trg_masked_required) · không sao xuống nhà máy |
| `requested_delivery_date` | date |  | ngày giao dự kiến — Sales sửa trực tiếp, ghi nhật ký (24/10) |
| `delivery_method` | text |  |  |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `sales_order_lot`

Lô gắn đơn: lô TP sinh từ lệnh SX của đơn — xuất bán lấy đúng các lô này, không theo FEFO.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc
- **QT:** tạo khi lô BTP của lệnh SX có đơn được nhập kho (QT14 / QT21); đọc QT09, QT15
- **Khóa chính:** `id`
- **Khóa ngoại:** `sales_order_id` → `sales_order.id` · `lot_id` → `lot.id`
- **Unique:** `(sales_order_id, lot_id where released_at is null)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `sales_order_id` | uuid | có | → sales_order |
| `lot_id` | uuid | có | → lot |
| `qty` | numeric(14,3) | có |  |
| `released_at` | timestamptz |  | gỡ gắn (vd hủy đơn) |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `sales_order_status_log`

Nhật ký đổi trạng thái đơn.

- **Nơi:** Chỉ cloud — chỉ cloud
- **QT:** QT05–QT10
- **Khóa chính:** `id`
- **Khóa ngoại:** `sales_order_id` → `sales_order.id` · `actor_id` → `app_user.id`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `sales_order_id` | uuid | có | → sales_order |
| `version_no` | integer |  |  |
| `from_status` | text |  |  |
| `to_status` | text | có |  |
| `qt_code` | text | có |  |
| `actor_id` | uuid | có | → app_user |
| `occurred_at` | timestamptz | có | mặc định now() |
| `note` | text |  |  |

<sub>Cột chung: `— (nhật ký / hàng đợi có cột thời điểm + người riêng)`</sub>

### `payment_schedule`

Lịch thanh toán của phiên bản đơn: từng khoản (cọc / trả đủ / trả nốt / công nợ / chênh lệch), mốc đến hạn, số đã thu. Sinh khi có HĐ (QT05 yl), tính lại khi sửa đơn (QT08 — khoản cũ chuyển THAY_THE). Khoản trước giao tính theo giá trị từng yêu cầu xuất bán: mỗi yêu cầu tách từ khoản TRA_NOT gốc một khoản riêng (sales_issue_request_id) = giá trị phần xuất × (1 − % cọc), khoản gốc giảm tương ứng (dòng cũ THAY_THE, sinh dòng mới); hủy yêu cầu thì gộp lại; công nợ sau giao theo từng lần ghi nhận (hạn = ngày khách nhận + N ngày).

- **Nơi:** Chỉ cloud — chỉ cloud
- **QT:** QT05 yl, QT08 m4, QT09 yk; QT10 yk (paid_amount từ payment_allocation), g9 (kết quả nợ quá 90 ngày)
- **Khóa chính:** `id`
- **Khóa ngoại:** `sales_order_id` → `sales_order.id` · `version_id` → `sales_order_version.id` · `sales_issue_request_id` → `sales_issue_request.id` · `escalation_file_id` → `file_attachment.id`
- **Unique:** `(version_id, seq_no)`
- **Check:** `due_basis <> 'SAU_GIAO' or installment_type = 'CONG_NO'` · `escalation_note is null or installment_type = 'CONG_NO'`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `sales_order_id` | uuid | có | → sales_order |
| `version_id` | uuid | có | → sales_order_version |
| `seq_no` | integer | có |  |
| `installment_type` | text | có | giá trị: COC / TRA_DU / TRA_NOT / CONG_NO / CHENH_LECH |
| `due_basis` | text | có | giá trị: TRUOC_SX / TRUOC_GIAO / SAU_GIAO |
| `sales_issue_request_id` | uuid |  | khoản trước giao theo yêu cầu xuất bán (24/10) · → sales_issue_request |
| `due_date` | date |  |  |
| `amount` | numeric(18,2) | có | âm = phải hoàn |
| `paid_amount` | numeric(18,2) | có | mặc định 0 |
| `escalation_note` | text |  | kết quả xử lý công nợ quá 90 ngày: GĐ / KTT quyết bên ngoài, Kế toán ghi (QT10 g9) — hệ thống không xóa nợ |
| `escalation_file_id` | uuid |  | → file_attachment |
| `escalation_recorded_at` | timestamptz |  |  |
| `status` | text | có | giá trị: MO / DA_THU_DU / THAY_THE / HUY · mặc định 'MO' |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `sales_issue_request`

Yêu cầu xuất bán (sửa 24/10 — thay đợt giao): Sales lập từ đơn, chọn dòng / SL giao lần này (xuất từng phần, mỗi lần 1 yêu cầu → 1 phiếu xuất bán). Hệ thống kiểm khoản trước giao theo giá trị yêu cầu + cờ tạm khóa (đơn Mua chịu) lúc lập; thiếu thì CHO_THANH_TOAN (quá 14 ngày → QT07). Sao xuống máy chủ nhà máy; máy chủ nhà máy tự lập phiếu xuất bán (lô, SL theo yêu cầu) hoặc trả về BI_TRA_VE kèm lý do khi lô không còn đủ (24/10 đợt 3). Một yêu cầu chỉ lấy lô của nhà máy factory_id; hủy bắt buộc lý do. Không có địa chỉ, lịch, xe, hóa đơn — giao hàng chỉ ghi nhận (delivery_note theo phiếu xuất).

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc; cột status do cloud chiếu từ dữ liệu nhà máy; không sao xuống nhà máy: value_amount (quyết định 38)
- **QT:** QT09 t2, yk, y2, t9 (Đơn hàng › tab Giao hàng); QT15 lập phiếu xuất bán từ yêu cầu
- **Khóa chính:** `id`
- **Khóa ngoại:** `sales_order_id` → `sales_order.id` · `cancelled_by` → `app_user.id`
- **Unique:** `(code)` · `(sales_order_id, seq_no)`
- **Check:** `status <> 'BI_TRA_VE' or return_reason is not null` · `status <> 'DA_HUY' or (cancel_reason is not null and cancelled_by is not null and cancelled_at is not null)`
- **Trigger:** trg_sales_issue_line (dòng): lô phải gắn đơn (sales_order_lot còn hiệu lực), cùng nhà máy với yêu cầu, đúng SP của dòng đơn; tổng SL các yêu cầu chưa hủy của lô ≤ SL lô gắn đơn

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `code` | text | có |  |
| `sales_order_id` | uuid | có | → sales_order |
| `seq_no` | integer | có |  |
| `status` | text | có | CHO_XUAT: đã sao xuống, máy chủ nhà máy tự lập phiếu xuất bán; BI_TRA_VE: nhà máy không lập được phiếu (lô không còn đủ); DA_XUAT, DA_GHI_NHAN do cloud chiếu từ phiếu xuất và ghi nhận giao · giá trị: CHO_THANH_TOAN / CHO_XUAT / BI_TRA_VE / DA_XUAT / DA_GHI_NHAN / DA_HUY · mặc định 'CHO_THANH_TOAN' |
| `planned_date` | date |  | ngày giao dự kiến (chỉ ghi nhận) |
| `payment_wait_since` | timestamptz |  | bắt đầu chờ thu đủ / khách bị khóa (14 ngày → QT07) |
| `value_amount` | numeric(18,2) |  | giá trị phần yêu cầu xuất (tính khoản trước giao) · không sao xuống nhà máy |
| `return_reason` | text |  | lý do nhà máy trả về (BI_TRA_VE) |
| `cancel_reason` | text |  | bắt buộc khi hủy |
| `cancelled_by` | uuid |  | → app_user |
| `cancelled_at` | timestamptz |  |  |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `sales_issue_request_line`

Dòng đơn, lô TP (ĐẠT, của đơn) và SL yêu cầu xuất lần này.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc
- **QT:** QT09 t2
- **Khóa chính:** `id`
- **Khóa ngoại:** `request_id` → `sales_issue_request.id` · `sales_order_line_id` → `sales_order_line.id` · `lot_id` → `lot.id` · `uom_code` → `uom.code`
- **Unique:** `(request_id, sales_order_line_id, lot_id)`
- **Check:** `qty > 0`
- **Trigger:** trg_sales_issue_line — xem sales_issue_request

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `request_id` | uuid | có | → sales_issue_request |
| `sales_order_line_id` | uuid | có | → sales_order_line |
| `lot_id` | uuid | có | → lot |
| `qty` | numeric(14,3) | có |  |
| `uom_code` | text | có | → uom |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `delivery_note`

Ghi nhận giao (biên bản giao nhận) theo phiếu xuất bán: Sales ghi ngày khách nhận, người ký, ảnh biên bản (sửa 24/10 — 1 phiếu xuất = 1 ghi nhận, không còn đợt giao). Hạn công nợ = ngày nhận + N ngày.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc
- **QT:** QT09 t5 (Đơn hàng › tab Giao hàng — Sales ghi)
- **Khóa chính:** `id`
- **Khóa ngoại:** `goods_issue_id` → `goods_issue.id` · `photo_file_id` → `file_attachment.id`
- **Unique:** `(goods_issue_id)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `goods_issue_id` | uuid | có | phiếu xuất bán (issue_type BAN) · → goods_issue |
| `signed_by_name` | text |  |  |
| `signed_at` | timestamptz | có | ngày giờ khách nhận / ký |
| `photo_file_id` | uuid |  | → file_attachment |
| `note` | text |  |  |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `delivery_note_line`

Theo lô của phiếu xuất: SL đã xuất, SL khách nhận, SL không nhận + lý do (phần không nhận → nhập kho hàng khách trả). Mắt xích cuối "phiếu xuất → khách" của chuỗi truy xuất.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc
- **QT:** QT09 t5, r4
- **Khóa chính:** `id`
- **Khóa ngoại:** `delivery_note_id` → `delivery_note.id` · `lot_id` → `lot.id` · `uom_code` → `uom.code`
- **Unique:** `(delivery_note_id, lot_id)`
- **Check:** `delivered_qty = accepted_qty + returned_qty` · `returned_qty = 0 or return_reason is not null` · `returned_qty = 0 or customer_takes_rest is not null`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `delivery_note_id` | uuid | có | → delivery_note |
| `lot_id` | uuid | có | → lot |
| `delivered_qty` | numeric(14,3) | có |  |
| `accepted_qty` | numeric(14,3) | có |  |
| `returned_qty` | numeric(14,3) | có | mặc định 0 |
| `return_reason` | text |  | giá trị: TU_CHOI / HU / THIEU |
| `customer_takes_rest` | boolean |  | khách nhận thiếu: còn lấy phần không nhận (giao lần sau) hay không (giảm SL đơn) — bắt buộc khi có SL không nhận (04/11) |
| `uom_code` | text | có | → uom |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `sales_order_invoice`

Hóa đơn bán hàng (sửa 04/11): Kế toán lập trên MES, in A4 (bản thể hiện của hóa đơn điện tử), hóa đơn gắn phiếu xuất bán; phát hành qua nhà cung cấp hóa đơn điện tử. Một đơn nhiều hóa đơn. Tổng quan Giám đốc có việc "Lập hóa đơn" cho lần giao chưa có hóa đơn.

- **Nơi:** Chỉ cloud — chỉ cloud
- **QT:** QT10 t1 (Đơn hàng › tab Giao hàng; Tổng quan Giám đốc › Lập hóa đơn)
- **Khóa chính:** `id`
- **Khóa ngoại:** `sales_order_id` → `sales_order.id` · `goods_issue_id` → `goods_issue.id` · `invoice_file_id` → `file_attachment.id`
- **Unique:** `(sales_order_id, invoice_no)`
- **Check:** `status <> 'DA_PHAT_HANH' or (invoice_no is not null and invoice_date is not null)` · `total_amount is null or total_amount >= 0`
- **Trigger (04/11):** phiếu xuất phải là phiếu BAN đã xuất (hoặc xuất một phần) của đúng đơn (trg_sales_order_invoice)

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `sales_order_id` | uuid | có | → sales_order |
| `goods_issue_id` | uuid | có | phiếu xuất bán của hóa đơn (04/11) · → goods_issue |
| `invoice_no` | text |  | số hóa đơn — có khi phát hành |
| `invoice_date` | date |  |  |
| `invoice_series` | text |  | ký hiệu hóa đơn |
| `tax_authority_code` | text |  | mã của cơ quan thuế |
| `lookup_code` | text |  | mã tra cứu hóa đơn |
| `total_amount` | numeric(18,2) |  | tổng tiền thanh toán |
| `status` | text | có | giá trị: NHAP / DA_PHAT_HANH / DA_HUY · mặc định 'NHAP' |
| `invoice_file_id` | uuid |  | file hóa đơn · → file_attachment |
| `note` | text |  |  |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `payment_voucher`

Bản ghi nhận thu / chi (sửa 19/10): mỗi lần Kế toán ghi nhận tiền về của khách, hoàn tiền cho khách hoặc đã trả NCC — số tiền, ngày, CK / tiền mặt, ảnh chứng từ. Chỉ ghi nhận: không duyệt, không hạch toán, hệ thống không tự sinh. Tiền về / hoàn của khách cấn vào khoản trong lịch thanh toán qua payment_allocation; trả NCC giảm khoản phải trả qua ap_entry. Màn Sổ thu chi liệt kê bảng này. Nhập sai thì hủy kèm lý do (không xóa).

- **Nơi:** Chỉ cloud — chỉ cloud
- **QT:** QT10 k2, h1; QT12 t6, t8; QT26 t3 (hoàn tiền thu hồi)
- **Khóa chính:** `id`
- **Khóa ngoại:** `customer_id` → `customer.id` · `supplier_id` → `supplier.id` · `sales_order_id` → `sales_order.id` · `purchase_order_id` → `purchase_order.id` · `doc_file_id` → `file_attachment.id`
- **Unique:** `(code)`
- **Check:** `(customer_id is null) <> (supplier_id is null)` · `amount > 0` · `(voucher_type = 'THU') = (purpose = 'TIEN_VE')` · `(purpose = 'TRA_NCC') = (supplier_id is not null)` · `status <> 'DA_HUY' or (cancel_reason is not null and cancelled_at is not null)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `code` | text | có |  |
| `voucher_type` | text | có | giá trị: THU / CHI |
| `purpose` | text | có | TIEN_VE: tiền khách trả (cọc, trả đủ, trả nốt, chênh lệch, nợ quá hạn, công nợ — khoản cụ thể ở payment_allocation) · giá trị: TIEN_VE / HOAN_KHACH / TRA_NCC |
| `customer_id` | uuid |  | → customer |
| `supplier_id` | uuid |  | → supplier |
| `sales_order_id` | uuid |  | đơn liên quan, nếu tiền chỉ cho 1 đơn · → sales_order |
| `purchase_order_id` | uuid |  | → purchase_order |
| `amount` | numeric(18,2) | có | số tiền |
| `paid_on` | date | có | ngày tiền về / ngày chi |
| `method` | text | có | giá trị: CK / TIEN_MAT |
| `doc_file_id` | uuid | có | ảnh chứng từ (bắt buộc) · → file_attachment |
| `status` | text | có | DA_HUY: nhập sai, Kế toán hủy kèm lý do · giá trị: DA_GHI_NHAN / DA_HUY · mặc định 'DA_GHI_NHAN' |
| `cancel_reason` | text |  |  |
| `cancelled_at` | timestamptz |  |  |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `payment_allocation`

Cấn số tiền ghi nhận vào khoản (sửa 19/10): 1 lần ghi nhận tiền về / hoàn tiền cấn được vào nhiều khoản trong lịch thanh toán (cọc, trả đủ, trả nốt, chênh lệch, công nợ). Hệ thống tạo khi Kế toán ghi nhận; tổng cấn không vượt số tiền ghi nhận (trigger). Cấn vào khoản công nợ thì ghi thêm ar_entry THU. Thứ tự cấn khi khách trả gộp: xem câu hỏi.

- **Nơi:** Chỉ cloud — chỉ cloud
- **QT:** QT10 yk, h1
- **Khóa chính:** `id`
- **Khóa ngoại:** `voucher_id` → `payment_voucher.id` · `payment_schedule_id` → `payment_schedule.id`
- **Unique:** `(voucher_id, payment_schedule_id)`
- **Check:** `amount > 0`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `voucher_id` | uuid | có | → payment_voucher |
| `payment_schedule_id` | uuid | có | → payment_schedule |
| `amount` | numeric(18,2) | có | số tiền cấn vào khoản |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `ar_entry`

Sổ công nợ phải thu: phát sinh theo phần khách đã nhận (mỗi lần ghi nhận giao) (Mua chịu), tiền về cấn vào công nợ, cấn trừ cọc, điều chỉnh (vd sửa đơn). Không có xóa nợ (bỏ 19/10): nợ quá 90 ngày GĐ / KTT quyết bên ngoài, Kế toán ghi kết quả ở payment_schedule. Dư nợ, nợ quá hạn và cờ tạm khóa khách tính tự động từ đây (khi kiểm khóa dòng customer bằng SELECT … FOR UPDATE).

- **Nơi:** Chỉ cloud — chỉ cloud
- **QT:** QT10 y1, yk, ya; QT06 đọc
- **Khóa chính:** `id`
- **Khóa ngoại:** `customer_id` → `customer.id` · `sales_order_id` → `sales_order.id` · `delivery_note_id` → `delivery_note.id` · `voucher_id` → `payment_voucher.id` · `payment_schedule_id` → `payment_schedule.id`
- **Check:** `entry_type <> 'PHAT_SINH' or (amount > 0 and due_date is not null)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `customer_id` | uuid | có | → customer |
| `sales_order_id` | uuid |  | → sales_order |
| `delivery_note_id` | uuid |  | phát sinh công nợ theo lần ghi nhận khách nhận (24/10) · → delivery_note |
| `voucher_id` | uuid |  | → payment_voucher |
| `payment_schedule_id` | uuid |  | khoản công nợ tương ứng · → payment_schedule |
| `entry_type` | text | có | giá trị: PHAT_SINH / THU / CAN_TRU_COC / DIEU_CHINH |
| `amount` | numeric(18,2) | có | + tăng nợ / − giảm nợ |
| `due_date` | date |  |  |
| `occurred_at` | timestamptz | có | mặc định now() |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>


## 3 · Mua hàng — 13 bảng

### `supplier`

Hồ sơ NCC. Trạng thái CHO_DUYET / DA_DUYET / TU_CHOI / NGUNG_DUNG (dùng lại = duyệt lại như mới). Không đánh giá mẫu (bỏ 17/10): đủ hồ sơ pháp lý, chứng nhận còn hạn thì Trưởng BP Mua hàng duyệt. Không xóa, không chấm điểm.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc
- **QT:** QT11
- **Khóa chính:** `id`
- **Khóa ngoại:** `approved_by` → `app_user.id`
- **Unique:** `(code)` · `(tax_code)`
- **Check:** `status not in ('TU_CHOI','NGUNG_DUNG') or status_reason is not null` · `status <> 'DA_DUYET' or approved_by is not null` · `payment_terms is distinct from 'TRA_SAU' or payment_days is not null` · `payment_days is null or (payment_terms = 'TRA_SAU' and payment_days > 0)` · `(payment_terms = 'COC_TRA_NOT') = (deposit_pct is not null)` · `deposit_pct is null or (deposit_pct > 0 and deposit_pct < 100)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `code` | text | có |  |
| `name` | text | có |  |
| `tax_code` | text | có | MST, kiểm trùng |
| `address` | text |  |  |
| `contact_name` | text |  |  |
| `phone` | text |  |  |
| `email` | text |  |  |
| `payment_terms` | text |  | điều khoản mặc định của NCC: Trả trước / Cọc + trả nốt trước giao (31/10) / Trả sau N ngày · giá trị: TRA_TRUOC / COC_TRA_NOT / TRA_SAU |
| `payment_days` | integer |  | N ngày (chỉ khi TRA_SAU) |
| `deposit_pct` | numeric(5,2) |  | tỷ lệ cọc (chỉ COC_TRA_NOT) |
| `payment_method` | text |  | phương thức thanh toán · giá trị: TIEN_MAT / CHUYEN_KHOAN / TM_CK |
| `bank_name` | text |  |  |
| `bank_account_no` | text |  | số tài khoản |
| `bank_account_name` | text |  | chủ tài khoản |
| `status` | text | có | giá trị: CHO_DUYET / DA_DUYET / TU_CHOI / NGUNG_DUNG · mặc định 'CHO_DUYET' |
| `status_reason` | text |  | lý do từ chối / ngừng dùng |
| `approved_by` | uuid |  | Trưởng BP Mua hàng · → app_user |
| `approved_at` | timestamptz |  |  |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `supplier_status_log`

Nhật ký đổi trạng thái NCC kèm lý do.

- **Nơi:** Chỉ cloud — chỉ cloud
- **QT:** QT11 yr, yd, n2
- **Khóa chính:** `id`
- **Khóa ngoại:** `supplier_id` → `supplier.id` · `actor_id` → `app_user.id`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `supplier_id` | uuid | có | → supplier |
| `from_status` | text |  |  |
| `to_status` | text | có |  |
| `reason` | text |  |  |
| `actor_id` | uuid | có | → app_user |
| `occurred_at` | timestamptz | có | mặc định now() |

<sub>Cột chung: `— (nhật ký / hàng đợi có cột thời điểm + người riêng)`</sub>

### `supplier_certificate`

Chứng nhận của NCC (loại, số, hạn, file).

- **Nơi:** Chỉ cloud — chỉ cloud
- **QT:** QT11 y1
- **Khóa chính:** `id`
- **Khóa ngoại:** `supplier_id` → `supplier.id` · `file_id` → `file_attachment.id`
- **Check:** `cert_type = 'GIAY_PHEP_KINH_DOANH' or expiry_date is not null`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `supplier_id` | uuid | có | → supplier |
| `cert_type` | text | có | loại; GIAY_PHEP_KINH_DOANH không cần hạn |
| `cert_no` | text | có |  |
| `expiry_date` | date |  | bắt buộc, trừ giấy phép kinh doanh (04/11) |
| `file_id` | uuid |  | → file_attachment |
| `status` | text | có | giá trị: DANG_DUNG / NGUNG_DUNG · mặc định 'DANG_DUNG' |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `supplier_material`

NVL NCC được phép cung cấp. QT12 chỉ cho chọn NCC ĐÃ DUYỆT có dòng DUOC_PHEP cho NVL đó.

- **Nơi:** Chỉ cloud — chỉ cloud
- **QT:** QT11 y1 (đề xuất), yd (được phép)
- **Khóa chính:** `id`
- **Khóa ngoại:** `supplier_id` → `supplier.id` · `material_id` → `material.id`
- **Unique:** `(supplier_id, material_id)`
- **Check:** `lead_days is null or lead_days >= 0`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `supplier_id` | uuid | có | → supplier |
| `material_id` | uuid | có | → material |
| `status` | text | có | giá trị: DE_XUAT / DUOC_PHEP / KHONG_DUOC · mặc định 'DE_XUAT' |
| `lead_days` | integer |  | thời gian giao hàng của NCC này cho NVL này (ngày) — ghi đè material.purchase_lead_days (24/10 đợt 12) |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `supplier_history`

Lịch sử NCC để tra cứu, KHÔNG chấm điểm: trả hàng, giao trễ, giao thiếu. Hiện ở chi tiết NCC; giao trễ / giao thiếu ghi theo PO (04/11).

- **Nơi:** Chỉ cloud — chỉ cloud
- **QT:** QT12 y5, QT13 y2
- **Khóa chính:** `id`
- **Khóa ngoại:** `supplier_id` → `supplier.id` · `purchase_order_id` → `purchase_order.id` · `supplier_return_id` → `supplier_return.id`
- **Check:** `event_type not in ('GIAO_TRE','GIAO_THIEU') or purchase_order_id is not null` · `event_type <> 'GIAO_TRE' or days_late > 0` · `event_type <> 'GIAO_THIEU' or short_qty > 0`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `supplier_id` | uuid | có | → supplier |
| `event_type` | text | có | giá trị: TRA_HANG / GIAO_TRE / GIAO_THIEU |
| `purchase_order_id` | uuid |  | → purchase_order |
| `supplier_return_id` | uuid |  | → supplier_return |
| `days_late` | integer |  | GIAO_TRE: số ngày trễ so với ngày giao của PO |
| `short_qty` | numeric(14,3) |  | GIAO_THIEU: SL thiếu so với PO |
| `note` | text |  |  |
| `occurred_at` | timestamptz | có | mặc định now() |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `purchase_request`

Yêu cầu mua NVL (màn Đơn mua, tab Hàng đợi mua). Sửa 24/10 (đợt 12): NHU_CAU_SX do hệ thống tính và tự lập, gửi thẳng Mua hàng (không Kế hoạch xác nhận): từng NVL = tổng NVL các lệnh chưa xuất đủ (kể cả lệnh Chờ NVL) − tồn khả dụng − hàng đã đặt chưa về (PO mở) + phần thiếu so với tồn tối thiểu; tính lại khi tạo / sửa / hủy lệnh, khi nhập kho / PO đổi và mỗi đêm; mỗi NVL chỉ 1 dòng trong các yêu cầu NHU_CAU_SX đang MO của nhà máy (trigger) — lần tính sau cộng dồn / giảm SL dòng đó; lệnh hủy → dòng chưa lập PO tự giảm / hủy, đã có PO thì báo Mua hàng. LAP_TAY: Kế hoạch lập tay (lý do lập). Sửa 04/11 — bỏ báo giá: các dòng gộp thành Hàng đợi mua theo NVL × kho nhận; Mua hàng nhập đơn giá rồi lập PO (dòng cùng NCC × kho gộp 1 PO), hoặc trả về Kế hoạch kèm lý do.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc
- **QT:** QT12 t1 (Kế hoạch), Hàng đợi mua (Mua hàng)
- **Khóa chính:** `id`
- **Khóa ngoại:** `cancelled_by` → `app_user.id`
- **Unique:** `(code)`
- **Check:** `status <> 'HUY' or (cancel_reason is not null and cancelled_at is not null)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `code` | text | có |  |
| `source` | text | có | NHU_CAU_SX: hệ thống tính (lệnh SX + tồn tối thiểu); LAP_TAY: Kế hoạch lập (24/10 đợt 12 — thay LENH_SX / TON_TOI_THIEU) · giá trị: NHU_CAU_SX / LAP_TAY |
| `status` | text | có | MO → XONG khi mọi dòng đã lập PO / trả về / hủy; bỏ DANG_MUA (bỏ báo giá 04/11) · giá trị: MO / XONG / HUY · mặc định 'MO' |
| `note` | text |  | lý do lập (LAP_TAY) |
| `cancel_reason` | text |  |  |
| `cancelled_by` | uuid |  | → app_user |
| `cancelled_at` | timestamptz |  |  |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `purchase_request_line`

Dòng yêu cầu mua = 1 dòng của Hàng đợi mua: NVL × kho nhận, SL, ngày cần, NCC gợi ý, các lệnh liên quan; trạng thái theo Hàng đợi mua (04/11).

- **Nơi:** Chỉ cloud — chỉ cloud
- **QT:** QT12 t1
- **Khóa chính:** `id`
- **Khóa ngoại:** `request_id` → `purchase_request.id` · `material_id` → `material.id` · `warehouse_id` → `warehouse.id` · `uom_code` → `uom.code` · `suggested_supplier_id` → `supplier.id` · `po_line_id` → `purchase_order_line.id` · `returned_by` → `app_user.id`
- **Unique:** `(request_id, material_id, warehouse_id)`
- **Check:** `qty > 0` · `(status = 'DA_LAP_PO') = (po_line_id is not null)` · `status <> 'TRA_VE_KE_HOACH' or (return_reason is not null and returned_at is not null)` · `status <> 'HUY' or cancel_reason is not null`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `request_id` | uuid | có | → purchase_request |
| `material_id` | uuid | có | → material |
| `warehouse_id` | uuid | có | kho nhận (04/11) · → warehouse |
| `qty` | numeric(14,3) | có |  |
| `uom_code` | text | có | → uom |
| `needed_date` | date |  | ngày cần có hàng = ngày dự kiến chạy sớm nhất của các lệnh liên quan − thời gian giao hàng (NCC × NVL, mặc định theo NVL) |
| `suggested_supplier_id` | uuid |  | NCC gợi ý (đã duyệt, được phép cung cấp NVL) · → supplier |
| `production_order_ids` | uuid[] |  | các lệnh SX cần NVL này (truy ngược nhu cầu) |
| `status` | text | có | MO: trong Hàng đợi mua; TRA_VE_KE_HOACH: Mua hàng không mua được, Kế hoạch chọn cách bù khác · giá trị: MO / DA_LAP_PO / TRA_VE_KE_HOACH / HUY · mặc định 'MO' |
| `po_line_id` | uuid |  | dòng PO đã lập (PO hủy / từ chối / đóng phần còn lại thì gỡ, dòng về MO) · → purchase_order_line |
| `return_reason` | text |  |  |
| `returned_by` | uuid |  | → app_user |
| `returned_at` | timestamptz |  |  |
| `cancel_reason` | text |  |  |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `purchase_order`

PO (sửa 04/11 — bỏ báo giá): Mua hàng lập từ Hàng đợi mua (nhập đơn giá; dòng cùng NCC × kho nhận gộp 1 PO) → Chờ COA & HSD: gửi NCC 1 email yêu cầu COA và hạn dùng cho mọi NVL của PO, kiểm COA & HSD theo chỉ tiêu danh mục NVL (purchase_order_coa_result) — đạt thì Chờ chọn thanh toán, không đạt thì hủy PO, NVL quay lại Hàng đợi mua (30/10, 31/10) → chọn hình thức thanh toán → Chờ duyệt (Trưởng BP Mua hàng; GĐ duyệt thêm khi vượt ngưỡng) → Đã duyệt → gửi PO cho NCC qua email → nhận một phần / đủ; Đóng phần còn lại; Từ chối (lý do). PO đã duyệt chỉ Trưởng BP Mua hàng hủy được (ghi lý do).

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc; cột status do cloud chiếu từ dữ liệu nhà máy
- **QT:** QT12 t4 (lập từ Hàng đợi mua), kiểm COA & HSD, chọn thanh toán, d3, y3, y5; gửi COA / gửi PO qua email; hủy PO đã duyệt
- **Khóa chính:** `id`
- **Khóa ngoại:** `supplier_id` → `supplier.id` · `warehouse_id` → `warehouse.id` · `payment_chosen_by` → `app_user.id` · `coa_requested_by` → `app_user.id` · `coa_checked_by` → `app_user.id` · `approved_by` → `app_user.id` · `director_approved_by` → `app_user.id` · `cancelled_by` → `app_user.id` · `rejected_by` → `app_user.id` · `closed_by` → `app_user.id`
- **Unique:** `(code)`
- **Check:** `payment_terms <> 'TRA_SAU' or payment_days is not null` · `approved_by is null or approved_by <> created_by` · `status <> 'DA_HUY' or cancel_reason is not null` · `payment_days is null or (payment_terms = 'TRA_SAU' and payment_days > 0)` · `(payment_terms = 'COC_TRA_NOT') = (deposit_pct is not null)` · `deposit_pct is null or (deposit_pct > 0 and deposit_pct < 100)` · `status in ('CHO_COA_HSD','CHO_CHON_THANH_TOAN','DA_HUY') or payment_terms is not null` · `status in ('CHO_COA_HSD','DA_HUY') or coa_result = 'DAT'` · `(coa_result is null) = (coa_checked_at is null)` · `status <> 'TU_CHOI' or reject_reason is not null` · `status <> 'DA_DONG' or close_reason is not null`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `code` | text | có |  |
| `supplier_id` | uuid | có | → supplier |
| `warehouse_id` | uuid | có | kho nhận (04/11) · → warehouse |
| `status` | text | có | theo mockup (30/10, 31/10): bỏ Nháp, thêm Chờ COA & HSD, Chờ chọn thanh toán, Đã đóng, Từ chối · giá trị: CHO_COA_HSD / CHO_CHON_THANH_TOAN / CHO_DUYET / DA_DUYET / DA_GUI_NCC / NHAN_MOT_PHAN / DA_NHAN_DU / DA_DONG / TU_CHOI / DA_HUY · mặc định 'CHO_COA_HSD' |
| `payment_terms` | text |  | hình thức thanh toán, chọn ở bước Chờ chọn thanh toán (31/10): Trả trước / Cọc + trả nốt trước giao / Trả sau N ngày · giá trị: TRA_TRUOC / COC_TRA_NOT / TRA_SAU |
| `payment_days` | integer |  | N ngày (chỉ khi TRA_SAU) |
| `deposit_pct` | numeric(5,2) |  | % cọc (chỉ COC_TRA_NOT) |
| `payment_method` | text |  | phương thức thanh toán · giá trị: TIEN_MAT / CHUYEN_KHOAN / TM_CK |
| `payment_note` | text |  |  |
| `payment_chosen_by` | uuid |  | → app_user |
| `payment_chosen_at` | timestamptz |  |  |
| `coa_required` | boolean | có | mặc định true |
| `coa_requested_at` | timestamptz |  | lúc gửi email yêu cầu COA & HSD cho NCC |
| `coa_requested_by` | uuid |  | → app_user |
| `coa_request_email` | text |  | email NCC nhận yêu cầu |
| `coa_result` | text |  | kết quả kiểm COA & HSD của cả PO (đạt khi mọi NVL đạt) · giá trị: DAT / KHONG_DAT |
| `coa_checked_by` | uuid |  | → app_user |
| `coa_checked_at` | timestamptz |  |  |
| `total_amount` | numeric(18,2) | có |  |
| `approved_by` | uuid |  | Trưởng BP Mua hàng · → app_user |
| `approved_at` | timestamptz |  |  |
| `director_approved_by` | uuid |  | GĐ (vượt ngưỡng tham số) · → app_user |
| `director_approved_at` | timestamptz |  |  |
| `sent_at` | timestamptz |  |  |
| `cancelled_by` | uuid |  | hủy PO đã duyệt: Trưởng BP Mua hàng · → app_user |
| `cancelled_at` | timestamptz |  |  |
| `cancel_reason` | text |  |  |
| `rejected_by` | uuid |  | Trưởng BP Mua hàng / GĐ từ chối · → app_user |
| `rejected_at` | timestamptz |  |  |
| `reject_reason` | text |  |  |
| `closed_by` | uuid |  | Đóng phần còn lại · → app_user |
| `closed_at` | timestamptz |  |  |
| `close_reason` | text |  |  |
| `note` | text |  |  |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `purchase_order_line`

Dòng PO: NVL, SL, đơn giá (Mua hàng nhập ở Hàng đợi mua), SL đã nhận (nhận một phần); COA, NSX, HSD NCC gửi trước khi duyệt PO (04/11).

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc; cột received_qty do cloud chiếu từ dữ liệu nhà máy
- **QT:** QT12 t4, y5
- **Khóa chính:** `id`
- **Khóa ngoại:** `po_id` → `purchase_order.id` · `material_id` → `material.id` · `uom_code` → `uom.code` · `coa_file_id` → `file_attachment.id`
- **Unique:** `(po_id, line_no)`
- **Check:** `qty > 0 and received_qty >= 0` · `coa_exp_date is null or coa_mfg_date is null or coa_exp_date > coa_mfg_date`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `po_id` | uuid | có | → purchase_order |
| `line_no` | integer | có |  |
| `material_id` | uuid | có | → material |
| `qty` | numeric(14,3) | có |  |
| `uom_code` | text | có | → uom |
| `unit_price` | numeric(18,2) | có |  |
| `received_qty` | numeric(14,3) | có | mặc định 0 |
| `expected_date` | date |  |  |
| `coa_file_id` | uuid |  | COA NCC gửi cho NVL này · → file_attachment |
| `coa_mfg_date` | date |  | NSX của lô dự kiến giao (NCC báo) |
| `coa_exp_date` | date |  | HSD của lô dự kiến giao |
| `coa_passed` | boolean |  | kết quả kiểm COA & HSD của NVL |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `purchase_order_coa_result`

Kết quả kiểm COA & HSD của PO theo từng NVL × chỉ tiêu (30/10, 31/10): giá trị trên COA NCC gửi so với chỉ tiêu material_spec_item, chép lại giới hạn lúc kiểm.

- **Nơi:** Chỉ cloud — chỉ cloud
- **QT:** QT12 (Đơn mua › kiểm COA & HSD)
- **Khóa chính:** `id`
- **Khóa ngoại:** `po_line_id` → `purchase_order_line.id` · `spec_item_id` → `material_spec_item.id`
- **Unique:** `(po_line_id, spec_item_id)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `po_line_id` | uuid | có | → purchase_order_line |
| `spec_item_id` | uuid | có | → material_spec_item |
| `criterion_name` | text | có |  |
| `min_value` | numeric |  |  |
| `max_value` | numeric |  |  |
| `expected_text` | text |  |  |
| `coa_value_num` | numeric |  |  |
| `coa_value_text` | text |  |  |
| `passed` | boolean | có |  |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `ap_entry`

Sổ công nợ phải trả NCC: phát sinh theo PO (trả sau), đã trả (Kế toán ghi nhận, không duyệt), giảm trừ khi trả hàng. Màn Công nợ NCC tính khoản phải trả từ đây.

- **Nơi:** Chỉ cloud — chỉ cloud
- **QT:** QT12 y4, t6, t8; QT13 t4
- **Khóa chính:** `id`
- **Khóa ngoại:** `supplier_id` → `supplier.id` · `purchase_order_id` → `purchase_order.id` · `supplier_return_id` → `supplier_return.id` · `voucher_id` → `payment_voucher.id`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `supplier_id` | uuid | có | → supplier |
| `purchase_order_id` | uuid |  | → purchase_order |
| `supplier_return_id` | uuid |  | → supplier_return |
| `voucher_id` | uuid |  | → payment_voucher |
| `entry_type` | text | có | giá trị: PHAT_SINH / TRA_TIEN / GIAM_TRU_TRA_HANG / DIEU_CHINH |
| `amount` | numeric(18,2) | có |  |
| `due_date` | date |  |  |
| `occurred_at` | timestamptz | có | mặc định now() |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `supplier_return`

Phiếu trả hàng NCC (Mua hàng lập). Tranh chấp / kiểm nghiệm bên thứ 3 không có trong hệ thống (nhà máy tự xử lý ngoài) — chỉ ghi biên bản không thống nhất và kết quả cuối. Sửa 19/10 (đợt 2): Mua hàng gửi yêu cầu xuất trả; Thủ kho lập phiếu xuất loại TRA_NCC (chỉ khi phiếu trả đang CHO_KHO_XUAT_TRA); xuất xong → DA_XUAT_TRA. Sửa 24/10 (đợt 6): gửi yêu cầu xuất trả → CHO_DUYET_XUAT_TRA; Trưởng BP Mua hàng duyệt (export_approved_by, không phải người gửi) → CHO_KHO_XUAT_TRA, hoặc từ chối bắt buộc lý do → MO (trigger); phiếu xuất trả không còn Thủ kho trưởng duyệt. Giảm trừ do Kế toán ghi ở Công nợ NCC (ap_entry). Không trả vượt SL đã nhận của PO (cộng mọi phiếu trả của PO); PO trả trước không chọn GIAM_CONG_NO (trigger).

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc
- **QT:** QT13 t2, yq, d1, tx, dx, t3, y3, d2, yg, t4
- **Khóa chính:** `id`
- **Khóa ngoại:** `supplier_id` → `supplier.id` · `purchase_order_id` → `purchase_order.id` · `goods_receipt_id` → `goods_receipt.id` · `qc_inspection_id` → `qc_inspection.id` · `disagreement_file_id` → `file_attachment.id` · `goods_issue_id` → `goods_issue.id` · `disposal_id` → `disposal.id` · `replacement_receipt_id` → `goods_receipt.id` · `export_requested_by` → `app_user.id` · `export_approved_by` → `app_user.id`
- **Unique:** `(code)`
- **Check:** `outcome is null or outcome <> 'NHA_MAY_CHIU' or resolution is null` · `status not in ('CHO_DUYET_XUAT_TRA','CHO_KHO_XUAT_TRA','DA_XUAT_TRA') or export_requested_at is not null` · `status not in ('CHO_KHO_XUAT_TRA','DA_XUAT_TRA') or (export_approved_by is not null and export_approved_at is not null)` · `export_approved_by is null or export_approved_by is distinct from export_requested_by` · `status <> 'DA_XUAT_TRA' or goods_issue_id is not null`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `code` | text | có |  |
| `supplier_id` | uuid | có | → supplier |
| `purchase_order_id` | uuid | có | bắt buộc (đợt 3) — mọi phiếu trả gắn PO · → purchase_order |
| `goods_receipt_id` | uuid |  | → goods_receipt |
| `source` | text | có | hàng trả từ đâu: đã nhập kho / bao hư khi nhận / từ chối ở cửa kho (không có lô) · giá trị: DA_NHAP_KHO / BAO_HU_KHI_NHAN / TU_CHOI_CUA_KHO |
| `reason` | text | có | giá trị: HU / QC_KHONG_DAT |
| `photo_file_ids` | uuid[] | có | ảnh hàng lỗi, nhiều ảnh, không bắt buộc (04/11) · mặc định '{}' |
| `qc_inspection_id` | uuid |  | → qc_inspection |
| `supplier_accepted` | boolean |  |  |
| `disagreement_file_id` | uuid |  | biên bản không thống nhất · → file_attachment |
| `outcome` | text |  | giá trị: NCC_NHAN_LAI / NHA_MAY_CHIU |
| `resolution` | text |  | GIAM_CONG_NO không chọn được khi PO là TRA_TRUOC (trigger) · giá trị: DOI_1_1 / GIAM_CONG_NO |
| `goods_issue_id` | uuid |  | phiếu xuất trả NCC · → goods_issue |
| `disposal_id` | uuid |  | nhà máy chịu → hủy · → disposal |
| `replacement_receipt_id` | uuid |  | hàng đổi về · → goods_receipt |
| `ap_adjust_amount` | numeric(18,2) |  | số tiền giảm trừ khoản phải trả — Kế toán ghi ở Công nợ NCC |
| `status` | text | có | theo mockup (04/11): Chờ NCC xác nhận → NCC chấp nhận / Không thống nhất → Chờ duyệt xuất trả → Chờ kho xuất trả → Đã xuất trả → Chờ ký xác nhận → Hoàn tất; nhà máy chịu → Chuyển hủy · giá trị: CHO_NCC_XAC_NHAN / KHONG_THONG_NHAT / NCC_CHAP_NHAN / CHO_DUYET_XUAT_TRA / CHO_KHO_XUAT_TRA / DA_XUAT_TRA / CHO_KY_XAC_NHAN / HOAN_TAT / CHUYEN_HUY · mặc định 'CHO_NCC_XAC_NHAN' |
| `export_requested_by` | uuid |  | Mua hàng gửi yêu cầu xuất trả · → app_user |
| `export_requested_at` | timestamptz |  |  |
| `export_approved_by` | uuid |  | Trưởng BP Mua hàng duyệt / từ chối yêu cầu xuất trả (24/10 đợt 6) · → app_user |
| `export_approved_at` | timestamptz |  |  |
| `export_reject_reason` | text |  | lý do từ chối yêu cầu xuất trả (phiếu về NCC_CHAP_NHAN) |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `supplier_return_line`

Dòng trả: lô (null = hàng bị từ chối ở cửa kho, không có lô), số lô NCC, SL theo ĐVT gốc của NVL (trigger). Dòng có lô: tổng SL trả theo NVL của mọi phiếu trả cùng PO (kể cả phiếu nhà máy chịu) ≤ SL đã nhận của PO; SL trả của lô (cộng các phiếu chưa xuất xong) ≤ tồn hiện có của lô (trigger, đợt 3). Dòng không lô so với SL trong biên bản từ chối ở cửa kho (ứng dụng), không tính vào số đã nhận.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc
- **QT:** QT13 t2
- **Khóa chính:** `id`
- **Khóa ngoại:** `return_id` → `supplier_return.id` · `lot_id` → `lot.id` · `material_id` → `material.id` · `uom_code` → `uom.code`
- **Check:** `qty > 0` · `lot_id is null or supplier_lot_no is not null`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `return_id` | uuid | có | → supplier_return |
| `lot_id` | uuid |  | → lot |
| `material_id` | uuid | có | → material |
| `supplier_lot_no` | text |  | số lô NCC — bắt buộc với dòng có lô (04/11) |
| `qty` | numeric(14,3) | có |  |
| `uom_code` | text | có | → uom |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>


## 4 · Kho — 19 bảng

### `goods_receipt`

Phiếu nhập kho, 5 loại: MUA_HANG / TU_SX (BTP từ chiết rót, NVL dư) / CHUYEN_KHO / KHACH_TRA / THU_HOI. Thiếu chứng từ → từ chối ở cửa kho, không tạo lô. Sửa 24/10 (đợt 7): không lập tay, không duyệt — hệ thống tự sinh phiếu CHO_NHAN_HANG từ chứng từ gốc (BTP khi đóng thùng xong, NVL dư khi xả bột dư, khách trả, thu hồi, chuyển kho; NVL mua: quét PO là ra phiếu điền sẵn); quét bao / thùng đầu tiên → DANG_NHAN (trigger trên goods_receipt_scan); khớp SL dự kiến từng dòng và không có bao hư → DA_NHAP (cập nhật tồn); lệch / có bao hư → CHO_XAC_NHAN_LECH → Thủ kho trưởng (không phải người lập) xác nhận → DA_NHAP theo SL thực, hoặc yêu cầu đếm lại (bắt buộc lý do) → DANG_NHAN (trigger trg_goods_receipt). Bỏ CHO_DUYET / DA_DUYET / TU_CHOI, người duyệt, lý do từ chối.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT14 (tự sinh, nhận, xác nhận lệch dl / d4); QT16 y1, QT09 r4, QT21 t9, QT26 r2 gọi; Kế toán lưu hóa đơn, chứng từ QT14 t4 (04/11)
- **Khóa chính:** `id`
- **Khóa ngoại:** `warehouse_id` → `warehouse.id` · `supplier_id` → `supplier.id` · `purchase_order_id` → `purchase_order.id` · `supplier_invoice_file_id` → `file_attachment.id` · `invoice_recorded_by` → `app_user.id` · `production_order_id` → `production_order.id` · `delivery_note_id` → `delivery_note.id` · `recall_case_id` → `recall_case.id` · `stock_transfer_id` → `stock_transfer.id` · `doc_file_id` → `file_attachment.id` · `discrepancy_confirmed_by` → `app_user.id`
- **Unique:** `(code)`
- **Check:** `receipt_type <> 'MUA_HANG' or (supplier_id is not null and purchase_order_id is not null)` · `receipt_type <> 'TU_SX' or production_order_id is not null` · `receipt_type <> 'KHACH_TRA' or delivery_note_id is not null` · `receipt_type <> 'THU_HOI' or recall_case_id is not null` · `receipt_type <> 'CHUYEN_KHO' or stock_transfer_id is not null` · `discrepancy_confirmed_by is null or discrepancy_confirmed_by is distinct from created_by` · `discrepancy_confirmed_by is null or discrepancy_confirmed_at is not null` · `(invoice_recorded_by is null) = (invoice_recorded_at is null)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `code` | text | có |  |
| `receipt_type` | text | có | giá trị: MUA_HANG / TU_SX / CHUYEN_KHO / KHACH_TRA / THU_HOI |
| `warehouse_id` | uuid | có | → warehouse |
| `status` | text | có | CHO_NHAN_HANG: hệ thống tự sinh, chưa quét; DANG_NHAN: đang quét; CHO_XAC_NHAN_LECH: SL nhận khác dự kiến hoặc có bao hư; DA_NHAP: đã cập nhật tồn (24/10 đợt 7) · giá trị: CHO_NHAN_HANG / DANG_NHAN / CHO_XAC_NHAN_LECH / DA_NHAP / DA_HUY · mặc định 'CHO_NHAN_HANG' |
| `supplier_id` | uuid |  | → supplier |
| `purchase_order_id` | uuid |  | → purchase_order |
| `supplier_invoice_no` | text |  |  |
| `supplier_invoice_file_id` | uuid |  | tệp hóa đơn / chứng từ NCC — Kế toán lưu (QT14 t4) · → file_attachment |
| `hard_copy_received` | boolean | có | Kế toán đã nhận bản cứng hóa đơn / chứng từ · mặc định false |
| `invoice_recorded_by` | uuid |  | Kế toán lưu hóa đơn / chứng từ · → app_user |
| `invoice_recorded_at` | timestamptz |  |  |
| `production_order_id` | uuid |  | → production_order |
| `delivery_note_id` | uuid |  | KHACH_TRA: ghi nhận giao của phiếu xuất bán có phần khách không nhận · → delivery_note |
| `recall_case_id` | uuid |  | → recall_case |
| `stock_transfer_id` | uuid |  | → stock_transfer |
| `reason` | text |  |  |
| `doc_file_id` | uuid |  | → file_attachment |
| `discrepancy_confirmed_by` | uuid |  | Thủ kho trưởng xác nhận chênh lệch (không phải người lập phiếu) · → app_user |
| `discrepancy_confirmed_at` | timestamptz |  |  |
| `discrepancy_note` | text |  | ghi chú chênh lệch khi xác nhận |
| `recount_reason` | text |  | lý do Thủ kho trưởng yêu cầu đếm lại (phiếu về DANG_NHAN) |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `goods_receipt_line`

Dòng phiếu nhập = 1 mặt hàng × 1 lô. NVL mua: số lô NCC, NSX, HSD, COA và kết quả kiểm tự động COA / HSD (chép lại tỷ lệ HSD tối thiểu đã dùng).

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT14 l1, lv, k1
- **Khóa chính:** `id`
- **Khóa ngoại:** `receipt_id` → `goods_receipt.id` · `material_id` → `material.id` · `product_id` → `product.id` · `purchase_order_line_id` → `purchase_order_line.id` · `lot_id` → `lot.id` · `uom_code` → `uom.code` · `coa_file_id` → `file_attachment.id`
- **Unique:** `(receipt_id, line_no)`
- **Check:** `(material_id is null) <> (product_id is null)` · `received_qty >= 0`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `receipt_id` | uuid | có | → goods_receipt |
| `line_no` | integer | có |  |
| `material_id` | uuid |  | → material |
| `product_id` | uuid |  | → product |
| `purchase_order_line_id` | uuid |  | → purchase_order_line |
| `lot_id` | uuid |  | lô mới (NVL mua, NVL dư) hoặc lô cũ (khách trả, thu hồi, tìm lại) · → lot |
| `expected_qty` | numeric(14,3) |  |  |
| `received_qty` | numeric(14,3) | có | mặc định 0 |
| `uom_code` | text | có | → uom |
| `supplier_lot_no` | text |  |  |
| `mfg_date` | date |  |  |
| `exp_date` | date |  |  |
| `coa_file_id` | uuid |  | → file_attachment |
| `coa_check_result` | text |  | giá trị: DAT / KHONG_DAT / KHONG_YEU_CAU |
| `shelf_life_check_result` | text |  | giá trị: DAT / KHONG_DAT |
| `min_shelf_ratio_used` | numeric(4,3) |  |  |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `receipt_coa_result`

Kết quả kiểm COA tự động từng chỉ tiêu, chép lại giới hạn lúc kiểm.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT14 lv
- **Khóa chính:** `id`
- **Khóa ngoại:** `receipt_line_id` → `goods_receipt_line.id` · `spec_item_id` → `material_spec_item.id`
- **Unique:** `(receipt_line_id, spec_item_id)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `receipt_line_id` | uuid | có | → goods_receipt_line |
| `spec_item_id` | uuid | có | → material_spec_item |
| `criterion_name` | text | có |  |
| `min_value` | numeric |  |  |
| `max_value` | numeric |  |  |
| `expected_text` | text |  |  |
| `coa_value_num` | numeric |  |  |
| `coa_value_text` | text |  |  |
| `passed` | boolean | có |  |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `goods_receipt_scan`

Mỗi bao / thùng quét khi nhập (mã bao), kể cả khi nhận chuyển kho (tốt / hư). Sửa 24/10 đợt 9: bỏ quét mã ô khi cất hàng.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT14 k3–k5, vk, vd; QT16 t3
- **Khóa chính:** `id`
- **Khóa ngoại:** `receipt_line_id` → `goods_receipt_line.id` · `handling_unit_id` → `handling_unit.id`
- **Unique:** `(receipt_line_id, handling_unit_id)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `receipt_line_id` | uuid | có | → goods_receipt_line |
| `handling_unit_id` | uuid | có | → handling_unit |
| `qty` | numeric(12,3) | có |  |
| `unit_condition` | text | có | giá trị: TOT / HU · mặc định 'TOT' |
| `scanned_at` | timestamptz | có |  |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `goods_receipt_damage`

Bao / thùng hư khi kiểm ngoại quan lúc nhập và hướng xử lý: NVL mua → trả NCC; từ SX → NCR; khách trả / thu hồi → ghi biên bản, vẫn nhập.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT14 th, dh
- **Khóa chính:** `id`
- **Khóa ngoại:** `receipt_line_id` → `goods_receipt_line.id` · `photo_file_id` → `file_attachment.id` · `supplier_return_id` → `supplier_return.id` · `ncr_id` → `ncr.id`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `receipt_line_id` | uuid | có | → goods_receipt_line |
| `handling_unit_code` | text |  |  |
| `qty` | numeric(12,3) | có |  |
| `reason` | text | có |  |
| `photo_file_id` | uuid |  | → file_attachment |
| `disposition` | text | có | giá trị: TRA_NCC / NCR / GHI_BIEN_BAN |
| `supplier_return_id` | uuid |  | → supplier_return |
| `ncr_id` | uuid |  | NCR do Kế hoạch lập (QT14 nr) · → ncr |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `goods_issue`

Phiếu xuất kho, 4 loại: BAN / SAN_XUAT / CHUYEN_KHO / TRA_NCC. Hệ thống đề xuất lô → tạo phiếu, phiếu vào thẳng CHO_LAY_HANG → quét bao đầu tiên thì DANG_LAY_HANG → DA_XUAT / XUAT_MOT_PHAN (24/10 đợt 7: không ai duyệt nên bỏ tên DA_DUYET). Sửa 24/10 (đợt 6): bỏ bước Thủ kho trưởng duyệt phiếu xuất cho mọi loại — bỏ CHO_DUYET / TU_CHOI, bỏ approved_by / approved_at / reject_reason; duyệt nằm ở chứng từ gốc (yêu cầu xuất bán, lệnh SX, phiếu chuyển do Thủ kho trưởng xác nhận, yêu cầu xuất trả NCC do Trưởng BP Mua hàng duyệt) (trigger trg_goods_issue: lập ra phải là CHO_LAY_HANG; CHO_BEN_YEU_CAU / DA_XUAT / XUAT_MOT_PHAN chỉ từ DANG_LAY_HANG). Xuất bán: 1 yêu cầu xuất bán = 1 phiếu xuất, do máy chủ nhà máy tự lập (trigger trg_goods_issue_ban, 24/10 đợt 4); kết quả giao ghi theo phiếu (delivery_note, 24/10). Sửa 19/10 (đợt 2): thiếu hàng mà không có lô thay thế → CHO_BEN_YEU_CAU; chỉ bên yêu cầu (requested_by) chọn nhận phần đã lấy (→ XUAT_MOT_PHAN) hoặc hủy (→ DA_HUY) (trigger). TRA_NCC: Thủ kho lập theo yêu cầu xuất trả đã duyệt — chỉ khi phiếu trả NCC đang CHO_KHO_XUAT_TRA (trigger). Sửa 19/10 (đợt 4): SAN_XUAT chỉ lập từ kho loại DIEU_PHOI (trigger); sửa 24/10 đợt 10: máy chủ nhà máy tự lập khi lệnh phát sang khu SX (nơi nhận = khu của lệnh, kho điều phối chung), không qua CHO_BEN_YEU_CAU — thiếu thì tự XUAT_MOT_PHAN, phần thiếu thành đề nghị chuyển kho; lệnh hủy / kết thúc sớm thì ứng dụng hủy phiếu chưa lấy (trước: thủ kho kho điều phối lập theo lệnh), `requested_by` vẫn là Kế hoạch (bên quyết khi CHO_BEN_YEU_CAU); lô đề xuất FEFO trong tồn kho điều phối, trừ `material_reservation` của lệnh.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT15; gọi từ QT09 (yêu cầu xuất bán), QT13, QT16, QT19 / QT20
- **Khóa chính:** `id`
- **Khóa ngoại:** `warehouse_id` → `warehouse.id` · `requested_by` → `app_user.id` · `doc_file_id` → `file_attachment.id` · `sales_order_id` → `sales_order.id` · `sales_issue_request_id` → `sales_issue_request.id` · `production_order_id` → `production_order.id` · `stock_transfer_id` → `stock_transfer.id` · `supplier_return_id` → `supplier_return.id` · `requester_decision_by` → `app_user.id`
- **Unique:** `(code)` · `(sales_issue_request_id where sales_issue_request_id is not null)`
- **Check:** `issue_type <> 'BAN' or (sales_order_id is not null and sales_issue_request_id is not null)` · `issue_type <> 'SAN_XUAT' or production_order_id is not null` · `issue_type <> 'CHUYEN_KHO' or stock_transfer_id is not null` · `issue_type <> 'TRA_NCC' or supplier_return_id is not null` · `requester_decision_by is null or requester_decision_by = requested_by`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `code` | text | có |  |
| `issue_type` | text | có | giá trị: BAN / SAN_XUAT / CHUYEN_KHO / TRA_NCC |
| `warehouse_id` | uuid | có | → warehouse |
| `status` | text | có | CHO_LAY_HANG: vừa lập, chưa quét; DANG_LAY_HANG: tự chuyển khi quét bao / thùng đầu tiên (trigger trên goods_issue_scan); CHO_BEN_YEU_CAU: thiếu, không có lô thay thế — chờ bên yêu cầu chọn nhận phần đã lấy / hủy (24/10 đợt 7 — thay DA_DUYET) · giá trị: CHO_LAY_HANG / DANG_LAY_HANG / CHO_BEN_YEU_CAU / DA_XUAT / XUAT_MOT_PHAN / DA_HUY · mặc định 'CHO_LAY_HANG' |
| `requested_by` | uuid | có | bên yêu cầu (TRA_NCC: Mua hàng gửi yêu cầu xuất trả) · → app_user |
| `requested_date` | date | có |  |
| `reason` | text |  |  |
| `doc_file_id` | uuid |  | → file_attachment |
| `sales_order_id` | uuid |  | → sales_order |
| `sales_issue_request_id` | uuid |  | BAN: yêu cầu xuất bán từ đơn (1 yêu cầu = 1 phiếu) · → sales_issue_request |
| `production_order_id` | uuid |  | → production_order |
| `stock_transfer_id` | uuid |  | → stock_transfer |
| `supplier_return_id` | uuid |  | → supplier_return |
| `receiver_text` | text |  | đối tượng nhận (hiển thị) |
| `requester_decision_by` | uuid |  | bên yêu cầu quyết khi CHO_BEN_YEU_CAU (phải là requested_by) · → app_user |
| `requester_decision_at` | timestamptz |  |  |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `goods_issue_line`

Dòng phiếu xuất: lô đề xuất, SL đề xuất, SL thực xuất; dòng lô thay thế trỏ về dòng thiếu. Xuất SX trừ dần KG giữ chỗ của lệnh.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT15 y0, y1, y4, y5
- **Khóa chính:** `id`
- **Khóa ngoại:** `issue_id` → `goods_issue.id` · `material_id` → `material.id` · `product_id` → `product.id` · `proposed_lot_id` → `lot.id` · `uom_code` → `uom.code` · `substitute_for_line_id` → `goods_issue_line.id` · `reservation_id` → `material_reservation.id` · `sales_order_line_id` → `sales_order_line.id`
- **Unique:** `(issue_id, line_no)`
- **Check:** `(material_id is null) <> (product_id is null)` · `proposed_qty > 0 and actual_qty >= 0`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `issue_id` | uuid | có | → goods_issue |
| `line_no` | integer | có |  |
| `material_id` | uuid |  | → material |
| `product_id` | uuid |  | → product |
| `proposed_lot_id` | uuid | có | → lot |
| `proposed_qty` | numeric(14,3) | có |  |
| `actual_qty` | numeric(14,3) | có | mặc định 0 |
| `uom_code` | text | có | → uom |
| `substitute_for_line_id` | uuid |  | → goods_issue_line |
| `reservation_id` | uuid |  | → material_reservation |
| `sales_order_line_id` | uuid |  | → sales_order_line |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `goods_issue_scan`

Mỗi lần quét bao / thùng HỢP LỆ khi xuất — chính là liên kết bắt buộc "thùng → phiếu xuất", "bao NVL → phiếu xuất SX", "bao → phiếu chuyển". Không có dòng này thì không trừ tồn.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT15 y2, y5; QT16 g1
- **Khóa chính:** `id`
- **Khóa ngoại:** `issue_line_id` → `goods_issue_line.id` · `handling_unit_id` → `handling_unit.id` · `lot_id` → `lot.id` · `from_stock_line_id` → `stock_line.id`
- **Unique:** `(issue_line_id, handling_unit_id)` · `(source_event_id where source_event_id is not null)`
- **Check:** `qty > 0`
- **Ngưỡng hạn SX (24/10 đợt 9):** phiếu xuất SAN_XUAT chặn lô có hạn còn dưới production.min_shelf_days (trigger trg_goods_issue_scan_shelf)

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `issue_line_id` | uuid | có | → goods_issue_line |
| `handling_unit_id` | uuid | có | → handling_unit |
| `lot_id` | uuid | có | → lot |
| `from_stock_line_id` | uuid | có | → stock_line |
| `qty` | numeric(12,3) | có |  |
| `scanned_at` | timestamptz | có |  |
| `source_event_id` | uuid |  |  |
| `origin_site` | text | có | nơi tạo dòng · giá trị: CLOUD / NM |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `stock_discrepancy`

Lệch tồn phát sinh (sổ có, thực tế không / tồn âm / cân bằng lệch) → mở kiểm điểm (QT17).

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT15 y3, QT19 kf, QT25 t3
- **Khóa chính:** `id`
- **Khóa ngoại:** `lot_id` → `lot.id` · `warehouse_id` → `warehouse.id` · `stocktake_id` → `stocktake.id`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `source_qt` | text | có | giá trị: QT15 / QT19 / QT25 |
| `lot_id` | uuid | có | → lot |
| `warehouse_id` | uuid |  | → warehouse |
| `book_qty` | numeric(14,3) |  |  |
| `found_qty` | numeric(14,3) |  |  |
| `ref_table` | text |  |  |
| `ref_id` | uuid |  |  |
| `stocktake_id` | uuid |  | → stocktake |
| `status` | text | có | giá trị: MO / DANG_KIEM / DONG · mặc định 'MO' |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `stock_transfer`

Phiếu chuyển kho (cùng / khác nhà máy). Sửa 04/11 (chốt 30/10): nhà máy nhận gửi yêu cầu chuyển (transfer_request, YCC-); Kế hoạch nhà máy nguồn (nội bộ: Thủ kho điều phối) gom các yêu cầu theo kho xuất → kho nhận và lập phiếu — lập phiếu là chấp nhận (bỏ bước Thủ kho trưởng xác nhận / từ chối); thiếu NVL cho lệnh SX thì hệ thống tự lập phiếu từ kho tổng sang kho điều phối cấp NVL của khu (bỏ bước Kế hoạch gửi). Phiếu vào thẳng Chờ xuất → quét xuất: Đang chuyển (dòng tồn có stock_transfer_id — hàng nằm trên phiếu, không thuộc kho nào) → Đã nhận; có hàng hư: Chờ xử lý hàng hư; thiếu: Nhận thiếu (chờ tìm 7 ngày) → Chờ xác nhận thất lạc → Thất lạc (HỦY).

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command; cột dẫn xuất status, received_at do cloud chiếu từ phiếu nhập của nhà máy nhận (chuyển 2 nhà máy)
- **QT:** QT16 (yêu cầu chuyển, lập phiếu, xuất, nhận); QT19 (phiếu tự lập từ lệnh SX)
- **Khóa chính:** `id`
- **Khóa ngoại:** `to_factory_id` → `factory.id` · `from_warehouse_id` → `warehouse.id` · `to_warehouse_id` → `warehouse.id` · `source_order_id` → `production_order.id`
- **Unique:** `(code)` · `(source_order_id where auto_drafted and status = 'CHO_XUAT')` — mỗi lệnh 1 phiếu tự lập chưa xuất
- **Check:** `from_warehouse_id <> to_warehouse_id` · `not auto_drafted or source_order_id is not null`
- **Trigger (04/11):** phiếu tự lập chỉ từ kho TONG sang kho điều phối cấp NVL của khu của lệnh, cùng nhà máy; không lập cho lệnh đã hủy / hoàn thành; lệnh hủy / hoàn thành → phiếu tự lập còn CHO_XUAT của lệnh → DA_HUY; DANG_CHUYEN khi mọi dòng đã có lô; không quay về CHO_XUAT

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `code` | text | có |  |
| `to_factory_id` | uuid | có | → factory |
| `from_warehouse_id` | uuid | có | → warehouse |
| `to_warehouse_id` | uuid | có | → warehouse |
| `status` | text | có | theo mockup (04/11): lập phiếu là chấp nhận → CHO_XUAT; DANG_CHUYEN: đã quét xuất, hàng trên phiếu; bỏ Đề nghị / Chờ xác nhận / Từ chối / Nhận một phần / Đóng · giá trị: CHO_XUAT / DANG_CHUYEN / CHO_XU_LY_HANG_HU / NHAN_THIEU / CHO_XAC_NHAN_THAT_LAC / DA_NHAN / THAT_LAC / DA_HUY · mặc định 'CHO_XUAT' · cột dẫn xuất (cloud chiếu) |
| `source_order_id` | uuid |  | lệnh SX nguồn của đề nghị tự lập (đợt 4) · → production_order |
| `auto_drafted` | boolean | có | hệ thống tự lập từ lệnh SX (thiếu NVL ở kho điều phối cấp cho khu) — vào thẳng CHO_XUAT (04/11) · mặc định false |
| `vehicle_no` | text |  |  |
| `transporter_name` | text |  |  |
| `shipped_at` | timestamptz |  |  |
| `eta` | timestamptz |  | giờ đến dự kiến (lúc quét xuất) |
| `note` | text |  |  |
| `received_at` | timestamptz |  | cột dẫn xuất (cloud chiếu) |
| `compensation_amount` | numeric(18,2) |  | bồi thường thất lạc (xử lý ngoài, chỉ ghi số; không hạch toán) |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `stock_transfer_line`

Dòng chuyển: lô, SL yêu cầu / đã xuất / đã nhận / hư / thất lạc. Dòng gom từ yêu cầu chuyển (transfer_request_id) hoặc tự lập từ lệnh SX ghi NVL / SP + SL, chưa có lô — lô gán khi kho xuất lấy hàng theo FEFO (trigger: mọi dòng có `lot_id` trước khi phiếu sang DANG_CHUYEN; lô đúng NVL / SP của dòng).

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command; cột dẫn xuất received_qty, damaged_qty, lost_qty do cloud chiếu từ phiếu nhập của nhà máy nhận (chuyển 2 nhà máy)
- **QT:** QT16
- **Khóa chính:** `id`
- **Khóa ngoại:** `transfer_id` → `stock_transfer.id` · `lot_id` → `lot.id` · `material_id` → `material.id` · `product_id` → `product.id` · `transfer_request_id` → `transfer_request.id` · `uom_code` → `uom.code`
- **Unique:** `(transfer_id, line_no)`
- **Check:** `received_qty + damaged_qty + lost_qty <= shipped_qty` · `lot_id is not null or material_id is not null or product_id is not null`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `transfer_id` | uuid | có | → stock_transfer |
| `line_no` | integer | có |  |
| `lot_id` | uuid |  | bắt buộc từ lúc xuất; đề nghị tự lập để trống tới khi xuất (đợt 4) · → lot |
| `material_id` | uuid |  | NVL của dòng đề nghị theo KG (đợt 4) · → material |
| `product_id` | uuid |  | SP của dòng (yêu cầu chuyển BTP / TP chưa gán lô) · → product |
| `transfer_request_id` | uuid |  | yêu cầu chuyển được gom vào dòng (04/11) · → transfer_request |
| `requested_qty` | numeric(14,3) | có | đề nghị tự lập: KG thiếu = KG còn giữ của lệnh − tồn dùng được ở kho điều phối |
| `shipped_qty` | numeric(14,3) | có | mặc định 0 |
| `received_qty` | numeric(14,3) | có | mặc định 0 · cột dẫn xuất (cloud chiếu) |
| `damaged_qty` | numeric(14,3) | có | mặc định 0 · cột dẫn xuất (cloud chiếu) |
| `lost_qty` | numeric(14,3) | có | mặc định 0 · cột dẫn xuất (cloud chiếu) |
| `uom_code` | text | có | → uom |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `transfer_request`

Yêu cầu chuyển kho YCC- (chốt 30/10): nhà máy nhận gửi yêu cầu (Kế hoạch thêm tay, cân đối NVL, cách bù khi tạo lệnh), mỗi yêu cầu 1 NVL / SP × SL × ngày cần, kho xuất → kho nhận. Kế hoạch nhà máy nguồn gom các yêu cầu cùng kho xuất → kho nhận và lập phiếu chuyển (lập phiếu là chấp nhận) hoặc từ chối kèm lý do; giao một phần thì phần còn lại thành yêu cầu mới (parent_request_id).

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud ghi (Kế hoạch ở văn phòng); sao xuống máy chủ nhà máy nguồn (factory_id) để lập phiếu; status, stock_transfer_id do cloud chiếu từ phiếu chuyển nhà máy nguồn lập
- **QT:** QT16 (Kế hoạch gửi yêu cầu, Kế hoạch nhà máy nguồn / Thủ kho điều phối lập phiếu hoặc từ chối); QT19 (cách bù khi tạo lệnh)
- **Khóa chính:** `id`
- **Khóa ngoại:** `to_factory_id` → `factory.id` · `from_warehouse_id` → `warehouse.id` · `to_warehouse_id` → `warehouse.id` · `material_id` → `material.id` · `product_id` → `product.id` · `uom_code` → `uom.code` · `production_order_id` → `production_order.id` · `requested_by` → `app_user.id` · `stock_transfer_id` → `stock_transfer.id` · `parent_request_id` → `transfer_request.id`
- **Unique:** `(code)`
- **Check:** `(material_id is null) <> (product_id is null)` · `from_warehouse_id <> to_warehouse_id` · `qty > 0` · `(status = 'TREN_PHIEU') = (stock_transfer_id is not null)` · `status not in ('TU_CHOI','QUA_HAN_XUAT','DA_RUT','BI_TRA_VE') or status_reason is not null` · `source <> 'PHAN_CON_LAI' or parent_request_id is not null`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy nguồn (kho xuất) — nhà máy lập phiếu · → factory |
| `code` | text | có | YCC-{yymm}-{4 số} |
| `to_factory_id` | uuid | có | nhà máy nhận (bên gửi yêu cầu) · → factory |
| `from_warehouse_id` | uuid | có | → warehouse |
| `to_warehouse_id` | uuid | có | → warehouse |
| `material_id` | uuid |  | → material |
| `product_id` | uuid |  | → product |
| `qty` | numeric(14,3) | có |  |
| `uom_code` | text | có | → uom |
| `needed_date` | date | có |  |
| `production_order_id` | uuid |  | lệnh SX cần hàng (nếu có) · → production_order |
| `source` | text | có | giá trị: KE_HOACH_THEM / CAN_DOI_NVL / CACH_BU_TAO_LENH / PHAN_CON_LAI |
| `reason` | text | có | lý do / mục đích |
| `requested_by` | uuid | có | → app_user |
| `status` | text | có | giá trị: CHO_LAP_PHIEU / TREN_PHIEU / TU_CHOI / QUA_HAN_XUAT / DA_RUT / BI_TRA_VE · mặc định 'CHO_LAP_PHIEU' · cột dẫn xuất (cloud chiếu) |
| `status_reason` | text |  | lý do từ chối / rút / trả về / quá hạn |
| `stock_transfer_id` | uuid |  | phiếu chuyển đã lập · → stock_transfer · cột dẫn xuất (cloud chiếu) |
| `parent_request_id` | uuid |  | phần còn lại của yêu cầu nào · → transfer_request |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `transfer_discrepancy`

Biên bản chênh lệch khi nhận chuyển kho: THIẾU (giữ trên phiếu chuyển, hạn tìm), HƯ (chỉ các bao hư KHÓA tại kho nhận, bao lành giữ trạng thái; Thủ kho trưởng chọn gửi QC / hủy — bỏ khu hàng lỗi 24/10 đợt 9), THẤT LẠC (Kế hoạch lập biên bản, Thủ kho trưởng xác nhận → HỦY).

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT16 t4, g3, gx, gy
- **Khóa chính:** `id`
- **Khóa ngoại:** `transfer_line_id` → `stock_transfer_line.id` · `photo_file_id` → `file_attachment.id` · `resolved_by` → `app_user.id` · `confirmed_by` → `app_user.id` · `qc_request_id` → `qc_request.id` · `disposal_id` → `disposal.id`
- **Check:** `kind <> 'THIEU' or search_deadline is not null` · `confirmed_by is null or resolution = 'THAT_LAC'` · `confirmed_by is null or confirmed_by <> resolved_by`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `transfer_line_id` | uuid | có | → stock_transfer_line |
| `kind` | text | có | giá trị: THIEU / HU / THAT_LAC |
| `qty` | numeric(14,3) | có |  |
| `reason` | text |  |  |
| `photo_file_id` | uuid |  | → file_attachment |
| `search_deadline` | date |  | THIEU: mặc định +7 ngày |
| `resolution` | text |  | giá trị: TIM_THAY / THAT_LAC / GUI_QC / HUY |
| `resolved_by` | uuid |  | thất lạc: Kế hoạch lập biên bản (g3) · → app_user |
| `resolved_at` | timestamptz |  |  |
| `confirmed_by` | uuid |  | Thủ kho trưởng xác nhận biên bản thất lạc (QT16 gx) — có xác nhận mới thành HỦY · → app_user |
| `confirmed_at` | timestamptz |  |  |
| `responsible_person` | text |  | thất lạc |
| `qc_request_id` | uuid |  | → qc_request |
| `disposal_id` | uuid |  | → disposal |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `stocktake`

Phiếu kiểm kho: TOAN_KHO (định kỳ, cờ đang kiểm kê cả kho) / KIEM_DIEM (chỉ lô bị lệch trong kho).

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT17
- **Khóa chính:** `id`
- **Khóa ngoại:** `warehouse_id` → `warehouse.id` · `approved_by` → `app_user.id` · `report_file_id` → `file_attachment.id`
- **Unique:** `(code)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `code` | text | có |  |
| `stocktake_type` | text | có | giá trị: TOAN_KHO / KIEM_DIEM |
| `warehouse_id` | uuid | có | → warehouse |
| `trigger_source` | text | có | KHOI_TAO_LAI: khởi tạo lại máy chủ nhà máy — lô có biến động sau lần cloud xác nhận cuối (QT19 c3) · giá trị: DINH_KY / QT15 / QT19 / QT25 / KHOI_TAO_LAI / KHAC |
| `snapshot_at` | timestamptz |  | thời điểm chốt số liệu |
| `status` | text | có | KHOP: số đếm khớp sổ, không điều chỉnh (theo mockup 04/11 — thay DONG) · giá trị: DANG_KIEM / CHO_DUYET / DA_DIEU_CHINH / KHOP · mặc định 'DANG_KIEM' |
| `approved_by` | uuid |  | → app_user |
| `approved_at` | timestamptz |  |  |
| `report_file_id` | uuid |  | → file_attachment |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `stocktake_lock`

Cờ "đang kiểm kê" trên cả kho (lot_id null) hoặc trên 1 lô trong kho (sửa 24/10 đợt 9 — bỏ vị trí kệ). Chặn mọi nhập xuất trong phạm vi; KHÔNG đổi trạng thái lô; kiểm xong chỉ gỡ cờ.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT17 y1, p1, y3, p5
- **Khóa chính:** `id`
- **Khóa ngoại:** `stocktake_id` → `stocktake.id` · `warehouse_id` → `warehouse.id` · `lot_id` → `lot.id`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `stocktake_id` | uuid | có | → stocktake |
| `warehouse_id` | uuid | có | → warehouse |
| `lot_id` | uuid |  | → lot |
| `released_at` | timestamptz |  |  |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `stocktake_line`

Dòng đếm: số sổ (chốt), số đếm, đúng hàng, lô & HSD, tình trạng, lý do chênh lệch.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT17 t2, t3, p2, p6
- **Khóa chính:** `id`
- **Khóa ngoại:** `stocktake_id` → `stocktake.id` · `lot_id` → `lot.id` · `counted_by` → `app_user.id`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `stocktake_id` | uuid | có | → stocktake |
| `lot_id` | uuid |  | → lot |
| `book_qty` | numeric(14,3) | có |  |
| `counted_qty` | numeric(14,3) |  |  |
| `correct_item` | boolean |  |  |
| `lot_exp_ok` | boolean |  |  |
| `condition_note` | text |  |  |
| `diff_reason` | text |  |  |
| `counted_by` | uuid |  | → app_user |
| `counted_at` | timestamptz |  |  |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `stock_adjustment`

Điều chỉnh tồn sau kiểm kho (đã duyệt). Phần tăng (hủy nhầm, hàng tìm lại) vào KHÓA chờ QC.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT17 y2, p5
- **Khóa chính:** `id`
- **Khóa ngoại:** `stocktake_line_id` → `stocktake_line.id` · `stock_line_id` → `stock_line.id` · `new_lock_reason` → `lock_reason.code` · `approved_by` → `app_user.id`
- **Check:** `qty_delta <> 0` · `approved_by <> created_by` · `qty_delta < 0 or new_status = 'KHOA'`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `stocktake_line_id` | uuid | có | → stocktake_line |
| `stock_line_id` | uuid | có | → stock_line |
| `qty_delta` | numeric(14,3) | có |  |
| `new_status` | text |  | giá trị: CHO_KIEM / DAT / KHONG_DAT / KHOA |
| `new_lock_reason` | text |  | → lock_reason |
| `approved_by` | uuid | có | → app_user |
| `approved_at` | timestamptz | có |  |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `disposal`

Phiếu hủy. Tạo phiếu → tự KHÓA phần trên phiếu (lý do chờ hủy). Lô hết hạn và bột hỏng của mẻ hủy không được từ chối, chỉ dời ngày. Thủ kho trưởng từ chối → về trạng thái trước / gửi QC.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT18; gọi từ QT07, 13, 14, 16, 19, 20, 22, 23, 26
- **Khóa chính:** `id`
- **Khóa ngoại:** `warehouse_id` → `warehouse.id` · `confirmed_by` → `app_user.id` · `executed_by` → `app_user.id` · `report_file_id` → `file_attachment.id` · `recall_case_id` → `recall_case.id` · `sales_order_id` → `sales_order.id` · `supplier_return_id` → `supplier_return.id`
- **Unique:** `(code)`
- **Check:** `status <> 'TU_CHOI' or (reject_reason is not null and source not in ('HET_HAN','HUY_ME'))` · `confirmed_by is null or confirmed_by <> created_by`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `code` | text | có |  |
| `warehouse_id` | uuid | có | → warehouse |
| `source` | text | có | HUY_ME: bột hỏng của mẻ hủy, hệ thống tự tạo (QT20 ky); mẫu lưu không qua phiếu hủy (QC tự hủy, QT24) · giá trị: KIEM_TRA / HET_HAN / QC_KHONG_DAT / THU_HOI / HU_KHI_NHAN / NCR / HUY_DON / NHA_MAY_CHIU / HUY_ME / KHAC |
| `status` | text | có | giá trị: CHO_XAC_NHAN / TU_CHOI / DA_XAC_NHAN / DA_HUY · mặc định 'CHO_XAC_NHAN' |
| `planned_date` | date |  |  |
| `postponed_to` | date |  |  |
| `reject_reason` | text |  |  |
| `confirmed_by` | uuid |  | → app_user |
| `confirmed_at` | timestamptz |  |  |
| `executed_by` | uuid |  | → app_user |
| `executed_at` | timestamptz |  |  |
| `report_file_id` | uuid |  | biên bản hủy · → file_attachment |
| `destroyed_value` | numeric(18,2) |  | giá trị hàng hủy — Kế toán ghi (QT18 t5), chỉ ghi nhận, không hạch toán |
| `recall_case_id` | uuid |  | → recall_case |
| `sales_order_id` | uuid |  | → sales_order |
| `supplier_return_id` | uuid |  | → supplier_return |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `disposal_line`

Dòng hủy: phần lô bị hủy, trạng thái trước để trả về khi từ chối, SL thực hủy. Mẫu lưu hết hạn không qua đây (QC tự hủy ở retained_sample).

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT18 t2, y1
- **Khóa chính:** `id`
- **Khóa ngoại:** `disposal_id` → `disposal.id` · `lot_id` → `lot.id` · `stock_line_id` → `stock_line.id` · `prev_lock_reason` → `lock_reason.code`
- **Check:** `qty > 0`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `disposal_id` | uuid | có | → disposal |
| `lot_id` | uuid | có | → lot |
| `stock_line_id` | uuid | có | → stock_line |
| `qty` | numeric(14,3) | có |  |
| `prev_status` | text |  | giá trị: CHO_KIEM / DAT / KHONG_DAT / KHOA |
| `prev_lock_reason` | text |  | → lock_reason |
| `destroyed_qty` | numeric(14,3) |  |  |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>


## 5 · Sản xuất — 24 bảng

### `production_order`

Lệnh SX. Không tạo được ở server nhà máy. Lệnh đã phát giữ phiên bản công thức lúc phát. Sửa 19/10 (đợt 2): lệnh thuộc 1 khu (loại lệnh theo khu, KL mẻ ≤ mức tối đa của khu); 9 điều kiện tạo theo thứ tự (khu · đơn & khách · công thức · thời gian · NV tiếp thị · số mẻ & KL mẻ · tệp giấy tờ xuất xứ NVL · tồn NVL · dàn silo); phương án silo ở production_order_silo, chốt khi tạo (kiểm lúc COMMIT), kiểm lại khi phát. Mỗi khu một hàng đợi = thứ tự chạy ở nhà máy (queue_priority, lệnh MOI_TAO / CHO_PHAT; phát lệnh đầu hàng, lệnh Chờ phát giữ vị trí). Trạng thái MOI_TAO → CHO_PHAT (chỉ khi phát mà nhà máy không nhận) → DA_NHAN → DANG_CHAY → HOAN_THANH; DA_HUY (từ MOI_TAO / CHO_PHAT / DA_NHAN, bắt buộc lý do, tự giải phóng giữ chỗ). Không nháp, không xóa (trigger). Sửa 19/10 (đợt 3): chỉ sửa lệnh MOI_TAO; lệnh đã phát chỉ hủy — Chờ phát / Đã nhận cần nhà máy xác nhận chưa chạy mẻ; lệnh đang chạy chỉ kết thúc sớm (lý do, số mẻ thực tế, không có mẻ đang chạy dở) hoặc thêm mẻ bù; HOÀN THÀNH chỉ khi mọi nút silo của lệnh đã xả sạch (trigger). Sửa 24/10 (đợt 12): tồn NVL không chặn tạo lệnh — thiếu thì lệnh MOI_TAO không giữ chỗ (material_reserved_at null = Chờ NVL), không phát được (trigger); Kiểm tra lại đủ thì giữ chỗ, ghi material_reserved_at. Sửa 04/11: có lệnh sản xuất tồn kho (demand_kind TON_KHO, nhu cầu đơn không bắt buộc); lệnh BTP thêm 2 điều kiện: SP có bản công bố còn hiệu lực và quy cách có mẫu nhãn đã duyệt (trigger trên production_order_brand).

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud là chủ, CHỈ tạo trên cloud → sao xuống server nhà máy khi phát lệnh; trạng thái chạy / xong do sự kiện từ nhà máy cập nhật; cột status, nm_ack_at, started_at, finished_at, nm_cancel_confirmed_at, ended_early_at, actual_batch_count do cloud chiếu từ dữ liệu nhà máy
- **QT:** tạo QT19 t1, tb, ys, y1; sửa su (chỉ Mới tạo); hàng đợi q1; phát y2 (kiểm lại yx), CHỜ PHÁT kp, ĐÃ NHẬN y3; chạy y4; hủy hl / yh (QT07 h4, QT08 r2); kết thúc sớm kt; mẻ bù QT20 kb
- **Khóa chính:** `id`
- **Khóa ngoại:** `work_area_id` → `work_area.id` · `sales_order_id` → `sales_order.id` · `formula_version_id` → `formula_version.id` · `marketing_user_id` → `app_user.id` · `origin_docs_file_id` → `file_attachment.id` · `cancel_requested_by` → `app_user.id` · `ended_early_by` → `app_user.id`
- **Unique:** `(code)`
- **Check:** `planned_batch_count > 0 and batch_weight_kg > 0` · `status <> 'DA_HUY' or cancel_reason is not null` · `makeup_batch_count >= 0` · `queue_priority is null or queue_priority > 0` · `status not in ('MOI_TAO','CHO_PHAT') or queue_priority is not null` · `cancel_requested_at is null or cancel_reason is not null` · `nm_cancel_confirmed_at is null or cancel_requested_at is not null` · `ended_early_at is null or (status = 'HOAN_THANH' and early_end_reason is not null and actual_batch_count is not null)` · `demand_kind <> 'TON_KHO' or sales_order_id is null` · `nm_check_result is distinct from 'KHONG_DAT' or nm_check_fail_reason is not null` · `(nm_check_result is null) = (nm_checked_at is null)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `code` | text | có |  |
| `order_kind` | text | có | theo loại khu của work_area (trigger) · giá trị: HH / BTP |
| `work_area_id` | uuid | có | khu sản xuất (điều kiện 1); khu HH / BTP đang dùng, cùng nhà máy · → work_area |
| `demand_kind` | text | có | TON_KHO: lệnh sản xuất tồn kho, không theo đơn — không gắn đơn (chốt 04/11) · giá trị: THEO_DON / TON_KHO · mặc định 'THEO_DON' |
| `sales_order_id` | uuid |  | → sales_order |
| `sales_order_version_no` | integer |  |  |
| `formula_version_id` | uuid | có | phiên bản lúc phát; lệnh DANG_CHAY trỏ phiên bản không còn hiệu lực → hiện ở màn Công thức · → formula_version |
| `planned_batch_count` | integer | có |  |
| `makeup_batch_count` | integer | có | số mẻ bù vì mẻ hủy do sự cố (QT20 kb); tổng mẻ phải chạy = planned_batch_count + makeup_batch_count · mặc định 0 |
| `batch_weight_kg` | numeric(12,3) | có | ≤ work_area.max_batch_kg (trigger) |
| `order_received_at` | timestamptz |  | thời gian nhận đơn |
| `planned_finish_date` | date |  | dự kiến xong |
| `marketing_user_id` | uuid |  | NV tiếp thị · → app_user |
| `origin_docs_file_id` | uuid | có | giấy tờ xuất xứ NVL — 1 tệp đính kèm của lệnh, Kế hoạch tải lên khi tạo (bắt buộc); không kiểm chứng từ / COA theo từng lô · → file_attachment |
| `status` | text | có | MOI_TAO (đã giữ chỗ KG, trong hàng đợi) → CHO_PHAT (chỉ khi phát mà nhà máy không nhận) → DA_NHAN → DANG_CHAY → HOAN_THANH; DA_HUY. Chuyển sai thứ tự bị chặn (trigger) · giá trị: MOI_TAO / CHO_PHAT / DA_NHAN / DANG_CHAY / HOAN_THANH / DA_HUY · mặc định 'MOI_TAO' |
| `material_reserved_at` | timestamptz |  | lúc giữ chỗ NVL; null = lệnh Chờ NVL (tồn khả dụng chưa đủ khi tạo) — không phát được (trigger), Kế hoạch bấm Kiểm tra lại khi hàng về (24/10 đợt 12) |
| `queue_priority` | integer |  | thứ tự trong hàng đợi của khu = thứ tự chạy ở nhà máy (1 = đầu hàng) — bắt buộc khi MOI_TAO / CHO_PHAT (Chờ phát giữ vị trí); không trùng trong 1 khu (ràng buộc loại trừ, kiểm lúc COMMIT); chỉ phát lệnh không có lệnh Mới tạo / Chờ phát nào đứng trước (trigger) |
| `silo_plan_status` | text | có | CAN_XEP_LAI: silo trong phương án chuyển bảo trì / ngừng dùng khi lệnh còn Mới tạo → báo Kế hoạch, chặn phát tới khi xếp lại (trigger) · giá trị: DA_CHOT / CAN_XEP_LAI · mặc định 'DA_CHOT' |
| `dispatch_attempts` | integer | có | mặc định 0 |
| `last_dispatch_at` | timestamptz |  |  |
| `nm_ack_at` | timestamptz |  | server nhà máy xác nhận đã nhận |
| `nm_check_result` | text |  | máy chủ nhà máy tự kiểm khi nhận lệnh (thay bước Kế hoạch xác nhận cho lệnh xuống PC — 04/11) · giá trị: DAT / KHONG_DAT |
| `nm_check_fail_reason` | text |  | lý do không đạt |
| `nm_checked_at` | timestamptz |  |  |
| `started_at` | timestamptz |  |  |
| `finished_at` | timestamptz |  |  |
| `cancel_reason` | text |  |  |
| `cancel_requested_at` | timestamptz |  | Kế hoạch gửi hủy lệnh đã phát (Chờ phát / Đã nhận) — chờ nhà máy xác nhận |
| `cancel_requested_by` | uuid |  | → app_user |
| `nm_cancel_confirmed_at` | timestamptz |  | nhà máy xác nhận chưa chạy mẻ → mới ĐÃ HỦY được (trigger) |
| `ended_early_at` | timestamptz |  | kết thúc sớm lệnh đang chạy (QT19 kt) → HOÀN THÀNH |
| `ended_early_by` | uuid |  | → app_user |
| `early_end_reason` | text |  | lý do kết thúc sớm (bắt buộc) |
| `actual_batch_count` | integer |  | số mẻ thực tế khi kết thúc sớm |
| `created_site` | text | có | giá trị: CLOUD · mặc định 'CLOUD' |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `production_order_brand`

Kế hoạch nhãn hiệu của lệnh BTP, nhiều dòng: SP (nhãn hiệu), số lô in trên lon (nếu đã biết), số lon kế hoạch — lấy từ các dòng đơn có cùng công thức (SP phải dùng công thức của lệnh, chỉ lệnh BTP, chỉ sửa khi lệnh MOI_TAO — trigger); nạp vào máy chiết (QT21 yn). Sửa 04/11: mỗi dòng chọn quy cách của SP; lệnh BTP chỉ tạo khi SP có bản công bố và mẫu nhãn đã duyệt.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud chủ → nhà máy cùng lệnh
- **QT:** QT19 tb; QT21 yn
- **Khóa chính:** `id`
- **Khóa ngoại:** `production_order_id` → `production_order.id` · `product_id` → `product.id` · `product_pack_id` → `product_pack.id` · `sales_order_line_id` → `sales_order_line.id`
- **Unique:** `(production_order_id, product_id, printed_lot_no)` — null coi như bằng nhau
- **Check:** `planned_can_count > 0`
- **Trigger (04/11):** quy cách thuộc SP; SP có bản công bố (product_document CONG_BO) đang dùng, còn hạn; quy cách có mẫu nhãn hiện hành DA_DUYET (trg_production_order_brand_docs)

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `production_order_id` | uuid | có | → production_order |
| `product_id` | uuid | có | → product |
| `product_pack_id` | uuid | có | quy cách đóng gói của SP (04/11) · → product_pack |
| `sales_order_line_id` | uuid |  | dòng đơn nguồn (cùng công thức) · → sales_order_line |
| `printed_lot_no` | text |  | số lô in trên lon (nếu đã biết); số lô in khi chiết vẫn ⏸ ở filling_run |
| `planned_can_count` | integer | có |  |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `production_order_silo`

Phương án dàn silo của lệnh (thêm 19/10 đợt 2): mỗi NVL của công thức → 1 silo của khu. Hệ thống gợi ý theo gán cứng và sức chứa, Kế hoạch kéo thả chỉnh (is_adjusted); chốt khi tạo lệnh (đủ mọi NVL, kiểm lúc COMMIT), kiểm lại khi phát. Điều kiện (trigger): silo thuộc khu của lệnh, đang hoạt động, đúng gán cứng, NVL có trong công thức, KL / mẻ ≤ sức chứa (silo nạp nhiều mẻ, nạp bổ sung — sức chứa kiểm ở mỗi lần nạp, lot_link); 1 NVL – 1 silo, 1 silo – 1 NVL trong 1 lệnh ⇒ số NVL ≤ số silo đang hoạt động. Chỉ sửa khi lệnh MOI_TAO (đợt 3: lệnh đã phát không sửa).

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud chủ → server nhà máy cùng lệnh (PC xưởng mở silo theo phương án)
- **QT:** QT19 ys, tk, y1 (chốt), yx / xs (kiểm lại khi phát, xếp lại); QT20 g1, y1 (silo của bao)
- **Khóa chính:** `id`
- **Khóa ngoại:** `production_order_id` → `production_order.id` · `material_id` → `material.id` · `silo_equipment_id` → `equipment.id`
- **Unique:** `(production_order_id, material_id)` · `(production_order_id, silo_equipment_id)`
- **Check:** `kg_per_batch > 0`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `production_order_id` | uuid | có | → production_order |
| `material_id` | uuid | có | NVL của công thức (formula_item của phiên bản lệnh) · → material |
| `silo_equipment_id` | uuid | có | silo của khu (equipment loại SILO) · → equipment |
| `kg_per_batch` | numeric(12,3) | có | KL NVL này / mẻ — ≤ equipment.capacity_kg |
| `is_adjusted` | boolean | có | Kế hoạch kéo thả khác gợi ý của hệ thống · mặc định false |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `material_reservation`

Giữ chỗ NVL theo KG cho lệnh, KHÔNG gắn lô: KG = định mức × số mẻ; xuất SX trừ dần (issued_kg). Tồn dùng được cho SX = KG lô ĐẠT có hạn còn ≥ ngưỡng tối thiểu cho SX (production.min_shelf_days, mặc định 30 ngày — 24/10 đợt 9), đang ở kho (không tính hàng đang chuyển) − Σ(reserved − issued − released).

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc; cột issued_kg do cloud chiếu từ dữ liệu nhà máy
- **QT:** QT19 g1; QT15 y5; QT20 kb (giữ thêm cho mẻ bù); QT07 / QT08 / QT19 hl giải phóng (hủy lệnh → tự giải phóng, trigger)
- **Khóa chính:** `id`
- **Khóa ngoại:** `production_order_id` → `production_order.id` · `material_id` → `material.id`
- **Unique:** `(production_order_id, material_id)`
- **Check:** `reserved_kg > 0 and issued_kg >= 0 and released_kg >= 0 and released_kg <= reserved_kg` · `makeup_kg >= 0 and makeup_kg <= reserved_kg`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `production_order_id` | uuid | có | → production_order |
| `material_id` | uuid | có | → material |
| `reserved_kg` | numeric(14,3) | có |  |
| `makeup_kg` | numeric(14,3) | có | phần giữ thêm cho mẻ bù (đã gồm trong reserved_kg) · mặc định 0 |
| `issued_kg` | numeric(14,3) | có | mặc định 0 |
| `released_kg` | numeric(14,3) | có | mặc định 0 |
| `status` | text | có | giá trị: MO / DA_XUAT_DU / DA_GIAI_PHONG · mặc định 'MO' |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `production_batch`

Mẻ HH / BTP: ghi số phiên bản công thức, khu, thời gian, trạng thái. Mỗi mẻ có 1 lô mẻ (lot_kind = ME) làm nút trong chuỗi liên kết. Mốc thời gian + thiết bị là điểm nối dữ liệu cảm biến sau này. Tạo mẻ (Start) bị chặn khi silo trong phương án silo của lệnh không hoạt động (bảo trì / ngừng dùng — trigger, đợt 3).

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT20 t2 (tạo), y2 (đóng hồ sơ), g4 (sự cố), ky (hủy); QT21 (mẻ BTP chiết)
- **Khóa chính:** `id`
- **Khóa ngoại:** `production_order_id` → `production_order.id` · `formula_version_id` → `formula_version.id` · `work_area_id` → `work_area.id` · `batch_lot_id` → `lot.id`
- **Unique:** `(factory_id, batch_no)` · `(production_order_id, seq_in_order)` · `(batch_lot_id where batch_lot_id is not null)` · `(source_event_id where source_event_id is not null)`
- **Check:** `ended_at is null or ended_at >= started_at` · `status <> 'DA_HUY' or ended_at is not null`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `batch_no` | text | có |  |
| `production_order_id` | uuid | có | → production_order |
| `seq_in_order` | integer | có |  |
| `batch_kind` | text | có | giá trị: HH / BTP |
| `formula_version_id` | uuid | có | ghi số phiên bản · → formula_version |
| `work_area_id` | uuid | có | → work_area |
| `batch_lot_id` | uuid |  | lô mẻ (ME) · → lot |
| `started_at` | timestamptz | có |  |
| `ended_at` | timestamptz |  |  |
| `status` | text | có | DUNG_SU_CO: đang dừng chờ khắc phục; DA_HUY: Kế hoạch quyết hủy (batch_cancellation) · giá trị: DANG_CHAY / DUNG_SU_CO / HOAN_THANH / DA_HUY · mặc định 'DANG_CHAY' |
| `is_makeup` | boolean | có | mẻ bù cho mẻ đã hủy · mặc định false |
| `started_offline` | boolean | có | mặc định false |
| `source_event_id` | uuid |  |  |
| `origin_site` | text | có | nơi tạo dòng · giá trị: CLOUD / NM |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `batch_cancellation`

Hủy mẻ do sự cố không khắc phục được (QT20 hx → kh → ky → kr → kb): công nhân báo, Kế hoạch quyết hủy, ghi lý do và số kg bột bỏ. Lưu là trong 1 giao dịch: mẻ → ĐÃ HỦY; tạo lô bột hỏng (HONG) nối từ lô mẻ (RA_ME) để truy xuất và cân bằng khối lượng tính vào ô hủy; phần lô KHÓA lý do chờ hủy; tự tạo phiếu hủy (QT18); thêm 1 mẻ bù vào lệnh đang chạy và giữ thêm NVL theo KG. NVL đã đổ vào mẻ giữ nguyên liên kết DO_VAO_ME.

- **Nơi:** Cloud chủ, sao xuống nhà máy — Kế hoạch ghi trên cloud (cả khi nhà máy mất mạng) → lệnh HUY_ME (site_command) xuống máy chủ nhà máy; nhà máy áp khi mẻ còn DUNG_SU_CO, khác thì từ chối
- **QT:** QT20 hx, kh, ky, kr, kb
- **Khóa chính:** `id`
- **Khóa ngoại:** `batch_id` → `production_batch.id` · `production_order_id` → `production_order.id` · `downtime_id` → `batch_downtime.id` · `scrap_lot_id` → `lot.id` · `disposal_id` → `disposal.id` · `site_command_id` → `site_command.id` · `decided_by` → `app_user.id`
- **Unique:** `(batch_id)`
- **Check:** `discarded_kg >= 0` · `scrap_lot_id is null or disposal_id is not null`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `batch_id` | uuid | có | mẻ bị hủy · → production_batch |
| `production_order_id` | uuid | có | → production_order |
| `downtime_id` | uuid |  | sự cố gốc, nếu đã ghi · → batch_downtime |
| `reason` | text | có | sự cố gì, vì sao không khắc phục được |
| `discarded_kg` | numeric(12,3) | có | số kg bột bỏ |
| `scrap_lot_id` | uuid |  | lô bột hỏng (HONG), KHÓA chờ hủy · → lot |
| `disposal_id` | uuid |  | phiếu hủy hệ thống tự tạo (nguồn HUY_ME) · → disposal |
| `site_command_id` | uuid |  | lệnh HUY_ME gửi xuống nhà máy (Chờ gửi khi nhà máy mất mạng); nhà máy áp khi mẻ còn DUNG_SU_CO, khác thì TU_CHOI · → site_command |
| `makeup_batch` | boolean | có | thêm 1 mẻ bù vào lệnh (kb) · mặc định true |
| `makeup_reserved` | jsonb |  | KG NVL giữ thêm cho mẻ bù, theo từng NVL |
| `decided_by` | uuid | có | Kế hoạch (kh) · → app_user |
| `decided_at` | timestamptz | có |  |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `batch_operator`

Người vận hành mẻ (công nhân quét thẻ; chỉ thao tác mẻ của khu mình).

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT20, QT21
- **Khóa chính:** `id`
- **Khóa ngoại:** `batch_id` → `production_batch.id` · `user_id` → `app_user.id` · `work_area_id` → `work_area.id`
- **Unique:** `(batch_id, user_id, joined_at)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `batch_id` | uuid | có | → production_batch |
| `user_id` | uuid | có | → app_user |
| `work_area_id` | uuid | có | → work_area |
| `joined_at` | timestamptz | có |  |
| `left_at` | timestamptz |  |  |
| `origin_site` | text | có | nơi tạo dòng · giá trị: CLOUD / NM |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `batch_equipment_usage`

ĐIỂM NỐI IoT: thiết bị nào chạy cho mẻ nào, từ lúc nào đến lúc nào (thiết bị nạp khi triển khai). Dữ liệu cảm biến (chuỗi thời gian) sau này nối theo equipment.iot_source_ref + khoảng thời gian — không thiết kế bảng cảm biến ở đây.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT20, QT21
- **Khóa chính:** `id`
- **Khóa ngoại:** `batch_id` → `production_batch.id` · `equipment_id` → `equipment.id`
- **Check:** `ended_at is null or ended_at >= started_at`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `batch_id` | uuid | có | → production_batch |
| `equipment_id` | uuid | có | → equipment |
| `started_at` | timestamptz | có |  |
| `ended_at` | timestamptz |  |  |
| `origin_site` | text | có | nơi tạo dòng · giá trị: CLOUD / NM |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `silo_charge` · ⏸ có cột chờ quyết

Mỗi lần quét bao (NVL / HH) nạp silo của lệnh (đổi tên từ batch_material_scan 19/10 đợt 3 — bao không đổ thẳng vào mẻ nữa). Quét OK phải sinh 1 dòng lot_link NAP_SILO vào nút silo đang mở trong CÙNG giao dịch; không ghi được thì chặn, không mở silo. Silo phải đúng silo xếp cho NVL của bao trong phương án silo của lệnh (trigger).

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT20 t3, g2, g1, y1 (nạp silo, nạp bổ sung)
- **Khóa chính:** `id`
- **Khóa ngoại:** `production_order_id` → `production_order.id` · `handling_unit_id` → `handling_unit.id` · `lot_id` → `lot.id` · `silo_equipment_id` → `equipment.id` · `silo_lot_id` → `lot.id` · `lot_link_id` → `lot_link.id`
- **Unique:** `(source_event_id where source_event_id is not null)`
- **Check:** `scan_result <> 'OK' or (lot_link_id is not null and silo_lot_id is not null)`
- **Ngưỡng hạn SX (24/10 đợt 9):** quét OK chặn lô có hạn còn dưới production.min_shelf_days (trigger trg_silo_charge_shelf)

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `production_order_id` | uuid | có | lệnh đang nạp silo · → production_order |
| `handling_unit_id` | uuid | có | → handling_unit |
| `lot_id` | uuid | có | → lot |
| `qty_kg` | numeric(12,3) | có |  |
| `scan_result` | text | có | giá trị: OK / CHAN |
| `block_reason` | text |  | ⏸ CHỜ QUYẾT — chặn bao sai: danh sách lý do, cách trả bao |
| `silo_equipment_id` | uuid | có | silo xếp cho NVL của bao trong phương án silo của lệnh (production_order_silo) — phải đúng phương án (trigger) · → equipment |
| `silo_lot_id` | uuid |  | nút silo (lot SILO) đang mở — bắt buộc khi quét OK · → lot |
| `lot_link_id` | uuid |  | → lot_link |
| `scanned_at` | timestamptz | có |  |
| `source_event_id` | uuid |  |  |
| `origin_site` | text | có | nơi tạo dòng · giá trị: CLOUD / NM |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `filling_run` · ⏸ có cột chờ quyết

Lượt chiết rót theo nhãn hiệu trong 1 mẻ BTP: quét lon đầu → gắn mẻ → nhãn hiệu → lô; bộ đếm lon đạt / loại; thùng gắn lô theo bộ đếm.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT21 yq, ct, ye
- **Khóa chính:** `id`
- **Khóa ngoại:** `batch_id` → `production_batch.id` · `product_id` → `product.id` · `lot_id` → `lot.id`
- **Unique:** `(batch_id, product_id)` · `(source_event_id where source_event_id is not null)`
- **Check:** `good_can_count >= 0 and rejected_can_count >= 0`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `batch_id` | uuid | có | → production_batch |
| `product_id` | uuid | có | → product |
| `lot_id` | uuid | có | lô BTP của nhãn hiệu · → lot |
| `first_can_code` | text | có | mã quét trên lon đầu |
| `planned_can_count` | integer | có |  |
| `good_can_count` | integer | có | mặc định 0 |
| `rejected_can_count` | integer | có | mặc định 0 |
| `started_at` | timestamptz | có |  |
| `ended_at` | timestamptz |  |  |
| `printed_lot_no` | text |  | ⏸ CHỜ QUYẾT — in NSX / HSD / lô lên lon: ai nhập, đối chiếu thế nào |
| `printed_mfg_date` | date |  | ⏸ CHỜ QUYẾT —  |
| `printed_exp_date` | date |  | ⏸ CHỜ QUYẾT —  |
| `source_event_id` | uuid |  |  |
| `origin_site` | text | có | nơi tạo dòng · giá trị: CLOUD / NM |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `carton_recount`

Thùng thiếu kg: đếm lại, sửa số lon của thùng, ghi lệch vào hồ sơ mẻ.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT21 tx, yd
- **Khóa chính:** `id`
- **Khóa ngoại:** `handling_unit_id` → `handling_unit.id` · `filling_run_id` → `filling_run.id`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `handling_unit_id` | uuid | có | → handling_unit |
| `filling_run_id` | uuid | có | → filling_run |
| `counter_qty` | integer | có | số lon theo bộ đếm |
| `counted_qty` | integer | có | số lon đếm lại |
| `source_event_id` | uuid |  |  |
| `origin_site` | text | có | nơi tạo dòng · giá trị: CLOUD / NM |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `batch_mixing_param` · ⏸ CHỜ QUYẾT

Thông số trộn thực tế của mẻ BTP.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT20 g7 (chờ quyết)
- **⏸ Chờ quyết:** QT20 "thông số trộn" — chưa quyết thông số nào, nhập tay hay lấy từ máy. Chỉ chừa 1 dòng / mẻ + jsonb.
- **Khóa chính:** `id`
- **Khóa ngoại:** `batch_id` → `production_batch.id`
- **Unique:** `(batch_id)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `batch_id` | uuid | có | → production_batch |
| `params` | jsonb |  |  |
| `recorded_at` | timestamptz | có |  |
| `origin_site` | text | có | nơi tạo dòng · giá trị: CLOUD / NM |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `batch_downtime` · ⏸ CHỜ QUYẾT

Sự cố / dừng máy trong mẻ.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT20 g4 (chờ quyết)
- **⏸ Chờ quyết:** QT20 "sự cố dừng máy" — chưa quyết trường bắt buộc (nguyên nhân theo danh mục?, người xử lý), có nối dữ liệu máy không. Chỉ chừa thời gian + thiết bị + jsonb. Hủy mẻ khi không khắc phục được đã chốt 17/10 (batch_cancellation).
- **Khóa chính:** `id`
- **Khóa ngoại:** `batch_id` → `production_batch.id` · `equipment_id` → `equipment.id`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `batch_id` | uuid | có | → production_batch |
| `equipment_id` | uuid |  | → equipment |
| `started_at` | timestamptz | có |  |
| `ended_at` | timestamptz |  |  |
| `detail` | jsonb |  |  |
| `origin_site` | text | có | nơi tạo dòng · giá trị: CLOUD / NM |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `batch_weight_check` · ⏸ CHỜ QUYẾT

KL thực tế so với công thức (cân bao HH theo dung sai).

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT20 h8, g3, yk (chờ quyết)
- **⏸ Chờ quyết:** QT20 "KL thực tế vs công thức" — chưa quyết ghi theo bao hay theo mẻ, xử lý lệch. Chỉ chừa mục tiêu / thực tế + jsonb.
- **Khóa chính:** `id`
- **Khóa ngoại:** `batch_id` → `production_batch.id` · `handling_unit_id` → `handling_unit.id`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `batch_id` | uuid | có | → production_batch |
| `handling_unit_id` | uuid |  | → handling_unit |
| `target_kg` | numeric(12,3) |  |  |
| `actual_kg` | numeric(12,3) |  |  |
| `detail` | jsonb |  |  |
| `origin_site` | text | có | nơi tạo dòng · giá trị: CLOUD / NM |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `filling_can_weight` · ⏸ CHỜ QUYẾT

Cân từng lon sau đậy nắp.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT21 g2, yx, dc (chờ quyết)
- **⏸ Chờ quyết:** QT21 "cân từng lon" — chưa quyết lưu từng lon hay chỉ tổng hợp (khối lượng dữ liệu lớn, có thể thuộc phần dữ liệu máy / IoT). Chỉ chừa khung.
- **Khóa chính:** `id`
- **Khóa ngoại:** `filling_run_id` → `filling_run.id`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `filling_run_id` | uuid | có | → filling_run |
| `measured_at` | timestamptz | có |  |
| `net_weight_g` | numeric(10,2) |  |  |
| `accepted` | boolean |  |  |
| `detail` | jsonb |  |  |
| `origin_site` | text | có | nơi tạo dòng · giá trị: CLOUD / NM |

<sub>Cột chung: `— (nhật ký / hàng đợi có cột thời điểm + người riêng)`</sub>

### `ncr` · ⏸ CHỜ QUYẾT

Phiếu không phù hợp (NCR). Đã được nhắc ở QT14 (bao hư từ SX), QT25 (gom NCR), QT26 (CAPA).

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT14 nr (Kế hoạch lập), QT26 q3 (chờ quyết)
- **⏸ Chờ quyết:** NCR chưa có quy trình riêng (nội dung, luồng duyệt). Đã chốt 17/10: Kế hoạch lập NCR khi SX giao hàng hư vào kho (QT14 nr); hủy mẻ do sự cố không đi qua NCR (batch_cancellation). Chỉ chừa khung để bảng khác trỏ tới.
- **Khóa chính:** `id`
- **Khóa ngoại:** `lot_id` → `lot.id` · `batch_id` → `production_batch.id`
- **Unique:** `(code)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `code` | text | có |  |
| `source_qt` | text |  |  |
| `lot_id` | uuid |  | → lot |
| `batch_id` | uuid |  | → production_batch |
| `qty` | numeric(14,3) |  |  |
| `detail` | jsonb |  |  |
| `status` | text |  |  |
| `origin_site` | text | có | nơi tạo dòng · giá trị: CLOUD / NM |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `sync_outbox`

Hàng đợi gửi lên tại máy chủ nhà máy (sửa 20/10 đợt 2 — thay sync_event): MỌI thay đổi trên bảng nhà máy chủ (nhóm NM của sync_policy: tồn, lô, bao / thùng, chứng từ kho, QC, mẻ, nạp / xả silo, chiết rót…) và bảng nơi phát sinh (phiên, tệp, nhật ký) ghi 1 dòng ở đây TRONG CÙNG GIAO DỊCH bằng trigger (event_type = DONG, payload = bản ghi sau thay đổi); sự kiện SX có nghĩa giữ event_type cũ. Luôn ghi kể cả khi có kết nối (1 đường đồng bộ). Nhà máy chủ động đẩy lên cloud theo seq_no (POST /sync/push); giữ 30 ngày sau khi cloud xác nhận rồi dọn.

- **Nơi:** Chỉ máy chủ nhà máy — máy chủ nhà máy ghi, đẩy lên cloud theo seq_no; cloud nhận vào sync_event_inbox (bỏ trùng theo event_id)
- **QT:** QT19 k3, k5, c1; mọi QT có dữ liệu nhà máy chủ (QT04, QT14–QT18, QT20–QT24)
- **Khóa chính:** `event_id`
- **Khóa ngoại:** `production_order_id` → `production_order.id` · `batch_id` → `production_batch.id` · `recorded_by` → `app_user.id`
- **Unique:** `(factory_id, seq_no)`
- **Check:** `event_type <> 'DONG' or (table_name is not null and record_key is not null and op is not null)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `event_id` | uuid | có | mã sự kiện duy nhất (sinh tại nhà máy) |
| `seq_no` | bigint | có | số thứ tự tăng dần theo nhà máy |
| `table_name` | text |  | bảng của dòng thay đổi (event_type = DONG) |
| `record_key` | text |  | khóa của dòng (dạng chữ — bảng có khóa chính khác id vẫn ghi được) |
| `op` | text |  | loại thay đổi (event_type = DONG) · giá trị: INSERT / UPDATE |
| `production_order_id` | uuid |  | → production_order |
| `batch_id` | uuid |  | → production_batch |
| `event_type` | text | có | DONG: thay đổi 1 dòng của bảng nhà máy chủ (trigger ghi); còn lại: sự kiện SX có nghĩa · giá trị: DONG / ME_BAT_DAU / QUET_BAO / CAN_BAO_HH / BAO_HH / LON_DAU / DEM_LON / THUNG / DEM_LAI_THUNG / ME_KET_THUC / XUAT_NVL / SU_CO / ME_HUY / KHAC |
| `payload` | jsonb | có |  |
| `occurred_at` | timestamptz | có |  |
| `recorded_by` | uuid | có | → app_user |
| `offline` | boolean | có |  |
| `status` | text | có | giá trị: CHO_GUI / DA_GUI / DA_XAC_NHAN · mặc định 'CHO_GUI' |
| `sent_at` | timestamptz |  |  |
| `acked_at` | timestamptz |  |  |

<sub>Cột chung: `— (nhật ký / hàng đợi có cột thời điểm + người riêng)`</sub>

### `sync_event_inbox`

Sổ nhận sự kiện trên cloud. Khóa chính = event_id nên gửi lại không ghi 2 lần (INSERT … ON CONFLICT DO NOTHING = bỏ trùng). Áp dụng đúng thứ tự seq_no theo nhà máy.

- **Nơi:** Chỉ cloud — chỉ cloud — nhận sync_outbox của các nhà máy, bỏ trùng theo event_id, áp dụng theo seq_no từng nhà máy
- **QT:** QT19 k5, k6
- **Khóa chính:** `event_id`
- **Khóa ngoại:** `factory_id` → `factory.id`
- **Unique:** `(factory_id, seq_no)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `event_id` | uuid | có |  |
| `factory_id` | uuid | có | → factory |
| `seq_no` | bigint | có |  |
| `event_type` | text | có |  |
| `payload` | jsonb | có |  |
| `occurred_at` | timestamptz | có |  |
| `received_at` | timestamptz | có | mặc định now() |
| `applied_at` | timestamptz |  |  |
| `apply_result` | text | có | giá trị: CHO / DA_AP_DUNG / XUNG_DOT / LOI · mặc định 'CHO' |
| `error_message` | text |  |  |

<sub>Cột chung: `— (nhật ký / hàng đợi có cột thời điểm + người riêng)`</sub>

### `factory_sync_state`

Trạng thái đồng bộ từng nhà máy: seq_no đã áp dụng cuối, lần liên lạc cuối, đang ngoại tuyến không.

- **Nơi:** Chỉ cloud — chỉ cloud
- **QT:** QT19 dp, k1, kd
- **Khóa chính:** `factory_id`
- **Khóa ngoại:** `factory_id` → `factory.id`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | → factory |
| `last_applied_seq` | bigint | có | mặc định 0 |
| `last_contact_at` | timestamptz |  |  |
| `is_offline` | boolean | có | mặc định false |
| `last_downstream_seq` | bigint | có | thay đổi cloud → nhà máy đã gửi tới đâu · mặc định 0 |

<sub>Cột chung: `— (nhật ký / hàng đợi có cột thời điểm + người riêng)`</sub>

### `downstream_change`

Dòng bản sao cloud → nhà máy (bảng nhóm CLOUD của sync_policy, lọc theo factory_id, kéo theo dòng cha theo khóa ngoại): danh mục, tài khoản, lệnh, PO đã duyệt, đợt giao đã chốt lịch, hồ sơ thu hồi, phiếu chuyển của nhà máy khác, cột dẫn xuất do cloud chiếu. Sửa 20/10 (đợt 2): bỏ op KHOA — khóa lô / tài khoản / hủy lệnh đi bằng lệnh site_command. Nhà máy kéo theo seq (GET /sync/pull), áp dụng với app.sync_apply = on.

- **Nơi:** Chỉ cloud — cloud ghi → máy chủ nhà máy kéo theo seq
- **QT:** QT19 k5, c2
- **Khóa chính:** `id`
- **Khóa ngoại:** `factory_id` → `factory.id`
- **Unique:** `(factory_id, seq)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | → factory |
| `seq` | bigint | có |  |
| `table_name` | text | có |  |
| `record_id` | uuid | có |  |
| `op` | text | có | giá trị: UPSERT |
| `payload` | jsonb | có |  |
| `created_at` | timestamptz | có | mặc định now() |

<sub>Cột chung: `— (nhật ký / hàng đợi có cột thời điểm + người riêng)`</sub>

### `sync_conflict`

Xung đột khi đồng bộ: lô đã dùng nhưng cloud đã KHÓA / HỦY, tồn âm. Hệ thống tự KHÓA lô sinh ra theo chuỗi liên kết; Kế hoạch + QC xử lý. Sửa 20/10 (đợt 2): ghi tại máy chủ nhà máy khi áp lệnh khóa lô tới muộn (QT19 kz); lô HỦY bị dùng, tồn âm.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT19 kx, kz, kf
- **Khóa chính:** `id`
- **Khóa ngoại:** `site_command_id` → `site_command.id` · `lot_id` → `lot.id` · `batch_id` → `production_batch.id` · `handled_by` → `app_user.id` · `recall_case_id` → `recall_case.id` · `qc_request_id` → `qc_request.id` · `stocktake_id` → `stocktake.id`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `event_id` | uuid |  | sự kiện / lệnh gốc (mã sự kiện ở sync_outbox hoặc mã lệnh site_command) — không khóa ngoại vì 2 nơi |
| `site_command_id` | uuid |  | lệnh từ trung tâm tới muộn gây xung đột (KHOA_LO) · → site_command |
| `conflict_type` | text | có | giá trị: LO_DA_KHOA / LO_DA_HUY / TON_AM / KHAC |
| `lot_id` | uuid |  | → lot |
| `batch_id` | uuid |  | → production_batch |
| `detail` | jsonb |  |  |
| `status` | text | có | giá trị: MO / DANG_XU_LY / DA_XU_LY · mặc định 'MO' |
| `handled_by` | uuid |  | → app_user |
| `resolution` | text |  |  |
| `resolved_at` | timestamptz |  |  |
| `recall_case_id` | uuid |  | → recall_case |
| `qc_request_id` | uuid |  | → qc_request |
| `stocktake_id` | uuid |  | → stocktake |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `offline_session`

Nhật ký mỗi lần mất kết nối: bắt đầu, kết thúc, dải seq, số sự kiện đã đồng bộ, số xung đột, lúc dừng nhận mẻ mới (quá 8 giờ).

- **Nơi:** Chỉ máy chủ nhà máy — chỉ máy chủ nhà máy; tóm tắt phiên gửi lên cloud qua sync_outbox
- **QT:** QT19 k1, k7
- **Khóa chính:** `id`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `started_at` | timestamptz | có |  |
| `ended_at` | timestamptz |  |  |
| `first_seq` | bigint |  |  |
| `last_seq` | bigint |  |  |
| `events_synced` | integer |  |  |
| `conflicts` | integer |  |  |
| `stopped_new_batches_at` | timestamptz |  |  |

<sub>Cột chung: `— (nhật ký / hàng đợi có cột thời điểm + người riêng)`</sub>

### `site_command`

Kênh lệnh từ trung tâm (thêm 20/10 đợt 2 — quyết định 35): mọi tác động của cloud lên dữ liệu nhà máy chủ — phát / hủy / kết thúc sớm lệnh, hủy mẻ + mẻ bù, khóa / mở khóa lô (thu hồi, khoanh vùng), khóa tài khoản, silo bảo trì, đổi loại khu, giảm KL mẻ tối đa, yêu cầu xuất kho, đề nghị chuyển kho. Nhà máy kéo theo seq, áp dụng trong 1 giao dịch kèm kiểm điều kiện thực tế, trả kết quả qua command_inbox; trạng thái chỉ đi tới (trigger). Màn cloud hiện trạng thái lệnh cạnh thao tác.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud ghi (cả khi nhà máy mất kết nối — nằm CHO_GUI) → máy chủ nhà máy kéo theo seq (GET /sync/pull), ghi command_inbox; status, result_text, sent_at, applied_at do cloud chiếu từ command_inbox
- **QT:** QT19 y2, yh, kt, kl; QT20 kh, kb; QT26 y1, y2, yv; QT01 nk; QT02 ka, ks; QT16 ya
- **Khóa chính:** `id`
- **Khóa ngoại:** `factory_id` → `factory.id`
- **Unique:** `(factory_id, seq)`
- **Check:** `status <> 'TU_CHOI' or result_text is not null` · `status not in ('DA_AP_DUNG','TU_CHOI') or applied_at is not null` · `status = 'CHO_GUI' or sent_at is not null`
- **Trigger:** trạng thái chỉ đi tới CHO_GUI → DA_GUI → DA_AP_DUNG / TU_CHOI, trạng thái cuối không đổi (trg_site_command_status); command_inbox kết thúc → cloud chiếu sang lệnh (trg_command_inbox_result)

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy nhận lệnh · → factory |
| `seq` | bigint | có | số thứ tự lệnh theo nhà máy (nhà máy kéo theo seq) |
| `kind` | text | có | giá trị: PHAT_LENH / HUY_LENH / KET_THUC_SOM / HUY_ME / ME_BU / KHOA_LO / MO_KHOA_LO / KHOA_TAI_KHOAN / SILO_BAO_TRI / DOI_LOAI_KHU / GIAM_KL_ME / YEU_CAU_XUAT / DE_NGHI_CHUYEN |
| `payload` | jsonb | có | nội dung lệnh (vd lô + lý do khóa, mẻ + số kg bỏ) |
| `ref_table` | text |  | chứng từ cloud sinh ra lệnh (vd recall_case, batch_cancellation, production_order) |
| `ref_id` | uuid |  |  |
| `status` | text | có | CHO_GUI: nhà máy chưa kéo (đang mất mạng); chỉ đi tới, DA_AP_DUNG / TU_CHOI là cuối (trigger); cloud chiếu từ command_inbox · giá trị: CHO_GUI / DA_GUI / DA_AP_DUNG / TU_CHOI · mặc định 'CHO_GUI' |
| `result_text` | text |  | lý do từ chối / ghi chú khi áp dụng |
| `sent_at` | timestamptz |  | nhà máy kéo về |
| `applied_at` | timestamptz |  | nhà máy áp dụng / từ chối |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `command_inbox`

Sổ lệnh đã nhận tại máy chủ nhà máy (thêm 20/10 đợt 2): mỗi lệnh site_command nhà máy kéo về 1 dòng, ghi kết quả áp dụng (ĐÃ ÁP DỤNG / TỪ CHỐI kèm lý do), gửi lên cloud qua sync_outbox; cloud chiếu sang site_command. Cloud khôi phục từ sao lưu thì nhà máy gửi lại sổ này để cloud dựng lại trạng thái lệnh (QT19 c1).

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT19 kl, c1
- **Khóa chính:** `command_id`
- **Khóa ngoại:** `command_id` → `site_command.id` · `applied_by` → `app_user.id`
- **Unique:** `(factory_id, seq)`
- **Check:** `status <> 'TU_CHOI' or result_text is not null` · `status = 'DA_NHAN' or applied_at is not null`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `command_id` | uuid | có | mã lệnh · → site_command |
| `seq` | bigint | có |  |
| `kind` | text | có |  |
| `received_at` | timestamptz | có | mặc định now() |
| `status` | text | có | giá trị: DA_NHAN / DA_AP_DUNG / TU_CHOI · mặc định 'DA_NHAN' |
| `result_text` | text |  | lý do từ chối (bắt buộc khi TU_CHOI) |
| `applied_at` | timestamptz |  |  |
| `applied_by` | uuid |  | người / Hệ thống áp dụng · → app_user |

<sub>Cột chung: `— (nhật ký / hàng đợi có cột thời điểm + người riêng)`</sub>


## 6 · Chất lượng — 8 bảng

### `qc_request`

Yêu cầu kiểm. QT22: chỉ khi lô NVL nghi lỗi. QT23: BTP mới nhập kho BTP, hàng khách trả, lô bị khoanh vùng / xung đột / hư khi nhận / tìm lại. Gửi là phần lô → CHỜ KIỂM; QC trưởng duyệt / từ chối (lô về trạng thái trước) / yêu cầu bổ sung. BTP mới nhập không được từ chối.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT22 t1, y1, d1, yt; QT23 t1, y1, d1, yt; tự hủy khi lô đến hạn (QT18 yc)
- **Khóa chính:** `id`
- **Khóa ngoại:** `lot_id` → `lot.id` · `reviewed_by` → `app_user.id` · `goods_receipt_id` → `goods_receipt.id` · `recall_case_id` → `recall_case.id` · `sync_conflict_id` → `sync_conflict.id` · `transfer_discrepancy_id` → `transfer_discrepancy.id`
- **Unique:** `(code)`
- **Check:** `status <> 'TU_CHOI' or reject_reason is not null` · `reviewed_by is null or reviewed_by <> created_by` · `request_kind <> 'BTP_MOI_NHAP' or status <> 'TU_CHOI'` · `request_kind <> 'BTP_MOI_NHAP' or qt_code = 'QT23'` · `request_kind <> 'NVL_NGHI_LOI' or qt_code = 'QT22'` · `status <> 'YEU_CAU_BO_SUNG' or supplement_note is not null`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `code` | text | có |  |
| `qt_code` | text | có | giá trị: QT22 / QT23 |
| `request_kind` | text | có | giá trị: NVL_NGHI_LOI / BTP_MOI_NHAP / KHACH_TRA / KHOANH_VUNG / XUNG_DOT / HU_KHI_NHAN / TIM_LAI |
| `lot_id` | uuid | có | → lot |
| `reason` | text |  |  |
| `status` | text | có | giá trị: CHO_DUYET / YEU_CAU_BO_SUNG / TU_CHOI / DA_DUYET / DA_KET_LUAN / DA_HUY · mặc định 'CHO_DUYET' |
| `reviewed_by` | uuid |  | QC trưởng · → app_user |
| `reviewed_at` | timestamptz |  |  |
| `reject_reason` | text |  |  |
| `supplement_note` | text |  | nội dung yêu cầu bổ sung (QC trưởng) |
| `goods_receipt_id` | uuid |  | → goods_receipt |
| `recall_case_id` | uuid |  | → recall_case |
| `sync_conflict_id` | uuid |  | → sync_conflict |
| `transfer_discrepancy_id` | uuid |  | → transfer_discrepancy |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `qc_request_part`

Các phần lô (dòng tồn lô × kho, theo bao) bị đưa vào CHỜ KIỂM, kèm trạng thái + lý do khóa trước đó để trả về đúng khi QC trưởng từ chối.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT22 y1, yt; QT23 y1, yt
- **Khóa chính:** `id`
- **Khóa ngoại:** `request_id` → `qc_request.id` · `stock_line_id` → `stock_line.id` · `prev_lock_reason` → `lock_reason.code`
- **Unique:** `(request_id, stock_line_id)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `request_id` | uuid | có | → qc_request |
| `stock_line_id` | uuid | có | → stock_line |
| `qty` | numeric(14,3) | có |  |
| `prev_status` | text | có | giá trị: CHO_KIEM / DAT / KHONG_DAT / KHOA |
| `prev_lock_reason` | text |  | → lock_reason |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `qc_inspection`

Phiếu kiểm: mẫu đã lấy, số liệu QC nhập, kết luận hệ thống đề xuất, kết luận QC trưởng duyệt. Người nhập không tự duyệt; lô chỉ đổi trạng thái sau khi duyệt.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT22 t3, g1, d2; QT23 t3, yq, d2
- **Khóa chính:** `id`
- **Khóa ngoại:** `request_id` → `qc_request.id` · `lot_id` → `lot.id` · `sampled_by` → `app_user.id` · `sample_uom` → `uom.code` · `entered_by` → `app_user.id` · `external_report_file_id` → `file_attachment.id` · `approved_by` → `app_user.id`
- **Unique:** `(code)`
- **Check:** `approved_by is null or approved_by <> entered_by` · `(final_result is null) = (approved_by is null)` · `final_result is null or proposed_result is null or final_result = proposed_result or override_reason is not null`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `code` | text | có |  |
| `request_id` | uuid | có | → qc_request |
| `inspection_kind` | text | có | giá trị: NVL / TP |
| `lot_id` | uuid | có | → lot |
| `sampled_at` | timestamptz |  |  |
| `sampled_by` | uuid |  | → app_user |
| `sample_qty` | numeric(12,3) |  |  |
| `sample_uom` | text |  | → uom |
| `entered_by` | uuid | có | → app_user |
| `proposed_result` | text |  | giá trị: DAT / KHONG_DAT / CHUA_CO_GIOI_HAN |
| `final_result` | text |  | giá trị: DAT / KHONG_DAT |
| `external_report_file_id` | uuid |  | file đánh giá / kiểm nghiệm bên ngoài · → file_attachment |
| `qc_note` | text |  | ghi chú QC |
| `override_reason` | text |  | lý do QC trưởng kết luận khác đề xuất |
| `approved_by` | uuid |  | QC trưởng · → app_user |
| `approved_at` | timestamptz |  |  |
| `status` | text | có | giá trị: DANG_KIEM / CHO_DUYET / DA_DUYET · mặc định 'DANG_KIEM' |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `qc_result_item`

Kết quả theo từng chỉ tiêu, chép lại giới hạn lúc kiểm.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT22 g1, QT23 yq
- **Khóa chính:** `id`
- **Khóa ngoại:** `inspection_id` → `qc_inspection.id` · `material_spec_item_id` → `material_spec_item.id` · `product_spec_item_id` → `product_spec_item.id`
- **Check:** `material_spec_item_id is null or product_spec_item_id is null`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `inspection_id` | uuid | có | → qc_inspection |
| `material_spec_item_id` | uuid |  | → material_spec_item |
| `product_spec_item_id` | uuid |  | → product_spec_item |
| `criterion_name` | text | có |  |
| `unit` | text |  |  |
| `min_value` | numeric |  |  |
| `max_value` | numeric |  |  |
| `expected_text` | text |  |  |
| `value_num` | numeric |  |  |
| `value_text` | text |  |  |
| `passed` | boolean |  |  |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `product_spec_item`

Bộ chỉ tiêu & giới hạn BTP / TP theo từng SP (vi sinh, độ ẩm, KL tịnh…) — QC tự quyết, nhập ở danh mục SP (QT23 g1), phần mềm ghi nhận. Chốt 19/10 (đợt 4): đây là bộ chỉ tiêu thành phẩm chuẩn gắn với SP — phiếu kiểm TP (`qc_result_item.product_spec_item_id`) và phiếu chứng nhận dùng đúng bộ này. Kết quả kiểm chép lại giới hạn lúc kiểm, nên sửa giới hạn không làm sai kết quả cũ.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc
- **QT:** QC nhập ở trang chi tiết SP (QT02 qc, QT23 g1); dùng QT23 yq
- **Khóa chính:** `id`
- **Khóa ngoại:** `product_id` → `product.id`
- **Unique:** `(product_id, criterion_code where status = 'DANG_DUNG')`
- **Check:** `min_value is null or max_value is null or min_value <= max_value`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `product_id` | uuid | có | → product |
| `criterion_code` | text | có |  |
| `criterion_name` | text | có |  |
| `unit` | text |  |  |
| `value_type` | text | có | giá trị: SO / CHU / DAT_KHONG |
| `min_value` | numeric |  |  |
| `max_value` | numeric |  |  |
| `expected_text` | text |  |  |
| `sort_order` | integer | có | mặc định 0 |
| `status` | text | có | giá trị: DANG_DUNG / NGUNG_DUNG · mặc định 'DANG_DUNG' |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `quality_certificate`

Phiếu chứng nhận chất lượng xuất xưởng cho lô TP. Sửa 04/11: QC trưởng duyệt kết luận thì hệ thống lập phiếu ở Chờ ký; ký tách riêng sau (tab Chờ ký) → Đã ký, gửi kèm khi giao. Lô TP kiểm lại (khách trả) sinh phiếu mới.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT23 g2 (lập khi duyệt kết luận), ký phiếu chứng nhận (QC trưởng); QT09 đọc
- **Khóa chính:** `id`
- **Khóa ngoại:** `lot_id` → `lot.id` · `inspection_id` → `qc_inspection.id` · `approved_by` → `app_user.id` · `file_id` → `file_attachment.id` · `signed_by` → `app_user.id`
- **Unique:** `(code)` · `(lot_id, inspection_id)`
- **Check:** `status <> 'DA_KY' or (code is not null and signed_by is not null and signed_at is not null and issued_at is not null)` · `status <> 'DA_HUY' or cancel_reason is not null`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `code` | text |  | số phiếu CN-{NM}-{yymm}-{4 số} — cấp khi ký |
| `lot_id` | uuid | có | → lot |
| `inspection_id` | uuid | có | → qc_inspection |
| `approved_by` | uuid | có | QC trưởng duyệt kết luận · → app_user |
| `issued_at` | timestamptz |  | ngày cấp = lúc ký |
| `content_snapshot` | jsonb | có | chỉ tiêu, kết quả, giới hạn tại lúc cấp |
| `file_id` | uuid |  | → file_attachment |
| `status` | text | có | giá trị: CHO_KY / DA_KY / DA_HUY · mặc định 'CHO_KY' |
| `signed_by` | uuid |  | QC trưởng ký · → app_user |
| `signed_at` | timestamptz |  |  |
| `cancel_reason` | text |  |  |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `retained_sample`

Mẫu lưu gắn lô: mã mẫu, số lượng, niêm phong, hạn lưu, nơi lưu, ghi chú — QC tự quyết hạn lưu, phần mềm ghi nhận và nhắc khi hết hạn. Sửa 04/11 (theo mockup): lấy mẫu ra đánh giá → niêm phong lại (ghi kết quả), sửa hạn lưu — mỗi lần 1 dòng retained_sample_event; ô "Nơi lưu mẫu"; hủy ghi cách hủy, người chứng kiến, biên bản.

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT24 t1, t2, y1, t3, g1, d1, t4; lấy ra / niêm phong lại / sửa hạn lưu (04/11); QT22 / QT23 t3
- **Khóa chính:** `id`
- **Khóa ngoại:** `lot_id` → `lot.id` · `inspection_id` → `qc_inspection.id` · `uom_code` → `uom.code` · `destroyed_by` → `app_user.id` · `destruction_file_id` → `file_attachment.id`
- **Unique:** `(code)`
- **Check:** `status <> 'DA_HUY' or (destroyed_at is not null and destroyed_by is not null)` · `status <> 'DA_HUY' or destruction_method is not null` · `not (is_open and status = 'DA_HUY')`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `factory_id` | uuid | có | nhà máy (phân dữ liệu theo nhà máy) · → factory |
| `code` | text | có |  |
| `lot_id` | uuid | có | → lot |
| `inspection_id` | uuid |  | → qc_inspection |
| `qty` | numeric(12,3) | có |  |
| `uom_code` | text | có | → uom |
| `sealed_at` | timestamptz |  |  |
| `retain_until` | date | có | QC tự quyết; gợi ý HSD + 6 tháng (tham số) |
| `storage_place` | text |  | nơi lưu mẫu (04/11) |
| `is_open` | boolean | có | đang lấy ra đánh giá (mở niêm phong) · mặc định false |
| `note` | text |  | ghi chú khi ghi mẫu lưu (không bắt buộc) |
| `status` | text | có | giá trị: DANG_LUU / DA_HUY · mặc định 'DANG_LUU' |
| `destroyed_at` | timestamptz |  |  |
| `destroyed_by` | uuid |  | QC tự hủy mẫu hết hạn lưu, không cần duyệt (QT24 t4) · → app_user |
| `destruction_method` | text |  | cách hủy |
| `destruction_witness` | text |  | người chứng kiến |
| `destruction_file_id` | uuid |  | biên bản hủy mẫu · → file_attachment |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `retained_sample_event`

Nhật ký mẫu lưu (chốt 04/11): lấy mẫu ra đánh giá (mục đích, truy xuất / thu hồi liên quan), niêm phong lại (kết quả đánh giá), sửa hạn lưu (hạn cũ → mới, lý do).

- **Nơi:** Nhà máy chủ dòng của mình, sao lên cloud — máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command
- **QT:** QT24 (Mẫu lưu › lấy ra / niêm phong lại / sửa hạn lưu)
- **Khóa chính:** `id`
- **Khóa ngoại:** `sample_id` → `retained_sample.id` · `trace_request_id` → `trace_request.id` · `recall_case_id` → `recall_case.id` · `actor_id` → `app_user.id`
- **Check:** `event_kind <> 'LAY_RA' or reason is not null` · `event_kind <> 'NIEM_PHONG_LAI' or result_text is not null` · `event_kind <> 'SUA_HAN_LUU' or (old_retain_until is not null and new_retain_until is not null and reason is not null)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `sample_id` | uuid | có | → retained_sample |
| `event_kind` | text | có | giá trị: LAY_RA / NIEM_PHONG_LAI / SUA_HAN_LUU |
| `reason` | text |  | mục đích lấy ra / lý do sửa hạn |
| `trace_request_id` | uuid |  | → trace_request |
| `recall_case_id` | uuid |  | → recall_case |
| `result_text` | text |  | kết quả đánh giá khi niêm phong lại |
| `old_retain_until` | date |  |  |
| `new_retain_until` | date |  |  |
| `occurred_at` | timestamptz | có | mặc định now() |
| `actor_id` | uuid | có | → app_user |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

## 7 · Truy xuất & thu hồi — 10 bảng

### `trace_request`

Phiếu truy xuất: nguồn, lý do, mã đầu vào, hướng, người truy xuất (vai trò gán ở QT01), thời điểm tạo / có kết quả (bằng chứng, không đặt mục tiêu thời gian — bỏ 29/10). Lưu ≥ HSD + 12 tháng, không xóa.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc
- **QT:** QT25 t1, y0, y6
- **Khóa chính:** `id`
- **Khóa ngoại:** `factory_id` → `factory.id` · `recall_case_id` → `recall_case.id` · `input_sales_order_id` → `sales_order.id` · `input_customer_id` → `customer.id` · `input_material_id` → `material.id` · `input_lot_id` → `lot.id` · `tracer_id` → `app_user.id` · `report_file_id` → `file_attachment.id` · `authority_letter_file_id` → `file_attachment.id`
- **Unique:** `(code)`
- **Check:** `source <> 'THU_HOI' or recall_case_id is not null` · `input_kind <> 'DON_HANG' or input_sales_order_id is not null` · `input_kind <> 'KHACH_HANG' or input_customer_id is not null` · `input_kind <> 'MA_NVL' or input_material_id is not null`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `code` | text | có |  |
| `factory_id` | uuid |  | → factory |
| `source` | text | có | giá trị: THU_HOI / QC / CO_QUAN / NOI_BO |
| `recall_case_id` | uuid |  | → recall_case |
| `reason` | text | có |  |
| `input_kind` | text | có | loại mã đầu vào (04/11: thêm đơn hàng, khách hàng, mã NVL) · giá trị: SO_LO / QR / DON_HANG / KHACH_HANG / MA_NVL · mặc định 'SO_LO' |
| `input_sales_order_id` | uuid |  | → sales_order |
| `input_customer_id` | uuid |  | → customer |
| `input_material_id` | uuid |  | → material |
| `input_code` | text | có | mã nhập: QR lon / thùng / bao, số lô, mã đơn, mã khách hoặc mã NVL |
| `input_lot_id` | uuid |  | → lot |
| `direction` | text | có | giá trị: NGUOC / XUOI |
| `tracer_id` | uuid | có | Người truy xuất (vai trò chỉ Admin gán) · → app_user |
| `started_at` | timestamptz | có | thời điểm tạo phiếu |
| `completed_at` | timestamptz |  | thời điểm hệ thống có kết quả |
| `retain_until` | date |  |  |
| `report_file_id` | uuid |  | → file_attachment |
| `authority_letter_file_id` | uuid |  | công văn cơ quan (nguồn CO_QUAN) · → file_attachment |
| `status` | text | có | giá trị: DANG_TRUY_XUAT / HOAN_THANH · mặc định 'DANG_TRUY_XUAT' |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `trace_result_lot`

Bản chụp chuỗi lô của lần truy xuất (bằng chứng — không tính lại về sau): lô, độ sâu, đường đi, trạng thái lúc truy xuất, hồ sơ QC / COA / mẫu lưu / NCR kèm theo.

- **Nơi:** Chỉ cloud — chỉ cloud
- **QT:** QT25 y2, y3, y4
- **Khóa chính:** `id`
- **Khóa ngoại:** `trace_request_id` → `trace_request.id` · `lot_id` → `lot.id`
- **Unique:** `(trace_request_id, lot_id)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `trace_request_id` | uuid | có | → trace_request |
| `lot_id` | uuid | có | → lot |
| `depth` | integer | có |  |
| `path` | uuid[] | có |  |
| `lot_status_summary` | jsonb |  |  |
| `documents` | jsonb |  |  |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `trace_result_customer`

Bản chụp khách đã nhận theo lô (đầu vào danh sách thông báo của QT26).

- **Nơi:** Chỉ cloud — chỉ cloud
- **QT:** QT25 y3, y6
- **Khóa chính:** `id`
- **Khóa ngoại:** `trace_request_id` → `trace_request.id` · `customer_id` → `customer.id` · `lot_id` → `lot.id` · `goods_issue_id` → `goods_issue.id`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `trace_request_id` | uuid | có | → trace_request |
| `customer_id` | uuid | có | → customer |
| `lot_id` | uuid | có | → lot |
| `goods_issue_id` | uuid |  | phiếu xuất bán · → goods_issue |
| `qty_delivered` | numeric(14,3) | có |  |
| `qty_returned` | numeric(14,3) | có | mặc định 0 |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `mass_balance_result`

Cân bằng khối lượng từng lô: SL vào (nhập / SX ra) = dùng cho SX + giao + trả NCC + hủy + mẫu + tồn + đang chuyển (+ điều chỉnh kiểm kho). Lệch → biên bản + kiểm kho (QT17).

- **Nơi:** Chỉ cloud — chỉ cloud
- **QT:** QT25 y5, d4, t3
- **Khóa chính:** `id`
- **Khóa ngoại:** `trace_request_id` → `trace_request.id` · `lot_id` → `lot.id` · `uom_code` → `uom.code` · `discrepancy_file_id` → `file_attachment.id` · `stock_discrepancy_id` → `stock_discrepancy.id`
- **Unique:** `(trace_request_id, lot_id)`
- **Check:** `diff = 0 or stock_discrepancy_id is not null`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `trace_request_id` | uuid | có | → trace_request |
| `lot_id` | uuid | có | → lot |
| `uom_code` | text | có | → uom |
| `qty_in` | numeric(14,3) | có |  |
| `used_in_production` | numeric(14,3) | có |  |
| `delivered` | numeric(14,3) | có |  |
| `returned_to_supplier` | numeric(14,3) | có |  |
| `destroyed` | numeric(14,3) | có |  |
| `samples` | numeric(14,3) | có |  |
| `adjustments` | numeric(14,3) | có |  |
| `on_hand` | numeric(14,3) | có |  |
| `in_transit` | numeric(14,3) | có | hàng đang chuyển (dòng tồn trên phiếu chuyển) |
| `diff` | numeric(14,3) | có |  |
| `discrepancy_file_id` | uuid |  | → file_attachment |
| `stock_discrepancy_id` | uuid |  | → stock_discrepancy |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `recall_case`

Hồ sơ thu hồi: chỉ QC trưởng mở (người tạo; mở là hệ thống khóa cả lô ngay), QC trưởng đánh giá rủi ro, mức nguy hại (nhà máy tự quyết, hệ thống ghi nhận), phạm vi, báo cơ quan; GĐ quyết thu hồi / khoanh vùng và duyệt đóng hồ sơ; % thu hồi, nguyên nhân gốc. Lô thu hồi chỉ hủy. Lưu ≥ HSD + 12 tháng. Trạng thái áp dụng lệnh khóa lô theo từng nhà máy (Đã áp dụng lúc … / Chờ nhà máy áp dụng) đọc từ site_command KHOA_LO của hồ sơ (ref_table = recall_case, status, applied_at) — không thêm cột (04/11).

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc
- **QT:** QT26 o1 (QC trưởng tạo), y1, q1, d1, y3, gd, y4; QT23 r6 (quay lại GĐ)
- **Khóa chính:** `id`
- **Khóa ngoại:** `factory_id` → `factory.id` · `trace_request_id` → `trace_request.id` · `risk_assessed_by` → `app_user.id` · `decided_by` → `app_user.id` · `close_approved_by` → `app_user.id`
- **Unique:** `(code)`
- **Check:** `(decision is null) = (decided_by is null)` · `status <> 'DA_DONG' or closed_at is not null` · `status <> 'DA_DONG' or close_approved_by is not null`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `code` | text | có |  |
| `factory_id` | uuid |  | → factory |
| `source` | text | có | giá trị: KHACH_BAO / QT23 / QT25 / NVL_LOI / CO_QUAN |
| `trace_request_id` | uuid |  | → trace_request |
| `hazard_level` | text |  | mức nguy hại — danh mục do nhà máy tự đặt |
| `scope` | text |  | giá trị: KHO / DAI_LY / NGUOI_DUNG |
| `qty_in_market` | numeric(14,3) |  | số lượng ngoài thị trường |
| `qty_in_stock` | numeric(14,3) |  | số lượng còn trong kho |
| `risk_assessment` | text |  |  |
| `risk_assessed_by` | uuid |  | QC trưởng (q1) · → app_user |
| `risk_assessed_at` | timestamptz |  |  |
| `proposed_decision` | text |  | giá trị: THU_HOI / KHOANH_VUNG |
| `decision` | text |  | giá trị: THU_HOI / KHOANH_VUNG |
| `decided_by` | uuid |  | GĐ ký · → app_user |
| `decided_at` | timestamptz |  |  |
| `deadline` | date |  | mặc định quyết định + 30 ngày |
| `root_cause` | text |  |  |
| `status` | text | có | giá trị: MO / DANG_THU / DA_XU_LY_LO / DA_DONG · mặc định 'MO' |
| `closed_at` | timestamptz |  |  |
| `close_approved_by` | uuid |  | Giám đốc duyệt đóng hồ sơ (gd) · → app_user |
| `close_approved_at` | timestamptz |  |  |
| `retain_until` | date |  |  |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `recall_lot`

Lô trong hồ sơ: lô nghi lỗi và lô liên quan (từ truy xuất, từ xung đột mất kết nối, NVL dư trả về), kết quả QC kiểm lại khi khoanh vùng.

- **Nơi:** Cloud chủ, sao xuống nhà máy — cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc
- **QT:** QT26 y1, y2, r5
- **Khóa chính:** `id`
- **Khóa ngoại:** `recall_case_id` → `recall_case.id` · `lot_id` → `lot.id` · `qc_request_id` → `qc_request.id`
- **Unique:** `(recall_case_id, lot_id)`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `recall_case_id` | uuid | có | → recall_case |
| `lot_id` | uuid | có | → lot |
| `role` | text | có | giá trị: NGHI_LOI / LIEN_QUAN |
| `added_from` | text | có | giá trị: BAN_DAU / TRUY_XUAT / XUNG_DOT / NVL_DU / QT23 |
| `qc_request_id` | uuid |  | → qc_request |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `recall_customer`

Khách trong hồ sơ: SL đã giao, SL thu về, thời điểm thông báo, lần nhắc cuối → % thu hồi = Σ thu về / Σ đã giao.

- **Nơi:** Chỉ cloud — chỉ cloud
- **QT:** QT26 t1, r2, y3
- **Khóa chính:** `id`
- **Khóa ngoại:** `recall_case_id` → `recall_case.id` · `customer_id` → `customer.id` · `lot_id` → `lot.id` · `notified_by` → `app_user.id`
- **Unique:** `(recall_case_id, customer_id, lot_id)`
- **Check:** `qty_recovered >= 0`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `recall_case_id` | uuid | có | → recall_case |
| `customer_id` | uuid | có | → customer |
| `lot_id` | uuid | có | → lot |
| `qty_delivered` | numeric(14,3) | có |  |
| `qty_recovered` | numeric(14,3) | có | mặc định 0 |
| `notified_at` | timestamptz |  |  |
| `notified_by` | uuid |  | CSKH (QT26 t1) · → app_user |
| `last_reminder_at` | timestamptz |  |  |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

### `recall_authority_report`

Báo cơ quan quản lý (bắt buộc theo luật), do QC trưởng gửi: báo đầu, cập nhật tiến độ, báo kết thúc.

- **Nơi:** Chỉ cloud — chỉ cloud
- **QT:** QT26 t0, y4
- **Khóa chính:** `id`
- **Khóa ngoại:** `recall_case_id` → `recall_case.id` · `file_id` → `file_attachment.id`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `recall_case_id` | uuid | có | → recall_case |
| `report_kind` | text | có | giá trị: BAN_DAU / TIEN_DO / KET_THUC |
| `sent_at` | timestamptz | có |  |
| `file_id` | uuid |  | → file_attachment |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `recall_resolution`

Sales đổi lô mới (đơn thay thế QT05) / hoàn tiền cho khách: số tiền GĐ hoặc KTT duyệt như hủy đơn, Kế toán ghi nhận ở QT10 (không duyệt thêm).

- **Nơi:** Chỉ cloud — chỉ cloud
- **QT:** QT26 t3
- **Khóa chính:** `id`
- **Khóa ngoại:** `recall_case_id` → `recall_case.id` · `customer_id` → `customer.id` · `sales_order_id` → `sales_order.id` · `voucher_id` → `payment_voucher.id` · `approved_by` → `app_user.id`
- **Check:** `kind <> 'DOI_LO' or sales_order_id is not null` · `status <> 'DA_DUYET' or kind <> 'HOAN_TIEN' or approved_by is not null` · `status <> 'TU_CHOI' or reject_reason is not null` · `voucher_id is null or status = 'DA_DUYET'` · `approved_by is null or approved_by <> created_by`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `recall_case_id` | uuid | có | → recall_case |
| `customer_id` | uuid | có | → customer |
| `kind` | text | có | giá trị: DOI_LO / HOAN_TIEN |
| `sales_order_id` | uuid |  | → sales_order |
| `voucher_id` | uuid |  | bản ghi nhận hoàn tiền (QT10 h1) · → payment_voucher |
| `amount` | numeric(18,2) |  |  |
| `approved_by` | uuid |  | GĐ hoặc KTT duyệt số tiền hoàn (một người là đủ, số tiền do người duyệt nhập) · → app_user |
| `approved_at` | timestamptz |  |  |
| `status` | text | có | hoàn tiền chờ GĐ / KTT duyệt (04/11); đổi lô vào thẳng DA_DUYET · giá trị: CHO_DUYET / DA_DUYET / TU_CHOI · mặc định 'CHO_DUYET' |
| `reject_reason` | text |  |  |

<sub>Cột chung: `created_at, created_by (dòng không sửa)`</sub>

### `capa`

Nguyên nhân gốc & hành động khắc phục (CAPA), QC lập, QC trưởng duyệt: NVL → trả NCC; SX → sửa công thức / thiết bị / thao tác; bao bì → NCC bao bì.

- **Nơi:** Chỉ cloud — chỉ cloud
- **QT:** QT26 q3, qa
- **Khóa chính:** `id`
- **Khóa ngoại:** `recall_case_id` → `recall_case.id` · `ncr_id` → `ncr.id` · `owner_id` → `app_user.id` · `supplier_return_id` → `supplier_return.id` · `approved_by` → `app_user.id`
- **Check:** `recall_case_id is not null or ncr_id is not null` · `status <> 'DA_DUYET' or approved_by is not null` · `approved_by is null or approved_by <> created_by`

| Cột | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `recall_case_id` | uuid |  | → recall_case |
| `ncr_id` | uuid |  | → ncr |
| `category` | text | có | giá trị: NVL / SAN_XUAT / BAO_BI / KHAC |
| `root_cause` | text | có |  |
| `action` | text | có |  |
| `owner_id` | uuid |  | → app_user |
| `due_date` | date |  |  |
| `done_at` | timestamptz |  |  |
| `supplier_return_id` | uuid |  | → supplier_return |
| `approved_by` | uuid |  | QC trưởng duyệt CAPA (qa) · → app_user |
| `approved_at` | timestamptz |  |  |
| `return_reason` | text |  | lý do QC trưởng trả lại (về DANG_LAM) |
| `status` | text | có | giá trị: MO / DANG_LAM / CHO_DUYET / DA_DUYET · mặc định 'MO' |

<sub>Cột chung: `created_at, created_by, updated_at, updated_by`</sub>

