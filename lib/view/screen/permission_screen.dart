

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:z_admin/view/screen/organizer_approval.dart';

// class PermissionsPage extends StatefulWidget {
//   const PermissionsPage({super.key});

//   @override
//   State<PermissionsPage> createState() => _PermissionsPageState();
// }

// class _PermissionsPageState extends State<PermissionsPage> {
//   String selectedFilter = 'All';
//   final List<String> filters = ['All', 'Pending', 'Approved', 'Rejected'];
//   TextEditingController searchController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         title: const Text(
//           "Permissions List",
//           style: TextStyle(
//             color: Color(0xFF2A3F85),
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.download_outlined, color: Color(0xFF2A3F85)),
//             onPressed: () {
//               // Export functionality
//             },
//             tooltip: 'Export Data',
//           ),
//           const SizedBox(width: 8),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Search Bar
//           Container(
//             padding: const EdgeInsets.all(16.0),
//             color: Colors.white,
//             child: Column(
//               children: [
//                 TextField(
//                   controller: searchController,
//                   decoration: InputDecoration(
//                     hintText: 'Search users...',
//                     prefixIcon: const Icon(Icons.search, color: Colors.grey),
//                     filled: true,
//                     fillColor: Colors.grey[100],
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide.none,
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(vertical: 12),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
                
//                 // Filter Chips
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: filters.map((filter) {
//                       return Padding(
//                         padding: const EdgeInsets.only(right: 8.0),
//                         child: FilterChip(
//                           label: Text(filter),
//                           selected: selectedFilter == filter,
//                           backgroundColor: Colors.white,
//                           selectedColor: const Color(0xFF2A3F85).withOpacity(0.1),
//                           checkmarkColor: const Color(0xFF2A3F85),
//                           labelStyle: TextStyle(
//                             color: selectedFilter == filter 
//                                 ? const Color(0xFF2A3F85) 
//                                 : Colors.black87,
//                             fontWeight: selectedFilter == filter 
//                                 ? FontWeight.bold 
//                                 : FontWeight.normal,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             side: BorderSide(
//                               color: selectedFilter == filter 
//                                   ? const Color(0xFF2A3F85) 
//                                   : Colors.grey.withOpacity(0.3),
//                             ),
//                           ),
//                           onSelected: (selected) {
//                             setState(() {
//                               selectedFilter = filter;
//                             });
//                           },
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Data Table Header
//           Container(
//             color: Colors.white,
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             margin: const EdgeInsets.only(top: 1),
//             child: Row(
//               children: const [
//                 Expanded(
//                   flex: 2,
//                   child: Text(
//                     'ORGANIZER',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 12,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 2,
//                   child: Text(
//                     'ORGANIZATION',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 12,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 80),
//               ],
//             ),
//           ),

//           // Fetch and display user data
//           Expanded(
//             child: StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection('users')
//                   .where('status', isEqualTo: 'pending')
//                   .snapshots(),
//               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(
//                     child: CircularProgressIndicator(
//                       color: Color(0xFF2A3F85),
//                     ),
//                   );
//                 }
                
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.person_off_outlined,
//                           size: 64,
//                           color: Colors.grey[400],
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           "No pending approvals",
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey[600],
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           "There are no users waiting for approval",
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey[500],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 var pendingUsers = snapshot.data!.docs;

//                 return ListView.builder(
//                   itemCount: pendingUsers.length,
//                   itemBuilder: (context, index) {
//                     var user = pendingUsers[index];

//                     return Container(
//                       margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(8),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.05),
//                             blurRadius: 4,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: ListTile(
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 8,
//                         ),
//                         leading: CircleAvatar(
//                           backgroundColor: const Color(0xFF2A3F85).withOpacity(0.1),
//                           child: Text(
//                             user['fullName'].substring(0, 1).toUpperCase(),
//                             style: const TextStyle(
//                               color: Color(0xFF2A3F85),
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         title: Text(
//                           user['fullName'],
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(height: 4),
//                             Text(user['organizationName']),
//                             const SizedBox(height: 4),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 8,
//                                 vertical: 2,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.orange.withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                               child: const Text(
//                                 'Pending',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.orange,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         trailing: ElevatedButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     ApprovalPage(userId: user.id),
//                               ),
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF2A3F85),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 8,
//                             ),
//                           ),
//                           child: const Text(
//                             "Review",
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:z_admin/view/screen/organizer_approval.dart';

class PermissionsPage extends StatefulWidget {
  const PermissionsPage({super.key});

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  String selectedFilter = 'All';
  final List<String> filters = ['All', 'Pending', 'Approved', 'Rejected'];
  TextEditingController searchController = TextEditingController();

  Stream<QuerySnapshot> getFilteredUsers() {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    if (selectedFilter == 'All') {
      return usersCollection.snapshots();
    } else {
      return usersCollection
          .where('status', isEqualTo: selectedFilter.toLowerCase())
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Permissions List",
          style: TextStyle(
            color: Color(0xFF2A3F85),
            fontWeight: FontWeight.bold,
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
          // Search Bar & Filters
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: 'Search users...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                const SizedBox(height: 16),
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: filters.map((filter) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(filter),
                          selected: selectedFilter == filter,
                          backgroundColor: Colors.white,
                          selectedColor: const Color(0xFF2A3F85).withOpacity(0.1),
                          checkmarkColor: const Color(0xFF2A3F85),
                          labelStyle: TextStyle(
                            color: selectedFilter == filter
                                ? const Color(0xFF2A3F85)
                                : Colors.black87,
                            fontWeight: selectedFilter == filter
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: selectedFilter == filter
                                  ? const Color(0xFF2A3F85)
                                  : Colors.grey.withOpacity(0.3),
                            ),
                          ),
                          onSelected: (selected) {
                            setState(() {
                              selectedFilter = filter;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Data Table Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: const EdgeInsets.only(top: 1),
            child: Row(
              children: const [
                Expanded(
                  flex: 2,
                  child: Text(
                    'ORGANIZER',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'ORGANIZATION',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(width: 80),
              ],
            ),
          ),

          // Fetch and display user data
          Expanded(
            child: StreamBuilder(
              stream: getFilteredUsers(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF2A3F85),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_off_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No results found",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Try adjusting your filters",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                var filteredUsers = snapshot.data!.docs.where((user) {
                  String userName = user['fullName'].toString().toLowerCase();
                  return userName.contains(searchController.text.toLowerCase());
                }).toList();

                return ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    var user = filteredUsers[index];

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF2A3F85).withOpacity(0.1),
                          child: Text(
                            user['fullName'].substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xFF2A3F85),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          user['fullName'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(user['organizationName']),
                        trailing: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ApprovalPage(userId: user.id),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2A3F85),
                          ),
                          child: const Text("Review"),
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
