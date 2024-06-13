

import 'package:nike2/data/common/http_client.dart';
import 'package:nike2/data/order.dart';
import 'package:nike2/data/payment_receipt.dart';
import 'package:nike2/data/source/order_data_source.dart';

final orderRepository =
    OrderRepository(dataSource: OrderRemoteDataSource(httpclient: httpClient));

abstract class IOrderRepository extends IOrderDataSource {}

class OrderRepository implements IOrderRepository {
  final IOrderDataSource dataSource;

  OrderRepository({required this.dataSource});
  @override
  Future<CreateOrderResult> create(CreateOrderParams params) =>
      dataSource.create(params);

  @override
  Future<PaymentReceiptData> getPaymentReceipt(int orderId) =>
      dataSource.getPaymentReceipt(orderId);
}
