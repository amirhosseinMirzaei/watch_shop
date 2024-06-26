import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike2/common/exceptions.dart';
import 'package:nike2/data/order.dart';
import 'package:nike2/data/rep/order_repository.dart';

part 'shipping_event.dart';
part 'shipping_state.dart';

class ShippingBloc extends Bloc<ShippingEvent, ShippingState> {
  final IOrderRepository repository;
  ShippingBloc(this.repository) : super(ShippingInitial()) {
    on<ShippingEvent>((event, emit) async {
      if (event is ShippingCreateOrder) {
        try {
          emit(ShippingLoading());
          final result = await repository.create(event.params);
          emit(ShippingSuccess(result: result));
        } catch (e) {
          emit(ShippingError(exception: AppException(message: e.toString())));
        }
      }
    });
  }
}
