import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inventory_management/ClientScreen.dart';
import 'package:inventory_management/addClient.dart';
import 'package:inventory_management/homeScreen.dart';
import 'package:inventory_management/login_screen.dart';
import 'package:inventory_management/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'clientScreen',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: ClientScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                // Change the opacity of the screen using a Curve based on the the animation's
                // value
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc)
                      .animate(animation),
                  child: child,
                );
              },
            );
            ;
          },
        ),
        GoRoute(
          path: 'homeScreen',
          builder: (BuildContext context, GoRouterState state) {
            return HomeScreen();
          },
        ),
        GoRoute(
          path: 'addClient',
          builder: (BuildContext context, GoRouterState state) {
            return AddClient();
          },
        ),
        GoRoute(
          path: 'loginScreen',
          builder: (BuildContext context, GoRouterState state) {
            return LoginScreen();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  MyApp({super.key, required this.prefs});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) =>
                AuthProvider(googleSignIn: GoogleSignIn(), prefs: prefs))
      ],
      child: MaterialApp.router(
        routerConfig: _router,
        title: 'Inventory',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

Future<void> signInWithGoogle() async {
  // Create a new provider

  GoogleAuthProvider googleProvider = GoogleAuthProvider();
  //GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();

  final FirebaseAuth auth = FirebaseAuth.instance;
  googleProvider.addScope('https://www.googleapis.com/auth/userinfo.email');
  googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

  // Once signed in, return the UserCredential
  UserCredential user = await auth.signInWithPopup(googleProvider);
  print(user.user?.displayName);
}
