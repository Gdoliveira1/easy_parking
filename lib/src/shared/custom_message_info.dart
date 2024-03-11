import "package:easy_parking/src/domain/constants/app_text_styles.dart";
import "package:flutter/material.dart";

class CustomMessageInfo extends StatelessWidget {
  final String message;
  final TextStyle style;
  final Alignment alignment;

  const CustomMessageInfo({
    required this.message,
    super.key,
    this.style = AppTextStyles.grey18w400,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Center(
        heightFactor: 8,
        child: Text(
          message,
          style: style,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
