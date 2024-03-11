import "package:easy_parking/src/domain/constants/app_colors.dart";
import "package:flutter/material.dart";

class CustomInfoBar extends StatelessWidget {
  const CustomInfoBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            ClipOval(
              child: Container(
                height: 20,
                width: 20,
                color: AppColors.deYork,
              ),
            ),
            const SizedBox(width: 10),
            const Text("Liberado"),
          ],
        ),
        const SizedBox(width: 30),
        Row(
          children: [
            ClipOval(
              child: Container(
                height: 20,
                width: 20,
                color: AppColors.sunglo,
              ),
            ),
            const SizedBox(width: 10),
            const Text("Ocupado"),
          ],
        ),
      ],
    );
  }
}
