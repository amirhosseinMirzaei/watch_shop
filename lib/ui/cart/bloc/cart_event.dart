part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CartStarted extends CartEvent {
  final AuthInfo? authInfo;
  final bool isRefreshing;

  const CartStarted(
    this.authInfo, {
    this.isRefreshing = false,
  });
}

class CartAuthInfoChanged extends CartEvent {
  final AuthInfo? authInfo;

  const CartAuthInfoChanged({required this.authInfo});
}

class CartDeleteButtonClicked extends CartEvent {
  final int cartItemId;

  CartDeleteButtonClicked({required this.cartItemId});
  @override
  // TODO: implement props
  List<Object?> get props => [cartItemId];
}

class IncreaseCountButtonIsClicked extends CartEvent {
  final int cartItemId;

  const IncreaseCountButtonIsClicked({required this.cartItemId});

  @override
  // TODO: implement props
  List<Object?> get props => [cartItemId];
}

class DecreaseCartButtonIsClicked extends CartEvent {
  final int cartItemId;

  DecreaseCartButtonIsClicked({required this.cartItemId});
  @override
  // TODO: implement props
  List<Object?> get props => [cartItemId];
}
