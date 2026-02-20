# 修复 AI 模型加载失败 — Native Library 编译问题

**Status**: Build Verified
**Created**: 2026-02-20
**Verified**: 2026-02-20
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

### Step 3: 构建 debug APK 并验证 — DONE

构建验证于 2026-02-20 在 Linux (阿里云 ECS) 完成。

**发现的额外问题与修复：**

1. **Flutter 插件注册缺失**：`llama_cpp_dart/pubspec.yaml` 缺少 `flutter.plugin.platforms` 声明，Flutter 不会编译其 native 代码
   - 修复：添加 `ffiPlugin: true` 声明（android / linux / macos）
2. **CMake 参数缺失**：`llama_cpp_dart/android/build.gradle`（主插件）缺少 cmake arguments（BUILD_SHARED_LIBS、OpenCL 等）
   - 修复：从 `llamalib/build.gradle` 移植 cmake arguments
3. **NDK 版本不匹配**：插件使用 `android.ndkVersion`（Flutter 默认 27.x），但需要 NDK 29
   - 修复：硬编码 `ndkVersion "29.0.13846066"`
4. **mtmd 源文件缺失**：`src/CMakeLists.txt` 的 mtmd target 未编译 `models/` 子目录下的 clip 实现文件
   - 修复：添加所有 15 个 model .cpp 文件到 `add_library(mtmd ...)`

**验证结果：**

```
unzip -l app-debug.apk | grep -E "(libmtmd|libllama|libggml)"
  938440  lib/arm64-v8a/libggml-base.so
 1258720  lib/arm64-v8a/libggml-cpu.so
 1005760  lib/arm64-v8a/libggml-opencl.so
  129240  lib/arm64-v8a/libggml.so
 5292024  lib/arm64-v8a/libllama.so
 1433024  lib/arm64-v8a/libmtmd.so
  905872  lib/x86_64/libggml-base.so
 1074992  lib/x86_64/libggml-cpu.so
 1003976  lib/x86_64/libggml-opencl.so
  119976  lib/x86_64/libggml.so
 5179752  lib/x86_64/libllama.so
 1480272  lib/x86_64/libmtmd.so
```

### Step 4: 设备测试 — TODO

构建验证通过，待在 vivo 设备上测试模型加载：

```bash
adb shell settings put global package_verifier_enable 0
adb install -r -t -d build/app/outputs/flutter-apk/app-debug.apk
# 打开 AI 功能 → 下载模型 → 测试模型 → 应能正常加载
adb logcat -c && adb logcat -s flutter
```

---

## 关键文件

| 文件 | 修改内容 | 状态 |
|------|----------|------|
| `packages/llama_cpp_dart/android/llamalib/build.gradle` | 删除硬编码 CMake 路径 | Done |
| `lib/providers/llm_provider.dart` | loadModel() 错误传播（rethrow） | Done |
| `packages/llama_cpp_dart/pubspec.yaml` | 添加 `flutter.plugin.platforms` ffiPlugin 声明 | Done |
| `packages/llama_cpp_dart/android/build.gradle` | 添加 cmake arguments、固定 NDK 版本、指定 cmake 3.22.1 | Done |
| `packages/llama_cpp_dart/src/CMakeLists.txt` | mtmd target 添加 models/ 子目录全部 cpp 文件 | Done |

## 验证清单

- [x] `unzip -l app-debug.apk | grep mtmd` → 必须看到 `lib/arm64-v8a/libmtmd.so` ✓
- [x] APK 包含全部 native 库（libmtmd.so + libllama.so + libggml*.so，arm64-v8a + x86_64）✓
- [ ] 安装 debug APK → 打开 AI 功能 → 下载模型 → 测试模型 → 应能正常加载
- [ ] `adb logcat -s flutter` → 确认无 native library 加载错误

---

## 注意事项

- 首次 CMake 编译 llama.cpp 需要 5-10 分钟，**不要同时开多个构建进程**，否则会卡死
- 确保电脑空闲时再执行构建
- Debug APK 用于调试，Release APK 用于发布，日常开发一律用 debug
