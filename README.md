# 隆众 ChartAI — Mac Excel 智能图表插件

一个运行在 **Mac 版 Office 365 Excel** 中的任务窗格加载项（Office Add-in）。接入 **DeepSeek**，提供类似 **ChartExpo** 的高级可视化（桑基图、旭日图、矩形树图、热力图、漏斗、仪表盘、瀑布图等），并可一键把图表插入工作表。

---

## 一、目录结构

```
LZ-ChartAI/
├── manifest.xml          # 加载项清单（旁加载用）
├── src/taskpane.html      # 任务窗格主体（UI + 全部逻辑，单文件）
├── assets/
│   ├── echarts.min.js     # 本地内置 ECharts（国内/离线可用，无需外网 CDN）
│   └── icon-*.png         # 插件图标（隆众配色）
├── serve.sh               # 一键启动本地 HTTPS 服务
└── sideload-mac.sh        # 一键把 manifest 旁加载到 Excel
```

---

## 二、快速开始（本地 HTTPS，推荐）

Office 加载项**强制要求 HTTPS**，本地需用受信任证书。已为你封装好两条命令。

**1. 启动服务**（保持这个终端窗口开着）
```bash
cd LZ-ChartAI
./serve.sh
```
首次会自动安装 `office-addin-dev-certs`、`http-server`，并弹出钥匙串授权（输入开机密码以信任本地证书）。看到 `https://localhost:3000` 即成功。

**2. 旁加载插件**（另开一个终端）
```bash
cd LZ-ChartAI
./sideload-mac.sh
```

**3. 重启 Excel**（⌘Q 完全退出再打开），在「开始」选项卡找到 **隆众 ChartAI → 智能图表**，点击打开任务窗格。

> 卸载：删除 `~/Library/Containers/com.microsoft.Excel/Data/Documents/wef/manifest.xml` 后重启 Excel。

---

## 三、替代方案（GitHub Pages，免本地服务、长期在线）

不想每次开终端时，可把文件托管到 GitHub Pages：

1. 把整个文件夹推到一个 GitHub 仓库，开启 Pages（Settings → Pages → 选 main 分支）。
2. 得到形如 `https://你的用户名.github.io/仓库名/` 的地址。
3. 把 `manifest.xml` 里**所有** `https://localhost:3000` 批量替换为该地址（去掉末尾多余斜杠）。
4. 运行 `./sideload-mac.sh`，重启 Excel。

之后无需 `serve.sh`，插件始终可用。

---

## 四、使用流程

1. 在「**API 设置**」里填入 DeepSeek API Key（`sk-...`）→ 保存 → 测试连接。
2. 在 Excel 中**选中数据区域** → 任务窗格点「**读取当前选区**」。
3. 三种出图方式任选：
   - **AI 生成**：用中文描述（如"做成桑基图展示原油来源到炼厂的流向"）→ AI 生成图表。
   - **图表模板**：直接点选桑基图/旭日图/热力图等，按数据格式提示自动渲染。
   - **推荐图表 / 数据洞察**：让 AI 分析数据并给建议或关键结论。
4. 点「**插入到工作表**」把图表作为图片插入，或「下载 PNG」。

---

## 五、关于 API 与跨域（重要）

- **预留的 API 输入框**：除 API Key 外，还预留了「**API 地址**」与「**模型**」两个输入框。默认指向 `https://api.deepseek.com` 与 `deepseek-chat`，可随时改成其它兼容 OpenAI 协议的端点或你的代理。
- **CORS**：浏览器/加载项的 webview 直连 `api.deepseek.com` 可能因跨域被拦。若「测试连接」报 CORS / Failed to fetch：
  - 自建一个反向代理（如 Cloudflare Workers / Nginx），透传 `/chat/completions` 并补上 `Access-Control-Allow-Origin: *`；
  - 把任务窗格里的「API 地址」改为你的代理地址即可，其余无需改动。
- Key 仅存于本机 `localStorage`，不会上传到除所配置 API 地址以外的任何服务器。

---

## 六、支持的图表类型与数据格式

| 图表 | 数据格式（按列） |
|---|---|
| 柱状图 / 折线图 | 第一列=类别，其余各列=数值系列 |
| 饼图 / 漏斗图 | 第一列=名称，第二列=数值 |
| 雷达图 | 第一列=维度，其余各列=系列 |
| 仪表盘 | 取所选区域第一个数值 |
| 散点 / 气泡 | 列1=X，列2=Y，列3=气泡大小(可选) |
| 桑基图 | 三列：源、目标、数值 |
| 旭日图 / 矩形树图 | 末列=数值，前面各列=层级路径 |
| 热力图 | 三列：X类别、Y类别、数值 |
| 瀑布图 | 第一列=类别，第二列=数值(可正可负) |

模板覆盖不到的图型（如 Likert 双向堆叠、ThemeRiver 等），直接用「AI 生成」描述即可，AI 会返回对应的 ECharts 配置渲染。

---

## 七、技术说明

- 图表引擎：Apache ECharts 5（本地内置，无外网依赖）。
- 与 Excel 交互：Office.js（`Excel.run` 读选区、`shapes.addImage` 插图）。需 ExcelApi 1.9+，Mac 版 Office 365 当前版本均满足。
- 配色遵循隆众资讯品牌：navy `#003880` / red `#C02828` 及配套色。
