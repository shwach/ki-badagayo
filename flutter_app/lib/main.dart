import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const KiBadagayoApp());
}

class KiBadagayoApp extends StatelessWidget {
  const KiBadagayoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '기받아가요',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFA78BFA)),
      ),
      home: const WebViewPage(),
    );
  }
}

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFF8F6FF))
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (req) {
          // 외부 링크는 앱 안에서만 처리
          if (req.url.startsWith('https://kibadagayo.site') ||
              req.url.startsWith('https://www.gstatic.com') ||
              req.url.startsWith('https://firestore.googleapis.com') ||
              req.url.startsWith('https://identitytoolkit.googleapis.com') ||
              req.url.startsWith('https://securetoken.googleapis.com')) {
            return NavigationDecision.navigate;
          }
          return NavigationDecision.prevent;
        },
      ))
      ..loadRequest(Uri.parse('https://kibadagayo.site'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
