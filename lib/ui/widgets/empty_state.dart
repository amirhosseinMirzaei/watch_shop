import 'package:flutter/material.dart';

class EmptyViewe extends StatelessWidget {
  final String message;
  final Widget? callToAction;
  final Widget image;

  const EmptyViewe(
      {super.key,
      required this.message,
      this.callToAction,
      required this.image});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        image,
        Padding(
          padding:
              const EdgeInsets.only(right: 48, left: 48, top: 24, bottom: 16),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        if (callToAction != null) callToAction!
      ],
    );
  }
}
