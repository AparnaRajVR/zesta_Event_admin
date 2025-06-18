import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_admin/view/screen/organizer_approval.dart';
import 'package:z_admin/view/widget/permission/filter_section.dart';
import 'package:z_admin/view/widget/permission/result_info.dart';

import 'package:z_admin/viewmodel/permission_bloc/bloc/permission_bloc.dart';
import 'package:z_admin/viewmodel/permission_bloc/bloc/permission_event.dart';
import 'package:z_admin/viewmodel/permission_bloc/bloc/permission_state.dart';

class PermissionsView extends StatelessWidget {
  const PermissionsView({super.key});

  @override
  Widget build(BuildContext context) {
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
                return FiltersSection(
                  selectedFilter: selectedFilter,
                  onFilterSelected: (filter) {
                    selectedFilter = filter;
                    context
                        .read<PermissionsBloc>()
                        .add(FilterUsers(filter: filter, searchQuery: searchQuery));
                  },
                  onSearchChanged: (query) {
                    searchQuery = query;
                    context
                        .read<PermissionsBloc>()
                        .add(FilterUsers(filter: selectedFilter, searchQuery: query));
                  },
                );
              },
            ),
          ),
          const ResultsInfo(),
          // const Expanded(child: UserList()),
          Expanded(
  child: BlocBuilder<PermissionsBloc, PermissionsState>(
    builder: (context, state) {
      if (state is UsersLoading) {
        return const Center(child: CircularProgressIndicator(color: Color(0xFF2A3F85)));
      }
      if (state is UsersError) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(state.message, style: const TextStyle(color: Colors.red, fontSize: 16)),
            ],
          ),
        );
      }
      if (state is UsersLoaded && state.users.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, color: Colors.grey, size: 48),
              SizedBox(height: 16),
              Text("No results found", style: TextStyle(color: Colors.grey, fontSize: 16)),
            ],
          ),
        );
      }
      if (state is UsersLoaded) {
        final users = [...state.users];
        users.sort((a, b) {
          final aData = a.data() as Map<String, dynamic>;
          final bData = b.data() as Map<String, dynamic>;

          final aTime = aData['createdAt'] is Timestamp
              ? (aData['createdAt'] as Timestamp).toDate()
              : DateTime.fromMillisecondsSinceEpoch(0);
          final bTime = bData['createdAt'] is Timestamp
              ? (bData['createdAt'] as Timestamp).toDate()
              : DateTime.fromMillisecondsSinceEpoch(0);

          return bTime.compareTo(aTime);
        });

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final data = user.data() as Map<String, dynamic>;
            final status = data['status'] ?? 'Pending';

            final statusColor = {
              'Approved': Colors.green,
              'Rejected': Colors.red,
            }[status] ?? Colors.orange;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A3F85).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.person, size: 28, color: Color(0xFF2A3F85)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data['fullName'] ?? 'Unknown',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2A3F85))),
                          const SizedBox(height: 4),
                          Text(data['organizationName'] ?? 'N/A',
                              style: const TextStyle(color: Colors.black54, fontSize: 14)),
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
                                Container(width: 8, height: 8, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                                const SizedBox(width: 4),
                                Text(status,
                                    style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ApprovalPage(userId: user.id),
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
)

        ],
      ),
    );
  }
}
