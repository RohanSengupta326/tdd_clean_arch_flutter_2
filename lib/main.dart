import 'package:clean_arch_bloc_2/core/res/colours.dart';
import 'package:clean_arch_bloc_2/core/res/fonts.dart';
import 'package:clean_arch_bloc_2/core/services/injection_container.dart';
import 'package:clean_arch_bloc_2/core/services/router.dart';

import 'package:flutter/material.dart';

// analysiss_options.yaml is providing one of the most important rules to follow
// for clean code by 'very good ventures' package.
// they simply combine the most important rules for clean code, else we could
//customise the rules we want, with linter package.

//  Now because of 'very good analysis' code wills show warnings to make
// changes for good clean code.
// if want to apply those changes to an already existing code run :
// ` dart fix --apply `

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Education App',
      theme: ThemeData(
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: Fonts.poppins,
        appBarTheme: const AppBarTheme(
          color: Colors.transparent,
        ),
        colorScheme: ColorScheme.fromSwatch(accentColor: Colours.primaryColour),
      ),
      onGenerateRoute: generateRoute,
    );
  }
}
