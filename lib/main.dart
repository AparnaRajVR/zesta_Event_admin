import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:z_admin/firebase_options.dart';
import 'package:z_admin/service/firebase_service.dart';
import 'package:z_admin/view/screen/dashboard_screen.dart';
import 'package:z_admin/view/screen/entry/login.dart';
import 'package:z_admin/view/screen/entry/splash_screen.dart';
import 'package:z_admin/viewmodel/category_bloc/bloc/category_bloc.dart';
import 'package:z_admin/viewmodel/dashboard/bloc/dashboard_bloc_bloc.dart';
import 'package:z_admin/viewmodel/login_bloc/admin_login_bloc.dart';
import 'package:z_admin/viewmodel/organize_list/bloc/organizer_list_bloc.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,  
  );

  final firestoreService = FirestoreService();
  await firestoreService.addAdminUser();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(),

        ),
        BlocProvider(
          create: (context) => DashboardBloc(),
        ),
        BlocProvider<OrganizerBloc>(
          create: (context) => OrganizerBloc(),
        ),
         BlocProvider<CategoryBloc>(
          create: (context) => CategoryBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Inter', 
          useMaterial3: true,
        ),
        initialRoute: '/splash', 
        routes: {
          '/splash': (context) => SplashScreen(),
          '/login': (context) => LoginPage(),
          '/dashboard': (context) => DashboardScreen(),
        },
      ),
    );
  }
}