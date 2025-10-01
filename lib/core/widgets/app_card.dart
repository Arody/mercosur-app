import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.onTap, this.padding});

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final card = Padding(
      padding: padding ?? const EdgeInsets.all(16.0),
      child: child,
    );

    return onTap != null
        ? InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Card(child: card),
          )
        : Card(child: card);
  }
}

