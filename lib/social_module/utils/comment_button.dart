import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';

class CommentButton extends StatelessWidget {
  final void Function()? onTap;
  const CommentButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      // ignore: prefer_const_constructors
      child: Icon(EneftyIcons.message_2_outline),
    );
  }
}
