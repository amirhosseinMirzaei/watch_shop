import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike2/common/exceptions.dart';
import 'package:nike2/data/payment_receipt.dart';
import 'package:nike2/data/rep/order_repository.dart';


part 'payment_receipt_event.dart';
part 'payment_receipt_state.dart';

class PaymentReceiptBloc
    extends Bloc<PaymentReceiptEvent, PaymentReceiptState> {
  final IOrderRepository repository;
  PaymentReceiptBloc(this.repository) : super(PaymentReceiptLoading()) {
    on<PaymentReceiptEvent>((event, emit) async {
      if (event is PaymentReceiptStarted) {
        try {
          emit(PaymentReceiptLoading());
          final result = await repository.getPaymentReceipt(event.orderId);
          emit(PaymentReceiptSuccess(paymentReceiptData: result));
        } catch (e) {
          emit(PaymentReceiptError(exception: AppException()));
        }
      }
    });
  }
}
