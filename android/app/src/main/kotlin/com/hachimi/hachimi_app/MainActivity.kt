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
import android.util.Base64
import androidx.activity.enableEdgeToEdge
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        // 固定 App Check Debug Token — 从 local.properties 注入，避免每次重新生成
        val token = BuildConfig.APP_CHECK_DEBUG_TOKEN
        if (token.isNotEmpty()) {
            injectAppCheckDebugToken(token)
        }
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)
    }

    /**
     * Firebase App Check SDK 的 SharedPreferences 文件名格式：
     * "com.google.firebase.appcheck.debug.store." + base64([DEFAULT]) + "+" + base64(appId)
     *
     * 将固定 token 写入两个可能的文件名：编码版（SDK 实际使用）+ [DEFAULT]（兜底）。
     */
    private fun injectAppCheckDebugToken(token: String) {
        val key = "com.google.firebase.appcheck.debug.DEBUG_SECRET"
        val appId = BuildConfig.FIREBASE_APP_ID

        // 主文件名（带 App ID 编码）— Firebase SDK 实际读取的文件
        if (appId.isNotEmpty()) {
            val defaultB64 = Base64.encodeToString(
                "[DEFAULT]".toByteArray(Charsets.UTF_8), Base64.NO_WRAP
            )
            val appIdB64 = Base64.encodeToString(
                appId.toByteArray(Charsets.UTF_8), Base64.NO_WRAP
            )
            val prefsName = "com.google.firebase.appcheck.debug.store.$defaultB64+$appIdB64"
            getSharedPreferences(prefsName, MODE_PRIVATE).edit()
                .putString(key, token)
                .apply()
        }

        // 兼容文件名（[DEFAULT]）— 兜底
        getSharedPreferences(
            "com.google.firebase.appcheck.debug.store.[DEFAULT]",
            MODE_PRIVATE
        ).edit()
            .putString(key, token)
            .apply()
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
