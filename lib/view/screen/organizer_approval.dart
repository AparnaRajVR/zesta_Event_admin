
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApprovalPage extends StatelessWidget {
  final String userId;
  const ApprovalPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: const Text("Approval Details")),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("User not found"));
          }

      
          log("Firestore User Data: ${snapshot.data!.data()}");

          var user = snapshot.data!;
          return SingleChildScrollView(  // ✅ Fix overflow issue
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align text properly
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text(
                          user['fullName'], 
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(user['organizationName']),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildInfoTile(Icons.email, "Email", user['email']),
                  _buildInfoTile(Icons.phone, "Phone", user['phone']),
                  _buildInfoTile(Icons.category, "Type", user['organizerType']),
                  _buildInfoTile(Icons.location_on, "Address", user['address'] ?? "Not provided"),

                  const SizedBox(height: 20),
                  _buildSectionTitle('Documents'),

                  user['documentImage'] != null
                      ? (user['documentImage'] is List<dynamic>
                          ? Column(
                              children: (user['documentImage'] as List<dynamic>).map((docUrl) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Image.network(docUrl, height: 150),
                                );
                              }).toList(),
                            )
                          : Image.network(user['documentImage'], height: 150)) // Single image case
                      : const Text("No documents uploaded"),

                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _updateStatus(userId, "rejected"),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          child: const Text("Reject"),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _updateStatus(userId, "approved"),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          child: const Text("Approve"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(value),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title, 
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  void _updateStatus(String userId, String status) {
    FirebaseFirestore.instance.collection('users').doc(userId).update({'status': status});
  }
}
