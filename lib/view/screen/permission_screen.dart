
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_admin/view/screen/organizer_approval.dart';
import 'package:z_admin/viewmodel/permission_bloc/bloc/permission_bloc.dart';
import 'package:z_admin/viewmodel/permission_bloc/bloc/permission_event.dart';
import 'package:z_admin/viewmodel/permission_bloc/bloc/permission_state.dart';

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

class PermissionsView extends StatefulWidget {
  const PermissionsView({super.key});

  @override
  State<PermissionsView> createState() => _PermissionsViewState();
}

class _PermissionsViewState extends State<PermissionsView> {
  String selectedFilter = 'All';
  final List<String> filters = ['All', 'Pending', 'Approved', 'Rejected'];
  TextEditingController searchController = TextEditingController();
  
  void _applyFilter(BuildContext context) {
    context.read<PermissionsBloc>().add(
          FilterUsers(
            filter: selectedFilter,
            searchQuery: searchController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          IconButton(
            icon: const Icon(Icons.download_outlined, color: Color(0xFF2A3F85)),
            onPressed: () {
              // Export functionality
            },
            tooltip: 'Export Data',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search and filter container with shadow
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Column(
              children: [
                // Search bar with improved styling
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: (_) => _applyFilter(context),
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Filter Chips with improved design
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
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          onSelected: (selected) {
                            setState(() {
                              selectedFilter = filter;
                            });
                            _applyFilter(context);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          
          // Count summary bar
          BlocBuilder<PermissionsBloc, PermissionsState>(
            builder: (context, state) {
              if (state is UsersLoaded) {
                return Container(
                  color: const Color(0xFFEEF2F6),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        "${state.users.length} results found",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF505A6B),
                          fontSize: 13,
                        ),
                      ),
                   
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // User list with improved cards
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
                        const SizedBox(height: 8),
                        Text(
                          "Try adjusting your search or filter",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                var users = (state as UsersLoaded).users;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    var user = users[index];
                    
                    // Status color mapping
                    Color statusColor;
                    String status = user['status'] ?? 'Pending';
                    
                    switch (status) {
                      case 'Approved':
                        statusColor = Colors.green;
                        break;
                      case 'Rejected':
                        statusColor = Colors.red;
                        break;
                      default:
                        statusColor = Colors.orange; // Pending
                        break;
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Avatar or icon
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
                            
                            // User details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user['fullName'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF2A3F85),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user['organizationName'],
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
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
                                ],
                              ),
                            ),
                            
                            // Review button
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ApprovalPage(userId: user.id),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2A3F85),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              ),
                              child: const Text(
                                "Review",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
