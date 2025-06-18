import 'package:flutter/material.dart';
import 'package:z_admin/view/widget/search.dart';

class FiltersSection extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterSelected;
  final Function(String) onSearchChanged;

  const FiltersSection({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.onSearchChanged,
  });

  static const List<String> filters = ['All', 'Pending', 'Approved', 'Rejected'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBarWidget(
          hintText: 'Search by name or organization...',
          onChanged: onSearchChanged,
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filters.map((filter) {
              final isSelected = selectedFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: FilterChip(
                  label: Text(
                    filter,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? const Color(0xFF2A3F85) : Colors.black87,
                    ),
                  ),
                  selected: isSelected,
                  backgroundColor: Colors.white,
                  selectedColor: const Color(0xFF2A3F85).withOpacity(0.1),
                  checkmarkColor: const Color(0xFF2A3F85),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(
                      color: isSelected ? const Color(0xFF2A3F85) : Colors.grey.withOpacity(0.3),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  onSelected: (_) => onFilterSelected(filter),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
