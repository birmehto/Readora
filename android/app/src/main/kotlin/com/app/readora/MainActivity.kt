package com.app.readora

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private companion object {
        const val CHANNEL = "app.channel.shared.data"
    }

    private var pendingSharedUrl: String? = null
    private lateinit var channel: MethodChannel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        extractSharedUrl(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        extractSharedUrl(intent)
        notifyFlutterIfReady()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL,
        ).apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "getInitialUrl" -> {
                        result.success(pendingSharedUrl)
                        pendingSharedUrl = null
                    }
                    "shareUrl" -> {
                        shareUrl(
                            call.argument("url"),
                            call.argument("title"),
                        )
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
        }

        notifyFlutterIfReady()
    }

    // ─────────────────────────────────────────────

    private fun extractSharedUrl(intent: Intent?) {
        pendingSharedUrl = when (intent?.action) {
            Intent.ACTION_SEND ->
                intent.takeIf { it.type == "text/plain" }
                    ?.getStringExtra(Intent.EXTRA_TEXT)

            Intent.ACTION_VIEW ->
                intent.dataString

            else -> pendingSharedUrl
        }
    }

    private fun notifyFlutterIfReady() {
        val url = pendingSharedUrl ?: return
        if (::channel.isInitialized) {
            channel.invokeMethod("handleSharedUrl", url)
            pendingSharedUrl = null
        }
    }

    private fun shareUrl(url: String?, title: String?) {
        if (url.isNullOrEmpty()) return

        startActivity(
            Intent.createChooser(
                Intent(Intent.ACTION_SEND).apply {
                    type = "text/plain"
                    putExtra(Intent.EXTRA_TEXT, url)
                    putExtra(Intent.EXTRA_SUBJECT, title)
                },
                "Share Article",
            ),
        )
    }
}
