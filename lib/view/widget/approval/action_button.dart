import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_admin/viewmodel/approval_bloc/bloc/approval_bloc.dart';
import 'package:z_admin/viewmodel/approval_bloc/bloc/approval_event.dart';
import 'package:z_admin/viewmodel/approval_bloc/bloc/approval_state.dart';

class ActionButtons extends StatelessWidget {
  final String userId;
  const ActionButtons({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
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
          _buildButton(context, "Reject", Colors.red, "rejected"),
          const SizedBox(width: 16),
          _buildButton(context, "Approve", Colors.green, "approved"),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, Color color, String status) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => context.read<ApprovalBloc>().add(UpdateUserStatus(userId, status)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(label),
      ),
    );
  }
}
