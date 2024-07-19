import 'package:flutter/material.dart';

class BottomSheetWidget extends StatefulWidget {
  const BottomSheetWidget({super.key});

  @override
  BottomSheetWidgetState createState() => BottomSheetWidgetState();
}

class BottomSheetWidgetState extends State<BottomSheetWidget> {
  SortOption _selectedOption = SortOption.all;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Sort',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          RadioListTile<SortOption>(
            title: const Text('All'),
            value: SortOption.all,
            groupValue: _selectedOption,
            onChanged: (SortOption? value) {
              setState(() {
                _selectedOption = value!;
              });
            },
          ),
          RadioListTile<SortOption>(
            title: const Text('Age: Elder'),
            value: SortOption.ageElder,
            groupValue: _selectedOption,
            onChanged: (SortOption? value) {
              setState(() {
                _selectedOption = value!;
              });
            },
          ),
          RadioListTile<SortOption>(
            title: const Text('Age: Younger'),
            value: SortOption.ageYounger,
            groupValue: _selectedOption,
            onChanged: (SortOption? value) {
              setState(() {
                _selectedOption = value!;
              });
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

enum SortOption { all, ageElder, ageYounger }