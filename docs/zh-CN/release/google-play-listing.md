# Google Play 商店上架 — 文字素材

> **唯一真值（SSOT）**：本文档是 Google Play 商店所有上架文字的唯一来源。更新 Play Console 时，从此处复制文字。

## 概览

| 字段 | 值 |
|------|-----|
| 包名 | `com.hachimi.hachimi_app` |
| 类别 | 生产力工具（Productivity） |
| 内容分级 | 适合所有人（Everyone） |
| 包含广告 | 否 |
| 隐私政策 | `https://hachimi.ai/en/privacy` |
| 支持语言 | en-US、zh-CN、zh-TW、ja-JP、ko-KR |
| 数据安全 | 参见 `docs/release/google-play-setup.md` 第 6c 步 |

---

## 英语（en-US）

### 应用名称（≤ 30 字符）

```
Hachimi - Cat Habit Tracker
```

### 简短描述（≤ 80 字符）

```
Adopt pixel cats that grow as you build habits. Focus timer and AI chat inside.
```

### 完整描述（≤ 4000 字符）

参见英文版 `docs/release/google-play-listing.md` 中的 English (en-US) 部分。

---

## 简体中文（zh-CN）

### 应用名称（≤ 30 字符）

```
Hachimi - 猫咪习惯养成
```

### 简短描述（≤ 80 字符）

```
领养像素猫咪，在养成习惯的过程中看它们成长。内置专注计时器和 AI 聊天。
```

### 完整描述（≤ 4000 字符）

参见英文版 `docs/release/google-play-listing.md` 中的 Simplified Chinese (zh-CN) 部分。

---

## 繁体中文（zh-TW）

### 应用名称（≤ 30 字符）

```
Hachimi - 貓咪習慣養成
```

### 简短描述（≤ 80 字符）

```
領養像素貓咪，在養成習慣的過程中看牠們成長。內建專注計時器和 AI 聊天。
```

### 完整描述（≤ 4000 字符）

参见英文版 `docs/release/google-play-listing.md` 中的 Traditional Chinese (zh-TW) 部分。

---

## 日语（ja-JP）

### 应用名称（≤ 30 字符）

```
Hachimi - 猫育て習慣トラッカー
```

### 简短描述（≤ 80 字符）

```
ピクセル猫を育てながら習慣を身につけよう。集中タイマーとAIチャット搭載。
```

### 完整描述（≤ 4000 字符）

参见英文版 `docs/release/google-play-listing.md` 中的 Japanese (ja-JP) 部分。

---

## 韩语（ko-KR）

### 应用名称（≤ 30 字符）

```
하치미 - 고양이 습관 트래커
```

### 简短描述（≤ 80 字符）

```
픽셀 고양이를 키우며 습관을 만들어 보세요. 집중 타이머와 AI 채팅 포함.
```

### 完整描述（≤ 4000 字符）

参见英文版 `docs/release/google-play-listing.md` 中的 Korean (ko-KR) 部分。

---

## 版本发布信息

### Release Name 格式

```
{语义化版本} ({构建号})
```

示例：`2.24.0 (58)` — 对应 `pubspec.yaml` 中的 `2.24.0+58`。

### Release Notes

Release Notes 以纯文本文件形式存储在 `distribution/whatsnew/` 目录：

```
distribution/whatsnew/
├── whatsnew-en-US
├── whatsnew-zh-CN
├── whatsnew-zh-TW
├── whatsnew-ja-JP
└── whatsnew-ko-KR
```

文件命名遵循 `r0adkll/upload-google-play@v1` 规范：`whatsnew-{BCP47 语言代码}`。

每个文件内容不超过 500 字符。

---

## 变更记录

| 日期 | 变更 |
|------|------|
| 2026-03-02 | 初始创建，用于 v2.24.0 首次上架 Google Play |
