import 'package:addetto_raccolta/App_navigator.dart';
import 'package:addetto_raccolta/Session_cubit.dart';
import 'package:addetto_raccolta/login/AuthRepository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RepositoryProvider(
        create: (context) => AuthRepository(),
        child: BlocProvider(
            create: (context) =>
                SessionCubit(authRepo: context.read<AuthRepository>()),
            child: const AppNavigator()),
      ),
    );
  }
}
