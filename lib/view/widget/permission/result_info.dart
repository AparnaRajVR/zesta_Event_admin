import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_admin/viewmodel/permission_bloc/bloc/permission_bloc.dart';
import 'package:z_admin/viewmodel/permission_bloc/bloc/permission_state.dart';

class ResultsInfo extends StatelessWidget {
  const ResultsInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermissionsBloc, PermissionsState>(
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
    );
  }
}
