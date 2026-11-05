/* MES Powder — thanh cuộn nổi (03/11)
   Ẩn thanh cuộn gốc của trình duyệt (không chiếm chỗ); vẽ thanh cuộn nổi đè lên nội dung,
   chỉ hiện khi rê chuột / cuộn, tự ẩn sau ~1 giây đứng yên. Kéo được, bấm vào rãnh để nhảy trang.
   Bảng rộng: 2 thanh ngang — ngay dưới hàng tiêu đề và ở đáy thân bảng (bám đáy khung nhìn khi bảng dài), luôn nằm trên cột cố định. */
(function () {
  if (window.__mpScroll) return; window.__mpScroll = 1;
  var D = document, R = D.documentElement;
  R.classList.add('mp-osb');
  var HIDE_MS = 1000, MIN_THUMB = 40;
  var layer = null, items = new Map(), raf = 0, drag = null;

  function ensureLayer() {
    if (layer && layer.isConnected) return layer;
    if (!D.body) return null;
    layer = D.createElement('div'); layer.className = 'mp-osb-layer'; layer.setAttribute('aria-hidden', 'true');
    D.body.appendChild(layer); return layer;
  }
  function docEl() { return D.scrollingElement || R; }
  function canX(el) {
    if (el.scrollWidth - el.clientWidth < 2) return false;
    if (el === docEl()) return getComputedStyle(D.body).overflowX !== 'hidden' && getComputedStyle(R).overflowX !== 'hidden';
    return /(auto|scroll)/.test(getComputedStyle(el).overflowX);
  }
  function canY(el) {
    if (el.scrollHeight - el.clientHeight < 2) return false;
    if (el === docEl()) return getComputedStyle(D.body).overflowY !== 'hidden' && getComputedStyle(R).overflowY !== 'hidden';
    return /(auto|scroll)/.test(getComputedStyle(el).overflowY);
  }
  function rectOf(el) {
    if (el === docEl()) return { left: 0, top: 0, right: R.clientWidth || innerWidth, bottom: innerHeight };
    return el.getBoundingClientRect();
  }
  function mkBar(axis, kind) {
    var tr = D.createElement('div'); tr.className = 'mp-osb-track mp-osb-track--' + axis + (kind ? ' mp-osb-track--' + kind : '');
    var th = D.createElement('div'); th.className = 'mp-osb-thumb'; tr.appendChild(th);
    tr.addEventListener('pointerdown', function (e) { onDown(e, tr); });
    return tr;
  }
  function get(el) {
    var it = items.get(el);
    if (!it) { it = { el: el, bars: [], t: 0, on: false }; items.set(el, it); }
    return it;
  }
  function wake(el) {
    var L = ensureLayer(); if (!L) return;
    var x = canX(el), y = canY(el); if (!x && !y) return;
    var it = get(el), want = [];
    if (y) want.push('y');
    if (x) { want.push('x'); if (el.classList && el.classList.contains('mp-xs__body') && el.querySelector('thead')) want.push('xh'); }
    var key = want.join(',');
    if (it.key !== key) {
      it.bars.forEach(function (b) { b.remove(); });
      it.bars = want.map(function (k) { var b = mkBar(k === 'y' ? 'y' : 'x', k === 'xh' ? 'head' : ''); b._it = it; b._k = k; L.appendChild(b); return b; });
      it.key = key;
    }
    it.t = Date.now(); it.on = true;
    it.bars.forEach(function (b) { b.classList.add('is-on'); });
    loop();
  }
  function place(it) {
    var el = it.el;
    if (!el.isConnected) { it.bars.forEach(function (b) { b.remove(); }); items.delete(el); return; }
    var r = rectOf(el), vw = R.clientWidth || innerWidth, vh = innerHeight;
    var top = Math.max(r.top, 0), bot = Math.min(r.bottom, vh), left = Math.max(r.left, 0), right = Math.min(r.right, vw);
    var vis = bot - top > 8 && right - left > 8;
    it.bars.forEach(function (b) {
      var th = b.firstChild, k = b._k;
      if (!vis) { b.style.display = 'none'; return; }
      b.style.display = '';
      if (k === 'y') {
        var trH = bot - top, ratio = el.clientHeight / el.scrollHeight, tH = Math.max(MIN_THUMB, trH * ratio);
        var max = el.scrollHeight - el.clientHeight, pos = max > 0 ? el.scrollTop / max : 0;
        b.style.cssText = 'left:' + (right - 14) + 'px;top:' + top + 'px;width:14px;height:' + trH + 'px';
        th.style.cssText = 'height:' + tH + 'px;transform:translateY(' + ((trH - tH) * pos) + 'px)';
      } else {
        var y0 = bot - 14;
        if (k === 'xh') {
          /* thanh trên: ngay dưới hàng tiêu đề, đè lên đầu thân bảng */
          var hd = el.querySelector('thead'), hb = hd ? hd.getBoundingClientRect().bottom : r.top;
          if (hb < top || hb + 14 > bot - 14) { b.style.display = 'none'; return; }
          y0 = hb;
        }
        var trW = right - left, ratioX = el.clientWidth / el.scrollWidth, tW = Math.max(MIN_THUMB, trW * ratioX);
        var maxX = el.scrollWidth - el.clientWidth, px = maxX > 0 ? el.scrollLeft / maxX : 0;
        b.style.cssText = 'left:' + left + 'px;top:' + y0 + 'px;height:14px;width:' + trW + 'px';
        th.style.cssText = 'width:' + tW + 'px;transform:translateX(' + ((trW - tW) * px) + 'px)';
      }
    });
  }
  function loop() { if (!raf) raf = requestAnimationFrame(tick); }
  function tick() {
    raf = 0; var now = Date.now(), any = false;
    items.forEach(function (it) {
      if (!it.on) return;
      var hot = drag && drag.it === it || it.bars.some(function (b) { return b.matches(':hover'); });
      if (hot) it.t = now;
      if (now - it.t > HIDE_MS) { it.on = false; it.bars.forEach(function (b) { b.classList.remove('is-on'); }); return; }
      place(it); any = true;
    });
    if (any) loop();
  }
  function chain(e) {
    var path = e.composedPath ? e.composedPath() : [], out = [];
    for (var i = 0; i < path.length; i++) {
      var n = path[i]; if (!n || n.nodeType !== 1) continue;
      if (n === D.body || n === R) break;
      if (n.classList && n.classList.contains('mp-osb-layer')) return [];
      if (n.scrollWidth - n.clientWidth > 1 || n.scrollHeight - n.clientHeight > 1) out.push(n);
    }
    out.push(docEl()); return out;
  }
  /* composedPath() chỉ có giá trị trong lúc sự kiện đang chạy: lấy chuỗi phần tử ngay, gom lại xử lý ở khung hình kế tiếp */
  var mmList = null;
  D.addEventListener('mousemove', function (e) {
    var first = !mmList; mmList = chain(e);
    if (first) requestAnimationFrame(function () { var l = mmList; mmList = null; l.forEach(wake); });
  }, { passive: true, capture: true });
  D.addEventListener('scroll', function (e) {
    var t = e.target; wake(t === D || t === R || t === D.body ? docEl() : t);
  }, { passive: true, capture: true });
  addEventListener('resize', function () { items.forEach(function (it) { if (it.on) place(it); }); }, { passive: true });

  function onDown(e, tr) {
    if (e.button !== 0) return;
    var it = tr._it, el = it.el, k = tr._k, th = tr.firstChild, vert = k === 'y';
    e.preventDefault(); e.stopPropagation();
    var tb = th.getBoundingClientRect(), trb = tr.getBoundingClientRect();
    var p = vert ? e.clientY : e.clientX;
    var a0 = vert ? tb.top : tb.left, a1 = vert ? tb.bottom : tb.right;
    if (p < a0 || p > a1) {
      var page = vert ? el.clientHeight : el.clientWidth, dir = p < a0 ? -1 : 1;
      if (vert) el.scrollTop += dir * page * 0.9; else el.scrollLeft += dir * page * 0.9;
      wake(el); return;
    }
    var span = (vert ? trb.height - tb.height : trb.width - tb.width) || 1;
    var max = vert ? el.scrollHeight - el.clientHeight : el.scrollWidth - el.clientWidth;
    drag = { it: it, start: p, s0: vert ? el.scrollTop : el.scrollLeft, k: max / span, vert: vert, tr: tr, id: e.pointerId };
    tr.classList.add('is-drag'); try { tr.setPointerCapture(e.pointerId); } catch (_) {}
    R.classList.add('mp-osb-dragging');
  }
  D.addEventListener('pointermove', function (e) {
    if (!drag) return;
    var d = ((drag.vert ? e.clientY : e.clientX) - drag.start) * drag.k, el = drag.it.el;
    if (drag.vert) el.scrollTop = drag.s0 + d; else el.scrollLeft = drag.s0 + d;
    drag.it.t = Date.now(); loop();
  }, true);
  function up() {
    if (!drag) return;
    drag.tr.classList.remove('is-drag'); try { drag.tr.releasePointerCapture(drag.id); } catch (_) {}
    R.classList.remove('mp-osb-dragging'); drag.it.t = Date.now(); drag = null; loop();
  }
  D.addEventListener('pointerup', up, true); D.addEventListener('pointercancel', up, true);
})();
