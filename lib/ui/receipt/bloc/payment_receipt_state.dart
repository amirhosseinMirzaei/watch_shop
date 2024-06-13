part of 'payment_receipt_bloc.dart';

sealed class PaymentReceiptState extends Equatable {
  const PaymentReceiptState();

  @override
  List<Object> get props => [];
}

final class PaymentReceiptLoading extends PaymentReceiptState {}

class PaymentReceiptSuccess extends PaymentReceiptState {
  final PaymentReceiptData paymentReceiptData;

  const PaymentReceiptSuccess({required this.paymentReceiptData});
  @override
  List<Object> get props => [paymentReceiptData];
}

class PaymentReceiptError extends PaymentReceiptState {
  final AppException exception;

  const PaymentReceiptError({required this.exception});
  @override
  List<Object> get props => [exception];
}
