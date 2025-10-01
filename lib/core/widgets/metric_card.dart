import 'package:flutter/material.dart';
import 'app_card.dart';

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.trend,
    this.trendColor,
  });

  final IconData icon;
  final String value;
  final String label;
  final String? trend; // e.g. +12.5%
  final Color? trendColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: trendColor?.withOpacity(0.12) ?? Colors.white24,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(icon, color: trendColor ?? Colors.white, size: 24),
              ),
              const Spacer(),
              if (trend != null)
                Row(
                  children: [
                    Icon(Icons.trending_up,
                        color: trendColor ?? Colors.green, size: 16),
                    const SizedBox(width: 4),
                    Text(trend!, style: textTheme.bodySmall?.copyWith(color: trendColor ?? Colors.green)),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(value, style: textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: textTheme.labelLarge),
        ],
      ),
    );
  }
}

