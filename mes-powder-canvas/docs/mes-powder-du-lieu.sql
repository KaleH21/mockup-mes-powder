-- MES Powder — DDL + ràng buộc + dữ liệu nạp. Sinh cùng nguồn với claude/mes-powder-du-lieu.md (05/11/2026: theo mockup sau họp khách — phân quyền từng người (user_permission), khu chiết rót & đóng gói gộp 1 loại, NVL có quy cách đóng gói (material_pack, material_pack_level), mục khác của SP có loại ô nhập, hình thức công bố là lựa chọn thêm được, hồ sơ pháp lý sắp hết hạn ≤ 30 ngày, công thức bỏ dung sai và thông số trộn chuẩn, lệnh SX thêm % hao hụt và bỏ giấy tờ xuất xứ NVL, hợp đồng tải theo từng đơn, có hiệu lực từ – đến (bỏ Chờ ký HĐ), đơn sau QC đạt qua Chờ nhập kho → Chờ kế toán duyệt → Chờ xuất kho, bỏ Danh mục › Nhà cung cấp; 143 bảng. 04/11/2026: đồng bộ theo mockup — bỏ báo giá, PO kiểm COA & HSD + cọc / trả nốt, yêu cầu chuyển YCC- và phiếu chuyển "lập là chấp nhận", mô hình SP mới (quy cách nhiều tầng, mẫu nhãn, bản công bố), hồ sơ pháp lý chung, đơn vị có loại / quy đổi, nhiều kho điều phối, phạm vi quyền theo vai trò / theo quyền, vai trò Thủ kho điều phối, xóa bản ghi chưa dùng, bản lưu & nhật ký in; 140 bảng. 29/10/2026: bỏ mục tiêu thời gian truy xuất — trace_request bỏ target_hours, bỏ tham số trace.target_hours. 28/10/2026: bỏ vai trò Trưởng bộ phận và rà soát quyền hằng quý — bỏ access_review, access_review_line; ngừng mã danh mục do trưởng bên đề xuất duyệt, Kế hoạch tự ngừng — catalog_retire_request thêm NGUNG_TRUC_TIEP. 26/10/2026: mẫu lưu bỏ tủ / ngăn và điều kiện bảo quản — bỏ sample_storage_condition, retained_sample thêm note. 24/10/2026 đợt 12: lệnh Chờ NVL, nhu cầu mua do hệ thống tính, thời gian giao hàng NVL. Đợt 9: bỏ vị trí kệ — tồn theo lô × kho, trạng thái theo bao qua dòng tồn, hàng đang chuyển nằm trên phiếu chuyển; bỏ cảnh báo cận date, thêm ngưỡng hạn tối thiểu cho sản xuất; 24/10/2026: giao hàng chỉ ghi nhận — bỏ đợt giao, yêu cầu xuất bán từ đơn, ghi nhận theo phiếu xuất, một đơn nhiều hóa đơn; 20/10/2026 đợt 3: bản sao khách / đơn xuống nhà máy bỏ cột tiền, liên hệ, công nợ — sync_policy.masked_columns; đợt 2: chủ dữ liệu theo dòng cloud ↔ nhà máy — sync_policy, sync_outbox, site_command, command_inbox; trước đó 20/10: Admin không còn toàn quyền, menu suy ra từ quyền — bảng screen, screen_function; 19/10 đợt 4 — danh mục SP tách 4 danh mục phụ, đề nghị chuyển kho tự lập từ lệnh SX, xuất SX chỉ từ kho điều phối). Đã chạy trên PostgreSQL 16.

-- Phần DDL sinh tự động bằng claude/mes-powder-gen-du-lieu.py từ mô hình bảng trong trang "Sơ đồ dữ liệu MES Powder" (cùng nguồn với mục 10 của file md). Lượt 04/11 sửa tay đồng thời mô hình JSON, mục 10 và DDL (script sinh không có trên máy); lượt 05/11 sửa JSON rồi sinh lại khối create / comment của các bảng đổi.
-- Dữ liệu nạp vai trò / thao tác / Vai trò × Thao tác sinh bằng claude/mes-powder-gen-quyen.py từ mục "Vai trò × Chức năng" của file quy trình; dữ liệu nạp sync_policy sinh bằng script này.
create schema if not exists mes;
set search_path = mes;

create table factory (
  id uuid not null default gen_random_uuid(),
  code text not null,
  name text not null,
  unit_code_prefix text not null,
  address text,
  phone text,
  email text,
  status text not null default 'DANG_DUNG',
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (status in ('DANG_DUNG', 'NGUNG_DUNG')),
  unique (code),
  unique (unit_code_prefix),
  check (unit_code_prefix ~ '^[A-Z0-9]{1,4}$')
);
comment on table factory is 'Nhà máy. Mỗi nhà máy một tiền tố mã định danh để mã bao HH / thùng sinh ở 2 server nhà máy không bao giờ trùng nhau.';
comment on column factory.code is 'NM1, NM2';
comment on column factory.unit_code_prefix is 'tiền tố mã định danh, vd "A", "B"';
comment on column factory.address is 'địa chỉ nhà máy (in trên phiếu)';

create table work_area (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  code text not null,
  name text not null,
  area_type text not null,
  max_batch_kg numeric(12,3),
  supply_warehouse_id uuid,
  status text not null default 'DANG_DUNG',
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (area_type in ('HH', 'BTP', 'CHIET_ROT_DONG_GOI')),
  check (status in ('DANG_DUNG', 'NGUNG_DUNG')),
  unique (factory_id, code),
  check ((area_type in ('HH','BTP')) = (max_batch_kg is not null)),
  check (max_batch_kg is null or max_batch_kg > 0),
  check (area_type not in ('HH','BTP') or supply_warehouse_id is not null)
);
comment on table work_area is 'Khu vực làm việc, 3 loại: sản xuất nguyên liệu hỗn hợp (HH) / sản xuất bán thành phẩm (BTP) / chiết rót & đóng gói (gộp 1 khu — chốt 05/11). Khu HH, BTP có khối lượng mẻ tối đa và dàn silo riêng (equipment loại SILO, Admin cấu hình ngay trong khu — sửa 19/10 đợt 2). Loại lệnh SX theo khu; KL mẻ của lệnh ≤ mức tối đa của khu. Không đổi loại khu khi còn lệnh chưa hoàn thành (trigger); không xóa, chỉ ngừng dùng. Công nhân gắn khu; PC C# chỉ hiện lệnh / mẻ của khu; mỗi khu một hàng đợi phát lệnh. Sửa 04/11: mỗi khu chọn 1 kho điều phối cấp NVL (`supply_warehouse_id`); một kho điều phối cấp được cho nhiều khu, một nhà máy có nhiều kho điều phối.';
comment on column work_area.area_type is 'loại lệnh SX theo loại khu (HH / BTP); không đổi khi khu còn lệnh chưa hoàn thành (trigger)';
comment on column work_area.max_batch_kg is 'khối lượng mẻ tối đa (kg) — bắt buộc với khu HH / BTP; KL mẻ của lệnh không được vượt';
comment on column work_area.supply_warehouse_id is 'kho điều phối cấp NVL cho khu (chốt 04/11) — bắt buộc với khu HH / BTP; kho loại DIEU_PHOI cùng nhà máy (trigger)';

create table app_user (
  id uuid not null default gen_random_uuid(),
  employee_code text not null,
  full_name text not null,
  department text not null,
  job_title text not null,
  email text,
  phone text,
  home_factory_id uuid,
  is_worker boolean not null default false,
  work_area_id uuid,
  badge_code text,
  password_hash text,
  must_change_password boolean not null default true,
  status text not null default 'HOAT_DONG',
  lock_reason text,
  effective_date date not null,
  resign_date date,
  scheduled_lock_date date,
  last_login_at timestamptz,
  is_system boolean not null default false,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (status in ('HOAT_DONG', 'KHOA_TAM', 'DA_KHOA')),
  unique (employee_code),
  check (not is_worker or (work_area_id is not null and badge_code is not null)),
  check (scheduled_lock_date is null or resign_date is not null)
);
create unique index ux_app_user_0 on app_user (email) where email is not null;
create unique index ux_app_user_1 on app_user (phone) where phone is not null;
create unique index ux_app_user_2 on app_user (badge_code) where badge_code is not null;
comment on table app_user is 'Tài khoản, kể cả công nhân SX / đóng gói (tài khoản riêng, gắn khu vực làm việc). Đăng nhập web bằng mã NV + mật khẩu; quét thẻ NV chỉ ở PC xưởng (bỏ máy quét riêng — 19/10 đợt 2); thẻ của tài khoản đã khóa bị chặn ngay. Đăng nhập lần đầu / sau mật khẩu tạm: bắt đổi mật khẩu. Quy tắc mật khẩu cố định trong code (≥ 8 ký tự, có cả chữ và số), không phải tham số. Nghỉ việc thì đến ngày khóa HR đặt hệ thống tự khóa. Xóa được khi tài khoản chưa từng đăng nhập và chưa có giao dịch (chốt 04/11): trigger chặn khi đã có phiên đăng nhập, khóa ngoại chặn khi đã có dữ liệu trỏ tới; xóa thì gỡ luôn dòng gán vai trò và ghi nhật ký XOA. Có 1 tài khoản "Hệ thống" để ghi người tạo cho thao tác tự động.';
comment on column app_user.employee_code is 'mã NV (kiểm trùng)';
comment on column app_user.department is 'bộ phận';
comment on column app_user.job_title is 'chức danh';
comment on column app_user.home_factory_id is 'nhà máy chính; phạm vi quyền nằm ở user_role';
comment on column app_user.is_worker is 'công nhân SX / đóng gói';
comment on column app_user.work_area_id is 'bắt buộc với công nhân';
comment on column app_user.badge_code is 'mã thẻ NV: chỉ để đăng nhập PC xưởng; bắt buộc với công nhân, không bắt buộc với người khác; khi tạo tài khoản nhập tay mã in trên thẻ, không quét (05/11)';
comment on column app_user.password_hash is 'quy tắc mật khẩu cố định trong code: ≥ 8 ký tự, có cả chữ và số (không phải tham số)';
comment on column app_user.must_change_password is 'đăng nhập lần đầu / sau khi Admin cấp mật khẩu tạm: bắt đổi';
comment on column app_user.status is 'KHOA_TAM: quên mật khẩu / không đăng nhập; DA_KHOA: nghỉ việc';
comment on column app_user.effective_date is 'ngày hiệu lực';
comment on column app_user.resign_date is 'ngày nghỉ việc';
comment on column app_user.scheduled_lock_date is 'ngày khóa tài khoản HR đặt (mặc định = ngày nghỉ) — ô riêng, tách khỏi ngày nghỉ việc (04/11)';

create table role (
  id uuid not null default gen_random_uuid(),
  code text not null,
  name text not null,
  description text,
  admin_assign_only boolean not null default false,
  delegable boolean not null default false,
  factory_scope text not null default 'NHA_MAY_TAI_KHOAN',
  scope_factory_id uuid,
  status text not null default 'DANG_DUNG',
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (factory_scope in ('MOI_NHA_MAY', 'NHA_MAY_TAI_KHOAN', 'CO_DINH')),
  check (status in ('DANG_DUNG', 'NGUNG_DUNG')),
  unique (code),
  check ((factory_scope = 'CO_DINH') = (scope_factory_id is not null))
);
comment on table role is 'Vai trò — 19 vai trò nạp sẵn theo mục "Vai trò × Chức năng" (bỏ Trưởng bộ phận 28/10; thêm Thủ kho điều phối 04/11). Màn Vai trò × quyền sửa được (chốt 04/11): Admin sửa quyền của vai trò, phạm vi nhà máy của vai trò và của từng quyền. Quyền chỉ gán qua vai trò, không gán quyền lẻ. Vai trò Admin, Người truy xuất chỉ Admin gán; vai trò có quyền duyệt được ủy quyền tạm khi vắng.';
comment on column role.admin_assign_only is 'chỉ Admin gán được (Admin, Người truy xuất) — trigger kiểm khi gán';
comment on column role.delegable is 'vai trò ủy quyền tạm được (chốt 19/10): Giám đốc, Kế toán trưởng, Thủ kho trưởng, Trưởng BP Mua hàng, QC trưởng, Kế hoạch (bỏ Trưởng bộ phận 28/10)';
comment on column role.factory_scope is 'phạm vi nhà máy của vai trò (chốt 04/11): mọi nhà máy / nhà máy của tài khoản / cố định 1 nhà máy — áp cho các quyền để "Theo vai trò"';
comment on column role.scope_factory_id is 'nhà máy cố định (chỉ khi CO_DINH)';

create table permission (
  id uuid not null default gen_random_uuid(),
  function_code text not null,
  action text not null,
  qt_code text,
  description text not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (action in ('XEM', 'TAO', 'SUA', 'DUYET', 'HUY')),
  unique (function_code, action)
);
comment on table permission is 'Danh sách thao tác: chức năng (QT + bước) × hành động (xem / tạo / sửa / duyệt / hủy). Nạp sẵn từ bảng quyền 7 mảng của mục "Vai trò × Chức năng". Sửa 04/11: Admin thêm / sửa quyền ở Danh mục quyền; xóa được khi quyền chưa gán cho vai trò nào (khóa ngoại chặn).';
comment on column permission.function_code is 'QT + bước theo bảng Vai trò × Chức năng, vd QT14.d4; bước không có mã: QT01.#8';

create table role_permission (
  id uuid not null default gen_random_uuid(),
  role_id uuid not null,
  permission_id uuid not null,
  scope_mode text not null default 'THEO_VAI_TRO',
  scope_factory_id uuid,
  revoked_at timestamptz,
  revoked_by uuid,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (scope_mode in ('THEO_VAI_TRO', 'MOI_NHA_MAY', 'NHA_MAY_TAI_KHOAN', 'CO_DINH')),
  check ((scope_mode = 'CO_DINH') = (scope_factory_id is not null))
);
create unique index ux_role_permission_0 on role_permission (role_id, permission_id) where revoked_at is null;
comment on table role_permission is 'Bảng Vai trò × Thao tác, nạp sẵn theo mục "Vai trò × Chức năng" (Admin không còn mọi thao tác — chỉ quản trị và QT01.xa xem mọi màn). Sửa 04/11: Admin cấp / gỡ quyền trên màn Vai trò × quyền; mỗi quyền có phạm vi riêng: theo vai trò (dùng phạm vi của vai trò), mọi nhà máy, nhà máy của tài khoản, hoặc cố định 1 nhà máy. Gỡ quyền = ghi revoked_at, không xóa dòng.';
comment on column role_permission.scope_mode is 'phạm vi của quyền (chốt 04/11)';
comment on column role_permission.scope_factory_id is 'nhà máy cố định (chỉ khi CO_DINH)';

create table user_permission (
  id uuid not null default gen_random_uuid(),
  user_id uuid not null,
  permission_id uuid not null,
  effect text not null,
  revoked_at timestamptz,
  revoked_by uuid,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (effect in ('THEM', 'BO')),
  check (user_id <> created_by),
  check (revoked_by is null or revoked_by <> user_id)
);
create unique index ux_user_permission_0 on user_permission (user_id, permission_id) where revoked_at is null;
comment on table user_permission is 'Phân quyền từng người (chốt 05/11): vai trò cho bộ quyền gốc (role_permission); HR / Admin tick bỏ hoặc thêm từng quyền riêng cho 1 tài khoản — dòng THEM cấp thêm quyền ngoài vai trò, dòng BO gỡ 1 quyền của vai trò. Quyền thực của người = quyền các vai trò còn hiệu lực − BO + THEM (v_user_screen). Phạm vi nhà máy của quyền thêm theo phạm vi vai trò của người đó. Không ai tự phân quyền cho mình (check). Thôi áp dụng = ghi revoked_at, không xóa dòng; xóa tài khoản chưa dùng thì xóa luôn.';
comment on column user_permission.effect is 'THEM: thêm quyền ngoài bộ quyền gốc của vai trò; BO: bỏ 1 quyền của vai trò';

create table screen (
  id uuid not null default gen_random_uuid(),
  code text not null,
  module text not null,
  name text not null,
  sort_order integer not null,
  always_visible boolean not null default false,
  status text not null default 'DANG_DUNG',
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (module in ('TONG_QUAN', 'VIEC_CAN_LAM', 'BAN_HANG', 'MUA_HANG', 'KE_TOAN', 'KHO', 'SAN_XUAT', 'CHAT_LUONG', 'TRUY_XUAT_THU_HOI', 'HO_SO_BIEU_MAU', 'DANH_MUC', 'QUAN_TRI')),
  check (status in ('DANG_DUNG', 'NGUNG_DUNG')),
  unique (code)
);
comment on table screen is 'Màn hình của menu web (thêm 20/10): phân hệ, tên, thứ tự. Nạp sẵn từ mục "Màn × chức năng" (phần "Phân hệ & màn hình") của file quy trình. Menu hiện màn khi vai trò của người dùng có ít nhất 1 quyền ở các chức năng của màn (screen_function, view v_user_screen); phân hệ không còn màn nào thì ẩn. Không có màn quản lý: đổi = sửa file quy trình rồi sinh lại dữ liệu nạp.';
comment on column screen.code is 'mã màn, vd KHO_XUAT';
comment on column screen.module is 'phân hệ trên menu (12 phân hệ theo menu mockup 04/11 — thêm Tổng quan, Hồ sơ & biểu mẫu in)';
comment on column screen.sort_order is 'thứ tự trên menu';
comment on column screen.always_visible is 'hiện cho mọi người dùng, không xét quyền (Việc cần làm; Hồ sơ & biểu mẫu in — chỉ hiện phiếu của phân hệ có quyền, 04/11)';

create table screen_function (
  id uuid not null default gen_random_uuid(),
  screen_id uuid not null,
  function_code text not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  unique (screen_id, function_code)
);
comment on table screen_function is 'Màn × chức năng (thêm 20/10): các bước quy trình (permission.function_code) làm hoặc xem ở màn đó. Người dùng thấy màn khi một vai trò còn hiệu lực của họ có quyền (role_permission còn hiệu lực) ở ít nhất 1 chức năng của màn. QT01.xa (Admin · Giám đốc xem mọi màn) có ở mọi màn trừ Việc cần làm, Hồ sơ & biểu mẫu in. Sửa 04/11: bỏ cột warehouse_type (cờ @DIEU_PHOI) — Thủ kho điều phối là vai trò riêng.';
comment on column screen_function.function_code is 'mã chức năng của bảng quyền, vd QT15.d1 — phải có trong permission (trigger kiểm khi nạp)';

create table user_role (
  id uuid not null default gen_random_uuid(),
  user_id uuid not null,
  role_id uuid not null,
  scope_type text not null,
  factory_id uuid,
  warehouse_id uuid,
  work_area_id uuid,
  valid_from timestamptz not null default now(),
  valid_until timestamptz,
  delegation_id uuid,
  revoked_at timestamptz,
  revoked_by uuid,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (scope_type in ('TOAN_HT', 'NHA_MAY', 'KHO', 'KHU_VUC')),
  check ((scope_type = 'TOAN_HT' and factory_id is null and warehouse_id is null and work_area_id is null) or (scope_type = 'NHA_MAY' and factory_id is not null and warehouse_id is null and work_area_id is null) or (scope_type = 'KHO' and warehouse_id is not null and work_area_id is null) or (scope_type = 'KHU_VUC' and work_area_id is not null and warehouse_id is null)),
  check (user_id <> created_by),
  check (revoked_by is null or revoked_by <> user_id),
  check ((delegation_id is null) = (valid_until is null)),
  check (valid_until is null or valid_until > valid_from)
);
create unique index ux_user_role_0 on user_role (user_id, role_id, scope_type, factory_id, warehouse_id, work_area_id) nulls not distinct where revoked_at is null;
comment on table user_role is 'Gán vai trò cho tài khoản kèm phạm vi (vai trò cho bộ quyền gốc; quyền riêng từng người ở user_permission — 05/11): toàn hệ thống / nhà máy / kho / khu vực làm việc → Quyền = vai trò × thao tác × phạm vi. Đổi vai trò = thu hồi dòng cũ + thêm dòng mới trong 1 giao dịch. Không ai tự gán / tự gỡ vai trò của chính mình (check); vai trò chỉ Admin gán thì trigger kiểm người gán là Admin. Ủy quyền tạm sinh dòng có valid_until, đến hạn tự gỡ.';
comment on column user_role.valid_until is 'hết hạn — chỉ với vai trò ủy quyền tạm';
comment on column user_role.delegation_id is 'dòng sinh từ ủy quyền tạm';

create table user_delegation (
  id uuid not null default gen_random_uuid(),
  delegator_id uuid not null,
  role_id uuid not null,
  delegate_id uuid not null,
  scope_type text not null,
  factory_id uuid,
  warehouse_id uuid,
  work_area_id uuid,
  starts_at timestamptz not null,
  ends_at timestamptz not null,
  reason text,
  status text not null default 'HIEU_LUC',
  revoked_at timestamptz,
  revoked_by uuid,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (scope_type in ('TOAN_HT', 'NHA_MAY', 'KHO', 'KHU_VUC')),
  check (status in ('HIEU_LUC', 'HET_HAN', 'THU_HOI_SOM')),
  check (delegator_id <> delegate_id),
  check (ends_at > starts_at),
  check (delegate_id <> created_by),
  check (status = 'HIEU_LUC' or revoked_at is not null)
);
comment on table user_delegation is 'Ủy quyền tạm khi vắng (QT01 u1–u3): HR hoặc Admin giao 1 vai trò của người vắng cho người nhận trong khoảng ngày, bắt buộc ngày hết hạn. Lưu là sinh 1 dòng user_role tạm (valid_until = ngày hết hạn); đến hạn hệ thống tự gỡ, ghi nhật ký, báo cả 2 người. Người nhận vẫn không được duyệt phiếu mình tạo.';
comment on column user_delegation.delegator_id is 'người vắng';
comment on column user_delegation.role_id is 'vai trò ủy quyền (vai trò có delegable)';
comment on column user_delegation.delegate_id is 'người nhận';
comment on column user_delegation.scope_type is 'phạm vi = phạm vi vai trò đó của người vắng';
comment on column user_delegation.starts_at is 'ngày bắt đầu';
comment on column user_delegation.ends_at is 'ngày hết hạn (bắt buộc)';
comment on column user_delegation.status is 'HET_HAN: hệ thống tự gỡ khi đến hạn; màn hình hiện "Sắp bắt đầu" khi starts_at ở tương lai — suy ra từ ngày, không thêm giá trị trạng thái';
comment on column user_delegation.revoked_by is 'HR / Admin thu hồi sớm; hệ thống khi hết hạn';

create table job_title_role (
  id uuid not null default gen_random_uuid(),
  job_title text not null,
  role_id uuid not null,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  unique (job_title, role_id)
);
comment on table job_title_role is 'Bảng gợi ý Chức danh → Vai trò khi HR tạo tài khoản.';

create table user_session (
  id uuid not null default gen_random_uuid(),
  user_id uuid not null,
  factory_id uuid,
  device_type text not null,
  device_id text,
  login_method text not null,
  started_at timestamptz not null default now(),
  last_seen_at timestamptz,
  ended_at timestamptz,
  end_reason text,
  primary key (id),
  check (device_type in ('WEB', 'PC_CSHARP')),
  check (login_method in ('MAT_KHAU', 'QUET_THE')),
  check (end_reason in ('DANG_XUAT', 'HET_HAN', 'KHOA_TAI_KHOAN')),
  check (login_method <> 'QUET_THE' or device_type = 'PC_CSHARP')
);
create index ix_user_session_0 on user_session (user_id, ended_at);
comment on table user_session is 'Phiên đăng nhập (web, PC xưởng C#). Web: mã NV + mật khẩu; PC xưởng: quét thẻ NV (hoặc mã NV + mật khẩu). Không còn máy quét riêng (bỏ MAY_QUET 19/10 đợt 2). Khóa tài khoản → đóng mọi phiên, chặn thẻ.';
comment on column user_session.factory_id is 'null = phiên trên cloud';
comment on column user_session.device_type is 'PC_CSHARP = PC xưởng';
comment on column user_session.login_method is 'QUET_THE chỉ ở PC xưởng';

create table account_change_log (
  id uuid not null default gen_random_uuid(),
  user_id uuid,
  change_type text not null,
  roles_before jsonb,
  roles_after jsonb,
  detail jsonb,
  actor_id uuid not null,
  occurred_at timestamptz not null default now(),
  primary key (id),
  check (change_type in ('TAO', 'SUA_THONG_TIN', 'DOI_VAI_TRO', 'DAT_NGAY_KHOA', 'KHOA', 'MO_KHOA', 'CAP_MAT_KHAU', 'UY_QUYEN', 'HET_UY_QUYEN', 'XOA'))
);
create index ix_account_change_log_0 on account_change_log (user_id, occurred_at);
comment on table account_change_log is 'Nhật ký thay đổi tài khoản / vai trò: ai làm, loại, vai trò trước / sau, thời điểm.';
comment on column account_change_log.user_id is 'tài khoản bị thay đổi; trống khi tài khoản đã bị xóa (mã NV giữ ở detail — 04/11)';

create table audit_log (
  id uuid not null default gen_random_uuid(),
  table_name text not null,
  record_id uuid not null,
  action text not null,
  before_data jsonb,
  after_data jsonb,
  actor_id uuid,
  factory_id uuid,
  origin_site text not null,
  occurred_at timestamptz not null default now(),
  primary key (id),
  check (action in ('TAO', 'SUA', 'DOI_TRANG_THAI', 'KHOA', 'HUY')),
  check (origin_site in ('CLOUD', 'NM'))
);
create index ix_audit_log_0 on audit_log (table_name, record_id);
comment on table audit_log is 'Nhật ký thay đổi chung cho mọi bảng nghiệp vụ (dữ liệu trước / sau). Ghi bằng trigger.';

create table system_parameter (
  id uuid not null default gen_random_uuid(),
  param_key text not null,
  scope_type text not null default 'TOAN_HT',
  factory_id uuid,
  group_code text,
  value jsonb not null,
  default_value jsonb not null,
  unit text,
  qt_code text not null,
  description text not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (scope_type in ('TOAN_HT', 'NHA_MAY', 'NHOM')),
  check (unit in ('NGAY', 'GIO', 'PHUT', 'GIAY', 'VND', 'TY_LE', 'THANG', 'BAT_TAT', 'DANH_SACH')),
  check ((scope_type = 'NHA_MAY') = (factory_id is not null)),
  check ((scope_type = 'NHOM') = (group_code is not null))
);
create unique index ux_system_parameter_0 on system_parameter (param_key, factory_id, group_code) nulls not distinct;
comment on table system_parameter is 'Tham số cấu hình — mọi số trong mục "Tham số mặc định". Giá trị chung, có thể ghi đè theo nhà máy hoặc theo nhóm (TP / NVL / BTP / mã NVL). Lịch sử sửa nằm ở audit_log.';
comment on column system_parameter.group_code is 'vd TP, NVL, BTP hoặc mã NVL';

create table uom (
  code text not null,
  name text not null,
  uom_type text not null default 'DEM',
  base_uom_code text,
  factor numeric(18,6),
  conversion_note text,
  usage_note text,
  status text not null default 'DANG_DUNG',
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (code),
  check (uom_type in ('KHOI_LUONG', 'THE_TICH', 'DEM')),
  check (status in ('DANG_DUNG', 'NGUNG_DUNG')),
  check ((base_uom_code is null) = (factor is null)),
  check (factor is null or factor > 0),
  check (base_uom_code is null or base_uom_code <> code)
);
comment on table uom is 'Đơn vị tính — màn riêng Danh mục › Đơn vị (chốt 04/11, thay mục trong Tham số): loại, quy đổi về đơn vị gốc, trạng thái. Xóa được khi chưa có tham chiếu (khóa ngoại chặn); đã dùng thì ngừng dùng.';
comment on column uom.code is 'KG, G, BAO, THUNG, LON, CAI';
comment on column uom.uom_type is 'loại đơn vị';
comment on column uom.base_uom_code is 'đơn vị gốc để quy đổi (vd tấn → kg); trống = chính nó là gốc hoặc quy đổi theo NVL / quy cách';
comment on column uom.factor is '1 đơn vị này = factor × đơn vị gốc';
comment on column uom.conversion_note is 'quy đổi theo NVL / quy cách SP, vd "1 bao = 25 kg (theo NVL)"';
comment on column uom.usage_note is 'dùng ở đâu';

create table material (
  id uuid not null default gen_random_uuid(),
  code text not null,
  name text not null,
  material_group text not null,
  uom_code text not null,
  shelf_life_days integer not null,
  storage_condition text not null,
  purchase_lead_days integer,
  coa_required boolean not null default true,
  min_stock_qty numeric(14,3),
  replenish_method text,
  image_file_ids uuid[] not null default '{}',
  incompatible_material_ids uuid[] not null default '{}',
  note text,
  produced_by_formula_id uuid,
  uom_locked boolean not null default false,
  status text not null default 'DANG_DUNG',
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (material_group in ('BOT', 'PHU_GIA', 'BAO_BI', 'HON_HOP')),
  check (status in ('DANG_DUNG', 'NGUNG_DUNG')),
  unique (code),
  check (shelf_life_days > 0),
  check ((material_group = 'HON_HOP') = (produced_by_formula_id is not null)),
  check (purchase_lead_days is null or purchase_lead_days >= 0),
  check (cardinality(image_file_ids) <= 5),
  check (not (id = any(incompatible_material_ids))),
  check (min_stock_qty is null or min_stock_qty >= 0)
);
comment on table material is 'Danh mục NVL: bột, phụ gia, bao bì (lon, thùng, nắp…). Mã đã có giao dịch thì khóa ĐVT (QT02 f1). Lô bao bì là lô của NVL nhóm BAO_BI. Sửa 04/11: tối đa 5 ảnh, nguyên liệu kỵ nhau (chọn nhiều), tồn tối thiểu + cách bù, ghi chú; sửa 05/11: quy cách đóng gói nhiều cấp (material_pack) như SP; NVL (trừ HON_HOP) bắt buộc ít nhất 1 chỉ tiêu COA đang dùng (trigger kiểm lúc COMMIT).';
comment on column material.code is 'hệ thống tự sinh theo code_format, vd NVL-BOT-0001; không sửa';
comment on column material.material_group is 'vào mã: BOT → BOT, PHU_GIA → PGA, BAO_BI → BBI, HON_HOP → HHP; HON_HOP = NVL hỗn hợp (bao HH) — tạm đặt ở đây, xem câu hỏi';
comment on column material.shelf_life_days is 'HSD chuẩn';
comment on column material.purchase_lead_days is 'thời gian NCC giao hàng mặc định (ngày) — tính ngày cần của yêu cầu mua; null → tham số purchase.default_lead_days (24/10 đợt 12)';
comment on column material.min_stock_qty is 'tồn tối thiểu (ĐVT của NVL) — phần thiếu vào nhu cầu mua';
comment on column material.replenish_method is 'cách bù khi dưới tồn tối thiểu (Kế hoạch đặt, hệ thống tự bù theo cách này)';
comment on column material.image_file_ids is 'ảnh NVL, tối đa 5 (chốt 30/10)';
comment on column material.incompatible_material_ids is 'nguyên liệu kỵ nhau, chọn nhiều (chốt 30/10)';
comment on column material.produced_by_formula_id is 'chỉ với HON_HOP';
comment on column material.uom_locked is 'đã có giao dịch → không đổi ĐVT';

create table material_spec_item (
  id uuid not null default gen_random_uuid(),
  material_id uuid not null,
  criterion_code text not null,
  criterion_name text not null,
  unit text,
  value_type text not null,
  min_value numeric,
  max_value numeric,
  expected_text text,
  used_for_coa boolean not null default true,
  used_for_qc boolean not null default true,
  sort_order integer not null default 0,
  status text not null default 'DANG_DUNG',
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (value_type in ('SO', 'CHU', 'DAT_KHONG')),
  check (status in ('DANG_DUNG', 'NGUNG_DUNG')),
  check (min_value is null or max_value is null or min_value <= max_value)
);
create unique index ux_material_spec_item_0 on material_spec_item (material_id, criterion_code) where status = 'DANG_DUNG';
comment on table material_spec_item is 'Bộ chỉ tiêu COA và giới hạn của từng NVL (nhà máy tự nhập). Kiểm COA tự động khi nhập (QT14) và so kết quả QC NVL (QT22). Kết quả kiểm luôn chép lại giới hạn lúc kiểm, nên sửa giới hạn không làm sai kết quả cũ. Mỗi NVL mua (không phải HON_HOP) bắt buộc ít nhất 1 chỉ tiêu COA (chốt 04/11). Kiểm COA & HSD trước khi lập PO dùng bộ này (purchase_order_coa_result).';

create table material_pack (
  id uuid not null default gen_random_uuid(),
  material_id uuid not null,
  line_no integer not null,
  pack_tool text not null,
  status text not null default 'DANG_DUNG',
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (status in ('DANG_DUNG', 'NGUNG_DUNG')),
  unique (material_id, line_no),
  check (line_no > 0)
);
comment on table material_pack is 'Quy cách đóng gói của 1 NVL (chốt 05/11, cùng kiểu quy cách SP): 1 NVL có ít nhất 1 quy cách; mỗi quy cách chọn dụng cụ đóng gói (Bao / Thùng / Túi / Chai…) và các cấp (material_pack_level, vd Túi → Thùng). Dụng cụ và tên cấp chọn từ danh sách, thêm được qua "+ Khác". NVL đã có lô nhập thì khóa quy cách cũ; xóa được khi chưa dùng (khóa ngoại chặn).';
comment on column material_pack.line_no is 'thứ tự quy cách trong NVL';
comment on column material_pack.pack_tool is 'dụng cụ đóng gói cấp trong cùng, vd Bao / Thùng / Túi / Chai';

create table material_pack_level (
  id uuid not null default gen_random_uuid(),
  pack_id uuid not null,
  level_no integer not null,
  unit_name text not null,
  child_qty integer,
  net_qty numeric(12,3),
  net_uom_code text,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  unique (pack_id, level_no),
  check (level_no > 0),
  check ((level_no = 1) = (child_qty is null)),
  check (child_qty is null or child_qty > 0),
  check (level_no <> 1 or (net_qty is not null and net_uom_code is not null)),
  check (net_qty is null or net_qty > 0)
);
comment on table material_pack_level is 'Cấp của quy cách NVL (chốt 05/11): cấp 1 = đơn vị nhỏ nhất (bao / túi / chai) có khối lượng tịnh (bao bì: số cái); cấp trên ghi số đơn vị cấp dưới (vd 1 thùng = 10 túi). Không trộn khối lượng, thể tích và số cái trong một quy cách.';
comment on column material_pack_level.level_no is '1 = trong cùng';
comment on column material_pack_level.unit_name is 'tên đơn vị của cấp, vd Bao, Túi, Thùng';
comment on column material_pack_level.child_qty is 'số đơn vị tầng dưới trong 1 đơn vị tầng này (tầng 1 để trống)';
comment on column material_pack_level.net_qty is 'khối lượng / thể tích tịnh mỗi đơn vị — bắt buộc ở tầng 1';
comment on column material_pack_level.net_uom_code is 'mg / g / kg / yến / tạ / tấn / ml / l / cái (bao bì)';

create table product (
  id uuid not null default gen_random_uuid(),
  code text not null,
  name text not null,
  formula_id uuid not null,
  structure_option_id uuid not null,
  group_option_id uuid not null,
  class_option_id uuid,
  age_option_id uuid,
  company_name text not null,
  made_at_factory_id uuid,
  extra_attributes jsonb not null default '[]',
  shelf_life_days integer not null,
  can_barcode text,
  uom_locked boolean not null default false,
  status text not null default 'DANG_DUNG',
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (status in ('DANG_DUNG', 'NGUNG_DUNG')),
  unique (code),
  check (shelf_life_days > 0)
);
create unique index ux_product_0 on product (can_barcode) where can_barcode is not null;
comment on table product is 'Danh mục SP (mô hình mới chốt 04/11): 1 mã SP có nhiều quy cách đóng gói, mỗi quy cách nhiều tầng (product_pack, product_pack_level); ô Cấu trúc / Nhóm / Phân loại / Độ tuổi chọn từ product_option; thương hiệu và thông tin khác gõ tự do ở "mục khác" (extra_attributes). Mỗi quy cách một mẫu nhãn, QC trưởng duyệt (product_label); bản công bố và hồ sơ pháp lý riêng ở product_document, hồ sơ pháp lý chung ở legal_document. Sau khi lưu, thông tin SP, mục khác và quy cách khóa theo mã + barcode — muốn đổi thì sao chép thành mã mới; chỉ sửa mẫu nhãn và hồ sơ pháp lý. Nhiều SP dùng chung 1 công thức BTP. Lô BTP / TP gắn SP. Bộ chỉ tiêu thành phẩm ở product_spec_item.';
comment on column product.code is 'hệ thống tự sinh, vd SP-0001; không sửa';
comment on column product.formula_id is 'công thức BTP';
comment on column product.structure_option_id is 'Cấu trúc, vd Dạng bột / Dạng nước';
comment on column product.group_option_id is 'Nhóm, vd Sữa bột trẻ em';
comment on column product.class_option_id is 'Phân loại, vd Cao cấp / Trung cấp';
comment on column product.age_option_id is 'Độ tuổi, vd 1–3 tuổi';
comment on column product.company_name is 'tên công ty chủ sản phẩm (in trên nhãn)';
comment on column product.made_at_factory_id is 'nơi sản xuất';
comment on column product.extra_attributes is 'mục khác [{t, ty, v, unit, opts}] — ty: text / num / date / bool / list / long / file (loại ô nhập, 05/11); num có đơn vị, list có các lựa chọn; vd Thương hiệu: Nhãn A';
comment on column product.can_barcode is 'mã in sẵn trên bao bì lon để kiểm "đúng nhãn hiệu của mẻ"';

create table product_option (
  id uuid not null default gen_random_uuid(),
  option_kind text not null,
  name text not null,
  sort_order integer not null default 0,
  status text not null default 'DANG_DUNG',
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (option_kind in ('CAU_TRUC', 'NHOM', 'PHAN_LOAI', 'DO_TUOI', 'HINH_THUC_CONG_BO')),
  check (status in ('DANG_DUNG', 'NGUNG_DUNG')),
  check (sort_order >= 0)
);
create unique index ux_product_option_0 on product_option (option_kind, lower(name));
comment on table product_option is 'Lựa chọn của các ô chọn ở SP (chốt 04/11): Cấu trúc, Nhóm, Phân loại, Độ tuổi, Hình thức công bố (05/11 — mặc định Tự công bố, Đăng ký bản công bố; thêm được qua "+ Khác") — thay các danh mục thương hiệu / dòng / hạng. Xóa được khi chưa SP nào dùng (khóa ngoại chặn); đã dùng thì ngừng dùng.';

create table product_pack (
  id uuid not null default gen_random_uuid(),
  product_id uuid not null,
  line_no integer not null,
  pack_tool text not null,
  status text not null default 'DANG_DUNG',
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (status in ('DANG_DUNG', 'NGUNG_DUNG')),
  unique (product_id, line_no),
  check (line_no > 0)
);
comment on table product_pack is 'Quy cách đóng gói của 1 SP (chốt 04/11): 1 SP nhiều quy cách; mỗi quy cách chọn dụng cụ đóng gói và các tầng (product_pack_level, vd Lon → Thùng). Khóa theo mã SP sau khi lưu; xóa được khi chưa dùng (khóa ngoại chặn).';
comment on column product_pack.line_no is 'thứ tự quy cách trong SP';
comment on column product_pack.pack_tool is 'dụng cụ đóng gói tầng trong cùng, vd Lon / Hộp / Túi';

create table product_pack_level (
  id uuid not null default gen_random_uuid(),
  pack_id uuid not null,
  level_no integer not null,
  unit_name text not null,
  child_qty integer,
  net_qty numeric(12,3),
  net_uom_code text,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  unique (pack_id, level_no),
  check (level_no > 0),
  check ((level_no = 1) = (child_qty is null)),
  check (child_qty is null or child_qty > 0),
  check (level_no <> 1 or (net_qty is not null and net_uom_code is not null)),
  check (net_qty is null or net_qty > 0)
);
comment on table product_pack_level is 'Tầng của quy cách (chốt 04/11): tầng 1 = đơn vị nhỏ nhất (lon / gói) có khối lượng / thể tích tịnh; tầng trên ghi số đơn vị tầng dưới (vd 1 thùng = 24 lon).';
comment on column product_pack_level.level_no is '1 = trong cùng';
comment on column product_pack_level.unit_name is 'tên đơn vị của tầng, vd Lon, Thùng';
comment on column product_pack_level.child_qty is 'số đơn vị tầng dưới trong 1 đơn vị tầng này (tầng 1 để trống)';
comment on column product_pack_level.net_qty is 'khối lượng / thể tích tịnh mỗi đơn vị — bắt buộc ở tầng 1';
comment on column product_pack_level.net_uom_code is 'g / kg / ml / l';

create table product_label (
  id uuid not null default gen_random_uuid(),
  product_pack_id uuid not null,
  version_no integer not null,
  file_id uuid not null,
  status text not null default 'CHO_DUYET',
  approved_by uuid,
  approved_at timestamptz,
  reject_reason text,
  superseded_at timestamptz,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (status in ('CHO_DUYET', 'DA_DUYET', 'TU_CHOI')),
  unique (product_pack_id, version_no),
  check (status = 'CHO_DUYET' or (approved_by is not null and approved_at is not null)),
  check (status <> 'TU_CHOI' or reject_reason is not null),
  check (approved_by is null or approved_by <> created_by)
);
create unique index ux_product_label_0 on product_label (product_pack_id) where superseded_at is null;
comment on table product_label is 'Mẫu nhãn theo từng quy cách của SP (chốt 04/11): tải bản mới = dòng mới Chờ duyệt (bản cũ ghi superseded_at); QC trưởng duyệt. Lệnh BTP chỉ dùng quy cách có mẫu nhãn hiện hành đã duyệt.';
comment on column product_label.file_id is 'file mẫu nhãn (PDF / ảnh)';
comment on column product_label.approved_by is 'QC trưởng duyệt / từ chối';
comment on column product_label.superseded_at is 'có bản mới thay';

create table product_document (
  id uuid not null default gen_random_uuid(),
  product_id uuid not null,
  doc_kind text not null,
  declaration_option_id uuid,
  doc_type text,
  doc_no text not null,
  issued_date date,
  exp_date date,
  file_id uuid,
  status text not null default 'DANG_DUNG',
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (doc_kind in ('CONG_BO', 'RIENG')),
  check (status in ('DANG_DUNG', 'NGUNG_DUNG')),
  check (doc_kind <> 'CONG_BO' or (declaration_option_id is not null and issued_date is not null and file_id is not null)),
  check (doc_kind = 'CONG_BO' or declaration_option_id is null),
  check (exp_date is null or issued_date is null or exp_date > issued_date)
);
create unique index ux_product_document_0 on product_document (product_id) where doc_kind = 'CONG_BO' and status = 'DANG_DUNG';
comment on table product_document is 'Hồ sơ pháp lý riêng của 1 SP (chốt 04/11): bản công bố sản phẩm (bắt buộc với SP dùng cho lệnh BTP — tự công bố hoặc đăng ký bản công bố, số, ngày, file) và các hồ sơ riêng khác (loại, số, hạn, file). Hồ sơ dùng chung nhiều SP ở legal_document.';
comment on column product_document.doc_kind is 'CONG_BO: bản công bố sản phẩm; RIENG: hồ sơ riêng khác';
comment on column product_document.declaration_option_id is 'hình thức công bố (chỉ CONG_BO) — lựa chọn loại HINH_THUC_CONG_BO (05/11)';
comment on column product_document.doc_type is 'loại hồ sơ (RIENG)';
comment on column product_document.issued_date is 'ngày công bố / tiếp nhận / cấp';
comment on column product_document.exp_date is 'hết hạn (trống = không thời hạn)';

create table legal_document (
  id uuid not null default gen_random_uuid(),
  code text not null,
  name text not null,
  doc_type text not null,
  doc_no text not null,
  issuing_org text,
  issued_date date,
  exp_date date,
  remind_days integer not null default 60,
  scope text not null default 'TAT_CA',
  file_ids uuid[] not null default '{}',
  note text,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (scope in ('TAT_CA', 'NHA_MAY', 'CHON_SP')),
  unique (code),
  check (cardinality(file_ids) > 0),
  check (remind_days >= 0),
  check (exp_date is null or issued_date is null or exp_date > issued_date)
);
comment on table legal_document is 'Hồ sơ pháp lý chung (màn Danh mục › Hồ sơ pháp lý chung — chốt 04/11): giấy tờ doanh nghiệp, ATTP, chứng nhận thị trường, quảng cáo…; phạm vi áp dụng: mọi SP, SP của nhà máy, hoặc SP chọn (legal_document_scope). Hạn trống = không thời hạn; nhắc trước hạn N ngày. Trạng thái Hiệu lực / Sắp hết hạn (còn ≤ 30 ngày — chốt 05/11) / Hết hạn tính từ hạn, không lưu; màn có thanh cảnh báo số hồ sơ sắp hết hạn / đã hết hạn và lọc nhanh hồ sơ cần gia hạn. Xóa được (chưa có bảng nào trỏ tới).';
comment on column legal_document.code is 'HS-0001 (code_format HO_SO_PHAP_LY)';
comment on column legal_document.doc_type is 'vd Pháp lý doanh nghiệp, An toàn thực phẩm, Chứng nhận thị trường';
comment on column legal_document.issuing_org is 'cơ quan cấp';
comment on column legal_document.exp_date is 'trống = không thời hạn';
comment on column legal_document.remind_days is 'nhắc trước hạn N ngày (thông báo); trạng thái Sắp hết hạn cố định ≤ 30 ngày (05/11)';
comment on column legal_document.scope is 'NHA_MAY: SP sản xuất tại nhà máy chọn; CHON_SP: SP chọn';
comment on column legal_document.file_ids is 'các file của hồ sơ';

create table legal_document_scope (
  id uuid not null default gen_random_uuid(),
  legal_document_id uuid not null,
  factory_id uuid,
  product_id uuid,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check ((factory_id is null) <> (product_id is null))
);
create unique index ux_legal_document_scope_0 on legal_document_scope (legal_document_id, factory_id, product_id) nulls not distinct;
comment on table legal_document_scope is 'Phạm vi của hồ sơ pháp lý chung (chốt 04/11): mỗi dòng 1 nhà máy (scope NHA_MAY) hoặc 1 SP (scope CHON_SP).';
comment on column legal_document_scope.factory_id is 'scope NHA_MAY';
comment on column legal_document_scope.product_id is 'scope CHON_SP';

create table warehouse (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  code text not null,
  name text not null,
  warehouse_type text not null,
  manager_id uuid,
  status text not null default 'DANG_DUNG',
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (warehouse_type in ('TONG', 'DIEU_PHOI', 'BTP', 'MAU_QC', 'KHAC')),
  check (status in ('DANG_DUNG', 'NGUNG_DUNG')),
  unique (factory_id, code)
);
comment on table warehouse is 'Kho thuộc 1 nhà máy (kho tổng, kho điều phối, kho BTP, kho mẫu QC…). Sửa 04/11: một nhà máy có nhiều kho điều phối; mỗi khu HH / BTP chọn kho điều phối cấp NVL (work_area.supply_warehouse_id).';
comment on column warehouse.code is 'hệ thống tự sinh {nhà máy}-{loại kho}, kho thứ 2 trở đi cùng loại thêm số: NM1-DP, NM1-DP2 — một nhà máy có nhiều kho điều phối (chốt 04/11)';
comment on column warehouse.manager_id is 'người phụ trách';

create table equipment (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  code text not null,
  name text not null,
  equipment_type text not null,
  work_area_id uuid,
  location_text text,
  capacity_kg numeric(12,3),
  hard_material_id uuid,
  iot_source_ref text,
  status text not null default 'DANG_DUNG',
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (equipment_type in ('SILO', 'BON_TRON', 'MAY_CHIET', 'ROBOT', 'THANG_NANG', 'CAN_BANG_TAI', 'KHAC')),
  check (status in ('DANG_DUNG', 'BAO_TRI', 'NGUNG_DUNG')),
  unique (factory_id, code),
  check (equipment_type <> 'SILO' or (work_area_id is not null and capacity_kg > 0 and iot_source_ref is not null)),
  check (equipment_type = 'SILO' or (capacity_kg is null and hard_material_id is null and status <> 'BAO_TRI'))
);
create unique index ux_equipment_0 on equipment (iot_source_ref) where iot_source_ref is not null;
create unique index ux_equipment_1 on equipment (work_area_id, name) where equipment_type = 'SILO';
comment on table equipment is 'Thiết bị sản xuất (silo, bồn trộn, máy chiết, robot, thang nâng, cân băng tải). Sửa 19/10 (đợt 2): SILO là thiết bị duy nhất có màn quản lý — dàn silo của từng khu HH / BTP do Admin cấu hình trong Quản trị · Nhà máy & khu vực làm việc (thêm, sửa, bảo trì, ngừng dùng; không xóa): tên, sức chứa, gán cứng 1 NVL (tùy chọn), trạng thái Hoạt động / Bảo trì / Ngừng dùng, mã thiết bị trên SCADA. Thiết bị khác không có màn quản lý: do bên cung cấp thiết bị khai báo, nạp khi triển khai. Gộp silo vào bảng này (không tách bảng riêng) vì silo đã là dòng equipment: silo_charge / lot_link / batch_equipment_usage / batch_downtime đều trỏ equipment, iot_source_ref đã là mã SCADA — tách bảng thì trùng mã / tên / SCADA và phải đổi 4 khóa ngoại. Bỏ thiết bị đo (19/10). ĐIỂM NỐI IoT: iot_source_ref.';
comment on column equipment.code is 'mã theo danh sách của bên cung cấp thiết bị (silo: Admin đặt khi thêm silo)';
comment on column equipment.work_area_id is 'khu chứa thiết bị — bắt buộc với SILO (chỉ khu HH / BTP, trigger)';
comment on column equipment.location_text is 'vị trí';
comment on column equipment.capacity_kg is 'sức chứa (kg) — chỉ silo, bắt buộc; KL NVL / mẻ xếp vào silo không vượt';
comment on column equipment.hard_material_id is 'gán cứng 1 NVL (tùy chọn, chỉ silo): silo chỉ nhận NVL này';
comment on column equipment.iot_source_ref is 'mã thiết bị / tag gốc trên SCADA — bắt buộc với SILO; ĐIỂM NỐI IoT';
comment on column equipment.status is 'silo: DANG_DUNG = Hoạt động / BAO_TRI / NGUNG_DUNG; BAO_TRI chỉ cho silo. Silo chuyển bảo trì / ngừng dùng → lệnh MOI_TAO đang xếp NVL vào bị đánh dấu CAN_XEP_LAI (trigger); không chuyển BAO_TRI / NGUNG_DUNG khi silo còn nút SILO đang mở (còn bột của lệnh — trigger)';

create table formula (
  id uuid not null default gen_random_uuid(),
  code text not null,
  name text not null,
  formula_kind text not null,
  status text not null default 'DANG_DUNG',
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (formula_kind in ('HH', 'BTP')),
  check (status in ('DANG_DUNG', 'NGUNG_DUNG')),
  unique (code),
  check (code ~ ('^CT-' || formula_kind || '-[0-9]{4,}$'))
);
comment on table formula is 'Công thức (HH hoặc BTP), thuộc phân hệ Sản xuất. Mã do hệ thống tự sinh CT-{loại}-{4 số} (sửa 20/10 đợt 3: 2 → 4 số), không sửa. Nội dung nằm ở phiên bản. Sao chép (05/11): tạo công thức mới từ phiên bản hiện hành (thành phần, KL mẻ, mặt hàng) — mã mới cấp như tạo mới, không chép phiên bản / lịch sử.';
comment on column formula.code is 'hệ thống tự sinh CT-{loại}-{4 số} (loại HH / BTP, vd CT-HH-0001, CT-BTP-0002); không sửa';

create table formula_version (
  id uuid not null default gen_random_uuid(),
  formula_id uuid not null,
  version_no integer not null,
  batch_weight_kg numeric(12,3) not null,
  effective_from timestamptz not null default now(),
  superseded_at timestamptz,
  is_current boolean not null default true,
  note text,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  unique (formula_id, version_no),
  check (batch_weight_kg > 0)
);
create unique index ux_formula_version_0 on formula_version (formula_id) where is_current;
comment on table formula_version is 'Phiên bản công thức. Chỉ ghi nhận, không duyệt: lưu là có hiệu lực, bản cũ hết hiệu lực nhưng giữ nguyên để truy xuất; lệnh đã phát giữ phiên bản cũ. Không sửa dòng đã lưu. Bỏ thông số trộn chuẩn (thời gian, tốc độ) — chốt 05/11. Màn Công thức hiện lệnh nào đang chạy phiên bản cũ: production_order.formula_version_id trỏ tới phiên bản is_current = false, lệnh DANG_CHAY.';
comment on column formula_version.batch_weight_kg is 'KL mẻ';

create table formula_item (
  id uuid not null default gen_random_uuid(),
  formula_version_id uuid not null,
  line_no integer not null,
  material_id uuid not null,
  qty_kg numeric(12,3) not null,
  load_order integer,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  unique (formula_version_id, line_no),
  unique (formula_version_id, material_id),
  check (qty_kg > 0),
  check (load_order is null or load_order > 0)
);
create unique index ux_formula_item_0 on formula_item (formula_version_id, load_order) where load_order is not null;
comment on table formula_item is 'Thành phần của phiên bản: NVL (hoặc NVL hỗn hợp), KL / mẻ (bỏ dung sai — chốt 05/11). Tổng KL thành phần = KL mẻ (kiểm khi lưu, QT03 y1).';
comment on column formula_item.load_order is 'thứ tự nạp = thứ tự dòng trong công thức (đổi bằng nút lên / xuống — 05/11)';

create table label_incident (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  incident_type text not null,
  handling_unit_id uuid not null,
  new_handling_unit_id uuid,
  warehouse_id uuid,
  lot_id uuid,
  from_cancel boolean not null default false,
  confirmed_scan_at timestamptz,
  reprint_count smallint not null default 0,
  note text,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (incident_type in ('HONG', 'MAT', 'HUY')),
  check ((incident_type = 'MAT') = (new_handling_unit_id is not null)),
  check (incident_type <> 'MAT' or lot_id is not null),
  check (not from_cancel or incident_type = 'MAT'),
  check (incident_type <> 'MAT' or warehouse_id is not null)
);
comment on table label_incident is 'Sự cố tem (QT04, sửa 19/10 đợt 2: làm ở Kho · Tồn kho, không còn máy quét riêng): chọn dòng lô × kho → danh sách bao → Sự cố tem. Hỏng → in lại cùng mã, dán, quét xác nhận; mất → kho + lô lấy từ dòng tồn, chọn mã cũ để khóa, cấp mã mới cùng lô (in, dán, quét xác nhận); hủy → khóa mã, thu tem; hủy khi bao còn trong kho → ghi như tem mất (cấp mã mới, from_cancel). Mã mới vào cùng dòng tồn với mã cũ — mang trạng thái + lý do khóa của bao cũ (24/10 đợt 9). Mã cũ trỏ mã mới qua handling_unit.replaced_by_id; mã đã khóa bị quét ở bất kỳ màn nào → scan_log chặn, hiện mã thay thế.';
comment on column label_incident.handling_unit_id is 'mã cũ';
comment on column label_incident.new_handling_unit_id is 'mã mới (tem mất)';
comment on column label_incident.warehouse_id is 'kho của dòng tồn đã chọn ở Kho · Tồn kho (tem mất — bắt buộc)';
comment on column label_incident.lot_id is 'lô của dòng tồn đã chọn (tem mất — bắt buộc)';
comment on column label_incident.from_cancel is 'hủy tem khi bao còn trong kho → chuyển sang luồng tem mất';
comment on column label_incident.confirmed_scan_at is 'quét xác nhận tem mới / tem in lại (đầu đọc mã ở màn Kho)';

create table file_attachment (
  id uuid not null default gen_random_uuid(),
  factory_id uuid,
  storage_key text not null,
  file_name text not null,
  mime_type text not null,
  size_bytes bigint not null,
  sha256 text not null,
  kind text not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (kind in ('COA', 'ANH', 'HOP_DONG', 'PHU_LUC', 'BIEN_BAN', 'BAO_CAO', 'CHUNG_NHAN', 'KHAC')),
  unique (storage_key)
);
comment on table file_attachment is 'Tệp đính kèm (COA, ảnh, hợp đồng, phụ lục, biên bản, báo cáo). Bảng khác trỏ tới bằng cột *_file_id.';

create table document_snapshot (
  id uuid not null default gen_random_uuid(),
  factory_id uuid,
  doc_type text not null,
  source_table text not null,
  record_id uuid not null,
  doc_code text not null,
  file_id uuid not null,
  signed_by uuid,
  signed_at timestamptz not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id)
);
create unique index ux_document_snapshot_0 on document_snapshot (source_table, record_id, signed_at);
comment on table document_snapshot is 'Bản lưu của phiếu / biên bản / hóa đơn tại thời điểm ký (màn Hồ sơ & biểu mẫu in — chốt 04/11): in lại luôn từ bản lưu này, không dựng lại từ dữ liệu hiện tại.';
comment on column document_snapshot.factory_id is 'nhà máy của chứng từ (trống = cloud)';
comment on column document_snapshot.doc_type is 'loại biểu mẫu, vd Phiếu nhập kho, Hóa đơn bán hàng';
comment on column document_snapshot.source_table is 'bảng của chứng từ';
comment on column document_snapshot.doc_code is 'số phiếu';
comment on column document_snapshot.file_id is 'PDF bản lưu lúc ký';

create table document_print_log (
  id uuid not null default gen_random_uuid(),
  snapshot_id uuid not null,
  printed_by uuid not null,
  printed_at timestamptz not null default now(),
  copies integer not null default 1,
  reason text not null,
  reason_note text,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (reason in ('KHACH_YEU_CAU', 'THANH_TRA', 'BAN_CU_HONG', 'KHAC')),
  check (copies > 0),
  check (reason <> 'KHAC' or reason_note is not null)
);
comment on table document_print_log is 'Mỗi lần in lại bản lưu (chốt 04/11): đóng dấu BẢN SAO, ghi người in, ngày in, số bản, lý do — số lần in đếm từ đây.';

create table code_sequence (
  id uuid not null default gen_random_uuid(),
  factory_id uuid,
  code_type text not null,
  period text not null,
  last_value bigint not null default 0,
  owner_site text not null,
  primary key (id),
  check (owner_site in ('CLOUD', 'NM')),
  check (owner_site = 'CLOUD' or factory_id is not null)
);
create unique index ux_code_sequence_0 on code_sequence (factory_id, code_type, period) nulls not distinct;
comment on table code_sequence is 'Bộ đếm sinh mã: số phiếu (cloud), mã danh mục theo code_format (cloud — chỉ tăng, không dùng lại số của mã đã ngừng) và mã định danh bao HH / thùng (server nhà máy, có tiền tố nhà máy nên không trùng).';
comment on column code_sequence.code_type is 'vd PN (phiếu nhập), BAO_HH, THUNG, ME; mã danh mục: MA_NVL_BOT, MA_SP, MA_TB_CAN_NM1…; mã chứng từ nhà máy (20/10 đợt 2): PN, PX, PC, PK, PH, YCQC, PKQC, CN, ML — owner_site NM, factory_id bắt buộc';
comment on column code_sequence.period is 'yyyymm / yyyy / ''-'' nếu không theo kỳ';

create table code_format (
  id uuid not null default gen_random_uuid(),
  entity_type text not null,
  pattern text not null,
  tokens jsonb,
  counter_scope text,
  example text not null,
  status text not null default 'DANG_DUNG',
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (entity_type in ('NVL', 'SP', 'CT', 'KHO', 'PHIEU_NHAP', 'PHIEU_XUAT', 'PHIEU_CHUYEN', 'PHIEU_KIEM_KHO', 'PHIEU_HUY', 'YEU_CAU_KIEM', 'PHIEU_KIEM', 'CHUNG_NHAN', 'MAU_LUU', 'KHACH_HANG', 'NCC', 'MA_NV', 'LO_NVL', 'LO_BTP', 'LO_TP', 'DON_HANG', 'PO', 'NHU_CAU_MUA', 'YEU_CAU_CHUYEN', 'HO_SO_PHAP_LY')),
  check (status in ('DANG_DUNG', 'NGUNG_DUNG'))
);
create unique index ux_code_format_0 on code_format (entity_type) where status = 'DANG_DUNG';
comment on table code_format is 'Định dạng mã từng loại: hệ thống tự sinh mã theo mẫu, số thứ tự tự tăng (bộ đếm ở code_sequence), không dùng lại số của mã đã ngừng; mã mới không có bước duyệt. Danh mục: NVL, SP, công thức, kho, khách hàng, NCC, mã nhân viên, lô (NVL nội bộ, BTP, TP) — thêm 04/11 theo màn Định dạng mã; bỏ thương hiệu / dòng / hạng / quy cách (04/11). Chứng từ cloud: đơn hàng, PO, nhu cầu mua, yêu cầu chuyển YCC-, hồ sơ pháp lý. Chứng từ sinh tại máy chủ nhà máy có tiền tố nhà máy: PN-{NM}-{yymm}-{4 số}, PX-, PC-, kiểm kho PK-, PH-, yêu cầu kiểm YC-{NM}-, QC-, CN-, ML-.';
comment on column code_format.pattern is 'mẫu, vd NVL-{nhom}-{so:4}; {so:N} = số thứ tự N chữ số';
comment on column code_format.tokens is 'đổi giá trị trong danh mục → chữ trong mã, vd nhom: BOT→BOT, PHU_GIA→PGA, BAO_BI→BBI';
comment on column code_format.counter_scope is 'bộ đếm tính riêng theo phần nào của mã (vd nhom; loai + nha_may); null = 1 bộ đếm chung';
comment on column code_format.example is 'mã mẫu hiện ở màn hình cấu hình';

create table sync_policy (
  table_name text not null,
  owner_group text not null,
  factory_column text,
  derived_columns text[] not null default '{}',
  masked_columns text[] not null default '{}',
  note text,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (table_name),
  check (owner_group in ('CLOUD', 'CLOUD_ONLY', 'NM', 'NM_ONLY', 'NOI_PHAT_SINH'))
);
comment on table sync_policy is 'Nhóm đồng bộ từng bảng (thêm 20/10 đợt 2 — quyết định 34): ai là chủ, chiều đồng bộ, cột nhà máy dùng để xác định chủ dòng, cột dẫn xuất (do cloud chiếu từ dữ liệu nơi kia). Nạp sẵn từ mô hình bảng (cột Nơi của mục 10) bằng mes-powder-gen-du-lieu.py; trigger chặn ghi sai nơi và trigger ghi hàng đợi gửi lên đọc bảng này. Sửa 20/10 đợt 3: thêm masked_columns — cột cloud chủ nhưng không sao xuống nhà máy (bộ sao xuống bỏ đi qua hàm sync_down_row).';
comment on column sync_policy.table_name is 'tên bảng';
comment on column sync_policy.owner_group is 'CLOUD: cloud chủ, sao xuống phần nhà máy cần; CLOUD_ONLY: chỉ cloud; NM: máy chủ nhà máy của dòng làm chủ, sao lên; NM_ONLY: chỉ máy chủ nhà máy; NOI_PHAT_SINH: nơi tạo dòng là chủ, gộp lên cloud';
comment on column sync_policy.factory_column is 'cột xác định nhà máy chủ của dòng (thường factory_id); trống = theo dòng cha';
comment on column sync_policy.derived_columns is 'cột dẫn xuất: cloud chiếu từ dữ liệu nơi kia (vd SL đã nhận trên phiếu chuyển của nhà máy xuất); người dùng không sửa tay';
comment on column sync_policy.masked_columns is 'cột không sao xuống máy chủ nhà máy (bản sao nhà máy để trống) — tiền, liên hệ, công nợ của khách / đơn (quyết định 38)';

create table catalog_retire_request (
  id uuid not null default gen_random_uuid(),
  entity_table text not null,
  record_id uuid not null,
  department text not null,
  reason text not null,
  reference_check jsonb,
  status text not null default 'CHO_DUYET',
  approved_by uuid,
  approved_at timestamptz,
  reject_reason text,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (entity_table in ('material', 'product')),
  check (department in ('MUA_HANG', 'KE_HOACH', 'KHO', 'QC')),
  check (status in ('CHO_DUYET', 'DA_DUYET', 'TU_CHOI', 'DA_RUT', 'NGUNG_TRUC_TIEP')),
  check (approved_by is null or approved_by <> created_by),
  check (status <> 'DA_DUYET' or approved_by is not null),
  check (status <> 'TU_CHOI' or reject_reason is not null),
  check (status <> 'DA_RUT' or updated_by is not distinct from created_by),
  check ((department = 'KE_HOACH') = (status = 'NGUNG_TRUC_TIEP')),
  check (status <> 'NGUNG_TRUC_TIEP' or approved_by is null)
);
comment on table catalog_retire_request is 'Đề nghị ngừng dùng mã NVL / SP (QT02 nhánh dưới; bỏ 4 danh mục thương hiệu / dòng / hạng / quy cách 04/11 — lựa chọn của SP ngừng / xóa trực tiếp): bộ phận đề xuất gửi, hệ thống kiểm tham chiếu (tồn kho, phiếu đang mở, đơn mua đang mở, công thức hiệu lực; danh mục SP: còn SP ĐANG DÙNG), trưởng của bên đề xuất duyệt (sửa 28/10: Mua hàng → Trưởng BP Mua hàng, Kho → Thủ kho trưởng, QC → QC trưởng; hiện trong Việc cần làm) → mã NGỪNG DÙNG. Kế hoạch tự ngừng không qua duyệt (QT02 tk): dòng lập thẳng ở NGUNG_TRUC_TIEP, mã NGỪNG DÙNG ngay — vẫn kiểm tham chiếu, giữ người + lý do làm dấu vết. Người đề xuất rút được khi đang chờ duyệt (DA_RUT — chỉ người tạo, check). Kho không qua đề nghị: Admin làm trực tiếp.';
comment on column catalog_retire_request.entity_table is 'bảng danh mục';
comment on column catalog_retire_request.record_id is 'dòng danh mục xin ngừng';
comment on column catalog_retire_request.department is 'bộ phận đề xuất (Mua hàng / Kế hoạch / Kho / QC) — quyết người duyệt: MUA_HANG → Trưởng BP Mua hàng, KHO → Thủ kho trưởng, QC → QC trưởng; KE_HOACH tự ngừng (28/10)';
comment on column catalog_retire_request.reference_check is 'kết quả kiểm tham chiếu lúc gửi (y3): tồn kho, phiếu đang mở, đơn mua đang mở, công thức hiệu lực; danh mục SP: SP ĐANG DÙNG tham chiếu';
comment on column catalog_retire_request.status is 'NGUNG_TRUC_TIEP: Kế hoạch tự ngừng, không qua duyệt (28/10)';
comment on column catalog_retire_request.approved_by is 'trưởng bên đề xuất (d4): Trưởng BP Mua hàng / Thủ kho trưởng / QC trưởng theo department (sửa 28/10)';

create table lot (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  lot_no text not null,
  lot_kind text not null,
  material_id uuid,
  product_id uuid,
  production_batch_id uuid,
  production_order_id uuid,
  silo_equipment_id uuid,
  silo_emptied_at timestamptz,
  supplier_id uuid,
  supplier_lot_no text,
  mfg_date date,
  exp_date date,
  uom_code text not null,
  coa_file_id uuid,
  source_lot_id uuid,
  expired_note boolean not null default false,
  converted_to_tp_at timestamptz,
  origin_site text not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (lot_kind in ('NVL_MUA', 'HH', 'ME', 'SILO', 'BTP', 'TP', 'HONG')),
  check (origin_site in ('CLOUD', 'NM')),
  check ((lot_kind in ('NVL_MUA','HH') and material_id is not null and product_id is null) or (lot_kind in ('BTP','TP') and product_id is not null and material_id is null) or (lot_kind = 'ME' and production_batch_id is not null and material_id is null and product_id is null) or (lot_kind = 'HONG' and production_batch_id is not null and material_id is null and product_id is null) or (lot_kind = 'SILO' and material_id is not null and product_id is null)),
  check (lot_kind <> 'NVL_MUA' or source_lot_id is not null or (supplier_id is not null and supplier_lot_no is not null and mfg_date is not null and exp_date is not null)),
  check (lot_kind in ('ME','HONG','SILO') or exp_date is not null),
  check (exp_date is null or mfg_date is null or exp_date > mfg_date),
  check (lot_kind <> 'TP' or converted_to_tp_at is not null),
  check ((lot_kind = 'SILO') = (silo_equipment_id is not null and production_order_id is not null)),
  check (silo_emptied_at is null or lot_kind = 'SILO')
);
create unique index ux_lot_0 on lot (factory_id, lot_no, material_id, product_id) nulls not distinct;
create unique index ux_lot_1 on lot (production_order_id, silo_equipment_id) where lot_kind = 'SILO' and silo_emptied_at is null;
create index ix_lot_0 on lot (exp_date);
comment on table lot is 'Lô. Một mã lô cho mọi phần ở mọi kho. TRẠNG THÁI KHÔNG NẰM Ở ĐÂY mà ở dòng tồn lô × kho (stock_line) — mỗi bao / thùng nằm ở đúng 1 dòng tồn nên trạng thái theo từng bao (24/10 đợt 9). Lô mẻ (ME) là nút trung gian của chuỗi liên kết, không có tồn. BTP đạt QC đổi thành TP trên cùng dòng (đổi lot_kind). Hàng khách trả, thu hồi, tìm lại sau thất lạc dùng lại lô cũ; NVL dư trả về là lô mới trỏ về lô gốc. Bột hỏng của mẻ hủy do sự cố là lô HONG nối từ lô mẻ (RA_ME), KHÓA chờ hủy ngay khi sinh ra. Sửa 19/10 (đợt 3): silo nạp một lần dùng cho nhiều mẻ → mỗi silo của lệnh là 1 nút SILO (như lô mẻ, không tồn): lô NVL —nạp silo→ SILO —xả→ lô mẻ; silo xả sạch thì đóng nút (silo_emptied_at), lần nạp sau mở nút mới; mỗi lệnh × silo chỉ 1 nút đang mở. Bột dư cuối lệnh là lô NVL dư mới trỏ về nút SILO. Sửa 24/10 (đợt 9): bỏ cận date; số ngày còn lại, hết hạn, dưới ngưỡng SX không lưu — view v_lot_shelf tính từ exp_date + tham số production.min_shelf_days, mỗi nơi tự tính.';
comment on column lot.lot_no is 'mã lô; BTP / TP = số lô in sẵn trên lon';
comment on column lot.lot_kind is 'HONG: bột hỏng của mẻ hủy do sự cố (QT20), không HSD, chỉ đi hủy. SILO: nút silo của lệnh (19/10 đợt 3) — không tồn, không HSD';
comment on column lot.material_id is 'NVL_MUA, HH';
comment on column lot.product_id is 'BTP, TP';
comment on column lot.production_batch_id is 'ME: mẻ của nó; HH / BTP / HONG: mẻ sinh ra';
comment on column lot.production_order_id is 'SILO: lệnh của nút silo';
comment on column lot.silo_equipment_id is 'SILO: silo của nút';
comment on column lot.silo_emptied_at is 'SILO: thời điểm silo xả sạch — đóng nút, lần nạp sau mở nút mới (bột trong nút phải = 0, trigger)';
comment on column lot.supplier_lot_no is 'số lô NCC';
comment on column lot.mfg_date is 'NSX';
comment on column lot.exp_date is 'HSD';
comment on column lot.source_lot_id is 'NVL dư trả về: lô gốc; bột dư xả từ silo: nút SILO';
comment on column lot.expired_note is 'ghi chú "đã hết hạn" trên lô KHÔNG ĐẠT';
comment on column lot.converted_to_tp_at is 'BTP → TP (QT23)';

create table handling_unit (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  code text not null,
  unit_type text not null,
  lot_id uuid not null,
  qty numeric(12,3) not null,
  uom_code text not null,
  stock_line_id uuid,
  production_batch_id uuid,
  filling_run_id uuid,
  receipt_line_id uuid,
  label_status text not null default 'KICH_HOAT',
  replaced_by_id uuid,
  source_event_id uuid,
  origin_site text not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (unit_type in ('BAO_NVL', 'BAO_HH', 'THUNG')),
  check (label_status in ('KICH_HOAT', 'KHOA')),
  check (origin_site in ('CLOUD', 'NM')),
  unique (code),
  check (qty > 0),
  check (unit_type <> 'THUNG' or filling_run_id is not null),
  check (unit_type <> 'BAO_HH' or production_batch_id is not null),
  check (unit_type <> 'BAO_NVL' or receipt_line_id is not null)
);
create unique index ux_handling_unit_0 on handling_unit (source_event_id) where source_event_id is not null;
comment on table handling_unit is 'Mã định danh, TÁCH KHỎI LÔ: bao NVL, bao HH, thùng — 1 lô có nhiều mã. Lon KHÔNG có dòng ở đây: lon dùng mã in sẵn trên bao bì, hệ thống không cấp. Mã chỉ là định danh + tra CSDL, không nhúng loại / ngày.';
comment on column handling_unit.code is 'tiền tố nhà máy + số tăng dần';
comment on column handling_unit.qty is 'kg (bao) / số lon (thùng)';
comment on column handling_unit.stock_line_id is 'dòng tồn (lô × kho × trạng thái) đang chứa mã này — trạng thái của bao = trạng thái dòng tồn; đổi trạng thái 1 bao = chuyển bao sang dòng khác (24/10 đợt 9); null khi đã xuất / đã dùng';
comment on column handling_unit.production_batch_id is 'mẻ sinh ra (bao HH, thùng)';
comment on column handling_unit.filling_run_id is 'thùng: lượt chiết của nhãn hiệu';
comment on column handling_unit.receipt_line_id is 'bao NVL: dòng phiếu nhập';
comment on column handling_unit.label_status is 'trạng thái mã tem, không phải trạng thái lô';
comment on column handling_unit.replaced_by_id is 'tem mất → mã mới (QT04)';
comment on column handling_unit.source_event_id is 'sự kiện tạo ra (bỏ trùng khi đồng bộ)';

create table stock_line (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  lot_id uuid not null,
  warehouse_id uuid,
  stock_transfer_id uuid,
  qty numeric(14,3) not null,
  uom_code text not null,
  status text not null,
  lock_reason text,
  prev_status text,
  prev_lock_reason text,
  version integer not null default 1,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (status in ('CHO_KIEM', 'DAT', 'KHONG_DAT', 'KHOA', 'HUY')),
  check (prev_status in ('CHO_KIEM', 'DAT', 'KHONG_DAT', 'KHOA')),
  check ((status = 'KHOA') = (lock_reason is not null)),
  check (qty >= 0),
  check ((warehouse_id is null) = (stock_transfer_id is not null))
);
create unique index ux_stock_line_0 on stock_line (lot_id, warehouse_id, stock_transfer_id, status, lock_reason) nulls not distinct;
create index ix_stock_line_0 on stock_line (warehouse_id);
create index ix_stock_line_1 on stock_line (lot_id, status);
comment on table stock_line is 'Tồn theo lô × kho (sửa 24/10 đợt 9 — bỏ vị trí kệ; thay "phần lô × vị trí"). TRẠNG THÁI LÔ GẮN Ở ĐÂY (vòng đời lô hàng, chốt 16/10). Mỗi dòng = 1 lô × 1 kho (hoặc 1 phiếu chuyển khi hàng đang chuyển) × 1 trạng thái × 1 lý do khóa. Mỗi bao / thùng (handling_unit.stock_line_id) nằm ở đúng 1 dòng, nên trạng thái theo từng bao: cùng lô cùng kho vẫn tách được bao ĐẠT và bao KHÓA (vd hư khi nhận, chờ hủy). Đổi trạng thái 1 phần / 1 bao = chuyển SL (và bao) sang dòng khác + ghi lot_status_log + 2 dòng inventory_txn. Hàng đang chuyển: warehouse_id null, stock_transfer_id = phiếu chuyển — không thuộc kho nào, không tính tồn dùng được.';
comment on column stock_line.warehouse_id is 'null khi hàng đang chuyển (nằm trên phiếu chuyển)';
comment on column stock_line.stock_transfer_id is 'hàng đang chuyển: phiếu chuyển đang chở — thay vị trí "trên xe" (24/10 đợt 9)';
comment on column stock_line.lock_reason is 'bắt buộc khi KHÓA';
comment on column stock_line.prev_status is 'trạng thái trước — để "về trạng thái trước" khi QC trưởng / Thủ kho trưởng từ chối';
comment on column stock_line.version is 'khóa lạc quan';

create table lock_reason (
  code text not null,
  name text not null,
  scope text not null,
  applies_to text not null,
  allow_qc boolean not null,
  allowed_exits text[] not null,
  strictness smallint not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (code),
  check (scope in ('RIENG_PHAN', 'CA_LO', 'PHAN_TREN_PHIEU'))
);
comment on table lock_reason is 'Danh mục 9 lý do khóa (bảng "Lý do khóa"): phạm vi, có cho gửi QC không, lối ra được phép, độ chặt (2 lý do cùng lúc → lấy lý do chặt hơn).';
comment on column lock_reason.applies_to is 'loại lô áp dụng';
comment on column lock_reason.allowed_exits is 'QC / HUY / TRA_NCC / VE_TRUOC / HO_SO_THU_HOI';
comment on column lock_reason.strictness is 'số lớn hơn = chặt hơn';

create table lot_status_transition (
  id uuid not null default gen_random_uuid(),
  from_status text,
  to_status text not null,
  lock_reason text,
  qt_code text not null,
  step_code text not null,
  actor_rule text not null,
  condition_text text not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (from_status in ('CHO_KIEM', 'DAT', 'KHONG_DAT', 'KHOA')),
  check (to_status in ('CHO_KIEM', 'DAT', 'KHONG_DAT', 'KHOA', 'HUY'))
);
comment on table lot_status_transition is 'Bảng chuyển trạng thái hợp lệ — chép đúng bảng chuyển trạng thái của mục "Vòng đời lô hàng", tách mỗi trạng thái nguồn thành 1 dòng. Tầng ứng dụng chỉ cho đổi trạng thái khi khớp 1 dòng ở đây; nhật ký trỏ về dòng đã dùng.';
comment on column lot_status_transition.from_status is 'null = lô mới';
comment on column lot_status_transition.lock_reason is 'lý do khi sang KHÓA';

create table lot_lock (
  id uuid not null default gen_random_uuid(),
  factory_id uuid,
  lot_id uuid not null,
  lock_reason text not null,
  recall_case_id uuid,
  sync_conflict_id uuid,
  site_command_id uuid,
  applied_at timestamptz,
  released_at timestamptz,
  released_by uuid,
  release_note text,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id)
);
create unique index ux_lot_lock_0 on lot_lock (lot_id, lock_reason, factory_id) nulls not distinct where released_at is null;
comment on table lot_lock is 'Khóa CẢ LÔ (khoanh vùng, xung đột, thu hồi, hết hạn): áp lên mọi phần của lô, kể cả phần nhập lại về sau (NVL dư, hàng thu hồi). Mở khóa = ghi released_at. Sửa 20/10 (đợt 2): dòng khóa do máy chủ nhà máy ghi (nhà máy chủ tồn & trạng thái lô); thu hồi / khoanh vùng từ trung tâm là lệnh KHOA_LO (site_command) — nhà máy áp dụng thì ghi dòng ở đây kèm site_command_id; lô có phần ở 2 nhà máy thì mỗi nhà máy 1 dòng.';
comment on column lot_lock.factory_id is 'nhà máy áp dụng khóa (dòng ghi tại máy chủ nhà máy); trống = dòng cũ / ghi ở cloud trước 20/10';
comment on column lot_lock.site_command_id is 'lệnh KHÓA LÔ từ trung tâm sinh ra dòng này (thu hồi / khoanh vùng — QT26); trống = nhà máy tự khóa (hết hạn, NVL dư, xung đột)';
comment on column lot_lock.applied_at is 'thời điểm máy chủ nhà máy áp dụng';

create table lot_status_log (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  lot_id uuid not null,
  stock_line_id uuid,
  warehouse_id uuid,
  handling_unit_ids uuid[],
  qty numeric(14,3),
  from_status text,
  from_lock_reason text,
  to_status text not null,
  to_lock_reason text,
  qt_code text not null,
  step_code text not null,
  transition_id uuid not null,
  actor_id uuid not null,
  occurred_at timestamptz not null default now(),
  ref_table text,
  ref_id uuid,
  reason_text text,
  attachment_file_id uuid,
  source_event_id uuid,
  primary key (id),
  check (from_status in ('CHO_KIEM', 'DAT', 'KHONG_DAT', 'KHOA', 'HUY')),
  check (to_status in ('CHO_KIEM', 'DAT', 'KHONG_DAT', 'KHOA', 'HUY')),
  check (to_status <> 'KHOA' or to_lock_reason is not null)
);
create index ix_lot_status_log_0 on lot_status_log (lot_id, occurred_at);
comment on table lot_status_log is 'Nhật ký đổi trạng thái lô: ai, lúc nào, từ → sang (kèm lý do khóa), QT + bước, phần lô và SL bị đổi, chứng từ, lý do, file.';
comment on column lot_status_log.stock_line_id is 'phần bị đổi; null nếu ghi cho cả lô';
comment on column lot_status_log.warehouse_id is 'kho của phần bị đổi; null khi hàng đang chuyển';
comment on column lot_status_log.handling_unit_ids is 'các bao / thùng bị đổi khi đổi theo bao (24/10 đợt 9); null khi đổi cả phần lô';
comment on column lot_status_log.from_status is 'null = lô mới';
comment on column lot_status_log.qt_code is 'QT14…';
comment on column lot_status_log.step_code is 'y2, d2…';

create table lot_link (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  parent_lot_id uuid not null,
  child_lot_id uuid not null,
  link_type text not null,
  qty numeric(14,3) not null,
  uom_code text not null,
  production_batch_id uuid,
  handling_unit_id uuid,
  operator_id uuid,
  linked_at timestamptz not null,
  source_event_id uuid,
  origin_site text not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (link_type in ('NAP_SILO', 'XA_SILO', 'RA_ME', 'BAO_BI', 'NVL_DU')),
  check (origin_site in ('CLOUD', 'NM')),
  check (parent_lot_id <> child_lot_id),
  check (qty > 0),
  check (link_type not in ('XA_SILO','RA_ME','BAO_BI') or production_batch_id is not null),
  check (link_type <> 'NAP_SILO' or handling_unit_id is not null)
);
create unique index ux_lot_link_0 on lot_link (source_event_id, parent_lot_id, child_lot_id) where source_event_id is not null;
create index ix_lot_link_0 on lot_link (parent_lot_id);
create index ix_lot_link_1 on lot_link (child_lot_id);
comment on table lot_link is 'Liên kết lô cha → lô con kèm khối lượng — 1 đồ thị tổng quát cho cả chuỗi: lô NVL / bao HH —nạp→ nút silo của lệnh —xả→ lô mẻ → lô HH / lô BTP-TP / lô bột hỏng (mẻ hủy); lô bao bì (lon, thùng) → lô BTP-TP; lô gốc → lô NVL dư; nút silo → lô bột dư. Qua nút silo (19/10 đợt 3): lô nạp lúc T là đầu vào của các mẻ xả sau T (so linked_at), tới khi silo xả sạch. BẮT BUỘC: thao tác quét chỉ thành công khi dòng này ghi được trong cùng giao dịch; ràng buộc trễ chặn lô HH / BTP không có liên kết vào. Trigger: nạp đúng silo của phương án, silo đang hoạt động, bột trong nút + nạp ≤ sức chứa; xả / bột dư ≤ bột đang có.';
comment on column lot_link.link_type is 'NAP_SILO: lô NVL / HH → nút SILO (quét bao nạp silo); XA_SILO: nút SILO → lô mẻ (silo xả cho mẻ); NVL_DU: lô gốc → lô dư, hoặc nút SILO → lô bột dư. Bỏ DO_VAO_ME (bao không đổ thẳng vào mẻ — đợt 3)';
comment on column lot_link.handling_unit_id is 'bao được quét';
comment on column lot_link.linked_at is 'thời điểm nạp / xả — truy xuất qua nút SILO chỉ nối lần nạp có linked_at ≤ linked_at của lần xả (cách B)';

create table inventory_txn (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  stock_line_id uuid not null,
  lot_id uuid not null,
  warehouse_id uuid,
  qty_delta numeric(14,3) not null,
  uom_code text not null,
  txn_category text not null,
  ref_table text not null,
  ref_id uuid not null,
  actor_id uuid not null,
  occurred_at timestamptz not null default now(),
  source_event_id uuid,
  primary key (id),
  check (txn_category in ('NHAP_MUA', 'NHAP_SX', 'NHAP_KHACH_TRA', 'NHAP_THU_HOI', 'NHAP_NVL_DU', 'NHAP_TIM_LAI', 'XUAT_SX', 'XUAT_BAN', 'XUAT_TRA_NCC', 'CHUYEN_DI', 'CHUYEN_DEN', 'DOI_TRANG_THAI', 'HUY', 'DIEU_CHINH', 'LAY_MAU_LUU', 'LAY_MAU_KIEM')),
  check (qty_delta <> 0)
);
create index ix_inventory_txn_0 on inventory_txn (lot_id, txn_category);
comment on table inventory_txn is 'Sổ kho: mọi thay đổi SL của phần lô. Đổi trạng thái / chuyển / hủy luôn là cặp −/+ (tổng lô không đổi). Nguồn số cho cân bằng khối lượng (QT25).';
comment on column inventory_txn.warehouse_id is 'null khi dòng tồn đang trên phiếu chuyển';

create table scan_log (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  device_id text,
  user_id uuid,
  scanned_code text not null,
  scan_context text not null,
  ref_table text,
  ref_id uuid,
  result text not null,
  block_reason text,
  message text,
  replacement_code text,
  scanned_at timestamptz not null default now(),
  source_event_id uuid,
  primary key (id),
  check (scan_context in ('NHAP_KHO', 'XUAT_KHO', 'NHAN_CHUYEN', 'KIEM_KHO', 'QUET_BAO_ME', 'LON_DAU', 'DONG_THUNG', 'SU_CO_TEM')),
  check (result in ('OK', 'CHAN')),
  check (block_reason in ('SAI_LO', 'SAI_TRANG_THAI', 'HET_HAN', 'DANG_KIEM_KE', 'DUOI_NGUONG_SX', 'SAI_CONG_THUC', 'SAI_NHAN_HIEU', 'KHONG_GHI_DUOC_LIEN_KET', 'MA_BI_KHOA', 'KHAC')),
  check ((result = 'CHAN') = (block_reason is not null)),
  check (replacement_code is null or block_reason is not distinct from 'MA_BI_KHOA')
);
comment on table scan_log is 'Nhật ký mọi lần quét, kể cả lần bị chặn (sai lô, sai trạng thái, hết hạn, đang kiểm kê, dưới ngưỡng hạn tối thiểu cho SX, sai nhãn hiệu, không ghi được liên kết, mã đã khóa — kèm mã thay thế). Chỉ để tra cứu — liên kết thật nằm ở lot_link / goods_issue_scan / goods_receipt_scan.';
comment on column scan_log.replacement_code is 'mã thay thế hiện cho người quét khi quét trúng mã đã khóa (QT04)';

create table goods_receipt (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  code text not null,
  receipt_type text not null,
  warehouse_id uuid not null,
  status text not null default 'CHO_NHAN_HANG',
  supplier_id uuid,
  purchase_order_id uuid,
  supplier_invoice_no text,
  supplier_invoice_file_id uuid,
  hard_copy_received boolean not null default false,
  invoice_recorded_by uuid,
  invoice_recorded_at timestamptz,
  production_order_id uuid,
  delivery_note_id uuid,
  recall_case_id uuid,
  stock_transfer_id uuid,
  reason text,
  doc_file_id uuid,
  discrepancy_confirmed_by uuid,
  discrepancy_confirmed_at timestamptz,
  discrepancy_note text,
  recount_reason text,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (receipt_type in ('MUA_HANG', 'TU_SX', 'CHUYEN_KHO', 'KHACH_TRA', 'THU_HOI')),
  check (status in ('CHO_NHAN_HANG', 'DANG_NHAN', 'CHO_XAC_NHAN_LECH', 'DA_NHAP', 'DA_HUY')),
  unique (code),
  check (receipt_type <> 'MUA_HANG' or (supplier_id is not null and purchase_order_id is not null)),
  check (receipt_type <> 'TU_SX' or production_order_id is not null),
  check (receipt_type <> 'KHACH_TRA' or delivery_note_id is not null),
  check (receipt_type <> 'THU_HOI' or recall_case_id is not null),
  check (receipt_type <> 'CHUYEN_KHO' or stock_transfer_id is not null),
  check (discrepancy_confirmed_by is null or discrepancy_confirmed_by is distinct from created_by),
  check (discrepancy_confirmed_by is null or discrepancy_confirmed_at is not null),
  check ((invoice_recorded_by is null) = (invoice_recorded_at is null))
);
comment on table goods_receipt is 'Phiếu nhập kho, 5 loại: MUA_HANG / TU_SX (BTP từ chiết rót, NVL dư) / CHUYEN_KHO / KHACH_TRA / THU_HOI. Thiếu chứng từ → từ chối ở cửa kho, không tạo lô. Sửa 24/10 (đợt 7): không lập tay, không duyệt — hệ thống tự sinh phiếu CHO_NHAN_HANG từ chứng từ gốc (BTP khi đóng thùng xong, NVL dư khi xả bột dư, khách trả, thu hồi, chuyển kho; NVL mua: quét PO là ra phiếu điền sẵn); quét bao / thùng đầu tiên → DANG_NHAN (trigger trên goods_receipt_scan); khớp SL dự kiến từng dòng và không có bao hư → DA_NHAP (cập nhật tồn); lệch / có bao hư → CHO_XAC_NHAN_LECH → Thủ kho trưởng (không phải người lập) xác nhận → DA_NHAP theo SL thực, hoặc yêu cầu đếm lại (bắt buộc lý do) → DANG_NHAN (trigger trg_goods_receipt). Bỏ CHO_DUYET / DA_DUYET / TU_CHOI, người duyệt, lý do từ chối.';
comment on column goods_receipt.status is 'CHO_NHAN_HANG: hệ thống tự sinh, chưa quét; DANG_NHAN: đang quét; CHO_XAC_NHAN_LECH: SL nhận khác dự kiến hoặc có bao hư; DA_NHAP: đã cập nhật tồn (24/10 đợt 7)';
comment on column goods_receipt.supplier_invoice_file_id is 'tệp hóa đơn / chứng từ NCC — Kế toán lưu (QT14 t4)';
comment on column goods_receipt.hard_copy_received is 'Kế toán đã nhận bản cứng hóa đơn / chứng từ';
comment on column goods_receipt.invoice_recorded_by is 'Kế toán lưu hóa đơn / chứng từ';
comment on column goods_receipt.delivery_note_id is 'KHACH_TRA: ghi nhận giao của phiếu xuất bán có phần khách không nhận';
comment on column goods_receipt.discrepancy_confirmed_by is 'Thủ kho trưởng xác nhận chênh lệch (không phải người lập phiếu)';
comment on column goods_receipt.discrepancy_note is 'ghi chú chênh lệch khi xác nhận';
comment on column goods_receipt.recount_reason is 'lý do Thủ kho trưởng yêu cầu đếm lại (phiếu về DANG_NHAN)';

create table goods_receipt_line (
  id uuid not null default gen_random_uuid(),
  receipt_id uuid not null,
  line_no integer not null,
  material_id uuid,
  product_id uuid,
  purchase_order_line_id uuid,
  lot_id uuid,
  expected_qty numeric(14,3),
  received_qty numeric(14,3) not null default 0,
  uom_code text not null,
  supplier_lot_no text,
  mfg_date date,
  exp_date date,
  coa_file_id uuid,
  coa_check_result text,
  shelf_life_check_result text,
  min_shelf_ratio_used numeric(4,3),
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (coa_check_result in ('DAT', 'KHONG_DAT', 'KHONG_YEU_CAU')),
  check (shelf_life_check_result in ('DAT', 'KHONG_DAT')),
  unique (receipt_id, line_no),
  check ((material_id is null) <> (product_id is null)),
  check (received_qty >= 0)
);
comment on table goods_receipt_line is 'Dòng phiếu nhập = 1 mặt hàng × 1 lô. NVL mua: số lô NCC, NSX, HSD, COA và kết quả kiểm tự động COA / HSD (chép lại tỷ lệ HSD tối thiểu đã dùng).';
comment on column goods_receipt_line.lot_id is 'lô mới (NVL mua, NVL dư) hoặc lô cũ (khách trả, thu hồi, tìm lại)';

create table receipt_coa_result (
  id uuid not null default gen_random_uuid(),
  receipt_line_id uuid not null,
  spec_item_id uuid not null,
  criterion_name text not null,
  min_value numeric,
  max_value numeric,
  expected_text text,
  coa_value_num numeric,
  coa_value_text text,
  passed boolean not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  unique (receipt_line_id, spec_item_id)
);
comment on table receipt_coa_result is 'Kết quả kiểm COA tự động từng chỉ tiêu, chép lại giới hạn lúc kiểm.';

create table goods_receipt_scan (
  id uuid not null default gen_random_uuid(),
  receipt_line_id uuid not null,
  handling_unit_id uuid not null,
  qty numeric(12,3) not null,
  unit_condition text not null default 'TOT',
  scanned_at timestamptz not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (unit_condition in ('TOT', 'HU')),
  unique (receipt_line_id, handling_unit_id)
);
comment on table goods_receipt_scan is 'Mỗi bao / thùng quét khi nhập (mã bao), kể cả khi nhận chuyển kho (tốt / hư). Sửa 24/10 đợt 9: bỏ quét mã ô khi cất hàng.';

create table goods_receipt_damage (
  id uuid not null default gen_random_uuid(),
  receipt_line_id uuid not null,
  handling_unit_code text,
  qty numeric(12,3) not null,
  reason text not null,
  photo_file_id uuid,
  disposition text not null,
  supplier_return_id uuid,
  ncr_id uuid,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (disposition in ('TRA_NCC', 'NCR', 'GHI_BIEN_BAN'))
);
comment on table goods_receipt_damage is 'Bao / thùng hư khi kiểm ngoại quan lúc nhập và hướng xử lý: NVL mua → trả NCC; từ SX → NCR; khách trả / thu hồi → ghi biên bản, vẫn nhập.';
comment on column goods_receipt_damage.ncr_id is 'NCR do Kế hoạch lập (QT14 nr)';

create table goods_issue (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  code text not null,
  issue_type text not null,
  warehouse_id uuid not null,
  status text not null default 'CHO_LAY_HANG',
  requested_by uuid not null,
  requested_date date not null,
  reason text,
  doc_file_id uuid,
  sales_order_id uuid,
  sales_issue_request_id uuid,
  production_order_id uuid,
  stock_transfer_id uuid,
  supplier_return_id uuid,
  receiver_text text,
  requester_decision_by uuid,
  requester_decision_at timestamptz,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (issue_type in ('BAN', 'SAN_XUAT', 'CHUYEN_KHO', 'TRA_NCC')),
  check (status in ('CHO_LAY_HANG', 'DANG_LAY_HANG', 'CHO_BEN_YEU_CAU', 'DA_XUAT', 'XUAT_MOT_PHAN', 'DA_HUY')),
  unique (code),
  check (issue_type <> 'BAN' or (sales_order_id is not null and sales_issue_request_id is not null)),
  check (issue_type <> 'SAN_XUAT' or production_order_id is not null),
  check (issue_type <> 'CHUYEN_KHO' or stock_transfer_id is not null),
  check (issue_type <> 'TRA_NCC' or supplier_return_id is not null),
  check (requester_decision_by is null or requester_decision_by = requested_by)
);
create unique index ux_goods_issue_0 on goods_issue (sales_issue_request_id) where sales_issue_request_id is not null;
comment on table goods_issue is 'Phiếu xuất kho, 4 loại: BAN / SAN_XUAT / CHUYEN_KHO / TRA_NCC. Hệ thống đề xuất lô → tạo phiếu, phiếu vào thẳng CHO_LAY_HANG → quét bao đầu tiên thì DANG_LAY_HANG → DA_XUAT / XUAT_MOT_PHAN (24/10 đợt 7: không ai duyệt nên bỏ tên DA_DUYET). Sửa 24/10 (đợt 6): bỏ bước Thủ kho trưởng duyệt phiếu xuất cho mọi loại — bỏ CHO_DUYET / TU_CHOI, bỏ approved_by / approved_at / reject_reason; duyệt nằm ở chứng từ gốc (yêu cầu xuất bán, lệnh SX, phiếu chuyển do Thủ kho trưởng xác nhận, yêu cầu xuất trả NCC do Trưởng BP Mua hàng duyệt) (trigger trg_goods_issue: lập ra phải là CHO_LAY_HANG; CHO_BEN_YEU_CAU / DA_XUAT / XUAT_MOT_PHAN chỉ từ DANG_LAY_HANG). Xuất bán: 1 yêu cầu xuất bán = 1 phiếu xuất, do máy chủ nhà máy tự lập (trigger trg_goods_issue_ban, 24/10 đợt 4); kết quả giao ghi theo phiếu (delivery_note, 24/10). Sửa 19/10 (đợt 2): thiếu hàng mà không có lô thay thế → CHO_BEN_YEU_CAU; chỉ bên yêu cầu (requested_by) chọn nhận phần đã lấy (→ XUAT_MOT_PHAN) hoặc hủy (→ DA_HUY) (trigger). TRA_NCC: Thủ kho lập theo yêu cầu xuất trả đã duyệt — chỉ khi phiếu trả NCC đang CHO_KHO_XUAT_TRA (trigger). Sửa 19/10 (đợt 4): SAN_XUAT chỉ lập từ kho loại DIEU_PHOI (trigger); sửa 24/10 đợt 10: máy chủ nhà máy tự lập khi lệnh phát sang khu SX (nơi nhận = khu của lệnh, kho điều phối chung), không qua CHO_BEN_YEU_CAU — thiếu thì tự XUAT_MOT_PHAN, phần thiếu thành đề nghị chuyển kho; lệnh hủy / kết thúc sớm thì ứng dụng hủy phiếu chưa lấy (trước: thủ kho kho điều phối lập theo lệnh), `requested_by` vẫn là Kế hoạch (bên quyết khi CHO_BEN_YEU_CAU); lô đề xuất FEFO trong tồn kho điều phối, trừ `material_reservation` của lệnh.';
comment on column goods_issue.status is 'CHO_LAY_HANG: vừa lập, chưa quét; DANG_LAY_HANG: tự chuyển khi quét bao / thùng đầu tiên (trigger trên goods_issue_scan); CHO_BEN_YEU_CAU: thiếu, không có lô thay thế — chờ bên yêu cầu chọn nhận phần đã lấy / hủy (24/10 đợt 7 — thay DA_DUYET)';
comment on column goods_issue.requested_by is 'bên yêu cầu (TRA_NCC: Mua hàng gửi yêu cầu xuất trả)';
comment on column goods_issue.sales_issue_request_id is 'BAN: yêu cầu xuất bán từ đơn (1 yêu cầu = 1 phiếu)';
comment on column goods_issue.receiver_text is 'đối tượng nhận (hiển thị)';
comment on column goods_issue.requester_decision_by is 'bên yêu cầu quyết khi CHO_BEN_YEU_CAU (phải là requested_by)';

create table goods_issue_line (
  id uuid not null default gen_random_uuid(),
  issue_id uuid not null,
  line_no integer not null,
  material_id uuid,
  product_id uuid,
  proposed_lot_id uuid not null,
  proposed_qty numeric(14,3) not null,
  actual_qty numeric(14,3) not null default 0,
  uom_code text not null,
  substitute_for_line_id uuid,
  reservation_id uuid,
  sales_order_line_id uuid,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  unique (issue_id, line_no),
  check ((material_id is null) <> (product_id is null)),
  check (proposed_qty > 0 and actual_qty >= 0)
);
comment on table goods_issue_line is 'Dòng phiếu xuất: lô đề xuất, SL đề xuất, SL thực xuất; dòng lô thay thế trỏ về dòng thiếu. Xuất SX trừ dần KG giữ chỗ của lệnh.';

create table goods_issue_scan (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  issue_line_id uuid not null,
  handling_unit_id uuid not null,
  lot_id uuid not null,
  from_stock_line_id uuid not null,
  qty numeric(12,3) not null,
  scanned_at timestamptz not null,
  source_event_id uuid,
  origin_site text not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (origin_site in ('CLOUD', 'NM')),
  unique (issue_line_id, handling_unit_id),
  check (qty > 0)
);
create unique index ux_goods_issue_scan_0 on goods_issue_scan (source_event_id) where source_event_id is not null;
comment on table goods_issue_scan is 'Mỗi lần quét bao / thùng HỢP LỆ khi xuất — chính là liên kết bắt buộc "thùng → phiếu xuất", "bao NVL → phiếu xuất SX", "bao → phiếu chuyển". Không có dòng này thì không trừ tồn.';

create table stock_discrepancy (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  source_qt text not null,
  lot_id uuid not null,
  warehouse_id uuid,
  book_qty numeric(14,3),
  found_qty numeric(14,3),
  ref_table text,
  ref_id uuid,
  stocktake_id uuid,
  status text not null default 'MO',
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (source_qt in ('QT15', 'QT19', 'QT25')),
  check (status in ('MO', 'DANG_KIEM', 'DONG'))
);
comment on table stock_discrepancy is 'Lệch tồn phát sinh (sổ có, thực tế không / tồn âm / cân bằng lệch) → mở kiểm điểm (QT17).';

create table stock_transfer (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  code text not null,
  to_factory_id uuid not null,
  from_warehouse_id uuid not null,
  to_warehouse_id uuid not null,
  status text not null default 'CHO_XUAT',
  source_order_id uuid,
  auto_drafted boolean not null default false,
  vehicle_no text,
  transporter_name text,
  shipped_at timestamptz,
  eta timestamptz,
  note text,
  received_at timestamptz,
  compensation_amount numeric(18,2),
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (status in ('CHO_XUAT', 'DANG_CHUYEN', 'CHO_XU_LY_HANG_HU', 'NHAN_THIEU', 'CHO_XAC_NHAN_THAT_LAC', 'DA_NHAN', 'THAT_LAC', 'DA_HUY')),
  unique (code),
  check (from_warehouse_id <> to_warehouse_id),
  check (not auto_drafted or source_order_id is not null)
);
create unique index ux_stock_transfer_0 on stock_transfer (source_order_id) where auto_drafted and status = 'CHO_XUAT';
comment on table stock_transfer is 'Phiếu chuyển kho (cùng / khác nhà máy). Sửa 04/11 (chốt 30/10): nhà máy nhận gửi yêu cầu chuyển (transfer_request, YCC-); Kế hoạch nhà máy nguồn (nội bộ: Thủ kho điều phối) gom các yêu cầu theo kho xuất → kho nhận và lập phiếu — lập phiếu là chấp nhận (bỏ bước Thủ kho trưởng xác nhận / từ chối); thiếu NVL cho lệnh SX thì hệ thống tự lập phiếu từ kho tổng sang kho điều phối cấp NVL của khu (bỏ bước Kế hoạch gửi). Phiếu vào thẳng Chờ xuất → quét xuất: Đang chuyển (dòng tồn có stock_transfer_id — hàng nằm trên phiếu, không thuộc kho nào) → Đã nhận; có hàng hư: Chờ xử lý hàng hư; thiếu: Nhận thiếu (chờ tìm 7 ngày) → Chờ xác nhận thất lạc → Thất lạc (HỦY).';
comment on column stock_transfer.status is 'theo mockup (04/11): lập phiếu là chấp nhận → CHO_XUAT; DANG_CHUYEN: đã quét xuất, hàng trên phiếu; bỏ Đề nghị / Chờ xác nhận / Từ chối / Nhận một phần / Đóng';
comment on column stock_transfer.source_order_id is 'lệnh SX nguồn của đề nghị tự lập (đợt 4)';
comment on column stock_transfer.auto_drafted is 'hệ thống tự lập từ lệnh SX (thiếu NVL ở kho điều phối cấp cho khu) — vào thẳng CHO_XUAT (04/11)';
comment on column stock_transfer.eta is 'giờ đến dự kiến (lúc quét xuất)';
comment on column stock_transfer.compensation_amount is 'bồi thường thất lạc (xử lý ngoài, chỉ ghi số; không hạch toán)';

create table stock_transfer_line (
  id uuid not null default gen_random_uuid(),
  transfer_id uuid not null,
  line_no integer not null,
  lot_id uuid,
  material_id uuid,
  product_id uuid,
  transfer_request_id uuid,
  requested_qty numeric(14,3) not null,
  shipped_qty numeric(14,3) not null default 0,
  received_qty numeric(14,3) not null default 0,
  damaged_qty numeric(14,3) not null default 0,
  lost_qty numeric(14,3) not null default 0,
  uom_code text not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  unique (transfer_id, line_no),
  check (received_qty + damaged_qty + lost_qty <= shipped_qty),
  check (lot_id is not null or material_id is not null or product_id is not null)
);
comment on table stock_transfer_line is 'Dòng chuyển: lô, SL yêu cầu / đã xuất / đã nhận / hư / thất lạc. Dòng gom từ yêu cầu chuyển (transfer_request_id) hoặc tự lập từ lệnh SX ghi NVL / SP + SL, chưa có lô — lô gán khi kho xuất lấy hàng theo FEFO (trigger: mọi dòng có `lot_id` trước khi phiếu sang DANG_CHUYEN; lô đúng NVL / SP của dòng).';
comment on column stock_transfer_line.lot_id is 'bắt buộc từ lúc xuất; đề nghị tự lập để trống tới khi xuất (đợt 4)';
comment on column stock_transfer_line.material_id is 'NVL của dòng đề nghị theo KG (đợt 4)';
comment on column stock_transfer_line.product_id is 'SP của dòng (yêu cầu chuyển BTP / TP chưa gán lô)';
comment on column stock_transfer_line.transfer_request_id is 'yêu cầu chuyển được gom vào dòng (04/11)';
comment on column stock_transfer_line.requested_qty is 'đề nghị tự lập: KG thiếu = KG còn giữ của lệnh − tồn dùng được ở kho điều phối';

create table transfer_request (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  code text not null,
  to_factory_id uuid not null,
  from_warehouse_id uuid not null,
  to_warehouse_id uuid not null,
  material_id uuid,
  product_id uuid,
  qty numeric(14,3) not null,
  uom_code text not null,
  needed_date date not null,
  production_order_id uuid,
  source text not null,
  reason text not null,
  requested_by uuid not null,
  status text not null default 'CHO_LAP_PHIEU',
  status_reason text,
  stock_transfer_id uuid,
  parent_request_id uuid,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (source in ('KE_HOACH_THEM', 'CAN_DOI_NVL', 'CACH_BU_TAO_LENH', 'PHAN_CON_LAI')),
  check (status in ('CHO_LAP_PHIEU', 'TREN_PHIEU', 'TU_CHOI', 'QUA_HAN_XUAT', 'DA_RUT', 'BI_TRA_VE')),
  unique (code),
  check ((material_id is null) <> (product_id is null)),
  check (from_warehouse_id <> to_warehouse_id),
  check (qty > 0),
  check ((status = 'TREN_PHIEU') = (stock_transfer_id is not null)),
  check (status not in ('TU_CHOI','QUA_HAN_XUAT','DA_RUT','BI_TRA_VE') or status_reason is not null),
  check (source <> 'PHAN_CON_LAI' or parent_request_id is not null)
);
comment on table transfer_request is 'Yêu cầu chuyển kho YCC- (chốt 30/10): nhà máy nhận gửi yêu cầu (Kế hoạch thêm tay, cân đối NVL, cách bù khi tạo lệnh), mỗi yêu cầu 1 NVL / SP × SL × ngày cần, kho xuất → kho nhận. Kế hoạch nhà máy nguồn gom các yêu cầu cùng kho xuất → kho nhận và lập phiếu chuyển (lập phiếu là chấp nhận) hoặc từ chối kèm lý do; giao một phần thì phần còn lại thành yêu cầu mới (parent_request_id).';
comment on column transfer_request.code is 'YCC-{yymm}-{4 số}';
comment on column transfer_request.to_factory_id is 'nhà máy nhận (bên gửi yêu cầu)';
comment on column transfer_request.production_order_id is 'lệnh SX cần hàng (nếu có)';
comment on column transfer_request.reason is 'lý do / mục đích';
comment on column transfer_request.status_reason is 'lý do từ chối / rút / trả về / quá hạn';
comment on column transfer_request.stock_transfer_id is 'phiếu chuyển đã lập';
comment on column transfer_request.parent_request_id is 'phần còn lại của yêu cầu nào';

create table transfer_discrepancy (
  id uuid not null default gen_random_uuid(),
  transfer_line_id uuid not null,
  kind text not null,
  qty numeric(14,3) not null,
  reason text,
  photo_file_id uuid,
  search_deadline date,
  resolution text,
  resolved_by uuid,
  resolved_at timestamptz,
  confirmed_by uuid,
  confirmed_at timestamptz,
  responsible_person text,
  qc_request_id uuid,
  disposal_id uuid,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (kind in ('THIEU', 'HU', 'THAT_LAC')),
  check (resolution in ('TIM_THAY', 'THAT_LAC', 'GUI_QC', 'HUY')),
  check (kind <> 'THIEU' or search_deadline is not null),
  check (confirmed_by is null or resolution = 'THAT_LAC'),
  check (confirmed_by is null or confirmed_by <> resolved_by)
);
comment on table transfer_discrepancy is 'Biên bản chênh lệch khi nhận chuyển kho: THIẾU (giữ trên phiếu chuyển, hạn tìm), HƯ (chỉ các bao hư KHÓA tại kho nhận, bao lành giữ trạng thái; Thủ kho trưởng chọn gửi QC / hủy — bỏ khu hàng lỗi 24/10 đợt 9), THẤT LẠC (Kế hoạch lập biên bản, Thủ kho trưởng xác nhận → HỦY).';
comment on column transfer_discrepancy.search_deadline is 'THIEU: mặc định +7 ngày';
comment on column transfer_discrepancy.resolved_by is 'thất lạc: Kế hoạch lập biên bản (g3)';
comment on column transfer_discrepancy.confirmed_by is 'Thủ kho trưởng xác nhận biên bản thất lạc (QT16 gx) — có xác nhận mới thành HỦY';
comment on column transfer_discrepancy.responsible_person is 'thất lạc';

create table stocktake (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  code text not null,
  stocktake_type text not null,
  warehouse_id uuid not null,
  trigger_source text not null,
  snapshot_at timestamptz,
  status text not null default 'DANG_KIEM',
  approved_by uuid,
  approved_at timestamptz,
  report_file_id uuid,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (stocktake_type in ('TOAN_KHO', 'KIEM_DIEM')),
  check (trigger_source in ('DINH_KY', 'QT15', 'QT19', 'QT25', 'KHOI_TAO_LAI', 'KHAC')),
  check (status in ('DANG_KIEM', 'CHO_DUYET', 'DA_DIEU_CHINH', 'KHOP')),
  unique (code)
);
comment on table stocktake is 'Phiếu kiểm kho: TOAN_KHO (định kỳ, cờ đang kiểm kê cả kho) / KIEM_DIEM (chỉ lô bị lệch trong kho).';
comment on column stocktake.trigger_source is 'KHOI_TAO_LAI: khởi tạo lại máy chủ nhà máy — lô có biến động sau lần cloud xác nhận cuối (QT19 c3)';
comment on column stocktake.snapshot_at is 'thời điểm chốt số liệu';
comment on column stocktake.status is 'KHOP: số đếm khớp sổ, không điều chỉnh (theo mockup 04/11 — thay DONG)';

create table stocktake_lock (
  id uuid not null default gen_random_uuid(),
  stocktake_id uuid not null,
  warehouse_id uuid not null,
  lot_id uuid,
  released_at timestamptz,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id)
);
create index ix_stocktake_lock_0 on stocktake_lock (warehouse_id, released_at);
comment on table stocktake_lock is 'Cờ "đang kiểm kê" trên cả kho (lot_id null) hoặc trên 1 lô trong kho (sửa 24/10 đợt 9 — bỏ vị trí kệ). Chặn mọi nhập xuất trong phạm vi; KHÔNG đổi trạng thái lô; kiểm xong chỉ gỡ cờ.';

create table stocktake_line (
  id uuid not null default gen_random_uuid(),
  stocktake_id uuid not null,
  lot_id uuid,
  book_qty numeric(14,3) not null,
  counted_qty numeric(14,3),
  correct_item boolean,
  lot_exp_ok boolean,
  condition_note text,
  diff_reason text,
  counted_by uuid,
  counted_at timestamptz,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id)
);
comment on table stocktake_line is 'Dòng đếm: số sổ (chốt), số đếm, đúng hàng, lô & HSD, tình trạng, lý do chênh lệch.';

create table stock_adjustment (
  id uuid not null default gen_random_uuid(),
  stocktake_line_id uuid not null,
  stock_line_id uuid not null,
  qty_delta numeric(14,3) not null,
  new_status text,
  new_lock_reason text,
  approved_by uuid not null,
  approved_at timestamptz not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (new_status in ('CHO_KIEM', 'DAT', 'KHONG_DAT', 'KHOA')),
  check (qty_delta <> 0),
  check (approved_by <> created_by),
  check (qty_delta < 0 or new_status = 'KHOA')
);
comment on table stock_adjustment is 'Điều chỉnh tồn sau kiểm kho (đã duyệt). Phần tăng (hủy nhầm, hàng tìm lại) vào KHÓA chờ QC.';

create table disposal (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  code text not null,
  warehouse_id uuid not null,
  source text not null,
  status text not null default 'CHO_XAC_NHAN',
  planned_date date,
  postponed_to date,
  reject_reason text,
  confirmed_by uuid,
  confirmed_at timestamptz,
  executed_by uuid,
  executed_at timestamptz,
  report_file_id uuid,
  destroyed_value numeric(18,2),
  recall_case_id uuid,
  sales_order_id uuid,
  supplier_return_id uuid,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (source in ('KIEM_TRA', 'HET_HAN', 'QC_KHONG_DAT', 'THU_HOI', 'HU_KHI_NHAN', 'NCR', 'HUY_DON', 'NHA_MAY_CHIU', 'HUY_ME', 'KHAC')),
  check (status in ('CHO_XAC_NHAN', 'TU_CHOI', 'DA_XAC_NHAN', 'DA_HUY')),
  unique (code),
  check (status <> 'TU_CHOI' or (reject_reason is not null and source not in ('HET_HAN','HUY_ME'))),
  check (confirmed_by is null or confirmed_by <> created_by)
);
comment on table disposal is 'Phiếu hủy. Tạo phiếu → tự KHÓA phần trên phiếu (lý do chờ hủy). Lô hết hạn và bột hỏng của mẻ hủy không được từ chối, chỉ dời ngày. Thủ kho trưởng từ chối → về trạng thái trước / gửi QC.';
comment on column disposal.source is 'HUY_ME: bột hỏng của mẻ hủy, hệ thống tự tạo (QT20 ky); mẫu lưu không qua phiếu hủy (QC tự hủy, QT24)';
comment on column disposal.report_file_id is 'biên bản hủy';
comment on column disposal.destroyed_value is 'giá trị hàng hủy — Kế toán ghi (QT18 t5), chỉ ghi nhận, không hạch toán';

create table disposal_line (
  id uuid not null default gen_random_uuid(),
  disposal_id uuid not null,
  lot_id uuid not null,
  stock_line_id uuid not null,
  qty numeric(14,3) not null,
  prev_status text,
  prev_lock_reason text,
  destroyed_qty numeric(14,3),
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (prev_status in ('CHO_KIEM', 'DAT', 'KHONG_DAT', 'KHOA')),
  check (qty > 0)
);
comment on table disposal_line is 'Dòng hủy: phần lô bị hủy, trạng thái trước để trả về khi từ chối, SL thực hủy. Mẫu lưu hết hạn không qua đây (QC tự hủy ở retained_sample).';

create table customer (
  id uuid not null default gen_random_uuid(),
  code text not null,
  company_name text not null,
  company_code text,
  tax_code text,
  contact_name text,
  contact_title text,
  phone text,
  email text,
  contact_address text,
  delivery_address text,
  bank_account text,
  bank_name text,
  bank_account_name text,
  default_payment_method text,
  default_payment_channel text,
  default_credit_days integer,
  default_deposit_pct numeric(5,2),
  invoice_email text,
  credit_limit numeric(18,2),
  is_credit_blocked boolean default false,
  credit_blocked_at timestamptz,
  status text not null default 'HOAT_DONG',
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (default_payment_method in ('TRA_DU', 'COC_TRA_NOT', 'MUA_CHIU')),
  check (default_payment_channel in ('TIEN_MAT', 'CHUYEN_KHOAN', 'TM_CK')),
  check (status in ('HOAT_DONG', 'TAM_DUNG', 'NGUNG_DUNG')),
  unique (code),
  check (credit_limit is null or credit_limit >= 0),
  check (is_credit_blocked = (credit_blocked_at is not null)),
  check (default_deposit_pct is null or default_deposit_pct between 0 and 100),
  check (default_credit_days is null or default_credit_days >= 0)
);
create unique index ux_customer_0 on customer (tax_code) where tax_code is not null;
comment on table customer is 'Khách hàng. Hạn mức luôn vĩnh viễn (không có cột hạn mức tạm, không có ngày hết hạn). Cờ tạm khóa do nợ quá hạn chỉ chặn đơn Mua chịu. Bỏ trạng thái "mất" (24/10). Sửa 05/11: bỏ hợp đồng ở hồ sơ khách — hợp đồng tải theo từng đơn (sales_order_version).';
comment on column customer.contact_title is 'chức vụ';
comment on column customer.phone is 'bắt buộc ở cloud (trg_masked_required)';
comment on column customer.bank_account is 'số tài khoản của khách';
comment on column customer.bank_name is 'ngân hàng';
comment on column customer.bank_account_name is 'chủ tài khoản';
comment on column customer.default_payment_channel is 'phương thức thanh toán mặc định: tiền mặt / chuyển khoản / TM-CK';
comment on column customer.default_credit_days is 'số ngày nợ mặc định (Mua chịu)';
comment on column customer.default_deposit_pct is 'tỷ lệ cọc mặc định (Cọc + trả nốt)';
comment on column customer.invoice_email is 'email nhận hóa đơn';
comment on column customer.credit_limit is 'null = chưa có hạn mức';
comment on column customer.is_credit_blocked is 'cờ "tạm khóa do nợ quá hạn" — hệ thống tự bật / tắt (QT10 ya, y3) · bắt buộc ở cloud (trg_masked_required)';
comment on column customer.status is 'Đang hoạt động / Tạm dừng giao dịch / Ngừng hoạt động (theo mockup 04/11)';

create table customer_contact_log (
  id uuid not null default gen_random_uuid(),
  customer_id uuid not null,
  sales_order_id uuid,
  payment_schedule_id uuid,
  purpose text not null,
  contacted_at timestamptz not null,
  result text not null,
  note text,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (purpose in ('GIAO_HANG', 'NHAC_NO', 'THU_HOI')),
  check (result in ('LIEN_HE_DUOC', 'KHONG_LIEN_HE_DUOC'))
);
comment on table customer_contact_log is 'Các lần Sales liên hệ khách nhắc nợ (QT10 k3). Bỏ liên hệ khi giao (24/10 — giao hàng chỉ ghi nhận).';

create table credit_limit_request (
  id uuid not null default gen_random_uuid(),
  customer_id uuid not null,
  sales_order_version_id uuid not null,
  request_kind text not null,
  order_value numeric(18,2) not null,
  current_limit numeric(18,2),
  requested_limit numeric(18,2),
  reason text,
  status text not null default 'CHO_DUYET',
  approved_limit numeric(18,2),
  decided_by uuid,
  decided_at timestamptz,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (request_kind in ('BAN_DAU', 'TANG')),
  check (status in ('CHO_DUYET', 'DA_DUYET', 'TU_CHOI')),
  check (decided_by is null or decided_by <> created_by),
  check (status <> 'DA_DUYET' or approved_limit is not null)
);
comment on table credit_limit_request is 'Đề xuất hạn mức ban đầu / yêu cầu tăng hạn mức, gắn phiên bản đơn. Cờ "đã xin tăng" của 1 phiên bản = có dòng ở đây cho phiên bản đó (sửa đơn tạo phiên bản mới nên cờ tự về chưa).';
comment on column credit_limit_request.decided_by is 'GĐ hoặc KTT (một người là đủ)';

create table sales_order (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  code text not null,
  customer_id uuid not null,
  sales_user_id uuid not null,
  order_date date not null,
  delivery_address text,
  current_version_no integer not null default 1,
  status text not null default 'NHAP',
  status_changed_at timestamptz not null default now(),
  cancel_reason text,
  cancelled_at timestamptz,
  cancelled_by uuid,
  refund_amount numeric(18,2),
  retained_amount numeric(18,2),
  cancel_approved_by uuid,
  delivery_approved_by uuid,
  delivery_approved_at timestamptz,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (status in ('NHAP', 'CHO_KIEM_CONG_NO', 'CHO_XU_LY_NO', 'CHO_DUYET_HAN_MUC', 'CHO_KHACH', 'CHO_THU_TIEN', 'DA_CHOT', 'DANG_SAN_XUAT', 'CHO_NHAP_KHO', 'CHO_KE_TOAN_DUYET', 'CHO_XUAT_KHO', 'SAN_SANG_GIAO', 'DANG_GIAO', 'GIAO_MOT_PHAN', 'DA_GIAO', 'CHO_DUYET_HUY', 'DANG_HUY', 'TU_CHOI', 'DA_HUY')),
  unique (code),
  check (status <> 'DA_HUY' or cancel_reason is not null),
  check ((delivery_approved_by is null) = (delivery_approved_at is null))
);
comment on table sales_order is 'Đầu đơn (phần không đổi theo phiên bản): khách, nhà máy SX / giao, Sales, trạng thái, số phiên bản hiện tại. Không xóa đơn: hủy = trạng thái DA_HUY. Sửa 04/11: Sales hủy thẳng đơn chưa chốt (Chờ thu tiền; Chờ ký HĐ bỏ 05/11), không cần duyệt; từ Đã chốt trở đi hủy qua Chờ duyệt hủy → Đang hủy.';
comment on column sales_order.delivery_address is 'địa chỉ giao của đơn (mặc định từ khách)';
comment on column sales_order.status is 'theo mockup (04/11): thêm Chờ kiểm công nợ, Đang sản xuất, Chờ duyệt hủy, Đang hủy; 05/11: bỏ Chờ ký HĐ (hợp đồng tải theo từng đơn, chưa có / hết hạn thì chưa chốt được); lô SX cho đơn QC đạt: Chờ nhập kho → Chờ kế toán duyệt (Cọc + trả nốt / Mua nợ; Trả đủ bỏ qua) → Chờ xuất kho → Đang giao; Sẵn sàng giao còn cho đơn gắn lô tồn';
comment on column sales_order.status_changed_at is 'mốc tính "chờ quá 3 / 7 ngày"';
comment on column sales_order.cancelled_by is 'người hủy — Sales hủy thẳng ở Chờ thu tiền (04/11)';
comment on column sales_order.refund_amount is 'số hoàn khi hủy (QT07)';
comment on column sales_order.retained_amount is 'phần giữ lại';
comment on column sales_order.cancel_approved_by is 'GĐ hoặc KTT duyệt hủy (đơn từ Đã chốt trở đi, qua Chờ duyệt hủy); hủy thẳng ở Chờ thu tiền không cần (04/11)';
comment on column sales_order.delivery_approved_by is 'Kế toán duyệt xuất giao sau khi nhập kho (QT09 kd — 05/11): Mua nợ kiểm công nợ; Cọc + trả nốt ghi nhận phần còn lại; Trả đủ không cần';

create table sales_order_version (
  id uuid not null default gen_random_uuid(),
  sales_order_id uuid not null,
  version_no integer not null,
  payment_method text,
  deposit_pct numeric(5,2) default 0,
  credit_days integer,
  payment_channel text,
  deposit_amount numeric(18,2),
  vat_pct numeric(5,2),
  delivery_date date,
  total_before_vat numeric(18,2),
  vat_amount numeric(18,2),
  total_amount numeric(18,2),
  contract_file_ids uuid[],
  contract_no text,
  contract_valid_from date,
  contract_valid_to date,
  signed_at timestamptz,
  change_reason text,
  superseded_at timestamptz,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (payment_method in ('TRA_DU', 'COC_TRA_NOT', 'MUA_CHIU', 'KHONG_THU')),
  check (payment_channel in ('TIEN_MAT', 'CHUYEN_KHOAN', 'TM_CK')),
  unique (sales_order_id, version_no),
  check (deposit_pct between 0 and 100),
  check (payment_method <> 'MUA_CHIU' or credit_days is not null),
  check (version_no = 1 or change_reason is not null),
  check (deposit_amount is null or deposit_amount >= 0),
  check (vat_pct is null or vat_pct between 0 and 100),
  check ((contract_no is null) = (coalesce(cardinality(contract_file_ids), 0) = 0)),
  check (contract_valid_to is null or contract_valid_from is null or contract_valid_to >= contract_valid_from)
);
create unique index ux_sales_order_version_0 on sales_order_version (sales_order_id) where superseded_at is null;
comment on table sales_order_version is 'Phiên bản đơn: điều khoản thương mại + HĐ / phụ lục. Sửa đơn đã chốt → thêm phiên bản mới; dòng cũ không bao giờ sửa. Sửa 05/11: hợp đồng tải theo từng đơn (số, hiệu lực từ – đến, file) — chưa có hoặc hết hạn thì chưa chốt được đơn.';
comment on column sales_order_version.payment_method is 'bắt buộc ở cloud (trg_masked_required); KHONG_THU: đơn đổi lô thu hồi (04/11)';
comment on column sales_order_version.deposit_pct is 'bắt buộc ở cloud (trg_masked_required)';
comment on column sales_order_version.credit_days is 'số ngày nợ (Mua chịu)';
comment on column sales_order_version.payment_channel is 'phương thức thanh toán: tiền mặt / chuyển khoản / TM-CK (04/11)';
comment on column sales_order_version.deposit_amount is 'tiền cọc bằng số tiền (mockup nhập số tiền; % cọc tính ra)';
comment on column sales_order_version.vat_pct is 'VAT ở đầu đơn (mockup) — dòng đơn chép theo';
comment on column sales_order_version.delivery_date is 'ngày giao ở đầu đơn (mockup) — dòng đơn chép theo';
comment on column sales_order_version.total_before_vat is 'bắt buộc ở cloud (trg_masked_required)';
comment on column sales_order_version.vat_amount is 'bắt buộc ở cloud (trg_masked_required)';
comment on column sales_order_version.total_amount is 'bắt buộc ở cloud (trg_masked_required)';
comment on column sales_order_version.contract_file_ids is 'bản 1: file hợp đồng khách đã ký cho đơn — nhập khi tạo đơn hoặc upload ở chi tiết đơn (05/11); bản sau: phụ lục';
comment on column sales_order_version.contract_no is 'số hợp đồng của đơn (05/11)';
comment on column sales_order_version.contract_valid_from is 'hợp đồng hiệu lực từ ngày (05/11)';
comment on column sales_order_version.contract_valid_to is 'hợp đồng hiệu lực đến ngày; quá ngày thì chưa chốt được đơn (05/11)';

create table sales_order_line (
  id uuid not null default gen_random_uuid(),
  version_id uuid not null,
  line_no integer not null,
  product_id uuid not null,
  pack_spec text not null,
  qty numeric(14,3) not null,
  uom_code text not null,
  unit_price numeric(18,2),
  vat_rate numeric(5,2),
  requested_delivery_date date,
  delivery_method text,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  unique (version_id, line_no),
  check (qty > 0 and unit_price >= 0)
);
comment on table sales_order_line is 'Dòng hàng thuộc 1 phiên bản đơn.';
comment on column sales_order_line.pack_spec is 'quy cách (lon / bao)';
comment on column sales_order_line.unit_price is 'bắt buộc ở cloud (trg_masked_required)';
comment on column sales_order_line.vat_rate is 'bắt buộc ở cloud (trg_masked_required)';
comment on column sales_order_line.requested_delivery_date is 'ngày giao dự kiến — Sales sửa trực tiếp, ghi nhật ký (24/10)';

create table sales_order_lot (
  id uuid not null default gen_random_uuid(),
  sales_order_id uuid not null,
  lot_id uuid not null,
  qty numeric(14,3) not null,
  released_at timestamptz,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id)
);
create unique index ux_sales_order_lot_0 on sales_order_lot (sales_order_id, lot_id) where released_at is null;
comment on table sales_order_lot is 'Lô gắn đơn: lô TP sinh từ lệnh SX của đơn — xuất bán lấy đúng các lô này, không theo FEFO.';
comment on column sales_order_lot.released_at is 'gỡ gắn (vd hủy đơn)';

create table sales_order_status_log (
  id uuid not null default gen_random_uuid(),
  sales_order_id uuid not null,
  version_no integer,
  from_status text,
  to_status text not null,
  qt_code text not null,
  actor_id uuid not null,
  occurred_at timestamptz not null default now(),
  note text,
  primary key (id)
);
comment on table sales_order_status_log is 'Nhật ký đổi trạng thái đơn.';

create table payment_schedule (
  id uuid not null default gen_random_uuid(),
  sales_order_id uuid not null,
  version_id uuid not null,
  seq_no integer not null,
  installment_type text not null,
  due_basis text not null,
  sales_issue_request_id uuid,
  due_date date,
  amount numeric(18,2) not null,
  paid_amount numeric(18,2) not null default 0,
  escalation_note text,
  escalation_file_id uuid,
  escalation_recorded_at timestamptz,
  status text not null default 'MO',
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (installment_type in ('COC', 'TRA_DU', 'TRA_NOT', 'CONG_NO', 'CHENH_LECH')),
  check (due_basis in ('TRUOC_SX', 'TRUOC_GIAO', 'SAU_GIAO')),
  check (status in ('MO', 'DA_THU_DU', 'THAY_THE', 'HUY')),
  unique (version_id, seq_no),
  check (due_basis <> 'SAU_GIAO' or installment_type = 'CONG_NO'),
  check (escalation_note is null or installment_type = 'CONG_NO')
);
comment on table payment_schedule is 'Lịch thanh toán của phiên bản đơn: từng khoản (cọc / trả đủ / trả nốt / công nợ / chênh lệch), mốc đến hạn, số đã thu. Sinh khi có HĐ (QT05 yl), tính lại khi sửa đơn (QT08 — khoản cũ chuyển THAY_THE). Khoản trước giao tính theo giá trị từng yêu cầu xuất bán: mỗi yêu cầu tách từ khoản TRA_NOT gốc một khoản riêng (sales_issue_request_id) = giá trị phần xuất × (1 − % cọc), khoản gốc giảm tương ứng (dòng cũ THAY_THE, sinh dòng mới); hủy yêu cầu thì gộp lại; công nợ sau giao theo từng lần ghi nhận (hạn = ngày khách nhận + N ngày).';
comment on column payment_schedule.sales_issue_request_id is 'khoản trước giao theo yêu cầu xuất bán (24/10)';
comment on column payment_schedule.amount is 'âm = phải hoàn';
comment on column payment_schedule.escalation_note is 'kết quả xử lý công nợ quá 90 ngày: GĐ / KTT quyết bên ngoài, Kế toán ghi (QT10 g9) — hệ thống không xóa nợ';

create table sales_issue_request (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  code text not null,
  sales_order_id uuid not null,
  seq_no integer not null,
  status text not null default 'CHO_THANH_TOAN',
  planned_date date,
  payment_wait_since timestamptz,
  value_amount numeric(18,2),
  return_reason text,
  cancel_reason text,
  cancelled_by uuid,
  cancelled_at timestamptz,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (status in ('CHO_THANH_TOAN', 'CHO_XUAT', 'BI_TRA_VE', 'DA_XUAT', 'DA_GHI_NHAN', 'DA_HUY')),
  unique (code),
  unique (sales_order_id, seq_no),
  check (status <> 'BI_TRA_VE' or return_reason is not null),
  check (status <> 'DA_HUY' or (cancel_reason is not null and cancelled_by is not null and cancelled_at is not null))
);
comment on table sales_issue_request is 'Yêu cầu xuất bán (sửa 24/10 — thay đợt giao): Sales lập từ đơn, chọn dòng / SL giao lần này (xuất từng phần, mỗi lần 1 yêu cầu → 1 phiếu xuất bán). Hệ thống kiểm khoản trước giao theo giá trị yêu cầu + cờ tạm khóa (đơn Mua chịu) lúc lập; thiếu thì CHO_THANH_TOAN (quá 14 ngày → QT07). Sao xuống máy chủ nhà máy; máy chủ nhà máy tự lập phiếu xuất bán (lô, SL theo yêu cầu) hoặc trả về BI_TRA_VE kèm lý do khi lô không còn đủ (24/10 đợt 3). Một yêu cầu chỉ lấy lô của nhà máy factory_id; hủy bắt buộc lý do. Không có địa chỉ, lịch, xe, hóa đơn — giao hàng chỉ ghi nhận (delivery_note theo phiếu xuất).';
comment on column sales_issue_request.status is 'CHO_XUAT: đã sao xuống, máy chủ nhà máy tự lập phiếu xuất bán; BI_TRA_VE: nhà máy không lập được phiếu (lô không còn đủ); DA_XUAT, DA_GHI_NHAN do cloud chiếu từ phiếu xuất và ghi nhận giao';
comment on column sales_issue_request.planned_date is 'ngày giao dự kiến (chỉ ghi nhận)';
comment on column sales_issue_request.payment_wait_since is 'bắt đầu chờ thu đủ / khách bị khóa (14 ngày → QT07)';
comment on column sales_issue_request.value_amount is 'giá trị phần yêu cầu xuất (tính khoản trước giao)';
comment on column sales_issue_request.return_reason is 'lý do nhà máy trả về (BI_TRA_VE)';
comment on column sales_issue_request.cancel_reason is 'bắt buộc khi hủy';

create table sales_issue_request_line (
  id uuid not null default gen_random_uuid(),
  request_id uuid not null,
  sales_order_line_id uuid not null,
  lot_id uuid not null,
  qty numeric(14,3) not null,
  uom_code text not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  unique (request_id, sales_order_line_id, lot_id),
  check (qty > 0)
);
comment on table sales_issue_request_line is 'Dòng đơn, lô TP (ĐẠT, của đơn) và SL yêu cầu xuất lần này.';

create table delivery_note (
  id uuid not null default gen_random_uuid(),
  goods_issue_id uuid not null,
  signed_by_name text,
  signed_at timestamptz not null,
  photo_file_id uuid,
  note text,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  unique (goods_issue_id)
);
comment on table delivery_note is 'Ghi nhận giao (biên bản giao nhận) theo phiếu xuất bán: Sales ghi ngày khách nhận, người ký, ảnh biên bản (sửa 24/10 — 1 phiếu xuất = 1 ghi nhận, không còn đợt giao). Hạn công nợ = ngày nhận + N ngày.';
comment on column delivery_note.goods_issue_id is 'phiếu xuất bán (issue_type BAN)';
comment on column delivery_note.signed_at is 'ngày giờ khách nhận / ký';

create table delivery_note_line (
  id uuid not null default gen_random_uuid(),
  delivery_note_id uuid not null,
  lot_id uuid not null,
  delivered_qty numeric(14,3) not null,
  accepted_qty numeric(14,3) not null,
  returned_qty numeric(14,3) not null default 0,
  return_reason text,
  customer_takes_rest boolean,
  uom_code text not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (return_reason in ('TU_CHOI', 'HU', 'THIEU')),
  unique (delivery_note_id, lot_id),
  check (delivered_qty = accepted_qty + returned_qty),
  check (returned_qty = 0 or return_reason is not null),
  check (returned_qty = 0 or customer_takes_rest is not null)
);
comment on table delivery_note_line is 'Theo lô của phiếu xuất: SL đã xuất, SL khách nhận, SL không nhận + lý do (phần không nhận → nhập kho hàng khách trả). Mắt xích cuối "phiếu xuất → khách" của chuỗi truy xuất.';
comment on column delivery_note_line.customer_takes_rest is 'khách nhận thiếu: còn lấy phần không nhận (giao lần sau) hay không (giảm SL đơn) — bắt buộc khi có SL không nhận (04/11)';

create table sales_order_invoice (
  id uuid not null default gen_random_uuid(),
  sales_order_id uuid not null,
  goods_issue_id uuid not null,
  invoice_no text,
  invoice_date date,
  invoice_series text,
  tax_authority_code text,
  lookup_code text,
  total_amount numeric(18,2),
  status text not null default 'NHAP',
  invoice_file_id uuid,
  note text,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (status in ('NHAP', 'DA_PHAT_HANH', 'DA_HUY')),
  unique (sales_order_id, invoice_no),
  check (status <> 'DA_PHAT_HANH' or (invoice_no is not null and invoice_date is not null)),
  check (total_amount is null or total_amount >= 0)
);
comment on table sales_order_invoice is 'Hóa đơn bán hàng (sửa 04/11): Kế toán lập trên MES, in A4 (bản thể hiện của hóa đơn điện tử), hóa đơn gắn phiếu xuất bán; phát hành qua nhà cung cấp hóa đơn điện tử. Một đơn nhiều hóa đơn. Tổng quan Giám đốc có việc "Lập hóa đơn" cho lần giao chưa có hóa đơn.';
comment on column sales_order_invoice.goods_issue_id is 'phiếu xuất bán của hóa đơn (04/11)';
comment on column sales_order_invoice.invoice_no is 'số hóa đơn — có khi phát hành';
comment on column sales_order_invoice.invoice_series is 'ký hiệu hóa đơn';
comment on column sales_order_invoice.tax_authority_code is 'mã của cơ quan thuế';
comment on column sales_order_invoice.lookup_code is 'mã tra cứu hóa đơn';
comment on column sales_order_invoice.total_amount is 'tổng tiền thanh toán';
comment on column sales_order_invoice.invoice_file_id is 'file hóa đơn';

create table payment_voucher (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  code text not null,
  voucher_type text not null,
  purpose text not null,
  customer_id uuid,
  supplier_id uuid,
  sales_order_id uuid,
  purchase_order_id uuid,
  amount numeric(18,2) not null,
  paid_on date not null,
  method text not null,
  doc_file_id uuid not null,
  status text not null default 'DA_GHI_NHAN',
  cancel_reason text,
  cancelled_at timestamptz,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (voucher_type in ('THU', 'CHI')),
  check (purpose in ('TIEN_VE', 'HOAN_KHACH', 'TRA_NCC')),
  check (method in ('CK', 'TIEN_MAT')),
  check (status in ('DA_GHI_NHAN', 'DA_HUY')),
  unique (code),
  check ((customer_id is null) <> (supplier_id is null)),
  check (amount > 0),
  check ((voucher_type = 'THU') = (purpose = 'TIEN_VE')),
  check ((purpose = 'TRA_NCC') = (supplier_id is not null)),
  check (status <> 'DA_HUY' or (cancel_reason is not null and cancelled_at is not null))
);
comment on table payment_voucher is 'Bản ghi nhận thu / chi (sửa 19/10): mỗi lần Kế toán ghi nhận tiền về của khách, hoàn tiền cho khách hoặc đã trả NCC — số tiền, ngày, CK / tiền mặt, ảnh chứng từ. Chỉ ghi nhận: không duyệt, không hạch toán, hệ thống không tự sinh. Tiền về / hoàn của khách cấn vào khoản trong lịch thanh toán qua payment_allocation; trả NCC giảm khoản phải trả qua ap_entry. Màn Sổ thu chi liệt kê bảng này. Nhập sai thì hủy kèm lý do (không xóa).';
comment on column payment_voucher.purpose is 'TIEN_VE: tiền khách trả (cọc, trả đủ, trả nốt, chênh lệch, nợ quá hạn, công nợ — khoản cụ thể ở payment_allocation)';
comment on column payment_voucher.sales_order_id is 'đơn liên quan, nếu tiền chỉ cho 1 đơn';
comment on column payment_voucher.amount is 'số tiền';
comment on column payment_voucher.paid_on is 'ngày tiền về / ngày chi';
comment on column payment_voucher.doc_file_id is 'ảnh chứng từ (bắt buộc)';
comment on column payment_voucher.status is 'DA_HUY: nhập sai, Kế toán hủy kèm lý do';

create table payment_allocation (
  id uuid not null default gen_random_uuid(),
  voucher_id uuid not null,
  payment_schedule_id uuid not null,
  amount numeric(18,2) not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  unique (voucher_id, payment_schedule_id),
  check (amount > 0)
);
create index ix_payment_allocation_0 on payment_allocation (payment_schedule_id);
comment on table payment_allocation is 'Cấn số tiền ghi nhận vào khoản (sửa 19/10): 1 lần ghi nhận tiền về / hoàn tiền cấn được vào nhiều khoản trong lịch thanh toán (cọc, trả đủ, trả nốt, chênh lệch, công nợ). Hệ thống tạo khi Kế toán ghi nhận; tổng cấn không vượt số tiền ghi nhận (trigger). Cấn vào khoản công nợ thì ghi thêm ar_entry THU. Thứ tự cấn khi khách trả gộp: xem câu hỏi.';
comment on column payment_allocation.amount is 'số tiền cấn vào khoản';

create table ar_entry (
  id uuid not null default gen_random_uuid(),
  customer_id uuid not null,
  sales_order_id uuid,
  delivery_note_id uuid,
  voucher_id uuid,
  payment_schedule_id uuid,
  entry_type text not null,
  amount numeric(18,2) not null,
  due_date date,
  occurred_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (entry_type in ('PHAT_SINH', 'THU', 'CAN_TRU_COC', 'DIEU_CHINH')),
  check (entry_type <> 'PHAT_SINH' or (amount > 0 and due_date is not null))
);
create index ix_ar_entry_0 on ar_entry (customer_id, due_date);
comment on table ar_entry is 'Sổ công nợ phải thu: phát sinh theo phần khách đã nhận (mỗi lần ghi nhận giao) (Mua chịu), tiền về cấn vào công nợ, cấn trừ cọc, điều chỉnh (vd sửa đơn). Không có xóa nợ (bỏ 19/10): nợ quá 90 ngày GĐ / KTT quyết bên ngoài, Kế toán ghi kết quả ở payment_schedule. Dư nợ, nợ quá hạn và cờ tạm khóa khách tính tự động từ đây (khi kiểm khóa dòng customer bằng SELECT … FOR UPDATE).';
comment on column ar_entry.delivery_note_id is 'phát sinh công nợ theo lần ghi nhận khách nhận (24/10)';
comment on column ar_entry.payment_schedule_id is 'khoản công nợ tương ứng';
comment on column ar_entry.amount is '+ tăng nợ / − giảm nợ';

create table supplier (
  id uuid not null default gen_random_uuid(),
  code text not null,
  name text not null,
  tax_code text not null,
  address text,
  contact_name text,
  phone text,
  email text,
  payment_terms text,
  payment_days integer,
  deposit_pct numeric(5,2),
  payment_method text,
  bank_name text,
  bank_account_no text,
  bank_account_name text,
  status text not null default 'CHO_DUYET',
  status_reason text,
  approved_by uuid,
  approved_at timestamptz,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (payment_terms in ('TRA_TRUOC', 'COC_TRA_NOT', 'TRA_SAU')),
  check (payment_method in ('TIEN_MAT', 'CHUYEN_KHOAN', 'TM_CK')),
  check (status in ('CHO_DUYET', 'DA_DUYET', 'TU_CHOI', 'NGUNG_DUNG')),
  unique (code),
  unique (tax_code),
  check (status not in ('TU_CHOI','NGUNG_DUNG') or status_reason is not null),
  check (status <> 'DA_DUYET' or approved_by is not null),
  check (payment_terms is distinct from 'TRA_SAU' or payment_days is not null),
  check (payment_days is null or (payment_terms = 'TRA_SAU' and payment_days > 0)),
  check ((payment_terms = 'COC_TRA_NOT') = (deposit_pct is not null)),
  check (deposit_pct is null or (deposit_pct > 0 and deposit_pct < 100))
);
comment on table supplier is 'Hồ sơ NCC. Trạng thái CHO_DUYET / DA_DUYET / TU_CHOI / NGUNG_DUNG (dùng lại = duyệt lại như mới). Không đánh giá mẫu (bỏ 17/10): đủ hồ sơ pháp lý, chứng nhận còn hạn thì Trưởng BP Mua hàng duyệt. Không xóa, không chấm điểm.';
comment on column supplier.tax_code is 'MST, kiểm trùng';
comment on column supplier.payment_terms is 'điều khoản mặc định của NCC: Trả trước / Cọc + trả nốt trước giao (31/10) / Trả sau N ngày';
comment on column supplier.payment_days is 'N ngày (chỉ khi TRA_SAU)';
comment on column supplier.deposit_pct is 'tỷ lệ cọc (chỉ COC_TRA_NOT)';
comment on column supplier.payment_method is 'phương thức thanh toán';
comment on column supplier.bank_account_no is 'số tài khoản';
comment on column supplier.bank_account_name is 'chủ tài khoản';
comment on column supplier.status_reason is 'lý do từ chối / ngừng dùng';
comment on column supplier.approved_by is 'Trưởng BP Mua hàng';

create table supplier_status_log (
  id uuid not null default gen_random_uuid(),
  supplier_id uuid not null,
  from_status text,
  to_status text not null,
  reason text,
  actor_id uuid not null,
  occurred_at timestamptz not null default now(),
  primary key (id)
);
comment on table supplier_status_log is 'Nhật ký đổi trạng thái NCC kèm lý do.';

create table supplier_certificate (
  id uuid not null default gen_random_uuid(),
  supplier_id uuid not null,
  cert_type text not null,
  cert_no text not null,
  expiry_date date,
  file_id uuid,
  status text not null default 'DANG_DUNG',
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (status in ('DANG_DUNG', 'NGUNG_DUNG')),
  check (cert_type = 'GIAY_PHEP_KINH_DOANH' or expiry_date is not null)
);
comment on table supplier_certificate is 'Chứng nhận của NCC (loại, số, hạn, file).';
comment on column supplier_certificate.cert_type is 'loại; GIAY_PHEP_KINH_DOANH không cần hạn';
comment on column supplier_certificate.expiry_date is 'bắt buộc, trừ giấy phép kinh doanh (04/11)';

create table supplier_material (
  id uuid not null default gen_random_uuid(),
  supplier_id uuid not null,
  material_id uuid not null,
  status text not null default 'DE_XUAT',
  lead_days integer,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (status in ('DE_XUAT', 'DUOC_PHEP', 'KHONG_DUOC')),
  unique (supplier_id, material_id),
  check (lead_days is null or lead_days >= 0)
);
comment on table supplier_material is 'NVL NCC được phép cung cấp. QT12 chỉ cho chọn NCC ĐÃ DUYỆT có dòng DUOC_PHEP cho NVL đó.';
comment on column supplier_material.lead_days is 'thời gian giao hàng của NCC này cho NVL này (ngày) — ghi đè material.purchase_lead_days (24/10 đợt 12)';

create table supplier_history (
  id uuid not null default gen_random_uuid(),
  supplier_id uuid not null,
  event_type text not null,
  purchase_order_id uuid,
  supplier_return_id uuid,
  days_late integer,
  short_qty numeric(14,3),
  note text,
  occurred_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (event_type in ('TRA_HANG', 'GIAO_TRE', 'GIAO_THIEU')),
  check (event_type not in ('GIAO_TRE','GIAO_THIEU') or purchase_order_id is not null),
  check (event_type <> 'GIAO_TRE' or days_late > 0),
  check (event_type <> 'GIAO_THIEU' or short_qty > 0)
);
comment on table supplier_history is 'Lịch sử NCC để tra cứu, KHÔNG chấm điểm: trả hàng, giao trễ, giao thiếu. Hiện ở chi tiết NCC; giao trễ / giao thiếu ghi theo PO (04/11).';
comment on column supplier_history.days_late is 'GIAO_TRE: số ngày trễ so với ngày giao của PO';
comment on column supplier_history.short_qty is 'GIAO_THIEU: SL thiếu so với PO';

create table purchase_request (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  code text not null,
  source text not null,
  status text not null default 'MO',
  note text,
  cancel_reason text,
  cancelled_by uuid,
  cancelled_at timestamptz,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (source in ('NHU_CAU_SX', 'LAP_TAY')),
  check (status in ('MO', 'XONG', 'HUY')),
  unique (code),
  check (status <> 'HUY' or (cancel_reason is not null and cancelled_at is not null))
);
comment on table purchase_request is 'Yêu cầu mua NVL (màn Đơn mua, tab Hàng đợi mua). Sửa 24/10 (đợt 12): NHU_CAU_SX do hệ thống tính và tự lập, gửi thẳng Mua hàng (không Kế hoạch xác nhận): từng NVL = tổng NVL các lệnh chưa xuất đủ (kể cả lệnh Chờ NVL) − tồn khả dụng − hàng đã đặt chưa về (PO mở) + phần thiếu so với tồn tối thiểu; tính lại khi tạo / sửa / hủy lệnh, khi nhập kho / PO đổi và mỗi đêm; mỗi NVL chỉ 1 dòng trong các yêu cầu NHU_CAU_SX đang MO của nhà máy (trigger) — lần tính sau cộng dồn / giảm SL dòng đó; lệnh hủy → dòng chưa lập PO tự giảm / hủy, đã có PO thì báo Mua hàng. LAP_TAY: Kế hoạch lập tay (lý do lập). Sửa 04/11 — bỏ báo giá: các dòng gộp thành Hàng đợi mua theo NVL × kho nhận; Mua hàng nhập đơn giá rồi lập PO (dòng cùng NCC × kho gộp 1 PO), hoặc trả về Kế hoạch kèm lý do.';
comment on column purchase_request.source is 'NHU_CAU_SX: hệ thống tính (lệnh SX + tồn tối thiểu); LAP_TAY: Kế hoạch lập (24/10 đợt 12 — thay LENH_SX / TON_TOI_THIEU)';
comment on column purchase_request.status is 'MO → XONG khi mọi dòng đã lập PO / trả về / hủy; bỏ DANG_MUA (bỏ báo giá 04/11)';
comment on column purchase_request.note is 'lý do lập (LAP_TAY)';

create table purchase_request_line (
  id uuid not null default gen_random_uuid(),
  request_id uuid not null,
  material_id uuid not null,
  warehouse_id uuid not null,
  qty numeric(14,3) not null,
  uom_code text not null,
  needed_date date,
  suggested_supplier_id uuid,
  production_order_ids uuid[],
  status text not null default 'MO',
  po_line_id uuid,
  return_reason text,
  returned_by uuid,
  returned_at timestamptz,
  cancel_reason text,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (status in ('MO', 'DA_LAP_PO', 'TRA_VE_KE_HOACH', 'HUY')),
  unique (request_id, material_id, warehouse_id),
  check (qty > 0),
  check ((status = 'DA_LAP_PO') = (po_line_id is not null)),
  check (status <> 'TRA_VE_KE_HOACH' or (return_reason is not null and returned_at is not null)),
  check (status <> 'HUY' or cancel_reason is not null)
);
comment on table purchase_request_line is 'Dòng yêu cầu mua = 1 dòng của Hàng đợi mua: NVL × kho nhận, SL, ngày cần, NCC gợi ý, các lệnh liên quan; trạng thái theo Hàng đợi mua (04/11).';
comment on column purchase_request_line.warehouse_id is 'kho nhận (04/11)';
comment on column purchase_request_line.needed_date is 'ngày cần có hàng = ngày dự kiến chạy sớm nhất của các lệnh liên quan − thời gian giao hàng (NCC × NVL, mặc định theo NVL)';
comment on column purchase_request_line.suggested_supplier_id is 'NCC gợi ý (đã duyệt, được phép cung cấp NVL)';
comment on column purchase_request_line.production_order_ids is 'các lệnh SX cần NVL này (truy ngược nhu cầu)';
comment on column purchase_request_line.status is 'MO: trong Hàng đợi mua; TRA_VE_KE_HOACH: Mua hàng không mua được, Kế hoạch chọn cách bù khác';
comment on column purchase_request_line.po_line_id is 'dòng PO đã lập (PO hủy / từ chối / đóng phần còn lại thì gỡ, dòng về MO)';

create table purchase_order (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  code text not null,
  supplier_id uuid not null,
  warehouse_id uuid not null,
  status text not null default 'CHO_COA_HSD',
  payment_terms text,
  payment_days integer,
  deposit_pct numeric(5,2),
  payment_method text,
  payment_note text,
  payment_chosen_by uuid,
  payment_chosen_at timestamptz,
  coa_required boolean not null default true,
  coa_requested_at timestamptz,
  coa_requested_by uuid,
  coa_request_email text,
  coa_result text,
  coa_checked_by uuid,
  coa_checked_at timestamptz,
  total_amount numeric(18,2) not null,
  approved_by uuid,
  approved_at timestamptz,
  director_approved_by uuid,
  director_approved_at timestamptz,
  sent_at timestamptz,
  cancelled_by uuid,
  cancelled_at timestamptz,
  cancel_reason text,
  rejected_by uuid,
  rejected_at timestamptz,
  reject_reason text,
  closed_by uuid,
  closed_at timestamptz,
  close_reason text,
  note text,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (status in ('CHO_COA_HSD', 'CHO_CHON_THANH_TOAN', 'CHO_DUYET', 'DA_DUYET', 'DA_GUI_NCC', 'NHAN_MOT_PHAN', 'DA_NHAN_DU', 'DA_DONG', 'TU_CHOI', 'DA_HUY')),
  check (payment_terms in ('TRA_TRUOC', 'COC_TRA_NOT', 'TRA_SAU')),
  check (payment_method in ('TIEN_MAT', 'CHUYEN_KHOAN', 'TM_CK')),
  check (coa_result in ('DAT', 'KHONG_DAT')),
  unique (code),
  check (payment_terms <> 'TRA_SAU' or payment_days is not null),
  check (approved_by is null or approved_by <> created_by),
  check (status <> 'DA_HUY' or cancel_reason is not null),
  check (payment_days is null or (payment_terms = 'TRA_SAU' and payment_days > 0)),
  check ((payment_terms = 'COC_TRA_NOT') = (deposit_pct is not null)),
  check (deposit_pct is null or (deposit_pct > 0 and deposit_pct < 100)),
  check (status in ('CHO_COA_HSD','CHO_CHON_THANH_TOAN','DA_HUY') or payment_terms is not null),
  check (status in ('CHO_COA_HSD','DA_HUY') or coa_result = 'DAT'),
  check ((coa_result is null) = (coa_checked_at is null)),
  check (status <> 'TU_CHOI' or reject_reason is not null),
  check (status <> 'DA_DONG' or close_reason is not null)
);
comment on table purchase_order is 'PO (sửa 04/11 — bỏ báo giá): Mua hàng lập từ Hàng đợi mua (nhập đơn giá; dòng cùng NCC × kho nhận gộp 1 PO) → Chờ COA & HSD: gửi NCC 1 email yêu cầu COA và hạn dùng cho mọi NVL của PO, kiểm COA & HSD theo chỉ tiêu danh mục NVL (purchase_order_coa_result) — đạt thì Chờ chọn thanh toán, không đạt thì hủy PO, NVL quay lại Hàng đợi mua (30/10, 31/10) → chọn hình thức thanh toán → Chờ duyệt (Trưởng BP Mua hàng; GĐ duyệt thêm khi vượt ngưỡng) → Đã duyệt → gửi PO cho NCC qua email → nhận một phần / đủ; Đóng phần còn lại; Từ chối (lý do). PO đã duyệt chỉ Trưởng BP Mua hàng hủy được (ghi lý do).';
comment on column purchase_order.warehouse_id is 'kho nhận (04/11)';
comment on column purchase_order.status is 'theo mockup (30/10, 31/10): bỏ Nháp, thêm Chờ COA & HSD, Chờ chọn thanh toán, Đã đóng, Từ chối';
comment on column purchase_order.payment_terms is 'hình thức thanh toán, chọn ở bước Chờ chọn thanh toán (31/10): Trả trước / Cọc + trả nốt trước giao / Trả sau N ngày';
comment on column purchase_order.payment_days is 'N ngày (chỉ khi TRA_SAU)';
comment on column purchase_order.deposit_pct is '% cọc (chỉ COC_TRA_NOT)';
comment on column purchase_order.payment_method is 'phương thức thanh toán';
comment on column purchase_order.coa_requested_at is 'lúc gửi email yêu cầu COA & HSD cho NCC';
comment on column purchase_order.coa_request_email is 'email NCC nhận yêu cầu';
comment on column purchase_order.coa_result is 'kết quả kiểm COA & HSD của cả PO (đạt khi mọi NVL đạt)';
comment on column purchase_order.approved_by is 'Trưởng BP Mua hàng';
comment on column purchase_order.director_approved_by is 'GĐ (vượt ngưỡng tham số)';
comment on column purchase_order.cancelled_by is 'hủy PO đã duyệt: Trưởng BP Mua hàng';
comment on column purchase_order.rejected_by is 'Trưởng BP Mua hàng / GĐ từ chối';
comment on column purchase_order.closed_by is 'Đóng phần còn lại';

create table purchase_order_line (
  id uuid not null default gen_random_uuid(),
  po_id uuid not null,
  line_no integer not null,
  material_id uuid not null,
  qty numeric(14,3) not null,
  uom_code text not null,
  unit_price numeric(18,2) not null,
  received_qty numeric(14,3) not null default 0,
  expected_date date,
  coa_file_id uuid,
  coa_mfg_date date,
  coa_exp_date date,
  coa_passed boolean,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  unique (po_id, line_no),
  check (qty > 0 and received_qty >= 0),
  check (coa_exp_date is null or coa_mfg_date is null or coa_exp_date > coa_mfg_date)
);
comment on table purchase_order_line is 'Dòng PO: NVL, SL, đơn giá (Mua hàng nhập ở Hàng đợi mua), SL đã nhận (nhận một phần); COA, NSX, HSD NCC gửi trước khi duyệt PO (04/11).';
comment on column purchase_order_line.coa_file_id is 'COA NCC gửi cho NVL này';
comment on column purchase_order_line.coa_mfg_date is 'NSX của lô dự kiến giao (NCC báo)';
comment on column purchase_order_line.coa_exp_date is 'HSD của lô dự kiến giao';
comment on column purchase_order_line.coa_passed is 'kết quả kiểm COA & HSD của NVL';

create table purchase_order_coa_result (
  id uuid not null default gen_random_uuid(),
  po_line_id uuid not null,
  spec_item_id uuid not null,
  criterion_name text not null,
  min_value numeric,
  max_value numeric,
  expected_text text,
  coa_value_num numeric,
  coa_value_text text,
  passed boolean not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  unique (po_line_id, spec_item_id)
);
comment on table purchase_order_coa_result is 'Kết quả kiểm COA & HSD của PO theo từng NVL × chỉ tiêu (30/10, 31/10): giá trị trên COA NCC gửi so với chỉ tiêu material_spec_item, chép lại giới hạn lúc kiểm.';

create table ap_entry (
  id uuid not null default gen_random_uuid(),
  supplier_id uuid not null,
  purchase_order_id uuid,
  supplier_return_id uuid,
  voucher_id uuid,
  entry_type text not null,
  amount numeric(18,2) not null,
  due_date date,
  occurred_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (entry_type in ('PHAT_SINH', 'TRA_TIEN', 'GIAM_TRU_TRA_HANG', 'DIEU_CHINH'))
);
comment on table ap_entry is 'Sổ công nợ phải trả NCC: phát sinh theo PO (trả sau), đã trả (Kế toán ghi nhận, không duyệt), giảm trừ khi trả hàng. Màn Công nợ NCC tính khoản phải trả từ đây.';

create table supplier_return (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  code text not null,
  supplier_id uuid not null,
  purchase_order_id uuid not null,
  goods_receipt_id uuid,
  source text not null,
  reason text not null,
  photo_file_ids uuid[] not null default '{}',
  qc_inspection_id uuid,
  supplier_accepted boolean,
  disagreement_file_id uuid,
  outcome text,
  resolution text,
  goods_issue_id uuid,
  disposal_id uuid,
  replacement_receipt_id uuid,
  ap_adjust_amount numeric(18,2),
  status text not null default 'CHO_NCC_XAC_NHAN',
  export_requested_by uuid,
  export_requested_at timestamptz,
  export_approved_by uuid,
  export_approved_at timestamptz,
  export_reject_reason text,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (source in ('DA_NHAP_KHO', 'BAO_HU_KHI_NHAN', 'TU_CHOI_CUA_KHO')),
  check (reason in ('HU', 'QC_KHONG_DAT')),
  check (outcome in ('NCC_NHAN_LAI', 'NHA_MAY_CHIU')),
  check (resolution in ('DOI_1_1', 'GIAM_CONG_NO')),
  check (status in ('CHO_NCC_XAC_NHAN', 'KHONG_THONG_NHAT', 'NCC_CHAP_NHAN', 'CHO_DUYET_XUAT_TRA', 'CHO_KHO_XUAT_TRA', 'DA_XUAT_TRA', 'CHO_KY_XAC_NHAN', 'HOAN_TAT', 'CHUYEN_HUY')),
  unique (code),
  check (outcome is null or outcome <> 'NHA_MAY_CHIU' or resolution is null),
  check (status not in ('CHO_DUYET_XUAT_TRA','CHO_KHO_XUAT_TRA','DA_XUAT_TRA') or export_requested_at is not null),
  check (status not in ('CHO_KHO_XUAT_TRA','DA_XUAT_TRA') or (export_approved_by is not null and export_approved_at is not null)),
  check (export_approved_by is null or export_approved_by is distinct from export_requested_by),
  check (status <> 'DA_XUAT_TRA' or goods_issue_id is not null)
);
comment on table supplier_return is 'Phiếu trả hàng NCC (Mua hàng lập). Tranh chấp / kiểm nghiệm bên thứ 3 không có trong hệ thống (nhà máy tự xử lý ngoài) — chỉ ghi biên bản không thống nhất và kết quả cuối. Sửa 19/10 (đợt 2): Mua hàng gửi yêu cầu xuất trả; Thủ kho lập phiếu xuất loại TRA_NCC (chỉ khi phiếu trả đang CHO_KHO_XUAT_TRA); xuất xong → DA_XUAT_TRA. Sửa 24/10 (đợt 6): gửi yêu cầu xuất trả → CHO_DUYET_XUAT_TRA; Trưởng BP Mua hàng duyệt (export_approved_by, không phải người gửi) → CHO_KHO_XUAT_TRA, hoặc từ chối bắt buộc lý do → MO (trigger); phiếu xuất trả không còn Thủ kho trưởng duyệt. Giảm trừ do Kế toán ghi ở Công nợ NCC (ap_entry). Không trả vượt SL đã nhận của PO (cộng mọi phiếu trả của PO); PO trả trước không chọn GIAM_CONG_NO (trigger).';
comment on column supplier_return.purchase_order_id is 'bắt buộc (đợt 3) — mọi phiếu trả gắn PO';
comment on column supplier_return.source is 'hàng trả từ đâu: đã nhập kho / bao hư khi nhận / từ chối ở cửa kho (không có lô)';
comment on column supplier_return.photo_file_ids is 'ảnh hàng lỗi, nhiều ảnh, không bắt buộc (04/11)';
comment on column supplier_return.disagreement_file_id is 'biên bản không thống nhất';
comment on column supplier_return.resolution is 'GIAM_CONG_NO không chọn được khi PO là TRA_TRUOC (trigger)';
comment on column supplier_return.goods_issue_id is 'phiếu xuất trả NCC';
comment on column supplier_return.disposal_id is 'nhà máy chịu → hủy';
comment on column supplier_return.replacement_receipt_id is 'hàng đổi về';
comment on column supplier_return.ap_adjust_amount is 'số tiền giảm trừ khoản phải trả — Kế toán ghi ở Công nợ NCC';
comment on column supplier_return.status is 'theo mockup (04/11): Chờ NCC xác nhận → NCC chấp nhận / Không thống nhất → Chờ duyệt xuất trả → Chờ kho xuất trả → Đã xuất trả → Chờ ký xác nhận → Hoàn tất; nhà máy chịu → Chuyển hủy';
comment on column supplier_return.export_requested_by is 'Mua hàng gửi yêu cầu xuất trả';
comment on column supplier_return.export_approved_by is 'Trưởng BP Mua hàng duyệt / từ chối yêu cầu xuất trả (24/10 đợt 6)';
comment on column supplier_return.export_reject_reason is 'lý do từ chối yêu cầu xuất trả (phiếu về NCC_CHAP_NHAN)';

create table supplier_return_line (
  id uuid not null default gen_random_uuid(),
  return_id uuid not null,
  lot_id uuid,
  material_id uuid not null,
  supplier_lot_no text,
  qty numeric(14,3) not null,
  uom_code text not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (qty > 0),
  check (lot_id is null or supplier_lot_no is not null)
);
comment on table supplier_return_line is 'Dòng trả: lô (null = hàng bị từ chối ở cửa kho, không có lô), số lô NCC, SL theo ĐVT gốc của NVL (trigger). Dòng có lô: tổng SL trả theo NVL của mọi phiếu trả cùng PO (kể cả phiếu nhà máy chịu) ≤ SL đã nhận của PO; SL trả của lô (cộng các phiếu chưa xuất xong) ≤ tồn hiện có của lô (trigger, đợt 3). Dòng không lô so với SL trong biên bản từ chối ở cửa kho (ứng dụng), không tính vào số đã nhận.';
comment on column supplier_return_line.supplier_lot_no is 'số lô NCC — bắt buộc với dòng có lô (04/11)';

create table production_order (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  code text not null,
  order_kind text not null,
  work_area_id uuid not null,
  demand_kind text not null default 'THEO_DON',
  sales_order_id uuid,
  sales_order_version_no integer,
  formula_version_id uuid not null,
  planned_batch_count integer not null,
  makeup_batch_count integer not null default 0,
  batch_weight_kg numeric(12,3) not null,
  loss_pct numeric(5,2) not null default 0,
  order_received_at timestamptz,
  planned_finish_date date,
  marketing_user_id uuid,
  status text not null default 'MOI_TAO',
  material_reserved_at timestamptz,
  queue_priority integer,
  silo_plan_status text not null default 'DA_CHOT',
  dispatch_attempts integer not null default 0,
  last_dispatch_at timestamptz,
  nm_ack_at timestamptz,
  nm_check_result text,
  nm_check_fail_reason text,
  nm_checked_at timestamptz,
  started_at timestamptz,
  finished_at timestamptz,
  cancel_reason text,
  cancel_requested_at timestamptz,
  cancel_requested_by uuid,
  nm_cancel_confirmed_at timestamptz,
  ended_early_at timestamptz,
  ended_early_by uuid,
  early_end_reason text,
  actual_batch_count integer,
  created_site text not null default 'CLOUD',
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (order_kind in ('HH', 'BTP')),
  check (demand_kind in ('THEO_DON', 'TON_KHO')),
  check (status in ('MOI_TAO', 'CHO_PHAT', 'DA_NHAN', 'DANG_CHAY', 'HOAN_THANH', 'DA_HUY')),
  check (silo_plan_status in ('DA_CHOT', 'CAN_XEP_LAI')),
  check (nm_check_result in ('DAT', 'KHONG_DAT')),
  check (created_site in ('CLOUD')),
  unique (code),
  check (planned_batch_count > 0 and batch_weight_kg > 0),
  check (status <> 'DA_HUY' or cancel_reason is not null),
  check (makeup_batch_count >= 0),
  check (queue_priority is null or queue_priority > 0),
  check (status not in ('MOI_TAO','CHO_PHAT') or queue_priority is not null),
  check (cancel_requested_at is null or cancel_reason is not null),
  check (nm_cancel_confirmed_at is null or cancel_requested_at is not null),
  check (ended_early_at is null or (status = 'HOAN_THANH' and early_end_reason is not null and actual_batch_count is not null)),
  check (demand_kind <> 'TON_KHO' or sales_order_id is null),
  check (nm_check_result is distinct from 'KHONG_DAT' or nm_check_fail_reason is not null),
  check ((nm_check_result is null) = (nm_checked_at is null)),
  check (loss_pct between 0 and 50)
);
create index ix_production_order_0 on production_order (work_area_id, status);
comment on table production_order is 'Lệnh SX. Không tạo được ở server nhà máy. Lệnh đã phát giữ phiên bản công thức lúc phát. Sửa 19/10 (đợt 2): lệnh thuộc 1 khu (loại lệnh theo khu, KL mẻ ≤ mức tối đa của khu); 9 điều kiện tạo theo thứ tự (khu · đơn & khách · công thức · thời gian · NV tiếp thị · số mẻ & KL mẻ · tệp giấy tờ xuất xứ NVL · tồn NVL · dàn silo — sửa 05/11: bỏ giấy tờ xuất xứ NVL, thêm % hao hụt bù vào khối lượng phải sản xuất); phương án silo ở production_order_silo, chốt khi tạo (kiểm lúc COMMIT), kiểm lại khi phát. Mỗi khu một hàng đợi = thứ tự chạy ở nhà máy (queue_priority, lệnh MOI_TAO / CHO_PHAT; phát lệnh đầu hàng, lệnh Chờ phát giữ vị trí). Trạng thái MOI_TAO → CHO_PHAT (chỉ khi phát mà nhà máy không nhận) → DA_NHAN → DANG_CHAY → HOAN_THANH; DA_HUY (từ MOI_TAO / CHO_PHAT / DA_NHAN, bắt buộc lý do, tự giải phóng giữ chỗ). Không nháp, không xóa (trigger). Sửa 19/10 (đợt 3): chỉ sửa lệnh MOI_TAO; lệnh đã phát chỉ hủy — Chờ phát / Đã nhận cần nhà máy xác nhận chưa chạy mẻ; lệnh đang chạy chỉ kết thúc sớm (lý do, số mẻ thực tế, không có mẻ đang chạy dở) hoặc thêm mẻ bù; HOÀN THÀNH chỉ khi mọi nút silo của lệnh đã xả sạch (trigger). Sửa 24/10 (đợt 12): tồn NVL không chặn tạo lệnh — thiếu thì lệnh MOI_TAO không giữ chỗ (material_reserved_at null = Chờ NVL), không phát được (trigger); Kiểm tra lại đủ thì giữ chỗ, ghi material_reserved_at. Sửa 04/11: có lệnh sản xuất tồn kho (demand_kind TON_KHO, nhu cầu đơn không bắt buộc); lệnh BTP thêm 2 điều kiện: SP có bản công bố còn hiệu lực và quy cách có mẫu nhãn đã duyệt (trigger trên production_order_brand).';
comment on column production_order.order_kind is 'theo loại khu của work_area (trigger)';
comment on column production_order.work_area_id is 'khu sản xuất (điều kiện 1); khu HH / BTP đang dùng, cùng nhà máy';
comment on column production_order.demand_kind is 'TON_KHO: lệnh sản xuất tồn kho, không theo đơn — không gắn đơn (chốt 04/11)';
comment on column production_order.formula_version_id is 'phiên bản lúc phát; lệnh DANG_CHAY trỏ phiên bản không còn hiệu lực → hiện ở màn Công thức';
comment on column production_order.makeup_batch_count is 'số mẻ bù vì mẻ hủy do sự cố (QT20 kb); tổng mẻ phải chạy = planned_batch_count + makeup_batch_count';
comment on column production_order.batch_weight_kg is '≤ work_area.max_batch_kg (trigger)';
comment on column production_order.loss_pct is '% hao hụt (05/11): khối lượng phải sản xuất = khối lượng cần × (1 + % hao hụt), số mẻ / KL mẻ tính theo số này; 0 = không tính hao hụt';
comment on column production_order.order_received_at is 'thời gian nhận đơn';
comment on column production_order.planned_finish_date is 'dự kiến xong';
comment on column production_order.marketing_user_id is 'NV tiếp thị';
comment on column production_order.status is 'MOI_TAO (đã giữ chỗ KG, trong hàng đợi) → CHO_PHAT (chỉ khi phát mà nhà máy không nhận) → DA_NHAN → DANG_CHAY → HOAN_THANH; DA_HUY. Chuyển sai thứ tự bị chặn (trigger)';
comment on column production_order.material_reserved_at is 'lúc giữ chỗ NVL; null = lệnh Chờ NVL (tồn khả dụng chưa đủ khi tạo) — không phát được (trigger), Kế hoạch bấm Kiểm tra lại khi hàng về (24/10 đợt 12)';
comment on column production_order.queue_priority is 'thứ tự trong hàng đợi của khu = thứ tự chạy ở nhà máy (1 = đầu hàng) — bắt buộc khi MOI_TAO / CHO_PHAT (Chờ phát giữ vị trí); không trùng trong 1 khu (ràng buộc loại trừ, kiểm lúc COMMIT); chỉ phát lệnh không có lệnh Mới tạo / Chờ phát nào đứng trước (trigger)';
comment on column production_order.silo_plan_status is 'CAN_XEP_LAI: silo trong phương án chuyển bảo trì / ngừng dùng khi lệnh còn Mới tạo → báo Kế hoạch, chặn phát tới khi xếp lại (trigger)';
comment on column production_order.nm_ack_at is 'server nhà máy xác nhận đã nhận';
comment on column production_order.nm_check_result is 'máy chủ nhà máy tự kiểm khi nhận lệnh (thay bước Kế hoạch xác nhận cho lệnh xuống PC — 04/11)';
comment on column production_order.nm_check_fail_reason is 'lý do không đạt';
comment on column production_order.cancel_requested_at is 'Kế hoạch gửi hủy lệnh đã phát (Chờ phát / Đã nhận) — chờ nhà máy xác nhận';
comment on column production_order.nm_cancel_confirmed_at is 'nhà máy xác nhận chưa chạy mẻ → mới ĐÃ HỦY được (trigger)';
comment on column production_order.ended_early_at is 'kết thúc sớm lệnh đang chạy (QT19 kt) → HOÀN THÀNH';
comment on column production_order.early_end_reason is 'lý do kết thúc sớm (bắt buộc)';
comment on column production_order.actual_batch_count is 'số mẻ thực tế khi kết thúc sớm';

create table production_order_brand (
  id uuid not null default gen_random_uuid(),
  production_order_id uuid not null,
  product_id uuid not null,
  product_pack_id uuid not null,
  sales_order_line_id uuid,
  printed_lot_no text,
  planned_can_count integer not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (planned_can_count > 0)
);
create unique index ux_production_order_brand_0 on production_order_brand (production_order_id, product_id, printed_lot_no) nulls not distinct;
comment on table production_order_brand is 'Kế hoạch nhãn hiệu của lệnh BTP, nhiều dòng: SP (nhãn hiệu), số lô in trên lon (nếu đã biết), số lon kế hoạch — lấy từ các dòng đơn có cùng công thức (SP phải dùng công thức của lệnh, chỉ lệnh BTP, chỉ sửa khi lệnh MOI_TAO — trigger); nạp vào máy chiết (QT21 yn). Sửa 04/11: mỗi dòng chọn quy cách của SP; lệnh BTP chỉ tạo khi SP có bản công bố và mẫu nhãn đã duyệt.';
comment on column production_order_brand.product_pack_id is 'quy cách đóng gói của SP (04/11)';
comment on column production_order_brand.sales_order_line_id is 'dòng đơn nguồn (cùng công thức)';
comment on column production_order_brand.printed_lot_no is 'số lô in trên lon (nếu đã biết); số lô in khi chiết vẫn ⏸ ở filling_run';

create table production_order_silo (
  id uuid not null default gen_random_uuid(),
  production_order_id uuid not null,
  material_id uuid not null,
  silo_equipment_id uuid not null,
  kg_per_batch numeric(12,3) not null,
  is_adjusted boolean not null default false,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  unique (production_order_id, material_id),
  unique (production_order_id, silo_equipment_id),
  check (kg_per_batch > 0)
);
create index ix_production_order_silo_0 on production_order_silo (silo_equipment_id);
comment on table production_order_silo is 'Phương án dàn silo của lệnh (thêm 19/10 đợt 2): mỗi NVL của công thức → 1 silo của khu. Hệ thống gợi ý theo gán cứng và sức chứa, Kế hoạch kéo thả chỉnh (is_adjusted); chốt khi tạo lệnh (đủ mọi NVL, kiểm lúc COMMIT), kiểm lại khi phát. Điều kiện (trigger): silo thuộc khu của lệnh, đang hoạt động, đúng gán cứng, NVL có trong công thức, KL / mẻ ≤ sức chứa (silo nạp nhiều mẻ, nạp bổ sung — sức chứa kiểm ở mỗi lần nạp, lot_link); 1 NVL – 1 silo, 1 silo – 1 NVL trong 1 lệnh ⇒ số NVL ≤ số silo đang hoạt động. Chỉ sửa khi lệnh MOI_TAO (đợt 3: lệnh đã phát không sửa).';
comment on column production_order_silo.material_id is 'NVL của công thức (formula_item của phiên bản lệnh)';
comment on column production_order_silo.silo_equipment_id is 'silo của khu (equipment loại SILO)';
comment on column production_order_silo.kg_per_batch is 'KL NVL này / mẻ — ≤ equipment.capacity_kg';
comment on column production_order_silo.is_adjusted is 'Kế hoạch kéo thả khác gợi ý của hệ thống';

create table material_reservation (
  id uuid not null default gen_random_uuid(),
  production_order_id uuid not null,
  material_id uuid not null,
  reserved_kg numeric(14,3) not null,
  makeup_kg numeric(14,3) not null default 0,
  issued_kg numeric(14,3) not null default 0,
  released_kg numeric(14,3) not null default 0,
  status text not null default 'MO',
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (status in ('MO', 'DA_XUAT_DU', 'DA_GIAI_PHONG')),
  unique (production_order_id, material_id),
  check (reserved_kg > 0 and issued_kg >= 0 and released_kg >= 0 and released_kg <= reserved_kg),
  check (makeup_kg >= 0 and makeup_kg <= reserved_kg)
);
comment on table material_reservation is 'Giữ chỗ NVL theo KG cho lệnh, KHÔNG gắn lô: KG = định mức × số mẻ; xuất SX trừ dần (issued_kg). Tồn dùng được cho SX = KG lô ĐẠT có hạn còn ≥ ngưỡng tối thiểu cho SX (production.min_shelf_days, mặc định 30 ngày — 24/10 đợt 9), đang ở kho (không tính hàng đang chuyển) − Σ(reserved − issued − released).';
comment on column material_reservation.makeup_kg is 'phần giữ thêm cho mẻ bù (đã gồm trong reserved_kg)';

create table production_batch (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  batch_no text not null,
  production_order_id uuid not null,
  seq_in_order integer not null,
  batch_kind text not null,
  formula_version_id uuid not null,
  work_area_id uuid not null,
  batch_lot_id uuid,
  started_at timestamptz not null,
  ended_at timestamptz,
  status text not null default 'DANG_CHAY',
  is_makeup boolean not null default false,
  started_offline boolean not null default false,
  source_event_id uuid,
  origin_site text not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (batch_kind in ('HH', 'BTP')),
  check (status in ('DANG_CHAY', 'DUNG_SU_CO', 'HOAN_THANH', 'DA_HUY')),
  check (origin_site in ('CLOUD', 'NM')),
  unique (factory_id, batch_no),
  unique (production_order_id, seq_in_order),
  check (ended_at is null or ended_at >= started_at),
  check (status <> 'DA_HUY' or ended_at is not null)
);
create unique index ux_production_batch_0 on production_batch (batch_lot_id) where batch_lot_id is not null;
create unique index ux_production_batch_1 on production_batch (source_event_id) where source_event_id is not null;
comment on table production_batch is 'Mẻ HH / BTP: ghi số phiên bản công thức, khu, thời gian, trạng thái. Mỗi mẻ có 1 lô mẻ (lot_kind = ME) làm nút trong chuỗi liên kết. Mốc thời gian + thiết bị là điểm nối dữ liệu cảm biến sau này. Tạo mẻ (Start) bị chặn khi silo trong phương án silo của lệnh không hoạt động (bảo trì / ngừng dùng — trigger, đợt 3).';
comment on column production_batch.formula_version_id is 'ghi số phiên bản';
comment on column production_batch.batch_lot_id is 'lô mẻ (ME)';
comment on column production_batch.status is 'DUNG_SU_CO: đang dừng chờ khắc phục; DA_HUY: Kế hoạch quyết hủy (batch_cancellation)';
comment on column production_batch.is_makeup is 'mẻ bù cho mẻ đã hủy';

create table batch_cancellation (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  batch_id uuid not null,
  production_order_id uuid not null,
  downtime_id uuid,
  reason text not null,
  discarded_kg numeric(12,3) not null,
  scrap_lot_id uuid,
  disposal_id uuid,
  site_command_id uuid,
  makeup_batch boolean not null default true,
  makeup_reserved jsonb,
  decided_by uuid not null,
  decided_at timestamptz not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  unique (batch_id),
  check (discarded_kg >= 0),
  check (scrap_lot_id is null or disposal_id is not null)
);
comment on table batch_cancellation is 'Hủy mẻ do sự cố không khắc phục được (QT20 hx → kh → ky → kr → kb): công nhân báo, Kế hoạch quyết hủy, ghi lý do và số kg bột bỏ. Lưu là trong 1 giao dịch: mẻ → ĐÃ HỦY; tạo lô bột hỏng (HONG) nối từ lô mẻ (RA_ME) để truy xuất và cân bằng khối lượng tính vào ô hủy; phần lô KHÓA lý do chờ hủy; tự tạo phiếu hủy (QT18); thêm 1 mẻ bù vào lệnh đang chạy và giữ thêm NVL theo KG. NVL đã đổ vào mẻ giữ nguyên liên kết DO_VAO_ME.';
comment on column batch_cancellation.batch_id is 'mẻ bị hủy';
comment on column batch_cancellation.downtime_id is 'sự cố gốc, nếu đã ghi';
comment on column batch_cancellation.reason is 'sự cố gì, vì sao không khắc phục được';
comment on column batch_cancellation.discarded_kg is 'số kg bột bỏ';
comment on column batch_cancellation.scrap_lot_id is 'lô bột hỏng (HONG), KHÓA chờ hủy';
comment on column batch_cancellation.disposal_id is 'phiếu hủy hệ thống tự tạo (nguồn HUY_ME)';
comment on column batch_cancellation.site_command_id is 'lệnh HUY_ME gửi xuống nhà máy (Chờ gửi khi nhà máy mất mạng); nhà máy áp khi mẻ còn DUNG_SU_CO, khác thì TU_CHOI';
comment on column batch_cancellation.makeup_batch is 'thêm 1 mẻ bù vào lệnh (kb)';
comment on column batch_cancellation.makeup_reserved is 'KG NVL giữ thêm cho mẻ bù, theo từng NVL';
comment on column batch_cancellation.decided_by is 'Kế hoạch (kh)';

create table batch_operator (
  id uuid not null default gen_random_uuid(),
  batch_id uuid not null,
  user_id uuid not null,
  work_area_id uuid not null,
  joined_at timestamptz not null,
  left_at timestamptz,
  origin_site text not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (origin_site in ('CLOUD', 'NM')),
  unique (batch_id, user_id, joined_at)
);
comment on table batch_operator is 'Người vận hành mẻ (công nhân quét thẻ; chỉ thao tác mẻ của khu mình).';

create table batch_equipment_usage (
  id uuid not null default gen_random_uuid(),
  batch_id uuid not null,
  equipment_id uuid not null,
  started_at timestamptz not null,
  ended_at timestamptz,
  origin_site text not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (origin_site in ('CLOUD', 'NM')),
  check (ended_at is null or ended_at >= started_at)
);
comment on table batch_equipment_usage is 'ĐIỂM NỐI IoT: thiết bị nào chạy cho mẻ nào, từ lúc nào đến lúc nào (thiết bị nạp khi triển khai). Dữ liệu cảm biến (chuỗi thời gian) sau này nối theo equipment.iot_source_ref + khoảng thời gian — không thiết kế bảng cảm biến ở đây.';

create table silo_charge (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  production_order_id uuid not null,
  handling_unit_id uuid not null,
  lot_id uuid not null,
  qty_kg numeric(12,3) not null,
  scan_result text not null,
  block_reason text,
  silo_equipment_id uuid not null,
  silo_lot_id uuid,
  lot_link_id uuid,
  scanned_at timestamptz not null,
  source_event_id uuid,
  origin_site text not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (scan_result in ('OK', 'CHAN')),
  check (origin_site in ('CLOUD', 'NM')),
  check (scan_result <> 'OK' or (lot_link_id is not null and silo_lot_id is not null))
);
create unique index ux_silo_charge_0 on silo_charge (source_event_id) where source_event_id is not null;
comment on table silo_charge is 'Mỗi lần quét bao (NVL / HH) nạp silo của lệnh (đổi tên từ batch_material_scan 19/10 đợt 3 — bao không đổ thẳng vào mẻ nữa). Quét OK phải sinh 1 dòng lot_link NAP_SILO vào nút silo đang mở trong CÙNG giao dịch; không ghi được thì chặn, không mở silo. Silo phải đúng silo xếp cho NVL của bao trong phương án silo của lệnh (trigger).';
comment on column silo_charge.production_order_id is 'lệnh đang nạp silo';
comment on column silo_charge.block_reason is 'chặn bao sai: danh sách lý do, cách trả bao';
comment on column silo_charge.silo_equipment_id is 'silo xếp cho NVL của bao trong phương án silo của lệnh (production_order_silo) — phải đúng phương án (trigger)';
comment on column silo_charge.silo_lot_id is 'nút silo (lot SILO) đang mở — bắt buộc khi quét OK';

create table filling_run (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  batch_id uuid not null,
  product_id uuid not null,
  lot_id uuid not null,
  first_can_code text not null,
  planned_can_count integer not null,
  good_can_count integer not null default 0,
  rejected_can_count integer not null default 0,
  started_at timestamptz not null,
  ended_at timestamptz,
  printed_lot_no text,
  printed_mfg_date date,
  printed_exp_date date,
  source_event_id uuid,
  origin_site text not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (origin_site in ('CLOUD', 'NM')),
  unique (batch_id, product_id),
  check (good_can_count >= 0 and rejected_can_count >= 0)
);
create unique index ux_filling_run_0 on filling_run (source_event_id) where source_event_id is not null;
comment on table filling_run is 'Lượt chiết rót theo nhãn hiệu trong 1 mẻ BTP: quét lon đầu → gắn mẻ → nhãn hiệu → lô; bộ đếm lon đạt / loại; thùng gắn lô theo bộ đếm.';
comment on column filling_run.lot_id is 'lô BTP của nhãn hiệu';
comment on column filling_run.first_can_code is 'mã quét trên lon đầu';
comment on column filling_run.printed_lot_no is 'in NSX / HSD / lô lên lon: ai nhập, đối chiếu thế nào';

create table carton_recount (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  handling_unit_id uuid not null,
  filling_run_id uuid not null,
  counter_qty integer not null,
  counted_qty integer not null,
  source_event_id uuid,
  origin_site text not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (origin_site in ('CLOUD', 'NM'))
);
comment on table carton_recount is 'Thùng thiếu kg: đếm lại, sửa số lon của thùng, ghi lệch vào hồ sơ mẻ.';
comment on column carton_recount.counter_qty is 'số lon theo bộ đếm';
comment on column carton_recount.counted_qty is 'số lon đếm lại';

create table batch_mixing_param (
  id uuid not null default gen_random_uuid(),
  batch_id uuid not null,
  params jsonb,
  recorded_at timestamptz not null,
  origin_site text not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (origin_site in ('CLOUD', 'NM')),
  unique (batch_id)
);
comment on table batch_mixing_param is 'Thông số trộn thực tế của mẻ BTP.';

create table batch_downtime (
  id uuid not null default gen_random_uuid(),
  batch_id uuid not null,
  equipment_id uuid,
  started_at timestamptz not null,
  ended_at timestamptz,
  detail jsonb,
  origin_site text not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (origin_site in ('CLOUD', 'NM'))
);
comment on table batch_downtime is 'Sự cố / dừng máy trong mẻ.';

create table batch_weight_check (
  id uuid not null default gen_random_uuid(),
  batch_id uuid not null,
  handling_unit_id uuid,
  target_kg numeric(12,3),
  actual_kg numeric(12,3),
  detail jsonb,
  origin_site text not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (origin_site in ('CLOUD', 'NM'))
);
comment on table batch_weight_check is 'KL thực tế so với công thức (cân bao HH so với KL công thức — công thức không còn dung sai (05/11)).';

create table filling_can_weight (
  id uuid not null default gen_random_uuid(),
  filling_run_id uuid not null,
  measured_at timestamptz not null,
  net_weight_g numeric(10,2),
  accepted boolean,
  detail jsonb,
  origin_site text not null,
  primary key (id),
  check (origin_site in ('CLOUD', 'NM'))
);
comment on table filling_can_weight is 'Cân từng lon sau đậy nắp.';

create table ncr (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  code text not null,
  source_qt text,
  lot_id uuid,
  batch_id uuid,
  qty numeric(14,3),
  detail jsonb,
  status text,
  origin_site text not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (origin_site in ('CLOUD', 'NM')),
  unique (code)
);
comment on table ncr is 'Phiếu không phù hợp (NCR). Đã được nhắc ở QT14 (bao hư từ SX), QT25 (gom NCR), QT26 (CAPA).';

create table sync_outbox (
  factory_id uuid not null,
  event_id uuid not null,
  seq_no bigint not null,
  table_name text,
  record_key text,
  op text,
  production_order_id uuid,
  batch_id uuid,
  event_type text not null,
  payload jsonb not null,
  occurred_at timestamptz not null,
  recorded_by uuid not null,
  offline boolean not null,
  status text not null default 'CHO_GUI',
  sent_at timestamptz,
  acked_at timestamptz,
  primary key (event_id),
  check (op in ('INSERT', 'UPDATE')),
  check (event_type in ('DONG', 'ME_BAT_DAU', 'QUET_BAO', 'CAN_BAO_HH', 'BAO_HH', 'LON_DAU', 'DEM_LON', 'THUNG', 'DEM_LAI_THUNG', 'ME_KET_THUC', 'XUAT_NVL', 'SU_CO', 'ME_HUY', 'KHAC')),
  check (status in ('CHO_GUI', 'DA_GUI', 'DA_XAC_NHAN')),
  unique (factory_id, seq_no),
  check (event_type <> 'DONG' or (table_name is not null and record_key is not null and op is not null))
);
create index ix_sync_outbox_0 on sync_outbox (status, seq_no);
comment on table sync_outbox is 'Hàng đợi gửi lên tại máy chủ nhà máy (sửa 20/10 đợt 2 — thay sync_event): MỌI thay đổi trên bảng nhà máy chủ (nhóm NM của sync_policy: tồn, lô, bao / thùng, chứng từ kho, QC, mẻ, nạp / xả silo, chiết rót…) và bảng nơi phát sinh (phiên, tệp, nhật ký) ghi 1 dòng ở đây TRONG CÙNG GIAO DỊCH bằng trigger (event_type = DONG, payload = bản ghi sau thay đổi); sự kiện SX có nghĩa giữ event_type cũ. Luôn ghi kể cả khi có kết nối (1 đường đồng bộ). Nhà máy chủ động đẩy lên cloud theo seq_no (POST /sync/push); giữ 30 ngày sau khi cloud xác nhận rồi dọn.';
comment on column sync_outbox.event_id is 'mã sự kiện duy nhất (sinh tại nhà máy)';
comment on column sync_outbox.seq_no is 'số thứ tự tăng dần theo nhà máy';
comment on column sync_outbox.table_name is 'bảng của dòng thay đổi (event_type = DONG)';
comment on column sync_outbox.record_key is 'khóa của dòng (dạng chữ — bảng có khóa chính khác id vẫn ghi được)';
comment on column sync_outbox.op is 'loại thay đổi (event_type = DONG)';
comment on column sync_outbox.event_type is 'DONG: thay đổi 1 dòng của bảng nhà máy chủ (trigger ghi); còn lại: sự kiện SX có nghĩa';

create table sync_event_inbox (
  event_id uuid not null,
  factory_id uuid not null,
  seq_no bigint not null,
  event_type text not null,
  payload jsonb not null,
  occurred_at timestamptz not null,
  received_at timestamptz not null default now(),
  applied_at timestamptz,
  apply_result text not null default 'CHO',
  error_message text,
  primary key (event_id),
  check (apply_result in ('CHO', 'DA_AP_DUNG', 'XUNG_DOT', 'LOI')),
  unique (factory_id, seq_no)
);
comment on table sync_event_inbox is 'Sổ nhận sự kiện trên cloud. Khóa chính = event_id nên gửi lại không ghi 2 lần (INSERT … ON CONFLICT DO NOTHING = bỏ trùng). Áp dụng đúng thứ tự seq_no theo nhà máy.';

create table factory_sync_state (
  factory_id uuid not null,
  last_applied_seq bigint not null default 0,
  last_contact_at timestamptz,
  is_offline boolean not null default false,
  last_downstream_seq bigint not null default 0,
  primary key (factory_id)
);
comment on table factory_sync_state is 'Trạng thái đồng bộ từng nhà máy: seq_no đã áp dụng cuối, lần liên lạc cuối, đang ngoại tuyến không.';
comment on column factory_sync_state.last_downstream_seq is 'thay đổi cloud → nhà máy đã gửi tới đâu';

create table downstream_change (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  seq bigint not null,
  table_name text not null,
  record_id uuid not null,
  op text not null,
  payload jsonb not null,
  created_at timestamptz not null default now(),
  primary key (id),
  check (op in ('UPSERT')),
  unique (factory_id, seq)
);
comment on table downstream_change is 'Dòng bản sao cloud → nhà máy (bảng nhóm CLOUD của sync_policy, lọc theo factory_id, kéo theo dòng cha theo khóa ngoại): danh mục, tài khoản, lệnh, PO đã duyệt, đợt giao đã chốt lịch, hồ sơ thu hồi, phiếu chuyển của nhà máy khác, cột dẫn xuất do cloud chiếu. Sửa 20/10 (đợt 2): bỏ op KHOA — khóa lô / tài khoản / hủy lệnh đi bằng lệnh site_command. Nhà máy kéo theo seq (GET /sync/pull), áp dụng với app.sync_apply = on.';

create table sync_conflict (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  event_id uuid,
  site_command_id uuid,
  conflict_type text not null,
  lot_id uuid,
  batch_id uuid,
  detail jsonb,
  status text not null default 'MO',
  handled_by uuid,
  resolution text,
  resolved_at timestamptz,
  recall_case_id uuid,
  qc_request_id uuid,
  stocktake_id uuid,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (conflict_type in ('LO_DA_KHOA', 'LO_DA_HUY', 'TON_AM', 'KHAC')),
  check (status in ('MO', 'DANG_XU_LY', 'DA_XU_LY'))
);
comment on table sync_conflict is 'Xung đột khi đồng bộ: lô đã dùng nhưng cloud đã KHÓA / HỦY, tồn âm. Hệ thống tự KHÓA lô sinh ra theo chuỗi liên kết; Kế hoạch + QC xử lý. Sửa 20/10 (đợt 2): ghi tại máy chủ nhà máy khi áp lệnh khóa lô tới muộn (QT19 kz); lô HỦY bị dùng, tồn âm.';
comment on column sync_conflict.event_id is 'sự kiện / lệnh gốc (mã sự kiện ở sync_outbox hoặc mã lệnh site_command) — không khóa ngoại vì 2 nơi';
comment on column sync_conflict.site_command_id is 'lệnh từ trung tâm tới muộn gây xung đột (KHOA_LO)';

create table site_command (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  seq bigint not null,
  kind text not null,
  payload jsonb not null,
  ref_table text,
  ref_id uuid,
  status text not null default 'CHO_GUI',
  result_text text,
  sent_at timestamptz,
  applied_at timestamptz,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (kind in ('PHAT_LENH', 'HUY_LENH', 'KET_THUC_SOM', 'HUY_ME', 'ME_BU', 'KHOA_LO', 'MO_KHOA_LO', 'KHOA_TAI_KHOAN', 'SILO_BAO_TRI', 'DOI_LOAI_KHU', 'GIAM_KL_ME', 'YEU_CAU_XUAT', 'DE_NGHI_CHUYEN')),
  check (status in ('CHO_GUI', 'DA_GUI', 'DA_AP_DUNG', 'TU_CHOI')),
  unique (factory_id, seq),
  check (status <> 'TU_CHOI' or result_text is not null),
  check (status not in ('DA_AP_DUNG','TU_CHOI') or applied_at is not null),
  check (status = 'CHO_GUI' or sent_at is not null)
);
create index ix_site_command_0 on site_command (factory_id, status);
comment on table site_command is 'Kênh lệnh từ trung tâm (thêm 20/10 đợt 2 — quyết định 35): mọi tác động của cloud lên dữ liệu nhà máy chủ — phát / hủy / kết thúc sớm lệnh, hủy mẻ + mẻ bù, khóa / mở khóa lô (thu hồi, khoanh vùng), khóa tài khoản, silo bảo trì, đổi loại khu, giảm KL mẻ tối đa, yêu cầu xuất kho, đề nghị chuyển kho. Nhà máy kéo theo seq, áp dụng trong 1 giao dịch kèm kiểm điều kiện thực tế, trả kết quả qua command_inbox; trạng thái chỉ đi tới (trigger). Màn cloud hiện trạng thái lệnh cạnh thao tác.';
comment on column site_command.factory_id is 'nhà máy nhận lệnh';
comment on column site_command.seq is 'số thứ tự lệnh theo nhà máy (nhà máy kéo theo seq)';
comment on column site_command.payload is 'nội dung lệnh (vd lô + lý do khóa, mẻ + số kg bỏ)';
comment on column site_command.ref_table is 'chứng từ cloud sinh ra lệnh (vd recall_case, batch_cancellation, production_order)';
comment on column site_command.status is 'CHO_GUI: nhà máy chưa kéo (đang mất mạng); chỉ đi tới, DA_AP_DUNG / TU_CHOI là cuối (trigger); cloud chiếu từ command_inbox';
comment on column site_command.result_text is 'lý do từ chối / ghi chú khi áp dụng';
comment on column site_command.sent_at is 'nhà máy kéo về';
comment on column site_command.applied_at is 'nhà máy áp dụng / từ chối';

create table command_inbox (
  factory_id uuid not null,
  command_id uuid not null,
  seq bigint not null,
  kind text not null,
  received_at timestamptz not null default now(),
  status text not null default 'DA_NHAN',
  result_text text,
  applied_at timestamptz,
  applied_by uuid,
  primary key (command_id),
  check (status in ('DA_NHAN', 'DA_AP_DUNG', 'TU_CHOI')),
  unique (factory_id, seq),
  check (status <> 'TU_CHOI' or result_text is not null),
  check (status = 'DA_NHAN' or applied_at is not null)
);
comment on table command_inbox is 'Sổ lệnh đã nhận tại máy chủ nhà máy (thêm 20/10 đợt 2): mỗi lệnh site_command nhà máy kéo về 1 dòng, ghi kết quả áp dụng (ĐÃ ÁP DỤNG / TỪ CHỐI kèm lý do), gửi lên cloud qua sync_outbox; cloud chiếu sang site_command. Cloud khôi phục từ sao lưu thì nhà máy gửi lại sổ này để cloud dựng lại trạng thái lệnh (QT19 c1).';
comment on column command_inbox.command_id is 'mã lệnh';
comment on column command_inbox.result_text is 'lý do từ chối (bắt buộc khi TU_CHOI)';
comment on column command_inbox.applied_by is 'người / Hệ thống áp dụng';

create table offline_session (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  started_at timestamptz not null,
  ended_at timestamptz,
  first_seq bigint,
  last_seq bigint,
  events_synced integer,
  conflicts integer,
  stopped_new_batches_at timestamptz,
  primary key (id)
);
comment on table offline_session is 'Nhật ký mỗi lần mất kết nối: bắt đầu, kết thúc, dải seq, số sự kiện đã đồng bộ, số xung đột, lúc dừng nhận mẻ mới (quá 8 giờ).';

create table qc_request (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  code text not null,
  qt_code text not null,
  request_kind text not null,
  lot_id uuid not null,
  reason text,
  status text not null default 'CHO_DUYET',
  reviewed_by uuid,
  reviewed_at timestamptz,
  reject_reason text,
  supplement_note text,
  goods_receipt_id uuid,
  recall_case_id uuid,
  sync_conflict_id uuid,
  transfer_discrepancy_id uuid,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (qt_code in ('QT22', 'QT23')),
  check (request_kind in ('NVL_NGHI_LOI', 'BTP_MOI_NHAP', 'KHACH_TRA', 'KHOANH_VUNG', 'XUNG_DOT', 'HU_KHI_NHAN', 'TIM_LAI')),
  check (status in ('CHO_DUYET', 'YEU_CAU_BO_SUNG', 'TU_CHOI', 'DA_DUYET', 'DA_KET_LUAN', 'DA_HUY')),
  unique (code),
  check (status <> 'TU_CHOI' or reject_reason is not null),
  check (reviewed_by is null or reviewed_by <> created_by),
  check (request_kind <> 'BTP_MOI_NHAP' or status <> 'TU_CHOI'),
  check (request_kind <> 'BTP_MOI_NHAP' or qt_code = 'QT23'),
  check (request_kind <> 'NVL_NGHI_LOI' or qt_code = 'QT22'),
  check (status <> 'YEU_CAU_BO_SUNG' or supplement_note is not null)
);
comment on table qc_request is 'Yêu cầu kiểm. QT22: chỉ khi lô NVL nghi lỗi. QT23: BTP mới nhập kho BTP, hàng khách trả, lô bị khoanh vùng / xung đột / hư khi nhận / tìm lại. Gửi là phần lô → CHỜ KIỂM; QC trưởng duyệt / từ chối (lô về trạng thái trước) / yêu cầu bổ sung. BTP mới nhập không được từ chối.';
comment on column qc_request.reviewed_by is 'QC trưởng';
comment on column qc_request.supplement_note is 'nội dung yêu cầu bổ sung (QC trưởng)';

create table qc_request_part (
  id uuid not null default gen_random_uuid(),
  request_id uuid not null,
  stock_line_id uuid not null,
  qty numeric(14,3) not null,
  prev_status text not null,
  prev_lock_reason text,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (prev_status in ('CHO_KIEM', 'DAT', 'KHONG_DAT', 'KHOA')),
  unique (request_id, stock_line_id)
);
comment on table qc_request_part is 'Các phần lô (dòng tồn lô × kho, theo bao) bị đưa vào CHỜ KIỂM, kèm trạng thái + lý do khóa trước đó để trả về đúng khi QC trưởng từ chối.';

create table qc_inspection (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  code text not null,
  request_id uuid not null,
  inspection_kind text not null,
  lot_id uuid not null,
  sampled_at timestamptz,
  sampled_by uuid,
  sample_qty numeric(12,3),
  sample_uom text,
  entered_by uuid not null,
  proposed_result text,
  final_result text,
  external_report_file_id uuid,
  qc_note text,
  override_reason text,
  approved_by uuid,
  approved_at timestamptz,
  status text not null default 'DANG_KIEM',
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (inspection_kind in ('NVL', 'TP')),
  check (proposed_result in ('DAT', 'KHONG_DAT', 'CHUA_CO_GIOI_HAN')),
  check (final_result in ('DAT', 'KHONG_DAT')),
  check (status in ('DANG_KIEM', 'CHO_DUYET', 'DA_DUYET')),
  unique (code),
  check (approved_by is null or approved_by <> entered_by),
  check ((final_result is null) = (approved_by is null)),
  check (final_result is null or proposed_result is null or final_result = proposed_result or override_reason is not null)
);
comment on table qc_inspection is 'Phiếu kiểm: mẫu đã lấy, số liệu QC nhập, kết luận hệ thống đề xuất, kết luận QC trưởng duyệt. Người nhập không tự duyệt; lô chỉ đổi trạng thái sau khi duyệt.';
comment on column qc_inspection.external_report_file_id is 'file đánh giá / kiểm nghiệm bên ngoài';
comment on column qc_inspection.qc_note is 'ghi chú QC';
comment on column qc_inspection.override_reason is 'lý do QC trưởng kết luận khác đề xuất';
comment on column qc_inspection.approved_by is 'QC trưởng';

create table qc_result_item (
  id uuid not null default gen_random_uuid(),
  inspection_id uuid not null,
  material_spec_item_id uuid,
  product_spec_item_id uuid,
  criterion_name text not null,
  unit text,
  min_value numeric,
  max_value numeric,
  expected_text text,
  value_num numeric,
  value_text text,
  passed boolean,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (material_spec_item_id is null or product_spec_item_id is null)
);
comment on table qc_result_item is 'Kết quả theo từng chỉ tiêu, chép lại giới hạn lúc kiểm.';

create table product_spec_item (
  id uuid not null default gen_random_uuid(),
  product_id uuid not null,
  criterion_code text not null,
  criterion_name text not null,
  unit text,
  value_type text not null,
  min_value numeric,
  max_value numeric,
  expected_text text,
  sort_order integer not null default 0,
  status text not null default 'DANG_DUNG',
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (value_type in ('SO', 'CHU', 'DAT_KHONG')),
  check (status in ('DANG_DUNG', 'NGUNG_DUNG')),
  check (min_value is null or max_value is null or min_value <= max_value)
);
create unique index ux_product_spec_item_0 on product_spec_item (product_id, criterion_code) where status = 'DANG_DUNG';
comment on table product_spec_item is 'Bộ chỉ tiêu & giới hạn BTP / TP theo từng SP (vi sinh, độ ẩm, KL tịnh…) — QC tự quyết, nhập ở danh mục SP (QT23 g1), phần mềm ghi nhận. Chốt 19/10 (đợt 4): đây là bộ chỉ tiêu thành phẩm chuẩn gắn với SP — phiếu kiểm TP (`qc_result_item.product_spec_item_id`) và phiếu chứng nhận dùng đúng bộ này. Kết quả kiểm chép lại giới hạn lúc kiểm, nên sửa giới hạn không làm sai kết quả cũ.';

create table quality_certificate (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  code text,
  lot_id uuid not null,
  inspection_id uuid not null,
  approved_by uuid not null,
  issued_at timestamptz,
  content_snapshot jsonb not null,
  file_id uuid,
  status text not null default 'CHO_KY',
  signed_by uuid,
  signed_at timestamptz,
  cancel_reason text,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (status in ('CHO_KY', 'DA_KY', 'DA_HUY')),
  unique (code),
  unique (lot_id, inspection_id),
  check (status <> 'DA_KY' or (code is not null and signed_by is not null and signed_at is not null and issued_at is not null)),
  check (status <> 'DA_HUY' or cancel_reason is not null)
);
comment on table quality_certificate is 'Phiếu chứng nhận chất lượng xuất xưởng cho lô TP. Sửa 04/11: QC trưởng duyệt kết luận thì hệ thống lập phiếu ở Chờ ký; ký tách riêng sau (tab Chờ ký) → Đã ký, gửi kèm khi giao. Lô TP kiểm lại (khách trả) sinh phiếu mới.';
comment on column quality_certificate.code is 'số phiếu CN-{NM}-{yymm}-{4 số} — cấp khi ký';
comment on column quality_certificate.approved_by is 'QC trưởng duyệt kết luận';
comment on column quality_certificate.issued_at is 'ngày cấp = lúc ký';
comment on column quality_certificate.content_snapshot is 'chỉ tiêu, kết quả, giới hạn tại lúc cấp';
comment on column quality_certificate.signed_by is 'QC trưởng ký';

create table retained_sample (
  id uuid not null default gen_random_uuid(),
  factory_id uuid not null,
  code text not null,
  lot_id uuid not null,
  inspection_id uuid,
  qty numeric(12,3) not null,
  uom_code text not null,
  sealed_at timestamptz,
  retain_until date not null,
  storage_place text,
  is_open boolean not null default false,
  note text,
  status text not null default 'DANG_LUU',
  destroyed_at timestamptz,
  destroyed_by uuid,
  destruction_method text,
  destruction_witness text,
  destruction_file_id uuid,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (status in ('DANG_LUU', 'DA_HUY')),
  unique (code),
  check (status <> 'DA_HUY' or (destroyed_at is not null and destroyed_by is not null)),
  check (status <> 'DA_HUY' or destruction_method is not null),
  check (not (is_open and status = 'DA_HUY'))
);
comment on table retained_sample is 'Mẫu lưu gắn lô: mã mẫu, số lượng, niêm phong, hạn lưu, nơi lưu, ghi chú — QC tự quyết hạn lưu, phần mềm ghi nhận và nhắc khi hết hạn. Sửa 04/11 (theo mockup): lấy mẫu ra đánh giá → niêm phong lại (ghi kết quả), sửa hạn lưu — mỗi lần 1 dòng retained_sample_event; ô "Nơi lưu mẫu"; hủy ghi cách hủy, người chứng kiến, biên bản.';
comment on column retained_sample.retain_until is 'QC tự quyết; gợi ý HSD + 6 tháng (tham số)';
comment on column retained_sample.storage_place is 'nơi lưu mẫu (04/11)';
comment on column retained_sample.is_open is 'đang lấy ra đánh giá (mở niêm phong)';
comment on column retained_sample.note is 'ghi chú khi ghi mẫu lưu (không bắt buộc)';
comment on column retained_sample.destroyed_by is 'QC tự hủy mẫu hết hạn lưu, không cần duyệt (QT24 t4)';
comment on column retained_sample.destruction_method is 'cách hủy';
comment on column retained_sample.destruction_witness is 'người chứng kiến';
comment on column retained_sample.destruction_file_id is 'biên bản hủy mẫu';

create table retained_sample_event (
  id uuid not null default gen_random_uuid(),
  sample_id uuid not null,
  event_kind text not null,
  reason text,
  trace_request_id uuid,
  recall_case_id uuid,
  result_text text,
  old_retain_until date,
  new_retain_until date,
  occurred_at timestamptz not null default now(),
  actor_id uuid not null,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (event_kind in ('LAY_RA', 'NIEM_PHONG_LAI', 'SUA_HAN_LUU')),
  check (event_kind <> 'LAY_RA' or reason is not null),
  check (event_kind <> 'NIEM_PHONG_LAI' or result_text is not null),
  check (event_kind <> 'SUA_HAN_LUU' or (old_retain_until is not null and new_retain_until is not null and reason is not null))
);
comment on table retained_sample_event is 'Nhật ký mẫu lưu (chốt 04/11): lấy mẫu ra đánh giá (mục đích, truy xuất / thu hồi liên quan), niêm phong lại (kết quả đánh giá), sửa hạn lưu (hạn cũ → mới, lý do).';
comment on column retained_sample_event.reason is 'mục đích lấy ra / lý do sửa hạn';
comment on column retained_sample_event.result_text is 'kết quả đánh giá khi niêm phong lại';

create table trace_request (
  id uuid not null default gen_random_uuid(),
  code text not null,
  factory_id uuid,
  source text not null,
  recall_case_id uuid,
  reason text not null,
  input_kind text not null default 'SO_LO',
  input_sales_order_id uuid,
  input_customer_id uuid,
  input_material_id uuid,
  input_code text not null,
  input_lot_id uuid,
  direction text not null,
  tracer_id uuid not null,
  started_at timestamptz not null,
  completed_at timestamptz,
  retain_until date,
  report_file_id uuid,
  authority_letter_file_id uuid,
  status text not null default 'DANG_TRUY_XUAT',
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (source in ('THU_HOI', 'QC', 'CO_QUAN', 'NOI_BO')),
  check (input_kind in ('SO_LO', 'QR', 'DON_HANG', 'KHACH_HANG', 'MA_NVL')),
  check (direction in ('NGUOC', 'XUOI')),
  check (status in ('DANG_TRUY_XUAT', 'HOAN_THANH')),
  unique (code),
  check (source <> 'THU_HOI' or recall_case_id is not null),
  check (input_kind <> 'DON_HANG' or input_sales_order_id is not null),
  check (input_kind <> 'KHACH_HANG' or input_customer_id is not null),
  check (input_kind <> 'MA_NVL' or input_material_id is not null)
);
comment on table trace_request is 'Phiếu truy xuất: nguồn, lý do, mã đầu vào, hướng, người truy xuất (vai trò gán ở QT01), thời điểm tạo / có kết quả (bằng chứng, không đặt mục tiêu thời gian — bỏ 29/10). Lưu ≥ HSD + 12 tháng, không xóa.';
comment on column trace_request.input_kind is 'loại mã đầu vào (04/11: thêm đơn hàng, khách hàng, mã NVL)';
comment on column trace_request.input_code is 'mã nhập: QR lon / thùng / bao, số lô, mã đơn, mã khách hoặc mã NVL';
comment on column trace_request.tracer_id is 'Người truy xuất (vai trò chỉ Admin gán)';
comment on column trace_request.started_at is 'thời điểm tạo phiếu';
comment on column trace_request.completed_at is 'thời điểm hệ thống có kết quả';
comment on column trace_request.authority_letter_file_id is 'công văn cơ quan (nguồn CO_QUAN)';

create table trace_result_lot (
  id uuid not null default gen_random_uuid(),
  trace_request_id uuid not null,
  lot_id uuid not null,
  depth integer not null,
  path uuid[] not null,
  lot_status_summary jsonb,
  documents jsonb,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  unique (trace_request_id, lot_id)
);
comment on table trace_result_lot is 'Bản chụp chuỗi lô của lần truy xuất (bằng chứng — không tính lại về sau): lô, độ sâu, đường đi, trạng thái lúc truy xuất, hồ sơ QC / COA / mẫu lưu / NCR kèm theo.';

create table trace_result_customer (
  id uuid not null default gen_random_uuid(),
  trace_request_id uuid not null,
  customer_id uuid not null,
  lot_id uuid not null,
  goods_issue_id uuid,
  qty_delivered numeric(14,3) not null,
  qty_returned numeric(14,3) not null default 0,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id)
);
comment on table trace_result_customer is 'Bản chụp khách đã nhận theo lô (đầu vào danh sách thông báo của QT26).';
comment on column trace_result_customer.goods_issue_id is 'phiếu xuất bán';

create table mass_balance_result (
  id uuid not null default gen_random_uuid(),
  trace_request_id uuid not null,
  lot_id uuid not null,
  uom_code text not null,
  qty_in numeric(14,3) not null,
  used_in_production numeric(14,3) not null,
  delivered numeric(14,3) not null,
  returned_to_supplier numeric(14,3) not null,
  destroyed numeric(14,3) not null,
  samples numeric(14,3) not null,
  adjustments numeric(14,3) not null,
  on_hand numeric(14,3) not null,
  in_transit numeric(14,3) not null,
  diff numeric(14,3) not null,
  discrepancy_file_id uuid,
  stock_discrepancy_id uuid,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  unique (trace_request_id, lot_id),
  check (diff = 0 or stock_discrepancy_id is not null)
);
comment on table mass_balance_result is 'Cân bằng khối lượng từng lô: SL vào (nhập / SX ra) = dùng cho SX + giao + trả NCC + hủy + mẫu + tồn + đang chuyển (+ điều chỉnh kiểm kho). Lệch → biên bản + kiểm kho (QT17).';
comment on column mass_balance_result.in_transit is 'hàng đang chuyển (dòng tồn trên phiếu chuyển)';

create table recall_case (
  id uuid not null default gen_random_uuid(),
  code text not null,
  factory_id uuid,
  source text not null,
  trace_request_id uuid,
  hazard_level text,
  scope text,
  qty_in_market numeric(14,3),
  qty_in_stock numeric(14,3),
  risk_assessment text,
  risk_assessed_by uuid,
  risk_assessed_at timestamptz,
  proposed_decision text,
  decision text,
  decided_by uuid,
  decided_at timestamptz,
  deadline date,
  root_cause text,
  status text not null default 'MO',
  closed_at timestamptz,
  close_approved_by uuid,
  close_approved_at timestamptz,
  retain_until date,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (source in ('KHACH_BAO', 'QT23', 'QT25', 'NVL_LOI', 'CO_QUAN')),
  check (scope in ('KHO', 'DAI_LY', 'NGUOI_DUNG')),
  check (proposed_decision in ('THU_HOI', 'KHOANH_VUNG')),
  check (decision in ('THU_HOI', 'KHOANH_VUNG')),
  check (status in ('MO', 'DANG_THU', 'DA_XU_LY_LO', 'DA_DONG')),
  unique (code),
  check ((decision is null) = (decided_by is null)),
  check (status <> 'DA_DONG' or closed_at is not null),
  check (status <> 'DA_DONG' or close_approved_by is not null)
);
comment on table recall_case is 'Hồ sơ thu hồi: chỉ QC trưởng mở (người tạo; mở là hệ thống khóa cả lô ngay), QC trưởng đánh giá rủi ro, mức nguy hại (nhà máy tự quyết, hệ thống ghi nhận), phạm vi, báo cơ quan; GĐ quyết thu hồi / khoanh vùng và duyệt đóng hồ sơ; % thu hồi, nguyên nhân gốc. Lô thu hồi chỉ hủy. Lưu ≥ HSD + 12 tháng. Trạng thái áp dụng lệnh khóa lô theo từng nhà máy (Đã áp dụng lúc … / Chờ nhà máy áp dụng) đọc từ site_command KHOA_LO của hồ sơ (ref_table = recall_case, status, applied_at) — không thêm cột (04/11).';
comment on column recall_case.hazard_level is 'mức nguy hại — danh mục do nhà máy tự đặt';
comment on column recall_case.qty_in_market is 'số lượng ngoài thị trường';
comment on column recall_case.qty_in_stock is 'số lượng còn trong kho';
comment on column recall_case.risk_assessed_by is 'QC trưởng (q1)';
comment on column recall_case.decided_by is 'GĐ ký';
comment on column recall_case.deadline is 'mặc định quyết định + 30 ngày';
comment on column recall_case.close_approved_by is 'Giám đốc duyệt đóng hồ sơ (gd)';

create table recall_lot (
  id uuid not null default gen_random_uuid(),
  recall_case_id uuid not null,
  lot_id uuid not null,
  role text not null,
  added_from text not null,
  qc_request_id uuid,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (role in ('NGHI_LOI', 'LIEN_QUAN')),
  check (added_from in ('BAN_DAU', 'TRUY_XUAT', 'XUNG_DOT', 'NVL_DU', 'QT23')),
  unique (recall_case_id, lot_id)
);
comment on table recall_lot is 'Lô trong hồ sơ: lô nghi lỗi và lô liên quan (từ truy xuất, từ xung đột mất kết nối, NVL dư trả về), kết quả QC kiểm lại khi khoanh vùng.';

create table recall_customer (
  id uuid not null default gen_random_uuid(),
  recall_case_id uuid not null,
  customer_id uuid not null,
  lot_id uuid not null,
  qty_delivered numeric(14,3) not null,
  qty_recovered numeric(14,3) not null default 0,
  notified_at timestamptz,
  notified_by uuid,
  last_reminder_at timestamptz,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  unique (recall_case_id, customer_id, lot_id),
  check (qty_recovered >= 0)
);
comment on table recall_customer is 'Khách trong hồ sơ: SL đã giao, SL thu về, thời điểm thông báo, lần nhắc cuối → % thu hồi = Σ thu về / Σ đã giao.';
comment on column recall_customer.notified_by is 'CSKH (QT26 t1)';

create table recall_authority_report (
  id uuid not null default gen_random_uuid(),
  recall_case_id uuid not null,
  report_kind text not null,
  sent_at timestamptz not null,
  file_id uuid,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (report_kind in ('BAN_DAU', 'TIEN_DO', 'KET_THUC'))
);
comment on table recall_authority_report is 'Báo cơ quan quản lý (bắt buộc theo luật), do QC trưởng gửi: báo đầu, cập nhật tiến độ, báo kết thúc.';

create table recall_resolution (
  id uuid not null default gen_random_uuid(),
  recall_case_id uuid not null,
  customer_id uuid not null,
  kind text not null,
  sales_order_id uuid,
  voucher_id uuid,
  amount numeric(18,2),
  approved_by uuid,
  approved_at timestamptz,
  status text not null default 'CHO_DUYET',
  reject_reason text,
  created_at timestamptz not null default now(),
  created_by uuid not null,
  primary key (id),
  check (kind in ('DOI_LO', 'HOAN_TIEN')),
  check (status in ('CHO_DUYET', 'DA_DUYET', 'TU_CHOI')),
  check (kind <> 'DOI_LO' or sales_order_id is not null),
  check (status <> 'DA_DUYET' or kind <> 'HOAN_TIEN' or approved_by is not null),
  check (status <> 'TU_CHOI' or reject_reason is not null),
  check (voucher_id is null or status = 'DA_DUYET'),
  check (approved_by is null or approved_by <> created_by)
);
comment on table recall_resolution is 'Sales đổi lô mới (đơn thay thế QT05) / hoàn tiền cho khách: số tiền GĐ hoặc KTT duyệt như hủy đơn, Kế toán ghi nhận ở QT10 (không duyệt thêm).';
comment on column recall_resolution.voucher_id is 'bản ghi nhận hoàn tiền (QT10 h1)';
comment on column recall_resolution.approved_by is 'GĐ hoặc KTT duyệt số tiền hoàn (một người là đủ, số tiền do người duyệt nhập)';
comment on column recall_resolution.status is 'hoàn tiền chờ GĐ / KTT duyệt (04/11); đổi lô vào thẳng DA_DUYET';

create table capa (
  id uuid not null default gen_random_uuid(),
  recall_case_id uuid,
  ncr_id uuid,
  category text not null,
  root_cause text not null,
  action text not null,
  owner_id uuid,
  due_date date,
  done_at timestamptz,
  supplier_return_id uuid,
  approved_by uuid,
  approved_at timestamptz,
  return_reason text,
  status text not null default 'MO',
  created_at timestamptz not null default now(),
  created_by uuid not null,
  updated_at timestamptz,
  updated_by uuid,
  primary key (id),
  check (category in ('NVL', 'SAN_XUAT', 'BAO_BI', 'KHAC')),
  check (status in ('MO', 'DANG_LAM', 'CHO_DUYET', 'DA_DUYET')),
  check (recall_case_id is not null or ncr_id is not null),
  check (status <> 'DA_DUYET' or approved_by is not null),
  check (approved_by is null or approved_by <> created_by)
);
comment on table capa is 'Nguyên nhân gốc & hành động khắc phục (CAPA), QC lập, QC trưởng duyệt: NVL → trả NCC; SX → sửa công thức / thiết bị / thao tác; bao bì → NCC bao bì.';
comment on column capa.approved_by is 'QC trưởng duyệt CAPA (qa)';
comment on column capa.return_reason is 'lý do QC trưởng trả lại (về DANG_LAM)';

-- ===== khóa ngoại (thêm sau vì có tham chiếu vòng) =====
alter table factory add constraint fk_factory_created_by foreign key (created_by) references app_user (id);
alter table factory add constraint fk_factory_updated_by foreign key (updated_by) references app_user (id);
alter table work_area add constraint fk_work_area_factory_id foreign key (factory_id) references factory (id);
alter table work_area add constraint fk_work_area_supply_warehouse_id foreign key (supply_warehouse_id) references warehouse (id);
alter table work_area add constraint fk_work_area_created_by foreign key (created_by) references app_user (id);
alter table work_area add constraint fk_work_area_updated_by foreign key (updated_by) references app_user (id);
alter table app_user add constraint fk_app_user_home_factory_id foreign key (home_factory_id) references factory (id);
alter table app_user add constraint fk_app_user_work_area_id foreign key (work_area_id) references work_area (id);
alter table app_user add constraint fk_app_user_created_by foreign key (created_by) references app_user (id);
alter table app_user add constraint fk_app_user_updated_by foreign key (updated_by) references app_user (id);
alter table role add constraint fk_role_scope_factory_id foreign key (scope_factory_id) references factory (id);
alter table role add constraint fk_role_created_by foreign key (created_by) references app_user (id);
alter table role add constraint fk_role_updated_by foreign key (updated_by) references app_user (id);
alter table permission add constraint fk_permission_created_by foreign key (created_by) references app_user (id);
alter table role_permission add constraint fk_role_permission_role_id foreign key (role_id) references role (id);
alter table role_permission add constraint fk_role_permission_permission_id foreign key (permission_id) references permission (id);
alter table role_permission add constraint fk_role_permission_scope_factory_id foreign key (scope_factory_id) references factory (id);
alter table role_permission add constraint fk_role_permission_revoked_by foreign key (revoked_by) references app_user (id);
alter table role_permission add constraint fk_role_permission_created_by foreign key (created_by) references app_user (id);
alter table user_permission add constraint fk_user_permission_user_id foreign key (user_id) references app_user (id);
alter table user_permission add constraint fk_user_permission_permission_id foreign key (permission_id) references permission (id);
alter table user_permission add constraint fk_user_permission_revoked_by foreign key (revoked_by) references app_user (id);
alter table user_permission add constraint fk_user_permission_created_by foreign key (created_by) references app_user (id);
alter table screen add constraint fk_screen_created_by foreign key (created_by) references app_user (id);
alter table screen add constraint fk_screen_updated_by foreign key (updated_by) references app_user (id);
alter table screen_function add constraint fk_screen_function_screen_id foreign key (screen_id) references screen (id);
alter table screen_function add constraint fk_screen_function_created_by foreign key (created_by) references app_user (id);
alter table user_role add constraint fk_user_role_user_id foreign key (user_id) references app_user (id);
alter table user_role add constraint fk_user_role_role_id foreign key (role_id) references role (id);
alter table user_role add constraint fk_user_role_factory_id foreign key (factory_id) references factory (id);
alter table user_role add constraint fk_user_role_warehouse_id foreign key (warehouse_id) references warehouse (id);
alter table user_role add constraint fk_user_role_work_area_id foreign key (work_area_id) references work_area (id);
alter table user_role add constraint fk_user_role_delegation_id foreign key (delegation_id) references user_delegation (id);
alter table user_role add constraint fk_user_role_revoked_by foreign key (revoked_by) references app_user (id);
alter table user_role add constraint fk_user_role_created_by foreign key (created_by) references app_user (id);
alter table user_delegation add constraint fk_user_delegation_delegator_id foreign key (delegator_id) references app_user (id);
alter table user_delegation add constraint fk_user_delegation_role_id foreign key (role_id) references role (id);
alter table user_delegation add constraint fk_user_delegation_delegate_id foreign key (delegate_id) references app_user (id);
alter table user_delegation add constraint fk_user_delegation_factory_id foreign key (factory_id) references factory (id);
alter table user_delegation add constraint fk_user_delegation_warehouse_id foreign key (warehouse_id) references warehouse (id);
alter table user_delegation add constraint fk_user_delegation_work_area_id foreign key (work_area_id) references work_area (id);
alter table user_delegation add constraint fk_user_delegation_revoked_by foreign key (revoked_by) references app_user (id);
alter table user_delegation add constraint fk_user_delegation_created_by foreign key (created_by) references app_user (id);
alter table user_delegation add constraint fk_user_delegation_updated_by foreign key (updated_by) references app_user (id);
alter table job_title_role add constraint fk_job_title_role_role_id foreign key (role_id) references role (id);
alter table job_title_role add constraint fk_job_title_role_created_by foreign key (created_by) references app_user (id);
alter table user_session add constraint fk_user_session_user_id foreign key (user_id) references app_user (id);
alter table user_session add constraint fk_user_session_factory_id foreign key (factory_id) references factory (id);
alter table account_change_log add constraint fk_account_change_log_user_id foreign key (user_id) references app_user (id);
alter table account_change_log add constraint fk_account_change_log_actor_id foreign key (actor_id) references app_user (id);
alter table audit_log add constraint fk_audit_log_actor_id foreign key (actor_id) references app_user (id);
alter table audit_log add constraint fk_audit_log_factory_id foreign key (factory_id) references factory (id);
alter table system_parameter add constraint fk_system_parameter_factory_id foreign key (factory_id) references factory (id);
alter table system_parameter add constraint fk_system_parameter_created_by foreign key (created_by) references app_user (id);
alter table system_parameter add constraint fk_system_parameter_updated_by foreign key (updated_by) references app_user (id);
alter table uom add constraint fk_uom_base_uom_code foreign key (base_uom_code) references uom (code);
alter table uom add constraint fk_uom_created_by foreign key (created_by) references app_user (id);
alter table material add constraint fk_material_uom_code foreign key (uom_code) references uom (code);
alter table material add constraint fk_material_produced_by_formula_id foreign key (produced_by_formula_id) references formula (id);
alter table material add constraint fk_material_created_by foreign key (created_by) references app_user (id);
alter table material add constraint fk_material_updated_by foreign key (updated_by) references app_user (id);
alter table material_spec_item add constraint fk_material_spec_item_material_id foreign key (material_id) references material (id);
alter table material_spec_item add constraint fk_material_spec_item_created_by foreign key (created_by) references app_user (id);
alter table material_spec_item add constraint fk_material_spec_item_updated_by foreign key (updated_by) references app_user (id);
alter table product add constraint fk_product_formula_id foreign key (formula_id) references formula (id);
alter table product add constraint fk_product_structure_option_id foreign key (structure_option_id) references product_option (id);
alter table product add constraint fk_product_group_option_id foreign key (group_option_id) references product_option (id);
alter table product add constraint fk_product_class_option_id foreign key (class_option_id) references product_option (id);
alter table product add constraint fk_product_age_option_id foreign key (age_option_id) references product_option (id);
alter table product add constraint fk_product_made_at_factory_id foreign key (made_at_factory_id) references factory (id);
alter table product add constraint fk_product_created_by foreign key (created_by) references app_user (id);
alter table product add constraint fk_product_updated_by foreign key (updated_by) references app_user (id);
alter table product_option add constraint fk_product_option_created_by foreign key (created_by) references app_user (id);
alter table product_option add constraint fk_product_option_updated_by foreign key (updated_by) references app_user (id);
alter table material_pack add constraint fk_material_pack_material_id foreign key (material_id) references material (id);
alter table material_pack add constraint fk_material_pack_created_by foreign key (created_by) references app_user (id);
alter table material_pack add constraint fk_material_pack_updated_by foreign key (updated_by) references app_user (id);
alter table material_pack_level add constraint fk_material_pack_level_pack_id foreign key (pack_id) references material_pack (id);
alter table material_pack_level add constraint fk_material_pack_level_net_uom_code foreign key (net_uom_code) references uom (code);
alter table material_pack_level add constraint fk_material_pack_level_created_by foreign key (created_by) references app_user (id);
alter table product_pack add constraint fk_product_pack_product_id foreign key (product_id) references product (id);
alter table product_pack add constraint fk_product_pack_created_by foreign key (created_by) references app_user (id);
alter table product_pack add constraint fk_product_pack_updated_by foreign key (updated_by) references app_user (id);
alter table product_pack_level add constraint fk_product_pack_level_pack_id foreign key (pack_id) references product_pack (id);
alter table product_pack_level add constraint fk_product_pack_level_net_uom_code foreign key (net_uom_code) references uom (code);
alter table product_pack_level add constraint fk_product_pack_level_created_by foreign key (created_by) references app_user (id);
alter table product_label add constraint fk_product_label_product_pack_id foreign key (product_pack_id) references product_pack (id);
alter table product_label add constraint fk_product_label_file_id foreign key (file_id) references file_attachment (id);
alter table product_label add constraint fk_product_label_approved_by foreign key (approved_by) references app_user (id);
alter table product_label add constraint fk_product_label_created_by foreign key (created_by) references app_user (id);
alter table product_label add constraint fk_product_label_updated_by foreign key (updated_by) references app_user (id);
alter table product_document add constraint fk_product_document_declaration_option_id foreign key (declaration_option_id) references product_option (id);
alter table product_document add constraint fk_product_document_product_id foreign key (product_id) references product (id);
alter table product_document add constraint fk_product_document_file_id foreign key (file_id) references file_attachment (id);
alter table product_document add constraint fk_product_document_created_by foreign key (created_by) references app_user (id);
alter table product_document add constraint fk_product_document_updated_by foreign key (updated_by) references app_user (id);
alter table legal_document add constraint fk_legal_document_created_by foreign key (created_by) references app_user (id);
alter table legal_document add constraint fk_legal_document_updated_by foreign key (updated_by) references app_user (id);
alter table legal_document_scope add constraint fk_legal_document_scope_legal_document_id foreign key (legal_document_id) references legal_document (id);
alter table legal_document_scope add constraint fk_legal_document_scope_factory_id foreign key (factory_id) references factory (id);
alter table legal_document_scope add constraint fk_legal_document_scope_product_id foreign key (product_id) references product (id);
alter table legal_document_scope add constraint fk_legal_document_scope_created_by foreign key (created_by) references app_user (id);
alter table warehouse add constraint fk_warehouse_factory_id foreign key (factory_id) references factory (id);
alter table warehouse add constraint fk_warehouse_manager_id foreign key (manager_id) references app_user (id);
alter table warehouse add constraint fk_warehouse_created_by foreign key (created_by) references app_user (id);
alter table warehouse add constraint fk_warehouse_updated_by foreign key (updated_by) references app_user (id);
alter table equipment add constraint fk_equipment_factory_id foreign key (factory_id) references factory (id);
alter table equipment add constraint fk_equipment_work_area_id foreign key (work_area_id) references work_area (id);
alter table equipment add constraint fk_equipment_hard_material_id foreign key (hard_material_id) references material (id);
alter table equipment add constraint fk_equipment_created_by foreign key (created_by) references app_user (id);
alter table equipment add constraint fk_equipment_updated_by foreign key (updated_by) references app_user (id);
alter table formula add constraint fk_formula_created_by foreign key (created_by) references app_user (id);
alter table formula add constraint fk_formula_updated_by foreign key (updated_by) references app_user (id);
alter table formula_version add constraint fk_formula_version_formula_id foreign key (formula_id) references formula (id);
alter table formula_version add constraint fk_formula_version_created_by foreign key (created_by) references app_user (id);
alter table formula_item add constraint fk_formula_item_formula_version_id foreign key (formula_version_id) references formula_version (id);
alter table formula_item add constraint fk_formula_item_material_id foreign key (material_id) references material (id);
alter table formula_item add constraint fk_formula_item_created_by foreign key (created_by) references app_user (id);
alter table label_incident add constraint fk_label_incident_factory_id foreign key (factory_id) references factory (id);
alter table label_incident add constraint fk_label_incident_handling_unit_id foreign key (handling_unit_id) references handling_unit (id);
alter table label_incident add constraint fk_label_incident_new_handling_unit_id foreign key (new_handling_unit_id) references handling_unit (id);
alter table label_incident add constraint fk_label_incident_warehouse_id foreign key (warehouse_id) references warehouse (id);
alter table label_incident add constraint fk_label_incident_lot_id foreign key (lot_id) references lot (id);
alter table label_incident add constraint fk_label_incident_created_by foreign key (created_by) references app_user (id);
alter table file_attachment add constraint fk_file_attachment_factory_id foreign key (factory_id) references factory (id);
alter table file_attachment add constraint fk_file_attachment_created_by foreign key (created_by) references app_user (id);
alter table document_snapshot add constraint fk_document_snapshot_factory_id foreign key (factory_id) references factory (id);
alter table document_snapshot add constraint fk_document_snapshot_file_id foreign key (file_id) references file_attachment (id);
alter table document_snapshot add constraint fk_document_snapshot_signed_by foreign key (signed_by) references app_user (id);
alter table document_snapshot add constraint fk_document_snapshot_created_by foreign key (created_by) references app_user (id);
alter table document_print_log add constraint fk_document_print_log_snapshot_id foreign key (snapshot_id) references document_snapshot (id);
alter table document_print_log add constraint fk_document_print_log_printed_by foreign key (printed_by) references app_user (id);
alter table document_print_log add constraint fk_document_print_log_created_by foreign key (created_by) references app_user (id);
alter table code_sequence add constraint fk_code_sequence_factory_id foreign key (factory_id) references factory (id);
alter table code_format add constraint fk_code_format_created_by foreign key (created_by) references app_user (id);
alter table code_format add constraint fk_code_format_updated_by foreign key (updated_by) references app_user (id);
alter table sync_policy add constraint fk_sync_policy_created_by foreign key (created_by) references app_user (id);
alter table catalog_retire_request add constraint fk_catalog_retire_request_approved_by foreign key (approved_by) references app_user (id);
alter table catalog_retire_request add constraint fk_catalog_retire_request_created_by foreign key (created_by) references app_user (id);
alter table catalog_retire_request add constraint fk_catalog_retire_request_updated_by foreign key (updated_by) references app_user (id);
alter table lot add constraint fk_lot_factory_id foreign key (factory_id) references factory (id);
alter table lot add constraint fk_lot_material_id foreign key (material_id) references material (id);
alter table lot add constraint fk_lot_product_id foreign key (product_id) references product (id);
alter table lot add constraint fk_lot_production_batch_id foreign key (production_batch_id) references production_batch (id);
alter table lot add constraint fk_lot_production_order_id foreign key (production_order_id) references production_order (id);
alter table lot add constraint fk_lot_silo_equipment_id foreign key (silo_equipment_id) references equipment (id);
alter table lot add constraint fk_lot_supplier_id foreign key (supplier_id) references supplier (id);
alter table lot add constraint fk_lot_uom_code foreign key (uom_code) references uom (code);
alter table lot add constraint fk_lot_coa_file_id foreign key (coa_file_id) references file_attachment (id);
alter table lot add constraint fk_lot_source_lot_id foreign key (source_lot_id) references lot (id);
alter table lot add constraint fk_lot_created_by foreign key (created_by) references app_user (id);
alter table lot add constraint fk_lot_updated_by foreign key (updated_by) references app_user (id);
alter table handling_unit add constraint fk_handling_unit_factory_id foreign key (factory_id) references factory (id);
alter table handling_unit add constraint fk_handling_unit_lot_id foreign key (lot_id) references lot (id);
alter table handling_unit add constraint fk_handling_unit_uom_code foreign key (uom_code) references uom (code);
alter table handling_unit add constraint fk_handling_unit_stock_line_id foreign key (stock_line_id) references stock_line (id);
alter table handling_unit add constraint fk_handling_unit_production_batch_id foreign key (production_batch_id) references production_batch (id);
alter table handling_unit add constraint fk_handling_unit_filling_run_id foreign key (filling_run_id) references filling_run (id);
alter table handling_unit add constraint fk_handling_unit_receipt_line_id foreign key (receipt_line_id) references goods_receipt_line (id);
alter table handling_unit add constraint fk_handling_unit_replaced_by_id foreign key (replaced_by_id) references handling_unit (id);
alter table handling_unit add constraint fk_handling_unit_created_by foreign key (created_by) references app_user (id);
alter table handling_unit add constraint fk_handling_unit_updated_by foreign key (updated_by) references app_user (id);
alter table stock_line add constraint fk_stock_line_factory_id foreign key (factory_id) references factory (id);
alter table stock_line add constraint fk_stock_line_lot_id foreign key (lot_id) references lot (id);
alter table stock_line add constraint fk_stock_line_warehouse_id foreign key (warehouse_id) references warehouse (id);
alter table stock_line add constraint fk_stock_line_stock_transfer_id foreign key (stock_transfer_id) references stock_transfer (id);
alter table stock_line add constraint fk_stock_line_uom_code foreign key (uom_code) references uom (code);
alter table stock_line add constraint fk_stock_line_lock_reason foreign key (lock_reason) references lock_reason (code);
alter table stock_line add constraint fk_stock_line_prev_lock_reason foreign key (prev_lock_reason) references lock_reason (code);
alter table stock_line add constraint fk_stock_line_created_by foreign key (created_by) references app_user (id);
alter table stock_line add constraint fk_stock_line_updated_by foreign key (updated_by) references app_user (id);
alter table lock_reason add constraint fk_lock_reason_created_by foreign key (created_by) references app_user (id);
alter table lot_status_transition add constraint fk_lot_status_transition_lock_reason foreign key (lock_reason) references lock_reason (code);
alter table lot_status_transition add constraint fk_lot_status_transition_created_by foreign key (created_by) references app_user (id);
alter table lot_lock add constraint fk_lot_lock_factory_id foreign key (factory_id) references factory (id);
alter table lot_lock add constraint fk_lot_lock_lot_id foreign key (lot_id) references lot (id);
alter table lot_lock add constraint fk_lot_lock_lock_reason foreign key (lock_reason) references lock_reason (code);
alter table lot_lock add constraint fk_lot_lock_recall_case_id foreign key (recall_case_id) references recall_case (id);
alter table lot_lock add constraint fk_lot_lock_sync_conflict_id foreign key (sync_conflict_id) references sync_conflict (id);
alter table lot_lock add constraint fk_lot_lock_site_command_id foreign key (site_command_id) references site_command (id);
alter table lot_lock add constraint fk_lot_lock_released_by foreign key (released_by) references app_user (id);
alter table lot_lock add constraint fk_lot_lock_created_by foreign key (created_by) references app_user (id);
alter table lot_lock add constraint fk_lot_lock_updated_by foreign key (updated_by) references app_user (id);
alter table lot_status_log add constraint fk_lot_status_log_factory_id foreign key (factory_id) references factory (id);
alter table lot_status_log add constraint fk_lot_status_log_lot_id foreign key (lot_id) references lot (id);
alter table lot_status_log add constraint fk_lot_status_log_stock_line_id foreign key (stock_line_id) references stock_line (id);
alter table lot_status_log add constraint fk_lot_status_log_warehouse_id foreign key (warehouse_id) references warehouse (id);
alter table lot_status_log add constraint fk_lot_status_log_from_lock_reason foreign key (from_lock_reason) references lock_reason (code);
alter table lot_status_log add constraint fk_lot_status_log_to_lock_reason foreign key (to_lock_reason) references lock_reason (code);
alter table lot_status_log add constraint fk_lot_status_log_transition_id foreign key (transition_id) references lot_status_transition (id);
alter table lot_status_log add constraint fk_lot_status_log_actor_id foreign key (actor_id) references app_user (id);
alter table lot_status_log add constraint fk_lot_status_log_attachment_file_id foreign key (attachment_file_id) references file_attachment (id);
alter table lot_link add constraint fk_lot_link_factory_id foreign key (factory_id) references factory (id);
alter table lot_link add constraint fk_lot_link_parent_lot_id foreign key (parent_lot_id) references lot (id);
alter table lot_link add constraint fk_lot_link_child_lot_id foreign key (child_lot_id) references lot (id);
alter table lot_link add constraint fk_lot_link_uom_code foreign key (uom_code) references uom (code);
alter table lot_link add constraint fk_lot_link_production_batch_id foreign key (production_batch_id) references production_batch (id);
alter table lot_link add constraint fk_lot_link_handling_unit_id foreign key (handling_unit_id) references handling_unit (id);
alter table lot_link add constraint fk_lot_link_operator_id foreign key (operator_id) references app_user (id);
alter table lot_link add constraint fk_lot_link_created_by foreign key (created_by) references app_user (id);
alter table inventory_txn add constraint fk_inventory_txn_factory_id foreign key (factory_id) references factory (id);
alter table inventory_txn add constraint fk_inventory_txn_stock_line_id foreign key (stock_line_id) references stock_line (id);
alter table inventory_txn add constraint fk_inventory_txn_lot_id foreign key (lot_id) references lot (id);
alter table inventory_txn add constraint fk_inventory_txn_warehouse_id foreign key (warehouse_id) references warehouse (id);
alter table inventory_txn add constraint fk_inventory_txn_uom_code foreign key (uom_code) references uom (code);
alter table inventory_txn add constraint fk_inventory_txn_actor_id foreign key (actor_id) references app_user (id);
alter table scan_log add constraint fk_scan_log_factory_id foreign key (factory_id) references factory (id);
alter table scan_log add constraint fk_scan_log_user_id foreign key (user_id) references app_user (id);
alter table goods_receipt add constraint fk_goods_receipt_factory_id foreign key (factory_id) references factory (id);
alter table goods_receipt add constraint fk_goods_receipt_warehouse_id foreign key (warehouse_id) references warehouse (id);
alter table goods_receipt add constraint fk_goods_receipt_supplier_id foreign key (supplier_id) references supplier (id);
alter table goods_receipt add constraint fk_goods_receipt_purchase_order_id foreign key (purchase_order_id) references purchase_order (id);
alter table goods_receipt add constraint fk_goods_receipt_supplier_invoice_file_id foreign key (supplier_invoice_file_id) references file_attachment (id);
alter table goods_receipt add constraint fk_goods_receipt_invoice_recorded_by foreign key (invoice_recorded_by) references app_user (id);
alter table goods_receipt add constraint fk_goods_receipt_production_order_id foreign key (production_order_id) references production_order (id);
alter table goods_receipt add constraint fk_goods_receipt_delivery_note_id foreign key (delivery_note_id) references delivery_note (id);
alter table goods_receipt add constraint fk_goods_receipt_recall_case_id foreign key (recall_case_id) references recall_case (id);
alter table goods_receipt add constraint fk_goods_receipt_stock_transfer_id foreign key (stock_transfer_id) references stock_transfer (id);
alter table goods_receipt add constraint fk_goods_receipt_doc_file_id foreign key (doc_file_id) references file_attachment (id);
alter table goods_receipt add constraint fk_goods_receipt_discrepancy_confirmed_by foreign key (discrepancy_confirmed_by) references app_user (id);
alter table goods_receipt add constraint fk_goods_receipt_created_by foreign key (created_by) references app_user (id);
alter table goods_receipt add constraint fk_goods_receipt_updated_by foreign key (updated_by) references app_user (id);
alter table goods_receipt_line add constraint fk_goods_receipt_line_receipt_id foreign key (receipt_id) references goods_receipt (id);
alter table goods_receipt_line add constraint fk_goods_receipt_line_material_id foreign key (material_id) references material (id);
alter table goods_receipt_line add constraint fk_goods_receipt_line_product_id foreign key (product_id) references product (id);
alter table goods_receipt_line add constraint fk_goods_receipt_line_purchase_order_line_id foreign key (purchase_order_line_id) references purchase_order_line (id);
alter table goods_receipt_line add constraint fk_goods_receipt_line_lot_id foreign key (lot_id) references lot (id);
alter table goods_receipt_line add constraint fk_goods_receipt_line_uom_code foreign key (uom_code) references uom (code);
alter table goods_receipt_line add constraint fk_goods_receipt_line_coa_file_id foreign key (coa_file_id) references file_attachment (id);
alter table goods_receipt_line add constraint fk_goods_receipt_line_created_by foreign key (created_by) references app_user (id);
alter table goods_receipt_line add constraint fk_goods_receipt_line_updated_by foreign key (updated_by) references app_user (id);
alter table receipt_coa_result add constraint fk_receipt_coa_result_receipt_line_id foreign key (receipt_line_id) references goods_receipt_line (id);
alter table receipt_coa_result add constraint fk_receipt_coa_result_spec_item_id foreign key (spec_item_id) references material_spec_item (id);
alter table receipt_coa_result add constraint fk_receipt_coa_result_created_by foreign key (created_by) references app_user (id);
alter table goods_receipt_scan add constraint fk_goods_receipt_scan_receipt_line_id foreign key (receipt_line_id) references goods_receipt_line (id);
alter table goods_receipt_scan add constraint fk_goods_receipt_scan_handling_unit_id foreign key (handling_unit_id) references handling_unit (id);
alter table goods_receipt_scan add constraint fk_goods_receipt_scan_created_by foreign key (created_by) references app_user (id);
alter table goods_receipt_damage add constraint fk_goods_receipt_damage_receipt_line_id foreign key (receipt_line_id) references goods_receipt_line (id);
alter table goods_receipt_damage add constraint fk_goods_receipt_damage_photo_file_id foreign key (photo_file_id) references file_attachment (id);
alter table goods_receipt_damage add constraint fk_goods_receipt_damage_supplier_return_id foreign key (supplier_return_id) references supplier_return (id);
alter table goods_receipt_damage add constraint fk_goods_receipt_damage_ncr_id foreign key (ncr_id) references ncr (id);
alter table goods_receipt_damage add constraint fk_goods_receipt_damage_created_by foreign key (created_by) references app_user (id);
alter table goods_issue add constraint fk_goods_issue_factory_id foreign key (factory_id) references factory (id);
alter table goods_issue add constraint fk_goods_issue_warehouse_id foreign key (warehouse_id) references warehouse (id);
alter table goods_issue add constraint fk_goods_issue_requested_by foreign key (requested_by) references app_user (id);
alter table goods_issue add constraint fk_goods_issue_doc_file_id foreign key (doc_file_id) references file_attachment (id);
alter table goods_issue add constraint fk_goods_issue_sales_order_id foreign key (sales_order_id) references sales_order (id);
alter table goods_issue add constraint fk_goods_issue_sales_issue_request_id foreign key (sales_issue_request_id) references sales_issue_request (id);
alter table goods_issue add constraint fk_goods_issue_production_order_id foreign key (production_order_id) references production_order (id);
alter table goods_issue add constraint fk_goods_issue_stock_transfer_id foreign key (stock_transfer_id) references stock_transfer (id);
alter table goods_issue add constraint fk_goods_issue_supplier_return_id foreign key (supplier_return_id) references supplier_return (id);
alter table goods_issue add constraint fk_goods_issue_requester_decision_by foreign key (requester_decision_by) references app_user (id);
alter table goods_issue add constraint fk_goods_issue_created_by foreign key (created_by) references app_user (id);
alter table goods_issue add constraint fk_goods_issue_updated_by foreign key (updated_by) references app_user (id);
alter table goods_issue_line add constraint fk_goods_issue_line_issue_id foreign key (issue_id) references goods_issue (id);
alter table goods_issue_line add constraint fk_goods_issue_line_material_id foreign key (material_id) references material (id);
alter table goods_issue_line add constraint fk_goods_issue_line_product_id foreign key (product_id) references product (id);
alter table goods_issue_line add constraint fk_goods_issue_line_proposed_lot_id foreign key (proposed_lot_id) references lot (id);
alter table goods_issue_line add constraint fk_goods_issue_line_uom_code foreign key (uom_code) references uom (code);
alter table goods_issue_line add constraint fk_goods_issue_line_substitute_for_line_id foreign key (substitute_for_line_id) references goods_issue_line (id);
alter table goods_issue_line add constraint fk_goods_issue_line_reservation_id foreign key (reservation_id) references material_reservation (id);
alter table goods_issue_line add constraint fk_goods_issue_line_sales_order_line_id foreign key (sales_order_line_id) references sales_order_line (id);
alter table goods_issue_line add constraint fk_goods_issue_line_created_by foreign key (created_by) references app_user (id);
alter table goods_issue_line add constraint fk_goods_issue_line_updated_by foreign key (updated_by) references app_user (id);
alter table goods_issue_scan add constraint fk_goods_issue_scan_factory_id foreign key (factory_id) references factory (id);
alter table goods_issue_scan add constraint fk_goods_issue_scan_issue_line_id foreign key (issue_line_id) references goods_issue_line (id);
alter table goods_issue_scan add constraint fk_goods_issue_scan_handling_unit_id foreign key (handling_unit_id) references handling_unit (id);
alter table goods_issue_scan add constraint fk_goods_issue_scan_lot_id foreign key (lot_id) references lot (id);
alter table goods_issue_scan add constraint fk_goods_issue_scan_from_stock_line_id foreign key (from_stock_line_id) references stock_line (id);
alter table goods_issue_scan add constraint fk_goods_issue_scan_created_by foreign key (created_by) references app_user (id);
alter table stock_discrepancy add constraint fk_stock_discrepancy_factory_id foreign key (factory_id) references factory (id);
alter table stock_discrepancy add constraint fk_stock_discrepancy_lot_id foreign key (lot_id) references lot (id);
alter table stock_discrepancy add constraint fk_stock_discrepancy_warehouse_id foreign key (warehouse_id) references warehouse (id);
alter table stock_discrepancy add constraint fk_stock_discrepancy_stocktake_id foreign key (stocktake_id) references stocktake (id);
alter table stock_discrepancy add constraint fk_stock_discrepancy_created_by foreign key (created_by) references app_user (id);
alter table stock_transfer add constraint fk_stock_transfer_factory_id foreign key (factory_id) references factory (id);
alter table stock_transfer add constraint fk_stock_transfer_to_factory_id foreign key (to_factory_id) references factory (id);
alter table stock_transfer add constraint fk_stock_transfer_from_warehouse_id foreign key (from_warehouse_id) references warehouse (id);
alter table stock_transfer add constraint fk_stock_transfer_to_warehouse_id foreign key (to_warehouse_id) references warehouse (id);
alter table stock_transfer add constraint fk_stock_transfer_source_order_id foreign key (source_order_id) references production_order (id);
alter table stock_transfer add constraint fk_stock_transfer_created_by foreign key (created_by) references app_user (id);
alter table stock_transfer add constraint fk_stock_transfer_updated_by foreign key (updated_by) references app_user (id);
alter table stock_transfer_line add constraint fk_stock_transfer_line_transfer_id foreign key (transfer_id) references stock_transfer (id);
alter table stock_transfer_line add constraint fk_stock_transfer_line_lot_id foreign key (lot_id) references lot (id);
alter table stock_transfer_line add constraint fk_stock_transfer_line_material_id foreign key (material_id) references material (id);
alter table stock_transfer_line add constraint fk_stock_transfer_line_product_id foreign key (product_id) references product (id);
alter table stock_transfer_line add constraint fk_stock_transfer_line_transfer_request_id foreign key (transfer_request_id) references transfer_request (id);
alter table stock_transfer_line add constraint fk_stock_transfer_line_uom_code foreign key (uom_code) references uom (code);
alter table stock_transfer_line add constraint fk_stock_transfer_line_created_by foreign key (created_by) references app_user (id);
alter table stock_transfer_line add constraint fk_stock_transfer_line_updated_by foreign key (updated_by) references app_user (id);
alter table transfer_request add constraint fk_transfer_request_factory_id foreign key (factory_id) references factory (id);
alter table transfer_request add constraint fk_transfer_request_to_factory_id foreign key (to_factory_id) references factory (id);
alter table transfer_request add constraint fk_transfer_request_from_warehouse_id foreign key (from_warehouse_id) references warehouse (id);
alter table transfer_request add constraint fk_transfer_request_to_warehouse_id foreign key (to_warehouse_id) references warehouse (id);
alter table transfer_request add constraint fk_transfer_request_material_id foreign key (material_id) references material (id);
alter table transfer_request add constraint fk_transfer_request_product_id foreign key (product_id) references product (id);
alter table transfer_request add constraint fk_transfer_request_uom_code foreign key (uom_code) references uom (code);
alter table transfer_request add constraint fk_transfer_request_production_order_id foreign key (production_order_id) references production_order (id);
alter table transfer_request add constraint fk_transfer_request_requested_by foreign key (requested_by) references app_user (id);
alter table transfer_request add constraint fk_transfer_request_stock_transfer_id foreign key (stock_transfer_id) references stock_transfer (id);
alter table transfer_request add constraint fk_transfer_request_parent_request_id foreign key (parent_request_id) references transfer_request (id);
alter table transfer_request add constraint fk_transfer_request_created_by foreign key (created_by) references app_user (id);
alter table transfer_request add constraint fk_transfer_request_updated_by foreign key (updated_by) references app_user (id);
alter table transfer_discrepancy add constraint fk_transfer_discrepancy_transfer_line_id foreign key (transfer_line_id) references stock_transfer_line (id);
alter table transfer_discrepancy add constraint fk_transfer_discrepancy_photo_file_id foreign key (photo_file_id) references file_attachment (id);
alter table transfer_discrepancy add constraint fk_transfer_discrepancy_resolved_by foreign key (resolved_by) references app_user (id);
alter table transfer_discrepancy add constraint fk_transfer_discrepancy_confirmed_by foreign key (confirmed_by) references app_user (id);
alter table transfer_discrepancy add constraint fk_transfer_discrepancy_qc_request_id foreign key (qc_request_id) references qc_request (id);
alter table transfer_discrepancy add constraint fk_transfer_discrepancy_disposal_id foreign key (disposal_id) references disposal (id);
alter table transfer_discrepancy add constraint fk_transfer_discrepancy_created_by foreign key (created_by) references app_user (id);
alter table transfer_discrepancy add constraint fk_transfer_discrepancy_updated_by foreign key (updated_by) references app_user (id);
alter table stocktake add constraint fk_stocktake_factory_id foreign key (factory_id) references factory (id);
alter table stocktake add constraint fk_stocktake_warehouse_id foreign key (warehouse_id) references warehouse (id);
alter table stocktake add constraint fk_stocktake_approved_by foreign key (approved_by) references app_user (id);
alter table stocktake add constraint fk_stocktake_report_file_id foreign key (report_file_id) references file_attachment (id);
alter table stocktake add constraint fk_stocktake_created_by foreign key (created_by) references app_user (id);
alter table stocktake add constraint fk_stocktake_updated_by foreign key (updated_by) references app_user (id);
alter table stocktake_lock add constraint fk_stocktake_lock_stocktake_id foreign key (stocktake_id) references stocktake (id);
alter table stocktake_lock add constraint fk_stocktake_lock_warehouse_id foreign key (warehouse_id) references warehouse (id);
alter table stocktake_lock add constraint fk_stocktake_lock_lot_id foreign key (lot_id) references lot (id);
alter table stocktake_lock add constraint fk_stocktake_lock_created_by foreign key (created_by) references app_user (id);
alter table stocktake_line add constraint fk_stocktake_line_stocktake_id foreign key (stocktake_id) references stocktake (id);
alter table stocktake_line add constraint fk_stocktake_line_lot_id foreign key (lot_id) references lot (id);
alter table stocktake_line add constraint fk_stocktake_line_counted_by foreign key (counted_by) references app_user (id);
alter table stocktake_line add constraint fk_stocktake_line_created_by foreign key (created_by) references app_user (id);
alter table stocktake_line add constraint fk_stocktake_line_updated_by foreign key (updated_by) references app_user (id);
alter table stock_adjustment add constraint fk_stock_adjustment_stocktake_line_id foreign key (stocktake_line_id) references stocktake_line (id);
alter table stock_adjustment add constraint fk_stock_adjustment_stock_line_id foreign key (stock_line_id) references stock_line (id);
alter table stock_adjustment add constraint fk_stock_adjustment_new_lock_reason foreign key (new_lock_reason) references lock_reason (code);
alter table stock_adjustment add constraint fk_stock_adjustment_approved_by foreign key (approved_by) references app_user (id);
alter table stock_adjustment add constraint fk_stock_adjustment_created_by foreign key (created_by) references app_user (id);
alter table stock_adjustment add constraint fk_stock_adjustment_updated_by foreign key (updated_by) references app_user (id);
alter table disposal add constraint fk_disposal_factory_id foreign key (factory_id) references factory (id);
alter table disposal add constraint fk_disposal_warehouse_id foreign key (warehouse_id) references warehouse (id);
alter table disposal add constraint fk_disposal_confirmed_by foreign key (confirmed_by) references app_user (id);
alter table disposal add constraint fk_disposal_executed_by foreign key (executed_by) references app_user (id);
alter table disposal add constraint fk_disposal_report_file_id foreign key (report_file_id) references file_attachment (id);
alter table disposal add constraint fk_disposal_recall_case_id foreign key (recall_case_id) references recall_case (id);
alter table disposal add constraint fk_disposal_sales_order_id foreign key (sales_order_id) references sales_order (id);
alter table disposal add constraint fk_disposal_supplier_return_id foreign key (supplier_return_id) references supplier_return (id);
alter table disposal add constraint fk_disposal_created_by foreign key (created_by) references app_user (id);
alter table disposal add constraint fk_disposal_updated_by foreign key (updated_by) references app_user (id);
alter table disposal_line add constraint fk_disposal_line_disposal_id foreign key (disposal_id) references disposal (id);
alter table disposal_line add constraint fk_disposal_line_lot_id foreign key (lot_id) references lot (id);
alter table disposal_line add constraint fk_disposal_line_stock_line_id foreign key (stock_line_id) references stock_line (id);
alter table disposal_line add constraint fk_disposal_line_prev_lock_reason foreign key (prev_lock_reason) references lock_reason (code);
alter table disposal_line add constraint fk_disposal_line_created_by foreign key (created_by) references app_user (id);
alter table customer add constraint fk_customer_created_by foreign key (created_by) references app_user (id);
alter table customer add constraint fk_customer_updated_by foreign key (updated_by) references app_user (id);
alter table customer_contact_log add constraint fk_customer_contact_log_customer_id foreign key (customer_id) references customer (id);
alter table customer_contact_log add constraint fk_customer_contact_log_sales_order_id foreign key (sales_order_id) references sales_order (id);
alter table customer_contact_log add constraint fk_customer_contact_log_payment_schedule_id foreign key (payment_schedule_id) references payment_schedule (id);
alter table customer_contact_log add constraint fk_customer_contact_log_created_by foreign key (created_by) references app_user (id);
alter table credit_limit_request add constraint fk_credit_limit_request_customer_id foreign key (customer_id) references customer (id);
alter table credit_limit_request add constraint fk_credit_limit_request_sales_order_version_id foreign key (sales_order_version_id) references sales_order_version (id);
alter table credit_limit_request add constraint fk_credit_limit_request_decided_by foreign key (decided_by) references app_user (id);
alter table credit_limit_request add constraint fk_credit_limit_request_created_by foreign key (created_by) references app_user (id);
alter table credit_limit_request add constraint fk_credit_limit_request_updated_by foreign key (updated_by) references app_user (id);
alter table sales_order add constraint fk_sales_order_factory_id foreign key (factory_id) references factory (id);
alter table sales_order add constraint fk_sales_order_customer_id foreign key (customer_id) references customer (id);
alter table sales_order add constraint fk_sales_order_sales_user_id foreign key (sales_user_id) references app_user (id);
alter table sales_order add constraint fk_sales_order_cancelled_by foreign key (cancelled_by) references app_user (id);
alter table sales_order add constraint fk_sales_order_cancel_approved_by foreign key (cancel_approved_by) references app_user (id);
alter table sales_order add constraint fk_sales_order_delivery_approved_by foreign key (delivery_approved_by) references app_user (id);
alter table sales_order add constraint fk_sales_order_created_by foreign key (created_by) references app_user (id);
alter table sales_order add constraint fk_sales_order_updated_by foreign key (updated_by) references app_user (id);
alter table sales_order_version add constraint fk_sales_order_version_sales_order_id foreign key (sales_order_id) references sales_order (id);
alter table sales_order_version add constraint fk_sales_order_version_created_by foreign key (created_by) references app_user (id);
alter table sales_order_line add constraint fk_sales_order_line_version_id foreign key (version_id) references sales_order_version (id);
alter table sales_order_line add constraint fk_sales_order_line_product_id foreign key (product_id) references product (id);
alter table sales_order_line add constraint fk_sales_order_line_uom_code foreign key (uom_code) references uom (code);
alter table sales_order_line add constraint fk_sales_order_line_created_by foreign key (created_by) references app_user (id);
alter table sales_order_lot add constraint fk_sales_order_lot_sales_order_id foreign key (sales_order_id) references sales_order (id);
alter table sales_order_lot add constraint fk_sales_order_lot_lot_id foreign key (lot_id) references lot (id);
alter table sales_order_lot add constraint fk_sales_order_lot_created_by foreign key (created_by) references app_user (id);
alter table sales_order_status_log add constraint fk_sales_order_status_log_sales_order_id foreign key (sales_order_id) references sales_order (id);
alter table sales_order_status_log add constraint fk_sales_order_status_log_actor_id foreign key (actor_id) references app_user (id);
alter table payment_schedule add constraint fk_payment_schedule_sales_order_id foreign key (sales_order_id) references sales_order (id);
alter table payment_schedule add constraint fk_payment_schedule_version_id foreign key (version_id) references sales_order_version (id);
alter table payment_schedule add constraint fk_payment_schedule_sales_issue_request_id foreign key (sales_issue_request_id) references sales_issue_request (id);
alter table payment_schedule add constraint fk_payment_schedule_escalation_file_id foreign key (escalation_file_id) references file_attachment (id);
alter table payment_schedule add constraint fk_payment_schedule_created_by foreign key (created_by) references app_user (id);
alter table payment_schedule add constraint fk_payment_schedule_updated_by foreign key (updated_by) references app_user (id);
alter table sales_issue_request add constraint fk_sales_issue_request_factory_id foreign key (factory_id) references factory (id);
alter table sales_issue_request add constraint fk_sales_issue_request_sales_order_id foreign key (sales_order_id) references sales_order (id);
alter table sales_issue_request add constraint fk_sales_issue_request_cancelled_by foreign key (cancelled_by) references app_user (id);
alter table sales_issue_request add constraint fk_sales_issue_request_created_by foreign key (created_by) references app_user (id);
alter table sales_issue_request add constraint fk_sales_issue_request_updated_by foreign key (updated_by) references app_user (id);
alter table sales_issue_request_line add constraint fk_sales_issue_request_line_request_id foreign key (request_id) references sales_issue_request (id);
alter table sales_issue_request_line add constraint fk_sales_issue_request_line_sales_order_line_id foreign key (sales_order_line_id) references sales_order_line (id);
alter table sales_issue_request_line add constraint fk_sales_issue_request_line_lot_id foreign key (lot_id) references lot (id);
alter table sales_issue_request_line add constraint fk_sales_issue_request_line_uom_code foreign key (uom_code) references uom (code);
alter table sales_issue_request_line add constraint fk_sales_issue_request_line_created_by foreign key (created_by) references app_user (id);
alter table delivery_note add constraint fk_delivery_note_goods_issue_id foreign key (goods_issue_id) references goods_issue (id);
alter table delivery_note add constraint fk_delivery_note_photo_file_id foreign key (photo_file_id) references file_attachment (id);
alter table delivery_note add constraint fk_delivery_note_created_by foreign key (created_by) references app_user (id);
alter table delivery_note add constraint fk_delivery_note_updated_by foreign key (updated_by) references app_user (id);
alter table delivery_note_line add constraint fk_delivery_note_line_delivery_note_id foreign key (delivery_note_id) references delivery_note (id);
alter table delivery_note_line add constraint fk_delivery_note_line_lot_id foreign key (lot_id) references lot (id);
alter table delivery_note_line add constraint fk_delivery_note_line_uom_code foreign key (uom_code) references uom (code);
alter table delivery_note_line add constraint fk_delivery_note_line_created_by foreign key (created_by) references app_user (id);
alter table sales_order_invoice add constraint fk_sales_order_invoice_sales_order_id foreign key (sales_order_id) references sales_order (id);
alter table sales_order_invoice add constraint fk_sales_order_invoice_goods_issue_id foreign key (goods_issue_id) references goods_issue (id);
alter table sales_order_invoice add constraint fk_sales_order_invoice_invoice_file_id foreign key (invoice_file_id) references file_attachment (id);
alter table sales_order_invoice add constraint fk_sales_order_invoice_created_by foreign key (created_by) references app_user (id);
alter table sales_order_invoice add constraint fk_sales_order_invoice_updated_by foreign key (updated_by) references app_user (id);
alter table payment_voucher add constraint fk_payment_voucher_factory_id foreign key (factory_id) references factory (id);
alter table payment_voucher add constraint fk_payment_voucher_customer_id foreign key (customer_id) references customer (id);
alter table payment_voucher add constraint fk_payment_voucher_supplier_id foreign key (supplier_id) references supplier (id);
alter table payment_voucher add constraint fk_payment_voucher_sales_order_id foreign key (sales_order_id) references sales_order (id);
alter table payment_voucher add constraint fk_payment_voucher_purchase_order_id foreign key (purchase_order_id) references purchase_order (id);
alter table payment_voucher add constraint fk_payment_voucher_doc_file_id foreign key (doc_file_id) references file_attachment (id);
alter table payment_voucher add constraint fk_payment_voucher_created_by foreign key (created_by) references app_user (id);
alter table payment_voucher add constraint fk_payment_voucher_updated_by foreign key (updated_by) references app_user (id);
alter table payment_allocation add constraint fk_payment_allocation_voucher_id foreign key (voucher_id) references payment_voucher (id);
alter table payment_allocation add constraint fk_payment_allocation_payment_schedule_id foreign key (payment_schedule_id) references payment_schedule (id);
alter table payment_allocation add constraint fk_payment_allocation_created_by foreign key (created_by) references app_user (id);
alter table ar_entry add constraint fk_ar_entry_customer_id foreign key (customer_id) references customer (id);
alter table ar_entry add constraint fk_ar_entry_sales_order_id foreign key (sales_order_id) references sales_order (id);
alter table ar_entry add constraint fk_ar_entry_delivery_note_id foreign key (delivery_note_id) references delivery_note (id);
alter table ar_entry add constraint fk_ar_entry_voucher_id foreign key (voucher_id) references payment_voucher (id);
alter table ar_entry add constraint fk_ar_entry_payment_schedule_id foreign key (payment_schedule_id) references payment_schedule (id);
alter table ar_entry add constraint fk_ar_entry_created_by foreign key (created_by) references app_user (id);
alter table supplier add constraint fk_supplier_approved_by foreign key (approved_by) references app_user (id);
alter table supplier add constraint fk_supplier_created_by foreign key (created_by) references app_user (id);
alter table supplier add constraint fk_supplier_updated_by foreign key (updated_by) references app_user (id);
alter table supplier_status_log add constraint fk_supplier_status_log_supplier_id foreign key (supplier_id) references supplier (id);
alter table supplier_status_log add constraint fk_supplier_status_log_actor_id foreign key (actor_id) references app_user (id);
alter table supplier_certificate add constraint fk_supplier_certificate_supplier_id foreign key (supplier_id) references supplier (id);
alter table supplier_certificate add constraint fk_supplier_certificate_file_id foreign key (file_id) references file_attachment (id);
alter table supplier_certificate add constraint fk_supplier_certificate_created_by foreign key (created_by) references app_user (id);
alter table supplier_certificate add constraint fk_supplier_certificate_updated_by foreign key (updated_by) references app_user (id);
alter table supplier_material add constraint fk_supplier_material_supplier_id foreign key (supplier_id) references supplier (id);
alter table supplier_material add constraint fk_supplier_material_material_id foreign key (material_id) references material (id);
alter table supplier_material add constraint fk_supplier_material_created_by foreign key (created_by) references app_user (id);
alter table supplier_material add constraint fk_supplier_material_updated_by foreign key (updated_by) references app_user (id);
alter table supplier_history add constraint fk_supplier_history_supplier_id foreign key (supplier_id) references supplier (id);
alter table supplier_history add constraint fk_supplier_history_purchase_order_id foreign key (purchase_order_id) references purchase_order (id);
alter table supplier_history add constraint fk_supplier_history_supplier_return_id foreign key (supplier_return_id) references supplier_return (id);
alter table supplier_history add constraint fk_supplier_history_created_by foreign key (created_by) references app_user (id);
alter table purchase_request add constraint fk_purchase_request_factory_id foreign key (factory_id) references factory (id);
alter table purchase_request add constraint fk_purchase_request_cancelled_by foreign key (cancelled_by) references app_user (id);
alter table purchase_request add constraint fk_purchase_request_created_by foreign key (created_by) references app_user (id);
alter table purchase_request add constraint fk_purchase_request_updated_by foreign key (updated_by) references app_user (id);
alter table purchase_request_line add constraint fk_purchase_request_line_request_id foreign key (request_id) references purchase_request (id);
alter table purchase_request_line add constraint fk_purchase_request_line_material_id foreign key (material_id) references material (id);
alter table purchase_request_line add constraint fk_purchase_request_line_warehouse_id foreign key (warehouse_id) references warehouse (id);
alter table purchase_request_line add constraint fk_purchase_request_line_uom_code foreign key (uom_code) references uom (code);
alter table purchase_request_line add constraint fk_purchase_request_line_suggested_supplier_id foreign key (suggested_supplier_id) references supplier (id);
alter table purchase_request_line add constraint fk_purchase_request_line_po_line_id foreign key (po_line_id) references purchase_order_line (id);
alter table purchase_request_line add constraint fk_purchase_request_line_returned_by foreign key (returned_by) references app_user (id);
alter table purchase_request_line add constraint fk_purchase_request_line_created_by foreign key (created_by) references app_user (id);
alter table purchase_order add constraint fk_purchase_order_factory_id foreign key (factory_id) references factory (id);
alter table purchase_order add constraint fk_purchase_order_supplier_id foreign key (supplier_id) references supplier (id);
alter table purchase_order add constraint fk_purchase_order_warehouse_id foreign key (warehouse_id) references warehouse (id);
alter table purchase_order add constraint fk_purchase_order_payment_chosen_by foreign key (payment_chosen_by) references app_user (id);
alter table purchase_order add constraint fk_purchase_order_coa_requested_by foreign key (coa_requested_by) references app_user (id);
alter table purchase_order add constraint fk_purchase_order_coa_checked_by foreign key (coa_checked_by) references app_user (id);
alter table purchase_order add constraint fk_purchase_order_approved_by foreign key (approved_by) references app_user (id);
alter table purchase_order add constraint fk_purchase_order_director_approved_by foreign key (director_approved_by) references app_user (id);
alter table purchase_order add constraint fk_purchase_order_cancelled_by foreign key (cancelled_by) references app_user (id);
alter table purchase_order add constraint fk_purchase_order_rejected_by foreign key (rejected_by) references app_user (id);
alter table purchase_order add constraint fk_purchase_order_closed_by foreign key (closed_by) references app_user (id);
alter table purchase_order add constraint fk_purchase_order_created_by foreign key (created_by) references app_user (id);
alter table purchase_order add constraint fk_purchase_order_updated_by foreign key (updated_by) references app_user (id);
alter table purchase_order_line add constraint fk_purchase_order_line_po_id foreign key (po_id) references purchase_order (id);
alter table purchase_order_line add constraint fk_purchase_order_line_material_id foreign key (material_id) references material (id);
alter table purchase_order_line add constraint fk_purchase_order_line_uom_code foreign key (uom_code) references uom (code);
alter table purchase_order_line add constraint fk_purchase_order_line_coa_file_id foreign key (coa_file_id) references file_attachment (id);
alter table purchase_order_line add constraint fk_purchase_order_line_created_by foreign key (created_by) references app_user (id);
alter table purchase_order_line add constraint fk_purchase_order_line_updated_by foreign key (updated_by) references app_user (id);
alter table purchase_order_coa_result add constraint fk_purchase_order_coa_result_po_line_id foreign key (po_line_id) references purchase_order_line (id);
alter table purchase_order_coa_result add constraint fk_purchase_order_coa_result_spec_item_id foreign key (spec_item_id) references material_spec_item (id);
alter table purchase_order_coa_result add constraint fk_purchase_order_coa_result_created_by foreign key (created_by) references app_user (id);
alter table ap_entry add constraint fk_ap_entry_supplier_id foreign key (supplier_id) references supplier (id);
alter table ap_entry add constraint fk_ap_entry_purchase_order_id foreign key (purchase_order_id) references purchase_order (id);
alter table ap_entry add constraint fk_ap_entry_supplier_return_id foreign key (supplier_return_id) references supplier_return (id);
alter table ap_entry add constraint fk_ap_entry_voucher_id foreign key (voucher_id) references payment_voucher (id);
alter table ap_entry add constraint fk_ap_entry_created_by foreign key (created_by) references app_user (id);
alter table supplier_return add constraint fk_supplier_return_factory_id foreign key (factory_id) references factory (id);
alter table supplier_return add constraint fk_supplier_return_supplier_id foreign key (supplier_id) references supplier (id);
alter table supplier_return add constraint fk_supplier_return_purchase_order_id foreign key (purchase_order_id) references purchase_order (id);
alter table supplier_return add constraint fk_supplier_return_goods_receipt_id foreign key (goods_receipt_id) references goods_receipt (id);
alter table supplier_return add constraint fk_supplier_return_qc_inspection_id foreign key (qc_inspection_id) references qc_inspection (id);
alter table supplier_return add constraint fk_supplier_return_disagreement_file_id foreign key (disagreement_file_id) references file_attachment (id);
alter table supplier_return add constraint fk_supplier_return_goods_issue_id foreign key (goods_issue_id) references goods_issue (id);
alter table supplier_return add constraint fk_supplier_return_disposal_id foreign key (disposal_id) references disposal (id);
alter table supplier_return add constraint fk_supplier_return_replacement_receipt_id foreign key (replacement_receipt_id) references goods_receipt (id);
alter table supplier_return add constraint fk_supplier_return_export_requested_by foreign key (export_requested_by) references app_user (id);
alter table supplier_return add constraint fk_supplier_return_export_approved_by foreign key (export_approved_by) references app_user (id);
alter table supplier_return add constraint fk_supplier_return_created_by foreign key (created_by) references app_user (id);
alter table supplier_return add constraint fk_supplier_return_updated_by foreign key (updated_by) references app_user (id);
alter table supplier_return_line add constraint fk_supplier_return_line_return_id foreign key (return_id) references supplier_return (id);
alter table supplier_return_line add constraint fk_supplier_return_line_lot_id foreign key (lot_id) references lot (id);
alter table supplier_return_line add constraint fk_supplier_return_line_material_id foreign key (material_id) references material (id);
alter table supplier_return_line add constraint fk_supplier_return_line_uom_code foreign key (uom_code) references uom (code);
alter table supplier_return_line add constraint fk_supplier_return_line_created_by foreign key (created_by) references app_user (id);
alter table production_order add constraint fk_production_order_factory_id foreign key (factory_id) references factory (id);
alter table production_order add constraint fk_production_order_work_area_id foreign key (work_area_id) references work_area (id);
alter table production_order add constraint fk_production_order_sales_order_id foreign key (sales_order_id) references sales_order (id);
alter table production_order add constraint fk_production_order_formula_version_id foreign key (formula_version_id) references formula_version (id);
alter table production_order add constraint fk_production_order_marketing_user_id foreign key (marketing_user_id) references app_user (id);
alter table production_order add constraint fk_production_order_cancel_requested_by foreign key (cancel_requested_by) references app_user (id);
alter table production_order add constraint fk_production_order_ended_early_by foreign key (ended_early_by) references app_user (id);
alter table production_order add constraint fk_production_order_created_by foreign key (created_by) references app_user (id);
alter table production_order add constraint fk_production_order_updated_by foreign key (updated_by) references app_user (id);
alter table production_order_brand add constraint fk_production_order_brand_production_order_id foreign key (production_order_id) references production_order (id);
alter table production_order_brand add constraint fk_production_order_brand_product_id foreign key (product_id) references product (id);
alter table production_order_brand add constraint fk_production_order_brand_product_pack_id foreign key (product_pack_id) references product_pack (id);
alter table production_order_brand add constraint fk_production_order_brand_sales_order_line_id foreign key (sales_order_line_id) references sales_order_line (id);
alter table production_order_brand add constraint fk_production_order_brand_created_by foreign key (created_by) references app_user (id);
alter table production_order_silo add constraint fk_production_order_silo_production_order_id foreign key (production_order_id) references production_order (id);
alter table production_order_silo add constraint fk_production_order_silo_material_id foreign key (material_id) references material (id);
alter table production_order_silo add constraint fk_production_order_silo_silo_equipment_id foreign key (silo_equipment_id) references equipment (id);
alter table production_order_silo add constraint fk_production_order_silo_created_by foreign key (created_by) references app_user (id);
alter table production_order_silo add constraint fk_production_order_silo_updated_by foreign key (updated_by) references app_user (id);
alter table material_reservation add constraint fk_material_reservation_production_order_id foreign key (production_order_id) references production_order (id);
alter table material_reservation add constraint fk_material_reservation_material_id foreign key (material_id) references material (id);
alter table material_reservation add constraint fk_material_reservation_created_by foreign key (created_by) references app_user (id);
alter table material_reservation add constraint fk_material_reservation_updated_by foreign key (updated_by) references app_user (id);
alter table production_batch add constraint fk_production_batch_factory_id foreign key (factory_id) references factory (id);
alter table production_batch add constraint fk_production_batch_production_order_id foreign key (production_order_id) references production_order (id);
alter table production_batch add constraint fk_production_batch_formula_version_id foreign key (formula_version_id) references formula_version (id);
alter table production_batch add constraint fk_production_batch_work_area_id foreign key (work_area_id) references work_area (id);
alter table production_batch add constraint fk_production_batch_batch_lot_id foreign key (batch_lot_id) references lot (id);
alter table production_batch add constraint fk_production_batch_created_by foreign key (created_by) references app_user (id);
alter table production_batch add constraint fk_production_batch_updated_by foreign key (updated_by) references app_user (id);
alter table batch_cancellation add constraint fk_batch_cancellation_factory_id foreign key (factory_id) references factory (id);
alter table batch_cancellation add constraint fk_batch_cancellation_batch_id foreign key (batch_id) references production_batch (id);
alter table batch_cancellation add constraint fk_batch_cancellation_production_order_id foreign key (production_order_id) references production_order (id);
alter table batch_cancellation add constraint fk_batch_cancellation_downtime_id foreign key (downtime_id) references batch_downtime (id);
alter table batch_cancellation add constraint fk_batch_cancellation_scrap_lot_id foreign key (scrap_lot_id) references lot (id);
alter table batch_cancellation add constraint fk_batch_cancellation_disposal_id foreign key (disposal_id) references disposal (id);
alter table batch_cancellation add constraint fk_batch_cancellation_site_command_id foreign key (site_command_id) references site_command (id);
alter table batch_cancellation add constraint fk_batch_cancellation_decided_by foreign key (decided_by) references app_user (id);
alter table batch_cancellation add constraint fk_batch_cancellation_created_by foreign key (created_by) references app_user (id);
alter table batch_cancellation add constraint fk_batch_cancellation_updated_by foreign key (updated_by) references app_user (id);
alter table batch_operator add constraint fk_batch_operator_batch_id foreign key (batch_id) references production_batch (id);
alter table batch_operator add constraint fk_batch_operator_user_id foreign key (user_id) references app_user (id);
alter table batch_operator add constraint fk_batch_operator_work_area_id foreign key (work_area_id) references work_area (id);
alter table batch_operator add constraint fk_batch_operator_created_by foreign key (created_by) references app_user (id);
alter table batch_equipment_usage add constraint fk_batch_equipment_usage_batch_id foreign key (batch_id) references production_batch (id);
alter table batch_equipment_usage add constraint fk_batch_equipment_usage_equipment_id foreign key (equipment_id) references equipment (id);
alter table batch_equipment_usage add constraint fk_batch_equipment_usage_created_by foreign key (created_by) references app_user (id);
alter table silo_charge add constraint fk_silo_charge_factory_id foreign key (factory_id) references factory (id);
alter table silo_charge add constraint fk_silo_charge_production_order_id foreign key (production_order_id) references production_order (id);
alter table silo_charge add constraint fk_silo_charge_handling_unit_id foreign key (handling_unit_id) references handling_unit (id);
alter table silo_charge add constraint fk_silo_charge_lot_id foreign key (lot_id) references lot (id);
alter table silo_charge add constraint fk_silo_charge_silo_equipment_id foreign key (silo_equipment_id) references equipment (id);
alter table silo_charge add constraint fk_silo_charge_silo_lot_id foreign key (silo_lot_id) references lot (id);
alter table silo_charge add constraint fk_silo_charge_lot_link_id foreign key (lot_link_id) references lot_link (id);
alter table silo_charge add constraint fk_silo_charge_created_by foreign key (created_by) references app_user (id);
alter table filling_run add constraint fk_filling_run_factory_id foreign key (factory_id) references factory (id);
alter table filling_run add constraint fk_filling_run_batch_id foreign key (batch_id) references production_batch (id);
alter table filling_run add constraint fk_filling_run_product_id foreign key (product_id) references product (id);
alter table filling_run add constraint fk_filling_run_lot_id foreign key (lot_id) references lot (id);
alter table filling_run add constraint fk_filling_run_created_by foreign key (created_by) references app_user (id);
alter table filling_run add constraint fk_filling_run_updated_by foreign key (updated_by) references app_user (id);
alter table carton_recount add constraint fk_carton_recount_factory_id foreign key (factory_id) references factory (id);
alter table carton_recount add constraint fk_carton_recount_handling_unit_id foreign key (handling_unit_id) references handling_unit (id);
alter table carton_recount add constraint fk_carton_recount_filling_run_id foreign key (filling_run_id) references filling_run (id);
alter table carton_recount add constraint fk_carton_recount_created_by foreign key (created_by) references app_user (id);
alter table batch_mixing_param add constraint fk_batch_mixing_param_batch_id foreign key (batch_id) references production_batch (id);
alter table batch_mixing_param add constraint fk_batch_mixing_param_created_by foreign key (created_by) references app_user (id);
alter table batch_downtime add constraint fk_batch_downtime_batch_id foreign key (batch_id) references production_batch (id);
alter table batch_downtime add constraint fk_batch_downtime_equipment_id foreign key (equipment_id) references equipment (id);
alter table batch_downtime add constraint fk_batch_downtime_created_by foreign key (created_by) references app_user (id);
alter table batch_weight_check add constraint fk_batch_weight_check_batch_id foreign key (batch_id) references production_batch (id);
alter table batch_weight_check add constraint fk_batch_weight_check_handling_unit_id foreign key (handling_unit_id) references handling_unit (id);
alter table batch_weight_check add constraint fk_batch_weight_check_created_by foreign key (created_by) references app_user (id);
alter table filling_can_weight add constraint fk_filling_can_weight_filling_run_id foreign key (filling_run_id) references filling_run (id);
alter table ncr add constraint fk_ncr_factory_id foreign key (factory_id) references factory (id);
alter table ncr add constraint fk_ncr_lot_id foreign key (lot_id) references lot (id);
alter table ncr add constraint fk_ncr_batch_id foreign key (batch_id) references production_batch (id);
alter table ncr add constraint fk_ncr_created_by foreign key (created_by) references app_user (id);
alter table ncr add constraint fk_ncr_updated_by foreign key (updated_by) references app_user (id);
alter table sync_outbox add constraint fk_sync_outbox_factory_id foreign key (factory_id) references factory (id);
alter table sync_outbox add constraint fk_sync_outbox_production_order_id foreign key (production_order_id) references production_order (id);
alter table sync_outbox add constraint fk_sync_outbox_batch_id foreign key (batch_id) references production_batch (id);
alter table sync_outbox add constraint fk_sync_outbox_recorded_by foreign key (recorded_by) references app_user (id);
alter table sync_event_inbox add constraint fk_sync_event_inbox_factory_id foreign key (factory_id) references factory (id);
alter table factory_sync_state add constraint fk_factory_sync_state_factory_id foreign key (factory_id) references factory (id);
alter table downstream_change add constraint fk_downstream_change_factory_id foreign key (factory_id) references factory (id);
alter table sync_conflict add constraint fk_sync_conflict_factory_id foreign key (factory_id) references factory (id);
alter table sync_conflict add constraint fk_sync_conflict_site_command_id foreign key (site_command_id) references site_command (id);
alter table sync_conflict add constraint fk_sync_conflict_lot_id foreign key (lot_id) references lot (id);
alter table sync_conflict add constraint fk_sync_conflict_batch_id foreign key (batch_id) references production_batch (id);
alter table sync_conflict add constraint fk_sync_conflict_handled_by foreign key (handled_by) references app_user (id);
alter table sync_conflict add constraint fk_sync_conflict_recall_case_id foreign key (recall_case_id) references recall_case (id);
alter table sync_conflict add constraint fk_sync_conflict_qc_request_id foreign key (qc_request_id) references qc_request (id);
alter table sync_conflict add constraint fk_sync_conflict_stocktake_id foreign key (stocktake_id) references stocktake (id);
alter table sync_conflict add constraint fk_sync_conflict_created_by foreign key (created_by) references app_user (id);
alter table sync_conflict add constraint fk_sync_conflict_updated_by foreign key (updated_by) references app_user (id);
alter table site_command add constraint fk_site_command_factory_id foreign key (factory_id) references factory (id);
alter table site_command add constraint fk_site_command_created_by foreign key (created_by) references app_user (id);
alter table command_inbox add constraint fk_command_inbox_factory_id foreign key (factory_id) references factory (id);
alter table command_inbox add constraint fk_command_inbox_command_id foreign key (command_id) references site_command (id);
alter table command_inbox add constraint fk_command_inbox_applied_by foreign key (applied_by) references app_user (id);
alter table offline_session add constraint fk_offline_session_factory_id foreign key (factory_id) references factory (id);
alter table qc_request add constraint fk_qc_request_factory_id foreign key (factory_id) references factory (id);
alter table qc_request add constraint fk_qc_request_lot_id foreign key (lot_id) references lot (id);
alter table qc_request add constraint fk_qc_request_reviewed_by foreign key (reviewed_by) references app_user (id);
alter table qc_request add constraint fk_qc_request_goods_receipt_id foreign key (goods_receipt_id) references goods_receipt (id);
alter table qc_request add constraint fk_qc_request_recall_case_id foreign key (recall_case_id) references recall_case (id);
alter table qc_request add constraint fk_qc_request_sync_conflict_id foreign key (sync_conflict_id) references sync_conflict (id);
alter table qc_request add constraint fk_qc_request_transfer_discrepancy_id foreign key (transfer_discrepancy_id) references transfer_discrepancy (id);
alter table qc_request add constraint fk_qc_request_created_by foreign key (created_by) references app_user (id);
alter table qc_request add constraint fk_qc_request_updated_by foreign key (updated_by) references app_user (id);
alter table qc_request_part add constraint fk_qc_request_part_request_id foreign key (request_id) references qc_request (id);
alter table qc_request_part add constraint fk_qc_request_part_stock_line_id foreign key (stock_line_id) references stock_line (id);
alter table qc_request_part add constraint fk_qc_request_part_prev_lock_reason foreign key (prev_lock_reason) references lock_reason (code);
alter table qc_request_part add constraint fk_qc_request_part_created_by foreign key (created_by) references app_user (id);
alter table qc_inspection add constraint fk_qc_inspection_factory_id foreign key (factory_id) references factory (id);
alter table qc_inspection add constraint fk_qc_inspection_request_id foreign key (request_id) references qc_request (id);
alter table qc_inspection add constraint fk_qc_inspection_lot_id foreign key (lot_id) references lot (id);
alter table qc_inspection add constraint fk_qc_inspection_sampled_by foreign key (sampled_by) references app_user (id);
alter table qc_inspection add constraint fk_qc_inspection_sample_uom foreign key (sample_uom) references uom (code);
alter table qc_inspection add constraint fk_qc_inspection_entered_by foreign key (entered_by) references app_user (id);
alter table qc_inspection add constraint fk_qc_inspection_external_report_file_id foreign key (external_report_file_id) references file_attachment (id);
alter table qc_inspection add constraint fk_qc_inspection_approved_by foreign key (approved_by) references app_user (id);
alter table qc_inspection add constraint fk_qc_inspection_created_by foreign key (created_by) references app_user (id);
alter table qc_inspection add constraint fk_qc_inspection_updated_by foreign key (updated_by) references app_user (id);
alter table qc_result_item add constraint fk_qc_result_item_inspection_id foreign key (inspection_id) references qc_inspection (id);
alter table qc_result_item add constraint fk_qc_result_item_material_spec_item_id foreign key (material_spec_item_id) references material_spec_item (id);
alter table qc_result_item add constraint fk_qc_result_item_product_spec_item_id foreign key (product_spec_item_id) references product_spec_item (id);
alter table qc_result_item add constraint fk_qc_result_item_created_by foreign key (created_by) references app_user (id);
alter table product_spec_item add constraint fk_product_spec_item_product_id foreign key (product_id) references product (id);
alter table product_spec_item add constraint fk_product_spec_item_created_by foreign key (created_by) references app_user (id);
alter table product_spec_item add constraint fk_product_spec_item_updated_by foreign key (updated_by) references app_user (id);
alter table quality_certificate add constraint fk_quality_certificate_factory_id foreign key (factory_id) references factory (id);
alter table quality_certificate add constraint fk_quality_certificate_lot_id foreign key (lot_id) references lot (id);
alter table quality_certificate add constraint fk_quality_certificate_inspection_id foreign key (inspection_id) references qc_inspection (id);
alter table quality_certificate add constraint fk_quality_certificate_approved_by foreign key (approved_by) references app_user (id);
alter table quality_certificate add constraint fk_quality_certificate_file_id foreign key (file_id) references file_attachment (id);
alter table quality_certificate add constraint fk_quality_certificate_signed_by foreign key (signed_by) references app_user (id);
alter table quality_certificate add constraint fk_quality_certificate_created_by foreign key (created_by) references app_user (id);
alter table quality_certificate add constraint fk_quality_certificate_updated_by foreign key (updated_by) references app_user (id);
alter table retained_sample add constraint fk_retained_sample_factory_id foreign key (factory_id) references factory (id);
alter table retained_sample add constraint fk_retained_sample_lot_id foreign key (lot_id) references lot (id);
alter table retained_sample add constraint fk_retained_sample_inspection_id foreign key (inspection_id) references qc_inspection (id);
alter table retained_sample add constraint fk_retained_sample_uom_code foreign key (uom_code) references uom (code);
alter table retained_sample add constraint fk_retained_sample_destroyed_by foreign key (destroyed_by) references app_user (id);
alter table retained_sample add constraint fk_retained_sample_destruction_file_id foreign key (destruction_file_id) references file_attachment (id);
alter table retained_sample add constraint fk_retained_sample_created_by foreign key (created_by) references app_user (id);
alter table retained_sample add constraint fk_retained_sample_updated_by foreign key (updated_by) references app_user (id);
alter table retained_sample_event add constraint fk_retained_sample_event_sample_id foreign key (sample_id) references retained_sample (id);
alter table retained_sample_event add constraint fk_retained_sample_event_trace_request_id foreign key (trace_request_id) references trace_request (id);
alter table retained_sample_event add constraint fk_retained_sample_event_recall_case_id foreign key (recall_case_id) references recall_case (id);
alter table retained_sample_event add constraint fk_retained_sample_event_actor_id foreign key (actor_id) references app_user (id);
alter table retained_sample_event add constraint fk_retained_sample_event_created_by foreign key (created_by) references app_user (id);
alter table trace_request add constraint fk_trace_request_factory_id foreign key (factory_id) references factory (id);
alter table trace_request add constraint fk_trace_request_recall_case_id foreign key (recall_case_id) references recall_case (id);
alter table trace_request add constraint fk_trace_request_input_sales_order_id foreign key (input_sales_order_id) references sales_order (id);
alter table trace_request add constraint fk_trace_request_input_customer_id foreign key (input_customer_id) references customer (id);
alter table trace_request add constraint fk_trace_request_input_material_id foreign key (input_material_id) references material (id);
alter table trace_request add constraint fk_trace_request_input_lot_id foreign key (input_lot_id) references lot (id);
alter table trace_request add constraint fk_trace_request_tracer_id foreign key (tracer_id) references app_user (id);
alter table trace_request add constraint fk_trace_request_report_file_id foreign key (report_file_id) references file_attachment (id);
alter table trace_request add constraint fk_trace_request_authority_letter_file_id foreign key (authority_letter_file_id) references file_attachment (id);
alter table trace_request add constraint fk_trace_request_created_by foreign key (created_by) references app_user (id);
alter table trace_request add constraint fk_trace_request_updated_by foreign key (updated_by) references app_user (id);
alter table trace_result_lot add constraint fk_trace_result_lot_trace_request_id foreign key (trace_request_id) references trace_request (id);
alter table trace_result_lot add constraint fk_trace_result_lot_lot_id foreign key (lot_id) references lot (id);
alter table trace_result_lot add constraint fk_trace_result_lot_created_by foreign key (created_by) references app_user (id);
alter table trace_result_customer add constraint fk_trace_result_customer_trace_request_id foreign key (trace_request_id) references trace_request (id);
alter table trace_result_customer add constraint fk_trace_result_customer_customer_id foreign key (customer_id) references customer (id);
alter table trace_result_customer add constraint fk_trace_result_customer_lot_id foreign key (lot_id) references lot (id);
alter table trace_result_customer add constraint fk_trace_result_customer_goods_issue_id foreign key (goods_issue_id) references goods_issue (id);
alter table trace_result_customer add constraint fk_trace_result_customer_created_by foreign key (created_by) references app_user (id);
alter table mass_balance_result add constraint fk_mass_balance_result_trace_request_id foreign key (trace_request_id) references trace_request (id);
alter table mass_balance_result add constraint fk_mass_balance_result_lot_id foreign key (lot_id) references lot (id);
alter table mass_balance_result add constraint fk_mass_balance_result_uom_code foreign key (uom_code) references uom (code);
alter table mass_balance_result add constraint fk_mass_balance_result_discrepancy_file_id foreign key (discrepancy_file_id) references file_attachment (id);
alter table mass_balance_result add constraint fk_mass_balance_result_stock_discrepancy_id foreign key (stock_discrepancy_id) references stock_discrepancy (id);
alter table mass_balance_result add constraint fk_mass_balance_result_created_by foreign key (created_by) references app_user (id);
alter table recall_case add constraint fk_recall_case_factory_id foreign key (factory_id) references factory (id);
alter table recall_case add constraint fk_recall_case_trace_request_id foreign key (trace_request_id) references trace_request (id);
alter table recall_case add constraint fk_recall_case_risk_assessed_by foreign key (risk_assessed_by) references app_user (id);
alter table recall_case add constraint fk_recall_case_decided_by foreign key (decided_by) references app_user (id);
alter table recall_case add constraint fk_recall_case_close_approved_by foreign key (close_approved_by) references app_user (id);
alter table recall_case add constraint fk_recall_case_created_by foreign key (created_by) references app_user (id);
alter table recall_case add constraint fk_recall_case_updated_by foreign key (updated_by) references app_user (id);
alter table recall_lot add constraint fk_recall_lot_recall_case_id foreign key (recall_case_id) references recall_case (id);
alter table recall_lot add constraint fk_recall_lot_lot_id foreign key (lot_id) references lot (id);
alter table recall_lot add constraint fk_recall_lot_qc_request_id foreign key (qc_request_id) references qc_request (id);
alter table recall_lot add constraint fk_recall_lot_created_by foreign key (created_by) references app_user (id);
alter table recall_customer add constraint fk_recall_customer_recall_case_id foreign key (recall_case_id) references recall_case (id);
alter table recall_customer add constraint fk_recall_customer_customer_id foreign key (customer_id) references customer (id);
alter table recall_customer add constraint fk_recall_customer_lot_id foreign key (lot_id) references lot (id);
alter table recall_customer add constraint fk_recall_customer_notified_by foreign key (notified_by) references app_user (id);
alter table recall_customer add constraint fk_recall_customer_created_by foreign key (created_by) references app_user (id);
alter table recall_customer add constraint fk_recall_customer_updated_by foreign key (updated_by) references app_user (id);
alter table recall_authority_report add constraint fk_recall_authority_report_recall_case_id foreign key (recall_case_id) references recall_case (id);
alter table recall_authority_report add constraint fk_recall_authority_report_file_id foreign key (file_id) references file_attachment (id);
alter table recall_authority_report add constraint fk_recall_authority_report_created_by foreign key (created_by) references app_user (id);
alter table recall_resolution add constraint fk_recall_resolution_recall_case_id foreign key (recall_case_id) references recall_case (id);
alter table recall_resolution add constraint fk_recall_resolution_customer_id foreign key (customer_id) references customer (id);
alter table recall_resolution add constraint fk_recall_resolution_sales_order_id foreign key (sales_order_id) references sales_order (id);
alter table recall_resolution add constraint fk_recall_resolution_voucher_id foreign key (voucher_id) references payment_voucher (id);
alter table recall_resolution add constraint fk_recall_resolution_approved_by foreign key (approved_by) references app_user (id);
alter table recall_resolution add constraint fk_recall_resolution_created_by foreign key (created_by) references app_user (id);
alter table capa add constraint fk_capa_recall_case_id foreign key (recall_case_id) references recall_case (id);
alter table capa add constraint fk_capa_ncr_id foreign key (ncr_id) references ncr (id);
alter table capa add constraint fk_capa_owner_id foreign key (owner_id) references app_user (id);
alter table capa add constraint fk_capa_supplier_return_id foreign key (supplier_return_id) references supplier_return (id);
alter table capa add constraint fk_capa_approved_by foreign key (approved_by) references app_user (id);
alter table capa add constraint fk_capa_created_by foreign key (created_by) references app_user (id);
alter table capa add constraint fk_capa_updated_by foreign key (updated_by) references app_user (id);


-- Ràng buộc nghiệp vụ ở mức CSDL (bổ sung cho phần DDL ở trên)
set search_path = mes;

-- 1. Không xóa cứng: mọi bảng nghiệp vụ chặn DELETE (chỉ khóa / ngừng dùng / hủy bằng trạng thái).
--    Ngoại lệ: sync_outbox (hàng đợi gửi lên ở máy chủ nhà máy, dọn sau 30 ngày kể từ khi cloud xác nhận — sửa 20/10 đợt 2; bỏ lot_status_replica).
--    Sửa 04/11: xóa được bản ghi CHƯA TỪNG DÙNG ở các bảng danh mục dưới — khóa ngoại (không cascade) chặn khi đã có dòng trỏ tới,
--    nên bản ghi đã dùng vẫn chỉ khóa / ngừng dùng. Tài khoản: thêm điều kiện chưa từng đăng nhập (mục 29a).
create or replace function forbid_delete() returns trigger language plpgsql as $$
begin
  if tg_table_name in ('app_user', 'uom', 'product_option', 'product_pack', 'product_pack_level', 'material_pack', 'material_pack_level', 'permission',
                       'legal_document', 'legal_document_scope')
     or (tg_table_name in ('user_role', 'user_permission') and current_setting('mes.deleting_user', true) = to_jsonb(old) ->> 'user_id') then
    return old;
  end if;
  raise exception 'Không xóa cứng bảng %: dùng trạng thái khóa / ngừng dùng / hủy', tg_table_name;
end $$;

do $$
declare r record;
begin
  for r in select table_name from information_schema.tables
           where table_schema = 'mes' and table_type = 'BASE TABLE' and table_name <> 'sync_outbox'
  loop
    execute format('create trigger trg_no_delete before delete on mes.%I for each row execute function mes.forbid_delete()', r.table_name);
  end loop;
end $$;

-- 2. Liên kết lô đúng loại: kiểm loại lô cha / con theo link_type (sửa 19/10 đợt 3: bỏ DO_VAO_ME, thêm NAP_SILO / XA_SILO qua nút silo).
create or replace function check_lot_link() returns trigger language plpgsql as $$
declare p text; c text; pg text;
begin
  select lot_kind into p from lot where id = new.parent_lot_id;
  select lot_kind into c from lot where id = new.child_lot_id;
  select m.material_group into pg from lot l join material m on m.id = l.material_id where l.id = new.parent_lot_id;
  if new.link_type = 'NAP_SILO' and not (p in ('NVL_MUA','HH') and c = 'SILO') then
    raise exception 'NAP_SILO: cha phải là lô NVL / HH, con phải là nút silo (đang là % → %)', p, c;
  elsif new.link_type = 'XA_SILO' and not (p = 'SILO' and c = 'ME') then
    raise exception 'XA_SILO: cha phải là nút silo, con phải là lô mẻ (đang là % → %)', p, c;
  elsif new.link_type = 'RA_ME' and not (p = 'ME' and c in ('HH','BTP','TP','HONG')) then
    raise exception 'RA_ME: cha phải là lô mẻ, con là lô HH / BTP / bột hỏng (đang là % → %)', p, c;
  elsif new.link_type = 'BAO_BI' and not (p = 'NVL_MUA' and pg = 'BAO_BI' and c in ('BTP','TP')) then
    raise exception 'BAO_BI: cha phải là lô bao bì, con là lô BTP / TP';
  elsif new.link_type = 'NVL_DU' and not ((p in ('NVL_MUA','HH') and c = p) or (p = 'SILO' and c in ('NVL_MUA','HH'))) then
    raise exception 'NVL_DU: lô dư phải cùng loại với lô gốc (hoặc là bột dư xả từ nút silo)';
  end if;
  return new;
end $$;
create trigger trg_lot_link_kind before insert or update on lot_link
  for each row execute function check_lot_link();

-- 3. Liên kết BẮT BUỘC: lô HH / BTP / bột hỏng (HONG) phải có liên kết "ra mẻ", lô NVL dư phải có liên kết về lô gốc
--    — kiểm lúc COMMIT (ràng buộc trễ), nên thao tác tạo lô mà không ghi được liên kết sẽ bị hủy cả giao dịch.
create or replace function require_lot_link() returns trigger language plpgsql as $$
begin
  if new.lot_kind in ('HH','BTP','HONG')
     and not exists (select 1 from lot_link where child_lot_id = new.id and link_type = 'RA_ME') then
    raise exception 'Lô % (%) chưa có liên kết ra mẻ — chặn thao tác', new.lot_no, new.lot_kind;
  end if;
  if new.source_lot_id is not null
     and not exists (select 1 from lot_link where child_lot_id = new.id and parent_lot_id = new.source_lot_id and link_type = 'NVL_DU') then
    raise exception 'Lô NVL dư % chưa có liên kết về lô gốc — chặn thao tác', new.lot_no;
  end if;
  return null;
end $$;
create constraint trigger trg_lot_require_link after insert on lot
  deferrable initially deferred for each row execute function require_lot_link();

-- 4. Phần lô KHÓA phải dùng đúng phạm vi: lô có khóa cả lô đang hiệu lực thì phần ĐẠT / CHỜ KIỂM mới không được thêm vào.
create or replace function check_whole_lot_lock() returns trigger language plpgsql as $$
begin
  if new.status in ('DAT','CHO_KIEM') and exists (select 1 from lot_lock where lot_id = new.lot_id and released_at is null) then
    raise exception 'Lô đang bị khóa cả lô — phần lô mới phải là KHÓA cùng lý do';
  end if;
  return new;
end $$;
create trigger trg_stock_line_whole_lock before insert or update of status on stock_line
  for each row execute function check_whole_lot_lock();

-- 5. Gán vai trò: vai trò admin_assign_only (Admin, Người truy xuất) chỉ người đang giữ vai trò Admin (hoặc tài khoản Hệ thống) gán được.
--    Không tự gán / tự gỡ vai trò của chính mình: check trên user_role (user_id <> created_by, revoked_by <> user_id).
create or replace function check_role_grant() returns trigger language plpgsql as $$
begin
  if (select admin_assign_only from role where id = new.role_id)
     and not exists (select 1 from app_user u where u.id = new.created_by and u.is_system)
     and not exists (select 1 from user_role ur join role r on r.id = ur.role_id
                     where ur.user_id = new.created_by and r.code = 'ADMIN' and ur.revoked_at is null
                       and (ur.valid_until is null or ur.valid_until > now())) then
    raise exception 'Chỉ Admin được gán vai trò %', (select name from role where id = new.role_id);
  end if;
  return new;
end $$;
create trigger trg_user_role_grant before insert on user_role
  for each row execute function check_role_grant();

-- 6. Ủy quyền tạm: chỉ vai trò delegable; dòng user_role tạm phải trùng người nhận, vai trò, hạn của phiếu ủy quyền.
create or replace function check_delegation() returns trigger language plpgsql as $$
declare d user_delegation%rowtype;
begin
  if tg_table_name = 'user_delegation' then
    if not (select delegable from role where id = new.role_id) then
      raise exception 'Vai trò % không ủy quyền tạm được', (select name from role where id = new.role_id);
    end if;
  elsif new.delegation_id is not null then
    select * into d from user_delegation where id = new.delegation_id;
    if new.user_id <> d.delegate_id or new.role_id <> d.role_id or new.valid_until <> d.ends_at then
      raise exception 'Dòng vai trò tạm không khớp phiếu ủy quyền';
    end if;
  end if;
  return new;
end $$;
create trigger trg_delegation_role before insert on user_delegation
  for each row execute function check_delegation();
create trigger trg_user_role_delegation before insert on user_role
  for each row execute function check_delegation();


-- 7. Ghi nhận thu / chi (sửa 19/10): tổng số tiền cấn vào các khoản không vượt số tiền ghi nhận; bản ghi đã hủy không cấn được.
create or replace function check_payment_allocation() returns trigger language plpgsql as $$
declare v payment_voucher%rowtype; total numeric;
begin
  select * into v from payment_voucher where id = new.voucher_id;
  if v.status <> 'DA_GHI_NHAN' then
    raise exception 'Bản ghi nhận % đã hủy — không cấn được', v.code;
  end if;
  select coalesce(sum(amount), 0) + new.amount into total from payment_allocation where voucher_id = new.voucher_id and id <> new.id;
  if total > v.amount then
    raise exception 'Cấn % vượt số tiền ghi nhận % của %', total, v.amount, v.code;
  end if;
  return new;
end $$;
create trigger trg_payment_allocation before insert or update on payment_allocation
  for each row execute function check_payment_allocation();

-- 8. (Bỏ 28/10 — không còn rà soát quyền hằng quý: bảng access_review, access_review_line và trigger xác nhận rà soát đã bỏ.)

-- 9. (Bỏ 24/10 đợt 9 — không còn vị trí kệ / ô: tồn theo lô × kho, bảng location và trigger ngừng dùng ô đã bỏ.)

-- ===== Bổ sung 19/10 (đợt 2, sửa đợt 3): khu vực làm việc & dàn silo, lệnh SX, nạp / xả silo, mua hàng / kho =====

-- 10. Khu vực làm việc: không đổi loại khu khi khu còn lệnh chưa hoàn thành (không xóa khu — đã chặn ở mục 1).
create or replace function check_work_area_type() returns trigger language plpgsql as $$
begin
  if new.area_type <> old.area_type
     and exists (select 1 from production_order where work_area_id = new.id and status not in ('HOAN_THANH','DA_HUY')) then
    raise exception 'Khu % còn lệnh chưa hoàn thành — không đổi loại khu được', new.code;
  end if;
  return new;
end $$;
create trigger trg_work_area_type before update of area_type on work_area
  for each row execute function check_work_area_type();

-- 11. Dàn silo: silo chỉ thuộc khu HH / BTP. Silo chuyển bảo trì / ngừng dùng → mọi lệnh MOI_TAO (chưa phát) đang xếp NVL vào silo đó
--     thành silo_plan_status = CAN_XEP_LAI (hiện trong Việc cần làm của Kế hoạch; chặn phát tới khi xếp lại — mục 12c).
--     Đợt 3: không chuyển bảo trì / ngừng dùng khi silo còn nút SILO đang mở (còn bột của lệnh — xả về kho điều phối / luồng sự cố trước).
create or replace function check_silo() returns trigger language plpgsql as $$
declare oc text;
begin
  if new.equipment_type = 'SILO' and (select area_type from work_area where id = new.work_area_id) not in ('HH','BTP') then
    raise exception 'Silo % phải thuộc khu HH / BTP', new.code;
  end if;
  if tg_op = 'UPDATE' and new.status in ('BAO_TRI','NGUNG_DUNG') and old.status = 'DANG_DUNG' then
    select po.code into oc from lot l join production_order po on po.id = l.production_order_id
     where l.lot_kind = 'SILO' and l.silo_equipment_id = new.id and l.silo_emptied_at is null limit 1;
    if oc is not null then
      raise exception 'Silo % còn bột của lệnh % — xả về kho điều phối (hoặc xử lý sự cố) trước khi chuyển bảo trì / ngừng dùng', new.code, oc;
    end if;
  end if;
  return new;
end $$;
create trigger trg_equipment_silo before insert or update on equipment
  for each row execute function check_silo();

create or replace function flag_silo_replan() returns trigger language plpgsql as $$
begin
  if new.equipment_type = 'SILO' and new.status in ('BAO_TRI','NGUNG_DUNG') and old.status = 'DANG_DUNG' then
    update production_order po set silo_plan_status = 'CAN_XEP_LAI', updated_at = now()
     where po.status = 'MOI_TAO'
       and exists (select 1 from production_order_silo s where s.production_order_id = po.id and s.silo_equipment_id = new.id);
  end if;
  return null;
end $$;
create trigger trg_equipment_silo_replan after update of status on equipment
  for each row execute function flag_silo_replan();

-- 12. Lệnh SX.
-- 12a. Kiểm phương án silo của 1 lệnh (null = hợp lệ): đủ mọi NVL của công thức, không thừa NVL; mọi silo đang hoạt động, đúng khu, đúng gán cứng, đủ sức chứa.
--      1 NVL – 1 silo và 1 silo – 1 NVL (unique) ⇒ số NVL của công thức ≤ số silo đang hoạt động của khu.
create or replace function silo_plan_problem(p_order uuid) returns text language plpgsql as $$
declare o production_order%rowtype; m text;
begin
  select * into o from production_order where id = p_order;
  select mt.code into m from formula_item fi join material mt on mt.id = fi.material_id
   where fi.formula_version_id = o.formula_version_id
     and not exists (select 1 from production_order_silo s where s.production_order_id = o.id and s.material_id = fi.material_id)
   order by fi.line_no limit 1;
  if m is not null then return format('NVL %s chưa xếp vào silo', m); end if;
  select mt.code into m from production_order_silo s join material mt on mt.id = s.material_id
   where s.production_order_id = o.id
     and not exists (select 1 from formula_item fi where fi.formula_version_id = o.formula_version_id and fi.material_id = s.material_id)
   limit 1;
  if m is not null then return format('NVL %s không có trong công thức', m); end if;
  select e.code into m from production_order_silo s join equipment e on e.id = s.silo_equipment_id
   where s.production_order_id = o.id
     and (e.status <> 'DANG_DUNG' or e.work_area_id is distinct from o.work_area_id
          or (e.hard_material_id is not null and e.hard_material_id <> s.material_id) or s.kg_per_batch > e.capacity_kg)
   limit 1;
  if m is not null then return format('silo %s không còn hợp lệ (bảo trì / ngừng dùng / sai khu / sai gán cứng / quá sức chứa)', m); end if;
  return null;
end $$;

-- 12b. Dòng phương án silo: silo của khu lệnh, đang hoạt động, đúng gán cứng, NVL có trong công thức, KL / mẻ ≤ sức chứa;
--      chỉ sửa khi lệnh Mới tạo (đợt 3: lệnh đã phát không sửa — hủy rồi tạo lại).
create or replace function check_order_silo_row() returns trigger language plpgsql as $$
declare o production_order%rowtype; e equipment%rowtype;
begin
  select * into o from production_order where id = new.production_order_id;
  select * into e from equipment where id = new.silo_equipment_id;
  if o.status <> 'MOI_TAO' then
    raise exception 'Lệnh % đã phát — không sửa phương án silo (hủy rồi tạo lại)', o.code;
  elsif e.equipment_type <> 'SILO' or e.work_area_id is distinct from o.work_area_id then
    raise exception 'Thiết bị % không phải silo của khu sản xuất của lệnh %', e.code, o.code;
  elsif e.status <> 'DANG_DUNG' then
    raise exception 'Silo % đang % — không xếp NVL vào được', e.code, e.status;
  elsif e.hard_material_id is not null and e.hard_material_id <> new.material_id then
    raise exception 'Silo % gán cứng NVL khác', e.code;
  elsif not exists (select 1 from formula_item where formula_version_id = o.formula_version_id and material_id = new.material_id) then
    raise exception 'NVL không có trong công thức của lệnh %', o.code;
  elsif new.kg_per_batch > e.capacity_kg then
    raise exception 'KL / mẻ % kg vượt sức chứa silo % (% kg)', new.kg_per_batch, e.code, e.capacity_kg;
  end if;
  return new;
end $$;
create trigger trg_order_silo_row before insert or update on production_order_silo
  for each row execute function check_order_silo_row();

-- 12c. Lệnh: loại lệnh = loại khu, cùng nhà máy, khu đang dùng, KL mẻ ≤ mức tối đa của khu; chuyển trạng thái đúng thứ tự (không nháp, không xóa).
--      Đợt 3: chỉ sửa lệnh MOI_TAO (lệnh đang chạy chỉ được cộng mẻ bù); phát (MOI_TAO → CHO_PHAT / DA_NHAN) kiểm lại phương án silo,
--      KL mẻ ≤ mức tối đa hiện tại, không có lệnh Mới tạo / Chờ phát nào đứng trước trong hàng đợi của khu; hủy lệnh đã phát cần nhà máy xác nhận;
--      hủy / kết thúc sớm → giải phóng giữ chỗ còn lại; HOÀN THÀNH chỉ khi mọi nút silo của lệnh đã xả sạch; kết thúc sớm khi không còn mẻ chạy dở.
create or replace function check_production_order() returns trigger language plpgsql as $$
declare w work_area%rowtype; prob text; ahead text;
  nxt constant jsonb := '{"MOI_TAO":["CHO_PHAT","DA_NHAN","DA_HUY"],"CHO_PHAT":["DA_NHAN","DA_HUY"],"DA_NHAN":["DANG_CHAY","DA_HUY"],"DANG_CHAY":["HOAN_THANH"]}';
begin
  select * into w from work_area where id = new.work_area_id;
  if tg_op = 'UPDATE' and old.status <> 'MOI_TAO'
     and (new.work_area_id, new.order_kind, new.formula_version_id, new.planned_batch_count, new.batch_weight_kg, new.planned_finish_date,
          new.sales_order_id, new.loss_pct, new.marketing_user_id, new.order_received_at)
         is distinct from
         (old.work_area_id, old.order_kind, old.formula_version_id, old.planned_batch_count, old.batch_weight_kg, old.planned_finish_date,
          old.sales_order_id, old.loss_pct, old.marketing_user_id, old.order_received_at) then
    raise exception 'Lệnh % đã phát — không sửa (hủy rồi tạo lại, hoặc kết thúc sớm khi đang chạy)', new.code;
  end if;
  if tg_op = 'INSERT' or new.work_area_id <> old.work_area_id or new.order_kind <> old.order_kind or new.batch_weight_kg <> old.batch_weight_kg then
    if w.area_type <> new.order_kind then
      raise exception 'Lệnh % loại % nhưng khu % là khu % — loại lệnh theo khu', new.code, new.order_kind, w.code, w.area_type;
    elsif w.factory_id <> new.factory_id then
      raise exception 'Khu % thuộc nhà máy khác với lệnh %', w.code, new.code;
    elsif w.status <> 'DANG_DUNG' and (tg_op = 'INSERT' or new.work_area_id <> old.work_area_id) then
      raise exception 'Khu % đã ngừng dùng', w.code;
    elsif new.batch_weight_kg > w.max_batch_kg then
      raise exception 'KL mẻ % kg vượt mức tối đa % kg của khu %', new.batch_weight_kg, w.max_batch_kg, w.code;
    end if;
  end if;
  if tg_op = 'UPDATE' and new.status <> old.status then
    if not coalesce(nxt -> old.status, '[]'::jsonb) ? new.status then
      raise exception 'Lệnh %: không chuyển % → % được', new.code, old.status, new.status;
    end if;
    if old.status = 'MOI_TAO' and new.status in ('CHO_PHAT','DA_NHAN') then
      if new.silo_plan_status <> 'DA_CHOT' then
        raise exception 'Lệnh %: phương án silo cần xếp lại (silo bảo trì / ngừng dùng) — chặn phát', new.code;
      end if;
      prob := silo_plan_problem(new.id);
      if prob is not null then raise exception 'Lệnh %: % — chặn phát', new.code, prob; end if;
      if old.status = 'MOI_TAO' then
        if new.batch_weight_kg > w.max_batch_kg then
          raise exception 'Lệnh %: KL mẻ % kg vượt mức tối đa hiện tại % kg của khu % — sửa lệnh trước khi phát', new.code, new.batch_weight_kg, w.max_batch_kg, w.code;
        end if;
        select code into ahead from production_order
         where work_area_id = new.work_area_id and id <> new.id and status in ('MOI_TAO','CHO_PHAT') and queue_priority < old.queue_priority
         order by queue_priority limit 1;
        if ahead is not null then
          raise exception 'Lệnh % không ở đầu hàng đợi của khu % — lệnh % đứng trước (Mới tạo / Chờ phát)', new.code, w.code, ahead;
        end if;
      end if;
    end if;
    if new.status = 'DA_HUY' and old.status in ('CHO_PHAT','DA_NHAN') and new.nm_cancel_confirmed_at is null then
      raise exception 'Lệnh % đã phát — chờ nhà máy xác nhận chưa chạy mẻ mới hủy được', new.code;
    end if;
    if new.status = 'HOAN_THANH' then
      if exists (select 1 from lot where lot_kind = 'SILO' and production_order_id = new.id and silo_emptied_at is null) then
        raise exception 'Lệnh %: còn silo chưa xả sạch — xả bột dư về kho điều phối trước khi hoàn thành', new.code;
      end if;
      if new.ended_early_at is not null
         and exists (select 1 from production_batch where production_order_id = new.id and status in ('DANG_CHAY','DUNG_SU_CO')) then
        raise exception 'Lệnh %: còn mẻ đang chạy dở — chạy xong (hoặc hủy mẻ) rồi mới kết thúc sớm', new.code;
      end if;
    end if;
    if new.status = 'DA_HUY' or new.ended_early_at is not null then
      update material_reservation set released_kg = reserved_kg - issued_kg, status = 'DA_GIAI_PHONG'
       where production_order_id = new.id and status = 'MO';
    end if;
  end if;
  if tg_op = 'UPDATE' and new.silo_plan_status = 'DA_CHOT' and old.silo_plan_status = 'CAN_XEP_LAI' then
    prob := silo_plan_problem(new.id);
    if prob is not null then raise exception 'Lệnh %: % — chưa xếp lại xong', new.code, prob; end if;
  end if;
  return new;
end $$;
create trigger trg_production_order before insert or update on production_order
  for each row execute function check_production_order();

-- 12d. Phương án silo chốt khi tạo lệnh: lệnh tạo ở MOI_TAO phải có phương án đủ, hợp lệ lúc COMMIT (ràng buộc trễ).
create or replace function require_silo_plan() returns trigger language plpgsql as $$
declare prob text;
begin
  if new.status = 'MOI_TAO' then
    prob := silo_plan_problem(new.id);
    if prob is not null then
      raise exception 'Lệnh %: % — phương án silo phải chốt khi tạo lệnh', new.code, prob;
    end if;
  end if;
  return null;
end $$;
create constraint trigger trg_production_order_silo_plan after insert on production_order
  deferrable initially deferred for each row execute function require_silo_plan();

-- 12e. Hàng đợi phát lệnh = thứ tự chạy ở nhà máy: thứ tự không trùng trong 1 khu giữa các lệnh Mới tạo / Chờ phát (Chờ phát giữ vị trí);
--      kiểm lúc COMMIT để đổi thứ tự được trong 1 giao dịch.
alter table production_order add constraint ex_production_order_queue
  exclude using btree (work_area_id with =, queue_priority with =) where (status in ('MOI_TAO','CHO_PHAT')) deferrable initially deferred;

-- 12f. Kế hoạch nhãn hiệu: chỉ lệnh BTP, SP dùng đúng công thức của lệnh, chỉ sửa khi lệnh Mới tạo (đợt 3).
create or replace function check_order_brand() returns trigger language plpgsql as $$
declare o production_order%rowtype;
begin
  select * into o from production_order where id = new.production_order_id;
  if o.order_kind <> 'BTP' then
    raise exception 'Lệnh % là lệnh HH — không có kế hoạch nhãn hiệu', o.code;
  elsif o.status <> 'MOI_TAO' then
    raise exception 'Lệnh % đã phát — không sửa kế hoạch nhãn hiệu (hủy rồi tạo lại)', o.code;
  elsif (select formula_id from product where id = new.product_id)
        is distinct from (select formula_id from formula_version where id = o.formula_version_id) then
    raise exception 'SP không dùng công thức của lệnh % — chỉ lấy các dòng đơn cùng công thức', o.code;
  end if;
  return new;
end $$;
create trigger trg_order_brand before insert or update on production_order_brand
  for each row execute function check_order_brand();

-- 12g. Quét bao nạp silo (silo_charge, đợt 3): silo phải là silo xếp cho NVL của bao trong phương án của lệnh; nút silo (nếu có) đúng lệnh, đúng silo.
create or replace function check_scan_silo() returns trigger language plpgsql as $$
declare s uuid; n lot%rowtype;
begin
  select pos.silo_equipment_id into s
    from lot l join production_order_silo pos on pos.production_order_id = new.production_order_id and pos.material_id = l.material_id
   where l.id = new.lot_id;
  if s is distinct from new.silo_equipment_id then
    raise exception 'Bao nạp sai silo — phương án silo của lệnh xếp NVL này vào silo khác (hoặc chưa xếp)';
  end if;
  if new.silo_lot_id is not null then
    select * into n from lot where id = new.silo_lot_id;
    if n.lot_kind <> 'SILO' or n.production_order_id <> new.production_order_id or n.silo_equipment_id <> new.silo_equipment_id then
      raise exception 'Nút silo không khớp lệnh / silo của lần nạp';
    end if;
  end if;
  return new;
end $$;
create trigger trg_scan_silo before insert or update on silo_charge
  for each row execute function check_scan_silo();

-- 12h. Nạp / xả qua nút silo (đợt 3, truy xuất cách B): nút đang mở; nạp: lô đúng NVL của nút, silo của phương án, silo đang hoạt động,
--      lệnh Đã nhận / Đang chạy, bột trong nút + nạp ≤ sức chứa; xả cho mẻ: mẻ của đúng lệnh, ≤ bột đang có; bột dư: ≤ bột đang có.
create or replace function silo_content(p_silo_lot uuid) returns numeric language sql stable as $$
  select coalesce(sum(case when child_lot_id = p_silo_lot then qty else -qty end), 0)
    from lot_link
   where (child_lot_id = p_silo_lot and link_type = 'NAP_SILO')
      or (parent_lot_id = p_silo_lot and link_type in ('XA_SILO','NVL_DU'))
$$;
create or replace function check_silo_link() returns trigger language plpgsql as $$
declare n lot%rowtype; e equipment%rowtype; o production_order%rowtype; m uuid; cur numeric;
begin
  if new.link_type = 'NAP_SILO' then
    select * into n from lot where id = new.child_lot_id;
  elsif new.link_type in ('XA_SILO','NVL_DU') and (select lot_kind from lot where id = new.parent_lot_id) = 'SILO' then
    select * into n from lot where id = new.parent_lot_id;
  else
    return new;
  end if;
  select * into e from equipment where id = n.silo_equipment_id;
  select * into o from production_order where id = n.production_order_id;
  if n.silo_emptied_at is not null then
    raise exception 'Nút silo % đã đóng (silo đã xả sạch) — lần nạp mới phải mở nút mới', n.lot_no;
  end if;
  cur := silo_content(n.id);
  if new.link_type = 'NAP_SILO' then
    select material_id into m from lot where id = new.parent_lot_id;
    if m is distinct from n.material_id then
      raise exception 'Nạp sai NVL vào silo % (nút silo của NVL khác)', e.code;
    elsif not exists (select 1 from production_order_silo where production_order_id = o.id and material_id = m and silo_equipment_id = e.id) then
      raise exception 'Silo % không phải silo xếp cho NVL này trong phương án của lệnh %', e.code, o.code;
    elsif e.status <> 'DANG_DUNG' then
      raise exception 'Silo % đang % — không nạp được', e.code, e.status;
    elsif o.status not in ('DA_NHAN','DANG_CHAY') then
      raise exception 'Lệnh % không ở Đã nhận / Đang chạy — không nạp silo', o.code;
    elsif cur + new.qty > e.capacity_kg then
      raise exception 'Nạp % kg: bột trong silo % (% kg) + bao vượt sức chứa % kg', new.qty, e.code, cur, e.capacity_kg;
    end if;
  else
    if new.qty > cur then
      raise exception 'Xả % kg vượt bột đang có trong silo % (% kg)', new.qty, e.code, cur;
    end if;
    if new.link_type = 'XA_SILO'
       and (select production_order_id from production_batch where id = new.production_batch_id) is distinct from o.id then
      raise exception 'Silo % chỉ xả cho mẻ của lệnh %', e.code, o.code;
    end if;
  end if;
  return new;
end $$;
create trigger trg_silo_link before insert or update on lot_link
  for each row execute function check_silo_link();

-- 12i. Đóng nút silo (silo xả sạch giữa lệnh hoặc cuối lệnh): chỉ khi bột trong nút = 0.
create or replace function check_silo_close() returns trigger language plpgsql as $$
begin
  if new.lot_kind = 'SILO' and new.silo_emptied_at is not null and old.silo_emptied_at is null and silo_content(new.id) <> 0 then
    raise exception 'Silo còn % kg trong nút % — xả hết (cho mẻ / bột dư về kho điều phối) rồi mới xác nhận xả sạch', silo_content(new.id), new.lot_no;
  end if;
  return new;
end $$;
create trigger trg_silo_close before update of silo_emptied_at on lot
  for each row execute function check_silo_close();

-- 12j. Tạo mẻ (Start trên PC xưởng): chặn khi silo trong phương án của lệnh không hoạt động (bảo trì / ngừng dùng).
create or replace function check_batch_start() returns trigger language plpgsql as $$
declare sc text;
begin
  select e.code into sc from production_order_silo s join equipment e on e.id = s.silo_equipment_id
   where s.production_order_id = new.production_order_id and e.status <> 'DANG_DUNG' limit 1;
  if sc is not null then
    raise exception 'Silo % của lệnh đang bảo trì / ngừng dùng — chặn mẻ mới (chờ bảo trì xong, hoặc Kế hoạch hủy / kết thúc sớm lệnh)', sc;
  end if;
  return new;
end $$;
create trigger trg_batch_start before insert on production_batch
  for each row execute function check_batch_start();

-- 13. (Sửa 04/11 — bỏ báo giá: bảng quotation, quotation_line và trigger báo giá đã bỏ.) PO kiểm COA & HSD (30/10, 31/10):
--     sang CHO_CHON_THANH_TOAN chỉ từ CHO_COA_HSD, khi đã gửi yêu cầu COA, mọi dòng có COA đạt (coa_passed, có NSX / HSD) và đủ kết quả
--     cho mọi chỉ tiêu COA đang dùng của NVL; sang CHO_DUYET chỉ từ CHO_CHON_THANH_TOAN và đã chọn hình thức thanh toán.
create or replace function check_purchase_order_coa() returns trigger language plpgsql as $$
begin
  if tg_op = 'INSERT' and new.status <> 'CHO_COA_HSD' then
    raise exception 'PO % lập ra ở Chờ COA & HSD', new.code;
  end if;
  if tg_op = 'UPDATE' and new.status <> old.status then
    if new.status = 'CHO_CHON_THANH_TOAN' then
      if old.status <> 'CHO_COA_HSD' or new.coa_requested_at is null or new.coa_result is distinct from 'DAT' then
        raise exception 'PO %: chỉ sang Chờ chọn thanh toán sau khi gửi yêu cầu COA và kiểm COA & HSD đạt', new.code;
      elsif exists (select 1 from purchase_order_line l where l.po_id = new.id
                      and (l.coa_passed is not true or l.coa_mfg_date is null or l.coa_exp_date is null
                           or exists (select 1 from material_spec_item i where i.material_id = l.material_id and i.status = 'DANG_DUNG' and i.used_for_coa
                                        and not exists (select 1 from purchase_order_coa_result r where r.po_line_id = l.id and r.spec_item_id = i.id)))) then
        raise exception 'PO %: còn NVL chưa có COA / NSX / HSD đạt hoặc thiếu kết quả chỉ tiêu COA', new.code;
      end if;
    elsif new.status = 'CHO_DUYET' and (old.status <> 'CHO_CHON_THANH_TOAN' or new.payment_chosen_at is null) then
      raise exception 'PO %: chọn hình thức thanh toán (Chờ chọn thanh toán) trước khi gửi duyệt', new.code;
    end if;
  end if;
  return new;
end $$;
create trigger trg_purchase_order_coa before insert or update of status on purchase_order
  for each row execute function check_purchase_order_coa();

-- 14. Trả hàng NCC: PO trả trước / cọc + trả nốt trước giao không chọn giảm công nợ; Đã xuất trả chỉ khi phiếu xuất TRA_NCC đã xuất.
--     Sửa 04/11: trạng thái theo mockup — từ chối yêu cầu xuất trả về NCC_CHAP_NHAN (thay MO); xong = HOAN_TAT, nhà máy chịu = CHUYEN_HUY.
--     24/10 đợt 6: yêu cầu xuất trả qua Trưởng BP Mua hàng duyệt — CHO_DUYET_XUAT_TRA → CHO_KHO_XUAT_TRA (người duyệt giữ vai trò
--     TRUONG_BP_MUA_HANG, không phải người gửi) hoặc → MO kèm lý do từ chối; vào CHO_KHO_XUAT_TRA chỉ từ CHO_DUYET_XUAT_TRA.
--     Dòng trả (đợt 3): SL theo ĐVT gốc của NVL; dòng có lô: tổng trả theo NVL của mọi phiếu trả cùng PO (kể cả phiếu nhà máy chịu) ≤ SL đã nhận,
--     và SL trả của lô (cộng các phiếu chưa xuất xong) ≤ tồn hiện có của lô. Dòng không lô (từ chối ở cửa kho) không tính vào số đã nhận.
create or replace function check_supplier_return() returns trigger language plpgsql as $$
declare gs text;
begin
  if new.resolution = 'GIAM_CONG_NO'
     and (select payment_terms from purchase_order where id = new.purchase_order_id) in ('TRA_TRUOC', 'COC_TRA_NOT') then
    raise exception 'PO % trả trước — không chọn giảm công nợ được (chỉ đổi 1-1)', (select code from purchase_order where id = new.purchase_order_id);
  end if;
  if new.status = 'CHO_KHO_XUAT_TRA' and (tg_op = 'INSERT' or old.status <> 'CHO_KHO_XUAT_TRA') then
    if tg_op = 'INSERT' or old.status <> 'CHO_DUYET_XUAT_TRA' then
      raise exception 'Phiếu trả %: chỉ yêu cầu xuất trả đang Chờ duyệt mới sang Chờ kho xuất trả', new.code;
    elsif not exists (select 1 from user_role ur join role r on r.id = ur.role_id
                      where ur.user_id = new.export_approved_by and r.code = 'TRUONG_BP_MUA_HANG' and ur.revoked_at is null
                        and ur.valid_from <= now() and (ur.valid_until is null or ur.valid_until > now())) then
      raise exception 'Phiếu trả %: chỉ Trưởng BP Mua hàng duyệt yêu cầu xuất trả', new.code;
    end if;
  end if;
  if tg_op = 'UPDATE' and old.status = 'CHO_DUYET_XUAT_TRA' and new.status = 'NCC_CHAP_NHAN' and new.export_reject_reason is null then
    raise exception 'Phiếu trả %: từ chối yêu cầu xuất trả phải ghi lý do', new.code;
  end if;
  if new.status = 'DA_XUAT_TRA' and (tg_op = 'INSERT' or old.status <> 'DA_XUAT_TRA') then
    select status into gs from goods_issue where id = new.goods_issue_id;
    if gs is null or gs not in ('DA_XUAT','XUAT_MOT_PHAN') then
      raise exception 'Phiếu xuất trả NCC chưa xuất — chưa cập nhật Đã xuất trả được';
    end if;
  end if;
  return new;
end $$;
create trigger trg_supplier_return before insert or update on supplier_return
  for each row execute function check_supplier_return();

create or replace function check_supplier_return_qty() returns trigger language plpgsql as $$
declare po uuid; got numeric; ret numeric; base text; ton numeric; dang numeric;
begin
  select uom_code into base from material where id = new.material_id;
  if new.uom_code <> base then
    raise exception 'SL trả phải theo ĐVT gốc của NVL (%), không phải %', base, new.uom_code;
  end if;
  if new.lot_id is not null then
    select purchase_order_id into po from supplier_return where id = new.return_id;
    select coalesce(sum(received_qty), 0) into got from purchase_order_line where po_id = po and material_id = new.material_id;
    select coalesce(sum(l.qty), 0) + new.qty into ret
      from supplier_return_line l join supplier_return r on r.id = l.return_id
     where r.purchase_order_id = po and l.material_id = new.material_id and l.lot_id is not null and l.id <> new.id;
    if ret > got then
      raise exception 'Trả % vượt SL đã nhận % của PO (đã cộng các phiếu trả khác)', ret, got;
    end if;
    select coalesce(sum(qty), 0) into ton from stock_line where lot_id = new.lot_id and status <> 'HUY';
    select coalesce(sum(l.qty), 0) + new.qty into dang
      from supplier_return_line l join supplier_return r on r.id = l.return_id
     where l.lot_id = new.lot_id and l.id <> new.id and r.status not in ('DA_XUAT_TRA','CHO_KY_XAC_NHAN','HOAN_TAT','CHUYEN_HUY');
    if dang > ton then
      raise exception 'Trả % vượt tồn hiện có % của lô (đã cộng các phiếu trả chưa xuất)', dang, ton;
    end if;
  end if;
  return new;
end $$;
create trigger trg_supplier_return_qty before insert or update on supplier_return_line
  for each row execute function check_supplier_return_qty();

-- 15. Phiếu xuất: TRA_NCC chỉ lập khi phiếu trả NCC đang CHO_KHO_XUAT_TRA; CHO_BEN_YEU_CAU chỉ từ DANG_LAY_HANG (đang lấy hàng),
--     và chỉ bên yêu cầu (requested_by) chọn nhận phần đã lấy (→ XUAT_MOT_PHAN) hoặc hủy (→ DA_HUY).
--     Đợt 4: SAN_XUAT chỉ lập từ kho loại DIEU_PHOI (không xuất SX thẳng từ kho tổng).
--     24/10 đợt 5 + 6: không duyệt phiếu xuất (bỏ CHO_DUYET / TU_CHOI, bỏ người duyệt). Đợt 7: lập ra ở CHO_LAY_HANG (thay tên DA_DUYET);
--     quét bao đầu tiên → DANG_LAY_HANG (trigger trên goods_issue_scan); CHO_BEN_YEU_CAU / DA_XUAT chỉ từ DANG_LAY_HANG.
create or replace function check_goods_issue() returns trigger language plpgsql as $$
begin
  if new.issue_type = 'SAN_XUAT' and (tg_op = 'INSERT' or (new.issue_type, new.warehouse_id) is distinct from (old.issue_type, old.warehouse_id))
     and (select warehouse_type from warehouse where id = new.warehouse_id) <> 'DIEU_PHOI' then
    raise exception 'Phiếu xuất SX chỉ lập từ kho điều phối (NVL đi kho tổng → chuyển kho → kho điều phối)';
  end if;
  -- 24/10 đợt 6 + 7: mọi phiếu xuất lập ra là Chờ lấy hàng — không ai duyệt phiếu xuất (duyệt ở chứng từ gốc)
  if tg_op = 'INSERT' and new.status <> 'CHO_LAY_HANG' then
    raise exception 'Phiếu xuất lập ra phải ở Chờ lấy hàng (không qua duyệt — duyệt ở chứng từ gốc)';
  end if;
  if tg_op = 'INSERT' and new.issue_type = 'TRA_NCC'
     and (select status from supplier_return where id = new.supplier_return_id) is distinct from 'CHO_KHO_XUAT_TRA' then
    raise exception 'Yêu cầu xuất trả NCC chưa gửi hoặc chưa được Trưởng BP Mua hàng duyệt (chưa Chờ kho xuất trả) — kho chưa lập phiếu xuất được';
  end if;
  if tg_op = 'UPDATE' and new.status <> old.status then
    if new.status = 'DANG_LAY_HANG' and old.status <> 'CHO_LAY_HANG' then
      raise exception 'Phiếu %: chỉ phiếu Chờ lấy hàng mới sang Đang lấy hàng', new.code;
    end if;
    if new.status = 'CHO_BEN_YEU_CAU' and new.issue_type = 'SAN_XUAT' then
      raise exception 'Phiếu xuất SX %: không qua Chờ bên yêu cầu — thiếu thì Xuất một phần, phần thiếu thành đề nghị chuyển kho (24/10 đợt 10)', new.code;
    end if;
    if new.status in ('CHO_BEN_YEU_CAU','DA_XUAT') and old.status <> 'DANG_LAY_HANG' then
      raise exception 'Phiếu %: chỉ phiếu Đang lấy hàng mới sang % (chưa quét bao nào)', new.code, new.status;
    end if;
    if new.status = 'XUAT_MOT_PHAN' and old.status not in ('DANG_LAY_HANG','CHO_BEN_YEU_CAU') then
      raise exception 'Phiếu %: chỉ phiếu đang lấy hàng / chờ bên yêu cầu mới Xuất một phần', new.code;
    end if;
    if old.status = 'CHO_BEN_YEU_CAU' then
      if new.status not in ('XUAT_MOT_PHAN','DA_HUY') then
        raise exception 'Phiếu % chờ bên yêu cầu: chỉ nhận phần đã lấy (Xuất một phần) hoặc hủy', new.code;
      elsif new.requester_decision_by is distinct from new.requested_by then
        raise exception 'Phiếu %: chỉ bên yêu cầu được chọn nhận phần đã lấy / hủy', new.code;
      end if;
    end if;
  end if;
  return new;
end $$;
create trigger trg_goods_issue before insert or update on goods_issue
  for each row execute function check_goods_issue();

-- ===== Bổ sung 19/10 (đợt 4), sửa 04/11: danh mục SP, phiếu chuyển tự lập từ lệnh SX, xuất SX chỉ từ kho điều phối =====

-- 16. Danh mục SP (mô hình mới chốt 04/11 — bỏ thương hiệu / dòng / hạng / quy cách dùng chung và các trigger 16a–16d cũ).
-- 16a'. Bản công bố: hình thức công bố là lựa chọn loại HINH_THUC_CONG_BO đang dùng (05/11).
create or replace function check_product_document_option() returns trigger language plpgsql as $$
begin
  if new.declaration_option_id is not null and (tg_op = 'INSERT' or new.declaration_option_id is distinct from old.declaration_option_id)
     and not exists (select 1 from product_option where id = new.declaration_option_id and option_kind = 'HINH_THUC_CONG_BO' and status = 'DANG_DUNG') then
    raise exception 'Hình thức công bố không đúng loại hoặc đã ngừng dùng';
  end if;
  return new;
end $$;
create trigger trg_product_document_option before insert or update on product_document
  for each row execute function check_product_document_option();
-- 16a. SP: ô Cấu trúc / Nhóm / Phân loại / Độ tuổi phải là lựa chọn đúng loại, đang dùng (khi tạo / đổi).
create or replace function check_product_options() returns trigger language plpgsql as $$
declare k text; v uuid;
begin
  foreach k in array array['CAU_TRUC', 'NHOM', 'PHAN_LOAI', 'DO_TUOI'] loop
    v := case k when 'CAU_TRUC' then new.structure_option_id when 'NHOM' then new.group_option_id
                when 'PHAN_LOAI' then new.class_option_id else new.age_option_id end;
    if v is not null and (tg_op = 'INSERT' or v is distinct from case k when 'CAU_TRUC' then old.structure_option_id
           when 'NHOM' then old.group_option_id when 'PHAN_LOAI' then old.class_option_id else old.age_option_id end)
       and not exists (select 1 from product_option where id = v and option_kind = k and status = 'DANG_DUNG') then
      raise exception 'SP %: lựa chọn % không đúng loại hoặc đã ngừng dùng', new.code, k;
    end if;
  end loop;
  return new;
end $$;
create trigger trg_product_options before insert or update on product
  for each row execute function check_product_options();

-- 16b. Mẫu nhãn: QC trưởng duyệt / từ chối (giữ vai trò QC_TRUONG); bản đã duyệt / từ chối không đổi lại trạng thái.
create or replace function check_product_label() returns trigger language plpgsql as $$
begin
  if new.status <> 'CHO_DUYET' and (tg_op = 'INSERT' or old.status = 'CHO_DUYET') then
    if not exists (select 1 from user_role ur join role r on r.id = ur.role_id
                   where ur.user_id = new.approved_by and r.code = 'QC_TRUONG' and ur.revoked_at is null
                     and ur.valid_from <= now() and (ur.valid_until is null or ur.valid_until > now())) then
      raise exception 'Mẫu nhãn v%: chỉ QC trưởng duyệt / từ chối', new.version_no;
    end if;
  elsif tg_op = 'UPDATE' and old.status <> 'CHO_DUYET' and new.status <> old.status then
    raise exception 'Mẫu nhãn v% đã %: tải bản mới thay vì đổi trạng thái', new.version_no, old.status;
  end if;
  return new;
end $$;
create trigger trg_product_label before insert or update on product_label
  for each row execute function check_product_label();

-- 16c. Lệnh BTP (điều kiện thêm 04/11): mỗi dòng nhãn hiệu chọn quy cách của đúng SP; SP có bản công bố đang dùng, còn hạn;
--      quy cách có mẫu nhãn hiện hành (chưa bị thay) đã duyệt. Kiểm khi thêm / đổi dòng (lệnh chỉ sửa khi Mới tạo — 12f).
create or replace function check_production_order_brand_docs() returns trigger language plpgsql as $$
begin
  if (select product_id from product_pack where id = new.product_pack_id) is distinct from new.product_id then
    raise exception 'Kế hoạch nhãn hiệu: quy cách không thuộc SP của dòng';
  elsif not exists (select 1 from product_document where product_id = new.product_id and doc_kind = 'CONG_BO'
                      and status = 'DANG_DUNG' and (exp_date is null or exp_date >= current_date)) then
    raise exception 'SP % chưa có bản công bố còn hiệu lực — chưa tạo lệnh BTP được', (select code from product where id = new.product_id);
  elsif not exists (select 1 from product_label where product_pack_id = new.product_pack_id and superseded_at is null and status = 'DA_DUYET') then
    raise exception 'SP %: quy cách chưa có mẫu nhãn đã duyệt — chưa tạo lệnh BTP được', (select code from product where id = new.product_id);
  end if;
  return new;
end $$;
create trigger trg_production_order_brand_docs before insert or update of product_id, product_pack_id on production_order_brand
  for each row execute function check_production_order_brand_docs();

-- 16d. NVL mua (không phải HON_HOP) ĐANG DÙNG phải có ít nhất 1 chỉ tiêu COA đang dùng (04/11) — kiểm lúc COMMIT để tạo NVL + chỉ tiêu trong 1 giao dịch;
--      ngừng / sửa chỉ tiêu cuối cùng cũng bị chặn.
create or replace function check_material_coa_spec() returns trigger language plpgsql as $$
declare mid uuid := (to_jsonb(new) ->> case when tg_table_name = 'material' then 'id' else 'material_id' end)::uuid;
begin
  if exists (select 1 from material m where m.id = mid and m.status = 'DANG_DUNG' and m.material_group <> 'HON_HOP'
               and not exists (select 1 from material_spec_item i where i.material_id = m.id and i.status = 'DANG_DUNG' and i.used_for_coa)) then
    raise exception 'NVL %: cần ít nhất 1 chỉ tiêu COA đang dùng', (select code from material where id = mid);
  end if;
  return null;
end $$;
create constraint trigger trg_material_coa_spec after insert or update on material
  deferrable initially deferred for each row execute function check_material_coa_spec();
create constraint trigger trg_material_coa_spec after update on material_spec_item
  deferrable initially deferred for each row execute function check_material_coa_spec();

-- 16e. Khu HH / BTP: kho điều phối cấp NVL phải là kho DIEU_PHOI đang dùng, cùng nhà máy (04/11 — một nhà máy nhiều kho điều phối).
create or replace function check_work_area_supply() returns trigger language plpgsql as $$
begin
  if new.supply_warehouse_id is not null and not exists (
       select 1 from warehouse where id = new.supply_warehouse_id and warehouse_type = 'DIEU_PHOI'
         and status = 'DANG_DUNG' and factory_id = new.factory_id) then
    raise exception 'Khu %: kho cấp NVL phải là kho điều phối đang dùng của cùng nhà máy', new.code;
  end if;
  return new;
end $$;
create trigger trg_work_area_supply before insert or update of supply_warehouse_id, factory_id on work_area
  for each row execute function check_work_area_supply();

-- 17. Phiếu chuyển (sửa 04/11 — chốt 30/10): lập phiếu là chấp nhận; bỏ Đề nghị / Chờ xác nhận / Từ chối và người gửi / người xác nhận.
-- 17a. Phiếu tự lập từ lệnh SX: lệnh nguồn còn mở (khi lập), từ kho TONG sang kho điều phối cấp NVL của khu của lệnh, cùng nhà máy.
--      Mọi phiếu lập ra ở CHO_XUAT, không quay về CHO_XUAT; DANG_CHUYEN (đã quét xuất) chỉ khi mọi dòng đã có lô.
create or replace function check_stock_transfer() returns trigger language plpgsql as $$
declare o production_order%rowtype;
begin
  if tg_op = 'INSERT' and new.status <> 'CHO_XUAT' then
    raise exception 'Phiếu chuyển % lập ra ở Chờ xuất (lập phiếu là chấp nhận)', new.code;
  end if;
  if new.auto_drafted and (tg_op = 'INSERT' or (new.source_order_id, new.from_warehouse_id, new.to_warehouse_id)
                           is distinct from (old.source_order_id, old.from_warehouse_id, old.to_warehouse_id)) then
    select * into o from production_order where id = new.source_order_id;
    if tg_op = 'INSERT' and o.status in ('DA_HUY','HOAN_THANH') then
      raise exception 'Lệnh % đã % — không lập phiếu chuyển tự động', o.code, o.status;
    elsif (select warehouse_type from warehouse where id = new.from_warehouse_id) <> 'TONG'
       or new.to_warehouse_id is distinct from (select supply_warehouse_id from work_area where id = o.work_area_id) then
      raise exception 'Phiếu chuyển tự lập chỉ từ kho tổng sang kho điều phối cấp NVL của khu lệnh %', o.code;
    elsif (select factory_id from warehouse where id = new.from_warehouse_id) <> o.factory_id
       or new.factory_id <> o.factory_id or new.to_factory_id <> o.factory_id then
      raise exception 'Phiếu chuyển tự lập phải cùng nhà máy với lệnh %', o.code;
    end if;
  end if;
  if tg_op = 'UPDATE' and new.status <> old.status then
    if new.status = 'CHO_XUAT' then
      raise exception 'Phiếu chuyển % không quay về Chờ xuất', new.code;
    elsif new.status = 'DANG_CHUYEN' and exists (select 1 from stock_transfer_line where transfer_id = new.id and lot_id is null) then
      raise exception 'Phiếu chuyển %: còn dòng chưa gán lô — gán lô (FEFO) trước khi xuất', new.code;
    end if;
  end if;
  return new;
end $$;
create trigger trg_stock_transfer before insert or update on stock_transfer
  for each row execute function check_stock_transfer();

-- 17b. Dòng chuyển: lô đúng NVL / SP của dòng; từ lúc xuất (DANG_CHUYEN trở đi) dòng phải có lô;
--      yêu cầu chuyển gom vào dòng phải cùng kho xuất → kho nhận với phiếu và đang chờ lập phiếu (hoặc đã trên chính phiếu này).
create or replace function check_stock_transfer_line() returns trigger language plpgsql as $$
declare t stock_transfer%rowtype; r transfer_request%rowtype;
begin
  select * into t from stock_transfer where id = new.transfer_id;
  if new.lot_id is not null and new.material_id is not null
     and (select material_id from lot where id = new.lot_id) is distinct from new.material_id then
    raise exception 'Dòng chuyển %: lô không đúng NVL của dòng', new.line_no;
  elsif new.lot_id is not null and new.product_id is not null
     and (select product_id from lot where id = new.lot_id) is distinct from new.product_id then
    raise exception 'Dòng chuyển %: lô không đúng SP của dòng', new.line_no;
  elsif new.lot_id is null and t.status not in ('CHO_XUAT','DA_HUY') then
    raise exception 'Dòng chuyển %: phiếu đã xuất — dòng phải có lô', new.line_no;
  end if;
  if new.transfer_request_id is not null and (tg_op = 'INSERT' or new.transfer_request_id is distinct from old.transfer_request_id) then
    select * into r from transfer_request where id = new.transfer_request_id;
    if (r.from_warehouse_id, r.to_warehouse_id) is distinct from (t.from_warehouse_id, t.to_warehouse_id) then
      raise exception 'Yêu cầu % khác kho xuất / kho nhận của phiếu %', r.code, t.code;
    elsif r.status <> 'CHO_LAP_PHIEU' and r.stock_transfer_id is distinct from t.id then
      raise exception 'Yêu cầu % đang % — không gom vào phiếu', r.code, r.status;
    end if;
  end if;
  return new;
end $$;
create trigger trg_stock_transfer_line before insert or update on stock_transfer_line
  for each row execute function check_stock_transfer_line();

-- 17c. Lệnh hủy / hoàn thành (kể cả kết thúc sớm) → phiếu tự lập còn CHO_XUAT (chưa quét xuất) của lệnh thành DA_HUY.
--      Ghi ở máy chủ nhà máy khi nhận lệnh hủy / kết thúc (bảng do nhà máy làm chủ); phiếu đã xuất xử lý theo QT16.
create or replace function cancel_order_transfer_drafts() returns trigger language plpgsql as $$
begin
  if new.status in ('DA_HUY','HOAN_THANH') and old.status is distinct from new.status then
    update stock_transfer set status = 'DA_HUY', updated_at = now(), updated_by = '00000000-0000-0000-0000-000000000001'
     where source_order_id = new.id and auto_drafted and status = 'CHO_XUAT';
  end if;
  return new;
end $$;
create trigger trg_order_transfer_drafts after update of status on production_order
  for each row execute function cancel_order_transfer_drafts();

-- 17d. Yêu cầu chuyển YCC- (04/11): chỉ đi tới — CHO_LAP_PHIEU → TREN_PHIEU / TU_CHOI / QUA_HAN_XUAT / DA_RUT;
--      TREN_PHIEU → BI_TRA_VE (phiếu hủy); trạng thái khác không đổi lại. Kho xuất và kho nhận khác nhà máy hoặc khác kho.
create or replace function check_transfer_request() returns trigger language plpgsql as $$
begin
  if tg_op = 'INSERT' and new.status <> 'CHO_LAP_PHIEU' then
    raise exception 'Yêu cầu chuyển % lập ra ở Chờ lập phiếu', new.code;
  elsif (select factory_id from warehouse where id = new.from_warehouse_id) <> new.factory_id
     or (select factory_id from warehouse where id = new.to_warehouse_id) <> new.to_factory_id then
    raise exception 'Yêu cầu chuyển %: nhà máy nguồn / nhận không khớp kho xuất / kho nhận', new.code;
  end if;
  if tg_op = 'UPDATE' and new.status <> old.status
     and not ((old.status = 'CHO_LAP_PHIEU' and new.status in ('TREN_PHIEU','TU_CHOI','QUA_HAN_XUAT','DA_RUT'))
              or (old.status = 'TREN_PHIEU' and new.status = 'BI_TRA_VE')) then
    raise exception 'Yêu cầu chuyển %: không đổi % → %', new.code, old.status, new.status;
  end if;
  return new;
end $$;
create trigger trg_transfer_request before insert or update on transfer_request
  for each row execute function check_transfer_request();

-- Menu theo quyền (thêm 20/10): màn hiện khi vai trò còn hiệu lực của người dùng có quyền ở ít nhất 1 chức năng của màn
--    (screen_function). Sửa 04/11: bỏ cờ loại kho của chức năng (@DIEU_PHOI) — Thủ kho điều phối là vai trò riêng.
--    Admin không còn mọi thao tác: chỉ quản trị + QT01.xa (xem mọi màn, cùng Giám đốc).
create or replace function check_screen_function() returns trigger language plpgsql as $$
begin
  if not exists (select 1 from permission where function_code = new.function_code) then
    raise exception 'Chức năng % không có trong bảng quyền', new.function_code;
  end if;
  return new;
end $$;
create trigger trg_screen_function_ma before insert or update of function_code on screen_function
  for each row execute function check_screen_function();

create or replace view v_user_screen as
with ur as (
  select ur.user_id, ur.role_id
    from user_role ur
    join role r on r.id = ur.role_id and r.status = 'DANG_DUNG'
   where ur.revoked_at is null and ur.valid_from <= now() and (ur.valid_until is null or ur.valid_until > now())
), up as (
  -- quyền thực = quyền vai trò − BO + THEM (phân quyền từng người, 05/11)
  select ur.user_id, rp.permission_id
    from ur join role_permission rp on rp.role_id = ur.role_id and rp.revoked_at is null
   where not exists (select 1 from user_permission x where x.user_id = ur.user_id and x.permission_id = rp.permission_id
                       and x.effect = 'BO' and x.revoked_at is null)
  union
  select user_id, permission_id from user_permission where effect = 'THEM' and revoked_at is null
)
select distinct up.user_id, s.id as screen_id, s.code as screen_code, s.module, s.name, s.sort_order
  from up
  join permission p on p.id = up.permission_id
  join screen_function sf on sf.function_code = p.function_code
  join screen s on s.id = sf.screen_id and s.status = 'DANG_DUNG'
union
select u.id, s.id, s.code, s.module, s.name, s.sort_order
  from app_user u cross join screen s
 where s.always_visible and s.status = 'DANG_DUNG' and not u.is_system;
comment on view v_user_screen is 'Màn mỗi người dùng thấy trên menu (thêm 20/10): theo vai trò còn hiệu lực × quyền (trừ BO, cộng THEM của user_permission — 05/11) × màn × chức năng; Việc cần làm cho mọi người dùng.';

-- ===== Bổ sung 20/10 (đợt 2): chủ dữ liệu theo dòng cloud ↔ máy chủ nhà máy, kênh lệnh từ trung tâm, hàng đợi gửi lên =====
-- Một schema, một mã nguồn chạy ở cloud và ở từng máy chủ nhà máy. Mỗi kết nối của ứng dụng đặt:
--   set app.site = 'CLOUD' | 'NM';  set app.factory_id = '<uuid nhà máy>' (ở máy chủ nhà máy);
--   bộ áp dụng đồng bộ (ghi bản sao nhận từ nơi kia) đặt thêm app.sync_apply = 'on'; máy chủ nhà máy đang mất kết nối đặt app.offline = 'on'.
-- Không đặt app.site (công cụ nạp dữ liệu, phép thử cũ) thì các trigger dưới không làm gì.

-- 18. Chặn ghi sai nơi (quyết định thiết kế 34): đọc nhóm của bảng ở sync_policy.
--     Cloud: không ghi bảng nhóm NM / NM_ONLY — trừ cập nhật chỉ cột dẫn xuất (derived_columns, vd SL đã nhận trên phiếu chuyển của nhà máy xuất).
--     Máy chủ nhà máy: không ghi bảng nhóm CLOUD / CLOUD_ONLY; bảng nhóm NM chỉ ghi dòng có factory_id = nhà máy mình.
create or replace function site_guard() returns trigger language plpgsql as $$
declare
  s text := nullif(current_setting('app.site', true), '');
  f text := nullif(current_setting('app.factory_id', true), '');
  g text; fc text; der text[]; rowf text;
begin
  if s is null or coalesce(current_setting('app.sync_apply', true), '') = 'on' then return new; end if;
  select owner_group, factory_column, derived_columns into g, fc, der from mes.sync_policy where table_name = tg_table_name;
  if g is null or g = 'NOI_PHAT_SINH' then return new; end if;
  if s = 'CLOUD' then
    if g in ('NM', 'NM_ONLY') then
      if tg_op = 'UPDATE' and cardinality(der) > 0
         and (to_jsonb(new) - (der || array['updated_at', 'updated_by'])) = (to_jsonb(old) - (der || array['updated_at', 'updated_by'])) then
        return new;  -- bộ chiếu của cloud ghi cột dẫn xuất
      end if;
      raise exception 'Bảng % do máy chủ nhà máy làm chủ: cloud chỉ đọc bản đồng bộ, muốn đổi thì gửi lệnh (site_command)', tg_table_name;
    end if;
  else
    if g in ('CLOUD', 'CLOUD_ONLY') then
      raise exception 'Bảng % do cloud làm chủ: máy chủ nhà máy chỉ đọc bản sao', tg_table_name;
    end if;
    if g = 'NM' and fc is not null and f is not null then
      rowf := to_jsonb(new) ->> fc;
      if rowf is distinct from f then
        raise exception 'Dòng % thuộc nhà máy khác (%): chỉ máy chủ nhà máy của dòng được ghi', tg_table_name, coalesce(rowf, 'trống');
      end if;
    end if;
  end if;
  return new;
end $$;

-- 19. Hàng đợi gửi lên (quyết định 36): ở máy chủ nhà máy, mọi INSERT / UPDATE trên bảng nhóm NM và NOI_PHAT_SINH ghi 1 dòng sync_outbox
--     (event_type DONG, payload = bản ghi sau thay đổi) trong CÙNG giao dịch — kể cả khi có kết nối (chỉ một đường đồng bộ).
create sequence if not exists sync_outbox_seq;
create or replace function sync_outbox_write() returns trigger language plpgsql as $$
declare
  s text := nullif(current_setting('app.site', true), '');
  g text; f uuid; j jsonb := to_jsonb(new);
begin
  if s is null or s = 'CLOUD' or coalesce(current_setting('app.sync_apply', true), '') = 'on' then return null; end if;
  select owner_group into g from mes.sync_policy where table_name = tg_table_name;
  if g is null or g not in ('NM', 'NOI_PHAT_SINH') or tg_table_name = 'code_sequence' then return null; end if;
  f := nullif(current_setting('app.factory_id', true), '')::uuid;
  if f is null then
    raise exception 'Máy chủ nhà máy phải đặt app.factory_id trước khi ghi % (hàng đợi gửi lên)', tg_table_name;
  end if;
  insert into mes.sync_outbox (factory_id, event_id, seq_no, table_name, record_key, op, event_type, payload, occurred_at, recorded_by, offline)
  values (f, gen_random_uuid(), nextval('mes.sync_outbox_seq'), tg_table_name,
          coalesce(j ->> 'id', j ->> 'event_id', j ->> 'command_id', j ->> 'code'), tg_op, 'DONG', j, now(),
          coalesce((j ->> 'updated_by')::uuid, (j ->> 'created_by')::uuid, (j ->> 'actor_id')::uuid, (j ->> 'user_id')::uuid,
                   '00000000-0000-0000-0000-000000000001'::uuid),
          coalesce(current_setting('app.offline', true), '') = 'on');
  return null;
end $$;

do $$
declare r record;
begin
  for r in select table_name from information_schema.tables
           where table_schema = 'mes' and table_type = 'BASE TABLE' and table_name not in ('sync_outbox', 'sync_policy')
  loop
    execute format('create trigger trg_site_guard before insert or update on mes.%I for each row execute function mes.site_guard()', r.table_name);
    execute format('create trigger trg_sync_outbox after insert or update on mes.%I for each row execute function mes.sync_outbox_write()', r.table_name);
  end loop;
end $$;

-- 20. Kênh lệnh từ trung tâm (quyết định 35): trạng thái lệnh chỉ đi tới, nội dung lệnh không sửa; kết quả nhà máy (command_inbox) → cloud chiếu sang lệnh.
create or replace function site_command_status() returns trigger language plpgsql as $$
declare st text[] := array['CHO_GUI', 'DA_GUI', 'DA_AP_DUNG', 'TU_CHOI'];
begin
  if new.kind <> old.kind or new.payload <> old.payload or new.factory_id <> old.factory_id or new.seq <> old.seq then
    raise exception 'Không sửa nội dung lệnh % đã lập — lập lệnh mới', old.seq;
  end if;
  if old.status in ('DA_AP_DUNG', 'TU_CHOI') and (new.status <> old.status or new.result_text is distinct from old.result_text) then
    raise exception 'Lệnh % đã % — không đổi được', old.seq, old.status;
  end if;
  if array_position(st, new.status) < array_position(st, old.status) then
    raise exception 'Lệnh chỉ đi tới: % → % không hợp lệ', old.status, new.status;
  end if;
  return new;
end $$;
create trigger trg_site_command_status before update on site_command
  for each row execute function site_command_status();

create or replace function command_inbox_result() returns trigger language plpgsql as $$
begin
  if coalesce(nullif(current_setting('app.site', true), ''), 'CLOUD') <> 'CLOUD' then return null; end if;
  if not exists (select 1 from mes.site_command c where c.id = new.command_id and c.factory_id = new.factory_id and c.seq = new.seq and c.kind = new.kind) then
    raise exception 'Sổ lệnh nhà máy lệch lệnh gốc (mã %, nhà máy, số thứ tự hoặc loại)', new.command_id;
  end if;
  update mes.site_command
     set status = case when new.status = 'DA_NHAN' then 'DA_GUI' else new.status end,
         sent_at = coalesce(sent_at, new.received_at),
         result_text = coalesce(new.result_text, result_text),
         applied_at = case when new.status = 'DA_NHAN' then applied_at else new.applied_at end
   where id = new.command_id and status not in ('DA_AP_DUNG', 'TU_CHOI');
  return null;
end $$;
create trigger trg_command_inbox_result after insert or update on command_inbox
  for each row execute function command_inbox_result();

-- 21. Hạn dùng tính từ HSD (sửa 24/10 đợt 9 — bỏ cảnh báo cận date, thay view v_lot_expiry): số ngày còn lại, đã hết hạn, dưới ngưỡng SX
--     không lưu, mỗi nơi tự tính. Ngưỡng hạn còn lại tối thiểu khi dùng cho SX = tham số production.min_shelf_days (mặc định 30 ngày;
--     ghi đè theo mã NVL rồi theo nhóm NVL qua group_code, rồi theo nhà máy). Chặn ở CSDL: quét xuất SX (goods_issue_scan của phiếu SAN_XUAT),
--     quét bao nạp silo OK (silo_charge), xả silo cho mẻ khi nút silo có lô đã nạp hết hạn (lot_link XA_SILO). Lô dưới ngưỡng vẫn ĐẠT.
create or replace function production_min_shelf_days(p_lot uuid) returns integer language sql stable as $$
  select coalesce(
    (select (p.value #>> '{}')::int from mes.system_parameter p join mes.lot l on l.id = p_lot join mes.material m on m.id = l.material_id
      where p.param_key = 'production.min_shelf_days' and p.scope_type = 'NHOM' and p.group_code = m.code),
    (select (p.value #>> '{}')::int from mes.system_parameter p join mes.lot l on l.id = p_lot join mes.material m on m.id = l.material_id
      where p.param_key = 'production.min_shelf_days' and p.scope_type = 'NHOM' and p.group_code = m.material_group),
    (select (p.value #>> '{}')::int from mes.system_parameter p join mes.lot l on l.id = p_lot
      where p.param_key = 'production.min_shelf_days' and p.scope_type = 'NHA_MAY' and p.factory_id = l.factory_id),
    (select (value #>> '{}')::int from mes.system_parameter where param_key = 'production.min_shelf_days' and scope_type = 'TOAN_HT'),
    30)
$$;
create or replace view v_lot_shelf as
select l.id as lot_id, l.factory_id, l.lot_no, l.lot_kind, l.exp_date, (l.exp_date - current_date) as days_left,
       (l.exp_date < current_date) as expired,
       case when l.lot_kind in ('NVL_MUA', 'HH') then production_min_shelf_days(l.id) end as production_min_days,
       (l.lot_kind in ('NVL_MUA', 'HH') and (l.exp_date - current_date) < production_min_shelf_days(l.id)) as below_production_min
  from lot l
 where l.exp_date is not null;
comment on view v_lot_shelf is 'Hạn còn lại của lô tính từ HSD (24/10 đợt 9 — thay v_lot_expiry, bỏ mức cận date): đã hết hạn; lô NVL / hỗn hợp dưới ngưỡng tối thiểu cho SX (vẫn ĐẠT, không xuất SX / nạp silo được).';

create or replace function check_production_shelf(p_lot uuid, p_at date, p_what text) returns void language plpgsql as $$
declare e date; n integer; k text;
begin
  select exp_date, lot_kind into e, k from mes.lot where id = p_lot;
  if e is null or k not in ('NVL_MUA', 'HH') then return; end if;
  n := mes.production_min_shelf_days(p_lot);
  if e - p_at < n then
    raise exception '% — lô còn % ngày (HSD %), dưới ngưỡng tối thiểu cho sản xuất % ngày', p_what, e - p_at, e, n;
  end if;
end $$;
create or replace function goods_issue_scan_shelf() returns trigger language plpgsql as $$
begin
  if (select gi.issue_type from goods_issue_line li join goods_issue gi on gi.id = li.issue_id where li.id = new.issue_line_id) = 'SAN_XUAT' then
    perform check_production_shelf(new.lot_id, new.scanned_at::date, 'Quét xuất sản xuất');
  end if;
  return new;
end $$;
create trigger trg_goods_issue_scan_shelf before insert on goods_issue_scan
  for each row execute function goods_issue_scan_shelf();
create or replace function silo_charge_shelf() returns trigger language plpgsql as $$
begin
  if new.scan_result = 'OK' then
    perform check_production_shelf(new.lot_id, new.scanned_at::date, 'Quét bao nạp silo');
  end if;
  return new;
end $$;
create trigger trg_silo_charge_shelf before insert or update of scan_result, lot_id on silo_charge
  for each row execute function silo_charge_shelf();
create or replace function lot_link_shelf() returns trigger language plpgsql as $$
declare bad text;
begin
  if new.link_type = 'XA_SILO' then
    select string_agg(distinct l.lot_no, ', ') into bad
      from lot_link n join lot l on l.id = n.parent_lot_id
     where n.child_lot_id = new.parent_lot_id and n.link_type = 'NAP_SILO' and n.linked_at <= new.linked_at
       and l.exp_date < new.linked_at::date;
    if bad is not null then
      raise exception 'Xả silo cho mẻ bị chặn — trong silo có lô đã hết hạn: %', bad;
    end if;
  end if;
  return new;
end $$;
create trigger trg_lot_link_shelf before insert on lot_link
  for each row execute function lot_link_shelf();

-- 22. Bản sao khách / đơn xuống máy chủ nhà máy (20/10 đợt 3 — quyết định 38): giữ khóa ngoại (yêu cầu xuất bán → đơn → khách — sửa 24/10, thay đợt giao) nhưng bỏ cột tiền,
--     liên hệ, công nợ (sync_policy.masked_columns). Bộ sao xuống của cloud đọc dòng qua sync_down_row(); bản sao ở nhà máy để trống các cột đó.
--     Cột vốn bắt buộc được nới ở mức bảng và bắt buộc lại bằng trigger khi ghi ở cloud / công cụ nạp (không đặt app.site).
create or replace function sync_down_row(p_table text, p_row jsonb) returns jsonb language sql stable as $$
  select p_row - coalesce((select masked_columns from mes.sync_policy where table_name = p_table), '{}'::text[])
$$;
create or replace function masked_required() returns trigger language plpgsql as $$
declare j jsonb := to_jsonb(new); c text;
begin
  if coalesce(nullif(current_setting('app.site', true), ''), 'CLOUD') = 'NM' then return new; end if;
  foreach c in array tg_argv loop
    if j ->> c is null then
      raise exception 'Cột %.% bắt buộc khi ghi ở cloud (chỉ bản sao ở máy chủ nhà máy được để trống)', tg_table_name, c;
    end if;
  end loop;
  return new;
end $$;
create trigger trg_masked_required before insert or update on customer
  for each row execute function masked_required('phone', 'is_credit_blocked');
create trigger trg_masked_required before insert or update on sales_order_version
  for each row execute function masked_required('payment_method', 'deposit_pct', 'total_before_vat', 'vat_amount', 'total_amount');
create trigger trg_masked_required before insert or update on sales_order_line
  for each row execute function masked_required('unit_price', 'vat_rate');


-- 23. Giao hàng chỉ ghi nhận (24/10): ghi nhận giao (delivery_note) gắn 1 phiếu xuất bán đã xuất — không có đợt giao.
--     Phiếu xuất bán bắt buộc gắn yêu cầu xuất bán của đơn (check trên goods_issue); hóa đơn của đơn ở sales_order_invoice (một đơn nhiều hóa đơn).
create or replace function check_delivery_note() returns trigger language plpgsql as $$
declare t text; st text;
begin
  select issue_type, status into t, st from goods_issue where id = new.goods_issue_id;
  if t is distinct from 'BAN' then
    raise exception 'Ghi nhận giao chỉ gắn phiếu xuất bán (phiếu này loại %)', coalesce(t, '?');
  end if;
  if st not in ('DA_XUAT','XUAT_MOT_PHAN') then
    raise exception 'Phiếu xuất bán chưa xuất xong (trạng thái %) — chưa ghi nhận giao được', st;
  end if;
  return new;
end $$;
create trigger trg_delivery_note before insert or update of goods_issue_id on delivery_note
  for each row execute function check_delivery_note();
-- 23b (24/10 đợt 3). Yêu cầu xuất bán: dòng lấy lô gắn đơn, cùng nhà máy với yêu cầu, đúng SP của dòng đơn; tổng SL các yêu cầu
--     chưa hủy của lô ≤ SL lô gắn đơn. Phiếu xuất bán chỉ lập (máy chủ nhà máy tự lập) khi yêu cầu đang CHO_XUAT, cùng nhà máy, và vào thẳng DA_DUYET (đợt 4).
create or replace function check_sales_issue_line() returns trigger language plpgsql as $$
declare r record; v_lot record; v_cap numeric; v_used numeric; v_prod uuid;
begin
  select * into r from sales_issue_request where id = new.request_id;
  select * into v_lot from lot where id = new.lot_id;
  if v_lot.factory_id is distinct from r.factory_id then
    raise exception 'Lô % không ở nhà máy của yêu cầu xuất % (mỗi yêu cầu chỉ lấy lô của 1 nhà máy)', v_lot.lot_no, r.code;
  end if;
  select sum(qty) into v_cap from sales_order_lot where sales_order_id = r.sales_order_id and lot_id = new.lot_id and released_at is null;
  if v_cap is null then
    raise exception 'Lô % không gắn với đơn của yêu cầu %', v_lot.lot_no, r.code;
  end if;
  select product_id into v_prod from sales_order_line where id = new.sales_order_line_id;
  if v_prod is distinct from v_lot.product_id then
    raise exception 'Lô % khác sản phẩm của dòng đơn', v_lot.lot_no;
  end if;
  select coalesce(sum(l.qty), 0) into v_used from sales_issue_request_line l join sales_issue_request q on q.id = l.request_id
   where q.sales_order_id = r.sales_order_id and l.lot_id = new.lot_id and q.status <> 'DA_HUY' and l.id <> new.id;
  if v_used + new.qty > v_cap then
    raise exception 'Lô %: yêu cầu xuất % + đã yêu cầu % vượt % gắn đơn', v_lot.lot_no, new.qty, v_used, v_cap;
  end if;
  return new;
end $$;
create trigger trg_sales_issue_line before insert or update on sales_issue_request_line
  for each row execute function check_sales_issue_line();
create or replace function check_goods_issue_ban() returns trigger language plpgsql as $$
declare r record;
begin
  if new.issue_type = 'BAN' then
    select * into r from sales_issue_request where id = new.sales_issue_request_id;
    if r.status is distinct from 'CHO_XUAT' or r.factory_id is distinct from new.factory_id or r.sales_order_id is distinct from new.sales_order_id then
      raise exception 'Phiếu xuất bán chỉ lập từ yêu cầu xuất bán đang Chờ xuất, đúng nhà máy và đơn (yêu cầu %: %)', coalesce(r.code, '?'), coalesce(r.status, '?');
    end if;
  end if;
  return new;
end $$;
create trigger trg_goods_issue_ban before insert on goods_issue
  for each row execute function check_goods_issue_ban();

-- 25. (24/10 đợt 7) Phiếu xuất: quét bao / thùng hợp lệ đầu tiên → phiếu tự sang DANG_LAY_HANG.
create or replace function goods_issue_scan_start() returns trigger language plpgsql as $$
begin
  update goods_issue set status = 'DANG_LAY_HANG'
   where id = (select issue_id from goods_issue_line where id = new.issue_line_id) and status = 'CHO_LAY_HANG';
  return new;
end $$;
create trigger trg_goods_issue_scan_start after insert on goods_issue_scan
  for each row execute function goods_issue_scan_start();

-- 26. (24/10 đợt 7) Phiếu nhập không duyệt: hệ thống tự sinh CHO_NHAN_HANG (NVL mua: quét PO → DANG_NHAN); quét bao / thùng đầu tiên
--     → DANG_NHAN (trigger trên goods_receipt_scan); DA_NHAP chỉ từ DANG_NHAN khi không lệch (mọi dòng có SL dự kiến: SL nhận = dự kiến,
--     không có bao hư), lệch thì phải qua CHO_XAC_NHAN_LECH → Thủ kho trưởng (không phải người lập) xác nhận; về DANG_NHAN (đếm lại) bắt buộc lý do.
create or replace function goods_receipt_lech(p_id uuid) returns boolean language sql stable as $$
  select exists (select 1 from goods_receipt_line l where l.receipt_id = p_id and l.expected_qty is not null and l.received_qty <> l.expected_qty)
      or exists (select 1 from goods_receipt_damage d join goods_receipt_line l on l.id = d.receipt_line_id where l.receipt_id = p_id) $$;
create or replace function check_goods_receipt() returns trigger language plpgsql as $$
begin
  if tg_op = 'INSERT' and new.status not in ('CHO_NHAN_HANG','DANG_NHAN') then
    raise exception 'Phiếu nhập lập ra ở Chờ nhận hàng (tự sinh) hoặc Đang nhận (quét PO) — không lập thẳng trạng thái khác';
  end if;
  if tg_op = 'UPDATE' and new.status <> old.status then
    if new.status = 'DANG_NHAN' and old.status = 'CHO_XAC_NHAN_LECH' and new.recount_reason is null then
      raise exception 'Phiếu nhập %: yêu cầu đếm lại phải ghi lý do', new.code;
    elsif new.status = 'DANG_NHAN' and old.status not in ('CHO_NHAN_HANG','CHO_XAC_NHAN_LECH') then
      raise exception 'Phiếu nhập %: không về Đang nhận từ %', new.code, old.status;
    elsif new.status = 'CHO_XAC_NHAN_LECH' and (old.status <> 'DANG_NHAN' or not goods_receipt_lech(new.id)) then
      raise exception 'Phiếu nhập %: chỉ phiếu Đang nhận có lệch / bao hư mới sang Chờ xác nhận lệch', new.code;
    elsif new.status = 'DA_NHAP' then
      if old.status = 'DANG_NHAN' and goods_receipt_lech(new.id) then
        raise exception 'Phiếu nhập %: SL nhận lệch dự kiến hoặc có bao hư — phải qua Thủ kho trưởng xác nhận chênh lệch', new.code;
      elsif old.status = 'CHO_XAC_NHAN_LECH' and not exists (
              select 1 from user_role ur join role r on r.id = ur.role_id
               where ur.user_id = new.discrepancy_confirmed_by and r.code = 'THU_KHO_TRUONG' and ur.revoked_at is null
                 and ur.valid_from <= now() and (ur.valid_until is null or ur.valid_until > now())) then
        raise exception 'Phiếu nhập %: chỉ Thủ kho trưởng xác nhận chênh lệch', new.code;
      elsif old.status not in ('DANG_NHAN','CHO_XAC_NHAN_LECH') then
        raise exception 'Phiếu nhập %: chưa nhận hàng (chưa quét) — chưa Đã nhập được', new.code;
      end if;
    end if;
  end if;
  return new;
end $$;
create trigger trg_goods_receipt before insert or update on goods_receipt
  for each row execute function check_goods_receipt();
create or replace function goods_receipt_scan_start() returns trigger language plpgsql as $$
begin
  update goods_receipt set status = 'DANG_NHAN'
   where id = (select receipt_id from goods_receipt_line where id = new.receipt_line_id) and status = 'CHO_NHAN_HANG';
  return new;
end $$;
create trigger trg_goods_receipt_scan_start after insert on goods_receipt_scan
  for each row execute function goods_receipt_scan_start();

-- 27. (24/10 đợt 12) Lệnh Chờ NVL: tồn NVL không chặn tạo lệnh; lệnh chưa giữ chỗ (material_reserved_at null) không phát được.
create or replace function check_production_order_material() returns trigger language plpgsql as $$
begin
  if new.status in ('CHO_PHAT','DA_NHAN') and (tg_op = 'INSERT' or old.status = 'MOI_TAO') and new.material_reserved_at is null then
    raise exception 'Lệnh % đang Chờ NVL (chưa giữ chỗ) — Kiểm tra lại khi hàng về, đủ mới phát được', new.code;
  end if;
  return new;
end $$;
create trigger trg_production_order_material before insert or update of status on production_order
  for each row execute function check_production_order_material();

-- 28. (24/10 đợt 12) Nhu cầu mua do hệ thống tính: mỗi NVL × kho nhận (sửa 04/11 — Hàng đợi mua theo NVL × kho) chỉ 1 dòng
--     chưa lập PO trong các yêu cầu NHU_CAU_SX đang MO của 1 nhà máy (lần tính sau cộng dồn / giảm SL dòng đó, không lập trùng).
create or replace function check_purchase_request_line_auto() returns trigger language plpgsql as $$
declare r purchase_request%rowtype;
begin
  select * into r from purchase_request where id = new.request_id;
  if r.source = 'NHU_CAU_SX' and r.status = 'MO' and new.status = 'MO' and exists (
       select 1 from purchase_request_line l join purchase_request q on q.id = l.request_id
        where l.material_id = new.material_id and l.warehouse_id = new.warehouse_id and l.status = 'MO' and l.id <> new.id
          and q.source = 'NHU_CAU_SX' and q.status = 'MO' and q.factory_id = r.factory_id) then
    raise exception 'NVL đã có trong yêu cầu mua tự lập đang Mở — cập nhật SL dòng đó, không lập trùng';
  end if;
  return new;
end $$;
create trigger trg_purchase_request_line_auto before insert or update of material_id, warehouse_id, request_id, status on purchase_request_line
  for each row execute function check_purchase_request_line_auto();

-- ===== Bổ sung 04/11: xóa tài khoản chưa dùng, hóa đơn gắn phiếu xuất, mẫu lưu =====

-- 29a. Xóa tài khoản (chốt 04/11): chỉ khi chưa từng đăng nhập (không có user_session) — dữ liệu khác trỏ tới (người tạo, người duyệt…)
--      do khóa ngoại chặn. Xóa: gỡ dòng gán vai trò của tài khoản, nhật ký tài khoản bỏ trỏ tới (giữ mã NV ở detail) và ghi 1 dòng XOA.
--      Người xóa lấy từ app.user_id (ứng dụng đặt), mặc định tài khoản Hệ thống.
create or replace function delete_unused_user() returns trigger language plpgsql as $$
declare actor uuid := coalesce(nullif(current_setting('app.user_id', true), '')::uuid, '00000000-0000-0000-0000-000000000001');
begin
  if old.is_system then
    raise exception 'Không xóa tài khoản Hệ thống';
  elsif exists (select 1 from user_session where user_id = old.id) then
    raise exception 'Tài khoản % đã đăng nhập — chỉ khóa, không xóa', old.employee_code;
  end if;
  perform set_config('mes.deleting_user', old.id::text, true);
  delete from user_role where user_id = old.id;
  delete from user_permission where user_id = old.id;
  perform set_config('mes.deleting_user', '', true);
  update account_change_log set user_id = null, detail = coalesce(detail, '{}'::jsonb) || jsonb_build_object('employee_code', old.employee_code)
   where user_id = old.id;
  insert into account_change_log (user_id, change_type, detail, actor_id)
  values (null, 'XOA', jsonb_build_object('employee_code', old.employee_code, 'full_name', old.full_name), actor);
  return old;
end $$;
create trigger trg_app_user_delete before delete on app_user
  for each row execute function delete_unused_user();

-- 29b. Hóa đơn bán hàng (04/11): gắn phiếu xuất bán (BAN) đã xuất / xuất một phần của đúng đơn.
create or replace function check_sales_order_invoice() returns trigger language plpgsql as $$
declare g goods_issue%rowtype;
begin
  select * into g from goods_issue where id = new.goods_issue_id;
  if g.issue_type <> 'BAN' or g.status not in ('DA_XUAT','XUAT_MOT_PHAN') or g.sales_order_id <> new.sales_order_id then
    raise exception 'Hóa đơn: phiếu xuất % không phải phiếu xuất bán đã xuất của đơn', g.code;
  end if;
  return new;
end $$;
create trigger trg_sales_order_invoice before insert or update of goods_issue_id, sales_order_id on sales_order_invoice
  for each row execute function check_sales_order_invoice();

-- 29c. Mẫu lưu (04/11): lấy ra → mẫu đang mở (is_open); niêm phong lại chỉ khi đang mở; sửa hạn lưu ghi hạn cũ đúng hạn hiện tại
--      và cập nhật hạn mới vào mẫu; mẫu đã hủy không ghi thêm.
create or replace function apply_retained_sample_event() returns trigger language plpgsql as $$
declare s retained_sample%rowtype;
begin
  select * into s from retained_sample where id = new.sample_id;
  if s.status = 'DA_HUY' then
    raise exception 'Mẫu % đã hủy', s.code;
  elsif new.event_kind = 'LAY_RA' then
    if s.is_open then raise exception 'Mẫu % đang lấy ra — niêm phong lại trước', s.code; end if;
    update retained_sample set is_open = true, sealed_at = null, updated_at = now(), updated_by = new.actor_id where id = s.id;
  elsif new.event_kind = 'NIEM_PHONG_LAI' then
    if not s.is_open then raise exception 'Mẫu % chưa lấy ra', s.code; end if;
    update retained_sample set is_open = false, sealed_at = new.occurred_at, updated_at = now(), updated_by = new.actor_id where id = s.id;
  else
    if new.old_retain_until <> s.retain_until then raise exception 'Mẫu %: hạn cũ % khác hạn hiện tại %', s.code, new.old_retain_until, s.retain_until; end if;
    update retained_sample set retain_until = new.new_retain_until, updated_at = now(), updated_by = new.actor_id where id = s.id;
  end if;
  return new;
end $$;
create trigger trg_retained_sample_event before insert on retained_sample_event
  for each row execute function apply_retained_sample_event();

-- Dữ liệu nạp khi triển khai: tài khoản Hệ thống, đơn vị tính, vai trò + thao tác + Vai trò × Thao tác, định dạng mã danh mục, lý do khóa, bảng chuyển trạng thái, tham số mặc định
set search_path = mes;
\set sys '''00000000-0000-0000-0000-000000000001'''

insert into app_user (id, employee_code, full_name, department, job_title, effective_date, is_system, status, created_by)
values (:sys, 'SYSTEM', 'Hệ thống', 'IT', 'Hệ thống', current_date, true, 'HOAT_DONG', :sys);

insert into uom (code, name, uom_type, created_by) values
 ('KG','Kilogram','KHOI_LUONG',:sys), ('L','Lít','THE_TICH',:sys), ('BAO','Bao','DEM',:sys), ('THUNG','Thùng','DEM',:sys), ('LON','Lon','DEM',:sys), ('CAI','Cái','DEM',:sys);
-- đơn vị quy đổi về đơn vị gốc (Danh mục › Đơn vị, chốt 04/11)
insert into uom (code, name, uom_type, base_uom_code, factor, created_by) values
 ('G','Gram','KHOI_LUONG','KG',0.001,:sys), ('TAN','Tấn','KHOI_LUONG','KG',1000,:sys), ('ML','Mililít','THE_TICH','L',0.001,:sys);

-- 19 vai trò (mục "Vai trò × Chức năng"; bỏ Trưởng bộ phận 28/10; thêm Thủ kho điều phối 04/11 — quyền của vai trò này nạp ở lượt sửa bảng quyền sau). admin_assign_only: chỉ Admin gán. delegable: ủy quyền tạm được (chốt 19/10).
insert into role (code, name, description, admin_assign_only, delegable, created_by) values
 ('ADMIN', 'Admin', 'Quản trị hệ thống. Phạm vi mặc định: Mọi nhà máy. Quản trị hệ thống, xem mọi màn ở mọi nhà máy (chỉ xem), không làm bước nghiệp vụ (cần làm thì được gán thêm vai trò đó, do HR / Admin khác gán — chốt 20/10); chỉ Admin gán vai trò Admin và Người truy xuất; mở khóa, cấp mật khẩu tạm; cấu hình tham số mặc định, định dạng mã danh mục, thêm đơn vị tính; tạo / sửa / ngừng dùng nhà máy, khu vực làm việc (loại khu, khối lượng mẻ tối đa, dàn silo), kho; không tự sửa vai trò của mình', true, false, :sys),
 ('HR', 'HR', 'Nhân sự. Phạm vi mặc định: Mọi nhà máy. Tạo / sửa tài khoản, gán vai trò trực tiếp (trừ Admin và Người truy xuất), không duyệt, không bàn giao; nhập ngày nghỉ, đặt ngày khóa tài khoản; ủy quyền tạm khi vắng; không tự sửa vai trò của mình (bỏ theo dõi rà soát hằng quý — 28/10)', false, false, :sys),
 ('GIAM_DOC', 'Giám đốc', 'GĐ. Phạm vi mặc định: Mọi nhà máy. Duyệt hạn mức, số tiền hoàn khi hủy đơn và khi thu hồi (cùng Kế toán trưởng, một người duyệt là đủ); duyệt thêm PO trên ngưỡng; ký quyết định thu hồi / khoanh vùng, duyệt đóng hồ sơ thu hồi; quyết công nợ quá 90 ngày bên ngoài hệ thống (Kế toán ghi kết quả); xem mọi màn ở mọi nhà máy (chỉ xem)', false, true, :sys),
 ('KE_TOAN_TRUONG', 'Kế toán trưởng', 'KTT. Phạm vi mặc định: Mọi nhà máy. Duyệt hạn mức, số tiền hoàn khi hủy đơn và khi thu hồi (cùng Giám đốc, một người duyệt là đủ); xem mọi công nợ khách hàng, NCC và sổ thu chi; quyết công nợ quá 90 ngày bên ngoài hệ thống (Kế toán ghi kết quả). Không còn duyệt phiếu chi (bỏ 19/10)', false, true, :sys),
 ('KE_TOAN', 'Kế toán', 'Kế toán. Phạm vi mặc định: Mọi nhà máy. Đề xuất hạn mức; ghi nhận tiền về / hoàn tiền (không duyệt); thêm hóa đơn (số, ngày, file) vào đơn — một đơn nhiều hóa đơn (hóa đơn xuất ở phần mềm riêng); ghi nhận đã trả NCC, giảm trừ khi trả hàng; ghi kết quả công nợ quá 90 ngày; ghi giá trị hàng hủy (không hạch toán)', false, false, :sys),
 ('SALES', 'Sales', 'Kinh doanh. Phạm vi mặc định: Mọi nhà máy. Khách hàng, nhận / sửa / hủy đơn, xin tăng hạn mức, yêu cầu xuất từ đơn và ghi nhận kết quả giao (SL khách nhận, ảnh biên bản — 24/10), nhắc nợ; xem công nợ, hạn mức, lịch sử thanh toán của khách (chỉ xem); đổi lô mới / đề nghị hoàn tiền khi thu hồi', false, false, :sys),
 ('CSKH', 'CSKH', 'Chăm sóc khách hàng. Phạm vi mặc định: Mọi nhà máy. Thông báo khách / đại lý khi thu hồi (QT26); không tạo / sửa / hủy đơn', false, false, :sys),
 ('KE_HOACH', 'Kế hoạch', 'Kế hoạch sản xuất, đại diện bộ phận SX. Phạm vi mặc định: Nhà máy. Công thức; tạo / phát lệnh SX trên cloud (xếp dàn silo, hàng đợi phát lệnh từng khu; sửa lệnh Mới tạo, hủy lệnh chưa chạy, kết thúc sớm lệnh đang chạy); lập yêu cầu mua NVL; xử lý xung đột ngoại tuyến cùng QC; gửi yêu cầu xuất kho, gửi yêu cầu chuyển YCC- (nhà máy nhận) và lập phiếu chuyển từ yêu cầu (nhà máy nguồn — lập phiếu là chấp nhận, 04/11), yêu cầu QC kiểm thay bộ phận SX; lập phiếu báo lỗi NCR khi SX giao hàng hư; xem tình trạng giao của đơn; biên bản thất lạc chuyển kho; tự ngừng dùng mã NVL / SP do mình đề nghị, không qua duyệt (QT02 tk — 28/10)', false, true, :sys),
 ('RND', 'R&D', 'Nghiên cứu công thức. Phạm vi mặc định: Mọi nhà máy. Nhập / sửa công thức (QT03), không duyệt', false, false, :sys),
 ('MUA_HANG', 'Mua hàng', 'Nhân viên mua hàng. Phạm vi mặc định: Mọi nhà máy. Hồ sơ NCC, Hàng đợi mua (nhập đơn giá, lập PO hoặc trả về Kế hoạch — bỏ báo giá 04/11), gửi yêu cầu COA & HSD, kiểm COA & HSD, chọn hình thức thanh toán, gửi PO cho NCC qua email, phiếu trả hàng NCC (không cần duyệt thêm), gửi yêu cầu xuất trả NCC', false, false, :sys),
 ('TRUONG_BP_MUA_HANG', 'Trưởng BP Mua hàng', 'Trưởng bộ phận mua hàng. Phạm vi mặc định: Mọi nhà máy. Duyệt NCC, ngừng dùng NCC, duyệt PO, hủy PO đã duyệt; duyệt ngừng dùng mã NVL / SP do Mua hàng đề nghị (QT02 d4 — 28/10)', false, true, :sys),
 ('THU_KHO', 'Thủ kho', 'Thủ kho mọi kho: kho tổng, kho điều phối, kho BTP, kho xuất / nhận. Phạm vi mặc định: Kho được gán. Nhập / xuất / chuyển / đếm / cất hàng / tem (kể cả tem lỗi ở khu SX — công nhân chỉ báo); chuẩn bị NVL ở kho điều phối theo lệnh, lập phiếu xuất SX từ kho điều phối (thủ kho kho điều phối; nhận & quét hàng chuyển từ kho tổng); tạo và thực hiện phiếu hủy; gửi yêu cầu QC; biên bản chênh lệch khi truy xuất. Đăng nhập web bằng mã NV + mật khẩu; quét mã ngay trên màn Kho; sự cố tem làm ở Kho · Tồn kho', false, false, :sys),
 ('THU_KHO_TRUONG', 'Thủ kho trưởng', 'Thủ kho trưởng. Phạm vi mặc định: Kho được gán. Xác nhận chênh lệch khi nhập (phiếu nhập / xuất không duyệt — 24/10 đợt 6, 7), duyệt hủy hàng, ra lệnh kiểm kho và duyệt điều chỉnh (toàn kho và kiểm điểm); chọn gửi QC / hủy hàng hư khi nhận chuyển kho; xác nhận biên bản thất lạc; duyệt ngừng dùng mã NVL / SP do Kho đề nghị (QT02 d4 — 28/10)', false, true, :sys),
 ('THU_KHO_DIEU_PHOI', 'Thủ kho điều phối', 'Thủ kho kho điều phối (thêm 04/11). Phạm vi mặc định: Kho được gán. Chuẩn bị NVL theo lệnh, nhận hàng chuyển từ kho tổng, lập phiếu xuất SX; lập phiếu chuyển từ yêu cầu chuyển YCC- thay Kế hoạch nhà máy nguồn (nội bộ)', false, false, :sys),
 ('VAN_CHUYEN', 'Vận chuyển', 'Tài xế. Phạm vi mặc định: Chuyến được giao. Chuyến xe chuyển kho giữa 2 nhà máy (QT16). Không còn giao hàng cho khách — giao hàng chỉ ghi nhận, Sales ghi (24/10)', false, false, :sys),
 ('CONG_NHAN', 'Công nhân', 'Công nhân sản xuất và đóng gói; tài khoản riêng, đăng nhập PC xưởng bằng quét thẻ. Phạm vi mặc định: Khu vực làm việc: HH / BTP / chiết rót & đóng gói. Chỉ thao tác lệnh của khu mình trên PC xưởng (PC C#: quét bao nạp silo, xả bột dư cuối lệnh, lon đầu, dán QR thùng — QT20, QT21)', false, false, :sys),
 ('QC', 'QC', 'Nhân viên QC. Phạm vi mặc định: Nhà máy. Lấy mẫu (TP sau khi thùng đã nhập kho BTP), gửi kiểm nghiệm, tải file đánh giá bên ngoài và đề xuất kết luận; tự quyết thời hạn lưu mẫu; quản lý và tự hủy mẫu lưu hết hạn; nguyên nhân gốc / CAPA', false, false, :sys),
 ('QC_TRUONG', 'QC trưởng', 'Trưởng QC. Phạm vi mặc định: Nhà máy. Duyệt / từ chối yêu cầu kiểm, duyệt kết luận (lô chỉ đổi ĐẠT / KHÔNG ĐẠT / KHÓA sau khi QC trưởng duyệt), ký phiếu chứng nhận, mở lại lô NVL KHÔNG ĐẠT; mở hồ sơ thu hồi (chỉ vai trò này), đánh giá rủi ro, báo cơ quan, duyệt CAPA; duyệt ngừng dùng mã NVL / SP do QC đề nghị (QT02 d4 — 28/10)', false, true, :sys),
 ('NGUOI_TRUY_XUAT', 'Người truy xuất', 'Do Admin gán. Phạm vi mặc định: Mọi nhà máy. Tạo phiếu và chạy truy xuất QT25 — chỉ vai trò này', true, false, :sys);

-- 239 thao tác = QT + bước × hành động, lấy từ bảng quyền 7 mảng của file quy trình (bước không có mã: QT01.#6 = dòng thứ 6 của QT01); sinh lại 04/11
insert into permission (function_code, action, qt_code, description, created_by) values
 ('QT01.d0,a1', 'TAO', 'QT01', 'Tạo tài khoản, nhập thông tin, chọn vai trò (trừ Admin và Người truy xuất) rồi tick bỏ / thêm quyền riêng từng người (05/11); đổi vai trò; không tự sửa vai trò, quyền của mình', :sys),
 ('QT01.d0,a1', 'SUA', 'QT01', 'Tạo tài khoản, nhập thông tin, chọn vai trò (trừ Admin và Người truy xuất) rồi tick bỏ / thêm quyền riêng từng người (05/11); đổi vai trò; không tự sửa vai trò, quyền của mình', :sys),
 ('QT01.a1', 'SUA', 'QT01', 'Gán / gỡ vai trò Admin và Người truy xuất', :sys),
 ('QT01.n1', 'SUA', 'QT01', 'Nhập ngày nghỉ, đặt / sửa ngày khóa tài khoản', :sys),
 ('QT01.m1', 'SUA', 'QT01', 'Xác minh, mở khóa, cấp mật khẩu tạm (bắt đổi khi đăng nhập)', :sys),
 ('QT01.u1', 'TAO', 'QT01', 'Ủy quyền tạm một vai trò khi vắng (người nhận, ngày bắt đầu, ngày hết hạn bắt buộc; đến hạn tự gỡ)', :sys),
 ('QT01.#6', 'XEM', 'QT01', 'Nhật ký tài khoản', :sys),
 ('QT01.vq', 'SUA', 'QT01', 'Vai trò × quyền: sửa quyền của vai trò, thêm / sửa / xóa quyền, phạm vi nhà máy theo vai trò và theo quyền (chốt 04/11, thay "chỉ xem")', :sys),
 ('QT01.#8', 'SUA', 'QT01', 'Tham số mặc định (⚙ ở mọi QT), định dạng mã danh mục và chứng từ (đơn vị tính chuyển sang Danh mục › Đơn vị — QT02 dv, 04/11)', :sys),
 ('QT01.xa', 'XEM', 'QT01', 'Xem mọi màn ở mọi nhà máy — chỉ xem, không tạo / sửa / duyệt / hủy nghiệp vụ (chốt 20/10, thay "Admin toàn quyền")', :sys),
 ('QT01.xq', 'XEM', 'QT01', 'Xem Vai trò × quyền', :sys),
 ('QT01.xt', 'HUY', 'QT01', 'Xóa tài khoản chưa từng dùng (chưa đăng nhập, chưa có giao dịch); không tự xóa tài khoản của mình (04/11)', :sys),
 ('QT01.tq', 'XEM', 'QT01', 'Tổng quan Giám đốc: số liệu toàn công ty, việc chờ Giám đốc duyệt, lối tắt sang màn nghiệp vụ — chỉ xem (thêm 04/11)', :sys),
 ('QT02.t1,t2', 'TAO', 'QT02', 'Tạo / sửa mã NVL (bộ chỉ tiêu COA ≥ 1, nguyên liệu kỵ nhau, ảnh, tồn tối thiểu, cách bù), SP (cấu trúc, nhóm, phân loại, độ tuổi, mục khác, quy cách đóng gói nhiều cấp, barcode, mẫu nhãn, bản công bố, hồ sơ pháp lý — 04/11) và lựa chọn của ô chọn SP; sửa thông tin khi trùng', :sys),
 ('QT02.t1,t2', 'SUA', 'QT02', 'Tạo / sửa mã NVL (bộ chỉ tiêu COA ≥ 1, nguyên liệu kỵ nhau, ảnh, tồn tối thiểu, cách bù), SP (cấu trúc, nhóm, phân loại, độ tuổi, mục khác, quy cách đóng gói nhiều cấp, barcode, mẫu nhãn, bản công bố, hồ sơ pháp lý — 04/11) và lựa chọn của ô chọn SP; sửa thông tin khi trùng', :sys),
 ('QT02.xo', 'HUY', 'QT02', 'Xóa lựa chọn của ô chọn SP chưa SP nào dùng (04/11)', :sys),
 ('QT02.ml', 'DUYET', 'QT02', 'Duyệt mẫu nhãn của SP (Chờ duyệt → Đã duyệt) (04/11)', :sys),
 ('QT02.t3', 'SUA', 'QT02', 'Xử lý hết tồn / phiếu / đơn mua đang mở trước khi ngừng mã (danh mục SP: ngừng hoặc chuyển các SP đang dùng trước)', :sys),
 ('QT02.tk', 'HUY', 'QT02', 'Kế hoạch ngừng dùng trực tiếp mã do mình đề nghị, ghi lý do — không qua duyệt (28/10)', :sys),
 ('QT02.tg', 'TAO', 'QT02', 'Gửi đề nghị ngừng dùng mã NVL / SP (Kế hoạch không gửi — tự ngừng ở tk)', :sys),
 ('QT02.tr', 'HUY', 'QT02', 'Rút đề nghị ngừng dùng khi đang chờ duyệt (chỉ người đề xuất)', :sys),
 ('QT02.d4', 'DUYET', 'QT02', 'Duyệt ngừng dùng mã NVL / SP (hiện trong Việc cần làm; người gửi không tự duyệt)', :sys),
 ('QT02.ka', 'TAO', 'QT02', 'Nhà máy (Danh mục › Nhà máy; tiền tố mã định danh), kho (bên trong màn Nhà máy; được nhiều kho điều phối — 04/11), khu vực làm việc (loại khu; khối lượng mẻ tối đa với khu HH / BTP; kho điều phối cấp NVL — Danh mục › Nhà máy › Khu vực làm việc & dàn silo): tạo / sửa / ngừng dùng (làm trực tiếp; không đổi loại khu khi còn lệnh chưa hoàn thành)', :sys),
 ('QT02.ka', 'SUA', 'QT02', 'Nhà máy (Danh mục › Nhà máy; tiền tố mã định danh), kho (bên trong màn Nhà máy; được nhiều kho điều phối — 04/11), khu vực làm việc (loại khu; khối lượng mẻ tối đa với khu HH / BTP; kho điều phối cấp NVL — Danh mục › Nhà máy › Khu vực làm việc & dàn silo): tạo / sửa / ngừng dùng (làm trực tiếp; không đổi loại khu khi còn lệnh chưa hoàn thành)', :sys),
 ('QT02.ka', 'HUY', 'QT02', 'Nhà máy (Danh mục › Nhà máy; tiền tố mã định danh), kho (bên trong màn Nhà máy; được nhiều kho điều phối — 04/11), khu vực làm việc (loại khu; khối lượng mẻ tối đa với khu HH / BTP; kho điều phối cấp NVL — Danh mục › Nhà máy › Khu vực làm việc & dàn silo): tạo / sửa / ngừng dùng (làm trực tiếp; không đổi loại khu khi còn lệnh chưa hoàn thành)', :sys),
 ('QT02.ks', 'TAO', 'QT02', 'Dàn silo của khu HH / BTP: thêm silo (tên, sức chứa, gán cứng NVL, mã SCADA), sửa, chuyển bảo trì / ngừng dùng (xem danh sách lệnh bị ảnh hưởng; không chuyển khi silo còn bột của lệnh)', :sys),
 ('QT02.ks', 'SUA', 'QT02', 'Dàn silo của khu HH / BTP: thêm silo (tên, sức chứa, gán cứng NVL, mã SCADA), sửa, chuyển bảo trì / ngừng dùng (xem danh sách lệnh bị ảnh hưởng; không chuyển khi silo còn bột của lệnh)', :sys),
 ('QT02.ks', 'HUY', 'QT02', 'Dàn silo của khu HH / BTP: thêm silo (tên, sức chứa, gán cứng NVL, mã SCADA), sửa, chuyển bảo trì / ngừng dùng (xem danh sách lệnh bị ảnh hưởng; không chuyển khi silo còn bột của lệnh)', :sys),
 ('QT02.dv', 'TAO', 'QT02', 'Đơn vị: thêm / sửa / xóa đơn vị chưa có tham chiếu; đã dùng thì khóa (04/11)', :sys),
 ('QT02.dv', 'SUA', 'QT02', 'Đơn vị: thêm / sửa / xóa đơn vị chưa có tham chiếu; đã dùng thì khóa (04/11)', :sys),
 ('QT02.dv', 'HUY', 'QT02', 'Đơn vị: thêm / sửa / xóa đơn vị chưa có tham chiếu; đã dùng thì khóa (04/11)', :sys),
 ('QT02.xv', 'XEM', 'QT02', 'Xem đơn vị (Danh mục › Đơn vị)', :sys),
 ('QT02.hs', 'TAO', 'QT02', 'Hồ sơ pháp lý chung: tạo / sửa / xóa (04/11)', :sys),
 ('QT02.hs', 'SUA', 'QT02', 'Hồ sơ pháp lý chung: tạo / sửa / xóa (04/11)', :sys),
 ('QT02.hs', 'HUY', 'QT02', 'Hồ sơ pháp lý chung: tạo / sửa / xóa (04/11)', :sys),
 ('QT02.xh', 'XEM', 'QT02', 'Xem hồ sơ pháp lý chung', :sys),
 ('QT02.xk', 'XEM', 'QT02', 'Xem nhà máy, kho (Danh mục › Nhà máy)', :sys),
 ('QT03.t1,t2', 'TAO', 'QT03', 'Nhập / sửa / sao chép công thức; thứ tự dòng là thứ tự nạp (lưu phiên bản mới, không duyệt; bỏ dung sai, thông số trộn chuẩn — 05/11)', :sys),
 ('QT03.t1,t2', 'SUA', 'QT03', 'Nhập / sửa / sao chép công thức; thứ tự dòng là thứ tự nạp (lưu phiên bản mới, không duyệt; bỏ dung sai, thông số trộn chuẩn — 05/11)', :sys),
 ('QT03.#2', 'XEM', 'QT03', 'Xem công thức (kèm lệnh đang chạy phiên bản cũ); công nhân xem trên PC xưởng, chỉ công thức của lệnh khu mình (không vào màn web)', :sys),
 ('QT04.t4,dh', 'HUY', 'QT04', 'Hủy tem (Kho · Tồn kho → dòng lô → bao): bao còn trong kho → cấp mã mới như tem mất; bao không còn → khóa mã, thu tem', :sys),
 ('QT04.t5a,t5', 'SUA', 'QT04', 'Tem hỏng (Kho · Tồn kho → dòng lô → bao): in lại cùng mã, dán, quét xác nhận', :sys),
 ('QT04.t6c,t6', 'TAO', 'QT04', 'Tem mất (ô + lô lấy từ dòng tồn): chọn mã cũ để khóa, cấp mã mới cùng lô, in, dán, quét xác nhận', :sys),
 ('QT04.#4', 'TAO', 'QT04', 'Tem lỗi phát hiện ở khu SX: công nhân chỉ báo, Thủ kho điều phối xử lý như các dòng trên', :sys),
 ('QT04.#4', 'SUA', 'QT04', 'Tem lỗi phát hiện ở khu SX: công nhân chỉ báo, Thủ kho điều phối xử lý như các dòng trên', :sys),
 ('QT04.#4', 'HUY', 'QT04', 'Tem lỗi phát hiện ở khu SX: công nhân chỉ báo, Thủ kho điều phối xử lý như các dòng trên', :sys),
 ('QT05.t1–t3', 'TAO', 'QT05', 'Tạo / cập nhật hồ sơ khách, nhập đơn (Nháp) — kèm hợp đồng nếu đã có: số, hiệu lực, file (05/11)', :sys),
 ('QT05.t1–t3', 'SUA', 'QT05', 'Tạo / cập nhật hồ sơ khách, nhập đơn (Nháp) — kèm hợp đồng nếu đã có: số, hiệu lực, file (05/11)', :sys),
 ('QT05.d2', 'SUA', 'QT05', 'Chọn hình thức, phương thức thanh toán, tiền cọc, số ngày nợ (điền sẵn theo khách)', :sys),
 ('QT05.t6', 'SUA', 'QT05', 'Chốt đơn theo hợp đồng còn hiệu lực của đơn (chưa có thì upload ở chi tiết đơn — 05/11)', :sys),
 ('QT05.hn', 'HUY', 'QT05', 'Hủy đơn chưa chốt (Chờ thu tiền), bắt buộc lý do — không qua duyệt (chốt 04/11)', :sys),
 ('QT05.xk', 'XEM', 'QT05', 'Xem hồ sơ khách, lịch sử liên hệ (Bán hàng › Khách hàng)', :sys),
 ('QT06.t4', 'TAO', 'QT06', 'Đề xuất hạn mức ban đầu', :sys),
 ('QT06.t4d', 'DUYET', 'QT06', 'Duyệt hạn mức ban đầu (vĩnh viễn)', :sys),
 ('QT06.q1,v4', 'SUA', 'QT06', 'Báo khách, chuyển đơn sang trạng thái chờ', :sys),
 ('QT06.q2', 'TAO', 'QT06', 'Ghi nhận tiền về (QT10); hệ thống tự cấn, đóng khoản quá hạn', :sys),
 ('QT06.v1', 'TAO', 'QT06', 'Xin tăng hạn mức', :sys),
 ('QT06.v2', 'XEM', 'QT06', 'Xem công nợ, lịch sử thanh toán', :sys),
 ('QT06.vd1', 'DUYET', 'QT06', 'Quyết hạn mức mới (luôn vĩnh viễn)', :sys),
 ('QT06.v5', 'SUA', 'QT06', 'Ghi mức cọc mới vào đơn', :sys),
 ('QT07.t0', 'HUY', 'QT07', 'Ghi nhận yêu cầu hủy đơn đã chốt, lý do', :sys),
 ('QT07.h2', 'DUYET', 'QT07', 'Quyết số tiền hoàn (mặc định giữ toàn bộ cọc)', :sys),
 ('QT07.h4', 'HUY', 'QT07', 'Hủy lệnh SX chưa chạy', :sys),
 ('QT07.h5', 'XEM', 'QT07', 'TP / BTP của đơn không dùng lại → chuyển Hủy hàng (phiếu hủy do Thủ kho lập ở QT18); Sales xem phiếu hủy của đơn', :sys),
 ('QT08.m1', 'SUA', 'QT08', 'Thỏa thuận lại, tạo phiên bản đơn mới', :sys),
 ('QT08.t6', 'SUA', 'QT08', 'Tải phụ lục đã ký', :sys),
 ('QT08.r2', 'SUA', 'QT08', 'Cập nhật lệnh SX theo đơn mới: lệnh Mới tạo sửa; đã phát chưa chạy hủy rồi tạo lại; đang chạy kết thúc sớm / tạo thêm lệnh', :sys),
 ('QT09.t1', 'XEM', 'QT09', 'Nhận thông báo đơn Sẵn sàng giao; xem tab Giao hàng của đơn', :sys),
 ('QT09.t2', 'TAO', 'QT09', 'Yêu cầu xuất từ đơn: chọn dòng, SL giao lần này; sửa ngày giao dự kiến', :sys),
 ('QT09.kd', 'DUYET', 'QT09', 'Duyệt xuất giao sau khi nhập kho lô của đơn: Mua nợ kiểm công nợ; Cọc + trả nốt ghi nhận phần còn lại (05/11)', :sys),
 ('QT09.t9', 'SUA', 'QT09', 'Phiếu xuất bán Chờ bên yêu cầu: nhận phần đã lấy hoặc hủy yêu cầu', :sys),
 ('QT09.tr', 'HUY', 'QT09', 'Hủy yêu cầu xuất chưa xuất (bắt buộc lý do), kể cả yêu cầu bị nhà máy trả về', :sys),
 ('QT09.t5', 'TAO', 'QT09', 'Ghi nhận kết quả giao theo phiếu xuất: SL khách nhận từng lô, ngày nhận, ảnh biên bản, phần không nhận', :sys),
 ('QT09.dg', 'SUA', 'QT09', 'Ghi khách còn lấy phần trả về hay không (bắt buộc khi có SL không nhận): còn lấy → đơn giữ Giao một phần, chờ QC kiểm lại; không lấy → giảm SL đơn phần đó, đã thu tiền thì GĐ / KTT quyết số tiền hoàn (QT07 h2)', :sys),
 ('QT10.t1', 'TAO', 'QT10', 'Lập hóa đơn bán hàng gắn phiếu xuất của lần giao (một đơn nhiều hóa đơn), in A4 trên MES (chốt 04/11)', :sys),
 ('QT10.k2', 'TAO', 'QT10', 'Ghi nhận tiền về: số tiền, ngày, CK / tiền mặt, ảnh chứng từ (hệ thống cấn vào khoản)', :sys),
 ('QT10.h1', 'TAO', 'QT10', 'Ghi nhận hoàn tiền theo số GĐ / KTT đã quyết (không duyệt thêm)', :sys),
 ('QT10.#4', 'HUY', 'QT10', 'Hủy bản ghi nhận thu / chi nhập sai (bắt buộc lý do; không xóa)', :sys),
 ('QT10.k3', 'TAO', 'QT10', 'Liên hệ khách nhắc nợ, thỏa thuận lịch trả (ngoài hệ thống); ghi lần liên hệ ở Kế toán › Công nợ KH (Bán hàng › Khách hàng hiện lịch sử liên hệ)', :sys),
 ('QT10.g9', 'SUA', 'QT10', 'Ghi kết quả xử lý công nợ quá 90 ngày (GĐ / KTT quyết bên ngoài hệ thống; hệ thống không xóa nợ)', :sys),
 ('QT10.#7', 'XEM', 'QT10', 'Xem công nợ, hạn mức, lịch sử thanh toán của khách (chỉ xem — để nhắc nợ, xin tăng hạn mức)', :sys),
 ('QT10.#8', 'XEM', 'QT10', 'Xem mọi công nợ khách hàng, công nợ NCC và sổ thu chi', :sys),
 ('QT11.t1', 'TAO', 'QT11', 'Tìm NCC, xin hồ sơ, tạo hồ sơ NCC (CHỜ DUYỆT)', :sys),
 ('QT11.d1', 'SUA', 'QT11', 'Kiểm đủ hồ sơ pháp lý, chứng nhận còn hạn (không có bước đánh giá mẫu)', :sys),
 ('QT11.d3', 'DUYET', 'QT11', 'Duyệt / từ chối NCC (chỉ vai trò này)', :sys),
 ('QT11.dr', 'SUA', 'QT11', 'Tìm NCC khác hay báo không có NCC', :sys),
 ('QT11.n1', 'HUY', 'QT11', 'Ngừng dùng NCC, ghi lý do (chỉ vai trò này)', :sys),
 ('QT12.t1', 'TAO', 'QT12', 'Thêm tay nhu cầu mua NVL (mã NC-) ngoài nhu cầu hệ thống tính — nhu cầu theo lệnh SX / tồn tối thiểu hệ thống tự đưa vào Hàng đợi mua (bỏ phiếu yêu cầu mua và báo giá — 04/11)', :sys),
 ('QT12.th', 'HUY', 'QT12', 'Hủy nhu cầu lập tay khi chưa lên PO (bắt buộc lý do)', :sys),
 ('QT12.d1', 'XEM', 'QT12', 'Kiểm tồn khả dụng', :sys),
 ('QT12.t2', 'XEM', 'QT12', 'Nhận dòng ở Hàng đợi mua', :sys),
 ('QT12.tv', 'SUA', 'QT12', 'Trả dòng về Kế hoạch kèm lý do khi không mua được', :sys),
 ('QT12.t3,t4', 'TAO', 'QT12', 'Điền SL, chọn NCC, nhập đơn giá, ngày giao ở Hàng đợi mua; lập PO (gộp theo NCC × kho nhận) → Chờ COA & HSD', :sys),
 ('QT12.t3,t4', 'SUA', 'QT12', 'Điền SL, chọn NCC, nhập đơn giá, ngày giao ở Hàng đợi mua; lập PO (gộp theo NCC × kho nhận) → Chờ COA & HSD', :sys),
 ('QT12.ce', 'SUA', 'QT12', 'Gửi email yêu cầu COA & HSD cho NCC (30/10, 31/10)', :sys),
 ('QT12.ck', 'SUA', 'QT12', 'Kiểm COA & HSD NCC gửi theo bộ chỉ tiêu của NVL (đạt → Chờ chọn thanh toán; không đạt → PO Đã hủy, NVL về Hàng đợi mua)', :sys),
 ('QT12.tt', 'SUA', 'QT12', 'Chọn hình thức thanh toán PO: Trả trước / Cọc + trả nốt trước giao / Trả sau N ngày (→ Chờ duyệt)', :sys),
 ('QT12.d3', 'DUYET', 'QT12', 'Duyệt / từ chối PO (từ chối bắt buộc lý do)', :sys),
 ('QT12.c2', 'DUYET', 'QT12', 'Duyệt thêm PO trên ngưỡng (mặc định 100 triệu)', :sys),
 ('QT12.gp', 'SUA', 'QT12', 'Gửi PO cho NCC qua email (→ Đã gửi NCC)', :sys),
 ('QT12.hp', 'HUY', 'QT12', 'Hủy PO (bắt buộc lý do; đã gửi NCC thì email báo hủy): PO chưa duyệt — Mua hàng hoặc Trưởng BP Mua hàng; PO đã duyệt — chỉ Trưởng BP Mua hàng', :sys),
 ('QT12.dl', 'HUY', 'QT12', 'Đóng phần còn lại của PO giao thiếu (bắt buộc lý do) → Đã đóng, phần chưa giao về Hàng đợi mua', :sys),
 ('QT12.d4,t6', 'TAO', 'QT12', 'Ghi nhận đã trả trước / cọc / trả nốt theo PO (số tiền, ngày, CK / tiền mặt, ảnh chứng từ; không duyệt)', :sys),
 ('QT12.t8', 'TAO', 'QT12', 'Ghi nhận đã trả NCC khoản trả sau (giảm khoản phải trả)', :sys),
 ('QT12.y5', 'XEM', 'QT12', 'Theo dõi PO nhận một phần, giao trễ / thiếu', :sys),
 ('QT13.t1', 'TAO', 'QT13', 'Ghi nhận hàng lỗi chờ trả (để riêng ngoài hệ thống)', :sys),
 ('QT13.t2', 'TAO', 'QT13', 'Tạo phiếu trả hàng NCC (hệ thống KHÓA lô ĐẠT, lý do hàng hư chờ trả NCC)', :sys),
 ('QT13.d1,d2', 'SUA', 'QT13', 'Ghi kết quả NCC: chấp nhận / đổi 1-1 / giảm công nợ (PO trả trước không chọn được giảm công nợ)', :sys),
 ('QT13.n1,n2,nd', 'TAO', 'QT13', 'Biên bản không thống nhất; ghi kết quả nhà máy tự giải quyết (hệ thống chỉ ghi nhận)', :sys),
 ('QT13.n1,n2,nd', 'SUA', 'QT13', 'Biên bản không thống nhất; ghi kết quả nhà máy tự giải quyết (hệ thống chỉ ghi nhận)', :sys),
 ('QT13.tx', 'SUA', 'QT13', 'Gửi yêu cầu xuất trả (phiếu trả → Chờ duyệt xuất trả); chặn trả vượt SL đã nhận của PO', :sys),
 ('QT13.dx', 'DUYET', 'QT13', 'Duyệt yêu cầu xuất trả (→ Chờ kho xuất trả) / từ chối bắt buộc lý do (→ Mở); không tự duyệt yêu cầu mình gửi (24/10 đợt 6)', :sys),
 ('QT13.t3', 'TAO', 'QT13', 'Lập phiếu xuất loại "trả NCC" theo yêu cầu, đúng lô trên phiếu trả (phiếu xuất vào thẳng Chờ lấy hàng — 24/10 đợt 6); xuất xong → Đã xuất trả', :sys),
 ('QT13.t6', 'TAO', 'QT13', 'Nhập hàng đổi về như hàng mua (QT14)', :sys),
 ('QT13.t4', 'SUA', 'QT13', 'Ghi nhận giảm trừ khoản phải trả NCC', :sys),
 ('QT13.t5', 'SUA', 'QT13', 'Ký xác nhận, gửi giấy tờ cho kế toán', :sys),
 ('QT14.d0,t1', 'TAO', 'QT14', 'Nhận hàng: quét đơn mua (phiếu điền sẵn theo PO) hoặc mở phiếu Chờ nhận hàng hệ thống tự sinh; đối chiếu chứng từ', :sys),
 ('QT14.d1', 'HUY', 'QT14', 'Thiếu chứng từ → từ chối ở cửa kho (không tạo lô)', :sys),
 ('QT14.t2', 'TAO', 'QT14', 'Báo NCC, tạo phiếu gửi NCC', :sys),
 ('QT14.l1', 'TAO', 'QT14', 'Nhập số lô NCC, NSX, HSD, tải file đánh giá bên ngoài', :sys),
 ('QT14.t3,kb', 'TAO', 'QT14', 'Kiểm ngoại quan từng bao, ghi bao hư, biên bản', :sys),
 ('QT14.nr', 'TAO', 'QT14', 'Phiếu báo lỗi NCR cho bao hư từ SX', :sys),
 ('QT14.k1,k3,k6,k7', 'TAO', 'QT14', 'Chọn dòng hàng, in / dán / quét tem (NVL mua), quét tem có sẵn (thùng BTP — dán lúc đóng thùng, bao bột dư, khách trả, thu hồi, chuyển kho), dán lại tem nhầm', :sys),
 ('QT14.k1,k3,k6,k7', 'SUA', 'QT14', 'Chọn dòng hàng, in / dán / quét tem (NVL mua), quét tem có sẵn (thùng BTP — dán lúc đóng thùng, bao bột dư, khách trả, thu hồi, chuyển kho), dán lại tem nhầm', :sys),
 ('QT14.d4', 'DUYET', 'QT14', 'Xác nhận chênh lệch khi nhập (SL nhận khác dự kiến / có bao hư) → nhập theo SL thực; hoặc yêu cầu đếm lại (bắt buộc lý do). Phiếu khớp tự Đã nhập, không duyệt (24/10 đợt 7)', :sys),
 ('QT14.t4', 'TAO', 'QT14', 'Lưu hóa đơn / chứng từ của phiếu nhập NVL mua đã nhập: số hóa đơn, tệp, bản cứng', :sys),
 ('QT15.s', 'TAO', 'QT15', 'Yêu cầu xuất: bán / SX / chuyển kho / trả NCC', :sys),
 ('QT15.dq0,dq1', 'SUA', 'QT15', 'Xuất phần có / hủy yêu cầu; phiếu Chờ bên yêu cầu (thiếu, không có lô thay thế): nhận phần đã lấy (→ Xuất một phần) hoặc hủy (→ Đã hủy) — chỉ bên yêu cầu', :sys),
 ('QT15.dq0,dq1', 'HUY', 'QT15', 'Xuất phần có / hủy yêu cầu; phiếu Chờ bên yêu cầu (thiếu, không có lô thay thế): nhận phần đã lấy (→ Xuất một phần) hoặc hủy (→ Đã hủy) — chỉ bên yêu cầu', :sys),
 ('QT15.t2,t3,d4', 'SUA', 'QT15', 'Lấy hàng theo phiếu, quét, lấy lại bao sai, báo hết hàng', :sys),
 ('QT15.t4', 'HUY', 'QT15', 'Cất lại hàng đã lấy, phiếu → Đã hủy', :sys),
 ('QT15.xt', 'XEM', 'QT15', 'Xem tồn kho của kho mình có nhập / xuất (Kho › Tồn kho; bản cloud chỉ xem, ghi "tính đến …")', :sys),
 ('QT15.xp', 'XEM', 'QT15', 'Xem phiếu xuất của kho mình (phiếu xuất không duyệt — 24/10 đợt 6)', :sys),
 ('QT16.s,y0', 'TAO', 'QT16', 'Gửi yêu cầu chuyển liên nhà máy YCC- (nhà máy nhận), rút yêu cầu chưa lên phiếu (mọi yêu cầu chuyển kho do Kế hoạch gửi, không phải Thủ kho)', :sys),
 ('QT16.s,y0', 'HUY', 'QT16', 'Gửi yêu cầu chuyển liên nhà máy YCC- (nhà máy nhận), rút yêu cầu chưa lên phiếu (mọi yêu cầu chuyển kho do Kế hoạch gửi, không phải Thủ kho)', :sys),
 ('QT16.yl', 'TAO', 'QT16', 'Nhà máy nguồn: gom yêu cầu chuyển, lập phiếu chuyển — lập phiếu là chấp nhận (bỏ Thủ kho trưởng xác nhận — 30/10); lập một phần; từ chối (bắt buộc lý do); hủy phiếu chưa xuất (yêu cầu về Chờ lập phiếu)', :sys),
 ('QT16.yl', 'HUY', 'QT16', 'Nhà máy nguồn: gom yêu cầu chuyển, lập phiếu chuyển — lập phiếu là chấp nhận (bỏ Thủ kho trưởng xác nhận — 30/10); lập một phần; từ chối (bắt buộc lý do); hủy phiếu chưa xuất (yêu cầu về Chờ lập phiếu)', :sys),
 ('QT16.yn', 'TAO', 'QT16', 'Lập tay phiếu chuyển nội bộ ngoài phiếu theo lệnh; lập phiếu từ yêu cầu chuyển nội bộ (nếu có)', :sys),
 ('QT16.r1,g1', 'TAO', 'QT16', 'Xuất hàng, quét bao → phiếu (chuyển cho kho điều phối: thủ kho kho tổng)', :sys),
 ('QT16.kx', 'HUY', 'QT16', 'Không thực hiện được (lý do bắt buộc) → phiếu Đã hủy', :sys),
 ('QT16.t1', 'SUA', 'QT16', 'Chuyển hàng, truy vết chuyến xe', :sys),
 ('QT16.d3,t3,d4', 'SUA', 'QT16', 'Nhận hàng, quét, ký nhận, đối chiếu phiếu (NVL cho SX: Thủ kho điều phối)', :sys),
 ('QT16.t4', 'TAO', 'QT16', 'Biên bản chênh lệch; quét bao hư (ĐẠT → KHÓA từng bao, lý do hư khi nhận)', :sys),
 ('QT16.t4', 'DUYET', 'QT16', 'Chọn hàng hư gửi QC hay hủy', :sys),
 ('QT16.t2', 'SUA', 'QT16', 'Xử lý trễ; tìm hàng thiếu trong 7 ngày', :sys),
 ('QT16.g3', 'TAO', 'QT16', 'Lập biên bản thất lạc', :sys),
 ('QT16.gx', 'DUYET', 'QT16', 'Xác nhận biên bản thất lạc (phần thất lạc → HỦY); không xác nhận thì tìm tiếp', :sys),
 ('QT17.d1', 'TAO', 'QT17', 'Ra lệnh kiểm toàn kho', :sys),
 ('QT17.t2,d2,t3', 'TAO', 'QT17', 'Đếm, đối chiếu, ghi chênh lệch (kiểm toàn kho)', :sys),
 ('QT17.p2,p3,p6', 'TAO', 'QT17', 'Đếm lại lô lệch, ghi chênh lệch (kiểm điểm)', :sys),
 ('QT17.d3,p4', 'DUYET', 'QT17', 'Duyệt điều chỉnh tồn (toàn kho và kiểm điểm)', :sys),
 ('QT17.t4', 'XEM', 'QT17', 'In báo cáo gửi các bên', :sys),
 ('QT17.t1', 'XEM', 'QT17', 'Nhận thông báo kiểm kho (cột "Các bộ phận")', :sys),
 ('QT18.t1,d1', 'TAO', 'QT18', 'Kiểm tra, phát hiện hàng lỗi / hết hạn', :sys),
 ('QT18.t2', 'TAO', 'QT18', 'Tạo phiếu hủy (phần trên phiếu → KHÓA chờ hủy)', :sys),
 ('QT18.d2', 'DUYET', 'QT18', 'Xác nhận phiếu hủy', :sys),
 ('QT18.xr', 'DUYET', 'QT18', 'Từ chối phiếu hủy (lô chờ hủy → về trạng thái trước / gửi QC); lô hết hạn chỉ dời ngày hủy', :sys),
 ('QT18.xr', 'SUA', 'QT18', 'Từ chối phiếu hủy (lô chờ hủy → về trạng thái trước / gửi QC); lô hết hạn chỉ dời ngày hủy', :sys),
 ('QT18.t3', 'HUY', 'QT18', 'Hủy mẫu lưu liên quan', :sys),
 ('QT18.t4', 'HUY', 'QT18', 'Thực hiện hủy, lập biên bản (lô → HỦY)', :sys),
 ('QT18.t5', 'SUA', 'QT18', 'Ghi giá trị hàng hủy vào phiếu hủy (chỉ ghi nhận, không hạch toán)', :sys),
 ('QT19.t1,y1', 'TAO', 'QT19', 'Tạo lệnh SX trên cloud từ tab Chờ lên lệnh, hoặc lệnh sản xuất tồn kho không theo đơn (04/11), theo các điều kiện (khu, nhu cầu: 1 mã SP + dòng đơn & số lon hoặc kế hoạch tồn kho, công thức, thời gian, số mẻ & KL mẻ ≤ tối đa của khu, % hao hụt (05/11), dàn silo; tồn NVL thiếu vẫn tạo được — lệnh Chờ NVL, không giữ chỗ, không phát, 24/10 đợt 12), kế hoạch nhãn hiệu của lệnh BTP (SP có hồ sơ công bố hiệu lực, mẫu nhãn đã duyệt — 04/11) (không tạo lệnh ở server nhà máy — không vai trò nào có quyền này)', :sys),
 ('QT19.ys', 'TAO', 'QT19', 'Phương án dàn silo: nhận gợi ý xếp NVL → silo, kéo thả chỉnh, chốt khi tạo lệnh; xếp lại khi silo chuyển bảo trì / ngừng dùng', :sys),
 ('QT19.ys', 'SUA', 'QT19', 'Phương án dàn silo: nhận gợi ý xếp NVL → silo, kéo thả chỉnh, chốt khi tạo lệnh; xếp lại khi silo chuyển bảo trì / ngừng dùng', :sys),
 ('QT19.t2', 'SUA', 'QT19', 'Bổ sung / từ chối khi chưa đủ điều kiện tạo lệnh', :sys),
 ('QT19.q1', 'SUA', 'QT19', 'Hàng đợi phát lệnh của khu: đổi thứ tự ưu tiên', :sys),
 ('QT19.y2', 'DUYET', 'QT19', 'Phát lệnh đầu hàng đợi xuống server nhà máy', :sys),
 ('QT19.su', 'SUA', 'QT19', 'Sửa lệnh Mới tạo (số mẻ, KL mẻ, ngày, nhãn hiệu, dàn silo); lệnh đã phát không sửa — hủy rồi tạo lại (QT08 r2)', :sys),
 ('QT19.hl', 'HUY', 'QT19', 'Hủy lệnh chưa chạy, bắt buộc lý do, giải phóng giữ chỗ: Mới tạo / Chờ phát hủy ngay; Đã nhận chờ nhà máy xác nhận chưa chạy mẻ; nhà máy mất mạng thì chặn, thử lại khi có kết nối (04/11) (QT07 h4)', :sys),
 ('QT19.kt', 'SUA', 'QT19', 'Kết thúc sớm lệnh đang chạy (lý do, sau khi mẻ đang chạy xong): lệnh → Hoàn thành với số mẻ thực tế, giải phóng giữ chỗ còn lại, bột dư silo về kho điều phối', :sys),
 ('QT19.kr', 'SUA', 'QT19', 'Kiểm tra lại NVL trên lệnh (lệnh Chờ NVL / kho điều phối thiếu): đủ thì giữ chỗ / cho phát (24/10 đợt 11, 12)', :sys),
 ('QT19.dc,yd,d2', 'XEM', 'QT19', 'Kho điều phối thiếu NVL so với KG giữ chỗ (khi tạo / phát lệnh): hệ thống tự lập phiếu chuyển nội bộ kho tổng → kho điều phối đúng phần thiếu, vào thẳng Chờ xuất; Kế hoạch theo dõi trong màn Lệnh SX (bỏ bước Kế hoạch gửi tg — 30/10)', :sys),
 ('QT19.cb', 'SUA', 'QT19', 'Chọn cách bù phần thiếu NVL (Mua / chuyển kho liên nhà máy / lùi ngày) khi tạo lệnh và ở màn Cân đối NVL (04/11)', :sys),
 ('QT19.kp', 'XEM', 'QT19', 'Nhận báo phát lệnh không tới', :sys),
 ('QT19.kf', 'SUA', 'QT19', 'Xử lý xung đột ngoại tuyến (lệnh khóa lô tới muộn: thu hồi → hồ sơ thu hồi, khoanh vùng → QC kiểm lại; lô HỦY bị dùng → sửa SL thực hủy; tồn âm → kiểm kho)', :sys),
 ('QT19.xl', 'XEM', 'QT19', 'Xem lệnh SX và KG giữ chỗ để chuẩn bị NVL (kho điều phối) / xuất chuyển kho tổng → kho điều phối (kho tổng)', :sys),
 ('QT20.t0,t1', 'TAO', 'QT20', 'Lấy hàng theo phiếu xuất SX hệ thống tự lập khi lệnh phát sang khu (quét, giao cho khu; không lập tay — 24/10 đợt 10); không xuất SX thẳng từ kho tổng', :sys),
 ('QT20.t0,t1', 'SUA', 'QT20', 'Lấy hàng theo phiếu xuất SX hệ thống tự lập khi lệnh phát sang khu (quét, giao cho khu; không lập tay — 24/10 đợt 10); không xuất SX thẳng từ kho tổng', :sys),
 ('QT20.t2', 'SUA', 'QT20', 'Nhấn Start trên PC C#', :sys),
 ('QT20.t3,x1,t4', 'TAO', 'QT20', 'Quét QR bao nạp silo, nạp bổ sung khi silo vơi (ghi liên kết lô → silo của lệnh), trả bao sai, đổ bao', :sys),
 ('QT20.vs', 'SUA', 'QT20', 'Xác nhận silo đã xả sạch giữa lệnh (mốc tách truy xuất)', :sys),
 ('QT20.h3,b4,h6', 'SUA', 'QT20', 'Móc bột silo / bồn, khắc phục sự cố cảm biến (ghi vào hồ sơ mẻ)', :sys),
 ('QT20.ha', 'SUA', 'QT20', 'Bù / bớt bột tới đúng KL, cân lại', :sys),
 ('QT20.h9', 'TAO', 'QT20', 'Dán QR bao HH (bao → ĐẠT, không QC)', :sys),
 ('QT20.hx', 'TAO', 'QT20', 'Báo sự cố không khắc phục được', :sys),
 ('QT20.kh', 'HUY', 'QT20', 'Quyết hủy mẻ, ghi lý do, số kg bột bỏ', :sys),
 ('QT20.kb', 'SUA', 'QT20', 'Thêm 1 mẻ bù vào lệnh đang chạy', :sys),
 ('QT20.xd', 'TAO', 'QT20', 'Hết lệnh / kết thúc sớm: xả bột dư từng silo vào bao, dán QR (lô NVL dư), giao kho điều phối (nhập ở QT14)', :sys),
 ('QT20.xm', 'XEM', 'QT20', 'Xem theo dõi mẻ, tiến độ lệnh', :sys),
 ('QT21.t1', 'SUA', 'QT21', 'Mở van bướm, cấp bột xuống máy chiết', :sys),
 ('QT21.q1,xq', 'TAO', 'QT21', 'Quét lon đầu từng nhãn hiệu, đổi lon sai rồi quét lại', :sys),
 ('QT21.q1,xq', 'SUA', 'QT21', 'Quét lon đầu từng nhãn hiệu, đổi lon sai rồi quét lại', :sys),
 ('QT21.xl', 'HUY', 'QT21', 'Loại lon lệch KL, chiết bù', :sys),
 ('QT21.t2', 'SUA', 'QT21', 'Chuẩn bị thùng, lon theo nhãn hiệu', :sys),
 ('QT21.t4,dt', 'SUA', 'QT21', 'Bỏ lon vào thùng, xác định thùng đủ', :sys),
 ('QT21.tx', 'SUA', 'QT21', 'Thùng thiếu kg: mở thùng, đếm lại, bổ sung (hệ thống sửa số lon của thùng)', :sys),
 ('QT21.t7', 'TAO', 'QT21', 'Dán băng keo, dán QR thùng (ghi thùng → nhãn hiệu / lô)', :sys),
 ('QT21.t9', 'TAO', 'QT21', 'Nhận thùng về kho BTP theo phiếu nhập tự sinh, quét (lệch → Thủ kho trưởng xác nhận ở QT14)', :sys),
 ('QT21.t8', 'TAO', 'QT21', 'Lấy mẫu từng lô sau khi thùng đã nhập kho BTP', :sys),
 ('QT22.t1,t2', 'TAO', 'QT22', 'Gửi yêu cầu kiểm lô NVL nghi lỗi (ĐẠT / KHÓA → CHỜ KIỂM); bổ sung, gửi lại khi QC trưởng yêu cầu', :sys),
 ('QT22.t1,t2', 'SUA', 'QT22', 'Gửi yêu cầu kiểm lô NVL nghi lỗi (ĐẠT / KHÓA → CHỜ KIỂM); bổ sung, gửi lại khi QC trưởng yêu cầu', :sys),
 ('QT22.d1', 'DUYET', 'QT22', 'Duyệt / từ chối / yêu cầu bổ sung yêu cầu kiểm (từ chối → lô về trạng thái trước)', :sys),
 ('QT22.t3', 'TAO', 'QT22', 'Lấy 2 mẫu', :sys),
 ('QT22.g1', 'TAO', 'QT22', 'Tải file đánh giá bên ngoài, đề xuất kết luận', :sys),
 ('QT22.d2', 'DUYET', 'QT22', 'Duyệt kết luận (CHỜ KIỂM → ĐẠT / KHÔNG ĐẠT)', :sys),
 ('QT22.t4', 'XEM', 'QT22', 'Báo Mua hàng lô KHÔNG ĐẠT', :sys),
 ('QT22.ym', 'SUA', 'QT22', 'Mở lại lô NVL KHÔNG ĐẠT (lý do + file, chặn khi hết hạn)', :sys),
 ('QT22.xq', 'XEM', 'QT22', 'Xem yêu cầu kiểm và kết quả phiếu kiểm của lô mình gửi (QT22, QT23)', :sys),
 ('QT23.t1,t2', 'TAO', 'QT23', 'Gửi yêu cầu kiểm (khách trả, khoanh vùng, xung đột, hư khi nhận, tìm lại), bổ sung thông tin', :sys),
 ('QT23.t1,t2', 'SUA', 'QT23', 'Gửi yêu cầu kiểm (khách trả, khoanh vùng, xung đột, hư khi nhận, tìm lại), bổ sung thông tin', :sys),
 ('QT23.d1', 'DUYET', 'QT23', 'Duyệt / từ chối / yêu cầu bổ sung (BTP mới nhập chỉ được yêu cầu bổ sung)', :sys),
 ('QT23.t3', 'TAO', 'QT23', 'Lấy 2 mẫu', :sys),
 ('QT23.yq', 'TAO', 'QT23', 'Tải file đánh giá bên ngoài, đề xuất kết luận', :sys),
 ('QT23.d2', 'DUYET', 'QT23', 'Duyệt kết luận (BTP → TP ĐẠT / KHÔNG ĐẠT)', :sys),
 ('QT23.gk', 'DUYET', 'QT23', 'Ký phiếu chứng nhận chất lượng xuất xưởng (phiếu Chờ ký → Đã ký; ký riêng sau khi duyệt kết luận d2 — 04/11)', :sys),
 ('QT23.t4', 'XEM', 'QT23', 'Báo Kế hoạch, Kho', :sys),
 ('QT23.r1', 'TAO', 'QT23', 'Tạo lệnh mới từ NVL để bù đơn', :sys),
 ('QT23.xc', 'XEM', 'QT23', 'Xem / tải phiếu chứng nhận (gửi khách khi giao; xem ở Đơn hàng › tab Giao hàng)', :sys),
 ('QT24.t1', 'TAO', 'QT24', 'Lấy 2 mẫu', :sys),
 ('QT24.t2', 'TAO', 'QT24', 'Tạo mã mẫu lưu', :sys),
 ('QT24.t3', 'SUA', 'QT24', 'Niêm phong, lưu ở kho mẫu lưu QC (ghi nơi lưu — 04/11)', :sys),
 ('QT24.lr,np', 'SUA', 'QT24', 'Lấy mẫu ra đánh giá (lý do), niêm phong lại (kết quả đánh giá) (04/11)', :sys),
 ('QT24.sh', 'SUA', 'QT24', 'Sửa hạn lưu (lý do) (04/11)', :sys),
 ('QT24.g1', 'TAO', 'QT24', 'Thời hạn lưu mẫu: QC tự quyết, phần mềm ghi nhận', :sys),
 ('QT24.g1', 'SUA', 'QT24', 'Thời hạn lưu mẫu: QC tự quyết, phần mềm ghi nhận', :sys),
 ('QT24.d1,t4', 'HUY', 'QT24', 'Hết hạn lưu: tự hủy mẫu, lập biên bản (không cần duyệt)', :sys),
 ('QT25.t1', 'TAO', 'QT25', 'Tạo phiếu truy xuất (mã đầu vào: số lô, QR, mã đơn hàng, mã khách, mã NVL — 04/11), chạy truy xuất ngược / xuôi, xuất báo cáo (chỉ vai trò này)', :sys),
 ('QT25.t3', 'TAO', 'QT25', 'Biên bản chênh lệch cân bằng khối lượng', :sys),
 ('QT26.o1', 'TAO', 'QT26', 'Mở hồ sơ thu hồi khi có kết luận lỗi cả lô (hệ thống khóa cả lô ngay) — chỉ vai trò này', :sys),
 ('QT26.r1', 'TAO', 'QT26', 'Truy xuất lô nghi lỗi', :sys),
 ('QT26.q1', 'TAO', 'QT26', 'Đánh giá rủi ro, phạm vi, đề xuất thu hồi / khoanh vùng', :sys),
 ('QT26.d1', 'DUYET', 'QT26', 'Ký quyết định thu hồi / khoanh vùng (thu hồi → lý do khóa đổi thành "thu hồi")', :sys),
 ('QT26.t0', 'TAO', 'QT26', 'Báo cơ quan quản lý, cập nhật tiến độ', :sys),
 ('QT26.t1', 'SUA', 'QT26', 'Thông báo khách / đại lý theo danh sách truy xuất', :sys),
 ('QT26.t3', 'TAO', 'QT26', 'Đổi lô mới (đơn thay thế QT05) / đề nghị hoàn tiền (Kế toán ghi nhận ở QT10)', :sys),
 ('QT26.t3', 'DUYET', 'QT26', 'Duyệt số tiền hoàn khi thu hồi (như hủy đơn)', :sys),
 ('QT26.q3', 'TAO', 'QT26', 'Nguyên nhân gốc, hành động khắc phục (NCR / CAPA)', :sys),
 ('QT26.qa', 'DUYET', 'QT26', 'Duyệt nguyên nhân gốc, hành động khắc phục (CAPA)', :sys),
 ('QT26.gd', 'DUYET', 'QT26', 'Duyệt đóng hồ sơ thu hồi', :sys);

-- Vai trò × Thao tác: 346 dòng đúng bảng quyền (Admin chỉ quản trị + QT01.xa xem mọi màn; 19 vai trò, thêm Thủ kho điều phối 04/11) — bộ quyền mặc định, Admin sửa trên màn Vai trò × quyền
insert into role_permission (role_id, permission_id, created_by)
select r.id, p.id, :sys from (values
 ('HR', 'QT01.d0,a1', 'TAO'),
 ('ADMIN', 'QT01.d0,a1', 'TAO'),
 ('HR', 'QT01.d0,a1', 'SUA'),
 ('ADMIN', 'QT01.d0,a1', 'SUA'),
 ('ADMIN', 'QT01.a1', 'SUA'),
 ('HR', 'QT01.n1', 'SUA'),
 ('ADMIN', 'QT01.m1', 'SUA'),
 ('HR', 'QT01.u1', 'TAO'),
 ('ADMIN', 'QT01.u1', 'TAO'),
 ('ADMIN', 'QT01.#6', 'XEM'),
 ('HR', 'QT01.#6', 'XEM'),
 ('ADMIN', 'QT01.vq', 'SUA'),
 ('ADMIN', 'QT01.#8', 'SUA'),
 ('ADMIN', 'QT01.xa', 'XEM'),
 ('GIAM_DOC', 'QT01.xa', 'XEM'),
 ('HR', 'QT01.xq', 'XEM'),
 ('HR', 'QT01.xt', 'HUY'),
 ('ADMIN', 'QT01.xt', 'HUY'),
 ('GIAM_DOC', 'QT01.tq', 'XEM'),
 ('MUA_HANG', 'QT02.t1,t2', 'TAO'),
 ('KE_HOACH', 'QT02.t1,t2', 'TAO'),
 ('THU_KHO', 'QT02.t1,t2', 'TAO'),
 ('THU_KHO_DIEU_PHOI', 'QT02.t1,t2', 'TAO'),
 ('QC', 'QT02.t1,t2', 'TAO'),
 ('MUA_HANG', 'QT02.t1,t2', 'SUA'),
 ('KE_HOACH', 'QT02.t1,t2', 'SUA'),
 ('THU_KHO', 'QT02.t1,t2', 'SUA'),
 ('THU_KHO_DIEU_PHOI', 'QT02.t1,t2', 'SUA'),
 ('QC', 'QT02.t1,t2', 'SUA'),
 ('MUA_HANG', 'QT02.xo', 'HUY'),
 ('KE_HOACH', 'QT02.xo', 'HUY'),
 ('THU_KHO', 'QT02.xo', 'HUY'),
 ('THU_KHO_DIEU_PHOI', 'QT02.xo', 'HUY'),
 ('QC', 'QT02.xo', 'HUY'),
 ('QC_TRUONG', 'QT02.ml', 'DUYET'),
 ('MUA_HANG', 'QT02.t3', 'SUA'),
 ('KE_HOACH', 'QT02.t3', 'SUA'),
 ('THU_KHO', 'QT02.t3', 'SUA'),
 ('THU_KHO_DIEU_PHOI', 'QT02.t3', 'SUA'),
 ('QC', 'QT02.t3', 'SUA'),
 ('KE_HOACH', 'QT02.tk', 'HUY'),
 ('MUA_HANG', 'QT02.tg', 'TAO'),
 ('THU_KHO', 'QT02.tg', 'TAO'),
 ('THU_KHO_DIEU_PHOI', 'QT02.tg', 'TAO'),
 ('QC', 'QT02.tg', 'TAO'),
 ('MUA_HANG', 'QT02.tr', 'HUY'),
 ('THU_KHO', 'QT02.tr', 'HUY'),
 ('THU_KHO_DIEU_PHOI', 'QT02.tr', 'HUY'),
 ('QC', 'QT02.tr', 'HUY'),
 ('TRUONG_BP_MUA_HANG', 'QT02.d4', 'DUYET'),
 ('THU_KHO_TRUONG', 'QT02.d4', 'DUYET'),
 ('QC_TRUONG', 'QT02.d4', 'DUYET'),
 ('ADMIN', 'QT02.ka', 'TAO'),
 ('ADMIN', 'QT02.ka', 'SUA'),
 ('ADMIN', 'QT02.ka', 'HUY'),
 ('ADMIN', 'QT02.ks', 'TAO'),
 ('ADMIN', 'QT02.ks', 'SUA'),
 ('ADMIN', 'QT02.ks', 'HUY'),
 ('ADMIN', 'QT02.dv', 'TAO'),
 ('ADMIN', 'QT02.dv', 'SUA'),
 ('ADMIN', 'QT02.dv', 'HUY'),
 ('KE_HOACH', 'QT02.xv', 'XEM'),
 ('MUA_HANG', 'QT02.xv', 'XEM'),
 ('TRUONG_BP_MUA_HANG', 'QT02.xv', 'XEM'),
 ('THU_KHO', 'QT02.xv', 'XEM'),
 ('THU_KHO_DIEU_PHOI', 'QT02.xv', 'XEM'),
 ('THU_KHO_TRUONG', 'QT02.xv', 'XEM'),
 ('QC', 'QT02.xv', 'XEM'),
 ('QC_TRUONG', 'QT02.xv', 'XEM'),
 ('GIAM_DOC', 'QT02.hs', 'TAO'),
 ('ADMIN', 'QT02.hs', 'TAO'),
 ('GIAM_DOC', 'QT02.hs', 'SUA'),
 ('ADMIN', 'QT02.hs', 'SUA'),
 ('GIAM_DOC', 'QT02.hs', 'HUY'),
 ('ADMIN', 'QT02.hs', 'HUY'),
 ('KE_HOACH', 'QT02.xh', 'XEM'),
 ('RND', 'QT02.xh', 'XEM'),
 ('MUA_HANG', 'QT02.xh', 'XEM'),
 ('TRUONG_BP_MUA_HANG', 'QT02.xh', 'XEM'),
 ('THU_KHO_TRUONG', 'QT02.xh', 'XEM'),
 ('QC', 'QT02.xh', 'XEM'),
 ('QC_TRUONG', 'QT02.xh', 'XEM'),
 ('THU_KHO_TRUONG', 'QT02.xk', 'XEM'),
 ('RND', 'QT03.t1,t2', 'TAO'),
 ('KE_HOACH', 'QT03.t1,t2', 'TAO'),
 ('RND', 'QT03.t1,t2', 'SUA'),
 ('KE_HOACH', 'QT03.t1,t2', 'SUA'),
 ('QC', 'QT03.#2', 'XEM'),
 ('THU_KHO', 'QT04.t4,dh', 'HUY'),
 ('THU_KHO_DIEU_PHOI', 'QT04.t4,dh', 'HUY'),
 ('THU_KHO', 'QT04.t5a,t5', 'SUA'),
 ('THU_KHO_DIEU_PHOI', 'QT04.t5a,t5', 'SUA'),
 ('THU_KHO', 'QT04.t6c,t6', 'TAO'),
 ('THU_KHO_DIEU_PHOI', 'QT04.t6c,t6', 'TAO'),
 ('THU_KHO_DIEU_PHOI', 'QT04.#4', 'TAO'),
 ('THU_KHO_DIEU_PHOI', 'QT04.#4', 'SUA'),
 ('THU_KHO_DIEU_PHOI', 'QT04.#4', 'HUY'),
 ('SALES', 'QT05.t1–t3', 'TAO'),
 ('SALES', 'QT05.t1–t3', 'SUA'),
 ('SALES', 'QT05.d2', 'SUA'),
 ('SALES', 'QT05.t6', 'SUA'),
 ('SALES', 'QT05.hn', 'HUY'),
 ('CSKH', 'QT05.xk', 'XEM'),
 ('KE_TOAN', 'QT06.t4', 'TAO'),
 ('GIAM_DOC', 'QT06.t4d', 'DUYET'),
 ('KE_TOAN_TRUONG', 'QT06.t4d', 'DUYET'),
 ('SALES', 'QT06.q1,v4', 'SUA'),
 ('KE_TOAN', 'QT06.q2', 'TAO'),
 ('SALES', 'QT06.v1', 'TAO'),
 ('KE_TOAN', 'QT06.v2', 'XEM'),
 ('GIAM_DOC', 'QT06.vd1', 'DUYET'),
 ('KE_TOAN_TRUONG', 'QT06.vd1', 'DUYET'),
 ('SALES', 'QT06.v5', 'SUA'),
 ('SALES', 'QT07.t0', 'HUY'),
 ('GIAM_DOC', 'QT07.h2', 'DUYET'),
 ('KE_TOAN_TRUONG', 'QT07.h2', 'DUYET'),
 ('KE_HOACH', 'QT07.h4', 'HUY'),
 ('KE_HOACH', 'QT07.h5', 'XEM'),
 ('SALES', 'QT07.h5', 'XEM'),
 ('SALES', 'QT08.m1', 'SUA'),
 ('SALES', 'QT08.t6', 'SUA'),
 ('KE_HOACH', 'QT08.r2', 'SUA'),
 ('KE_HOACH', 'QT09.t1', 'XEM'),
 ('SALES', 'QT09.t2', 'TAO'),
 ('SALES', 'QT09.t9', 'SUA'),
 ('SALES', 'QT09.tr', 'HUY'),
 ('SALES', 'QT09.t5', 'TAO'),
 ('SALES', 'QT09.dg', 'SUA'),
 ('KE_TOAN', 'QT09.kd', 'DUYET'),
 ('KE_TOAN', 'QT10.t1', 'TAO'),
 ('KE_TOAN', 'QT10.k2', 'TAO'),
 ('KE_TOAN', 'QT10.h1', 'TAO'),
 ('KE_TOAN', 'QT10.#4', 'HUY'),
 ('SALES', 'QT10.k3', 'TAO'),
 ('KE_TOAN', 'QT10.g9', 'SUA'),
 ('SALES', 'QT10.#7', 'XEM'),
 ('KE_TOAN_TRUONG', 'QT10.#8', 'XEM'),
 ('MUA_HANG', 'QT11.t1', 'TAO'),
 ('MUA_HANG', 'QT11.d1', 'SUA'),
 ('TRUONG_BP_MUA_HANG', 'QT11.d3', 'DUYET'),
 ('MUA_HANG', 'QT11.dr', 'SUA'),
 ('TRUONG_BP_MUA_HANG', 'QT11.n1', 'HUY'),
 ('KE_HOACH', 'QT12.t1', 'TAO'),
 ('KE_HOACH', 'QT12.th', 'HUY'),
 ('THU_KHO', 'QT12.d1', 'XEM'),
 ('THU_KHO_DIEU_PHOI', 'QT12.d1', 'XEM'),
 ('MUA_HANG', 'QT12.t2', 'XEM'),
 ('MUA_HANG', 'QT12.tv', 'SUA'),
 ('MUA_HANG', 'QT12.t3,t4', 'TAO'),
 ('MUA_HANG', 'QT12.t3,t4', 'SUA'),
 ('MUA_HANG', 'QT12.ce', 'SUA'),
 ('TRUONG_BP_MUA_HANG', 'QT12.ce', 'SUA'),
 ('MUA_HANG', 'QT12.ck', 'SUA'),
 ('TRUONG_BP_MUA_HANG', 'QT12.ck', 'SUA'),
 ('MUA_HANG', 'QT12.tt', 'SUA'),
 ('TRUONG_BP_MUA_HANG', 'QT12.tt', 'SUA'),
 ('TRUONG_BP_MUA_HANG', 'QT12.d3', 'DUYET'),
 ('GIAM_DOC', 'QT12.c2', 'DUYET'),
 ('MUA_HANG', 'QT12.gp', 'SUA'),
 ('TRUONG_BP_MUA_HANG', 'QT12.gp', 'SUA'),
 ('MUA_HANG', 'QT12.hp', 'HUY'),
 ('TRUONG_BP_MUA_HANG', 'QT12.hp', 'HUY'),
 ('TRUONG_BP_MUA_HANG', 'QT12.dl', 'HUY'),
 ('KE_TOAN', 'QT12.d4,t6', 'TAO'),
 ('KE_TOAN', 'QT12.t8', 'TAO'),
 ('MUA_HANG', 'QT12.y5', 'XEM'),
 ('THU_KHO', 'QT13.t1', 'TAO'),
 ('THU_KHO_DIEU_PHOI', 'QT13.t1', 'TAO'),
 ('MUA_HANG', 'QT13.t2', 'TAO'),
 ('MUA_HANG', 'QT13.d1,d2', 'SUA'),
 ('MUA_HANG', 'QT13.n1,n2,nd', 'TAO'),
 ('MUA_HANG', 'QT13.n1,n2,nd', 'SUA'),
 ('MUA_HANG', 'QT13.tx', 'SUA'),
 ('TRUONG_BP_MUA_HANG', 'QT13.dx', 'DUYET'),
 ('THU_KHO', 'QT13.t3', 'TAO'),
 ('THU_KHO', 'QT13.t6', 'TAO'),
 ('KE_TOAN', 'QT13.t4', 'SUA'),
 ('MUA_HANG', 'QT13.t5', 'SUA'),
 ('THU_KHO', 'QT14.d0,t1', 'TAO'),
 ('THU_KHO_DIEU_PHOI', 'QT14.d0,t1', 'TAO'),
 ('THU_KHO', 'QT14.d1', 'HUY'),
 ('MUA_HANG', 'QT14.t2', 'TAO'),
 ('THU_KHO', 'QT14.l1', 'TAO'),
 ('THU_KHO', 'QT14.t3,kb', 'TAO'),
 ('THU_KHO_DIEU_PHOI', 'QT14.t3,kb', 'TAO'),
 ('KE_HOACH', 'QT14.nr', 'TAO'),
 ('THU_KHO', 'QT14.k1,k3,k6,k7', 'TAO'),
 ('THU_KHO_DIEU_PHOI', 'QT14.k1,k3,k6,k7', 'TAO'),
 ('THU_KHO', 'QT14.k1,k3,k6,k7', 'SUA'),
 ('THU_KHO_DIEU_PHOI', 'QT14.k1,k3,k6,k7', 'SUA'),
 ('THU_KHO_TRUONG', 'QT14.d4', 'DUYET'),
 ('KE_TOAN', 'QT14.t4', 'TAO'),
 ('SALES', 'QT15.s', 'TAO'),
 ('KE_HOACH', 'QT15.s', 'TAO'),
 ('THU_KHO', 'QT15.s', 'TAO'),
 ('MUA_HANG', 'QT15.s', 'TAO'),
 ('SALES', 'QT15.dq0,dq1', 'SUA'),
 ('KE_HOACH', 'QT15.dq0,dq1', 'SUA'),
 ('MUA_HANG', 'QT15.dq0,dq1', 'SUA'),
 ('SALES', 'QT15.dq0,dq1', 'HUY'),
 ('KE_HOACH', 'QT15.dq0,dq1', 'HUY'),
 ('MUA_HANG', 'QT15.dq0,dq1', 'HUY'),
 ('THU_KHO', 'QT15.t2,t3,d4', 'SUA'),
 ('THU_KHO_DIEU_PHOI', 'QT15.t2,t3,d4', 'SUA'),
 ('THU_KHO', 'QT15.t4', 'HUY'),
 ('THU_KHO_DIEU_PHOI', 'QT15.t4', 'HUY'),
 ('SALES', 'QT15.xt', 'XEM'),
 ('KE_HOACH', 'QT15.xt', 'XEM'),
 ('MUA_HANG', 'QT15.xt', 'XEM'),
 ('KE_TOAN', 'QT15.xt', 'XEM'),
 ('THU_KHO_TRUONG', 'QT15.xt', 'XEM'),
 ('THU_KHO_TRUONG', 'QT15.xp', 'XEM'),
 ('KE_HOACH', 'QT16.s,y0', 'TAO'),
 ('KE_HOACH', 'QT16.s,y0', 'HUY'),
 ('KE_HOACH', 'QT16.yl', 'TAO'),
 ('KE_HOACH', 'QT16.yl', 'HUY'),
 ('KE_HOACH', 'QT16.yn', 'TAO'),
 ('THU_KHO_DIEU_PHOI', 'QT16.yn', 'TAO'),
 ('THU_KHO', 'QT16.r1,g1', 'TAO'),
 ('THU_KHO', 'QT16.kx', 'HUY'),
 ('VAN_CHUYEN', 'QT16.t1', 'SUA'),
 ('THU_KHO', 'QT16.d3,t3,d4', 'SUA'),
 ('THU_KHO_DIEU_PHOI', 'QT16.d3,t3,d4', 'SUA'),
 ('THU_KHO', 'QT16.t4', 'TAO'),
 ('THU_KHO_DIEU_PHOI', 'QT16.t4', 'TAO'),
 ('THU_KHO_TRUONG', 'QT16.t4', 'DUYET'),
 ('KE_HOACH', 'QT16.t2', 'SUA'),
 ('KE_HOACH', 'QT16.g3', 'TAO'),
 ('THU_KHO_TRUONG', 'QT16.gx', 'DUYET'),
 ('THU_KHO_TRUONG', 'QT17.d1', 'TAO'),
 ('THU_KHO', 'QT17.t2,d2,t3', 'TAO'),
 ('THU_KHO_DIEU_PHOI', 'QT17.t2,d2,t3', 'TAO'),
 ('THU_KHO', 'QT17.p2,p3,p6', 'TAO'),
 ('THU_KHO_DIEU_PHOI', 'QT17.p2,p3,p6', 'TAO'),
 ('THU_KHO_TRUONG', 'QT17.d3,p4', 'DUYET'),
 ('THU_KHO', 'QT17.t4', 'XEM'),
 ('THU_KHO_DIEU_PHOI', 'QT17.t4', 'XEM'),
 ('THU_KHO', 'QT17.t1', 'XEM'),
 ('THU_KHO_DIEU_PHOI', 'QT17.t1', 'XEM'),
 ('THU_KHO_TRUONG', 'QT17.t1', 'XEM'),
 ('THU_KHO', 'QT18.t1,d1', 'TAO'),
 ('THU_KHO_DIEU_PHOI', 'QT18.t1,d1', 'TAO'),
 ('THU_KHO', 'QT18.t2', 'TAO'),
 ('THU_KHO_DIEU_PHOI', 'QT18.t2', 'TAO'),
 ('THU_KHO_TRUONG', 'QT18.d2', 'DUYET'),
 ('THU_KHO_TRUONG', 'QT18.xr', 'DUYET'),
 ('THU_KHO_TRUONG', 'QT18.xr', 'SUA'),
 ('QC', 'QT18.t3', 'HUY'),
 ('THU_KHO', 'QT18.t4', 'HUY'),
 ('THU_KHO_DIEU_PHOI', 'QT18.t4', 'HUY'),
 ('KE_TOAN', 'QT18.t5', 'SUA'),
 ('KE_HOACH', 'QT19.t1,y1', 'TAO'),
 ('KE_HOACH', 'QT19.ys', 'TAO'),
 ('KE_HOACH', 'QT19.ys', 'SUA'),
 ('KE_HOACH', 'QT19.t2', 'SUA'),
 ('KE_HOACH', 'QT19.q1', 'SUA'),
 ('KE_HOACH', 'QT19.y2', 'DUYET'),
 ('KE_HOACH', 'QT19.su', 'SUA'),
 ('KE_HOACH', 'QT19.hl', 'HUY'),
 ('KE_HOACH', 'QT19.kt', 'SUA'),
 ('KE_HOACH', 'QT19.kr', 'SUA'),
 ('KE_HOACH', 'QT19.dc,yd,d2', 'XEM'),
 ('KE_HOACH', 'QT19.cb', 'SUA'),
 ('KE_HOACH', 'QT19.kp', 'XEM'),
 ('KE_HOACH', 'QT19.kf', 'SUA'),
 ('QC', 'QT19.kf', 'SUA'),
 ('THU_KHO', 'QT19.xl', 'XEM'),
 ('THU_KHO_DIEU_PHOI', 'QT19.xl', 'XEM'),
 ('THU_KHO_DIEU_PHOI', 'QT20.t0,t1', 'TAO'),
 ('THU_KHO_DIEU_PHOI', 'QT20.t0,t1', 'SUA'),
 ('CONG_NHAN', 'QT20.t2', 'SUA'),
 ('CONG_NHAN', 'QT20.t3,x1,t4', 'TAO'),
 ('CONG_NHAN', 'QT20.vs', 'SUA'),
 ('CONG_NHAN', 'QT20.h3,b4,h6', 'SUA'),
 ('CONG_NHAN', 'QT20.ha', 'SUA'),
 ('CONG_NHAN', 'QT20.h9', 'TAO'),
 ('CONG_NHAN', 'QT20.hx', 'TAO'),
 ('KE_HOACH', 'QT20.kh', 'HUY'),
 ('KE_HOACH', 'QT20.kb', 'SUA'),
 ('CONG_NHAN', 'QT20.xd', 'TAO'),
 ('QC', 'QT20.xm', 'XEM'),
 ('CONG_NHAN', 'QT21.t1', 'SUA'),
 ('CONG_NHAN', 'QT21.q1,xq', 'TAO'),
 ('CONG_NHAN', 'QT21.q1,xq', 'SUA'),
 ('CONG_NHAN', 'QT21.xl', 'HUY'),
 ('CONG_NHAN', 'QT21.t2', 'SUA'),
 ('CONG_NHAN', 'QT21.t4,dt', 'SUA'),
 ('CONG_NHAN', 'QT21.tx', 'SUA'),
 ('CONG_NHAN', 'QT21.t7', 'TAO'),
 ('THU_KHO', 'QT21.t9', 'TAO'),
 ('QC', 'QT21.t8', 'TAO'),
 ('THU_KHO', 'QT22.t1,t2', 'TAO'),
 ('THU_KHO_DIEU_PHOI', 'QT22.t1,t2', 'TAO'),
 ('KE_HOACH', 'QT22.t1,t2', 'TAO'),
 ('THU_KHO', 'QT22.t1,t2', 'SUA'),
 ('THU_KHO_DIEU_PHOI', 'QT22.t1,t2', 'SUA'),
 ('KE_HOACH', 'QT22.t1,t2', 'SUA'),
 ('QC_TRUONG', 'QT22.d1', 'DUYET'),
 ('QC', 'QT22.t3', 'TAO'),
 ('QC', 'QT22.g1', 'TAO'),
 ('QC_TRUONG', 'QT22.d2', 'DUYET'),
 ('QC_TRUONG', 'QT22.t4', 'XEM'),
 ('QC_TRUONG', 'QT22.ym', 'SUA'),
 ('THU_KHO', 'QT22.xq', 'XEM'),
 ('THU_KHO_DIEU_PHOI', 'QT22.xq', 'XEM'),
 ('THU_KHO_TRUONG', 'QT22.xq', 'XEM'),
 ('KE_HOACH', 'QT22.xq', 'XEM'),
 ('THU_KHO', 'QT23.t1,t2', 'TAO'),
 ('THU_KHO_DIEU_PHOI', 'QT23.t1,t2', 'TAO'),
 ('KE_HOACH', 'QT23.t1,t2', 'TAO'),
 ('THU_KHO', 'QT23.t1,t2', 'SUA'),
 ('THU_KHO_DIEU_PHOI', 'QT23.t1,t2', 'SUA'),
 ('KE_HOACH', 'QT23.t1,t2', 'SUA'),
 ('QC_TRUONG', 'QT23.d1', 'DUYET'),
 ('QC', 'QT23.t3', 'TAO'),
 ('QC', 'QT23.yq', 'TAO'),
 ('QC_TRUONG', 'QT23.d2', 'DUYET'),
 ('QC_TRUONG', 'QT23.gk', 'DUYET'),
 ('QC_TRUONG', 'QT23.t4', 'XEM'),
 ('KE_HOACH', 'QT23.r1', 'TAO'),
 ('SALES', 'QT23.xc', 'XEM'),
 ('KE_HOACH', 'QT23.xc', 'XEM'),
 ('QC', 'QT23.xc', 'XEM'),
 ('QC', 'QT24.t1', 'TAO'),
 ('QC', 'QT24.t2', 'TAO'),
 ('QC', 'QT24.t3', 'SUA'),
 ('QC', 'QT24.lr,np', 'SUA'),
 ('QC', 'QT24.sh', 'SUA'),
 ('QC', 'QT24.g1', 'TAO'),
 ('QC', 'QT24.g1', 'SUA'),
 ('QC', 'QT24.d1,t4', 'HUY'),
 ('NGUOI_TRUY_XUAT', 'QT25.t1', 'TAO'),
 ('THU_KHO', 'QT25.t3', 'TAO'),
 ('THU_KHO_DIEU_PHOI', 'QT25.t3', 'TAO'),
 ('QC_TRUONG', 'QT26.o1', 'TAO'),
 ('NGUOI_TRUY_XUAT', 'QT26.r1', 'TAO'),
 ('QC_TRUONG', 'QT26.q1', 'TAO'),
 ('GIAM_DOC', 'QT26.d1', 'DUYET'),
 ('QC_TRUONG', 'QT26.t0', 'TAO'),
 ('CSKH', 'QT26.t1', 'SUA'),
 ('SALES', 'QT26.t3', 'TAO'),
 ('GIAM_DOC', 'QT26.t3', 'DUYET'),
 ('KE_TOAN_TRUONG', 'QT26.t3', 'DUYET'),
 ('QC', 'QT26.q3', 'TAO'),
 ('QC_TRUONG', 'QT26.qa', 'DUYET'),
 ('GIAM_DOC', 'QT26.gd', 'DUYET')
) v(role_code, function_code, action)
join role r on r.code = v.role_code
join permission p on p.function_code = v.function_code and p.action = v.action;

-- 37 màn của menu web và 261 dòng màn × chức năng (mục "Màn × chức năng" của file quy trình; sinh lại 04/11 theo menu mockup).
-- Màn hiện khi vai trò có ít nhất 1 quyền ở chức năng của màn; QT01.xa (Admin · Giám đốc xem mọi màn) có ở mọi màn trừ Việc cần làm, Hồ sơ & biểu mẫu in (hai màn này hiện cho mọi người dùng).
insert into screen (code, module, name, sort_order, always_visible, created_by) values
 ('TONG_QUAN', 'TONG_QUAN', 'Tổng quan Giám đốc', 5, false, :sys),
 ('VIEC_CAN_LAM', 'VIEC_CAN_LAM', 'Việc cần làm', 10, true, :sys),
 ('BAN_DON_HANG', 'BAN_HANG', 'Đơn hàng', 20, false, :sys),
 ('BAN_KHACH_HANG', 'BAN_HANG', 'Khách hàng', 30, false, :sys),
 ('MUA_DON_MUA', 'MUA_HANG', 'Đơn mua', 50, false, :sys),
 ('MUA_NCC', 'MUA_HANG', 'Nhà cung cấp', 60, false, :sys),
 ('MUA_TRA_HANG', 'MUA_HANG', 'Trả hàng nhà cung cấp', 70, false, :sys),
 ('KT_CONG_NO_KH', 'KE_TOAN', 'Công nợ khách hàng', 80, false, :sys),
 ('KT_CONG_NO_NCC', 'KE_TOAN', 'Công nợ nhà cung cấp', 90, false, :sys),
 ('KT_SO_THU_CHI', 'KE_TOAN', 'Sổ thu chi', 100, false, :sys),
 ('KHO_TON', 'KHO', 'Tồn kho', 110, false, :sys),
 ('KHO_NHAP', 'KHO', 'Nhập kho', 120, false, :sys),
 ('KHO_XUAT', 'KHO', 'Xuất kho', 130, false, :sys),
 ('KHO_CHUYEN', 'KHO', 'Chuyển kho', 140, false, :sys),
 ('KHO_KIEM', 'KHO', 'Kiểm kho', 150, false, :sys),
 ('KHO_HUY', 'KHO', 'Hủy hàng', 160, false, :sys),
 ('SX_LENH', 'SAN_XUAT', 'Lệnh sản xuất', 170, false, :sys),
 ('SX_THEO_DOI_ME', 'SAN_XUAT', 'Theo dõi mẻ', 180, false, :sys),
 ('CL_YEU_CAU_KIEM', 'CHAT_LUONG', 'Yêu cầu kiểm', 200, false, :sys),
 ('CL_PHIEU_KIEM', 'CHAT_LUONG', 'Phiếu kiểm', 210, false, :sys),
 ('CL_PHIEU_CHUNG_NHAN', 'CHAT_LUONG', 'Phiếu chứng nhận', 220, false, :sys),
 ('CL_MAU_LUU', 'CHAT_LUONG', 'Mẫu lưu', 230, false, :sys),
 ('TX_TRUY_XUAT', 'TRUY_XUAT_THU_HOI', 'Truy xuất', 240, false, :sys),
 ('TX_THU_HOI', 'TRUY_XUAT_THU_HOI', 'Hồ sơ thu hồi', 250, false, :sys),
 ('HO_SO_BIEU_MAU', 'HO_SO_BIEU_MAU', 'Hồ sơ & biểu mẫu in', 255, true, :sys),
 ('DM_NVL', 'DANH_MUC', 'Nguyên vật liệu', 260, false, :sys),
 ('DM_CONG_THUC', 'DANH_MUC', 'Công thức', 265, false, :sys),
 ('DM_SAN_PHAM', 'DANH_MUC', 'Sản phẩm', 270, false, :sys),
 ('DM_DON_VI', 'DANH_MUC', 'Đơn vị', 275, false, :sys),
 ('DM_NHA_MAY', 'DANH_MUC', 'Nhà máy', 280, false, :sys),
 ('DM_KHO', 'DANH_MUC', 'Nhà máy › Kho', 285, false, :sys),
 ('DM_KHU_VUC', 'DANH_MUC', 'Nhà máy › Khu vực làm việc & dàn silo', 290, false, :sys),
 ('DM_HO_SO_PHAP_LY', 'DANH_MUC', 'Hồ sơ pháp lý chung', 295, false, :sys),
 ('QT_NGUOI_DUNG', 'QUAN_TRI', 'Người dùng & vai trò', 310, false, :sys),
 ('QT_THAM_SO', 'QUAN_TRI', 'Tham số & định dạng mã', 330, false, :sys),
 ('QT_NHAT_KY', 'QUAN_TRI', 'Nhật ký hệ thống', 340, false, :sys);
insert into screen_function (screen_id, function_code, created_by)
select s.id, v.function_code, :sys from (values
 ('TONG_QUAN', 'QT01.tq'),
 ('TONG_QUAN', 'QT01.xa'),
 ('BAN_DON_HANG', 'QT05.t1–t3'),
 ('BAN_DON_HANG', 'QT05.d2'),
 ('BAN_DON_HANG', 'QT05.t6'),
 ('BAN_DON_HANG', 'QT05.hn'),
 ('BAN_DON_HANG', 'QT06.t4'),
 ('BAN_DON_HANG', 'QT06.t4d'),
 ('BAN_DON_HANG', 'QT06.q1,v4'),
 ('BAN_DON_HANG', 'QT06.v1'),
 ('BAN_DON_HANG', 'QT06.vd1'),
 ('BAN_DON_HANG', 'QT06.v5'),
 ('BAN_DON_HANG', 'QT07.t0'),
 ('BAN_DON_HANG', 'QT07.h2'),
 ('BAN_DON_HANG', 'QT07.h4'),
 ('BAN_DON_HANG', 'QT07.h5'),
 ('BAN_DON_HANG', 'QT08.m1'),
 ('BAN_DON_HANG', 'QT08.t6'),
 ('BAN_DON_HANG', 'QT08.r2'),
 ('BAN_DON_HANG', 'QT09.t1'),
 ('BAN_DON_HANG', 'QT09.t2'),
 ('BAN_DON_HANG', 'QT09.kd'),
 ('BAN_DON_HANG', 'QT09.t9'),
 ('BAN_DON_HANG', 'QT09.tr'),
 ('BAN_DON_HANG', 'QT09.t5'),
 ('BAN_DON_HANG', 'QT09.dg'),
 ('BAN_DON_HANG', 'QT10.t1'),
 ('BAN_DON_HANG', 'QT01.xa'),
 ('BAN_KHACH_HANG', 'QT05.t1–t3'),
 ('BAN_KHACH_HANG', 'QT05.xk'),
 ('BAN_KHACH_HANG', 'QT10.k3'),
 ('BAN_KHACH_HANG', 'QT01.xa'),
 ('MUA_DON_MUA', 'QT12.t1'),
 ('MUA_DON_MUA', 'QT12.th'),
 ('MUA_DON_MUA', 'QT12.d1'),
 ('MUA_DON_MUA', 'QT12.t2'),
 ('MUA_DON_MUA', 'QT12.tv'),
 ('MUA_DON_MUA', 'QT12.t3,t4'),
 ('MUA_DON_MUA', 'QT12.ce'),
 ('MUA_DON_MUA', 'QT12.ck'),
 ('MUA_DON_MUA', 'QT12.tt'),
 ('MUA_DON_MUA', 'QT12.d3'),
 ('MUA_DON_MUA', 'QT12.c2'),
 ('MUA_DON_MUA', 'QT12.gp'),
 ('MUA_DON_MUA', 'QT12.hp'),
 ('MUA_DON_MUA', 'QT12.dl'),
 ('MUA_DON_MUA', 'QT12.y5'),
 ('MUA_DON_MUA', 'QT01.xa'),
 ('MUA_NCC', 'QT11.t1'),
 ('MUA_NCC', 'QT11.d1'),
 ('MUA_NCC', 'QT11.d3'),
 ('MUA_NCC', 'QT11.dr'),
 ('MUA_NCC', 'QT11.n1'),
 ('MUA_NCC', 'QT01.xa'),
 ('MUA_TRA_HANG', 'QT13.t1'),
 ('MUA_TRA_HANG', 'QT13.t2'),
 ('MUA_TRA_HANG', 'QT13.d1,d2'),
 ('MUA_TRA_HANG', 'QT13.n1,n2,nd'),
 ('MUA_TRA_HANG', 'QT13.tx'),
 ('MUA_TRA_HANG', 'QT13.dx'),
 ('MUA_TRA_HANG', 'QT13.t3'),
 ('MUA_TRA_HANG', 'QT13.t6'),
 ('MUA_TRA_HANG', 'QT13.t5'),
 ('MUA_TRA_HANG', 'QT01.xa'),
 ('KT_CONG_NO_KH', 'QT06.q2'),
 ('KT_CONG_NO_KH', 'QT06.v2'),
 ('KT_CONG_NO_KH', 'QT10.k2'),
 ('KT_CONG_NO_KH', 'QT10.h1'),
 ('KT_CONG_NO_KH', 'QT10.#4'),
 ('KT_CONG_NO_KH', 'QT10.k3'),
 ('KT_CONG_NO_KH', 'QT10.g9'),
 ('KT_CONG_NO_KH', 'QT10.#7'),
 ('KT_CONG_NO_KH', 'QT10.#8'),
 ('KT_CONG_NO_KH', 'QT01.xa'),
 ('KT_CONG_NO_NCC', 'QT12.d4,t6'),
 ('KT_CONG_NO_NCC', 'QT12.t8'),
 ('KT_CONG_NO_NCC', 'QT13.t4'),
 ('KT_CONG_NO_NCC', 'QT10.#8'),
 ('KT_CONG_NO_NCC', 'QT01.xa'),
 ('KT_SO_THU_CHI', 'QT10.k2'),
 ('KT_SO_THU_CHI', 'QT10.h1'),
 ('KT_SO_THU_CHI', 'QT10.#4'),
 ('KT_SO_THU_CHI', 'QT10.#8'),
 ('KT_SO_THU_CHI', 'QT12.d4,t6'),
 ('KT_SO_THU_CHI', 'QT12.t8'),
 ('KT_SO_THU_CHI', 'QT01.xa'),
 ('KHO_TON', 'QT04.t4,dh'),
 ('KHO_TON', 'QT04.t5a,t5'),
 ('KHO_TON', 'QT04.t6c,t6'),
 ('KHO_TON', 'QT04.#4'),
 ('KHO_TON', 'QT12.d1'),
 ('KHO_TON', 'QT15.xt'),
 ('KHO_TON', 'QT17.t1'),
 ('KHO_TON', 'QT01.xa'),
 ('KHO_NHAP', 'QT14.d0,t1'),
 ('KHO_NHAP', 'QT14.d1'),
 ('KHO_NHAP', 'QT14.t2'),
 ('KHO_NHAP', 'QT14.l1'),
 ('KHO_NHAP', 'QT14.t3,kb'),
 ('KHO_NHAP', 'QT14.nr'),
 ('KHO_NHAP', 'QT14.k1,k3,k6,k7'),
 ('KHO_NHAP', 'QT14.d4'),
 ('KHO_NHAP', 'QT14.t4'),
 ('KHO_NHAP', 'QT13.t6'),
 ('KHO_NHAP', 'QT21.t9'),
 ('KHO_NHAP', 'QT01.xa'),
 ('KHO_XUAT', 'QT15.s'),
 ('KHO_XUAT', 'QT15.dq0,dq1'),
 ('KHO_XUAT', 'QT15.t2,t3,d4'),
 ('KHO_XUAT', 'QT15.t4'),
 ('KHO_XUAT', 'QT15.xp'),
 ('KHO_XUAT', 'QT13.t3'),
 ('KHO_XUAT', 'QT20.t0,t1'),
 ('KHO_XUAT', 'QT01.xa'),
 ('KHO_CHUYEN', 'QT16.s,y0'),
 ('KHO_CHUYEN', 'QT16.yl'),
 ('KHO_CHUYEN', 'QT16.yn'),
 ('KHO_CHUYEN', 'QT16.r1,g1'),
 ('KHO_CHUYEN', 'QT16.kx'),
 ('KHO_CHUYEN', 'QT16.t1'),
 ('KHO_CHUYEN', 'QT16.d3,t3,d4'),
 ('KHO_CHUYEN', 'QT16.t4'),
 ('KHO_CHUYEN', 'QT16.t2'),
 ('KHO_CHUYEN', 'QT16.g3'),
 ('KHO_CHUYEN', 'QT16.gx'),
 ('KHO_CHUYEN', 'QT01.xa'),
 ('KHO_KIEM', 'QT17.d1'),
 ('KHO_KIEM', 'QT17.t2,d2,t3'),
 ('KHO_KIEM', 'QT17.p2,p3,p6'),
 ('KHO_KIEM', 'QT17.d3,p4'),
 ('KHO_KIEM', 'QT17.t4'),
 ('KHO_KIEM', 'QT01.xa'),
 ('KHO_HUY', 'QT18.t1,d1'),
 ('KHO_HUY', 'QT18.t2'),
 ('KHO_HUY', 'QT18.d2'),
 ('KHO_HUY', 'QT18.xr'),
 ('KHO_HUY', 'QT18.t3'),
 ('KHO_HUY', 'QT18.t4'),
 ('KHO_HUY', 'QT18.t5'),
 ('KHO_HUY', 'QT07.h5'),
 ('KHO_HUY', 'QT01.xa'),
 ('SX_LENH', 'QT19.t1,y1'),
 ('SX_LENH', 'QT19.ys'),
 ('SX_LENH', 'QT19.t2'),
 ('SX_LENH', 'QT19.q1'),
 ('SX_LENH', 'QT19.y2'),
 ('SX_LENH', 'QT19.su'),
 ('SX_LENH', 'QT19.hl'),
 ('SX_LENH', 'QT19.kt'),
 ('SX_LENH', 'QT19.kr'),
 ('SX_LENH', 'QT19.dc,yd,d2'),
 ('SX_LENH', 'QT19.cb'),
 ('SX_LENH', 'QT19.kp'),
 ('SX_LENH', 'QT19.kf'),
 ('SX_LENH', 'QT19.xl'),
 ('SX_LENH', 'QT07.h4'),
 ('SX_LENH', 'QT08.r2'),
 ('SX_LENH', 'QT23.r1'),
 ('SX_LENH', 'QT01.xa'),
 ('SX_THEO_DOI_ME', 'QT20.kh'),
 ('SX_THEO_DOI_ME', 'QT20.kb'),
 ('SX_THEO_DOI_ME', 'QT20.xm'),
 ('SX_THEO_DOI_ME', 'QT20.t0,t1'),
 ('SX_THEO_DOI_ME', 'QT01.xa'),
 ('CL_YEU_CAU_KIEM', 'QT22.t1,t2'),
 ('CL_YEU_CAU_KIEM', 'QT22.d1'),
 ('CL_YEU_CAU_KIEM', 'QT22.t3'),
 ('CL_YEU_CAU_KIEM', 'QT22.xq'),
 ('CL_YEU_CAU_KIEM', 'QT23.t1,t2'),
 ('CL_YEU_CAU_KIEM', 'QT23.d1'),
 ('CL_YEU_CAU_KIEM', 'QT23.t3'),
 ('CL_YEU_CAU_KIEM', 'QT01.xa'),
 ('CL_PHIEU_KIEM', 'QT22.t3'),
 ('CL_PHIEU_KIEM', 'QT22.g1'),
 ('CL_PHIEU_KIEM', 'QT22.d2'),
 ('CL_PHIEU_KIEM', 'QT22.t4'),
 ('CL_PHIEU_KIEM', 'QT22.ym'),
 ('CL_PHIEU_KIEM', 'QT22.xq'),
 ('CL_PHIEU_KIEM', 'QT23.t3'),
 ('CL_PHIEU_KIEM', 'QT23.yq'),
 ('CL_PHIEU_KIEM', 'QT23.d2'),
 ('CL_PHIEU_KIEM', 'QT23.t4'),
 ('CL_PHIEU_KIEM', 'QT21.t8'),
 ('CL_PHIEU_KIEM', 'QT01.xa'),
 ('CL_PHIEU_CHUNG_NHAN', 'QT23.gk'),
 ('CL_PHIEU_CHUNG_NHAN', 'QT23.xc'),
 ('CL_PHIEU_CHUNG_NHAN', 'QT01.xa'),
 ('CL_MAU_LUU', 'QT24.t1'),
 ('CL_MAU_LUU', 'QT24.t2'),
 ('CL_MAU_LUU', 'QT24.t3'),
 ('CL_MAU_LUU', 'QT24.lr,np'),
 ('CL_MAU_LUU', 'QT24.sh'),
 ('CL_MAU_LUU', 'QT24.g1'),
 ('CL_MAU_LUU', 'QT24.d1,t4'),
 ('CL_MAU_LUU', 'QT18.t3'),
 ('CL_MAU_LUU', 'QT01.xa'),
 ('TX_TRUY_XUAT', 'QT25.t1'),
 ('TX_TRUY_XUAT', 'QT25.t3'),
 ('TX_TRUY_XUAT', 'QT01.xa'),
 ('TX_THU_HOI', 'QT26.o1'),
 ('TX_THU_HOI', 'QT26.r1'),
 ('TX_THU_HOI', 'QT26.q1'),
 ('TX_THU_HOI', 'QT26.d1'),
 ('TX_THU_HOI', 'QT26.t0'),
 ('TX_THU_HOI', 'QT26.t1'),
 ('TX_THU_HOI', 'QT26.t3'),
 ('TX_THU_HOI', 'QT26.q3'),
 ('TX_THU_HOI', 'QT26.qa'),
 ('TX_THU_HOI', 'QT26.gd'),
 ('TX_THU_HOI', 'QT01.xa'),
 ('DM_NVL', 'QT02.t1,t2'),
 ('DM_NVL', 'QT02.t3'),
 ('DM_NVL', 'QT02.tk'),
 ('DM_NVL', 'QT02.tg'),
 ('DM_NVL', 'QT02.tr'),
 ('DM_NVL', 'QT02.d4'),
 ('DM_NVL', 'QT01.xa'),
 ('DM_CONG_THUC', 'QT03.t1,t2'),
 ('DM_CONG_THUC', 'QT03.#2'),
 ('DM_CONG_THUC', 'QT01.xa'),
 ('DM_SAN_PHAM', 'QT02.t1,t2'),
 ('DM_SAN_PHAM', 'QT02.xo'),
 ('DM_SAN_PHAM', 'QT02.ml'),
 ('DM_SAN_PHAM', 'QT02.t3'),
 ('DM_SAN_PHAM', 'QT02.tk'),
 ('DM_SAN_PHAM', 'QT02.tg'),
 ('DM_SAN_PHAM', 'QT02.tr'),
 ('DM_SAN_PHAM', 'QT02.d4'),
 ('DM_SAN_PHAM', 'QT01.xa'),
 ('DM_DON_VI', 'QT02.dv'),
 ('DM_DON_VI', 'QT02.xv'),
 ('DM_DON_VI', 'QT01.xa'),
 ('DM_NHA_MAY', 'QT02.ka'),
 ('DM_NHA_MAY', 'QT02.xk'),
 ('DM_NHA_MAY', 'QT01.xa'),
 ('DM_KHO', 'QT02.ka'),
 ('DM_KHO', 'QT02.xk'),
 ('DM_KHO', 'QT01.xa'),
 ('DM_KHU_VUC', 'QT02.ka'),
 ('DM_KHU_VUC', 'QT02.ks'),
 ('DM_KHU_VUC', 'QT01.xa'),
 ('DM_HO_SO_PHAP_LY', 'QT02.hs'),
 ('DM_HO_SO_PHAP_LY', 'QT02.xh'),
 ('DM_HO_SO_PHAP_LY', 'QT01.xa'),
 ('QT_NGUOI_DUNG', 'QT01.d0,a1'),
 ('QT_NGUOI_DUNG', 'QT01.a1'),
 ('QT_NGUOI_DUNG', 'QT01.n1'),
 ('QT_NGUOI_DUNG', 'QT01.m1'),
 ('QT_NGUOI_DUNG', 'QT01.u1'),
 ('QT_NGUOI_DUNG', 'QT01.vq'),
 ('QT_NGUOI_DUNG', 'QT01.xq'),
 ('QT_NGUOI_DUNG', 'QT01.xt'),
 ('QT_NGUOI_DUNG', 'QT01.xa'),
 ('QT_THAM_SO', 'QT01.#8'),
 ('QT_THAM_SO', 'QT01.xa'),
 ('QT_NHAT_KY', 'QT01.#6'),
 ('QT_NHAT_KY', 'QT01.xa')
) v(screen_code, function_code)
join screen s on s.code = v.screen_code;

-- Nhóm đồng bộ từng bảng (sync_policy — 20/10 đợt 2): 140 bảng (04/11), sinh từ cột Nơi của mô hình bảng (mes-powder-gen-du-lieu.py).
insert into sync_policy (table_name, owner_group, factory_column, derived_columns, masked_columns, note, created_by) values
 ('factory', 'CLOUD', null, '{}', '{}', 'cloud là chủ → sao xuống mọi server nhà máy', :sys),
 ('work_area', 'CLOUD', 'factory_id', '{}', '{}', 'cloud chủ → sao xuống nhà máy đó', :sys),
 ('app_user', 'CLOUD', null, '{}', '{}', 'cloud chủ → sao xuống nhà máy (tài khoản có phạm vi nhà máy đó) để đăng nhập quét thẻ khi mất kết nối', :sys),
 ('role', 'CLOUD', null, '{}', '{}', 'cloud chủ → nhà máy', :sys),
 ('permission', 'CLOUD', null, '{}', '{}', 'cloud chủ → nhà máy', :sys),
 ('role_permission', 'CLOUD', null, '{}', '{}', 'cloud chủ → nhà máy', :sys),
 ('user_permission', 'CLOUD', null, '{}', '{}', 'cloud chủ → nhà máy', :sys),
 ('screen', 'CLOUD', null, '{}', '{}', 'cloud chủ → nhà máy', :sys),
 ('screen_function', 'CLOUD', null, '{}', '{}', 'cloud chủ → nhà máy', :sys),
 ('user_role', 'CLOUD', 'factory_id', '{}', '{}', 'cloud chủ → nhà máy', :sys),
 ('user_delegation', 'CLOUD', 'factory_id', '{}', '{}', 'cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc', :sys),
 ('job_title_role', 'CLOUD_ONLY', null, '{}', '{}', 'chỉ cloud', :sys),
 ('user_session', 'NOI_PHAT_SINH', 'factory_id', '{}', '{}', 'nơi tạo dòng là chủ; dòng tạo ở máy chủ nhà máy gộp lên cloud qua sync_outbox', :sys),
 ('account_change_log', 'CLOUD_ONLY', null, '{}', '{}', 'chỉ cloud', :sys),
 ('audit_log', 'NOI_PHAT_SINH', 'factory_id', '{}', '{}', 'nơi tạo dòng là chủ; dòng tạo ở máy chủ nhà máy gộp lên cloud qua sync_outbox', :sys),
 ('system_parameter', 'CLOUD', 'factory_id', '{}', '{}', 'cloud chủ → nhà máy (tham số ngoại tuyến, hạn tối thiểu cho SX…)', :sys),
 ('uom', 'CLOUD', null, '{}', '{}', 'cloud chủ → nhà máy', :sys),
 ('material', 'CLOUD', null, '{}', '{}', 'cloud chủ → nhà máy', :sys),
 ('material_spec_item', 'CLOUD', null, '{}', '{}', 'cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc', :sys),
 ('product', 'CLOUD', null, '{}', '{}', 'cloud chủ → nhà máy', :sys),
 ('product_option', 'CLOUD', null, '{}', '{}', 'cloud chủ → nhà máy', :sys),
 ('material_pack', 'CLOUD', null, '{}', '{}', 'cloud chủ → nhà máy', :sys),
 ('material_pack_level', 'CLOUD', null, '{}', '{}', 'cloud chủ → nhà máy', :sys),
 ('product_pack', 'CLOUD', null, '{}', '{}', 'cloud chủ → nhà máy', :sys),
 ('product_pack_level', 'CLOUD', null, '{}', '{}', 'cloud chủ → nhà máy', :sys),
 ('product_label', 'CLOUD', null, '{}', '{}', 'cloud chủ → nhà máy', :sys),
 ('product_document', 'CLOUD', null, '{}', '{}', 'cloud chủ → nhà máy', :sys),
 ('legal_document', 'CLOUD', null, '{}', '{}', 'cloud chủ → nhà máy', :sys),
 ('legal_document_scope', 'CLOUD', 'factory_id', '{}', '{}', 'cloud chủ → nhà máy', :sys),
 ('warehouse', 'CLOUD', 'factory_id', '{}', '{}', 'cloud chủ → nhà máy đó', :sys),
 ('equipment', 'CLOUD', 'factory_id', '{}', '{}', 'cloud chủ → nhà máy đó (silo đi kèm phương án silo của lệnh)', :sys),
 ('formula', 'CLOUD', null, '{}', '{}', 'cloud chủ → nhà máy', :sys),
 ('formula_version', 'CLOUD', null, '{}', '{}', 'cloud chủ → nhà máy (gửi kèm lệnh)', :sys),
 ('formula_item', 'CLOUD', null, '{}', '{}', 'cloud chủ → nhà máy', :sys),
 ('label_incident', 'NM', 'factory_id', '{}', '{}', 'máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('file_attachment', 'NOI_PHAT_SINH', 'factory_id', '{}', '{}', 'nơi tạo dòng là chủ; dòng tạo ở máy chủ nhà máy gộp lên cloud qua sync_outbox', :sys),
 ('document_snapshot', 'NOI_PHAT_SINH', 'factory_id', '{}', '{}', 'nơi tạo dòng là chủ; dòng tạo ở máy chủ nhà máy gộp lên cloud qua sync_outbox', :sys),
 ('document_print_log', 'NOI_PHAT_SINH', null, '{}', '{}', 'nơi tạo dòng là chủ; dòng tạo ở máy chủ nhà máy gộp lên cloud qua sync_outbox', :sys),
 ('code_sequence', 'NOI_PHAT_SINH', 'factory_id', '{}', '{}', 'mỗi nơi giữ bộ đếm của mình (owner_site), không gộp', :sys),
 ('code_format', 'CLOUD', null, '{}', '{}', 'cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc', :sys),
 ('catalog_retire_request', 'CLOUD_ONLY', null, '{}', '{}', 'chỉ cloud', :sys),
 ('lot', 'NM', 'factory_id', '{}', '{}', 'máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('handling_unit', 'NM', 'factory_id', '{}', '{}', 'máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('stock_line', 'NM', 'factory_id', '{}', '{}', 'máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('lock_reason', 'CLOUD', null, '{}', '{}', 'cloud chủ → nhà máy', :sys),
 ('lot_status_transition', 'CLOUD', null, '{}', '{}', 'cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc', :sys),
 ('lot_lock', 'NM', 'factory_id', '{}', '{}', 'máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('lot_status_log', 'NM', 'factory_id', '{}', '{}', 'máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('lot_link', 'NM', 'factory_id', '{}', '{}', 'máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('inventory_txn', 'NM', 'factory_id', '{}', '{}', 'máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('scan_log', 'NM', 'factory_id', '{}', '{}', 'máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('goods_receipt', 'NM', 'factory_id', '{}', '{}', 'máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('goods_receipt_line', 'NM', null, '{}', '{}', 'máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('receipt_coa_result', 'NM', null, '{}', '{}', 'máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('goods_receipt_scan', 'NM', null, '{}', '{}', 'máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('goods_receipt_damage', 'NM', null, '{}', '{}', 'máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('goods_issue', 'NM', 'factory_id', '{}', '{}', 'máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('goods_issue_line', 'NM', null, '{}', '{}', 'máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('goods_issue_scan', 'NM', 'factory_id', '{}', '{}', 'máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('stock_discrepancy', 'NM', 'factory_id', '{}', '{}', 'máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('stock_transfer', 'NM', 'factory_id', '{status,received_at}', '{}', 'máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command; cột dẫn xuất status, received_at do cloud chiếu từ phiếu nhập của nhà máy nhận (chuyển 2 nhà máy)', :sys),
 ('stock_transfer_line', 'NM', null, '{received_qty,damaged_qty,lost_qty}', '{}', 'máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command; cột dẫn xuất received_qty, damaged_qty, lost_qty do cloud chiếu từ phiếu nhập của nhà máy nhận (chuyển 2 nhà máy)', :sys),
 ('transfer_request', 'CLOUD', 'factory_id', '{status,stock_transfer_id}', '{}', 'cloud ghi (Kế hoạch ở văn phòng); sao xuống máy chủ nhà máy nguồn (factory_id) để lập phiếu; status, stock_transfer_id do cloud chiếu từ phiếu chuyển nhà máy nguồn lập', :sys),
 ('transfer_discrepancy', 'NM', null, '{}', '{}', 'máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('stocktake', 'NM', 'factory_id', '{}', '{}', 'máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('stocktake_lock', 'NM', null, '{}', '{}', 'máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('stocktake_line', 'NM', null, '{}', '{}', 'máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('stock_adjustment', 'NM', null, '{}', '{}', 'máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('disposal', 'NM', 'factory_id', '{}', '{}', 'máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('disposal_line', 'NM', null, '{}', '{}', 'máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('customer', 'CLOUD', null, '{}', '{company_code,tax_code,contact_name,contact_title,phone,email,contact_address,bank_account,default_payment_method,credit_limit,is_credit_blocked,credit_blocked_at,bank_name,bank_account_name,default_payment_channel,default_credit_days,default_deposit_pct,invoice_email}', 'cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc; không sao xuống nhà máy: company_code, tax_code, contact_name, contact_title, phone, email, contact_address, bank_account, default_payment_method, credit_limit, is_credit_blocked, credit_blocked_at, bank_name, bank_account_name, default_payment_channel, default_credit_days, default_deposit_pct, invoice_email (quyết định 38)', :sys),
 ('customer_contact_log', 'CLOUD_ONLY', null, '{}', '{}', 'chỉ cloud', :sys),
 ('credit_limit_request', 'CLOUD_ONLY', null, '{}', '{}', 'chỉ cloud', :sys),
 ('sales_order', 'CLOUD', 'factory_id', '{}', '{refund_amount,retained_amount}', 'cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc; cột status do cloud chiếu từ dữ liệu nhà máy; không sao xuống nhà máy: refund_amount, retained_amount (quyết định 38)', :sys),
 ('sales_order_version', 'CLOUD', null, '{}', '{payment_method,deposit_pct,credit_days,total_before_vat,vat_amount,total_amount,contract_file_ids,contract_no,contract_valid_from,contract_valid_to,payment_channel,deposit_amount}', 'cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc; không sao xuống nhà máy: payment_method, deposit_pct, credit_days, total_before_vat, vat_amount, total_amount, contract_file_ids, contract_no, contract_valid_from, contract_valid_to, payment_channel, deposit_amount (quyết định 38)', :sys),
 ('sales_order_line', 'CLOUD', null, '{}', '{unit_price,vat_rate}', 'cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc; không sao xuống nhà máy: unit_price, vat_rate (quyết định 38)', :sys),
 ('sales_order_lot', 'CLOUD', null, '{}', '{}', 'cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc', :sys),
 ('sales_order_status_log', 'CLOUD_ONLY', null, '{}', '{}', 'chỉ cloud', :sys),
 ('payment_schedule', 'CLOUD_ONLY', null, '{}', '{}', 'chỉ cloud', :sys),
 ('sales_issue_request', 'CLOUD', 'factory_id', '{}', '{value_amount}', 'cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc; cột status do cloud chiếu từ dữ liệu nhà máy; không sao xuống nhà máy: value_amount (quyết định 38)', :sys),
 ('sales_issue_request_line', 'CLOUD', null, '{}', '{}', 'cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc', :sys),
 ('delivery_note', 'CLOUD', null, '{}', '{}', 'cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc', :sys),
 ('delivery_note_line', 'CLOUD', null, '{}', '{}', 'cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc', :sys),
 ('sales_order_invoice', 'CLOUD_ONLY', null, '{}', '{}', 'chỉ cloud', :sys),
 ('payment_voucher', 'CLOUD_ONLY', 'factory_id', '{}', '{}', 'chỉ cloud', :sys),
 ('payment_allocation', 'CLOUD_ONLY', null, '{}', '{}', 'chỉ cloud', :sys),
 ('ar_entry', 'CLOUD_ONLY', null, '{}', '{}', 'chỉ cloud', :sys),
 ('supplier', 'CLOUD', null, '{}', '{}', 'cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc', :sys),
 ('supplier_status_log', 'CLOUD_ONLY', null, '{}', '{}', 'chỉ cloud', :sys),
 ('supplier_certificate', 'CLOUD_ONLY', null, '{}', '{}', 'chỉ cloud', :sys),
 ('supplier_material', 'CLOUD_ONLY', null, '{}', '{}', 'chỉ cloud', :sys),
 ('supplier_history', 'CLOUD_ONLY', null, '{}', '{}', 'chỉ cloud', :sys),
 ('purchase_request', 'CLOUD', 'factory_id', '{}', '{}', 'cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc', :sys),
 ('purchase_request_line', 'CLOUD_ONLY', null, '{}', '{}', 'chỉ cloud', :sys),
 ('purchase_order', 'CLOUD', 'factory_id', '{}', '{}', 'cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc; cột status do cloud chiếu từ dữ liệu nhà máy', :sys),
 ('purchase_order_line', 'CLOUD', null, '{}', '{}', 'cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc; cột received_qty do cloud chiếu từ dữ liệu nhà máy', :sys),
 ('purchase_order_coa_result', 'CLOUD_ONLY', null, '{}', '{}', 'chỉ cloud', :sys),
 ('ap_entry', 'CLOUD_ONLY', null, '{}', '{}', 'chỉ cloud', :sys),
 ('supplier_return', 'CLOUD', 'factory_id', '{}', '{}', 'cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc', :sys),
 ('supplier_return_line', 'CLOUD', null, '{}', '{}', 'cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc', :sys),
 ('production_order', 'CLOUD', 'factory_id', '{}', '{}', 'cloud là chủ, CHỈ tạo trên cloud → sao xuống server nhà máy khi phát lệnh; trạng thái chạy / xong do sự kiện từ nhà máy cập nhật; cột status, nm_ack_at, started_at, finished_at, nm_cancel_confirmed_at, ended_early_at, actual_batch_count do cloud chiếu từ dữ liệu nhà máy', :sys),
 ('production_order_brand', 'CLOUD', null, '{}', '{}', 'cloud chủ → nhà máy cùng lệnh', :sys),
 ('production_order_silo', 'CLOUD', null, '{}', '{}', 'cloud chủ → server nhà máy cùng lệnh (PC xưởng mở silo theo phương án)', :sys),
 ('material_reservation', 'CLOUD', null, '{}', '{}', 'cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc; cột issued_kg do cloud chiếu từ dữ liệu nhà máy', :sys),
 ('production_batch', 'NM', 'factory_id', '{}', '{}', 'máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('batch_cancellation', 'CLOUD', 'factory_id', '{}', '{}', 'Kế hoạch ghi trên cloud (cả khi nhà máy mất mạng) → lệnh HUY_ME (site_command) xuống máy chủ nhà máy; nhà máy áp khi mẻ còn DUNG_SU_CO, khác thì từ chối', :sys),
 ('batch_operator', 'NM', null, '{}', '{}', 'máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('batch_equipment_usage', 'NM', null, '{}', '{}', 'máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('silo_charge', 'NM', 'factory_id', '{}', '{}', 'máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('filling_run', 'NM', 'factory_id', '{}', '{}', 'máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('carton_recount', 'NM', 'factory_id', '{}', '{}', 'máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('batch_mixing_param', 'NM', null, '{}', '{}', 'máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('batch_downtime', 'NM', null, '{}', '{}', 'máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('batch_weight_check', 'NM', null, '{}', '{}', 'máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('filling_can_weight', 'NM', null, '{}', '{}', 'máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('ncr', 'NM', 'factory_id', '{}', '{}', 'máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('sync_outbox', 'NM_ONLY', 'factory_id', '{}', '{}', 'máy chủ nhà máy ghi, đẩy lên cloud theo seq_no; cloud nhận vào sync_event_inbox (bỏ trùng theo event_id)', :sys),
 ('sync_event_inbox', 'CLOUD_ONLY', 'factory_id', '{}', '{}', 'chỉ cloud — nhận sync_outbox của các nhà máy, bỏ trùng theo event_id, áp dụng theo seq_no từng nhà máy', :sys),
 ('factory_sync_state', 'CLOUD_ONLY', 'factory_id', '{}', '{}', 'chỉ cloud', :sys),
 ('downstream_change', 'CLOUD_ONLY', 'factory_id', '{}', '{}', 'cloud ghi → máy chủ nhà máy kéo theo seq', :sys),
 ('sync_conflict', 'NM', 'factory_id', '{}', '{}', 'máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('offline_session', 'NM_ONLY', 'factory_id', '{}', '{}', 'chỉ máy chủ nhà máy; tóm tắt phiên gửi lên cloud qua sync_outbox', :sys),
 ('qc_request', 'NM', 'factory_id', '{}', '{}', 'máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('qc_request_part', 'NM', null, '{}', '{}', 'máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('qc_inspection', 'NM', 'factory_id', '{}', '{}', 'máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('qc_result_item', 'NM', null, '{}', '{}', 'máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('product_spec_item', 'CLOUD', null, '{}', '{}', 'cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc', :sys),
 ('quality_certificate', 'NM', 'factory_id', '{}', '{}', 'máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('retained_sample', 'NM', 'factory_id', '{}', '{}', 'máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('retained_sample_event', 'NM', null, '{}', '{}', 'máy chủ nhà máy của dòng cha ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys),
 ('trace_request', 'CLOUD', 'factory_id', '{}', '{}', 'cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc', :sys),
 ('trace_result_lot', 'CLOUD_ONLY', null, '{}', '{}', 'chỉ cloud', :sys),
 ('trace_result_customer', 'CLOUD_ONLY', null, '{}', '{}', 'chỉ cloud', :sys),
 ('mass_balance_result', 'CLOUD_ONLY', null, '{}', '{}', 'chỉ cloud', :sys),
 ('recall_case', 'CLOUD', 'factory_id', '{}', '{}', 'cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc', :sys),
 ('recall_lot', 'CLOUD', null, '{}', '{}', 'cloud ghi; sao xuống máy chủ nhà máy phần nhà máy cần (lọc theo factory_id, kéo theo dòng cha theo khóa ngoại), chỉ đọc', :sys),
 ('recall_customer', 'CLOUD_ONLY', null, '{}', '{}', 'chỉ cloud', :sys),
 ('recall_authority_report', 'CLOUD_ONLY', null, '{}', '{}', 'chỉ cloud', :sys),
 ('recall_resolution', 'CLOUD_ONLY', null, '{}', '{}', 'chỉ cloud', :sys),
 ('capa', 'CLOUD_ONLY', null, '{}', '{}', 'chỉ cloud', :sys),
 ('sync_policy', 'CLOUD', null, '{}', '{}', 'cloud ghi (nạp khi triển khai), sao xuống mọi máy chủ nhà máy', :sys),
 ('site_command', 'CLOUD', 'factory_id', '{}', '{}', 'cloud ghi (cả khi nhà máy mất kết nối — nằm CHO_GUI) → máy chủ nhà máy kéo theo seq (GET /sync/pull), ghi command_inbox; status, result_text, sent_at, applied_at do cloud chiếu từ command_inbox', :sys),
 ('command_inbox', 'NM', 'factory_id', '{}', '{}', 'máy chủ nhà máy của dòng (factory_id) ghi, luôn qua sync_outbox lên cloud; cloud giữ bản đồng bộ chỉ xem (ghi "tính đến" khi nhà máy mất kết nối); cloud muốn đổi thì gửi lệnh site_command', :sys);

-- Định dạng mã danh mục (QT02 y2, QT03 y2; chốt 17/10, sửa 19/10: thêm công thức, bỏ thiết bị đo; 24/10 đợt 9: bỏ vị trí kệ; đợt 4: thêm thương hiệu, dòng SP, hạng, quy cách
-- chốt 19/10 tối: THH- / DSP- / QCD- / HSP- — bỏ 04/11 cùng 4 danh mục; kho thứ 2 trở đi cùng loại thêm số NM1-DP2 (nhiều kho điều phối — 04/11); Admin sửa được). Số thứ tự lấy từ code_sequence, chỉ tăng, không dùng lại.
insert into code_format (entity_type, pattern, tokens, counter_scope, example, created_by) values
 ('NVL',        'NVL-{nhom}-{so:4}',                       '{"nhom":{"BOT":"BOT","PHU_GIA":"PGA","BAO_BI":"BBI","HON_HOP":"HHP"}}', 'nhom', 'NVL-BOT-0001', :sys),
 ('SP',         'SP-{so:4}',                               null,                                                                    null,   'SP-0001', :sys),
 ('KHO',        '{nha_may}-{loai}{so_tu_2}',               '{"loai":{"TONG":"TONG","DIEU_PHOI":"DP","BTP":"BTP","MAU_QC":"QC","KHAC":"KHAC"}}', 'nha_may,loai', 'NM1-DP2', :sys),
 ('CT',         'CT-{loai}-{so:4}',                        '{"loai":{"HH":"HH","BTP":"BTP"}}',                                'loai', 'CT-HH-0001', :sys),
  -- 04/11: theo màn Định dạng mã của mockup — khách hàng, NCC, mã NV, lô; bỏ thương hiệu / dòng / hạng / quy cách (mô hình SP mới)
 ('KHACH_HANG', 'KH-{so:4}',                               null,                                                                    null,   'KH-0001', :sys),
 ('NCC',        'NCC-{so:4}',                              null,                                                                    null,   'NCC-0001', :sys),
 ('MA_NV',      'NV{so:4}',                                null,                                                                    null,   'NV0001', :sys),
 ('LO_NVL',     'L-{viet_tat}-{so:2}',                     null,                                                                    'viet_tat', 'L-BOT-01', :sys),
 ('LO_BTP',     'B{yymmdd}{so:2}',                         null,                                                                    'yymmdd', 'B26101401', :sys),
 ('LO_TP',      'A{yymmdd}',                               null,                                                                    null,   'A261014', :sys),
 -- 04/11: chứng từ cloud (số theo tháng)
 ('DON_HANG',       'ĐH-{yymm}-{so:4}',                    null, null, 'ĐH-2610-0001', :sys),
 ('PO',             'PO-{yymm}-{so:4}',                    null, null, 'PO-2610-0001', :sys),
 ('NHU_CAU_MUA',    'NC-{yymm}-{so:4}',                    null, null, 'NC-2610-0001', :sys),
 ('YEU_CAU_CHUYEN', 'YCC-{yymm}-{so:4}',                   null, null, 'YCC-2610-0001', :sys),
 ('HO_SO_PHAP_LY',  'HS-{so:4}',                           null, null, 'HS-0001', :sys),
 -- 20/10 đợt 2: mã chứng từ sinh tại máy chủ nhà máy, có tiền tố nhà máy (bộ đếm code_sequence owner_site NM, theo nhà máy × tháng)
 ('PHIEU_NHAP',     'PN-{nha_may}-{yymm}-{so:4}',          null, 'nha_may', 'PN-NM1-2610-0001', :sys),
 ('PHIEU_XUAT',     'PX-{nha_may}-{yymm}-{so:4}',          null, 'nha_may', 'PX-NM1-2610-0001', :sys),
 ('PHIEU_CHUYEN',   'PC-{nha_may}-{yymm}-{so:4}',          null, 'nha_may', 'PC-NM1-2610-0001', :sys),
 ('PHIEU_KIEM_KHO', 'PK-{nha_may}-{yymm}-{so:4}',          null, 'nha_may', 'PK-NM1-2610-0001', :sys),
 ('PHIEU_HUY',      'PH-{nha_may}-{yymm}-{so:4}',          null, 'nha_may', 'PH-NM1-2610-0001', :sys),
 ('YEU_CAU_KIEM',   'YC-{nha_may}-{yymm}-{so:4}',          null, 'nha_may', 'YC-NM1-2610-0001', :sys),
 ('PHIEU_KIEM',     'QC-{nha_may}-{yymm}-{so:4}',          null, 'nha_may', 'QC-NM1-2610-0001', :sys),
 ('CHUNG_NHAN',     'CN-{nha_may}-{yymm}-{so:4}',          null, 'nha_may', 'CN-NM1-2610-0001', :sys),
 ('MAU_LUU',        'ML-{nha_may}-{yymm}-{so:4}',          null, 'nha_may', 'ML-NM1-2610-0001', :sys);

-- 9 lý do khóa (mục "Lý do khóa"). strictness: số lớn = chặt hơn — THỨ TỰ CẦN XÁC NHẬN (câu hỏi).
insert into lock_reason (code, name, scope, applies_to, allow_qc, allowed_exits, strictness, created_by) values
 ('KHACH_TRA',      'Hàng khách trả',                                  'RIENG_PHAN',      'TP',          true,  '{QC}',                 1, :sys),
 ('TIM_LAI',        'Tìm lại sau thất lạc / điều chỉnh hủy nhầm',      'RIENG_PHAN',      'MOI_LOAI',    true,  '{QC}',                 1, :sys),
 ('HU_KHI_NHAN',    'Hư khi nhận chuyển kho',                          'RIENG_PHAN',      'MOI_LOAI',    true,  '{QC,HUY}',             2, :sys),
 ('HU_CHO_TRA_NCC', 'Hàng hư, chờ trả NCC',                            'RIENG_PHAN',      'NVL_MUA',     false, '{TRA_NCC,HUY}',        3, :sys),
 ('KHOANH_VUNG',    'Khoanh vùng (nghi lỗi, chưa quyết thu hồi)',      'CA_LO',           'MOI_LOAI',    true,  '{QC}',                 4, :sys),
 ('XUNG_DOT',       'Xung đột khi mất kết nối',                        'CA_LO',           'HH,BTP,TP',   true,  '{QC,HO_SO_THU_HOI}',   4, :sys),
 ('CHO_HUY',        'Chờ hủy (đã tạo phiếu hủy)',                      'PHAN_TREN_PHIEU', 'MOI_LOAI',    false, '{HUY,VE_TRUOC,QC}',    5, :sys),
 ('HET_HAN',        'Hết hạn dùng',                                    'CA_LO',           'MOI_LOAI',    false, '{HUY}',                6, :sys),
 ('THU_HOI',        'Thu hồi (đã quyết thu hồi)',                      'CA_LO',           'MOI_LOAI',    false, '{HUY}',                7, :sys);

-- Bảng chuyển trạng thái (mục "Vòng đời lô hàng", mỗi trạng thái nguồn 1 dòng)
insert into lot_status_transition (from_status, to_status, lock_reason, qt_code, step_code, actor_rule, condition_text, created_by) values
 (null,        'DAT',       null,            'QT14','y2','Hệ thống, khi phiếu nhập Đã nhập (lệch thì sau Thủ kho trưởng xác nhận, d4)','NVL mua đã qua kiểm COA, HSD (lv, ld)',:sys),
 (null,        'DAT',       null,            'QT20','h9','Hệ thống','NVL hỗn hợp: bao vừa dán mã, không QC',:sys),
 (null,        'CHO_KIEM',  null,            'QT14','y2','Hệ thống','BTP (thùng sau chiết rót) nhập kho BTP (QT21 g3), chờ QC thành phẩm',:sys),
 (null,        'KHOA',      'KHACH_TRA',     'QT14','y2','Hệ thống','Hàng khách trả (từ QT09 r4)',:sys),
 (null,        'KHOA',      'THU_HOI',       'QT14','y2','Hệ thống','Hàng thu hồi (từ QT26 r2)',:sys),
 (null,        'DAT',       null,            'QT14','y2','Hệ thống','NVL dư trả về: lô gốc không có khóa cả lô và còn hạn',:sys),
 (null,        'KHOA',      null,            'QT14','y2','Hệ thống','NVL dư trả về: lô gốc có khóa cả lô → cùng lý do (thu hồi thì thêm vào hồ sơ thu hồi)',:sys),
 (null,        'KHOA',      'HET_HAN',       'QT14','y2','Hệ thống','NVL dư trả về: đã hết hạn',:sys),
 (null,        'KHOA',      'CHO_HUY',       'QT14','y2','Hệ thống','NVL dư trả về: lô gốc đã HỦY hết → tự tạo phiếu hủy',:sys),
 (null,        'KHOA',      'CHO_HUY',       'QT20','ky','Hệ thống, sau Kế hoạch quyết hủy mẻ (kh)','Bột hỏng của mẻ hủy do sự cố (lô HONG): tự tạo phiếu hủy (QT18)',:sys),
 ('DAT',       'CHO_KIEM',  null,            'QT22','y1','Kho / SX gửi yêu cầu (t1), hệ thống chặn ngay','Lô NVL nghi lỗi',:sys),
 ('KHOA',      'CHO_KIEM',  null,            'QT22/QT23','y1','Kho / SX gửi yêu cầu (t1)','Chỉ lý do khóa cho phép QC (khách trả, hư khi nhận, khoanh vùng, xung đột, tìm lại)',:sys),
 ('CHO_KIEM',  'DAT',       null,            'QT22/QT23','d2','QC nhập số liệu, QC trưởng duyệt kết luận','Đạt. BTP đạt → đổi thành TP, sinh phiếu chứng nhận; mọi lô TP của đơn ĐẠT → gọi QT09',:sys),
 ('CHO_KIEM',  'KHONG_DAT', null,            'QT22/QT23','d2','QC nhập số liệu, QC trưởng duyệt kết luận','Không đạt',:sys),
 ('CHO_KIEM',  'DAT',       null,            'QT22','yt','QC trưởng từ chối yêu cầu kiểm, bắt buộc lý do','Trước khi gửi là ĐẠT',:sys),
 ('CHO_KIEM',  'KHOA',      null,            'QT22/QT23','yt','QC trưởng từ chối yêu cầu kiểm, bắt buộc lý do','Trước khi gửi là KHÓA: về KHÓA, giữ lý do cũ. BTP mới nhập không được từ chối',:sys),
 ('KHONG_DAT', 'DAT',       null,            'QT22','ym','QC trưởng, thao tác tay','Chỉ lô NVL; bắt buộc lý do + file; chặn nếu lô đã hết hạn',:sys),
 ('DAT',       'KHOA',      'HU_CHO_TRA_NCC','QT13','y1','Hệ thống','Hàng hư phát hiện sau khi nhập, mở phiếu trả NCC',:sys),
 ('DAT',       'KHOA',      'HU_KHI_NHAN',   'QT16','t4','Kho nhận quét bao hư, chỉ các bao đó đổi trạng thái','Hư khi nhận chuyển kho (ảnh, lý do)',:sys),
 ('DAT',       'KHOA',      'CHO_HUY',       'QT18','t2','Hệ thống, khi kho tạo phiếu hủy','Phần trên phiếu hủy',:sys),
 ('KHONG_DAT', 'KHOA',      'CHO_HUY',       'QT18','t2','Hệ thống, khi kho tạo phiếu hủy','Lô Không đạt đưa vào phiếu hủy → KHÓA lý do Chờ hủy (04/11)',:sys),
 ('KHOA',      'DAT',       null,            'QT18','xr','Thủ kho trưởng từ chối phiếu hủy, bắt buộc lý do','Lô chờ hủy, kiểm lại thấy không lỗi → về trạng thái trước',:sys),
 ('KHOA',      'KHOA',      'KHOANH_VUNG',   'QT18','xr','Thủ kho trưởng từ chối phiếu hủy','Lô chờ hủy còn nghi ngờ → gửi QC, lý do đổi thành khoanh vùng',:sys),
 ('DAT',       'KHOA',      'HET_HAN',       'QT18','yc','Hệ thống (quét HSD hằng ngày)','Đến hạn dùng',:sys),
 ('CHO_KIEM',  'KHOA',      'HET_HAN',       'QT18','yc','Hệ thống (quét HSD hằng ngày)','Đến hạn khi đang CHỜ KIỂM → tự hủy yêu cầu QC đang mở',:sys),
 ('DAT',       'KHOA',      'KHOANH_VUNG',   'QT26','y1/y2','Hệ thống','Lô nghi lỗi và lô liên quan',:sys),
 ('CHO_KIEM',  'KHOA',      'KHOANH_VUNG',   'QT26','y1/y2','Hệ thống','Lô nghi lỗi và lô liên quan',:sys),
 ('KHOA',      'KHOA',      'THU_HOI',       'QT26','yv','Hệ thống','GĐ quyết thu hồi → đổi lý do khoanh vùng thành thu hồi',:sys),
 ('DAT',       'KHOA',      'XUNG_DOT',      'QT19','kz','Hệ thống, khi đồng bộ lại','Lô sinh ra từ mẻ đã dùng lô bị KHÓA / HỦY lúc mất kết nối',:sys),
 ('CHO_KIEM',  'KHOA',      'XUNG_DOT',      'QT19','kz','Hệ thống, khi đồng bộ lại','Như trên',:sys),
 ('KHOA',      'KHOA',      null,            'Lý do khóa','—','Hệ thống','Phần lô đã KHÓA nhận thêm lý do chặt hơn (2 lý do cùng lúc → lấy lý do chặt hơn)',:sys),
 ('DAT',       'HUY',       null,            'QT18','y1','Kho thực hiện hủy (t4), Thủ kho trưởng xác nhận (d2)','Phiếu hủy được xác nhận',:sys),
 ('CHO_KIEM',  'HUY',       null,            'QT18','y1','Kho thực hiện hủy (t4), Thủ kho trưởng xác nhận (d2)','Phiếu hủy được xác nhận',:sys),
 ('KHOA',      'HUY',       null,            'QT18','y1','Kho thực hiện hủy (t4), Thủ kho trưởng xác nhận (d2)','Phiếu hủy được xác nhận',:sys),
 ('KHONG_DAT', 'HUY',       null,            'QT18','y1','Kho thực hiện hủy (t4), Thủ kho trưởng xác nhận (d2)','Phiếu hủy được xác nhận',:sys),
 ('DAT',       'HUY',       null,            'QT16','g3/gx/gy','Kế hoạch lập biên bản thất lạc, Thủ kho trưởng xác nhận','Xe không tới / hàng thiếu quá 7 ngày chưa tìm thấy',:sys),
 ('CHO_KIEM',  'HUY',       null,            'QT16','g3/gx/gy','Kế hoạch lập biên bản thất lạc, Thủ kho trưởng xác nhận','Như trên',:sys),
 ('KHOA',      'HUY',       null,            'QT16','g3/gx/gy','Kế hoạch lập biên bản thất lạc, Thủ kho trưởng xác nhận','Như trên',:sys),
 ('KHONG_DAT', 'HUY',       null,            'QT16','g3/gx/gy','Kế hoạch lập biên bản thất lạc, Thủ kho trưởng xác nhận','Như trên',:sys);

-- Tham số mặc định (mục "Tham số mặc định"), cấu hình lại được
insert into system_parameter (param_key, scope_type, group_code, value, default_value, unit, qt_code, description, created_by) values
 ('account.idle_lock_days',              'TOAN_HT', null, '90',  '90',  'NGAY', 'QT01', 'Không đăng nhập quá N ngày thì tự khóa', :sys),
 ('account.lock_notice_days',            'TOAN_HT', null, '3',   '3',   'NGAY', 'QT01', 'Báo HR trước ngày khóa', :sys),
 ('credit.wait_remind_days',             'TOAN_HT', null, '3',   '3',   'NGAY', 'QT06', 'Đơn chờ xử lý nợ / duyệt hạn mức / chờ khách quá N ngày thì nhắc Sales', :sys),
 ('credit.wait_auto_reject_days',        'TOAN_HT', null, '7',   '7',   'NGAY', 'QT06', 'Quá N ngày thì tự Từ chối', :sys),
 ('delivery.payment_wait_days',          'TOAN_HT', null, '14',  '14',  'NGAY', 'QT09', 'Yêu cầu xuất bán chưa thu đủ / khách bị khóa quá N ngày → QT07', :sys),
 ('cancel.retain_full_deposit',          'TOAN_HT', null, 'true','true','BAT_TAT','QT09','Hủy đơn đề xuất giữ toàn bộ cọc (người duyệt QT07 sửa được)', :sys),
 ('ar.overdue_first_remind_days',        'TOAN_HT', null, '3',   '3',   'NGAY', 'QT10', 'Quá hạn N ngày thì nhắc lần đầu (thông báo trong hệ thống cho Sales, Kế toán)', :sys),
 ('ar.overdue_repeat_remind_days',       'TOAN_HT', null, '7',   '7',   'NGAY', 'QT10', 'Sau đó nhắc mỗi N ngày', :sys),
 ('ar.pre_delivery_escalate_days',       'TOAN_HT', null, '14',  '14',  'NGAY', 'QT10', 'Khoản trước giao quá N ngày → báo QT gọi (Từ chối / Hủy)', :sys),
 ('ar.escalate_director_days',           'TOAN_HT', null, '90',  '90',  'NGAY', 'QT10', 'Công nợ sau giao quá N ngày → báo GĐ / KTT quyết bên ngoài hệ thống', :sys),
 ('po.director_approval_threshold_vnd',  'TOAN_HT', null, '100000000','100000000','VND','QT12','PO trên mức này cần GĐ duyệt thêm', :sys),
 ('receipt.min_remaining_shelf_ratio',   'TOAN_HT', null, '0.667','0.667','TY_LE','QT14','HSD còn ≥ 2/3 hạn dùng khi nhận (ghi đè theo mã NVL qua group_code)', :sys),
 ('transfer.missing_search_days',        'TOAN_HT', null, '7',   '7',   'NGAY', 'QT16', 'Hàng thiếu khi nhận chuyển kho chờ tìm N ngày rồi lập biên bản thất lạc', :sys),
 ('purchase.default_lead_days',         'TOAN_HT', null, '14',  '14',  'NGAY', 'QT12', 'Thời gian NCC giao hàng mặc định khi NVL / NCC chưa ghi — tính ngày cần của yêu cầu mua (24/10 đợt 12)', :sys),
 ('production.min_shelf_days',           'TOAN_HT', null, '30',  '30',  'NGAY', 'QT15', 'Hạn còn lại tối thiểu khi dùng cho SX (đề xuất / quét xuất SX, nạp silo, tồn khả dụng cho lệnh) — ghi đè theo mã / nhóm NVL qua group_code (24/10 đợt 9)', :sys),
 ('expiry.undestroyed_remind_days',      'TOAN_HT', null, '30',  '30',  'NGAY', 'QT18', 'Lô hết hạn chưa hủy quá N ngày thì nhắc Thủ kho trưởng', :sys),
 ('dispatch.alert_minutes',              'TOAN_HT', null, '10',  '10',  'PHUT', 'QT19', 'Phát lệnh không tới quá N phút báo Kế hoạch', :sys),
 ('offline.enter_after_seconds',         'TOAN_HT', null, '30',  '30',  'GIAY', 'QT19', 'Mất kết nối quá N giây vào chế độ ngoại tuyến', :sys),
 ('sync.outbox_retain_days',             'TOAN_HT', null, '30',  '30',  'NGAY', 'QT19', 'Hàng đợi gửi lên giữ N ngày sau khi cloud xác nhận rồi dọn (không giới hạn thời gian ngoại tuyến — bỏ offline.max_hours 20/10 đợt 2)', :sys),
 ('sync.clock_skew_warn_minutes',        'TOAN_HT', null, '5',   '5',   'PHUT', 'QT19', 'Giờ máy chủ nhà máy lệch cloud quá N phút thì cảnh báo Admin', :sys),
 ('sample.retain_months_after_exp',      'TOAN_HT', null, '6',   '6',   'THANG','QT24', 'Gợi ý hạn lưu mẫu = HSD + N tháng; QC tự quyết từng mẫu', :sys),
 ('trace.retain_months_after_exp',       'TOAN_HT', null, '12',  '12',  'THANG','QT25', 'Lưu hồ sơ truy xuất ≥ HSD + N tháng', :sys),
 ('recall.complete_days',                'TOAN_HT', null, '30',  '30',  'NGAY', 'QT26', 'Hoàn thành thu hồi trong N ngày kể từ quyết định', :sys),
 ('recall.retain_months_after_exp',      'TOAN_HT', null, '12',  '12',  'THANG','QT26', 'Lưu hồ sơ thu hồi ≥ HSD + N tháng', :sys);
