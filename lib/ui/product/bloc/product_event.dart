part of 'product_bloc.dart';

// @immutable
abstract class ProductEvent extends Equatable {
  const ProductEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class CartAddButtonIsClicked extends ProductEvent{
final int productId;

 const CartAddButtonIsClicked(this.productId);

}