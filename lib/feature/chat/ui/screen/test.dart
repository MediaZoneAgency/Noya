// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; // قد تحتاج لاستيراد هذا
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_android/webview_flutter_android.dart';

// class ConversationPage extends StatefulWidget {
//   const ConversationPage({super.key});

//   @override
//   State<ConversationPage> createState() => _ConversationPageState();
// }

// class _ConversationPageState extends State<ConversationPage> {
//   late final WebViewController _controller;

//   @override
//   void initState() {
//     super.initState();

//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) => debugPrint('WebView loading (progress : $progress%)'),
//           onPageFinished: (String url) => debugPrint('Page finished loading: $url'),
//           onWebResourceError: (WebResourceError error) => debugPrint('''
//             Page resource error:
//             code: ${error.errorCode}
//             description: ${error.description}
//             errorType: ${error.errorType}
//             isForMainFrame: ${error.isForMainFrame}
//           '''),
//         ),
//       );

//     // هذا الكود لمنح الإذن ما زال ضروريًا جدًا
//     if (_controller.platform is AndroidWebViewController) {
//       final androidController = _controller.platform as AndroidWebViewController;
//       androidController.setOnPlatformPermissionRequest(
//         (PlatformWebViewPermissionRequest request) {
//           debugPrint('Permission requested for types: ${request.types}');
//           if (request.types.contains(WebViewPermissionResourceType.microphone)) {
//             request.grant();
//           } else {
//             request.deny();
//           }
//         },
//       );
//     }

//     // *** التغيير الرئيسي هنا ***
//     // نقوم الآن بتحميل الملف من مجلد assets
//     _loadHtmlFromAssets();
//   }
  
//   // دالة جديدة لتحميل الملف
//   Future<void> _loadHtmlFromAssets() async {
//     await _controller.loadFlutterAsset('assets/elevenlabs_widget.html');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('ElevenLabs Conversation'),
//       ),
//       body: WebViewWidget(
//         controller: _controller,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class StyledConversationPage extends StatefulWidget {
  const StyledConversationPage({super.key});

  @override
  State<StyledConversationPage> createState() => _StyledConversationPageState();
}

class _StyledConversationPageState extends State<StyledConversationPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // *** التغيير الأهم: جعل خلفية WebView شفافة ***
      ..setBackgroundColor(const Color(0x00000000)) 
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) => debugPrint('WebView loading (progress : $progress%)'),
        ),
      );

    // كود طلب الإذن يبقى كما هو لأنه ضروري
    if (_controller.platform is AndroidWebViewController) {
      final androidController = _controller.platform as AndroidWebViewController;
      androidController.setOnPlatformPermissionRequest(
        (PlatformWebViewPermissionRequest request) {
          debugPrint('Permission requested for types: ${request.types}');
          request.grant(); // الموافقة على كل الأذونات المطلوبة
        },
      );
    }

    _loadHtmlFromAssets();
  }

  Future<void> _loadHtmlFromAssets() async {
    // سنقوم بتعديل هذا الملف في الخطوة التالية
    await _controller.loadFlutterAsset('assets/elevenlabs_widget.html');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // لون الخلفية الداكن للتطبيق كله
      backgroundColor: const Color(0xFF0D1F1E), 
      body: SafeArea(
        child: Column(
          children: [
            // 1. الـ AppBar المخصص الذي سنقوم ببنائه
            const _CustomAppBar(),
            
            // 2. مسافة صغيرة بين الـ AppBar والمحتوى
            const SizedBox(height: 20),

            // 3. الـ WebView يأخذ كل المساحة المتبقية
            Expanded(
              child: WebViewWidget(
                controller: _controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ويدجت خاصة بالـ AppBar المخصص
class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // أيقونة القائمة على اليسار
          const Icon(Icons.menu, color: Colors.white, size: 30),
          
          // شعار التطبيق في المنتصف (استخدمت أيقونة مؤقتة)
          const Icon(Icons.hub_outlined, color: Colors.white, size: 35),
          
          // صورة المستخدم على اليمين
          const CircleAvatar(
            radius: 20,
            // يمكنك استخدام NetworkImage لتحميل صورة من الإنترنت
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=a042581f4e29026704d'),
          ),
        ],
      ),
    );
  }
}