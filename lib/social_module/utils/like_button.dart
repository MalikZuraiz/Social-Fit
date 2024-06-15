import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final bool isLiked;
  final void Function()? onTap;
  const LikeButton({super.key, required this.isLiked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(isLiked ? EneftyIcons.heart_bold : EneftyIcons.heart_outline),
    );
  }
}
