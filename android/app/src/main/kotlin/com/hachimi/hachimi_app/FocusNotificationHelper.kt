// ---
// 📘 文件说明：
// vivo 原子岛 / Android 16 ProgressStyle 富通知构建器。
// 通过标准 Android 通知元数据（CATEGORY_STOPWATCH + chronometer）
// 让 OriginOS 自动识别并将倒计时提升至原子岛胶囊。
//
// 📋 程序整体伪代码（中文）：
// 1. ensureChannel() 创建 HIGH importance 通知渠道，删除旧渠道；
// 2. updateNotification() 构建富通知并发送；
// 3. cancel() 取消指定 ID 的通知；
//
// 🧩 文件结构：
// - FocusNotificationHelper：单例对象，包含渠道管理和通知构建逻辑；
//
// 🕒 创建时间：2026-02-19
// ---

package com.hachimi.hachimi_app

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat

object FocusNotificationHelper {
    private const val CHANNEL_ID = "hachimi_focus_timer_v2"
    private const val OLD_CHANNEL_ID = "hachimi_focus_timer"
    private const val NOTIFICATION_ID = 1000

    fun ensureChannel(context: Context) {
        val nm = context.getSystemService(NotificationManager::class.java)

        // 创建新渠道（HIGH importance，静音）
        val channel = NotificationChannel(
            CHANNEL_ID,
            "Focus Timer",
            NotificationManager.IMPORTANCE_HIGH
        ).apply {
            description = "Focus timer countdown on status bar and lock screen"
            setShowBadge(false)
            enableVibration(false)
            setSound(null, null)
        }
        nm.createNotificationChannel(channel)

        // 删除旧渠道
        nm.deleteNotificationChannel(OLD_CHANNEL_ID)
    }

    fun updateNotification(
        context: Context,
        title: String,
        text: String,
        subText: String,
        endTimeMs: Long?,
        startTimeMs: Long?,
        isCountdown: Boolean,
        isPaused: Boolean,
    ) {
        val builder = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setLargeIcon(
                BitmapFactory.decodeResource(context.resources, R.mipmap.ic_launcher)
            )
            .setContentTitle(title)
            .setContentText(text)
            .setSubText(subText)
            .setCategory(NotificationCompat.CATEGORY_STOPWATCH)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setShowWhen(true)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setContentIntent(getLaunchPendingIntent(context))

        if (!isPaused) {
            builder.setUsesChronometer(true)
            builder.setChronometerCountDown(isCountdown)
            if (isCountdown && endTimeMs != null) {
                builder.setWhen(endTimeMs)
            } else if (!isCountdown && startTimeMs != null) {
                builder.setWhen(startTimeMs)
            }
        } else {
            // 暂停时停止 chronometer，显示静态文本
            builder.setUsesChronometer(false)
        }

        // Android 16+ ProgressStyle
        if (Build.VERSION.SDK_INT >= 36 && !isPaused && startTimeMs != null && endTimeMs != null && isCountdown) {
            applyProgressStyle(context, builder, startTimeMs, endTimeMs)
        }

        NotificationManagerCompat.from(context).notify(NOTIFICATION_ID, builder.build())
    }

    private fun applyProgressStyle(
        context: Context,
        builder: NotificationCompat.Builder,
        startTimeMs: Long,
        endTimeMs: Long,
    ) {
        // Android 16 ProgressStyle requires native Notification.Builder
        // We set the progress extras that the system reads for promoted notifications
        if (Build.VERSION.SDK_INT >= 36) {
            try {
                val totalDuration = endTimeMs - startTimeMs
                val elapsed = System.currentTimeMillis() - startTimeMs
                val progress = ((elapsed.toFloat() / totalDuration) * 100).toInt().coerceIn(0, 100)
                builder.setProgress(100, progress, false)
            } catch (_: Exception) {
                // 静默失败 — 基础通知仍然可用
            }
        }
    }

    fun cancel(context: Context) {
        NotificationManagerCompat.from(context).cancel(NOTIFICATION_ID)
    }

    private fun getLaunchPendingIntent(context: Context): PendingIntent {
        val intent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        return PendingIntent.getActivity(
            context,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }
}
