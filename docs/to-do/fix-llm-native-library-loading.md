# 修复 AI 模型加载失败 — Native Library 编译问题

**Status**: In Progress
**Created**: 2026-02-20
**Priority**: Critical — AI 功能完全不可用

---

## 问题描述

用户下载完 AI 模型后点击"测试模型"，出现"模型加载失败，无法加载模型"错误。

### 根本原因

APK 中 **完全没有** llama.cpp 的 native `.so` 文件（libmtmd.so / libllama.so / libggml.so）。

验证命令：
```bash
unzip -l app-release.apk | grep "\.so"
# 结果：只有 libapp.so, libflutter.so, libdatastore_shared_counter.so
# 没有任何 llama 相关的 .so 文件
```

### 原因链

1. `llamalib/build.gradle` 第 27 行有硬编码路径：`-DCMAKE_PROJECT_INCLUDE=/Users/adel/Workspace/...`（原作者的机器路径），本机不存在
2. CMake 构建失败 → native `.so` 未编译
3. `DynamicLibrary.open("libmtmd.so")` 失败 → 模型加载抛异常
4. `LlmAvailabilityNotifier.loadModel()` 吞掉了异常（catch 后不 rethrow），UI 只显示通用错误

---

## 执行计划

### Step 1: 修复 native library 编译问题 — DONE

**文件**：`packages/llama_cpp_dart/android/llamalib/build.gradle`

- [x] 删除硬编码路径 `-DCMAKE_PROJECT_INCLUDE=/Users/adel/Workspace/llama_cpp_dart/darwin/no_bundle.cmake`
- 这行是原作者（adel）为 macOS/Darwin 构建时用的，Android 构建不需要
- 保留其余 CMake 参数（OpenCL、C++17 等）

### Step 2: 修复错误吞没问题 — DONE

**文件**：`lib/providers/llm_provider.dart`（第 137-139 行）

- [x] `LlmAvailabilityNotifier.loadModel()` 的 catch 块添加 `rethrow`，让 UI 层能拿到实际错误消息

### Step 3: 构建 debug APK 并验证 — TODO

```bash
# 1. 清理并重新构建
flutter clean && flutter pub get
flutter build apk --debug

# 2. 验证 native .so 文件存在
unzip -l build/app/outputs/flutter-apk/app-debug.apk | grep "\.so"
# 期望看到：lib/arm64-v8a/libmtmd.so, libllama.so, libggml.so

# 3. 安装到 vivo 测试
adb shell settings put global package_verifier_enable 0
adb install -r -t -d build/app/outputs/flutter-apk/app-debug.apk

# 4. 测试模型加载
# 打开 AI 功能 → 下载模型 → 测试模型 → 应能正常加载

# 5. 检查 logcat 无 native library 加载错误
adb logcat -c && adb logcat -s flutter
```

### Step 4: 如果 Step 3 仍失败 — 排查 CMake — TODO (contingency)

检查构建日志中 CMake 相关输出，可能需要：

1. **确认 NDK 版本匹配**：llamalib 要求 `29.0.13846066`
   ```bash
   ls $ANDROID_HOME/ndk/
   ```
2. **确认 OpenCL 预编译库路径正确**：检查 CMake 能否找到 OpenCL headers/libs
3. **暂时关闭 OpenCL**（降级方案）：先验证 CPU-only 推理
   - 修改 `llamalib/build.gradle`：`-DGGML_OPENCL=OFF`
   - 如果 CPU-only 构建成功，说明问题在 OpenCL 依赖
4. **检查构建日志**：
   ```bash
   # 保存完整构建日志
   flutter build apk --debug -v 2>&1 | tee /tmp/build_debug.log
   # 搜索 CMake 错误
   grep -i "error\|fatal\|failed" /tmp/build_debug.log | head -20
   ```

---

## 关键文件

| 文件 | 修改内容 | 状态 |
|------|----------|------|
| `packages/llama_cpp_dart/android/llamalib/build.gradle` | 删除硬编码 CMake 路径 | Done |
| `lib/providers/llm_provider.dart` | loadModel() 错误传播（rethrow） | Done |

## 验证清单

- [ ] `unzip -l app-debug.apk | grep mtmd` → 必须看到 `lib/arm64-v8a/libmtmd.so`
- [ ] 安装 debug APK → 打开 AI 功能 → 下载模型 → 测试模型 → 应能正常加载
- [ ] `adb logcat -s flutter` → 确认无 native library 加载错误

---

## 注意事项

- 首次 CMake 编译 llama.cpp 需要 5-10 分钟，**不要同时开多个构建进程**，否则会卡死
- 确保电脑空闲时再执行构建
- Debug APK 用于调试，Release APK 用于发布，日常开发一律用 debug
