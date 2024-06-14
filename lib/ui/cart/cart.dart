import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nike2/data/rep/auth_repository.dart';
import 'package:nike2/data/rep/cart_repository.dart';
import 'package:nike2/ui/auth/Auth.dart';
import 'package:nike2/ui/cart/bloc/cart_bloc.dart';
import 'package:nike2/ui/cart/cart_item.dart';
import 'package:nike2/ui/shipping/shipping.dart';
import 'package:nike2/ui/widgets/empty_state.dart';

import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import 'price_info.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartBloc? cartBloc;
  bool stateIsSuccess = false;
  final RefreshController _refreshController = RefreshController();
  StreamSubscription? satateStreamSubscription;
  @override
  void initState() {
    AuthRepository.authChangeNotifier.addListener(authChangeNotifierListener);
    super.initState();
  }

  void authChangeNotifierListener() {
    cartBloc?.add(
        CartAuthInfoChanged(authInfo: AuthRepository.authChangeNotifier.value));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    AuthRepository.authChangeNotifier
        .removeListener(authChangeNotifierListener);
    cartBloc?.close();
    satateStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff26272C),
        appBar: AppBar(
          backgroundColor: const Color(0xff262a35),
          centerTitle: true,
          title: const Text("سبد خرید"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Visibility(
          visible: stateIsSuccess,
          child: Container(
            margin: const EdgeInsets.only(left: 48, right: 48),
            width: MediaQuery.of(context).size.width,
            child: FloatingActionButton.extended(
                backgroundColor: Colors.white,
                onPressed: () {
                  final state = cartBloc!.state;
                  if (state is CartSuccess) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ShippingScreen(
                              payablePrice: state.cartResponse.payablePrice,
                              shippingCost: state.cartResponse.shippingCost,
                              totalPrice: state.cartResponse.totalPrice,
                            )));
                  }
                },
                label: const Text(
                  'پرداخت ',
                  style: TextStyle(color: Colors.black),
                )),
          ),
        ),
        body: Center(
          child: BlocProvider<CartBloc>(
            create: (context) {
              final bloc = CartBloc(cartRepository);
              satateStreamSubscription = bloc.stream.listen((state) {
                setState(() {
                  stateIsSuccess = state is CartSuccess;
                });
          
                if (_refreshController.isRefresh) {
                  if (state is CartSuccess) {
                    _refreshController.refreshCompleted();
                  } else if (state is CartError) {
                    _refreshController.refreshFailed();
                  }
                }
              });
              cartBloc = bloc;
              bloc.add(CartStarted(AuthRepository.authChangeNotifier.value));
              return bloc;
            },
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state is CartLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is CartError) {
                  return Center(
                    child: Text(state.exception.message),
                  );
                } else if (state is CartSuccess) {
                  return SmartRefresher(
                    header: const ClassicHeader(
                      completeText: 'با موفقیت انجام شد',
                      refreshingText: 'در حال بروز رسانی',
                      idleText: 'برای بروزرسانی پایین بکشید',
                      releaseText: 'رها کنید',
                      failedText: 'خطای نامشخص',
                      spacing: 2,
                      completeIcon: Icon(
                        CupertinoIcons.checkmark_circle,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                    onRefresh: () {
                      cartBloc?.add(CartStarted(
                          AuthRepository.authChangeNotifier.value,
                          isRefreshing: true));
                    },
                    controller: _refreshController,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 65),
                      itemBuilder: (context, index) {
                        if (index < state.cartResponse.cartItems.length) {
                          final data = state.cartResponse.cartItems[index];
                          return CartItem(
                            data: data,
                            onDeleteButtonClick: () {
                              cartBloc?.add(
                                  CartDeleteButtonClicked(cartItemId: data.id));
                            },
                            onIncreaseButtonClick: () {
                              cartBloc?.add(IncreaseCountButtonIsClicked(
                                  cartItemId: data.id));
                            },
                            onDecreaseButtonClick: () {
                              if (data.count > 1) {
                                cartBloc?.add(DecreaseCartButtonIsClicked(
                                    cartItemId: data.id));
                              }
                            },
                          );
                        } else {
                          return PriceInfo(
                            payablePrice: state.cartResponse.payablePrice,
                            shippingCost: state.cartResponse.shippingCost,
                            totalPrice: state.cartResponse.totalPrice,
                          );
                        }
                      },
                      itemCount: state.cartResponse.cartItems.length + 1,
                    ),
                  );
                } else if (state is CartAuthRequired) {
                  return EmptyViewe(
                    message:
                        'برای مشاهده سبد خرید ابتدا وارد حساب کاربری خود شوید',
                    callToAction: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AuthScreen()));
                      },
                      child: const Text(
                        'ورورد به حساب کاربری',
                        style: TextStyle(color: Color(0xff262a35)),
                      ),
                    ),
                    image: SvgPicture.asset(
                      'assets/img/auth_required.svg',
                      width: 150,
                    ),
                  );
                } else if (state is CartEmpty) {
                  return EmptyViewe(
                      message:
                          'تا کنون هیج محصولی به سبد خرید خود اضافه نکرده اید',
                      image: SvgPicture.asset(
                        'assets/img/empty_cart.svg',
                        width: 200,
                      ));
                } else {
                  throw Exception('current cart state is not valid');
                }
              },
            ),
          ),
        )

        // body: ValueListenableBuilder<AuthInfo?>(
        //     builder: (context, authState, child) {
        //       bool isAuthenticated =
        //           authState != null && authState.accessToken.isNotEmpty;
        //       return SizedBox(
        //         width: MediaQuery.of(context).size.width,
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Text(isAuthenticated
        //             ? 'خوش آمدید'
        //             : ',وارد حساب کاربری خود شوید'),
        //         isAuthenticated
        //             ? ElevatedButton(
        //                 onPressed: () {
        //                   authRepository.signOut();
        //                 },
        //                 child: Text('خروج از حساب'))
        //             : ElevatedButton(
        //                 onPressed: () {
        //                   Navigator.of(context, rootNavigator: true)
        //                       .push(MaterialPageRoute(builder: (context) {
        //                     return const AuthScreen();
        //                   }));
        //                 },
        //                 child: Text('ورود')),
        //       ],
        //     ),
        //   );
        // },
        // valueListenable: AuthRepository.authChangeNotifier),
        );
  }
}
