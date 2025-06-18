
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_admin/view/widget/permission/permission_view.dart';
import 'package:z_admin/viewmodel/permission_bloc/bloc/permission_bloc.dart';
import 'package:z_admin/viewmodel/permission_bloc/bloc/permission_event.dart';

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
