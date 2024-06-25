import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CheckoutWebviewScreen extends StatelessWidget {
  final String checkoutUrl;

  const CheckoutWebviewScreen({super.key, required this.checkoutUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(checkoutUrl)),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            useShouldOverrideUrlLoading: true,
            mediaPlaybackRequiresUserGesture: false, //TODO: Remove in next commit, need to test if it breaks anything
          ),
        ),
      ),
    );
  }
}
