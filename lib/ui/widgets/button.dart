import 'package:flutter/material.dart';

import '../../core/res/colors.dart';
import '../../core/res/spacing.dart';
import '../../core/res/styles.dart';

TextStyle _buttonTextStyle = AppStyle.buttonText;
TextStyle _outlineTextStyle = const TextStyle(
    fontSize: 15,
    fontFamily: AppStyle.fontFamily,
    fontWeight: FontWeight.w500,
    color: AppColor.primary,
    letterSpacing: 1.5);

class Button extends StatelessWidget {
  @override
  final String text;
  TextStyle? textStyle;
  final EdgeInsets? padding;
  final double width;
  final double height;
  final VoidCallback onPressed;
  final Color color;
  final Color borderColor;
  final BorderRadius? borderRadius;
  final bool disabled;
  Widget? icon = Container();
  bool isLoading = false;

  bool isOutline = false;

  Button(this.text,
      {super.key,
      this.textStyle,
      this.width = 82,
      this.height = 44,
      required this.onPressed,
      this.color = AppColor.primary,
      this.borderColor = AppColor.primary,
      this.borderRadius,
      this.disabled = false,
      this.isLoading = false,
      this.icon,
      this.padding});

  Button.outline(this.text,
      {super.key,
      this.textStyle,
      this.width = 82,
      this.height = 44,
      required this.onPressed,
      this.color = AppColor.background,
      this.borderColor = AppColor.primary,
      this.borderRadius,
      this.disabled = false,
      this.icon,
      this.padding}) {
    isOutline = true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      key: key,
      elevation: 0.0,
      height: height,
      minWidth: width,
      onPressed: disabled ? null : onPressed,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      color: disabled ? color.withOpacity(0.4) : color,
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: disabled ? borderColor.withOpacity(0.1) : borderColor,
            width: 1.0),
        borderRadius:
            borderRadius ?? const BorderRadius.all(Radius.circular(6)),
      ),
      child: isLoading
          ? const SizedBox(
              width: 15,
              height: 15,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(AppColor.surface),
              ),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon ?? Container(),
                if (icon != null) HorizontalSpacing.custom(value: 8.0),
                Text(
                  text,
                  style: textStyle ??
                      (isOutline ? _outlineTextStyle : _buttonTextStyle),
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                ),
              ],
            ),
    );
  }
}
