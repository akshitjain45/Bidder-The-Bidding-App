package com.example.bidding_app

import io.flutter.embedding.android.FlutterActivity
// import android.os.Bundle
// import android.content.Intent
// import android.net.Uri
// import io.flutter.plugin.common.MethodCall
// import io.flutter.plugin.common.MethodChannel
// import io.flutter.plugin.common.MethodChannel.MethodCallHandler
// import io.flutter.plugins.GeneratedPluginRegistrant
// import androidx.annotation.NonNull
// import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {

// private var sharedText: String? = null
// private var sharedImage: ByteArray? = null;

// override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//     GeneratedPluginRegistrant.registerWith(flutterEngine)
//     handleShareIntent(getIntent())
//     MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "app.channel.shared.data")
//             .setMethodCallHandler { call, result ->
//               if (call.method.contentEquals("getSharedText")) {
//                 result.success(sharedText)
//                 sharedText = null
//               }
//               if (call.method.contentEquals("getSharedImage")) {
//                 result.success(sharedImage)
//                 sharedImage = null
//               }
//             }
//   }

//   override fun onNewIntent(intent: Intent) {
//     super.onNewIntent(intent);
//     handleShareIntent(intent);
//   }

//   fun handleShareIntent(intent: Intent) {

//     if (intent.type?.startsWith("image/") == true) 
//       handleSendImage(intent)
//     handleSendText(intent)
//   }

//   fun handleSendText(intent : Intent) {
//     sharedText = intent.getStringExtra(Intent.EXTRA_TEXT)
//   }

//   fun handleSendImage(intent : Intent) {
//     val uri: Uri = intent.getClipData()?.getItemAt(0)!!.getUri()
//     val inputStream = contentResolver.openInputStream(uri)
//     sharedImage = inputStream?.readBytes()
//   }
}
