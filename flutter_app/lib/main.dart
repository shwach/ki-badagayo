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
  bool _hasError = false;
  bool _isLoading = true;

  void _load() {
    _controller.loadRequest(
      Uri.parse('https://kibadagayo.site?v=${DateTime.now().millisecondsSinceEpoch}'),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFF8F6FF))
      ..addJavaScriptChannel(
        'Haptic',
        onMessageReceived: (msg) {
          switch (msg.message) {
            case 'heavy':
              HapticFeedback.heavyImpact();
            case 'medium':
              HapticFeedback.mediumImpact();
            case 'light':
              HapticFeedback.lightImpact();
            case 'success':
              HapticFeedback.vibrate();
          }
        },
      )
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) {
          if (mounted) setState(() { _isLoading = true; _hasError = false; });
        },
        onPageFinished: (_) {
          if (mounted) setState(() { _isLoading = false; });
        },
        onWebResourceError: (error) {
          if (mounted) setState(() { _isLoading = false; _hasError = true; });
        },
        onNavigationRequest: (req) {
          if (req.url.startsWith('https://kibadagayo.site') ||
              req.url.startsWith('https://www.gstatic.com') ||
              req.url.startsWith('https://firestore.googleapis.com') ||
              req.url.startsWith('https://identitytoolkit.googleapis.com') ||
              req.url.startsWith('https://securetoken.googleapis.com')) {
            return NavigationDecision.navigate;
          }
          return NavigationDecision.prevent;
        },
      ));
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FF),
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_hasError)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('연결에 실패했어요', style: TextStyle(fontSize: 16, color: Color(0xFF5B21B6))),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() { _hasError = false; _isLoading = true; });
                        _load();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C3AED),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      ),
                      child: const Text('다시 시도'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
