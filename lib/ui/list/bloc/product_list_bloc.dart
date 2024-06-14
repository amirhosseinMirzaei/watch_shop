import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike2/common/exceptions.dart';
import 'package:nike2/data/product.dart';
import 'package:nike2/data/rep/product_repository.dart';


part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final IProductRepository repository;
  ProductListBloc(this.repository) : super(ProductListLoading()) {
    on<ProductListEvent>((event, emit) async {
      if (event is ProductListStarted) {
        emit(ProductListLoading());
        try {
          final products = await repository.getAll(event.sort);
          emit(ProductListSuccess(
              products: products,
              sort: event.sort,
              sortNames: ProductSort.names));
        } catch (e) {
          emit(ProductListError(exception: AppException(message: e.toString())));
        }
      }
    });
  }
}
