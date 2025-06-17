import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_admin/view/screen/organizer_approval.dart';
import 'package:z_admin/viewmodel/permission_bloc/bloc/permission_bloc.dart';
import 'package:z_admin/viewmodel/permission_bloc/bloc/permission_event.dart';
import 'package:z_admin/viewmodel/permission_bloc/bloc/permission_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PermissionsPage extends StatelessWidget {
  const PermissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PermissionsBloc()..add(LoadUsers()),
      child: const PermissionsView(),
    );
  }
}

class PermissionsView extends StatelessWidget {
  const PermissionsView({super.key});

  static final List<String> filters = ['All', 'Pending', 'Approved', 'Rejected'];

  void _onSearchChanged(BuildContext context, String query, String filter) {
    context.read<PermissionsBloc>().add(
      FilterUsers(filter: filter, searchQuery: query),
    );
  }

  void _onFilterSelected(BuildContext context, String filter, String query) {
    context.read<PermissionsBloc>().add(
      FilterUsers(filter: filter, searchQuery: query),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use BlocSelector or BlocBuilder to get current filter/search if needed
    String selectedFilter = 'All';
    String searchQuery = '';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "User Permissions",
          style: TextStyle(
            color: Color(0xFF2A3F85),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: BlocBuilder<PermissionsBloc, PermissionsState>(
              buildWhen: (prev, curr) => prev != curr,
              builder: (context, state) {
                // Get current filter and search from state if you store them in your state
                return Column(
                  children: [
                    TextField(
                      onChanged: (value) {
                        searchQuery = value;
                        _onSearchChanged(context, value, selectedFilter);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search by name or organization...',
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF2A3F85)),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[200]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[200]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF2A3F85)),
                        ),
                      ),
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
                                  color: isSelected
                                      ? const Color(0xFF2A3F85)
                                      : Colors.grey.withOpacity(0.3),
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              onSelected: (selected) {
                                selectedFilter = filter;
                                _onFilterSelected(context, filter, searchQuery);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          BlocBuilder<PermissionsBloc, PermissionsState>(
            builder: (context, state) {
              if (state is UsersLoaded) {
                return Container(
                  color: const Color(0xFFEEF2F6),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Text(
                    "${state.users.length} results found",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF505A6B),
                      fontSize: 13,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          Expanded(
            child: BlocBuilder<PermissionsBloc, PermissionsState>(
              builder: (context, state) {
                if (state is UsersLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF2A3F85),
                    ),
                  );
                }
                if (state is UsersError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, color: Colors.red[300], size: 48),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                if (state is UsersLoaded && state.users.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, color: Colors.grey[400], size: 48),
                        const SizedBox(height: 16),
                        Text(
                          "No results found",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                if (state is UsersLoaded) {
                  var users = state.users;
                  // Sort users by createdAt in descending order (latest first)
                  users.sort((a, b) {
                    var aData = a.data() as Map<String, dynamic>;
                    var bData = b.data() as Map<String, dynamic>;
                    var aTime = aData['createdAt'] != null
                        ? (aData['createdAt'] as Timestamp)
                        : null;
                    var bTime = bData['createdAt'] != null
                        ? (bData['createdAt'] as Timestamp)
                        : null;
                    if (aTime != null && bTime != null) {
                      return bTime.compareTo(aTime);
                    }
                    return 0;
                  });
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      var user = users[index];
                      var data = user.data() as Map<String, dynamic>;
                      Color statusColor;
                      String status = data['status'] ?? 'Pending';
                      switch (status) {
                        case 'Approved':
                          statusColor = Colors.green;
                          break;
                        case 'Rejected':
                          statusColor = Colors.red;
                          break;
                        default:
                          statusColor = Colors.orange;
                          break;
                      }
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2A3F85).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 28,
                                    color: Color(0xFF2A3F85),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['fullName'] ?? 'Unknown',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xFF2A3F85),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      data['organizationName'] ?? 'N/A',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: statusColor,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            status,
                                            style: TextStyle(
                                              color: statusColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                             ElevatedButton(
  onPressed: () {
   log("Review tapped for ${user.id}");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApprovalPage(userId: user.id),
      ),
    );
  },
  child: const Text("Review"),
),

                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
