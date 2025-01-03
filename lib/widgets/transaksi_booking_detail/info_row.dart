import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;
  final TextStyle? valueStyle;
  final TextStyle? labelStyle;

  const InfoRow({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
    this.valueStyle,
    this.labelStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: iconColor ?? Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: labelStyle ?? 
                    Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).textTheme.labelLarge?.color?.withOpacity(0.8),
                    ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: valueStyle ?? Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}