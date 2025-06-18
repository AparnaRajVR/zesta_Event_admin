
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:z_admin/viewmodel/organize_list/bloc/organizer_list_bloc.dart';
import 'package:z_admin/viewmodel/organize_list/bloc/organizer_list_event.dart';
import 'package:z_admin/viewmodel/organize_list/bloc/organizer_list_state.dart';

class OrganizerListPage extends StatelessWidget {
  const OrganizerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrganizerBloc(),
      child: Scaffold(
        body: Column(
          children: [
            // Header section with enhanced styling
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  const Expanded(
                    flex: 3,
                    child: Text(
                      "Organizer Management",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.file_download, size: 20),
                      label: const Text("Export"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            
            // Filter buttons and Data table wrapped in a single BlocBuilder
            Expanded(
              child: BlocBuilder<OrganizerBloc, OrganizerState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      // Filter buttons with improved spacing
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _filterButton(context, 'All', state.filterStatus == 'All' ? Colors.blue : Colors.blue.shade50),
                            const SizedBox(width: 12),
                            _filterButton(context, 'Approved', state.filterStatus == 'Approved' ? Colors.blue : Colors.blue.shade50),
                            const SizedBox(width: 12),
                            _filterButton(context, 'Pending', state.filterStatus == 'Pending' ? Colors.blue : Colors.blue.shade50),
                            const SizedBox(width: 12),
                            _filterButton(context, 'Rejected', state.filterStatus == 'Rejected' ? Colors.blue : Colors.blue.shade50),
                          ],
                        ),
                      ),
                      
                      // Data table
                      Expanded(
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('users').snapshots(),
                          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            
                            var docs = snapshot.data!.docs;
                            
                            // Apply status filter only
                            List<QueryDocumentSnapshot> filteredDocs = docs.where((doc) {
                              var data = doc.data() as Map<String, dynamic>;
                              if (state.filterStatus != 'All' && 
                                  (data['status'] ?? 'pending').toLowerCase() != state.filterStatus.toLowerCase()) {
                                return false;
                              }
                              return true;
                            }).toList();
                            
                            if (filteredDocs.isEmpty) {
                              return Center(
                                child: Text(
                                  "No organizers found matching your criteria",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }
                            
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade200),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade100,
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    // Table header
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                      ),
                                      child: const Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              "Name",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              "Organization",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              "Contact",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              "Status",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    // Table content
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: filteredDocs.length,
                                        itemBuilder: (context, index) {
                                          var organizer = filteredDocs[index].data() as Map<String, dynamic>;
                                          return Container(
                                            decoration: BoxDecoration(
                                              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                      organizer['fullName'] ?? 'Unknown',
                                                      style: const TextStyle(fontSize: 15),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      organizer['organizationName'] ?? 'No Organization',
                                                      style: const TextStyle(fontSize: 15),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      organizer['phone'] ?? 'No Phone',
                                                      style: const TextStyle(fontSize: 15),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                      decoration: BoxDecoration(
                                                        color: _getStatusColor(organizer['status'] ?? 'pending').withOpacity(0.1),
                                                        borderRadius: BorderRadius.circular(16),
                                                      ),
                                                      child: Text(
                                                        organizer['status'] ?? 'pending',
                                                        style: TextStyle(
                                                          color: _getStatusColor(organizer['status'] ?? 'pending'),
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 14,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterButton(BuildContext context, String label, Color bgColor) {
    return ElevatedButton(
      onPressed: () {
        context.read<OrganizerBloc>().add(FilterStatusChanged(label));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: bgColor == Colors.blue ? Colors.white : Colors.black,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
    }
  }
}