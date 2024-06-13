import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike2/common/utils.dart';
import 'package:nike2/data/cart_item.dart';
import 'package:nike2/theme.dart';
import 'package:nike2/ui/widgets/image.dart';

class CartItem extends StatelessWidget {
  final CartItemEntity data;
  final GestureTapCallback onDeleteButtonClick;
  final GestureTapCallback onIncreaseButtonClick;
  final GestureTapCallback onDecreaseButtonClick;
  const CartItem(
      {super.key,
      required this.data,
      required this.onDeleteButtonClick,
      required this.onIncreaseButtonClick,
      required this.onDecreaseButtonClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xff262a35),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10)
          ]),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: ImageLoadingService(
                    imageUrl: data.product.imageUrl,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      data.product.title,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('تعداد'),
                    Row(
                      children: [
                        IconButton(
                          onPressed: onIncreaseButtonClick,
                          icon: const Icon(
                            CupertinoIcons.plus_circle,
                            color: Colors.white,
                          ),
                        ),
                        data.changeCountLoading
                            ? CupertinoActivityIndicator(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              )
                            : Text(
                                data.count.toString(),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                        IconButton(
                          onPressed: onDecreaseButtonClick,
                          icon: const Icon(CupertinoIcons.minus_circle,
                              color: Colors.white),
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data.product.previousPrice.withPriceLabel.toString(),
                      style: const TextStyle(
                          color: LightThemeColor.secondaryTextColor,
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough),
                    ),
                    Text(data.product.price.withPriceLabel.toString()),
                  ],
                )
              ],
            ),
          ),

          data.deleteButtonLoading
              ? const SizedBox(
                  height: 48,
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ))
              : SizedBox(
                  width: MediaQuery.of(context).size.width - 20,
                  child: ElevatedButton(
                    onPressed: onDeleteButtonClick,
                    child: const Text('حذف'),
                  ),
                )
          // : TextButton(
          //     onPressed: onDeleteButtonClick,
          //     child: const Text('حذف از سبد خرید'),
          //   ),
        ],
      ),
    );
  }
}
