import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pfe_1/arabic_course/arabic_main.dart';
import 'package:pfe_1/chatt/chatt.dart';
import 'package:pfe_1/constant/language_const.dart';
import 'package:pfe_1/english_course/english_main.dart';
import 'package:pfe_1/french_course/frensh_main.dart';
import 'package:pfe_1/french_course/frensh_unities.dart';
import 'package:pfe_1/home/home.dart';
import 'package:pfe_1/services/firebase_options.dart';
import 'package:pfe_1/starting/signin.dart';
import 'package:pfe_1/starting/signup.dart';
import 'package:pfe_1/stages/stages.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pfe_1/starting/welcome_signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((Locale) => setLocale(Locale));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('fr'),
        Locale('hi'), // Ajoutez la nouvelle langue (hindi)
        // autres langues supportées
      ],
      locale: _locale,
      home: _getStartScreen(),
      routes: {
        'stages': (context) => StagesPage(),
        'frenshunities': (context) => FrenshUnities(),
        'home': (context) => HomeScreen(),
        'arabicCourse': (context) => ArabicCourse(),
        'frenchCourse': (context) => FrenchCourse(),
        'englishCourse': (context) => EnglishCourse(),
        "signup": (context) => const Signup(),
        "login": (context) => Login(),
        "chatt": (context) => ChatScreen(),
        "signup1": (context) => Signup1()
      },
    );
  }

  Widget _getStartScreen() {
    if (FirebaseAuth.instance.currentUser == null) {
      return Login();
    } else {
      return HomeScreen();
    }
  }
}
