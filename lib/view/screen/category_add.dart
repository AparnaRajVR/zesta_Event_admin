
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_admin/viewmodel/category_bloc/bloc/category_bloc.dart';
import 'package:z_admin/viewmodel/category_bloc/bloc/category_event.dart';
import 'package:z_admin/viewmodel/category_bloc/bloc/category_state.dart';

class CategoryDialog extends StatefulWidget {
  const CategoryDialog({super.key});

  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(LoadCategories());
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 500;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Create Event Category',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter category name',
                prefixIcon: const Icon(Icons.category),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final name = _controller.text.trim();
                  if (name.isNotEmpty) {
                    context.read<CategoryBloc>().add(AddCategory(name));
                    _controller.clear();
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Category'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const Divider(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Added Categories:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.maxFinite,
              child: BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  final categories = (state is CategoryLoaded) ? state.categories : [];

                  if (categories.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(child: Text('No categories added yet.')),
                    );
                  }

                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: categories.map((cat) {
                      return GestureDetector(
                        onDoubleTap: () {
                          context.read<CategoryBloc>().add(DeleteCategory(cat['id']));
                        },
                        child: Chip(
                          label: Text(cat['name']),
                          backgroundColor: Colors.blue.shade100,
                          labelStyle: const TextStyle(fontWeight: FontWeight.w500),
                          deleteIcon: const Icon(Icons.close),
                          onDeleted: () {
                            context.read<CategoryBloc>().add(DeleteCategory(cat['id']));
                          },
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
          label: const Text('Close'),
        ),
      ],
    );
  }
}
