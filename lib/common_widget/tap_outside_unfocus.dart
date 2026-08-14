import 'package:flutter/material.dart';

/// Simple wrapper that will clear focus when a tap is detected outside its boundaries
class TapOutsideUnFocus extends StatelessWidget {
  final Widget child;
  final bool shrinkWrap;

  const TapOutsideUnFocus({super.key, required this.child, this.shrinkWrap = false });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: shrinkWrap ? null : double.infinity,
      child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: child
      ),
    );
  }
}