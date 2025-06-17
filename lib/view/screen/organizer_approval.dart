

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:z_admin/viewmodel/approval_bloc/bloc/approval_bloc.dart';
import 'package:z_admin/viewmodel/approval_bloc/bloc/approval_event.dart';
import 'package:z_admin/viewmodel/approval_bloc/bloc/approval_state.dart';

class ApprovalPage extends StatelessWidget {
  final String userId;
  const ApprovalPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ApprovalBloc(firestore: FirebaseFirestore.instance)..add(FetchUserData(userId)),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text("Approval Details"),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
           elevation: 2,
        ),
        body: BlocBuilder<ApprovalBloc, ApprovalState>(
          builder: (context, state) {
            if (state is ApprovalLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ApprovalError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<ApprovalBloc>().add(FetchUserData(userId)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );
            } else if (state is ApprovalLoaded) {
              final userData = state.user.data() as Map<String, dynamic>;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUserHeader(userData),
                      const SizedBox(height: 20),
                      _buildInfoCard(userData),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Documents'),
                      const SizedBox(height: 10),
                      _buildDocumentsCard(userData),
                      const SizedBox(height: 30),
                      _buildActionButtons(context, userId),
                    ],
                  ),
                ),
              );
            }
             return const Center(child: Text("Approved"));
          },
        ),
      ),
    );
  }

  Widget _buildUserHeader(Map<String, dynamic> user) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user['fullName'] ?? "User Name",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                user['organizationName'] ?? "Organization",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(Map<String, dynamic> user) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
              child: _buildSectionTitle('User Information'),
            ),
            const Divider(),
            _buildInfoTile(Icons.email, "Email", user['email'] ?? "Not provided"),
            _buildInfoTile(Icons.phone, "Phone", user['phone'] ?? "Not provided"),
            _buildInfoTile(Icons.category, "Type", user['organizerType'] ?? "Not provided"),
            _buildInfoTile(Icons.location_on, "Address", user['address'] ?? "Not provided"),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentsCard(Map<String, dynamic> user) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: user['documentImage'] != null
            ? (user['documentImage'] is List<dynamic>
                ? Column(
                    children: (user['documentImage'] as List<dynamic>).map((docUrl) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            docUrl,
                            height: 150,
                            errorBuilder: (context, error, stackTrace) => const Text(
                              "Failed to load image",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )
                : Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        user['documentImage'],
                        height: 150,
                        errorBuilder: (context, error, stackTrace) => const Text(
                          "Failed to load image",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ))
            : Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Text(
                  "No documents uploaded",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, String userId) {
    return BlocListener<ApprovalBloc, ApprovalState>(
      listener: (context, state) {
        if (state is StatusUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Status updated to ${state.status}"),
              backgroundColor: state.status == "approved" ? Colors.green : Colors.red,
            ),
          );
        }
      },
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => context.read<ApprovalBloc>().add(UpdateUserStatus(userId, "rejected")),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Reject"),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () => context.read<ApprovalBloc>().add(UpdateUserStatus(userId, "approved")),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Approve"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Colors.black54,
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}

