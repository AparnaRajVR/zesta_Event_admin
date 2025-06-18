import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_admin/viewmodel/organize_list/bloc/organizer_list_bloc.dart';
import 'package:z_admin/viewmodel/organize_list/bloc/organizer_list_event.dart';

class OrganizerFilterButtons extends StatelessWidget {
  final String selectedFilter;

  const OrganizerFilterButtons({super.key, required this.selectedFilter});

  @override
  Widget build(BuildContext context) {
    final filters = ['All', 'Approved', 'Pending', 'Rejected'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: filters.map((filter) {
          final isSelected = filter == selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ElevatedButton(
              onPressed: () {
                context.read<OrganizerBloc>().add(FilterStatusChanged(filter));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? Colors.blue : Colors.blue.shade50,
                foregroundColor: isSelected ? Colors.white : Colors.black87,
                elevation: 2,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                filter,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
