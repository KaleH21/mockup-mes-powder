#!/usr/bin/env bash
# Tải mã nguồn canvas "MES Powder — khuôn màn hình" về máy — chỉ file của dự án (project/),
# bỏ phần chạy của canvas (app.js, app.css… ~6 MB) nên không vướng giới hạn 16 MB khi tải.
#
# Dùng:  bash tai-canvas.sh "<BASE>"
#   BASE = địa chỉ thư mục project/ của canvas, lấy trong DevTools (xem hướng dẫn trong chat).
#   File lưu vào ./mes-powder-canvas/project/...
# Thêm file script thanh cuộn (tài nguyên /_blob/...) nếu BLOB_BASE được đặt:
#   BLOB_BASE="https://<origin>" bash tai-canvas.sh "<BASE>"
set -euo pipefail
BASE="${1:?Thiếu BASE — địa chỉ thư mục project/ của canvas}"
BASE="${BASE%/}/"
OUT="mes-powder-canvas/project"

FILES=(
canvas.json
mp-scroll.js
ds/mespowder/tokens.css
ds/mespowder/tokens.json
ds/mespowder/components/bundle.css
ds/mespowder/fonts/BeVietnamPro-Bold.woff2
ds/mespowder/fonts/BeVietnamPro-Medium.woff2
ds/mespowder/fonts/BeVietnamPro-Regular.woff2
ds/mespowder/fonts/BeVietnamPro-SemiBold.woff2
ds/mespowder/fonts/JetBrainsMono.woff2
BanDonHang-0r5c.dc.html BanDonHangCapNhatLSX-d3wu.dc.html BanDonHangChiTiet-e8kw.dc.html BanDonHangChoKhach-p2rx.dc.html
BanDonHangCongNo-q6vt.dc.html BanDonHangDangHuy-k1fs.dc.html BanDonHangDuyetHuy-v9ta.dc.html BanDonHangGhiNhanGiao-g8nq.dc.html
BanDonHangHanMuc-w8kd.dc.html BanDonHangHoaDon-h3vk.dc.html BanDonHangHuy-c5jn.dc.html BanDonHangPhuLuc-r7qe.dc.html
BanDonHangSua-m4yb.dc.html BanDonHangTao-8o5y.dc.html BanDonHangXuLyNo-h3mz.dc.html BanDonHangYeuCauXuat-y5xb.dc.html
BanHang-wvhq.dc.html BanKhachHangChiTiet-khht.dc.html BanKhachHangTao-xhk5.dc.html BienBanKiemKeIn-k7bb.dc.html
CauHinh-cocg.dc.html CauHinhSuaMa-m6ta.dc.html ChatLuong-q4ls.dc.html ChatLuongCN-t9bw.dc.html ChatLuongCNBanIn-k4rv.dc.html
ChatLuongCNDaKy-m7xe.dc.html ChatLuongCNKy-w2hd.dc.html ChatLuongML-p5ga.dc.html ChatLuongMLCanHuy-b6tn.dc.html
ChatLuongMLChiTiet-r9fc.dc.html ChatLuongMLGhi-e8pw.dc.html ChatLuongMLHuy-z3qa.dc.html ChatLuongMLLayRa-h5uj.dc.html
ChatLuongPK-d2xh.dc.html ChatLuongPK-k4wn.dc.html ChatLuongPK-m2zl.dc.html ChatLuongPK-v8ru.dc.html ChatLuongPKKy-c8sn.dc.html
ChatLuongYC-b5qe.dc.html ChatLuongYC-g7mb.dc.html ChatLuongYC-t3hc.dc.html CongThuc-qdhl.dc.html CongThucChiTiet-pji2.dc.html
CongThucTao-n4ct.dc.html DangNhap.dc.html DanhMuc-15tr.dc.html DanhMucSP-zd4p.dc.html DonVi-u7dv.dc.html DonViSua-b4kp.dc.html
DonViThamChieu-r2xw.dc.html GuiCOA-c7ya.dc.html GuiPO-r6mx.dc.html HoSoBieuMau-p7rn.dc.html HoSoPhapLy-h7pl.dc.html
HoSoPhapLyTao-k3fz.dc.html HoaDonBanIn-a4hd.dc.html HopDuyet.dc.html HopDuyetGiamDoc-r5mz.dc.html HopDuyetTaiKhoan-q7wd.dc.html
HopDuyetThongBao-k3np.dc.html HopDuyetThuKho-w8tn.dc.html KeToan-k2vm.dc.html KeToanNCC-m3pz.dc.html KeToanSo-v6qe.dc.html
KeToanTienVe-r4ha.dc.html KeToanTraNCC-x8dw.dc.html KhoChoChuyen-h2tq.dc.html KhoChuyen-oq5y.dc.html KhoChuyenQuet-c4qn.dc.html
KhoHuy-br6r.dc.html KhoKiemKe-23cu.dc.html KhoKiemQuet-k9qd.dc.html KhoNhapChiTiet-lk8h.dc.html KhoVH-xv2s.dc.html
KhoXuat-71ki.dc.html KhoXuatQuet-q7xs.dc.html KhoXuatTao-u8sl.dc.html KhuVuc.dc.html KhuVucThem-a8tk.dc.html LenhSX-hxoc.dc.html
LenhSXCachBu-b7cv.dc.html LenhSXCanDoi-c4nv.dc.html LenhSXChiTiet-tu9p.dc.html LenhSXDongBo-k7qe.dc.html LenhSXLocal-tajs.dc.html
LenhSXNhuCau-n8cq.dc.html LenhSXPhat-408l.dc.html LenhSXTaoBTP-nan3.dc.html LenhSXTaoHH-isnv.dc.html LenhSXTaoNhuCau-t5pa.dc.html
MuaBaoGia-nksw.dc.html MuaHang-7mvk.dc.html MuaNCCChiTiet-x9dk.dc.html MuaPO-3fox.dc.html MuaPOTao-9joi.dc.html MuaTraHang-e9jn.dc.html
NguoiDung.dc.html NguoiDungSua-k1vb.dc.html NguoiDungTao-f6nm.dc.html NguoiDungVaiTro-s3pf.dc.html NguoiDungXoa-d8zq.dc.html
NhaMay-qd07.dc.html NhaMayForm-ldp8.dc.html NhaMayKho-r3dp.dc.html NhaMayKhu-s7lo.dc.html NhaMaySua-v2qa.dc.html NhatKy-n5jd.dc.html
NhatKyHR-t4wq.dc.html NhatKyQuet-k2vd.dc.html NhatKyXungDot-8rme.dc.html PhieuNhapIn-p4nk.dc.html PhieuXuatBanIn-b3xk.dc.html
PhieuXuatIn-x6qk.dc.html QuyCachDongGoi-xq9j.dc.html SanPhamChiTiet-okbh.dc.html SanPhamTao-vl0t.dc.html SuaNVL-e5nv.dc.html
SuaNVLMoi-p4bx.dc.html TaoMa-29ia.dc.html TaoMaChiTieu-n2kq.dc.html TheoDoiMe-w4ka.dc.html TheoDoiMeHuy-c7rn.dc.html
ThuHoi-r8hw.dc.html ThuHoiChoGD-7wna.dc.html ThuHoiDangThu-m2xc.dc.html ThuHoiDong-z5rd.dc.html ThuHoiMoTX-k4qe.dc.html
TonLo.dc.html TongQuanGiamDoc-g1dx.dc.html TruyXuat.dc.html TruyXuatCanBang-h3vd.dc.html TruyXuatDongThoiGian-t1mx.dc.html
TruyXuatTao-q7mc.dc.html TruyXuatXuoi-b8nw.dc.html UyQuyen.dc.html VaiTroQuyen.dc.html VaiTroQuyenDanhMuc-k8dm.dc.html
VaiTroQuyenNhaMay-h5fc.dc.html VaiTroQuyenSua-p3qe.dc.html
)

ok=0; fail=()
for f in "${FILES[@]}"; do
  mkdir -p "$OUT/$(dirname "$f")"
  if curl -fsSL --retry 2 -o "$OUT/$f" "$BASE$f"; then ok=$((ok+1)); else fail+=("$f"); rm -f "$OUT/$f"; fi
done

if [ -n "${BLOB_BASE:-}" ]; then
  mkdir -p "$OUT/_blob"
  curl -fsSL -o "$OUT/_blob/mp-scroll.js" "${BLOB_BASE%/}/_blob/1ac7da4f2947094995f1ad52291bf36c" || fail+=("_blob/mp-scroll.js")
fi

echo "Đã tải $ok / ${#FILES[@]} file vào $OUT"
if [ ${#fail[@]} -gt 0 ]; then printf 'Lỗi: %s\n' "${fail[@]}"; exit 1; fi
