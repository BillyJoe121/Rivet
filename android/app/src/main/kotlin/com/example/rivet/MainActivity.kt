package com.example.rivet

import android.app.Activity
import android.content.Intent
import android.graphics.Bitmap
import android.os.Build
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {
    private val channelName = "com.example.rivet/camera"
    private val requestImageCapture = 4102
    private var pendingCameraResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                if (call.method == "takePhoto") {
                    if (pendingCameraResult != null) {
                        result.error("BUSY", "La cámara ya está abierta.", null)
                        return@setMethodCallHandler
                    }
                    val intent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
                    try {
                        pendingCameraResult = result
                        startActivityForResult(intent, requestImageCapture)
                    } catch (e: Exception) {
                        pendingCameraResult = null
                        result.error("NO_CAMERA", "No se encontró aplicación de cámara.", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == requestImageCapture) {
            val callback = pendingCameraResult
            pendingCameraResult = null
            if (callback == null) return

            if (resultCode == Activity.RESULT_OK) {
                val bitmap: Bitmap? = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    data?.extras?.getParcelable("data", Bitmap::class.java)
                } else {
                    @Suppress("DEPRECATION")
                    data?.extras?.get("data") as? Bitmap
                }
                if (bitmap != null) {
                    val outFile = File(cacheDir, "rivet_cam_${System.currentTimeMillis()}.jpg")
                    FileOutputStream(outFile).use { stream ->
                        bitmap.compress(Bitmap.CompressFormat.JPEG, 92, stream)
                    }
                    callback.success(outFile.absolutePath)
                } else {
                    callback.success(null)
                }
            } else {
                callback.success(null)
            }
        }
    }
}
