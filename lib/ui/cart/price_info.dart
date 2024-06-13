import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike2/common/utils.dart';
import 'package:nike2/theme.dart';

class PriceInfo extends StatelessWidget {
  final int payablePrice;
  final int shippingCost;
  final int totalPrice;

  const PriceInfo(
      {super.key,
      required this.payablePrice,
      required this.shippingCost,
      required this.totalPrice});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 24, 8, 0),
          child: Text(
            'جزییات خرید',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(8, 8, 8, 32),
          decoration: BoxDecoration(
              color: Color(0xff262a35),
              borderRadius: BorderRadiusDirectional.circular(2),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black.withOpacity(0.1),
                ),
              ]),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('مبلغ کل خرید'),
                    RichText(
                      text: TextSpan(
                          text: totalPrice.seperateByComma,
                          style: DefaultTextStyle.of(context)
                              .style
                              .apply(color: LightThemeColor.secondaryColor),
                          children: const [
                            TextSpan(
                                text: ' تومان', style: TextStyle(fontSize: 10))
                          ]),
                    )
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: Colors.black.withOpacity(0.1),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 12, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('هزینه ارسال'),
                    Text(shippingCost.withPriceLabel.toString()),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: Colors.black.withOpacity(0.1),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 12, 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(' مبلغ قابل پرداخت'),
                    RichText(
                      text: TextSpan(
                        text: payablePrice.seperateByComma,
                        style: DefaultTextStyle.of(context).style.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        children: const [
                          TextSpan(
                              text: ' تومان',
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.normal))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
