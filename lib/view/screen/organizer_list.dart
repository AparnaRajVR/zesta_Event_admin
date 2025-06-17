

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
    final TextEditingController _searchController = TextEditingController();

    return BlocProvider(
      create: (context) => OrganizerBloc(),
      child: Scaffold(
        body: Column(
          children: [
            // Header section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Expanded(
                    flex: 3,
                    child: Text(
                      "Organizer Management",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.file_download),
                      label: const Text("Export"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    context.read<OrganizerBloc>().add(SearchQueryChanged(value.toLowerCase()));
                  },
                  decoration: const InputDecoration(
                    hintText: "Search organizers...",
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),
            
            // Filter buttons and Data table wrapped in a single BlocBuilder
            Expanded(
              child: BlocBuilder<OrganizerBloc, OrganizerState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      // Filter buttons
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            _filterButton(context, 'All', state.filterStatus == 'All' ? Colors.blue : Colors.blue.shade50),
                            const SizedBox(width: 10),
                            _filterButton(context, 'Approved', state.filterStatus == 'Approved' ? Colors.blue : Colors.blue.shade50),
                            const SizedBox(width: 10),
                            _filterButton(context, 'Pending', state.filterStatus == 'Pending' ? Colors.blue : Colors.blue.shade50),
                            const SizedBox(width: 10),
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
                            
                            // Apply filters
                            List<QueryDocumentSnapshot> filteredDocs = docs.where((doc) {
                              var data = doc.data() as Map<String, dynamic>;
                              
                              // Status filter
                              if (state.filterStatus != 'All' && 
                                  (data['status'] ?? 'pending').toLowerCase() != state.filterStatus.toLowerCase()) {
                                return false;
                              }
                              
                              // Search filter
                              if (state.searchQuery.isNotEmpty) {
                                String fullName = (data['fullName'] ?? '').toLowerCase();
                                String orgName = (data['organizationName'] ?? '').toLowerCase();
                                String email = (data['email'] ?? '').toLowerCase();
                                String phone = (data['phone'] ?? '').toLowerCase();
                                
                                if ((fullName.isNotEmpty && fullName.contains(state.searchQuery)) ||
                                    (orgName.isNotEmpty && orgName.contains(state.searchQuery)) ||
                                    (email.isNotEmpty && email.contains(state.searchQuery)) ||
                                    (phone.isNotEmpty && phone.contains(state.searchQuery))) {
                                  return true;
                                } else {
                                  return false;
                                }
                              }
                              
                              return true;
                            }).toList();
                            
                            if (filteredDocs.isEmpty) {
                              return Center(
                                child: Text(
                                  "No organizers found matching your criteria",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              );
                            }
                            
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade200),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    // Table header
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8),
                                        ),
                                      ),
                                      child: const Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Text("Name", style: TextStyle(fontWeight: FontWeight.bold)),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text("Organization", style: TextStyle(fontWeight: FontWeight.bold)),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text("Contact", style: TextStyle(fontWeight: FontWeight.bold)),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text("Action", style: TextStyle(fontWeight: FontWeight.bold)),
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
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(organizer['fullName'] ?? 'Unknown'),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(organizer['organizationName'] ?? 'No Organization'),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(organizer['phone'] ?? 'No Phone'),
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
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        IconButton(
                                                          icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                                                          onPressed: () => context.read<OrganizerBloc>().add(
                                                            UpdateOrganizerStatus(filteredDocs[index].id, 'approved')
                                                          ),
                                                          tooltip: 'Approve',
                                                          iconSize: 20,
                                                        ),
                                                        IconButton(
                                                          icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                                                          onPressed: () => context.read<OrganizerBloc>().add(
                                                            UpdateOrganizerStatus(filteredDocs[index].id, 'rejected')
                                                          ),
                                                          tooltip: 'Reject',
                                                          iconSize: 20,
                                                        ),
                                                      ],
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
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(label),
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



// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:z_admin/viewmodel/organize_list/bloc/organizer_list_bloc.dart';
// import 'package:z_admin/viewmodel/organize_list/bloc/organizer_list_event.dart';
// import 'package:z_admin/viewmodel/organize_list/bloc/organizer_list_state.dart';

// class OrganizerListPage extends StatelessWidget {
//   const OrganizerListPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController _searchController = TextEditingController();

//     return BlocProvider(
//       create: (context) => OrganizerBloc(),
//       child: Scaffold(
//         body: Column(
//           children: [
//             // Header
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 children: [
//                   const Expanded(
//                     child: Text(
//                       "Organizer Management",
//                       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   ElevatedButton.icon(
//                     icon: const Icon(Icons.file_download),
//                     label: const Text("Export"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       foregroundColor: Colors.white,
//                     ),
//                     onPressed: () {},
//                   ),
//                 ],
//               ),
//             ),

//             // Search Bar
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: TextField(
//                 controller: _searchController,
//                 onChanged: (value) {
//                   context.read<OrganizerBloc>().add(SearchQueryChanged(value.toLowerCase()));
//                 },
//                 decoration: InputDecoration(
//                   hintText: "Search organizers...",
//                   prefixIcon: const Icon(Icons.search),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//             ),

//             // Filter Buttons
//             BlocBuilder<OrganizerBloc, OrganizerState>(
//               builder: (context, state) {
//                 return Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Wrap(
//                     spacing: 10,
//                     children: ["All", "Approved", "Pending", "Rejected"]
//                         .map((status) => _filterButton(context, status, state.filterStatus == status))
//                         .toList(),
//                   ),
//                 );
//               },
//             ),

//             // Data Table
//             Expanded(
//               child: StreamBuilder(
//                 stream: FirebaseFirestore.instance
//                     .collection('users')
//                     .orderBy('createdAt', descending: true) // Sorting newest first
//                     .snapshots(),
//                 builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                   if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

//                   List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
//                   return BlocBuilder<OrganizerBloc, OrganizerState>(
//                     builder: (context, state) {
//                       List<QueryDocumentSnapshot> filteredDocs = docs.where((doc) {
//                         var data = doc.data() as Map<String, dynamic>;
//                         bool statusMatch = state.filterStatus == "All" ||
//                             (data['status']?.toLowerCase() == state.filterStatus.toLowerCase());

//                         bool searchMatch = state.searchQuery.isEmpty ||
//                             (data['fullName'] ?? '').toLowerCase().contains(state.searchQuery) ||
//                             (data['organizationName'] ?? '').toLowerCase().contains(state.searchQuery) ||
//                             (data['phone'] ?? '').toLowerCase().contains(state.searchQuery);

//                         return statusMatch && searchMatch;
//                       }).toList();

//                       if (filteredDocs.isEmpty) {
//                         return const Center(child: Text("No organizers found"));
//                       }

//                       return ListView(
//                         padding: const EdgeInsets.all(16),
//                         children: [
//                           // Table Header
//                           Container(
//                             padding: const EdgeInsets.symmetric(vertical: 12),
//                             decoration: BoxDecoration(
//                               color: Colors.grey.shade200,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Row(
//                               children: _tableHeaders(),
//                             ),
//                           ),

//                           // Table Content
//                           ...filteredDocs.map((doc) {
//                             var data = doc.data() as Map<String, dynamic>;
//                             return Container(
//                               padding: const EdgeInsets.symmetric(vertical: 12),
//                               decoration: BoxDecoration(
//                                 border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
//                               ),
//                               child: Row(
//                                 children: _tableRow(context, doc.id, data),
//                               ),
//                             );
//                           }).toList(),
//                         ],
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _filterButton(BuildContext context, String label, bool isActive) {
//     return ElevatedButton(
//       onPressed: () => context.read<OrganizerBloc>().add(FilterStatusChanged(label)),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: isActive ? Colors.blue : Colors.grey.shade200,
//         foregroundColor: isActive ? Colors.white : Colors.black,
//       ),
//       child: Text(label),
//     );
//   }

//   List<Widget> _tableHeaders() {
//     return [
//       _tableCell("Name", flex: 3, isHeader: true),
//       _tableCell("Organization", flex: 2, isHeader: true),
//       _tableCell("Phone", flex: 2, isHeader: true),
//       _tableCell("Status", flex: 2, isHeader: true),
//       _tableCell("Actions", flex: 1, isHeader: true),
//     ];
//   }

//   List<Widget> _tableRow(BuildContext context, String id, Map<String, dynamic> data) {
//     return [
//       _tableCell(data['fullName'] ?? "Unknown", flex: 3),
//       _tableCell(data['organizationName'] ?? "N/A", flex: 2),
//       _tableCell(data['phone'] ?? "No Phone", flex: 2),
//       _statusCell(data['status'] ?? "Pending"),
//       _actionButtons(context, id),
//     ];
//   }

//   Widget _tableCell(String text, {int flex = 1, bool isHeader = false}) {
//     return Expanded(
//       flex: flex,
//       child: Text(
//         text,
//         style: TextStyle(
//           fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
//           color: isHeader ? Colors.black : Colors.grey[800],
//         ),
//         textAlign: TextAlign.left,
//       ),
//     );
//   }

//   Widget _statusCell(String status) {
//     Color statusColor = _getStatusColor(status);
//     return Expanded(
//       flex: 2,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         decoration: BoxDecoration(
//           color: statusColor.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Text(
//           status,
//           style: TextStyle(color: statusColor, fontWeight: FontWeight.w500),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }

//   Widget _actionButtons(BuildContext context, String id) {
//     return Expanded(
//       flex: 1,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           IconButton(
//             icon: const Icon(Icons.check_circle_outline, color: Colors.green),
//             onPressed: () => context.read<OrganizerBloc>().add(UpdateOrganizerStatus(id, 'approved')),
//           ),
//           IconButton(
//             icon: const Icon(Icons.cancel_outlined, color: Colors.red),
//             onPressed: () => context.read<OrganizerBloc>().add(UpdateOrganizerStatus(id, 'rejected')),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'approved':
//         return Colors.green;
//       case 'rejected':
//         return Colors.red;
//       case 'pending':
//       default:
//         return Colors.orange;
//     }
//   }
// }
