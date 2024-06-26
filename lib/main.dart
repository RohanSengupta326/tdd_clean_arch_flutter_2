import 'package:clean_arch_bloc_2/core/common/app/providers/user_provider.dart';
import 'package:clean_arch_bloc_2/core/res/colours.dart';
import 'package:clean_arch_bloc_2/core/res/fonts.dart';
import 'package:clean_arch_bloc_2/core/services/injection_container.dart';
import 'package:clean_arch_bloc_2/core/services/router.dart';
import 'package:clean_arch_bloc_2/firebase_options.dart';
import 'package:clean_arch_bloc_2/src/dashboard/presentation/providers/dashboard_controller.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// analysis_options.yaml is providing one of the most important rules to follow
// for clean code by 'very good ventures' package.
// they simply combine the most important rules for clean code, else we could
//customise the rules we want, with linter package.

//  Now because of 'very good analysis' code wills show warnings to make
// changes for good clean code.
// if want to apply those changes to an already existing code run :
// ` dart fix --apply `

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseUIAuth.configureProviders([EmailAuthProvider()]); // for forgotten
  // password firebase provided UI is used. for tha this is needed.
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => DashboardController()),
      ],
      child: MaterialApp(
        title: 'Education App',
        theme: ThemeData(
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: Fonts.poppins,
          appBarTheme: const AppBarTheme(
            color: Colors.transparent,
          ),
          colorScheme:
              ColorScheme.fromSwatch(accentColor: Colours.primaryColour),
        ),
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
