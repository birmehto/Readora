package com.app.readora

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "app.channel.shared.data"
    private var sharedUrl: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent?) {
        when (intent?.action) {
            Intent.ACTION_SEND -> {
                if (intent.type == "text/plain") {
                    sharedUrl = intent.getStringExtra(Intent.EXTRA_TEXT)
                }
            }
            Intent.ACTION_VIEW -> {
                sharedUrl = intent.dataString
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitialUrl" -> {
                    result.success(sharedUrl)
                    sharedUrl = null // Clear after sending
                }
                "shareUrl" -> {
                    val url = call.argument<String>("url")
                    val title = call.argument<String>("title")
                    shareUrl(url, title)
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
        
        // Notify Flutter about shared URL if app is already running
        sharedUrl?.let { url ->
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
                .invokeMethod("handleSharedUrl", url)
            sharedUrl = null
        }
    }

    private fun shareUrl(url: String?, title: String?) {
        val shareIntent = Intent().apply {
            action = Intent.ACTION_SEND
            type = "text/plain"
            putExtra(Intent.EXTRA_TEXT, url)
            putExtra(Intent.EXTRA_SUBJECT, title)
        }
        startActivity(Intent.createChooser(shareIntent, "Share Article"))
    }
}
