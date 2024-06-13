import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike2/common/exceptions.dart';
import 'package:nike2/data/rep/cart_repository.dart';



part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ICartRepository cartRepository;
  ProductBloc(this.cartRepository) : super(ProductInitial()) {
    on<ProductEvent>((event, emit) async {
      if (event is CartAddButtonIsClicked) {
        try {
          emit(ProductAddToCartButtonLoading());
          await Future.delayed(const Duration(seconds: 1));
          final result = cartRepository.add(event.productId);
          await cartRepository.count();
          emit(ProductAddToCartSuccess());
        } catch (e) {
          emit(ProductAddToCartError(AppException()));
        }
      }
    });
  }
}
