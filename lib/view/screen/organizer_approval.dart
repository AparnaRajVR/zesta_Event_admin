
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:z_admin/view/widget/approval/action_button.dart';
import 'package:z_admin/view/widget/approval/documents_card.dart';
import 'package:z_admin/view/widget/approval/info_card.dart';
import 'package:z_admin/view/widget/approval/section_title.dart';
import 'package:z_admin/view/widget/approval/user_header.dart';
import 'package:z_admin/viewmodel/approval_bloc/bloc/approval_bloc.dart';
import 'package:z_admin/viewmodel/approval_bloc/bloc/approval_event.dart';
import 'package:z_admin/viewmodel/approval_bloc/bloc/approval_state.dart';


class ApprovalPage extends StatelessWidget {
  final String userId;
  const ApprovalPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ApprovalBloc(firestore: FirebaseFirestore.instance)..add(FetchUserData(userId)),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text("Approval Details"),
          centerTitle: true,
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
                      onPressed: () =>
                          context.read<ApprovalBloc>().add(FetchUserData(userId)),
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
                      UserHeader(userData: userData),
                      const SizedBox(height: 20),
                      InfoCard(userData: userData),
                      const SizedBox(height: 20),
                      const SectionTitle(title: 'Documents'),
                      const SizedBox(height: 10),
                      DocumentsCard(userData: userData),
                      const SizedBox(height: 30),
                      ActionButtons(userId: userId),
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
}
