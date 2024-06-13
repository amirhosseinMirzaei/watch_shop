import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike2/data/order.dart';
import 'package:nike2/data/rep/order_repository.dart';
import 'package:nike2/ui/cart/price_info.dart';
import 'package:nike2/ui/payment_webview.dart';
import 'package:nike2/ui/receipt/payment_receipt.dart';
import 'package:nike2/ui/shipping/bloc/shipping_bloc.dart';

class ShippingScreen extends StatefulWidget {
  final int payablePrice;
  final int shippingCost;
  final int totalPrice;

  ShippingScreen(
      {super.key,
      required this.payablePrice,
      required this.shippingCost,
      required this.totalPrice});

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController phoneNumberController = TextEditingController();

  final TextEditingController postalCodeController = TextEditingController();

  final TextEditingController addressController = TextEditingController();

  StreamSubscription? subscription;
  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width - 50,
        child: FloatingActionButton.extended(
            backgroundColor: Colors.white,
            splashColor: Color.fromARGB(0, 153, 112, 244),
            isExtended: true,
            onPressed: () {},
            label: Text(
              'پرداخت آنلاین',
              style: TextStyle(color: Colors.black),
            )),
      ),
      backgroundColor: Color(0xff26272C),
      appBar: AppBar(
        backgroundColor: Color(0xff26272C),
        centerTitle: false,
        title: Text('مشخصات مشتری '),
      ),
      body: BlocProvider<ShippingBloc>(
        create: (context) {
          final bloc = ShippingBloc(orderRepository);
          subscription = bloc.stream.listen((state) {
            if (state is ShippingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.exception.message)));
            } else if (state is ShippingSuccess) {
              if (state.result.bankGatewayUrl.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentGatewayScreen(
                        bankGatewayUrl: state.result.bankGatewayUrl),
                  ),
                );
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        PaymentReceiptScreen(orderId: state.result.orderId)));
              }
            }
          });
          return bloc;
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                    label: Text(
                  'نام',
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontSize: 16),
                )),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                    label: Text(
                  ' نام خانوادگی',
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontSize: 16),
                )),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(
                    label: Text(
                  'شماره تماس',
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontSize: 16),
                )),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: postalCodeController,
                decoration: InputDecoration(
                    label: Text(
                  ' کد پستی',
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontSize: 16),
                )),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                    label: Text(
                  ' آدرس',
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontSize: 16),
                )),
              ),
              const SizedBox(
                height: 12,
              ),
              PriceInfo(
                  payablePrice: widget.payablePrice,
                  shippingCost: widget.shippingCost,
                  totalPrice: widget.totalPrice),
              BlocBuilder<ShippingBloc, ShippingState>(
                builder: (context, state) {
                  return state is ShippingLoading
                      ? const Center(
                          child: CupertinoActivityIndicator(),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // OutlinedButton(
                            //   onPressed: () {
                            //     BlocProvider.of<ShippingBloc>(context).add(
                            //       ShippingCreateOrder(
                            //         params: CreateOrderParams(
                            //             firstName: firstNameController.text,
                            //             lastName: lastNameController.text,
                            //             phoneNumber: phoneNumberController.text,
                            //             postalCode: postalCodeController.text,
                            //             address: addressController.text,
                            //             paymentMethod:
                            //                 PaymentMethod.cashOnDelivery),
                            //       ),
                            //     );
                            //   },
                            //   child: const Text('پرداخت در محل'),
                            // ),

                            // ElevatedButton(
                            //   onPressed: () {
                            //     BlocProvider.of<ShippingBloc>(context).add(
                            //       ShippingCreateOrder(
                            //         params: CreateOrderParams(
                            //             firstName: firstNameController.text,
                            //             lastName: lastNameController.text,
                            //             phoneNumber: phoneNumberController.text,
                            //             postalCode: postalCodeController.text,
                            //             address: addressController.text,
                            //             paymentMethod: PaymentMethod.online),
                            //       ),
                            //     );
                            //   },
                            //   child: const Text('پرداخت اینترنتی'),
                            // ),
                          ],
                        );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
