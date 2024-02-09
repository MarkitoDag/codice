import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistema_gestione_comune/App_navigator.dart';
import 'package:sistema_gestione_comune/Session_cubit.dart';
import 'package:sistema_gestione_comune/login/AuthRepository.dart';

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
