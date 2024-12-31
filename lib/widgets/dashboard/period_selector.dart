
// lib/widgets/period_selector.dart
import 'package:flutter/material.dart';

class PeriodSelector extends StatefulWidget {
  const PeriodSelector({Key? key}) : super(key: key);

  @override
  State<PeriodSelector> createState() => _PeriodSelectorState();
}

class _PeriodSelectorState extends State<PeriodSelector> {
  String selectedPeriod = 'Weekly';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Revenue',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment<String>(value: 'Monthly', label: Text('Monthly')),
            ButtonSegment<String>(value: 'Weekly', label: Text('Weekly')),
            ButtonSegment<String>(value: 'Today', label: Text('Today')),
          ],
          selected: {selectedPeriod},
          onSelectionChanged: (Set<String> newSelection) {
            setState(() {
              selectedPeriod = newSelection.first;
            });
          },
        ),
      ],
    );
  }
}
