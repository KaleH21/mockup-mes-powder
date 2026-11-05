// Chạy mockup ở máy: node serve.mjs [cổng]  → http://localhost:4321/
// "/" = toàn cảnh canvas (dựng từ canvas.json), "/<Man>.dc.html" = từng màn.
// support.js = runtime canvas (runtime/artifact-type/dc-runtime.js, tải từ artifact công khai).
import http from "node:http";
import fs from "node:fs";
import path from "node:path";
import os from "node:os";
import { fileURLToPath } from "node:url";

const HERE = path.dirname(fileURLToPath(import.meta.url));
const PROJECT = path.join(HERE, "mes-powder-canvas", "project");
const ALIAS = {
  "/support.js": path.join(HERE, "runtime", "artifact-type", "dc-runtime.js"),
  "/_blob/1ac7da4f2947094995f1ad52291bf36c": path.join(HERE, "mp-scroll.js"),
  "/": path.join(HERE, "canvas-view.html"),
};
const TYPES = {
  ".html": "text/html",
  ".js": "text/javascript",
  ".css": "text/css",
  ".json": "application/json",
  ".woff2": "font/woff2",
};
const PORT = Number(process.argv[2] || process.env.PORT || 4321);

http
  .createServer((req, res) => {
    const url = decodeURIComponent(new URL(req.url, "http://x").pathname);
    const file = ALIAS[url] ?? path.join(PROJECT, path.normalize(url));
    // chặn ../ thoát khỏi thư mục project
    if (!ALIAS[url] && !file.startsWith(PROJECT + path.sep)) {
      res.writeHead(403).end();
      return;
    }
    fs.readFile(file, (err, data) => {
      if (err) {
        res.writeHead(404).end("Không có: " + url);
        return;
      }
      // _blob không có đuôi file → là JS
      const type =
        TYPES[path.extname(file)] ||
        (url.startsWith("/_blob/")
          ? "text/javascript"
          : "application/octet-stream");
      res
        .writeHead(200, {
          "Content-Type": type + "; charset=utf-8",
          "Cache-Control": "no-store",
        })
        .end(data);
    });
  })
  .listen(PORT, () => {
    // không truyền host → nghe mọi card mạng, máy khác trong LAN vào được bằng IP
    const lan = Object.values(os.networkInterfaces())
      .flat()
      .filter((i) => i.family === "IPv4" && !i.internal);
    console.log(`Mockup: http://localhost:${PORT}/`);
    for (const i of lan) console.log(`  LAN:  http://${i.address}:${PORT}/`);
  });
