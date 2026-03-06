// ---
// 📘 文件说明：
// Flutter 主 Activity — 注册 Hachimi 自定义 MethodChannel，
// 用于原子岛富通知的 Dart ↔ Kotlin 通信。
//
// 📋 程序整体伪代码（中文）：
// 1. configureFlutterEngine() 中创建通知渠道；
// 2. 注册 "com.hachimi.notification" MethodChannel；
// 3. 根据 method name 分发至 FocusNotificationHelper；
//
// 🧩 文件结构：
// - MainActivity：FlutterActivity 子类 + MethodChannel 注册；
//
// 🕒 创建时间：2026-02-19
// ---

package com.hachimi.hachimi_app

import android.os.Bundle
import androidx.activity.enableEdgeToEdge
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        FocusNotificationHelper.ensureChannel(this)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.hachimi.notification")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "updateTimerNotification" -> {
                        FocusNotificationHelper.updateNotification(
                            context = this,
                            title = call.argument<String>("title") ?: "",
                            text = call.argument<String>("text") ?: "",
                            subText = call.argument<String>("subText") ?: "Hachimi",
                            endTimeMs = call.argument<Number>("endTimeMs")?.toLong(),
                            startTimeMs = call.argument<Number>("startTimeMs")?.toLong(),
                            isCountdown = call.argument<Boolean>("isCountdown") ?: true,
                            isPaused = call.argument<Boolean>("isPaused") ?: false,
                        )
                        result.success(null)
                    }
                    "cancelTimerNotification" -> {
                        FocusNotificationHelper.cancel(this)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
