import '/config/global_color.dart';
import '/lang/l.dart';
import 'package:get/get.dart';

import '/base/lifecycle_state.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends LifecycleState<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) {},
        onPageStarted: (url) {},
        onPageFinished: (url) {},
        onHttpError: (error) {},
        onWebResourceError: (error) {},
      ))
      ..loadRequest(Uri.parse(
          "https://sites.google.com/view/privacypolicydrinkwaterremider/trang-ch%E1%BB%A7"));
    return Scaffold(
      backgroundColor: GlobalColors.bg1,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          L.privacyPolicy.tr,
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }

  @override
  void onDetached() {}

  @override
  void onInactive() {}

  @override
  void onKeyboardHint() {}

  @override
  void onKeyboardShow() {}

  @override
  void onPaused() {}

  @override
  void onResumed() {}
}
