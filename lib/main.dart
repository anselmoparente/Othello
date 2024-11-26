import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/client_base.dart';
import 'pages/initial_page.dart';
import 'services/client_socket_impl.dart';
import 'utils/constants.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ClientBase>(
      create: (context) => SocketClientImpl(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF0D4AB),
          fontFamily: Constants.pressStartFontFamily,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFDDDDDD),
            surfaceTintColor: Colors.transparent,
          ),
        ),
        home: const UserIdentificationPage(),
      ),
    );
  }
}
