
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_admin/constants/color.dart';
import 'package:z_admin/view/screen/dashboard_screen.dart';
import 'package:z_admin/view/widget/custom_textfeild.dart';
import 'package:z_admin/viewmodel/login_bloc/admin_login_bloc.dart';
import 'package:z_admin/viewmodel/login_bloc/admin_login_event.dart';
import 'package:z_admin/viewmodel/login_bloc/admin_login_state.dart';
import 'package:z_admin/utils/validation.dart';
import 'package:z_admin/view/widget/custom_button.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            bool isDesktop = constraints.maxWidth > 800;
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isDesktop ? 800 : 400,
                  maxHeight: 500,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: isDesktop
                      ? Row(
                          children: [
                           
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/logo.png',
                                        height: 100,
                                        width: 100,
                                      ),
                                      
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        
                            Expanded(
                              flex: 1,
                              child: _buildLoginForm(),
                            ),
                          ],
                        )
                      : _buildLoginForm(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                controller: usernameController,
                label: 'Username',
                hint: 'Enter your username',
                prefixIcon:
                    const Icon(Icons.person_outline, color: AppColors.second),
                validator: Validation.validateUsername,
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                controller: passwordController,
                label: 'Password',
                hint: 'Enter your password',
                isPassword: true,
                prefixIcon:
                    const Icon(Icons.lock_outline, color: AppColors.second),
                validator: Validation.validatePassword,
              ),
              const SizedBox(height: 16),
             

              BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is LoginSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login successful')),
                    );
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => DashboardScreen()),
                      (route) => false,
                    );
                  } else if (state is LoginFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is LoginLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return CustomButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() == true) {
                        final username = usernameController.text.trim();
                        final password = passwordController.text.trim();
                        context.read<LoginBloc>().add(
                              LoginButtonPressed(
                                username: username,
                                password: password,
                              ),
                            );
                      }
                    },
                    label: 'Login',
                    backgroundColor: AppColors.primary,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
