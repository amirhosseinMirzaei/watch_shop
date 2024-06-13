import 'package:dio/dio.dart';
import 'package:nike2/data/order.dart';
import 'package:nike2/data/payment_receipt.dart';


abstract class IOrderDataSource {
  Future<CreateOrderResult> create(CreateOrderParams params);
  Future<PaymentReceiptData> getPaymentReceipt(int orderId);
}

class OrderRemoteDataSource implements IOrderDataSource {
  final Dio httpclient;

  OrderRemoteDataSource({required this.httpclient});
  @override
  Future<CreateOrderResult> create(CreateOrderParams params) async {
    final response = await httpclient.post('order/submit', data: {
      'first_name': params.firstName,
      'last_name': params.lastName,
      'mobile': params.phoneNumber,
      'postal_code': params.postalCode,
      'address': params.address,
      'payment_method': params.paymentMethod == PaymentMethod.online
          ? 'online'
          : 'cashe_on_delivery',
    });
    return CreateOrderResult.fromJson(response.data);
  }

  @override
  Future<PaymentReceiptData> getPaymentReceipt(int orderId) async {
    final response = await httpclient.get('order/checkout?order_id=$orderId');
    return PaymentReceiptData.fromJson(response.data);
  }
}
