import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

import 'receipt/payment_receipt.dart';

class PaymentGatewayScreen extends StatelessWidget {
  final String bankGatewayUrl;
  const PaymentGatewayScreen({super.key, required this.bankGatewayUrl});

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: bankGatewayUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onPageStarted: (url) {
        debugPrint('url:$url');
        final uri = Uri.parse(url);

        if (uri.pathSegments.contains('checkout') &&
            uri.host == 'expertdevelopers.ir') {
          final orderId = int.parse(uri.queryParameters['order_id']!);
          debugPrint('orderId=$orderId');
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PaymentReceiptScreen(orderId: orderId)));
        }
      },
    );
  }
}
