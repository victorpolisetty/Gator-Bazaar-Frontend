import 'package:flutter/material.dart';

class CustomRadioListTile<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final String title;
  final bool isSelected;

  CustomRadioListTile({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(value);
      },
      child: Row(
        children: [
          Radio<T>(
            activeColor: Colors.black,
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          Text(title),
          SizedBox(width: 8), // Add spacing between the radio button and the text// Empty SizedBox if not selected
        ],
      ),
    );
  }
}
