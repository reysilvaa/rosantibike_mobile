import 'package:flutter/material.dart';

class MenuGrid extends StatelessWidget {
  const MenuGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {'icon': Icons.send, 'label': 'Transfer'},
      {'icon': Icons.account_balance_wallet, 'label': 'Top Up'},
      {'icon': Icons.payment, 'label': 'Pay'},
      {'icon': Icons.receipt, 'label': 'Bills'},
      {'icon': Icons.shopping_cart, 'label': 'Shop'},
      {'icon': Icons.more_horiz, 'label': 'More'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.2),
                child: Icon(
                  item['icon'] as IconData,
                  color: Theme.of(context).iconTheme.color,
                  size: Theme.of(context).iconTheme.size,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item['label'] as String,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          );
        },
      ),
    );
  }
}
